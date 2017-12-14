From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 for-rc 8/8] RDMA/vmw_pvrdma: Use completion instead of
 wait queue
Date: Wed, 13 Dec 2017 16:26:49 -0800
Message-ID: <20171214002638.GA20297@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
References: <20171214001753.GA9780@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171214001753.GA9780-qXbCdz4EeRo1jLI2hToXVI42T8aCTgcwy4vvyvUx+exJXi8ZT2ovy+oDBWuYMCC/JZORHMmSJCU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The use of wait queues in vmw_pvrdma for handling concurrent
access to a resource leaves a possible use after free bug.
Fix this by using completions instead.

Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h      | 6 +++---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c   | 7 ++++---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c | 8 ++++----
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c   | 7 ++++---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c  | 7 ++++---
 5 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
index 07d287e..44cb1cf 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
@@ -94,7 +94,7 @@ struct pvrdma_cq {
 	u32 cq_handle;
 	bool is_kernel;
 	refcount_t refcnt;
-	wait_queue_head_t wait;
+	struct completion free;
 };
 
 struct pvrdma_id_table {
@@ -175,7 +175,7 @@ struct pvrdma_srq {
 	u32 srq_handle;
 	int npages;
 	refcount_t refcnt;
-	wait_queue_head_t wait;
+	struct completion free;
 };
 
 struct pvrdma_qp {
@@ -197,7 +197,7 @@ struct pvrdma_qp {
 	bool is_kernel;
 	struct mutex mutex; /* QP state mutex. */
 	refcount_t refcnt;
-	wait_queue_head_t wait;
+	struct completion free;
 };
 
 struct pvrdma_dev {
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
index 9dba949..faa9478 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
@@ -178,7 +178,7 @@ struct ib_cq *pvrdma_create_cq(struct ib_device *ibdev,
 		pvrdma_page_dir_insert_umem(&cq->pdir, cq->umem, 0);
 
 	refcount_set(&cq->refcnt, 1);
-	init_waitqueue_head(&cq->wait);
+	init_completion(&cq->free);
 	spin_lock_init(&cq->cq_lock);
 
 	memset(cmd, 0, sizeof(*cmd));
@@ -229,8 +229,9 @@ struct ib_cq *pvrdma_create_cq(struct ib_device *ibdev,
 
 static void pvrdma_free_cq(struct pvrdma_dev *dev, struct pvrdma_cq *cq)
 {
-	if (!refcount_dec_and_test(&cq->refcnt))
-		wait_event(cq->wait, !refcount_read(&cq->refcnt));
+	if (refcount_dec_and_test(&cq->refcnt))
+		complete(&cq->free);
+	wait_for_completion(&cq->free);
 
 	if (!cq->is_kernel)
 		ib_umem_release(cq->umem);
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
index 5cff9fa..939ac2f 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
@@ -347,7 +347,7 @@ static void pvrdma_qp_event(struct pvrdma_dev *dev, u32 qpn, int type)
 	}
 	if (qp) {
 		if (refcount_dec_and_test(&qp->refcnt))
-			wake_up(&qp->wait);
+			complete(&qp->free);
 	}
 }
 
@@ -373,7 +373,7 @@ static void pvrdma_cq_event(struct pvrdma_dev *dev, u32 cqn, int type)
 	}
 	if (cq) {
 		if (refcount_dec_and_test(&cq->refcnt))
-			wake_up(&cq->wait);
+			complete(&cq->free);
 	}
 }
 
@@ -402,7 +402,7 @@ static void pvrdma_srq_event(struct pvrdma_dev *dev, u32 srqn, int type)
 	}
 	if (srq) {
 		if (refcount_dec_and_test(&srq->refcnt))
-			wake_up(&srq->wait);
+			complete(&srq->free);
 	}
 }
 
@@ -538,7 +538,7 @@ static irqreturn_t pvrdma_intrx_handler(int irq, void *dev_id)
 			cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context);
 		if (cq) {
 			if (refcount_dec_and_test(&cq->refcnt))
-				wake_up(&cq->wait);
+				complete(&cq->free);
 		}
 		pvrdma_idx_ring_inc(&ring->cons_head, ring_slots);
 	}
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
index 9745cb1..7bf518b 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
@@ -246,7 +246,7 @@ struct ib_qp *pvrdma_create_qp(struct ib_pd *pd,
 		spin_lock_init(&qp->rq.lock);
 		mutex_init(&qp->mutex);
 		refcount_set(&qp->refcnt, 1);
-		init_waitqueue_head(&qp->wait);
+		init_completion(&qp->free);
 
 		qp->state = IB_QPS_RESET;
 		qp->is_kernel = !(pd->uobject && udata);
@@ -427,8 +427,9 @@ static void pvrdma_free_qp(struct pvrdma_qp *qp)
 
 	pvrdma_unlock_cqs(scq, rcq, &scq_flags, &rcq_flags);
 
-	if (!refcount_dec_and_test(&qp->refcnt))
-		wait_event(qp->wait, !refcount_read(&qp->refcnt));
+	if (refcount_dec_and_test(&qp->refcnt))
+		complete(&qp->free);
+	wait_for_completion(&qp->free);
 
 	if (!qp->is_kernel) {
 		if (qp->rumem)
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c
index a2b1a3c..5acebb1 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c
@@ -149,7 +149,7 @@ struct ib_srq *pvrdma_create_srq(struct ib_pd *pd,
 
 	spin_lock_init(&srq->lock);
 	refcount_set(&srq->refcnt, 1);
-	init_waitqueue_head(&srq->wait);
+	init_completion(&srq->free);
 
 	dev_dbg(&dev->pdev->dev,
 		"create shared receive queue from user space\n");
@@ -236,8 +236,9 @@ static void pvrdma_free_srq(struct pvrdma_dev *dev, struct pvrdma_srq *srq)
 	dev->srq_tbl[srq->srq_handle] = NULL;
 	spin_unlock_irqrestore(&dev->srq_tbl_lock, flags);
 
-	if (!refcount_dec_and_test(&srq->refcnt))
-		wait_event(srq->wait, !refcount_read(&srq->refcnt));
+	if (refcount_dec_and_test(&srq->refcnt))
+		complete(&srq->free);
+	wait_for_completion(&srq->free);
 
 	/* There is no support for kernel clients, so this is safe. */
 	ib_umem_release(srq->umem);
-- 
1.8.5.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
