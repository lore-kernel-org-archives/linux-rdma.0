From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Mon, 20 Jul 2015 13:50:27 -0600
Message-ID: <20150720195027.GA24162@obsidianresearch.com>
References: <559F8BD1.9080308@dev.mellanox.co.il>
 <55AB3976.7060202@dev.mellanox.co.il>
 <20150720161821.GA18336@obsidianresearch.com>
 <55AD2188.50708@dev.mellanox.co.il>
 <20150720170033.GA20350@obsidianresearch.com>
 <55AD2AB4.8010209@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55AD2AB4.8010209-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 20, 2015 at 08:07:00PM +0300, Sagi Grimberg wrote:
> On 7/20/2015 8:00 PM, Jason Gunthorpe wrote:
> >On Mon, Jul 20, 2015 at 07:27:52PM +0300, Sagi Grimberg wrote:
> >>>>I'm thinking now that this should have an input argument
> >>>>of block_size. Maybe in the future ULPs would want to register
> >>>>huge pages, it will be a shame to map it into PAGE_SIZE chunks...
> >>>
> >>>Why wouldn't it just transparently support huge pages? sg seems to
> >>>have enough information.
> >>
> >>I'm not sure I know how to do that, can you explain how please?
> >
> >Scan the scatter list, if the pages are all the same length and
> >aligned on their length then that is the huge page size, otherwise use
> >4k.
> 
> Bleh... seems like a great effort just to find that out. Isn't it
> better to just ask for a page_size arg?

So who computes page_size and how? Don't just punt things to a caller
without really explaining how the caller is supposed to use it
correctly.

For a value like this, it is a property of the scatter list. It should
either be computed when the scatterlist is created, or computed when
the scatterlist is passed to the HW.

Since IB is probably the only driver that would need to compute this,
then IB should do it at the driver level, and not burden the block
layer/etc with useless work.

Unless you think the ULP can get the same value faster..

> It not missing, we have device attribute page_size_cap which is
> a bitmask of supported page shifts (if I'm not mistaken).

Hum. That is what it should be..

Some drivers are wrong:

#define C2_MIN_PAGESIZE  1024
drivers/infiniband/hw/amso1100/c2_rnic.c:       props->page_size_cap       = ~(C2_MIN_PAGESIZE-1);

Many set it to PAGE_SIZE, which seems bonkers:

drivers/infiniband/hw/usnic/usnic_ib_verbs.c:   props->page_size_cap = USNIC_UIOM_PAGE_SIZE;
drivers/infiniband/hw/usnic/usnic_uiom.h:#define USNIC_UIOM_PAGE_SIZE           (PAGE_SIZE)
drivers/infiniband/hw/ipath/ipath_verbs.c:      props->page_size_cap = PAGE_SIZE;
drivers/infiniband/hw/qib/qib_verbs.c:  props->page_size_cap = PAGE_SIZE;

mlx5 seems to support only 1 page size, Sagi: I assume that needs fixing?

drivers/infiniband/hw/mlx5/main.c:      props->page_size_cap       = 1ull << MLX5_CAP_GEN(mdev, log_pg_sz);

ocrdma,cxgb4,mlx4,mhtca look pretty good, and support various huge
pages.

> It is negotiable. Most drivers don't negotiate it though... srp is
> the only one who does it.

Well SRP does this:

drivers/infiniband/ulp/srp/ib_srp.c:    mr_page_shift           = max(12, ffs(dev_attr->page_size_cap) - 1);
drivers/infiniband/ulp/srp/ib_srp.c:    srp_dev->mr_page_size   = 1 << mr_page_shift;

So it always uses 4096 on supported IB hardware and no huge page
support is enabled. This seems like the wrong way to use
page_size_cap...

Hopefully moving SRP to your new API will fix that.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
