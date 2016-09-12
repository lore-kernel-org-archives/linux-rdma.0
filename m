From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 2/7] IB/mlx4: Fix code indentation in QP1 MAD flow
Date: Mon, 12 Sep 2016 19:16:19 +0300
Message-ID: <1473696984-6161-3-git-send-email-leon@kernel.org>
References: <1473696984-6161-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473696984-6161-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

The indentation in the QP1 GRH flow in procedure build_mlx_header is
really confusing. Fix it, in preparation for a commit which touches
this code.

Fixes: 1ffeb2eb8be9 ("IB/mlx4: SR-IOV IB context objects and proxy/tunnel SQP support")
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 768085f..e398c04 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -2493,24 +2493,26 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *wr,
 		sqp->ud_header.grh.flow_label    =
 			ah->av.ib.sl_tclass_flowlabel & cpu_to_be32(0xfffff);
 		sqp->ud_header.grh.hop_limit     = ah->av.ib.hop_limit;
-		if (is_eth)
+		if (is_eth) {
 			memcpy(sqp->ud_header.grh.source_gid.raw, sgid.raw, 16);
-		else {
-		if (mlx4_is_mfunc(to_mdev(ib_dev)->dev)) {
-			/* When multi-function is enabled, the ib_core gid
-			 * indexes don't necessarily match the hw ones, so
-			 * we must use our own cache */
-			sqp->ud_header.grh.source_gid.global.subnet_prefix =
-				to_mdev(ib_dev)->sriov.demux[sqp->qp.port - 1].
-						       subnet_prefix;
-			sqp->ud_header.grh.source_gid.global.interface_id =
-				to_mdev(ib_dev)->sriov.demux[sqp->qp.port - 1].
-					       guid_cache[ah->av.ib.gid_index];
-		} else
-			ib_get_cached_gid(ib_dev,
-					  be32_to_cpu(ah->av.ib.port_pd) >> 24,
-					  ah->av.ib.gid_index,
-					  &sqp->ud_header.grh.source_gid, NULL);
+		} else {
+			if (mlx4_is_mfunc(to_mdev(ib_dev)->dev)) {
+				/* When multi-function is enabled, the ib_core gid
+				 * indexes don't necessarily match the hw ones, so
+				 * we must use our own cache
+				 */
+				sqp->ud_header.grh.source_gid.global.subnet_prefix =
+					to_mdev(ib_dev)->sriov.demux[sqp->qp.port - 1].
+							       subnet_prefix;
+				sqp->ud_header.grh.source_gid.global.interface_id =
+					to_mdev(ib_dev)->sriov.demux[sqp->qp.port - 1].
+						       guid_cache[ah->av.ib.gid_index];
+			} else {
+				ib_get_cached_gid(ib_dev,
+						  be32_to_cpu(ah->av.ib.port_pd) >> 24,
+						  ah->av.ib.gid_index,
+						  &sqp->ud_header.grh.source_gid, NULL);
+			}
 		}
 		memcpy(sqp->ud_header.grh.destination_gid.raw,
 		       ah->av.ib.dgid, 16);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
