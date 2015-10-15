From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 2/7] IB: Introduce Work Queue object and its verbs
Date: Thu, 15 Oct 2015 10:16:45 +0300
Message-ID: <1444893410-13242-3-git-send-email-yishaih@mellanox.com>
References: <1444893410-13242-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444893410-13242-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Introduce Work Queue object and its create/destroy/modify verbs.

QP can be created without internal WQs "packaged" inside it,
this QP can be configured to use "external" WQ object as its
receive/send queue.
WQ is a necessary component for RSS technology since RSS mechanism
is supposed to distribute the traffic between multiple
Receive Work Queues.

WQ associated (many to one) with Completion Queue and it owns WQ
properties (PD, WQ size, etc.).
WQ has a type, this patch introduces the IB_WQT_RQ (i.e.receive queue),
it may be extend to others such as IB_WQT_SQ. (send queue).
WQ from type IB_WQT_RQ contains receive work requests.

WQ context is subject to a well-defined state transitions done by
the modify_wq verb.
When WQ is created its initial state becomes IB_WQS_RESET.
>From IB_WQS_RESET it can be modified to itself or to IB_WQS_RDY.
>From IB_WQS_RDY it can be modified to itself, to IB_WQS_RESET
or to IB_WQS_ERR.
>From IB_WQS_ERR it can be modified to IB_WQS_RESET.

Note: transition to IB_WQS_ERR might occur implicitly in case there
was some HW error.


Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c |   59 ++++++++++++++++++++++++++
 include/rdma/ib_verbs.h         |   88 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 147 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index e1f2c98..c63c622 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1435,6 +1435,65 @@ int ib_dealloc_xrcd(struct ib_xrcd *xrcd)
 }
 EXPORT_SYMBOL(ib_dealloc_xrcd);
 
+struct ib_wq *ib_create_wq(struct ib_pd *pd,
+			   struct ib_wq_init_attr *wq_attr)
+{
+	struct ib_wq *wq;
+
+	if (!pd->device->create_wq)
+		return ERR_PTR(-ENOSYS);
+
+	wq = pd->device->create_wq(pd, wq_attr, NULL);
+	if (!IS_ERR(wq)) {
+		wq->event_handler = wq_attr->event_handler;
+		wq->wq_context = wq_attr->wq_context;
+		wq->wq_type = wq_attr->wq_type;
+		wq->cq = wq_attr->cq;
+		wq->device = pd->device;
+		wq->pd = pd;
+		wq->uobject = NULL;
+		atomic_inc(&pd->usecnt);
+		atomic_inc(&wq_attr->cq->usecnt);
+		atomic_set(&wq->usecnt, 0);
+	}
+	return wq;
+}
+EXPORT_SYMBOL(ib_create_wq);
+
+int ib_destroy_wq(struct ib_wq *wq)
+{
+	int err;
+	struct ib_cq *cq = wq->cq;
+	struct ib_pd *pd = wq->pd;
+
+	if (!wq->device->destroy_wq)
+		return -ENOSYS;
+
+	if (atomic_read(&wq->usecnt))
+		return -EBUSY;
+
+	err = wq->device->destroy_wq(wq);
+	if (!err) {
+		atomic_dec(&pd->usecnt);
+		atomic_dec(&cq->usecnt);
+	}
+	return err;
+}
+EXPORT_SYMBOL(ib_destroy_wq);
+
+int ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr *wq_attr,
+		 enum ib_wq_attr_mask attr_mask)
+{
+	int err;
+
+	if (!wq->device->modify_wq)
+		return -ENOSYS;
+
+	err = wq->device->modify_wq(wq, wq_attr, attr_mask, NULL);
+	return err;
+}
+EXPORT_SYMBOL(ib_modify_wq);
+
 struct ib_flow *ib_create_flow(struct ib_qp *qp,
 			       struct ib_flow_attr *flow_attr,
 			       int domain)
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index e1f65e2..0c6291b 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1310,6 +1310,48 @@ struct ib_srq {
 	} ext;
 };
 
+enum ib_wq_type {
+	IB_WQT_RQ
+};
+
+enum ib_wq_state {
+	IB_WQS_RESET,
+	IB_WQS_RDY,
+	IB_WQS_ERR
+};
+
+struct ib_wq {
+	struct ib_device       *device;
+	struct ib_uobject      *uobject;
+	void		    *wq_context;
+	void		    (*event_handler)(struct ib_event *, void *);
+	struct ib_pd	       *pd;
+	struct ib_cq	       *cq;
+	u32		wq_num;
+	enum ib_wq_state       state;
+	enum ib_wq_type	wq_type;
+	atomic_t		usecnt;
+};
+
+struct ib_wq_init_attr {
+	void		       *wq_context;
+	enum ib_wq_type	wq_type;
+	u32		max_wr;
+	u32		max_sge;
+	struct	ib_cq	       *cq;
+	void		    (*event_handler)(struct ib_event *, void *);
+};
+
+enum ib_wq_attr_mask {
+	IB_WQ_STATE	= 1 << 0,
+	IB_WQ_CUR_STATE	= 1 << 1,
+};
+
+struct ib_wq_attr {
+	enum	ib_wq_state	wq_state;
+	enum	ib_wq_state	curr_wq_state;
+};
+
 struct ib_qp {
 	struct ib_device       *device;
 	struct ib_pd	       *pd;
@@ -1771,6 +1813,14 @@ struct ib_device {
 	int			   (*check_mr_status)(struct ib_mr *mr, u32 check_mask,
 						      struct ib_mr_status *mr_status);
 	void			   (*disassociate_ucontext)(struct ib_ucontext *ibcontext);
+	struct ib_wq *		   (*create_wq)(struct ib_pd *pd,
+						struct ib_wq_init_attr *init_attr,
+						struct ib_udata *udata);
+	int			   (*destroy_wq)(struct ib_wq *wq);
+	int			   (*modify_wq)(struct ib_wq *wq,
+						struct ib_wq_attr *attr,
+						enum ib_wq_attr_mask attr_mask,
+						struct ib_udata *udata);
 
 	struct ib_dma_mapping_ops   *dma_ops;
 
@@ -3024,4 +3074,42 @@ struct net_device *ib_get_net_dev_by_params(struct ib_device *dev, u8 port,
 					    u16 pkey, const union ib_gid *gid,
 					    const struct sockaddr *addr);
 
+/**
+ * ib_create_wq - Creates a WQ associated with the specified protection
+ * domain.
+ * @pd: The protection domain associated with the WQ.
+ * @wq_init_attr: A list of initial attributes required to create the
+ * WQ. If WQ creation succeeds, then the attributes are updated to
+ * the actual capabilities of the created WQ.
+ *
+ * wq_init_attr->max_wr and wq_init_attr->max_sge determine
+ * the requested size of the WQ, and set to the actual values allocated
+ * on return.
+ * If ib_create_wq() succeeds, then max_wr and max_sge will always be
+ * at least as large as the requested values.
+ *
+ * Return Value
+ * ib_create_wq() returns a pointer to the created WQ, or NULL if the request
+ * fails.
+ */
+struct ib_wq *ib_create_wq(struct ib_pd *pd,
+			   struct ib_wq_init_attr *init_attr);
+
+/**
+ * ib_destroy_wq - Destroys the specified WQ.
+ * @wq: The WQ to destroy.
+ */
+int ib_destroy_wq(struct ib_wq *wq);
+
+/**
+ * ib_modify_wq - Modifies the specified WQ.
+ * @wq: The WQ to modify.
+ * @wq_attr: On input, specifies the WQ attributes to modify.
+ * @attr_mask: A bit-mask used to specify which attributes of the WQ
+ *   are being modified.
+ * On output, the current values of selected WQ attributes are returned.
+ */
+int ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr *attr,
+		 enum ib_wq_attr_mask attr_mask);
+
 #endif /* IB_VERBS_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
