From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/7] IB/qib: Remove qib_lookup_qpn and use rvt_lookup_qpn
 instead
Date: Wed, 03 Feb 2016 14:20:19 -0800
Message-ID: <20160203222015.4030.34728.stgit@scvm10.sc.intel.com>
References: <20160203221808.4030.95183.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203221808.4030.95183.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add calls to rcu_read_lock()/rcu_read_unlock() as rvt_lookup_qpn callers
must hold the rcu_read_lock before calling and keep the lock until the
returned qp is no longer in use.

Remove lookaside qp and some qp refcount atomics in the sdma send code
that is redundant with the s_dma_busy refcount, which will also stall
the state processing to the reset state.

Change the qpn hash function to hash_32 which is hash function used
in rvt_lookup_qpn. qpn_hash function would be eliminated in later patches.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib.h        |    3 --
 drivers/infiniband/hw/qib/qib_driver.c |   25 ++++++-------------
 drivers/infiniband/hw/qib/qib_qp.c     |   42 ++------------------------------
 drivers/infiniband/hw/qib/qib_ruc.c    |   11 ++++++--
 drivers/infiniband/hw/qib/qib_ud.c     |   11 +++++---
 drivers/infiniband/hw/qib/qib_verbs.c  |   27 ++++++---------------
 drivers/infiniband/hw/qib/qib_verbs.h  |    2 --
 7 files changed, 34 insertions(+), 87 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index ccadece..751c9d7 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -230,9 +230,6 @@ struct qib_ctxtdata {
 	u8 redirect_seq_cnt;
 	/* ctxt rcvhdrq head offset */
 	u32 head;
-	/* lookaside fields */
-	struct rvt_qp *lookaside_qp;
-	u32 lookaside_qpn;
 	/* QPs waiting for context processing */
 	struct list_head qp_wait_list;
 #ifdef CONFIG_DEBUG_FS
diff --git a/drivers/infiniband/hw/qib/qib_driver.c b/drivers/infiniband/hw/qib/qib_driver.c
index a11de8e..707d789 100644
--- a/drivers/infiniband/hw/qib/qib_driver.c
+++ b/drivers/infiniband/hw/qib/qib_driver.c
@@ -322,6 +322,8 @@ static u32 qib_rcv_hdrerr(struct qib_ctxtdata *rcd, struct qib_pportdata *ppd,
 		struct qib_ib_header *hdr = (struct qib_ib_header *) rhdr;
 		struct qib_other_headers *ohdr = NULL;
 		struct qib_ibport *ibp = &ppd->ibport_data;
+		struct qib_devdata *dd = ppd->dd;
+		struct rvt_dev_info *rdi = &dd->verbs_dev.rdi;
 		struct rvt_qp *qp = NULL;
 		u32 tlen = qib_hdrget_length_in_bytes(rhf_addr);
 		u16 lid  = be16_to_cpu(hdr->lrh[1]);
@@ -366,9 +368,12 @@ static u32 qib_rcv_hdrerr(struct qib_ctxtdata *rcd, struct qib_pportdata *ppd,
 		if (qp_num != QIB_MULTICAST_QPN) {
 			int ruc_res;
 
-			qp = qib_lookup_qpn(ibp, qp_num);
-			if (!qp)
+			rcu_read_lock();
+			qp = rvt_lookup_qpn(rdi, &ibp->rvp, qp_num);
+			if (!qp) {
+				rcu_read_unlock();
 				goto drop;
+			}
 
 			/*
 			 * Handle only RC QPs - for other QP types drop error
@@ -435,12 +440,7 @@ static u32 qib_rcv_hdrerr(struct qib_ctxtdata *rcd, struct qib_pportdata *ppd,
 
 unlock:
 			spin_unlock(&qp->r_lock);
-			/*
-			 * Notify qib_destroy_qp() if it is waiting
-			 * for us to finish.
-			 */
-			if (atomic_dec_and_test(&qp->refcount))
-				wake_up(&qp->wait);
+			rcu_read_unlock();
 		} /* Unicast QP */
 	} /* Valid packet with TIDErr */
 
@@ -565,15 +565,6 @@ move_along:
 			updegr = 0;
 		}
 	}
-	/*
-	 * Notify qib_destroy_qp() if it is waiting
-	 * for lookaside_qp to finish.
-	 */
-	if (rcd->lookaside_qp) {
-		if (atomic_dec_and_test(&rcd->lookaside_qp->refcount))
-			wake_up(&rcd->lookaside_qp->wait);
-		rcd->lookaside_qp = NULL;
-	}
 
 	rcd->head = l;
 
diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index ce9002f..8508e69 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -34,7 +34,6 @@
 
 #include <linux/err.h>
 #include <linux/vmalloc.h>
-#include <linux/jhash.h>
 #include <rdma/rdma_vt.h>
 #ifdef CONFIG_DEBUG_FS
 #include <linux/seq_file.h>
@@ -221,8 +220,7 @@ static void free_qpn(struct rvt_qpn_table *qpt, u32 qpn)
 
 static inline unsigned qpn_hash(struct qib_ibdev *dev, u32 qpn)
 {
-	return jhash_1word(qpn, dev->qp_rnd) &
-		(dev->rdi.qp_dev->qp_table_size - 1);
+	return hash_32(qpn, dev->rdi.qp_dev->qp_table_bits);
 }
 
 
@@ -293,7 +291,8 @@ static void remove_qp(struct qib_ibdev *dev, struct rvt_qp *qp)
 	spin_unlock_irqrestore(&dev->rdi.qp_dev->qpt_lock, flags);
 	if (removed) {
 		synchronize_rcu();
-		atomic_dec(&qp->refcount);
+		if (atomic_dec_and_test(&qp->refcount))
+			wake_up(&qp->wait);
 	}
 }
 
@@ -320,41 +319,6 @@ unsigned qib_free_all_qps(struct rvt_dev_info *rdi)
 	return qp_inuse;
 }
 
-/**
- * qib_lookup_qpn - return the QP with the given QPN
- * @qpt: the QP table
- * @qpn: the QP number to look up
- *
- * The caller is responsible for decrementing the QP reference count
- * when done.
- */
-struct rvt_qp *qib_lookup_qpn(struct qib_ibport *ibp, u32 qpn)
-{
-	struct rvt_qp *qp = NULL;
-
-	rcu_read_lock();
-	if (unlikely(qpn <= 1)) {
-		if (qpn == 0)
-			qp = rcu_dereference(ibp->rvp.qp[0]);
-		else
-			qp = rcu_dereference(ibp->rvp.qp[1]);
-		if (qp)
-			atomic_inc(&qp->refcount);
-	} else {
-		struct qib_ibdev *dev = &ppd_from_ibp(ibp)->dd->verbs_dev;
-		unsigned n = qpn_hash(dev, qpn);
-
-		for (qp = rcu_dereference(dev->rdi.qp_dev->qp_table[n]); qp;
-			qp = rcu_dereference(qp->next))
-			if (qp->ibqp.qp_num == qpn) {
-				atomic_inc(&qp->refcount);
-				break;
-			}
-	}
-	rcu_read_unlock();
-	return qp;
-}
-
 void notify_qp_reset(struct rvt_qp *qp)
 {
 	struct qib_qp_priv *priv = qp->priv;
diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index 4961a54..e1d1a15 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -358,6 +358,9 @@ err:
 static void qib_ruc_loopback(struct rvt_qp *sqp)
 {
 	struct qib_ibport *ibp = to_iport(sqp->ibqp.device, sqp->port_num);
+	struct qib_pportdata *ppd = ppd_from_ibp(ibp);
+	struct qib_devdata *dd = ppd->dd;
+	struct rvt_dev_info *rdi = &dd->verbs_dev.rdi;
 	struct rvt_qp *qp;
 	struct rvt_swqe *wqe;
 	struct rvt_sge *sge;
@@ -369,11 +372,14 @@ static void qib_ruc_loopback(struct rvt_qp *sqp)
 	int release;
 	int ret;
 
+	rcu_read_lock();
 	/*
 	 * Note that we check the responder QP state after
 	 * checking the requester's state.
 	 */
-	qp = qib_lookup_qpn(ibp, sqp->remote_qpn);
+	qp = rvt_lookup_qpn(rdi, &ibp->rvp, sqp->remote_qpn);
+	if (!qp)
+		goto done;
 
 	spin_lock_irqsave(&sqp->s_lock, flags);
 
@@ -639,8 +645,7 @@ clr_busy:
 unlock:
 	spin_unlock_irqrestore(&sqp->s_lock, flags);
 done:
-	if (qp && atomic_dec_and_test(&qp->refcount))
-		wake_up(&qp->wait);
+	rcu_read_unlock();
 }
 
 /**
diff --git a/drivers/infiniband/hw/qib/qib_ud.c b/drivers/infiniband/hw/qib/qib_ud.c
index f0ea002..98bccb5 100644
--- a/drivers/infiniband/hw/qib/qib_ud.c
+++ b/drivers/infiniband/hw/qib/qib_ud.c
@@ -50,7 +50,9 @@
 static void qib_ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 {
 	struct qib_ibport *ibp = to_iport(sqp->ibqp.device, sqp->port_num);
-	struct qib_pportdata *ppd;
+	struct qib_pportdata *ppd = ppd_from_ibp(ibp);
+	struct qib_devdata *dd = ppd->dd;
+	struct rvt_dev_info *rdi = &dd->verbs_dev.rdi;
 	struct rvt_qp *qp;
 	struct ib_ah_attr *ah_attr;
 	unsigned long flags;
@@ -60,9 +62,11 @@ static void qib_ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 	u32 length;
 	enum ib_qp_type sqptype, dqptype;
 
-	qp = qib_lookup_qpn(ibp, swqe->ud_wr.remote_qpn);
+	rcu_read_lock();
+	qp = rvt_lookup_qpn(rdi, &ibp->rvp, swqe->ud_wr.remote_qpn);
 	if (!qp) {
 		ibp->rvp.n_pkt_drops++;
+		rcu_read_unlock();
 		return;
 	}
 
@@ -223,8 +227,7 @@ static void qib_ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 bail_unlock:
 	spin_unlock_irqrestore(&qp->r_lock, flags);
 drop:
-	if (atomic_dec_and_test(&qp->refcount))
-		wake_up(&qp->wait);
+	rcu_read_unlock();
 }
 
 /**
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 0116f58..c9cc3ae 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -367,6 +367,8 @@ void qib_ib_rcv(struct qib_ctxtdata *rcd, void *rhdr, void *data, u32 tlen)
 	struct qib_pportdata *ppd = rcd->ppd;
 	struct qib_ibport *ibp = &ppd->ibport_data;
 	struct qib_ib_header *hdr = rhdr;
+	struct qib_devdata *dd = ppd->dd;
+	struct rvt_dev_info *rdi = &dd->verbs_dev.rdi;
 	struct qib_other_headers *ohdr;
 	struct rvt_qp *qp;
 	u32 qp_num;
@@ -429,25 +431,15 @@ void qib_ib_rcv(struct qib_ctxtdata *rcd, void *rhdr, void *data, u32 tlen)
 		if (atomic_dec_return(&mcast->refcount) <= 1)
 			wake_up(&mcast->wait);
 	} else {
-		if (rcd->lookaside_qp) {
-			if (rcd->lookaside_qpn != qp_num) {
-				if (atomic_dec_and_test(
-					&rcd->lookaside_qp->refcount))
-					wake_up(
-					 &rcd->lookaside_qp->wait);
-				rcd->lookaside_qp = NULL;
-			}
+		rcu_read_lock();
+		qp = rvt_lookup_qpn(rdi, &ibp->rvp, qp_num);
+		if (!qp) {
+			rcu_read_unlock();
+			goto drop;
 		}
-		if (!rcd->lookaside_qp) {
-			qp = qib_lookup_qpn(ibp, qp_num);
-			if (!qp)
-				goto drop;
-			rcd->lookaside_qp = qp;
-			rcd->lookaside_qpn = qp_num;
-		} else
-			qp = rcd->lookaside_qp;
 		this_cpu_inc(ibp->pmastats->n_unicast_rcv);
 		qib_qp_rcv(rcd, hdr, lnh == QIB_LRH_GRH, data, tlen, qp);
+		rcu_read_unlock();
 	}
 	return;
 
@@ -747,8 +739,6 @@ void qib_put_txreq(struct qib_verbs_txreq *tx)
 	qp = tx->qp;
 	dev = to_idev(qp->ibqp.device);
 
-	if (atomic_dec_and_test(&qp->refcount))
-		wake_up(&qp->wait);
 	if (tx->mr) {
 		rvt_put_mr(tx->mr);
 		tx->mr = NULL;
@@ -929,7 +919,6 @@ static int qib_verbs_send_dma(struct rvt_qp *qp, struct qib_ib_header *hdr,
 	control = dd->f_setpbc_control(ppd, plen, qp->s_srate,
 				       be16_to_cpu(hdr->lrh[0]) >> 12);
 	tx->qp = qp;
-	atomic_inc(&qp->refcount);
 	tx->wqe = qp->s_wqe;
 	tx->mr = qp->s_rdma_mr;
 	if (qp->s_rdma_mr)
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index a7e3c71..6ad924f 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -359,8 +359,6 @@ int qib_get_counters(struct qib_pportdata *ppd,
 
 __be32 qib_compute_aeth(struct rvt_qp *qp);
 
-struct rvt_qp *qib_lookup_qpn(struct qib_ibport *ibp, u32 qpn);
-
 int qib_destroy_qp(struct ib_qp *ibqp);
 
 int qib_error_qp(struct rvt_qp *qp, enum ib_wc_status err);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
