From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/3] net/mlx4_core: Remove more annoying debug messages from the SRIOV flow
Date: Sun, 21 Oct 2012 16:59:22 +0200
Message-ID: <1350831564-25251-2-git-send-email-ogerlitz@mellanox.com>
References: <1350831564-25251-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350831564-25251-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

These debug prints left behind by commits c82e9aa0a8 "mlx4_core: resource
tracking for HCA resources used by guests", 54679e1482 "mlx4: Implement QP
paravirtualization and maintain phys_pkey_cache for smp_snoop" and 993c401e20
"mlx4_core: Add IB port-state machine and port mgmt event propagation" make it
pretty hard to actually use the mlx4_core debug messages when running in SRIOV/IB
mode -- for example, the module load sequence of a device with one VF yielded
631 debug prints, with 408 of them being from this set.  Let's just remove them.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/eq.c            |    6 ------
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |    6 ------
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/eq.c b/drivers/net/ethernet/mellanox/mlx4/eq.c
index 51c7649..194221b 100644
--- a/drivers/net/ethernet/mellanox/mlx4/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/eq.c
@@ -329,9 +329,6 @@ int set_and_calc_slave_port_state(struct mlx4_dev *dev, int slave,
 	ctx = &priv->mfunc.master.slave_state[slave];
 	spin_lock_irqsave(&ctx->lock, flags);
 
-	mlx4_dbg(dev, "%s: slave: %d, current state: %d new event :%d\n",
-		 __func__, slave, cur_state, event);
-
 	switch (cur_state) {
 	case SLAVE_PORT_DOWN:
 		if (MLX4_PORT_STATE_DEV_EVENT_PORT_UP == event)
@@ -366,9 +363,6 @@ int set_and_calc_slave_port_state(struct mlx4_dev *dev, int slave,
 			goto out;
 	}
 	ret = mlx4_get_slave_port_state(dev, slave, port);
-	mlx4_dbg(dev, "%s: slave: %d, current state: %d new event"
-		 " :%d gen_event: %d\n",
-		 __func__, slave, cur_state, event, *gen_event);
 
 out:
 	spin_unlock_irqrestore(&ctx->lock, flags);
diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
index 926c911..b05705f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
+++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
@@ -330,9 +330,6 @@ static void update_pkey_index(struct mlx4_dev *dev, int slave,
 
 	new_index = priv->virt2phys_pkey[slave][port - 1][orig_index];
 	*(u8 *)(inbox->buf + 35) = new_index;
-
-	mlx4_dbg(dev, "port = %d, orig pkey index = %d, "
-		 "new pkey index = %d\n", port, orig_index, new_index);
 }
 
 static void update_gid(struct mlx4_dev *dev, struct mlx4_cmd_mailbox *inbox,
@@ -351,9 +348,6 @@ static void update_gid(struct mlx4_dev *dev, struct mlx4_cmd_mailbox *inbox,
 		if (optpar & MLX4_QP_OPTPAR_ALT_ADDR_PATH)
 			qp_ctx->alt_path.mgid_index = slave & 0x7F;
 	}
-
-	mlx4_dbg(dev, "slave %d, new gid index: 0x%x ",
-		slave, qp_ctx->pri_path.mgid_index);
 }
 
 static int mpt_mask(struct mlx4_dev *dev)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
