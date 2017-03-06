From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 07/14] mlx4: Update to use new udma write
 barriers
Date: Mon, 6 Mar 2017 10:31:39 -0700
Message-ID: <20170306173139.GA11805@obsidianresearch.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1487272989-8215-8-git-send-email-jgunthorpe@obsidianresearch.com>
 <206559e5-0488-f6d5-c4ec-bf560e0c3ba6@dev.mellanox.co.il>
 <20170221181407.GA13138@obsidianresearch.com>
 <45d2b7da-9ad6-6b37-d0b2-00f7807966b4@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <45d2b7da-9ad6-6b37-d0b2-00f7807966b4-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 06, 2017 at 04:57:40PM +0200, Yishai Hadas wrote:

> >Since there is no cost on x86-64 to this barrier I would like to leave
> >it here as it lets us actually optimize the ARM and other barriers. If
> >you take it out then 'udma_ordering_write_barrier' is forced to be the
> >strongest barrier on all arches.
> 
> Till we make the further optimizations, we suspect a performance degradation
> in other ARCH(s) rather than X86, as this patch introduce an extra barrier
> which wasn't before (i.e udma_to_device_barrier).

Yes, possibly.

The only other option I see is to change those couple of call sites in
mlx4 to be udma_to_device_barrier() - which looses the information
they are actually doing something different.

Honestly, I think if someone cares about the other arches they will
see a net win if the proper weak barrier is implemented for
udma_ordering_write_barrier

> >Even on x86, it is very questionable to not have the SFENCE in that
> >spot. AFAIK it is not defined to be strongly ordered.
> >
> >mlx5 has the SFENCE here, for instance.
> 
> We made some performance testing with the above change, initial results
> point on degradation of about 3% in the message rate in the above BlueFlame
> path in X86, this is something that we should prevent.
> 
> Based on below analysis it looks as the change to use 'mmio_wc_start()'
> which is mapped to SFENCE in X86 is redundant.

Okay, I think your analysis makes sense, and extending it broadly
means there is a fair amount of over-barriering on x86 in various
places.

For now, there are several places where this WC spinlock pattern is
used, so let us pull it out, here is an example, there are still other
places in the mlx drivers.

What do you think about this approach? Notice that it allows us to see
that mlx5 should be optimized to elide the leading SFENCE as
well. This should speed up mlx5 compared to the original.

diff --git a/providers/mlx4/qp.c b/providers/mlx4/qp.c
index 77a4a34576cb69..32f0b3fe78fe7c 100644
--- a/providers/mlx4/qp.c
+++ b/providers/mlx4/qp.c
@@ -481,15 +481,14 @@ out:
 		 * Make sure that descriptor is written to memory
 		 * before writing to BlueFlame page.
 		 */
-		mmio_wc_start();
+		mmio_wc_spinlock(&ctx->bf_lock);
 
 		++qp->sq.head;
 
-		pthread_spin_lock(&ctx->bf_lock);
-
 		mlx4_bf_copy(ctx->bf_page + ctx->bf_offset, (unsigned long *) ctrl,
 			     align(size * 16, 64));
-		mmio_flush_writes();
+
+		mmio_wc_spinunlock(&ctx->bf_lock);
 
 		ctx->bf_offset ^= ctx->bf_buf_size;
 
diff --git a/providers/mlx5/qp.c b/providers/mlx5/qp.c
index d7087d986ce79f..6187b85219dacc 100644
--- a/providers/mlx5/qp.c
+++ b/providers/mlx5/qp.c
@@ -931,11 +931,11 @@ out:
 
 		/* Make sure that the doorbell write happens before the memcpy
 		 * to WC memory below */
-		mmio_wc_start();
-
 		ctx = to_mctx(ibqp->context);
-		if (bf->need_lock)
-			mlx5_spin_lock(&bf->lock);
+		if (bf->need_lock && !mlx5_single_threaded)
+			mmio_wc_spinlock(&bf->lock->lock);
+		else
+			mmio_wc_start();
 
 		if (!ctx->shut_up_bf && nreq == 1 && bf->uuarn &&
 		    (inl || ctx->prefer_bf) && size > 1 &&
@@ -955,10 +955,11 @@ out:
 		 * the mmio_flush_writes is CPU local, this will result in the HCA seeing
 		 * doorbell 2, followed by doorbell 1.
 		 */
-		mmio_flush_writes();
 		bf->offset ^= bf->buf_size;
-		if (bf->need_lock)
-			mlx5_spin_unlock(&bf->lock);
+		if (bf->need_lock && !mlx5_single_threaded)
+			mmio_wc_spinunlock(&bf->lock->lock);
+		else
+			mmio_flush_writes();
 	}
 
 	mlx5_spin_unlock(&qp->sq.lock);
diff --git a/util/udma_barrier.h b/util/udma_barrier.h
index 9e73148af8d5b6..ea4904d28f6a48 100644
--- a/util/udma_barrier.h
+++ b/util/udma_barrier.h
@@ -33,6 +33,8 @@
 #ifndef __UTIL_UDMA_BARRIER_H
 #define __UTIL_UDMA_BARRIER_H
 
+#include <pthread.h>
+
 /* Barriers for DMA.
 
    These barriers are expliclty only for use with user DMA operations. If you
@@ -222,4 +224,26 @@
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
+static inline void mmio_wc_spinunlock(pthread_spinlock_t *lock)
+{
+	/* On x86 the lock is enough for strong ordering, but the SFENCE
+	 * encourages the WC buffers to flush out more quickly (Yishai:
+	 * confirm?) */
+	mmio_flush_writes();
+	pthread_spin_unlock(lock);
+}
+
 #endif
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
