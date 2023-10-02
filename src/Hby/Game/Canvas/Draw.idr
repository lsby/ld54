module Hby.Game.Canvas.Draw

import Hby.Game.Base.Position
import Hby.Game.Base.Size
import Hby.Game.Canvas.Base

||| 元素是图形的基础构成
||| 比如图片, 文本等等, 都可以实现这个接口
||| 但元素还不能被绘制, 它还缺少坐标
public export
interface 元素 a where
    绘制元素 : 画布上下文引用 -> a -> (位置 : 坐标) -> IO ()

||| 实体是真正可以被绘制的东西
||| 实体包装了元素, 并要求多提供位置和图层
||| 只有元素才可以构造出实体
export
record 实体 where
    constructor MK_实体
    实体 : ({ r : Type } -> ({ a : Type } -> 元素 a => a -> r) -> r)
    位置 : 坐标
    图层 : Int

export
创建实体 : {a:Type} -> 元素 a => (元素 : a) -> (位置 : 坐标) -> (图层 : Int) -> 实体
创建实体 a wz tc = MK_实体 (\a_r => a_r a) wz tc

export
解包实体 : {r:Type} -> ({a:Type} -> 元素 a => a -> 坐标 -> Int -> r) -> 实体 -> r
解包实体 f (MK_实体 a wz tc) = a f wz tc

export
获得实体图层 : 实体 -> Int
获得实体图层 (MK_实体 a wz tc) = tc

||| 实体集是实体的集合
public export
data 实体集 : Type where
    MK_实体集 : List 实体 -> 实体集

||| 方便的创建只有一个元素的实体集
export
创建单一实体集 : {a:Type} -> 元素 a => (元素 : a) -> (位置 : 坐标) -> (图层 : Int) -> 实体集
创建单一实体集 a wz tc = MK_实体集 [MK_实体 (\a_r => a_r a) wz tc]

||| 将实体集列表展开为实体列表
export
实体集列表展开 : List 实体集 -> List 实体
实体集列表展开 Nil = []
实体集列表展开 ((MK_实体集 x) :: xs) = x ++ 实体集列表展开 xs

export
合并实体集 : 实体集 -> 实体集 -> 实体集
合并实体集 (MK_实体集 a) (MK_实体集 b) = MK_实体集 $ a ++ b

||| 描述某物可以转换为实体集
||| 游戏中所有可以被显示的东西都应该实现这个接口
public export
interface 可以被显示 a where
    转换到实体集 : a -> 实体集

||| 显示对象是"可以被显示"的包装
||| 只有"可以被显示"才可以构造显示对象
export
data 显示对象 = MK_显示对象 ({ r : Type } -> ({ a : Type } -> 可以被显示 a => a -> r) -> r)

export
创建显示对象 : {a:Type} -> 可以被显示 a => a -> 显示对象
创建显示对象 a = MK_显示对象 (\a_r => a_r a)

export
解包显示对象 : {r:Type} -> ({a:Type} -> 可以被显示 a => a -> r) -> 显示对象 -> r
解包显示对象 f (MK_显示对象 a) = a f
