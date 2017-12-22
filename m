From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-rc 1/3] iw_cxgb4: Only validate the MSN for successful completions
Date: Thu, 21 Dec 2017 19:23:39 -0600
Message-ID: <000801d37ac3$7f8e4d00$7eaae700$@opengridcomputing.com>
References: <20171220191644.CB3F62BC88@smtp.opengridcomputing.com> <20171222002341.GA20855@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171222002341.GA20855-uk2M96/98Pc@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> On Mon, Dec 18, 2017 at 01:10:00PM -0800, Steve Wise wrote:
> > If the RECV CQE is in error, ignore the MSN check.  This was causing
> > recvs that were flushed into the sw cq to be completed with the wrong
> > status (BAD_MSN instead of FLUSHED).
> >
> > Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> >  drivers/infiniband/hw/cxgb4/cq.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Applied the series to for-next, thanks

Thanks Jason.  I requested -rc though.  Did you not want it in -rc? 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
