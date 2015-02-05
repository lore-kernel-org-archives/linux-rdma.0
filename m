From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 2/2] infiniband: Fix duplicate KERN_* level
Date: Fri,  6 Feb 2015 00:32:59 +0100
Message-ID: <1423179179-16847-2-git-send-email-linux@rasmusvillemoes.dk>
References: <1423179179-16847-1-git-send-email-linux@rasmusvillemoes.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1423179179-16847-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Eli Cohen <eli@mellanox.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The pr_* macros already supply the relevant KERN_* level; any extra
just ends up as garbage in the output.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/infiniband/hw/mlx4/main.c | 3 +--
 drivers/infiniband/hw/mlx5/qp.c   | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 9117b7a2d5f8..e1f0503e4889 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1494,8 +1494,7 @@ static void reset_gids_task(struct work_struct *work)
 			       MLX4_CMD_TIME_CLASS_B,
 			       MLX4_CMD_WRAPPED);
 		if (err)
-			pr_warn(KERN_WARNING
-				"set port %d command failed\n", gw->port);
+			pr_warn("set port %d command failed\n", gw->port);
 	}
 
 	mlx4_free_cmd_mailbox(dev, mailbox);
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index be0cd358b080..e5b4253828b6 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1394,7 +1394,7 @@ static int mlx5_set_path(struct mlx5_ib_dev *dev, const struct ib_ah_attr *ah,
 
 	if (ah->ah_flags & IB_AH_GRH) {
 		if (ah->grh.sgid_index >= gen->port[port - 1].gid_table_len) {
-			pr_err(KERN_ERR "sgid_index (%u) too large. max is %d\n",
+			pr_err("sgid_index (%u) too large. max is %d\n",
 			       ah->grh.sgid_index, gen->port[port - 1].gid_table_len);
 			return -EINVAL;
 		}
-- 
2.1.3
