From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/mlx4: Allow to always block UD multicast loopback
Date: Mon, 21 Apr 2014 13:09:57 -0500 (CDT)
Message-ID: <alpine.DEB.2.10.1404211308140.29240@gentwo.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We need this option for many hosts to avoid backflow of multicast
packages. Could we get that merged?



>From 18ceae090b02b3055382e11c305dcb334d938122 Mon Sep 17 00:00:00 2001
From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Tue, 4 Mar 2014 17:20:00 +0200
Subject: [PATCH] IB/mlx4: Allow to always block UD multicast loopback

Currently, there's no way for user-space applications to specify
the IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK QP creation flags defined
by commit 47ee1b9 "IB/core: Add support for multicast loopback blocking".

As a result, applications who send and recieve on the same QP over
the same multicast group get all their packets bouncded back to them,
which is bad..

Add a module param to the mlx4_ib driver which allows to force all QP
attachements to be carried out with multicast loopback prevented.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index e81c554..fa01a9e 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -68,6 +68,10 @@ int mlx4_ib_sm_guid_assign = 1;
 module_param_named(sm_guid_assign, mlx4_ib_sm_guid_assign, int, 0444);
 MODULE_PARM_DESC(sm_guid_assign, "Enable SM alias_GUID assignment if sm_guid_assign > 0 (Default: 1)");

+int mlx4_block_loopback = 0;
+module_param_named(block_loopback, mlx4_block_loopback, int, 0644);
+MODULE_PARM_DESC(block_loopback, "Always block UD multicast loopback packets if > 0");
+
 static const char mlx4_ib_version[] =
 	DRV_NAME ": Mellanox ConnectX InfiniBand driver v"
 	DRV_VERSION " (" DRV_RELDATE ")\n";
@@ -1163,6 +1167,8 @@ static int mlx4_ib_mcg_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	struct mlx4_ib_steering *ib_steering = NULL;
 	enum mlx4_protocol prot = (gid->raw[1] == 0x0e) ?
 		MLX4_PROT_IB_IPV4 : MLX4_PROT_IB_IPV6;
+	int block_mcast_loopback = (!!(mqp->flags & MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK)) |
+				   mlx4_block_loopback;

 	if (mdev->dev->caps.steering_mode ==
 	    MLX4_STEERING_MODE_DEVICE_MANAGED) {
@@ -1172,8 +1178,7 @@ static int mlx4_ib_mcg_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	}

 	err = mlx4_multicast_attach(mdev->dev, &mqp->mqp, gid->raw, mqp->port,
-				    !!(mqp->flags &
-				       MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK),
+				    block_mcast_loopback,
 				    prot, &reg_id);
 	if (err)
 		goto err_malloc;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
