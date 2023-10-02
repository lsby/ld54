module Hby.Game.Canvas.Draw.CenterImage

import Hby.Game.Canvas.Draw.Image
import Hby.Game.Canvas.Base
import Hby.Game.Base.Size
import Hby.Game.Base.Area
import Hby.Game.Base.Position
import Hby.Game.Canvas.Draw

居中变换 : 大小 -> 坐标 -> 坐标
居中变换 (MK_大小 w h) (MK_坐标 x y) = MK_坐标 (x-(w/2)) (y-(h/2))

export
record 中心图片 where
    constructor MK_中心图片
    图片 : 图片

export
创建中心图片 : 大小 -> (路径 : String) -> IO (中心图片)
创建中心图片 dx s = map MK_中心图片 $ 创建图片 dx s

export
从中心图片计算区域 : (中心点 : 坐标) -> 中心图片 -> 区域
从中心图片计算区域 (MK_坐标 x y) (MK_中心图片 img) = case 取图片大小 img of
    MK_大小 w h => MK_区域 (x - w / 2) (y - h / 2) w h

绘制中心图片 : 画布上下文引用 -> 中心图片 -> (位置 : 坐标) -> IO ()
绘制中心图片 p (MK_中心图片 img) wz = 绘制图片 p img (居中变换 (取图片大小 img) wz)

export
元素 中心图片 where
    绘制元素 = 绘制中心图片
