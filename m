From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [ewg] [ANNOUNCE] OFED 4.8-rc2 release is available
Date: Thu, 4 May 2017 11:41:05 -0600
Message-ID: <20170504174105.GB20449@obsidianresearch.com>
References: <590096A3.5090107@dev.mellanox.co.il>
 <20170427070657.GA13585@infradead.org>
 <20170504084933.GA1359@infradead.org>
 <9C6B67F36DCAFC479B1CF6A967258A8C7E953FA6@ORSMSX115.amr.corp.intel.com>
 <20170504153003.GA854@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB1199FA@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB1199FA-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 04, 2017 at 05:34:35PM +0000, Hefty, Sean wrote:
> > This is exactly why we so strongly discourage this out of tree stuff -
> > getting something unmergable in OFED is *NOT* Job Done, Time to Go
> > Home. Down this path just creates another Lustre mess.
> 
> Actually, this may be 'job done'.  No individual or company is
> obligated to provide upstream software for any of their hardware.
> OFA decides what to ship in their software products, not the greater
> linux kernel community.

The founding imputus for OFA was to get this RDMA code upstream, so
OFA should not be spending their resources supporting non-upstream
works.

> Individual companies can decide if out of tree maintenance is more
> cost effective than trying to merge code upstream.  Because that's
> what this ultimately comes down to.

Sure. Outside the OFA and its works please.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
