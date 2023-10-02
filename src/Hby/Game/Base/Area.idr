module Hby.Game.Base.Area

import Hby.Game.Base.Position

public export
record 区域 where
    constructor MK_区域
    x, y, w, h : Double

export
点在区域中 : 坐标 -> 区域 -> Bool
点在区域中 (MK_坐标 x y) (MK_区域 x1 y1 w1 h1) =
    if (x > x1) && (x < x1 + w1) && (y > y1) && (y < y1 + h1)
    then True
    else False
