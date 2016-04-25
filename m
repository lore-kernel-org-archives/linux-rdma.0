From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Further thoughts on uAPI
Date: Mon, 25 Apr 2016 14:53:41 -0600
Message-ID: <20160425205341.GC15367@obsidianresearch.com>
References: <20160420012526.GA25508@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB044043@ORSMSX109.amr.corp.intel.com>
 <20160421172428.GA5102@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB045101@ORSMSX109.amr.corp.intel.com>
 <20160425181953.GC7675@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB04548E@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB04548E-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: OFVWG <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 25, 2016 at 07:16:12PM +0000, Hefty, Sean wrote:
> > However, I had intended to use the object type carred in the ioctl arg
> > as the primary mux and the ioctl would just indicate the 'method'. The
> > method ID table would be split much like you describe:
> > 
> > 'core common' object routines
> > 'built-in extra' object routines
> > 'driver-fast-path' object routines
> 
> I did understand the proposal.  My main concern was that it appeared
> that it would result in a very large function array, potentially
> with a significant number of NULL functions, associated with each
> driver.

Well, one way or another we need to build an efficient dispatch
between method + object_type.

I do not think there will be alot of nulls, a major point of the
scheme was avoid that sort of problem.
 1) Only objects type id's that actually have functions would be
    allocated, unused object type ids cost 8 bytes.
 2) Each object has it's own function table array, and each array can
    be potentially be sized to the per-object maximum function
    ordinal. So minimal nulls here
 3) Assign function ordinal numbers and object_types in a way that
    promotes dense packing, eg not just 'top 128 are driver-specific',
    but a demand based mixture.
 4) The table is allocated per-device and there is a small number of
    devices, so even if it is a few kB it is not a meaningful overhead.

> > Why do you feel cm/mgmt needs dedicated routines? I was going to model
> > CM as more objects and use the 'built-in extra' block to make CM
> > object specific calls (eg bind/etc)
> 
> I separated the cm/mgmt calls because I doubt a driver will ever
> override them, and some of the calls are system wide, versus being
> bound to a driver.

Right, this same scheme would be mirrored on the system-wide cdev (aka
rdma_cm) for that need. hfi1 also has a part of their uAPI that needs
this same functionality. :|

I'd probably just run it through the same basic code and flag some
ojects as 'global OK' ?

> I had followed this, but wondered if it wouldn't be easier to just
> say, use structure 1 or structure 2.

I don't know for sure either.

It may be simple things use the same format with a 'fixed' layout with
the header and a single variable sized structure attribute, and works
the same as a v1/v2 scheme. A little bit of overhead for consistency.

Complex things handling addresses would probably need to be
multi-attribute.

Attributes are the natural way to pass driver specific information (eg
the udata), so I think a lot of the commands will actually turn out to
be multi-attribute naturally - I haven't done a study to see how often
this is used by drivers.

At first blush it does seem reasonable, as long as we don't go
overboard. Though, I am concerned about complexity parsing this kind
of structure - every time I've built something like this the	
parsing turns out to be a royal pain. But 'comp_mask' isn't much better.

> A lot of the need for this complexity seems driven by treating all
> QPs as a single object, rather than separate objects.  Making that
> change might simplify things..?

We can certainly look at this, but we have to be careful any change
can still be made to look like the current model by libibverbs with
100% fidelity.

> Also I think we should consider reasonable optimizations for
> connecting QPs.  Doug and I had to debug apps that broke because the
> connection process was not completing quick enough.

This was discussed on the call as well..

I suspect as soon as you go to the network with any kind of packet the
small differences in API marshalling techniques is unimportant. Do you
see otherwise?

The need to create large number of AH's in a loop was brought up for
UD applications.

In any event, it is better that a driver implement a driver-specific
command for things which are truely performance senstive. This would
let the driver wring out 100% of the possible performance.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
