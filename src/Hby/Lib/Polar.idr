module Hby.Lib.Polar

import Hby.Game.Base.Position
import Hby.Lib.Math

public export
record 极坐标点 where
    constructor MK_极坐标点
    极径 : Double
    极角 : Double

export
极坐标转平面直角坐标 : 极坐标点 -> 坐标
极坐标转平面直角坐标 (MK_极坐标点 r s) = MK_坐标 (r * cos s) (r * sin s)

export
平面直角坐标转极坐标 : 坐标 -> 极坐标点
平面直角坐标转极坐标 (MK_坐标 x y) = MK_极坐标点 (sqrt (x * x + y * y)) (atan2 y x)
