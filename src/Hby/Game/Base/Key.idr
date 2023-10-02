module Hby.Game.Base.Key

export
data 键 = MK_键 String

export
创建键 : String -> 键
创建键 = MK_键

export
取键字符串 : 键 -> String
取键字符串 (MK_键 a) = a

export
Show 键 where
    show (MK_键 a) = "key:" ++ a
