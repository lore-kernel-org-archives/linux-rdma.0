From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 02/12] IB/qib,
 staging/rdma/hfi1: add s_hlock for use in post send
Date: Sun, 14 Feb 2016 12:10:04 -0800
Message-ID: <20160214201000.1410.41728.stgit@scvm10.sc.intel.com>
References: <20160214200613.1410.63195.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160214200613.1410.63195.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch adds an additional lock to reduce contention on the s_lock.

This lock is used in post_send() so that the post_send is not
serialized with the send engine and other send related processing.

To do this the s_next_psn is now maintained on post_send() while
post_send() related fields are moved to a new cache line.  There is
an s_avail maintained for the post_send() to mitigate trading cache
lines with the send engine.  The lock is released/acquired around
releasing the just built packet to the egress mechanism.

Reviewed-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_qp.c    |   36 ++++++++++++
 drivers/infiniband/hw/qib/qib_rc.c    |   44 +++------------
 drivers/infiniband/hw/qib/qib_ruc.c   |   11 ++--
 drivers/infiniband/hw/qib/qib_uc.c    |   22 +++----
 drivers/infiniband/hw/qib/qib_ud.c    |   22 ++++---
 drivers/infiniband/hw/qib/qib_verbs.c |   37 ++++++++++---
 drivers/infiniband/hw/qib/qib_verbs.h |    6 +-
 drivers/infiniband/sw/rdmavt/qp.c     |   97 ++++++++++++++++++++++++++-------
 drivers/staging/rdma/hfi1/qp.c        |   79 ++++++++++++++++++++++++---
 drivers/staging/rdma/hfi1/qp.h        |   37 +------------
 drivers/staging/rdma/hfi1/rc.c        |   44 +++------------
 drivers/staging/rdma/hfi1/ruc.c       |   40 +++++++-------
 drivers/staging/rdma/hfi1/uc.c        |   21 +++----
 drivers/staging/rdma/hfi1/ud.c        |   22 ++++---
 drivers/staging/rdma/hfi1/verbs.c     |    3 +
 drivers/staging/rdma/hfi1/verbs.h     |    2 -
 include/rdma/rdma_vt.h                |    4 +
 include/rdma/rdmavt_qp.h              |   13 +++-
 18 files changed, 319 insertions(+), 221 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 01d49dc..6ffa022 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -474,6 +474,42 @@ void qib_get_credit(struct rvt_qp *qp, u32 aeth)
 	}
 }
 
+/**
+ * qib_check_send_wqe - validate wr/wqe
+ * @qp - The qp
+ * @wqe - The built wqe
+ *
+ * validate wr/wqe.  This is called
+ * prior to inserting the wqe into
+ * the ring but after the wqe has been
+ * setup.
+ *
+ * Returns 0 on success, -EINVAL on failure
+ */
+int qib_check_send_wqe(struct rvt_qp *qp,
+		       struct rvt_swqe *wqe)
+{
+	struct rvt_ah *ah;
+
+	switch (qp->ibqp.qp_type) {
+	case IB_QPT_RC:
+	case IB_QPT_UC:
+		if (wqe->length > 0x80000000U)
+			return -EINVAL;
+		break;
+	case IB_QPT_SMI:
+	case IB_QPT_GSI:
+	case IB_QPT_UD:
+		ah = ibah_to_rvtah(wqe->ud_wr.ah);
+		if (wqe->length > (1 << ah->log_pmtu))
+			return -EINVAL;
+		break;
+	default:
+		break;
+	}
+	return 0;
+}
+
 #ifdef CONFIG_DEBUG_FS
 
 struct qib_qp_iter {
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index ce886b2..9088e26 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -226,6 +226,8 @@ bail:
  * qib_make_rc_req - construct a request packet (SEND, RDMA r/w, ATOMIC)
  * @qp: a pointer to the QP
  *
+ * Assumes the s_lock is held.
+ *
  * Return 1 if constructed; otherwise, return 0.
  */
 int qib_make_rc_req(struct rvt_qp *qp)
@@ -241,7 +243,6 @@ int qib_make_rc_req(struct rvt_qp *qp)
 	u32 bth2;
 	u32 pmtu = qp->pmtu;
 	char newreq;
-	unsigned long flags;
 	int ret = 0;
 	int delta;
 
@@ -249,12 +250,6 @@ int qib_make_rc_req(struct rvt_qp *qp)
 	if (qp->remote_ah_attr.ah_flags & IB_AH_GRH)
 		ohdr = &priv->s_hdr->u.l.oth;
 
-	/*
-	 * The lock is needed to synchronize between the sending tasklet,
-	 * the receive interrupt handler, and timeout resends.
-	 */
-	spin_lock_irqsave(&qp->s_lock, flags);
-
 	/* Sending responses has higher priority over sending requests. */
 	if ((qp->s_flags & RVT_S_RESP_PENDING) &&
 	    qib_make_rc_ack(dev, qp, ohdr, pmtu))
@@ -264,7 +259,8 @@ int qib_make_rc_req(struct rvt_qp *qp)
 		if (!(ib_rvt_state_ops[qp->state] & RVT_FLUSH_SEND))
 			goto bail;
 		/* We are in the error state, flush the work request. */
-		if (qp->s_last == qp->s_head)
+		smp_read_barrier_depends(); /* see post_one_send() */
+		if (qp->s_last == ACCESS_ONCE(qp->s_head))
 			goto bail;
 		/* If DMAs are in progress, we can't flush immediately. */
 		if (atomic_read(&priv->s_dma_busy)) {
@@ -321,8 +317,8 @@ int qib_make_rc_req(struct rvt_qp *qp)
 				qp->s_flags |= RVT_S_WAIT_FENCE;
 				goto bail;
 			}
-			wqe->psn = qp->s_next_psn;
 			newreq = 1;
+			qp->s_psn = wqe->psn;
 		}
 		/*
 		 * Note that we have to be careful not to modify the
@@ -341,9 +337,7 @@ int qib_make_rc_req(struct rvt_qp *qp)
 				qp->s_flags |= RVT_S_WAIT_SSN_CREDIT;
 				goto bail;
 			}
-			wqe->lpsn = wqe->psn;
 			if (len > pmtu) {
-				wqe->lpsn += (len - 1) / pmtu;
 				qp->s_state = OP(SEND_FIRST);
 				len = pmtu;
 				break;
@@ -381,9 +375,7 @@ int qib_make_rc_req(struct rvt_qp *qp)
 				cpu_to_be32(wqe->rdma_wr.rkey);
 			ohdr->u.rc.reth.length = cpu_to_be32(len);
 			hwords += sizeof(struct ib_reth) / sizeof(u32);
-			wqe->lpsn = wqe->psn;
 			if (len > pmtu) {
-				wqe->lpsn += (len - 1) / pmtu;
 				qp->s_state = OP(RDMA_WRITE_FIRST);
 				len = pmtu;
 				break;
@@ -418,13 +410,6 @@ int qib_make_rc_req(struct rvt_qp *qp)
 				qp->s_num_rd_atomic++;
 				if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT))
 					qp->s_lsn++;
-				/*
-				 * Adjust s_next_psn to count the
-				 * expected number of responses.
-				 */
-				if (len > pmtu)
-					qp->s_next_psn += (len - 1) / pmtu;
-				wqe->lpsn = qp->s_next_psn++;
 			}
 
 			ohdr->u.rc.reth.vaddr =
@@ -456,7 +441,6 @@ int qib_make_rc_req(struct rvt_qp *qp)
 				qp->s_num_rd_atomic++;
 				if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT))
 					qp->s_lsn++;
-				wqe->lpsn = wqe->psn;
 			}
 			if (wqe->atomic_wr.wr.opcode == IB_WR_ATOMIC_CMP_AND_SWP) {
 				qp->s_state = OP(COMPARE_SWAP);
@@ -499,11 +483,8 @@ int qib_make_rc_req(struct rvt_qp *qp)
 		}
 		if (wqe->wr.opcode == IB_WR_RDMA_READ)
 			qp->s_psn = wqe->lpsn + 1;
-		else {
+		else
 			qp->s_psn++;
-			if (qib_cmp24(qp->s_psn, qp->s_next_psn) > 0)
-				qp->s_next_psn = qp->s_psn;
-		}
 		break;
 
 	case OP(RDMA_READ_RESPONSE_FIRST):
@@ -523,8 +504,6 @@ int qib_make_rc_req(struct rvt_qp *qp)
 		/* FALLTHROUGH */
 	case OP(SEND_MIDDLE):
 		bth2 = qp->s_psn++ & QIB_PSN_MASK;
-		if (qib_cmp24(qp->s_psn, qp->s_next_psn) > 0)
-			qp->s_next_psn = qp->s_psn;
 		ss = &qp->s_sge;
 		len = qp->s_len;
 		if (len > pmtu) {
@@ -564,8 +543,6 @@ int qib_make_rc_req(struct rvt_qp *qp)
 		/* FALLTHROUGH */
 	case OP(RDMA_WRITE_MIDDLE):
 		bth2 = qp->s_psn++ & QIB_PSN_MASK;
-		if (qib_cmp24(qp->s_psn, qp->s_next_psn) > 0)
-			qp->s_next_psn = qp->s_psn;
 		ss = &qp->s_sge;
 		len = qp->s_len;
 		if (len > pmtu) {
@@ -630,13 +607,9 @@ int qib_make_rc_req(struct rvt_qp *qp)
 	qp->s_cur_size = len;
 	qib_make_ruc_header(qp, ohdr, bth0 | (qp->s_state << 24), bth2);
 done:
-	ret = 1;
-	goto unlock;
-
+	return 1;
 bail:
 	qp->s_flags &= ~RVT_S_BUSY;
-unlock:
-	spin_unlock_irqrestore(&qp->s_lock, flags);
 	return ret;
 }
 
@@ -1454,7 +1427,8 @@ static void qib_rc_rcv_resp(struct qib_ibport *ibp,
 		goto ack_done;
 
 	/* Ignore invalid responses. */
-	if (qib_cmp24(psn, qp->s_next_psn) >= 0)
+	smp_read_barrier_depends(); /* see post_one_send */
+	if (qib_cmp24(psn, ACCESS_ONCE(qp->s_next_psn)) >= 0)
 		goto ack_done;
 
 	/* Ignore duplicate responses. */
diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index 2623684..a5f07a6 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -391,7 +391,8 @@ static void qib_ruc_loopback(struct rvt_qp *sqp)
 	sqp->s_flags |= RVT_S_BUSY;
 
 again:
-	if (sqp->s_last == sqp->s_head)
+	smp_read_barrier_depends(); /* see post_one_send() */
+	if (sqp->s_last == ACCESS_ONCE(sqp->s_head))
 		goto clr_busy;
 	wqe = rvt_get_swqe_ptr(sqp, sqp->s_last);
 
@@ -765,22 +766,24 @@ void qib_do_send(struct rvt_qp *qp)
 
 	qp->s_flags |= RVT_S_BUSY;
 
-	spin_unlock_irqrestore(&qp->s_lock, flags);
-
 	do {
 		/* Check for a constructed packet to be sent. */
 		if (qp->s_hdrwords != 0) {
+			spin_unlock_irqrestore(&qp->s_lock, flags);
 			/*
 			 * If the packet cannot be sent now, return and
 			 * the send tasklet will be woken up later.
 			 */
 			if (qib_verbs_send(qp, priv->s_hdr, qp->s_hdrwords,
 					   qp->s_cur_sge, qp->s_cur_size))
-				break;
+				return;
 			/* Record that s_hdr is empty. */
 			qp->s_hdrwords = 0;
+			spin_lock_irqsave(&qp->s_lock, flags);
 		}
 	} while (make_req(qp));
+
+	spin_unlock_irqrestore(&qp->s_lock, flags);
 }
 
 /*
diff --git a/drivers/infiniband/hw/qib/qib_uc.c b/drivers/infiniband/hw/qib/qib_uc.c
index 1b2fc69..7bdbc79 100644
--- a/drivers/infiniband/hw/qib/qib_uc.c
+++ b/drivers/infiniband/hw/qib/qib_uc.c
@@ -41,6 +41,8 @@
  * qib_make_uc_req - construct a request packet (SEND, RDMA write)
  * @qp: a pointer to the QP
  *
+ * Assumes the s_lock is held.
+ *
  * Return 1 if constructed; otherwise, return 0.
  */
 int qib_make_uc_req(struct rvt_qp *qp)
@@ -48,20 +50,18 @@ int qib_make_uc_req(struct rvt_qp *qp)
 	struct qib_qp_priv *priv = qp->priv;
 	struct qib_other_headers *ohdr;
 	struct rvt_swqe *wqe;
-	unsigned long flags;
 	u32 hwords;
 	u32 bth0;
 	u32 len;
 	u32 pmtu = qp->pmtu;
 	int ret = 0;
 
-	spin_lock_irqsave(&qp->s_lock, flags);
-
 	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_SEND_OK)) {
 		if (!(ib_rvt_state_ops[qp->state] & RVT_FLUSH_SEND))
 			goto bail;
 		/* We are in the error state, flush the work request. */
-		if (qp->s_last == qp->s_head)
+		smp_read_barrier_depends(); /* see post_one_send() */
+		if (qp->s_last == ACCESS_ONCE(qp->s_head))
 			goto bail;
 		/* If DMAs are in progress, we can't flush immediately. */
 		if (atomic_read(&priv->s_dma_busy)) {
@@ -90,13 +90,13 @@ int qib_make_uc_req(struct rvt_qp *qp)
 		    RVT_PROCESS_NEXT_SEND_OK))
 			goto bail;
 		/* Check if send work queue is empty. */
-		if (qp->s_cur == qp->s_head)
+		smp_read_barrier_depends(); /* see post_one_send() */
+		if (qp->s_cur == ACCESS_ONCE(qp->s_head))
 			goto bail;
 		/*
 		 * Start a new request.
 		 */
-		wqe->psn = qp->s_next_psn;
-		qp->s_psn = qp->s_next_psn;
+		qp->s_psn = wqe->psn;
 		qp->s_sge.sge = wqe->sg_list[0];
 		qp->s_sge.sg_list = wqe->sg_list + 1;
 		qp->s_sge.num_sge = wqe->wr.num_sge;
@@ -215,15 +215,11 @@ int qib_make_uc_req(struct rvt_qp *qp)
 	qp->s_cur_sge = &qp->s_sge;
 	qp->s_cur_size = len;
 	qib_make_ruc_header(qp, ohdr, bth0 | (qp->s_state << 24),
-			    qp->s_next_psn++ & QIB_PSN_MASK);
+			    qp->s_psn++ & QIB_PSN_MASK);
 done:
-	ret = 1;
-	goto unlock;
-
+	return 1;
 bail:
 	qp->s_flags &= ~RVT_S_BUSY;
-unlock:
-	spin_unlock_irqrestore(&qp->s_lock, flags);
 	return ret;
 }
 
diff --git a/drivers/infiniband/hw/qib/qib_ud.c b/drivers/infiniband/hw/qib/qib_ud.c
index fe49172..d950213 100644
--- a/drivers/infiniband/hw/qib/qib_ud.c
+++ b/drivers/infiniband/hw/qib/qib_ud.c
@@ -234,6 +234,8 @@ drop:
  * qib_make_ud_req - construct a UD request packet
  * @qp: the QP
  *
+ * Assumes the s_lock is held.
+ *
  * Return 1 if constructed; otherwise, return 0.
  */
 int qib_make_ud_req(struct rvt_qp *qp)
@@ -244,7 +246,6 @@ int qib_make_ud_req(struct rvt_qp *qp)
 	struct qib_pportdata *ppd;
 	struct qib_ibport *ibp;
 	struct rvt_swqe *wqe;
-	unsigned long flags;
 	u32 nwords;
 	u32 extra_bytes;
 	u32 bth0;
@@ -253,13 +254,12 @@ int qib_make_ud_req(struct rvt_qp *qp)
 	int ret = 0;
 	int next_cur;
 
-	spin_lock_irqsave(&qp->s_lock, flags);
-
 	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_NEXT_SEND_OK)) {
 		if (!(ib_rvt_state_ops[qp->state] & RVT_FLUSH_SEND))
 			goto bail;
 		/* We are in the error state, flush the work request. */
-		if (qp->s_last == qp->s_head)
+		smp_read_barrier_depends(); /* see post_one_send */
+		if (qp->s_last == ACCESS_ONCE(qp->s_head))
 			goto bail;
 		/* If DMAs are in progress, we can't flush immediately. */
 		if (atomic_read(&priv->s_dma_busy)) {
@@ -271,7 +271,9 @@ int qib_make_ud_req(struct rvt_qp *qp)
 		goto done;
 	}
 
-	if (qp->s_cur == qp->s_head)
+	/* see post_one_send() */
+	smp_read_barrier_depends();
+	if (qp->s_cur == ACCESS_ONCE(qp->s_head))
 		goto bail;
 
 	wqe = rvt_get_swqe_ptr(qp, qp->s_cur);
@@ -292,6 +294,7 @@ int qib_make_ud_req(struct rvt_qp *qp)
 		this_cpu_inc(ibp->pmastats->n_unicast_xmit);
 		lid = ah_attr->dlid & ~((1 << ppd->lmc) - 1);
 		if (unlikely(lid == ppd->lid)) {
+			unsigned long flags;
 			/*
 			 * If DMAs are in progress, we can't generate
 			 * a completion for the loopback packet since
@@ -304,6 +307,7 @@ int qib_make_ud_req(struct rvt_qp *qp)
 				goto bail;
 			}
 			qp->s_cur = next_cur;
+			local_irq_save(flags);
 			spin_unlock_irqrestore(&qp->s_lock, flags);
 			qib_ud_loopback(qp, wqe);
 			spin_lock_irqsave(&qp->s_lock, flags);
@@ -378,7 +382,7 @@ int qib_make_ud_req(struct rvt_qp *qp)
 		ah_attr->dlid != be16_to_cpu(IB_LID_PERMISSIVE) ?
 		cpu_to_be32(QIB_MULTICAST_QPN) :
 		cpu_to_be32(wqe->ud_wr.remote_qpn);
-	ohdr->bth[2] = cpu_to_be32(qp->s_next_psn++ & QIB_PSN_MASK);
+	ohdr->bth[2] = cpu_to_be32(wqe->psn & QIB_PSN_MASK);
 	/*
 	 * Qkeys with the high order bit set mean use the
 	 * qkey from the QP context instead of the WR (see 10.2.5).
@@ -388,13 +392,9 @@ int qib_make_ud_req(struct rvt_qp *qp)
 	ohdr->u.ud.deth[1] = cpu_to_be32(qp->ibqp.qp_num);
 
 done:
-	ret = 1;
-	goto unlock;
-
+	return 1;
 bail:
 	qp->s_flags &= ~RVT_S_BUSY;
-unlock:
-	spin_unlock_irqrestore(&qp->s_lock, flags);
 	return ret;
 }
 
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index fa94f78..5cf019f 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1662,6 +1662,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	dd->verbs_dev.rdi.driver_f.get_card_name = qib_get_card_name;
 	dd->verbs_dev.rdi.driver_f.get_pci_dev = qib_get_pci_dev;
 	dd->verbs_dev.rdi.driver_f.check_ah = qib_check_ah;
+	dd->verbs_dev.rdi.driver_f.check_send_wqe = qib_check_send_wqe;
 	dd->verbs_dev.rdi.driver_f.notify_new_ah = qib_notify_new_ah;
 	dd->verbs_dev.rdi.driver_f.alloc_qpn = qib_alloc_qpn;
 	dd->verbs_dev.rdi.driver_f.qp_priv_alloc = qib_qp_priv_alloc;
@@ -1677,6 +1678,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	dd->verbs_dev.rdi.driver_f.mtu_to_path_mtu = qib_mtu_to_path_mtu;
 	dd->verbs_dev.rdi.driver_f.mtu_from_qp = qib_mtu_from_qp;
 	dd->verbs_dev.rdi.driver_f.get_pmtu_from_attr = qib_get_pmtu_from_attr;
+	dd->verbs_dev.rdi.driver_f.schedule_send_no_lock = _qib_schedule_send;
 	dd->verbs_dev.rdi.driver_f.query_port_state = qib_query_port;
 	dd->verbs_dev.rdi.driver_f.shut_down_port = qib_shut_down_port;
 	dd->verbs_dev.rdi.driver_f.cap_mask_chg = qib_cap_mask_chg;
@@ -1778,17 +1780,34 @@ void qib_unregister_ib_device(struct qib_devdata *dd)
 				  dev->pio_hdrs, dev->pio_hdrs_phys);
 }
 
-/*
- * This must be called with s_lock held.
+/**
+ * _qib_schedule_send - schedule progress
+ * @qp - the qp
+ *
+ * This schedules progress w/o regard to the s_flags.
+ *
+ * It is only used in post send, which doesn't hold
+ * the s_lock.
  */
-void qib_schedule_send(struct rvt_qp *qp)
+void _qib_schedule_send(struct rvt_qp *qp)
 {
+	struct qib_ibport *ibp =
+		to_iport(qp->ibqp.device, qp->port_num);
+	struct qib_pportdata *ppd = ppd_from_ibp(ibp);
 	struct qib_qp_priv *priv = qp->priv;
-	if (qib_send_ok(qp)) {
-		struct qib_ibport *ibp =
-			to_iport(qp->ibqp.device, qp->port_num);
-		struct qib_pportdata *ppd = ppd_from_ibp(ibp);
 
-		queue_work(ppd->qib_wq, &priv->s_work);
-	}
+	queue_work(ppd->qib_wq, &priv->s_work);
+}
+
+/**
+ * qib_schedule_send - schedule progress
+ * @qp - the qp
+ *
+ * This schedules qp progress.  The s_lock
+ * should be held.
+ */
+void qib_schedule_send(struct rvt_qp *qp)
+{
+	if (qib_send_ok(qp))
+		_qib_schedule_send(qp);
 }
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index b88e027..d137d71 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -298,9 +298,7 @@ static inline int qib_send_ok(struct rvt_qp *qp)
 		 !(qp->s_flags & RVT_S_ANY_WAIT_SEND));
 }
 
-/*
- * This must be called with s_lock held.
- */
+void _qib_schedule_send(struct rvt_qp *qp);
 void qib_schedule_send(struct rvt_qp *qp);
 
 static inline int qib_pkey_ok(u16 pkey1, u16 pkey2)
@@ -392,6 +390,8 @@ void qib_rc_rcv(struct qib_ctxtdata *rcd, struct qib_ib_header *hdr,
 
 int qib_check_ah(struct ib_device *ibdev, struct ib_ah_attr *ah_attr);
 
+int qib_check_send_wqe(struct rvt_qp *qp, struct rvt_swqe *wqe);
+
 struct ib_ah *qib_create_qp0_ah(struct qib_ibport *ibp, u16 dlid);
 
 void qib_rc_rnr_retry(unsigned long arg);
diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 7dc837c..522404a 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -401,6 +401,7 @@ void rvt_reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
 		rdi->driver_f.flush_qp_waiters(qp);
 		qp->s_flags &= ~(RVT_S_TIMER | RVT_S_ANY_WAIT);
 		spin_unlock(&qp->s_lock);
+		spin_unlock(&qp->s_hlock);
 		spin_unlock_irq(&qp->r_lock);
 
 		/* Stop the send queue and the retry timer */
@@ -415,6 +416,7 @@ void rvt_reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
 
 		/* grab the lock b/c it was locked at call time */
 		spin_lock_irq(&qp->r_lock);
+		spin_lock(&qp->s_hlock);
 		spin_lock(&qp->s_lock);
 
 		rvt_clear_mr_refs(qp, 1);
@@ -610,6 +612,7 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 		 * except for qp->ibqp.qp_num.
 		 */
 		spin_lock_init(&qp->r_lock);
+		spin_lock_init(&qp->s_hlock);
 		spin_lock_init(&qp->s_lock);
 		spin_lock_init(&qp->r_rq.lock);
 		atomic_set(&qp->refcount, 0);
@@ -620,6 +623,7 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 		qp->state = IB_QPS_RESET;
 		qp->s_wq = swq;
 		qp->s_size = init_attr->cap.max_send_wr + 1;
+		qp->s_avail = init_attr->cap.max_send_wr;
 		qp->s_max_sge = init_attr->cap.max_send_sge;
 		if (init_attr->sq_sig_type == IB_SIGNAL_REQ_WR)
 			qp->s_flags = RVT_S_SIGNAL_REQ_WR;
@@ -779,6 +783,7 @@ void rvt_clear_mr_refs(struct rvt_qp *qp, int clr_sends)
 						wqe->ud_wr.ah)->refcount);
 			if (++qp->s_last >= qp->s_size)
 				qp->s_last = 0;
+			smp_wmb(); /* see qp_set_savail */
 		}
 		if (qp->s_rdma_mr) {
 			rvt_put_mr(qp->s_rdma_mr);
@@ -833,7 +838,7 @@ int rvt_error_qp(struct rvt_qp *qp, enum ib_wc_status err)
 	rdi->driver_f.notify_error_qp(qp);
 
 	/* Schedule the sending tasklet to drain the send work queue. */
-	if (qp->s_last != qp->s_head)
+	if (ACCESS_ONCE(qp->s_last) != qp->s_head)
 		rdi->driver_f.schedule_send(qp);
 
 	rvt_clear_mr_refs(qp, 0);
@@ -979,6 +984,7 @@ int rvt_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	link = rdma_port_get_link_layer(ibqp->device, qp->port_num);
 
 	spin_lock_irq(&qp->r_lock);
+	spin_lock(&qp->s_hlock);
 	spin_lock(&qp->s_lock);
 
 	cur_state = attr_mask & IB_QP_CUR_STATE ?
@@ -1151,6 +1157,7 @@ int rvt_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	if (attr_mask & IB_QP_PATH_MTU) {
 		qp->pmtu = rdi->driver_f.mtu_from_qp(rdi, qp, pmtu);
 		qp->path_mtu = rdi->driver_f.mtu_to_path_mtu(qp->pmtu);
+		qp->log_pmtu = ilog2(qp->pmtu);
 	}
 
 	if (attr_mask & IB_QP_RETRY_CNT) {
@@ -1186,6 +1193,7 @@ int rvt_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		rdi->driver_f.modify_qp(qp, attr, attr_mask, udata);
 
 	spin_unlock(&qp->s_lock);
+	spin_unlock(&qp->s_hlock);
 	spin_unlock_irq(&qp->r_lock);
 
 	if (cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT)
@@ -1207,6 +1215,7 @@ int rvt_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 
 inval:
 	spin_unlock(&qp->s_lock);
+	spin_unlock(&qp->s_hlock);
 	spin_unlock_irq(&qp->r_lock);
 	return -EINVAL;
 }
@@ -1226,9 +1235,11 @@ int rvt_destroy_qp(struct ib_qp *ibqp)
 	struct rvt_dev_info *rdi = ib_to_rvt(ibqp->device);
 
 	spin_lock_irq(&qp->r_lock);
+	spin_lock(&qp->s_hlock);
 	spin_lock(&qp->s_lock);
 	rvt_reset_qp(rdi, qp, ibqp->qp_type);
 	spin_unlock(&qp->s_lock);
+	spin_unlock(&qp->s_hlock);
 	spin_unlock_irq(&qp->r_lock);
 
 	/* qpn is now available for use again */
@@ -1358,6 +1369,28 @@ int rvt_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 }
 
 /**
+ * qp_get_savail - return number of avail send entries
+ *
+ * @qp - the qp
+ *
+ * This assumes the s_hlock is held but the s_last
+ * qp variable is uncontrolled.
+ */
+static inline u32 qp_get_savail(struct rvt_qp *qp)
+{
+	u32 slast;
+	u32 ret;
+
+	smp_read_barrier_depends(); /* see rc.c */
+	slast = ACCESS_ONCE(qp->s_last);
+	if (qp->s_head >= slast)
+		ret = qp->s_size - (qp->s_head - slast);
+	else
+		ret = slast - qp->s_head;
+	return ret - 1;
+}
+
+/**
  * rvt_post_one_wr - post one RC, UC, or UD send work request
  * @qp: the QP to post on
  * @wr: the work request to send
@@ -1372,6 +1405,8 @@ static int rvt_post_one_wr(struct rvt_qp *qp, struct ib_send_wr *wr)
 	struct rvt_lkey_table *rkt;
 	struct rvt_pd *pd;
 	struct rvt_dev_info *rdi = ib_to_rvt(qp->ibqp.device);
+	u8 log_pmtu;
+	int ret;
 
 	/* IB spec says that num_sge == 0 is OK. */
 	if (unlikely(wr->num_sge > qp->s_max_sge))
@@ -1403,16 +1438,16 @@ static int rvt_post_one_wr(struct rvt_qp *qp, struct ib_send_wr *wr)
 	} else if (wr->opcode >= IB_WR_RDMA_READ && !qp->s_max_rd_atomic) {
 		return -EINVAL;
 	}
-
+	/* check for avail */
+	if (unlikely(!qp->s_avail)) {
+		qp->s_avail = qp_get_savail(qp);
+		WARN_ON(qp->s_avail > (qp->s_size - 1));
+		if (!qp->s_avail)
+			return -ENOMEM;
+	}
 	next = qp->s_head + 1;
 	if (next >= qp->s_size)
 		next = 0;
-	if (next == qp->s_last)
-		return -ENOMEM;
-
-	if (rdi->driver_f.check_send_wr &&
-	    rdi->driver_f.check_send_wr(qp, wr))
-		return -EINVAL;
 
 	rkt = &rdi->lkey_table;
 	pd = ibpd_to_rvtpd(qp->ibqp.pd);
@@ -1444,21 +1479,39 @@ static int rvt_post_one_wr(struct rvt_qp *qp, struct ib_send_wr *wr)
 				continue;
 			ok = rvt_lkey_ok(rkt, pd, &wqe->sg_list[j],
 					 &wr->sg_list[i], acc);
-			if (!ok)
+			if (!ok) {
+				ret = -EINVAL;
 				goto bail_inval_free;
+			}
 			wqe->length += length;
 			j++;
 		}
 		wqe->wr.num_sge = j;
 	}
-	if (qp->ibqp.qp_type == IB_QPT_UC ||
-	    qp->ibqp.qp_type == IB_QPT_RC) {
-		if (wqe->length > 0x80000000U)
+
+	/* general part of wqe valid - allow for driver checks */
+	if (rdi->driver_f.check_send_wqe) {
+		ret = rdi->driver_f.check_send_wqe(qp, wqe);
+		if (ret)
 			goto bail_inval_free;
-	} else {
+	}
+
+	log_pmtu = qp->log_pmtu;
+	if (qp->ibqp.qp_type != IB_QPT_UC &&
+	    qp->ibqp.qp_type != IB_QPT_RC) {
+		struct rvt_ah *ah = ibah_to_rvtah(wqe->ud_wr.ah);
+
+		log_pmtu = ah->log_pmtu;
 		atomic_inc(&ibah_to_rvtah(ud_wr(wr)->ah)->refcount);
 	}
+
 	wqe->ssn = qp->s_ssn++;
+	wqe->psn = qp->s_next_psn;
+	wqe->lpsn = wqe->psn +
+			(wqe->length ? ((wqe->length - 1) >> log_pmtu) : 0);
+	qp->s_next_psn = wqe->lpsn + 1;
+	smp_wmb(); /* see request builders */
+	qp->s_avail--;
 	qp->s_head = next;
 
 	return 0;
@@ -1470,7 +1523,7 @@ bail_inval_free:
 
 		rvt_put_mr(sge->mr);
 	}
-	return -EINVAL;
+	return ret;
 }
 
 /**
@@ -1491,14 +1544,14 @@ int rvt_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	unsigned nreq = 0;
 	int err = 0;
 
-	spin_lock_irqsave(&qp->s_lock, flags);
+	spin_lock_irqsave(&qp->s_hlock, flags);
 
 	/*
 	 * Ensure QP state is such that we can send. If not bail out early,
 	 * there is no need to do this every time we post a send.
 	 */
 	if (unlikely(!(ib_rvt_state_ops[qp->state] & RVT_POST_SEND_OK))) {
-		spin_unlock_irqrestore(&qp->s_lock, flags);
+		spin_unlock_irqrestore(&qp->s_hlock, flags);
 		return -EINVAL;
 	}
 
@@ -1518,11 +1571,13 @@ int rvt_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		nreq++;
 	}
 bail:
-	if (nreq && !call_send)
-		rdi->driver_f.schedule_send(qp);
-	spin_unlock_irqrestore(&qp->s_lock, flags);
-	if (nreq && call_send)
-		rdi->driver_f.do_send(qp);
+	spin_unlock_irqrestore(&qp->s_hlock, flags);
+	if (nreq) {
+		if (call_send)
+			rdi->driver_f.schedule_send_no_lock(qp);
+		else
+			rdi->driver_f.do_send(qp);
+	}
 	return err;
 }
 
diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index a0bf23d..1f6b55e 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -226,16 +226,45 @@ void hfi1_modify_qp(struct rvt_qp *qp, struct ib_qp_attr *attr,
 	}
 }
 
-int hfi1_check_send_wr(struct rvt_qp *qp, struct ib_send_wr *wr)
+/**
+ * hfi1_check_send_wqe - validate wqe
+ * @qp - The qp
+ * @wqe - The built wqe
+ *
+ * validate wqe.  This is called
+ * prior to inserting the wqe into
+ * the ring but after the wqe has been
+ * setup.
+ *
+ * Returns 0 on success, -EINVAL on failure
+ *
+ */
+int hfi1_check_send_wqe(struct rvt_qp *qp,
+			struct rvt_swqe *wqe)
 {
 	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
-	struct rvt_ah *ah = ibah_to_rvtah(ud_wr(wr)->ah);
+	struct rvt_ah *ah;
 
-	if (qp->ibqp.qp_type != IB_QPT_RC &&
-	    qp->ibqp.qp_type != IB_QPT_UC &&
-	    qp->ibqp.qp_type != IB_QPT_SMI &&
-	    ibp->sl_to_sc[ah->attr.sl] == 0xf) {
-		return -EINVAL;
+	switch (qp->ibqp.qp_type) {
+	case IB_QPT_RC:
+	case IB_QPT_UC:
+		if (wqe->length > 0x80000000U)
+			return -EINVAL;
+		break;
+	case IB_QPT_SMI:
+		ah = ibah_to_rvtah(wqe->ud_wr.ah);
+		if (wqe->length > (1 << ah->log_pmtu))
+			return -EINVAL;
+		break;
+	case IB_QPT_GSI:
+	case IB_QPT_UD:
+		ah = ibah_to_rvtah(wqe->ud_wr.ah);
+		if (wqe->length > (1 << ah->log_pmtu))
+			return -EINVAL;
+		if (ibp->sl_to_sc[ah->attr.sl] == 0xf)
+			return -EINVAL;
+	default:
+		break;
 	}
 	return 0;
 }
@@ -302,6 +331,42 @@ __be32 hfi1_compute_aeth(struct rvt_qp *qp)
 }
 
 /**
+ * _hfi1_schedule_send - schedule progress
+ * @qp: the QP
+ *
+ * This schedules qp progress w/o regard to the s_flags.
+ *
+ * It is only used in the post send, which doesn't hold
+ * the s_lock.
+ */
+void _hfi1_schedule_send(struct rvt_qp *qp)
+{
+	struct hfi1_qp_priv *priv = qp->priv;
+	struct hfi1_ibport *ibp =
+		to_iport(qp->ibqp.device, qp->port_num);
+	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
+	struct hfi1_devdata *dd = dd_from_ibdev(qp->ibqp.device);
+
+	iowait_schedule(&priv->s_iowait, ppd->hfi1_wq,
+			priv->s_sde ?
+			priv->s_sde->cpu :
+			cpumask_first(cpumask_of_node(dd->node)));
+}
+
+/**
+ * hfi1_schedule_send - schedule progress
+ * @qp: the QP
+ *
+ * This schedules qp progress and caller should hold
+ * the s_lock.
+ */
+void hfi1_schedule_send(struct rvt_qp *qp)
+{
+	if (hfi1_send_ok(qp))
+		_hfi1_schedule_send(qp);
+}
+
+/**
  * hfi1_get_credit - flush the send work queue of a QP
  * @qp: the qp who's send work queue to flush
  * @aeth: the Acknowledge Extended Transport Header
diff --git a/drivers/staging/rdma/hfi1/qp.h b/drivers/staging/rdma/hfi1/qp.h
index 973c14b..98827b5 100644
--- a/drivers/staging/rdma/hfi1/qp.h
+++ b/drivers/staging/rdma/hfi1/qp.h
@@ -137,41 +137,8 @@ void qp_iter_print(struct seq_file *s, struct qp_iter *iter);
  */
 void qp_comm_est(struct rvt_qp *qp);
 
-/**
- * _hfi1_schedule_send - schedule progress
- * @qp: the QP
- *
- * This schedules qp progress w/o regard to the s_flags.
- *
- * It is only used in the post send, which doesn't hold
- * the s_lock.
- */
-static inline void _hfi1_schedule_send(struct rvt_qp *qp)
-{
-	struct hfi1_qp_priv *priv = qp->priv;
-	struct hfi1_ibport *ibp =
-		to_iport(qp->ibqp.device, qp->port_num);
-	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
-	struct hfi1_devdata *dd = dd_from_ibdev(qp->ibqp.device);
-
-	iowait_schedule(&priv->s_iowait, ppd->hfi1_wq,
-			priv->s_sde ?
-			priv->s_sde->cpu :
-			cpumask_first(cpumask_of_node(dd->node)));
-}
-
-/**
- * hfi1_schedule_send - schedule progress
- * @qp: the QP
- *
- * This schedules qp progress and caller should hold
- * the s_lock.
- */
-static inline void hfi1_schedule_send(struct rvt_qp *qp)
-{
-	if (hfi1_send_ok(qp))
-		_hfi1_schedule_send(qp);
-}
+void _hfi1_schedule_send(struct rvt_qp *qp);
+void hfi1_schedule_send(struct rvt_qp *qp);
 
 void hfi1_migrate_qp(struct rvt_qp *qp);
 
diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index a4a44d3..a62c942 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -367,6 +367,8 @@ bail:
  * hfi1_make_rc_req - construct a request packet (SEND, RDMA r/w, ATOMIC)
  * @qp: a pointer to the QP
  *
+ * Assumes s_lock is held.
+ *
  * Return 1 if constructed; otherwise, return 0.
  */
 int hfi1_make_rc_req(struct rvt_qp *qp)
@@ -383,7 +385,6 @@ int hfi1_make_rc_req(struct rvt_qp *qp)
 	u32 bth2;
 	u32 pmtu = qp->pmtu;
 	char newreq;
-	unsigned long flags;
 	int ret = 0;
 	int middle = 0;
 	int delta;
@@ -392,12 +393,6 @@ int hfi1_make_rc_req(struct rvt_qp *qp)
 	if (qp->remote_ah_attr.ah_flags & IB_AH_GRH)
 		ohdr = &priv->s_hdr->ibh.u.l.oth;
 
-	/*
-	 * The lock is needed to synchronize between the sending tasklet,
-	 * the receive interrupt handler, and timeout re-sends.
-	 */
-	spin_lock_irqsave(&qp->s_lock, flags);
-
 	/* Sending responses has higher priority over sending requests. */
 	if ((qp->s_flags & RVT_S_RESP_PENDING) &&
 	    make_rc_ack(dev, qp, ohdr, pmtu))
@@ -407,7 +402,8 @@ int hfi1_make_rc_req(struct rvt_qp *qp)
 		if (!(ib_rvt_state_ops[qp->state] & RVT_FLUSH_SEND))
 			goto bail;
 		/* We are in the error state, flush the work request. */
-		if (qp->s_last == qp->s_head)
+		smp_read_barrier_depends(); /* see post_one_send() */
+		if (qp->s_last == ACCESS_ONCE(qp->s_head))
 			goto bail;
 		/* If DMAs are in progress, we can't flush immediately. */
 		if (atomic_read(&priv->s_iowait.sdma_busy)) {
@@ -463,8 +459,8 @@ int hfi1_make_rc_req(struct rvt_qp *qp)
 				qp->s_flags |= RVT_S_WAIT_FENCE;
 				goto bail;
 			}
-			wqe->psn = qp->s_next_psn;
 			newreq = 1;
+			qp->s_psn = wqe->psn;
 		}
 		/*
 		 * Note that we have to be careful not to modify the
@@ -483,9 +479,7 @@ int hfi1_make_rc_req(struct rvt_qp *qp)
 				qp->s_flags |= RVT_S_WAIT_SSN_CREDIT;
 				goto bail;
 			}
-			wqe->lpsn = wqe->psn;
 			if (len > pmtu) {
-				wqe->lpsn += (len - 1) / pmtu;
 				qp->s_state = OP(SEND_FIRST);
 				len = pmtu;
 				break;
@@ -522,9 +516,7 @@ int hfi1_make_rc_req(struct rvt_qp *qp)
 				cpu_to_be32(wqe->rdma_wr.rkey);
 			ohdr->u.rc.reth.length = cpu_to_be32(len);
 			hwords += sizeof(struct ib_reth) / sizeof(u32);
-			wqe->lpsn = wqe->psn;
 			if (len > pmtu) {
-				wqe->lpsn += (len - 1) / pmtu;
 				qp->s_state = OP(RDMA_WRITE_FIRST);
 				len = pmtu;
 				break;
@@ -559,13 +551,6 @@ int hfi1_make_rc_req(struct rvt_qp *qp)
 				qp->s_num_rd_atomic++;
 				if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT))
 					qp->s_lsn++;
-				/*
-				 * Adjust s_next_psn to count the
-				 * expected number of responses.
-				 */
-				if (len > pmtu)
-					qp->s_next_psn += (len - 1) / pmtu;
-				wqe->lpsn = qp->s_next_psn++;
 			}
 			ohdr->u.rc.reth.vaddr =
 				cpu_to_be64(wqe->rdma_wr.remote_addr);
@@ -596,7 +581,6 @@ int hfi1_make_rc_req(struct rvt_qp *qp)
 				qp->s_num_rd_atomic++;
 				if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT))
 					qp->s_lsn++;
-				wqe->lpsn = wqe->psn;
 			}
 			if (wqe->wr.opcode == IB_WR_ATOMIC_CMP_AND_SWP) {
 				qp->s_state = OP(COMPARE_SWAP);
@@ -639,11 +623,8 @@ int hfi1_make_rc_req(struct rvt_qp *qp)
 		}
 		if (wqe->wr.opcode == IB_WR_RDMA_READ)
 			qp->s_psn = wqe->lpsn + 1;
-		else {
+		else
 			qp->s_psn++;
-			if (cmp_psn(qp->s_psn, qp->s_next_psn) > 0)
-				qp->s_next_psn = qp->s_psn;
-		}
 		break;
 
 	case OP(RDMA_READ_RESPONSE_FIRST):
@@ -663,8 +644,6 @@ int hfi1_make_rc_req(struct rvt_qp *qp)
 		/* FALLTHROUGH */
 	case OP(SEND_MIDDLE):
 		bth2 = mask_psn(qp->s_psn++);
-		if (cmp_psn(qp->s_psn, qp->s_next_psn) > 0)
-			qp->s_next_psn = qp->s_psn;
 		ss = &qp->s_sge;
 		len = qp->s_len;
 		if (len > pmtu) {
@@ -705,8 +684,6 @@ int hfi1_make_rc_req(struct rvt_qp *qp)
 		/* FALLTHROUGH */
 	case OP(RDMA_WRITE_MIDDLE):
 		bth2 = mask_psn(qp->s_psn++);
-		if (cmp_psn(qp->s_psn, qp->s_next_psn) > 0)
-			qp->s_next_psn = qp->s_psn;
 		ss = &qp->s_sge;
 		len = qp->s_len;
 		if (len > pmtu) {
@@ -777,13 +754,9 @@ int hfi1_make_rc_req(struct rvt_qp *qp)
 		bth2,
 		middle);
 done:
-	ret = 1;
-	goto unlock;
-
+	return 1;
 bail:
 	qp->s_flags &= ~RVT_S_BUSY;
-unlock:
-	spin_unlock_irqrestore(&qp->s_lock, flags);
 	return ret;
 }
 
@@ -1563,7 +1536,8 @@ static void rc_rcv_resp(struct hfi1_ibport *ibp,
 	trace_hfi1_rc_ack(qp, psn);
 
 	/* Ignore invalid responses. */
-	if (cmp_psn(psn, qp->s_next_psn) >= 0)
+	smp_read_barrier_depends(); /* see post_one_send */
+	if (cmp_psn(psn, ACCESS_ONCE(qp->s_next_psn)) >= 0)
 		goto ack_done;
 
 	/* Ignore duplicate responses. */
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index a7add3c..6114550 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -392,7 +392,8 @@ static void ruc_loopback(struct rvt_qp *sqp)
 	sqp->s_flags |= RVT_S_BUSY;
 
 again:
-	if (sqp->s_last == sqp->s_head)
+	smp_read_barrier_depends(); /* see post_one_send() */
+	if (sqp->s_last == ACCESS_ONCE(sqp->s_head))
 		goto clr_busy;
 	wqe = rvt_get_swqe_ptr(sqp, sqp->s_last);
 
@@ -871,40 +872,43 @@ void hfi1_do_send(struct rvt_qp *qp)
 
 	qp->s_flags |= RVT_S_BUSY;
 
-	spin_unlock_irqrestore(&qp->s_lock, flags);
-
 	timeout = jiffies + (timeout_int) / 8;
 	cpu = priv->s_sde ? priv->s_sde->cpu :
 			cpumask_first(cpumask_of_node(ps.ppd->dd->node));
 	do {
 		/* Check for a constructed packet to be sent. */
 		if (qp->s_hdrwords != 0) {
+			spin_unlock_irqrestore(&qp->s_lock, flags);
 			/*
 			 * If the packet cannot be sent now, return and
 			 * the send tasklet will be woken up later.
 			 */
 			if (hfi1_verbs_send(qp, &ps))
-				break;
+				return;
 			/* Record that s_hdr is empty. */
 			qp->s_hdrwords = 0;
-		}
-
-		/* allow other tasks to run */
-		if (unlikely(time_after(jiffies, timeout))) {
-			if (workqueue_congested(cpu, ps.ppd->hfi1_wq)) {
-				spin_lock_irqsave(&qp->s_lock, flags);
-				qp->s_flags &= ~RVT_S_BUSY;
-				hfi1_schedule_send(qp);
-				spin_unlock_irqrestore(&qp->s_lock,
-						       flags);
+			/* allow other tasks to run */
+			if (unlikely(time_after(jiffies, timeout))) {
+				if (workqueue_congested(cpu,
+							ps.ppd->hfi1_wq)) {
+					spin_lock_irqsave(&qp->s_lock, flags);
+					qp->s_flags &= ~RVT_S_BUSY;
+					hfi1_schedule_send(qp);
+					spin_unlock_irqrestore(&qp->s_lock,
+							       flags);
+					this_cpu_inc(
+						*ps.ppd->dd->send_schedule);
+					return;
+				}
+				cond_resched();
 				this_cpu_inc(*ps.ppd->dd->send_schedule);
-				return;
+				timeout = jiffies + (timeout_int) / 8;
 			}
-			cond_resched();
-			this_cpu_inc(*ps.ppd->dd->send_schedule);
-			timeout = jiffies + (timeout_int) / 8;
+			spin_lock_irqsave(&qp->s_lock, flags);
 		}
 	} while (make_req(qp));
+
+	spin_unlock_irqrestore(&qp->s_lock, flags);
 }
 
 /*
diff --git a/drivers/staging/rdma/hfi1/uc.c b/drivers/staging/rdma/hfi1/uc.c
index 0aa604b..f884b5c 100644
--- a/drivers/staging/rdma/hfi1/uc.c
+++ b/drivers/staging/rdma/hfi1/uc.c
@@ -59,6 +59,8 @@
  * hfi1_make_uc_req - construct a request packet (SEND, RDMA write)
  * @qp: a pointer to the QP
  *
+ * Assume s_lock is held.
+ *
  * Return 1 if constructed; otherwise, return 0.
  */
 int hfi1_make_uc_req(struct rvt_qp *qp)
@@ -66,7 +68,6 @@ int hfi1_make_uc_req(struct rvt_qp *qp)
 	struct hfi1_qp_priv *priv = qp->priv;
 	struct hfi1_other_headers *ohdr;
 	struct rvt_swqe *wqe;
-	unsigned long flags;
 	u32 hwords = 5;
 	u32 bth0 = 0;
 	u32 len;
@@ -74,13 +75,12 @@ int hfi1_make_uc_req(struct rvt_qp *qp)
 	int ret = 0;
 	int middle = 0;
 
-	spin_lock_irqsave(&qp->s_lock, flags);
-
 	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_SEND_OK)) {
 		if (!(ib_rvt_state_ops[qp->state] & RVT_FLUSH_SEND))
 			goto bail;
 		/* We are in the error state, flush the work request. */
-		if (qp->s_last == qp->s_head)
+		smp_read_barrier_depends(); /* see post_one_send() */
+		if (qp->s_last == ACCESS_ONCE(qp->s_head))
 			goto bail;
 		/* If DMAs are in progress, we can't flush immediately. */
 		if (atomic_read(&priv->s_iowait.sdma_busy)) {
@@ -106,15 +106,15 @@ int hfi1_make_uc_req(struct rvt_qp *qp)
 		    RVT_PROCESS_NEXT_SEND_OK))
 			goto bail;
 		/* Check if send work queue is empty. */
-		if (qp->s_cur == qp->s_head) {
+		smp_read_barrier_depends(); /* see post_one_send() */
+		if (qp->s_cur == ACCESS_ONCE(qp->s_head)) {
 			clear_ahg(qp);
 			goto bail;
 		}
 		/*
 		 * Start a new request.
 		 */
-		wqe->psn = qp->s_next_psn;
-		qp->s_psn = qp->s_next_psn;
+		qp->s_psn = wqe->psn;
 		qp->s_sge.sge = wqe->sg_list[0];
 		qp->s_sge.sg_list = wqe->sg_list + 1;
 		qp->s_sge.num_sge = wqe->wr.num_sge;
@@ -235,15 +235,12 @@ int hfi1_make_uc_req(struct rvt_qp *qp)
 	qp->s_cur_sge = &qp->s_sge;
 	qp->s_cur_size = len;
 	hfi1_make_ruc_header(qp, ohdr, bth0 | (qp->s_state << 24),
-			     mask_psn(qp->s_next_psn++), middle);
+			     mask_psn(qp->s_psn++), middle);
 done:
-	ret = 1;
-	goto unlock;
+	return 1;
 
 bail:
 	qp->s_flags &= ~RVT_S_BUSY;
-unlock:
-	spin_unlock_irqrestore(&qp->s_lock, flags);
 	return ret;
 }
 
diff --git a/drivers/staging/rdma/hfi1/ud.c b/drivers/staging/rdma/hfi1/ud.c
index fdf6e3b..ba78e2e 100644
--- a/drivers/staging/rdma/hfi1/ud.c
+++ b/drivers/staging/rdma/hfi1/ud.c
@@ -261,6 +261,8 @@ drop:
  * hfi1_make_ud_req - construct a UD request packet
  * @qp: the QP
  *
+ * Assume s_lock is held.
+ *
  * Return 1 if constructed; otherwise, return 0.
  */
 int hfi1_make_ud_req(struct rvt_qp *qp)
@@ -271,7 +273,6 @@ int hfi1_make_ud_req(struct rvt_qp *qp)
 	struct hfi1_pportdata *ppd;
 	struct hfi1_ibport *ibp;
 	struct rvt_swqe *wqe;
-	unsigned long flags;
 	u32 nwords;
 	u32 extra_bytes;
 	u32 bth0;
@@ -281,13 +282,12 @@ int hfi1_make_ud_req(struct rvt_qp *qp)
 	int next_cur;
 	u8 sc5;
 
-	spin_lock_irqsave(&qp->s_lock, flags);
-
 	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_NEXT_SEND_OK)) {
 		if (!(ib_rvt_state_ops[qp->state] & RVT_FLUSH_SEND))
 			goto bail;
 		/* We are in the error state, flush the work request. */
-		if (qp->s_last == qp->s_head)
+		smp_read_barrier_depends(); /* see post_one_send */
+		if (qp->s_last == ACCESS_ONCE(qp->s_head))
 			goto bail;
 		/* If DMAs are in progress, we can't flush immediately. */
 		if (atomic_read(&priv->s_iowait.sdma_busy)) {
@@ -299,7 +299,9 @@ int hfi1_make_ud_req(struct rvt_qp *qp)
 		goto done;
 	}
 
-	if (qp->s_cur == qp->s_head)
+	/* see post_one_send() */
+	smp_read_barrier_depends();
+	if (qp->s_cur == ACCESS_ONCE(qp->s_head))
 		goto bail;
 
 	wqe = rvt_get_swqe_ptr(qp, qp->s_cur);
@@ -317,6 +319,7 @@ int hfi1_make_ud_req(struct rvt_qp *qp)
 		if (unlikely(!loopback && (lid == ppd->lid ||
 		    (lid == be16_to_cpu(IB_LID_PERMISSIVE) &&
 		     qp->ibqp.qp_type == IB_QPT_GSI)))) {
+			unsigned long flags;
 			/*
 			 * If DMAs are in progress, we can't generate
 			 * a completion for the loopback packet since
@@ -329,6 +332,7 @@ int hfi1_make_ud_req(struct rvt_qp *qp)
 				goto bail;
 			}
 			qp->s_cur = next_cur;
+			local_irq_save(flags);
 			spin_unlock_irqrestore(&qp->s_lock, flags);
 			ud_loopback(qp, wqe);
 			spin_lock_irqsave(&qp->s_lock, flags);
@@ -408,7 +412,7 @@ int hfi1_make_ud_req(struct rvt_qp *qp)
 		bth0 |= hfi1_get_pkey(ibp, qp->s_pkey_index);
 	ohdr->bth[0] = cpu_to_be32(bth0);
 	ohdr->bth[1] = cpu_to_be32(wqe->ud_wr.remote_qpn);
-	ohdr->bth[2] = cpu_to_be32(mask_psn(qp->s_next_psn++));
+	ohdr->bth[2] = cpu_to_be32(mask_psn(wqe->psn));
 	/*
 	 * Qkeys with the high order bit set mean use the
 	 * qkey from the QP context instead of the WR (see 10.2.5).
@@ -423,13 +427,9 @@ int hfi1_make_ud_req(struct rvt_qp *qp)
 	priv->s_hdr->sde = NULL;
 
 done:
-	ret = 1;
-	goto unlock;
-
+	return 1;
 bail:
 	qp->s_flags &= ~RVT_S_BUSY;
-unlock:
-	spin_unlock_irqrestore(&qp->s_lock, flags);
 	return ret;
 }
 
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 35f6d92..1df4648 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -1533,6 +1533,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	dd->verbs_dev.rdi.driver_f.notify_qp_reset = notify_qp_reset;
 	dd->verbs_dev.rdi.driver_f.do_send = hfi1_do_send;
 	dd->verbs_dev.rdi.driver_f.schedule_send = hfi1_schedule_send;
+	dd->verbs_dev.rdi.driver_f.schedule_send_no_lock = _hfi1_schedule_send;
 	dd->verbs_dev.rdi.driver_f.get_pmtu_from_attr = get_pmtu_from_attr;
 	dd->verbs_dev.rdi.driver_f.notify_error_qp = notify_error_qp;
 	dd->verbs_dev.rdi.driver_f.flush_qp_waiters = flush_qp_waiters;
@@ -1543,7 +1544,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	dd->verbs_dev.rdi.driver_f.mtu_to_path_mtu = mtu_to_path_mtu;
 	dd->verbs_dev.rdi.driver_f.check_modify_qp = hfi1_check_modify_qp;
 	dd->verbs_dev.rdi.driver_f.modify_qp = hfi1_modify_qp;
-	dd->verbs_dev.rdi.driver_f.check_send_wr = hfi1_check_send_wr;
+	dd->verbs_dev.rdi.driver_f.check_send_wqe = hfi1_check_send_wqe;
 
 	/* completeion queue */
 	snprintf(dd->verbs_dev.rdi.dparms.cq_name,
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index adb63bb..d00c55d 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -427,7 +427,7 @@ int hfi1_check_modify_qp(struct rvt_qp *qp, struct ib_qp_attr *attr,
 void hfi1_modify_qp(struct rvt_qp *qp, struct ib_qp_attr *attr,
 		    int attr_mask, struct ib_udata *udata);
 
-int hfi1_check_send_wr(struct rvt_qp *qp, struct ib_send_wr *wr);
+int hfi1_check_send_wqe(struct rvt_qp *qp, struct rvt_swqe *wqe);
 
 int hfi1_ruc_check_hdr(struct hfi1_ibport *ibp, struct hfi1_ib_header *hdr,
 		       int has_grh, struct rvt_qp *qp, u32 bth0);
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 5ccf683..aabd2e5 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -220,6 +220,7 @@ struct rvt_ah {
 };
 
 struct rvt_dev_info;
+struct rvt_swqe;
 struct rvt_driver_provided {
 	/*
 	 * The work to create port files in /sys/class Infiniband is different
@@ -240,6 +241,7 @@ struct rvt_driver_provided {
 	void (*qp_priv_free)(struct rvt_dev_info *rdi, struct rvt_qp *qp);
 	void (*notify_qp_reset)(struct rvt_qp *qp);
 	void (*schedule_send)(struct rvt_qp *qp);
+	void (*schedule_send_no_lock)(struct rvt_qp *qp);
 	void (*do_send)(struct rvt_qp *qp);
 	int (*get_pmtu_from_attr)(struct rvt_dev_info *rdi, struct rvt_qp *qp,
 				  struct ib_qp_attr *attr);
@@ -273,7 +275,7 @@ struct rvt_driver_provided {
 	void (*modify_qp)(struct rvt_qp *qp, struct ib_qp_attr *attr,
 			  int attr_mask, struct ib_udata *udata);
 
-	int (*check_send_wr)(struct rvt_qp *qp, struct ib_send_wr *wr);
+	int (*check_send_wqe)(struct rvt_qp *qp, struct rvt_swqe *wqe);
 
 	void (*notify_create_mad_agent)(struct rvt_dev_info *rdi, int port_idx);
 	void (*notify_free_mad_agent)(struct rvt_dev_info *rdi, int port_idx);
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index b3ea745..1066b5d 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -250,11 +250,12 @@ struct rvt_qp {
 	enum ib_mtu path_mtu;
 	int srate_mbps;		/* s_srate (below) converted to Mbit/s */
 	u32 remote_qpn;
-	u32 pmtu;		/* decoded from path_mtu */
 	u32 qkey;               /* QKEY for this QP (for UD or RD) */
 	u32 s_size;             /* send work queue size */
 	u32 s_ahgpsn;           /* set to the psn in the copy of the header */
 
+	u16 pmtu;		/* decoded from path_mtu */
+	u8 log_pmtu;		/* shift for pmtu */
 	u8 state;               /* QP state */
 	u8 allowed_ops;		/* high order bits of allowed opcodes */
 	u8 qp_access_flags;
@@ -299,6 +300,13 @@ struct rvt_qp {
 	struct rvt_sge_state r_sge;     /* current receive data */
 	struct rvt_rq r_rq;             /* receive work queue */
 
+	/* post send line */
+	spinlock_t s_hlock ____cacheline_aligned_in_smp;
+	u32 s_head;             /* new entries added here */
+	u32 s_next_psn;         /* PSN for next request */
+	u32 s_avail;            /* number of entries avail */
+	u32 s_ssn;              /* SSN of tail entry */
+
 	spinlock_t s_lock ____cacheline_aligned_in_smp;
 	struct rvt_sge_state *s_cur_sge;
 	u32 s_flags;
@@ -308,19 +316,16 @@ struct rvt_qp {
 	u32 s_cur_size;         /* size of send packet in bytes */
 	u32 s_len;              /* total length of s_sge */
 	u32 s_rdma_read_len;    /* total length of s_rdma_read_sge */
-	u32 s_next_psn;         /* PSN for next request */
 	u32 s_last_psn;         /* last response PSN processed */
 	u32 s_sending_psn;      /* lowest PSN that is being sent */
 	u32 s_sending_hpsn;     /* highest PSN that is being sent */
 	u32 s_psn;              /* current packet sequence number */
 	u32 s_ack_rdma_psn;     /* PSN for sending RDMA read responses */
 	u32 s_ack_psn;          /* PSN for acking sends and RDMA writes */
-	u32 s_head;             /* new entries added here */
 	u32 s_tail;             /* next entry to process */
 	u32 s_cur;              /* current work queue entry */
 	u32 s_acked;            /* last un-ACK'ed entry */
 	u32 s_last;             /* last completed entry */
-	u32 s_ssn;              /* SSN of tail entry */
 	u32 s_lsn;              /* limit sequence number (credit) */
 	u16 s_hdrwords;         /* size of s_hdr in 32 bit words */
 	u16 s_rdma_ack_cnt;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
