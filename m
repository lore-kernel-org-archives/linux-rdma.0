From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 12/16] IB/pvrdma: Add Queue Pair support
Date: Mon, 5 Dec 2016 13:21:07 -0800
Message-ID: <76188e1e-9b9b-07d6-febd-41827a049837@vmware.com>
References: <cover.1475458407.git.aditr@vmware.com>
 <6a643e92376856394d45638d80a90619d3abac37.1475458407.git.aditr@vmware.com>
 <20161202130726.GB3663@yuval-lap> <20161205172533.GA14581@yuval-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161205172533.GA14581@yuval-lap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 05, 2016 at 7:25:34PM +0200, Yuval Shaia wrote:
> > > +
> > > +			/* Skip header page. */
> > > +			qp->sq.offset = PAGE_SIZE;
> > > +
> > > +			/* Recv queue pages are after send pages. */
> > > +			qp->rq.offset = qp->npages_send * PAGE_SIZE;
> > 
> > Unless i'm missing something here, per comment it should be:
> > qp->rq.offset = qp->sq.offset + qp->npages_send * PAGE_SIZE;
> 
> Hi,
> Any comments about this question?

My comment [1] for the npages_send applies here as well. Since
we account for the extra page within the npages_send attribute, the
rq.offset calculated here is correct.

[1] http://marc.info/?l=linux-rdma&m=148069497625433&w=2
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
