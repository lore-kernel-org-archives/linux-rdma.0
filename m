From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH] IB/fmr_pool: Convert the cleanup thread into kthread worker API
Date: Mon, 17 Oct 2016 17:39:32 +0200
Message-ID: <1476718772-9760-1-git-send-email-pmladek@suse.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Kthreads are currently implemented as an infinite loop. Each
has its own variant of checks for terminating, freezing,
awakening. In many cases it is unclear to say in which state
it is and sometimes it is done a wrong way.

The plan is to convert kthreads into kthread_worker or workqueues
API. It allows to split the functionality into separate operations.
It helps to make a better structure. Also it defines a clean state
where no locks are taken, IRQs blocked, the kthread might sleep
or even be safely migrated.

The kthread worker API is useful when we want to have a dedicated
single thread for the work. It helps to make sure that it is
available when needed. Also it allows a better control, e.g.
define a scheduling priority.

This patch converts the frm_pool kthread into the kthread worker
API because I am not sure how busy the thread is. It is well
possible that it does not need a dedicated kthread and workqueues
would be perfectly fine. Well, the conversion between kthread
worker API and workqueues is pretty trivial.

The patch moves one iteration from the kthread into the work function.
It is queued only when there is a pending work. Therefore we do not
need to compare flush_ser and req_ser at the beginning. On the contrary,
the same work could be queued only once at a time. Therefore it has to
re-queue itself if some requests are pending.

Otherwise, wake_up_process() is replaced by queuing the work.

Important: The change is only compile tested. I did not find an easy
way how to check it in a real life.

Signed-off-by: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
TO: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
CC: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---

The kthread worker API improvements are in 4.9-rc1. Therefore
we could finally start converting kthreads that fit this API.

 drivers/infiniband/core/fmr_pool.c | 49 +++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/core/fmr_pool.c b/drivers/infiniband/core/fmr_pool.c
index cdbb1f1a6d97..5ec8cf398d02 100644
--- a/drivers/infiniband/core/fmr_pool.c
+++ b/drivers/infiniband/core/fmr_pool.c
@@ -96,7 +96,8 @@ struct ib_fmr_pool {
 						   void *              arg);
 	void                     *flush_arg;
 
-	struct task_struct       *thread;
+	struct kthread_worker	  *worker;
+	struct kthread_work	  work;
 
 	atomic_t                  req_ser;
 	atomic_t                  flush_ser;
@@ -174,29 +175,19 @@ static void ib_fmr_batch_release(struct ib_fmr_pool *pool)
 	spin_unlock_irq(&pool->pool_lock);
 }
 
-static int ib_fmr_cleanup_thread(void *pool_ptr)
+static void ib_fmr_cleanup_func(struct kthread_work *work)
 {
-	struct ib_fmr_pool *pool = pool_ptr;
+	struct ib_fmr_pool *pool = container_of(work, struct ib_fmr_pool, work);
 
-	do {
-		if (atomic_read(&pool->flush_ser) - atomic_read(&pool->req_ser) < 0) {
-			ib_fmr_batch_release(pool);
-
-			atomic_inc(&pool->flush_ser);
-			wake_up_interruptible(&pool->force_wait);
-
-			if (pool->flush_function)
-				pool->flush_function(pool, pool->flush_arg);
-		}
+	ib_fmr_batch_release(pool);
+	atomic_inc(&pool->flush_ser);
+	wake_up_interruptible(&pool->force_wait);
 
-		set_current_state(TASK_INTERRUPTIBLE);
-		if (atomic_read(&pool->flush_ser) - atomic_read(&pool->req_ser) >= 0 &&
-		    !kthread_should_stop())
-			schedule();
-		__set_current_state(TASK_RUNNING);
-	} while (!kthread_should_stop());
+	if (pool->flush_function)
+		pool->flush_function(pool, pool->flush_arg);
 
-	return 0;
+	if (atomic_read(&pool->flush_ser) - atomic_read(&pool->req_ser) < 0)
+		kthread_queue_work(pool->worker, &pool->work);
 }
 
 /**
@@ -266,15 +257,13 @@ struct ib_fmr_pool *ib_create_fmr_pool(struct ib_pd             *pd,
 	atomic_set(&pool->flush_ser, 0);
 	init_waitqueue_head(&pool->force_wait);
 
-	pool->thread = kthread_run(ib_fmr_cleanup_thread,
-				   pool,
-				   "ib_fmr(%s)",
-				   device->name);
-	if (IS_ERR(pool->thread)) {
-		pr_warn(PFX "couldn't start cleanup thread\n");
-		ret = PTR_ERR(pool->thread);
+	pool->worker = kthread_create_worker(0, "ib_fmr(%s)", device->name);
+	if (IS_ERR(pool->worker)) {
+		pr_warn(PFX "couldn't start cleanup kthread worker\n");
+		ret = PTR_ERR(pool->worker);
 		goto out_free_pool;
 	}
+	kthread_init_work(&pool->work, ib_fmr_cleanup_func);
 
 	{
 		struct ib_pool_fmr *fmr;
@@ -339,7 +328,7 @@ void ib_destroy_fmr_pool(struct ib_fmr_pool *pool)
 	LIST_HEAD(fmr_list);
 	int                 i;
 
-	kthread_stop(pool->thread);
+	kthread_destroy_worker(pool->worker);
 	ib_fmr_batch_release(pool);
 
 	i = 0;
@@ -389,7 +378,7 @@ int ib_flush_fmr_pool(struct ib_fmr_pool *pool)
 	spin_unlock_irq(&pool->pool_lock);
 
 	serial = atomic_inc_return(&pool->req_ser);
-	wake_up_process(pool->thread);
+	kthread_queue_work(pool->worker, &pool->work);
 
 	if (wait_event_interruptible(pool->force_wait,
 				     atomic_read(&pool->flush_ser) - serial >= 0))
@@ -503,7 +492,7 @@ int ib_fmr_pool_unmap(struct ib_pool_fmr *fmr)
 			list_add_tail(&fmr->list, &pool->dirty_list);
 			if (++pool->dirty_len >= pool->dirty_watermark) {
 				atomic_inc(&pool->req_ser);
-				wake_up_process(pool->thread);
+				kthread_queue_work(pool->worker, &pool->work);
 			}
 		}
 	}
-- 
1.8.5.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
