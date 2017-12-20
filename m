From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 for-rc 4/4] RDMA/vmw_pvrdma: Avoid use after free due to
 QP/CQ/SRQ destroy
Date: Wed, 20 Dec 2017 09:51:40 -0800
Message-ID: <20171220175126.GA23572@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
References: <20171220174748.GA18149@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171220174748.GA18149-qXbCdz4EeRo1jLI2hToXVI42T8aCTgcwy4vvyvUx+exJXi8ZT2ovy+oDBWuYMCC/JZORHMmSJCU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The use of wait queues in vmw_pvrdma for handling concurrent
access to a resource leaves a possible use after free bug.
Fix this by using completions instead, and also using
atomic_dec_and_test to ensure complete() is called only once.

Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h      |  6 +++---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c   |  7 ++++---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c | 17 +++++++----------
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c   |  7 ++++---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c  |  7 ++++---
 5 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
index 63bc2ef..4f7bd3b6 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
@@ -94,7 +94,7 @@ struct pvrdma_cq {
 	u32 cq_handle;
 	bool is_kernel;
 	atomic_t refcnt;
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
 	atomic_t refcnt;
-	wait_queue_head_t wait;
+	struct completion free;
 };
 
 struct pvrdma_dev {
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
index 3562c0c..e529622 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
@@ -179,7 +179,7 @@ struct ib_cq *pvrdma_create_cq(struct ib_device *ibdev,
 		pvrdma_page_dir_insert_umem(&cq->pdir, cq->umem, 0);
 
 	atomic_set(&cq->refcnt, 1);
-	init_waitqueue_head(&cq->wait);
+	init_completion(&cq->free);
 	spin_lock_init(&cq->cq_lock);
 
 	memset(cmd, 0, sizeof(*cmd));
@@ -230,8 +230,9 @@ struct ib_cq *pvrdma_create_cq(struct ib_device *ibdev,
 
 static void pvrdma_free_cq(struct pvrdma_dev *dev, struct pvrdma_cq *cq)
 {
-	atomic_dec(&cq->refcnt);
-	wait_event(cq->wait, !atomic_read(&cq->refcnt));
+	if (atomic_dec_and_test(&cq->refcnt))
+		complete(&cq->free);
+	wait_for_completion(&cq->free);
 
 	if (!cq->is_kernel)
 		ib_umem_release(cq->umem);
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
index 1f4e187..e926818 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
@@ -346,9 +346,8 @@ static void pvrdma_qp_event(struct pvrdma_dev *dev, u32 qpn, int type)
 		ibqp->event_handler(&e, ibqp->qp_context);
 	}
 	if (qp) {
-		atomic_dec(&qp->refcnt);
-		if (atomic_read(&qp->refcnt) == 0)
-			wake_up(&qp->wait);
+		if (atomic_dec_and_test(&qp->refcnt))
+			complete(&qp->free);
 	}
 }
 
@@ -373,9 +372,8 @@ static void pvrdma_cq_event(struct pvrdma_dev *dev, u32 cqn, int type)
 		ibcq->event_handler(&e, ibcq->cq_context);
 	}
 	if (cq) {
-		atomic_dec(&cq->refcnt);
-		if (atomic_read(&cq->refcnt) == 0)
-			wake_up(&cq->wait);
+		if (atomic_dec_and_test(&cq->refcnt))
+			complete(&cq->free);
 	}
 }
 
@@ -404,7 +402,7 @@ static void pvrdma_srq_event(struct pvrdma_dev *dev, u32 srqn, int type)
 	}
 	if (srq) {
 		if (refcount_dec_and_test(&srq->refcnt))
-			wake_up(&srq->wait);
+			complete(&srq->free);
 	}
 }
 
@@ -539,9 +537,8 @@ static irqreturn_t pvrdma_intrx_handler(int irq, void *dev_id)
 		if (cq && cq->ibcq.comp_handler)
 			cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context);
 		if (cq) {
-			atomic_dec(&cq->refcnt);
-			if (atomic_read(&cq->refcnt))
-				wake_up(&cq->wait);
+			if (atomic_dec_and_test(&cq->refcnt))
+				complete(&cq->free);
 		}
 		pvrdma_idx_ring_inc(&ring->cons_head, ring_slots);
 	}
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
index dceebc6..4059308 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
@@ -246,7 +246,7 @@ struct ib_qp *pvrdma_create_qp(struct ib_pd *pd,
 		spin_lock_init(&qp->rq.lock);
 		mutex_init(&qp->mutex);
 		atomic_set(&qp->refcnt, 1);
-		init_waitqueue_head(&qp->wait);
+		init_completion(&qp->free);
 
 		qp->state = IB_QPS_RESET;
 
@@ -428,8 +428,9 @@ static void pvrdma_free_qp(struct pvrdma_qp *qp)
 
 	pvrdma_unlock_cqs(scq, rcq, &scq_flags, &rcq_flags);
 
-	atomic_dec(&qp->refcnt);
-	wait_event(qp->wait, !atomic_read(&qp->refcnt));
+	if (atomic_dec_and_test(&qp->refcnt))
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
