module State.Barrier

import Data.String
import Hby.Game.Base.Position
import Hby.Game.Canvas.Draw.Text
import Hby.Game.Base.Font
import Hby.Game.Base.Color
import Hby.Game.Canvas.Draw
import Hby.Game.Canvas.Draw.Rect
import System.Symbol
import Hby.Game.Base.Area
import Hby.Game.Base.Size

export
record 障碍 where
    constructor MK_障碍
    位置 : 坐标
    大小 : 大小
    文本 : String
    颜色 : 颜色

export
创建障碍 : 坐标 -> 大小 -> String -> 颜色 -> 障碍
创建障碍 = MK_障碍

export
计算障碍区域 : 障碍 -> 区域
计算障碍区域 a = MK_区域 a.位置.x a.位置.y a.大小.w a.大小.h

export
可以被显示 障碍 where
    转换到实体集 a =
        let 位置 = a.位置
            大小 = a.大小
        in MK_实体集 [ 创建实体 { 元素 = 创建文本 { 内容 = a.文本
                                                  , 大小 = 20
                                                  , 字体 = MK_字体 符号_宋体
                                                  , 颜色 = MK_颜色 "#66CCFF"
                                                  }
                                , 位置 = 位置
                                , 图层 = 1
                                }
                     , 创建实体 { 元素 = 创建矩形 (大小) (a.颜色)
                                , 位置 = 位置
                                , 图层 = 1
                                }
                     ]
