From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Skip napi_schedule if ib_poll_cq fails
Date: Thu, 14 Jul 2016 11:34:59 -0600
Message-ID: <20160714173459.GA10759@obsidianresearch.com>
References: <1468402436-25053-1-git-send-email-yuval.shaia@oracle.com>
 <20160713174742.GE19657@obsidianresearch.com>
 <20160713191224.GB2985@yuval-lap>
 <20160713192504.GA26851@obsidianresearch.com>
 <20160713195030.GB4929@yuval-lap.uk.oracle.com>
 <02892134-15c7-963a-d13b-95d6e35ceaca@oracle.com>
 <20160713205358.GA27704@obsidianresearch.com>
 <5722B9B9-2145-414A-957A-AA5C1C223B31@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5722B9B9-2145-414A-957A-AA5C1C223B31-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: H??kon Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 14, 2016 at 07:12:48PM +0200, H??kon Bugge wrote:
> >> Probably Jason mean destroy the problematic CQ and create a new one. This is
> >> what Haakon suggested as well but it will lead to the leak
> >> and also possible issue with outstanding WC's getting lost without
> >> being flushed on that CQ.
> > 
> > Again, this seems crazy.
> > 
> > What failure mode does a CQ have that does not require a full driver
> > restart after?
> 
> The OFED API clearly indicates that ib_poll_cq() might fail and
> return an error status.
> 
> This API is also conforms with the IBTA specification, section
> 11.4.2.1 Poll for Completion:

Irrelevant. This is the kAPI, it is not defined by anyone except the
kernel community.

We have made mistakes in it's design in the past (eg see the _destroy
functions that used to return errors) and when those mistakes are
discovered they need to be fixed robustly across the whole kernel.

The approach in our subsystem for handling serious 'should never
happen' errors is to trigger a full device restart & recovery.

IMHO all CQ related errors at poll time fall into that category.

If you have a concrete counter example please share it.

> > Drivers that hard fail a CQ poll should declare themselves dead and
> > require a full restart to recover. This is the same infrastructure
> > that was added to the mlx drivers to handle other forms of hard
> > errors.
> 
> Yes, but this is at the discretion of the driver. Provider drivers
> are free to have a BUG_ON() instead of a return -EINVAL. But that is
> not the case. And, if there is an intermittent error return (e.g.,
> EAGAIN), I take it that we can agree that the driver shall not
> declare itself dead.

Giving the driver this discretion was the design error. The ULPs are
not prepared to handle this case, and any driver that returns an error
here is likely going to trigger kernel bugs elsewhere.

> Now, for drivers that can fault isolate a CQ error to the CQ and
> affected QPs, as supported by the API, should be allowed to offer
> that possibility in my opinion. Errors do happen, although this kind
> of errors happen seldom. There are different failover models that
> can be used to overcome such an error, whether it is intermittent or
> hard.

Again, that is not the recovery model we have in our subsystem.

Is this actually a real case? What scenario could possibly result in a
CQ localized polling error?

If a device really supports some kind of fine grained error detection
then it needs to use established mechanisms -> move the impacted QPs
to an error state and deliver a CQE. It is up to the driver to ensure
that this can happen without cq poll failure, not every ULP.

> I see -EINVAL returned from poll_cq() from ehca and mlx4 for example.

I'm not disputing there is a problem here, only that this patch
represents an acceptable fix.

For instance you can argue we should handle CQ isolated errors. Fine,
but this patch doesn't do that. It leaves IPoIB in a broken state if
such an error occurs. It doesn't represent an audit of all poll users
to check if they handle errors properly (I doubt they do, since this
patch doesn't even properly fix ipoib)

Thus, in my view, the shortest path to overall kernel correctness is
to follow our subsystem standard, and trigger a device restart in the
driver and ban failure of CQ poll in the kAPI.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
