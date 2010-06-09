From: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v2] libibverbs: ibv_fork_init() and libhugetlbfs
Date: Wed, 9 Jun 2010 11:47:50 +0200
Message-ID: <20100609114750.0798c664@alex-laptop>
References: <20100531111359.4c0696ab@alex-laptop>
	<adamxvdqf4e.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adamxvdqf4e.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Stefan Roscher <stefan.roscher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, of-ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Vainman <alexonlists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 02 Jun 2010 14:49:37 -0700
Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:

> So if I read this correctly this patch introduces almost a 50% overhead
> in the 1M case... and probably much worse (as a fraction) in say the 64K
> or 4K case.  I wonder if that's acceptable?

We don't think this is acceptable, so we like the third approach you suggested
very much. I've written the code and attached it below. This third version
does not introduce additional overhead when not using huge pages (verified
with 4k, 64k, 1m and 16m memory regions).

Problem description:

When fork support is enabled in libibverbs, madvise() is called for every
memory page that is registered as a memory region. Memory ranges that
are passed to madvise() must be page aligned and the size must be a
multiple of the page size. libibverbs uses sysconf(_SC_PAGESIZE) to find
out the system page size and rounds all ranges passed to reg_mr() according
to this page size. When memory from libhugetlbfs is passed to reg_mr(), this
does not work as the page size for this memory range might be different
(e.g. 16Mb). So libibverbs would have to use the huge page size to
calculate a page aligned range for madvise.

As huge pages are provided to the application "under the hood" when
preloading libhugetlbfs, the application does not have any knowledge about
when it registers a huge page or a usual page.

To work around this issue, detect the use of huge pages in libibverbs and
align memory ranges passed to madvise according to the huge page size.

Changes since v1:

- detect use of huge pages at ibv_fork_init() time by walking through
  /sys/kernel/mm/hugepages/
- read huge page size from /proc/pid/smaps, which contains the page
  size of the mapping (thereby enabling support for mutliple huge
  page sizes)
- code is independent of libhugetlbfs now, so huge pages can be provided
  to the application by any library

Changes since v2:

- reading from /proc/ to determine the huge page size is now only done
  when a call to madvise() using the system page size fails. So there
  is no overhead introduced when registering non-huge-page memory.

Signed-off-by: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 src/memory.c |   96 +++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 90 insertions(+), 6 deletions(-)

--- libibverbs.git.orig/src/memory.c
+++ libibverbs.git/src/memory.c
@@ -40,6 +40,8 @@
 #include <unistd.h>
 #include <stdlib.h>
 #include <stdint.h>
+#include <stdio.h>
+#include <string.h>
 
 #include "ibverbs.h"
 
@@ -70,10 +72,64 @@ static pthread_mutex_t mm_mutex = PTHREA
 static int page_size;
 static int too_late;
 
+static unsigned long smaps_page_size(FILE *file)
+{
+	int n;
+	unsigned long size = 0;
+	char buf[1024];
+
+	while (fgets(buf, sizeof(buf), file) != NULL) {
+		if (!strstr(buf, "KernelPageSize:"))
+			continue;
+
+		n = sscanf(buf, "%*s %lu", &size);
+		if (n < 1)
+			continue;
+
+		/* page size is printed in Kb */
+		size = size * 1024;
+
+		break;
+	}
+
+	return size;
+}
+
+static unsigned long get_page_size(void *base)
+{
+	unsigned long ret = 0;
+	FILE *file;
+	char buf[1024];
+
+	file = fopen("/proc/self/smaps", "r");
+	if (!file)
+		goto out;
+
+	while (fgets(buf, sizeof(buf), file) != NULL) {
+		int n;
+		uintptr_t range_start, range_end;
+
+		n = sscanf(buf, "%lx-%lx", &range_start, &range_end);
+
+		if (n < 2)
+			continue;
+
+		if ((uintptr_t) base >= range_start && (uintptr_t) base < range_end) {
+			ret = smaps_page_size(file);
+			break;
+		}
+	}
+	fclose(file);
+
+out:
+	return ret;
+}
+
 int ibv_fork_init(void)
 {
-	void *tmp;
+	void *tmp, *tmp_aligned;
 	int ret;
+	unsigned long size;
 
 	if (mm_root)
 		return 0;
@@ -88,8 +144,17 @@ int ibv_fork_init(void)
 	if (posix_memalign(&tmp, page_size, page_size))
 		return ENOMEM;
 
-	ret = madvise(tmp, page_size, MADV_DONTFORK) ||
-	      madvise(tmp, page_size, MADV_DOFORK);
+	size = get_page_size(tmp);
+
+	if (size)
+		tmp_aligned = (void *)((uintptr_t)tmp & ~(size - 1));
+	else {
+		size = page_size;
+		tmp_aligned = tmp;
+	}
+
+	ret = madvise(tmp_aligned, size, MADV_DONTFORK) ||
+	      madvise(tmp_aligned, size, MADV_DOFORK);
 
 	free(tmp);
 
@@ -522,7 +587,8 @@ static struct ibv_mem_node *undo_node(st
 	return node;
 }
 
-static int ibv_madvise_range(void *base, size_t size, int advice)
+static int ibv_madvise_range(void *base, size_t size, int advice,
+			     unsigned long page_size)
 {
 	uintptr_t start, end;
 	struct ibv_mem_node *node, *tmp;
@@ -612,10 +678,28 @@ out:
 	return ret;
 }
 
+static int ibv_fork_range(void *base, size_t size, int advice)
+{
+	int ret;
+	unsigned long range_page_size;
+
+	ret = ibv_madvise_range(base, size, advice, page_size);
+
+	if (ret == -1 && errno == EINVAL) {
+		range_page_size = get_page_size(base);
+
+		if (range_page_size)
+			ret = ibv_madvise_range(base, size, advice,
+						range_page_size);
+	}
+
+	return ret;
+}
+
 int ibv_dontfork_range(void *base, size_t size)
 {
 	if (mm_root)
-		return ibv_madvise_range(base, size, MADV_DONTFORK);
+		return ibv_fork_range(base, size, MADV_DONTFORK);
 	else {
 		too_late = 1;
 		return 0;
@@ -625,7 +709,7 @@ int ibv_dontfork_range(void *base, size_
 int ibv_dofork_range(void *base, size_t size)
 {
 	if (mm_root)
-		return ibv_madvise_range(base, size, MADV_DOFORK);
+		return ibv_fork_range(base, size, MADV_DOFORK);
 	else {
 		too_late = 1;
 		return 0;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
