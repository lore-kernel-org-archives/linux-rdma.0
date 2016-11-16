From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core] ccan: Add likely implementation
Date: Wed, 16 Nov 2016 19:40:11 +0200
Message-ID: <1479318011-26878-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add likely/unlikely macros to ccan directory.
This change includes adjustments to various providers, who
defined it locally (nes, mlx4, mlx5 and hns).

The code of i40iw had such definitions too, but without actual usage and
this patch removed this dead code.

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 ccan/CMakeLists.txt           |   2 +
 ccan/likely.c                 | 136 ++++++++++++++++++++++++++++++++++++++++++
 ccan/likely.h                 | 111 ++++++++++++++++++++++++++++++++++
 providers/hns/hns_roce_u.h    |   5 +-
 providers/i40iw/i40iw_umain.h |   7 ---
 providers/mlx4/mlx4.h         |   8 ---
 providers/mlx4/qp.c           |   1 +
 providers/mlx5/mlx5.h         |   6 +-
 providers/nes/nes_umain.h     |   8 +--
 9 files changed, 253 insertions(+), 31 deletions(-)
 create mode 100644 ccan/likely.c
 create mode 100644 ccan/likely.h

diff --git a/ccan/CMakeLists.txt b/ccan/CMakeLists.txt
index b5de515..153426f 100644
--- a/ccan/CMakeLists.txt
+++ b/ccan/CMakeLists.txt
@@ -6,11 +6,13 @@ publish_internal_headers(ccan
   minmax.h
   str.h
   str_debug.h
+  likely.h
   )
 
 set(C_FILES
   list.c
   str.c
+  likely.c
   )
 add_library(ccan STATIC ${C_FILES})
 add_library(ccan_pic STATIC ${C_FILES})
diff --git a/ccan/likely.c b/ccan/likely.c
new file mode 100644
index 0000000..83e8d6f
--- /dev/null
+++ b/ccan/likely.c
@@ -0,0 +1,136 @@
+/* CC0 (Public domain) - see LICENSE file for details. */
+#ifdef CCAN_LIKELY_DEBUG
+#include <ccan/likely/likely.h>
+#include <ccan/hash/hash.h>
+#include <ccan/htable/htable_type.h>
+#include <stdlib.h>
+#include <stdio.h>
+struct trace {
+	const char *condstr;
+	const char *file;
+	unsigned int line;
+	bool expect;
+	unsigned long count, right;
+};
+
+static size_t hash_trace(const struct trace *trace)
+{
+	return hash(trace->condstr, strlen(trace->condstr),
+		    hash(trace->file, strlen(trace->file),
+			 trace->line + trace->expect));
+}
+
+static bool trace_eq(const struct trace *t1, const struct trace *t2)
+{
+	return t1->condstr == t2->condstr
+		&& t1->file == t2->file
+		&& t1->line == t2->line
+		&& t1->expect == t2->expect;
+}
+
+/* struct thash */
+HTABLE_DEFINE_TYPE(struct trace, (const struct trace *), hash_trace, trace_eq,
+		   thash);
+
+static struct thash htable
+= { HTABLE_INITIALIZER(htable.raw, thash_hash, NULL) };
+
+static void init_trace(struct trace *trace,
+		       const char *condstr, const char *file, unsigned int line,
+		       bool expect)
+{
+	trace->condstr = condstr;
+	trace->file = file;
+	trace->line = line;
+	trace->expect = expect;
+	trace->count = trace->right = 0;
+}
+
+static struct trace *add_trace(const struct trace *t)
+{
+	struct trace *trace = malloc(sizeof(*trace));
+	*trace = *t;
+	thash_add(&htable, trace);
+	return trace;
+}
+
+long _likely_trace(bool cond, bool expect,
+		   const char *condstr,
+		   const char *file, unsigned int line)
+{
+	struct trace *p, trace;
+
+	init_trace(&trace, condstr, file, line, expect);
+	p = thash_get(&htable, &trace);
+	if (!p)
+		p = add_trace(&trace);
+
+	p->count++;
+	if (cond == expect)
+		p->right++;
+
+	return cond;
+}
+
+static double right_ratio(const struct trace *t)
+{
+	return (double)t->right / t->count;
+}
+
+char *likely_stats(unsigned int min_hits, unsigned int percent)
+{
+	struct trace *worst;
+	double worst_ratio;
+	struct thash_iter i;
+	char *ret;
+	struct trace *t;
+
+	worst = NULL;
+	worst_ratio = 2;
+
+	/* This is O(n), but it's not likely called that often. */
+	for (t = thash_first(&htable, &i); t; t = thash_next(&htable, &i)) {
+		if (t->count >= min_hits) {
+			if (right_ratio(t) < worst_ratio) {
+				worst = t;
+				worst_ratio = right_ratio(t);
+			}
+		}
+	}
+
+	if (worst_ratio * 100 > percent)
+		return NULL;
+
+	ret = malloc(strlen(worst->condstr) +
+		     strlen(worst->file) +
+		     sizeof(long int) * 8 +
+		     sizeof("%s:%u:%slikely(%s) correct %u%% (%lu/%lu)"));
+	sprintf(ret, "%s:%u:%slikely(%s) correct %u%% (%lu/%lu)",
+		worst->file, worst->line,
+		worst->expect ? "" : "un", worst->condstr,
+		(unsigned)(worst_ratio * 100),
+		worst->right, worst->count);
+
+	thash_del(&htable, worst);
+	free(worst);
+
+	return ret;
+}
+
+void likely_stats_reset(void)
+{
+	struct thash_iter i;
+	struct trace *t;
+
+	/* This is a bit better than O(n^2), but we have to loop since
+	 * first/next during delete is unreliable. */
+	while ((t = thash_first(&htable, &i)) != NULL) {
+		for (; t; t = thash_next(&htable, &i)) {
+			thash_del(&htable, t);
+			free(t);
+		}
+	}
+
+	thash_clear(&htable);
+}
+#endif /*CCAN_LIKELY_DEBUG*/
diff --git a/ccan/likely.h b/ccan/likely.h
new file mode 100644
index 0000000..a8f003d
--- /dev/null
+++ b/ccan/likely.h
@@ -0,0 +1,111 @@
+/* CC0 (Public domain) - see LICENSE file for details */
+#ifndef CCAN_LIKELY_H
+#define CCAN_LIKELY_H
+#include "config.h"
+#include <stdbool.h>
+
+#ifndef CCAN_LIKELY_DEBUG
+#if HAVE_BUILTIN_EXPECT
+/**
+ * likely - indicate that a condition is likely to be true.
+ * @cond: the condition
+ *
+ * This uses a compiler extension where available to indicate a likely
+ * code path and optimize appropriately; it's also useful for readers
+ * to quickly identify exceptional paths through functions.  The
+ * threshold for "likely" is usually considered to be between 90 and
+ * 99%; marginal cases should not be marked either way.
+ *
+ * See Also:
+ *	unlikely(), likely_stats()
+ *
+ * Example:
+ *	// Returns false if we overflow.
+ *	static inline bool inc_int(unsigned int *val)
+ *	{
+ *		(*val)++;
+ *		if (likely(*val))
+ *			return true;
+ *		return false;
+ *	}
+ */
+#define likely(cond) __builtin_expect(!!(cond), 1)
+
+/**
+ * unlikely - indicate that a condition is unlikely to be true.
+ * @cond: the condition
+ *
+ * This uses a compiler extension where available to indicate an unlikely
+ * code path and optimize appropriately; see likely() above.
+ *
+ * See Also:
+ *	likely(), likely_stats(), COLD (compiler.h)
+ *
+ * Example:
+ *	// Prints a warning if we overflow.
+ *	static inline void inc_int(unsigned int *val)
+ *	{
+ *		(*val)++;
+ *		if (unlikely(*val == 0))
+ *			fprintf(stderr, "Overflow!");
+ *	}
+ */
+#define unlikely(cond) __builtin_expect(!!(cond), 0)
+#else
+#define likely(cond) (!!(cond))
+#define unlikely(cond) (!!(cond))
+#endif
+#else /* CCAN_LIKELY_DEBUG versions */
+#include <ccan/str/str.h>
+
+#define likely(cond) \
+	(_likely_trace(!!(cond), 1, stringify(cond), __FILE__, __LINE__))
+#define unlikely(cond) \
+	(_likely_trace(!!(cond), 0, stringify(cond), __FILE__, __LINE__))
+
+long _likely_trace(bool cond, bool expect,
+		   const char *condstr,
+		   const char *file, unsigned int line);
+/**
+ * likely_stats - return description of abused likely()/unlikely()
+ * @min_hits: minimum number of hits
+ * @percent: maximum percentage correct
+ *
+ * When CCAN_LIKELY_DEBUG is defined, likely() and unlikely() trace their
+ * results: this causes a significant slowdown, but allows analysis of
+ * whether the branches are labelled correctly.
+ *
+ * This function returns a malloc'ed description of the least-correct
+ * usage of likely() or unlikely().  It ignores places which have been
+ * called less than @min_hits times, and those which were predicted
+ * correctly more than @percent of the time.  It returns NULL when
+ * nothing meets those criteria.
+ *
+ * Note that this call is destructive; the returned offender is
+ * removed from the trace so that the next call to likely_stats() will
+ * return the next-worst likely()/unlikely() usage.
+ *
+ * Example:
+ *	// Print every place hit more than twice which was wrong > 5%.
+ *	static void report_stats(void)
+ *	{
+ *	#ifdef CCAN_LIKELY_DEBUG
+ *		const char *bad;
+ *
+ *		while ((bad = likely_stats(2, 95)) != NULL) {
+ *			printf("Suspicious likely: %s", bad);
+ *			free(bad);
+ *		}
+ *	#endif
+ *	}
+ */
+char *likely_stats(unsigned int min_hits, unsigned int percent);
+
+/**
+ * likely_stats_reset - free up memory of likely()/unlikely() branches.
+ *
+ * This can also plug memory leaks.
+ */
+void likely_stats_reset(void);
+#endif /* CCAN_LIKELY_DEBUG */
+#endif /* CCAN_LIKELY_H */
diff --git a/providers/hns/hns_roce_u.h b/providers/hns/hns_roce_u.h
index 4a6ed8e..1659958 100644
--- a/providers/hns/hns_roce_u.h
+++ b/providers/hns/hns_roce_u.h
@@ -39,6 +39,7 @@
 #include <infiniband/arch.h>
 #include <infiniband/verbs.h>
 #include <ccan/container_of.h>
+#include <ccan/likely.h>
 
 #define HNS_ROCE_CQE_ENTRY_SIZE		0x20
 
@@ -51,10 +52,6 @@
 
 #define PFX				"hns: "
 
-#ifndef likely
-#define likely(x)     __builtin_expect(!!(x), 1)
-#endif
-
 #define roce_get_field(origin, mask, shift) \
 	(((origin) & (mask)) >> (shift))
 
diff --git a/providers/i40iw/i40iw_umain.h b/providers/i40iw/i40iw_umain.h
index 719aefc..6a23504 100644
--- a/providers/i40iw/i40iw_umain.h
+++ b/providers/i40iw/i40iw_umain.h
@@ -47,13 +47,6 @@
 #include "i40iw_status.h"
 #include "i40iw_user.h"
 
-#ifndef likely
-#define likely(x)   __builtin_expect((x), 1)
-#endif
-#ifndef unlikely
-#define unlikely(x) __builtin_expect((x), 0)
-#endif
-
 #define PFX "libi40iw-"
 
 #define  I40IW_BASE_PUSH_PAGE	1
diff --git a/providers/mlx4/mlx4.h b/providers/mlx4/mlx4.h
index b851e95..6467d5a 100644
--- a/providers/mlx4/mlx4.h
+++ b/providers/mlx4/mlx4.h
@@ -51,14 +51,6 @@ enum {
 	MLX4_STAT_RATE_OFFSET		= 5
 };
 
-#ifndef likely
-#ifdef __GNUC__
-#define likely(x)       __builtin_expect(!!(x),1)
-#else
-#define likely(x)      (x)
-#endif
-#endif
-
 enum {
 	MLX4_QP_TABLE_BITS		= 8,
 	MLX4_QP_TABLE_SIZE		= 1 << MLX4_QP_TABLE_BITS,
diff --git a/providers/mlx4/qp.c b/providers/mlx4/qp.c
index 268fb7d..af08874 100644
--- a/providers/mlx4/qp.c
+++ b/providers/mlx4/qp.c
@@ -40,6 +40,7 @@
 #include <string.h>
 #include <errno.h>
 #include <util/compiler.h>
+#include <ccan/likely.h>
 
 #include "mlx4.h"
 #include "doorbell.h"
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index cb65429..d5704d4 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -42,11 +42,7 @@
 #include <ccan/list.h>
 #include "bitmap.h"
 #include <ccan/minmax.h>
-
-#ifdef __GNUC__
-#define likely(x)	__builtin_expect((x), 1)
-#define unlikely(x)	__builtin_expect((x), 0)
-#endif
+#include <ccan/likely.h>
 
 #include <valgrind/memcheck.h>
 
diff --git a/providers/nes/nes_umain.h b/providers/nes/nes_umain.h
index 093956a..5f357a2 100644
--- a/providers/nes/nes_umain.h
+++ b/providers/nes/nes_umain.h
@@ -40,13 +40,7 @@
 
 #include <infiniband/driver.h>
 #include <infiniband/arch.h>
-
-#ifndef likely
-#define likely(x)   __builtin_expect((x),1)
-#endif
-#ifndef unlikely
-#define unlikely(x) __builtin_expect((x),0)
-#endif
+#include <ccan/likely.h>
 
 #define PFX	"libnes: "
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
