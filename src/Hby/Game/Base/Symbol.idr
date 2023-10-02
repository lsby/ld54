module Hby.Game.Base.Symbol

public export
data 符号代理 : (a : String) -> Type where
    MK_符号代理 : 符号代理 a

export
反射符号代理 : {a : String} -> 符号代理 a -> String
反射符号代理 _ = a
