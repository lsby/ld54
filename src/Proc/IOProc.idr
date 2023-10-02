module Proc.IOProc

import Hby.Game
import Hby.Lib.Time
import System.InitState
import State.SysInfo

设置系统信息 : (帧率 : Int) -> 状态 -> 状态
设置系统信息 z s = {系统信息 $= 设置帧率 z } s

设置帧率 : 状态 -> IO 状态
设置帧率 s = do
    now <- getTime13 ()
    s' <- pure $ {系统信息 $= 设置上次刷新时间  $ Just now} s
    case 获得上次刷新时间 s.系统信息 of
        Nothing => pure s'
        Just last => do
            pure $ 设置系统信息 (div 1000 $ now - last) s'

export
IO过程 : 事件 -> 状态 -> IO 状态
IO过程 (MK_心跳事件) s = 设置帧率 $ s
IO过程 e s = pure s
