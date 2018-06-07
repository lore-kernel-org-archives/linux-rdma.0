From: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Subject: [PATCH v2 1/2] idr: Add ida_simple_get_cyclic
Date: Thu,  7 Jun 2018 12:52:07 +0200
Message-ID: <20180607105208.16332-2-hans.westgaard.ry@oracle.com>
References: <20180529073808.27735-1-hans.westgaard.ry@oracle.com>
 <20180607105208.16332-1-hans.westgaard.ry@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180607105208.16332-1-hans.westgaard.ry@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Hakon Bugge <haakon.bugge@oracle.com>, Parav Pandit <parav@mellanox.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Pravin Shedge <pravin.shedge4linux@gmail.com>, Matthew Wilcox <mawilcox@microsoft.com>, Andrew Morton <akpm@linux-foundation.org>, Jeff Layton <jlayton@kernel.org>, Wei Wang <wei.w.wang@intel.com>, Chris Mi <chrism@mellanox.com>, Eric Biggers <ebiggers@google.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Mel Gorman <mgorman@techsingularity.net>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Orabug: 25571450

Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
---
 include/linux/idr.h |  8 +++++--
 lib/idr.c           | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index e856f4e0ab35..f151ce89124a 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -218,10 +218,12 @@ DECLARE_PER_CPU(struct ida_bitmap *, ida_bitmap);
 
 struct ida {
 	struct radix_tree_root	ida_rt;
+	unsigned int		ida_next;
 };
 
-#define IDA_INIT(name)	{						\
-	.ida_rt = RADIX_TREE_INIT(name, IDR_RT_MARKER | GFP_NOWAIT),	\
+#define IDA_INIT(name)	{						     \
+		.ida_rt = RADIX_TREE_INIT(name, IDR_RT_MARKER | GFP_NOWAIT), \
+		.ida_next = 0,						     \
 }
 #define DEFINE_IDA(name)	struct ida name = IDA_INIT(name)
 
@@ -232,6 +234,8 @@ void ida_destroy(struct ida *ida);
 
 int ida_simple_get(struct ida *ida, unsigned int start, unsigned int end,
 		   gfp_t gfp_mask);
+int ida_simple_get_cyclic(struct ida *ida, unsigned int start, unsigned int end,
+			  gfp_t gfp_mask);
 void ida_simple_remove(struct ida *ida, unsigned int id);
 
 static inline void ida_init(struct ida *ida)
diff --git a/lib/idr.c b/lib/idr.c
index 823b813f08f8..3374c3fa4027 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -599,6 +599,72 @@ int ida_simple_get(struct ida *ida, unsigned int start, unsigned int end,
 	return ret;
 }
 EXPORT_SYMBOL(ida_simple_get);
+/**
+ * ida_simple_get_cyclic - get a new id.
+ * @ida: the (initialized) ida.
+ * @start: the minimum id (inclusive, < 0x8000000)
+ * @end: the maximum id (exclusive, < 0x8000000 or 0)
+ * @gfp_mask: memory allocation flags
+ *
+ * Allocates an id in the range start <= id < end, or returns -ENOSPC.
+ * On memory allocation failure, returns -ENOMEM.
+ * The search for an unused id will start at the last id allocated and will
+ * wrap around to @start if no free ids are found before reaching @end.
+ *
+ * Compared to ida_get_new_above() this function does its own locking, and
+ * should be used unless there are special requirements.
+ *
+ * Use ida_simple_remove() to get rid of an id.
+ */
+int ida_simple_get_cyclic(struct ida *ida, unsigned int start, unsigned int end,
+		   gfp_t gfp_mask)
+{
+	int ret, id, next;
+	unsigned int max;
+	unsigned long flags;
+
+	WARN_ON((int)start < 0);
+	WARN_ON((int)end < 0);
+
+	if (end == 0) {
+		max = 0x80000000;
+	} else {
+		WARN_ON(end < start);
+		max = end - 1;
+	}
+
+again:
+	if (!ida_pre_get(ida, gfp_mask))
+		return -ENOMEM;
+
+	spin_lock_irqsave(&simple_ida_lock, flags);
+	next = ida->ida_next;
+	if (next < start || next >= end)
+		next = start;
+
+	ret = ida_get_new_above(ida, next, &id);
+	if (likely(!ret)) {
+		if (unlikely(id >= max)) {
+			ida_remove(ida, id);
+			if (next == start) {
+				ret = -ENOSPC;
+			} else {
+				ida->ida_next = start;
+				spin_unlock_irqrestore(&simple_ida_lock, flags);
+				goto again;
+			}
+		} else {
+			ida->ida_next = id + 1;
+			ret = id;
+		}
+	}
+	spin_unlock_irqrestore(&simple_ida_lock, flags);
+
+	if (unlikely(ret == -EAGAIN))
+		goto again;
+	return ret;
+}
+EXPORT_SYMBOL(ida_simple_get_cyclic);
 
 /**
  * ida_simple_remove - remove an allocated id.
-- 
2.14.3
