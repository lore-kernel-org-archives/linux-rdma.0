Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11023111.outbound.protection.outlook.com [40.93.196.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DD2453A4B
	for <linux-rdma@vger.kernel.org>; Thu,  3 Sep 2026 17:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.111
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788458119; cv=fail; b=DFaEWRNfzPP/QH7MvD69VciGT/37YfhtgCBI0Gel298/Dp9bwP4MhVmfppnpFLys2FTLag/M+bG70ungkASywpWt5Lh+PCJXnzG2NYiyHnJ3GeuXp5BamvY7FaZNmfFDIHa95GCamL7JHvq9pu0T637zdklP2Q81a0zCzqe1CWw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788458119; c=relaxed/simple;
	bh=UdjIDsLpXl9Vv419al4pdPCmZXyBhvOqf0zow5TDFMs=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DhncMZED7/hf9DIr5f3eaUbDhvPFnm6g8CufEmgMJy9k7Xa0PjpHi7DAZuwFZ7N7LVrfoP1xknlcG5G3e+B1XlWXBCo42mbuL8Z+Y5sVMUGtUN7+bQ+w2bLMq+OIbF5WiRvQDgBv0jzTAcJXID7qVt8G0YxwYod6Y/QzVk/I8XA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com; spf=pass smtp.mailfrom=cornelisnetworks.com; dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b=D+ANI7S6; arc=fail smtp.client-ip=40.93.196.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b="D+ANI7S6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GHnzZiREf5W7hcDAs14YfuAWNQOyW3a8Ouhr9VuYy1obETyQEIcx4Y2KQZrT2UWpFfVJJbibfD3uUX0l5pElnAkCowynpq+aUNwkSZVfj4zyaCN/PN+i06XJgvvbecMUC7KI1DJVXdgx5QOv/fhkecxKdCwsNw8rPenSMQRP1sUEsVQKBH+mIxmyha/1YIJP4nykvKZ2VZguoP+WVrTpr5x97gRtj7ysW2eaEZDmYcxf2XP55eKXFkDDRDAnE9bHuAJE9Ki6qoeLOMxTe0V61PFqpeSNaeoXYkQ6WaoaebSN2idEu+9O3QyiVY12v3pXdr5jcc+ExqBfDf3/rf5tcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mwKuCcfJzXx4PycXfLbHaAMVTjlYoAQ7yPQ99lPl5WY=;
 b=zVNC9EJPSZvx7AxPAF5vn061l9D/XV+ooUkIjxzSjKvpNITKHqowQktPBl0UKi2nTNL5mXU6rtFqbOZQe3CyqgvEjRQPzriPxxc6wArGPtbj7zyIef1+h8d5Umci84n+UXjMxJy46ku/kQCxlL/2yqF5MPbFf0s3ErJyJa38rd10uaj4wiVY6yqrVDgjuIcDd2Vu8XuGTnN6F5bVPoVgP5PGjfO1xTU1Tcli0jfk4KVn+0PYWqoeo8Qsrqz0BlVzz1yGNoQE6TloiE1Oy4ka5Axcs+hsa3GGtBNJhG6b2dWJs1dKEPMsy61AlhDMxgZoTyl2YZyLcGLNHuCPx1ZTUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 50.148.235.34) smtp.rcpttodomain=cornelisnetworks.com
 smtp.mailfrom=cornelisnetworks.com; dmarc=fail (p=none sp=none pct=100)
 action=none header.from=cornelisnetworks.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mwKuCcfJzXx4PycXfLbHaAMVTjlYoAQ7yPQ99lPl5WY=;
 b=D+ANI7S6CcAZpony0WxR943X5MYhE/+GlGJzEVgwzSNHcvn5ggHBDpGWgmRb+gl1LXCSDJG0VINshsD43fRfylX/28cNGzgXz67Ka8hC8P1plvgzTX/4DG9l+Gv+8al4j/ZqArHhDn+vQTwLgrN6G2vfE+mHNFUgNkNOk7/GdtHRIsVIjxhxzxDn3HHTffoVAON7AAQK9owQfk7Y3OW+F5AaA1S/UzupGqeC6/y3V2Strl10C+9AMGQSwl3gyPrvZIJyDMU8/D0wqs7XpKP43dM/H/ne6gYIWFHu4UpuHkIoZIHPck6FevFAx9Gz3DdHw2ToSnUd5Ij05lAcYO+IbA==
Received: from SJ0PR13CA0037.namprd13.prod.outlook.com (2603:10b6:a03:2c2::12)
 by LV3PR01MB8649.prod.exchangelabs.com (2603:10b6:408:1b7::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.13; Thu, 3 Sep 2026 17:55:09 +0000
Received: from MWH0EPF000C6190.namprd02.prod.outlook.com
 (2603:10b6:a03:2c2:cafe::19) by SJ0PR13CA0037.outlook.office365.com
 (2603:10b6:a03:2c2::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.4 via Frontend Transport; Thu, 3
 Sep 2026 17:55:09 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 50.148.235.34)
 smtp.mailfrom=cornelisnetworks.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=cornelisnetworks.com;
Received-SPF: Fail (protection.outlook.com: domain of cornelisnetworks.com
 does not designate 50.148.235.34 as permitted sender)
 receiver=protection.outlook.com; client-ip=50.148.235.34;
 helo=cn-mailer-00.localdomain;
Received: from cn-mailer-00.localdomain (50.148.235.34) by
 MWH0EPF000C6190.mail.protection.outlook.com (10.167.249.101) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Thu, 3 Sep 2026 17:55:08 +0000
Received: from awdrv-04.localdomain (unknown [10.228.212.218])
	by cn-mailer-00.localdomain (Postfix) with ESMTPS id DA3081FA26E;
	Thu,  3 Sep 2026 13:55:07 -0400 (EDT)
Received: from [10.228.212.218] (localhost [IPv6:::1])
	by awdrv-04.localdomain (Postfix) with ESMTP id D57BA18129B28;
	Thu,  3 Sep 2026 13:55:07 -0400 (EDT)
Subject: [PATCH v5 for-next 08/24] RDMA/hfi2: Add system core header files
From: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
To: jgg@ziepe.ca, leon@kernel.org
Cc: Dean Luick <dean.luick@cornelisnetworks.com>,
 Breandan Cunningham <brendan.cunningham@cornelisnetworks.com>,
 linux-rdma@vger.kernel.org
Date: Thu, 03 Sep 2026 13:55:07 -0400
Message-ID: <178845810783.2825126.6750483446263350611.stgit@awdrv-04>
In-Reply-To: <178845806706.2825126.2210865708266527909.stgit@awdrv-04>
References: <178845806706.2825126.2210865708266527909.stgit@awdrv-04>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6190:EE_|LV3PR01MB8649:EE_
X-MS-Office365-Filtering-Correlation-Id: e5ff0d46-c275-448f-b144-08df09e47e78
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|82310400026|36860700016|56012099006|10067099003|6133799003|55112099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	eYxc8E2GTWU/rfc6zJB0RBT9cXzoPWvwRWMB4bQEdeERA35STfjMQyQFnakEi77n+i+u+kqsn2BY9Ij6gdPoYNBEb6Q8PSYNb0xaXJ4lzHw9pfeiED4xzgd5i4e33aQEmwFW+CTfgaJ1GXtSSA8e+SAnYnT14tv9ZzxpaVmV3aexpFjS+CgdhktIF6dPxlP+1xG5tGsRhI36xVfOSR/brXqUules73o3uyZHJ0bQkrraxZE5FpsNa9UPFk5Xvv+IOdu99vSYFyzHqhx5FsFo5cFPFdjqeFvl3YW/4qlghyGeKtuC8tYcN2xqYqnn2mZzjS9NorG2liCmQQ6wWSDSbESnh0cjgg/OBHvTSPNwAHy3jrKlF+c6iE2FPhtQvsed2hjueifdUt+pc2pAnsZdJXQm/7AEw3boC9rcZoOfNhL9sCBw0GgWBS8n6Azbk1h5mh7OcbGZN9mvXBuULjfCyKAeIaW5EUmaXkeRfwZwH5Eyeihl9yHsHGxUjbBuoGVTR4lFENA9HtYWEidTRESHUH6ZgQ1piwF3bBcSHayCKuh6vJlyq2LsBUC7krkkx487hD8IeK5my3Odl2i7Gt2dQi7kRDzS4n31mhY9c6ZLOg5YUcpDTQc5tkT/HkicuF4qDDt69vMcIuKW4TsU07B1C2PNkCzEu6/Pi9asjQwSdRb0Qj9Htt1Q8KEXJbhu8i3J
X-Forefront-Antispam-Report:
	CIP:50.148.235.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:cn-mailer-00.localdomain;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(82310400026)(36860700016)(56012099006)(10067099003)(6133799003)(55112099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LHx9PX1sbHX9vzQdKKhBXCWI0NukLZZrQY2JwRDhiTcAxvs3qc8g6CF3fZgW4/+zyQQjXjJxjGhLb5V3YRYbyhIbS4by6JIgztOogLrmQWODvKZksunXuVuICEWiOaC0kqFGdcwG3ity1E/uvlOqdC3v4QHLp4jPktjUT0UTkQG94yEaapMY2gTZXp98c75TBdZsUuTEUReFfbawJ2K42OZtdqUL9nEpwh7OKMXnssgAsnuxgOsScAXS25ATtmwtoIbJeWmjRsST7UOxlBMG5w5Dvt2RJ0LT3o5NKxjX6/+QgbASPxYNicdfKZyA9TmznBHcWWxORZy+JrGwze4hI3mC3M3zNha4pdEmizU4yEqhqrkcp7y+heW8qsdXbRqTsGSF9O6MpUetneGTb58AB1uYAB0VQHo+5UbQspcQu4KKrKyZRoo8pO+jPR2OuzFB
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 17:55:08.6337
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e5ff0d46-c275-448f-b144-08df09e47e78
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a;Ip=[50.148.235.34];Helo=[cn-mailer-00.localdomain]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6190.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR01MB8649

Add header and support files for hooking into the core system, things
like IRQs. Includes mmu_rb.c for MMU range-based invalidation support
used by the expected receive and TID RDMA subsystems.

Co-developed-by: Dean Luick <dean.luick@cornelisnetworks.com>
Signed-off-by: Dean Luick <dean.luick@cornelisnetworks.com>
Co-developed-by: Bendan Cunningham <brendan.cunningham@cornelisnetworks.com>
Signed-off-by: Breandan Cunningham <brendan.cunningham@cornelisnetworks.com>
Assisted-by: LLM
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
index 2dbe22177f1d..ae8b4e81681f 100644
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


