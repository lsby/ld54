module State.SysInfo

import Data.String
import Hby.Game.Canvas.Draw
import Hby.Game.Canvas.Draw.Text
import Hby.Game.Base.Position
import Hby.Game.Base.Font
import Hby.Game.Base.Color
import Hby.Game.Base.Symbol
import System.Symbol

export
record 系统信息 where
    constructor MK_系统信息
    上次刷新时间 : Maybe Int
    帧率 : Int

export
创建系统信息 : 系统信息
创建系统信息 = MK_系统信息 { 上次刷新时间 = Nothing
                           , 帧率 = 0
                           }

export
设置帧率 : Int -> 系统信息 -> 系统信息
设置帧率 x a = {帧率 := x} a

export
设置上次刷新时间 : Maybe Int -> 系统信息 -> 系统信息
设置上次刷新时间 x a = {上次刷新时间 := x} a

export
获得上次刷新时间 : 系统信息 -> Maybe Int
获得上次刷新时间 a = a.上次刷新时间

export
可以被显示 系统信息 where
    转换到实体集 a = 创建单一实体集 { 元素 = 创建文本 { 内容 = "帧率: " ++ cast a.帧率
                                                      , 大小 = 20
                                                      , 字体 = MK_字体 符号_宋体
                                                      , 颜色 = MK_颜色 "#456123"
                                                      }
                                    , 位置 = MK_坐标 0 0
                                    , 图层 = 2
                                    }
