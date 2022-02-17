Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFB8FC43217
	for <linux-rdma@archiver.kernel.org>; Thu, 17 Feb 2022 03:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbiBQDBv (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 16 Feb 2022 22:01:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbiBQDBs (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 16 Feb 2022 22:01:48 -0500
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDE811A20
        for <linux-rdma@vger.kernel.org>; Wed, 16 Feb 2022 19:01:34 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V4fho6o_1645066891;
Received: from localhost(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0V4fho6o_1645066891)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 17 Feb 2022 11:01:32 +0800
From:   Cheng Xu <chengyou.xc@alibaba-inc.com>
To:     jgg@ziepe.ca, dledford@redhat.com
Cc:     leon@kernel.org, linux-rdma@vger.kernel.org,
        KaiShen@linux.alibaba.com, chengyou@linux.alibaba.com,
        tonylu@linux.alibaba.com
Subject: [PATCH for-next v3 12/12] RDMA/erdma: Add driver to kernel build environment
Date:   Thu, 17 Feb 2022 11:01:16 +0800
Message-Id: <20220217030116.6324-13-chengyou.xc@alibaba-inc.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220217030116.6324-1-chengyou.xc@alibaba-inc.com>
References: <20220217030116.6324-1-chengyou.xc@alibaba-inc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Cheng Xu <chengyou@linux.alibaba.com>

Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
---
 MAINTAINERS                          |  8 ++++++++
 drivers/infiniband/Kconfig           |  1 +
 drivers/infiniband/hw/Makefile       |  1 +
 drivers/infiniband/hw/erdma/Kconfig  | 10 ++++++++++
 drivers/infiniband/hw/erdma/Makefile |  4 ++++
 5 files changed, 24 insertions(+)
 create mode 100644 drivers/infiniband/hw/erdma/Kconfig
 create mode 100644 drivers/infiniband/hw/erdma/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index ea3e6c914384..6beb3019764d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -723,6 +723,14 @@ S:	Maintained
 F:	Documentation/i2c/busses/i2c-ali1563.rst
 F:	drivers/i2c/busses/i2c-ali1563.c
 
+ALIBABA ELASTIC RDMA DRIVER
+M:	Cheng Xu <chengyou@linux.alibaba.com>
+M:	Kai Shen <kaishen@linux.alibaba.com>
+L:	linux-rdma@vger.kernel.org
+S:	Supported
+F:	drivers/infiniband/hw/erdma
+F:	include/uapi/rdma/erdma-abi.h
+
 ALIENWARE WMI DRIVER
 L:	Dell.Client.Kernel@dell.com
 S:	Maintained
diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 33d3ce9c888e..cc6a7ff88ff3 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -92,6 +92,7 @@ source "drivers/infiniband/hw/hns/Kconfig"
 source "drivers/infiniband/hw/bnxt_re/Kconfig"
 source "drivers/infiniband/hw/hfi1/Kconfig"
 source "drivers/infiniband/hw/qedr/Kconfig"
+source "drivers/infiniband/hw/erdma/Kconfig"
 source "drivers/infiniband/sw/rdmavt/Kconfig"
 source "drivers/infiniband/sw/rxe/Kconfig"
 source "drivers/infiniband/sw/siw/Kconfig"
diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Makefile
index fba0b3be903e..6b3a88046125 100644
--- a/drivers/infiniband/hw/Makefile
+++ b/drivers/infiniband/hw/Makefile
@@ -13,3 +13,4 @@ obj-$(CONFIG_INFINIBAND_HFI1)		+= hfi1/
 obj-$(CONFIG_INFINIBAND_HNS)		+= hns/
 obj-$(CONFIG_INFINIBAND_QEDR)		+= qedr/
 obj-$(CONFIG_INFINIBAND_BNXT_RE)	+= bnxt_re/
+obj-$(CONFIG_INFINIBAND_ERDMA)		+= erdma/
diff --git a/drivers/infiniband/hw/erdma/Kconfig b/drivers/infiniband/hw/erdma/Kconfig
new file mode 100644
index 000000000000..8526689fede7
--- /dev/null
+++ b/drivers/infiniband/hw/erdma/Kconfig
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config INFINIBAND_ERDMA
+	tristate "Alibaba Elastic RDMA Adapter (ERDMA) support"
+	depends on PCI_MSI && 64BIT && !CPU_BIG_ENDIAN
+	depends on INFINIBAND_ADDR_TRANS
+	depends on INFINIBAND_USER_ACCESS
+	help
+	  This is a RDMA/iWarp driver for Alibaba Elastic RDMA Adapter(ERDMA).
+
+	  To compile this driver as module, choose M here.
diff --git a/drivers/infiniband/hw/erdma/Makefile b/drivers/infiniband/hw/erdma/Makefile
new file mode 100644
index 000000000000..51d2ef91905a
--- /dev/null
+++ b/drivers/infiniband/hw/erdma/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_INFINIBAND_ERDMA) := erdma.o
+
+erdma-y := erdma_cm.o erdma_main.o erdma_cmdq.o erdma_cq.o erdma_verbs.o erdma_qp.o erdma_eq.o
-- 
2.27.0

