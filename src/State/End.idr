module State.End

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
record 结束画面 where
    constructor MK_结束画面
    位置 : 坐标
    大小 : 大小

export
创建结束画面 : 结束画面
创建结束画面 = MK_结束画面 (MK_坐标 70 400) (MK_大小 700 50)

export
可以被显示 结束画面 where
    转换到实体集 a =
        let 位置 = a.位置
            大小 = a.大小
        in MK_实体集 [ 创建实体 { 元素 = 创建文本 { 内容 = "感谢游玩(Thanks for playing)"
                                                  , 大小 = cast $ (.h) 大小
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
