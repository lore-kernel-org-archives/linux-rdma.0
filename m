From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH 00/16] IB/hfi1: Add a page pinning cache for PSM sdma
Date: Thu, 10 Mar 2016 06:56:09 +0200
Message-ID: <20160310045609.GC1977@leon.nu>
References: <20160308191210.30542.91885.stgit@scvm10.sc.intel.com>
 <CAJ3xEMj8gz6Xw1bqA677fC8=U2ktLQ6b4W20SeNrztN7u6UKZg@mail.gmail.com>
 <20160309002157.GA20105@phlsvsds.ph.intel.com>
 <20160309050731.GM13396@leon.nu>
 <20160309192109.GB15031@phlsvsds.ph.intel.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160309192109.GB15031-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 09, 2016 at 02:21:10PM -0500, Dennis Dalessandro wrote:
> On Wed, Mar 09, 2016 at 07:07:31AM +0200, Leon Romanovsky wrote:
> >On Tue, Mar 08, 2016 at 07:21:58PM -0500, Dennis Dalessandro wrote:
> >>On Tue, Mar 08, 2016 at 10:56:48PM +0200, Or Gerlitz wrote:
> >>>On Tue, Mar 8, 2016 at 9:14 PM, Dennis Dalessandro
> >>><dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> >>>
> >>>>This patch series adds a performance improvement to user SDMA transfers from
> >>>>PSM applications by caching user buffer pages after pinning them. Subsequent
> >>>>uses of the same user buffer will not incur the cost of pinning the same pages
> >>>>again. Additionally, the cost of unpinning the same pages is avoided.  Buffer
> >>>>pages are unpinned when the context is torn down or when the driver determines
> >>>>that the buffer should be evicted from the cache. Cache evictions happen when
> >>>>there is a request for a new, uncached buffer and the current size of the cache
> >>>>has reached a pre-defined limit.
> >>>
> >>>If indeed there's a need for such a pin down cache, it should have
> >>>been implemented in the IB core, b/c both the problem and the solution
> >>>are generic and have nothing to do with certain device driver.
> >>
> >>Since this is for psm it has nothing to do with the IB core. I fail to see
> >>what that would achieve.
> >
> >I tend to agree with Or, your proposal goes far beyond the driver code.
> >Do you expect that all drivers which will be needed to support PSM will
> >implement (copy/paste) the same generic logic?
> 
> We should not be putting something which is specific to PSM in the IB core.
> We feel the driver is the most appropriate place for this.

To use cache logic - yes
To implement cache logic - no

Can you share with us the technical justification of implementing general
memory management cache mechanism in driver and not in appropriate layer
(IB/core and/or MM)?

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
