module Hby.Lib.Math

%foreign """
javascript:lambda:(a, b) => {
    return Math.atan2(a, b)
}
"""
export
atan2 : Double -> Double -> Double

export
角度转弧度 : (角度 : Double) -> Double
角度转弧度 a = a * (pi / 180)
