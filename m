From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 07/14] mlx4: Update to use new udma write
 barriers
Date: Thu, 9 Mar 2017 17:42:19 +0200
Message-ID: <4dcf0cea-3652-0df2-9d98-74e258e6170a@dev.mellanox.co.il>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1487272989-8215-8-git-send-email-jgunthorpe@obsidianresearch.com>
 <206559e5-0488-f6d5-c4ec-bf560e0c3ba6@dev.mellanox.co.il>
 <20170221181407.GA13138@obsidianresearch.com>
 <45d2b7da-9ad6-6b37-d0b2-00f7807966b4@dev.mellanox.co.il>
 <20170306173139.GA11805@obsidianresearch.com>
 <55bcc87e-b059-65df-8079-100120865ffb@dev.mellanox.co.il>
 <20170307191824.GD2228@obsidianresearch.com>
 <6571cf34-63b9-7b83-ddb0-9279e7e20fa9@dev.mellanox.co.il>
 <20170308215609.GB4109@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170308215609.GB4109-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/8/2017 11:56 PM, Jason Gunthorpe wrote:
> On Wed, Mar 08, 2017 at 11:27:51PM +0200, Yishai Hadas wrote:
>
>> As of that any command that needs the lock must be done before the
>> flush and delays the hardware from see the BF data immediately.
>
> The counter point is that the unlock macro can combine the WC flushing
> barrier with the spinlock atomics, reducing the amount of global
> fencing. If you remove the macro your remove that optimization.

The optimization is done as part of mmio_wc_spinlock() for X86, this 
macro is still used.

>
> Why not do this:
>
> -               mlx4_bf_copy(ctx->bf_page + ctx->bf_offset, (unsigned long *) ctrl,
> -                            align(size * 16, 64));
> -
> +               tmp_bf_offset = ctx->bf_offset;
>                 ctx->bf_offset ^= ctx->bf_buf_size;

The above 2 commands are still delaying the writing to the NIC comparing 
the original code where it was done in one command after mlx4_bf_copy().

> +               mlx4_bf_copy(ctx->bf_page + tmp_bf_offset, (unsigned long *) ctrl,
> +                            align(size * 16, 64));
>

The candidate mlx4 code will be as follows, similar logic will be in mlx5.

@@ -477,22 +474,18 @@ out:
                 ctrl->owner_opcode |= htonl((qp->sq.head & 0xffff) << 8);

                 ctrl->bf_qpn |= qp->doorbell_qpn;
+               ++qp->sq.head;
                 /*
                  * Make sure that descriptor is written to memory
                  * before writing to BlueFlame page.
                  */
-               mmio_wc_start();
-
-               ++qp->sq.head;
-
-               pthread_spin_lock(&ctx->bf_lock);
+               mmio_wc_spinlock(&ctx->bf_lock);

                 mlx4_bf_copy(ctx->bf_page + ctx->bf_offset, (unsigned
                              long *) ctrl, align(size * 16, 64));

		mmio_flush_writes();
                 ctx->bf_offset ^= ctx->bf_buf_size;
                 pthread_spin_unlock(&ctx->bf_lock);
         } else if (nreq) {
                 qp->sq.head += nreq;

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

     These barriers are explicitly only for use with user DMA 
operations. If you
@@ -222,4 +224,17 @@
  */
  #define mmio_ordered_writes_hack() mmio_flush_writes()

+/* Higher Level primitives */
+
+/* Do mmio_wc_start and grab a spinlock */
+static inline void mmio_wc_spinlock(pthread_spinlock_t *lock)
+{
+       pthread_spin_lock(lock);
+#if !defined(__i386__) && !defined(__x86_64__)
+       /* For x86 the serialization within the spin lock is enough to
+        * strongly order WC and other memory types. */
+       mmio_wc_start();
+#endif
+}
+
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
