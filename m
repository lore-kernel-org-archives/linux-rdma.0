From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] IB/vmw_pvrdma: Dont hardcode QP header page
Date: Wed, 11 Jan 2017 09:09:53 +0200
Message-ID: <20170111070952.GB5620@yuval-lap.uk.oracle.com>
References: <cover.1484075557.git.aditr@vmware.com>
 <2035e9eca59810687d9b53d7d6e603b765729b1f.1484075557.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2035e9eca59810687d9b53d7d6e603b765729b1f.1484075557.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 10, 2017 at 11:15:41AM -0800, Adit Ranadive wrote:
> Moved the header page count to a macro [1]. In a future patch we will
> separate out the allocation for the header page. Thanks Yuval.
> Also, clear out the alloc_ucontext user response [2]. Thanks Dan.

Though i appreciate the above acknowledgment i'm not sure it can be part of
the commit message.

> 
> [1] - http://marc.info/?l=linux-rdma&m=148101146228847&w=2
> [2] - http://marc.info/?l=linux-rdma&m=148351229926333&w=2

Same here.

> 
> Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
> Reported-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma.h       | 1 +
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c    | 9 +++++----
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c | 2 +-
>  3 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
> index ee6a941..5dada5a 100644
> --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
> @@ -70,6 +70,7 @@
>  #define PCI_DEVICE_ID_VMWARE_PVRDMA	0x0820
>  
>  #define PVRDMA_NUM_RING_PAGES		4
> +#define PVRDMA_QP_NUM_HEADER_PAGES	1
>  
>  struct pvrdma_dev;
>  
> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
> index 765bd32..3e23425 100644
> --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
> @@ -170,8 +170,9 @@ static int pvrdma_set_sq_size(struct pvrdma_dev *dev, struct ib_qp_cap *req_cap,
>  					     sizeof(struct pvrdma_sge) *
>  					     qp->sq.max_sg);
>  	/* Note: one extra page for the header. */
> -	qp->npages_send = 1 + (qp->sq.wqe_cnt * qp->sq.wqe_size +
> -			       PAGE_SIZE - 1) / PAGE_SIZE;
> +	qp->npages_send = PVRDMA_QP_NUM_HEADER_PAGES +
> +			  (qp->sq.wqe_cnt * qp->sq.wqe_size + PAGE_SIZE - 1) /
> +								PAGE_SIZE;
>  
>  	return 0;
>  }
> @@ -289,7 +290,7 @@ struct ib_qp *pvrdma_create_qp(struct ib_pd *pd,
>  			qp->npages = qp->npages_send + qp->npages_recv;
>  
>  			/* Skip header page. */
> -			qp->sq.offset = PAGE_SIZE;
> +			qp->sq.offset = PVRDMA_QP_NUM_HEADER_PAGES * PAGE_SIZE;
>  
>  			/* Recv queue pages are after send pages. */
>  			qp->rq.offset = qp->npages_send * PAGE_SIZE;
> @@ -342,7 +343,7 @@ struct ib_qp *pvrdma_create_qp(struct ib_pd *pd,
>  	cmd->qp_type = ib_qp_type_to_pvrdma(init_attr->qp_type);
>  	cmd->access_flags = IB_ACCESS_LOCAL_WRITE;
>  	cmd->total_chunks = qp->npages;
> -	cmd->send_chunks = qp->npages_send - 1;
> +	cmd->send_chunks = qp->npages_send - PVRDMA_QP_NUM_HEADER_PAGES;
>  	cmd->pdir_dma = qp->pdir.dir_dma;
>  
>  	dev_dbg(&dev->pdev->dev, "create queuepair with %d, %d, %d, %d\n",
> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
> index 5489137..c2aa526 100644
> --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
> @@ -306,7 +306,7 @@ struct ib_ucontext *pvrdma_alloc_ucontext(struct ib_device *ibdev,
>  	union pvrdma_cmd_resp rsp;
>  	struct pvrdma_cmd_create_uc *cmd = &req.create_uc;
>  	struct pvrdma_cmd_create_uc_resp *resp = &rsp.create_uc_resp;
> -	struct pvrdma_alloc_ucontext_resp uresp;
> +	struct pvrdma_alloc_ucontext_resp uresp = {0};
>  	int ret;
>  	void *ptr;

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

>  
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
