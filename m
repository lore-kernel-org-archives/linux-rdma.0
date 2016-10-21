From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RFC v2 2/3] rdma_cm: add rdma_consumer_reject() helper      function
Date: Fri, 21 Oct 2016 09:09:05 -0500
Message-ID: <005f01d22ba4$aeadeab0$0c09c010$@opengridcomputing.com>
References: <cover.1477003235.git.swise@opengridcomputing.com> <cb135696be86c21c144ef35a4d6f7f71394a3627.1477003235.git.swise@opengridcomputing.com> <20161021121428.GB17028@lst.de>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161021121428.GB17028-jcswGhMUV9g@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagig-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> On Thu, Oct 20, 2016 at 03:40:26PM -0700, Steve Wise wrote:
> > Return true if the peer consumer application rejected the
> > connection attempt.
> >
> > Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > ---
> >  drivers/infiniband/core/cma.c | 13 +++++++++++++
> >  include/rdma/ib_cm.h          |  9 +++++++++
> >  include/rdma/iw_cm.h          |  9 +++++++++
> >  include/rdma/rdma_cm.h        |  6 ++++++
> >  4 files changed, 37 insertions(+)
> >
> > diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> > index 7cc7346..4ec16a3 100644
> > --- a/drivers/infiniband/core/cma.c
> > +++ b/drivers/infiniband/core/cma.c
> > @@ -114,6 +114,19 @@ const char *__attribute_const__
> rdma_reject_msg(struct rdma_cm_id *id,
> >  }
> >  EXPORT_SYMBOL(rdma_reject_msg);
> >
> > +bool rdma_consumer_reject(struct rdma_cm_id *id, int reason)
> > +{
> > +	if (rdma_ib_or_roce(id->device, id->port_num))
> > +		return ib_consumer_reject(reason);
> > +
> > +	if (rdma_protocol_iwarp(id->device, id->port_num))
> > +		return iw_consumer_reject(reason);
> > +
> > +	/* FIXME should we WARN_ONCE() here? */
> > +	return false;
> 
> Yes.  Also I'd just inline the ib_consumer_reject and iw_consumer_reject
> helpers here.
> 
> Aso wouldn't it be better named rdma_consumer_is_reject or similar
> given that we don't reject anything here, but check if the request
> has been rejected?

How about rdma_rejected_by_consumer()?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
