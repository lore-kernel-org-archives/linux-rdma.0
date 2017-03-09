From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 07/14] mlx4: Update to use new udma write
 barriers
Date: Thu, 9 Mar 2017 10:03:20 -0700
Message-ID: <20170309170320.GA12694@obsidianresearch.com>
References: <1487272989-8215-8-git-send-email-jgunthorpe@obsidianresearch.com>
 <206559e5-0488-f6d5-c4ec-bf560e0c3ba6@dev.mellanox.co.il>
 <20170221181407.GA13138@obsidianresearch.com>
 <45d2b7da-9ad6-6b37-d0b2-00f7807966b4@dev.mellanox.co.il>
 <20170306173139.GA11805@obsidianresearch.com>
 <55bcc87e-b059-65df-8079-100120865ffb@dev.mellanox.co.il>
 <20170307191824.GD2228@obsidianresearch.com>
 <6571cf34-63b9-7b83-ddb0-9279e7e20fa9@dev.mellanox.co.il>
 <20170308215609.GB4109@obsidianresearch.com>
 <4dcf0cea-3652-0df2-9d98-74e258e6170a@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4dcf0cea-3652-0df2-9d98-74e258e6170a-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 09, 2017 at 05:42:19PM +0200, Yishai Hadas wrote:

> >The counter point is that the unlock macro can combine the WC flushing
> >barrier with the spinlock atomics, reducing the amount of global
> >fencing. If you remove the macro your remove that optimization.
> 
> The optimization is done as part of mmio_wc_spinlock() for X86, this macro
> is still used.

I'm talking about optimizing the unlock too.

The x86 definition probably requires the unlock to flush the WC
buffers just like for the lock, so avoiding the unlocking SFENCE
entirely will increase throughput further, but with a bit more latency
till flush.

> >Why not do this:
> >
> >-               mlx4_bf_copy(ctx->bf_page + ctx->bf_offset, (unsigned long *) ctrl,
> >-                            align(size * 16, 64));
> >-
> >+               tmp_bf_offset = ctx->bf_offset;
> >                ctx->bf_offset ^= ctx->bf_buf_size;
> 
> The above 2 commands are still delaying the writing to the NIC comparing the
> original code where it was done in one command after mlx4_bf_copy().

It so simple, look at the assembly, my version eliminates an extra
load, for instance. So we get once 'cycle' better on throughput and
one cycle worse on latency to SFENCE.

But.. This routine was obviously never written to optimize latency to
SFENCE, eg why isn't '++qp->sq.head;' pushed to after the SFENCE if
that is so important? But again, pushing it after will improve
latency, hurt throughput.

.. and if you are so concerned about latency to SFENCE you should be
super excited about the barrier changes I sent you, as those will
improve that by a few cycles also.

I honestly think you are trying far too much to pointlessly preserve
the exact original code...

If you want to wreck the API like this, I would rather do it supported
by actual numbers. Add some TSC measurements in this area and see what
the different scenarios cost.

IMHO this stuff is already hard enough, having a simple to use,
symmetric API is more valuable.

> +/* Higher Level primitives */

If you are going to send this a patch please include my updated
comment.

> +/* Do mmio_wc_start and grab a spinlock */
> +static inline void mmio_wc_spinlock(pthread_spinlock_t *lock)
> +{
> +       pthread_spin_lock(lock);
> +#if !defined(__i386__) && !defined(__x86_64__)
> +       /* For x86 the serialization within the spin lock is enough to
> +        * strongly order WC and other memory types. */
> +       mmio_wc_start();
> +#endif

I would like to see the unlock inline still present in the header for
clarity to the reader what the expected pattern is, and a comment in
mlx4/mlx5 indicating they are not using the unlock macro directly to
try and reduce latency to the flush.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
