From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/3] verbs: Add mmio_wc_spinlock barrier
Date: Mon, 13 Mar 2017 11:00:03 -0600
Message-ID: <20170313170003.GC25664@obsidianresearch.com>
References: <1489416829-15467-1-git-send-email-yishaih@mellanox.com>
 <1489416829-15467-2-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1489416829-15467-2-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 13, 2017 at 04:53:47PM +0200, Yishai Hadas wrote:
> From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> 
> For x86 the serialization within the spin lock is enough to
> strongly order WC and other memory types.
> 
> Add a new barrier named 'mmio_wc_spinlock' to optimize
> that.

Please use this patch with the commentary instead:

diff --git a/util/udma_barrier.h b/util/udma_barrier.h
index 9e73148af8d5b6..cfe0459d7f6fff 100644
--- a/util/udma_barrier.h
+++ b/util/udma_barrier.h
@@ -33,6 +33,8 @@
 #ifndef __UTIL_UDMA_BARRIER_H
 #define __UTIL_UDMA_BARRIER_H
 
+#include <pthread.h>
+
 /* Barriers for DMA.
 
    These barriers are expliclty only for use with user DMA operations. If you
@@ -222,4 +224,37 @@
 */
 #define mmio_ordered_writes_hack() mmio_flush_writes()
 
+/* Write Combining Spinlock primitive
+
+   Any access to a multi-value WC region must ensure that multiple cpus do not
+   write to the same values concurrently, these macros make that
+   straightforward and efficient if the choosen exclusion is a spinlock.
+
+   The spinlock guarantees that the WC writes issued within the critical
+   section are made visible as TLP to the device. The TLP must be seen by the
+   device strictly in the order that the spinlocks are acquired, and combining
+   WC writes between different sections is not permitted.
+
+   Use of these macros allow the fencing inside the spinlock to be combined
+   with the fencing required for DMA.
+ */
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
+static inline void mmio_wc_spinunlock(pthread_spinlock_t *lock)
+{
+	/* It is possible that on x86 the atomic in the lock is strong enough
+	 * to force-flush the WC buffers quickly, and this SFENCE can be
+	 * omitted too. */
+	mmio_flush_writes();
+	pthread_spin_unlock(lock);
+}
+
 #endif
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
