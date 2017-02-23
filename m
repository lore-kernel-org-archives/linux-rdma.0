From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 12/14] qedr: Update to use new udma write
 barriers
Date: Thu, 23 Feb 2017 10:30:47 -0700
Message-ID: <20170223173047.GC6688@obsidianresearch.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1487272989-8215-13-git-send-email-jgunthorpe@obsidianresearch.com>
 <SN1PR07MB2207DE206738E6DD8511CEA1F8530@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <SN1PR07MB2207DE206738E6DD8511CEA1F8530-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 23, 2017 at 01:49:47PM +0000, Amrani, Ram wrote:
> Thanks, Jason, for this work.
> 
> Per this change, I don't see any need in using mmio_wc_start() in
> qedr.

The required pattern when dealing with WC memory is this:

 mmio_wc_start();
 writel_to_wc(..);
 mmio_flush_writes();

On x86-64 this translates to

 sfence
 mov ..
 sfence

As far as I know, on x86-64 both sfences are required to ensure that
all stores are visible to the device in strictly program order. x86-64
does not strongly order accesses to WC relative to other memory types
without SFENCE.

mmio_wc_start() is defined to be a superset of the functionality of
udma_to_device_barrier() - and it is given a unique name to make it
very clear where to use it: directly before writing to WC memory.

> wmb() is invoked to make sure that the CPU doesn't issue the
> doorbell before the data was flushed (that's why I expected its
> implementation to be as the kernel's i.e. sfence. See e-mail

Exactly. mmio_wc_start() is defined as the barrier to do that.  It
specifically guarentees that all writes to C and UC memory are ordered
before upcoming writes to WC memory.

It is SFENCE on x86-64, which as you say, is what you expected in the
first place, so this fixes a bug :\..

FWIW the

#define mmio_wc_start() mmio_flush_writes()

Is just a stand in that happens to get a safe instruction on every
arch.

If required each of the macros could have a unique implementation if
the arch requires it, however in most cases I would expect that
udma_to_device_barrier(), mmio_flush_writes() and mmio_wc_start() are
the same instruction.

The use of different names is a purely descriptive to aid in
understanding what the barriers do and when to use them.

Does that address your concern?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
