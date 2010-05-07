From: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC] libibverbs: ibv_fork_init() and libhugetlbfs
Date: Fri, 7 May 2010 12:19:36 +0200
Message-ID: <20100507121936.283a18c6@alex-laptop>
References: <20100506093949.55916ab0@alex-laptop>
	<adavdb092d8.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adavdb092d8.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: of-ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Stefan Roscher <stefan.roscher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Joachim Fenkes <fenkes-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Alex Vainman <alexonlists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 06 May 2010 13:55:31 -0700
Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:
> I think that we cannot assume huge pages only come from libhugetlbfs --
> we should support an application directly enabling huge pages (possibly
> via another library too, so we can't assume that an application knows
> the page size for a memory range it is about to register).
> 
> And also the 16 MB page size constant is of course not feasible -- with
> all due respect, the x86 page size of 2 MB is much more likely in
> practice :)  (Although perhaps the much slower PowerPC TLB refill makes
> users more likely to try and use hugetlb pages ;)
> 
> Alex suggested parsing files in the same way as libhugetlbfs does to get
> the page size, and that seems to be the best solution, since I don't
> think the libhugetlbfs license is compatible with the BSD license for
> libibverbs.
> 
> But your trick of using /proc/*/maps looks nice.  Does that only work
> for libhugetlbfs or can we recognize direct mmap of hugetlb pages?

Hi Roland, thanks for your comments!

I've reworked my patch:
 * added get_huge_page_size() to read the huge page size from
   /proc/meminfo. This is done at ibv_fork_init() time.
 * I noticed that some applications like ibv_rc_pingpong already
   get memory from libhugetlbfs when running ibv_fork_init(). So
   I changed the code for testing madvise() to allocate a huge page
   if the huge page size is set in the system.

I have not tested this code with different libraries providing huge
pages / mmaped pages yet, but I hope this can be added later on when
we have agreed on an approach to handle huge pages.

Signed-off-by: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 src/memory.c |  103 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 95 insertions(+), 8 deletions(-)

--- libibverbs-1.1.2.orig/src/memory.c
+++ libibverbs-1.1.2/src/memory.c
@@ -40,6 +40,8 @@
 #include <unistd.h>
 #include <stdlib.h>
 #include <stdint.h>
+#include <stdio.h>
+#include <string.h>
 
 #include "ibverbs.h"
 
@@ -68,12 +70,45 @@ struct ibv_mem_node {
 static struct ibv_mem_node *mm_root;
 static pthread_mutex_t mm_mutex = PTHREAD_MUTEX_INITIALIZER;
 static int page_size;
+static int huge_page_size;
 static int too_late;
 
+static int get_huge_page_size(void)
+{
+	int ret = -1;
+	FILE *file;
+	char *path = "/proc/meminfo";
+	char buf[1024], type[128];
+
+	file = fopen(path, "r");
+	if (!file)
+		goto out;
+
+	while (fgets(buf, sizeof(buf), file) != NULL) {
+		int n;
+		unsigned long size;
+
+		n = sscanf(buf, "%127s %lu %*s", &type, &size);
+
+		if (n < 2)
+			continue;
+
+		if (!strcmp(type, "Hugepagesize:")) {
+			/* huge page size is printed in Kb */
+			ret = size * 1024;
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
 	void *tmp;
-	int ret;
+	int ret, size;
 
 	if (mm_root)
 		return 0;
@@ -85,11 +120,18 @@ int ibv_fork_init(void)
 	if (page_size < 0)
 		return errno;
 
-	if (posix_memalign(&tmp, page_size, page_size))
+	huge_page_size = get_huge_page_size();
+
+	if (huge_page_size > page_size)
+		size = huge_page_size;
+	else
+		size = page_size;
+
+	if (posix_memalign(&tmp, size, size))
 		return ENOMEM;
 
-	ret = madvise(tmp, page_size, MADV_DONTFORK) ||
-	      madvise(tmp, page_size, MADV_DOFORK);
+	ret = madvise(tmp, size, MADV_DONTFORK) ||
+	      madvise(tmp, size, MADV_DOFORK);
 
 	free(tmp);
 
@@ -446,11 +488,51 @@ static struct ibv_mem_node *__mm_find_st
 	return node;
 }
 
+static int is_huge_page(void *base)
+{
+	int ret = 0;
+	pid_t pid;
+	FILE *file;
+	char buf[1024], lib[128];
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
+				ret = 1;
+				break;
+			}
+		}
+	}
+	fclose(file);
+
+out:
+	return ret;
+}
+
 static int ibv_madvise_range(void *base, size_t size, int advice)
 {
 	uintptr_t start, end;
 	struct ibv_mem_node *node, *tmp;
-	int inc;
+	int inc, range_page_size;
 	int ret = 0;
 
 	if (!size)
@@ -458,9 +540,14 @@ static int ibv_madvise_range(void *base,
 
 	inc = advice == MADV_DONTFORK ? 1 : -1;
 
-	start = (uintptr_t) base & ~(page_size - 1);
-	end   = ((uintptr_t) (base + size + page_size - 1) &
-		 ~(page_size - 1)) - 1;
+	if (huge_page_size > page_size && is_huge_page(base))
+		range_page_size = huge_page_size;
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
