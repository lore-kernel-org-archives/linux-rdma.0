From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 05/12] IB/core: refactor ib_create_qp
Date: Mon, 18 Apr 2016 23:08:11 -0400
Message-ID: <20160419030810.GA27515@rhel.amr.corp.intel.com>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
 <1460410360-13104-6-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1460410360-13104-6-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 11, 2016 at 02:32:33PM -0700, Christoph Hellwig wrote:
> Split the XRC magic into a separate function, and return early on failure
> to make the initialization code readable.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Tested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Reviewed-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> ---
>  drivers/infiniband/core/verbs.c | 103 +++++++++++++++++++++-------------------
>  1 file changed, 54 insertions(+), 49 deletions(-)
> 
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index 064dbef..d0ed260 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -723,62 +723,67 @@ struct ib_qp *ib_open_qp(struct ib_xrcd *xrcd,
>  }
>  EXPORT_SYMBOL(ib_open_qp);
>  
> +static struct ib_qp *ib_create_xrc_qp(struct ib_qp *qp,
> +		struct ib_qp_init_attr *qp_init_attr)
> +{
> +	struct ib_qp *real_qp = qp;
> +
> +	qp->event_handler = __ib_shared_qp_event_handler;
> +	qp->qp_context = qp;
> +	qp->pd = NULL;
> +	qp->send_cq = qp->recv_cq = NULL;
> +	qp->srq = NULL;
> +	qp->xrcd = qp_init_attr->xrcd;
> +	atomic_inc(&qp_init_attr->xrcd->usecnt);
> +	INIT_LIST_HEAD(&qp->open_list);
> +
> +	qp = __ib_open_qp(real_qp, qp_init_attr->event_handler,
> +			  qp_init_attr->qp_context);
> +	if (!IS_ERR(qp))
> +		__ib_insert_xrcd_qp(qp_init_attr->xrcd, real_qp);
> +	else
> +		real_qp->device->destroy_qp(real_qp);
> +	return qp;
> +}
> +
>  struct ib_qp *ib_create_qp(struct ib_pd *pd,
>  			   struct ib_qp_init_attr *qp_init_attr)
>  {
> -	struct ib_qp *qp, *real_qp;
> -	struct ib_device *device;
> +	struct ib_device *device = pd ? pd->device : qp_init_attr->xrcd->device;
> +	struct ib_qp *qp;
>  
> -	device = pd ? pd->device : qp_init_attr->xrcd->device;
>  	qp = device->create_qp(pd, qp_init_attr, NULL);
> -
> -	if (!IS_ERR(qp)) {
> -		qp->device     = device;
> -		qp->real_qp    = qp;
> -		qp->uobject    = NULL;
> -		qp->qp_type    = qp_init_attr->qp_type;
> -
> -		atomic_set(&qp->usecnt, 0);
> -		if (qp_init_attr->qp_type == IB_QPT_XRC_TGT) {
> -			qp->event_handler = __ib_shared_qp_event_handler;
> -			qp->qp_context = qp;
> -			qp->pd = NULL;
> -			qp->send_cq = qp->recv_cq = NULL;
> -			qp->srq = NULL;
> -			qp->xrcd = qp_init_attr->xrcd;
> -			atomic_inc(&qp_init_attr->xrcd->usecnt);
> -			INIT_LIST_HEAD(&qp->open_list);
> -
> -			real_qp = qp;
> -			qp = __ib_open_qp(real_qp, qp_init_attr->event_handler,
> -					  qp_init_attr->qp_context);
> -			if (!IS_ERR(qp))
> -				__ib_insert_xrcd_qp(qp_init_attr->xrcd, real_qp);
> -			else
> -				real_qp->device->destroy_qp(real_qp);
> -		} else {
> -			qp->event_handler = qp_init_attr->event_handler;
> -			qp->qp_context = qp_init_attr->qp_context;
> -			if (qp_init_attr->qp_type == IB_QPT_XRC_INI) {
> -				qp->recv_cq = NULL;
> -				qp->srq = NULL;
> -			} else {
> -				qp->recv_cq = qp_init_attr->recv_cq;
> -				atomic_inc(&qp_init_attr->recv_cq->usecnt);
> -				qp->srq = qp_init_attr->srq;
> -				if (qp->srq)
> -					atomic_inc(&qp_init_attr->srq->usecnt);
> -			}
> -
> -			qp->pd	    = pd;
> -			qp->send_cq = qp_init_attr->send_cq;
> -			qp->xrcd    = NULL;
> -
> -			atomic_inc(&pd->usecnt);
> -			atomic_inc(&qp_init_attr->send_cq->usecnt);
> -		}
> +	if (IS_ERR(qp))
> +		return qp;
> +
> +	qp->device     = device;
> +	qp->real_qp    = qp;
> +	qp->uobject    = NULL;
> +	qp->qp_type    = qp_init_attr->qp_type;
> +
> +	atomic_set(&qp->usecnt, 0);
> +	if (qp_init_attr->qp_type == IB_QPT_XRC_TGT)
> +		return ib_create_xrc_qp(qp, qp_init_attr);
> +
> +	qp->event_handler = qp_init_attr->event_handler;
> +	qp->qp_context = qp_init_attr->qp_context;
> +	if (qp_init_attr->qp_type == IB_QPT_XRC_INI) {
> +		qp->recv_cq = NULL;
> +		qp->srq = NULL;
> +	} else {
> +		qp->recv_cq = qp_init_attr->recv_cq;
> +		atomic_inc(&qp_init_attr->recv_cq->usecnt);
> +		qp->srq = qp_init_attr->srq;
> +		if (qp->srq)
> +			atomic_inc(&qp_init_attr->srq->usecnt);
>  	}
>  
> +	qp->pd	    = pd;
> +	qp->send_cq = qp_init_attr->send_cq;
> +	qp->xrcd    = NULL;
> +
> +	atomic_inc(&pd->usecnt);
> +	atomic_inc(&qp_init_attr->send_cq->usecnt);
>  	return qp;
>  }
>  EXPORT_SYMBOL(ib_create_qp);
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
