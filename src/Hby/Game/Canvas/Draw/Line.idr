module Hby.Game.Canvas.Draw.Line

import Hby.Game.Base.Font
import Hby.Game.Canvas.Draw
import Hby.Game.Canvas.Base
import Hby.Game.Base.Position
import Hby.Game.Base.Color

export
record 线条 where
    constructor MK_线条
    起点 : 坐标
    终点 : 坐标
    大小 : Double
    颜色 : 颜色

export
创建线条 : (起点 : 坐标) -> (终点 : 坐标) -> (大小 : Double) -> (颜色 : 颜色) -> 线条
创建线条 = MK_线条

%foreign """
javascript:lambda:(ctx, x1, y1, x2, y2, size, color) => () => {
    ctx.strokeStyle = color
    ctx.lineWidth = size
    ctx.beginPath()
    ctx.moveTo(x1, y1)
    ctx.lineTo(x2, y2)
    ctx.stroke()
}
"""
绘制线条_js : AnyPtr -> (x1 : Double) -> (y1 : Double) -> (x2 : Double) -> (y2 : Double) -> (大小 : Double) -> (颜色 : String) -> IO ()

绘制线条 : 画布上下文引用 -> 线条 -> (位置 : 坐标) -> IO ()
绘制线条 (MK_画布上下文引用 p) (MK_线条 (MK_坐标 x1 y1) (MK_坐标 x2 y2) dx ys) (MK_坐标 x y) = 绘制线条_js p (x + x1) (y + y1) (x + x2) (y + y2) dx (取颜色值 ys)

export
元素 线条 where
    绘制元素 = 绘制线条
