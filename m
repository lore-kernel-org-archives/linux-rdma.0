From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [for-next 2/6] net/mlx5: Decrease level of prints about non-existent MKEY
Date: Mon,  7 May 2018 16:53:00 -0700
Message-ID: <20180507235304.25085-3-saeedm@mellanox.com>
References: <20180507235304.25085-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180507235304.25085-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>, Jason Gunthorpe <jgg@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

User-controlled application can cause multiple prints as below to flood
dmesg. Since knowledge of failed MKey release is important for debug,
let's decrease its level to debug.

mlx5_core 0000:00:04.0: mlx5_core_destroy_mkey:127:(pid 2352): failed
radix tree delete of mkey 0x1ed700

Reported-by: Noa Osherovich <noaos@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/mr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
index b9736f505bdf..f4f02f775c93 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
@@ -123,8 +123,8 @@ int mlx5_core_destroy_mkey(struct mlx5_core_dev *dev,
 	deleted_mkey = radix_tree_delete(&table->tree, mlx5_base_mkey(mkey->key));
 	write_unlock_irqrestore(&table->lock, flags);
 	if (!deleted_mkey) {
-		mlx5_core_warn(dev, "failed radix tree delete of mkey 0x%x\n",
-			       mlx5_base_mkey(mkey->key));
+		mlx5_core_dbg(dev, "failed radix tree delete of mkey 0x%x\n",
+			      mlx5_base_mkey(mkey->key));
 		return -ENOENT;
 	}
 
-- 
2.14.3
