From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-rc 4/6] RDMA/vmw_pvrdma: Use refcount_dec_and_test to
 avoid warning
Date: Tue, 12 Dec 2017 09:13:00 -0800
Message-ID: <20171212171300.GD20684@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
References: <20171208185818.GA28514@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171208190218.GA744@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171208233049.GB23239@ziepe.ca>
 <20171211183314.GA20684@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171211201421.GD27709@ziepe.ca>
 <20171211215936.GC20684@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171211221425.GA7551@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171211221425.GA7551-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 11, 2017 at 03:14:25PM -0700, Jason Gunthorpe wrote:
> On Mon, Dec 11, 2017 at 01:59:37PM -0800, Bryan Tan wrote:
> > On Mon, Dec 11, 2017 at 01:14:21PM -0700, Jason Gunthorpe wrote:
> > > On Mon, Dec 11, 2017 at 10:33:15AM -0800, Bryan Tan wrote:
> > > > On Fri, Dec 08, 2017 at 04:30:49PM -0700, Jason Gunthorpe wrote:
> > > > > On Fri, Dec 08, 2017 at 11:02:24AM -0800, Bryan Tan wrote:
> > > > > > refcount_dec generates a warning when the operation
> > > > > > causes the refcount to hit zero. Avoid this by using
> > > > > > refcount_dec_and_test.
> > > > > > 
> > > > > > Fixes: 8b10ba783c9d ("RDMA/vmw_pvrdma: Add shared receive queue support")
> > > > > > Reviewed-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > > > > > Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > > > > > Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > > > > > Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > > > > >  drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c | 4 ++--
> > > > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > > > 
> > > > > > diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c
> > > > > > index 826ccb8..a2b1a3c 100644
> > > > > > +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c
> > > > > > @@ -236,8 +236,8 @@ static void pvrdma_free_srq(struct pvrdma_dev *dev, struct pvrdma_srq *srq)
> > > > > >  	dev->srq_tbl[srq->srq_handle] = NULL;
> > > > > >  	spin_unlock_irqrestore(&dev->srq_tbl_lock, flags);
> > > > > >  
> > > > > > -	refcount_dec(&srq->refcnt);
> > > > > > -	wait_event(srq->wait, !refcount_read(&srq->refcnt));
> > > > > > +	if (!refcount_dec_and_test(&srq->refcnt))
> > > > > > +		wait_event(srq->wait, !refcount_read(&srq->refcnt));
> > > > > 
> > > > > I really don't like this idiom for using refcount, refcount should
> > > > > not be dec'd below 0 even under a dec_and_test..
> > > > > Why not just simplify:
> > > > >
> > > > > 	wait_event(srq->wait, refcount_read(&srq->refcnt) == 1);
> > > > >
> > > > > ???
> > > > >
> > > > > Same comment on the other patch switching from atomic to refcount
> > > > > 
> > > > > Jason
> > > > 
> > > > The refcount doesn't go below 0 in either case--the problem is that
> > > > I didn't realise refcount_dec complains about decrements resulting
> > > > in a value of 0 [1]. There are no problems with refcount_dec_and_test
> > > > resulting in a value of 0.
> > > 
> > > Thats what I ment with my remark.. Sorry for the confusion
> > > 
> > > > About checking for refcnt == 1, I do not know of a safe way to only
> > > > wake up when the refcount hits 1. Right now we do that by checking
> > > > for 0 and doing a wake_up if the result of refcount_dec_and_test is
> > > > 0 (see the SRQ event handler in pvrdma_main.c). If there's a way to
> > > > accomplish this without another dec_and_test in the destroy path, I
> > > > can do so.
> > > 
> > > What is wrong with this:
> > > 
> > >  	wait_event(srq->wait, refcount_read(&srq->refcnt) == 1);
> > > ?
> > > 
> > > refcount == 1 means the caller is the last owner of the refcount,
> > > presumably you have already taken care to ensure it cannot be inc'd
> > > again (or the code is already not locked right)
> > 
> > In the SRQ event handler, we do this at the end of handling the event:
> > 
> > > if (refcount_dec_and_test(&srq->refcnt))
> > >         wake_up(&srq->wait);
> 
> What? You can't combine one thread doing
> 
>  if (refcount_dec_and_test(&srq->refcnt))
>          wake_up(&srq->wait);
> 
> With
>   if (!refcount_dec_and_test(&srq->refcnt))
> 	wait_event(srq->wait, !refcount_read(&srq->refcnt));
> 
> It makes no sense, how is that a refcount???
> 
> They can't *BOTH* refcount_dec_and_test!
>
> I can understand doing
> 
>   if (refcount_dec_and_test(&srq->refcnt))
>          wake_up(&srq->wait);
> 
> and then
> 
>    wait_event(srq->wait, !refcount_read(&srq->refcnt));
> 
> That makes perfect sense.

Perhaps I am mistaken in my understanding of refcounts here, but
what is wrong with this? If it's not that the refcount is set to
1 on resource creation (which, by your earlier suggestion of
checking refcnt == 1, seems to be fine), and both callers (the
resource event handler and resource destroy call) need to make
sure the destroy sequence only happens once (when the refcount
reaches 0), then using refcount_dec_and_test seems right to me.

Your last suggestion would mean setting the refcount to 0 on
resource creation, as we wait on refcount hitting 0, but that
would mean the resource event handler would often be calling
wake_up unnecessarily.

What we're doing is effectively the same as how mlx5 handles
this (see drivers/net/ethernet/mellanox/mlx5/core/srq.c) I
suppose using refcount_t requires one to follow a particular
model of usage but I'm not sure how this isn't right.

Thanks,
Bryan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
