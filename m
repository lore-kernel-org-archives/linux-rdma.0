From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 17/27] IB/hfi1,
 rdmavt: Update copy_sge to use boolean arguments
Date: Wed, 08 Feb 2017 05:27:31 -0800
Message-ID: <20170208132730.16442.70413.stgit@scvm10.sc.intel.com>
References: <20170208132142.16442.69329.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170208132142.16442.69329.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Convert copy_sge and related SGE state functions to use boolean.
For determining if QP is in user mode, add helper function in rdmavt_qp.h.
This is used to determine if QP needs the last byte ordering.
While here, change rvt_pd.user to a boolean.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/rc.c    |   16 ++++++++--------
 drivers/infiniband/hw/hfi1/ruc.c   |   10 +++++-----
 drivers/infiniband/hw/hfi1/uc.c    |   10 +++++-----
 drivers/infiniband/hw/hfi1/ud.c    |   12 ++++++------
 drivers/infiniband/hw/hfi1/verbs.c |   21 +++++++++++----------
 drivers/infiniband/hw/hfi1/verbs.h |    4 ++--
 drivers/infiniband/sw/rdmavt/pd.c  |    2 +-
 include/rdma/rdma_vt.h             |    2 +-
 include/rdma/rdmavt_qp.h           |    9 +++++++++
 9 files changed, 48 insertions(+), 38 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index c2f1a6f..b1c350d 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -67,7 +67,7 @@ static u32 restart_sge(struct rvt_sge_state *ss, struct rvt_swqe *wqe,
 	ss->sg_list = wqe->sg_list + 1;
 	ss->num_sge = wqe->wr.num_sge;
 	ss->total_len = wqe->length;
-	hfi1_skip_sge(ss, len, 0);
+	hfi1_skip_sge(ss, len, false);
 	return wqe->length - len;
 }
 
@@ -1508,7 +1508,7 @@ static void rc_rcv_resp(struct hfi1_ibport *ibp,
 		qp->s_rdma_read_len -= pmtu;
 		update_last_psn(qp, psn);
 		spin_unlock_irqrestore(&qp->s_lock, flags);
-		hfi1_copy_sge(&qp->s_rdma_read_sge, data, pmtu, 0, 0);
+		hfi1_copy_sge(&qp->s_rdma_read_sge, data, pmtu, false, false);
 		goto bail;
 
 	case OP(RDMA_READ_RESPONSE_ONLY):
@@ -1552,7 +1552,7 @@ static void rc_rcv_resp(struct hfi1_ibport *ibp,
 		if (unlikely(tlen != qp->s_rdma_read_len))
 			goto ack_len_err;
 		aeth = be32_to_cpu(ohdr->u.aeth);
-		hfi1_copy_sge(&qp->s_rdma_read_sge, data, tlen, 0, 0);
+		hfi1_copy_sge(&qp->s_rdma_read_sge, data, tlen, false, false);
 		WARN_ON(qp->s_rdma_read_sge.num_sge);
 		(void)do_rc_ack(qp, aeth, psn,
 				 OP(RDMA_READ_RESPONSE_LAST), 0, rcd);
@@ -1923,7 +1923,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 	struct ib_reth *reth;
 	unsigned long flags;
 	int ret, is_fecn = 0;
-	int copy_last = 0;
+	bool copy_last = false;
 	u32 rkey;
 
 	lockdep_assert_held(&qp->r_lock);
@@ -2017,7 +2017,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 		qp->r_rcv_len += pmtu;
 		if (unlikely(qp->r_rcv_len > qp->r_len))
 			goto nack_inv;
-		hfi1_copy_sge(&qp->r_sge, data, pmtu, 1, 0);
+		hfi1_copy_sge(&qp->r_sge, data, pmtu, true, false);
 		break;
 
 	case OP(RDMA_WRITE_LAST_WITH_IMMEDIATE):
@@ -2057,7 +2057,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 		wc.wc_flags = IB_WC_WITH_INVALIDATE;
 		goto send_last;
 	case OP(RDMA_WRITE_LAST):
-		copy_last = ibpd_to_rvtpd(qp->ibqp.pd)->user;
+		copy_last = rvt_is_user_qp(qp);
 		/* fall through */
 	case OP(SEND_LAST):
 no_immediate_data:
@@ -2075,7 +2075,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 		wc.byte_len = tlen + qp->r_rcv_len;
 		if (unlikely(wc.byte_len > qp->r_len))
 			goto nack_inv;
-		hfi1_copy_sge(&qp->r_sge, data, tlen, 1, copy_last);
+		hfi1_copy_sge(&qp->r_sge, data, tlen, true, copy_last);
 		rvt_put_ss(&qp->r_sge);
 		qp->r_msn++;
 		if (!__test_and_clear_bit(RVT_R_WRID_VALID, &qp->r_aflags))
@@ -2113,7 +2113,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 		break;
 
 	case OP(RDMA_WRITE_ONLY):
-		copy_last = 1;
+		copy_last = rvt_is_user_qp(qp);
 		/* fall through */
 	case OP(RDMA_WRITE_FIRST):
 	case OP(RDMA_WRITE_ONLY_WITH_IMMEDIATE):
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index dc41b2c..bdf3697 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -320,9 +320,9 @@ static void ruc_loopback(struct rvt_qp *sqp)
 	u64 sdata;
 	atomic64_t *maddr;
 	enum ib_wc_status send_status;
-	int release;
+	bool release;
 	int ret;
-	int copy_last = 0;
+	bool copy_last = false;
 	int local_ops = 0;
 
 	rcu_read_lock();
@@ -386,7 +386,7 @@ static void ruc_loopback(struct rvt_qp *sqp)
 	memset(&wc, 0, sizeof(wc));
 	send_status = IB_WC_SUCCESS;
 
-	release = 1;
+	release = true;
 	sqp->s_sge.sge = wqe->sg_list[0];
 	sqp->s_sge.sg_list = wqe->sg_list + 1;
 	sqp->s_sge.num_sge = wqe->wr.num_sge;
@@ -437,7 +437,7 @@ static void ruc_loopback(struct rvt_qp *sqp)
 		/* skip copy_last set and qp_access_flags recheck */
 		goto do_write;
 	case IB_WR_RDMA_WRITE:
-		copy_last = ibpd_to_rvtpd(qp->ibqp.pd)->user;
+		copy_last = rvt_is_user_qp(qp);
 		if (unlikely(!(qp->qp_access_flags & IB_ACCESS_REMOTE_WRITE)))
 			goto inv_err;
 do_write:
@@ -461,7 +461,7 @@ static void ruc_loopback(struct rvt_qp *sqp)
 					  wqe->rdma_wr.rkey,
 					  IB_ACCESS_REMOTE_READ)))
 			goto acc_err;
-		release = 0;
+		release = false;
 		sqp->s_sge.sg_list = NULL;
 		sqp->s_sge.num_sge = 1;
 		qp->r_sge.sge = wqe->sg_list[0];
diff --git a/drivers/infiniband/hw/hfi1/uc.c b/drivers/infiniband/hw/hfi1/uc.c
index 782a0bf..4b2a840 100644
--- a/drivers/infiniband/hw/hfi1/uc.c
+++ b/drivers/infiniband/hw/hfi1/uc.c
@@ -419,7 +419,7 @@ void hfi1_uc_rcv(struct hfi1_packet *packet)
 		qp->r_rcv_len += pmtu;
 		if (unlikely(qp->r_rcv_len > qp->r_len))
 			goto rewind;
-		hfi1_copy_sge(&qp->r_sge, data, pmtu, 0, 0);
+		hfi1_copy_sge(&qp->r_sge, data, pmtu, false, false);
 		break;
 
 	case OP(SEND_LAST_WITH_IMMEDIATE):
@@ -444,7 +444,7 @@ void hfi1_uc_rcv(struct hfi1_packet *packet)
 		if (unlikely(wc.byte_len > qp->r_len))
 			goto rewind;
 		wc.opcode = IB_WC_RECV;
-		hfi1_copy_sge(&qp->r_sge, data, tlen, 0, 0);
+		hfi1_copy_sge(&qp->r_sge, data, tlen, false, false);
 		rvt_put_ss(&qp->s_rdma_read_sge);
 last_imm:
 		wc.wr_id = qp->r_wr_id;
@@ -519,7 +519,7 @@ void hfi1_uc_rcv(struct hfi1_packet *packet)
 		qp->r_rcv_len += pmtu;
 		if (unlikely(qp->r_rcv_len > qp->r_len))
 			goto drop;
-		hfi1_copy_sge(&qp->r_sge, data, pmtu, 1, 0);
+		hfi1_copy_sge(&qp->r_sge, data, pmtu, true, false);
 		break;
 
 	case OP(RDMA_WRITE_LAST_WITH_IMMEDIATE):
@@ -548,7 +548,7 @@ void hfi1_uc_rcv(struct hfi1_packet *packet)
 		}
 		wc.byte_len = qp->r_len;
 		wc.opcode = IB_WC_RECV_RDMA_WITH_IMM;
-		hfi1_copy_sge(&qp->r_sge, data, tlen, 1, 0);
+		hfi1_copy_sge(&qp->r_sge, data, tlen, true, false);
 		rvt_put_ss(&qp->r_sge);
 		goto last_imm;
 
@@ -564,7 +564,7 @@ void hfi1_uc_rcv(struct hfi1_packet *packet)
 		tlen -= (hdrsize + pad + 4);
 		if (unlikely(tlen + qp->r_rcv_len != qp->r_len))
 			goto drop;
-		hfi1_copy_sge(&qp->r_sge, data, tlen, 1, 0);
+		hfi1_copy_sge(&qp->r_sge, data, tlen, true, false);
 		rvt_put_ss(&qp->r_sge);
 		break;
 
diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index 58cd301..9329c16 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -189,10 +189,10 @@ static void ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 
 		hfi1_make_grh(ibp, &grh, &grd, 0, 0);
 		hfi1_copy_sge(&qp->r_sge, &grh,
-			      sizeof(grh), 1, 0);
+			      sizeof(grh), true, false);
 		wc.wc_flags |= IB_WC_GRH;
 	} else {
-		hfi1_skip_sge(&qp->r_sge, sizeof(struct ib_grh), 1);
+		hfi1_skip_sge(&qp->r_sge, sizeof(struct ib_grh), true);
 	}
 	ssge.sg_list = swqe->sg_list + 1;
 	ssge.sge = *swqe->sg_list;
@@ -206,7 +206,7 @@ static void ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 		if (len > sge->sge_length)
 			len = sge->sge_length;
 		WARN_ON_ONCE(len == 0);
-		hfi1_copy_sge(&qp->r_sge, sge->vaddr, len, 1, 0);
+		hfi1_copy_sge(&qp->r_sge, sge->vaddr, len, true, false);
 		sge->vaddr += len;
 		sge->length -= len;
 		sge->sge_length -= len;
@@ -812,13 +812,13 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 	}
 	if (has_grh) {
 		hfi1_copy_sge(&qp->r_sge, &hdr->u.l.grh,
-			      sizeof(struct ib_grh), 1, 0);
+			      sizeof(struct ib_grh), true, false);
 		wc.wc_flags |= IB_WC_GRH;
 	} else {
-		hfi1_skip_sge(&qp->r_sge, sizeof(struct ib_grh), 1);
+		hfi1_skip_sge(&qp->r_sge, sizeof(struct ib_grh), true);
 	}
 	hfi1_copy_sge(&qp->r_sge, data, wc.byte_len - sizeof(struct ib_grh),
-		      1, 0);
+		      true, false);
 	rvt_put_ss(&qp->r_sge);
 	if (!test_and_clear_bit(RVT_R_WRID_VALID, &qp->r_aflags))
 		return;
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index cae3230..b10c2dc 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -291,7 +291,7 @@ static void wss_insert(void *address)
 /*
  * Is the working set larger than the threshold?
  */
-static inline int wss_exceeds_threshold(void)
+static inline bool wss_exceeds_threshold(void)
 {
 	return atomic_read(&wss.total_count) >= wss.threshold;
 }
@@ -419,18 +419,19 @@ static inline int wss_exceeds_threshold(void)
  * @ss: the SGE state
  * @data: the data to copy
  * @length: the length of the data
+ * @release: boolean to release MR
  * @copy_last: do a separate copy of the last 8 bytes
  */
 void hfi1_copy_sge(
 	struct rvt_sge_state *ss,
 	void *data, u32 length,
-	int release,
-	int copy_last)
+	bool release,
+	bool copy_last)
 {
 	struct rvt_sge *sge = &ss->sge;
-	int in_last = 0;
 	int i;
-	int cacheless_copy = 0;
+	bool in_last = false;
+	bool cacheless_copy = false;
 
 	if (sge_copy_mode == COPY_CACHELESS) {
 		cacheless_copy = length >= PAGE_SIZE;
@@ -454,8 +455,8 @@ void hfi1_copy_sge(
 		if (length > 8) {
 			length -= 8;
 		} else {
-			copy_last = 0;
-			in_last = 1;
+			copy_last = false;
+			in_last = true;
 		}
 	}
 
@@ -501,8 +502,8 @@ void hfi1_copy_sge(
 	}
 
 	if (copy_last) {
-		copy_last = 0;
-		in_last = 1;
+		copy_last = false;
+		in_last = true;
 		length = 8;
 		goto again;
 	}
@@ -513,7 +514,7 @@ void hfi1_copy_sge(
  * @ss: the SGE state
  * @length: the number of bytes to skip
  */
-void hfi1_skip_sge(struct rvt_sge_state *ss, u32 length, int release)
+void hfi1_skip_sge(struct rvt_sge_state *ss, u32 length, bool release)
 {
 	struct rvt_sge *sge = &ss->sge;
 
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index 6e9e4bb..9fab6b3 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -289,9 +289,9 @@ static inline u32 delta_psn(u32 a, u32 b)
 int hfi1_verbs_send(struct rvt_qp *qp, struct hfi1_pkt_state *ps);
 
 void hfi1_copy_sge(struct rvt_sge_state *ss, void *data, u32 length,
-		   int release, int copy_last);
+		   bool release, bool copy_last);
 
-void hfi1_skip_sge(struct rvt_sge_state *ss, u32 length, int release);
+void hfi1_skip_sge(struct rvt_sge_state *ss, u32 length, bool release);
 
 void hfi1_cnp_rcv(struct hfi1_packet *packet);
 
diff --git a/drivers/infiniband/sw/rdmavt/pd.c b/drivers/infiniband/sw/rdmavt/pd.c
index d1292f3..8a89aff 100644
--- a/drivers/infiniband/sw/rdmavt/pd.c
+++ b/drivers/infiniband/sw/rdmavt/pd.c
@@ -90,7 +90,7 @@ struct ib_pd *rvt_alloc_pd(struct ib_device *ibdev,
 	spin_unlock(&dev->n_pds_lock);
 
 	/* ib_alloc_pd() will initialize pd->ibpd. */
-	pd->user = udata ? 1 : 0;
+	pd->user = !!udata;
 
 	ret = &pd->ibpd;
 
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index a69dee3..8fc1ca7 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -164,7 +164,7 @@ struct rvt_driver_params {
 /* Protection domain */
 struct rvt_pd {
 	struct ib_pd ibpd;
-	int user;               /* non-zero if created from user space */
+	bool user;
 };
 
 /* Address handle */
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index 0b1cbff..561b6c8 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -468,6 +468,15 @@ struct rvt_mcast {
 }
 
 /**
+ * rvt_is_user_qp - return if this is user mode QP
+ * @qp - the target QP
+ */
+static inline bool rvt_is_user_qp(struct rvt_qp *qp)
+{
+	return !!qp->pid;
+}
+
+/**
  * rvt_get_qp - get a QP reference
  * @qp - the QP to hold
  */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
