From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 6/6] RDMA/core: Unify style of IOCTL commands
Date: Tue, 6 Sep 2016 15:19:59 -0600
Message-ID: <20160906211959.GA27106@obsidianresearch.com>
References: <1472738739.16467.8.camel@intel.com>
 <20160901164624.GC6479@obsidianresearch.com>
 <20160901165552.GE21847@leon.nu>
 <20160901170742.GA20098@obsidianresearch.com>
 <1472749767.16467.25.camel@intel.com>
 <20160901171129.GB19982@obsidianresearch.com>
 <1472750241.16467.29.camel@intel.com>
 <20160901173320.GB20472@obsidianresearch.com>
 <20160901175222.GF21847@leon.nu>
 <20160906210313.GA24527@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160906210313.GA24527-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 06, 2016 at 05:03:14PM -0400, ira.weiny wrote:

> These defines are _not_ used anywhere in the kernel but rather define a
> device specific command _offset_ within the drm vendor ioctl range.

That is not completely true, the defines are used when setting up the
kernel ioctl #. I have no idea why they did this, to me it is
polluting a uapi header with unneeded defines which is a big no-no.

Userspace should certainly *NEVER* use these constants, removing them
is the best way to achieve that.

> When we agreed that HFI1 would use an 0x80 offset I thought that was the
> idea.[*]  That IB would have an upper range which was device specific and HFI1
> would be the first users of that range.

I'd rather not have non-unique ioctls if we can avoid it......

But even if we do, removing these indirection constants does nothing to
change that - other drivers can still alias 0x80.

That is doable, particularly if the struct is a different size, then
we still have unique ioctl numbers. With some care other vendors can
probably manage...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
