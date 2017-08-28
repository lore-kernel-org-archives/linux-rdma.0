From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 7/9] IB/hfi1: Convert qp_stats debugfs interface to
 use new iterator API
Date: Mon, 28 Aug 2017 11:23:58 -0700
Message-ID: <20170828182356.29434.75056.stgit@scvm10.sc.intel.com>
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

Continue moving copy/paste code into rdmavt.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/debugfs.c |   15 ++----
 drivers/infiniband/hw/hfi1/qp.c      |   83 ++--------------------------------
 drivers/infiniband/hw/hfi1/qp.h      |   23 +--------
 3 files changed, 14 insertions(+), 107 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/debugfs.c b/drivers/infiniband/hw/hfi1/debugfs.c
index c6a472f..36ae1fd 100644
--- a/drivers/infiniband/hw/hfi1/debugfs.c
+++ b/drivers/infiniband/hw/hfi1/debugfs.c
@@ -1,4 +1,3 @@
-#ifdef CONFIG_DEBUG_FS
 /*
  * Copyright(c) 2015-2017 Intel Corporation.
  *
@@ -267,10 +266,10 @@ static int _ctx_stats_seq_show(struct seq_file *s, void *v)
 static void *_qp_stats_seq_start(struct seq_file *s, loff_t *pos)
 	__acquires(RCU)
 {
-	struct qp_iter *iter;
+	struct rvt_qp_iter *iter;
 	loff_t n = *pos;
 
-	iter = qp_iter_init(s->private);
+	iter = rvt_qp_iter_init(s->private, 0, NULL);
 
 	/* stop calls rcu_read_unlock */
 	rcu_read_lock();
@@ -279,7 +278,7 @@ static int _ctx_stats_seq_show(struct seq_file *s, void *v)
 		return NULL;
 
 	do {
-		if (qp_iter_next(iter)) {
+		if (rvt_qp_iter_next(iter)) {
 			kfree(iter);
 			return NULL;
 		}
@@ -292,11 +291,11 @@ static int _ctx_stats_seq_show(struct seq_file *s, void *v)
 				loff_t *pos)
 	__must_hold(RCU)
 {
-	struct qp_iter *iter = iter_ptr;
+	struct rvt_qp_iter *iter = iter_ptr;
 
 	(*pos)++;
 
-	if (qp_iter_next(iter)) {
+	if (rvt_qp_iter_next(iter)) {
 		kfree(iter);
 		return NULL;
 	}
@@ -312,7 +311,7 @@ static void _qp_stats_seq_stop(struct seq_file *s, void *iter_ptr)
 
 static int _qp_stats_seq_show(struct seq_file *s, void *iter_ptr)
 {
-	struct qp_iter *iter = iter_ptr;
+	struct rvt_qp_iter *iter = iter_ptr;
 
 	if (!iter)
 		return 0;
@@ -1535,5 +1534,3 @@ void hfi1_dbg_exit(void)
 	debugfs_remove_recursive(hfi1_dbg_root);
 	hfi1_dbg_root = NULL;
 }
-
-#endif
diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index af71131..4b01ccd 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -530,82 +530,6 @@ struct send_context *qp_to_send_context(struct rvt_qp *qp, u8 sc5)
 					  sc5);
 }
 
-struct qp_iter {
-	struct hfi1_ibdev *dev;
-	struct rvt_qp *qp;
-	int specials;
-	int n;
-};
-
-struct qp_iter *qp_iter_init(struct hfi1_ibdev *dev)
-{
-	struct qp_iter *iter;
-
-	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
-	if (!iter)
-		return NULL;
-
-	iter->dev = dev;
-	iter->specials = dev->rdi.ibdev.phys_port_cnt * 2;
-
-	return iter;
-}
-
-int qp_iter_next(struct qp_iter *iter)
-{
-	struct hfi1_ibdev *dev = iter->dev;
-	int n = iter->n;
-	int ret = 1;
-	struct rvt_qp *pqp = iter->qp;
-	struct rvt_qp *qp;
-
-	/*
-	 * The approach is to consider the special qps
-	 * as an additional table entries before the
-	 * real hash table.  Since the qp code sets
-	 * the qp->next hash link to NULL, this works just fine.
-	 *
-	 * iter->specials is 2 * # ports
-	 *
-	 * n = 0..iter->specials is the special qp indices
-	 *
-	 * n = iter->specials..dev->rdi.qp_dev->qp_table_size+iter->specials are
-	 * the potential hash bucket entries
-	 *
-	 */
-	for (; n <  dev->rdi.qp_dev->qp_table_size + iter->specials; n++) {
-		if (pqp) {
-			qp = rcu_dereference(pqp->next);
-		} else {
-			if (n < iter->specials) {
-				struct hfi1_pportdata *ppd;
-				struct hfi1_ibport *ibp;
-				int pidx;
-
-				pidx = n % dev->rdi.ibdev.phys_port_cnt;
-				ppd = &dd_from_dev(dev)->pport[pidx];
-				ibp = &ppd->ibport_data;
-
-				if (!(n & 1))
-					qp = rcu_dereference(ibp->rvp.qp[0]);
-				else
-					qp = rcu_dereference(ibp->rvp.qp[1]);
-			} else {
-				qp = rcu_dereference(
-					dev->rdi.qp_dev->qp_table[
-						(n - iter->specials)]);
-			}
-		}
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
@@ -619,7 +543,12 @@ static int qp_idle(struct rvt_qp *qp)
 		qp->s_tail == qp->s_head;
 }
 
-void qp_iter_print(struct seq_file *s, struct qp_iter *iter)
+/**
+ * qp_iter_print - print the qp information to seq_file
+ * @s: the seq_file to emit the qp information on
+ * @iter: the iterator for the qp hash list
+ */
+void qp_iter_print(struct seq_file *s, struct rvt_qp_iter *iter)
 {
 	struct rvt_swqe *wqe;
 	struct rvt_qp *qp = iter->qp;
diff --git a/drivers/infiniband/hw/hfi1/qp.h b/drivers/infiniband/hw/hfi1/qp.h
index 6fe542b..c06d2f8 100644
--- a/drivers/infiniband/hw/hfi1/qp.h
+++ b/drivers/infiniband/hw/hfi1/qp.h
@@ -1,7 +1,7 @@
 #ifndef _QP_H
 #define _QP_H
 /*
- * Copyright(c) 2015, 2016 Intel Corporation.
+ * Copyright(c) 2015 - 2017 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
@@ -94,26 +94,7 @@ struct ib_qp *hfi1_create_qp(struct ib_pd *ibpd,
 struct sdma_engine *qp_to_sdma_engine(struct rvt_qp *qp, u8 sc5);
 struct send_context *qp_to_send_context(struct rvt_qp *qp, u8 sc5);
 
-struct qp_iter;
-
-/**
- * qp_iter_init - initialize the iterator for the qp hash list
- * @dev: the hfi1_ibdev
- */
-struct qp_iter *qp_iter_init(struct hfi1_ibdev *dev);
-
-/**
- * qp_iter_next - Find the next qp in the hash list
- * @iter: the iterator for the qp hash list
- */
-int qp_iter_next(struct qp_iter *iter);
-
-/**
- * qp_iter_print - print the qp information to seq_file
- * @s: the seq_file to emit the qp information on
- * @iter: the iterator for the qp hash list
- */
-void qp_iter_print(struct seq_file *s, struct qp_iter *iter);
+void qp_iter_print(struct seq_file *s, struct rvt_qp_iter *iter);
 
 void _hfi1_schedule_send(struct rvt_qp *qp);
 void hfi1_schedule_send(struct rvt_qp *qp);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
