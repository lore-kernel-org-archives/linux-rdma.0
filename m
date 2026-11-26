Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.59
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705043;
	b=kjB+j52/xtOINQPV2Ty+xosq45Z8SPprMnze03zT4uGT41rEv216A//4bGTPsy6QYk4F
	 8yKWmlr94K24O+OMPfb2tLHIybey3bV4PpP1pUZROJ+irk8YopJSBInIRdUNOmJ+4A19U
	 Kl9SGtIWHc1n2/oLA5Z4uuwPwmZ/JW5aY5zcCAmLhGt6ETs2cIIP2f7oXclLSndePKawB
	 vv8gfltoVCmb5dxjJV5XfEaIiZeXXV7fDdwV53PUYJN72IudsW5FRkef4owGTU0E6yRTn
	 0DL2rnHG4u6SqPQNcht/Ht6CU2uk8D/t797/MCDvVkWfKNxudJidDnM2goL6dsSbq+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705043;
	h=DMARC-Filter:DKIM-Signature:Subject:Message-Id:In-Reply-To:
	 Content-Transfer-Encoding:To:Cc:From:Received:Content-Type:X-Mailer:
	 Date:X-Original-From:Mime-Version:References:X-Lms-Return-Path;
	bh=QHqLS3Lb6Agvm1JH+yEBrEtKRMG4ffmyogGVZrw7Qn4=;
	b=p3UkiSxGvPEjM18WjJHNqtumyNBuTyYrAiLu6LKEMUbKO1kzSUjsTvb6be6K4cFOOX2A
	 XlQvM/U66E/PrJ7a3CEW5Tuqqw2zE28foQRZv6InbW1dtM6D0mtCKM86ZmC00QPVIGJYN
	 0NNwzogdD/8g548lbMKQ02RIIPd8WWEVuCPcDzvJnLLNdNz5ZaDTozhvPD+2Z5D3limH4
	 lfPxRLkr84N/Clx+n4zXNEbQMeXT+X02J1q+RF8FRaY/NLiETO0LX1zroXUduOeqzNHdO
	 9xPRGUcWMFT67RLSjFcdgpPs7EXllH/LRZXttF8dqXg91Ng39+xvzqyo2qGEKx4D72g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=yunsilicon.com;
	spf=pass smtp.mailfrom=yunsilicon.com;
	dkim=pass header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=f1xIgfwg;
	arc=none smtp.remote-ip=209.127.231.59
Received: from va-2-59.ptr.blmpb.com (va-2-59.ptr.blmpb.com [209.127.231.59])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15F5606A31E
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 14:57:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C15F5606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=f1xIgfwg
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1795705036; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=QHqLS3Lb6Agvm1JH+yEBrEtKRMG4ffmyogGVZrw7Qn4=;
 b=f1xIgfwgGxG6fLx/CIf+1up+vWR6kHmXlkwBaL8im2I0Uw7Jm1CrrThbyhBdaqXGcTV910
 rr1vY+gzDf5z3vFVBKQWJy+iSDSGjBjHyhfjcLxwwGSAVbu65keqYcKWiXD5PNYR1CX8om
 AeK+gjnjMZOYFr86mkLP7UWFkwt9VI7R0Psr72wR9cjGFVTiojkmFFG64IuuYQtcC6i5/w
 k31b+0tB/ElgA2VTdx9X8/IlLlz0CaiNuRPlCtp2YhmaR2qNpl0oZKJs3iLynX0XtI4/j6
 /F02vJsRWau4UWHJzcIfR7WLPhLuhoXDLgh4JlCl/FRqlPdcsRqFjMRe7rI8qQ==
Subject: [PATCH v2 01/11] net/xsc: add Yunsilicon XSC ethernet PCI driver
Message-Id: <20261126145711.70868-2-tianx@yunsilicon.com>
In-Reply-To: <20261126145711.70868-1-tianx@yunsilicon.com>
Content-Transfer-Encoding: 7bit
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>, 
	"Junxian Huang" <huangjunxian6@hisilicon.com>
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>, 
	<kerneljasonxing@gmail.com>
From: "Xin Tian" <tianx@yunsilicon.com>
Received: from DESKTOP-TGBQGEC.localdomain ([183.193.56.110]) by smtp.feishu.cn with ESMTPS; Thu, 26 Nov 2026 22:57:13 +0800
Content-Type: text/plain; charset=UTF-8
X-Mailer: git-send-email 2.25.1
Date: Thu, 26 Nov 2026 22:57:13 +0800
X-Original-From: Xin Tian <tianx@yunsilicon.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261126145711.70868-1-tianx@yunsilicon.com>
X-Lms-Return-Path: <lba+26b0848ca+2aef17+vger.kernel.org+tianx@yunsilicon.com>

skeleton

Add the Yunsilicon vendor Kbuild glue and the PCI layer of the XSC
ethernet driver. For now the PCI core only enables the device, maps
BAR0 and records DMA capabilities; the doorbell, command queue and
netdev layer are added by subsequent patches.

Signed-off-by: Xin Tian <tianx@yunsilicon.com>
---
 MAINTAINERS                                   |   7 +
 drivers/net/ethernet/Kconfig                  |   1 +
 drivers/net/ethernet/Makefile                 |   1 +
 drivers/net/ethernet/yunsilicon/Kconfig       |  26 +++
 drivers/net/ethernet/yunsilicon/Makefile      |   8 +
 .../ethernet/yunsilicon/xsc/common/xsc_core.h |  35 ++++
 .../ethernet/yunsilicon/xsc/common/xsc_reg.h  |  23 +++
 .../net/ethernet/yunsilicon/xsc/pci/Kconfig   |  16 ++
 .../net/ethernet/yunsilicon/xsc/pci/Makefile  |   9 +
 .../net/ethernet/yunsilicon/xsc/pci/main.c    | 170 ++++++++++++++++++
 10 files changed, 296 insertions(+)
 create mode 100644 drivers/net/ethernet/yunsilicon/Kconfig
 create mode 100644 drivers/net/ethernet/yunsilicon/Makefile
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/xsc_reg.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/Kconfig
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/main.c

diff --git a/MAINTAINERS b/MAINTAINERS
index c24144478..bc9e7d267 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -30069,6 +30069,13 @@ S:	Maintained
 F:	Documentation/input/devices/yealink.rst
 F:	drivers/input/misc/yealink.*
 
+YUNSILICON XSC DRIVERS
+M:	Honggang Wei <weihg@yunsilicon.com>
+M:	Xin Tian <tianx@yunsilicon.com>
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/ethernet/yunsilicon/xsc
+
 ZD1211RW WIRELESS DRIVER
 L:	linux-wireless@vger.kernel.org
 S:	Orphan
diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
index 8581ccba1..88cdf87b0 100644
--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -189,6 +189,7 @@ source "drivers/net/ethernet/wangxun/Kconfig"
 source "drivers/net/ethernet/wiznet/Kconfig"
 source "drivers/net/ethernet/xilinx/Kconfig"
 source "drivers/net/ethernet/xircom/Kconfig"
+source "drivers/net/ethernet/yunsilicon/Kconfig"
 source "drivers/net/ethernet/zte/Kconfig"
 
 endif # ETHERNET
diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
index 2b1153d35..5b571d761 100644
--- a/drivers/net/ethernet/Makefile
+++ b/drivers/net/ethernet/Makefile
@@ -101,6 +101,7 @@ obj-$(CONFIG_NET_VENDOR_VIA) += via/
 obj-$(CONFIG_NET_VENDOR_WANGXUN) += wangxun/
 obj-$(CONFIG_NET_VENDOR_WIZNET) += wiznet/
 obj-$(CONFIG_NET_VENDOR_XILINX) += xilinx/
+obj-$(CONFIG_NET_VENDOR_YUNSILICON) += yunsilicon/
 obj-$(CONFIG_NET_VENDOR_XIRCOM) += xircom/
 obj-$(CONFIG_NET_VENDOR_SYNOPSYS) += synopsys/
 obj-$(CONFIG_NET_VENDOR_PENSANDO) += pensando/
diff --git a/drivers/net/ethernet/yunsilicon/Kconfig b/drivers/net/ethernet/yunsilicon/Kconfig
new file mode 100644
index 000000000..ffdfdf4bf
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/Kconfig
@@ -0,0 +1,26 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+# All rights reserved.
+#
+# Yunsilicon driver configuration
+#
+
+config NET_VENDOR_YUNSILICON
+	bool "Yunsilicon devices"
+	default y
+	depends on PCI
+	depends on 64BIT || COMPILE_TEST
+	help
+	  If you have a network (Ethernet) device belonging to this class,
+	  say Y.
+
+	  Note that the answer to this question doesn't directly affect the
+	  kernel: saying N will just cause the configurator to skip all
+	  the questions about Yunsilicon cards. If you say Y, you will be asked
+	  for your specific card in the following questions.
+
+if NET_VENDOR_YUNSILICON
+
+source "drivers/net/ethernet/yunsilicon/xsc/pci/Kconfig"
+
+endif # NET_VENDOR_YUNSILICON
diff --git a/drivers/net/ethernet/yunsilicon/Makefile b/drivers/net/ethernet/yunsilicon/Makefile
new file mode 100644
index 000000000..b2924ccaf
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/Makefile
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+# All rights reserved.
+#
+# Makefile for the Yunsilicon device drivers.
+#
+
+obj-$(CONFIG_YUNSILICON_XSC_PCI) += xsc/pci/
diff --git a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
new file mode 100644
index 000000000..2d0eda8a2
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __XSC_CORE_H
+#define __XSC_CORE_H
+
+#include <linux/pci.h>
+#include <linux/bitfield.h>
+
+#define XSC_PCI_VENDOR_ID		0x1f67
+
+#define XSC_MC_PF_DEV_ID		0x1011
+
+#define XSC_MF_HOST_PF_DEV_ID		0x1051
+#define XSC_MF_SOC_PF_DEV_ID		0x1053
+
+#define XSC_MS_PF_DEV_ID		0x1111
+
+#define XSC_MV_HOST_PF_DEV_ID		0x1151
+#define XSC_MV_SOC_PF_DEV_ID		0x1153
+
+#define XSC_PAGE_SHIFT_4K		12
+#define XSC_PAGE_SIZE_4K		(_AC(1, UL) << XSC_PAGE_SHIFT_4K)
+
+struct xsc_core_device {
+	struct pci_dev		*pdev;
+	struct device		*device;
+
+	void __iomem		*bar;
+	int			bar_num;
+};
+
+#endif
diff --git a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_reg.h b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_reg.h
new file mode 100644
index 000000000..26773383f
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_reg.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __XSC_REG_H
+#define __XSC_REG_H
+#define CMDQM_HOST_REQ_BUF_BASE_H_ADDR_MEM_ADDR 0x0
+#define CMDQM_HOST_REQ_BUF_BASE_L_ADDR_MEM_ADDR 0x4
+#define CMDQM_HOST_REQ_PID_MEM_ADDR 0x8
+#define CMDQM_HOST_RSP_BUF_BASE_H_ADDR_MEM_ADDR 0x10
+#define CMDQM_HOST_RSP_BUF_BASE_L_ADDR_MEM_ADDR 0x14
+#define CMDQM_HOST_RSP_PID_MEM_ADDR 0x18
+#define CMDQM_HOST_RSP_CID_MEM_ADDR 0x1c
+#define CMDQM_HOST_VF_ERR_STS_MEM_ADDR 0x20
+
+#define DB_CQ_FUNC_MEM_ADDR 0x8c4
+#define DB_EQ_FUNC_MEM_ADDR 0x8c8
+#define DB_CQ_CID_DIRECT_MEM_ADDR 0x8cc
+#define TX_DB_FUNC_MEM_ADDR 0x8d0
+#define RX_DB_FUNC_MEM_ADDR 0x8d4
+
+#endif
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/Kconfig b/drivers/net/ethernet/yunsilicon/xsc/pci/Kconfig
new file mode 100644
index 000000000..a27a37b3a
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/Kconfig
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+# All rights reserved.
+# Yunsilicon PCI configuration
+#
+
+config YUNSILICON_XSC_PCI
+	tristate "Yunsilicon XSC PCI driver"
+	depends on PCI
+	depends on NET
+	help
+	  This driver provides the PCI core for Yunsilicon XSC
+	  ethernet devices.
+
+	  To compile this driver as a module, choose M here. The module
+	  will be called xsc_pci.
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
new file mode 100644
index 000000000..c163aa950
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
@@ -0,0 +1,9 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+# All rights reserved.
+
+ccflags-y += -I$(srctree)/drivers/net/ethernet/yunsilicon/xsc
+
+obj-$(CONFIG_YUNSILICON_XSC_PCI) += xsc_pci.o
+
+xsc_pci-y := main.o
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/main.c b/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
new file mode 100644
index 000000000..c926507a7
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
@@ -0,0 +1,170 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include <linux/slab.h>
+
+#include "common/xsc_core.h"
+
+static const struct pci_device_id xsc_pci_id_table[] = {
+	{ PCI_DEVICE(XSC_PCI_VENDOR_ID, XSC_MC_PF_DEV_ID) },
+	{ PCI_DEVICE(XSC_PCI_VENDOR_ID, XSC_MF_HOST_PF_DEV_ID) },
+	{ PCI_DEVICE(XSC_PCI_VENDOR_ID, XSC_MF_SOC_PF_DEV_ID) },
+	{ PCI_DEVICE(XSC_PCI_VENDOR_ID, XSC_MS_PF_DEV_ID) },
+	{ PCI_DEVICE(XSC_PCI_VENDOR_ID, XSC_MV_HOST_PF_DEV_ID) },
+	{ PCI_DEVICE(XSC_PCI_VENDOR_ID, XSC_MV_SOC_PF_DEV_ID) },
+	{ 0 }
+};
+
+static int xsc_set_dma_caps(struct pci_dev *pdev)
+{
+	int err;
+
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (!err)
+		dma_set_max_seg_size(&pdev->dev, SZ_2G);
+
+	return err;
+}
+
+static int xsc_pci_init(struct xsc_core_device *xdev,
+			const struct pci_device_id *id)
+{
+	struct pci_dev *pdev = xdev->pdev;
+	void __iomem *bar_base;
+	int bar_num = 0;
+	int err;
+
+	err = pci_enable_device(pdev);
+	if (err) {
+		pci_err(pdev, "failed to enable PCI device: err=%d\n", err);
+		goto err_out;
+	}
+
+	err = pci_request_region(pdev, bar_num, KBUILD_MODNAME);
+	if (err) {
+		pci_err(pdev, "failed to request %s pci_region=%d: err=%d\n",
+			KBUILD_MODNAME, bar_num, err);
+		goto err_disable;
+	}
+
+	pci_set_master(pdev);
+
+	err = xsc_set_dma_caps(pdev);
+	if (err) {
+		pci_err(pdev, "failed to set DMA capabilities mask: err=%d\n",
+			err);
+		goto err_clr_master;
+	}
+
+	bar_base = pci_ioremap_bar(pdev, bar_num);
+	if (!bar_base) {
+		pci_err(pdev, "failed to ioremap %s bar%d\n", KBUILD_MODNAME,
+			bar_num);
+		err = -ENOMEM;
+		goto err_clr_master;
+	}
+
+	err = pci_save_state(pdev);
+	if (err) {
+		pci_err(pdev, "pci_save_state failed: err=%d\n", err);
+		goto err_io_unmap;
+	}
+
+	xdev->bar_num = bar_num;
+	xdev->bar = bar_base;
+
+	return 0;
+
+err_io_unmap:
+	pci_iounmap(pdev, bar_base);
+err_clr_master:
+	pci_clear_master(pdev);
+	pci_release_region(pdev, bar_num);
+err_disable:
+	pci_disable_device(pdev);
+err_out:
+	return err;
+}
+
+static void xsc_pci_fini(struct xsc_core_device *xdev)
+{
+	struct pci_dev *pdev = xdev->pdev;
+
+	pci_iounmap(pdev, xdev->bar);
+	pci_clear_master(pdev);
+	pci_release_region(pdev, xdev->bar_num);
+	pci_disable_device(pdev);
+}
+
+static int xsc_pci_probe(struct pci_dev *pci_dev,
+			 const struct pci_device_id *id)
+{
+	struct xsc_core_device *xdev;
+	int err;
+
+	xdev = kzalloc_obj(*xdev, GFP_KERNEL);
+	if (!xdev)
+		return -ENOMEM;
+
+	xdev->pdev = pci_dev;
+	xdev->device = &pci_dev->dev;
+
+	pci_set_drvdata(pci_dev, xdev);
+	err = xsc_pci_init(xdev, id);
+	if (err) {
+		pci_err(pci_dev, "xsc_pci_init failed %d\n", err);
+		goto err_unset_pci_drvdata;
+	}
+
+	return 0;
+
+err_unset_pci_drvdata:
+	pci_set_drvdata(pci_dev, NULL);
+	kfree(xdev);
+
+	return err;
+}
+
+static void xsc_pci_remove(struct pci_dev *pci_dev)
+{
+	struct xsc_core_device *xdev = pci_get_drvdata(pci_dev);
+
+	xsc_pci_fini(xdev);
+	pci_set_drvdata(pci_dev, NULL);
+	kfree(xdev);
+}
+
+static struct pci_driver xsc_pci_driver = {
+	.name		= "xsc-pci",
+	.id_table	= xsc_pci_id_table,
+	.probe		= xsc_pci_probe,
+	.remove		= xsc_pci_remove,
+};
+
+static int __init xsc_init(void)
+{
+	int err;
+
+	err = pci_register_driver(&xsc_pci_driver);
+	if (err) {
+		pr_err("failed to register pci driver\n");
+		return err;
+	}
+
+	return 0;
+}
+
+static void __exit xsc_fini(void)
+{
+	pci_unregister_driver(&xsc_pci_driver);
+}
+
+module_init(xsc_init);
+module_exit(xsc_fini);
+
+MODULE_DEVICE_TABLE(pci, xsc_pci_id_table);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Yunsilicon XSC PCI driver");
-- 
2.43.0
