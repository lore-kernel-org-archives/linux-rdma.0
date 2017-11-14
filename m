From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 09/31] IB/core: Make sure that PSN does not
 overflow
Date: Tue, 14 Nov 2017 16:44:33 -0700
Message-ID: <20171114234433.GD25894@ziepe.ca>
References: <20171114125218.20477-1-leon@kernel.org>
 <20171114125218.20477-10-leon@kernel.org>
 <CAJ3xEMj+QYJs7cTaP7-Z2WGoPZN2ujh+_2sQhW7ZKg0ZGjQacg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMj+QYJs7cTaP7-Z2WGoPZN2ujh+_2sQhW7ZKg0ZGjQacg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 14, 2017 at 11:23:07PM +0200, Or Gerlitz wrote:
> > +
> > +       if (rdma_ib_or_roce(qp->device, port)) {
> > +               if (attr_mask & IB_QP_RQ_PSN && attr->rq_psn & ~0xffffff) {
> > +                       pr_warn("%s: %s rq_psn overflow, masking to 24 bits\n",
> > +                               __func__, qp->device->name);
> > +                       attr->rq_psn &= 0xffffff;
> > +               }
> > +
> > +               if (attr_mask & IB_QP_SQ_PSN && attr->sq_psn & ~0xffffff) {
> > +                       pr_warn("%s: %s sq_psn overflow, masking to 24 bits\n",
> > +                               __func__, qp->device->name);
> > +                       attr->sq_psn &= 0xffffff;
> > +               }
> > +       }
> > +
> 
> Isn't this what we tried to push in the past and Jason/Sean rejected [1]?
> 
> [1] https://marc.info/?l=linux-rdma&m=142309249413868&w=2

No, this version is what I asked for originally in that thread:

  I think we'd be better off keeping the current behavior of masking
  the PSN, not enforcing the limit.

The issue was because the link'd version returned an error.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
