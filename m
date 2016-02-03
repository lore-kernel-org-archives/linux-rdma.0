From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 37/54] staging/rdma/hfi1: Split last 8 bytes of copy to user
 buffer
Date: Wed, 03 Feb 2016 14:35:49 -0800
Message-ID: <20160203223545.5923.7330.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Copy the last 8 bytes of user mode RC WRITE_ONLY and WRITE_LAST
opcodes separately from the rest of the data.

It is a de-facto standard for some MPI implementations to use a
poll on the last few bytes of a verbs message to indicate that
the message has been received rather than follow the required
function method.  The driver uses the kernel memcpy routine, which
becomes "rep movsb" on modern machines.  This copy, while very
fast, does not guarantee in-order copy completion and the result
is an occasional perceived corrupted packet.  Avoid the issue by
splitting the last 8 bytes to copy from the verbs opcodes where it
matters and performing an in-order byte copy.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/rc.c    |   17 +++++++++++------
 drivers/staging/rdma/hfi1/ruc.c   |    8 ++++++--
 drivers/staging/rdma/hfi1/uc.c    |   10 +++++-----
 drivers/staging/rdma/hfi1/ud.c    |    9 +++++----
 drivers/staging/rdma/hfi1/verbs.c |   31 +++++++++++++++++++++++++++++--
 drivers/staging/rdma/hfi1/verbs.h |    2 +-
 6 files changed, 57 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index 50559fd..371edc3 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -1539,7 +1539,7 @@ read_middle:
 		qp->s_rdma_read_len -= pmtu;
 		update_last_psn(qp, psn);
 		spin_unlock_irqrestore(&qp->s_lock, flags);
-		hfi1_copy_sge(&qp->s_rdma_read_sge, data, pmtu, 0);
+		hfi1_copy_sge(&qp->s_rdma_read_sge, data, pmtu, 0, 0);
 		goto bail;
 
 	case OP(RDMA_READ_RESPONSE_ONLY):
@@ -1583,7 +1583,7 @@ read_last:
 		if (unlikely(tlen != qp->s_rdma_read_len))
 			goto ack_len_err;
 		aeth = be32_to_cpu(ohdr->u.aeth);
-		hfi1_copy_sge(&qp->s_rdma_read_sge, data, tlen, 0);
+		hfi1_copy_sge(&qp->s_rdma_read_sge, data, tlen, 0, 0);
 		WARN_ON(qp->s_rdma_read_sge.num_sge);
 		(void) do_rc_ack(qp, aeth, psn,
 				 OP(RDMA_READ_RESPONSE_LAST), 0, rcd);
@@ -1977,6 +1977,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 	unsigned long flags;
 	u32 bth1;
 	int ret, is_fecn = 0;
+	int copy_last = 0;
 
 	bth0 = be32_to_cpu(ohdr->bth[0]);
 	if (hfi1_ruc_check_hdr(ibp, hdr, rcv_flags & HFI1_HAS_GRH, qp, bth0))
@@ -2081,7 +2082,7 @@ send_middle:
 		qp->r_rcv_len += pmtu;
 		if (unlikely(qp->r_rcv_len > qp->r_len))
 			goto nack_inv;
-		hfi1_copy_sge(&qp->r_sge, data, pmtu, 1);
+		hfi1_copy_sge(&qp->r_sge, data, pmtu, 1, 0);
 		break;
 
 	case OP(RDMA_WRITE_LAST_WITH_IMMEDIATE):
@@ -2109,8 +2110,10 @@ send_last_imm:
 		wc.ex.imm_data = ohdr->u.imm_data;
 		wc.wc_flags = IB_WC_WITH_IMM;
 		goto send_last;
-	case OP(SEND_LAST):
 	case OP(RDMA_WRITE_LAST):
+		copy_last = ibpd_to_rvtpd(qp->ibqp.pd)->user;
+		/* fall through */
+	case OP(SEND_LAST):
 no_immediate_data:
 		wc.wc_flags = 0;
 		wc.ex.imm_data = 0;
@@ -2126,7 +2129,7 @@ send_last:
 		wc.byte_len = tlen + qp->r_rcv_len;
 		if (unlikely(wc.byte_len > qp->r_len))
 			goto nack_inv;
-		hfi1_copy_sge(&qp->r_sge, data, tlen, 1);
+		hfi1_copy_sge(&qp->r_sge, data, tlen, 1, copy_last);
 		rvt_put_ss(&qp->r_sge);
 		qp->r_msn++;
 		if (!test_and_clear_bit(RVT_R_WRID_VALID, &qp->r_aflags))
@@ -2163,8 +2166,10 @@ send_last:
 			     (bth0 & IB_BTH_SOLICITED) != 0);
 		break;
 
-	case OP(RDMA_WRITE_FIRST):
 	case OP(RDMA_WRITE_ONLY):
+		copy_last = 1;
+		/* fall through */
+	case OP(RDMA_WRITE_FIRST):
 	case OP(RDMA_WRITE_ONLY_WITH_IMMEDIATE):
 		if (unlikely(!(qp->qp_access_flags & IB_ACCESS_REMOTE_WRITE)))
 			goto nack_inv;
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index f09badb..6aeea6c 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -370,6 +370,7 @@ static void ruc_loopback(struct rvt_qp *sqp)
 	enum ib_wc_status send_status;
 	int release;
 	int ret;
+	int copy_last = 0;
 
 	rcu_read_lock();
 
@@ -459,10 +460,13 @@ again:
 			goto op_err;
 		if (!ret)
 			goto rnr_nak;
-		/* FALLTHROUGH */
+		/* skip copy_last set and qp_access_flags recheck */
+		goto do_write;
 	case IB_WR_RDMA_WRITE:
+		copy_last = ibpd_to_rvtpd(qp->ibqp.pd)->user;
 		if (unlikely(!(qp->qp_access_flags & IB_ACCESS_REMOTE_WRITE)))
 			goto inv_err;
+do_write:
 		if (wqe->length == 0)
 		if (unlikely(!rvt_rkey_ok(qp, &qp->r_sge.sge, wqe->length,
 					  wqe->rdma_wr.remote_addr,
@@ -526,7 +530,7 @@ again:
 		if (len > sge->sge_length)
 			len = sge->sge_length;
 		WARN_ON_ONCE(len == 0);
-		hfi1_copy_sge(&qp->r_sge, sge->vaddr, len, release);
+		hfi1_copy_sge(&qp->r_sge, sge->vaddr, len, release, copy_last);
 		sge->vaddr += len;
 		sge->length -= len;
 		sge->sge_length -= len;
diff --git a/drivers/staging/rdma/hfi1/uc.c b/drivers/staging/rdma/hfi1/uc.c
index 1e50d30..0aa604b 100644
--- a/drivers/staging/rdma/hfi1/uc.c
+++ b/drivers/staging/rdma/hfi1/uc.c
@@ -418,7 +418,7 @@ send_first:
 		qp->r_rcv_len += pmtu;
 		if (unlikely(qp->r_rcv_len > qp->r_len))
 			goto rewind;
-		hfi1_copy_sge(&qp->r_sge, data, pmtu, 0);
+		hfi1_copy_sge(&qp->r_sge, data, pmtu, 0, 0);
 		break;
 
 	case OP(SEND_LAST_WITH_IMMEDIATE):
@@ -443,7 +443,7 @@ send_last:
 		if (unlikely(wc.byte_len > qp->r_len))
 			goto rewind;
 		wc.opcode = IB_WC_RECV;
-		hfi1_copy_sge(&qp->r_sge, data, tlen, 0);
+		hfi1_copy_sge(&qp->r_sge, data, tlen, 0, 0);
 		rvt_put_ss(&qp->s_rdma_read_sge);
 last_imm:
 		wc.wr_id = qp->r_wr_id;
@@ -518,7 +518,7 @@ rdma_first:
 		qp->r_rcv_len += pmtu;
 		if (unlikely(qp->r_rcv_len > qp->r_len))
 			goto drop;
-		hfi1_copy_sge(&qp->r_sge, data, pmtu, 1);
+		hfi1_copy_sge(&qp->r_sge, data, pmtu, 1, 0);
 		break;
 
 	case OP(RDMA_WRITE_LAST_WITH_IMMEDIATE):
@@ -547,7 +547,7 @@ rdma_last_imm:
 		}
 		wc.byte_len = qp->r_len;
 		wc.opcode = IB_WC_RECV_RDMA_WITH_IMM;
-		hfi1_copy_sge(&qp->r_sge, data, tlen, 1);
+		hfi1_copy_sge(&qp->r_sge, data, tlen, 1, 0);
 		rvt_put_ss(&qp->r_sge);
 		goto last_imm;
 
@@ -563,7 +563,7 @@ rdma_last:
 		tlen -= (hdrsize + pad + 4);
 		if (unlikely(tlen + qp->r_rcv_len != qp->r_len))
 			goto drop;
-		hfi1_copy_sge(&qp->r_sge, data, tlen, 1);
+		hfi1_copy_sge(&qp->r_sge, data, tlen, 1, 0);
 		rvt_put_ss(&qp->r_sge);
 		break;
 
diff --git a/drivers/staging/rdma/hfi1/ud.c b/drivers/staging/rdma/hfi1/ud.c
index 2eae167..fdf6e3b 100644
--- a/drivers/staging/rdma/hfi1/ud.c
+++ b/drivers/staging/rdma/hfi1/ud.c
@@ -187,7 +187,7 @@ static void ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 
 	if (ah_attr->ah_flags & IB_AH_GRH) {
 		hfi1_copy_sge(&qp->r_sge, &ah_attr->grh,
-			      sizeof(struct ib_grh), 1);
+			      sizeof(struct ib_grh), 1, 0);
 		wc.wc_flags |= IB_WC_GRH;
 	} else
 		hfi1_skip_sge(&qp->r_sge, sizeof(struct ib_grh), 1);
@@ -203,7 +203,7 @@ static void ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 		if (len > sge->sge_length)
 			len = sge->sge_length;
 		WARN_ON_ONCE(len == 0);
-		hfi1_copy_sge(&qp->r_sge, sge->vaddr, len, 1);
+		hfi1_copy_sge(&qp->r_sge, sge->vaddr, len, 1, 0);
 		sge->vaddr += len;
 		sge->length -= len;
 		sge->sge_length -= len;
@@ -836,11 +836,12 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 	}
 	if (has_grh) {
 		hfi1_copy_sge(&qp->r_sge, &hdr->u.l.grh,
-			      sizeof(struct ib_grh), 1);
+			      sizeof(struct ib_grh), 1, 0);
 		wc.wc_flags |= IB_WC_GRH;
 	} else
 		hfi1_skip_sge(&qp->r_sge, sizeof(struct ib_grh), 1);
-	hfi1_copy_sge(&qp->r_sge, data, wc.byte_len - sizeof(struct ib_grh), 1);
+	hfi1_copy_sge(&qp->r_sge, data, wc.byte_len - sizeof(struct ib_grh),
+		      1, 0);
 	rvt_put_ss(&qp->r_sge);
 	if (!test_and_clear_bit(RVT_R_WRID_VALID, &qp->r_aflags))
 		return;
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index d617324..8f351bc 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -242,14 +242,28 @@ __be64 ib_hfi1_sys_image_guid;
  * @ss: the SGE state
  * @data: the data to copy
  * @length: the length of the data
+ * @copy_last: do a separate copy of the last 8 bytes
  */
 void hfi1_copy_sge(
 	struct rvt_sge_state *ss,
 	void *data, u32 length,
-	int release)
+	int release,
+	int copy_last)
 {
 	struct rvt_sge *sge = &ss->sge;
+	int in_last = 0;
+	int i;
+
+	if (copy_last) {
+		if (length > 8) {
+			length -= 8;
+		} else {
+			copy_last = 0;
+			in_last = 1;
+		}
+	}
 
+again:
 	while (length) {
 		u32 len = sge->length;
 
@@ -258,7 +272,13 @@ void hfi1_copy_sge(
 		if (len > sge->sge_length)
 			len = sge->sge_length;
 		WARN_ON_ONCE(len == 0);
-		memcpy(sge->vaddr, data, len);
+		if (in_last) {
+			/* enforce byte transer ordering */
+			for (i = 0; i < len; i++)
+				((u8 *)sge->vaddr)[i] = ((u8 *)data)[i];
+		} else {
+			memcpy(sge->vaddr, data, len);
+		}
 		sge->vaddr += len;
 		sge->length -= len;
 		sge->sge_length -= len;
@@ -281,6 +301,13 @@ void hfi1_copy_sge(
 		data += len;
 		length -= len;
 	}
+
+	if (copy_last) {
+		copy_last = 0;
+		in_last = 1;
+		length = 8;
+		goto again;
+	}
 }
 
 /**
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index ac84dd7..afb2d7f 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -398,7 +398,7 @@ void hfi1_put_txreq(struct verbs_txreq *tx);
 int hfi1_verbs_send(struct rvt_qp *qp, struct hfi1_pkt_state *ps);
 
 void hfi1_copy_sge(struct rvt_sge_state *ss, void *data, u32 length,
-		   int release);
+		   int release, int copy_last);
 
 void hfi1_skip_sge(struct rvt_sge_state *ss, u32 length, int release);
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
