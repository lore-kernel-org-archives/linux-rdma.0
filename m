From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: optimize CQ callbacks
Date: Tue, 04 Jun 2013 15:05:37 -0400
Message-ID: <20130604190537.18766.4331.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The current workqueue implemention has the following performance
deficiencies on QDR HCAs:
- The CQ call backs tend to run on the CPUs processing the
receive queues
- The single thread queue isn't optimal for multiple HCAs

This patch adds a dedicated per HCA bound thread to process CQ callbacks.

Reviewed-by: Ramkrishna Vepa <ramkrishna.vepa-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib.h       |    5 ++
 drivers/infiniband/hw/qib/qib_cq.c    |   67 ++++++++++++++++++++++++++++++---
 drivers/infiniband/hw/qib/qib_init.c  |   18 ++-------
 drivers/infiniband/hw/qib/qib_verbs.h |   10 +++--
 4 files changed, 76 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index ca740d8..04a9aad 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -1,7 +1,7 @@
 #ifndef _QIB_KERNEL_H
 #define _QIB_KERNEL_H
 /*
- * Copyright (c) 2012 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2012, 2013 Intel Corporation.  All rights reserved.
  * Copyright (c) 2006 - 2012 QLogic Corporation. All rights reserved.
  * Copyright (c) 2003, 2004, 2005, 2006 PathScale, Inc. All rights reserved.
  *
@@ -51,6 +51,7 @@
 #include <linux/completion.h>
 #include <linux/kref.h>
 #include <linux/sched.h>
+#include <linux/kthread.h>
 
 #include "qib_common.h"
 #include "qib_verbs.h"
@@ -1094,6 +1095,8 @@ struct qib_devdata {
 	u16 psxmitwait_check_rate;
 	/* high volume overflow errors defered to tasklet */
 	struct tasklet_struct error_tasklet;
+	/* per device cq worker */
+	struct kthread_worker *worker;
 
 	int assigned_node_id; /* NUMA node closest to HCA */
 };
diff --git a/drivers/infiniband/hw/qib/qib_cq.c b/drivers/infiniband/hw/qib/qib_cq.c
index 5246aa4..ab4e11c 100644
--- a/drivers/infiniband/hw/qib/qib_cq.c
+++ b/drivers/infiniband/hw/qib/qib_cq.c
@@ -1,4 +1,5 @@
 /*
+ * Copyright (c) 2013 Intel Corporation.  All rights reserved.
  * Copyright (c) 2006, 2007, 2008, 2010 QLogic Corporation. All rights reserved.
  * Copyright (c) 2005, 2006 PathScale, Inc. All rights reserved.
  *
@@ -34,8 +35,10 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/kthread.h>
 
 #include "qib_verbs.h"
+#include "qib.h"
 
 /**
  * qib_cq_enter - add a new entry to the completion queue
@@ -102,13 +105,18 @@ void qib_cq_enter(struct qib_cq *cq, struct ib_wc *entry, int solicited)
 	if (cq->notify == IB_CQ_NEXT_COMP ||
 	    (cq->notify == IB_CQ_SOLICITED &&
 	     (solicited || entry->status != IB_WC_SUCCESS))) {
-		cq->notify = IB_CQ_NONE;
-		cq->triggered++;
+		struct kthread_worker *worker;
 		/*
 		 * This will cause send_complete() to be called in
 		 * another thread.
 		 */
-		queue_work(qib_cq_wq, &cq->comptask);
+		smp_rmb();
+		worker = cq->dd->worker;
+		if (likely(worker)) {
+			cq->notify = IB_CQ_NONE;
+			cq->triggered++;
+			queue_kthread_work(worker, &cq->comptask);
+		}
 	}
 
 	spin_unlock_irqrestore(&cq->lock, flags);
@@ -163,7 +171,7 @@ bail:
 	return npolled;
 }
 
-static void send_complete(struct work_struct *work)
+static void send_complete(struct kthread_work *work)
 {
 	struct qib_cq *cq = container_of(work, struct qib_cq, comptask);
 
@@ -287,11 +295,12 @@ struct ib_cq *qib_create_cq(struct ib_device *ibdev, int entries,
 	 * The number of entries should be >= the number requested or return
 	 * an error.
 	 */
+	cq->dd = dd_from_dev(dev);
 	cq->ibcq.cqe = entries;
 	cq->notify = IB_CQ_NONE;
 	cq->triggered = 0;
 	spin_lock_init(&cq->lock);
-	INIT_WORK(&cq->comptask, send_complete);
+	init_kthread_work(&cq->comptask, send_complete);
 	wc->head = 0;
 	wc->tail = 0;
 	cq->queue = wc;
@@ -323,7 +332,7 @@ int qib_destroy_cq(struct ib_cq *ibcq)
 	struct qib_ibdev *dev = to_idev(ibcq->device);
 	struct qib_cq *cq = to_icq(ibcq);
 
-	flush_work(&cq->comptask);
+	flush_kthread_work(&cq->comptask);
 	spin_lock(&dev->n_cqs_lock);
 	dev->n_cqs_allocated--;
 	spin_unlock(&dev->n_cqs_lock);
@@ -483,3 +492,49 @@ bail_free:
 bail:
 	return ret;
 }
+
+int qib_cq_init(struct qib_devdata *dd)
+{
+	int ret = 0;
+	int cpu;
+	struct task_struct *task;
+
+	if (dd->worker)
+		return 0;
+	dd->worker = kzalloc(sizeof(*dd->worker), GFP_KERNEL);
+	if (!dd->worker)
+		return -ENOMEM;
+	init_kthread_worker(dd->worker);
+	task = kthread_create_on_node(
+		kthread_worker_fn,
+		dd->worker,
+		dd->assigned_node_id,
+		"qib_cq%d", dd->unit);
+	if (IS_ERR(task))
+		goto task_fail;
+	cpu = cpumask_first(cpumask_of_node(dd->assigned_node_id));
+	kthread_bind(task, cpu);
+	wake_up_process(task);
+out:
+	return ret;
+task_fail:
+	ret = PTR_ERR(task);
+	kfree(dd->worker);
+	dd->worker = NULL;
+	goto out;
+}
+
+void qib_cq_exit(struct qib_devdata *dd)
+{
+	struct kthread_worker *worker;
+
+	worker = dd->worker;
+	if (!worker)
+		return;
+	/* blocks future queuing from send_complete() */
+	dd->worker = NULL;
+	smp_wmb();
+	flush_kthread_worker(worker);
+	kthread_stop(worker->task);
+	kfree(worker);
+}
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index e02217b..ff36903 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -97,8 +97,6 @@ unsigned qib_wc_pat = 1; /* default (1) is to use PAT, not MTRR */
 module_param_named(wc_pat, qib_wc_pat, uint, S_IRUGO);
 MODULE_PARM_DESC(wc_pat, "enable write-combining via PAT mechanism");
 
-struct workqueue_struct *qib_cq_wq;
-
 static void verify_interrupt(unsigned long);
 
 static struct idr qib_unit_table;
@@ -445,6 +443,7 @@ static int loadtime_init(struct qib_devdata *dd)
 	dd->intrchk_timer.function = verify_interrupt;
 	dd->intrchk_timer.data = (unsigned long) dd;
 
+	ret = qib_cq_init(dd);
 done:
 	return ret;
 }
@@ -1215,12 +1214,6 @@ static int __init qlogic_ib_init(void)
 	if (ret)
 		goto bail;
 
-	qib_cq_wq = create_singlethread_workqueue("qib_cq");
-	if (!qib_cq_wq) {
-		ret = -ENOMEM;
-		goto bail_dev;
-	}
-
 	/*
 	 * These must be called before the driver is registered with
 	 * the PCI subsystem.
@@ -1233,7 +1226,7 @@ static int __init qlogic_ib_init(void)
 	ret = pci_register_driver(&qib_driver);
 	if (ret < 0) {
 		pr_err("Unable to register driver: error %d\n", -ret);
-		goto bail_unit;
+		goto bail_dev;
 	}
 
 	/* not fatal if it doesn't work */
@@ -1241,13 +1234,11 @@ static int __init qlogic_ib_init(void)
 		pr_err("Unable to register ipathfs\n");
 	goto bail; /* all OK */
 
-bail_unit:
+bail_dev:
 #ifdef CONFIG_INFINIBAND_QIB_DCA
 	dca_unregister_notify(&dca_notifier);
 #endif
 	idr_destroy(&qib_unit_table);
-	destroy_workqueue(qib_cq_wq);
-bail_dev:
 	qib_dev_cleanup();
 bail:
 	return ret;
@@ -1273,8 +1264,6 @@ static void __exit qlogic_ib_cleanup(void)
 #endif
 	pci_unregister_driver(&qib_driver);
 
-	destroy_workqueue(qib_cq_wq);
-
 	qib_cpulist_count = 0;
 	kfree(qib_cpulist);
 
@@ -1365,6 +1354,7 @@ static void cleanup_device_data(struct qib_devdata *dd)
 	}
 	kfree(tmp);
 	kfree(dd->boardname);
+	qib_cq_exit(dd);
 }
 
 /*
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index aff8b2c..86c2cb3 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -41,6 +41,7 @@
 #include <linux/interrupt.h>
 #include <linux/kref.h>
 #include <linux/workqueue.h>
+#include <linux/kthread.h>
 #include <linux/completion.h>
 #include <rdma/ib_pack.h>
 #include <rdma/ib_user_verbs.h>
@@ -267,7 +268,8 @@ struct qib_cq_wc {
  */
 struct qib_cq {
 	struct ib_cq ibcq;
-	struct work_struct comptask;
+	struct kthread_work comptask;
+	struct qib_devdata *dd;
 	spinlock_t lock; /* protect changes in this struct */
 	u8 notify;
 	u8 triggered;
@@ -832,8 +834,6 @@ static inline int qib_send_ok(struct qib_qp *qp)
 		 !(qp->s_flags & QIB_S_ANY_WAIT_SEND));
 }
 
-extern struct workqueue_struct *qib_cq_wq;
-
 /*
  * This must be called with s_lock held.
  */
@@ -972,6 +972,10 @@ int qib_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr);
 
 int qib_destroy_srq(struct ib_srq *ibsrq);
 
+int qib_cq_init(struct qib_devdata *dd);
+
+void qib_cq_exit(struct qib_devdata *dd);
+
 void qib_cq_enter(struct qib_cq *cq, struct ib_wc *entry, int sig);
 
 int qib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
