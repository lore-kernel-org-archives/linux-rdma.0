From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH v2] net/mlx5: Fix use-after-free
Date: Thu, 22 Mar 2018 13:44:56 -0500
Message-ID: <20180322184456.GA22259@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Yuval Shaia <yuval.shaia@oracle.com>, Ilan Tayari <ilant@mellanox.com>, Boris Pismenny <borisp@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leon@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-rdma@vger.kernel.org

_rule_ is being freed and then dereferenced by accessing rule->ctx

Fix this by copying the value returned by PTR_ERR(rule->ctx) into a local
variable for its safe use after freeing _rule_

Addresses-Coverity-ID: 1466041 ("Read from pointer after free")
Fixes: 05564d0ae075 ("net/mlx5: Add flow-steering commands for FPGA IPSec implementation")
Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
Changes in v2:
 - Use a short subject prefix as suggested by Yuval Shaia.
 - Add Yuval's Reviewed-by.

 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
index 4f15685..0f5da49 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
@@ -1061,8 +1061,9 @@ static int fpga_ipsec_fs_create_fte(struct mlx5_core_dev *dev,
 
 	rule->ctx = mlx5_fpga_ipsec_fs_create_sa_ctx(dev, fte, is_egress);
 	if (IS_ERR(rule->ctx)) {
+		int err = PTR_ERR(rule->ctx);
 		kfree(rule);
-		return PTR_ERR(rule->ctx);
+		return err;
 	}
 
 	rule->fte = fte;
-- 
2.7.4
