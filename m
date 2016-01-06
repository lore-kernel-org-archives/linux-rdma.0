From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 21/36] IB/rdmavt: Move MR datastructures into rvt
Date: Wed, 06 Jan 2016 10:01:42 -0800
Message-ID: <20160106180122.8747.8793.stgit@scvm10.sc.intel.com>
References: <20160106174638.8747.47197.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160106174638.8747.47197.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds the MR datastructures based on hfi1 into rvt. For now the
data structures are defined in include/rdma/rdma_vt.h but once all MR
functionality has been moved from the drivers into rvt these should move to
rdmavt/mr.h

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes since v1:
Rename rdi.lk_table => rdi.lkey_table

 include/rdma/rdma_vt.h |   53 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index bf072a4..f232e39 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -56,6 +56,56 @@
 #include "ib_verbs.h"
 
 /*
+ * For Memory Regions. This stuff should probably be moved into rdmavt/mr.h once
+ * drivers no longer need access to the MR directly.
+ */
+
+/*
+ * A segment is a linear region of low physical memory.
+ * Used by the verbs layer.
+ */
+struct rvt_seg {
+	void *vaddr;
+	size_t length;
+};
+
+/* The number of rvt_segs that fit in a page. */
+#define RVT_SEGSZ     (PAGE_SIZE / sizeof(struct rvt_seg))
+
+struct rvt_segarray {
+	struct rvt_seg segs[RVT_SEGSZ];
+};
+
+struct rvt_mregion {
+	struct ib_pd *pd;       /* shares refcnt of ibmr.pd */
+	u64 user_base;          /* User's address for this region */
+	u64 iova;               /* IB start address of this region */
+	size_t length;
+	u32 lkey;
+	u32 offset;             /* offset (bytes) to start of region */
+	int access_flags;
+	u32 max_segs;           /* number of rvt_segs in all the arrays */
+	u32 mapsz;              /* size of the map array */
+	u8  page_shift;         /* 0 - non unform/non powerof2 sizes */
+	u8  lkey_published;     /* in global table */
+	struct completion comp; /* complete when refcount goes to zero */
+	atomic_t refcount;
+	struct rvt_segarray *map[0];    /* the segments */
+};
+
+#define RVT_MAX_LKEY_TABLE_BITS 23
+
+struct rvt_lkey_table {
+	spinlock_t lock; /* protect changes in this struct */
+	u32 next;               /* next unused index (speeds search) */
+	u32 gen;                /* generation count */
+	u32 max;                /* size of the table */
+	struct rvt_mregion __rcu **table;
+};
+
+/* End Memmory Region */
+
+/*
  * Things that are driver specific, module parameters in hfi1 and qib
  */
 struct rvt_driver_params {
@@ -119,6 +169,9 @@ struct rvt_dev_info {
 	/* Driver specific properties */
 	struct rvt_driver_params dparms;
 
+	struct rvt_mregion __rcu *dma_mr;
+	struct rvt_lkey_table lkey_table;
+
 	/* PKey Table goes here */
 
 	/*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
