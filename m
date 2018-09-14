From: Qing Huang <qing.huang@oracle.com>
Subject: [PATCH] net/mlx4_core: print firmware version during driver loading
Date: Thu, 13 Sep 2018 17:25:14 -0700
Message-ID: <20180914002514.27571-1-qing.huang@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tariqt@mellanox.com, davem@davemloft.net
List-Id: linux-rdma@vger.kernel.org

When debugging firmware related issues, it's very helpful to have
the installed FW version info in the kernel log when the driver is
loaded. It's easier to match error/warning messages with different
FW versions in the log other than running a separate tool to get
the information back and forth.

Signed-off-by: Qing Huang <qing.huang@oracle.com>
---
 drivers/net/ethernet/mellanox/mlx4/fw.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index babcfd9..e1c5218 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -1686,11 +1686,11 @@ int mlx4_QUERY_FW(struct mlx4_dev *dev)
 	MLX4_GET(lg, outbox, QUERY_FW_MAX_CMD_OFFSET);
 	cmd->max_cmds = 1 << lg;
 
-	mlx4_dbg(dev, "FW version %d.%d.%03d (cmd intf rev %d), max commands %d\n",
-		 (int) (dev->caps.fw_ver >> 32),
-		 (int) (dev->caps.fw_ver >> 16) & 0xffff,
-		 (int) dev->caps.fw_ver & 0xffff,
-		 cmd_if_rev, cmd->max_cmds);
+	mlx4_info(dev, "FW version %d.%d.%03d (cmd intf rev %d), max commands %d\n",
+		  (int)(dev->caps.fw_ver >> 32),
+		  (int)(dev->caps.fw_ver >> 16) & 0xffff,
+		  (int)dev->caps.fw_ver & 0xffff,
+		  cmd_if_rev, cmd->max_cmds);
 
 	MLX4_GET(fw->catas_offset, outbox, QUERY_FW_ERR_START_OFFSET);
 	MLX4_GET(fw->catas_size,   outbox, QUERY_FW_ERR_SIZE_OFFSET);
-- 
2.9.3
