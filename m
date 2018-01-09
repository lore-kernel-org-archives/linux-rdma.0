From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 3/4] IB/core: Attempt DMAC resolution for only RoCE
Date: Tue,  9 Jan 2018 15:24:52 +0200
Message-ID: <20180109132453.29038-4-leon@kernel.org>
References: <20180109132453.29038-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180109132453.29038-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Instead of returning 0 (success) for RoCE scenarios where DMAC should
not be resolved, avoid such attempt and make code consistent with
ib_create_user_ah().

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index d8f4f1b56f94..019f1d87db46 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1302,9 +1302,6 @@ static int ib_resolve_eth_dmac(struct ib_device *device,
 	if (!rdma_is_port_valid(device, rdma_ah_get_port_num(ah_attr)))
 		return -EINVAL;
 
-	if (ah_attr->type != RDMA_AH_ATTR_TYPE_ROCE)
-		return 0;
-
 	grh = rdma_ah_retrieve_grh(ah_attr);
 
 	if (rdma_is_multicast_addr((struct in6_addr *)ah_attr->grh.dgid.raw)) {
@@ -1370,7 +1367,8 @@ int ib_modify_qp_with_udata(struct ib_qp *ib_qp, struct ib_qp_attr *attr,
 	struct ib_qp *qp = ib_qp->real_qp;
 	int ret;
 
-	if (attr_mask & IB_QP_AV) {
+	if (attr_mask & IB_QP_AV &&
+	    attr->ah_attr.type == RDMA_AH_ATTR_TYPE_ROCE) {
 		ret = ib_resolve_eth_dmac(qp->device, &attr->ah_attr);
 		if (ret)
 			return ret;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
