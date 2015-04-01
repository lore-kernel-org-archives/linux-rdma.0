From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] ib_ipoib: Scatter-Gather support in connected mode
Date: Wed, 1 Apr 2015 13:17:19 -0400
Message-ID: <20150401171708.GA21266@phlsvsds.ph.intel.com>
References: <1422357682-8934-1-git-send-email-yuval.shaia@oracle.com> <1422444987.3133.81.camel@opteya.com> <20150201070941.GA4778@yuval-lab> <20150315151616.GA3546@yuval-lab> <20150322092149.GA5229@yuval-lab> <20150323171749.GA3580@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150323171749.GA3580-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 23, 2015 at 11:17:49AM -0600, Jason Gunthorpe wrote:
> On Sun, Mar 22, 2015 at 11:21:50AM +0200, Yuval Shaia wrote:
> > On Sun, Mar 15, 2015 at 05:16:16PM +0200, Yuval Shaia wrote:
> > > Hi,
> > > I didn't got any further comments on this one.
> > > Any idea why SG in CM is un-welcome?
> > By mistake I sent a private mail only.
> > Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > 
> > Your advice would be very appreciated.
> 
> I haven't looked in detail at the patch, but in principle, using S/G
> when ever possible should be the default, even if this creates a
> performance regression.
> 
> It is well known that high order allocations are problematic in Linux
> and should be avoided, and I also have seen systems blow up because of
> high order IPoIB allocations.
> 
> That said, there may be cases where S/G is not possible, you should
> try and get Mellanox to comment if all their offloads work on all
> their cards when S/G is used. Work may be required to resolve any of
> these constraints. I'd like to belive there is some reason why we've
> been doing high order allocations for so many years.
> 
> FWIW, I would probably choose to default S/G over any other offload
> acceleration.

I concur with Jason's assessment.

As Yann asked before:

What hardware have you tested this on?  Do you have any performance
measurements?  Or do you have a reproducer for some of the allocation issues
which have been seen?

I can't comment on how this may affect Mellanox Hardware but it seems like it
will work fine with Qib hardware.

Ira


> 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
