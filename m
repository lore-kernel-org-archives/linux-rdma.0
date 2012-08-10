From: Kleber Sacilotto de Souza <klebers-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH] IB/mlx4: check iboe netdev pointer before dereferencing it
Date: Fri, 10 Aug 2012 15:25:34 -0300
Message-ID: <1344623134-22600-1-git-send-email-klebers@linux.vnet.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, cascardo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Kleber Sacilotto de Souza <klebers-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Unlike other parts of the mlx4_ib code, the function build_mlx_header()
doesn't check if the iboe netdev of the given port is valid before
derefering it, which can cause a crash if the ethernet interface has
already been taken down.

This patch fixes the problem by checking for a valid netdev pointer
before using it to get the port MAC address.

Signed-off-by: Kleber Sacilotto de Souza <klebers-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index a6d8ea0..f585edd 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1407,6 +1407,7 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 	struct mlx4_wqe_mlx_seg *mlx = wqe;
 	struct mlx4_wqe_inline_seg *inl = wqe + sizeof *mlx;
 	struct mlx4_ib_ah *ah = to_mah(wr->wr.ud.ah);
+	struct net_device *ndev;
 	union ib_gid sgid;
 	u16 pkey;
 	int send_size;
@@ -1483,7 +1484,10 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 
 		memcpy(sqp->ud_header.eth.dmac_h, ah->av.eth.mac, 6);
 		/* FIXME: cache smac value? */
-		smac = to_mdev(sqp->qp.ibqp.device)->iboe.netdevs[sqp->qp.port - 1]->dev_addr;
+		ndev = to_mdev(sqp->qp.ibqp.device)->iboe.netdevs[sqp->qp.port - 1];
+		if (!ndev)
+			return -ENODEV;
+		smac = ndev->dev_addr;
 		memcpy(sqp->ud_header.eth.smac_h, smac, 6);
 		if (!memcmp(sqp->ud_header.eth.smac_h, sqp->ud_header.eth.dmac_h, 6))
 			mlx->flags |= cpu_to_be32(MLX4_WQE_CTRL_FORCE_LOOPBACK);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
