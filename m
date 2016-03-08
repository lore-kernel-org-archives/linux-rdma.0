From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 13/16] IB/hfi1: Add pin query function
Date: Tue, 08 Mar 2016 11:15:28 -0800
Message-ID: <20160308191527.30542.76026.stgit@scvm10.sc.intel.com>
References: <20160308191210.30542.91885.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160308191210.30542.91885.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

System administrators can use the locked memory
ulimit setting to set the maximum amount of memory
a user can lock/pin. However, this setting alone is not
enough to guarantee good operation of the hfi1 driver
due to the fact that the setting does not have fine
enough granularity to account for the limit being used
by multiple user processes and caches.

Therefore, a better limiting algorithm is needed. This
is where the new hfi1_can_pin_pages() function and the
cache_size module parameter come in.

The function works by looking at the ulimit and cache_size
value to compute a cache size. The algorithm examines the
ulimit value and, if it is not "unlimited", computes a
per-cache limit based on the number of configured user
contexts.

After that, the lower of the two - cache_size and computed
per-cache limit - is used.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/hfi.h        |    1 +
 drivers/infiniband/hw/hfi1/user_pages.c |   52 +++++++++++++++++++++++++++----
 2 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 2107cdc..ff3b37a 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1664,6 +1664,7 @@ void shutdown_led_override(struct hfi1_pportdata *ppd);
  */
 #define DEFAULT_RCVHDR_ENTSIZE 32
 
+bool hfi1_can_pin_pages(struct hfi1_devdata *, u32, u32);
 int hfi1_acquire_user_pages(unsigned long, size_t, bool, struct page **);
 void hfi1_release_user_pages(struct page **, size_t, bool);
 
diff --git a/drivers/infiniband/hw/hfi1/user_pages.c b/drivers/infiniband/hw/hfi1/user_pages.c
index 3bf8108..bd7a8ab 100644
--- a/drivers/infiniband/hw/hfi1/user_pages.c
+++ b/drivers/infiniband/hw/hfi1/user_pages.c
@@ -48,22 +48,62 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/device.h>
+#include <linux/module.h>
 
 #include "hfi.h"
 
-int hfi1_acquire_user_pages(unsigned long vaddr, size_t npages, bool writable,
-			    struct page **pages)
+static unsigned long cache_size = 256;
+module_param(cache_size, ulong, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(cache_size, "Send and receive side cache size limit (in MB)");
+
+/*
+ * Determine whether the caller can pin pages.
+ *
+ * This function should be used in the implementation of buffer caches.
+ * The cache implementation should call this function prior to attempting
+ * to pin buffer pages in order to determine whether they should do so.
+ * The function computes cache limits based on the configured ulimit and
+ * cache size. Use of this function is especially important for caches
+ * which are not limited in any other way (e.g. by HW resources) and, thus,
+ * could keeping caching buffers.
+ *
+ */
+bool hfi1_can_pin_pages(struct hfi1_devdata *dd, u32 nlocked, u32 npages)
 {
-	unsigned long pinned, lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+	unsigned long ulimit = rlimit(RLIMIT_MEMLOCK), pinned, cache_limit,
+		size = (cache_size * (1UL << 20)); /* convert to bytes */
+	unsigned usr_ctxts = dd->num_rcv_contexts - dd->first_user_ctxt;
 	bool can_lock = capable(CAP_IPC_LOCK);
-	int ret;
+
+	/*
+	 * Calculate per-cache size. The calculation below uses only a quarter
+	 * of the available per-context limit. This leaves space for other
+	 * pinning. Should we worry about shared ctxts?
+	 */
+	cache_limit = (ulimit / usr_ctxts) / 4;
+
+	/* If ulimit isn't set to "unlimited" and is smaller than cache_size. */
+	if (ulimit != (-1UL) && size > cache_limit)
+		size = cache_limit;
+
+	/* Convert to number of pages */
+	size = DIV_ROUND_UP(size, PAGE_SIZE);
 
 	down_read(&current->mm->mmap_sem);
 	pinned = current->mm->pinned_vm;
 	up_read(&current->mm->mmap_sem);
 
-	if (pinned + npages > lock_limit && !can_lock)
-		return -ENOMEM;
+	/* First, check the absolute limit against all pinned pages. */
+	if (pinned + npages >= ulimit && !can_lock)
+		return false;
+
+	return ((nlocked + npages) <= size) || can_lock;
+}
+
+int hfi1_acquire_user_pages(unsigned long vaddr, size_t npages, bool writable,
+			    struct page **pages)
+{
+	int ret;
 
 	ret = get_user_pages_fast(vaddr, npages, writable, pages);
 	if (ret < 0)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
