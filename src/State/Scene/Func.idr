module State.Scene.Func

import Hby.Game
import Hby.Game.Canvas.Draw
import System.InitState
import State.Hello
import State.SysInfo
import State.Protagonist
import State.Barrier
import State.Scene.Scene
import State.Start
import State.Bed
import Hby.Game.Base.Area

export
获得显示对象 : 状态 -> List 显示对象
获得显示对象 s = case 获得当前场景 s.场景控制器 of
    开始画面 => [ 创建显示对象 s.开始画面
                ]
    第一关 => [ 创建显示对象 s.你好世界
              , 创建显示对象 s.系统信息
              , 创建显示对象 s.障碍
              , 创建显示对象 s.主角
              , 创建显示对象 s.床
              ]
    第二关 => []

export
场景控制器处理事件 : 事件 -> 状态 -> 状态
场景控制器处理事件 e s = case 获得当前场景 s.场景控制器 of
    开始画面 => case e of
        (MK_鼠标弹起事件 p) => case 点在区域中 p (获得开始按钮区域 s.开始画面) of
            True => {场景控制器 := 修改当前场景 第一关 s.场景控制器} s
            False => s
        _ => s
    第一关 => case e of
        (MK_鼠标按下事件 _) => {主角 $= 主角处理事件 (计算障碍区域 s.障碍) e} s
        (MK_鼠标弹起事件 _) => {主角 $= 主角处理事件 (计算障碍区域 s.障碍) e} s
        (MK_鼠标移动事件 _) => {主角 $= 主角处理事件 (计算障碍区域 s.障碍) e} s
        _ => s
    第二关 => s
