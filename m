From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 07/14] mlx4: Update to use new udma write
 barriers
Date: Tue, 7 Mar 2017 12:18:24 -0700
Message-ID: <20170307191824.GD2228@obsidianresearch.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1487272989-8215-8-git-send-email-jgunthorpe@obsidianresearch.com>
 <206559e5-0488-f6d5-c4ec-bf560e0c3ba6@dev.mellanox.co.il>
 <20170221181407.GA13138@obsidianresearch.com>
 <45d2b7da-9ad6-6b37-d0b2-00f7807966b4@dev.mellanox.co.il>
 <20170306173139.GA11805@obsidianresearch.com>
 <55bcc87e-b059-65df-8079-100120865ffb@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55bcc87e-b059-65df-8079-100120865ffb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 07, 2017 at 06:44:55PM +0200, Yishai Hadas wrote:

> >Honestly, I think if someone cares about the other arches they will
> >see a net win if the proper weak barrier is implemented for
> >udma_ordering_write_barrier
> 
> We can't allow any temporary degradation and rely on some future
> improvements, it must come together and be justified by some performance
> testing.

Well, I haven't sent any changes to the barrier macros, until we get
everyone happy with them, but they exist.. I've included a few lines
in the patch below.

This *probably* makes ppc faster, if you leave the mlx4 stuff as-is,
as it replaces some hwsync with lwsync

Notice the use of atomic_thread_fence also produces more optimal
compiler output with new compilers since it is a much weaker impact to
the memory model that asm ("" ::: "memory"). Eg for mlx4_post_send
this results in less stack traffic and 15 bytes less in the function
for x86-64.

If that shows a performance win, let us keep it as is?

> I'll send some patch that will drop the leading udma_to_device_barrier() and
> replace udma_ordering_write_barrier() to be udma_to_device_barrier(), this
> will be done as part of the other change that is expected here, see below.

Sure, but lets have two patches so we can revert it..

> The below patch makes sense, however, need to be fixed in few points, see
> below. I'll fix it and take it in-house to our regression and performance
> systems, once approved will sent it upstream.

Okay, thanks for working on this!

> >-		pthread_spin_lock(&ctx->bf_lock);
> >-
> > 		mlx4_bf_copy(ctx->bf_page + ctx->bf_offset, (unsigned long *) ctrl,
> > 			     align(size * 16, 64));
> >-		mmio_flush_writes();
> >+
> >+		mmio_wc_spinunlock(&ctx->bf_lock);
> 
> We still should be under the spinlock, see below note, we expect here only a
> mmio_flush_writes() so this macro is not needed at all.

Right sorry, I just made a quick sketch to see if you like it.

> >+static inline void mmio_wc_spinunlock(pthread_spinlock_t *lock)
> >+{
> >+	/* On x86 the lock is enough for strong ordering, but the SFENCE
> >+	 * encourages the WC buffers to flush out more quickly (Yishai:
> >+	 * confirm?) */
> 
> This macro can't do both and should be dropped, see above.

I don't understand this comment? Why can't it do both? The patch below
shows the corrected version, perhaps it is clearer.

The intended guarentee of the wc_spinlock critical region is that:

   mmio_wc_spinlock();
   *wc_mem = 1;
   mmio_wc_spinunlock();

   mmio_wc_spinlock();
   *wc_mem = 2;
   mmio_wc_spinunlock();

Must *always* generate two TLPs, and *must* generate the visible TLPs in CPU
order of acquiring the spinlock - even if the two critical sections
are run on concurrently on different CPUs.

This is needed to consistently address the risk identified in mlx5:

		/*
		 * use mmio_flush_writes() to ensure write combining buffers are flushed out
		 * of the running CPU. This must be carried inside the spinlock.
		 * Otherwise, there is a potential race. In the race, CPU A
		 * writes doorbell 1, which is waiting in the WC buffer. CPU B
		 * writes doorbell 2, and it's write is flushed earlier. Since
		 * the mmio_flush_writes is CPU local, this will result in the HCA seeing
		 * doorbell 2, followed by doorbell 1.
		 */

We cannot provide these invariant without also providing
mmio_wc_spinunlock()

If for some reason that doesn't work for you then we should not use
the approach of wrappering the spinlock.

Anyhow, here is the patch that summarizes everything in this email:

diff --git a/providers/mlx4/qp.c b/providers/mlx4/qp.c
index 77a4a34576cb69..a22fca7c6f1360 100644
--- a/providers/mlx4/qp.c
+++ b/providers/mlx4/qp.c
@@ -477,23 +477,20 @@ out:
 		ctrl->owner_opcode |= htonl((qp->sq.head & 0xffff) << 8);
 
 		ctrl->bf_qpn |= qp->doorbell_qpn;
+		++qp->sq.head;
+
 		/*
 		 * Make sure that descriptor is written to memory
 		 * before writing to BlueFlame page.
 		 */
-		mmio_wc_start();
-
-		++qp->sq.head;
-
-		pthread_spin_lock(&ctx->bf_lock);
+		mmio_wc_spinlock(&ctx->bf_lock);
 
 		mlx4_bf_copy(ctx->bf_page + ctx->bf_offset, (unsigned long *) ctrl,
 			     align(size * 16, 64));
-		mmio_flush_writes();
 
 		ctx->bf_offset ^= ctx->bf_buf_size;
 
-		pthread_spin_unlock(&ctx->bf_lock);
+		mmio_wc_spinunlock(&ctx->bf_lock);
 	} else if (nreq) {
 		qp->sq.head += nreq;
 
diff --git a/providers/mlx5/qp.c b/providers/mlx5/qp.c
index d7087d986ce79f..0f1ec0ef2b094b 100644
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
+			mmio_wc_spinlock(&bf->lock.lock);
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
+			mmio_wc_spinunlock(&bf->lock.lock);
+		else
+			mmio_flush_writes();
 	}
 
 	mlx5_spin_unlock(&qp->sq.lock);
diff --git a/util/udma_barrier.h b/util/udma_barrier.h
index 9e73148af8d5b6..db4ff0c6c25376 100644
--- a/util/udma_barrier.h
+++ b/util/udma_barrier.h
@@ -33,6 +33,9 @@
 #ifndef __UTIL_UDMA_BARRIER_H
 #define __UTIL_UDMA_BARRIER_H
 
+#include <pthread.h>
+#include <stdatomic.h>
+
 /* Barriers for DMA.
 
    These barriers are expliclty only for use with user DMA operations. If you
@@ -78,10 +81,8 @@
    memory types or non-temporal stores are required to use SFENCE in their own
    code prior to calling verbs to start a DMA.
 */
-#if defined(__i386__)
-#define udma_to_device_barrier() asm volatile("" ::: "memory")
-#elif defined(__x86_64__)
-#define udma_to_device_barrier() asm volatile("" ::: "memory")
+#if defined(__i386__) || defined(__x86_64__)
+#define udma_to_device_barrier() atomic_thread_fence(memory_order_release)
 #elif defined(__PPC64__)
 #define udma_to_device_barrier() asm volatile("sync" ::: "memory")
 #elif defined(__PPC__)
@@ -115,7 +116,7 @@
 #elif defined(__x86_64__)
 #define udma_from_device_barrier() asm volatile("lfence" ::: "memory")
 #elif defined(__PPC64__)
-#define udma_from_device_barrier() asm volatile("lwsync" ::: "memory")
+#define udma_from_device_barrier() atomic_thread_fence(memory_order_acquire)
 #elif defined(__PPC__)
 #define udma_from_device_barrier() asm volatile("sync" ::: "memory")
 #elif defined(__ia64__)
@@ -149,7 +150,11 @@
       udma_ordering_write_barrier();  // Guarantee WQE written in order
       wqe->valid = 1;
 */
+#if defined(__i386__) || defined(__x86_64__) || defined(__PPC64__) || defined(__PPC__)
+#define udma_ordering_write_barrier() atomic_thread_fence(memory_order_release)
+#else
 #define udma_ordering_write_barrier() udma_to_device_barrier()
+#endif
 
 /* Promptly flush writes to MMIO Write Cominbing memory.
    This should be used after a write to WC memory. This is both a barrier
@@ -222,4 +227,37 @@
 */
 #define mmio_ordered_writes_hack() mmio_flush_writes()
 
+/* Write Combining Spinlock primitive
+
+   Any access to a multi-value WC region must ensure that multiple cpus do not
+   write to the same values concurrently, these macros make that
+   straightforward and efficient if the choosen exclusion is a spinlock.
+
+   The spinlock guarantees that the WC writes issued within the critical
+   section are made visible as TLP to the device. The TLP must seen by the
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
