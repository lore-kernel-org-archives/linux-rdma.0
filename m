From: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [RFC] libibverbs: ibv_fork_init() and libhugetlbfs
Date: Thu, 6 May 2010 09:39:49 +0200
Message-ID: <20100506093949.55916ab0@alex-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, of-ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Hoang-Nam Nguyen <HNGUYEN-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Stefan Roscher <stefan.roscher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Joachim Fenkes <fenkes-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi all,

we are trying to make use of libhugetlbfs in an application that relies on
ibv_fork_init() to enable fork() support. The problem we are running into is
that calls to the madvise system call fail when registering a memory region
for memory that is provided by libhugetlbfs. We have written a preliminary
fix (see below) for this and are looking for comments / feedback to get an
acceptable solution.

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

The patch below demonstrates a possible solution for this. It parses the
/proc/PID/maps file when registering a memory region and decides if the
memory that is to be registered is part of a libhugetlbfs range or not. If so,
a page size of 16Mb is used to align the memory range passed to madvise().

We see two problems with this: it is not a very elegant solution to parse the
procfs file and the 16Mb are hardcoded currently. The latter point could be
solved by calling gethugepagesize() from libhugetlbfs, which would add a new
dependency to libibverbs.

We are highly interested in reviews, comments, suggestions to get this solved
soon. Thanks!

Signed-off-by: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 src/memory.c |   50 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 47 insertions(+), 3 deletions(-)

--- libibverbs-1.1.2.orig/src/memory.c
+++ libibverbs-1.1.2/src/memory.c
@@ -40,6 +40,8 @@
 #include <unistd.h>
 #include <stdlib.h>
 #include <stdint.h>
+#include <stdio.h>
+#include <string.h>
 
 #include "ibverbs.h"
 
@@ -54,6 +56,8 @@
 #define MADV_DOFORK	11
 #endif
 
+#define HUGE_PAGE_SIZE	(16 * 1024 * 1024)
+
 struct ibv_mem_node {
 	enum {
 		IBV_RED,
@@ -446,6 +450,48 @@ static struct ibv_mem_node *__mm_find_st
 	return node;
 }
 
+static void get_range_address(uintptr_t *start, uintptr_t *end, void *base, size_t size)
+{
+	pid_t pid;
+	FILE *file;
+	char buf[1024], lib[128];
+	int range_page_size = page_size;
+
+	pid = getpid();
+	snprintf(buf, sizeof(buf), "/proc/%d/maps", pid);
+
+	file = fopen(buf, "r");
+	if (!file)
+		goto out;
+
+	while (fgets(buf, sizeof(buf), file) != NULL) {
+		int n;
+		char *substr;
+		uintptr_t range_start, range_end;
+
+		n = sscanf(buf, "%lx-%lx %*s %*x %*s %*u %127s",
+				&range_start, &range_end, &lib);
+
+		if (n < 3)
+			continue;
+
+		substr = strstr(lib, "libhugetlbfs");
+		if (substr) {
+			if ((uintptr_t) base >= range_start &&
+					(uintptr_t) base < range_end) {
+				range_page_size = HUGE_PAGE_SIZE;
+				break;
+			}
+		}
+	}
+	fclose(file);
+
+out:
+	*start = (uintptr_t) base & ~(range_page_size - 1);
+	*end   = ((uintptr_t) (base + size + range_page_size - 1) &
+		 ~(range_page_size - 1)) - 1;
+}
+
 static int ibv_madvise_range(void *base, size_t size, int advice)
 {
 	uintptr_t start, end;
@@ -458,9 +504,7 @@ static int ibv_madvise_range(void *base,
 
 	inc = advice == MADV_DONTFORK ? 1 : -1;
 
-	start = (uintptr_t) base & ~(page_size - 1);
-	end   = ((uintptr_t) (base + size + page_size - 1) &
-		 ~(page_size - 1)) - 1;
+	get_range_address(&start, &end, base, size);
 
 	pthread_mutex_lock(&mm_mutex);
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
