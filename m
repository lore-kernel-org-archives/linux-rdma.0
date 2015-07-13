From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Sun, 12 Jul 2015 23:47:01 -0700
Message-ID: <20150713064701.GB31842@infradead.org>
References: <559F8BD1.9080308@dev.mellanox.co.il>
 <20150711103920.GE14741@infradead.org>
 <55A21DF6.6090909@dev.mellanox.co.il>
 <96901C8F-D916-4ECF-8DA4-C5C67FB8539E@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <96901C8F-D916-4ECF-8DA4-C5C67FB8539E-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 12, 2015 at 02:15:56PM -0400, Chuck Lever wrote:
> > Chuck, Would a scatterlist API make life easier for you?
> 
> No benefit for me.
> 
> The NFS upper layer already slices and dices I/O until it is a
> stream of contiguous single I/O requests for the server.
> 
> It passes down a vector of struct page pointers which xprtrdma?s
> memory registration logic has to walk through and convert into
> something the provider can deal with.
> 
> See fmr_op_map and frwr_op_map. The loop in there becomes costly
> as the number of pages involved in an I/O request increases.
> 
> I suppose an s/g list wouldn?t be much different from the current
> arrangement. And if NFS and SunRPC are the only users that deal
> with struct page, then there?s no code sharing benefit to
> providing a provider API based on struct page.

NFS really should be using something more similar to a scatterlist,
as it maps pretty well to the sk_frags in the network layer as well.

Struct scatterlist is imprtant because it's the way the DMA mapping
functions takes a multi-page argument, so ayone who wants to batch
the S/G mapping calls needs it.  It might be worthwhile to find a way
to replace the struct ib_sge argumets in the RDMA code with a
scatterlist separate key argument to simplify the calling conventions
and avoid the need to allocate two list.  Note that I think for IB and
IB-like transports we'll always use the same lkey anyway, and from what
I understood about iWarp it probably should generate the lkey as part
of it's dma mapping operations instead of relying on the ULD to generate
one.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
