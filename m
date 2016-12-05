From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 08/28] bnxt_re: Add bnxt_re RoCE driver files
Date: Sun,  4 Dec 2016 22:38:12 -0800
Message-ID: <1480919912-1079-9-git-send-email-selvin.xavier@broadcom.com>
References: <1480919912-1079-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480919912-1079-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds the required skeletal files for Broadcom NetXtreme RoCE
driver. Also, added the load/unload routines for bnxt_re driver.

Signed-off-by: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/Kconfig                      |  2 +
 drivers/infiniband/hw/Makefile                  |  1 +
 drivers/infiniband/hw/bnxtre/Kconfig            |  9 +++
 drivers/infiniband/hw/bnxtre/Makefile           |  5 ++
 drivers/infiniband/hw/bnxtre/bnxt_qplib_fp.c    | 12 ++++
 drivers/infiniband/hw/bnxtre/bnxt_qplib_fp.h    | 17 +++++
 drivers/infiniband/hw/bnxtre/bnxt_qplib_rcfw.c  | 12 ++++
 drivers/infiniband/hw/bnxtre/bnxt_qplib_rcfw.h  | 17 +++++
 drivers/infiniband/hw/bnxtre/bnxt_qplib_res.c   | 12 ++++
 drivers/infiniband/hw/bnxtre/bnxt_qplib_res.h   | 17 +++++
 drivers/infiniband/hw/bnxtre/bnxt_qplib_sp.c    | 12 ++++
 drivers/infiniband/hw/bnxtre/bnxt_qplib_sp.h    | 17 +++++
 drivers/infiniband/hw/bnxtre/bnxt_re.h          | 17 +++++
 drivers/infiniband/hw/bnxtre/bnxt_re_hsi.h      | 18 +++++
 drivers/infiniband/hw/bnxtre/bnxt_re_ib_verbs.c | 12 ++++
 drivers/infiniband/hw/bnxtre/bnxt_re_ib_verbs.h | 17 +++++
 drivers/infiniband/hw/bnxtre/bnxt_re_main.c     | 96 +++++++++++++++++++++++++
 17 files changed, 293 insertions(+)
 create mode 100644 drivers/infiniband/hw/bnxtre/Kconfig
 create mode 100644 drivers/infiniband/hw/bnxtre/Makefile
 create mode 100644 drivers/infiniband/hw/bnxtre/bnxt_qplib_fp.c
 create mode 100644 drivers/infiniband/hw/bnxtre/bnxt_qplib_fp.h
 create mode 100644 drivers/infiniband/hw/bnxtre/bnxt_qplib_rcfw.c
 create mode 100644 drivers/infiniband/hw/bnxtre/bnxt_qplib_rcfw.h
 create mode 100644 drivers/infiniband/hw/bnxtre/bnxt_qplib_res.c
 create mode 100644 drivers/infiniband/hw/bnxtre/bnxt_qplib_res.h
 create mode 100644 drivers/infiniband/hw/bnxtre/bnxt_qplib_sp.c
 create mode 100644 drivers/infiniband/hw/bnxtre/bnxt_qplib_sp.h
 create mode 100644 drivers/infiniband/hw/bnxtre/bnxt_re.h
 create mode 100644 drivers/infiniband/hw/bnxtre/bnxt_re_hsi.h
 create mode 100644 drivers/infiniband/hw/bnxtre/bnxt_re_ib_verbs.c
 create mode 100644 drivers/infiniband/hw/bnxtre/bnxt_re_ib_verbs.h
 create mode 100644 drivers/infiniband/hw/bnxtre/bnxt_re_main.c

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index fb3fb89..a4fab22 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -91,4 +91,6 @@ source "drivers/infiniband/hw/hfi1/Kconfig"
 
 source "drivers/infiniband/hw/qedr/Kconfig"
 
+source "drivers/infiniband/hw/bnxtre/Kconfig"
+
 endif # INFINIBAND
diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Makefile
index e7a5ed9..7227b36 100644
--- a/drivers/infiniband/hw/Makefile
+++ b/drivers/infiniband/hw/Makefile
@@ -11,3 +11,4 @@ obj-$(CONFIG_INFINIBAND_USNIC)		+= usnic/
 obj-$(CONFIG_INFINIBAND_HFI1)		+= hfi1/
 obj-$(CONFIG_INFINIBAND_HNS)		+= hns/
 obj-$(CONFIG_INFINIBAND_QEDR)		+= qedr/
+obj-$(CONFIG_INFINIBAND_BNXTRE)		+= bnxtre/
diff --git a/drivers/infiniband/hw/bnxtre/Kconfig b/drivers/infiniband/hw/bnxtre/Kconfig
new file mode 100644
index 0000000..2637544
--- /dev/null
+++ b/drivers/infiniband/hw/bnxtre/Kconfig
@@ -0,0 +1,9 @@
+config INFINIBAND_BNXTRE
+    tristate "Broadcom Netxtreme HCA support"
+    depends on ETHERNET && NETDEVICES && PCI && INET
+    select NET_VENDOR_BROADCOM
+    select BNXT
+    ---help---
+	  This driver supports Broadcom NetXtreme-C/E 10/25/40/50 gigabit
+	  RoCE HCAs.  To compile this driver as a module, choose M here:
+	  the module will be called bnxt_re.
diff --git a/drivers/infiniband/hw/bnxtre/Makefile b/drivers/infiniband/hw/bnxtre/Makefile
new file mode 100644
index 0000000..0521489
--- /dev/null
+++ b/drivers/infiniband/hw/bnxtre/Makefile
@@ -0,0 +1,5 @@
+
+obj-$(CONFIG_INFINIBAND_BNXTRE) += bnxt_re.o
+bnxt_re-y := bnxt_re_main.o bnxt_re_ib_verbs.o \
+	     bnxt_qplib_res.o bnxt_qplib_rcfw.o	\
+	     bnxt_qplib_sp.o bnxt_qplib_fp.o
diff --git a/drivers/infiniband/hw/bnxtre/bnxt_qplib_fp.c b/drivers/infiniband/hw/bnxtre/bnxt_qplib_fp.c
new file mode 100644
index 0000000..34873f4
--- /dev/null
+++ b/drivers/infiniband/hw/bnxtre/bnxt_qplib_fp.c
@@ -0,0 +1,12 @@
+/* Broadcom NetXtreme-C/E RoCE driver.
+ *
+ * Copyright (c) 2016 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+/*
+ * Description: Fast Path Operators
+ */
diff --git a/drivers/infiniband/hw/bnxtre/bnxt_qplib_fp.h b/drivers/infiniband/hw/bnxtre/bnxt_qplib_fp.h
new file mode 100644
index 0000000..7278999
--- /dev/null
+++ b/drivers/infiniband/hw/bnxtre/bnxt_qplib_fp.h
@@ -0,0 +1,17 @@
+/* Broadcom NetXtreme-C/E RoCE driver.
+ *
+ * Copyright (c) 2016 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+/*
+ * Description: Fast Path Operators (header)
+ */
+
+#ifndef __BNXT_QPLIB_FP_H__
+#define __BNXT_QPLIB_FP_H__
+
+#endif /* __BNXT_QPLIB_FP_H__ */
diff --git a/drivers/infiniband/hw/bnxtre/bnxt_qplib_rcfw.c b/drivers/infiniband/hw/bnxtre/bnxt_qplib_rcfw.c
new file mode 100644
index 0000000..3bfb526
--- /dev/null
+++ b/drivers/infiniband/hw/bnxtre/bnxt_qplib_rcfw.c
@@ -0,0 +1,12 @@
+/* Broadcom NetXtreme-C/E RoCE driver.
+ *
+ * Copyright (c) 2016 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+/*
+ * Description: RDMA Controller HW interface
+ */
diff --git a/drivers/infiniband/hw/bnxtre/bnxt_qplib_rcfw.h b/drivers/infiniband/hw/bnxtre/bnxt_qplib_rcfw.h
new file mode 100644
index 0000000..bdf78e1
--- /dev/null
+++ b/drivers/infiniband/hw/bnxtre/bnxt_qplib_rcfw.h
@@ -0,0 +1,17 @@
+/* Broadcom NetXtreme-C/E RoCE driver.
+ *
+ * Copyright (c) 2016 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+/*
+ * Description: RDMA Controller HW interface (header)
+ */
+
+#ifndef __BNXT_QPLIB_RCFW_H__
+#define __BNXT_QPLIB_RCFW_H__
+
+#endif /* __BNXT_QPLIB_RCFW_H__ */
diff --git a/drivers/infiniband/hw/bnxtre/bnxt_qplib_res.c b/drivers/infiniband/hw/bnxtre/bnxt_qplib_res.c
new file mode 100644
index 0000000..c8fb9b3
--- /dev/null
+++ b/drivers/infiniband/hw/bnxtre/bnxt_qplib_res.c
@@ -0,0 +1,12 @@
+/* Broadcom NetXtreme-C/E RoCE driver.
+ *
+ * Copyright (c) 2016 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+/*
+ * Description: QPLib resource manager
+ */
diff --git a/drivers/infiniband/hw/bnxtre/bnxt_qplib_res.h b/drivers/infiniband/hw/bnxtre/bnxt_qplib_res.h
new file mode 100644
index 0000000..39b186b
--- /dev/null
+++ b/drivers/infiniband/hw/bnxtre/bnxt_qplib_res.h
@@ -0,0 +1,17 @@
+/* Broadcom NetXtreme-C/E RoCE driver.
+ *
+ * Copyright (c) 2016 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+/*
+ * Description: QPLib resource manager (header)
+ */
+
+#ifndef __BNXT_QPLIB_RES_H__
+#define __BNXT_QPLIB_RES_H_
+
+#endif /* __BNXT_QPLIB_RES_H__ */
diff --git a/drivers/infiniband/hw/bnxtre/bnxt_qplib_sp.c b/drivers/infiniband/hw/bnxtre/bnxt_qplib_sp.c
new file mode 100644
index 0000000..4ef5e26
--- /dev/null
+++ b/drivers/infiniband/hw/bnxtre/bnxt_qplib_sp.c
@@ -0,0 +1,12 @@
+/* Broadcom NetXtreme-C/E RoCE driver.
+ *
+ * Copyright (c) 2016 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+/*
+ * Description: Slow Path Operators
+ */
diff --git a/drivers/infiniband/hw/bnxtre/bnxt_qplib_sp.h b/drivers/infiniband/hw/bnxtre/bnxt_qplib_sp.h
new file mode 100644
index 0000000..501ef6c
--- /dev/null
+++ b/drivers/infiniband/hw/bnxtre/bnxt_qplib_sp.h
@@ -0,0 +1,17 @@
+/* Broadcom NetXtreme-C/E RoCE driver.
+ *
+ * Copyright (c) 2016 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+/*
+ * Description: Slow Path Operators (header)
+ */
+
+#ifndef __BNXT_QPLIB_SP_H__
+#define __BNXT_QPLIB_SP_H__
+
+#endif /* __BNXT_QPLIB_SP_H__*/
diff --git a/drivers/infiniband/hw/bnxtre/bnxt_re.h b/drivers/infiniband/hw/bnxtre/bnxt_re.h
new file mode 100644
index 0000000..649c58e
--- /dev/null
+++ b/drivers/infiniband/hw/bnxtre/bnxt_re.h
@@ -0,0 +1,17 @@
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
+#ifndef __BNXT_RE_H__
+#define __BNXT_RE_H__
+#define ROCE_DRV_MODULE_NAME		"bnxt_re"
+#define ROCE_DRV_MODULE_VERSION		"1.0.0"
+
+#define BNXT_RE_DESC	"Broadcom NetXtreme-C/E RoCE Driver"
+#endif
diff --git a/drivers/infiniband/hw/bnxtre/bnxt_re_hsi.h b/drivers/infiniband/hw/bnxtre/bnxt_re_hsi.h
new file mode 100644
index 0000000..2aa5b38
--- /dev/null
+++ b/drivers/infiniband/hw/bnxtre/bnxt_re_hsi.h
@@ -0,0 +1,18 @@
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
+ * Description: RoCE HSI File - Autogenerated
+ */
+
+#ifndef __BNXT_RE_HSI_H__
+#define __BNXT_RE_HSI_H__
+
+#endif /* __BNXT_RE_HSI_H__ */
diff --git a/drivers/infiniband/hw/bnxtre/bnxt_re_ib_verbs.c b/drivers/infiniband/hw/bnxtre/bnxt_re_ib_verbs.c
new file mode 100644
index 0000000..e69fb3f
--- /dev/null
+++ b/drivers/infiniband/hw/bnxtre/bnxt_re_ib_verbs.c
@@ -0,0 +1,12 @@
+/* Broadcom NetXtreme-C/E RoCE driver.
+ *
+ * Copyright (c) 2016 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+/*
+ * Description: IB Verbs interpreter
+ */
diff --git a/drivers/infiniband/hw/bnxtre/bnxt_re_ib_verbs.h b/drivers/infiniband/hw/bnxtre/bnxt_re_ib_verbs.h
new file mode 100644
index 0000000..0651c30
--- /dev/null
+++ b/drivers/infiniband/hw/bnxtre/bnxt_re_ib_verbs.h
@@ -0,0 +1,17 @@
+/* Broadcom NetXtreme-C/E RoCE driver.
+ *
+ * Copyright (c) 2016 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+/*
+ * Description: IB Verbs interpreter (header)
+ */
+
+#ifndef __BNXT_RE_IB_VERBS_H__
+#define __BNXT_RE_IB_VERBS_H__
+
+#endif /* __BNXT_RE_IB_VERBS_H__ */
diff --git a/drivers/infiniband/hw/bnxtre/bnxt_re_main.c b/drivers/infiniband/hw/bnxtre/bnxt_re_main.c
new file mode 100644
index 0000000..4c377dc
--- /dev/null
+++ b/drivers/infiniband/hw/bnxtre/bnxt_re_main.c
@@ -0,0 +1,96 @@
+/* Broadcom NetXtreme-C/E RoCE driver.
+ *
+ * Copyright (c) 2016 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+/*
+ * Description: Main component of the bnxt_re driver
+ */
+
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/rculist.h>
+#include "bnxt_re.h"
+static char version[] =
+		BNXT_RE_DESC " v" ROCE_DRV_MODULE_VERSION "\n";
+
+
+MODULE_AUTHOR("Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>");
+MODULE_DESCRIPTION(BNXT_RE_DESC " Driver");
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_VERSION(ROCE_DRV_MODULE_VERSION);
+
+/* globals */
+struct list_head bnxt_re_dev_list = LIST_HEAD_INIT(bnxt_re_dev_list);
+DEFINE_MUTEX(bnxt_re_dev_lock);
+static struct workqueue_struct *bnxt_re_wq;
+/*
+ * "Notifier chain callback can be invoked for the same chain from
+ * different CPUs at the same time".
+ *
+ * For cases when the netdev is already present, our call to the
+ * register_netdevice_notifier() will actually get the rtnl_lock()
+ * before sending NETDEV_REGISTER and (if up) NETDEV_UP
+ * events.
+ *
+ * But for cases when the netdev is not already present, the notifier
+ * chain is subjected to be invoked from different CPUs simultaneously.
+ *
+ * This is protected by the netdev_mutex.
+ */
+static int bnxt_re_netdev_event(struct notifier_block *notifier,
+				unsigned long event, void *ptr)
+{
+	return NOTIFY_DONE;
+}
+static struct notifier_block bnxt_re_netdev_notifier = {
+	.notifier_call = bnxt_re_netdev_event
+};
+static int __init bnxt_re_mod_init(void)
+{
+	int rc = 0;
+
+	pr_info("%s: %s", ROCE_DRV_MODULE_NAME, version);
+
+	bnxt_re_wq = create_singlethread_workqueue("bnxt_re");
+	if (!bnxt_re_wq)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&bnxt_re_dev_list);
+
+	rc = register_netdevice_notifier(&bnxt_re_netdev_notifier);
+	if (rc) {
+		pr_err("%s: Cannot register to netdevice_notifier",
+			ROCE_DRV_MODULE_NAME);
+		goto err_netdev;
+	}
+	return 0;
+
+err_netdev:
+	destroy_workqueue(bnxt_re_wq);
+
+	return rc;
+}
+static void __exit bnxt_re_mod_exit(void)
+{
+	LIST_HEAD(to_be_deleted);
+
+	/* Free all adapter allocated resources */
+	mutex_lock(&bnxt_re_dev_lock);
+	if (!list_empty(&bnxt_re_dev_list))
+		list_splice_init_rcu(&bnxt_re_dev_list, &to_be_deleted,
+				     synchronize_rcu);
+	mutex_unlock(&bnxt_re_dev_lock);
+	unregister_netdevice_notifier(&bnxt_re_netdev_notifier);
+	if (bnxt_re_wq)
+		destroy_workqueue(bnxt_re_wq);
+}
+
+module_init(bnxt_re_mod_init);
+module_exit(bnxt_re_mod_exit);
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
