module Proc.StateProc

import Hby.Game
import System.InitState
import State.Scene.Scene
import State.Scene.Func

export
计算状态迁移 : 事件 -> 状态 -> 状态
计算状态迁移 e s = 场景控制器处理事件 e s
