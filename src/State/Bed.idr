module State.Bed

import Data.String
import Hby.Game.Canvas.Draw
import Hby.Game.Canvas.Draw.Text
import Hby.Game.Base.Position
import Hby.Game.Base.Font
import Hby.Game.Base.Color
import Hby.Game.Base.Size
import System.Symbol
import Hby.Game.Canvas.Draw.Rect
import Hby.Game.Base.Area

export
record 床 where
    constructor MK_床
    位置 : 坐标
    大小 : 大小

export
创建床 : 床
创建床 = MK_床 (MK_坐标 500 200) (MK_大小 200 300)

export
获得床区域 : 床 -> 区域
获得床区域 a = MK_区域 a.位置.x a.位置.y a.大小.w a.大小.h

export
可以被显示 床 where
    转换到实体集 a =
        let 位置 = a.位置
            大小 = a.大小
        in MK_实体集 [ 创建实体 { 元素 = 创建文本 { 内容 = "床(bed)"
                                                  , 大小 = 20
                                                  , 字体 = MK_字体 符号_宋体
                                                  , 颜色 = MK_颜色 "#66CCFF"
                                                  }
                                , 位置 = 位置
                                , 图层 = 1
                                }
                     , 创建实体 { 元素 = 创建矩形 (大小) (MK_颜色 "#FFEEDD")
                                , 位置 = 位置
                                , 图层 = 1
                                }
                     ]
