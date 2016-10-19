From: Petr Mladek <pmladek@suse.com>
Subject: [PATCH 1/2] IB/rdmavt: Avoid queuing work into a destroyed cq kthread worker
Date: Wed, 19 Oct 2016 14:07:19 +0200
Message-ID: <1476878840-14548-2-git-send-email-pmladek@suse.com>
References: <1476878840-14548-1-git-send-email-pmladek@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476878840-14548-1-git-send-email-pmladek@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>
Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>
List-Id: linux-rdma@vger.kernel.org

The memory barrier is not enough to protect queuing works into
a destroyed cq kthread. Just imagine the following situation:

CPU1				CPU2

rvt_cq_enter()
  worker =  cq->rdi->worker;

				rvt_cq_exit()
				  rdi->worker = NULL;
				  smp_wmb();
				  kthread_flush_worker(worker);
				  kthread_stop(worker->task);
				  kfree(worker);

				  // nothing queued yet =>
				  // nothing flushed and
				  // happily stopped and freed

  if (likely(worker)) {
     // true => read before CPU2 acted
     cq->notify = RVT_CQ_NONE;
     cq->triggered++;
     kthread_queue_work(worker, &cq->comptask);

  BANG: worker has been flushed/stopped/freed in the meantime.

This patch solves this by protecting the critical sections by
rdi->n_cqs_lock. It seems that this lock is not much contended
and looks reasonable for this purpose.

One catch is that rvt_cq_enter() might be called from IRQ context.
Therefore we must always take the lock with IRQs disabled to avoid
a possible deadlock.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 drivers/infiniband/sw/rdmavt/cq.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/cq.c b/drivers/infiniband/sw/rdmavt/cq.c
index 6d9904a4a0ab..223ec4589fc7 100644
--- a/drivers/infiniband/sw/rdmavt/cq.c
+++ b/drivers/infiniband/sw/rdmavt/cq.c
@@ -119,18 +119,17 @@ void rvt_cq_enter(struct rvt_cq *cq, struct ib_wc *entry, bool solicited)
 	if (cq->notify == IB_CQ_NEXT_COMP ||
 	    (cq->notify == IB_CQ_SOLICITED &&
 	     (solicited || entry->status != IB_WC_SUCCESS))) {
-		struct kthread_worker *worker;
 		/*
 		 * This will cause send_complete() to be called in
 		 * another thread.
 		 */
-		smp_read_barrier_depends(); /* see rvt_cq_exit */
-		worker = cq->rdi->worker;
-		if (likely(worker)) {
+		spin_lock(&cq->rdi->n_cqs_lock);
+		if (likely(cq->rdi->worker)) {
 			cq->notify = RVT_CQ_NONE;
 			cq->triggered++;
-			kthread_queue_work(worker, &cq->comptask);
+			kthread_queue_work(cq->rdi->worker, &cq->comptask);
 		}
+		spin_unlock(&cq->rdi->n_cqs_lock);
 	}
 
 	spin_unlock_irqrestore(&cq->lock, flags);
@@ -240,15 +239,15 @@ struct ib_cq *rvt_create_cq(struct ib_device *ibdev,
 		}
 	}
 
-	spin_lock(&rdi->n_cqs_lock);
+	spin_lock_irq(&rdi->n_cqs_lock);
 	if (rdi->n_cqs_allocated == rdi->dparms.props.max_cq) {
-		spin_unlock(&rdi->n_cqs_lock);
+		spin_unlock_irq(&rdi->n_cqs_lock);
 		ret = ERR_PTR(-ENOMEM);
 		goto bail_ip;
 	}
 
 	rdi->n_cqs_allocated++;
-	spin_unlock(&rdi->n_cqs_lock);
+	spin_unlock_irq(&rdi->n_cqs_lock);
 
 	if (cq->ip) {
 		spin_lock_irq(&rdi->pending_lock);
@@ -296,9 +295,9 @@ int rvt_destroy_cq(struct ib_cq *ibcq)
 	struct rvt_dev_info *rdi = cq->rdi;
 
 	kthread_flush_work(&cq->comptask);
-	spin_lock(&rdi->n_cqs_lock);
+	spin_lock_irq(&rdi->n_cqs_lock);
 	rdi->n_cqs_allocated--;
-	spin_unlock(&rdi->n_cqs_lock);
+	spin_unlock_irq(&rdi->n_cqs_lock);
 	if (cq->ip)
 		kref_put(&cq->ip->ref, rvt_release_mmap_info);
 	else
@@ -541,12 +540,15 @@ void rvt_cq_exit(struct rvt_dev_info *rdi)
 {
 	struct kthread_worker *worker;
 
-	worker = rdi->worker;
-	if (!worker)
+	/* block future queuing from send_complete() */
+	spin_lock_irq(&rdi->n_cqs_lock);
+	if (!rdi->worker) {
+		spin_unlock_irq(&rdi->n_cqs_lock);
 		return;
-	/* blocks future queuing from send_complete() */
+	}
 	rdi->worker = NULL;
-	smp_wmb(); /* See rdi_cq_enter */
+	spin_unlock_irq(&rdi->n_cqs_lock);
+
 	kthread_flush_worker(worker);
 	kthread_stop(worker->task);
 	kfree(worker);
-- 
1.8.5.6
