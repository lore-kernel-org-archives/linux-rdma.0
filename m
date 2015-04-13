From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3 07/28] IB/Verbs: Reform IB-ulp ipoib
Date: Mon, 13 Apr 2015 14:01:38 -0600
Message-ID: <20150413200138.GC19112@obsidianresearch.com>
References: <552BB470.4090407@profitbricks.com>
 <552BB5AC.6050101@profitbricks.com>
 <20150413192701.GA19112@obsidianresearch.com>
 <20150413194602.GA21467@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150413194602.GA21467-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 13, 2015 at 03:46:03PM -0400, ira.weiny wrote:

> > This doesn't quite look right, it should be 'goto error1'
> 
> Looks like you replied to the wrong patch.  ??  I don't see error1 in ipoib_add_one.

> For the ib_cm module...

Right, sorry.
 
> Yes I think it should go to "error1".  However, see below...
> 
> This is the type of clean up error which would be avoided if a call to
> cap_ib_cm_dev() were done at the top of the function.

So what does cap_ib_cm_dev return in your example:

> Dev
> 	port 1 : cap_is_cm == true
> 	port 2 : cap_is_cm == false
> 	port 3 : cap_is_cm == true

True? Then the code is still broken, having cap_ib_cm_dev doesn't help
anything.

If we make it possible to be per port then it has to be fixed.

If you want to argue the above example is illegal and port 2 has to be
on a different device, I'd be interested to see what that looks like.

Thinking about it some more, cap_foo_dev only makes sense if all ports
are either true or false. Mixed is a BUG.

That seems reasonable, and solves the #10 problem, but we should
enforce this invariant during device register.

Typically the ports seem to be completely orthogonal (like SA), so in those
cases the _dev and restriction makes no sense.

CM seems to be different, so it should probably enforce its rules

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
