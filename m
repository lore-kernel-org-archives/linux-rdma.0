From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH v3 1/9] RDMA/core: Add implicit per-device completion queue pools
Date: Wed,  8 Nov 2017 11:57:34 +0200
Message-ID: <20171108095742.25365-2-sagi@grimberg.me>
References: <20171108095742.25365-1-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171108095742.25365-1-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allow a ULP to ask the core to implicitly assign a completion
queue to a queue-pair based on a least-used search on a per-device
cq pools. The device CQ pools grow in a lazy fashion with every
QP creation.

In addition, expose an affinity hint for a queue pair creation.
If passed, the core will attempt to attach a CQ with a completion
vector that is directed to the cpu core as the affinity hint
provided.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/infiniband/core/core_priv.h |   6 ++
 drivers/infiniband/core/cq.c        | 193 ++++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/device.c    |   4 +
 drivers/infiniband/core/verbs.c     |  69 +++++++++++--
 include/rdma/ib_verbs.h             |  31 ++++--
 5 files changed, 291 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index a1d687a664f8..4f6cd4cf5116 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -179,6 +179,12 @@ static inline bool rdma_is_upper_dev_rcu(struct net_device *dev,
 	return netdev_has_upper_dev_all_rcu(dev, upper);
 }
 
+void ib_init_cq_pools(struct ib_device *dev);
+void ib_purge_cq_pools(struct ib_device *dev);
+struct ib_cq *ib_find_get_cq(struct ib_device *dev, unsigned int nr_cqe,
+		enum ib_poll_context poll_ctx, int affinity_hint);
+void ib_put_cq(struct ib_cq *cq, unsigned int nr_cqe);
+
 int addr_init(void);
 void addr_cleanup(void);
 
diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
index f2ae75fa3128..8b9f9be5386b 100644
--- a/drivers/infiniband/core/cq.c
+++ b/drivers/infiniband/core/cq.c
@@ -15,6 +15,9 @@
 #include <linux/slab.h>
 #include <rdma/ib_verbs.h>
 
+/* XXX: wild guess - should not be too large or too small to avoid wastage */
+#define IB_CQE_BATCH			1024
+
 /* # of WCs to poll for with a single call to ib_poll_cq */
 #define IB_POLL_BATCH			16
 
@@ -149,6 +152,8 @@ struct ib_cq *ib_alloc_cq(struct ib_device *dev, void *private,
 	cq->cq_context = private;
 	cq->poll_ctx = poll_ctx;
 	atomic_set(&cq->usecnt, 0);
+	cq->cqe_used = 0;
+	cq->comp_vector = comp_vector;
 
 	cq->wc = kmalloc_array(IB_POLL_BATCH, sizeof(*cq->wc), GFP_KERNEL);
 	if (!cq->wc)
@@ -194,6 +199,8 @@ void ib_free_cq(struct ib_cq *cq)
 
 	if (WARN_ON_ONCE(atomic_read(&cq->usecnt)))
 		return;
+	if (WARN_ON_ONCE(cq->cqe_used != 0))
+		return;
 
 	switch (cq->poll_ctx) {
 	case IB_POLL_DIRECT:
@@ -213,3 +220,189 @@ void ib_free_cq(struct ib_cq *cq)
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
+void ib_purge_cq_pools(struct ib_device *dev)
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
+/**
+ * ib_find_vector_affinity() - Find the first completion vector mapped to a given
+ *     cpu core affinity
+ * @device:            rdma device
+ * @cpu:               cpu for the corresponding completion vector affinity
+ * @vector:            output target completion vector
+ *
+ * If the device expose vector affinity we will search each of the vectors
+ * and if we find one that gives us the desired cpu core we return true
+ * and assign @vector to the corresponding completion vector. Otherwise
+ * we return false. We stop at the first appropriate completion vector
+ * we find as we don't have any preference for multiple vectors with the
+ * same affinity.
+ */
+static bool ib_find_vector_affinity(struct ib_device *device, int cpu,
+		unsigned int *vector)
+{
+	bool found = false;
+	unsigned int c;
+	int vec;
+
+	if (cpu == -1)
+		goto out;
+
+	for (vec = 0; vec < device->num_comp_vectors; vec++) {
+		const struct cpumask *mask;
+
+		mask = ib_get_vector_affinity(device, vec);
+		if (!mask)
+			goto out;
+
+		for_each_cpu(c, mask) {
+			if (c == cpu) {
+				*vector = vec;
+				found = true;
+				goto out;
+			}
+		}
+	}
+
+out:
+	return found;
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
+ * ib_find_get_cq() - Find the least used completion queue that matches
+ *     a given affinity hint (or least used for wild card affinity)
+ *     and fits nr_cqe
+ * @dev:              rdma device
+ * @nr_cqe:           number of needed cqe entries
+ * @poll_ctx:         cq polling context
+ * @affinity_hint:    affinity hint (-1) for wild-card assignment
+ *
+ * Finds a cq that satisfies @affinity_hint and @nr_cqe requirements and claim
+ * entries in it for us. In case there is no available cq, allocate a new cq
+ * with the requirements and add it to the device pool.
+ */
+struct ib_cq *ib_find_get_cq(struct ib_device *dev, unsigned int nr_cqe,
+		enum ib_poll_context poll_ctx, int affinity_hint)
+{
+	struct ib_cq *cq, *found;
+	unsigned long flags;
+	int vector, ret;
+
+	if (poll_ctx >= ARRAY_SIZE(dev->cq_pools))
+		return ERR_PTR(-EINVAL);
+
+	if (!ib_find_vector_affinity(dev, affinity_hint, &vector)) {
+		/*
+		 * Couldn't find matching vector affinity so project
+		 * the affinty to the device completion vector range
+		 */
+		vector = affinity_hint % dev->num_comp_vectors;
+	}
+
+restart:
+	/*
+	 * Find the least used CQ with correct affinity and
+	 * enough free cq entries
+	 */
+	found = NULL;
+	spin_lock_irqsave(&dev->cq_lock, flags);
+	list_for_each_entry(cq, &dev->cq_pools[poll_ctx], pool_entry) {
+		if (vector != -1 && vector != cq->comp_vector)
+			continue;
+		if (cq->cqe_used + nr_cqe > cq->cqe)
+			continue;
+		if (found && cq->cqe_used >= found->cqe_used)
+			continue;
+		found = cq;
+	}
+
+	if (found) {
+		found->cqe_used += nr_cqe;
+		spin_unlock_irqrestore(&dev->cq_lock, flags);
+		return found;
+	}
+	spin_unlock_irqrestore(&dev->cq_lock, flags);
+
+	/*
+	 * Didn't find a match or ran out of CQs,
+	 * device pool, allocate a new array of CQs.
+	 */
+	ret = ib_alloc_cqs(dev, nr_cqe, poll_ctx);
+	if (ret)
+		return ERR_PTR(ret);
+
+	/* Now search again */
+	goto restart;
+}
+
+void ib_put_cq(struct ib_cq *cq, unsigned int nr_cqe)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cq->device->cq_lock, flags);
+	cq->cqe_used -= nr_cqe;
+	WARN_ON_ONCE(cq->cqe_used < 0);
+	spin_unlock_irqrestore(&cq->device->cq_lock, flags);
+}
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 84fc32a2c8b3..c828845c46d8 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -468,6 +468,8 @@ int ib_register_device(struct ib_device *device,
 		device->dma_device = parent;
 	}
 
+	ib_init_cq_pools(device);
+
 	mutex_lock(&device_mutex);
 
 	if (strchr(device->name, '%')) {
@@ -590,6 +592,8 @@ void ib_unregister_device(struct ib_device *device)
 	up_write(&lists_rwsem);
 
 	device->reg_state = IB_DEV_UNREGISTERED;
+
+	ib_purge_cq_pools(device);
 }
 EXPORT_SYMBOL(ib_unregister_device);
 
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index de57d6c11a25..fcc9ecba6741 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -793,14 +793,16 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
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
@@ -811,9 +813,51 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 	if (qp_init_attr->cap.max_rdma_ctxs)
 		rdma_rw_init_qp(device, qp_init_attr);
 
+	if (qp_init_attr->create_flags & IB_QP_CREATE_ASSIGN_CQS) {
+		int affinity = -1;
+
+		if (WARN_ON(qp_init_attr->recv_cq))
+			goto out;
+		if (WARN_ON(qp_init_attr->send_cq))
+			goto out;
+
+		if (qp_init_attr->create_flags & IB_QP_CREATE_AFFINITY_HINT)
+			affinity = qp_init_attr->affinity_hint;
+
+		nr_cqes = qp_init_attr->cap.max_recv_wr +
+			  qp_init_attr->cap.max_send_wr;
+		if (nr_cqes) {
+			cq = ib_find_get_cq(device, nr_cqes,
+					    qp_init_attr->poll_ctx, affinity);
+			if (IS_ERR(cq)) {
+				ret = PTR_ERR(cq);
+				goto out;
+			}
+
+			if (qp_init_attr->cap.max_send_wr)
+				qp_init_attr->send_cq = cq;
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
+		}
+
+		qp_init_attr->create_flags &=
+			~(IB_QP_CREATE_ASSIGN_CQS | IB_QP_CREATE_AFFINITY_HINT);
+	}
+
 	qp = device->create_qp(pd, qp_init_attr, NULL);
-	if (IS_ERR(qp))
-		return qp;
+	if (IS_ERR(qp)) {
+		ret = PTR_ERR(qp);
+		goto out_put_cq;
+	}
 
 	ret = ib_create_qp_security(qp, device);
 	if (ret) {
@@ -826,6 +870,7 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 	qp->uobject    = NULL;
 	qp->qp_type    = qp_init_attr->qp_type;
 	qp->rwq_ind_tbl = qp_init_attr->rwq_ind_tbl;
+	qp->nr_cqes    = nr_cqes;
 
 	atomic_set(&qp->usecnt, 0);
 	qp->mrs_used = 0;
@@ -865,8 +910,7 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 		ret = rdma_rw_init_mrs(qp, qp_init_attr);
 		if (ret) {
 			pr_err("failed to init MR pool ret= %d\n", ret);
-			ib_destroy_qp(qp);
-			return ERR_PTR(ret);
+			goto out_destroy_qp;
 		}
 	}
 
@@ -880,6 +924,14 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
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
 
@@ -1478,6 +1530,11 @@ int ib_destroy_qp(struct ib_qp *qp)
 			atomic_dec(&ind_tbl->usecnt);
 		if (sec)
 			ib_destroy_qp_security_end(sec);
+
+		if (qp->nr_cqes) {
+			WARN_ON_ONCE(rcq && rcq != scq);
+			ib_put_cq(scq, qp->nr_cqes);
+		}
 	} else {
 		if (sec)
 			ib_destroy_qp_security_abort(sec);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index bdb1279a415b..56d42e753eb4 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1098,11 +1098,22 @@ enum ib_qp_create_flags {
 	IB_QP_CREATE_SCATTER_FCS		= 1 << 8,
 	IB_QP_CREATE_CVLAN_STRIPPING		= 1 << 9,
 	IB_QP_CREATE_SOURCE_QPN			= 1 << 10,
+
+	/* only used by the core, not passed to low-level drivers */
+	IB_QP_CREATE_ASSIGN_CQS			= 1 << 24,
+	IB_QP_CREATE_AFFINITY_HINT		= 1 << 25,
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
@@ -1124,6 +1135,13 @@ struct ib_qp_init_attr {
 	 * Only needed for special QP types, or when using the RW API.
 	 */
 	u8			port_num;
+
+	/*
+	 * Only needed when not passing in explicit CQs.
+	 */
+	enum ib_poll_context	poll_ctx;
+	int			affinity_hint;
+
 	struct ib_rwq_ind_table *rwq_ind_tbl;
 	u32			source_qpn;
 };
@@ -1536,12 +1554,6 @@ struct ib_ah {
 
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
@@ -1549,9 +1561,12 @@ struct ib_cq {
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
@@ -1731,6 +1746,7 @@ struct ib_qp {
 	struct ib_rwq_ind_table *rwq_ind_tbl;
 	struct ib_qp_security  *qp_sec;
 	u8			port;
+	u32			nr_cqes;
 };
 
 struct ib_mr {
@@ -2338,6 +2354,9 @@ struct ib_device {
 
 	u32                          index;
 
+	spinlock_t		     cq_lock;
+	struct list_head	     cq_pools[IB_POLL_WORKQUEUE + 1];
+
 	/**
 	 * The following mandatory functions are used only at device
 	 * registration.  Keep functions such as these at the end of this
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
