From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/4] RDMA/bnxt_re: Set QP state in case of response completion errors
Date: Mon,  6 Nov 2017 08:07:30 -0800
Message-ID: <1509984452-18336-3-git-send-email-selvin.xavier@broadcom.com>
References: <1509984452-18336-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509984452-18336-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Moves the driver QP state to error in case of response completion
errors. Handles the scenarios which doesn't generate a terminal CQE.

Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index 31ea9f4..805a612 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -2118,6 +2118,7 @@ static int bnxt_qplib_cq_process_res_rc(struct bnxt_qplib_cq *cq,
 	*pcqe = cqe;
 
 	if (hwcqe->status != CQ_RES_RC_STATUS_OK) {
+		qp->state = CMDQ_MODIFY_QP_NEW_STATE_ERR;
 		 /* Add qp to flush list of the CQ */
 		bnxt_qplib_lock_buddy_cq(qp, cq);
 		__bnxt_qplib_add_flush_qp(qp);
@@ -2181,6 +2182,7 @@ static int bnxt_qplib_cq_process_res_ud(struct bnxt_qplib_cq *cq,
 	*pcqe = cqe;
 
 	if (hwcqe->status != CQ_RES_RC_STATUS_OK) {
+		qp->state = CMDQ_MODIFY_QP_NEW_STATE_ERR;
 		/* Add qp to flush list of the CQ */
 		bnxt_qplib_lock_buddy_cq(qp, cq);
 		__bnxt_qplib_add_flush_qp(qp);
@@ -2268,6 +2270,7 @@ static int bnxt_qplib_cq_process_res_raweth_qp1(struct bnxt_qplib_cq *cq,
 	*pcqe = cqe;
 
 	if (hwcqe->status != CQ_RES_RC_STATUS_OK) {
+		qp->state = CMDQ_MODIFY_QP_NEW_STATE_ERR;
 		/* Add qp to flush list of the CQ */
 		bnxt_qplib_lock_buddy_cq(qp, cq);
 		__bnxt_qplib_add_flush_qp(qp);
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
