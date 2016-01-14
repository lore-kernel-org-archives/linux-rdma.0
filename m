From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/mlx4: Take source mac from AH instead from the port
Date: Thu, 14 Jan 2016 17:47:38 +0200
Message-ID: <1452786458-30341-1-git-send-email-monis@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In commit dbf727de7440 ("IB/core: Use GID table in AH creation and dmac
resolution") we copy source mac to mlx4_ah from the attributes of
gid at ib_ah_attr.grh.sgid_index. Now we can use it.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c | 24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 24ed03c..bb30a0f 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -32,6 +32,7 @@
  */
 
 #include <linux/log2.h>
+#include <linux/etherdevice.h>
 #include <linux/slab.h>
 #include <linux/netdevice.h>
 #include <linux/vmalloc.h>
@@ -2256,16 +2257,6 @@ static int build_sriov_qp0_header(struct mlx4_ib_sqp *sqp,
 	return 0;
 }
 
-static void mlx4_u64_to_smac(u8 *dst_mac, u64 src_mac)
-{
-	int i;
-
-	for (i = ETH_ALEN; i; i--) {
-		dst_mac[i - 1] = src_mac & 0xff;
-		src_mac >>= 8;
-	}
-}
-
 static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *wr,
 			    void *wqe, unsigned *mlx_seg_len)
 {
@@ -2387,27 +2378,16 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *wr,
 
 	if (is_eth) {
 		struct in6_addr in6;
-
 		u16 pcp = (be32_to_cpu(ah->av.ib.sl_tclass_flowlabel) >> 29) << 13;
 
 		mlx->sched_prio = cpu_to_be16(pcp);
 
+		ether_addr_copy(sqp->ud_header.eth.smac_h, ah->av.eth.s_mac);
 		memcpy(sqp->ud_header.eth.dmac_h, ah->av.eth.mac, 6);
-		/* FIXME: cache smac value? */
 		memcpy(&ctrl->srcrb_flags16[0], ah->av.eth.mac, 2);
 		memcpy(&ctrl->imm, ah->av.eth.mac + 2, 4);
 		memcpy(&in6, sgid.raw, sizeof(in6));
 
-		if (!mlx4_is_mfunc(to_mdev(ib_dev)->dev)) {
-			u64 mac = atomic64_read(&to_mdev(ib_dev)->iboe.mac[sqp->qp.port - 1]);
-			u8 smac[ETH_ALEN];
-
-			mlx4_u64_to_smac(smac, mac);
-			memcpy(sqp->ud_header.eth.smac_h, smac, ETH_ALEN);
-		} else {
-			/* use the src mac of the tunnel */
-			memcpy(sqp->ud_header.eth.smac_h, ah->av.eth.s_mac, ETH_ALEN);
-		}
 
 		if (!memcmp(sqp->ud_header.eth.smac_h, sqp->ud_header.eth.dmac_h, 6))
 			mlx->flags |= cpu_to_be32(MLX4_WQE_CTRL_FORCE_LOOPBACK);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
