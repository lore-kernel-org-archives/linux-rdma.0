From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next V2 22/22] IB/mlx4: Create pv contexts for active VFs when PF (master) ib driver initializes
Date: Fri,  3 Aug 2012 11:40:58 +0300
Message-ID: <1343983258-6268-23-git-send-email-jackm@dev.mellanox.co.il>
References: <1343983258-6268-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343983258-6268-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When have VFs and PFs on same host, the VFs are activated within the
mlx4_core module before the mlx4_ib kernel module is loaded.

When the mlx4_ib module initializes the PF (master), it now creates
mad paravirtualization contexts for any VFs already active.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c  |    3 +++
 drivers/infiniband/hw/mlx4/main.c |   11 +++++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 31b0559..090a2ad 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -1648,6 +1648,9 @@ static int create_pv_resources(struct ib_device *ibdev, int slave, int port,
 {
 	int ret, cq_size;
 
+	if (ctx->state != DEMUX_PV_STATE_DOWN)
+		return -EEXIST;
+
 	ctx->state = DEMUX_PV_STATE_STARTING;
 	/* have QP0 only on port owner, and only if link layer is IB */
 	if (ctx->slave == mlx4_master_func_num(to_mdev(ctx->ib_dev)->dev) &&
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 00384b3..82b7231 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -74,6 +74,8 @@ struct update_gid_work {
 	int			port;
 };
 
+static void do_slave_init(struct mlx4_ib_dev *ibdev, int slave, int do_init);
+
 static struct workqueue_struct *wq;
 
 static void init_query_mad(struct ib_smp *mad)
@@ -1469,6 +1471,15 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	if (mlx4_is_mfunc(ibdev->dev))
 		init_pkeys(ibdev);
 
+	/* create paravirt contexts for any VFs which are active */
+	if (mlx4_is_master(ibdev->dev)) {
+		for (j = 0; j < MLX4_MFUNC_MAX; j++) {
+			if (j == mlx4_master_func_num(ibdev->dev))
+				continue;
+			if (mlx4_is_slave_active(ibdev->dev, j))
+				do_slave_init(ibdev, j, 1);
+		}
+	}
 	return ibdev;
 
 err_notif:
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
