From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH v2] rdma/core: Don't dereference device->get_link_layer directly
Date: Wed, 20 Sep 2017 14:54:43 +0300
Message-ID: <1505908483-29641-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We have rdma_port_get_link_layer that checks the callout
is actually implemented.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
Changes from v1:
- fixed typo

 drivers/infiniband/core/verbs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index ee9e27dc799b..de57d6c11a25 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1646,7 +1646,7 @@ static bool is_valid_mcast_lid(struct ib_qp *qp, u16 lid)
 	 */
 	if (!ib_query_qp(qp, &attr, IB_QP_STATE | IB_QP_PORT, &init_attr)) {
 		if (attr.qp_state >= IB_QPS_INIT) {
-			if (qp->device->get_link_layer(qp->device, attr.port_num) !=
+			if (rdma_port_get_link_layer(qp->device, attr.port_num) !=
 			    IB_LINK_LAYER_INFINIBAND)
 				return true;
 			goto lid_check;
@@ -1655,7 +1655,7 @@ static bool is_valid_mcast_lid(struct ib_qp *qp, u16 lid)
 
 	/* Can't get a quick answer, iterate over all ports */
 	for (port = 0; port < qp->device->phys_port_cnt; port++)
-		if (qp->device->get_link_layer(qp->device, port) !=
+		if (rdma_port_get_link_layer(qp->device, port) !=
 		    IB_LINK_LAYER_INFINIBAND)
 			num_eth_ports++;
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
