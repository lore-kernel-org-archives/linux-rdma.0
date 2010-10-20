From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2.6.37] RDMA/cxgb3: When a user QP is marked in error,
	also mark the CQs in error.
Date: Wed, 20 Oct 2010 16:44:32 -0500
Message-ID: <20101020214432.4869.50981.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The flushing of work requests for user QPs is implemented entirely in the
user mode library.  The only kernel interaction is to mark the user QP
object indicating it is in error when the QP exits RTS.  When the user
QP operations are called by the application (eg: post_send, post_recv),
the QP in error bit is checked and if set, the library flushes the QP.
If, however, the application is not doing IO, but rather just polling the
CQ, it will never get flushed work requests.  This breaks some classes
of applications.

This patch adds logic to mark user CQs in error when a QP that is bound
to the CQ is marked in error.  The library poll code can then notice
the CQ is in error and flush all the in error QPs bound to that CQ.

Design:

- add 1 extra CQE entry to the CQ memory that will be used to indicate
in error status.

- return the desired CQ memory size that should be mapped by the library

- bump the ABI since the create_cq uverbs response changes.

- detect older libraries and reduce the mmap size accordingly.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb3/cxio_hal.c      |    1 +
 drivers/infiniband/hw/cxgb3/cxio_wr.h       |   16 ++++++++++++++++
 drivers/infiniband/hw/cxgb3/iwch_ev.c       |   17 +++++++++--------
 drivers/infiniband/hw/cxgb3/iwch_provider.c |   19 +++++++++++++++----
 drivers/infiniband/hw/cxgb3/iwch_qp.c       |   25 ++++++++++++++++++-------
 drivers/infiniband/hw/cxgb3/iwch_user.h     |    1 +
 6 files changed, 60 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c b/drivers/infiniband/hw/cxgb3/cxio_hal.c
index 005b7b5..09dda0b 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
@@ -160,6 +160,7 @@ int cxio_create_cq(struct cxio_rdev *rdev_p, struct t3_cq *cq, int kernel)
 	struct rdma_cq_setup setup;
 	int size = (1UL << (cq->size_log2)) * sizeof(struct t3_cqe);
 
+	size += 1; /* one extra page for storing cq-in-err state */
 	cq->cqid = cxio_hal_get_cqid(rdev_p->rscp);
 	if (!cq->cqid)
 		return -ENOMEM;
diff --git a/drivers/infiniband/hw/cxgb3/cxio_wr.h b/drivers/infiniband/hw/cxgb3/cxio_wr.h
index e5ddb63..4bb997a 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_wr.h
+++ b/drivers/infiniband/hw/cxgb3/cxio_wr.h
@@ -728,6 +728,22 @@ struct t3_cq {
 #define CQ_VLD_ENTRY(ptr,size_log2,cqe) (Q_GENBIT(ptr,size_log2) == \
 					 CQE_GENBIT(*cqe))
 
+struct t3_cq_status_page {
+	u32 cq_err;
+};
+
+static inline int cxio_cq_in_error(struct t3_cq *cq)
+{
+	return ((struct t3_cq_status_page *)
+		&cq->queue[1 << cq->size_log2])->cq_err;
+}
+
+static inline void cxio_set_cq_in_error(struct t3_cq *cq)
+{
+	((struct t3_cq_status_page *)
+	 &cq->queue[1 << cq->size_log2])->cq_err = 1;
+}
+
 static inline void cxio_set_wq_in_error(struct t3_wq *wq)
 {
 	wq->queue->wq_in_err.err |= 1;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_ev.c b/drivers/infiniband/hw/cxgb3/iwch_ev.c
index 6afc89e..71e0d84 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_ev.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_ev.c
@@ -76,6 +76,14 @@ static void post_qp_event(struct iwch_dev *rnicp, struct iwch_cq *chp,
 	atomic_inc(&qhp->refcnt);
 	spin_unlock(&rnicp->lock);
 
+	if (qhp->attr.state == IWCH_QP_STATE_RTS) {
+		attrs.next_state = IWCH_QP_STATE_TERMINATE;
+		iwch_modify_qp(qhp->rhp, qhp, IWCH_QP_ATTR_NEXT_STATE,
+			       &attrs, 1);
+		if (send_term)
+			iwch_post_terminate(qhp, rsp_msg);
+	}
+
 	event.event = ib_event;
 	event.device = chp->ibcq.device;
 	if (ib_event == IB_EVENT_CQ_ERR)
@@ -86,13 +94,7 @@ static void post_qp_event(struct iwch_dev *rnicp, struct iwch_cq *chp,
 	if (qhp->ibqp.event_handler)
 		(*qhp->ibqp.event_handler)(&event, qhp->ibqp.qp_context);
 
-	if (qhp->attr.state == IWCH_QP_STATE_RTS) {
-		attrs.next_state = IWCH_QP_STATE_TERMINATE;
-		iwch_modify_qp(qhp->rhp, qhp, IWCH_QP_ATTR_NEXT_STATE,
-			       &attrs, 1);
-		if (send_term)
-			iwch_post_terminate(qhp, rsp_msg);
-	}
+	(*chp->ibcq.comp_handler)(&chp->ibcq, chp->ibcq.cq_context);
 
 	if (atomic_dec_and_test(&qhp->refcnt))
 		wake_up(&qhp->wait);
@@ -179,7 +181,6 @@ void iwch_ev_dispatch(struct cxio_rdev *rdev_p, struct sk_buff *skb)
 	case TPT_ERR_BOUND:
 	case TPT_ERR_INVALIDATE_SHARED_MR:
 	case TPT_ERR_INVALIDATE_MR_WITH_MW_BOUND:
-		(*chp->ibcq.comp_handler)(&chp->ibcq, chp->ibcq.cq_context);
 		post_qp_event(rnicp, chp, rsp_msg, IB_EVENT_QP_ACCESS_ERR, 1);
 		break;
 
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index fca0b4b..a79df59 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -154,6 +154,7 @@ static struct ib_cq *iwch_create_cq(struct ib_device *ibdev, int entries, int ve
 	struct iwch_create_cq_resp uresp;
 	struct iwch_create_cq_req ureq;
 	struct iwch_ucontext *ucontext = NULL;
+	static int warned;
 
 	PDBG("%s ib_dev %p entries %d\n", __func__, ibdev, entries);
 	rhp = to_iwch_dev(ibdev);
@@ -217,15 +218,24 @@ static struct ib_cq *iwch_create_cq(struct ib_device *ibdev, int entries, int ve
 		uresp.key = ucontext->key;
 		ucontext->key += PAGE_SIZE;
 		spin_unlock(&ucontext->mmap_lock);
+		mm->key = uresp.key;
+		mm->addr = virt_to_phys(chp->cq.queue);
+		if (udata->outlen < sizeof uresp) {
+			if (!warned++)
+				printk(KERN_WARNING MOD "Warning - "
+				       "downlevel libcxgb3 (non-fatal).\n");
+			mm->len = PAGE_ALIGN((1UL << uresp.size_log2) *
+					     sizeof(struct t3_cqe));
+		} else {
+			mm->len = PAGE_ALIGN(((1UL << uresp.size_log2) + 1) *
+					     sizeof(struct t3_cqe));
+			uresp.memsize = mm->len;
+		}
 		if (ib_copy_to_udata(udata, &uresp, sizeof (uresp))) {
 			kfree(mm);
 			iwch_destroy_cq(&chp->ibcq);
 			return ERR_PTR(-EFAULT);
 		}
-		mm->key = uresp.key;
-		mm->addr = virt_to_phys(chp->cq.queue);
-		mm->len = PAGE_ALIGN((1UL << uresp.size_log2) *
-					     sizeof (struct t3_cqe));
 		insert_mmap(ucontext, mm);
 	}
 	PDBG("created cqid 0x%0x chp %p size 0x%0x, dma_addr 0x%0llx\n",
@@ -1414,6 +1424,7 @@ int iwch_register_device(struct iwch_dev *dev)
 	dev->ibdev.post_send = iwch_post_send;
 	dev->ibdev.post_recv = iwch_post_receive;
 	dev->ibdev.get_protocol_stats = iwch_get_mib;
+	dev->ibdev.uverbs_abi_ver = IWCH_UVERBS_ABI_VERSION;
 
 	dev->ibdev.iwcm = kmalloc(sizeof(struct iw_cm_verbs), GFP_KERNEL);
 	if (!dev->ibdev.iwcm)
diff --git a/drivers/infiniband/hw/cxgb3/iwch_qp.c b/drivers/infiniband/hw/cxgb3/iwch_qp.c
index c64d27b..0993137 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_qp.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_qp.c
@@ -802,14 +802,12 @@ int iwch_post_terminate(struct iwch_qp *qhp, struct respQ_msg_t *rsp_msg)
 /*
  * Assumes qhp lock is held.
  */
-static void __flush_qp(struct iwch_qp *qhp, unsigned long *flag)
+static void __flush_qp(struct iwch_qp *qhp, struct iwch_cq *rchp,
+				struct iwch_cq *schp, unsigned long *flag)
 {
-	struct iwch_cq *rchp, *schp;
 	int count;
 	int flushed;
 
-	rchp = get_chp(qhp->rhp, qhp->attr.rcq);
-	schp = get_chp(qhp->rhp, qhp->attr.scq);
 
 	PDBG("%s qhp %p rchp %p schp %p\n", __func__, qhp, rchp, schp);
 	/* take a ref on the qhp since we must release the lock */
@@ -847,10 +845,23 @@ static void __flush_qp(struct iwch_qp *qhp, unsigned long *flag)
 
 static void flush_qp(struct iwch_qp *qhp, unsigned long *flag)
 {
-	if (qhp->ibqp.uobject)
+	struct iwch_cq *rchp, *schp;
+
+	rchp = get_chp(qhp->rhp, qhp->attr.rcq);
+	schp = get_chp(qhp->rhp, qhp->attr.scq);
+
+	if (qhp->ibqp.uobject) {
 		cxio_set_wq_in_error(&qhp->wq);
-	else
-		__flush_qp(qhp, flag);
+		cxio_set_cq_in_error(&rchp->cq);
+		(*rchp->ibcq.comp_handler)(&rchp->ibcq, rchp->ibcq.cq_context);
+		if (schp != rchp) {
+			cxio_set_cq_in_error(&schp->cq);
+			(*schp->ibcq.comp_handler)(&schp->ibcq,
+						   schp->ibcq.cq_context);
+		}
+		return;
+	}
+	__flush_qp(qhp, rchp, schp, flag);
 }
 
 
diff --git a/drivers/infiniband/hw/cxgb3/iwch_user.h b/drivers/infiniband/hw/cxgb3/iwch_user.h
index cb7086f..ddf8678 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_user.h
+++ b/drivers/infiniband/hw/cxgb3/iwch_user.h
@@ -49,6 +49,7 @@ struct iwch_create_cq_resp {
 	__u64 key;
 	__u32 cqid;
 	__u32 size_log2;
+	__u32 memsize;
 };
 
 struct iwch_create_qp_resp {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
