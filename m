From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-rc] RDMA/restrack: don't use uaccess_kernel()
Date: Fri, 16 Feb 2018 09:47:06 -0600
Message-ID: <037601d3a73d$657c6090$307521b0$@opengridcomputing.com>
References: <eac01039be8c0518e37928e5b003a911c32e53a7.1518468700.git.swise@opengridcomputing.com> <20180215215854.GA16973@ziepe.ca> <02a301d3a6a8$e3b5dee0$ab219ca0$@opengridcomputing.com> <20180215224117.GA7803@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180215224117.GA7803-uk2M96/98Pc@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgg-uk2M96/98Pc@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > > On Thu, Feb 08, 2018 at 12:09:43PM -0800, Steve Wise wrote:
> > > > +	case RDMA_RESTRACK_QP:
> > > > +		qp = container_of(res, struct ib_qp, res);
> > > > +		if (qp->pd)
> > > > +			is_user = qp->pd->uobject;
> > >
> > > ?? Why is this like this?
> > >
> > > struct ib_qp has a uboject, why do we need to look at the PD?
> >
> > I wasn't getting the correct user/kernel setting when I used
qp->uobject.
> > Perhaps I should revisit this.
> 
> Oh that answer certainly makes me nervous.. Let's explain that please
> and either change it or add a big fat comment here about why it has to
> be like this.
> 

I see the problem:  in uverbs_cmd.c:create_qp(), the call to _ib_create_qp()
happens before qp->uobject is initialized.  I'll move the initialization of
qp->uobject to before the call to _ib_create_qp(), test it out, and send a
new patch.

Thanks Jason!

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
