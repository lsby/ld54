module Hby.Game.Base.Color

import Data.String

public export
是合法的颜色位 : String -> Bool
是合法的颜色位 "0" = True
是合法的颜色位 "1" = True
是合法的颜色位 "2" = True
是合法的颜色位 "3" = True
是合法的颜色位 "4" = True
是合法的颜色位 "5" = True
是合法的颜色位 "6" = True
是合法的颜色位 "7" = True
是合法的颜色位 "8" = True
是合法的颜色位 "9" = True
是合法的颜色位 "A" = True
是合法的颜色位 "B" = True
是合法的颜色位 "C" = True
是合法的颜色位 "D" = True
是合法的颜色位 "E" = True
是合法的颜色位 "F" = True
是合法的颜色位 _ = False

public export
字符串去掉头 : String -> String
字符串去掉头 s = strSubstr 1 ((strLength s) - 1) s

public export
拆分字符串 : String -> List String
拆分字符串 "" = Nil
拆分字符串 s = (strSubstr 0 1 s) :: (拆分字符串 $ 字符串去掉头 s)

public export
与 : Bool -> Bool -> Bool
与 True True = True
与 _ _ = False

-- 颜色
export
data 颜色 = MK_颜色_内部 String
data 颜色视角 = 正常颜色 | 错误颜色
data 错误的颜色 = MK_错误的颜色

public export
颜色判定 : String -> 颜色视角
颜色判定 s =
    if strLength s /= 7 then 错误颜色
    else if strSubstr 0 1 s /= "#" then 错误颜色
    else if (foldl 与 True $ map 是合法的颜色位 $ 拆分字符串 $ 字符串去掉头 s) == False then 错误颜色
    else 正常颜色

public export
颜色类型转换 : 颜色视角 -> Type
颜色类型转换 (正常颜色) = 颜色
颜色类型转换 (错误颜色) = 错误的颜色

export
MK_颜色 : (a : String) -> 颜色类型转换 (颜色判定 a)
MK_颜色 a with (颜色判定 a)
    _ | 正常颜色 = MK_颜色_内部 a
    _ | 错误颜色 = MK_错误的颜色

export
取颜色值 : 颜色 -> String
取颜色值 (MK_颜色_内部 a) = a
