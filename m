From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V4 for-next 12/14] RDMA/bnxt_re: Fixed the max_rd_atomic support for initiator and destination QP
Date: Mon, 22 May 2017 03:15:42 -0700
Message-ID: <1495448144-18966-13-git-send-email-selvin.xavier@broadcom.com>
References: <1495448144-18966-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1495448144-18966-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

There's a couple of bugs in the support of max_rd_atomic and
max_dest_rd_atomic. In the modify_qp, if the requested max_rd_atomic,
which is the ORRQ size, is greater than what the chip can support,
then we have to cap the request to chip max as we can't have the HW
overflow the ORRQ. Capping the max_rd_atomic support internally is okay
to do as the remaining read/atomic WRs will still be sitting in the SQ.
However, for the max_dest_rd_atomic, the driver has to error out as
this dictates the IRRQ size and we can't control what the remote
side sends.

Signed-off-by: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index ced8806..67285e3 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -172,7 +172,7 @@ int bnxt_re_query_device(struct ib_device *ibdev,
 	ib_attr->max_mr = dev_attr->max_mr;
 	ib_attr->max_pd = dev_attr->max_pd;
 	ib_attr->max_qp_rd_atom = dev_attr->max_qp_rd_atom;
-	ib_attr->max_qp_init_rd_atom = dev_attr->max_qp_rd_atom;
+	ib_attr->max_qp_init_rd_atom = dev_attr->max_qp_init_rd_atom;
 	ib_attr->atomic_cap = IB_ATOMIC_HCA;
 	ib_attr->masked_atomic_cap = IB_ATOMIC_HCA;
 
@@ -1495,13 +1495,24 @@ int bnxt_re_modify_qp(struct ib_qp *ib_qp, struct ib_qp_attr *qp_attr,
 	if (qp_attr_mask & IB_QP_MAX_QP_RD_ATOMIC) {
 		qp->qplib_qp.modify_flags |=
 				CMDQ_MODIFY_QP_MODIFY_MASK_MAX_RD_ATOMIC;
-		qp->qplib_qp.max_rd_atomic = qp_attr->max_rd_atomic;
+		/* Cap the max_rd_atomic to device max */
+		qp->qplib_qp.max_rd_atomic = min_t(u32, qp_attr->max_rd_atomic,
+						   dev_attr->max_qp_rd_atom);
 	}
 	if (qp_attr_mask & IB_QP_SQ_PSN) {
 		qp->qplib_qp.modify_flags |= CMDQ_MODIFY_QP_MODIFY_MASK_SQ_PSN;
 		qp->qplib_qp.sq.psn = qp_attr->sq_psn;
 	}
 	if (qp_attr_mask & IB_QP_MAX_DEST_RD_ATOMIC) {
+		if (qp_attr->max_dest_rd_atomic >
+		    dev_attr->max_qp_init_rd_atom) {
+			dev_err(rdev_to_dev(rdev),
+				"max_dest_rd_atomic requested%d is > dev_max%d",
+				qp_attr->max_dest_rd_atomic,
+				dev_attr->max_qp_init_rd_atom);
+			return -EINVAL;
+		}
+
 		qp->qplib_qp.modify_flags |=
 				CMDQ_MODIFY_QP_MODIFY_MASK_MAX_DEST_RD_ATOMIC;
 		qp->qplib_qp.max_dest_rd_atomic = qp_attr->max_dest_rd_atomic;
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
