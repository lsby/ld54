module Proc.StateProc

import Hby.Game
import System.InitState
import State.NodeSet

export
计算状态迁移 : 事件 -> 状态 -> 状态
计算状态迁移 (MK_心跳事件) s = s
计算状态迁移 e@(MK_鼠标按下事件 _) s = {测试节点集 $= 节点集处理事件 e} s
计算状态迁移 e@(MK_鼠标弹起事件 _) s = {测试节点集 $= 节点集处理事件 e} s
计算状态迁移 e@(MK_鼠标移动事件 _) s = {测试节点集 $= 节点集处理事件 e} s
计算状态迁移 _ s = s
