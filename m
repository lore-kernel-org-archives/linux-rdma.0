From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next v1 2/2] RDMA/vmw_pvrdma: Fix a signedness
Date: Wed, 30 Aug 2017 17:19:11 +0300
Message-ID: <20170830141911.GC7003@yuvallap>
References: <cover.1504045411.git.aditr@vmware.com>
 <41188f37ed9e524e6f53759ec92f9dd94c8b47a1.1504045412.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <41188f37ed9e524e6f53759ec92f9dd94c8b47a1.1504045412.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 29, 2017 at 03:51:30PM -0700, Adit Ranadive wrote:
> Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
> Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
> index 8a12dc7..3562c0c 100644
> --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
> @@ -299,7 +299,7 @@ static inline struct pvrdma_cqe *get_cqe(struct pvrdma_cq *cq, int i)
>  
>  void _pvrdma_flush_cqe(struct pvrdma_qp *qp, struct pvrdma_cq *cq)
>  {
> -	int head;
> +	unsigned int head;
>  	int has_data;
>  

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

>  	if (!cq->is_kernel)
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
