From: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/4] IB/core: XRC base implementation
Date: Mon, 25 Jan 2010 11:01:31 -0800
Message-ID: <1264446094-4460-2-git-send-email-rolandd@cisco.com>
References: <1264446094-4460-1-git-send-email-rolandd@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1264446094-4460-1-git-send-email-rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Add the core implementation for XRC ("eXtended reliable connected")
transport.  XRC provides better scalability by allowing senders to
specify which shared receive queue (SRQ) should be used to receive a
message, which essentially allows one transport context (QP
connection) to serve multiple destinations (as long as they shared an
adapter, of course).

A few new concepts are introduced to support this:

 - A new device capability flag, IB_DEVICE_XRC, which low-level drivers
   set to indicate that a device supports XRC.
 - A new object type: XRC domains (struct ib_xrcd), and new verbs
   ib_alloc_xrcd()/ib_dealloc_xrcd().  XRCDs are used to limit which XRC
   SRQs an incoming message can target.
 - A new QP type, IB_QPT_XRC, which is used to create QPs that use the
   XRC transport.  Creating XRC QPs requires an XRCD to be specified.
 - A new verb, ib_create_xrc_srq(), which is used to create XRC SRQs.
   XRC SRQs have an associated SRQ number (SRQN), which is included in
   incoming messages to target the message to a given SRQ.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c |  138 +++++++++++++++++++++++++++++++++++++--
 include/rdma/ib_verbs.h         |   60 ++++++++++++++++-
 2 files changed, 190 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index a7da9be..b75193c 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -234,6 +234,8 @@ struct ib_srq *ib_create_srq(struct ib_pd *pd,
 		srq->uobject       = NULL;
 		srq->event_handler = srq_init_attr->event_handler;
 		srq->srq_context   = srq_init_attr->srq_context;
+		srq->xrc_cq	   = NULL;
+		srq->xrcd	   = NULL;
 		atomic_inc(&pd->usecnt);
 		atomic_set(&srq->usecnt, 0);
 	}
@@ -242,6 +244,36 @@ struct ib_srq *ib_create_srq(struct ib_pd *pd,
 }
 EXPORT_SYMBOL(ib_create_srq);
 
+struct ib_srq *ib_create_xrc_srq(struct ib_pd *pd,
+				 struct ib_cq *xrc_cq,
+				 struct ib_xrcd *xrcd,
+				 struct ib_srq_init_attr *srq_init_attr)
+{
+	struct ib_srq *srq;
+
+	if (!pd->device->create_xrc_srq)
+		return ERR_PTR(-ENOSYS);
+
+	srq = pd->device->create_xrc_srq(pd, xrc_cq, xrcd, srq_init_attr, NULL);
+
+	if (!IS_ERR(srq)) {
+		srq->device	   = pd->device;
+		srq->pd		   = pd;
+		srq->uobject	   = NULL;
+		srq->event_handler = srq_init_attr->event_handler;
+		srq->srq_context   = srq_init_attr->srq_context;
+		srq->xrc_cq	   = xrc_cq;
+		srq->xrcd	   = xrcd;
+		atomic_inc(&pd->usecnt);
+		atomic_inc(&xrcd->usecnt);
+		atomic_inc(&xrc_cq->usecnt);
+		atomic_set(&srq->usecnt, 0);
+	}
+
+	return srq;
+}
+EXPORT_SYMBOL(ib_create_xrc_srq);
+
 int ib_modify_srq(struct ib_srq *srq,
 		  struct ib_srq_attr *srq_attr,
 		  enum ib_srq_attr_mask srq_attr_mask)
@@ -263,16 +295,25 @@ EXPORT_SYMBOL(ib_query_srq);
 int ib_destroy_srq(struct ib_srq *srq)
 {
 	struct ib_pd *pd;
+	struct ib_cq *xrc_cq;
+	struct ib_xrcd *xrcd;
 	int ret;
 
 	if (atomic_read(&srq->usecnt))
 		return -EBUSY;
 
-	pd = srq->pd;
+	pd     = srq->pd;
+	xrc_cq = srq->xrc_cq;
+	xrcd   = srq->xrcd;
 
 	ret = srq->device->destroy_srq(srq);
-	if (!ret)
+	if (!ret) {
 		atomic_dec(&pd->usecnt);
+		if (xrc_cq)
+			atomic_dec(&xrc_cq->usecnt);
+		if (xrcd)
+			atomic_dec(&xrcd->usecnt);
+	}
 
 	return ret;
 }
@@ -297,11 +338,17 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 		qp->event_handler = qp_init_attr->event_handler;
 		qp->qp_context    = qp_init_attr->qp_context;
 		qp->qp_type	  = qp_init_attr->qp_type;
+		if (qp->qp_type == IB_QPT_XRC)
+			qp->xrcd  = qp_init_attr->xrcd;
+		else
+			qp->xrcd  = NULL;
 		atomic_inc(&pd->usecnt);
 		atomic_inc(&qp_init_attr->send_cq->usecnt);
 		atomic_inc(&qp_init_attr->recv_cq->usecnt);
 		if (qp_init_attr->srq)
 			atomic_inc(&qp_init_attr->srq->usecnt);
+		if (qp->xrcd)
+			atomic_inc(&qp->xrcd->usecnt);
 	}
 
 	return qp;
@@ -327,6 +374,9 @@ static const struct {
 				[IB_QPT_RC]  = (IB_QP_PKEY_INDEX		|
 						IB_QP_PORT			|
 						IB_QP_ACCESS_FLAGS),
+				[IB_QPT_XRC] = (IB_QP_PKEY_INDEX		|
+						IB_QP_PORT			|
+						IB_QP_ACCESS_FLAGS),
 				[IB_QPT_SMI] = (IB_QP_PKEY_INDEX		|
 						IB_QP_QKEY),
 				[IB_QPT_GSI] = (IB_QP_PKEY_INDEX		|
@@ -349,6 +399,9 @@ static const struct {
 				[IB_QPT_RC]  = (IB_QP_PKEY_INDEX		|
 						IB_QP_PORT			|
 						IB_QP_ACCESS_FLAGS),
+				[IB_QPT_XRC] = (IB_QP_PKEY_INDEX		|
+						IB_QP_PORT			|
+						IB_QP_ACCESS_FLAGS),
 				[IB_QPT_SMI] = (IB_QP_PKEY_INDEX		|
 						IB_QP_QKEY),
 				[IB_QPT_GSI] = (IB_QP_PKEY_INDEX		|
@@ -368,6 +421,12 @@ static const struct {
 						IB_QP_RQ_PSN			|
 						IB_QP_MAX_DEST_RD_ATOMIC	|
 						IB_QP_MIN_RNR_TIMER),
+				[IB_QPT_XRC] = (IB_QP_AV			|
+						IB_QP_PATH_MTU			|
+						IB_QP_DEST_QPN			|
+						IB_QP_RQ_PSN			|
+						IB_QP_MAX_DEST_RD_ATOMIC	|
+						IB_QP_MIN_RNR_TIMER),
 			},
 			.opt_param = {
 				 [IB_QPT_UD]  = (IB_QP_PKEY_INDEX		|
@@ -378,6 +437,9 @@ static const struct {
 				 [IB_QPT_RC]  = (IB_QP_ALT_PATH			|
 						 IB_QP_ACCESS_FLAGS		|
 						 IB_QP_PKEY_INDEX),
+				 [IB_QPT_XRC] = (IB_QP_ALT_PATH			|
+						IB_QP_ACCESS_FLAGS		|
+						IB_QP_PKEY_INDEX),
 				 [IB_QPT_SMI] = (IB_QP_PKEY_INDEX		|
 						 IB_QP_QKEY),
 				 [IB_QPT_GSI] = (IB_QP_PKEY_INDEX		|
@@ -398,6 +460,11 @@ static const struct {
 						IB_QP_RNR_RETRY			|
 						IB_QP_SQ_PSN			|
 						IB_QP_MAX_QP_RD_ATOMIC),
+				[IB_QPT_XRC] = (IB_QP_TIMEOUT			|
+						IB_QP_RETRY_CNT			|
+						IB_QP_RNR_RETRY			|
+						IB_QP_SQ_PSN			|
+						IB_QP_MAX_QP_RD_ATOMIC),
 				[IB_QPT_SMI] = IB_QP_SQ_PSN,
 				[IB_QPT_GSI] = IB_QP_SQ_PSN,
 			},
@@ -413,6 +480,11 @@ static const struct {
 						 IB_QP_ACCESS_FLAGS		|
 						 IB_QP_MIN_RNR_TIMER		|
 						 IB_QP_PATH_MIG_STATE),
+				 [IB_QPT_XRC] = (IB_QP_CUR_STATE		|
+						IB_QP_ALT_PATH			|
+						IB_QP_ACCESS_FLAGS		|
+						IB_QP_MIN_RNR_TIMER		|
+						IB_QP_PATH_MIG_STATE),
 				 [IB_QPT_SMI] = (IB_QP_CUR_STATE		|
 						 IB_QP_QKEY),
 				 [IB_QPT_GSI] = (IB_QP_CUR_STATE		|
@@ -437,6 +509,11 @@ static const struct {
 						IB_QP_ALT_PATH			|
 						IB_QP_PATH_MIG_STATE		|
 						IB_QP_MIN_RNR_TIMER),
+				[IB_QPT_XRC] = (IB_QP_CUR_STATE			|
+						IB_QP_ACCESS_FLAGS		|
+						IB_QP_ALT_PATH			|
+						IB_QP_PATH_MIG_STATE		|
+						IB_QP_MIN_RNR_TIMER),
 				[IB_QPT_SMI] = (IB_QP_CUR_STATE			|
 						IB_QP_QKEY),
 				[IB_QPT_GSI] = (IB_QP_CUR_STATE			|
@@ -449,6 +526,7 @@ static const struct {
 				[IB_QPT_UD]  = IB_QP_EN_SQD_ASYNC_NOTIFY,
 				[IB_QPT_UC]  = IB_QP_EN_SQD_ASYNC_NOTIFY,
 				[IB_QPT_RC]  = IB_QP_EN_SQD_ASYNC_NOTIFY,
+				[IB_QPT_XRC] = IB_QP_EN_SQD_ASYNC_NOTIFY,
 				[IB_QPT_SMI] = IB_QP_EN_SQD_ASYNC_NOTIFY,
 				[IB_QPT_GSI] = IB_QP_EN_SQD_ASYNC_NOTIFY
 			}
@@ -471,6 +549,11 @@ static const struct {
 						IB_QP_ACCESS_FLAGS		|
 						IB_QP_MIN_RNR_TIMER		|
 						IB_QP_PATH_MIG_STATE),
+				[IB_QPT_XRC] = (IB_QP_CUR_STATE			|
+						IB_QP_ALT_PATH			|
+						IB_QP_ACCESS_FLAGS		|
+						IB_QP_MIN_RNR_TIMER		|
+						IB_QP_PATH_MIG_STATE),
 				[IB_QPT_SMI] = (IB_QP_CUR_STATE			|
 						IB_QP_QKEY),
 				[IB_QPT_GSI] = (IB_QP_CUR_STATE			|
@@ -499,6 +582,18 @@ static const struct {
 						IB_QP_PKEY_INDEX		|
 						IB_QP_MIN_RNR_TIMER		|
 						IB_QP_PATH_MIG_STATE),
+				[IB_QPT_XRC] = (IB_QP_PORT			|
+						IB_QP_AV			|
+						IB_QP_TIMEOUT			|
+						IB_QP_RETRY_CNT			|
+						IB_QP_RNR_RETRY			|
+						IB_QP_MAX_QP_RD_ATOMIC		|
+						IB_QP_MAX_DEST_RD_ATOMIC	|
+						IB_QP_ALT_PATH			|
+						IB_QP_ACCESS_FLAGS		|
+						IB_QP_PKEY_INDEX		|
+						IB_QP_MIN_RNR_TIMER		|
+						IB_QP_PATH_MIG_STATE),
 				[IB_QPT_SMI] = (IB_QP_PKEY_INDEX		|
 						IB_QP_QKEY),
 				[IB_QPT_GSI] = (IB_QP_PKEY_INDEX		|
@@ -583,12 +678,14 @@ int ib_destroy_qp(struct ib_qp *qp)
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
@@ -597,6 +694,8 @@ int ib_destroy_qp(struct ib_qp *qp)
 		atomic_dec(&rcq->usecnt);
 		if (srq)
 			atomic_dec(&srq->usecnt);
+		if (xrcd)
+			atomic_dec(&xrcd->usecnt);
 	}
 
 	return ret;
@@ -904,3 +1003,30 @@ int ib_detach_mcast(struct ib_qp *qp, union ib_gid *gid, u16 lid)
 	return qp->device->detach_mcast(qp, gid, lid);
 }
 EXPORT_SYMBOL(ib_detach_mcast);
+
+struct ib_xrcd *ib_alloc_xrcd(struct ib_device *device)
+{
+	struct ib_xrcd *xrcd;
+
+	if (!device->alloc_xrcd)
+		return ERR_PTR(-ENOSYS);
+
+	xrcd = device->alloc_xrcd(device, NULL, NULL);
+	if (!IS_ERR(xrcd)) {
+		xrcd->device  = device;
+		xrcd->uobject = NULL;
+		atomic_set(&xrcd->usecnt, 0);
+	}
+
+	return xrcd;
+}
+EXPORT_SYMBOL(ib_alloc_xrcd);
+
+int ib_dealloc_xrcd(struct ib_xrcd *xrcd)
+{
+	if (atomic_read(&xrcd->usecnt))
+		return -EBUSY;
+
+	return xrcd->device->dealloc_xrcd(xrcd);
+}
+EXPORT_SYMBOL(ib_dealloc_xrcd);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 09509ed..1d843c3 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -103,6 +103,7 @@ enum ib_device_cap_flags {
 	 */
 	IB_DEVICE_UD_IP_CSUM		= (1<<18),
 	IB_DEVICE_UD_TSO		= (1<<19),
+	IB_DEVICE_XRC			= (1<<20),
 	IB_DEVICE_MEM_MGT_EXTENSIONS	= (1<<21),
 	IB_DEVICE_BLOCK_MULTICAST_LOOPBACK = (1<<22),
 };
@@ -551,6 +552,7 @@ enum ib_qp_type {
 	IB_QPT_RC,
 	IB_QPT_UC,
 	IB_QPT_UD,
+	IB_QPT_XRC,
 	IB_QPT_RAW_IPV6,
 	IB_QPT_RAW_ETY
 };
@@ -566,6 +568,7 @@ struct ib_qp_init_attr {
 	struct ib_cq	       *send_cq;
 	struct ib_cq	       *recv_cq;
 	struct ib_srq	       *srq;
+	struct ib_xrcd	       *xrcd;	  /* XRC QPs only */
 	struct ib_qp_cap	cap;
 	enum ib_sig_type	sq_sig_type;
 	enum ib_qp_type		qp_type;
@@ -753,6 +756,7 @@ struct ib_send_wr {
 			u32				rkey;
 		} fast_reg;
 	} wr;
+	u32			xrc_remote_srq_num; /* valid for XRC sends only */
 };
 
 struct ib_recv_wr {
@@ -814,6 +818,7 @@ struct ib_ucontext {
 	struct list_head	qp_list;
 	struct list_head	srq_list;
 	struct list_head	ah_list;
+	struct list_head	xrcd_list;
 	int			closing;
 };
 
@@ -841,6 +846,12 @@ struct ib_pd {
 	atomic_t          	usecnt; /* count all resources */
 };
 
+struct ib_xrcd {
+	struct ib_device       *device;
+	struct ib_uobject      *uobject;
+	atomic_t		usecnt; /* count all resources */
+};
+
 struct ib_ah {
 	struct ib_device	*device;
 	struct ib_pd		*pd;
@@ -862,10 +873,13 @@ struct ib_cq {
 struct ib_srq {
 	struct ib_device       *device;
 	struct ib_pd	       *pd;
+	struct ib_cq	       *xrc_cq;
+	struct ib_xrcd	       *xrcd;
 	struct ib_uobject      *uobject;
 	void		      (*event_handler)(struct ib_event *, void *);
 	void		       *srq_context;
 	atomic_t		usecnt;
+	u32			xrc_srq_num;
 };
 
 struct ib_qp {
@@ -874,6 +888,7 @@ struct ib_qp {
 	struct ib_cq	       *send_cq;
 	struct ib_cq	       *recv_cq;
 	struct ib_srq	       *srq;
+	struct ib_xrcd	       *xrcd;  /* XRC QPs only */
 	struct ib_uobject      *uobject;
 	void                  (*event_handler)(struct ib_event *, void *);
 	void		       *qp_context;
@@ -1130,6 +1145,15 @@ struct ib_device {
 						  struct ib_grh *in_grh,
 						  struct ib_mad *in_mad,
 						  struct ib_mad *out_mad);
+	struct ib_srq *		   (*create_xrc_srq)(struct ib_pd *pd,
+						     struct ib_cq *xrc_cq,
+						     struct ib_xrcd *xrcd,
+						     struct ib_srq_init_attr *srq_init_attr,
+						     struct ib_udata *udata);
+	struct ib_xrcd *	   (*alloc_xrcd)(struct ib_device *device,
+						 struct ib_ucontext *context,
+						 struct ib_udata *udata);
+	int			   (*dealloc_xrcd)(struct ib_xrcd *xrcd);
 
 	struct ib_dma_mapping_ops   *dma_ops;
 
@@ -1312,8 +1336,28 @@ int ib_query_ah(struct ib_ah *ah, struct ib_ah_attr *ah_attr);
 int ib_destroy_ah(struct ib_ah *ah);
 
 /**
- * ib_create_srq - Creates a SRQ associated with the specified protection
- *   domain.
+ * ib_create_xrc_srq - Creates an XRC SRQ associated with the specified
+ *   protection domain, completion queue, and XRC domain.
+ * @pd: The protection domain associated with the SRQ.
+ * @xrc_cq: The CQ to be associated with the XRC SRQ.
+ * @xrcd: The XRC domain to be associated with the XRC SRQ.
+ * @srq_init_attr: A list of initial attributes required to create the
+ *   XRC SRQ.  If XRC SRQ creation succeeds, then the attributes are
+ *   updated to the actual capabilities of the created XRC SRQ.
+ *
+ * srq_attr->max_wr and srq_attr->max_sge are read the determine the
+ * requested size of the XRC SRQ, and set to the actual values allocated
+ * on return.  If ib_create_xrc_srq() succeeds, then max_wr and max_sge
+ * will always be at least as large as the requested values.
+ */
+struct ib_srq *ib_create_xrc_srq(struct ib_pd *pd,
+				 struct ib_cq *xrc_cq,
+				 struct ib_xrcd *xrcd,
+				 struct ib_srq_init_attr *srq_init_attr);
+
+/**
+ * ib_create_srq - Creates an SRQ associated with the specified
+ *   protection domain.
  * @pd: The protection domain associated with the SRQ.
  * @srq_init_attr: A list of initial attributes required to create the
  *   SRQ.  If SRQ creation succeeds, then the attributes are updated to
@@ -2036,4 +2080,16 @@ int ib_attach_mcast(struct ib_qp *qp, union ib_gid *gid, u16 lid);
  */
 int ib_detach_mcast(struct ib_qp *qp, union ib_gid *gid, u16 lid);
 
+/**
+ * ib_alloc_xrcd - Allocates an XRC domain.
+ * @device: The device on which to allocate the XRC domain.
+ */
+struct ib_xrcd *ib_alloc_xrcd(struct ib_device *device);
+
+/**
+ * ib_dealloc_xrcd - Deallocates an XRC domain.
+ * @xrcd: The XRC domain to deallocate.
+ */
+int ib_dealloc_xrcd(struct ib_xrcd *xrcd);
+
 #endif /* IB_VERBS_H */
-- 
1.6.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
