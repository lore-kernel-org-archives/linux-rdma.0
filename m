From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 02/15] IB/hfi1,
 IB/rdmavt: Move r_adefered to r_lock cache line
Date: Tue, 02 May 2017 17:41:11 -0700
Message-ID: <20170503004110.6965.94767.stgit@scvm10.sc.intel.com>
References: <20170503003734.6965.67405.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170503003734.6965.67405.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This field is causing excessive cache line bouncing.

There are spare bytes in the r_lock cache line so the best approach
is to make an rvt QP field and remove from the hfi1 priv field.

Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/qp.c    |    4 +---
 drivers/infiniband/hw/hfi1/rc.c    |   13 ++++---------
 drivers/infiniband/hw/hfi1/verbs.h |    1 -
 include/rdma/rdmavt_qp.h           |    1 +
 4 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index 4573e4c..650305c 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -731,9 +731,7 @@ void quiesce_qp(struct rvt_qp *qp)
 
 void notify_qp_reset(struct rvt_qp *qp)
 {
-	struct hfi1_qp_priv *priv = qp->priv;
-
-	priv->r_adefered = 0;
+	qp->r_adefered = 0;
 	clear_ahg(qp);
 }
 
diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 75a729c..069bdaf 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -727,10 +727,9 @@ void hfi1_send_rc_ack(struct hfi1_ctxtdata *rcd, struct rvt_qp *qp,
 	struct ib_header hdr;
 	struct ib_other_headers *ohdr;
 	unsigned long flags;
-	struct hfi1_qp_priv *priv = qp->priv;
 
 	/* clear the defer count */
-	priv->r_adefered = 0;
+	qp->r_adefered = 0;
 
 	/* Don't send ACK or NAK if a RDMA read or atomic is pending. */
 	if (qp->s_flags & RVT_S_RESP_PENDING)
@@ -1604,9 +1603,7 @@ static inline void rc_defered_ack(struct hfi1_ctxtdata *rcd,
 
 static inline void rc_cancel_ack(struct rvt_qp *qp)
 {
-	struct hfi1_qp_priv *priv = qp->priv;
-
-	priv->r_adefered = 0;
+	qp->r_adefered = 0;
 	if (list_empty(&qp->rspwait))
 		return;
 	list_del_init(&qp->rspwait);
@@ -2314,13 +2311,11 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 	qp->r_nak_state = 0;
 	/* Send an ACK if requested or required. */
 	if (psn & IB_BTH_REQ_ACK) {
-		struct hfi1_qp_priv *priv = qp->priv;
-
 		if (packet->numpkt == 0) {
 			rc_cancel_ack(qp);
 			goto send_ack;
 		}
-		if (priv->r_adefered >= HFI1_PSN_CREDIT) {
+		if (qp->r_adefered >= HFI1_PSN_CREDIT) {
 			rc_cancel_ack(qp);
 			goto send_ack;
 		}
@@ -2328,7 +2323,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 			rc_cancel_ack(qp);
 			goto send_ack;
 		}
-		priv->r_adefered++;
+		qp->r_adefered++;
 		rc_defered_ack(rcd, qp);
 	}
 	return;
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index 52ff275..c0913c6 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -125,7 +125,6 @@ struct hfi1_qp_priv {
 	struct sdma_engine *s_sde;                /* current sde */
 	struct send_context *s_sendcontext;       /* current sendcontext */
 	u8 s_sc;		                  /* SC[0..4] for next packet */
-	u8 r_adefered;                            /* number of acks defered */
 	struct iowait s_iowait;
 	struct rvt_qp *owner;
 };
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index 1d8141a..be6472e 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -324,6 +324,7 @@ struct rvt_qp {
 	u8 r_state;             /* opcode of last packet received */
 	u8 r_flags;
 	u8 r_head_ack_queue;    /* index into s_ack_queue[] */
+	u8 r_adefered;          /* defered ack count */
 
 	struct list_head rspwait;       /* link for waiting to respond */
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
