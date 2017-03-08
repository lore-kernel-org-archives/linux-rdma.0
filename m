From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 07/14] mlx4: Update to use new udma write
 barriers
Date: Wed, 8 Mar 2017 14:56:09 -0700
Message-ID: <20170308215609.GB4109@obsidianresearch.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1487272989-8215-8-git-send-email-jgunthorpe@obsidianresearch.com>
 <206559e5-0488-f6d5-c4ec-bf560e0c3ba6@dev.mellanox.co.il>
 <20170221181407.GA13138@obsidianresearch.com>
 <45d2b7da-9ad6-6b37-d0b2-00f7807966b4@dev.mellanox.co.il>
 <20170306173139.GA11805@obsidianresearch.com>
 <55bcc87e-b059-65df-8079-100120865ffb@dev.mellanox.co.il>
 <20170307191824.GD2228@obsidianresearch.com>
 <6571cf34-63b9-7b83-ddb0-9279e7e20fa9@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6571cf34-63b9-7b83-ddb0-9279e7e20fa9-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 08, 2017 at 11:27:51PM +0200, Yishai Hadas wrote:

> As of that any command that needs the lock must be done before the
> flush and delays the hardware from see the BF data immediately.

The counter point is that the unlock macro can combine the WC flushing
barrier with the spinlock atomics, reducing the amount of global
fencing. If you remove the macro your remove that optimization.

Why not do this:

-               mlx4_bf_copy(ctx->bf_page + ctx->bf_offset, (unsigned long *) ctrl,
-                            align(size * 16, 64));
-
+               tmp_bf_offset = ctx->bf_offset;
                ctx->bf_offset ^= ctx->bf_buf_size;
+               mlx4_bf_copy(ctx->bf_page + tmp_bf_offset, (unsigned long *) ctrl,
+                            align(size * 16, 64));
 
Which lets the load/store/xor run concurrently with filling of the write
buffer.

> Similar logical issue might be with the mmio_wc_spinlock macro in case the
> driver wants to make some command after the lock before the start_mmio,

I think you've missed the point. The idea is to combine the required
barrier for DMA with the required barrier for the spinlock. We can't
do that if we allow code to run between those steps.

> >diff --git a/providers/mlx4/qp.c b/providers/mlx4/qp.c
> >index 77a4a34576cb69..a22fca7c6f1360 100644
> >+++ b/providers/mlx4/qp.c
> >@@ -477,23 +477,20 @@ out:
> > 		ctrl->owner_opcode |= htonl((qp->sq.head & 0xffff) << 8);
> >
> > 		ctrl->bf_qpn |= qp->doorbell_qpn;
> >+		++qp->sq.head;
> >+
> 
> This is a change comparing the original code where was wmb() before that
> line to enforce the compiler not to change the order so that
> ctrl->owner_opcode will get the correct value of sq.head.

My reading was that the placement was not relevant, all access to
sq.head appears to be protected by pthread_spin_lock(&qp->sq.lock);

And sq.head is not DMA memory.

So ctrl->owner_opcode will get the correct value in both cases.

Just a few lines down we see:

		qp->sq.head += nreq;
		udma_to_device_barrier();

So there is a bug or the order doesn't matter.

> Will add here udma_to_device_barrier() which logically expects to do the
> same.

These new barriers are *only* for DMA memory. If it is the case that
qp->sq.head is being accessed concurrently without locking then it
*must* be converted to use stdatomic which provides the necessary
arch specific fencing.

> > 		ctx = to_mctx(ibqp->context);
> >-		if (bf->need_lock)
> >-			mlx5_spin_lock(&bf->lock);
> >+		if (bf->need_lock && !mlx5_single_threaded)
> 
> Can consider some pre-patch which will encapsulate the mlx5_single_threaded
> flag into the bf->need lock, it will prevent the extra if statement that
> this new code introduced in the data path.

Yes, I was thinking the same

> >+	/* On x86 the lock is enough for strong ordering, but the SFENCE
> >+	 * encourages the WC buffers to flush out more quickly (Yishai:
> >+	 * confirm?) */
> >+	mmio_flush_writes();
> >+	pthread_spin_unlock(lock);
> 
> See above comment on that.

The question here is if the atomic store inside pthread_spin_unlock is
enough to promptly flush the WC buffer. If so we should drop the
SFENCE for x86 and this will overall be faster.

It is the same reasoning you presented as to why we are able to drop
the SFENCE on the spin lock acquire.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
