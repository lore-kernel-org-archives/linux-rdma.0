From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 for-rc 1/8] RDMA/vmw_pvrdma: Clarify QP and CQ
 is_kernel logic
Date: Thu, 14 Dec 2017 11:30:17 +0200
Message-ID: <20171214093016.GB3254@yuvallap>
References: <20171214001753.GA9780@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171214001937.GA11378@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171214001937.GA11378-qXbCdz4EeRo1jLI2hToXVI42T8aCTgcwy4vvyvUx+exJXi8ZT2ovy+oDBWuYMCC/JZORHMmSJCU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 13, 2017 at 04:19:43PM -0800, Bryan Tan wrote:
> Be more consistent in setting and checking is_kernel
> flag for QPs and CQs.
> 
> Reviewed-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c | 9 ++++-----
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c | 7 +++----
>  2 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
> index 3562c0c..ea8db5e6 100644
> --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
> @@ -132,8 +132,9 @@ struct ib_cq *pvrdma_create_cq(struct ib_device *ibdev,
>  	}
>  
>  	cq->ibcq.cqe = entries;
> +	cq->is_kernel = !context;
>  
> -	if (context) {
> +	if (!cq->is_kernel) {
>  		if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd))) {
>  			ret = -EFAULT;
>  			goto err_cq;
> @@ -148,8 +149,6 @@ struct ib_cq *pvrdma_create_cq(struct ib_device *ibdev,
>  
>  		npages = ib_umem_page_count(cq->umem);
>  	} else {
> -		cq->is_kernel = true;
> -
>  		/* One extra page for shared ring state */
>  		npages = 1 + (entries * sizeof(struct pvrdma_cqe) +
>  			      PAGE_SIZE - 1) / PAGE_SIZE;
> @@ -202,7 +201,7 @@ struct ib_cq *pvrdma_create_cq(struct ib_device *ibdev,
>  	dev->cq_tbl[cq->cq_handle % dev->dsr->caps.max_cq] = cq;
>  	spin_unlock_irqrestore(&dev->cq_tbl_lock, flags);
>  
> -	if (context) {
> +	if (!cq->is_kernel) {
>  		cq->uar = &(to_vucontext(context)->uar);
>  
>  		/* Copy udata back. */
> @@ -219,7 +218,7 @@ struct ib_cq *pvrdma_create_cq(struct ib_device *ibdev,
>  err_page_dir:
>  	pvrdma_page_dir_cleanup(dev, &cq->pdir);
>  err_umem:
> -	if (context)
> +	if (!cq->is_kernel)
>  		ib_umem_release(cq->umem);
>  err_cq:
>  	atomic_dec(&dev->num_cqs);
> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
> index 10420a1..b932b7e 100644
> --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
> @@ -249,8 +249,9 @@ struct ib_qp *pvrdma_create_qp(struct ib_pd *pd,
>  		init_waitqueue_head(&qp->wait);
>  
>  		qp->state = IB_QPS_RESET;
> +		qp->is_kernel = !(pd->uobject && udata);
>  
> -		if (pd->uobject && udata) {
> +		if (!qp->is_kernel) {
>  			dev_dbg(&dev->pdev->dev,
>  				"create queuepair from user space\n");
>  
> @@ -291,8 +292,6 @@ struct ib_qp *pvrdma_create_qp(struct ib_pd *pd,
>  				qp->npages_recv = 0;
>  			qp->npages = qp->npages_send + qp->npages_recv;
>  		} else {
> -			qp->is_kernel = true;
> -
>  			ret = pvrdma_set_sq_size(to_vdev(pd->device),
>  						 &init_attr->cap, qp);
>  			if (ret)
> @@ -394,7 +393,7 @@ struct ib_qp *pvrdma_create_qp(struct ib_pd *pd,
>  err_pdir:
>  	pvrdma_page_dir_cleanup(dev, &qp->pdir);
>  err_umem:
> -	if (pd->uobject && udata) {
> +	if (!qp->is_kernel) {
>  		if (qp->rumem)
>  			ib_umem_release(qp->rumem);
>  		if (qp->sumem)
> -- 
> 1.8.5.6

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
