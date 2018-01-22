From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v5 2/8] RDMA/core: Save kernel caller name in PD and CQ objects
Date: Mon, 22 Jan 2018 14:51:13 +0200
Message-ID: <20180122125119.26419-3-leon@kernel.org>
References: <20180122125119.26419-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180122125119.26419-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The KBUILD_MODNAME variable contains the module name
and it is known for kernel users during compilation,
so let's reuse it to track the owners.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cq.c    | 11 +++++++----
 drivers/infiniband/core/verbs.c |  1 +
 include/rdma/ib_verbs.h         | 13 +++++++++++--
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
index c8c5a5a7f433..f2bf51885094 100644
--- a/drivers/infiniband/core/cq.c
+++ b/drivers/infiniband/core/cq.c
@@ -120,20 +120,22 @@ static void ib_cq_completion_workqueue(struct ib_cq *cq, void *private)
 }
 
 /**
- * ib_alloc_cq - allocate a completion queue
+ * __ib_alloc_cq - allocate a completion queue
  * @dev:		device to allocate the CQ for
  * @private:		driver private data, accessible from cq->cq_context
  * @nr_cqe:		number of CQEs to allocate
  * @comp_vector:	HCA completion vectors for this CQ
  * @poll_ctx:		context to poll the CQ from.
+ * @caller:		module owner name.
  *
  * This is the proper interface to allocate a CQ for in-kernel users. A
  * CQ allocated with this interface will automatically be polled from the
  * specified context. The ULP must use wr->wr_cqe instead of wr->wr_id
  * to use this CQ abstraction.
  */
-struct ib_cq *ib_alloc_cq(struct ib_device *dev, void *private,
-		int nr_cqe, int comp_vector, enum ib_poll_context poll_ctx)
+struct ib_cq *__ib_alloc_cq(struct ib_device *dev, void *private,
+			    int nr_cqe, int comp_vector,
+			    enum ib_poll_context poll_ctx, const char *caller)
 {
 	struct ib_cq_init_attr cq_attr = {
 		.cqe		= nr_cqe,
@@ -151,6 +153,7 @@ struct ib_cq *ib_alloc_cq(struct ib_device *dev, void *private,
 	cq->event_handler = NULL;
 	cq->cq_context = private;
 	cq->poll_ctx = poll_ctx;
+	cq->caller = caller;
 	atomic_set(&cq->usecnt, 0);
 
 	cq->wc = kmalloc_array(IB_POLL_BATCH, sizeof(*cq->wc), GFP_KERNEL);
@@ -185,7 +188,7 @@ struct ib_cq *ib_alloc_cq(struct ib_device *dev, void *private,
 	cq->device->destroy_cq(cq);
 	return ERR_PTR(ret);
 }
-EXPORT_SYMBOL(ib_alloc_cq);
+EXPORT_SYMBOL(__ib_alloc_cq);
 
 /**
  * ib_free_cq - free a completion queue
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index e9c3991a93ff..098bde906dfd 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -252,6 +252,7 @@ struct ib_pd *__ib_alloc_pd(struct ib_device *device, unsigned int flags,
 	pd->__internal_mr = NULL;
 	atomic_set(&pd->usecnt, 0);
 	pd->flags = flags;
+	pd->caller = caller;
 
 	if (device->attrs.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)
 		pd->local_dma_lkey = device->local_dma_lkey;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 1c6e9f52f127..4cb18bcc2f34 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1530,6 +1530,7 @@ struct ib_pd {
 	 * Implementation details of the RDMA core, don't use in drivers:
 	 */
 	struct ib_mr	       *__internal_mr;
+	const char		*caller;
 };
 
 struct ib_xrcd {
@@ -1570,6 +1571,10 @@ struct ib_cq {
 		struct irq_poll		iop;
 		struct work_struct	work;
 	};
+	/*
+	 * Implementation details of the RDMA core, don't use in drivers:
+	 */
+	const char		*caller;
 };
 
 struct ib_srq {
@@ -3135,8 +3140,12 @@ static inline int ib_post_recv(struct ib_qp *qp,
 	return qp->device->post_recv(qp, recv_wr, bad_recv_wr);
 }
 
-struct ib_cq *ib_alloc_cq(struct ib_device *dev, void *private,
-		int nr_cqe, int comp_vector, enum ib_poll_context poll_ctx);
+struct ib_cq *__ib_alloc_cq(struct ib_device *dev, void *private,
+			    int nr_cqe, int comp_vector,
+			    enum ib_poll_context poll_ctx, const char *caller);
+#define ib_alloc_cq(device, priv, nr_cqe, comp_vect, poll_ctx) \
+	__ib_alloc_cq((device), (priv), (nr_cqe), (comp_vect), (poll_ctx), KBUILD_MODNAME)
+
 void ib_free_cq(struct ib_cq *cq);
 int ib_process_cq_direct(struct ib_cq *cq, int budget);
 
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
