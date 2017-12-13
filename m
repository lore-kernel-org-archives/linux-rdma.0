From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH for-rc 2/6] RDMA/vmw_pvrdma: Call ib_umem_release on
 destroy QP path
Date: Wed, 13 Dec 2017 11:56:13 -0700
Message-ID: <20171213185613.GE16920@ziepe.ca>
References: <20171208185818.GA28514@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171208190106.GA32066@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171213085317.GC2669@yuvallap>
 <20171213161755.GB16920@ziepe.ca>
 <20171213184012.GA2516@yuvallap>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171213184012.GA2516@yuvallap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 13, 2017 at 08:40:13PM +0200, Yuval Shaia wrote:
> On Wed, Dec 13, 2017 at 09:17:55AM -0700, Jason Gunthorpe wrote:
> > On Wed, Dec 13, 2017 at 10:53:18AM +0200, Yuval Shaia wrote:
> > > On Fri, Dec 08, 2017 at 11:01:18AM -0800, Bryan Tan wrote:
> > > > The QP cleanup did not previously call ib_umem_release. Fix this.
> > > > 
> > > > Testing Done: ibv_rc_pingpong, rping, perftests.
> > > > 
> > > > Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
> > > > Reviewed-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > > > Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > > > Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > > > Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > > >  drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c | 7 +++++++
> > > >  1 file changed, 7 insertions(+)
> > > > 
> > > > diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
> > > > index b932b7e..77e7e57 100644
> > > > +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
> > > > @@ -430,6 +430,13 @@ static void pvrdma_free_qp(struct pvrdma_qp *qp)
> > > >  	atomic_dec(&qp->refcnt);
> > > >  	wait_event(qp->wait, !atomic_read(&qp->refcnt));
> > > >  
> > > > +	if (!qp->is_kernel) {
> > > > +		if (qp->rumem)
> > > 
> > > IS_ERR_OR_NULL?
> > 
> > How can we get an ERR_PTR in rumem?
> 
> qp->rumem is set with ib_umem_get which can either return ib_umem pointer
> or ERR_PTR.

In generall ERR_PTR's should not be permanently stored in structs and
I do not expect to see IS_ERR_OR_NULL used. Several kernel devs
consider is an abomination, and it certainly should *NEVER* be used
on a ptr which cannot, by design, have an ERR_PTR in it.

At least vmw_pvrdma appears to be OK:

                                qp->rumem = ib_umem_get(pd->uobject->context,
                                                        ucmd.rbuf_addr,
                                                        ucmd.rbuf_size, 0, 0);

                                if (IS_ERR(qp->rumem)) {
                                        ret = PTR_ERR(qp->rumem);
                                        goto err_qp;
[..]
err_qp:
        kfree(qp);


So we cannot have a 'qp' struct with an ERR_PTR in rumem.

> So i looked at other places which calls ib_umem_release. The first one that
> pops up is bnxt_re which do this check with IS_ERR_OR_NULL?.

The test in bnxt looks wrong to me, and should be removed:

                umem = ib_umem_get(context, ureq.qprva, bytes,
                                   IB_ACCESS_LOCAL_WRITE, 1);
                if (IS_ERR(umem))
                        goto rqfail;
                qp->rumem = umem;

So rumem can never be assigned to PTR_ERR, and this is garbage:

        if (!IS_ERR_OR_NULL(qp->rumem))
                ib_umem_release(qp->rumem);


Similar remark for other tests in that driver. Care to send a patch?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
