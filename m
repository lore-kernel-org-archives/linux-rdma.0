From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [rdma-core 1/3] libbnxt_re: Fix lat test failure in event mode
Date: Wed, 31 Jan 2018 09:51:49 -0500
Message-ID: <1517410311-23623-2-git-send-email-devesh.sharma@broadcom.com>
References: <1517410311-23623-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517410311-23623-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The application assumes that, when CQ is armed, it gives interrupt
for the new CQEs generated and not for the existing CQEs. This is
in-line with the IB-Spec. However, Broadcom HW generates an interrupt
for any unread CQEs not just new ones. This results in a scenario
where the application is expecting a completion for a SEND operation
but it receives a completion for a prior incoming-send/RQE that was
not yet consumed as per the HW thereby leading to failure.
Workaround this by deferring the ARM-ing of the CQ when invoked in
the notify_cq hook to 'poll_cq' so that the CQ is armed after all
completions are consumed.

Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 providers/bnxt_re/main.h  |  3 +++
 providers/bnxt_re/verbs.c | 13 ++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/providers/bnxt_re/main.h b/providers/bnxt_re/main.h
index affe24f..08aa277 100644
--- a/providers/bnxt_re/main.h
+++ b/providers/bnxt_re/main.h
@@ -76,6 +76,9 @@ struct bnxt_re_cq {
 	struct list_head rfhead;
 	uint32_t cqe_size;
 	uint8_t  phase;
+	int deferred_arm_flags;
+	bool first_arm;
+	bool deferred_arm;
 };
 
 struct bnxt_re_srq {
diff --git a/providers/bnxt_re/verbs.c b/providers/bnxt_re/verbs.c
index 09ac333..2e88304 100644
--- a/providers/bnxt_re/verbs.c
+++ b/providers/bnxt_re/verbs.c
@@ -202,6 +202,7 @@ struct ibv_cq *bnxt_re_create_cq(struct ibv_context *ibvctx, int ncqe,
 	cq->phase = resp.phase;
 	cq->cqq.tail = resp.tail;
 	cq->udpi = &cntx->udpi;
+	cq->first_arm = true;
 
 	list_head_init(&cq->sfhead);
 	list_head_init(&cq->rfhead);
@@ -654,6 +655,11 @@ int bnxt_re_poll_cq(struct ibv_cq *ibvcq, int nwc, struct ibv_wc *wc)
 
 	pthread_spin_lock(&cq->cqq.qlock);
 	dqed = bnxt_re_poll_one(cq, nwc, wc);
+	if (cq->deferred_arm) {
+		bnxt_re_ring_cq_arm_db(cq, cq->deferred_arm_flags);
+		cq->deferred_arm = false;
+		cq->deferred_arm_flags = 0;
+	}
 	pthread_spin_unlock(&cq->cqq.qlock);
 	/* Check if anything is there to flush. */
 	pthread_spin_lock(&cntx->fqlock);
@@ -718,7 +724,12 @@ int bnxt_re_arm_cq(struct ibv_cq *ibvcq, int flags)
 	pthread_spin_lock(&cq->cqq.qlock);
 	flags = !flags ? BNXT_RE_QUE_TYPE_CQ_ARMALL :
 			 BNXT_RE_QUE_TYPE_CQ_ARMSE;
-	bnxt_re_ring_cq_arm_db(cq, flags);
+	if (cq->first_arm) {
+		bnxt_re_ring_cq_arm_db(cq, flags);
+		cq->first_arm = false;
+	}
+	cq->deferred_arm = true;
+	cq->deferred_arm_flags = flags;
 	pthread_spin_unlock(&cq->cqq.qlock);
 
 	return 0;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
