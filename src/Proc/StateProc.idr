module Proc.StateProc

import Hby.Game
import System.InitState
import State.NodeSet
import State.Barrier

export
计算状态迁移 : 事件 -> 状态 -> 状态
计算状态迁移 (MK_心跳事件) s = s
计算状态迁移 e@(MK_鼠标按下事件 _) s = {主角 $= 节点集处理事件 (计算障碍区域 s.障碍) e} s
计算状态迁移 e@(MK_鼠标弹起事件 _) s = {主角 $= 节点集处理事件 (计算障碍区域 s.障碍) e} s
计算状态迁移 e@(MK_鼠标移动事件 _) s = {主角 $= 节点集处理事件 (计算障碍区域 s.障碍) e} s
计算状态迁移 _ s = s
