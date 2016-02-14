From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 06/16] staging/rdma/hfi1: Add s_sendcontext priv field
Date: Sun, 14 Feb 2016 12:45:00 -0800
Message-ID: <20160214204457.29247.20311.stgit@scvm10.sc.intel.com>
References: <20160214203612.29247.59915.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160214203612.29247.59915.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

s_sendcontext will be used to map the QPs to the send contexts
for PIO.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/qp.c    |   13 +++++++++++--
 drivers/staging/rdma/hfi1/ud.c    |    1 +
 drivers/staging/rdma/hfi1/verbs.h |    9 +++++----
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index 129a70d..b81dc50 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -191,6 +191,9 @@ int hfi1_check_modify_qp(struct rvt_qp *qp, struct ib_qp_attr *attr,
 		if (!qp_to_sdma_engine(qp, sc) &&
 		    dd->flags & HFI1_HAS_SEND_DMA)
 			return -EINVAL;
+
+		if (!qp_to_send_context(qp, sc))
+			return -EINVAL;
 	}
 
 	if (attr_mask & IB_QP_ALT_PATH) {
@@ -201,6 +204,9 @@ int hfi1_check_modify_qp(struct rvt_qp *qp, struct ib_qp_attr *attr,
 		if (!qp_to_sdma_engine(qp, sc) &&
 		    dd->flags & HFI1_HAS_SEND_DMA)
 			return -EINVAL;
+
+		if (!qp_to_send_context(qp, sc))
+			return -EINVAL;
 	}
 
 	return 0;
@@ -608,11 +614,13 @@ void qp_iter_print(struct seq_file *s, struct qp_iter *iter)
 	struct rvt_qp *qp = iter->qp;
 	struct hfi1_qp_priv *priv = qp->priv;
 	struct sdma_engine *sde;
+	struct send_context *send_context;
 
 	sde = qp_to_sdma_engine(qp, priv->s_sc);
 	wqe = rvt_get_swqe_ptr(qp, qp->s_last);
+	send_context = qp_to_send_context(qp, priv->s_sc);
 	seq_printf(s,
-		   "N %d %s QP%u R %u %s %u %u %u f=%x %u %u %u %u %u PSN %x %x %x %x %x (%u %u %u %u %u %u %u) QP%u LID %x SL %u MTU %u %u %u %u SDE %p,%u\n",
+		   "N %d %s QP%u R %u %s %u %u %u f=%x %u %u %u %u %u PSN %x %x %x %x %x (%u %u %u %u %u %u %u) QP%u LID %x SL %u MTU %u %u %u %u SDE %p,%u SC %p\n",
 		   iter->n,
 		   qp_idle(qp) ? "I" : "B",
 		   qp->ibqp.qp_num,
@@ -641,7 +649,8 @@ void qp_iter_print(struct seq_file *s, struct qp_iter *iter)
 		   qp->s_retry_cnt,
 		   qp->s_rnr_retry_cnt,
 		   sde,
-		   sde ? sde->this_idx : 0);
+		   sde ? sde->this_idx : 0,
+		   send_context);
 }
 
 void qp_comm_est(struct rvt_qp *qp)
diff --git a/drivers/staging/rdma/hfi1/ud.c b/drivers/staging/rdma/hfi1/ud.c
index a7118bc..1b4b191 100644
--- a/drivers/staging/rdma/hfi1/ud.c
+++ b/drivers/staging/rdma/hfi1/ud.c
@@ -394,6 +394,7 @@ int hfi1_make_ud_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 		priv->s_sc = sc5;
 	}
 	priv->s_sde = qp_to_sdma_engine(qp, priv->s_sc);
+	priv->s_sendcontext = qp_to_send_context(qp, priv->s_sc);
 	ps->s_txreq->phdr.hdr.lrh[0] = cpu_to_be16(lrh0);
 	ps->s_txreq->phdr.hdr.lrh[1] = cpu_to_be16(ah_attr->dlid);
 	ps->s_txreq->phdr.hdr.lrh[2] =
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index 73f471a..3d25ad4 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -199,10 +199,11 @@ struct hfi1_pio_header {
  * pair is made common
  */
 struct hfi1_qp_priv {
-	struct ahg_ib_header *s_hdr; /* next packet header to send */
-	struct sdma_engine *s_sde;   /* current sde */
-	u8 s_sc;		     /* SC[0..4] for next packet */
-	u8 r_adefered;               /* number of acks defered */
+	struct ahg_ib_header *s_hdr;              /* next header to send */
+	struct sdma_engine *s_sde;                /* current sde */
+	struct send_context *s_sendcontext;       /* current sendcontext */
+	u8 s_sc;		                  /* SC[0..4] for next packet */
+	u8 r_adefered;                            /* number of acks defered */
 	struct iowait s_iowait;
 	struct timer_list s_rnr_timer;
 	struct rvt_qp *owner;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
