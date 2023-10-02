module State.Barrier

import Hby.Game.Base.Position
import Hby.Game.Canvas.Draw
import Hby.Game.Canvas.Draw.Rect
import Hby.Game.Base.Area
import Hby.Game.Base.Size

export
record 障碍 where
    constructor MK_障碍
    图片 : 矩形

export
创建障碍 : 矩形 -> 障碍
创建障碍 = MK_障碍

export
计算障碍区域 : 障碍 -> 区域
计算障碍区域 a = MK_区域 0 0 (大小.w $ 获得大小 a.图片) (大小.h $ 获得大小 a.图片)

export
可以被显示 障碍 where
    转换到实体集 a = 创建单一实体集 { 元素 = a.图片
                                    , 位置 = MK_坐标 0 0
                                    , 图层 = 1
                                    }

