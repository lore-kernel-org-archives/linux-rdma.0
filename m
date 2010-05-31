From: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v2] libibverbs: ibv_fork_init() and libhugetlbfs
Date: Mon, 31 May 2010 11:13:59 +0200
Message-ID: <20100531111359.4c0696ab@alex-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Stefan Roscher <stefan.roscher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, of-ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Vainman <alexonlists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

we have been working on adressing your review comments and are looking for
feedback regarding v2 now.

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

Performance:

PPC64 system with eHCA

without patch:
1M memory region    120usec
16M memory region  1970usec 

with patch v2:
1M memory region    172usec
16M memory region  2030usec

with patch and 16M huge pages:
1M memory region    110usec
16M memory region   193usec

Signed-off-by: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 src/memory.c |  137 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 131 insertions(+), 6 deletions(-)

--- libibverbs-1.1.2.orig/src/memory.c
+++ libibverbs-1.1.2/src/memory.c
@@ -40,6 +40,10 @@
 #include <unistd.h>
 #include <stdlib.h>
 #include <stdint.h>
+#include <stdio.h>
+#include <string.h>
+#include <dirent.h>
+#include <limits.h>
 
 #include "ibverbs.h"
 
@@ -68,12 +72,117 @@ struct ibv_mem_node {
 static struct ibv_mem_node *mm_root;
 static pthread_mutex_t mm_mutex = PTHREAD_MUTEX_INITIALIZER;
 static int page_size;
+static int huge_page_enabled;
 static int too_late;
 
+static int is_huge_page_enabled(void)
+{
+	int n, ret = 0;
+	char *bufp;
+	DIR *dir;
+	struct dirent *entry;
+	FILE *file;
+	unsigned long nr_hugepages;
+	char buf[1024];
+
+	dir = opendir("/sys/kernel/mm/hugepages/");
+	if (!dir)
+		return 0;
+
+	while ((entry = readdir(dir))) {
+		if (strncmp(entry->d_name, "hugepages-", 10))
+			continue;
+
+		snprintf(buf, sizeof(buf), "/sys/kernel/mm/hugepages/%s/nr_hugepages",
+				entry->d_name);
+
+		file = fopen(buf, "r");
+		if (!file)
+			continue;
+
+		bufp = fgets(buf, sizeof(buf), file);
+		fclose(file);
+		if (!bufp)
+			continue;
+
+		n = sscanf(buf, "%lu", &nr_hugepages);
+		if (n < 1)
+			continue;
+
+		if (nr_hugepages) {
+			ret = 1;
+			goto out;
+		}
+	}
+
+out:
+	closedir(dir);
+
+	return ret;
+}
+
+static unsigned long smaps_page_size(FILE *file)
+{
+	int n;
+	unsigned long size = page_size;
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
+	unsigned long ret = page_size;
+	pid_t pid;
+	FILE *file;
+	char buf[1024];
+
+	pid = getpid();
+	snprintf(buf, sizeof(buf), "/proc/%d/smaps", pid);
+
+	file = fopen(buf, "r");
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
@@ -88,8 +197,18 @@ int ibv_fork_init(void)
 	if (posix_memalign(&tmp, page_size, page_size))
 		return ENOMEM;
 
-	ret = madvise(tmp, page_size, MADV_DONTFORK) ||
-	      madvise(tmp, page_size, MADV_DOFORK);
+	huge_page_enabled = is_huge_page_enabled();
+
+	if (huge_page_enabled) {
+		size = get_page_size(tmp);
+		tmp_aligned = (void *)((uintptr_t)tmp & ~(size - 1));
+	} else {
+		size = page_size;
+		tmp_aligned = tmp;
+	}
+
+	ret = madvise(tmp_aligned, size, MADV_DONTFORK) ||
+	      madvise(tmp_aligned, size, MADV_DOFORK);
 
 	free(tmp);
 
@@ -452,15 +571,21 @@ static int ibv_madvise_range(void *base,
 	struct ibv_mem_node *node, *tmp;
 	int inc;
 	int ret = 0;
+	unsigned long range_page_size;
 
 	if (!size)
 		return 0;
 
 	inc = advice == MADV_DONTFORK ? 1 : -1;
 
-	start = (uintptr_t) base & ~(page_size - 1);
-	end   = ((uintptr_t) (base + size + page_size - 1) &
-		 ~(page_size - 1)) - 1;
+	if (huge_page_enabled)
+		range_page_size = get_page_size(base);
+	else
+		range_page_size = page_size;
+
+	start = (uintptr_t) base & ~(range_page_size - 1);
+	end   = ((uintptr_t) (base + size + range_page_size - 1) &
+		 ~(range_page_size - 1)) - 1;
 
 	pthread_mutex_lock(&mm_mutex);
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
