module Hby.Lib.Debug

%foreign """
javascript:lambda:(_, s) => () => {
    console.log(s)
}
"""
export
debug : a -> IO ()

%foreign """
javascript:lambda:(_, s) => {
    console.log(s)
    return s
}
"""
export
tap : a -> a

%foreign """
javascript:lambda:(_, __, s, a) => {
    console.log(s)
    return a
}
"""
export
tap' : a -> b -> b
