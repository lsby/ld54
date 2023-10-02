module Hby.Game.Canvas.Draw.Rect

import Hby.Game.Base.Color
import Hby.Game.Canvas.Base
import Hby.Game.Base.Size
import Hby.Game.Base.Position
import Hby.Game.Canvas.Draw

-- 矩形
export
record 矩形 where
    constructor MK_矩形
    大小 : 大小
    颜色 : 颜色

export
创建矩形 : 大小 -> 颜色 -> 矩形
创建矩形 = MK_矩形

%foreign """
javascript:lambda:(ctx, x, y, w, h, ys) => () => {
    ctx.fillStyle = ys
    ctx.fillRect(x, y, w, h)
}
"""
绘制矩形_js : AnyPtr -> (x : Double) -> (y : Double) -> (w : Double) -> (h : Double) -> (颜色 : String) -> IO ()

绘制矩形 : 画布上下文引用 -> 矩形 -> (位置 : 坐标) -> IO ()
绘制矩形 (MK_画布上下文引用 p) (MK_矩形 (MK_大小 w h) ys) (MK_坐标 x y) = 绘制矩形_js p x y w h (取颜色值 ys)

export
元素 矩形 where
    绘制元素 = 绘制矩形
