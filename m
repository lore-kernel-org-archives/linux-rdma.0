From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V5 for-next 10/14] RDMA/bnxt_re: Fix RQE posting logic
Date: Wed, 14 Jun 2017 03:26:31 -0700
Message-ID: <1497435995-20480-11-git-send-email-selvin.xavier@broadcom.com>
References: <1497435995-20480-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1497435995-20480-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Kalesh AP <kalesh-anakkur.purayil-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

This patch adds code to ring RQ Doorbell aggressively
so that the adapter can DMA RQ buffers sooner, instead
of DMA all WQEs in the post_recv WR list together at the
end of the post_recv verb.
Also use spinlock to serialize RQ posting

Signed-off-by: Kalesh AP <kalesh-anakkur.purayil-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/bnxt_re.h  |  2 ++
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 18 +++++++++++++++++-
 drivers/infiniband/hw/bnxt_re/ib_verbs.h |  1 +
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
index 277c2da..12950ec 100644
--- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
+++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
@@ -58,6 +58,8 @@
 
 #define BNXT_RE_UD_QP_HW_STALL		0x400000
 
+#define BNXT_RE_RQ_WQE_THRESHOLD	32
+
 struct bnxt_re_work {
 	struct work_struct	work;
 	unsigned long		event;
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 2ad2876..5118cf3 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1218,6 +1218,7 @@ struct ib_qp *bnxt_re_create_qp(struct ib_pd *ib_pd,
 
 	qp->ib_qp.qp_num = qp->qplib_qp.id;
 	spin_lock_init(&qp->sq_lock);
+	spin_lock_init(&qp->rq_lock);
 
 	if (udata) {
 		struct bnxt_re_qp_resp resp;
@@ -2250,7 +2251,10 @@ int bnxt_re_post_recv(struct ib_qp *ib_qp, struct ib_recv_wr *wr,
 	struct bnxt_re_qp *qp = container_of(ib_qp, struct bnxt_re_qp, ib_qp);
 	struct bnxt_qplib_swqe wqe;
 	int rc = 0, payload_sz = 0;
+	unsigned long flags;
+	u32 count = 0;
 
+	spin_lock_irqsave(&qp->rq_lock, flags);
 	while (wr) {
 		/* House keeping */
 		memset(&wqe, 0, sizeof(wqe));
@@ -2279,9 +2283,21 @@ int bnxt_re_post_recv(struct ib_qp *ib_qp, struct ib_recv_wr *wr,
 			*bad_wr = wr;
 			break;
 		}
+
+		/* Ring DB if the RQEs posted reaches a threshold value */
+		if (++count >= BNXT_RE_RQ_WQE_THRESHOLD) {
+			bnxt_qplib_post_recv_db(&qp->qplib_qp);
+			count = 0;
+		}
+
 		wr = wr->next;
 	}
-	bnxt_qplib_post_recv_db(&qp->qplib_qp);
+
+	if (count)
+		bnxt_qplib_post_recv_db(&qp->qplib_qp);
+
+	spin_unlock_irqrestore(&qp->rq_lock, flags);
+
 	return rc;
 }
 
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.h b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
index 279eceb..1456ccd 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.h
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
@@ -73,6 +73,7 @@ struct bnxt_re_qp {
 	struct bnxt_re_dev	*rdev;
 	struct ib_qp		ib_qp;
 	spinlock_t		sq_lock;	/* protect sq */
+	spinlock_t		rq_lock;	/* protect rq */
 	struct bnxt_qplib_qp	qplib_qp;
 	struct ib_umem		*sumem;
 	struct ib_umem		*rumem;
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
