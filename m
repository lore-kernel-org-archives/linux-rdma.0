From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 19/20 v2] rdma/core: Export ib_open_qp to share XRC TGT QPs
Date: Fri, 19 Aug 2011 02:14:09 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E41AAA@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

XRC TGT QPs are shared resources among multiple processes.  Since the
creating process may exit, allow other processes which share the same
XRC domain to open the existing QP.  This allows us to transfer
ownership of an xrc tgt qp to another process.

Conceptually, verbs treats an xrc tgt qp as a 'shared qp'.  Shared QPs
are allocated by verbs, then implicitly opened.  The user is returned a
pointer to the open qp, which indirectly references the real qp.  Once
a shared QP has been created, it may be opened by other users that have
access to the same xrcd.

When a user of a shared qp no longer requires access to it, it may either
close the qp or destroy it.  If closed, the underlying QP will continue
to exist as long as the xrcd is opened.  If destroyed, the underlying QP
will be destroyed if this was the last held reference on the QP.

Although xrc tgt qps are the only qp type currently allowed to be shared
among multiple users, this framework could be reused to support sharing
other qp types.

The sharing of xrc tgt qp ownership was provided by the OFED
implementation and is used by existing MPI implementations.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
changes from v1:
Everything in this patch is new!

 drivers/infiniband/core/uverbs_cmd.c  |   13 ++-
 drivers/infiniband/core/uverbs_main.c |    4 -
 drivers/infiniband/core/verbs.c       |  163 ++++++++++++++++++++++++++-------
 include/rdma/ib_verbs.h               |   30 +++++-
 4 files changed, 163 insertions(+), 47 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 2787e5d..3d2226c 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1464,6 +1464,7 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	}
 
 	if (cmd.qp_type != IB_QPT_XRC_TGT) {
+		qp->real_qp       = qp;
 		qp->device     	  = device;
 		qp->pd         	  = pd;
 		qp->send_cq    	  = attr.send_cq;
@@ -1730,8 +1731,12 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 	attr->alt_ah_attr.ah_flags 	    = cmd.alt_dest.is_global ? IB_AH_GRH : 0;
 	attr->alt_ah_attr.port_num 	    = cmd.alt_dest.port_num;
 
-	ret = qp->device->modify_qp(qp, attr,
-				    modify_qp_mask(qp->qp_type, cmd.attr_mask), &udata);
+	if (qp->real_qp == qp) {
+		ret = qp->device->modify_qp(qp, attr,
+			modify_qp_mask(qp->qp_type, cmd.attr_mask), &udata);
+	} else {
+		ret = ib_modify_qp(qp, attr, modify_qp_mask(qp->qp_type, cmd.attr_mask));
+	}
 
 	put_qp_read(qp);
 
@@ -1928,7 +1933,7 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
 	}
 
 	resp.bad_wr = 0;
-	ret = qp->device->post_send(qp, wr, &bad_wr);
+	ret = qp->device->post_send(qp->real_qp, wr, &bad_wr);
 	if (ret)
 		for (next = wr; next; next = next->next) {
 			++resp.bad_wr;
@@ -2066,7 +2071,7 @@ ssize_t ib_uverbs_post_recv(struct ib_uverbs_file *file,
 		goto out;
 
 	resp.bad_wr = 0;
-	ret = qp->device->post_recv(qp, wr, &bad_wr);
+	ret = qp->device->post_recv(qp->real_qp, wr, &bad_wr);
 
 	put_qp_read(qp);
 
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 0cb69e0..9c877e2 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -206,8 +206,8 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 			container_of(uobj, struct ib_uqp_object, uevent.uobject);
 
 		idr_remove_uobj(&ib_uverbs_qp_idr, uobj);
-		if (qp->qp_type == IB_QPT_XRC_TGT) {
-			ib_release_qp(qp);
+		if (qp != qp->real_qp) {
+			ib_close_qp(qp);
 		} else {
 			ib_uverbs_detach_umcast(qp, uqp);
 			ib_destroy_qp(qp);
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 6d034b6..471c939 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -39,6 +39,7 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/string.h>
+#include <linux/slab.h>
 
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_cache.h>
@@ -316,6 +317,14 @@ EXPORT_SYMBOL(ib_destroy_srq);
 
 /* Queue pairs */
 
+static void __ib_shared_qp_event_handler(struct ib_event *event, void *context)
+{
+	struct ib_qp *qp = context;
+
+	list_for_each_entry(event->element.qp, &qp->open_list, open_list)
+		event->element.qp->event_handler(event, event->element.qp->qp_context);
+}
+
 static void __ib_insert_xrcd_qp(struct ib_xrcd *xrcd, struct ib_qp *qp)
 {
 	mutex_lock(&xrcd->tgt_qp_mutex);
@@ -323,33 +332,91 @@ static void __ib_insert_xrcd_qp(struct ib_xrcd *xrcd, struct ib_qp *qp)
 	mutex_unlock(&xrcd->tgt_qp_mutex);
 }
 
-static void __ib_remove_xrcd_qp(struct ib_xrcd *xrcd, struct ib_qp *qp)
+static struct ib_qp *__ib_open_qp(struct ib_qp *real_qp,
+				  void (*event_handler)(struct ib_event *, void *),
+				  void *qp_context)
+{
+	struct ib_qp *qp;
+	unsigned long flags;
+
+	qp = kzalloc(sizeof *qp, GFP_KERNEL);
+	if (!qp)
+		return ERR_PTR(-ENOMEM);
+
+	qp->real_qp = real_qp;
+	atomic_inc(&real_qp->usecnt);
+	qp->device = real_qp->device;
+	qp->event_handler = event_handler;
+	qp->qp_context = qp_context;
+	qp->qp_num = real_qp->qp_num;
+	qp->qp_type = real_qp->qp_type;
+
+	spin_lock_irqsave(&real_qp->device->event_handler_lock, flags);
+	list_add(&qp->open_list, &real_qp->open_list);
+	spin_unlock_irqrestore(&real_qp->device->event_handler_lock, flags);
+
+	return qp;
+}
+
+struct ib_qp *ib_open_qp(struct ib_xrcd *xrcd,
+			 struct ib_qp_open_attr *qp_open_attr)
 {
+	struct ib_qp *qp, *real_qp;
+
+	if (qp_open_attr->qp_type != IB_QPT_XRC_TGT)
+		return ERR_PTR(-EINVAL);
+
+	qp = ERR_PTR(-EINVAL);
 	mutex_lock(&xrcd->tgt_qp_mutex);
-	list_del(&qp->xrcd_list);
+	list_for_each_entry(real_qp, &xrcd->tgt_qp_list, xrcd_list) {
+		if (real_qp->qp_num == qp_open_attr->qp_num) {
+			qp = __ib_open_qp(real_qp, qp_open_attr->event_handler,
+					  qp_open_attr->qp_context);
+			break;
+		}
+	}
 	mutex_unlock(&xrcd->tgt_qp_mutex);
+	return qp;
 }
+EXPORT_SYMBOL(ib_open_qp);
 
 struct ib_qp *ib_create_qp(struct ib_pd *pd,
 			   struct ib_qp_init_attr *qp_init_attr)
 {
-	struct ib_qp *qp;
+	struct ib_qp *qp, *real_qp;
 	struct ib_device *device;
 
 	device = pd ? pd->device : qp_init_attr->xrcd->device;
 	qp = device->create_qp(pd, qp_init_attr, NULL);
 
 	if (!IS_ERR(qp)) {
-		qp->device = device;
+		qp->device     = device;
+		qp->real_qp    = qp;
+		qp->uobject    = NULL;
+		qp->qp_type    = qp_init_attr->qp_type;
 
 		if (qp_init_attr->qp_type == IB_QPT_XRC_TGT) {
+			qp->event_handler = __ib_shared_qp_event_handler;
+			qp->qp_context = qp;
 			qp->pd = NULL;
 			qp->send_cq = qp->recv_cq = NULL;
 			qp->srq = NULL;
 			qp->xrcd = qp_init_attr->xrcd;
 			atomic_inc(&qp_init_attr->xrcd->usecnt);
-			__ib_insert_xrcd_qp(qp_init_attr->xrcd, qp);
+			INIT_LIST_HEAD(&qp->open_list);
+			atomic_set(&qp->usecnt, 0);
+
+			real_qp = qp;
+			qp = __ib_open_qp(real_qp, qp_init_attr->event_handler,
+					  qp_init_attr->qp_context);
+			if (!IS_ERR(qp)) {
+				__ib_insert_xrcd_qp(qp_init_attr->xrcd, real_qp);
+			} else {
+				real_qp->device->destroy_qp(real_qp);
+			}
 		} else {
+			qp->event_handler = qp_init_attr->event_handler;
+			qp->qp_context = qp_init_attr->qp_context;
 			if (qp_init_attr->qp_type == IB_QPT_XRC_INI) {
 				qp->recv_cq = NULL;
 				qp->srq = NULL;
@@ -367,11 +434,6 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 			atomic_inc(&pd->usecnt);
 			atomic_inc(&qp_init_attr->send_cq->usecnt);
 		}
-
-		qp->uobject       = NULL;
-		qp->event_handler = qp_init_attr->event_handler;
-		qp->qp_context    = qp_init_attr->qp_context;
-		qp->qp_type	  = qp_init_attr->qp_type;
 	}
 
 	return qp;
@@ -716,7 +778,7 @@ int ib_modify_qp(struct ib_qp *qp,
 		 struct ib_qp_attr *qp_attr,
 		 int qp_attr_mask)
 {
-	return qp->device->modify_qp(qp, qp_attr, qp_attr_mask, NULL);
+	return qp->device->modify_qp(qp->real_qp, qp_attr, qp_attr_mask, NULL);
 }
 EXPORT_SYMBOL(ib_modify_qp);
 
@@ -726,25 +788,76 @@ int ib_query_qp(struct ib_qp *qp,
 		struct ib_qp_init_attr *qp_init_attr)
 {
 	return qp->device->query_qp ?
-		qp->device->query_qp(qp, qp_attr, qp_attr_mask, qp_init_attr) :
+		qp->device->query_qp(qp->real_qp, qp_attr, qp_attr_mask, qp_init_attr) :
 		-ENOSYS;
 }
 EXPORT_SYMBOL(ib_query_qp);
 
+int ib_close_qp(struct ib_qp *qp)
+{
+	struct ib_qp *real_qp;
+	unsigned long flags;
+
+	real_qp = qp->real_qp;
+	if (real_qp == qp)
+		return -EINVAL;
+
+	spin_lock_irqsave(&real_qp->device->event_handler_lock, flags);
+	list_del(&qp->open_list);
+	spin_unlock_irqrestore(&real_qp->device->event_handler_lock, flags);
+
+	atomic_dec(&real_qp->usecnt);
+	kfree(qp);
+
+	return 0;
+}
+EXPORT_SYMBOL(ib_close_qp);
+
+static int __ib_destroy_shared_qp(struct ib_qp *qp)
+{
+	struct ib_xrcd *xrcd;
+	struct ib_qp *real_qp;
+	int ret;
+
+	real_qp = qp->real_qp;
+	xrcd = real_qp->xrcd;
+
+	mutex_lock(&xrcd->tgt_qp_mutex);
+	ib_close_qp(qp);
+	if (atomic_read(&real_qp->usecnt) == 0)
+		list_del(&real_qp->xrcd_list);
+	else
+		real_qp = NULL;
+	mutex_unlock(&xrcd->tgt_qp_mutex);
+
+	if (real_qp) {
+		ret = ib_destroy_qp(real_qp);
+		if (!ret)
+			atomic_dec(&xrcd->usecnt);
+		else
+			__ib_insert_xrcd_qp(xrcd, real_qp);
+	}
+
+	return 0;
+}
+
 int ib_destroy_qp(struct ib_qp *qp)
 {
 	struct ib_pd *pd;
 	struct ib_cq *scq, *rcq;
 	struct ib_srq *srq;
-	struct ib_xrcd *xrcd;
 	int ret;
 
+	if (atomic_read(&qp->usecnt))
+		return -EBUSY;
+
+	if (qp->real_qp != qp)
+		return __ib_destroy_shared_qp(qp);
+
 	pd   = qp->pd;
 	scq  = qp->send_cq;
 	rcq  = qp->recv_cq;
 	srq  = qp->srq;
-	if ((xrcd = qp->xrcd))
-		__ib_remove_xrcd_qp(xrcd, qp);
 
 	ret = qp->device->destroy_qp(qp);
 	if (!ret) {
@@ -756,32 +869,12 @@ int ib_destroy_qp(struct ib_qp *qp)
 			atomic_dec(&rcq->usecnt);
 		if (srq)
 			atomic_dec(&srq->usecnt);
-		if (xrcd)
-			atomic_dec(&xrcd->usecnt);
-	} else if (xrcd) {
-		__ib_insert_xrcd_qp(xrcd, qp);
 	}
 
 	return ret;
 }
 EXPORT_SYMBOL(ib_destroy_qp);
 
-int ib_release_qp(struct ib_qp *qp)
-{
-	unsigned long flags;
-
-	if (qp->qp_type != IB_QPT_XRC_TGT)
-		return -EINVAL;
-
-	spin_lock_irqsave(&qp->device->event_handler_lock, flags);
-	qp->event_handler = NULL;
-	spin_unlock_irqrestore(&qp->device->event_handler_lock, flags);
-
-	atomic_dec(&qp->xrcd->usecnt);
-	return 0;
-}
-EXPORT_SYMBOL(ib_release_qp);
-
 /* Completion queues */
 
 struct ib_cq *ib_create_cq(struct ib_device *device,
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index a779fa0..f00b76f 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -604,6 +604,13 @@ struct ib_qp_init_attr {
 	u8			port_num; /* special QP types only */
 };
 
+struct ib_qp_open_attr {
+	void                  (*event_handler)(struct ib_event *, void *);
+	void		       *qp_context;
+	u32			qp_num;
+	enum ib_qp_type		qp_type;
+};
+
 enum ib_rnr_timeout {
 	IB_RNR_TIMER_655_36 =  0,
 	IB_RNR_TIMER_000_01 =  1,
@@ -931,6 +938,9 @@ struct ib_qp {
 	struct ib_srq	       *srq;
 	struct ib_xrcd	       *xrcd; /* XRC TGT QPs only */
 	struct list_head	xrcd_list;
+	atomic_t		usecnt; /* count times opened */
+	struct list_head	open_list;
+	struct ib_qp           *real_qp;
 	struct ib_uobject      *uobject;
 	void                  (*event_handler)(struct ib_event *, void *);
 	void		       *qp_context;
@@ -1487,15 +1497,23 @@ int ib_query_qp(struct ib_qp *qp,
 int ib_destroy_qp(struct ib_qp *qp);
 
 /**
- * ib_release_qp - Release an external reference to a QP.
+ * ib_open_qp - Obtain a reference to an existing sharable QP.
+ * @xrcd - XRC domain
+ * @qp_open_attr: Attributes identifying the QP to open.
+ *
+ * Returns a reference to a sharable QP.
+ */
+struct ib_qp *ib_open_qp(struct ib_xrcd *xrcd,
+			 struct ib_qp_open_attr *qp_open_attr);
+
+/**
+ * ib_close_qp - Release an external reference to a QP.
  * @qp: The QP handle to release
  *
- * The specified QP handle is released by the caller.  If the QP is
- * referenced internally, it is not destroyed until all internal
- * references are released.  After releasing the qp, the caller
- * can no longer access it and all events on the QP are discarded.
+ * The opened QP handle is released by the caller.  The underlying
+ * shared QP is not destroyed until all internal references are released.
  */
-int ib_release_qp(struct ib_qp *qp);
+int ib_close_qp(struct ib_qp *qp);
 
 /**
  * ib_post_send - Posts a list of work requests to the send queue of


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
