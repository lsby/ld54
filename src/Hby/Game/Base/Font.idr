module Hby.Game.Base.Font

import Hby.Game.Base.Symbol

public export
interface 字体枚举 (a : String) where

export
data 字体 = MK_字体_内部 String

export
MK_字体 : {a : String} -> 字体枚举 a => 符号代理 a -> 字体
MK_字体 _ = MK_字体_内部 a

export
字体转字符串 : 字体 -> String
字体转字符串 (MK_字体_内部 x) = x
