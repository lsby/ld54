module Hby.Game.Canvas.Base

import Hby.Game.Base.Size

public export
data 画布上下文引用 = MK_画布上下文引用 AnyPtr

%foreign """
javascript:lambda:(w, h, id) => () => {
    var app = document.getElementById(id)
    var canvas = document.createElement('canvas')
    app.append(canvas)

    // canvas.width = window.outerWidth
    // canvas.height = window.innerHeight

    canvas.style.width = w + 'px'
    canvas.style.height = h+ 'px'
    canvas.width = w
    canvas.height = h

    canvas.style.border = '1px dashed #000'

    canvas.tabIndex = 1000
    canvas.style.outline = "none"

    return canvas.getContext('2d')
}
"""
获得上下文引用_js : (w : Double) -> (h : Double) -> (画布ID : String) -> IO AnyPtr

export
获得上下文引用 : (大小 : 大小) -> (画布ID : String) -> IO 画布上下文引用
获得上下文引用 (MK_大小 w h) id = map MK_画布上下文引用 $ 获得上下文引用_js w h id

%foreign """
javascript:lambda:(上下文) => () => {
    var canvas = 上下文.canvas
    上下文.clearRect(0, 0, canvas.width, canvas.height)
}
"""
export
清空画布 : 画布上下文引用 -> IO ()
