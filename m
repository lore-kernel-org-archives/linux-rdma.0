From: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/usnic: Support more QP state transitions
Date: Wed,  9 Dec 2015 10:42:17 -0800
Message-ID: <1449686539-29959-4-git-send-email-neescoba@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

They were already implemented at a lower layer, but the upper level
routine placed arbitrary restrictions on which transitions were
permitted.  Simplify the state machine logic to live wholly in
usnic_ib_qp_grp_modify.

Signed-off-by: Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Reese Faucette <rfaucett-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Xuyang Wang <xuywang-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index 5ae6569..111afd5 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -571,20 +571,20 @@ int usnic_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 
 	qp_grp = to_uqp_grp(ibqp);
 
-	/* TODO: Future Support All States */
 	mutex_lock(&qp_grp->vf->pf->usdev_lock);
-	if ((attr_mask & IB_QP_STATE) && attr->qp_state == IB_QPS_INIT) {
-		status = usnic_ib_qp_grp_modify(qp_grp, IB_QPS_INIT, NULL);
-	} else if ((attr_mask & IB_QP_STATE) && attr->qp_state == IB_QPS_RTR) {
-		status = usnic_ib_qp_grp_modify(qp_grp, IB_QPS_RTR, NULL);
-	} else if ((attr_mask & IB_QP_STATE) && attr->qp_state == IB_QPS_RTS) {
-		status = usnic_ib_qp_grp_modify(qp_grp, IB_QPS_RTS, NULL);
+	if ((attr_mask & IB_QP_PORT) && attr->port_num != 1) {
+		/* usnic devices only have one port */
+		status = -EINVAL;
+		goto out_unlock;
+	}
+	if (attr_mask & IB_QP_STATE) {
+		status = usnic_ib_qp_grp_modify(qp_grp, attr->qp_state, NULL);
 	} else {
-		usnic_err("Unexpected combination mask: %u state: %u\n",
-				attr_mask & IB_QP_STATE, attr->qp_state);
+		usnic_err("Unhandled request, attr_mask=0x%x\n", attr_mask);
 		status = -EINVAL;
 	}
 
+out_unlock:
 	mutex_unlock(&qp_grp->vf->pf->usdev_lock);
 	return status;
 }
-- 
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
