From: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/8] bnxt_re: Fix update of qplib_qp.mtu when modified
Date: Thu, 31 Aug 2017 09:27:28 +0530
Message-ID: <20170831035735.19595-2-somnath.kotur@broadcom.com>
References: <20170831035735.19595-1-somnath.kotur@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170831035735.19595-1-somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

The MTU value in the qplib_qp.mtu should be
consistent with whatever mtu was set during
INIT to RTR.The Next PSN and number of packets
are calculated based on this member in the qplib_qp structure.

Signed-off-by: Narender Reddy <narender.reddy-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 43b3dee..6631d6e 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1438,11 +1438,14 @@ int bnxt_re_modify_qp(struct ib_qp *ib_qp, struct ib_qp_attr *qp_attr,
 		qp->qplib_qp.modify_flags |=
 				CMDQ_MODIFY_QP_MODIFY_MASK_PATH_MTU;
 		qp->qplib_qp.path_mtu = __from_ib_mtu(qp_attr->path_mtu);
+		qp->qplib_qp.mtu = ib_mtu_enum_to_int(qp_attr->path_mtu);
 	} else if (qp_attr->qp_state == IB_QPS_RTR) {
 		qp->qplib_qp.modify_flags |=
 			CMDQ_MODIFY_QP_MODIFY_MASK_PATH_MTU;
 		qp->qplib_qp.path_mtu =
 			__from_ib_mtu(iboe_get_mtu(rdev->netdev->mtu));
+		qp->qplib_qp.mtu =
+			ib_mtu_enum_to_int(iboe_get_mtu(rdev->netdev->mtu));
 	}
 
 	if (qp_attr_mask & IB_QP_TIMEOUT) {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
