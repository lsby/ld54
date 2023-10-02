module Hby.Game.Canvas.Event

import Hby.Game.Base.Position
import Hby.Game.Base.Key
import Hby.Game.Canvas.Base

-- 事件
%foreign """
javascript:lambda:(坐标构造子, 上下文, 鼠标移动回调) => () => {
    var canvas = 上下文.canvas
    var left = canvas.getBoundingClientRect().left
    var top = canvas.getBoundingClientRect().top
    canvas.onmousemove = (a) => {
        var 坐标 = 坐标构造子(a.clientX - left)(a.clientY - top)
        鼠标移动回调(坐标)()
    }
}
"""
设置鼠标移动事件_js : (坐标构造子 : Double -> Double -> 坐标) -> 画布上下文引用 -> (鼠标移动回调 : 坐标 -> IO ()) -> IO ()

export
设置鼠标移动事件 : 画布上下文引用 -> (鼠标移动回调 : 坐标 -> IO ()) -> IO ()
设置鼠标移动事件 ctxRef e = 设置鼠标移动事件_js MK_坐标 ctxRef e

%foreign """
javascript:lambda:(坐标构造子, 上下文, 鼠标按下回调) => () => {
    var canvas = 上下文.canvas
    var left = canvas.getBoundingClientRect().left
    var top = canvas.getBoundingClientRect().top
    canvas.onmousedown = (a) => {
        var 坐标 = 坐标构造子(a.clientX - left)(a.clientY - top)
        鼠标按下回调(坐标)()
    }
}
"""
设置鼠标按下事件_js : (坐标构造子 : Double -> Double -> 坐标) -> 画布上下文引用 -> (鼠标按下回调 : 坐标 -> IO ()) -> IO ()

export
设置鼠标按下事件 : 画布上下文引用 -> (鼠标按下回调 : 坐标 -> IO ()) -> IO ()
设置鼠标按下事件 ctxRef e = 设置鼠标按下事件_js MK_坐标 ctxRef e

%foreign """
javascript:lambda:(坐标构造子, 上下文, 鼠标弹起回调) => () => {
    var canvas = 上下文.canvas
    var left = canvas.getBoundingClientRect().left
    var top = canvas.getBoundingClientRect().top
    canvas.onmouseup = (a) => {
        var 坐标 = 坐标构造子(a.clientX - left)(a.clientY - top)
        鼠标弹起回调(坐标)()
    }
}
"""
设置鼠标弹起事件_js : (坐标构造子 : Double -> Double -> 坐标) -> 画布上下文引用 -> (鼠标弹起回调 : 坐标 -> IO ()) -> IO ()

export
设置鼠标弹起事件 : 画布上下文引用 -> (鼠标弹起回调 : 坐标 -> IO ()) -> IO ()
设置鼠标弹起事件 ctxRef e = 设置鼠标弹起事件_js MK_坐标 ctxRef e

%foreign """
javascript:lambda:(键构造子, 上下文, 键盘按下回调) => () => {
    var canvas = 上下文.canvas
    canvas.onkeydown = (a) => {
        键盘按下回调(键构造子(a.key))()
    }
}
"""
设置键盘按下事件_js : (键构造子 : String -> 键) -> 画布上下文引用 -> (键盘按下回调 : 键 -> IO ()) -> IO ()

export
设置键盘按下事件 : 画布上下文引用 -> (键盘按下回调 : 键 -> IO ()) -> IO ()
设置键盘按下事件 ctxRef e = 设置键盘按下事件_js 创建键 ctxRef e

%foreign """
javascript:lambda:(键构造子, 上下文, 键盘弹起回调) => () => {
    var canvas = 上下文.canvas
    canvas.onkeyup = (a) => {
        键盘弹起回调(键构造子(a.key))()
    }
}
"""
设置键盘弹起事件_js : (键构造子 : String -> 键) -> 画布上下文引用 -> (键盘弹起回调 : 键 -> IO ()) -> IO ()

export
设置键盘弹起事件 : 画布上下文引用 -> (键盘弹起回调 : 键 -> IO ()) -> IO ()
设置键盘弹起事件 ctxRef e = 设置键盘弹起事件_js 创建键 ctxRef e
