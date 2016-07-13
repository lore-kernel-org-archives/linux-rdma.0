From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Skip napi_schedule if ib_poll_cq fails
Date: Wed, 13 Jul 2016 14:53:58 -0600
Message-ID: <20160713205358.GA27704@obsidianresearch.com>
References: <1468402436-25053-1-git-send-email-yuval.shaia@oracle.com>
 <20160713174742.GE19657@obsidianresearch.com>
 <20160713191224.GB2985@yuval-lap>
 <20160713192504.GA26851@obsidianresearch.com>
 <20160713195030.GB4929@yuval-lap.uk.oracle.com>
 <02892134-15c7-963a-d13b-95d6e35ceaca@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <02892134-15c7-963a-d13b-95d6e35ceaca-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Haakon Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 13, 2016 at 01:46:07PM -0700, Santosh Shilimkar wrote:
> >Patch does not offer any recovery mechanism it simply print fatal error to
> >console and exit NAPI. This fatal error will suggest admin to reload the
> >driver or something like that.
> >This takes us to "recovery-mechanism" :)
> >I'm not sure that restarting the QP will help as the error is while reading
> >the CQ and restarting the CQ is more or less like restarting the driver.
> >
> Probably Jason mean destroy the problematic CQ and create a new one. This is
> what Haakon suggested as well but it will lead to the leak
> and also possible issue with outstanding WC's getting lost without
> being flushed on that CQ.

Again, this seems crazy.

What failure mode does a CQ have that does not require a full driver
restart after?

Drivers that hard fail a CQ poll should declare themselves dead and
require a full restart to recover. This is the same infrastructure
that was added to the mlx drivers to handle other forms of hard
errors.

This was the same direction we went in for the _destroy functions.

poll_cq should only return -EAGAIN or success (and EAGAIN seems
fairly strange, how is that different from returning 0 wcs?)

If there is some actual reason preventing a driver from implementing
that kind of API lets hear it. Otherwise I recommend you focus patches
on fixing any broken drivers and documenting this requirement.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
