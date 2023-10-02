module Main

import Hby.Lib.Ref
import Hby.Game
import Hby.Game.Base.Size
import System.InitState
import Proc.IOProc
import Proc.ShowProc
import Proc.StateProc

设置 : 游戏设置
设置 = 创建游戏设置 { 画布大小 = MK_大小 800 600
                    , 使能鼠标移动事件 = True
                    , 使能鼠标按下事件 = True
                    , 使能鼠标弹起事件 = True
                    , 使能键盘按下事件 = True
                    , 使能键盘弹起事件 = True
                    , 帧率 = 24
                    }

main : IO ()
main = do
    sRef <- 初始状态
    游戏 设置 sRef IO过程 计算状态迁移 计算显示对象
