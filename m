From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-rc 1/6] RDMA/vmw_pvrdma: Clarify QP is_kernel logic
Date: Wed, 13 Dec 2017 21:20:09 +0200
Message-ID: <20171213192008.GC6074@yuvallap>
References: <20171208185818.GA28514@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171208190010.GA31023@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171213090246.GD2669@yuvallap>
 <20171213190825.GH20684@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171213190825.GH20684-qXbCdz4EeRo1jLI2hToXVI42T8aCTgcwy4vvyvUx+exJXi8ZT2ovy+oDBWuYMCC/JZORHMmSJCU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 13, 2017 at 11:08:26AM -0800, Bryan Tan wrote:
> On Wed, Dec 13, 2017 at 11:02:46AM +0200, Yuval Shaia wrote:
> > On Fri, Dec 08, 2017 at 11:00:17AM -0800, Bryan Tan wrote:
> > > Be more consistent in checking is_kernel flag for QPs.
> > 
> > Consist with what?
> > (asking because expecting also pvrdma_create_cq to be fixed).
> 
> I had updated create SRQ's is_kernel in the same way. Thanks for
> pointing out that I had missed it in create CQ.
> 
> > > 
> > > Testing Done: ibv_rc_pingpong, rping, perftests.
> > 
> > These are all userspace tests, right?
> 
> Yes. That was accidentally carried over from our how we
> format our commits internally. I'll remove the "Testing Done"
> line here and in the next commit message.

But...since you exposed this info my question remains, you changed a flow
of a branch that checks if verb was requested by kernel or userspace but
you tested it only with userspace tools.

> 
> > > 
> > > Reviewed-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > > Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > > Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > > Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > > ---
> > >  drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c | 7 +++----
> > >  1 file changed, 3 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
> > > index 10420a1..b932b7e 100644
> > > --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
> > > +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
> > > @@ -249,8 +249,9 @@ struct ib_qp *pvrdma_create_qp(struct ib_pd *pd,
> > >  		init_waitqueue_head(&qp->wait);
> > >  
> > >  		qp->state = IB_QPS_RESET;
> > > +		qp->is_kernel = !(pd->uobject && udata);
> > >  
> > > -		if (pd->uobject && udata) {
> > > +		if (!qp->is_kernel) {
> > >  			dev_dbg(&dev->pdev->dev,
> > >  				"create queuepair from user space\n");
> > >  
> > > @@ -291,8 +292,6 @@ struct ib_qp *pvrdma_create_qp(struct ib_pd *pd,
> > >  				qp->npages_recv = 0;
> > >  			qp->npages = qp->npages_send + qp->npages_recv;
> > >  		} else {
> > > -			qp->is_kernel = true;
> > > -
> > >  			ret = pvrdma_set_sq_size(to_vdev(pd->device),
> > >  						 &init_attr->cap, qp);
> > >  			if (ret)
> > > @@ -394,7 +393,7 @@ struct ib_qp *pvrdma_create_qp(struct ib_pd *pd,
> > >  err_pdir:
> > >  	pvrdma_page_dir_cleanup(dev, &qp->pdir);
> > >  err_umem:
> > > -	if (pd->uobject && udata) {
> > > +	if (!qp->is_kernel) {
> > >  		if (qp->rumem)
> > >  			ib_umem_release(qp->rumem);
> > >  		if (qp->sumem)
> > 
> > Regardless of the comments:
> > 
> > Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > 
> > > -- 
> > > 1.8.5.6
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=uilaK90D4TOVoH58JNXRgQ&r=MjCVwEZlX7H-yXFOZ8b3IdkUDz9tjnFu-2RVvpFiKHw&m=M9b99UdgNMHlndgR9oY0KSFjeYht9EpUHM4iqxKTcUE&s=d8rmC5ZUNj2gLH8KOcrCgMmMg6484BYoXivYSjKEha0&e=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
