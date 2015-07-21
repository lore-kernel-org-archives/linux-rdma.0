From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Tue, 21 Jul 2015 10:00:14 -0600
Message-ID: <20150721160014.GA25291@obsidianresearch.com>
References: <559F8BD1.9080308@dev.mellanox.co.il>
 <55AB3976.7060202@dev.mellanox.co.il>
 <20150720161821.GA18336@obsidianresearch.com>
 <55AD2188.50708@dev.mellanox.co.il>
 <20150720170033.GA20350@obsidianresearch.com>
 <55AD2AB4.8010209@dev.mellanox.co.il>
 <20150720195027.GA24162@obsidianresearch.com>
 <55AE2FA2.3000601@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55AE2FA2.3000601-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 21, 2015 at 02:40:18PM +0300, Sagi Grimberg wrote:

> I'd imagine that the ULP knows when it registers huge-pages.
> OK, I can scan the scatterlist and check it.

At some point in the stack.. Not necessarily in the IB ULP though..

It is something that can be reviewed when the API is done, if it can
be sped up by shifting stuff around..

> >So it always uses 4096 on supported IB hardware and no huge page
> >support is enabled. This seems like the wrong way to use
> >page_size_cap...
> >
> >Hopefully moving SRP to your new API will fix that.
> 
> I have no plans in attempting the try to find the biggest aligned
> page_size that is supported by the device.

It might be worth doing if there is a single sg entry that is 'big', 
but I don't think we have workloads like that today, someone else can
worry about that.. I'd probably just leave a note in a comment about
the possibility.

> I'm only going to check HUGE_PAGE, and if not aligned I'll use
> PAGE_SIZE and if that's not aligned - fail.

Seems reasonable.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
