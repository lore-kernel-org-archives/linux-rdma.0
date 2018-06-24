From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 05/12] net/mlx5: Rate limit errors in command interface
Date: Sun, 24 Jun 2018 11:23:46 +0300
Message-ID: <20180624082353.16138-6-leon@kernel.org>
References: <20180624082353.16138-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180624082353.16138-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Hadar Hen Zion <hadarh@mellanox.com>, Matan Barak <matanb@mellanox.com>, Michael J Ruhl <michael.j.ruhl@intel.com>, Noa Osherovich <noaos@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Any error status returned by FW will trigger similar
to the following error message in the dmesg.

[   55.884355] mlx5_core 0000:00:04.0: mlx5_cmd_check:712:(pid 555):
ALLOC_UAR(0x802) op_mod(0x0) failed, status limits exceeded(0x8),
syndrome (0x0)

Those prints are extremely valuable to diagnose issues with running
system and it is important to keep them. However, not-so-careful user
can trigger endless number of such prints by depleting HW resources
and will spam dmesg.

Rate limiting of such messages solves this issue.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c       | 11 ++++-------
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h |  6 ++++++
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 9d03a202abb1..7dd878b00196 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -717,13 +717,10 @@ static int mlx5_cmd_check(struct mlx5_core_dev *dev, void *in, void *out)
 	uid    = MLX5_GET(mbox_in, in, uid);
 
 	if (!uid && opcode != MLX5_CMD_OP_DESTROY_MKEY)
-		mlx5_core_err(dev,
-		      "%s(0x%x) op_mod(0x%x) failed, status %s(0x%x), syndrome (0x%x)\n",
-		      mlx5_command_str(opcode),
-		      opcode, op_mod,
-		      cmd_status_str(status),
-		      status,
-		      syndrome);
+		mlx5_core_err_rl(dev,
+			"%s(0x%x) op_mod(0x%x) failed, status %s(0x%x), syndrome (0x%x)\n",
+			mlx5_command_str(opcode), opcode, op_mod,
+			cmd_status_str(status), status, syndrome);
 	else
 		mlx5_core_dbg(dev,
 		      "%s(0x%x) op_mod(0x%x) failed, status %s(0x%x), syndrome (0x%x)\n",
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 023882d9a22e..49955117ae36 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -66,6 +66,12 @@ do {									\
 		__func__, __LINE__, current->pid,	\
 	       ##__VA_ARGS__)
 
+#define mlx5_core_err_rl(__dev, format, ...)				\
+	dev_err_ratelimited(&(__dev)->pdev->dev,			\
+			   "%s:%d:(pid %d): " format,			\
+			   __func__, __LINE__, current->pid,		\
+			   ##__VA_ARGS__)
+
 #define mlx5_core_warn(__dev, format, ...)				\
 	dev_warn(&(__dev)->pdev->dev, "%s:%d:(pid %d): " format,	\
 		 __func__, __LINE__, current->pid,			\
-- 
2.14.4
