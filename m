From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/2] IB/uverbs: Make use of ib_modify_qp variant to avoid resolving DMAC
Date: Tue, 23 May 2017 11:26:09 +0300
Message-ID: <20170523082609.12603-2-leon@kernel.org>
References: <20170523082609.12603-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170523082609.12603-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch makes use of IB core's ib_modify_qp_with_udata function that
also resolves the DMAC and handles udata.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 70b7fb156414..cdd96f953c48 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1996,23 +1996,10 @@ static int modify_qp(struct ib_uverbs_file *file,
 	rdma_ah_set_port_num(&attr->alt_ah_attr,
 			     cmd->base.alt_dest.port_num);
 
-	if (qp->real_qp == qp) {
-		if (cmd->base.attr_mask & IB_QP_AV) {
-			ret = ib_resolve_eth_dmac(qp->device, &attr->ah_attr);
-			if (ret)
-				goto release_qp;
-		}
-		ret = qp->device->modify_qp(qp, attr,
-					    modify_qp_mask(qp->qp_type,
-							   cmd->base.attr_mask),
-					    udata);
-	} else {
-		ret = ib_modify_qp(qp, attr,
-				   modify_qp_mask(qp->qp_type,
-						  cmd->base.attr_mask));
-	}
-
-release_qp:
+	ret = ib_modify_qp_with_udata(qp, attr,
+				      modify_qp_mask(qp->qp_type,
+						     cmd->base.attr_mask),
+				      udata);
 	uobj_put_obj_read(qp);
 
 out:
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
