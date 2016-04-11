From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/12] IB/core: refactor ib_create_qp
Date: Mon, 11 Apr 2016 14:32:33 -0700
Message-ID: <1460410360-13104-6-git-send-email-hch@lst.de>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1460410360-13104-1-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: bart.vanassche@sandisk.com, swise@opengridcomputing.com, sagi@grimberg.me, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Split the XRC magic into a separate function, and return early on failure
to make the initialization code readable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Steve Wise <swise@opengridcomputing.com>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Steve Wise <swise@opengridcomputing.com>
---
 drivers/infiniband/core/verbs.c | 103 +++++++++++++++++++++-------------------
 1 file changed, 54 insertions(+), 49 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 064dbef..d0ed260 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -723,62 +723,67 @@ struct ib_qp *ib_open_qp(struct ib_xrcd *xrcd,
 }
 EXPORT_SYMBOL(ib_open_qp);
 
+static struct ib_qp *ib_create_xrc_qp(struct ib_qp *qp,
+		struct ib_qp_init_attr *qp_init_attr)
+{
+	struct ib_qp *real_qp = qp;
+
+	qp->event_handler = __ib_shared_qp_event_handler;
+	qp->qp_context = qp;
+	qp->pd = NULL;
+	qp->send_cq = qp->recv_cq = NULL;
+	qp->srq = NULL;
+	qp->xrcd = qp_init_attr->xrcd;
+	atomic_inc(&qp_init_attr->xrcd->usecnt);
+	INIT_LIST_HEAD(&qp->open_list);
+
+	qp = __ib_open_qp(real_qp, qp_init_attr->event_handler,
+			  qp_init_attr->qp_context);
+	if (!IS_ERR(qp))
+		__ib_insert_xrcd_qp(qp_init_attr->xrcd, real_qp);
+	else
+		real_qp->device->destroy_qp(real_qp);
+	return qp;
+}
+
 struct ib_qp *ib_create_qp(struct ib_pd *pd,
 			   struct ib_qp_init_attr *qp_init_attr)
 {
-	struct ib_qp *qp, *real_qp;
-	struct ib_device *device;
+	struct ib_device *device = pd ? pd->device : qp_init_attr->xrcd->device;
+	struct ib_qp *qp;
 
-	device = pd ? pd->device : qp_init_attr->xrcd->device;
 	qp = device->create_qp(pd, qp_init_attr, NULL);
-
-	if (!IS_ERR(qp)) {
-		qp->device     = device;
-		qp->real_qp    = qp;
-		qp->uobject    = NULL;
-		qp->qp_type    = qp_init_attr->qp_type;
-
-		atomic_set(&qp->usecnt, 0);
-		if (qp_init_attr->qp_type == IB_QPT_XRC_TGT) {
-			qp->event_handler = __ib_shared_qp_event_handler;
-			qp->qp_context = qp;
-			qp->pd = NULL;
-			qp->send_cq = qp->recv_cq = NULL;
-			qp->srq = NULL;
-			qp->xrcd = qp_init_attr->xrcd;
-			atomic_inc(&qp_init_attr->xrcd->usecnt);
-			INIT_LIST_HEAD(&qp->open_list);
-
-			real_qp = qp;
-			qp = __ib_open_qp(real_qp, qp_init_attr->event_handler,
-					  qp_init_attr->qp_context);
-			if (!IS_ERR(qp))
-				__ib_insert_xrcd_qp(qp_init_attr->xrcd, real_qp);
-			else
-				real_qp->device->destroy_qp(real_qp);
-		} else {
-			qp->event_handler = qp_init_attr->event_handler;
-			qp->qp_context = qp_init_attr->qp_context;
-			if (qp_init_attr->qp_type == IB_QPT_XRC_INI) {
-				qp->recv_cq = NULL;
-				qp->srq = NULL;
-			} else {
-				qp->recv_cq = qp_init_attr->recv_cq;
-				atomic_inc(&qp_init_attr->recv_cq->usecnt);
-				qp->srq = qp_init_attr->srq;
-				if (qp->srq)
-					atomic_inc(&qp_init_attr->srq->usecnt);
-			}
-
-			qp->pd	    = pd;
-			qp->send_cq = qp_init_attr->send_cq;
-			qp->xrcd    = NULL;
-
-			atomic_inc(&pd->usecnt);
-			atomic_inc(&qp_init_attr->send_cq->usecnt);
-		}
+	if (IS_ERR(qp))
+		return qp;
+
+	qp->device     = device;
+	qp->real_qp    = qp;
+	qp->uobject    = NULL;
+	qp->qp_type    = qp_init_attr->qp_type;
+
+	atomic_set(&qp->usecnt, 0);
+	if (qp_init_attr->qp_type == IB_QPT_XRC_TGT)
+		return ib_create_xrc_qp(qp, qp_init_attr);
+
+	qp->event_handler = qp_init_attr->event_handler;
+	qp->qp_context = qp_init_attr->qp_context;
+	if (qp_init_attr->qp_type == IB_QPT_XRC_INI) {
+		qp->recv_cq = NULL;
+		qp->srq = NULL;
+	} else {
+		qp->recv_cq = qp_init_attr->recv_cq;
+		atomic_inc(&qp_init_attr->recv_cq->usecnt);
+		qp->srq = qp_init_attr->srq;
+		if (qp->srq)
+			atomic_inc(&qp_init_attr->srq->usecnt);
 	}
 
+	qp->pd	    = pd;
+	qp->send_cq = qp_init_attr->send_cq;
+	qp->xrcd    = NULL;
+
+	atomic_inc(&pd->usecnt);
+	atomic_inc(&qp_init_attr->send_cq->usecnt);
 	return qp;
 }
 EXPORT_SYMBOL(ib_create_qp);
-- 
2.1.4
