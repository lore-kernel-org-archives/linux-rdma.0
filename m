From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-rc] RDMA/restrack: don't use uaccess_kernel()
Date: Thu, 15 Feb 2018 15:41:17 -0700
Message-ID: <20180215224117.GA7803@ziepe.ca>
References: <eac01039be8c0518e37928e5b003a911c32e53a7.1518468700.git.swise@opengridcomputing.com>
 <20180215215854.GA16973@ziepe.ca>
 <02a301d3a6a8$e3b5dee0$ab219ca0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <02a301d3a6a8$e3b5dee0$ab219ca0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 15, 2018 at 04:04:02PM -0600, Steve Wise wrote:
> > 
> > On Thu, Feb 08, 2018 at 12:09:43PM -0800, Steve Wise wrote:
> > > +	case RDMA_RESTRACK_QP:
> > > +		qp = container_of(res, struct ib_qp, res);
> > > +		if (qp->pd)
> > > +			is_user = qp->pd->uobject;
> > 
> > ?? Why is this like this?
> > 
> > struct ib_qp has a uboject, why do we need to look at the PD?
> 
> I wasn't getting the correct user/kernel setting when I used qp->uobject.
> Perhaps I should revisit this.

Oh that answer certainly makes me nervous.. Let's explain that please
and either change it or add a big fat comment here about why it has to
be like this.

Thanks,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
