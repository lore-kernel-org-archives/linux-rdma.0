From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma 4/5] RDMA/qedr: destroy CQ only after HW releases it
Date: Thu, 27 Apr 2017 13:35:34 +0300
Message-ID: <1493289335-29350-5-git-send-email-Ram.Amrani@cavium.com>
References: <1493289335-29350-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493289335-29350-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Wait for all relevant CNQ interrupts before freeing the CQ.
Don't invoke completion handlers for a destroyed CQ.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/main.c  | 11 +++++--
 drivers/infiniband/hw/qedr/qedr.h  |  2 ++
 drivers/infiniband/hw/qedr/verbs.c | 64 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index e3498e9..2ce7028 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -438,14 +438,21 @@ static irqreturn_t qedr_irq_handler(int irq, void *handle)
 
 		cq->arm_flags = 0;
 
-		if (cq->ibcq.comp_handler)
+		if (!cq->destroyed && cq->ibcq.comp_handler)
 			(*cq->ibcq.comp_handler)
 				(&cq->ibcq, cq->ibcq.cq_context);
 
+		/* The CQ's CNQ notification counter is checked before
+		 * destroying the CQ in a busy-wait loop that waits for all of
+		 * the CQ's CNQ interrupts to be processed. It is increased
+		 * here, only after the completion handler, to ensure that the
+		 * the handler is not running when the CQ is destroyed.
+		 */
+		cq->cnq_notif++;
+
 		sw_comp_cons = qed_chain_get_cons_idx(&cnq->pbl);
 
 		cnq->n_comp++;
-
 	}
 
 	qed_ops->rdma_cnq_prod_update(cnq->dev->rdma_ctx, cnq->index,
diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
index bb32e47..4e4495f 100644
--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -271,6 +271,8 @@ struct qedr_cq {
 	u32 cq_cons;
 
 	struct qedr_userq q;
+	u8 destroyed;
+	u16 cnq_notif;
 };
 
 struct qedr_pd {
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index bb235ea..2028c14 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -821,6 +821,17 @@ int qedr_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
 {
 	struct qedr_cq *cq = get_qedr_cq(ibcq);
 	unsigned long sflags;
+	struct qedr_dev *dev;
+
+	dev = get_qedr_dev(ibcq->device);
+
+	if (cq->destroyed) {
+		DP_ERR(dev,
+		       "warning: arm was invoked after destroy for cq %p (icid=%d)\n",
+		       cq, cq->icid);
+		return -EINVAL;
+	}
+
 
 	if (cq->cq_type == QEDR_CQ_TYPE_GSI)
 		return 0;
@@ -986,16 +997,22 @@ int qedr_resize_cq(struct ib_cq *ibcq, int new_cnt, struct ib_udata *udata)
 	return 0;
 }
 
+#define QEDR_DESTROY_CQ_MAX_ITERATIONS		(10)
+#define QEDR_DESTROY_CQ_ITER_DURATION		(10)
+
 int qedr_destroy_cq(struct ib_cq *ibcq)
 {
 	struct qedr_dev *dev = get_qedr_dev(ibcq->device);
 	struct qed_rdma_destroy_cq_out_params oparams;
 	struct qed_rdma_destroy_cq_in_params iparams;
 	struct qedr_cq *cq = get_qedr_cq(ibcq);
+	int iter;
 	int rc;
 
 	DP_DEBUG(dev, QEDR_MSG_CQ, "destroy cq %p (icid=%d)\n", cq, cq->icid);
 
+	cq->destroyed = 1;
+
 	/* GSIs CQs are handled by driver, so they don't exist in the FW */
 	if (cq->cq_type == QEDR_CQ_TYPE_GSI)
 		goto done;
@@ -1012,10 +1029,50 @@ int qedr_destroy_cq(struct ib_cq *ibcq)
 		ib_umem_release(cq->q.umem);
 	}
 
+	/* We don't want the IRQ handler to handle a non-existing CQ so we
+	 * wait until all CNQ interrupts, if any, are received. This will always
+	 * happen and will always happen very fast. If not, then a serious error
+	 * has occured. That is why we can use a long delay.
+	 * We spin for a short time so we don’t lose time on context switching
+	 * in case all the completions are handled in that span. Otherwise
+	 * we sleep for a while and check again. Since the CNQ may be
+	 * associated with (only) the current CPU we use msleep to allow the
+	 * current CPU to be freed.
+	 * The CNQ notification is increased in qedr_irq_handler().
+	 */
+	iter = QEDR_DESTROY_CQ_MAX_ITERATIONS;
+	while (oparams.num_cq_notif != READ_ONCE(cq->cnq_notif) && iter) {
+		udelay(QEDR_DESTROY_CQ_ITER_DURATION);
+		iter--;
+	}
+
+	iter = QEDR_DESTROY_CQ_MAX_ITERATIONS;
+	while (oparams.num_cq_notif != READ_ONCE(cq->cnq_notif) && iter) {
+		msleep(QEDR_DESTROY_CQ_ITER_DURATION);
+		iter--;
+	}
+
+	if (oparams.num_cq_notif != cq->cnq_notif)
+		goto err;
+
+	/* Note that we don't need to have explicit code to wait for the
+	 * completion of the event handler because it is invoked from the EQ.
+	 * Since the destroy CQ ramrod has also been received on the EQ we can
+	 * be certain that there's no event handler in process.
+	 */
 done:
+	cq->sig = ~cq->sig;
+
 	kfree(cq);
 
 	return 0;
+
+err:
+	DP_ERR(dev,
+	       "CQ %p (icid=%d) not freed, expecting %d ints but got %d ints\n",
+	       cq, cq->icid, oparams.num_cq_notif, cq->cnq_notif);
+
+	return -EINVAL;
 }
 
 static inline int get_gid_info_from_table(struct ib_qp *ibqp,
@@ -3418,6 +3475,13 @@ int qedr_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 	int update = 0;
 	int done = 0;
 
+	if (cq->destroyed) {
+		DP_ERR(dev,
+		       "warning: poll was invoked after destroy for cq %p (icid=%d)\n",
+		       cq, cq->icid);
+		return 0;
+	}
+
 	if (cq->cq_type == QEDR_CQ_TYPE_GSI)
 		return qedr_gsi_poll_cq(ibcq, num_entries, wc);
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
