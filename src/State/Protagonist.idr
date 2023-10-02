module State.Protagonist

import Hby.Game
import Hby.Game.Canvas.Draw
import Hby.Game.Base.Area
import State.NodeSet
import Hby.Game.Base.Position
import Hby.Game.Canvas.Draw.CenterImage

export
record 主角 where
    constructor MK_主角
    图片 : 中心图片
    节点集 : 节点集

export
创建主角 : 中心图片 -> 主角
创建主角 node_img = MK_主角 node_img $ 创建节点集 (MK_坐标 250 300) node_img -- 下身
                                        [ 创建子节点集 (MK_坐标 250 200) node_img 100 (-90-10, -90+10) -- 上身
                                            [ 创建子节点集 (MK_坐标 130 300) node_img 60 (120, 225) [ 创建子节点集 (MK_坐标 85 350) node_img 60 (90, 270) [] ] -- 左手
                                            , 创建子节点集 (MK_坐标 350 300) node_img 60 (-45, 60) [ 创建子节点集 (MK_坐标 400 350) node_img 60 (-90, 90) [] ] -- 右手
                                            , 创建子节点集 (MK_坐标 250 170) node_img 30 (-90-10, -90+10) [] -- 头
                                            ]
                                        , 创建子节点集 (MK_坐标 180 510) node_img 70 (100, 180) [ 创建子节点集 (MK_坐标 130 620) node_img 70 (90, 180) [] ] -- 左腿
                                        , 创建子节点集 (MK_坐标 300 510) node_img 70 (0, 80) [ 创建子节点集 (MK_坐标 340 620) node_img 70 (0, 90) [] ] -- 右腿
                                        ]

export
初始化主角 : 主角 -> 主角
初始化主角 a = 创建主角 a.图片

export
主角处理事件 : (障碍区域 : List 区域) -> 事件 -> 主角 -> 主角
主角处理事件 b e a = {节点集 := 节点集处理事件 b e a.节点集} a

export
判定主角在区域中 : 区域 -> 主角 -> Bool
判定主角在区域中 area a = 判定节点集在区域中 area a.节点集

export
可以被显示 主角 where
    转换到实体集 a = 节点集转实体集 a.节点集
