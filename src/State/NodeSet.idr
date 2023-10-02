module State.NodeSet

import Data.String
import Hby.Game
import Hby.Game.Base.Area
import Hby.Game.Base.Position
import Hby.Game.Canvas.Draw
import Hby.Game.Canvas.Draw.Line
import Hby.Game.Canvas.Draw.CenterImage
import Hby.Game.Base.Color
import Hby.Lib.Debug
import State.Node

export
record 子节点集 where
    constructor MK_子节点集
    位置 : 坐标
    图片 : 中心图片
    父节点距离 : Double
    父节点角度范围 : (Double, Double)
    list : List 子节点集

export
创建子节点集 : 坐标 -> (图片 : 中心图片) -> (父节点距离 : Double) -> (父节点角度范围 : (Double, Double)) -> List 子节点集 -> 子节点集
创建子节点集 = MK_子节点集

export
record 节点集 where
    constructor MK_节点集
    根节点 : 节点
    子节点们 : List 节点集

映射节点集根 : (节点 -> 节点) -> 节点集 -> 节点集
映射节点集根 f (MK_节点集 root list) = MK_节点集 (f root) list

-- 这个函数顺便也重建了父子关系
刷新节点集整体位置 : 节点集 -> 节点集
刷新节点集整体位置 n@(MK_节点集 root Nil) = {根节点 $= 从父节点刷新位置} n
刷新节点集整体位置 n@(MK_节点集 root list) =
    let 新父节点 = 从父节点刷新位置 root
        设置父节点后的子节点们 = map (映射节点集根 (设置父节点 新父节点)) list
    in MK_节点集 新父节点 (map 刷新节点集整体位置 设置父节点后的子节点们)

重建子节点关系 : 节点集 -> 节点集
重建子节点关系 n@(MK_节点集 root Nil) = n
重建子节点关系 (MK_节点集 root list) = MK_节点集 root $ map ((映射节点集根 $ 设置父节点 root) . 重建子节点关系) list

export
创建节点集 : 坐标 -> (图片 : 中心图片) -> List 子节点集 -> 节点集
创建节点集 p img list =
    let 根节点 = 创建节点 p img Nothing
        下层节点集 : List 节点集 = map (子节点集转节点集 根节点) list
    in 刷新节点集整体位置 $ MK_节点集 根节点 下层节点集
    where
    子节点集转节点集 : (根节点 : 节点) -> 子节点集 -> 节点集
    子节点集转节点集 root (MK_子节点集 p img l r list) = let r = 创建节点 p img $ Just $ 创建父节点信息 root l r in MK_节点集 r (map (子节点集转节点集 r) list)

搜索节点集 : (条件 : 节点 -> Bool) -> 节点集 -> Bool
搜索节点集 c (MK_节点集 root Nil) = if c root then True else False
搜索节点集 c (MK_节点集 root list) = if c root then True
                                     else if (length $ filter (\a => a == True) (map (搜索节点集 c) list)) == 0 then False
                                     else True

-- todo 这应该可以写得更好
mutual
    映射节点集第一个' : (条件 : 节点 -> Bool) -> (映射函数 : 节点 -> 节点) -> List 节点集 -> List 节点集
    映射节点集第一个' c f Nil = Nil
    映射节点集第一个' c f (x :: xs) = if 搜索节点集 c x
                                      then 映射节点集第一个 c f x :: xs
                                      else x :: 映射节点集第一个' c f xs

    映射节点集第一个 : (条件 : 节点 -> Bool) -> (映射函数 : 节点 -> 节点) -> 节点集 -> 节点集
    映射节点集第一个 c f n@(MK_节点集 root Nil) = if c root then {根节点 := f root} n else n
    映射节点集第一个 c f n@(MK_节点集 root (x :: xs)) = if c root then {根节点 := f root} n
                                                        else if 搜索节点集 c x then {子节点们 := 映射节点集第一个 c f x :: xs } n
                                                        else {子节点们 := x :: 映射节点集第一个' c f xs } n

export
节点集处理事件 : (障碍区域 : 区域) -> 事件 -> 节点集 -> 节点集
节点集处理事件 _ e@(MK_鼠标按下事件 p) n@(MK_节点集 root list) = 重建子节点关系 $ 映射节点集第一个 (命中节点判断 p) (设置节点选中状态 True) n
节点集处理事件 b e@(MK_鼠标弹起事件 p) (MK_节点集 root list) = 重建子节点关系 $ MK_节点集 (设置节点选中状态 False root) (map (节点集处理事件 b e) list)
节点集处理事件 b e@(MK_鼠标移动事件 p) n@(MK_节点集 root list) = case 获得节点选中状态 root of
    True =>
        let 预计的结果 = 刷新节点集整体位置 $ MK_节点集 (节点移动 p root) list
            存在重叠 = 搜索节点集 (\a => 区域重叠 b $ 获得节点区域 a) 预计的结果
        in if 存在重叠 then n else 预计的结果
    False => 重建子节点关系 $ MK_节点集 root $ map (节点集处理事件 b e) list
节点集处理事件 _ _ s = s

export
节点集转实体集 : 节点集 -> 实体集
节点集转实体集 (MK_节点集 root list) =
    let 所有直接子节点 = map (.根节点) list
        所有相关线条 = map (\c => 创建线条 (获得节点位置 root) (获得节点位置 c) 10 (MK_颜色 "#AABBCC")) 所有直接子节点
        所有线条实体 = map (\c => 创建实体 c (MK_坐标 0 0) 1) 所有相关线条
        所有线条实体集 = MK_实体集 所有线条实体
    in 合并实体集 (合并实体集 (转换到实体集 root) 所有线条实体集) (MK_实体集 $ 实体集列表展开 (map 节点集转实体集 list))

export
可以被显示 节点集 where
    转换到实体集 a = 节点集转实体集 a
