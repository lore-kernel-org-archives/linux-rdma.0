From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/17] rdma/verbs: Cleanup XRC TGT QPs when destroying XRCD
Date: Wed, 15 Jun 2011 06:28:03 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373021012@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

XRC TGT QPs are intended to be shared among multiple users and
processes.  Allow the destruction of an XRC TGT QP to be done
explicitly through ib_destroy_qp() or when the XRCD is
destroyed.

To support destroying an XRC TGT QP, we need to track TGT QPs
with the XRCD.  When the XRCD is destroyed, all tracked XRC
TGT QPs are also cleaned up.

To avoid stale reference issues, if a user is holding a
reference on a TGT QP, we increment a reference count on
the XRCD.  The user releases the reference by calling
ib_release_qp.  This releases any access to the QP from
a user above verbs, but allows the QP to continue to
exist until destroyed by the xrcd.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c |   48 ++++++++++++++++++++++++++++++++++++++-
 include/rdma/ib_verbs.h         |   17 +++++++++++++-
 2 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 52d36c8..5702e02 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -316,6 +316,20 @@ EXPORT_SYMBOL(ib_destroy_srq);
 
 /* Queue pairs */
 
+static void __ib_insert_xrcd_qp(struct ib_xrcd *xrcd, struct ib_qp *qp)
+{
+	mutex_lock(&xrcd->tgt_qp_mutex);
+	list_add(&qp->xrcd_list, &xrcd->tgt_qp_list);
+	mutex_unlock(&xrcd->tgt_qp_mutex);
+}
+
+static void __ib_remove_xrcd_qp(struct ib_xrcd *xrcd, struct ib_qp *qp)
+{
+	mutex_lock(&xrcd->tgt_qp_mutex);
+	list_del(&qp->xrcd_list);
+	mutex_unlock(&xrcd->tgt_qp_mutex);
+}
+
 struct ib_qp *ib_create_qp(struct ib_pd *pd,
 			   struct ib_qp_init_attr *qp_init_attr)
 {
@@ -334,6 +348,7 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 			qp->srq = NULL;
 			qp->xrcd = qp_init_attr->xrcd;
 			atomic_inc(&qp_init_attr->xrcd->usecnt);
+			__ib_insert_xrcd_qp(qp_init_attr->xrcd, qp);
 		} else {
 			if (qp_init_attr->qp_type == IB_QPT_XRC_INI) {
 				qp->recv_cq = NULL;
@@ -728,7 +743,8 @@ int ib_destroy_qp(struct ib_qp *qp)
 	scq  = qp->send_cq;
 	rcq  = qp->recv_cq;
 	srq  = qp->srq;
-	xrcd = qp->xrcd;
+	if ((xrcd = qp->xrcd))
+		__ib_remove_xrcd_qp(xrcd, qp);
 
 	ret = qp->device->destroy_qp(qp);
 	if (!ret) {
@@ -742,12 +758,30 @@ int ib_destroy_qp(struct ib_qp *qp)
 			atomic_dec(&srq->usecnt);
 		if (xrcd)
 			atomic_dec(&xrcd->usecnt);
+	} else if (xrcd) {
+		__ib_insert_xrcd_qp(xrcd, qp);
 	}
 
 	return ret;
 }
 EXPORT_SYMBOL(ib_destroy_qp);
 
+int ib_release_qp(struct ib_qp *qp)
+{
+	unsigned long flags;
+
+	if (qp->qp_type != IB_QPT_XRC_TGT)
+		return -EINVAL;
+
+	spin_lock_irqsave(&qp->device->event_handler_lock, flags);
+	qp->event_handler = NULL;
+	spin_unlock_irqrestore(&qp->device->event_handler_lock, flags);
+
+	atomic_dec(&qp->xrcd->usecnt);
+	return 0;
+}
+EXPORT_SYMBOL(ib_release_qp);
+
 /* Completion queues */
 
 struct ib_cq *ib_create_cq(struct ib_device *device,
@@ -1061,6 +1095,8 @@ struct ib_xrcd *ib_alloc_xrcd(struct ib_device *device)
 	if (!IS_ERR(xrcd)) {
 		xrcd->device = device;
 		atomic_set(&xrcd->usecnt, 0);
+		mutex_init(&xrcd->tgt_qp_mutex);
+		INIT_LIST_HEAD(&xrcd->tgt_qp_list);
 	}
 
 	return xrcd;
@@ -1069,9 +1105,19 @@ EXPORT_SYMBOL(ib_alloc_xrcd);
 
 int ib_dealloc_xrcd(struct ib_xrcd *xrcd)
 {
+	struct ib_qp *qp;
+	int ret;
+
 	if (atomic_read(&xrcd->usecnt))
 		return -EBUSY;
 
+	while (!list_empty(&xrcd->tgt_qp_list)) {
+		qp = list_entry(xrcd->tgt_qp_list.next, struct ib_qp, xrcd_list);
+		ret = ib_destroy_qp(qp);
+		if (ret)
+			return ret;
+	}
+
 	return xrcd->device->dealloc_xrcd(xrcd);
 }
 EXPORT_SYMBOL(ib_dealloc_xrcd);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 30c67cc..d916a84 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -877,7 +877,10 @@ struct ib_pd {
 
 struct ib_xrcd {
 	struct ib_device       *device;
-	atomic_t          	usecnt; /* count all resources */
+	atomic_t          	usecnt; /* count all exposed resources */
+
+	struct mutex		tgt_qp_mutex;
+	struct list_head	tgt_qp_list;
 };
 
 struct ib_ah {
@@ -923,6 +926,7 @@ struct ib_qp {
 	struct ib_cq	       *recv_cq;
 	struct ib_srq	       *srq;
 	struct ib_xrcd	       *xrcd; /* XRC TGT QPs only */
+	struct list_head	xrcd_list;
 	struct ib_uobject      *uobject;
 	void                  (*event_handler)(struct ib_event *, void *);
 	void		       *qp_context;
@@ -1479,6 +1483,17 @@ int ib_query_qp(struct ib_qp *qp,
 int ib_destroy_qp(struct ib_qp *qp);
 
 /**
+ * ib_release_qp - Release an external reference to a QP.
+ * @qp: The QP handle to release
+ *
+ * The specified QP handle is released by the caller.  If the QP is
+ * referenced internally, it is not destroyed until all internal
+ * references are released.  After releasing the qp, the caller
+ * can no longer access it and all events on the QP are discarded.
+ */
+int ib_release_qp(struct ib_qp *qp);
+
+/**
  * ib_post_send - Posts a list of work requests to the send queue of
  *   the specified QP.
  * @qp: The QP to post the work request on.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
