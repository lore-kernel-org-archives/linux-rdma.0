Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=183.62.165.209
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792826765;
	b=ilqHrFj8+uZQf1wbL0hPxGm6igXrqyiCkiZovh4H/j28AEqKWGmPDIYpzRGrwfmIEYGH
	 QB8zvxl9p63eoYjLoc/c+7t20p+KMEZZroIn1ANfq78+bU9Dch7UHltCZpKzzUIj82f9g
	 +lic0WOyeq5BXxXGWsvvKzNR48BmYc5ytdO1udfdICTtRAGVLTlHosasJ821HSplSKeXD
	 rsRjKceSPPShLSVwEi7ng6zS8mkZEfYwBAImz9AWyenBGRFQQyp23WUXuAoh4/sFNVrlQ
	 hbqMXtWgMaBNKEp0lJlp7fKmyozJkb8KTotJYEusKf3TGxyGkeNN3a7MxX6qFMnow7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792826765;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:
	 X-Zmail-LocalSMTP:X-Zmail-RealSender:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-ZMAIL-USEORIGINALEMLTOOUTBOUND:Content-Transfer-Encoding:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=9crfpEcboCTwaxJMz0XhJwgj28lYag0GHScqzTGMi8M=;
	b=h1w0ejkbH1sXGQXSRzq79+29OEs2892lajpcgKxpBkaBpD2u5yXcdha4j4UoRJK3M1lg
	 v0ImKrbJEKJ8cQcY6y1dyDTUOZsgHfjW3sdMyGJ361ArOkTse5d1tq4R9F44e2nBSSjPE
	 dSfpW5LoDd2VbC9U26lXbEpdpsETa2X94EFK/C/3hfAAGQdUlHENX1rUF071COmMBQX+o
	 9ClA7rYm75MuCT6BQyelPjXEMx7Ik8LgJrPur4V0EwjsDuZzS2IGbPVugpYu8y7bEOQyJ
	 Xt13BHH75Gw6EdVVQdSdvkQi4ReEtfbzSnSnIEoUf3t1jnkZn46pDr1KK9wyoD8ZFpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=183.62.165.209
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DB9606A330;
	Sat, 24 Oct 2026 07:26:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46DB9606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4jBWdZ2H4Mz55y2N;
	Sat, 24 Oct 2026 15:25:54 +0800 (CST)
Received: from szxl2zmapp06.zte.com.cn ([10.1.32.108])
	by mse-fl1.zte.com.cn with SMTP id 69O7Pi8Y030407;
	Sat, 24 Oct 2026 15:25:44 +0800 (+08)
	(envelope-from zhang.yanze@zte.com.cn)
Received: from localhost.localdomain (unknown [192.168.6.15])
	by smtp (Zmail) with SMTP;
	Sat, 24 Oct 2026 15:25:46 +0800
X-Zmail-TransId: 3e816adc5d79026-b7b7b
X-Zmail-LocalSMTP: 1
X-Zmail-RealSender: zhang.yanze@zte.com.cn
From: Yanze Zhang <zhang.yanze@zte.com.cn>
To: jgg@ziepe.ca, leon@kernel.org, julianbraha@gmail.com,
        huangjunxian6@hisilicon.com, yanjun.zhu@linux.dev, lkp@intel.com
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        wei.quan@zte.com.cn, han.junyang@zte.com.cn, ran.ming@zte.com.cn,
        han.chengfei@zte.com.cn, zhang.yanze@zte.com.cn
Subject: [PATCH 1/7] RDMA/zrdma: Add build infrastructure and module skeleton
Date: Sat, 24 Oct 2026 15:15:33 +0800
Message-ID: <20261024071539.2182864-2-zhang.yanze@zte.com.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261024071539.2182864-1-zhang.yanze@zte.com.cn>
References: <20261024071539.2182864-1-zhang.yanze@zte.com.cn>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ZMAIL-USEORIGINALEMLTOOUTBOUND: 1
Content-Transfer-Encoding: 8bit
X-MAIL:mse-fl1.zte.com.cn 69O7Pi8Y030407
X-TLS: YES
X-ENVELOPE-SENDER: zhang.yanze@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Sat, 24 Oct 2026 15:25:54 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6ADC5D82.001/4jBWdZ2H4Mz55y2N

Add MAINTAINERS entry, Kconfig, and Makefile entries for the ZTE DingHai
RDMA driver. Include a minimal module skeleton with auxiliary driver
registration structure to ensure the build system works and the module
can be loaded.

Signed-off-by: Yanze Zhang <zhang.yanze@zte.com.cn>
---
 MAINTAINERS                              |  6 +++
 drivers/infiniband/Kconfig               |  1 +
 drivers/infiniband/hw/Makefile           |  1 +
 drivers/infiniband/hw/zrdma/Kconfig      | 12 +++++
 drivers/infiniband/hw/zrdma/Makefile     |  4 ++
 drivers/infiniband/hw/zrdma/zrdma_main.c | 57 ++++++++++++++++++++++++
 include/uapi/rdma/ib_user_ioctl_verbs.h  |  1 +
 7 files changed, 82 insertions(+)
 create mode 100644 drivers/infiniband/hw/zrdma/Kconfig
 create mode 100644 drivers/infiniband/hw/zrdma/Makefile
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_main.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 2a6e6ec629e0..84a2c6fc3699 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -30193,6 +30193,12 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/zte/
 
+ZTE DINGHAI ZRDMA DRIVER
+M:	Yanze Zhang <zhang.yanze@zte.com.cn>
+L:	linux-rdma@vger.kernel.org
+S:	Supported
+F:	drivers/infiniband/hw/zrdma/
+
 THE REST
 M:	Linus Torvalds <torvalds@linux-foundation.org>
 L:	linux-kernel@vger.kernel.org
diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 086195758a8a..419dbf742f38 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -100,6 +100,7 @@ source "drivers/infiniband/hw/ocrdma/Kconfig"
 source "drivers/infiniband/hw/qedr/Kconfig"
 source "drivers/infiniband/hw/usnic/Kconfig"
 source "drivers/infiniband/hw/vmw_pvrdma/Kconfig"
+source "drivers/infiniband/hw/zrdma/Kconfig"
 source "drivers/infiniband/sw/rdmavt/Kconfig"
 endif # !UML
 source "drivers/infiniband/sw/rxe/Kconfig"
diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Makefile
index c42b22ac3303..a86b867c56d4 100644
--- a/drivers/infiniband/hw/Makefile
+++ b/drivers/infiniband/hw/Makefile
@@ -16,3 +16,4 @@ obj-$(CONFIG_INFINIBAND_BNXT_RE)	+= bnxt_re/
 obj-$(CONFIG_INFINIBAND_BNG_RE)		+= bng_re/
 obj-$(CONFIG_INFINIBAND_ERDMA)		+= erdma/
 obj-$(CONFIG_INFINIBAND_IONIC)		+= ionic/
+obj-$(CONFIG_INFINIBAND_ZRDMA)		+= zrdma/
diff --git a/drivers/infiniband/hw/zrdma/Kconfig b/drivers/infiniband/hw/zrdma/Kconfig
new file mode 100644
index 000000000000..bfe21c123217
--- /dev/null
+++ b/drivers/infiniband/hw/zrdma/Kconfig
@@ -0,0 +1,12 @@
+# SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+config INFINIBAND_ZRDMA
+	tristate "ZTE Ethernet Protocol Driver for RDMA"
+	depends on PCI
+	depends on NETDEVICES
+	select AUXILIARY_BUS
+	help
+	  Say Y or M here to enable support for the ZTE DingHai (ZXDH) Ethernet
+	  Protocol Driver for RDMA. This driver provides RDMA over Converged
+	  Ethernet (RoCE) functionality for ZTE DingHai network adapters.
+	  If you choose to build this driver as a module, it will be built as
+	  a module named zrdma.
diff --git a/drivers/infiniband/hw/zrdma/Makefile b/drivers/infiniband/hw/zrdma/Makefile
new file mode 100644
index 000000000000..2ddf50d1fd20
--- /dev/null
+++ b/drivers/infiniband/hw/zrdma/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+
+obj-$(CONFIG_INFINIBAND_ZRDMA) += zrdma.o
+zrdma-y := zrdma_main.o
diff --git a/drivers/infiniband/hw/zrdma/zrdma_main.c b/drivers/infiniband/hw/zrdma/zrdma_main.c
new file mode 100644
index 000000000000..af1d37be6336
--- /dev/null
+++ b/drivers/infiniband/hw/zrdma/zrdma_main.c
@@ -0,0 +1,57 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * ZTE DingHai Rdma driver
+ * Copyright (c) 2022-2026, ZTE Corporation
+ */
+
+#include <linux/module.h>
+#include <linux/auxiliary_bus.h>
+
+#define ZXDH_PF_NAME "dinghai10e"
+#define ZXDH_RDMA_DEV_NAME "rdma_aux"
+
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_AUTHOR("Yanze Zhang <zhang.yanze@zte.com.cn>");
+MODULE_DESCRIPTION("ZTE Ethernet Protocol Driver for RDMA");
+
+static const struct auxiliary_device_id zxdh_auxiliary_id_table[] = {
+	{
+		.name = ZXDH_PF_NAME "." ZXDH_RDMA_DEV_NAME,
+	},
+	{},
+};
+
+MODULE_DEVICE_TABLE(auxiliary, zxdh_auxiliary_id_table);
+
+static int zxdh_probe(struct auxiliary_device *aux_dev,
+		      const struct auxiliary_device_id *id)
+{
+	/* Placeholder: Real probe logic will be added in subsequent patches */
+	dev_info(&aux_dev->dev, "ZTE DingHai RDMA device detected (stub)\n");
+	return 0;
+}
+
+static void zxdh_remove(struct auxiliary_device *aux_dev)
+{
+	dev_info(&aux_dev->dev, "ZTE DingHai RDMA device removed (stub)\n");
+}
+
+static struct auxiliary_driver zxdh_auxiliary_drv = {
+	.name = ZXDH_RDMA_DEV_NAME,
+	.id_table = zxdh_auxiliary_id_table,
+	.probe = zxdh_probe,
+	.remove = zxdh_remove,
+};
+
+static int __init zrdma_module_init(void)
+{
+	return auxiliary_driver_register(&zxdh_auxiliary_drv);
+}
+
+static void __exit zrdma_module_exit(void)
+{
+	auxiliary_driver_unregister(&zxdh_auxiliary_drv);
+}
+
+module_init(zrdma_module_init);
+module_exit(zrdma_module_exit);
diff --git a/include/uapi/rdma/ib_user_ioctl_verbs.h b/include/uapi/rdma/ib_user_ioctl_verbs.h
index 21f86cc7bb1f..98dcea207357 100644
--- a/include/uapi/rdma/ib_user_ioctl_verbs.h
+++ b/include/uapi/rdma/ib_user_ioctl_verbs.h
@@ -257,6 +257,7 @@ enum rdma_driver_id {
 	RDMA_DRIVER_ERDMA,
 	RDMA_DRIVER_MANA,
 	RDMA_DRIVER_IONIC,
+	RDMA_DRIVER_ZRDMA,
 };
 
 enum ib_uverbs_gid_type {
-- 
2.27.0

