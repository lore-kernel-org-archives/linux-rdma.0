From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 4/4] IB/core: Limit DMAC resolution to RoCE Connected QPs
Date: Tue,  9 Jan 2018 15:24:53 +0200
Message-ID: <20180109132453.29038-5-leon@kernel.org>
References: <20180109132453.29038-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180109132453.29038-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Resolving DMAC for RoCE is applicable to only Connected mode QPs.
So resolve DMAC for only for Connected mode QPs.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 019f1d87db46..8a3ef182c72a 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1350,6 +1350,14 @@ static int _ib_modify_qp(struct ib_qp *qp, struct ib_qp_attr *attr,
 	return ret;
 }
 
+static bool is_qp_type_connected(const struct ib_qp *qp)
+{
+	return (qp->qp_type == IB_QPT_UC ||
+		qp->qp_type == IB_QPT_RC ||
+		qp->qp_type == IB_QPT_XRC_INI ||
+		qp->qp_type == IB_QPT_XRC_TGT);
+}
+
 /**
  * ib_modify_qp_with_udata - Modifies the attributes for the specified QP.
  * @ib_qp: The QP to modify.
@@ -1368,7 +1376,8 @@ int ib_modify_qp_with_udata(struct ib_qp *ib_qp, struct ib_qp_attr *attr,
 	int ret;
 
 	if (attr_mask & IB_QP_AV &&
-	    attr->ah_attr.type == RDMA_AH_ATTR_TYPE_ROCE) {
+	    attr->ah_attr.type == RDMA_AH_ATTR_TYPE_ROCE &&
+	    is_qp_type_connected(qp)) {
 		ret = ib_resolve_eth_dmac(qp->device, &attr->ah_attr);
 		if (ret)
 			return ret;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
