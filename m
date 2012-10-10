From: Isaac Huang <he.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: (R)DMA in userspace
Date: Wed, 10 Oct 2012 01:36:08 -0600
Message-ID: <20121010073608.GA1342@intel.com>
References: <OF84B00CFA.7F1CDA02-ONC1257A94.00545627-C1257A94.0055881A@ch.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <OF84B00CFA.7F1CDA02-ONC1257A94.00545627-C1257A94.0055881A-Xeyd2O9EBijQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Animesh K Trivedi1 <ZRLATR-Xeyd2O9EBijQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I looked at a similar problem a while back, and it seemed that none of
the IB HW drivers implemented the sync_single_for_[cpu|device] DMA
operations. Maybe I missed some code, but if it's true, then the
dma_sync_* functions would be no-ops on IB devices. Probably cache
coherence was guaranteed somewhere else?

It seemed that PCIe root complex could manage cache coherence for PCIe
requests, e.g. by reading directly from host CPU cache.

Thanks,
Isaac

On Thu, Oct 11, 2012 at 05:34:06PM +0200, Animesh K Trivedi1 wrote:
> 
> Hi all,
> 
> It is a curiosity question rather a bug/issue report.
> 
> Linux DMA subsystem wants streaming DMA buffers to be synchronized before
> accessing them. This is
> achieved by calling dma_sync_*  family of functions. And, I see that these
> functions are used in kernel clients
> (e.g. xprtrdma, and iSER). This is all fine.
> 
> During memory memory registration, userspace buffers also go through same
> API calls (dma_map_sg_attrs(...)).
> What I am confused about why no such synchronization primitives are
> required in userspace before accessing
> an RDMA data buffer just after when an incoming write/recv (DMA on it) is
> finished? Who guarantees data
> freshness?
> 
> Thanks,
> --
> Animesh
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
