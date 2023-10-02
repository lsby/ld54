module Hby.Game.Base.Position

public export
record 坐标 where
    constructor MK_坐标
    x, y : Double

export
计算两点间距离 : 坐标 -> 坐标 -> Double
计算两点间距离 (MK_坐标 x1 y1) (MK_坐标 x2 y2) = sqrt $ (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)

export
转换到参考系 : (目标参考系零点 : 坐标) -> (要转换的坐标 : 坐标) -> 坐标
转换到参考系 (MK_坐标 ox' oy') (MK_坐标 x y) = MK_坐标 (x - ox') (y - oy')

export
映射位置值 : (Double -> Double) -> 坐标 -> 坐标
映射位置值 f (MK_坐标 x y) = MK_坐标 (f x) (f y)

export
Show 坐标 where
    show (MK_坐标 x y) = "(" ++ (show x) ++ ", " ++ (show y) ++ ")"
