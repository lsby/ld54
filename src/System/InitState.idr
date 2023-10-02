module System.InitState

import Data.String
import Hby.Lib.Ref
import Hby.Game
import Hby.Game.Base.Size
import Hby.Game.Base.Position
import Hby.Game.Base.Color
import Hby.Game.Canvas.Draw.CenterImage
import Hby.Game.Canvas.Draw.Rect
import State.Hello
import State.SysInfo
import State.Node
import State.Protagonist
import State.Barrier
import State.Scene.Scene
import State.Start

public export
record 状态 where
    constructor MK_状态
    场景控制器 : 场景控制器
    开始画面 : 开始画面
    系统信息 : 系统信息
    你好世界 : 你好世界
    障碍 : 障碍
    主角 : 主角

export
游戏状态 状态 where

export
初始状态 : IO (Ref 状态)
初始状态 = do
    node_img <- 创建中心图片 (MK_大小 20 20) "asset/image/node.png"
    newRef $ MK_状态 { 场景控制器 = 创建场景控制器
                     , 开始画面 = 创建开始画面
                     , 系统信息 = 创建系统信息
                     , 你好世界 = 创建你好世界 $ MK_坐标 0 0
                     , 障碍 = 创建障碍 (创建矩形 (MK_大小 100 450) (MK_颜色 "#FFEEDD"))
                     , 主角 = 创建主角 node_img
                     }
