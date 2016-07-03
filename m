From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH for-next 2/3] IB/core: Fix ib_resolve_eth_dmac for Raw Packet QP
Date: Sun,  3 Jul 2016 15:42:06 +0300
Message-ID: <1467549727-23479-3-git-send-email-leon@kernel.org>
References: <1467549727-23479-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467549727-23479-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

For Raw Packet QP, the AV attribute is passed in INIT to RTR in order
to set the Ethernet Priority using the SL. The rest of the fields
aren't necessarily valid, which causes the ib_resolve_eth_dmac to fail.

Since no release address resolution is needed, don't do anything in
ib_resolve_eth_dmac for Raw Packet QP.

Fixes: dbf727de7440 ('IB/core: Use GID table in AH creation and ...')
Signed-off-by: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index ba75780..d41e403 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1171,7 +1171,7 @@ int ib_resolve_eth_dmac(struct ib_qp *qp,
 {
 	int           ret = 0;
 
-	if (*qp_attr_mask & IB_QP_AV) {
+	if ((*qp_attr_mask & IB_QP_AV) && (qp->qp_type != IB_QPT_RAW_PACKET)) {
 		if (qp_attr->ah_attr.port_num < rdma_start_port(qp->device) ||
 		    qp_attr->ah_attr.port_num > rdma_end_port(qp->device))
 			return -EINVAL;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
