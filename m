From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 1/6] IB/core: add implicit CQ allocation
Date: Fri,  9 Sep 2016 14:36:22 +0200
Message-ID: <1473424587-13818-2-git-send-email-hch@lst.de>
References: <1473424587-13818-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473424587-13818-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

Currently RDMA ULPs need to explicitly allocate CQ resources, which
leads to both code churn in the drivers, and the need to explicitly
handle load balancing between CQs and completion vectors, which is
especially painful for server / target side ULPs that server many
connections.

This API instead allows the RDMA core to implicitly allocate CQ
resources when QPs are created - the ULP just has to specify the
poll context, and the core will find a suitable CQ for the number
of entries calculated from the number or WRs and RDMA contexts
specified by the ULP.

CQs are allocated lazily on first use, and maybe be shard between
connections and ULPs.  For client-side ULPs that want to make use
of spread out completion vectors we also allow manually specifying
a completion vector for a QP.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
[hch: rewrote Sagi's CQ pool to be hidden behіnd QP creation / destruction]
Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/core/core_priv.h |   6 ++
 drivers/infiniband/core/cq.c        | 125 ++++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/device.c    |   4 ++
 drivers/infiniband/core/verbs.c     |  93 +++++++++++++++++++++------
 include/rdma/ib_verbs.h             |  31 +++++++--
 5 files changed, 234 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 19d499d..685bcdf 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -137,6 +137,12 @@ static inline bool rdma_is_upper_dev_rcu(struct net_device *dev,
 	return _upper == upper;
 }
 
+void ib_init_cq_pools(struct ib_device *dev);
+void ib_free_cq_pools(struct ib_device *dev);
+struct ib_cq *ib_find_get_cq(struct ib_device *dev, unsigned int nents,
+		enum ib_poll_context poll_ctx, int comp_vector);
+void ib_put_cq(struct ib_cq *cq, unsigned int nents);
+
 int addr_init(void);
 void addr_cleanup(void);
 
diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
index a754fc7..11d2ff8 100644
--- a/drivers/infiniband/core/cq.c
+++ b/drivers/infiniband/core/cq.c
@@ -15,6 +15,9 @@
 #include <linux/slab.h>
 #include <rdma/ib_verbs.h>
 
+/* wild guess - should not be too large or too small to avoid wastage */
+#define IB_CQE_BATCH			1024
+
 /* # of WCs to poll for with a single call to ib_poll_cq */
 #define IB_POLL_BATCH			16
 
@@ -143,6 +146,8 @@ struct ib_cq *ib_alloc_cq(struct ib_device *dev, void *private,
 	cq->cq_context = private;
 	cq->poll_ctx = poll_ctx;
 	atomic_set(&cq->usecnt, 0);
+	cq->cqe_used = 0;
+	cq->comp_vector = comp_vector;
 
 	cq->wc = kmalloc_array(IB_POLL_BATCH, sizeof(*cq->wc), GFP_KERNEL);
 	if (!cq->wc)
@@ -188,6 +193,8 @@ void ib_free_cq(struct ib_cq *cq)
 
 	if (WARN_ON_ONCE(atomic_read(&cq->usecnt)))
 		return;
+	if (WARN_ON_ONCE(cq->cqe_used != 0))
+		return;
 
 	switch (cq->poll_ctx) {
 	case IB_POLL_DIRECT:
@@ -207,3 +214,121 @@ void ib_free_cq(struct ib_cq *cq)
 	WARN_ON_ONCE(ret);
 }
 EXPORT_SYMBOL(ib_free_cq);
+
+void ib_init_cq_pools(struct ib_device *dev)
+{
+	int i;
+
+	spin_lock_init(&dev->cq_lock);
+	for (i = 0; i < ARRAY_SIZE(dev->cq_pools); i++)
+		INIT_LIST_HEAD(&dev->cq_pools[i]);
+}
+
+void ib_free_cq_pools(struct ib_device *dev)
+{
+	struct ib_cq *cq, *n;
+	LIST_HEAD(tmp_list);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dev->cq_pools); i++) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&dev->cq_lock, flags);
+		list_splice_init(&dev->cq_pools[i], &tmp_list);
+		spin_unlock_irqrestore(&dev->cq_lock, flags);
+	}
+
+	list_for_each_entry_safe(cq, n, &tmp_list, pool_entry)
+		ib_free_cq(cq);
+}
+
+static int ib_alloc_cqs(struct ib_device *dev, int nr_cqes,
+		enum ib_poll_context poll_ctx)
+{
+	LIST_HEAD(tmp_list);
+	struct ib_cq *cq;
+	unsigned long flags;
+	int nr_cqs, ret, i;
+
+	/*
+	 * Allocated at least as many CQEs as requested, and otherwise
+	 * a reasonable batch size so that we can share CQs between
+	 * multiple users instead of allocating a larger number of CQs.
+	 */
+	nr_cqes = max(nr_cqes, min(dev->attrs.max_cqe, IB_CQE_BATCH));
+	nr_cqs = min_t(int, dev->num_comp_vectors, num_possible_cpus());
+	for (i = 0; i < nr_cqs; i++) {
+		cq = ib_alloc_cq(dev, NULL, nr_cqes, i, poll_ctx);
+		if (IS_ERR(cq)) {
+			ret = PTR_ERR(cq);
+			pr_err("%s: failed to create CQ ret=%d\n",
+				__func__, ret);
+			goto out_free_cqs;
+		}
+		list_add_tail(&cq->pool_entry, &tmp_list);
+	}
+
+	spin_lock_irqsave(&dev->cq_lock, flags);
+	list_splice(&tmp_list, &dev->cq_pools[poll_ctx]);
+	spin_unlock_irqrestore(&dev->cq_lock, flags);
+
+	return 0;
+
+out_free_cqs:
+	list_for_each_entry(cq, &tmp_list, pool_entry)
+		ib_free_cq(cq);
+	return ret;
+}
+
+/*
+ * Find the least used completion queue that fits nents, and claim nents
+ * entries in it for us.  In case there aren't enough CQEs available, allocate
+ * another array of CQs and restart the search.
+ */
+struct ib_cq *ib_find_get_cq(struct ib_device *dev, unsigned int nents,
+		enum ib_poll_context poll_ctx, int comp_vector)
+{
+	struct ib_cq *cq, *found;
+	unsigned long flags;
+	int ret;
+
+	if (poll_ctx >= ARRAY_SIZE(dev->cq_pools))
+		return ERR_PTR(-EINVAL);
+
+	comp_vector %= num_possible_cpus();
+restart:
+	found = NULL;
+	spin_lock_irqsave(&dev->cq_lock, flags);
+	list_for_each_entry(cq, &dev->cq_pools[poll_ctx], pool_entry) {
+		if (comp_vector != -1 && comp_vector != cq->comp_vector)
+			continue;
+		if (cq->cqe_used + nents > cq->cqe)
+			continue;
+		if (found && cq->cqe_used >= found->cqe_used)
+			continue;
+		found = cq;
+	}
+
+	if (found) {
+		found->cqe_used += nents;
+		spin_unlock_irqrestore(&dev->cq_lock, flags);
+		return found;
+	}
+	spin_unlock_irqrestore(&dev->cq_lock, flags);
+
+	/* Ran out of CQs, allocate a new array of CQs */
+	ret = ib_alloc_cqs(dev, nents, poll_ctx);
+	if (ret)
+		return ERR_PTR(ret);
+	goto restart;
+}
+
+void ib_put_cq(struct ib_cq *cq, unsigned int nents)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cq->device->cq_lock, flags);
+	cq->cqe_used -= nents;
+	WARN_ON_ONCE(cq->cqe_used < 0);
+	spin_unlock_irqrestore(&cq->device->cq_lock, flags);
+}
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 760ef60..5a15ba8 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -337,6 +337,8 @@ int ib_register_device(struct ib_device *device,
 	struct ib_client *client;
 	struct ib_udata uhw = {.outlen = 0, .inlen = 0};
 
+	ib_init_cq_pools(device);
+
 	mutex_lock(&device_mutex);
 
 	if (strchr(device->name, '%')) {
@@ -435,6 +437,8 @@ void ib_unregister_device(struct ib_device *device)
 	up_write(&lists_rwsem);
 
 	device->reg_state = IB_DEV_UNREGISTERED;
+
+	ib_free_cq_pools(device);
 }
 EXPORT_SYMBOL(ib_unregister_device);
 
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index d4ef3b1..abd580b 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -777,14 +777,16 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 			   struct ib_qp_init_attr *qp_init_attr)
 {
 	struct ib_device *device = pd ? pd->device : qp_init_attr->xrcd->device;
+	struct ib_cq *cq = NULL;
 	struct ib_qp *qp;
-	int ret;
+	u32 nr_cqes = 0;
+	int ret = -EINVAL;
 
 	if (qp_init_attr->rwq_ind_tbl &&
 	    (qp_init_attr->recv_cq ||
 	    qp_init_attr->srq || qp_init_attr->cap.max_recv_wr ||
 	    qp_init_attr->cap.max_recv_sge))
-		return ERR_PTR(-EINVAL);
+		goto out;
 
 	/*
 	 * If the callers is using the RDMA API calculate the resources
@@ -795,15 +797,58 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 	if (qp_init_attr->cap.max_rdma_ctxs)
 		rdma_rw_init_qp(device, qp_init_attr);
 
+	if (qp_init_attr->create_flags & IB_QP_CREATE_ASSIGN_CQS) {
+		int vector = -1;
+
+		if (WARN_ON(qp_init_attr->recv_cq))
+			goto out;
+		if (WARN_ON(qp_init_attr->send_cq))
+			goto out;
+
+		if (qp_init_attr->create_flags & IB_QP_CREATE_COMP_VECTOR)
+			vector = qp_init_attr->comp_vector;
+
+		nr_cqes = qp_init_attr->cap.max_recv_wr +
+			  qp_init_attr->cap.max_send_wr;
+		if (nr_cqes) {
+			cq = ib_find_get_cq(device, nr_cqes,
+					    qp_init_attr->poll_ctx, vector);
+			if (IS_ERR(cq)) {
+				ret = PTR_ERR(cq);
+				goto out;
+			}
+
+			if (qp_init_attr->cap.max_recv_wr) {
+				qp_init_attr->recv_cq = cq;
+
+				/*
+				 * Low-level drivers expect max_recv_wr == 0
+				 * for the SRQ case:
+				 */
+				if (qp_init_attr->srq)
+					qp_init_attr->cap.max_recv_wr = 0;
+			}
+
+			if (qp_init_attr->cap.max_send_wr)
+				qp_init_attr->send_cq = cq;
+		}
+
+		qp_init_attr->create_flags &=
+			~(IB_QP_CREATE_ASSIGN_CQS | IB_QP_CREATE_COMP_VECTOR);
+	}
+
 	qp = device->create_qp(pd, qp_init_attr, NULL);
-	if (IS_ERR(qp))
-		return qp;
+	if (IS_ERR(qp)) {
+		ret = PTR_ERR(qp);
+		goto out_put_cq;
+	}
 
 	qp->device     = device;
 	qp->real_qp    = qp;
 	qp->uobject    = NULL;
 	qp->qp_type    = qp_init_attr->qp_type;
 	qp->rwq_ind_tbl = qp_init_attr->rwq_ind_tbl;
+	qp->nr_cqes    = nr_cqes;
 
 	atomic_set(&qp->usecnt, 0);
 	qp->mrs_used = 0;
@@ -842,8 +887,7 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 		ret = rdma_rw_init_mrs(qp, qp_init_attr);
 		if (ret) {
 			pr_err("failed to init MR pool ret= %d\n", ret);
-			ib_destroy_qp(qp);
-			qp = ERR_PTR(ret);
+			goto out_destroy_qp;
 		}
 	}
 
@@ -857,6 +901,14 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 				 device->attrs.max_sge_rd);
 
 	return qp;
+
+out_destroy_qp:
+	ib_destroy_qp(qp);
+out_put_cq:
+	if (cq)
+		ib_put_cq(cq, nr_cqes);
+out:
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL(ib_create_qp);
 
@@ -1346,20 +1398,23 @@ int ib_destroy_qp(struct ib_qp *qp)
 		rdma_rw_cleanup_mrs(qp);
 
 	ret = qp->device->destroy_qp(qp);
-	if (!ret) {
-		if (pd)
-			atomic_dec(&pd->usecnt);
-		if (scq)
-			atomic_dec(&scq->usecnt);
-		if (rcq)
-			atomic_dec(&rcq->usecnt);
-		if (srq)
-			atomic_dec(&srq->usecnt);
-		if (ind_tbl)
-			atomic_dec(&ind_tbl->usecnt);
-	}
+	if (ret)
+		return ret;
 
-	return ret;
+	if (qp->nr_cqes)
+		ib_put_cq(rcq ? rcq : scq, qp->nr_cqes);
+
+	if (pd)
+		atomic_dec(&pd->usecnt);
+	if (scq)
+		atomic_dec(&scq->usecnt);
+	if (rcq)
+		atomic_dec(&rcq->usecnt);
+	if (srq)
+		atomic_dec(&srq->usecnt);
+	if (ind_tbl)
+		atomic_dec(&ind_tbl->usecnt);
+	return 0;
 }
 EXPORT_SYMBOL(ib_destroy_qp);
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 0a6c708..147c451 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -991,11 +991,22 @@ enum ib_qp_create_flags {
 	IB_QP_CREATE_SIGNATURE_EN		= 1 << 6,
 	IB_QP_CREATE_USE_GFP_NOIO		= 1 << 7,
 	IB_QP_CREATE_SCATTER_FCS		= 1 << 8,
+
+	/* only used by the core, not passed to low-level drivers */
+	IB_QP_CREATE_ASSIGN_CQS			= 1 << 16,
+	IB_QP_CREATE_COMP_VECTOR		= 1 << 17,
+
 	/* reserve bits 26-31 for low level drivers' internal use */
 	IB_QP_CREATE_RESERVED_START		= 1 << 26,
 	IB_QP_CREATE_RESERVED_END		= 1 << 31,
 };
 
+enum ib_poll_context {
+	IB_POLL_SOFTIRQ,	/* poll from softirq context */
+	IB_POLL_WORKQUEUE,	/* poll from workqueue */
+	IB_POLL_DIRECT,		/* caller context, no hw completions */
+};
+
 /*
  * Note: users may not call ib_close_qp or ib_destroy_qp from the event_handler
  * callback to destroy the passed in QP.
@@ -1017,6 +1028,13 @@ struct ib_qp_init_attr {
 	 * Only needed for special QP types, or when using the RW API.
 	 */
 	u8			port_num;
+
+	/*
+	 * Only needed when not passing in explicit CQs.
+	 */
+	enum ib_poll_context	poll_ctx;
+	int			comp_vector;
+
 	struct ib_rwq_ind_table *rwq_ind_tbl;
 };
 
@@ -1400,12 +1418,6 @@ struct ib_ah {
 
 typedef void (*ib_comp_handler)(struct ib_cq *cq, void *cq_context);
 
-enum ib_poll_context {
-	IB_POLL_DIRECT,		/* caller context, no hw completions */
-	IB_POLL_SOFTIRQ,	/* poll from softirq context */
-	IB_POLL_WORKQUEUE,	/* poll from workqueue */
-};
-
 struct ib_cq {
 	struct ib_device       *device;
 	struct ib_uobject      *uobject;
@@ -1413,9 +1425,12 @@ struct ib_cq {
 	void                  (*event_handler)(struct ib_event *, void *);
 	void                   *cq_context;
 	int               	cqe;
+	unsigned int		cqe_used;
 	atomic_t          	usecnt; /* count number of work queues */
 	enum ib_poll_context	poll_ctx;
+	int			comp_vector;
 	struct ib_wc		*wc;
+	struct list_head	pool_entry;
 	union {
 		struct irq_poll		iop;
 		struct work_struct	work;
@@ -1526,6 +1541,7 @@ struct ib_qp {
 	u32			max_read_sge;
 	enum ib_qp_type		qp_type;
 	struct ib_rwq_ind_table *rwq_ind_tbl;
+	u32			nr_cqes;
 };
 
 struct ib_mr {
@@ -2050,6 +2066,9 @@ struct ib_device {
 	struct attribute_group	     *hw_stats_ag;
 	struct rdma_hw_stats         *hw_stats;
 
+	spinlock_t		     cq_lock;
+	struct list_head	     cq_pools[IB_POLL_WORKQUEUE + 1];
+
 	/**
 	 * The following mandatory functions are used only at device
 	 * registration.  Keep functions such as these at the end of this
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
