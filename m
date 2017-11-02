From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next] RDMA/vmw_pvrdma: Add shared receive queue
 support
Date: Thu, 2 Nov 2017 11:23:25 -0700
Message-ID: <20171102182325.GC24375@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
References: <20171030022037.GA20100@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171030060317.GS16127@mtr-leonro.local>
 <20171102175225.GB24375@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171102180247.GF16127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171102180247.GF16127-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 02, 2017 at 08:02:47PM +0200, Leon Romanovsky wrote:
> > Here we assumed that the verbs layer will only call down to us to
> > destroy a valid SRQ. If an SRQ has been created, then the srq_tbl
> > should exist. I can add a check here if that's not behaviour we
> > should rely on.
> 
> By saying "verbs layer", are you referring to libibverbs or IB/core?
> 

IB/core. Looking at core/verbs.c, it seems like the parameters are
assumed to be good. I'm unclear on who is responsible for ensuring
or checking for good inputs, kernel clients, IB/core, or the driver.

> > > > +int pvrdma_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
> > > > +		      enum ib_srq_attr_mask attr_mask, struct ib_udata *udata)
> > > > +{
> > > > +	struct pvrdma_srq *vsrq = to_vsrq(ibsrq);
> > > > +	union pvrdma_cmd_req req;
> > > > +	struct pvrdma_cmd_modify_srq *cmd = &req.modify_srq;
> > > > +	struct pvrdma_dev *dev = to_vdev(ibsrq->device);
> > > > +	int ret;
> > > > +
> > > > +	/* No support for resizing SRQs. */
> > >
> > > Better to write that you support, so future additions to ib_srq_attr_mask
> > > won't need to change your code.
> > >
> >
> > I'm a little unclear on what you mean here. Do you mean that we
> > should explicitly check for the only attribute we support
> > (IB_SRQ_LIMIT) and fail otherwise?
> 
> Yes, it will ensure that your driver doesn't get untested input.
> 

Sure, I will do that then.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
