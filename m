From: Petr Mladek <pmladek@suse.com>
Subject: [PATCH 2/2] IB/rdmavt: Handle the kthread worker using the new API
Date: Wed, 19 Oct 2016 14:07:20 +0200
Message-ID: <1476878840-14548-3-git-send-email-pmladek@suse.com>
References: <1476878840-14548-1-git-send-email-pmladek@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476878840-14548-1-git-send-email-pmladek@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>
Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>
List-Id: linux-rdma@vger.kernel.org

Use the new API to create and destroy the cq kthread worker.
The API hides some implementation details.

In particular, kthread_create_worker() allocates and initializes
struct kthread_worker. It runs the kthread the right way and stores
task_struct into the worker structure. In addition, the *on_cpu()
variant binds the kthread to the given cpu and the related memory
node.

kthread_destroy_worker() flushes all pending works, stops
the kthread and frees the structure.

This patch does not change the existing behavior. Note that we must
use the on_cpu() variant because the function starts the kthread
and it must bind it to the right CPU before waking. The numa node
is associated for given CPU as well.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 drivers/infiniband/sw/rdmavt/cq.c | 34 +++++++++++-----------------------
 1 file changed, 11 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/cq.c b/drivers/infiniband/sw/rdmavt/cq.c
index 223ec4589fc7..4d0b6992e847 100644
--- a/drivers/infiniband/sw/rdmavt/cq.c
+++ b/drivers/infiniband/sw/rdmavt/cq.c
@@ -503,33 +503,23 @@ int rvt_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry)
  */
 int rvt_driver_cq_init(struct rvt_dev_info *rdi)
 {
-	int ret = 0;
 	int cpu;
-	struct task_struct *task;
+	struct kthread_worker *worker;
 
 	if (rdi->worker)
 		return 0;
+
 	spin_lock_init(&rdi->n_cqs_lock);
-	rdi->worker = kzalloc(sizeof(*rdi->worker), GFP_KERNEL);
-	if (!rdi->worker)
-		return -ENOMEM;
-	kthread_init_worker(rdi->worker);
-	task = kthread_create_on_node(
-		kthread_worker_fn,
-		rdi->worker,
-		rdi->dparms.node,
-		"%s", rdi->dparms.cq_name);
-	if (IS_ERR(task)) {
-		kfree(rdi->worker);
-		rdi->worker = NULL;
-		return PTR_ERR(task);
-	}
 
-	set_user_nice(task, MIN_NICE);
 	cpu = cpumask_first(cpumask_of_node(rdi->dparms.node));
-	kthread_bind(task, cpu);
-	wake_up_process(task);
-	return ret;
+	worker = kthread_create_worker_on_cpu(cpu, 0,
+					      "%s", rdi->dparms.cq_name);
+	if (IS_ERR(worker))
+		return PTR_ERR(worker);
+
+	set_user_nice(worker->task, MIN_NICE);
+	rdi->worker = worker;
+	return 0;
 }
 
 /**
@@ -549,7 +539,5 @@ void rvt_cq_exit(struct rvt_dev_info *rdi)
 	rdi->worker = NULL;
 	spin_unlock_irq(&rdi->n_cqs_lock);
 
-	kthread_flush_worker(worker);
-	kthread_stop(worker->task);
-	kfree(worker);
+	kthread_destroy_worker(worker);
 }
-- 
1.8.5.6
