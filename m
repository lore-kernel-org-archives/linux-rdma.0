From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 for-rc 5/8] RDMA/vmw_pvrdma: Use refcount_t instead of
 atomic_t
Date: Wed, 20 Dec 2017 12:02:09 -0800
Message-ID: <20171220200209.GC18878@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
References: <20171214001753.GA9780@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171214002402.GA16082@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171219053201.GG18894@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171219053201.GG18894-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 19, 2017 at 07:32:01AM +0200, Leon Romanovsky wrote:
> On Wed, Dec 13, 2017 at 04:24:12PM -0800, Bryan Tan wrote:
> > @@ -229,8 +229,8 @@ struct ib_cq *pvrdma_create_cq(struct ib_device *ibdev,
> >
> >  static void pvrdma_free_cq(struct pvrdma_dev *dev, struct pvrdma_cq *cq)
> >  {
> > -	atomic_dec(&cq->refcnt);
> > -	wait_event(cq->wait, !atomic_read(&cq->refcnt));
> > +	if (!refcount_dec_and_test(&cq->refcnt))
> > +		wait_event(cq->wait, !refcount_read(&cq->refcnt));
> 
> Don't you suppose to call to wait_event without condition on refcnt and
> sleep till refcnt == 0??

By the time we check this condition, there cannot be any new references
to this CQ. If refcnt is zero, there isn't any reason to call
wait_event.

However, we've changed this to use completions instead of wait queues
because there is a possibility of use after free here still. For SRQs we
use this pattern first to fix the problem of using refcount_dec, and
then a few commits later in the new patch series wait queues are
switched to completions. Please take a look at the v2 patch series.

Thanks!
Bryan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
