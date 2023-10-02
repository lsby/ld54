module Proc.ShowProc

import Hby.Game.Canvas.Draw
import System.InitState
import State.Hello
import State.SysInfo
import State.NodeSet
import State.Barrier

export
计算显示对象 : 状态 -> List 显示对象
计算显示对象 s = [ 创建显示对象 s.你好世界
                 , 创建显示对象 s.系统信息
                 , 创建显示对象 s.障碍
                 , 创建显示对象 s.主角
                 ]
