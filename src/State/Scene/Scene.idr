module State.Scene.Scene

import Hby.Game.Canvas.Draw
import State.Hello
import State.SysInfo
import State.NodeSet
import State.Barrier

public export
data 场景 = 开始画面 | 第一关 | 第二关 | 第三关

export
record 场景控制器 where
    constructor MK_场景控制器
    当前场景 : 场景

export
创建场景控制器 : 场景控制器
创建场景控制器 = MK_场景控制器 第三关

export
获得当前场景 : 场景控制器 -> 场景
获得当前场景 a = a.当前场景

export
修改当前场景 : 场景 -> 场景控制器 -> 场景控制器
修改当前场景 c a = {当前场景 := c} a
