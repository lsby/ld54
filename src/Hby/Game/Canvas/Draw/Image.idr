module Hby.Game.Canvas.Draw.Image

import Hby.Game.Canvas.Base
import Hby.Game.Base.Size
import Hby.Game.Base.Position
import Hby.Game.Canvas.Draw

-- 图片
export
record 图片 where
    constructor MK_图片
    大小 : 大小
    图片对象 : AnyPtr

%foreign """
javascript:lambda:(路径) => () => {
    var img = new Image()
    img.src = 路径
    return img
}
"""
创建图片_js : (路径 : String) -> IO (AnyPtr)

export
创建图片 : 大小 -> (路径 : String) -> IO (图片)
创建图片 dx s = map (MK_图片 dx) $ 创建图片_js s

%foreign """
javascript:lambda:(ctx, x, y, w, h, img) => () => {
    ctx.drawImage(img, x, y, w, h)
}
"""
绘制图片_js : AnyPtr -> (x : Double) -> (y : Double) -> (w : Double) -> (h : Double) -> AnyPtr -> IO ()

export
绘制图片 : 画布上下文引用 -> 图片 -> (位置 : 坐标) -> IO ()
绘制图片 (MK_画布上下文引用 p) (MK_图片 (MK_大小 w h) img) (MK_坐标 x y) = 绘制图片_js p x y w h img

export
取图片大小 : 图片 -> 大小
取图片大小 (MK_图片 dx img) = dx

export
元素 图片 where
    绘制元素 = 绘制图片
