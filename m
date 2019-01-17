From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net/mlx4: remove unneeded semicolon
Date: Thu, 17 Jan 2019 21:03:56 +0800
Message-ID: <20190117130356.13652-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: davem@davemloft.net, tariqt@mellanox.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-rdma@vger.kernel.org

Remove unneeded semicolon.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx4/cmd.c | 2 +-
 drivers/net/ethernet/mellanox/mlx4/eq.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
index e65bc3c..c19e74e 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -3274,7 +3274,7 @@ int mlx4_set_vf_link_state(struct mlx4_dev *dev, int port, int vf, int link_stat
 		mlx4_warn(dev, "unknown value for link_state %02x on slave %d port %d\n",
 			  link_state, slave, port);
 		return -EINVAL;
-	};
+	}
 	s_info = &priv->mfunc.master.vf_admin[slave].vport[port];
 	s_info->link_state = link_state;
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/eq.c b/drivers/net/ethernet/mellanox/mlx4/eq.c
index 2df92db..4953c85 100644
--- a/drivers/net/ethernet/mellanox/mlx4/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/eq.c
@@ -820,7 +820,7 @@ static int mlx4_eq_int(struct mlx4_dev *dev, struct mlx4_eq *eq)
 				  !!(eqe->owner & 0x80) ^
 				  !!(eq->cons_index & eq->nent) ? "HW" : "SW");
 			break;
-		};
+		}
 
 		++eq->cons_index;
 		eqes_found = 1;
-- 
2.7.0
