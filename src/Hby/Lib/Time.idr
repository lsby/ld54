module Hby.Lib.Time

%foreign """
javascript:lambda:(s) => () => {
    return new Date().getTime()
}
"""
export
getTime13 : Unit -> IO Int
