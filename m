From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-rc 1/3] iw_cxgb4: Only validate the MSN for
 successful completions
Date: Thu, 21 Dec 2017 19:48:32 -0700
Message-ID: <20171222024832.GA23946@ziepe.ca>
References: <20171220191644.CB3F62BC88@smtp.opengridcomputing.com>
 <20171222002341.GA20855@ziepe.ca>
 <000801d37ac3$7f8e4d00$7eaae700$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <000801d37ac3$7f8e4d00$7eaae700$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 21, 2017 at 07:23:39PM -0600, Steve Wise wrote:
> > 
> > On Mon, Dec 18, 2017 at 01:10:00PM -0800, Steve Wise wrote:
> > > If the RECV CQE is in error, ignore the MSN check.  This was causing
> > > recvs that were flushed into the sw cq to be completed with the wrong
> > > status (BAD_MSN instead of FLUSHED).
> > >
> > > Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > >  drivers/infiniband/hw/cxgb4/cq.c | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > Applied the series to for-next, thanks
> 
> Thanks Jason.  I requested -rc though.  Did you not want it in -rc? 

Ah, I did put it in -rc, sorry, toddler-came-home distraction when I
was finishing.. Same for all the last couple patches.

The -rc branch tip is here right now while 0-day runs on it.

https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/log/?h=wip/jgg-zero-day

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
