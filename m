From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-rc] RDMA/restrack: don't use uaccess_kernel()
Date: Thu, 15 Feb 2018 16:04:02 -0600
Message-ID: <02a301d3a6a8$e3b5dee0$ab219ca0$@opengridcomputing.com>
References: <eac01039be8c0518e37928e5b003a911c32e53a7.1518468700.git.swise@opengridcomputing.com> <20180215215854.GA16973@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180215215854.GA16973-uk2M96/98Pc@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgg-uk2M96/98Pc@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> On Thu, Feb 08, 2018 at 12:09:43PM -0800, Steve Wise wrote:
> > +	case RDMA_RESTRACK_QP:
> > +		qp = container_of(res, struct ib_qp, res);
> > +		if (qp->pd)
> > +			is_user = qp->pd->uobject;
> 
> ?? Why is this like this?
> 
> struct ib_qp has a uboject, why do we need to look at the PD?

I wasn't getting the correct user/kernel setting when I used qp->uobject.
Perhaps I should revisit this.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
