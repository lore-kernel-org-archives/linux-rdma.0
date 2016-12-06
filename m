From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 12/16] IB/pvrdma: Add Queue Pair support
Date: Tue, 6 Dec 2016 10:00:59 +0200
Message-ID: <20161206080057.GA4894@yuval-lap>
References: <cover.1475458407.git.aditr@vmware.com>
 <6a643e92376856394d45638d80a90619d3abac37.1475458407.git.aditr@vmware.com>
 <20161202130726.GB3663@yuval-lap>
 <20161205172533.GA14581@yuval-lap>
 <76188e1e-9b9b-07d6-febd-41827a049837@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <76188e1e-9b9b-07d6-febd-41827a049837-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 05, 2016 at 01:21:07PM -0800, Adit Ranadive wrote:
> On Mon, Dec 05, 2016 at 7:25:34PM +0200, Yuval Shaia wrote:
> > > > +
> > > > +			/* Skip header page. */
> > > > +			qp->sq.offset = PAGE_SIZE;
> > > > +
> > > > +			/* Recv queue pages are after send pages. */
> > > > +			qp->rq.offset = qp->npages_send * PAGE_SIZE;
> > > 
> > > Unless i'm missing something here, per comment it should be:
> > > qp->rq.offset = qp->sq.offset + qp->npages_send * PAGE_SIZE;
> > 
> > Hi,
> > Any comments about this question?
> 
> My comment [1] for the npages_send applies here as well. Since
> we account for the extra page within the npages_send attribute, the
> rq.offset calculated here is correct.

Ok, i see that now.
It is kind of confusing that this logic of one extra page for header is
implemented in two places, i.e. in pvrdma_set_sq_size and in
pvrdma_set_sq_size's caller.
Still suggesting to move this logic to one place for better modularization.
(Just imagine one day that you will need to expand this header to two
pages).
If you accept it then caller is my vote to place it :)

> 
> [1] http://marc.info/?l=linux-rdma&m=148069497625433&w=2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
