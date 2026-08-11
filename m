Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C57E432E60;
	Tue, 11 Aug 2026 09:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=160.30.148.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786441388; cv=none; b=H4VckGxz9IzdHwxSw6b9MDmypFN6cUoMtt42XBsLbhm1XIKBBBIk2hgSX0K4A9oxfFxi9nSutDc1dEYU0LfQ1RoTMb8nBmtCAl1B1vvVZlAYIHnb03zaEr8DA3flN1BKrn+XEPWolb0EjgnVrvS39cKlyGSFzoUBvjrXain5H3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786441388; c=relaxed/simple;
	bh=5UwnjW2vL/sLtY92gtKUHFLMY4LA3TUrkup4dyxqPHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2y9fulFprZqHKkf1+2ZUA6wUAy4Nhu7LkFjAV/k9qmta3j1/d9B5PObOsXUOuHFGTvEt8MPSqGHqr37jQw4r/EPG+fM/5GnyqYYtfoy0QTt3AVO42yEaoAhUvm1tggjhJi4qy+edbm6IJaywM9JHasET08Lp+Qyf68awaoBRn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=160.30.148.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mxct.zte.com.cn (unknown [192.168.251.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4hK69t0BHSz8Xrr9;
	Tue, 11 Aug 2026 17:42:58 +0800 (CST)
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4hK69g2g8bz58fdb;
	Tue, 11 Aug 2026 17:42:47 +0800 (CST)
Received: from szxlzmapp03.zte.com.cn ([10.5.231.207])
	by mse-fl2.zte.com.cn with SMTP id 67B9gaj8073846;
	Tue, 11 Aug 2026 17:42:36 +0800 (+08)
	(envelope-from zhang.yanze@zte.com.cn)
Received: from localhost.localdomain (unknown [192.168.6.15])
	by smtp (Zmail) with SMTP;
	Tue, 11 Aug 2026 17:42:38 +0800
X-Zmail-TransId: 3e816a7aee8e013-44463
X-Zmail-LocalSMTP: 1
X-Zmail-RealSender: zhang.yanze@zte.com.cn
From: Yanze Zhang <zhang.yanze@zte.com.cn>
To: jgg@ziepe.ca, leon@kernel.org, julianbraha@gmail.com,
        huangjunxian6@hisilicon.com, yanjun.zhu@linux.dev, lkp@intel.com
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        wei.quan@zte.com.cn, han.junyang@zte.com.cn, ran.ming@zte.com.cn,
        han.chengfei@zte.com.cn, zhang.yanze@zte.com.cn
Subject: [PATCH rdma v5 1/7] RDMA/zrdma: Add build infrastructure and module skeleton
Date: Tue, 11 Aug 2026 17:37:34 +0800
Message-ID: <20260811093740.2607476-2-zhang.yanze@zte.com.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260811093740.2607476-1-zhang.yanze@zte.com.cn>
References: <20260811093740.2607476-1-zhang.yanze@zte.com.cn>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ZMAIL-USEORIGINALEMLTOOUTBOUND: 1
Content-Transfer-Encoding: 8bit
X-MAIL:mse-fl2.zte.com.cn 67B9gaj8073846
X-TLS: YES
X-ENVELOPE-SENDER: zhang.yanze@zte.com.cn
X-SOURCE-IP: 192.168.251.13 unknown Tue, 11 Aug 2026 17:42:58 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A7AEEA1.000/4hK69t0BHSz8Xrr9

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
 drivers/infiniband/hw/zrdma/zrdma_main.c | 59 ++++++++++++++++++++++++
 include/uapi/rdma/ib_user_ioctl_verbs.h  |  1 +
 7 files changed, 84 insertions(+)
 create mode 100644 drivers/infiniband/hw/zrdma/Kconfig
 create mode 100644 drivers/infiniband/hw/zrdma/Makefile
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_main.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 806bd2d80d15..e1369b20a1ef 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -29831,6 +29831,12 @@ S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound.git
 F:	sound/hda/codecs/senarytech.c
 
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
index 000000000000..7954d86573e2
--- /dev/null
+++ b/drivers/infiniband/hw/zrdma/zrdma_main.c
@@ -0,0 +1,59 @@
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
+	.driver = {
+		.name = ZXDH_RDMA_DEV_NAME,
+	},
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

