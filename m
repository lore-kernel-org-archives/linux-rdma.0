From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next] RDMA/vmw_pvrdma: Add shared receive queue
 support
Date: Thu, 2 Nov 2017 11:39:04 -0700
Message-ID: <20171102183904.GD24375@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
References: <20171030022037.GA20100@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171031140205.GA4317@yuvallap>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171031140205.GA4317@yuvallap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 31, 2017 at 04:02:07PM +0200, Yuval Shaia wrote:
> > +	if (is_srq) {
> > +		if (dev->dsr->caps.max_srq == 0) {
> 
> Let us be consist, so if in function pvrdma_init_device the assumption is
> that max_srq can have negative value then also check it here. Or on the
> other hands if not (and i assume it is not) then modify the check on
> pvrdma_init_device.
> 
> Also, suggesting:
> 	if (is_srq && !dev->dsr->caps.max_srq)
> Or (if you do not accept my comment):
> 	if (is_srq && dev->dsr->caps.max_srq == 0)
> 

Sure. I'll take your comment and fix the check in
pvrdma_register_device as well.

> > +	if (init_attr->srq_type != IB_SRQT_BASIC)
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	if (init_attr->attr.max_wr  > dev->dsr->caps.max_srq_wr ||
> > +	    init_attr->attr.max_sge > dev->dsr->caps.max_srq_sge)
> 
> Again - let us be consist, if we got warning in pvrdma_create_qp we should
> get one here as well.
> 

Added a warning here, as well as in the srq_type check above.

> > +	if (!(pd->uobject && udata)) {
> > +		/* No support for kernel clients. */
> > +		ret = -EOPNOTSUPP;
> > +		goto err_srq;
> > +	}
> 
> Why this check cannot be performed before the above initialization??
> Also, suggesting a debug message here.
> 

Moved check to beginning, and added a warning here.


Thanks for the review!
Bryan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
