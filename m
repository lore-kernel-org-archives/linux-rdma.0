From: Eli Cohen <eli@dev.mellanox.co.il>
Subject: [PATCH net-next 3/9] net/mlx5_core: Fix command queue size enforcement
Date: Tue,  2 Dec 2014 12:26:13 +0200
Message-ID: <1417515979-22418-4-git-send-email-eli@mellanox.com>
References: <1417515979-22418-1-git-send-email-eli@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1417515979-22418-1-git-send-email-eli@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: roland@kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, ogerlitz@mellanox.com, amirv@mellanox.com, Eli Cohen <eli@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Command queue descriptor page size is 4KB and not the page size used by the
kernel.

Signed-off-by: Eli Cohen <eli@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 368c6c5ea014..a2853057c779 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1363,7 +1363,7 @@ int mlx5_cmd_init(struct mlx5_core_dev *dev)
 		goto err_map;
 	}
 
-	if (cmd->log_sz + cmd->log_stride > PAGE_SHIFT) {
+	if (cmd->log_sz + cmd->log_stride > MLX5_ADAPTER_PAGE_SHIFT) {
 		dev_err(&dev->pdev->dev, "command queue size overflow\n");
 		err = -EINVAL;
 		goto err_map;
-- 
2.1.3
