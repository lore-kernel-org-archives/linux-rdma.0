From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH] iw_cxgb4: only call CQ completion handlers if they exist
Date: Wed, 30 Jul 2014 09:20:17 -0500
Message-ID: <003301cfac01$6302daf0$290890d0$@opengridcomputing.com>
References: <20140729212329.2419.84300.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140729212329.2419.84300.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roland, this patch needs rework.  As you pointed out to me, the iSER ULP never arms the SCQ, so iw_cxgb4 should not be trying to notify.   Thus even though the patch below resolves the crash, it is not the correct fix.

I'll send a new patch that will key on whether the CQs are armed or not.

Steve.


> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On
> Behalf Of Steve Wise
> Sent: Tuesday, July 29, 2014 4:24 PM
> To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH] iw_cxgb4: only call CQ completion handlers if they exist
> 
> The iser ULP creates a CQ without a SQ completion handler, which is valid.
> This will cause iw_cxgb4 to crash the system if the QP is flushed.
> The fix is to simply not call the handler if the handler ptr is NULL.
> 
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
> 
>  drivers/infiniband/hw/cxgb4/qp.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
> index 086f62f..bdbe6b4 100644
> --- a/drivers/infiniband/hw/cxgb4/qp.c
> +++ b/drivers/infiniband/hw/cxgb4/qp.c
> @@ -1087,7 +1087,7 @@ static void __flush_qp(struct c4iw_qp *qhp, struct c4iw_cq *rchp,
>  	flushed = c4iw_flush_rq(&qhp->wq, &rchp->cq, count);
>  	spin_unlock(&qhp->lock);
>  	spin_unlock_irqrestore(&rchp->lock, flag);
> -	if (flushed) {
> +	if (flushed && rchp->ibcq.comp_handler) {
>  		spin_lock_irqsave(&rchp->comp_handler_lock, flag);
>  		(*rchp->ibcq.comp_handler)(&rchp->ibcq, rchp->ibcq.cq_context);
>  		spin_unlock_irqrestore(&rchp->comp_handler_lock, flag);
> @@ -1101,7 +1101,7 @@ static void __flush_qp(struct c4iw_qp *qhp, struct c4iw_cq *rchp,
>  	flushed = c4iw_flush_sq(qhp);
>  	spin_unlock(&qhp->lock);
>  	spin_unlock_irqrestore(&schp->lock, flag);
> -	if (flushed) {
> +	if (flushed && schp->ibcq.comp_handler) {
>  		spin_lock_irqsave(&schp->comp_handler_lock, flag);
>  		(*schp->ibcq.comp_handler)(&schp->ibcq, schp->ibcq.cq_context);
>  		spin_unlock_irqrestore(&schp->comp_handler_lock, flag);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
