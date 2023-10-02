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

export
区域重叠 : 区域 -> 区域 -> Bool
区域重叠 (MK_区域 x1 y1 w1 h1) (MK_区域 x2 y2 w2 h2) =
    if x1 < x2 + w2 &&
       x1 + w1 > x2 &&
       y1 < y2 + h2 &&
       y1 + h1 > y2
    then True
    else False
