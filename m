From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC] libibverbs: add ARM64 memory barrier macros
Date: Thu, 19 May 2016 12:05:52 -0600
Message-ID: <20160519180552.GA26130@obsidianresearch.com>
References: <20160518220302.81260E09E9@smtp.ogc.us>
 <20160518222857.GB23835@obsidianresearch.com>
 <060701d1b1e7$dc7e1ff0$957a5fd0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <060701d1b1e7$dc7e1ff0$957a5fd0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 19, 2016 at 11:02:36AM -0500, Steve Wise wrote:

> Looking at the documentation, it is not clear to me which parameter value passed
> to atomic_thread_fence() maps to each of the mb services.  Is it correct to
> think that if I get it right, the resulting assembly should be what we currently
> have for the mb services?

You can review

https://www.cl.cam.ac.uk/~pes20/cpp/cpp0xmappings.html

Hurm.

So, I'd say libibverbs is kinda broken here, as it is using a model
that is different from the kernel model. Sigh, it actually looks like
kinda a mess because provider libraries are abusing the primitives for
lots of different things. :(

This is the mapping that matches the definitions of the barriers:

 wmb can be memory_order_release
 rmb can be memory_order_acquire
 mb can be memory_order_seq_cst

On x86 this is similar as what we have today, but slightly less
explicit than the kernel model. Seems OK

On ARMv8 this would be DMB slightly weaker than the
kernel's DSB (My read suggests this is OK for PCI vs system memory
on coherent ARM?)

PPC will be lwsync not sync (not OK)

ia64 will both use mf for mb, but different otherwise (not OK)

No idea about the others.

C11 atomics are only specified for system memory to system memory,
they are undefined when working with device MMIO memory - this is why
some of the above are 'not OK'.

You could provide the above as the new default, maybe even use it on
some of the archs, like armv8/x86 if you think the dmb is OK.

An even better suggestion is to try and clean up some of this mess by
being more explicit:

 /* Guarentee all system memory writes are visible by the device
    before value's write is seen at the device */
 mmio_barrier_write32(void *ptr, uint32_t value);

Most everything else can then safely use C11 atomics as it is not
working with device memory.

But that is too hard with all our providers sprinkled around in so
many git trees :(

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
