Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DE035AC16
	for <linux-rdma@vger.kernel.org>; Fri, 21 Aug 2026 18:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787336140; cv=none; b=V0k7sEO1skMxu0QCICPTwFIAKdKn3gs+Q/RMU+lUFcR7HrrskAOnbgU0VbI8ASng0lwuckbKelDVh/nV9p3LsvlGxxdWCxnV6b4HMrqQHJrPi5GAz1jTj+AYXioPP00NkocZBbive/Jc+L1YuAED4Qk5dwhQIH6oqN6Y85h8bgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787336140; c=relaxed/simple;
	bh=+QtaQlqdrXF+kJGQQeRm8B2Z7cAP2PBEeiptRiE/PCI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ej7STWmBwjJ1L2pITRLKQwiRlRKRp6PKo/RitlAVfgE5nFrCYU8c2sHI7YuZ9DkeOA97pGyQaQask57r5CCETvzNTHpkpadW0jb6Z3/P0vtQH1rBJJJW5dcx3Mk1nbU/oHFwVsA3UqOHdR7hf2eG5KdYy8/OaL6scvjFMYXfWzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=gULsf39u; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="gULsf39u"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ce98cb8165so13331315ad.1
        for <linux-rdma@vger.kernel.org>; Fri, 21 Aug 2026 11:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1787336135; x=1787940935; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+qHlaVMR+JfksZ0WCBWjvvW7EzCzRa+QuV5LJF7L6Jk=;
        b=gULsf39uq5Fic4Z+gTZ3LctXQZi7isZVskrlz5EWWVlwsM1ISBA4BG+UnFN5afdPFu
         TXVhKyGVWUehbyOivry7C4zsTE+ddcozfxIW9Cm7JS0fZFB3HQv3GcZ6YYXn9k3FIzdH
         PVF6fWqtL0rrOzhqzdVdUXqtsY13HYZq6o8enlHCZpuzD0p0ymkIts3R0XFl9cUdJAUc
         5T4lazEcWw/6945xiwngk3ls88RtOvS4D4rXUhrc6/YbangByuaRdfZcrgv4xkPlS82p
         jxiKYDVth3R/cgiGWA8890ReS+hsB2jpdY8bwZOVPzLNuJ6QlqnQDOD47/GLx+QX/fL1
         4ZGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787336135; x=1787940935;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+qHlaVMR+JfksZ0WCBWjvvW7EzCzRa+QuV5LJF7L6Jk=;
        b=R/NjRFecsYICIWfOG/7k05J8BiIEmoTzIbZUxNN25XyZahHLbWeBlAh/v1YiF3ewbp
         KZy7LJOg99gNdxUqmF8OuD/6MhDlc/ztYMkQ+4H8zNBPx4NkUHTB4bEBgc1mkHDUwD3D
         n1FeSW5VK6thENxCTD50ca1G3ILrsJAMQ524dZHk9MQvD9O9ADWj4Qss/JuXatULkDax
         avvBUlhE6rN7vL4FC7bQpNAvZfZbN5QfE/PiCPhk1jVt7gAjaxvB1H2zK2tYt0Ioknd8
         vnFB/x4/wQ6TLLbdyZUIhleBcyXY0Y+xNIlMnRjjQiH3+20Rrv7BI9bLo57+hzyRyk2M
         nhLg==
X-Forwarded-Encrypted: i=1; AHgh+RqN6HGFIxqeKszYZj/GhbTPlgaVmRvg8mN9f09h09YVXLDgRr/yWUbQdcPD96JqSV3xP2yRCLF0gaNF@vger.kernel.org
X-Gm-Message-State: AFuF++mNQUqa/k5IrOVPIeHDNtxyZINE+y4t506ljV/JlD3VBe8MeKbg
	L/LhpilJa9qNFRYHdaMQtlh4HSXHmyCyq1CnblaQEIzmzRdbYSAhndCGd/WDChuw2NA=
X-Gm-Gg: AR+sD11Cfuhl8UsSU5HWIZvC4w8n/8YzPAEW0KpyYKVZSPgSfD89jv3jCvMwxxeJWQn
	6diUnsbTKlPo1TxywExRXBJQvZTB2DDygVPempYO4PKIslAF27jSLZOn9GTiCHQoZDie+8MgoEW
	ER9GTMqVy1IRAcsZsfxQdpNm73W/V/Y4PZLdb5rVB1M+5qEb+oi4sW36zTLRPx5dXXt0MxOPCgM
	z3BwXtHo8CORroSTvrwi3uD3wY2WjFc4ztxcx7vIfmhj/FGnst1zxVbdC5PoyIyu4/Eg1I8tgs1
	QNu87IRoGVw1DBYfIQl7/RDxXaoo1wfsEJfe44SqSCKizsm8yZArhNP6zElyoS4bGsTzjAeVJ0N
	cpXnJHczZWPqFHInVPwCH85TG8iROBuJGEBJLvzbf5Y/tfHABlVnstBsl/29t2P6UZkaPJCPguZ
	4HJHkYo+54oPUxJ9z6hewRh8rJ4xLIwX92cl4BDh83zusWVB6A1DGawz++bchpY2GQdR9r6bDpV
	0u+bRHvQbelv+5Cy4/7L7/CACY=
X-Received: by 2002:a17:903:b45:b0:2ce:a6a4:451b with SMTP id d9443c01a7336-2d61a183641mr64217725ad.11.1787336135438;
        Fri, 21 Aug 2026 11:15:35 -0700 (PDT)
Received: from dev-mliang.dev.purestorage.com ([208.88.159.128])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327bef77fc0sm51475654eec.8.2026.08.21.11.15.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 11:15:34 -0700 (PDT)
From: Michael Liang <mliang@purestorage.com>
To: akinobu.mita@gmail.com,
	akpm@linux-foundation.org
Cc: dennis.dalessandro@cornelisnetworks.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	vbabka@kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Michael Liang <mliang@purestorage.com>
Subject: [PATCH] fault-inject: fix dentry leak
Date: Fri, 21 Aug 2026 12:15:27 -0600
Message-Id: <20260821181527.3271414-1-mliang@purestorage.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fault_create_debugfs_attr() has always taken an extra dentry reference
on the created directory (attr->dname = dget(dir)) so that fail_dump()
could print the name via %pd from any context.  Nothing anywhere in the
tree ever calls dput() on attr->dname.

For callers with a matching teardown, that unmatched reference causes
one dentry plus its attached inode to leak per fault_create_debugfs_attr
/ debugfs_remove_recursive cycle.  simple_recursive_removal() drops
debugfs's own +1 ref on the child dentry, but the dget()'d ref keeps
its refcount at 1: the dentry ends up unhashed but pinned, and its
inode is never freed.

Boot-once callers (mm/failslab, block/blk-core, etc.) leak exactly once
at init and never destroy the tree, so the impact there is bounded.
But per-lifecycle callers (drivers/nvme, drivers/infiniband/hw/hfi1,
drivers/mmc, drivers/iommu/iommufd, drivers/media, drivers/misc,
drivers/gpu/drm/msm, drivers/crypto, net/sunrpc) leak on every
create/destroy cycle.

We observed this in production: an NVMe/RDMA host repeatedly
reconnecting to a target that rejected the CRTO Property Get went
through ~50 nvme controller create/destroy cycles per second, and
dentry and inode_cache grew by ~13k pinned objects per 240 s --
unrecoverable through drop_caches.  Byte math matched a per-cycle
1-dentry / 1-inode leak from the "fault_inject" directory dentry.

Fix this by not holding any external reference in fault_attr.  Embed
the directory name as a fixed-size char array (FAULT_ATTR_DNAME_LEN,
64 bytes) inside struct fault_attr, copied by strscpy() at
fault_create_debugfs_attr() time.  fail_dump() prints it via %s.

Advantages of an embedded array over kstrdup() + kfree() paired with a
new destroy API:

  - Zero API footprint.  No new export and no caller changes required:
    callers already own their fault_attr's memory and free it when
    they are done, and now that suffices.
  - No allocation on the create path.
  - fault_create_debugfs_attr() cannot fail from the name-copy step.
  - No lifetime coupling between attr->dname and debugfs; the string
    is valid for exactly as long as the containing struct.

The 64-byte length accommodates every in-tree caller with generous
headroom (the longest current name is "fail_dma_array_full", 19
chars).

The user-visible fail_dump() format changes from "name %pd" to
"name %s", but the printed content is identical -- %pd on the created
directory renders the same string that was passed in as @name.

drivers/infiniband/hw/hfi1/fault.c drops a now-invalid
"attr.dname = NULL" statement; the surrounding kzalloc() already
zero-initialises the array.

Fixes: 6adc4a22f20b ("fault-inject: add ratelimit option")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Liang <mliang@purestorage.com>
---
 drivers/infiniband/hw/hfi1/fault.c |  1 -
 include/linux/fault-inject.h       | 10 ++++++++--
 lib/fault-inject.c                 |  7 +++++--
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/fault.c b/drivers/infiniband/hw/hfi1/fault.c
index 4ab72ef03ba1..941a0b96590b 100644
--- a/drivers/infiniband/hw/hfi1/fault.c
+++ b/drivers/infiniband/hw/hfi1/fault.c
@@ -216,7 +216,6 @@ int hfi1_fault_init_debugfs(struct hfi1_ibdev *ibd)
 	ibd->fault->attr.interval = 1;
 	ibd->fault->attr.require_end = ULONG_MAX;
 	ibd->fault->attr.stacktrace_depth = 32;
-	ibd->fault->attr.dname = NULL;
 	ibd->fault->attr.verbose = 0;
 	ibd->fault->enable = false;
 	ibd->fault->opcode = false;
diff --git a/include/linux/fault-inject.h b/include/linux/fault-inject.h
index 58fd14c82270..5c74748a53f3 100644
--- a/include/linux/fault-inject.h
+++ b/include/linux/fault-inject.h
@@ -18,6 +18,13 @@ enum fault_flags {
 #include <linux/configfs.h>
 #include <linux/ratelimit.h>
 
+/*
+ * Length of the debugfs directory name embedded in struct fault_attr.
+ * Chosen to accommodate every in-tree caller of fault_create_debugfs_attr()
+ * (the longest is "fail_dma_array_full", 19 chars) with generous headroom.
+ */
+#define FAULT_ATTR_DNAME_LEN	64
+
 /*
  * For explanation of the elements of this struct, see
  * Documentation/fault-injection/fault-injection.rst
@@ -37,7 +44,7 @@ struct fault_attr {
 
 	unsigned long count;
 	struct ratelimit_state ratelimit_state;
-	struct dentry *dname;
+	char dname[FAULT_ATTR_DNAME_LEN];
 };
 
 #define FAULT_ATTR_INITIALIZER {					\
@@ -47,7 +54,6 @@ struct fault_attr {
 		.stacktrace_depth = 32,					\
 		.ratelimit_state = RATELIMIT_STATE_INIT_DISABLED,	\
 		.verbose = 2,						\
-		.dname = NULL,						\
 	}
 
 #define DECLARE_FAULT_ATTR(name) struct fault_attr name = FAULT_ATTR_INITIALIZER
diff --git a/lib/fault-inject.c b/lib/fault-inject.c
index 999053fa133e..02916ef2761c 100644
--- a/lib/fault-inject.c
+++ b/lib/fault-inject.c
@@ -5,6 +5,7 @@
 #include <linux/debugfs.h>
 #include <linux/sched.h>
 #include <linux/stat.h>
+#include <linux/string.h>
 #include <linux/types.h>
 #include <linux/fs.h>
 #include <linux/export.h>
@@ -64,7 +65,7 @@ static void fail_dump(struct fault_attr *attr)
 {
 	if (attr->verbose > 0 && __ratelimit(&attr->ratelimit_state)) {
 		printk(KERN_NOTICE "FAULT_INJECTION: forcing a failure.\n"
-		       "name %pd, interval %lu, probability %lu, "
+		       "name %s, interval %lu, probability %lu, "
 		       "space %d, times %d\n", attr->dname,
 		       attr->interval, attr->probability,
 		       atomic_read(&attr->space),
@@ -261,7 +262,9 @@ struct dentry *fault_create_debugfs_attr(const char *name,
 	debugfs_create_xul("reject-end", mode, dir, &attr->reject_end);
 #endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
 
-	attr->dname = dget(dir);
+	if (strscpy(attr->dname, name, sizeof(attr->dname)) == -E2BIG)
+		pr_warn("FAULT_INJECTION: name '%s' truncated to '%s'\n",
+			name, attr->dname);
 	return dir;
 }
 EXPORT_SYMBOL_GPL(fault_create_debugfs_attr);
-- 
2.34.1

