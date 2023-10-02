module Hby.Game.Canvas.Draw.Text

import Hby.Game.Base.Font
import Hby.Game.Canvas.Draw
import Hby.Game.Canvas.Base
import Hby.Game.Base.Position
import Hby.Game.Base.Color

export
record 文本 where
    constructor MK_文本
    内容 : String
    大小 : Int
    字体 : 字体
    颜色 : 颜色

export
创建文本 : (内容 : String) -> (大小 : Int) -> (字体 : 字体) -> (颜色 : 颜色) -> 文本
创建文本 = MK_文本

%foreign """
javascript:lambda:(ctx, x, y, str, f_size, f_name, f_color) => () => {
    ctx.fillStyle = f_color
    ctx.textAlign = "start"
    ctx.textBaseline = "top"
    ctx.font = f_size + "px " + f_name
    ctx.fillText(str, x, y)
}
"""
绘制文本_js : AnyPtr -> (x : Double) -> (y : Double) -> (内容 : String) -> (字体大小 : Int) -> (字体名称 : String) -> (颜色 : String) -> IO ()

绘制文本 : 画布上下文引用 -> 文本 -> (位置 : 坐标) -> IO ()
绘制文本 (MK_画布上下文引用 p) (MK_文本 nr dx zt ys) (MK_坐标 x y) = 绘制文本_js p x y nr dx (字体转字符串 zt) (取颜色值 ys)

export
元素 文本 where
    绘制元素 = 绘制文本
