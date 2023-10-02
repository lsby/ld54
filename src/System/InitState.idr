module System.InitState

import Data.String
import Hby.Game
import Hby.Game.Base.Size
import Hby.Game.Base.Position
import Hby.Lib.Ref
import State.Hello
import State.SysInfo
import State.Node
import State.NodeSet
import State.Barrier
import Hby.Game.Canvas.Draw.CenterImage
import Hby.Game.Canvas.Draw.Rect
import Hby.Game.Base.Color

public export
record 状态 where
    constructor MK_状态
    系统信息 : 系统信息
    你好世界 : 你好世界
    障碍 : 障碍
    主角 : 节点集

export
游戏状态 状态 where

export
初始状态 : IO (Ref 状态)
初始状态 = do
    node_img <- 创建中心图片 (MK_大小 20 20) "asset/image/node.png"
    newRef $ MK_状态 { 系统信息 = 创建系统信息
                     , 你好世界 = 创建你好世界 $ MK_坐标 0 0
                     , 障碍 = 创建障碍 (创建矩形 (MK_大小 100 450) (MK_颜色 "#FFEEDD"))
                     , 主角 = 创建节点集 (MK_坐标 250 300) node_img -- 下身
                                    [ 创建子节点集 (MK_坐标 250 200) node_img 100 (-90-10, -90+10) -- 上身
                                      [ 创建子节点集 (MK_坐标 130 300) node_img 60 (120, 225) [ 创建子节点集 (MK_坐标 85 350) node_img 60 (90, 270) [] ] -- 左手
                                      , 创建子节点集 (MK_坐标 350 300) node_img 60 (-45, 60) [ 创建子节点集 (MK_坐标 400 350) node_img 60 (-90, 90) [] ] -- 右手
                                      , 创建子节点集 (MK_坐标 250 170) node_img 30 (-90-10, -90+10) [] -- 头
                                      ]
                                    , 创建子节点集 (MK_坐标 180 510) node_img 70 (100, 180) [ 创建子节点集 (MK_坐标 130 620) node_img 70 (90, 180) [] ] -- 左腿
                                    , 创建子节点集 (MK_坐标 300 510) node_img 70 (0, 80) [ 创建子节点集 (MK_坐标 340 620) node_img 70 (0, 90) [] ] -- 右腿
                                    ]
                     }
