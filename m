From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V4 for-next 06/14] RDMA/bnxt_re: Add HW workaround for avoiding stall for UD QPs
Date: Mon, 22 May 2017 03:15:36 -0700
Message-ID: <1495448144-18966-7-git-send-email-selvin.xavier@broadcom.com>
References: <1495448144-18966-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1495448144-18966-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

HW stalls out after 0x800000 WQEs are posted for UD QPs.
To workaround this problem, driver will send a modify_qp cmd
to the HW at around the halfway mark(0x400000) so that FW
can accordingly modify the QP context in the HW to prevent this
stall.
This workaround needs to be done for UD, QP1 and Raw Ethertype
packets. Added a counter to keep track of WQEs posted during post_send.

Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/bnxt_re.h  |  2 ++
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 18 ++++++++++++++++++
 drivers/infiniband/hw/bnxt_re/qplib_fp.c |  3 +++
 drivers/infiniband/hw/bnxt_re/qplib_fp.h |  1 +
 4 files changed, 24 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
index fad04b2..277c2da 100644
--- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
+++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
@@ -56,6 +56,8 @@
 #define BNXT_RE_MAX_SRQC_COUNT		(64 * 1024)
 #define BNXT_RE_MAX_CQ_COUNT		(64 * 1024)
 
+#define BNXT_RE_UD_QP_HW_STALL		0x400000
+
 struct bnxt_re_work {
 	struct work_struct	work;
 	unsigned long		event;
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 42dfbf3..6ec3ab2 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2040,6 +2040,22 @@ static int bnxt_re_copy_wr_payload(struct bnxt_re_dev *rdev,
 	return payload_sz;
 }
 
+static void bnxt_ud_qp_hw_stall_workaround(struct bnxt_re_qp *qp)
+{
+	if ((qp->ib_qp.qp_type == IB_QPT_UD ||
+	     qp->ib_qp.qp_type == IB_QPT_GSI ||
+	     qp->ib_qp.qp_type == IB_QPT_RAW_ETHERTYPE) &&
+	     qp->qplib_qp.wqe_cnt == BNXT_RE_UD_QP_HW_STALL) {
+		int qp_attr_mask;
+		struct ib_qp_attr qp_attr;
+
+		qp_attr_mask = IB_QP_STATE;
+		qp_attr.qp_state = IB_QPS_RTS;
+		bnxt_re_modify_qp(&qp->ib_qp, &qp_attr, qp_attr_mask, NULL);
+		qp->qplib_qp.wqe_cnt = 0;
+	}
+}
+
 static int bnxt_re_post_send_shadow_qp(struct bnxt_re_dev *rdev,
 				       struct bnxt_re_qp *qp,
 				struct ib_send_wr *wr)
@@ -2085,6 +2101,7 @@ static int bnxt_re_post_send_shadow_qp(struct bnxt_re_dev *rdev,
 		wr = wr->next;
 	}
 	bnxt_qplib_post_send_db(&qp->qplib_qp);
+	bnxt_ud_qp_hw_stall_workaround(qp);
 	spin_unlock_irqrestore(&qp->sq_lock, flags);
 	return rc;
 }
@@ -2181,6 +2198,7 @@ int bnxt_re_post_send(struct ib_qp *ib_qp, struct ib_send_wr *wr,
 		wr = wr->next;
 	}
 	bnxt_qplib_post_send_db(&qp->qplib_qp);
+	bnxt_ud_qp_hw_stall_workaround(qp);
 	spin_unlock_irqrestore(&qp->sq_lock, flags);
 
 	return rc;
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index 66abec0..0716298 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -1298,6 +1298,9 @@ int bnxt_qplib_post_send(struct bnxt_qplib_qp *qp,
 	}
 
 	sq->hwq.prod++;
+
+	qp->wqe_cnt++;
+
 done:
 	return rc;
 }
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.h b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
index 71539ea..36b7b7d 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.h
@@ -250,6 +250,7 @@ struct bnxt_qplib_qp {
 	u8				timeout;
 	u8				retry_cnt;
 	u8				rnr_retry;
+	u64				wqe_cnt;
 	u32				min_rnr_timer;
 	u32				max_rd_atomic;
 	u32				max_dest_rd_atomic;
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
