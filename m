From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/4] IB/qib: add qp_stats debug file
Date: Sat, 15 Jun 2013 17:07:14 -0400
Message-ID: <20130615210714.6069.45529.stgit@phlsvslse11.ph.intel.com>
References: <20130615210633.6069.14865.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130615210633.6069.14865.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This adds a seq_file iterator for reporting the
QP hash table when the qp_stats file is read.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_debugfs.c |   54 ++++++++++++++++++
 drivers/infiniband/hw/qib/qib_qp.c      |   94 +++++++++++++++++++++++++++++++
 drivers/infiniband/hw/qib/qib_verbs.h   |   14 ++++-
 3 files changed, 161 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib_debugfs.c b/drivers/infiniband/hw/qib/qib_debugfs.c
index a4e6ee1..799a0c3 100644
--- a/drivers/infiniband/hw/qib/qib_debugfs.c
+++ b/drivers/infiniband/hw/qib/qib_debugfs.c
@@ -188,6 +188,59 @@ static int _ctx_stats_seq_show(struct seq_file *s, void *v)
 
 DEBUGFS_FILE(ctx_stats)
 
+static void *_qp_stats_seq_start(struct seq_file *s, loff_t *pos)
+{
+	struct qib_qp_iter *iter;
+	loff_t n = *pos;
+
+	iter = qib_qp_iter_init(s->private);
+	if (!iter)
+		return NULL;
+
+	while (n--) {
+		if (qib_qp_iter_next(iter)) {
+			kfree(iter);
+			return NULL;
+		}
+	}
+
+	return iter;
+}
+
+static void *_qp_stats_seq_next(struct seq_file *s, void *iter_ptr,
+				   loff_t *pos)
+{
+	struct qib_qp_iter *iter = iter_ptr;
+
+	(*pos)++;
+
+	if (qib_qp_iter_next(iter)) {
+		kfree(iter);
+		return NULL;
+	}
+
+	return iter;
+}
+
+static void _qp_stats_seq_stop(struct seq_file *s, void *iter_ptr)
+{
+	/* nothing for now */
+}
+
+static int _qp_stats_seq_show(struct seq_file *s, void *iter_ptr)
+{
+	struct qib_qp_iter *iter = iter_ptr;
+
+	if (!iter)
+		return 0;
+
+	qib_qp_iter_print(s, iter);
+
+	return 0;
+}
+
+DEBUGFS_FILE(qp_stats)
+
 void qib_dbg_ibdev_init(struct qib_ibdev *ibd)
 {
 	char name[10];
@@ -200,6 +253,7 @@ void qib_dbg_ibdev_init(struct qib_ibdev *ibd)
 	}
 	DEBUGFS_FILE_CREATE(opcode_stats);
 	DEBUGFS_FILE_CREATE(ctx_stats);
+	DEBUGFS_FILE_CREATE(qp_stats);
 	return;
 }
 
diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index c1f573a..3cca55b 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -35,6 +35,9 @@
 #include <linux/err.h>
 #include <linux/vmalloc.h>
 #include <linux/jhash.h>
+#ifdef CONFIG_DEBUG_FS
+#include <linux/seq_file.h>
+#endif
 
 #include "qib.h"
 
@@ -1287,3 +1290,94 @@ void qib_get_credit(struct qib_qp *qp, u32 aeth)
 		}
 	}
 }
+
+#ifdef CONFIG_DEBUG_FS
+
+struct qib_qp_iter {
+	struct qib_ibdev *dev;
+	struct qib_qp *qp;
+	int n;
+};
+
+struct qib_qp_iter *qib_qp_iter_init(struct qib_ibdev *dev)
+{
+	struct qib_qp_iter *iter;
+
+	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
+	if (!iter)
+		return NULL;
+
+	iter->dev = dev;
+	if (qib_qp_iter_next(iter)) {
+		kfree(iter);
+		return NULL;
+	}
+
+	return iter;
+}
+
+int qib_qp_iter_next(struct qib_qp_iter *iter)
+{
+	struct qib_ibdev *dev = iter->dev;
+	int n = iter->n;
+	int ret = 1;
+	struct qib_qp *pqp = iter->qp;
+	struct qib_qp *qp;
+
+	rcu_read_lock();
+	for (; n < dev->qp_table_size; n++) {
+		if (pqp)
+			qp = rcu_dereference(pqp->next);
+		else
+			qp = rcu_dereference(dev->qp_table[n]);
+		pqp = qp;
+		if (qp) {
+			if (iter->qp)
+				atomic_dec(&iter->qp->refcount);
+			atomic_inc(&qp->refcount);
+			rcu_read_unlock();
+			iter->qp = qp;
+			iter->n = n;
+			return 0;
+		}
+	}
+	rcu_read_unlock();
+	if (iter->qp)
+		atomic_dec(&iter->qp->refcount);
+	return ret;
+}
+
+static const char * const qp_type_str[] = {
+	"SMI", "GSI", "RC", "UC", "UD",
+};
+
+void qib_qp_iter_print(struct seq_file *s, struct qib_qp_iter *iter)
+{
+	struct qib_swqe *wqe;
+	struct qib_qp *qp = iter->qp;
+
+	wqe = get_swqe_ptr(qp, qp->s_last);
+	seq_printf(s,
+		   "N %d QP%u %s %u %u %u f=%x %u %u %u %u %u PSN %x %x %x %x %x (%u %u %u %u %u %u) QP%u LID %x\n",
+		   iter->n,
+		   qp->ibqp.qp_num,
+		   qp_type_str[qp->ibqp.qp_type],
+		   qp->state,
+		   wqe->wr.opcode,
+		   qp->s_hdrwords,
+		   qp->s_flags,
+		   atomic_read(&qp->s_dma_busy),
+		   !list_empty(&qp->iowait),
+		   qp->timeout,
+		   wqe->ssn,
+		   qp->s_lsn,
+		   qp->s_last_psn,
+		   qp->s_psn, qp->s_next_psn,
+		   qp->s_sending_psn, qp->s_sending_hpsn,
+		   qp->s_last, qp->s_acked, qp->s_cur,
+		   qp->s_tail, qp->s_head, qp->s_size,
+		   qp->remote_qpn,
+		   qp->remote_ah_attr.dlid);
+}
+
+#endif
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index 4a22a85..012e2c7 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2012, 2013 Intel Corporation.  All rights reserved.
  * Copyright (c) 2006 - 2012 QLogic Corporation. All rights reserved.
  * Copyright (c) 2005, 2006 PathScale, Inc. All rights reserved.
  *
@@ -917,6 +917,18 @@ void qib_init_qpn_table(struct qib_devdata *dd, struct qib_qpn_table *qpt);
 
 void qib_free_qpn_table(struct qib_qpn_table *qpt);
 
+#ifdef CONFIG_DEBUG_FS
+
+struct qib_qp_iter;
+
+struct qib_qp_iter *qib_qp_iter_init(struct qib_ibdev *dev);
+
+int qib_qp_iter_next(struct qib_qp_iter *iter);
+
+void qib_qp_iter_print(struct seq_file *s, struct qib_qp_iter *iter);
+
+#endif
+
 void qib_get_credit(struct qib_qp *qp, u32 aeth);
 
 unsigned qib_pkt_delay(u32 plen, u8 snd_mult, u8 rcv_mult);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
