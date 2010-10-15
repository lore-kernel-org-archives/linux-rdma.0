From: Stephen Hemminger <shemminger-ZtmgI6mnKB3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cxgb3/cxgb4: remove dead code from infiniband drivers
Date: Fri, 15 Oct 2010 13:51:20 -0700
Message-ID: <20101015135120.60885db0@nehalam>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This removes unused code from the cxgb3 and cxgb4 infiniband drivers.
Found by running 'make namespacecheck'; compile tested only

Signed-off-by: Stephen Hemminger <shemminger-ZtmgI6mnKB3QT0dZR+AlfA@public.gmane.org>

--- a/drivers/infiniband/hw/cxgb3/cxio_hal.c	2010-10-15 13:40:49.431914857 -0700
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c	2010-10-15 13:42:44.247141385 -0700
@@ -188,6 +188,7 @@ int cxio_create_cq(struct cxio_rdev *rde
 	return (rdev_p->t3cdev_p->ctl(rdev_p->t3cdev_p, RDMA_CQ_SETUP, &setup));
 }
 
+#ifdef notyet
 int cxio_resize_cq(struct cxio_rdev *rdev_p, struct t3_cq *cq)
 {
 	struct rdma_cq_setup setup;
@@ -199,6 +200,7 @@ int cxio_resize_cq(struct cxio_rdev *rde
 	setup.ovfl_mode = 1;
 	return (rdev_p->t3cdev_p->ctl(rdev_p->t3cdev_p, RDMA_CQ_SETUP, &setup));
 }
+#endif
 
 static u32 get_qpid(struct cxio_rdev *rdev_p, struct cxio_ucontext *uctx)
 {
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.h	2010-10-15 13:43:44.328841007 -0700
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.h	2010-10-15 13:43:48.972972700 -0700
@@ -335,8 +335,6 @@ int iwch_post_terminate(struct iwch_qp *
 int iwch_post_zb_read(struct iwch_qp *qhp);
 int iwch_register_device(struct iwch_dev *dev);
 void iwch_unregister_device(struct iwch_dev *dev);
-int iwch_quiesce_qps(struct iwch_cq *chp);
-int iwch_resume_qps(struct iwch_cq *chp);
 void stop_read_rep_timer(struct iwch_qp *qhp);
 int iwch_register_mem(struct iwch_dev *rhp, struct iwch_pd *php,
 		      struct iwch_mr *mhp, int shift);
--- a/drivers/infiniband/hw/cxgb3/iwch_qp.c	2010-10-15 13:40:54.864066869 -0700
+++ b/drivers/infiniband/hw/cxgb3/iwch_qp.c	2010-10-15 13:44:36.302317363 -0700
@@ -1138,59 +1138,3 @@ out:
 	PDBG("%s exit state %d\n", __func__, qhp->attr.state);
 	return ret;
 }
-
-static int quiesce_qp(struct iwch_qp *qhp)
-{
-	spin_lock_irq(&qhp->lock);
-	iwch_quiesce_tid(qhp->ep);
-	qhp->flags |= QP_QUIESCED;
-	spin_unlock_irq(&qhp->lock);
-	return 0;
-}
-
-static int resume_qp(struct iwch_qp *qhp)
-{
-	spin_lock_irq(&qhp->lock);
-	iwch_resume_tid(qhp->ep);
-	qhp->flags &= ~QP_QUIESCED;
-	spin_unlock_irq(&qhp->lock);
-	return 0;
-}
-
-int iwch_quiesce_qps(struct iwch_cq *chp)
-{
-	int i;
-	struct iwch_qp *qhp;
-
-	for (i=0; i < T3_MAX_NUM_QP; i++) {
-		qhp = get_qhp(chp->rhp, i);
-		if (!qhp)
-			continue;
-		if ((qhp->attr.rcq == chp->cq.cqid) && !qp_quiesced(qhp)) {
-			quiesce_qp(qhp);
-			continue;
-		}
-		if ((qhp->attr.scq == chp->cq.cqid) && !qp_quiesced(qhp))
-			quiesce_qp(qhp);
-	}
-	return 0;
-}
-
-int iwch_resume_qps(struct iwch_cq *chp)
-{
-	int i;
-	struct iwch_qp *qhp;
-
-	for (i=0; i < T3_MAX_NUM_QP; i++) {
-		qhp = get_qhp(chp->rhp, i);
-		if (!qhp)
-			continue;
-		if ((qhp->attr.rcq == chp->cq.cqid) && qp_quiesced(qhp)) {
-			resume_qp(qhp);
-			continue;
-		}
-		if ((qhp->attr.scq == chp->cq.cqid) && qp_quiesced(qhp))
-			resume_qp(qhp);
-	}
-	return 0;
-}
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h	2010-10-15 13:43:55.221149947 -0700
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h	2010-10-15 13:44:00.981313424 -0700
@@ -730,7 +730,6 @@ int c4iw_flush_rq(struct t4_wq *wq, stru
 int c4iw_flush_sq(struct t4_wq *wq, struct t4_cq *cq, int count);
 int c4iw_ev_handler(struct c4iw_dev *rnicp, u32 qid);
 u16 c4iw_rqes_posted(struct c4iw_qp *qhp);
-int c4iw_post_zb_read(struct c4iw_qp *qhp);
 int c4iw_post_terminate(struct c4iw_qp *qhp, struct t4_cqe *err_cqe);
 u32 c4iw_get_cqid(struct c4iw_rdev *rdev, struct c4iw_dev_ucontext *uctx);
 void c4iw_put_cqid(struct c4iw_rdev *rdev, u32 qid,
--- a/drivers/infiniband/hw/cxgb4/qp.c	2010-10-15 13:40:59.920208415 -0700
+++ b/drivers/infiniband/hw/cxgb4/qp.c	2010-10-15 13:44:24.481981101 -0700
@@ -842,36 +842,6 @@ static inline void build_term_codes(stru
 	}
 }
 
-int c4iw_post_zb_read(struct c4iw_qp *qhp)
-{
-	union t4_wr *wqe;
-	struct sk_buff *skb;
-	u8 len16;
-
-	PDBG("%s enter\n", __func__);
-	skb = alloc_skb(40, GFP_KERNEL);
-	if (!skb) {
-		printk(KERN_ERR "%s cannot send zb_read!!\n", __func__);
-		return -ENOMEM;
-	}
-	set_wr_txq(skb, CPL_PRIORITY_DATA, qhp->ep->txq_idx);
-
-	wqe = (union t4_wr *)skb_put(skb, sizeof wqe->read);
-	memset(wqe, 0, sizeof wqe->read);
-	wqe->read.r2 = cpu_to_be64(0);
-	wqe->read.stag_sink = cpu_to_be32(1);
-	wqe->read.to_sink_hi = cpu_to_be32(0);
-	wqe->read.to_sink_lo = cpu_to_be32(1);
-	wqe->read.stag_src = cpu_to_be32(1);
-	wqe->read.plen = cpu_to_be32(0);
-	wqe->read.to_src_hi = cpu_to_be32(0);
-	wqe->read.to_src_lo = cpu_to_be32(1);
-	len16 = DIV_ROUND_UP(sizeof wqe->read, 16);
-	init_wr_hdr(wqe, 0, FW_RI_RDMA_READ_WR, FW_RI_COMPLETION_FLAG, len16);
-
-	return c4iw_ofld_send(&qhp->rhp->rdev, skb);
-}
-
 static void post_terminate(struct c4iw_qp *qhp, struct t4_cqe *err_cqe,
 			   gfp_t gfp)
 {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
