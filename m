From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 8/9] IB/qib: Convert qp_stats debugfs interface to
 use new iterator API
Date: Mon, 28 Aug 2017 11:24:04 -0700
Message-ID: <20170828182403.29434.72314.stgit@scvm10.sc.intel.com>
References: <20170828182121.29434.18989.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170828182121.29434.18989.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Continue porting copy/paste code into rdmavt from qib.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_debugfs.c |   18 ++++-------
 drivers/infiniband/hw/qib/qib_qp.c      |   51 ++++---------------------------
 drivers/infiniband/hw/qib/qib_verbs.h   |   10 +-----
 3 files changed, 16 insertions(+), 63 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_debugfs.c b/drivers/infiniband/hw/qib/qib_debugfs.c
index 5bad8e3..5ed1ed9 100644
--- a/drivers/infiniband/hw/qib/qib_debugfs.c
+++ b/drivers/infiniband/hw/qib/qib_debugfs.c
@@ -1,6 +1,5 @@
-#ifdef CONFIG_DEBUG_FS
 /*
- * Copyright (c) 2013 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2013 - 2017 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -191,10 +190,10 @@ static int _ctx_stats_seq_show(struct seq_file *s, void *v)
 static void *_qp_stats_seq_start(struct seq_file *s, loff_t *pos)
 	__acquires(RCU)
 {
-	struct qib_qp_iter *iter;
+	struct rvt_qp_iter *iter;
 	loff_t n = *pos;
 
-	iter = qib_qp_iter_init(s->private);
+	iter = rvt_qp_iter_init(s->private, 0, NULL);
 
 	/* stop calls rcu_read_unlock */
 	rcu_read_lock();
@@ -203,7 +202,7 @@ static int _ctx_stats_seq_show(struct seq_file *s, void *v)
 		return NULL;
 
 	do {
-		if (qib_qp_iter_next(iter)) {
+		if (rvt_qp_iter_next(iter)) {
 			kfree(iter);
 			return NULL;
 		}
@@ -216,11 +215,11 @@ static int _ctx_stats_seq_show(struct seq_file *s, void *v)
 				   loff_t *pos)
 	__must_hold(RCU)
 {
-	struct qib_qp_iter *iter = iter_ptr;
+	struct rvt_qp_iter *iter = iter_ptr;
 
 	(*pos)++;
 
-	if (qib_qp_iter_next(iter)) {
+	if (rvt_qp_iter_next(iter)) {
 		kfree(iter);
 		return NULL;
 	}
@@ -236,7 +235,7 @@ static void _qp_stats_seq_stop(struct seq_file *s, void *iter_ptr)
 
 static int _qp_stats_seq_show(struct seq_file *s, void *iter_ptr)
 {
-	struct qib_qp_iter *iter = iter_ptr;
+	struct rvt_qp_iter *iter = iter_ptr;
 
 	if (!iter)
 		return 0;
@@ -284,6 +283,3 @@ void qib_dbg_exit(void)
 	debugfs_remove_recursive(qib_dbg_root);
 	qib_dbg_root = NULL;
 }
-
-#endif
-
diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index a343e3b..344e401 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012, 2013 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2012 - 2017 Intel Corporation.  All rights reserved.
  * Copyright (c) 2006 - 2012 QLogic Corporation.  * All rights reserved.
  * Copyright (c) 2005, 2006 PathScale, Inc. All rights reserved.
  *
@@ -415,53 +415,16 @@ int qib_check_send_wqe(struct rvt_qp *qp,
 
 #ifdef CONFIG_DEBUG_FS
 
-struct qib_qp_iter {
-	struct qib_ibdev *dev;
-	struct rvt_qp *qp;
-	int n;
-};
-
-struct qib_qp_iter *qib_qp_iter_init(struct qib_ibdev *dev)
-{
-	struct qib_qp_iter *iter;
-
-	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
-	if (!iter)
-		return NULL;
-
-	iter->dev = dev;
-
-	return iter;
-}
-
-int qib_qp_iter_next(struct qib_qp_iter *iter)
-{
-	struct qib_ibdev *dev = iter->dev;
-	int n = iter->n;
-	int ret = 1;
-	struct rvt_qp *pqp = iter->qp;
-	struct rvt_qp *qp;
-
-	for (; n < dev->rdi.qp_dev->qp_table_size; n++) {
-		if (pqp)
-			qp = rcu_dereference(pqp->next);
-		else
-			qp = rcu_dereference(dev->rdi.qp_dev->qp_table[n]);
-		pqp = qp;
-		if (qp) {
-			iter->qp = qp;
-			iter->n = n;
-			return 0;
-		}
-	}
-	return ret;
-}
-
 static const char * const qp_type_str[] = {
 	"SMI", "GSI", "RC", "UC", "UD",
 };
 
-void qib_qp_iter_print(struct seq_file *s, struct qib_qp_iter *iter)
+/**
+ * qib_qp_iter_print - print information to seq_file
+ * @s - the seq_file
+ * @iter - the iterator
+ */
+void qib_qp_iter_print(struct seq_file *s, struct rvt_qp_iter *iter)
 {
 	struct rvt_swqe *wqe;
 	struct rvt_qp *qp = iter->qp;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index 95e3701..f887737 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012, 2013 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2012 - 2017 Intel Corporation.  All rights reserved.
  * Copyright (c) 2006 - 2012 QLogic Corporation. All rights reserved.
  * Copyright (c) 2005, 2006 PathScale, Inc. All rights reserved.
  *
@@ -282,13 +282,7 @@ int qib_alloc_qpn(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
 void qib_restart_rc(struct rvt_qp *qp, u32 psn, int wait);
 #ifdef CONFIG_DEBUG_FS
 
-struct qib_qp_iter;
-
-struct qib_qp_iter *qib_qp_iter_init(struct qib_ibdev *dev);
-
-int qib_qp_iter_next(struct qib_qp_iter *iter);
-
-void qib_qp_iter_print(struct seq_file *s, struct qib_qp_iter *iter);
+void qib_qp_iter_print(struct seq_file *s, struct rvt_qp_iter *iter);
 
 #endif
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
