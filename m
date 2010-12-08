From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: ibv_post_send/recv kernel path optimizations
Date: Wed, 8 Dec 2010 11:30:32 -0700
Message-ID: <20101208183032.GL16788@obsidianresearch.com>
References: <20101013091312.GB6060@bicker>
 <20101123071025.GI1522@bicker>
 <adahbf6gytv.fsf@cisco.com>
 <20101124221845.GH2369@obsidianresearch.com>
 <adad3pugi90.fsf@cisco.com>
 <20101125041337.GA11049@obsidianresearch.com>
 <4CEE7A22.2040706@voltaire.com>
 <BE2BFE91933D1B4089447C644860408064B44854@irsmsx503.ger.corp.intel.com>
 <4CF60343.7050602@voltaire.com>
 <BE2BFE91933D1B4089447C64486040806673CF38@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BE2BFE91933D1B4089447C64486040806673CF38-IGOiFh9zz4wLt2AQoY/u9bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 08, 2010 at 12:14:51PM +0000, Walukiewicz, Miroslaw wrote:
> Or, 
> 
> >I don't see why the ib uverbs flow (BTW - the data path has nothing to do with the 
> >rdma_cm, you're working with /dev/infiniband/uverbsX), can't be enhanced 
> >e.g to support shared-page which is allocated && mmaped from uverbs to 
> >user space and used in the same manner your implementation does.
> 
> The problem that I see is that the mmap is currently used for
> mapping of doorbell page in different drivers.
> 
> We can use it for mapping a page for transmit/receive operation when
> we are able to differentiate that we need to map Doorbell or our
> shared page.

There is the 64 bit file offset field to mmap which I think is
driver-specific. You could use 0 for the doorbell page, QPN*PAGE_SIZE
+ QPN_OFFSET for the per-QP page, etc..

> The second problem is that this rx/tx mmap should map the separate
> page per QP to avoid the unnecessary QP lookups so page identifier
> passed to mmap should be based on QP identifier.
> 
> I cannot find a specific code for /dev/infiniband/uverbsX. Is this
> device driver sharing the same functions like /dev/infiniband/rdmacm
> or it has own implementation.

It is in drivers/infiniband/core/uverbs*

For mmap the call is just routed to the driver's ib_dev mmap function,
so you can do whatever you want in your driver and match the
functionality in your userspace libibverbs driver library.

I think you should be able to implement your driver-specific
optimization within the uverbs framework - that would be best all
round.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
