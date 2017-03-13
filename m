From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 1/3] verbs: Add mmio_wc_spinlock barrier
Date: Mon, 13 Mar 2017 16:53:47 +0200
Message-ID: <1489416829-15467-2-git-send-email-yishaih@mellanox.com>
References: <1489416829-15467-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489416829-15467-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

For x86 the serialization within the spin lock is enough to
strongly order WC and other memory types.

Add a new barrier named 'mmio_wc_spinlock' to optimize
that.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 util/udma_barrier.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/util/udma_barrier.h b/util/udma_barrier.h
index 9e73148..ec14dd3 100644
--- a/util/udma_barrier.h
+++ b/util/udma_barrier.h
@@ -33,6 +33,8 @@
 #ifndef __UTIL_UDMA_BARRIER_H
 #define __UTIL_UDMA_BARRIER_H
 
+#include <pthread.h>
+
 /* Barriers for DMA.
 
    These barriers are expliclty only for use with user DMA operations. If you
@@ -222,4 +224,17 @@
 */
 #define mmio_ordered_writes_hack() mmio_flush_writes()
 
+/* Higher Level primitives */
+
+/* Do mmio_wc_start and grab a spinlock */
+static inline void mmio_wc_spinlock(pthread_spinlock_t *lock)
+{
+	pthread_spin_lock(lock);
+#if !defined(__i386__) && !defined(__x86_64__)
+	/* For x86 the serialization within the spin lock is enough to
+	 * strongly order WC and other memory types. */
+	mmio_wc_start();
+#endif
+}
+
 #endif
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
