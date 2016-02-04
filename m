From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 4/6] IB: add a simple MR pool
Date: Thu, 4 Feb 2016 13:52:40 -0800
Message-ID: <e55b00d8b6b73b66d89bae85d0a422776b9bef7d.1454709715.git.swise@chelsio.com>
References: <cover.1454709715.git.swise@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1454709715.git.swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Signed-off-by: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/core/Makefile  |  2 +-
 drivers/infiniband/core/mr_pool.c | 85 +++++++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/verbs.c   |  4 ++
 include/rdma/ib_verbs.h           | 10 ++++-
 include/rdma/mr_pool.h            | 20 +++++++++
 5 files changed, 119 insertions(+), 2 deletions(-)
 create mode 100644 drivers/infiniband/core/mr_pool.c
 create mode 100644 include/rdma/mr_pool.h

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index f818538..48bd9d8 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_INFINIBAND_USER_ACCESS) +=	ib_uverbs.o ib_ucm.o \
 
 ib_core-y :=			packer.o ud_header.o verbs.o cq.o sysfs.o \
 				device.o fmr_pool.o cache.o netlink.o \
-				roce_gid_mgmt.o
+				roce_gid_mgmt.o mr_pool.o
 ib_core-$(CONFIG_INFINIBAND_USER_MEM) += umem.o
 ib_core-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += umem_odp.o umem_rbtree.o
 
diff --git a/drivers/infiniband/core/mr_pool.c b/drivers/infiniband/core/mr_pool.c
new file mode 100644
index 0000000..b0a04c8
--- /dev/null
+++ b/drivers/infiniband/core/mr_pool.c
@@ -0,0 +1,85 @@
+/*
+ * Copyright (c) 2016 HGST, a Western Digital Company.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+#include <rdma/ib_verbs.h>
+#include <rdma/mr_pool.h>
+
+struct ib_mr *ib_mr_pool_get(struct ib_qp *qp)
+{
+	struct ib_mr *mr = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&qp->mr_lock, flags);
+	mr = list_first_entry_or_null(&qp->free_mrs, struct ib_mr, qp_entry);
+	if (mr)
+		list_move(&mr->qp_entry, &qp->used_mrs);
+	spin_unlock_irqrestore(&qp->mr_lock, flags);
+
+	return mr;
+}
+EXPORT_SYMBOL(ib_mr_pool_get);
+
+void ib_mr_pool_put(struct ib_qp *qp, struct ib_mr *mr)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&qp->mr_lock, flags);
+	list_move(&mr->qp_entry, &qp->free_mrs);
+	spin_unlock_irqrestore(&qp->mr_lock, flags);
+}
+EXPORT_SYMBOL(ib_mr_pool_put);
+
+int ib_mr_pool_init(struct ib_qp *qp, int nr, enum ib_mr_type type,
+		u32 max_num_sg)
+{
+	struct ib_mr *mr;
+	unsigned long flags;
+	int ret, i;
+
+	for (i = 0; i < nr; i++) {
+		mr = ib_alloc_mr(qp->pd, type, max_num_sg);
+		if (IS_ERR(mr)) {
+			ret = PTR_ERR(mr);
+			goto out;
+		}
+
+		spin_lock_irqsave(&qp->mr_lock, flags);
+		list_add_tail(&mr->qp_entry, &qp->free_mrs);
+		spin_unlock_irqrestore(&qp->mr_lock, flags);
+	}
+
+	return 0;
+out:
+	ib_mr_pool_destroy(qp);
+	return ret;
+}
+EXPORT_SYMBOL(ib_mr_pool_init);
+
+void ib_mr_pool_destroy(struct ib_qp *qp)
+{
+	struct ib_mr *mr;
+	unsigned long flags;
+
+	WARN_ON_ONCE(!list_empty(&qp->used_mrs));
+
+	spin_lock_irqsave(&qp->mr_lock, flags);
+	while (!list_empty(&qp->free_mrs)) {
+		mr = list_first_entry(&qp->free_mrs, struct ib_mr, qp_entry);
+		list_del(&mr->qp_entry);
+
+		spin_unlock_irqrestore(&qp->mr_lock, flags);
+		ib_dereg_mr(mr);
+		spin_lock_irqsave(&qp->mr_lock, flags);
+	}
+	spin_unlock_irqrestore(&qp->mr_lock, flags);
+}
+EXPORT_SYMBOL(ib_mr_pool_destroy);
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 31b82cd..879839f 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -738,6 +738,10 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 		qp->uobject    = NULL;
 		qp->qp_type    = qp_init_attr->qp_type;
 
+		spin_lock_init(&qp->mr_lock);
+		INIT_LIST_HEAD(&qp->free_mrs);
+		INIT_LIST_HEAD(&qp->used_mrs);
+
 		atomic_set(&qp->usecnt, 0);
 		if (qp_init_attr->qp_type == IB_QPT_XRC_TGT) {
 			qp->event_handler = __ib_shared_qp_event_handler;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index d8533ab..380d03d 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1408,6 +1408,11 @@ struct ib_qp {
 	struct ib_srq	       *srq;
 	struct ib_xrcd	       *xrcd; /* XRC TGT QPs only */
 	struct list_head	xrcd_list;
+
+	spinlock_t		mr_lock;
+	struct list_head	free_mrs;
+	struct list_head	used_mrs;
+
 	/* count times opened, mcast attaches, flow attaches */
 	atomic_t		usecnt;
 	struct list_head	open_list;
@@ -1422,12 +1427,15 @@ struct ib_qp {
 struct ib_mr {
 	struct ib_device  *device;
 	struct ib_pd	  *pd;
-	struct ib_uobject *uobject;
 	u32		   lkey;
 	u32		   rkey;
 	u64		   iova;
 	u32		   length;
 	unsigned int	   page_size;
+	union {
+		struct ib_uobject	*uobject;	/* user */
+		struct list_head	qp_entry;	/* FR */
+	};
 };
 
 struct ib_mw {
diff --git a/include/rdma/mr_pool.h b/include/rdma/mr_pool.h
new file mode 100644
index 0000000..b4ee196
--- /dev/null
+++ b/include/rdma/mr_pool.h
@@ -0,0 +1,20 @@
+/*
+ * Copyright (c) 2016 HGST, a Western Digital Company.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+#include <rdma/ib_verbs.h>
+
+struct ib_mr *ib_mr_pool_get(struct ib_qp *qp);
+void ib_mr_pool_put(struct ib_qp *qp, struct ib_mr *mr);
+
+int ib_mr_pool_init(struct ib_qp *qp, int nr, enum ib_mr_type type,
+		u32 max_num_sg);
+void ib_mr_pool_destroy(struct ib_qp *qp);
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
