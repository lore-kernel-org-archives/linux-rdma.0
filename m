Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AC825F98A
	for <linux-rdma@vger.kernel.org>; Sun,  7 Jun 2026 16:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.77.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780849098; cv=none; b=iJ3Ih4Vf9NUBoj2Ej+X8TA7MyzXxq/Kd6m26jy8l1gRknPZfHSbpJ0wCvs40Jyd6cvMgOge403mXEB0tmj+TS32LMbobMaPluCSHObesU41r0W5dJO9l0bYda7o9oqsOiiTwOIYzZrckCar6Kq4ZgjVLAYL2C466jdZqbyUC96w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780849098; c=relaxed/simple;
	bh=1dQQ1X2SkcJWWgM0LZthN08LoZhhkint4SN0DIpjQeI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XYaWchsLAxiTMIKzKkOA1BtWY5sy4kqo6MD4mGAA1GFyeiJe3ChnLtReOFhjI5/Z84ZTXVIvkpLtxgt/KuTM+K11eCgUou8qXyD8Q2UVDMr9SwfT/oYu7iKLo5qfB7dwJsSvFuHtuxKB+Sk72KnObRaoIMqY3hlWqO1UGUDuXSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=VPg5PuUP; arc=none smtp.client-ip=44.246.77.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="VPg5PuUP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1780849097; x=1812385097;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DOG/XAKd4BFFwOxO0rwLJU4Nu/7LcCMkaPkY6YMEmco=;
  b=VPg5PuUPZLAiEEjLELaFHcX34ifJqNkes2LHFSryFN3ofZe5Sc8A4eDC
   PyrwVfvvcaKhNTjY57Mp+2blNCqRYmOitvlUsxon2H5SluZxtAxgZzV5v
   Wb3tMjWJvsvzV1cSsjdKTnaUToLBi22of8AOOVZbNsBIJLHchi8tD85VV
   y0Kz/2dx4eNyzcK6hcuiZdsmDdSYzVTFF3TtT+UpQi4aZ+tkcf0rOGIho
   IeaOwVfOgF4CaqI3Pno9rRJ38wA+V8hm6jYnqocrIt9YyDcxW6x8/jdVR
   hpx/Sr/vhRPeKG72JVYPQu885P9XCo+0TVqUcz5VxkgRfgxOJ21dm96uM
   g==;
X-CSE-ConnectionGUID: dNe4sjuZRuugMYeTh32KIg==
X-CSE-MsgGUID: +UWrE//GSBuKJz9Ei2MjVA==
X-IronPort-AV: E=Sophos;i="6.24,192,1774310400"; 
   d="scan'208";a="21276352"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2026 16:18:15 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:22699]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.47.233:2525] with esmtp (Farcaster)
 id cd5ba897-ea47-425a-bfae-40944650cd26; Sun, 7 Jun 2026 16:18:14 +0000 (UTC)
X-Farcaster-Flow-ID: cd5ba897-ea47-425a-bfae-40944650cd26
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Sun, 7 Jun 2026 16:18:14 +0000
Received: from dev-dsk-ynachum-1b-0ecf7b87.eu-west-1.amazon.com
 (10.13.226.176) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Sun, 7 Jun 2026
 16:18:12 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <mrgolin@amazon.com>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, Yonatan Nachum <ynachum@amazon.com>, Firas Jahjah
	<firasj@amazon.com>
Subject: [PATCH for-next v3 1/2] RDMA/efa: Add initialization of AH cache rhashtable
Date: Sun, 7 Jun 2026 16:17:52 +0000
Message-ID: <20260607161753.1607559-2-ynachum@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260607161753.1607559-1-ynachum@amazon.com>
References: <20260607161753.1607559-1-ynachum@amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D046UWA002.ant.amazon.com (10.13.139.39) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

New EFA devices don't support the creation of multiple address handles
to the same remote on the same PD.
To overcome this limitation, introduce an AH cache rhashtable which will
store the refcounts of the same AH creation on the same PD and will
allow the driver to manage AH reuse. The hashtable key is the
combination of PD and GID. Add initialization and teardown logic for the
rhashtable.

Reviewed-by: Firas Jahjah <firasj@amazon.com>
Reviewed-by: Michael Margolin <mrgolin@amazon.com>
Signed-off-by: Yonatan Nachum <ynachum@amazon.com>
---
 drivers/infiniband/hw/efa/Makefile       |  4 +--
 drivers/infiniband/hw/efa/efa_ah_cache.c | 41 ++++++++++++++++++++++++
 drivers/infiniband/hw/efa/efa_ah_cache.h | 37 +++++++++++++++++++++
 drivers/infiniband/hw/efa/efa_com.c      | 12 ++++++-
 drivers/infiniband/hw/efa/efa_com.h      |  3 ++
 5 files changed, 94 insertions(+), 3 deletions(-)
 create mode 100644 drivers/infiniband/hw/efa/efa_ah_cache.c
 create mode 100644 drivers/infiniband/hw/efa/efa_ah_cache.h

diff --git a/drivers/infiniband/hw/efa/Makefile b/drivers/infiniband/hw/efa/Makefile
index 6e83083af0bc..a6a433b0ba2f 100644
--- a/drivers/infiniband/hw/efa/Makefile
+++ b/drivers/infiniband/hw/efa/Makefile
@@ -1,9 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
-# Copyright 2018-2019 Amazon.com, Inc. or its affiliates. All rights reserved.
+# Copyright 2018-2026 Amazon.com, Inc. or its affiliates. All rights reserved.
 #
 # Makefile for Amazon Elastic Fabric Adapter (EFA) device driver.
 #
 
 obj-$(CONFIG_INFINIBAND_EFA) += efa.o
 
-efa-y := efa_com_cmd.o efa_com.o efa_main.o efa_verbs.o
+efa-y := efa_com_cmd.o efa_ah_cache.o efa_com.o efa_main.o efa_verbs.o
diff --git a/drivers/infiniband/hw/efa/efa_ah_cache.c b/drivers/infiniband/hw/efa/efa_ah_cache.c
new file mode 100644
index 000000000000..ab763b06b9bb
--- /dev/null
+++ b/drivers/infiniband/hw/efa/efa_ah_cache.c
@@ -0,0 +1,41 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * Copyright 2026 Amazon.com, Inc. or its affiliates. All rights reserved.
+ */
+
+#include <linux/slab.h>
+
+#include "efa_ah_cache.h"
+
+static const struct rhashtable_params ah_cache_params = {
+	.key_len = sizeof(struct efa_ah_cache_key),
+	.key_offset = offsetof(struct efa_ah_cache_entry, key),
+	.head_offset = offsetof(struct efa_ah_cache_entry, linkage),
+};
+
+int efa_ah_cache_init(struct efa_ah_cache *ah_cache)
+{
+	int err;
+
+	mutex_init(&ah_cache->lock);
+	err = rhashtable_init(&ah_cache->hashtable, &ah_cache_params);
+	if (err)
+		mutex_destroy(&ah_cache->lock);
+
+	return err;
+}
+
+static void efa_ah_cache_entry_free(void *ptr, void *arg)
+{
+	struct efa_ah_cache_entry *entry = ptr;
+
+	mutex_destroy(&entry->lock);
+	kfree(entry);
+}
+
+void efa_ah_cache_destroy(struct efa_ah_cache *ah_cache)
+{
+	rcu_barrier();
+	rhashtable_free_and_destroy(&ah_cache->hashtable, efa_ah_cache_entry_free, NULL);
+	mutex_destroy(&ah_cache->lock);
+}
diff --git a/drivers/infiniband/hw/efa/efa_ah_cache.h b/drivers/infiniband/hw/efa/efa_ah_cache.h
new file mode 100644
index 000000000000..133181b4466d
--- /dev/null
+++ b/drivers/infiniband/hw/efa/efa_ah_cache.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
+/*
+ * Copyright 2026 Amazon.com, Inc. or its affiliates. All rights reserved.
+ */
+
+#ifndef _EFA_AH_CACHE_H_
+#define _EFA_AH_CACHE_H_
+
+#include <linux/refcount.h>
+#include <linux/rhashtable.h>
+
+#define EFA_AH_GID_SIZE 16
+
+struct efa_ah_cache_key {
+	u8 gid[EFA_AH_GID_SIZE];
+	u16 pd;
+};
+
+struct efa_ah_cache_entry {
+	struct efa_ah_cache_key key;
+	u16 ah;
+	bool initialized;
+	refcount_t refcount;
+	struct rhash_head linkage;
+	struct rcu_head rcu_head;
+	struct mutex lock; /* Serializes device commands per cache entry */
+};
+
+struct efa_ah_cache {
+	struct rhashtable hashtable;
+	struct mutex lock; /* Protects AH cache hashtable */
+};
+
+int efa_ah_cache_init(struct efa_ah_cache *ah_cache);
+void efa_ah_cache_destroy(struct efa_ah_cache *ah_cache);
+
+#endif /* _EFA_AH_CACHE_H_ */
diff --git a/drivers/infiniband/hw/efa/efa_com.c b/drivers/infiniband/hw/efa/efa_com.c
index 7cc3f4af0bb9..7097d1c2f23d 100644
--- a/drivers/infiniband/hw/efa/efa_com.c
+++ b/drivers/infiniband/hw/efa/efa_com.c
@@ -724,6 +724,8 @@ void efa_com_admin_destroy(struct efa_com_dev *edev)
 
 	size = aenq->depth * sizeof(*aenq->entries);
 	dma_free_coherent(edev->dmadev, size, aenq->entries, aenq->dma_addr);
+
+	efa_ah_cache_destroy(&edev->ah_cache);
 }
 
 /**
@@ -782,6 +784,12 @@ int efa_com_admin_init(struct efa_com_dev *edev,
 		return -ENODEV;
 	}
 
+	err = efa_ah_cache_init(&edev->ah_cache);
+	if (err) {
+		ibdev_err(edev->efa_dev, "Failed to init AH cache\n");
+		return err;
+	}
+
 	aq->depth = EFA_ADMIN_QUEUE_DEPTH;
 
 	aq->dmadev = edev->dmadev;
@@ -794,7 +802,7 @@ int efa_com_admin_init(struct efa_com_dev *edev,
 
 	err = efa_com_init_comp_ctxt(aq);
 	if (err)
-		return err;
+		goto err_destroy_ah_cache;
 
 	err = efa_com_admin_init_sq(edev);
 	if (err)
@@ -832,6 +840,8 @@ int efa_com_admin_init(struct efa_com_dev *edev,
 			  aq->sq.entries, aq->sq.dma_addr);
 err_destroy_comp_ctxt:
 	devm_kfree(edev->dmadev, aq->comp_ctx);
+err_destroy_ah_cache:
+	efa_ah_cache_destroy(&edev->ah_cache);
 
 	return err;
 }
diff --git a/drivers/infiniband/hw/efa/efa_com.h b/drivers/infiniband/hw/efa/efa_com.h
index f8c692b0e092..599db9d583bf 100644
--- a/drivers/infiniband/hw/efa/efa_com.h
+++ b/drivers/infiniband/hw/efa/efa_com.h
@@ -14,6 +14,7 @@
 
 #include <rdma/ib_verbs.h>
 
+#include "efa_ah_cache.h"
 #include "efa_common_defs.h"
 #include "efa_admin_defs.h"
 #include "efa_admin_cmds_defs.h"
@@ -113,6 +114,8 @@ struct efa_com_dev {
 	u32 supported_features;
 	u32 dma_addr_bits;
 
+	struct efa_ah_cache ah_cache;
+
 	u32 dev_api_ver;
 	struct efa_com_mmio_read mmio_read;
 };
-- 
2.50.1

