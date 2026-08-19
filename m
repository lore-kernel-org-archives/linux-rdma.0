Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DAA364EAB;
	Wed, 19 Aug 2026 08:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787128593; cv=none; b=EP+Y3UM8I0SEZ+R8JK2+jOL+SDLnv3KSlNV+LYev/1Cdc7y+XUCfsB/9h2e6zrHgN8yEvhemPP/lS9qsIwqQJSJ+4dtAnOv0JgynlohQKgc0rKRhlqnfcFzh7D3gu0ODSWwAzhttNBkNgLkn1/IX9cFHJpR+/gZd+dcnRcJb0rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787128593; c=relaxed/simple;
	bh=wec8R1rmA8Y7l60PLHflfGdO2AGKs3YEDhpo9bWwoHQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GIRPeJ2CVxv1vABQAwiNG/crfXB0k87yiKhXQ+tmPAO515x3FRND19v0WGuArjraDAOES7tzL2lG1kKvNv3ALrA+F+EoLFPRT3Ga4wVXclXQp0++mXZhKwiGt6wJznxEKYDMuBMhi02w43Y1CIuAaBsGUQfAPx4T4MfeWw1dJNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=uscxz3lh; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="uscxz3lh"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=DXyU34t4JY/bH2qRKqQJeUpV6LNj1+g92OC+ZRS8aps=;
	b=uscxz3lhCsitq5NLNYt/HklzZh3fnAAYHe+/hjSFJ4wMTmUoOiY4VaTb6dyYdVdohcsFKn4kA
	iKk4xWQah4ECSWRugdRyfVwkO5porUSmNFQxxE5mrC4/UWFSs1o0xypLhtTI4cL0+PLqIxryHqK
	R38XeqXk8HZvmHW8XhI/sH0=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hQ04z1ksgzmVXs;
	Wed, 19 Aug 2026 16:25:39 +0800 (CST)
Received: from kwepemo200010.china.huawei.com (unknown [7.202.195.178])
	by mail.maildlp.com (Postfix) with ESMTPS id 9CD7B40586;
	Wed, 19 Aug 2026 16:36:20 +0800 (CST)
Received: from huawei.com (10.44.142.85) by kwepemo200010.china.huawei.com
 (7.202.195.178) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 19 Aug
 2026 16:36:19 +0800
From: Qi Xi <xiqi2@huawei.com>
To: <akpm@linux-foundation.org>, <vbabka@kernel.org>
CC: <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<jan.kiszka@siemens.com>, <kbingham@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>,
	<ziy@nvidia.com>, <linux-hyperv@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <sunnanyong@huawei.com>,
	<wangkefeng.wang@huawei.com>, <xiqi2@huawei.com>
Subject: [PATCH v2] mm: drop stale MAX_ORDER references
Date: Wed, 19 Aug 2026 16:20:52 +0800
Message-ID: <20260819082052.3338603-1-xiqi2@huawei.com>
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

Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Qi Xi <xiqi2@huawei.com>
---
Changes in v2:
  - Correct the mana.h comment formula to 2^MAX_PAGE_ORDER.

 include/net/mana/mana.h | 4 ++--
 mm/page_alloc.c         | 2 +-
 scripts/gdb/linux/mm.py | 8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 04acb6791dbd..bc331bf9b205 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -40,8 +40,8 @@ enum TRI_STATE {
 #define COMP_ENTRY_SIZE 64
 
 /* This Max value for RX buffers is derived from __alloc_page()'s max page
- * allocation calculation. It allows maximum 2^(MAX_ORDER -1) pages. RX buffer
- * size beyond this value gets rejected by __alloc_page() call.
+ * allocation calculation. It allows maximum 2^MAX_PAGE_ORDER pages. RX
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

