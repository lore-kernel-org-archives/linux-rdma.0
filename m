Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11021077.outbound.protection.outlook.com [40.93.194.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E126334750F
	for <linux-rdma@vger.kernel.org>; Mon,  3 Aug 2026 16:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785772915; cv=fail; b=Re5NTIrhZySLTKzYEc32jLl83vObD0u172fEGTqYrYUdaogkH7gg6bxeRsLvFRwk7DGBf6CfgFGw4UpqBp7JJ6LNi2tok68LHdka9DDCXV5CV9BCOSOxXquirQLpQRmeyyvvRzYEWTqZvqGoHzT8m8HTntMPD92jNsmxmnw7nUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785772915; c=relaxed/simple;
	bh=h2i5vYxGYrx6cRLD64Chz89wBaQ0Dx/bIeC4ogTI8Vg=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PVaovAzIiUnU8ijWo39bo1GFV2F8sX1ABnbtkM3OJk/+OSS6h54lITXukGWFGOYV5VidOqTLDajAEVeSfGb45ve82umf1QCrA41LZFWKNSGEnvx6h1KB7pmxnGeZomkt5GPhd8cxQzHpEZhn9f2GUmI0mlDp/eugdydcG+48uu8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com; spf=pass smtp.mailfrom=cornelisnetworks.com; dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b=eaDm6i9b; arc=fail smtp.client-ip=40.93.194.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b="eaDm6i9b"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=izLaU1FkbAezVv751uOhe8GvzEnAi4Ft6Ia2B3cBhOfwa9OEpEaakebyUAADdlSDs60eyFpccVXZ5pfzi/fH7xTqRPa3r8/FlCbJzl3uZ4dzIrfrLK8I/TK3PmUcxAXPiLFVqulq9Y+WmklqOf+A6IZNAUgdg1ZnMf061XRQ4XZUrkftZmgOvCD4kw54rYSEXQnRiRO8LmW16BzJR36KCJUVgRFOYgUq0F8I8T8u1K9EwmjQpZYqTqNZvYtwHvVRPtkT/JdjbeqHGNwkjjIdrQvn4EzlwqKvgLZpv86EYQU6RiRGs/sRe2w30vw0XjBCmuHNVTmJUUndJ00Ry5zqmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+szlvYiqRh9HtFmBJIeLu+fTzyy8wlaeN4SLXo10nuY=;
 b=wOjdKVxPfjwaUhBQhbu31W+tpxBMMFotn2Bebxx/4aYX/NfnLfW0WNUkXYPQXhw3cGkE4y8f4rDU5qaJHlUcLGzNJw+biLTGRyzn8BKxxu0VBdCpnyZjlXiTWuoaxP8V0zTKcApCvGBLk9gPSxG5ygoXwkRwvSlcI6bOh5ngEJ1wBZj+qyc/0pCOtioj4sJ5pYiIMITBUziMHjqvM6B0vrJYJVxWt+SqfGUcHNAEGPbHXBhILlnJhQCOHPZB5MTHYDBRizW6WX92VdbYY9stzj9ayJPypbEKzFkNACuvF298YLdsSc5emqgPjuyAChHJRQ4gzGOit+u7XX4kf2WxeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 208.255.156.42) smtp.rcpttodomain=cornelisnetworks.com
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass (p=none sp=none pct=100)
 action=none header.from=cornelisnetworks.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+szlvYiqRh9HtFmBJIeLu+fTzyy8wlaeN4SLXo10nuY=;
 b=eaDm6i9bFRzLf4gK4UbPWRREpJD6uC+xgsGAo/6MnGP4PJshFDuxFh9cagW5Ir6YvcIUEloZ29/ubMEu7BWYS3XnXXCilJP46CE24bSPCz2VKhHJav99AXp/yCY75CoJipwEyOGIcjQ97NAyW3664cSot9ojfXFRWpPQdoMEWe0JFoMKHf2AmzqILpKYKbPyRiTtshEL/iT2R+3grDI54Vam7DdLUzah578ioSZBtonc9CJTpo1AZUQdG2cC9++LxQSHSe77nHANdQ9hvVs+tl37TlfaIwSrCBZ3mOiSVQTQb8On64KVVV5cEIbhSNxJC5M5BWbv8U/dbdKT/aMFOg==
Received: from SA9PR03CA0028.namprd03.prod.outlook.com (2603:10b6:806:20::33)
 by DS6PR01MB994712.prod.exchangelabs.com (2603:10b6:8:463::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.18; Mon, 3 Aug 2026 16:01:49 +0000
Received: from SN1PEPF000397B2.namprd05.prod.outlook.com
 (2603:10b6:806:20:cafe::21) by SA9PR03CA0028.outlook.office365.com
 (2603:10b6:806:20::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.18 via Frontend Transport; Mon, 3
 Aug 2026 16:01:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 208.255.156.42)
 smtp.mailfrom=cornelisnetworks.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cornelisnetworks.com;
Received-SPF: Pass (protection.outlook.com: domain of cornelisnetworks.com
 designates 208.255.156.42 as permitted sender)
 receiver=protection.outlook.com; client-ip=208.255.156.42;
 helo=cn-mailer-00.localdomain; pr=C
Received: from cn-mailer-00.localdomain (208.255.156.42) by
 SN1PEPF000397B2.mail.protection.outlook.com (10.167.248.56) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Mon, 3 Aug 2026 16:01:49 +0000
Received: from awdrv-04.localdomain (unknown [10.228.212.218])
	by cn-mailer-00.localdomain (Postfix) with ESMTPS id C64F31D6F74;
	Mon,  3 Aug 2026 12:01:48 -0400 (EDT)
Received: from [10.228.212.218] (localhost [IPv6:::1])
	by awdrv-04.localdomain (Postfix) with ESMTP id C1B7E1810DF01;
	Mon,  3 Aug 2026 12:01:48 -0400 (EDT)
Subject: [PATCH v3 for-next 08/24] RDMA/hfi2: Add system core header files
From: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
To: jgg@ziepe.ca, leon@kernel.org
Cc: Dean Luick <dean.luick@cornelisnetworks.com>,
 Breandan Cunningham <brendan.cunningham@cornelisnetworks.com>,
 linux-rdma@vger.kernel.org
Date: Mon, 03 Aug 2026 12:01:48 -0400
Message-ID: <178577290875.1792062.6191840125656155760.stgit@awdrv-04>
In-Reply-To: <178577280181.1792062.14134152769069940570.stgit@awdrv-04>
References: <178577280181.1792062.14134152769069940570.stgit@awdrv-04>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B2:EE_|DS6PR01MB994712:EE_
X-MS-Office365-Filtering-Correlation-Id: c6d73ecd-1bd4-4382-302c-08def17886dc
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700016|23010399003|82310400026|55112099003|18002099003|22082099003|10067099003|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	PBnaDj+DRpAOAkem8/nCQhp75p0gfv0O/yVyrfw6heLioNzflZMvM0Za6zHFuerInnBtolkpdRF0reLN/Sfu/z+wdIs5/vBXQYh99DyJWVNhiKyGe81TmSjrqKTpT1g7A75GXgFJDtyrxP78gnOd0cJtu/wDr8QVCKQWHkITijiMySZ+seFAb9e9SR8IHaouTFJlzKVzxm5fQ4wuxdWEcMlZG76hu1vRmEft3zv8XUrIvDVHvz+/CmWIizYcmqfTomr7aIO3q21oHSBIE2p+B9Xr/bX6Mjcw2ATPFiD7FuKHRWVXoeGVSy8pB/Vt/zecKKT8oypfil+vvEkYwjYjPSq6ngeG/WrKfllG1Q/esKKPQc7CZ/SUS+ZCsIPLE/X2dTpRavTYlIlfrqRe9Zs+ISoQBDA9H4DHvwXYzrH+1xJxzvNFK2Y41efHamX1UqaLYXe9HrcAbxlcXqHm5p+Fa3u7VcLYZbQv5EZfkp9QOPaHtHB1Pb4+fFqvrFllcB89x6eXlPdUZitG79yVQte8P1M2RLzLUNJ7DcIGM6iPnOLVbUNzsDvktP9yh5BwilwdmkceQbnbkG8uacO+uotLjJX7mcQOohKf5mDbjXmdVvEf0QmNQSDU+rAhUXb/SE3lR5oO1fgnbU9FgiWRGjZM9Hzuxc1KWDI7zFlDxUnnYRXCDTsV/hmFv6liGsZyKoq3
X-Forefront-Antispam-Report:
	CIP:208.255.156.42;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:cn-mailer-00.localdomain;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700016)(23010399003)(82310400026)(55112099003)(18002099003)(22082099003)(10067099003)(6133799003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Eg0J8tspWCNEWAcRT5KSudZ1quQKsuaA8w0x/M7ofL62nT+axsrNGsiWqkxcpD44OVgaEASARNcKQ4DKJdqfHn6AOVKNTHDiMYGMQv7FKkc3yoJ/ZkFlehMTWbxYky0z1ZsuByUBgL0HId+XLg+t6ZOxy+SA6YvdeVGqifOTPAnqed95E6rmeMBozS5Iqy1HKa0H71k/xbqLT485QO+hdwgTOpSDz89rwpc1d0v08gWdvGKKLHsdoM40IYaM1C01r8A5/GxoVJvx5Zc3xjqOdk5EmQKjIZlkBvtpBK5/moKD+c4y9W+hVlBSCQPH5aLpERqKQLSPzMfPKuk/bS/JSh0GV0dspuO7EBYSlih8SMiQIxj2O3RkkuVgeXYWibGysYyftlaYpepcjwrrkhS2ZaUxLVKQNrVe+FkYj8uAAp66YQ4JrMRKUwOLQFTBLpQR
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 16:01:49.2439
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c6d73ecd-1bd4-4382-302c-08def17886dc
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a;Ip=[208.255.156.42];Helo=[cn-mailer-00.localdomain]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR01MB994712

Add header and support files for hooking into the core system, things
like IRQs. Includes mmu_rb.c for MMU range-based invalidation support
used by the expected receive and TID RDMA subsystems.

Co-developed-by: Dean Luick <dean.luick@cornelisnetworks.com>
Signed-off-by: Dean Luick <dean.luick@cornelisnetworks.com>
Co-developed-by: Bendan Cunningham <brendan.cunningham@cornelisnetworks.com>
Signed-off-by: Breandan Cunningham <brendan.cunningham@cornelisnetworks.com>
Assisted-by: Claude:claude-sonnet-4-5
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
---
  Changes since v1:
  - Remove MSIx affinity management code (Leon Romanovsky).
  - Remove custom ASPM handling (Leon Romanovsky).
---
 drivers/infiniband/hw/hfi2/efivar.h |   17 ++
 drivers/infiniband/hw/hfi2/eprom.h  |   11 +
 drivers/infiniband/hw/hfi2/hfi2.h   |    1 
 drivers/infiniband/hw/hfi2/mmu_rb.c |  344 +++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/hfi2/mmu_rb.h |   78 ++++++++
 drivers/infiniband/hw/hfi2/msix.h   |   32 +++
 6 files changed, 482 insertions(+), 1 deletion(-)
 create mode 100644 drivers/infiniband/hw/hfi2/efivar.h
 create mode 100644 drivers/infiniband/hw/hfi2/eprom.h
 create mode 100644 drivers/infiniband/hw/hfi2/mmu_rb.c
 create mode 100644 drivers/infiniband/hw/hfi2/mmu_rb.h
 create mode 100644 drivers/infiniband/hw/hfi2/msix.h

diff --git a/drivers/infiniband/hw/hfi2/efivar.h b/drivers/infiniband/hw/hfi2/efivar.h
new file mode 100644
index 000000000000..a756758034ec
--- /dev/null
+++ b/drivers/infiniband/hw/hfi2/efivar.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/*
+ * Copyright(c) 2015, 2016 Intel Corporation.
+ * Copyright(c) 2025-2026 Cornelis Networks, Inc.
+ */
+
+#ifndef _HFI2_EFIVAR_H
+#define _HFI2_EFIVAR_H
+
+#include <linux/efi.h>
+
+#include "hfi2.h"
+
+int hfi2_read_hfi2_efi_var(struct hfi2_devdata *dd, const char *kind,
+		      unsigned long *size, void **return_data);
+
+#endif /* _HFI2_EFIVAR_H */
diff --git a/drivers/infiniband/hw/hfi2/eprom.h b/drivers/infiniband/hw/hfi2/eprom.h
new file mode 100644
index 000000000000..b6bb0dcc03c2
--- /dev/null
+++ b/drivers/infiniband/hw/hfi2/eprom.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/*
+ * Copyright(c) 2015, 2016 Intel Corporation.
+ * Copyright(c) 2025-2026 Cornelis Networks, Inc.
+ */
+
+struct hfi2_devdata;
+
+int hfi2_eprom_init(struct hfi2_devdata *dd);
+int hfi2_eprom_read_platform_config(struct hfi2_devdata *dd, void **buf_ret,
+			       u32 *size_ret);
diff --git a/drivers/infiniband/hw/hfi2/hfi2.h b/drivers/infiniband/hw/hfi2/hfi2.h
index d3dcf4b0a5a4..a7882177b8cb 100644
--- a/drivers/infiniband/hw/hfi2/hfi2.h
+++ b/drivers/infiniband/hw/hfi2/hfi2.h
@@ -43,7 +43,6 @@ struct hfi2_devrsrcs;
 #include "mad.h"
 #include "qsfp.h"
 #include "platform.h"
-#include "affinity.h"
 #include "msix.h"
 #include "cport.h"
 #ifdef CONFIG_HFI_L8SIM
diff --git a/drivers/infiniband/hw/hfi2/mmu_rb.c b/drivers/infiniband/hw/hfi2/mmu_rb.c
new file mode 100644
index 000000000000..7ebdc5ab691c
--- /dev/null
+++ b/drivers/infiniband/hw/hfi2/mmu_rb.c
@@ -0,0 +1,344 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * Copyright(c) 2025-2026 Cornelis Networks, Inc.
+ * Copyright(c) 2016 - 2017 Intel Corporation.
+ * Copyright(c) 2025-2026 Cornelis Networks, Inc.
+ */
+
+#include <linux/list.h>
+#include <linux/rculist.h>
+#include <linux/mmu_notifier.h>
+#include <linux/interval_tree_generic.h>
+#include <linux/sched/mm.h>
+
+#include "mmu_rb.h"
+#include "trace.h"
+
+static unsigned long mmu_node_start(struct mmu_rb_node *);
+static unsigned long mmu_node_last(struct mmu_rb_node *);
+static int mmu_notifier_range_start(struct mmu_notifier *,
+		const struct mmu_notifier_range *);
+static struct mmu_rb_node *__mmu_rb_search(struct mmu_rb_handler *,
+					   unsigned long, unsigned long);
+static void release_immediate(struct kref *refcount);
+static void handle_remove(struct work_struct *work);
+
+static const struct mmu_notifier_ops mn_opts = {
+	.invalidate_range_start = mmu_notifier_range_start,
+};
+
+INTERVAL_TREE_DEFINE(struct mmu_rb_node, node, unsigned long, __last,
+		     mmu_node_start, mmu_node_last, static, __mmu_int_rb);
+
+static unsigned long mmu_node_start(struct mmu_rb_node *node)
+{
+	return node->addr & PAGE_MASK;
+}
+
+static unsigned long mmu_node_last(struct mmu_rb_node *node)
+{
+	return PAGE_ALIGN(node->addr + node->len) - 1;
+}
+
+static int _hfi2_mmu_rb_register(void *ops_arg,
+				 const struct mmu_rb_ops *ops,
+				 struct workqueue_struct *wq,
+				 struct mmu_rb_handler **handler,
+				 const struct mmu_notifier_ops *mnops)
+{
+	struct mmu_rb_handler *h;
+	void *free_ptr;
+	int ret;
+
+	free_ptr = kzalloc(sizeof(*h) + cache_line_size() - 1, GFP_KERNEL);
+	if (!free_ptr)
+		return -ENOMEM;
+
+	h = PTR_ALIGN(free_ptr, cache_line_size());
+	h->root = RB_ROOT_CACHED;
+	h->ops = ops;
+	h->ops_arg = ops_arg;
+	INIT_HLIST_NODE(&h->mn.hlist);
+	spin_lock_init(&h->lock);
+	h->mn.ops = &mn_opts;
+	INIT_WORK(&h->del_work, handle_remove);
+	INIT_LIST_HEAD(&h->del_list);
+	INIT_LIST_HEAD(&h->lru_list);
+	h->wq = wq;
+	h->free_ptr = free_ptr;
+
+	ret = mmu_notifier_register(&h->mn, current->mm);
+	if (ret) {
+		kfree(free_ptr);
+		return ret;
+	}
+
+	*handler = h;
+	return 0;
+}
+
+int hfi2_mmu_rb_register(void *ops_arg,
+			 const struct mmu_rb_ops *ops,
+			 struct workqueue_struct *wq,
+			 struct mmu_rb_handler **handler)
+{
+	return _hfi2_mmu_rb_register(ops_arg, ops, wq, handler, &mn_opts);
+}
+
+void hfi2_mmu_rb_unregister(struct mmu_rb_handler *handler)
+{
+	struct mmu_rb_node *rbnode;
+	struct rb_node *node;
+	unsigned long flags;
+	struct list_head del_list;
+
+	/* Prevent freeing of mm until we are completely finished. */
+	mmgrab(handler->mn.mm);
+
+	/* Unregister first so we don't get any more notifications. */
+	mmu_notifier_unregister(&handler->mn, handler->mn.mm);
+
+	/*
+	 * Make sure the wq delete handler is finished running.  It will not
+	 * be triggered once the mmu notifiers are unregistered above.
+	 */
+	flush_work(&handler->del_work);
+
+	INIT_LIST_HEAD(&del_list);
+
+	spin_lock_irqsave(&handler->lock, flags);
+	while ((node = rb_first_cached(&handler->root))) {
+		rbnode = rb_entry(node, struct mmu_rb_node, node);
+		rb_erase_cached(node, &handler->root);
+		/* move from LRU list to delete list */
+		list_move(&rbnode->list, &del_list);
+	}
+	spin_unlock_irqrestore(&handler->lock, flags);
+
+	while (!list_empty(&del_list)) {
+		rbnode = list_first_entry(&del_list, struct mmu_rb_node, list);
+		list_del(&rbnode->list);
+		kref_put(&rbnode->refcount, release_immediate);
+	}
+
+	/* Now the mm may be freed. */
+	mmdrop(handler->mn.mm);
+
+	kfree(handler->free_ptr);
+}
+
+int hfi2_mmu_rb_insert(struct mmu_rb_handler *handler,
+		       struct mmu_rb_node *mnode)
+{
+	struct mmu_rb_node *node;
+	unsigned long flags;
+	int ret = 0;
+
+	trace_hfi2_mmu_rb_insert(mnode);
+
+	if (current->mm != handler->mn.mm)
+		return -EPERM;
+
+	spin_lock_irqsave(&handler->lock, flags);
+	node = __mmu_rb_search(handler, mnode->addr, mnode->len);
+	if (node) {
+		ret = -EEXIST;
+		goto unlock;
+	}
+	__mmu_int_rb_insert(mnode, &handler->root);
+	list_add_tail(&mnode->list, &handler->lru_list);
+	mnode->handler = handler;
+unlock:
+	spin_unlock_irqrestore(&handler->lock, flags);
+	return ret;
+}
+
+/* Caller must hold handler lock */
+struct mmu_rb_node *hfi2_mmu_rb_get_first(struct mmu_rb_handler *handler,
+					  unsigned long addr, unsigned long len)
+{
+	struct mmu_rb_node *node;
+
+	trace_hfi2_mmu_rb_search(addr, len);
+	node = __mmu_int_rb_iter_first(&handler->root, addr, (addr + len) - 1);
+	if (node)
+		list_move_tail(&node->list, &handler->lru_list);
+	return node;
+}
+
+/* Caller must hold handler lock */
+static struct mmu_rb_node *__mmu_rb_search(struct mmu_rb_handler *handler,
+					   unsigned long addr,
+					   unsigned long len)
+{
+	struct mmu_rb_node *node = NULL;
+
+	trace_hfi2_mmu_rb_search(addr, len);
+	if (!handler->ops->filter) {
+		node = __mmu_int_rb_iter_first(&handler->root, addr,
+					       (addr + len) - 1);
+	} else {
+		for (node = __mmu_int_rb_iter_first(&handler->root, addr,
+						    (addr + len) - 1);
+		     node;
+		     node = __mmu_int_rb_iter_next(node, addr,
+						   (addr + len) - 1)) {
+			if (handler->ops->filter(node, addr, len))
+				return node;
+		}
+	}
+	return node;
+}
+
+/*
+ * Must NOT call while holding mnode->handler->lock.
+ * mnode->handler->ops->remove() may sleep and mnode->handler->lock is a
+ * spinlock.
+ */
+static void release_immediate(struct kref *refcount)
+{
+	struct mmu_rb_node *mnode =
+		container_of(refcount, struct mmu_rb_node, refcount);
+	trace_hfi2_mmu_release_node(mnode);
+	mnode->handler->ops->remove(mnode->handler->ops_arg, mnode);
+}
+
+/* Caller must hold mnode->handler->lock */
+static void release_nolock(struct kref *refcount)
+{
+	struct mmu_rb_node *mnode =
+		container_of(refcount, struct mmu_rb_node, refcount);
+	list_move(&mnode->list, &mnode->handler->del_list);
+	queue_work(mnode->handler->wq, &mnode->handler->del_work);
+}
+
+/*
+ * struct mmu_rb_node->refcount kref_put() callback.
+ * Adds mmu_rb_node to mmu_rb_node->handler->del_list and queues
+ * handler->del_work on handler->wq.
+ * Does not remove mmu_rb_node from handler->lru_list or handler->rb_root.
+ * Acquires mmu_rb_node->handler->lock; do not call while already holding
+ * handler->lock.
+ */
+void hfi2_mmu_rb_release(struct kref *refcount)
+{
+	struct mmu_rb_node *mnode =
+		container_of(refcount, struct mmu_rb_node, refcount);
+	struct mmu_rb_handler *handler = mnode->handler;
+	unsigned long flags;
+
+	spin_lock_irqsave(&handler->lock, flags);
+	list_move(&mnode->list, &mnode->handler->del_list);
+	spin_unlock_irqrestore(&handler->lock, flags);
+	queue_work(handler->wq, &handler->del_work);
+}
+
+void hfi2_mmu_rb_evict(struct mmu_rb_handler *handler, void *evict_arg)
+{
+	struct mmu_rb_node *rbnode, *ptr;
+	struct list_head del_list;
+	unsigned long flags;
+	bool stop = false;
+
+	if (current->mm != handler->mn.mm)
+		return;
+
+	INIT_LIST_HEAD(&del_list);
+
+	spin_lock_irqsave(&handler->lock, flags);
+	list_for_each_entry_safe(rbnode, ptr, &handler->lru_list, list) {
+		/* refcount == 1 implies mmu_rb_handler has only rbnode ref */
+		if (kref_read(&rbnode->refcount) > 1)
+			continue;
+
+		if (handler->ops->evict(handler->ops_arg, rbnode, evict_arg,
+					&stop)) {
+			__mmu_int_rb_remove(rbnode, &handler->root);
+			/* move from LRU list to delete list */
+			list_move(&rbnode->list, &del_list);
+			++handler->internal_evictions;
+		}
+		if (stop)
+			break;
+	}
+	spin_unlock_irqrestore(&handler->lock, flags);
+
+	list_for_each_entry_safe(rbnode, ptr, &del_list, list) {
+		trace_hfi2_mmu_rb_evict(rbnode);
+		kref_put(&rbnode->refcount, release_immediate);
+	}
+}
+
+unsigned long hfi2_mmu_rb_for_n(struct mmu_rb_handler *handler,
+				unsigned long start, int count,
+				void (*fn)(const struct mmu_rb_node *rb_node, void *),
+				void *arg)
+{
+	struct mmu_rb_node *node = NULL, *next;
+	int i;
+
+	next = __mmu_int_rb_iter_first(&handler->root, start, ~0ULL - start);
+	for (i = 0; i < count; i++) {
+		node = next;
+		if (!node)
+			return ~0UL;
+
+		next = __mmu_int_rb_iter_next(node, start + node->len, ~0ULL);
+		fn(node, arg);
+	}
+	return node->addr;
+}
+
+static int mmu_notifier_range_start(struct mmu_notifier *mn,
+		const struct mmu_notifier_range *range)
+{
+	struct mmu_rb_handler *handler =
+		container_of(mn, struct mmu_rb_handler, mn);
+	struct rb_root_cached *root = &handler->root;
+	struct mmu_rb_node *node, *ptr = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&handler->lock, flags);
+	for (node = __mmu_int_rb_iter_first(root, range->start, range->end-1);
+	     node; node = ptr) {
+		/* Guard against node removal. */
+		ptr = __mmu_int_rb_iter_next(node, range->start,
+					     range->end - 1);
+		trace_hfi2_mmu_mem_invalidate(node);
+		/* Remove from rb tree and lru_list. */
+		__mmu_int_rb_remove(node, root);
+		list_del_init(&node->list);
+		kref_put(&node->refcount, release_nolock);
+		handler->external_evictions++;
+	}
+	spin_unlock_irqrestore(&handler->lock, flags);
+
+	return 0;
+}
+
+/*
+ * Work queue function to remove all nodes that have been queued up to
+ * be removed.  The key feature is that mm->mmap_lock is not being held
+ * and the remove callback can sleep while taking it, if needed.
+ */
+static void handle_remove(struct work_struct *work)
+{
+	struct mmu_rb_handler *handler = container_of(work,
+						struct mmu_rb_handler,
+						del_work);
+	struct list_head del_list;
+	unsigned long flags;
+	struct mmu_rb_node *node;
+
+	/* remove anything that is queued to get removed */
+	spin_lock_irqsave(&handler->lock, flags);
+	list_replace_init(&handler->del_list, &del_list);
+	spin_unlock_irqrestore(&handler->lock, flags);
+
+	while (!list_empty(&del_list)) {
+		node = list_first_entry(&del_list, struct mmu_rb_node, list);
+		list_del(&node->list);
+		trace_hfi2_mmu_release_node(node);
+		handler->ops->remove(handler->ops_arg, node);
+	}
+}
diff --git a/drivers/infiniband/hw/hfi2/mmu_rb.h b/drivers/infiniband/hw/hfi2/mmu_rb.h
new file mode 100644
index 000000000000..05a277f44582
--- /dev/null
+++ b/drivers/infiniband/hw/hfi2/mmu_rb.h
@@ -0,0 +1,78 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/*
+ * Copyright(c) 2025-2026 Cornelis Networks, Inc.
+ * Copyright(c) 2016 Intel Corporation.
+ * Copyright(c) 2025-2026 Cornelis Networks, Inc.
+ */
+
+#ifndef _HFI2_MMU_RB_H
+#define _HFI2_MMU_RB_H
+
+#include "hfi2.h"
+
+struct mmu_rb_node {
+	unsigned long addr;
+	unsigned long len;
+	unsigned long __last;
+	struct rb_node node;
+	struct mmu_rb_handler *handler;
+	struct list_head list;
+	struct kref refcount;
+};
+
+/* filter and evict must not sleep. Only remove is allowed to sleep. */
+struct mmu_rb_ops {
+	bool (*filter)(struct mmu_rb_node *node, unsigned long addr,
+		       unsigned long len);
+	void (*remove)(void *ops_arg, struct mmu_rb_node *mnode);
+	int (*evict)(void *ops_arg, struct mmu_rb_node *mnode,
+		     void *evict_arg, bool *stop);
+};
+
+struct mmu_rb_handler {
+	/*
+	 * struct mmu_notifier is 56 bytes, and spinlock_t is 4 bytes, so
+	 * they fit together in one cache line.  mn is relatively rarely
+	 * accessed, so co-locating the spinlock with it achieves much of
+	 * the cacheline contention reduction of giving the spinlock its own
+	 * cacheline without the overhead of doing so.
+	 */
+	struct mmu_notifier mn;
+	spinlock_t lock;        /* protect the RB tree */
+
+	/* Begin on a new cachline boundary here */
+	struct rb_root_cached root ____cacheline_aligned_in_smp;
+	void *ops_arg;
+	const struct mmu_rb_ops *ops;
+	struct list_head lru_list;
+	struct work_struct del_work;
+	struct list_head del_list;
+	struct workqueue_struct *wq;
+	size_t hits;
+	size_t misses;
+	size_t hint_hits;
+	size_t hint_misses;
+	size_t internal_evictions;
+	size_t external_evictions;
+	void *free_ptr;
+};
+
+int hfi2_mmu_rb_register(void *ops_arg,
+			 const struct mmu_rb_ops *ops,
+			 struct workqueue_struct *wq,
+			 struct mmu_rb_handler **handler);
+void hfi2_mmu_rb_unregister(struct mmu_rb_handler *handler);
+int hfi2_mmu_rb_insert(struct mmu_rb_handler *handler,
+		       struct mmu_rb_node *mnode);
+void hfi2_mmu_rb_release(struct kref *refcount);
+
+void hfi2_mmu_rb_evict(struct mmu_rb_handler *handler, void *evict_arg);
+struct mmu_rb_node *hfi2_mmu_rb_get_first(struct mmu_rb_handler *handler,
+					  unsigned long addr,
+					  unsigned long len);
+unsigned long hfi2_mmu_rb_for_n(struct mmu_rb_handler *handler,
+				unsigned long start, int count,
+				void (*fn)(const struct mmu_rb_node *rb_node, void *),
+				void *arg);
+
+#endif /* _HFI2_MMU_RB_H */
diff --git a/drivers/infiniband/hw/hfi2/msix.h b/drivers/infiniband/hw/hfi2/msix.h
new file mode 100644
index 000000000000..8d17b1613dc5
--- /dev/null
+++ b/drivers/infiniband/hw/hfi2/msix.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
+/*
+ * Copyright(c) 2018 - 2020 Intel Corporation.
+ * Copyright(c) 2025-2026 Cornelis Networks, Inc.
+ */
+
+#ifndef _HFI2_MSIX_H
+#define _HFI2_MSIX_H
+
+#include "hfi2.h"
+
+enum irq_type { IRQ_SDMA, IRQ_RCVCTXT, IRQ_NETDEVCTXT, IRQ_GENERAL, IRQ_OTHER };
+
+/* MSIx interface */
+int hfi2_msix_initialize(struct hfi2_devdata *dd);
+int hfi2_msix_early_request_irqs(struct hfi2_devdata *dd);
+int hfi2_msix_request_irqs(struct hfi2_devdata *dd);
+void hfi2_msix_clean_up_interrupts(struct hfi2_devdata *dd);
+void hfi2_msix_shut_down_interrupts(struct hfi2_devdata *dd, bool keep_general);
+int hfi2_msix_request_general_irq(struct hfi2_devdata *dd);
+int hfi2_msix_request_rcd_irq(struct hfi2_ctxtdata *rcd);
+int hfi2_msix_request_sdma_irq(struct sdma_engine *sde);
+void hfi2_msix_free_irq(struct hfi2_devdata *dd, u8 msix_intr);
+int hfi2_msix_request_irq_remap(struct hfi2_devdata *dd, u16 ctxt,
+			   enum irq_type type, int src, irq_handler_t handler,
+			   irq_handler_t thread, void *arg, const char *name);
+
+/* Netdev interface */
+void hfi2_msix_netdev_synchronize_irq(struct hfi2_pportdata *ppd);
+int hfi2_msix_netdev_request_rcd_irq(struct hfi2_ctxtdata *rcd);
+
+#endif


