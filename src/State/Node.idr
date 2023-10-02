module State.Node

import Hby.Game
import Hby.Game.Base.Area
import Hby.Game.Base.Position
import Hby.Game.Canvas.Draw
import Hby.Game.Canvas.Draw.CenterImage
import Hby.Lib.Math
import Hby.Lib.Polar
import Hby.Lib.Debug

data 节点状态 = 选中 | 没选中

mutual
    export
    record 父节点信息 where
        constructor MK_父节点信息
        节点 : 节点
        距离 : Double
        -- 做以父节点原点建立平面直角坐标系.
        -- 做父节点到子节点的射线, 考虑这条线在上述坐标系中的角度.
        -- 这里写的是角度不是弧度, 范围-180到180, 但注意这个坐标系中顺时针才是正半轴.
        角度范围 : (Double, Double)

    export
    record 节点 where
        constructor MK_节点
        位置 : 坐标
        图片 : 中心图片
        状态 : 节点状态
        父节点信息 : Maybe 父节点信息

export
创建父节点信息 : 节点 -> Double -> (Double, Double) -> 父节点信息
创建父节点信息 = MK_父节点信息

export
创建节点 : 坐标 -> (图片 : 中心图片) -> (父节点信息 : Maybe 父节点信息) -> 节点
创建节点 p s f = MK_节点 p s 没选中 f

export
获得节点图片 : 节点 -> 中心图片
获得节点图片 n = n.图片

export
获得节点选中状态 : 节点 -> Bool
获得节点选中状态 (MK_节点 _ _ 选中 _) = True
获得节点选中状态 (MK_节点 _ _ 没选中 _) = False

export
获得节点位置 : 节点 -> 坐标
获得节点位置 (MK_节点 x _ _ _) = x

export
设置节点选中状态 : Bool -> 节点 -> 节点
设置节点选中状态 True n = {状态 := 选中} n
设置节点选中状态 False n = {状态 := 没选中} n

export
设置父节点 : (父节点 : 节点) -> 节点 -> 节点
设置父节点 f_node n@(MK_节点 _ _ _ Nothing) = n
设置父节点 f_node n@(MK_节点 a b c (Just (MK_父节点信息 _ d r))) = MK_节点 a b c (Just $ MK_父节点信息 f_node d r)

export
命中节点判断 : 坐标 -> 节点 -> Bool
命中节点判断 p a = 点在区域中 p (从中心图片计算区域 a.位置 a.图片)

节点移动' : (目标位置 : 坐标) -> 节点 -> 节点
节点移动' p a = case a.父节点信息 of
    Nothing => {位置 := p} a
    Just (MK_父节点信息 f l r) =>
        let 父节点距离 = l
            目标点极坐标 = 平面直角坐标转极坐标 $ 转换到参考系 f.位置 p
            目标点极角 = (.极角) 目标点极坐标
            角度范围起点 = 角度转弧度 $ fst r
            角度范围终点 = 角度转弧度 $ snd r
            角度范围起点虚拟位置 = 转换到参考系 (映射位置值 (* -1) f.位置) $ 极坐标转平面直角坐标 (MK_极坐标点 100 角度范围起点)
            角度范围终点虚拟位置 = 转换到参考系 (映射位置值 (* -1) f.位置) $ 极坐标转平面直角坐标 (MK_极坐标点 100 角度范围终点)
            最近边界是起点 = if (计算两点间距离 p 角度范围起点虚拟位置) > (计算两点间距离 p 角度范围终点虚拟位置) then False else True
            离目标点近的边界 = if 最近边界是起点 == True then 角度范围起点 else 角度范围终点
            最终目标位置 = if 目标点极角 > 角度范围起点 && 目标点极角 < 角度范围终点 then p
                           else if 角度范围终点 > pi && 最近边界是起点 == False && (目标点极角 + pi) < (角度范围终点 - pi) then p
                           else 转换到参考系 (映射位置值 (* -1) f.位置) $ 极坐标转平面直角坐标 $ {极角 := 离目标点近的边界} 目标点极坐标
            目标距离 = 计算两点间距离 最终目标位置 f.位置
            相似比 = 父节点距离 / 目标距离
            目标x距离 = (.x) 最终目标位置 - f.位置.x
            目标y距离 = (.y) 最终目标位置 - f.位置.y
            最终x位置 = f.位置.x + 相似比 * 目标x距离
            最终y位置 = f.位置.y + 相似比 * 目标y距离
        in {位置 := MK_坐标 最终x位置 最终y位置} a

export
节点移动 : (目标位置 : 坐标) -> 节点 -> 节点
节点移动 p a = case a.状态 of
    没选中 => a
    选中 => 节点移动' p a

export
从父节点刷新位置 : 节点 -> 节点
从父节点刷新位置 a = 节点移动' a.位置 a

export
可以被显示 节点 where
    转换到实体集 a = 创建单一实体集 { 元素 = a.图片
                                    , 位置 = a.位置
                                    , 图层 = 1
                                    }
