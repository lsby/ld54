module Hby.Lib.Util

%foreign """
javascript:lambda:(时间, 函数) => () => {
    setTimeout(函数(), 时间)
}
"""
export
setTimeOut : (时间 : Double) -> (函数 : Unit -> IO ()) -> IO ()

%foreign """
javascript:lambda:(时间, 函数) => () => {
    setInterval(函数(), 时间)
}
"""
export
setInterval : (时间 : Double) -> (函数 : Unit -> IO ()) -> IO ()

%foreign """
javascript:lambda:(时间, 函数) => () => {
    function f(){
        setTimeout(() => {
            函数()()
            f()
        }, 时间)
    }
    f()
}
"""
export
setInterval' : (时间 : Double) -> (函数 : Unit -> IO ()) -> IO ()
