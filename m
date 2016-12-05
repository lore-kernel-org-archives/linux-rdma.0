From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 26/28] bnxt_re: Support debugfs
Date: Sun,  4 Dec 2016 22:38:30 -0800
Message-ID: <1480919912-1079-27-git-send-email-selvin.xavier@broadcom.com>
References: <1480919912-1079-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480919912-1079-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch exports some of the FW debug counters

Signed-off-by: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxtre/Makefile          |   2 +-
 drivers/infiniband/hw/bnxtre/bnxt_re_debugfs.c | 136 +++++++++++++++++++++++++
 drivers/infiniband/hw/bnxtre/bnxt_re_debugfs.h |  25 +++++
 drivers/infiniband/hw/bnxtre/bnxt_re_main.c    |   4 +
 4 files changed, 166 insertions(+), 1 deletion(-)
 create mode 100644 drivers/infiniband/hw/bnxtre/bnxt_re_debugfs.c
 create mode 100644 drivers/infiniband/hw/bnxtre/bnxt_re_debugfs.h

diff --git a/drivers/infiniband/hw/bnxtre/Makefile b/drivers/infiniband/hw/bnxtre/Makefile
index 71aa5a1..39df4f1 100644
--- a/drivers/infiniband/hw/bnxtre/Makefile
+++ b/drivers/infiniband/hw/bnxtre/Makefile
@@ -1,6 +1,6 @@
 
 ccflags-y := -Idrivers/net/ethernet/broadcom/bnxt
 obj-$(CONFIG_INFINIBAND_BNXTRE) += bnxt_re.o
-bnxt_re-y := bnxt_re_main.o bnxt_re_ib_verbs.o \
+bnxt_re-y := bnxt_re_main.o bnxt_re_ib_verbs.o bnxt_re_debugfs.o \
 	     bnxt_qplib_res.o bnxt_qplib_rcfw.o	\
 	     bnxt_qplib_sp.o bnxt_qplib_fp.o
diff --git a/drivers/infiniband/hw/bnxtre/bnxt_re_debugfs.c b/drivers/infiniband/hw/bnxtre/bnxt_re_debugfs.c
new file mode 100644
index 0000000..a80a241
--- /dev/null
+++ b/drivers/infiniband/hw/bnxtre/bnxt_re_debugfs.c
@@ -0,0 +1,136 @@
+
+/* Broadcom NetXtreme-C/E network driver.
+ *
+ * Copyright (c) 2014-2016 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ *
+ */
+
+/*
+ * Description: DebugFS specifics
+ */
+
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/netdevice.h>
+
+#include <rdma/ib_verbs.h>
+#include "bnxt_re_hsi.h"
+#include "bnxt_ulp.h"
+#include "bnxt_qplib_res.h"
+#include "bnxt_qplib_sp.h"
+#include "bnxt_qplib_fp.h"
+#include "bnxt_qplib_rcfw.h"
+
+#include "bnxt_re.h"
+#include "bnxt_re_debugfs.h"
+
+static struct dentry *bnxt_re_debugfs_root;
+static struct dentry *bnxt_re_debugfs_info;
+
+static ssize_t bnxt_re_debugfs_clear(struct file *fil, const char __user *u,
+				     size_t size, loff_t *off)
+{
+	return size;
+}
+
+static int bnxt_re_debugfs_show(struct seq_file *s, void *unused)
+{
+	struct bnxt_re_dev *rdev;
+
+	seq_puts(s, "bnxt_re debug info:\n");
+
+	mutex_lock(&bnxt_re_dev_lock);
+	list_for_each_entry(rdev, &bnxt_re_dev_list, list) {
+		struct ctx_hw_stats *stats = rdev->qplib_ctx.stats.dma;
+
+		seq_printf(s, "=====[ IBDEV %s ]=============================\n",
+			   rdev->ibdev.name);
+		if (rdev->netdev)
+			seq_printf(s, "\tlink state: %s\n",
+				   test_bit(__LINK_STATE_START,
+					    &rdev->netdev->state) ?
+				   (test_bit(__LINK_STATE_NOCARRIER,
+					     &rdev->netdev->state) ?
+				    "DOWN" : "UP") : "DOWN");
+		seq_printf(s, "\tMax QP: 0x%x\n", rdev->dev_attr.max_qp);
+		seq_printf(s, "\tMax SRQ: 0x%x\n", rdev->dev_attr.max_srq);
+		seq_printf(s, "\tMax CQ: 0x%x\n", rdev->dev_attr.max_cq);
+		seq_printf(s, "\tMax MR: 0x%x\n", rdev->dev_attr.max_mr);
+		seq_printf(s, "\tMax MW: 0x%x\n", rdev->dev_attr.max_mw);
+
+		seq_printf(s, "\tActive QP: %d\n",
+			   atomic_read(&rdev->qp_count));
+		seq_printf(s, "\tActive SRQ: %d\n",
+			   atomic_read(&rdev->srq_count));
+		seq_printf(s, "\tActive CQ: %d\n",
+			   atomic_read(&rdev->cq_count));
+		seq_printf(s, "\tActive MR: %d\n",
+			   atomic_read(&rdev->mr_count));
+		seq_printf(s, "\tActive MW: %d\n",
+			   atomic_read(&rdev->mw_count));
+		seq_printf(s, "\tRx Pkts: %lld\n",
+			   stats ? stats->rx_ucast_pkts : 0);
+		seq_printf(s, "\tRx Bytes: %lld\n",
+			   stats ? stats->rx_ucast_bytes : 0);
+		seq_printf(s, "\tTx Pkts: %lld\n",
+			   stats ? stats->tx_ucast_pkts : 0);
+		seq_printf(s, "\tTx Bytes: %lld\n",
+			   stats ? stats->tx_ucast_bytes : 0);
+		seq_printf(s, "\tRecoverable Errors: %lld\n",
+			   stats ? stats->tx_bcast_pkts : 0);
+		seq_puts(s, "\n");
+	}
+	mutex_unlock(&bnxt_re_dev_lock);
+	return 0;
+}
+
+static int bnxt_re_debugfs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, bnxt_re_debugfs_show, NULL);
+}
+
+static int bnxt_re_debugfs_release(struct inode *inode, struct file *file)
+{
+	return single_release(inode, file);
+}
+
+static const struct file_operations bnxt_re_dbg_ops = {
+	.owner		= THIS_MODULE,
+	.open		= bnxt_re_debugfs_open,
+	.read		= seq_read,
+	.write		= bnxt_re_debugfs_clear,
+	.llseek		= seq_lseek,
+	.release	= bnxt_re_debugfs_release,
+};
+
+void bnxt_re_debugfs_remove(void)
+{
+	debugfs_remove_recursive(bnxt_re_debugfs_root);
+	bnxt_re_debugfs_root = NULL;
+}
+
+void bnxt_re_debugfs_init(void)
+{
+	bnxt_re_debugfs_root = debugfs_create_dir(ROCE_DRV_MODULE_NAME, NULL);
+	if (IS_ERR_OR_NULL(bnxt_re_debugfs_root)) {
+		dev_dbg(NULL, "%s: Unable to create debugfs root directory ",
+			ROCE_DRV_MODULE_NAME);
+		dev_dbg(NULL, "with err 0x%lx", PTR_ERR(bnxt_re_debugfs_root));
+		return;
+	}
+	bnxt_re_debugfs_info = debugfs_create_file("info", 0400,
+						   bnxt_re_debugfs_root, NULL,
+						   &bnxt_re_dbg_ops);
+	if (IS_ERR_OR_NULL(bnxt_re_debugfs_info)) {
+		dev_dbg(NULL, "%s: Unable to create debugfs info node ",
+			ROCE_DRV_MODULE_NAME);
+		dev_dbg(NULL, "with err 0x%lx", PTR_ERR(bnxt_re_debugfs_info));
+		bnxt_re_debugfs_remove();
+	}
+}
diff --git a/drivers/infiniband/hw/bnxtre/bnxt_re_debugfs.h b/drivers/infiniband/hw/bnxtre/bnxt_re_debugfs.h
new file mode 100644
index 0000000..4089fa5
--- /dev/null
+++ b/drivers/infiniband/hw/bnxtre/bnxt_re_debugfs.h
@@ -0,0 +1,25 @@
+
+/* Broadcom NetXtreme-C/E network driver.
+ *
+ * Copyright (c) 2014-2016 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ *
+ */
+
+/*
+ * Description: DebugFS header
+ */
+
+#ifndef __BNXT_RE_DEBUGFS__
+#define __BNXT_RE_DEBUGFS__
+
+extern struct list_head bnxt_re_dev_list;
+extern struct mutex bnxt_re_dev_lock;
+
+void bnxt_re_debugfs_init(void);
+void bnxt_re_debugfs_remove(void);
+
+#endif
diff --git a/drivers/infiniband/hw/bnxtre/bnxt_re_main.c b/drivers/infiniband/hw/bnxtre/bnxt_re_main.c
index ab70d23..67b6a80 100644
--- a/drivers/infiniband/hw/bnxtre/bnxt_re_main.c
+++ b/drivers/infiniband/hw/bnxtre/bnxt_re_main.c
@@ -34,6 +34,7 @@
 #include "bnxt_qplib_fp.h"
 #include "bnxt_qplib_rcfw.h"
 #include "bnxt_re.h"
+#include "bnxt_re_debugfs.h"
 #include "bnxt_re_ib_verbs.h"
 #include "bnxt.h"
 static char version[] =
@@ -1252,6 +1253,7 @@ static int __init bnxt_re_mod_init(void)
 	if (!bnxt_re_wq)
 		return -ENOMEM;
 
+	bnxt_re_debugfs_init();
 	INIT_LIST_HEAD(&bnxt_re_dev_list);
 
 	rc = register_netdevice_notifier(&bnxt_re_netdev_notifier);
@@ -1263,6 +1265,7 @@ static int __init bnxt_re_mod_init(void)
 	return 0;
 
 err_netdev:
+	bnxt_re_debugfs_remove();
 	destroy_workqueue(bnxt_re_wq);
 
 	return rc;
@@ -1291,6 +1294,7 @@ static void __exit bnxt_re_mod_exit(void)
 	}
 
 	unregister_netdevice_notifier(&bnxt_re_netdev_notifier);
+	bnxt_re_debugfs_remove();
 	if (bnxt_re_wq)
 		destroy_workqueue(bnxt_re_wq);
 }
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
