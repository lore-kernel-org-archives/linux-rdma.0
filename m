From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: Correct reference counting in debugfs qp_stats
Date: Fri, 19 Sep 2014 08:32:19 -0400
Message-ID: <20140919123219.20437.93190.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This particular reference count is not needed with the
rcu protection and the current code leaks a reference count,
causing a hang in qib_qp_destroy().

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_debugfs.c |    3 ++-
 drivers/infiniband/hw/qib/qib_qp.c      |    8 --------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_debugfs.c b/drivers/infiniband/hw/qib/qib_debugfs.c
index 799a0c3..6abd3ed 100644
--- a/drivers/infiniband/hw/qib/qib_debugfs.c
+++ b/drivers/infiniband/hw/qib/qib_debugfs.c
@@ -193,6 +193,7 @@ static void *_qp_stats_seq_start(struct seq_file *s, loff_t *pos)
 	struct qib_qp_iter *iter;
 	loff_t n = *pos;
 
+	rcu_read_lock();
 	iter = qib_qp_iter_init(s->private);
 	if (!iter)
 		return NULL;
@@ -224,7 +225,7 @@ static void *_qp_stats_seq_next(struct seq_file *s, void *iter_ptr,
 
 static void _qp_stats_seq_stop(struct seq_file *s, void *iter_ptr)
 {
-	/* nothing for now */
+	rcu_read_unlock();
 }
 
 static int _qp_stats_seq_show(struct seq_file *s, void *iter_ptr)
diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index cb0c680..4fa88ba 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -1325,7 +1325,6 @@ int qib_qp_iter_next(struct qib_qp_iter *iter)
 	struct qib_qp *pqp = iter->qp;
 	struct qib_qp *qp;
 
-	rcu_read_lock();
 	for (; n < dev->qp_table_size; n++) {
 		if (pqp)
 			qp = rcu_dereference(pqp->next);
@@ -1333,18 +1332,11 @@ int qib_qp_iter_next(struct qib_qp_iter *iter)
 			qp = rcu_dereference(dev->qp_table[n]);
 		pqp = qp;
 		if (qp) {
-			if (iter->qp)
-				atomic_dec(&iter->qp->refcount);
-			atomic_inc(&qp->refcount);
-			rcu_read_unlock();
 			iter->qp = qp;
 			iter->n = n;
 			return 0;
 		}
 	}
-	rcu_read_unlock();
-	if (iter->qp)
-		atomic_dec(&iter->qp->refcount);
 	return ret;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
