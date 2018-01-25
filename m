From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next v6 3/8] RDMA/restrack: Add general
 infrastructure to track RDMA resources
Date: Thu, 25 Jan 2018 13:10:23 -0700
Message-ID: <20180125201023.GA9162@ziepe.ca>
References: <20180125151227.28202-1-leon@kernel.org>
 <20180125151227.28202-4-leon@kernel.org>
 <20180125174529.GB3739@ziepe.ca>
 <20180125194436.GR1393@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180125194436.GR1393-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 25, 2018 at 09:44:36PM +0200, Leon Romanovsky wrote:
> > > +	/*
> > > +	 * @kref: Protect destroy of the resource
> > > +	 */
> > > +	struct kref		kref;
> >
> > Sticking a kref in a random structure that is itself not malloc'd is a
> > big red flag:
> 
> It is not "rand", but embedded part of ib_qp,ib_pd and ib_cq. It is
> malloced as part of their creation.

I mean the kref isn't in any way linked the lifetime of the malloc
that contains it. So it isn't really a kref, it is just a refcount.

> > @@ -1746,6 +1756,11 @@ struct ib_qp {
> > +       struct rdma_restrack_root     res;
> >
> >
> > Not seeing how this works at all.
> >
> > qp does this:
> >
> > +       rdma_restrack_del(&qp->res);
> >         ret = qp->device->destroy_qp(qp);
> >
> > And for instance the mlx5 implementation of destroy_qp() does:
> >
> > int mlx5_ib_destroy_qp(struct ib_qp *qp)
> > {
> >         struct mlx5_ib_qp *mqp = to_mqp(qp);
> > [..]
> >
> >         kfree(mqp);
> >
> > So we kfree the kref containing memory outside the kref's release
> > function. Super big red flag.
> 
> It is worth to look on the actual implementation, the
> rdma_restrack_del() doesn't do a lot: removes from the list and marks
> the resource as not valid.

It doesn't even do that if the kref count is elevated.

Which is the whole point, the rdma_restrack_del *doesn't* prevent the
use-after-free on the read side.

> > The best idea I've had to make this locking work is what I emailed you
> > a few days ago..
> 
> It is more or less the same idea, but needs to move
> down_write(&dev->res.rwsem) to be part of rdma_restrack_del and not
> release routine. It will cause to block the progress of release.

That doesn't help - the kref is still totally non-functional as a kref:

 CPU0                                CPU1

                                 down_read()
                                 rdma_restrack_get()
				 up_read()
down_write()
restrack_release()
up_write()
kfree(qp)
                                 fill_res_qp_entry(qp)
				 // boom, use after free

A kref is not a lock, and a kref that *doesn't* put kfree in the
release function is probably not a kref but a refcount.

What I sent you wasn't remotely like this, it had two nested locks,
the outer mutex and a very special open coded inner read/write lock
that doesn't deadlock when nested..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
