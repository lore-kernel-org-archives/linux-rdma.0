From: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [rdma-next 01/33] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Tue, 1 Aug 2017 11:21:35 -0500
Message-ID: <20170801162135.GA240@ctung-MOBL3.amr.corp.intel.com>
References: <20170801120536.540-1-leon@kernel.org>
 <20170801120536.540-2-leon@kernel.org>
 <20170801133832.GA11812@ctung-MOBL3.amr.corp.intel.com>
 <20170801141023.GM13672@mtr-leonro.local>
 <20170801141842.GA1808@ctung-MOBL3.amr.corp.intel.com>
 <alpine.DEB.2.20.1708010921490.16491@nuc-kabylake>
 <20170801151511.GA13376@ctung-MOBL3.amr.corp.intel.com>
 <1501600807.2475.4.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1501600807.2475.4.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org" <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 01, 2017 at 03:20:11PM +0000, Bart Van Assche wrote:
> On Tue, 2017-08-01 at 10:15 -0500, Chien Tin Tung wrote:
> > On Tue, Aug 01, 2017 at 09:22:47AM -0500, Christopher Lameter wrote:
> > > On Tue, 1 Aug 2017, Chien Tin Tung wrote:
> > > 
> > > > Why do I need to explain the original patch?  It was accepted many kernels
> > > > ago.  Your questions on the original were based on false assumptions and
> > > > facts which I've proven over and over.  You are right in that I do
> > > > not want to revisit those either.  There is a patch that can solve
> > > > the problem you are facing but yet you insist on the revert.  This is
> > > > very puzzling to me.  You simply refuse to move this forward.  That
> > > > is your choice but revert is a no go for me.
> > > 
> > > Ok this is pretty confusing to someone not involved in the prior
> > > discussions. Could both of your stop attacking each other and start
> > > talking about the technical issues?
> > 
> > There's been multiple threads over this revert.  This one is the
> > latest Leon walked away from: https://patchwork.kernel.org/patch/9814367/
> > 
> > I'm simply asking for proof/evidence/facts to back up Leon's claims.
> > Show me the code/stack trace/whatever and I will be happy to admit wrong
> > publicly on the list and move on.  I do have better things to do than
> > to NACK a revert.
> 
> Hello Chien,
> 
> What Leon wrote, namely that calls that send netlink data from kernel to user
> space should be non-blocking makes sense to me.

That's been addressed in so many emails I won't rehash.  If _no_one_ should
block (it is actually a one shot retry with a timeout) sending Netlink message
from kernel to user, why don't Leon or you patch that code out?  All of
it, not just ibnl_unicast().

> So please be more constructive than replying with "NAK".

I've sent so many emails (some you were CC'd), so I'm not sure how
much more constructive I can be.  BTW, did you see the one with my
attempt at world peace (https://www.spinics.net/lists/linux-rdma/msg50591.html)?

Here are the relevant threads for people that are interested in participating
in this discussion.

https://patchwork.kernel.org/patch/9814367/

https://patchwork.kernel.org/patch/9752855/

Chien
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
