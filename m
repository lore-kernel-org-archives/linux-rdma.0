From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 4/7] IB/mlx4: put priority bits in WQE of IBoE MLX QP
Date: Sun, 29 Apr 2012 17:04:24 +0300
Message-ID: <1335708267-30284-5-git-send-email-ogerlitz@mellanox.com>
References: <1335708267-30284-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335708267-30284-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

Otherwise CM packets going over MLX QP1 get fixed scheduling priority 0.
We want CM packets to get the same scheduling priority, and therefore map
to the same SQ (Schedule Queue) and eventually TC (Traffic Class), as the
application requested for the actual QP used for the connection.

Signed-off-by: Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c |    6 +++---
 include/linux/mlx4/qp.h         |    3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 4649d83..5e37090 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1444,6 +1444,9 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 
 	if (is_eth) {
 		u8 *smac;
+		u16 pcp = (be32_to_cpu(ah->av.ib.sl_tclass_flowlabel) >> 29) << 13;
+
+		mlx->sched_prio = cpu_to_be16(pcp);
 
 		memcpy(sqp->ud_header.eth.dmac_h, ah->av.eth.mac, 6);
 		/* FIXME: cache smac value? */
@@ -1454,10 +1457,7 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 		if (!is_vlan) {
 			sqp->ud_header.eth.type = cpu_to_be16(MLX4_IB_IBOE_ETHERTYPE);
 		} else {
-			u16 pcp;
-
 			sqp->ud_header.vlan.type = cpu_to_be16(MLX4_IB_IBOE_ETHERTYPE);
-			pcp = (be32_to_cpu(ah->av.ib.sl_tclass_flowlabel) >> 29) << 13;
 			sqp->ud_header.vlan.tag = cpu_to_be16(vlan | pcp);
 		}
 	} else {
diff --git a/include/linux/mlx4/qp.h b/include/linux/mlx4/qp.h
index 091f9e7..bb57d5c 100644
--- a/include/linux/mlx4/qp.h
+++ b/include/linux/mlx4/qp.h
@@ -233,7 +233,8 @@ struct mlx4_wqe_mlx_seg {
 	u8			owner;
 	u8			reserved1[2];
 	u8			opcode;
-	u8			reserved2[3];
+	__be16			sched_prio;
+	u8			reserved2;
 	u8			size;
 	/*
 	 * [17]    VL15
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
