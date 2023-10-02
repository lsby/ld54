module State.Hello

import Data.String
import Hby.Game.Canvas.Draw
import Hby.Game.Canvas.Draw.Text
import Hby.Game.Base.Position
import Hby.Game.Base.Font
import Hby.Game.Base.Color
import System.Symbol

export
record 你好世界 where
    constructor MK_你好世界
    位置 : 坐标

export
创建你好世界 : 坐标 -> 你好世界
创建你好世界 p = MK_你好世界 p

export
可以被显示 你好世界 where
    转换到实体集 a = 创建单一实体集 { 元素 = 创建文本 { 内容 = "上床睡觉!(go to bed!)"
                                                      , 大小 = 70
                                                      , 字体 = MK_字体 符号_宋体
                                                      , 颜色 = MK_颜色 "#66CCFF"
                                                      }
                                    , 位置 = a.位置
                                    , 图层 = 1
                                    }
