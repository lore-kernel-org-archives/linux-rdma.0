From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next v1 1/2] RDMA/vmw_pvrdma: Report network header
 type in WC
Date: Wed, 30 Aug 2017 17:19:32 +0300
Message-ID: <20170830141931.GD7003@yuvallap>
References: <cover.1504045411.git.aditr@vmware.com>
 <2abd8333de3bb9a2e609f107b1826470a54d1c30.1504045411.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2abd8333de3bb9a2e609f107b1826470a54d1c30.1504045411.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 29, 2017 at 03:51:29PM -0700, Adit Ranadive wrote:
> From: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> 
> We should report the network header type in the work completion so that
> the kernel can infer the right RoCE type headers.
> 
> Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c | 1 +
>  include/uapi/rdma/vmw_pvrdma-abi.h           | 6 ++++--
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
> index 90aa326..8a12dc7 100644
> --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
> @@ -389,6 +389,7 @@ static int pvrdma_poll_one(struct pvrdma_cq *cq, struct pvrdma_qp **cur_qp,
>  	wc->dlid_path_bits = cqe->dlid_path_bits;
>  	wc->port_num = cqe->port_num;
>  	wc->vendor_err = cqe->vendor_err;
> +	wc->network_hdr_type = cqe->network_hdr_type;
>  
>  	/* Update shared ring state */
>  	pvrdma_idx_ring_inc(&cq->ring_state->rx.cons_head, cq->ibcq.cqe);
> diff --git a/include/uapi/rdma/vmw_pvrdma-abi.h b/include/uapi/rdma/vmw_pvrdma-abi.h
> index c8c1d2d..c6569b0 100644
> --- a/include/uapi/rdma/vmw_pvrdma-abi.h
> +++ b/include/uapi/rdma/vmw_pvrdma-abi.h
> @@ -125,7 +125,8 @@ enum pvrdma_wc_flags {
>  	PVRDMA_WC_IP_CSUM_OK		= 1 << 3,
>  	PVRDMA_WC_WITH_SMAC		= 1 << 4,
>  	PVRDMA_WC_WITH_VLAN		= 1 << 5,
> -	PVRDMA_WC_FLAGS_MAX		= PVRDMA_WC_WITH_VLAN,
> +	PVRDMA_WC_WITH_NETWORK_HDR_TYPE	= 1 << 6,
> +	PVRDMA_WC_FLAGS_MAX		= PVRDMA_WC_WITH_NETWORK_HDR_TYPE,
>  };
>  
>  struct pvrdma_alloc_ucontext_resp {
> @@ -283,7 +284,8 @@ struct pvrdma_cqe {
>  	__u8 dlid_path_bits;
>  	__u8 port_num;
>  	__u8 smac[6];
> -	__u8 reserved2[7]; /* Pad to next power of 2 (64). */
> +	__u8 network_hdr_type;
> +	__u8 reserved2[6]; /* Pad to next power of 2 (64). */
>  };

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

>  
>  #endif /* __VMW_PVRDMA_ABI_H__ */
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
