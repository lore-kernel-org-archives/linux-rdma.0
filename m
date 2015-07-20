From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Mon, 20 Jul 2015 11:00:33 -0600
Message-ID: <20150720170033.GA20350@obsidianresearch.com>
References: <559F8BD1.9080308@dev.mellanox.co.il>
 <55AB3976.7060202@dev.mellanox.co.il>
 <20150720161821.GA18336@obsidianresearch.com>
 <55AD2188.50708@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55AD2188.50708-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 20, 2015 at 07:27:52PM +0300, Sagi Grimberg wrote:
> >>I'm thinking now that this should have an input argument
> >>of block_size. Maybe in the future ULPs would want to register
> >>huge pages, it will be a shame to map it into PAGE_SIZE chunks...
> >
> >Why wouldn't it just transparently support huge pages? sg seems to
> >have enough information.
> 
> I'm not sure I know how to do that, can you explain how please?

Scan the scatter list, if the pages are all the same length and
aligned on their length then that is the huge page size, otherwise use
4k.

Convert to a shift.

See if the driver supports that as a huge page size (currently
missing from our driver API).

Fill in the wr as you'd expect using the computed value as
wr.fast_reg.page_shift

Really, today nothing can use huge pages with IB_WR_FAST_REG_MR
because there is no way to negotiate with the driver the supported
page shift values. Hopefully your new version can get closer to
fixing that by taking the wr construction away from the caller.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
