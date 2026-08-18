Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8771446EC9B;
	Tue, 18 Aug 2026 12:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787056795; cv=none; b=oxETGe5fu8kAgvAZnveSaRVrxOnTKIUborQXvUwPctexbrAR1C33QniHdJy3nP05vGhVDO3TuQ3OMNzew8EAsKchveK76cC8t+KqJRRJnh7li3CYd2hTXhubJCObjytHB5kP4Fl2eyrVFl/GnAznyr4Zl1LVx4MPqM9IBiTW85w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787056795; c=relaxed/simple;
	bh=pZC195ubo9vC9qIqjVGMk3pL3WHwKK+nlWXXlxb8KW4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FjstNLCzzAIc1l8zeBH0EgDwLmd1LznU0WaIEdeYUaVoi9WjnMU9AlPrKAOcDp3LZaUdeqmAwxnGfSwPJNwx2iGF8czCSf+ffddbMTPKhAwDOZ4eR7ueBNXugvdPfcupj/CXHUCok/kDUq2QtPP/hHcD+CL3rEjN/CGHdxZVlFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=cJGXOOz7; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="cJGXOOz7"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=61EB7xd78VmsW3Vtne3/GVzkEJHCsedf1b4wP+cKgAc=;
	b=cJGXOOz7g4QJkUJsl3S6q/OHVIO2OpSQ12Gwnvx/LDfB7j2e9EmtE+wl+FvTTaNmlXxPZBSoM
	KNe7EYBgpJaWfulSYLlXHEJmvcN4dYRcyiGIBUJ8QEQpm3tmfYJh6RI69VsVdB7Pf0ztoogoZH+
	DH6PmEGQgvfg2NxnkDJIw3E=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hPTX46pPgz1prKd;
	Tue, 18 Aug 2026 20:28:52 +0800 (CST)
Received: from kwepemo200010.china.huawei.com (unknown [7.202.195.178])
	by mail.maildlp.com (Postfix) with ESMTPS id BC10A4058C;
	Tue, 18 Aug 2026 20:39:35 +0800 (CST)
Received: from huawei.com (10.44.142.85) by kwepemo200010.china.huawei.com
 (7.202.195.178) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 18 Aug
 2026 20:39:34 +0800
From: Qi Xi <xiqi2@huawei.com>
To: <akpm@linux-foundation.org>, <vbabka@kernel.org>
CC: <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<jan.kiszka@siemens.com>, <kbingham@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>,
	<ziy@nvidia.com>, <linux-hyperv@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <sunnanyong@huawei.com>,
	<wangkefeng.wang@huawei.com>, <xiqi2@huawei.com>
Subject: [PATCH] mm: drop stale MAX_ORDER references
Date: Tue, 18 Aug 2026 20:24:08 +0800
Message-ID: <20260818122408.4182417-1-xiqi2@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemo200010.china.huawei.com (7.202.195.178)

The treewide rename in commit 5e0a760b4441 ("mm, treewide: rename
MAX_ORDER to MAX_PAGE_ORDER") left a few spots still using the old
name:

  - two comments in include/net/mana/mana.h and mm/page_alloc.c;
  - the gdb helper scripts/gdb/linux/mm.py, where self.MAX_ORDER is
    a local mirror of the kernel's MAX_ORDER define.

Rename the leftover instances to MAX_PAGE_ORDER so the tree is
consistent.

No functional changes.

Signed-off-by: Qi Xi <xiqi2@huawei.com>
---
 include/net/mana/mana.h | 4 ++--
 mm/page_alloc.c         | 2 +-
 scripts/gdb/linux/mm.py | 8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 04acb6791dbd..1d5bed71d6a7 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -40,8 +40,8 @@ enum TRI_STATE {
 #define COMP_ENTRY_SIZE 64
 
 /* This Max value for RX buffers is derived from __alloc_page()'s max page
- * allocation calculation. It allows maximum 2^(MAX_ORDER -1) pages. RX buffer
- * size beyond this value gets rejected by __alloc_page() call.
+ * allocation calculation. It allows maximum 2^(MAX_PAGE_ORDER -1) pages. RX
+ * buffer size beyond this value gets rejected by __alloc_page() call.
  */
 #define MAX_RX_BUFFERS_PER_QUEUE 8192
 #define DEF_RX_BUFFERS_PER_QUEUE 1024
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ee902a468c2f..42b5b41432c5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7803,7 +7803,7 @@ static bool cond_accept_memory(struct zone *zone, unsigned int order,
 	/*
 	 * Watermarks have not been initialized yet.
 	 *
-	 * Accepting one MAX_ORDER page to ensure progress.
+	 * Accepting one MAX_PAGE_ORDER page to ensure progress.
 	 */
 	if (!wmark)
 		return try_to_accept_memory_one(zone);
diff --git a/scripts/gdb/linux/mm.py b/scripts/gdb/linux/mm.py
index dffadccbb01d..28d33624c38b 100644
--- a/scripts/gdb/linux/mm.py
+++ b/scripts/gdb/linux/mm.py
@@ -56,7 +56,7 @@ class x86_page_ops():
 
         self.MAX_PHYSMEM_BITS = 46
         self.SECTION_SIZE_BITS = 27
-        self.MAX_ORDER = 10
+        self.MAX_PAGE_ORDER = 10
 
         self.SECTIONS_SHIFT = self.MAX_PHYSMEM_BITS - self.SECTION_SIZE_BITS
         self.NR_MEM_SECTIONS = 1 << self.SECTIONS_SHIFT
@@ -233,11 +233,11 @@ class aarch64_page_ops():
         self.SECTIONS_SHIFT = self.MAX_PHYSMEM_BITS - self.SECTION_SIZE_BITS
 
         if str(constants.LX_CONFIG_ARCH_FORCE_MAX_ORDER).isdigit():
-            self.MAX_ORDER = constants.LX_CONFIG_ARCH_FORCE_MAX_ORDER
+            self.MAX_PAGE_ORDER = constants.LX_CONFIG_ARCH_FORCE_MAX_ORDER
         else:
-            self.MAX_ORDER = 10
+            self.MAX_PAGE_ORDER = 10
 
-        self.MAX_ORDER_NR_PAGES = 1 << (self.MAX_ORDER)
+        self.MAX_ORDER_NR_PAGES = 1 << (self.MAX_PAGE_ORDER)
         self.PFN_SECTION_SHIFT = self.SECTION_SIZE_BITS - self.PAGE_SHIFT
         self.NR_MEM_SECTIONS = 1 << self.SECTIONS_SHIFT
         self.PAGES_PER_SECTION = 1 << self.PFN_SECTION_SHIFT
-- 
2.33.0

