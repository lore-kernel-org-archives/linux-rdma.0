From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 19/27] IB/qib: Updates to use rdmavt's SGE helper routines
Date: Wed, 08 Feb 2017 05:27:43 -0800
Message-ID: <20170208132742.16442.23226.stgit@scvm10.sc.intel.com>
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

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_rc.c    |    2 -
 drivers/infiniband/hw/qib/qib_ud.c    |    4 +
 drivers/infiniband/hw/qib/qib_verbs.c |   95 ++-------------------------------
 drivers/infiniband/hw/qib/qib_verbs.h |    2 -
 4 files changed, 9 insertions(+), 94 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index ea0bc6b..d712043 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -49,7 +49,7 @@ static u32 restart_sge(struct rvt_sge_state *ss, struct rvt_swqe *wqe,
 	ss->sg_list = wqe->sg_list + 1;
 	ss->num_sge = wqe->wr.num_sge;
 	ss->total_len = wqe->length;
-	qib_skip_sge(ss, len, 0);
+	rvt_skip_sge(ss, len, false);
 	return wqe->length - len;
 }
 
diff --git a/drivers/infiniband/hw/qib/qib_ud.c b/drivers/infiniband/hw/qib/qib_ud.c
index 04befa2..ddd4e74 100644
--- a/drivers/infiniband/hw/qib/qib_ud.c
+++ b/drivers/infiniband/hw/qib/qib_ud.c
@@ -177,7 +177,7 @@ static void qib_ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 			     sizeof(grh), 1);
 		wc.wc_flags |= IB_WC_GRH;
 	} else
-		qib_skip_sge(&qp->r_sge, sizeof(struct ib_grh), 1);
+		rvt_skip_sge(&qp->r_sge, sizeof(struct ib_grh), true);
 	ssge.sg_list = swqe->sg_list + 1;
 	ssge.sge = *swqe->sg_list;
 	ssge.num_sge = swqe->wr.num_sge;
@@ -567,7 +567,7 @@ void qib_ud_rcv(struct qib_ibport *ibp, struct ib_header *hdr,
 			     sizeof(struct ib_grh), 1);
 		wc.wc_flags |= IB_WC_GRH;
 	} else
-		qib_skip_sge(&qp->r_sge, sizeof(struct ib_grh), 1);
+		rvt_skip_sge(&qp->r_sge, sizeof(struct ib_grh), true);
 	qib_copy_sge(&qp->r_sge, data, wc.byte_len - sizeof(struct ib_grh), 1);
 	rvt_put_ss(&qp->r_sge);
 	if (!test_and_clear_bit(RVT_R_WRID_VALID, &qp->r_aflags))
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index ee7741e..b0b78e1 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -129,78 +129,16 @@ void qib_copy_sge(struct rvt_sge_state *ss, void *data, u32 length, int release)
 	struct rvt_sge *sge = &ss->sge;
 
 	while (length) {
-		u32 len = sge->length;
+		u32 len = rvt_get_sge_length(sge, length);
 
-		if (len > length)
-			len = length;
-		if (len > sge->sge_length)
-			len = sge->sge_length;
-		BUG_ON(len == 0);
+		WARN_ON_ONCE(len == 0);
 		memcpy(sge->vaddr, data, len);
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
 }
 
-/**
- * qib_skip_sge - skip over SGE memory - XXX almost dup of prev func
- * @ss: the SGE state
- * @length: the number of bytes to skip
- */
-void qib_skip_sge(struct rvt_sge_state *ss, u32 length, int release)
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
-		BUG_ON(len == 0);
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
  * Count the number of DMA descriptors needed to send length bytes of data.
  * Don't modify the qib_sge_state to get the count.
@@ -468,27 +406,6 @@ static void mem_timer(unsigned long data)
 	}
 }
 
-static void update_sge(struct rvt_sge_state *ss, u32 length)
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
 #ifdef __LITTLE_ENDIAN
 static inline u32 get_upper_bits(u32 data, u32 shift)
 {
@@ -646,11 +563,11 @@ static void copy_io(u32 __iomem *piobuf, struct rvt_sge_state *ss,
 				data = clear_upper_bytes(v, extra, 0);
 			}
 		}
-		update_sge(ss, len);
+		rvt_update_sge(ss, len, false);
 		length -= len;
 	}
 	/* Update address before sending packet. */
-	update_sge(ss, length);
+	rvt_update_sge(ss, length, false);
 	if (flush_wc) {
 		/* must flush early everything before trigger word */
 		qib_flush_wc();
@@ -1069,7 +986,7 @@ static int qib_verbs_send_pio(struct rvt_qp *qp, struct ib_header *ibhdr,
 		u32 *addr = (u32 *) ss->sge.vaddr;
 
 		/* Update address before sending packet. */
-		update_sge(ss, len);
+		rvt_update_sge(ss, len, false);
 		if (flush_wc) {
 			qib_pio_copy(piobuf, addr, dwords - 1);
 			/* must flush early everything before trigger word */
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index 1bdfa1c..212e8ce 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -304,8 +304,6 @@ int qib_verbs_send(struct rvt_qp *qp, struct ib_header *hdr,
 void qib_copy_sge(struct rvt_sge_state *ss, void *data, u32 length,
 		  int release);
 
-void qib_skip_sge(struct rvt_sge_state *ss, u32 length, int release);
-
 void qib_uc_rcv(struct qib_ibport *ibp, struct ib_header *hdr,
 		int has_grh, void *data, u32 tlen, struct rvt_qp *qp);
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
