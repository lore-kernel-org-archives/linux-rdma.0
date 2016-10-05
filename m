From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH qedr 01/10] qedr: Add RoCE driver framework
Date: Wed, 5 Oct 2016 18:47:54 +0300
Message-ID: <1475682483-9878-2-git-send-email-Ram.Amrani@cavium.com>
References: <1475682483-9878-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475682483-9878-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Yuval.Mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Adds a skeletal implementation of the qed* RoCE driver -
basically the ability to communicate with the qede driver and
receive notifications from it regarding various init/exit events.

Signed-off-by: Rajesh Borundia <rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/Kconfig          |   2 +
 drivers/infiniband/hw/Makefile      |   1 +
 drivers/infiniband/hw/qedr/Kconfig  |   7 +
 drivers/infiniband/hw/qedr/Makefile |   3 +
 drivers/infiniband/hw/qedr/main.c   | 254 ++++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/qedr/qedr.h   |  61 +++++++++
 drivers/net/ethernet/qlogic/Kconfig |  11 --
 include/uapi/linux/pci_regs.h       |   3 +
 8 files changed, 331 insertions(+), 11 deletions(-)
 create mode 100644 drivers/infiniband/hw/qedr/Kconfig
 create mode 100644 drivers/infiniband/hw/qedr/Makefile
 create mode 100644 drivers/infiniband/hw/qedr/main.c
 create mode 100644 drivers/infiniband/hw/qedr/qedr.h

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 19a418a..fb3fb89 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -89,4 +89,6 @@ source "drivers/infiniband/sw/rxe/Kconfig"
 
 source "drivers/infiniband/hw/hfi1/Kconfig"
 
+source "drivers/infiniband/hw/qedr/Kconfig"
+
 endif # INFINIBAND
diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Makefile
index 21fe401..e7a5ed9 100644
--- a/drivers/infiniband/hw/Makefile
+++ b/drivers/infiniband/hw/Makefile
@@ -10,3 +10,4 @@ obj-$(CONFIG_INFINIBAND_OCRDMA)		+= ocrdma/
 obj-$(CONFIG_INFINIBAND_USNIC)		+= usnic/
 obj-$(CONFIG_INFINIBAND_HFI1)		+= hfi1/
 obj-$(CONFIG_INFINIBAND_HNS)		+= hns/
+obj-$(CONFIG_INFINIBAND_QEDR)		+= qedr/
diff --git a/drivers/infiniband/hw/qedr/Kconfig b/drivers/infiniband/hw/qedr/Kconfig
new file mode 100644
index 0000000..7c06d85
--- /dev/null
+++ b/drivers/infiniband/hw/qedr/Kconfig
@@ -0,0 +1,7 @@
+config INFINIBAND_QEDR
+	tristate "QLogic RoCE driver"
+	depends on 64BIT && QEDE
+	select QED_LL2
+	---help---
+	  This driver provides low-level InfiniBand over Ethernet
+	  support for QLogic QED host channel adapters (HCAs).
diff --git a/drivers/infiniband/hw/qedr/Makefile b/drivers/infiniband/hw/qedr/Makefile
new file mode 100644
index 0000000..3a5b7a2
--- /dev/null
+++ b/drivers/infiniband/hw/qedr/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_INFINIBAND_QEDR) := qedr.o
+
+qedr-y := main.o
diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
new file mode 100644
index 0000000..7387d02
--- /dev/null
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -0,0 +1,254 @@
+/* QLogic qedr NIC Driver
+ * Copyright (c) 2015-2016  QLogic Corporation
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and /or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+#include <linux/module.h>
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_addr.h>
+#include <linux/netdevice.h>
+#include <linux/iommu.h>
+#include <net/addrconf.h>
+#include <linux/qed/qede_roce.h>
+#include "qedr.h"
+
+MODULE_DESCRIPTION("QLogic 40G/100G ROCE Driver");
+MODULE_AUTHOR("QLogic Corporation");
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_VERSION(QEDR_MODULE_VERSION);
+
+void qedr_ib_dispatch_event(struct qedr_dev *dev, u8 port_num,
+			    enum ib_event_type type)
+{
+	struct ib_event ibev;
+
+	ibev.device = &dev->ibdev;
+	ibev.element.port_num = port_num;
+	ibev.event = type;
+
+	ib_dispatch_event(&ibev);
+}
+
+static enum rdma_link_layer qedr_link_layer(struct ib_device *device,
+					    u8 port_num)
+{
+	return IB_LINK_LAYER_ETHERNET;
+}
+
+static int qedr_register_device(struct qedr_dev *dev)
+{
+	strlcpy(dev->ibdev.name, "qedr%d", IB_DEVICE_NAME_MAX);
+
+	memcpy(dev->ibdev.node_desc, QEDR_NODE_DESC, sizeof(QEDR_NODE_DESC));
+	dev->ibdev.owner = THIS_MODULE;
+
+	dev->ibdev.get_link_layer = qedr_link_layer;
+
+	return 0;
+}
+
+/* QEDR sysfs interface */
+static ssize_t show_rev(struct device *device, struct device_attribute *attr,
+			char *buf)
+{
+	struct qedr_dev *dev = dev_get_drvdata(device);
+
+	return scnprintf(buf, PAGE_SIZE, "0x%x\n", dev->pdev->vendor);
+}
+
+static ssize_t show_hca_type(struct device *device,
+			     struct device_attribute *attr, char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%s\n", "HCA_TYPE_TO_SET");
+}
+
+static DEVICE_ATTR(hw_rev, S_IRUGO, show_rev, NULL);
+static DEVICE_ATTR(hca_type, S_IRUGO, show_hca_type, NULL);
+
+static struct device_attribute *qedr_attributes[] = {
+	&dev_attr_hw_rev,
+	&dev_attr_hca_type
+};
+
+static void qedr_remove_sysfiles(struct qedr_dev *dev)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(qedr_attributes); i++)
+		device_remove_file(&dev->ibdev.dev, qedr_attributes[i]);
+}
+
+static void qedr_pci_set_atomic(struct qedr_dev *dev, struct pci_dev *pdev)
+{
+	struct pci_dev *bridge;
+	u32 val;
+
+	dev->atomic_cap = IB_ATOMIC_NONE;
+
+	bridge = pdev->bus->self;
+	if (!bridge)
+		return;
+
+	/* Check whether we are connected directly or via a switch */
+	while (bridge && bridge->bus->parent) {
+		DP_DEBUG(dev, QEDR_MSG_INIT,
+			 "Device is not connected directly to root. bridge->bus->number=%d primary=%d\n",
+			 bridge->bus->number, bridge->bus->primary);
+		/* Need to check Atomic Op Routing Supported all the way to
+		 * root complex.
+		 */
+		pcie_capability_read_dword(bridge, PCI_EXP_DEVCAP2, &val);
+		if (!(val & PCI_EXP_DEVCAP2_ATOMIC_ROUTE)) {
+			pcie_capability_clear_word(pdev,
+						   PCI_EXP_DEVCTL2,
+						   PCI_EXP_DEVCTL2_ATOMIC_REQ);
+			return;
+		}
+		bridge = bridge->bus->parent->self;
+	}
+	bridge = pdev->bus->self;
+
+	/* according to bridge capability */
+	pcie_capability_read_dword(bridge, PCI_EXP_DEVCAP2, &val);
+	if (val & PCI_EXP_DEVCAP2_ATOMIC_COMP64) {
+		pcie_capability_set_word(pdev, PCI_EXP_DEVCTL2,
+					 PCI_EXP_DEVCTL2_ATOMIC_REQ);
+		dev->atomic_cap = IB_ATOMIC_GLOB;
+	} else {
+		pcie_capability_clear_word(pdev, PCI_EXP_DEVCTL2,
+					   PCI_EXP_DEVCTL2_ATOMIC_REQ);
+	}
+}
+
+static struct qedr_dev *qedr_add(struct qed_dev *cdev, struct pci_dev *pdev,
+				 struct net_device *ndev)
+{
+	struct qedr_dev *dev;
+	int rc = 0, i;
+
+	dev = (struct qedr_dev *)ib_alloc_device(sizeof(*dev));
+	if (!dev) {
+		pr_err("Unable to allocate ib device\n");
+		return NULL;
+	}
+
+	DP_DEBUG(dev, QEDR_MSG_INIT, "qedr add device called\n");
+
+	dev->pdev = pdev;
+	dev->ndev = ndev;
+	dev->cdev = cdev;
+
+	qedr_pci_set_atomic(dev, pdev);
+
+	rc = qedr_register_device(dev);
+	if (rc) {
+		DP_ERR(dev, "Unable to allocate register device\n");
+		goto init_err;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(qedr_attributes); i++)
+		if (device_create_file(&dev->ibdev.dev, qedr_attributes[i]))
+			goto init_err;
+
+	DP_DEBUG(dev, QEDR_MSG_INIT, "qedr driver loaded successfully\n");
+	return dev;
+
+init_err:
+	ib_dealloc_device(&dev->ibdev);
+	DP_ERR(dev, "qedr driver load failed rc=%d\n", rc);
+
+	return NULL;
+}
+
+static void qedr_remove(struct qedr_dev *dev)
+{
+	/* First unregister with stack to stop all the active traffic
+	 * of the registered clients.
+	 */
+	qedr_remove_sysfiles(dev);
+
+	ib_dealloc_device(&dev->ibdev);
+}
+
+static int qedr_close(struct qedr_dev *dev)
+{
+	qedr_ib_dispatch_event(dev, 1, IB_EVENT_PORT_ERR);
+
+	return 0;
+}
+
+static void qedr_shutdown(struct qedr_dev *dev)
+{
+	qedr_close(dev);
+	qedr_remove(dev);
+}
+
+/* event handling via NIC driver ensures that all the NIC specific
+ * initialization done before RoCE driver notifies
+ * event to stack.
+ */
+static void qedr_notify(struct qedr_dev *dev, enum qede_roce_event event)
+{
+	switch (event) {
+	case QEDE_UP:
+		qedr_ib_dispatch_event(dev, 1, IB_EVENT_PORT_ACTIVE);
+		break;
+	case QEDE_DOWN:
+		qedr_close(dev);
+		break;
+	case QEDE_CLOSE:
+		qedr_shutdown(dev);
+		break;
+	case QEDE_CHANGE_ADDR:
+		qedr_ib_dispatch_event(dev, 1, IB_EVENT_GID_CHANGE);
+		break;
+	default:
+		pr_err("Event not supported\n");
+	}
+}
+
+static struct qedr_driver qedr_drv = {
+	.name = "qedr_driver",
+	.add = qedr_add,
+	.remove = qedr_remove,
+	.notify = qedr_notify,
+};
+
+static int __init qedr_init_module(void)
+{
+	return qede_roce_register_driver(&qedr_drv);
+}
+
+static void __exit qedr_exit_module(void)
+{
+	qede_roce_unregister_driver(&qedr_drv);
+}
+
+module_init(qedr_init_module);
+module_exit(qedr_exit_module);
diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
new file mode 100644
index 0000000..8014170
--- /dev/null
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -0,0 +1,61 @@
+/* QLogic qedr NIC Driver
+ * Copyright (c) 2015-2016  QLogic Corporation
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and /or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+#ifndef __QEDR_H__
+#define __QEDR_H__
+
+#include <linux/pci.h>
+#include <rdma/ib_addr.h>
+#include <linux/qed/qed_if.h>
+#include <linux/qed/qede_roce.h>
+
+#define QEDR_MODULE_VERSION	"8.10.10.0"
+#define QEDR_NODE_DESC "QLogic 579xx RoCE HCA"
+#define DP_NAME(dev) ((dev)->ibdev.name)
+
+#define DP_DEBUG(dev, module, fmt, ...)					\
+	pr_debug("(%s) " module ": " fmt,				\
+		 DP_NAME(dev) ? DP_NAME(dev) : "", ## __VA_ARGS__)
+
+#define QEDR_MSG_INIT "INIT"
+
+struct qedr_dev {
+	struct ib_device	ibdev;
+	struct qed_dev		*cdev;
+	struct pci_dev		*pdev;
+	struct net_device	*ndev;
+
+	enum ib_atomic_cap	atomic_cap;
+
+	u32			dp_module;
+	u8			dp_level;
+};
+#endif
diff --git a/drivers/net/ethernet/qlogic/Kconfig b/drivers/net/ethernet/qlogic/Kconfig
index 0df1391f9..1e8339a 100644
--- a/drivers/net/ethernet/qlogic/Kconfig
+++ b/drivers/net/ethernet/qlogic/Kconfig
@@ -107,15 +107,4 @@ config QEDE
 	---help---
 	  This enables the support for ...
 
-config INFINIBAND_QEDR
-	tristate "QLogic qede RoCE sources [debug]"
-	depends on QEDE && 64BIT
-	select QED_LL2
-	default n
-	---help---
-	  This provides a temporary node that allows the compilation
-	  and logical testing of the InfiniBand over Ethernet support
-	  for QLogic QED. This would be replaced by the 'real' option
-	  once the QEDR driver is added [+relocated].
-
 endif # NET_VENDOR_QLOGIC
diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index 4040951..30d66b5 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -612,6 +612,8 @@
  */
 #define PCI_EXP_DEVCAP2		36	/* Device Capabilities 2 */
 #define  PCI_EXP_DEVCAP2_ARI		0x00000020 /* Alternative Routing-ID */
+#define  PCI_EXP_DEVCAP2_ATOMIC_ROUTE	0x00000040 /* Atomic Op routing */
+#define PCI_EXP_DEVCAP2_ATOMIC_COMP64	0x00000100 /* Atomic 64-bit compare */
 #define  PCI_EXP_DEVCAP2_LTR		0x00000800 /* Latency tolerance reporting */
 #define  PCI_EXP_DEVCAP2_OBFF_MASK	0x000c0000 /* OBFF support mechanism */
 #define  PCI_EXP_DEVCAP2_OBFF_MSG	0x00040000 /* New message signaling */
@@ -619,6 +621,7 @@
 #define PCI_EXP_DEVCTL2		40	/* Device Control 2 */
 #define  PCI_EXP_DEVCTL2_COMP_TIMEOUT	0x000f	/* Completion Timeout Value */
 #define  PCI_EXP_DEVCTL2_ARI		0x0020	/* Alternative Routing-ID */
+#define PCI_EXP_DEVCTL2_ATOMIC_REQ	0x0040	/* Set Atomic requests */
 #define  PCI_EXP_DEVCTL2_IDO_REQ_EN	0x0100	/* Allow IDO for requests */
 #define  PCI_EXP_DEVCTL2_IDO_CMP_EN	0x0200	/* Allow IDO for completions */
 #define  PCI_EXP_DEVCTL2_LTR_EN		0x0400	/* Enable LTR mechanism */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
