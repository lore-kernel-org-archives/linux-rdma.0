From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/17] rdma/core: Add XRX QPs
Date: Wed, 15 Jun 2011 06:28:03 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237302100B@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

XRC communication is between an initiator (INI) QP and a target
(TGT) QP.  Target QPs are associated with SRQs through an XRCD.
An XRC TGT QP behaves like a receive-only RD QP.  XRC INI QPs
behave similar to an RC QP, except that work requests posted to
an XRC INI QP must specify the remote SRQ that is the target
of the work request.

We define two new QP types for XRC, to distinguish between
INI and TGT QPs, and update the core layer to support XRC QPs.

This patch is derived from work by Jack Morgenstein
<jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c |  145 ++++++++++++++++++++++++++++++++++-----
 include/rdma/ib_verbs.h         |    5 +
 2 files changed, 132 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 25c1c1e..52d36c8 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -320,24 +320,43 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 			   struct ib_qp_init_attr *qp_init_attr)
 {
 	struct ib_qp *qp;
+	struct ib_device *device;
 
-	qp = pd->device->create_qp(pd, qp_init_attr, NULL);
+	device = pd ? pd->device : qp_init_attr->xrcd->device;
+	qp = device->create_qp(pd, qp_init_attr, NULL);
 
 	if (!IS_ERR(qp)) {
-		qp->device     	  = pd->device;
-		qp->pd         	  = pd;
-		qp->send_cq    	  = qp_init_attr->send_cq;
-		qp->recv_cq    	  = qp_init_attr->recv_cq;
-		qp->srq	       	  = qp_init_attr->srq;
+		qp->device = device;
+
+		if (qp_init_attr->qp_type == IB_QPT_XRC_TGT) {
+			qp->pd = NULL;
+			qp->send_cq = qp->recv_cq = NULL;
+			qp->srq = NULL;
+			qp->xrcd = qp_init_attr->xrcd;
+			atomic_inc(&qp_init_attr->xrcd->usecnt);
+		} else {
+			if (qp_init_attr->qp_type == IB_QPT_XRC_INI) {
+				qp->recv_cq = NULL;
+				qp->srq = NULL;
+			} else {
+				qp->recv_cq = qp_init_attr->recv_cq;
+				atomic_inc(&qp_init_attr->recv_cq->usecnt);
+				if ((qp->srq = qp_init_attr->srq))
+					atomic_inc(&qp_init_attr->srq->usecnt);
+			}
+
+			qp->pd	    = pd;
+			qp->send_cq = qp_init_attr->send_cq;
+			qp->xrcd    = NULL;
+
+			atomic_inc(&pd->usecnt);
+			atomic_inc(&qp_init_attr->send_cq->usecnt);
+		}
+
 		qp->uobject       = NULL;
 		qp->event_handler = qp_init_attr->event_handler;
 		qp->qp_context    = qp_init_attr->qp_context;
 		qp->qp_type	  = qp_init_attr->qp_type;
-		atomic_inc(&pd->usecnt);
-		atomic_inc(&qp_init_attr->send_cq->usecnt);
-		atomic_inc(&qp_init_attr->recv_cq->usecnt);
-		if (qp_init_attr->srq)
-			atomic_inc(&qp_init_attr->srq->usecnt);
 	}
 
 	return qp;
@@ -363,6 +382,12 @@ static const struct {
 				[IB_QPT_RC]  = (IB_QP_PKEY_INDEX		|
 						IB_QP_PORT			|
 						IB_QP_ACCESS_FLAGS),
+				[IB_QPT_XRC_INI] = (IB_QP_PKEY_INDEX		|
+						IB_QP_PORT			|
+						IB_QP_ACCESS_FLAGS),
+				[IB_QPT_XRC_TGT] = (IB_QP_PKEY_INDEX		|
+						IB_QP_PORT			|
+						IB_QP_ACCESS_FLAGS),
 				[IB_QPT_SMI] = (IB_QP_PKEY_INDEX		|
 						IB_QP_QKEY),
 				[IB_QPT_GSI] = (IB_QP_PKEY_INDEX		|
@@ -385,6 +410,12 @@ static const struct {
 				[IB_QPT_RC]  = (IB_QP_PKEY_INDEX		|
 						IB_QP_PORT			|
 						IB_QP_ACCESS_FLAGS),
+				[IB_QPT_XRC_INI] = (IB_QP_PKEY_INDEX		|
+						IB_QP_PORT			|
+						IB_QP_ACCESS_FLAGS),
+				[IB_QPT_XRC_TGT] = (IB_QP_PKEY_INDEX		|
+						IB_QP_PORT			|
+						IB_QP_ACCESS_FLAGS),
 				[IB_QPT_SMI] = (IB_QP_PKEY_INDEX		|
 						IB_QP_QKEY),
 				[IB_QPT_GSI] = (IB_QP_PKEY_INDEX		|
@@ -404,6 +435,16 @@ static const struct {
 						IB_QP_RQ_PSN			|
 						IB_QP_MAX_DEST_RD_ATOMIC	|
 						IB_QP_MIN_RNR_TIMER),
+				[IB_QPT_XRC_INI] = (IB_QP_AV			|
+						IB_QP_PATH_MTU			|
+						IB_QP_DEST_QPN			|
+						IB_QP_RQ_PSN),
+				[IB_QPT_XRC_TGT] = (IB_QP_AV			|
+						IB_QP_PATH_MTU			|
+						IB_QP_DEST_QPN			|
+						IB_QP_RQ_PSN			|
+						IB_QP_MAX_DEST_RD_ATOMIC	|
+						IB_QP_MIN_RNR_TIMER),
 			},
 			.opt_param = {
 				 [IB_QPT_UD]  = (IB_QP_PKEY_INDEX		|
@@ -414,6 +455,12 @@ static const struct {
 				 [IB_QPT_RC]  = (IB_QP_ALT_PATH			|
 						 IB_QP_ACCESS_FLAGS		|
 						 IB_QP_PKEY_INDEX),
+				 [IB_QPT_XRC_INI] = (IB_QP_ALT_PATH		|
+						 IB_QP_ACCESS_FLAGS		|
+						 IB_QP_PKEY_INDEX),
+				 [IB_QPT_XRC_TGT] = (IB_QP_ALT_PATH		|
+						 IB_QP_ACCESS_FLAGS		|
+						 IB_QP_PKEY_INDEX),
 				 [IB_QPT_SMI] = (IB_QP_PKEY_INDEX		|
 						 IB_QP_QKEY),
 				 [IB_QPT_GSI] = (IB_QP_PKEY_INDEX		|
@@ -434,6 +481,13 @@ static const struct {
 						IB_QP_RNR_RETRY			|
 						IB_QP_SQ_PSN			|
 						IB_QP_MAX_QP_RD_ATOMIC),
+				[IB_QPT_XRC_INI] = (IB_QP_TIMEOUT		|
+						IB_QP_RETRY_CNT			|
+						IB_QP_RNR_RETRY			|
+						IB_QP_SQ_PSN			|
+						IB_QP_MAX_QP_RD_ATOMIC),
+				[IB_QPT_XRC_TGT] = (IB_QP_TIMEOUT		|
+						IB_QP_SQ_PSN),
 				[IB_QPT_SMI] = IB_QP_SQ_PSN,
 				[IB_QPT_GSI] = IB_QP_SQ_PSN,
 			},
@@ -449,6 +503,15 @@ static const struct {
 						 IB_QP_ACCESS_FLAGS		|
 						 IB_QP_MIN_RNR_TIMER		|
 						 IB_QP_PATH_MIG_STATE),
+				 [IB_QPT_XRC_INI] = (IB_QP_CUR_STATE		|
+						 IB_QP_ALT_PATH			|
+						 IB_QP_ACCESS_FLAGS		|
+						 IB_QP_PATH_MIG_STATE),
+				 [IB_QPT_XRC_TGT] = (IB_QP_CUR_STATE		|
+						 IB_QP_ALT_PATH			|
+						 IB_QP_ACCESS_FLAGS		|
+						 IB_QP_MIN_RNR_TIMER		|
+						 IB_QP_PATH_MIG_STATE),
 				 [IB_QPT_SMI] = (IB_QP_CUR_STATE		|
 						 IB_QP_QKEY),
 				 [IB_QPT_GSI] = (IB_QP_CUR_STATE		|
@@ -473,6 +536,15 @@ static const struct {
 						IB_QP_ALT_PATH			|
 						IB_QP_PATH_MIG_STATE		|
 						IB_QP_MIN_RNR_TIMER),
+				[IB_QPT_XRC_INI] = (IB_QP_CUR_STATE		|
+						IB_QP_ACCESS_FLAGS		|
+						IB_QP_ALT_PATH			|
+						IB_QP_PATH_MIG_STATE),
+				[IB_QPT_XRC_TGT] = (IB_QP_CUR_STATE		|
+						IB_QP_ACCESS_FLAGS		|
+						IB_QP_ALT_PATH			|
+						IB_QP_PATH_MIG_STATE		|
+						IB_QP_MIN_RNR_TIMER),
 				[IB_QPT_SMI] = (IB_QP_CUR_STATE			|
 						IB_QP_QKEY),
 				[IB_QPT_GSI] = (IB_QP_CUR_STATE			|
@@ -485,6 +557,8 @@ static const struct {
 				[IB_QPT_UD]  = IB_QP_EN_SQD_ASYNC_NOTIFY,
 				[IB_QPT_UC]  = IB_QP_EN_SQD_ASYNC_NOTIFY,
 				[IB_QPT_RC]  = IB_QP_EN_SQD_ASYNC_NOTIFY,
+				[IB_QPT_XRC_INI] = IB_QP_EN_SQD_ASYNC_NOTIFY,
+				[IB_QPT_XRC_TGT] = IB_QP_EN_SQD_ASYNC_NOTIFY, /* ??? */
 				[IB_QPT_SMI] = IB_QP_EN_SQD_ASYNC_NOTIFY,
 				[IB_QPT_GSI] = IB_QP_EN_SQD_ASYNC_NOTIFY
 			}
@@ -507,6 +581,15 @@ static const struct {
 						IB_QP_ACCESS_FLAGS		|
 						IB_QP_MIN_RNR_TIMER		|
 						IB_QP_PATH_MIG_STATE),
+				[IB_QPT_XRC_INI] = (IB_QP_CUR_STATE		|
+						IB_QP_ALT_PATH			|
+						IB_QP_ACCESS_FLAGS		|
+						IB_QP_PATH_MIG_STATE),
+				[IB_QPT_XRC_TGT] = (IB_QP_CUR_STATE		|
+						IB_QP_ALT_PATH			|
+						IB_QP_ACCESS_FLAGS		|
+						IB_QP_MIN_RNR_TIMER		|
+						IB_QP_PATH_MIG_STATE),
 				[IB_QPT_SMI] = (IB_QP_CUR_STATE			|
 						IB_QP_QKEY),
 				[IB_QPT_GSI] = (IB_QP_CUR_STATE			|
@@ -535,6 +618,25 @@ static const struct {
 						IB_QP_PKEY_INDEX		|
 						IB_QP_MIN_RNR_TIMER		|
 						IB_QP_PATH_MIG_STATE),
+				[IB_QPT_XRC_INI] = (IB_QP_PORT			|
+						IB_QP_AV			|
+						IB_QP_TIMEOUT			|
+						IB_QP_RETRY_CNT			|
+						IB_QP_RNR_RETRY			|
+						IB_QP_MAX_QP_RD_ATOMIC		|
+						IB_QP_ALT_PATH			|
+						IB_QP_ACCESS_FLAGS		|
+						IB_QP_PKEY_INDEX		|
+						IB_QP_PATH_MIG_STATE),
+				[IB_QPT_XRC_TGT] = (IB_QP_PORT			|
+						IB_QP_AV			|
+						IB_QP_TIMEOUT			|
+						IB_QP_MAX_DEST_RD_ATOMIC	|
+						IB_QP_ALT_PATH			|
+						IB_QP_ACCESS_FLAGS		|
+						IB_QP_PKEY_INDEX		|
+						IB_QP_MIN_RNR_TIMER		|
+						IB_QP_PATH_MIG_STATE),
 				[IB_QPT_SMI] = (IB_QP_PKEY_INDEX		|
 						IB_QP_QKEY),
 				[IB_QPT_GSI] = (IB_QP_PKEY_INDEX		|
@@ -619,20 +721,27 @@ int ib_destroy_qp(struct ib_qp *qp)
 	struct ib_pd *pd;
 	struct ib_cq *scq, *rcq;
 	struct ib_srq *srq;
+	struct ib_xrcd *xrcd;
 	int ret;
 
-	pd  = qp->pd;
-	scq = qp->send_cq;
-	rcq = qp->recv_cq;
-	srq = qp->srq;
+	pd   = qp->pd;
+	scq  = qp->send_cq;
+	rcq  = qp->recv_cq;
+	srq  = qp->srq;
+	xrcd = qp->xrcd;
 
 	ret = qp->device->destroy_qp(qp);
 	if (!ret) {
-		atomic_dec(&pd->usecnt);
-		atomic_dec(&scq->usecnt);
-		atomic_dec(&rcq->usecnt);
+		if (pd)
+			atomic_dec(&pd->usecnt);
+		if (scq)
+			atomic_dec(&scq->usecnt);
+		if (rcq)
+			atomic_dec(&rcq->usecnt);
 		if (srq)
 			atomic_dec(&srq->usecnt);
+		if (xrcd)
+			atomic_dec(&xrcd->usecnt);
 	}
 
 	return ret;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 2a85461..30c67cc 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -577,6 +577,8 @@ enum ib_qp_type {
 	IB_QPT_RC,
 	IB_QPT_UC,
 	IB_QPT_UD,
+	IB_QPT_XRC_INI,
+	IB_QPT_XRC_TGT,
 	IB_QPT_RAW_IPV6,
 	IB_QPT_RAW_ETHERTYPE
 };
@@ -592,6 +594,7 @@ struct ib_qp_init_attr {
 	struct ib_cq	       *send_cq;
 	struct ib_cq	       *recv_cq;
 	struct ib_srq	       *srq;
+	struct ib_xrcd	       *xrcd;     /* XRC TGT QPs only */
 	struct ib_qp_cap	cap;
 	enum ib_sig_type	sq_sig_type;
 	enum ib_qp_type		qp_type;
@@ -783,6 +786,7 @@ struct ib_send_wr {
 			u32				rkey;
 		} fast_reg;
 	} wr;
+	u32			xrc_remote_srq_num;	/* XRC TGT QPs only */
 };
 
 struct ib_recv_wr {
@@ -918,6 +922,7 @@ struct ib_qp {
 	struct ib_cq	       *send_cq;
 	struct ib_cq	       *recv_cq;
 	struct ib_srq	       *srq;
+	struct ib_xrcd	       *xrcd; /* XRC TGT QPs only */
 	struct ib_uobject      *uobject;
 	void                  (*event_handler)(struct ib_event *, void *);
 	void		       *qp_context;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
