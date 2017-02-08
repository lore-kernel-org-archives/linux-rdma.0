From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 18/27] IB/hfi1,
 rdmavt: Move SGE state helper routines into rdmavt
Date: Wed, 08 Feb 2017 05:27:37 -0800
Message-ID: <20170208132736.16442.1665.stgit@scvm10.sc.intel.com>
References: <20170208132142.16442.69329.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170208132142.16442.69329.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

To improve code reuse, add small SGE state helper routines to rdmavt_mr.h.
Leverage these in hfi1, including refactoring of hfi1_copy_sge.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/hfi.h   |    2 -
 drivers/infiniband/hw/hfi1/rc.c    |    2 -
 drivers/infiniband/hw/hfi1/ud.c    |    4 +-
 drivers/infiniband/hw/hfi1/verbs.c |   91 ++----------------------------------
 drivers/infiniband/hw/hfi1/verbs.h |    2 -
 include/rdma/rdmavt_mr.h           |   50 ++++++++++++++++++++
 6 files changed, 57 insertions(+), 94 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index fcfd5f1..9c3be91 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1797,8 +1797,6 @@ static inline void flush_wc(void)
 int kdeth_process_eager(struct hfi1_packet *packet);
 int process_receive_invalid(struct hfi1_packet *packet);
 
-void update_sge(struct rvt_sge_state *ss, u32 length);
-
 /* global module parameter variables */
 extern unsigned int hfi1_max_mtu;
 extern unsigned int hfi1_cu;
diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index b1c350d..85e7bf6 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -67,7 +67,7 @@ static u32 restart_sge(struct rvt_sge_state *ss, struct rvt_swqe *wqe,
 	ss->sg_list = wqe->sg_list + 1;
 	ss->num_sge = wqe->wr.num_sge;
 	ss->total_len = wqe->length;
-	hfi1_skip_sge(ss, len, false);
+	rvt_skip_sge(ss, len, false);
 	return wqe->length - len;
 }
 
diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index 9329c16..13ea4eb 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -192,7 +192,7 @@ static void ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 			      sizeof(grh), true, false);
 		wc.wc_flags |= IB_WC_GRH;
 	} else {
-		hfi1_skip_sge(&qp->r_sge, sizeof(struct ib_grh), true);
+		rvt_skip_sge(&qp->r_sge, sizeof(struct ib_grh), true);
 	}
 	ssge.sg_list = swqe->sg_list + 1;
 	ssge.sge = *swqe->sg_list;
@@ -815,7 +815,7 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 			      sizeof(struct ib_grh), true, false);
 		wc.wc_flags |= IB_WC_GRH;
 	} else {
-		hfi1_skip_sge(&qp->r_sge, sizeof(struct ib_grh), true);
+		rvt_skip_sge(&qp->r_sge, sizeof(struct ib_grh), true);
 	}
 	hfi1_copy_sge(&qp->r_sge, data, wc.byte_len - sizeof(struct ib_grh),
 		      true, false);
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index b10c2dc..72f459e 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -462,12 +462,8 @@ void hfi1_copy_sge(
 
 again:
 	while (length) {
-		u32 len = sge->length;
+		u32 len = rvt_get_sge_length(sge, length);
 
-		if (len > length)
-			len = length;
-		if (len > sge->sge_length)
-			len = sge->sge_length;
 		WARN_ON_ONCE(len == 0);
 		if (unlikely(in_last)) {
 			/* enforce byte transfer ordering */
@@ -478,25 +474,7 @@ void hfi1_copy_sge(
 		} else {
 			memcpy(sge->vaddr, data, len);
 		}
-		sge->vaddr += len;
-		sge->length -= len;
-		sge->sge_length -= len;
-		if (sge->sge_length == 0) {
-			if (release)
-				rvt_put_mr(sge->mr);
-			if (--ss->num_sge)
-				*sge = *ss->sg_list++;
-		} else if (sge->length == 0 && sge->mr->lkey) {
-			if (++sge->n >= RVT_SEGSZ) {
-				if (++sge->m >= sge->mr->mapsz)
-					break;
-				sge->n = 0;
-			}
-			sge->vaddr =
-				sge->mr->map[sge->m]->segs[sge->n].vaddr;
-			sge->length =
-				sge->mr->map[sge->m]->segs[sge->n].length;
-		}
+		rvt_update_sge(ss, len, release);
 		data += len;
 		length -= len;
 	}
@@ -509,46 +487,6 @@ void hfi1_copy_sge(
 	}
 }
 
-/**
- * hfi1_skip_sge - skip over SGE memory
- * @ss: the SGE state
- * @length: the number of bytes to skip
- */
-void hfi1_skip_sge(struct rvt_sge_state *ss, u32 length, bool release)
-{
-	struct rvt_sge *sge = &ss->sge;
-
-	while (length) {
-		u32 len = sge->length;
-
-		if (len > length)
-			len = length;
-		if (len > sge->sge_length)
-			len = sge->sge_length;
-		WARN_ON_ONCE(len == 0);
-		sge->vaddr += len;
-		sge->length -= len;
-		sge->sge_length -= len;
-		if (sge->sge_length == 0) {
-			if (release)
-				rvt_put_mr(sge->mr);
-			if (--ss->num_sge)
-				*sge = *ss->sg_list++;
-		} else if (sge->length == 0 && sge->mr->lkey) {
-			if (++sge->n >= RVT_SEGSZ) {
-				if (++sge->m >= sge->mr->mapsz)
-					break;
-				sge->n = 0;
-			}
-			sge->vaddr =
-				sge->mr->map[sge->m]->segs[sge->n].vaddr;
-			sge->length =
-				sge->mr->map[sge->m]->segs[sge->n].length;
-		}
-		length -= len;
-	}
-}
-
 /*
  * Make sure the QP is ready and able to accept the given opcode.
  */
@@ -690,27 +628,6 @@ static void mem_timer(unsigned long data)
 		hfi1_qp_wakeup(qp, RVT_S_WAIT_KMEM);
 }
 
-void update_sge(struct rvt_sge_state *ss, u32 length)
-{
-	struct rvt_sge *sge = &ss->sge;
-
-	sge->vaddr += length;
-	sge->length -= length;
-	sge->sge_length -= length;
-	if (sge->sge_length == 0) {
-		if (--ss->num_sge)
-			*sge = *ss->sg_list++;
-	} else if (sge->length == 0 && sge->mr->lkey) {
-		if (++sge->n >= RVT_SEGSZ) {
-			if (++sge->m >= sge->mr->mapsz)
-				return;
-			sge->n = 0;
-		}
-		sge->vaddr = sge->mr->map[sge->m]->segs[sge->n].vaddr;
-		sge->length = sge->mr->map[sge->m]->segs[sge->n].length;
-	}
-}
-
 /*
  * This is called with progress side lock held.
  */
@@ -799,7 +716,7 @@ static noinline int build_verbs_ulp_payload(
 			len);
 		if (ret)
 			goto bail_txadd;
-		update_sge(ss, len);
+		rvt_update_sge(ss, len, false);
 		length -= len;
 	}
 	return ret;
@@ -1074,7 +991,7 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 
 				if (slen > len)
 					slen = len;
-				update_sge(ss, slen);
+				rvt_update_sge(ss, slen, false);
 				seg_pio_copy_mid(pbuf, addr, slen);
 				len -= slen;
 			}
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index 9fab6b3..3a0b589 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -291,8 +291,6 @@ static inline u32 delta_psn(u32 a, u32 b)
 void hfi1_copy_sge(struct rvt_sge_state *ss, void *data, u32 length,
 		   bool release, bool copy_last);
 
-void hfi1_skip_sge(struct rvt_sge_state *ss, u32 length, bool release);
-
 void hfi1_cnp_rcv(struct hfi1_packet *packet);
 
 void hfi1_uc_rcv(struct hfi1_packet *packet);
diff --git a/include/rdma/rdmavt_mr.h b/include/rdma/rdmavt_mr.h
index 05698d8..f418bd5 100644
--- a/include/rdma/rdmavt_mr.h
+++ b/include/rdma/rdmavt_mr.h
@@ -141,4 +141,54 @@ static inline void rvt_put_ss(struct rvt_sge_state *ss)
 	}
 }
 
+static inline u32 rvt_get_sge_length(struct rvt_sge *sge, u32 length)
+{
+	u32 len = sge->length;
+
+	if (len > length)
+		len = length;
+	if (len > sge->sge_length)
+		len = sge->sge_length;
+
+	return len;
+}
+
+static inline void rvt_update_sge(struct rvt_sge_state *ss, u32 length,
+				  bool release)
+{
+	struct rvt_sge *sge = &ss->sge;
+
+	sge->vaddr += length;
+	sge->length -= length;
+	sge->sge_length -= length;
+	if (sge->sge_length == 0) {
+		if (release)
+			rvt_put_mr(sge->mr);
+		if (--ss->num_sge)
+			*sge = *ss->sg_list++;
+	} else if (sge->length == 0 && sge->mr->lkey) {
+		if (++sge->n >= RVT_SEGSZ) {
+			if (++sge->m >= sge->mr->mapsz)
+				return;
+			sge->n = 0;
+		}
+		sge->vaddr = sge->mr->map[sge->m]->segs[sge->n].vaddr;
+		sge->length = sge->mr->map[sge->m]->segs[sge->n].length;
+	}
+}
+
+static inline void rvt_skip_sge(struct rvt_sge_state *ss, u32 length,
+				bool release)
+{
+	struct rvt_sge *sge = &ss->sge;
+
+	while (length) {
+		u32 len = rvt_get_sge_length(sge, length);
+
+		WARN_ON_ONCE(len == 0);
+		rvt_update_sge(ss, len, release);
+		length -= len;
+	}
+}
+
 #endif          /* DEF_RDMAVT_INCMRH */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
