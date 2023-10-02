module Hby.Game

import Data.List
import Hby.Lib.Ref
import Hby.Lib.Util
import Hby.Game.Base.Position
import Hby.Game.Base.Size
import Hby.Game.Base.Color
import Hby.Game.Base.Key
import Hby.Game.Canvas.Base
import Hby.Game.Canvas.Event
import Hby.Game.Canvas.Draw

export
record 游戏设置 where
    constructor MK_游戏设置
    画布大小 : 大小
    使能鼠标移动事件 : Bool
    使能鼠标按下事件 : Bool
    使能鼠标弹起事件 : Bool
    使能键盘按下事件 : Bool
    使能键盘弹起事件 : Bool
    帧率 : Double

export
创建游戏设置 : (画布大小 : 大小)
    -> (使能鼠标移动事件 : Bool)
    -> (使能鼠标按下事件 : Bool)
    -> (使能鼠标弹起事件 : Bool)
    -> (使能键盘按下事件 : Bool)
    -> (使能键盘弹起事件 : Bool)
    -> (帧率 : Double)
    -> 游戏设置
创建游戏设置 = MK_游戏设置

public export
interface 游戏状态 (a : Type) where

public export
data 事件 =
    MK_鼠标移动事件 坐标
    | MK_鼠标按下事件 坐标
    | MK_鼠标弹起事件 坐标
    | MK_键盘按下事件 键
    | MK_键盘弹起事件 键
    | MK_心跳事件

渲染 : (画布上下文 : 画布上下文引用)
    -> (当前显示的对象 : List 显示对象)
    -> (下一帧要显示的对象 : List 显示对象)
    -> IO ()
渲染 ctxRef oldShowList newShowList = do
    -- todo 重点需要优化的地方.
    -- 可能的方法:
    -- * 建立一个不显示的画布, 然后从里面复制, 据说会比重绘快.
    -- * 对比当前显示元素和要显示的元素, 做diff.
    -- * 出界的元素就不用画了.
    清空画布 ctxRef
    -- 将显示对象的列表转换为实体的列表
    -- todo
    -- 有点效率问题, 这意味着每一帧都需要调用"转换到实体集"函数, 应该搞个记忆函数.
    -- 不过仅仅是包装为实体, 相比之前, 也其实也就是多调一层封装过程而已.
    entityList <- pure $ map (解包显示对象 转换到实体集) newShowList
    -- 按图层将实体列表排序
    sortList <- pure $ Data.List.sortBy (\a, b => if 获得实体图层 a > 获得实体图层 b then GT else LT) (实体集列表展开 entityList)
    -- 绘制实体列表
    _ <- traverse (解包实体 (\a, wz, _ => 绘制元素 ctxRef a wz)) sortList
    pure ()

主过程 : (游戏状态 s) =>
    (状态引用 : Ref s)
    -> (显示列表引用 : Ref (List 显示对象))
    -> (游戏事件 : 事件)
    -> (IO过程 : 事件 -> s -> IO s)
    -> (状态迁移函数 : 事件 -> s -> s)
    -> (计算显示对象 : s -> List 显示对象)
    -> IO ()
主过程 sRef showListRef event ioProc transition render = do
    -- 首先先取当前的显示对象和状态
    oldShowList <- readRef showListRef
    oldS <- readRef sRef
    -- 先调用io过程和转换过程 得到新的状态
    ioS <- ioProc event oldS
    newS <- pure $ transition event ioS
    -- 然后调用显示对象计算函数 得到新的显示对象
    newShowList <- pure $ render newS
    -- 最后保存新的显示对象和新的状态
    writeRef newShowList showListRef
    writeRef newS sRef

渲染过程 : (画布上下文 : 画布上下文引用)
    -> (当前显示列表引用 : Ref (List 显示对象))
    -> (旧的显示列表引用 : Ref (List 显示对象))
    -> IO ()
渲染过程 ctxRef nowShowListRef oldShowListRef = do
    nowShowList <- readRef nowShowListRef
    oldShowList <- readRef oldShowListRef
    渲染 ctxRef oldShowList nowShowList
    writeRef nowShowList oldShowListRef

||| 游戏的核心是一堆数据(这里称为状态).
||| 游戏引擎会监听若干事件, 例如鼠标按下等, 即使用户什么都不做, 每一帧也会产生一个'心跳事件'.
||| 游戏引擎监听到事件后, 会用它来调用'状态迁移函数', 该函数会计算得到一个新的状态, 这个状态会被游戏引擎记住.
||| 游戏引擎每帧会查看当前状态, 进行渲染.
||| 初始化游戏时需要提供以下数据:
||| - 设置: 一些设置, 例如屏幕大小等.
||| - 初始状态: 最开始的状态, 注意, 状态的类型是固定的, 不可以动态改变, 一开始就应该把所有可以的属性写上.
||| - IO过程: 这个函数中, 可以访问到状态和事件, 返回一个新的状态, 并且可以进行IO行为, 尽可能不要使用这个.
||| - 状态迁移函数: 这个函数中, 可以访问到状态和事件, 返回一个新的状态, 尽量使用这个.
||| - 渲染函数: 用于渲染的函数, 需要返回'显示对象'类型的数据, 引擎会绘制它们.
export
游戏 : (游戏状态 s) =>
    游戏设置
    -> (状态引用 : Ref s)
    -> (IO过程 : 事件 -> s -> IO s)
    -> (状态迁移函数 : 事件 -> s -> s)
    -> (计算显示对象 : s -> List 显示对象)
    -> IO ()
游戏 conf sRef ioProc transition render = do
    nowShowListRef <- 创建显示列表引用 ()
    oldShowListRef <- 创建显示列表引用 ()
    ctxRef <- 获得上下文引用 conf.画布大小 "app"
    if conf.使能鼠标移动事件 then 设置鼠标移动事件 ctxRef (\a => 主过程 sRef nowShowListRef (MK_鼠标移动事件 a) ioProc transition render) else pure ()
    if conf.使能鼠标按下事件 then 设置鼠标按下事件 ctxRef (\a => 主过程 sRef nowShowListRef (MK_鼠标按下事件 a) ioProc transition render) else pure ()
    if conf.使能鼠标弹起事件 then 设置鼠标弹起事件 ctxRef (\a => 主过程 sRef nowShowListRef (MK_鼠标弹起事件 a) ioProc transition render) else pure ()
    if conf.使能键盘按下事件 then 设置键盘按下事件 ctxRef (\a => 主过程 sRef nowShowListRef (MK_键盘按下事件 a) ioProc transition render) else pure ()
    if conf.使能键盘弹起事件 then 设置键盘弹起事件 ctxRef (\a => 主过程 sRef nowShowListRef (MK_键盘弹起事件 a) ioProc transition render) else pure ()
    setInterval' 帧率 (\_ => 主过程 sRef nowShowListRef (MK_心跳事件) ioProc transition render)
    setInterval' 帧率 (\_ => 渲染过程 ctxRef nowShowListRef oldShowListRef)
    where
    创建显示列表引用 : Unit -> IO (Ref (List 显示对象))
    创建显示列表引用 _ = newRef []
    帧率 : Double
    帧率 = 1000 / conf.帧率
