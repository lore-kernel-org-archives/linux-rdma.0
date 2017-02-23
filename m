From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 14/14] Remove the old barrier macros
Date: Thu, 23 Feb 2017 09:59:52 -0700
Message-ID: <20170223165952.GB6688@obsidianresearch.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1487272989-8215-15-git-send-email-jgunthorpe@obsidianresearch.com>
 <SN1PR07MB22070A48ACD50848267A5AD8F8530@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <SN1PR07MB22070A48ACD50848267A5AD8F8530-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 23, 2017 at 01:33:33PM +0000, Amrani, Ram wrote:
> >  /* Ensure that the device's view of memory matches the CPU's view of memory.
> > @@ -163,7 +78,25 @@
> >     memory types or non-temporal stores are required to use SFENCE in their own
> >     code prior to calling verbs to start a DMA.
> >  */
> > -#define udma_to_device_barrier() wmb()
> > +#if defined(__i386__)
> > +#define udma_to_device_barrier() asm volatile("" ::: "memory")
> > +#elif defined(__x86_64__)
> > +#define udma_to_device_barrier() asm volatile("" ::: "memory")
> > +#elif defined(__PPC64__)
> > +#define udma_to_device_barrier() asm volatile("sync" ::: "memory")
> > +#elif defined(__PPC__)
> > +#define udma_to_device_barrier() asm volatile("sync" ::: "memory")
> > +#elif defined(__ia64__)
> > +#define udma_to_device_barrier() asm volatile("mf" ::: "memory")
> > +#elif defined(__sparc_v9__)
> > +#define udma_to_device_barrier() asm volatile("membar #StoreStore" ::: "memory")
> > +#elif defined(__aarch64__)
> > +#define wmb() asm volatile("dsb st" ::: "memory");
> > +#elif defined(__sparc__) || defined(__s390x__)
> > +#define udma_to_device_barrier() asm volatile("" ::: "memory")
> > +#else
> > +#error No architecture specific memory barrier defines found!
> > +#endif
> 
> In the kernel wmb() translates, for x86_64, into 'sfence'.

Yes. Keep in mind the kernel wmb is doing something different, it is
basically defined as the strongest possible barrier that does SMP and
DMA strong ordering.

Based on this historical barrier in verbs the belief was apparently
that on x86 the order DMA observes stores is strictly in program order
for cachable memory. I have no idea if that is actually true or not..

> In user-space, however wmb, and now its "successor", udma_to_device_barrier,
> translate to volatile("" ::: "memory")

Yes :(

> What is the reasoning behind this?
> Why aren't the kernel and user space implementations the same?

I don't know. It is something that doesn't really make sense. Because
it is a weaker barrier user code using certain SSE stuff is going to
have to use SFENCE to be correct.

Arguably we should change it to be SFENCE.. Allowing that is why
I included the weaker udma_ordering_write_barrier..

I put this remark in the comments on udma_to_device_barrier:

   NOTE: x86 has historically used a weaker semantic for this barrier, and
   only fenced normal stores to normal memory. libibverbs users using other
   memory types or non-temporal stores are required to use SFENCE in their own
   code prior to calling verbs to start a DMA.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
