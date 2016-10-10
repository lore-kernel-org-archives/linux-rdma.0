From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/6] IB/hfi1: Add unique txwait_lock for txreq events
Date: Mon, 10 Oct 2016 06:14:28 -0700
Message-ID: <20161010131427.17586.37665.stgit@scvm10.sc.intel.com>
References: <20161010131249.17586.23789.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161010131249.17586.23789.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Profiling suggests that the read_seqbegin() in
the txreq put logic is colliding with other uses
of the iowait lock.

The packet at a time use of this lock dictates a unique
lock to avoid reader/writer collisions when the number
of vTxWait events is low.

In order to support a unique lock the iowait struct embedded
in the QP is extended to remember the lock that protects the queue
head.

The QP destroy removes that QP from any wait list.  It doesn't
need to know the head because of the linked list API, but it does
need to know the lock required to protect the head.

This also opens up the wait logic to have unique per resources locks
which needs to be in future refinement.

Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/iowait.h      |    8 ++++++++
 drivers/infiniband/hw/hfi1/pio.c         |    1 +
 drivers/infiniband/hw/hfi1/qp.c          |   11 ++++++++---
 drivers/infiniband/hw/hfi1/verbs.c       |    4 ++++
 drivers/infiniband/hw/hfi1/verbs.h       |   13 +++++++------
 drivers/infiniband/hw/hfi1/verbs_txreq.c |   13 +++++++------
 6 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/iowait.h b/drivers/infiniband/hw/hfi1/iowait.h
index 2ec6ef3..d9740dd 100644
--- a/drivers/infiniband/hw/hfi1/iowait.h
+++ b/drivers/infiniband/hw/hfi1/iowait.h
@@ -64,6 +64,7 @@ struct sdma_engine;
 /**
  * struct iowait - linkage for delayed progress/waiting
  * @list: used to add/insert into QP/PQ wait lists
+ * @lock: uses to record the list head lock
  * @tx_head: overflow list of sdma_txreq's
  * @sleep: no space callback
  * @wakeup: space callback wakeup
@@ -91,6 +92,11 @@ struct sdma_engine;
  * so sleeping is not allowed.
  *
  * The wait_dma member along with the iow
+ *
+ * The lock field is used by waiters to record
+ * the seqlock_t that guards the list head.
+ * Waiters explicity know that, but the destroy
+ * code that unwaits QPs does not.
  */
 
 struct iowait {
@@ -103,6 +109,7 @@ struct iowait {
 		unsigned seq);
 	void (*wakeup)(struct iowait *wait, int reason);
 	void (*sdma_drained)(struct iowait *wait);
+	seqlock_t *lock;
 	struct work_struct iowork;
 	wait_queue_head_t wait_dma;
 	wait_queue_head_t wait_pio;
@@ -141,6 +148,7 @@ static inline void iowait_init(
 	void (*sdma_drained)(struct iowait *wait))
 {
 	wait->count = 0;
+	wait->lock = NULL;
 	INIT_LIST_HEAD(&wait->list);
 	INIT_LIST_HEAD(&wait->tx_head);
 	INIT_WORK(&wait->iowork, func);
diff --git a/drivers/infiniband/hw/hfi1/pio.c b/drivers/infiniband/hw/hfi1/pio.c
index 50a3a36..385e4dc 100644
--- a/drivers/infiniband/hw/hfi1/pio.c
+++ b/drivers/infiniband/hw/hfi1/pio.c
@@ -1580,6 +1580,7 @@ static void sc_piobufavail(struct send_context *sc)
 		qp = iowait_to_qp(wait);
 		priv = qp->priv;
 		list_del_init(&priv->s_iowait.list);
+		priv->s_iowait.lock = NULL;
 		/* refcount held until actual wake up */
 		qps[n++] = qp;
 	}
diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index 9fc75e7..d752d67 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -196,15 +196,18 @@ static void flush_tx_list(struct rvt_qp *qp)
 static void flush_iowait(struct rvt_qp *qp)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
-	struct hfi1_ibdev *dev = to_idev(qp->ibqp.device);
 	unsigned long flags;
+	seqlock_t *lock = priv->s_iowait.lock;
 
-	write_seqlock_irqsave(&dev->iowait_lock, flags);
+	if (!lock)
+		return;
+	write_seqlock_irqsave(lock, flags);
 	if (!list_empty(&priv->s_iowait.list)) {
 		list_del_init(&priv->s_iowait.list);
+		priv->s_iowait.lock = NULL;
 		rvt_put_qp(qp);
 	}
-	write_sequnlock_irqrestore(&dev->iowait_lock, flags);
+	write_sequnlock_irqrestore(lock, flags);
 }
 
 static inline int opa_mtu_enum_to_int(int mtu)
@@ -543,6 +546,7 @@ static int iowait_sleep(
 			ibp->rvp.n_dmawait++;
 			qp->s_flags |= RVT_S_WAIT_DMA_DESC;
 			list_add_tail(&priv->s_iowait.list, &sde->dmawait);
+			priv->s_iowait.lock = &dev->iowait_lock;
 			trace_hfi1_qpsleep(qp, RVT_S_WAIT_DMA_DESC);
 			rvt_get_qp(qp);
 		}
@@ -964,6 +968,7 @@ void notify_error_qp(struct rvt_qp *qp)
 	if (!list_empty(&priv->s_iowait.list) && !(qp->s_flags & RVT_S_BUSY)) {
 		qp->s_flags &= ~RVT_S_ANY_WAIT_IO;
 		list_del_init(&priv->s_iowait.list);
+		priv->s_iowait.lock = NULL;
 		rvt_put_qp(qp);
 	}
 	write_sequnlock(&dev->iowait_lock);
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index f2f6b5a..9c3c237 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -694,6 +694,7 @@ static void mem_timer(unsigned long data)
 		qp = iowait_to_qp(wait);
 		priv = qp->priv;
 		list_del_init(&priv->s_iowait.list);
+		priv->s_iowait.lock = NULL;
 		/* refcount held until actual wake up */
 		if (!list_empty(list))
 			mod_timer(&dev->mem_timer, jiffies + 1);
@@ -769,6 +770,7 @@ static int wait_kmem(struct hfi1_ibdev *dev,
 				mod_timer(&dev->mem_timer, jiffies + 1);
 			qp->s_flags |= RVT_S_WAIT_KMEM;
 			list_add_tail(&priv->s_iowait.list, &dev->memwait);
+			priv->s_iowait.lock = &dev->iowait_lock;
 			trace_hfi1_qpsleep(qp, RVT_S_WAIT_KMEM);
 			rvt_get_qp(qp);
 		}
@@ -980,6 +982,7 @@ static int pio_wait(struct rvt_qp *qp,
 			qp->s_flags |= flag;
 			was_empty = list_empty(&sc->piowait);
 			list_add_tail(&priv->s_iowait.list, &sc->piowait);
+			priv->s_iowait.lock = &dev->iowait_lock;
 			trace_hfi1_qpsleep(qp, RVT_S_WAIT_PIO);
 			rvt_get_qp(qp);
 			/* counting: only call wantpiobuf_intr if first user */
@@ -1631,6 +1634,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	setup_timer(&dev->mem_timer, mem_timer, (unsigned long)dev);
 
 	seqlock_init(&dev->iowait_lock);
+	seqlock_init(&dev->txwait_lock);
 	INIT_LIST_HEAD(&dev->txwait);
 	INIT_LIST_HEAD(&dev->memwait);
 
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index 1c3815d..7a8af39 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -180,18 +180,19 @@ struct hfi1_ibdev {
 	struct rvt_dev_info rdi; /* Must be first */
 
 	/* QP numbers are shared by all IB ports */
-	/* protect wait lists */
-	seqlock_t iowait_lock;
+	/* protect txwait list */
+	seqlock_t txwait_lock ____cacheline_aligned_in_smp;
 	struct list_head txwait;        /* list for wait verbs_txreq */
 	struct list_head memwait;       /* list for wait kernel memory */
-	struct list_head txreq_free;
 	struct kmem_cache *verbs_txreq_cache;
-	struct timer_list mem_timer;
+	u64 n_txwait;
+	u64 n_kmem_wait;
 
+	/* protect iowait lists */
+	seqlock_t iowait_lock ____cacheline_aligned_in_smp;
 	u64 n_piowait;
 	u64 n_piodrain;
-	u64 n_txwait;
-	u64 n_kmem_wait;
+	struct timer_list mem_timer;
 
 #ifdef CONFIG_DEBUG_FS
 	/* per HFI debugfs */
diff --git a/drivers/infiniband/hw/hfi1/verbs_txreq.c b/drivers/infiniband/hw/hfi1/verbs_txreq.c
index 094ab82..5d23172 100644
--- a/drivers/infiniband/hw/hfi1/verbs_txreq.c
+++ b/drivers/infiniband/hw/hfi1/verbs_txreq.c
@@ -72,22 +72,22 @@ void hfi1_put_txreq(struct verbs_txreq *tx)
 	kmem_cache_free(dev->verbs_txreq_cache, tx);
 
 	do {
-		seq = read_seqbegin(&dev->iowait_lock);
+		seq = read_seqbegin(&dev->txwait_lock);
 		if (!list_empty(&dev->txwait)) {
 			struct iowait *wait;
 
-			write_seqlock_irqsave(&dev->iowait_lock, flags);
+			write_seqlock_irqsave(&dev->txwait_lock, flags);
 			wait = list_first_entry(&dev->txwait, struct iowait,
 						list);
 			qp = iowait_to_qp(wait);
 			priv = qp->priv;
 			list_del_init(&priv->s_iowait.list);
 			/* refcount held until actual wake up */
-			write_sequnlock_irqrestore(&dev->iowait_lock, flags);
+			write_sequnlock_irqrestore(&dev->txwait_lock, flags);
 			hfi1_qp_wakeup(qp, RVT_S_WAIT_TX);
 			break;
 		}
-	} while (read_seqretry(&dev->iowait_lock, seq));
+	} while (read_seqretry(&dev->txwait_lock, seq));
 }
 
 struct verbs_txreq *__get_txreq(struct hfi1_ibdev *dev,
@@ -96,7 +96,7 @@ struct verbs_txreq *__get_txreq(struct hfi1_ibdev *dev,
 {
 	struct verbs_txreq *tx = ERR_PTR(-EBUSY);
 
-	write_seqlock(&dev->iowait_lock);
+	write_seqlock(&dev->txwait_lock);
 	if (ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK) {
 		struct hfi1_qp_priv *priv;
 
@@ -108,13 +108,14 @@ struct verbs_txreq *__get_txreq(struct hfi1_ibdev *dev,
 			dev->n_txwait++;
 			qp->s_flags |= RVT_S_WAIT_TX;
 			list_add_tail(&priv->s_iowait.list, &dev->txwait);
+			priv->s_iowait.lock = &dev->txwait_lock;
 			trace_hfi1_qpsleep(qp, RVT_S_WAIT_TX);
 			rvt_get_qp(qp);
 		}
 		qp->s_flags &= ~RVT_S_BUSY;
 	}
 out:
-	write_sequnlock(&dev->iowait_lock);
+	write_sequnlock(&dev->txwait_lock);
 	return tx;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
