From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH 5/6] IB/uapi: expose uverbs WC status codes
Date: Sun, 27 Dec 2015 08:17:44 +0200
Message-ID: <20151227061744.GD8501@leon.nu>
References: <1450967967-12479-1-git-send-email-hch@lst.de>
 <1450967967-12479-6-git-send-email-hch@lst.de>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1450967967-12479-6-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 24, 2015 at 03:39:26PM +0100, Christoph Hellwig wrote:
> This exposes the WC status codes supported by uverbs as part of the uapi
> headers.  It follows the same scheme as the WR opcodes.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  include/rdma/ib_verbs.h      | 44 ++++++++++++++++++++++----------------------
>  include/uapi/rdma/ib_verbs.h | 25 +++++++++++++++++++++++++
>  2 files changed, 47 insertions(+), 22 deletions(-)
> 
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 337db70..48bfcf5 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -792,28 +792,28 @@ struct ib_ah_attr {
>  };
>  
>  enum ib_wc_status {
> -	IB_WC_SUCCESS,
> -	IB_WC_LOC_LEN_ERR,
> -	IB_WC_LOC_QP_OP_ERR,
> -	IB_WC_LOC_EEC_OP_ERR,
> -	IB_WC_LOC_PROT_ERR,
> -	IB_WC_WR_FLUSH_ERR,
> -	IB_WC_MW_BIND_ERR,
> -	IB_WC_BAD_RESP_ERR,
> -	IB_WC_LOC_ACCESS_ERR,
> -	IB_WC_REM_INV_REQ_ERR,
> -	IB_WC_REM_ACCESS_ERR,
> -	IB_WC_REM_OP_ERR,
> -	IB_WC_RETRY_EXC_ERR,
> -	IB_WC_RNR_RETRY_EXC_ERR,
> -	IB_WC_LOC_RDD_VIOL_ERR,
> -	IB_WC_REM_INV_RD_REQ_ERR,
> -	IB_WC_REM_ABORT_ERR,
> -	IB_WC_INV_EECN_ERR,
> -	IB_WC_INV_EEC_STATE_ERR,
> -	IB_WC_FATAL_ERR,
> -	IB_WC_RESP_TIMEOUT_ERR,
> -	IB_WC_GENERAL_ERR
> +	IB_WC_SUCCESS		= IB_UVERBS_WC_SUCCESS,
> +	IB_WC_LOC_LEN_ERR	= IB_UVERBS_WC_LOC_LEN_ERR,
> +	IB_WC_LOC_QP_OP_ERR	= IB_UVERBS_WC_LOC_QP_OP_ERR,
> +	IB_WC_LOC_EEC_OP_ERR	= IB_UVERBS_WC_LOC_EEC_OP_ERR,
> +	IB_WC_LOC_PROT_ERR	= IB_UVERBS_WC_LOC_PROT_ERR,
> +	IB_WC_WR_FLUSH_ERR	= IB_UVERBS_WC_WR_FLUSH_ERR,
> +	IB_WC_MW_BIND_ERR	= IB_UVERBS_WC_MW_BIND_ERR,
> +	IB_WC_BAD_RESP_ERR	= IB_UVERBS_WC_BAD_RESP_ERR,
> +	IB_WC_LOC_ACCESS_ERR	= IB_UVERBS_WC_LOC_ACCESS_ERR,
> +	IB_WC_REM_INV_REQ_ERR	= IB_UVERBS_WC_REM_INV_REQ_ERR,
> +	IB_WC_REM_ACCESS_ERR	= IB_UVERBS_WC_REM_ACCESS_ERR,
> +	IB_WC_REM_OP_ERR	= IB_UVERBS_WC_REM_OP_ERR,
> +	IB_WC_RETRY_EXC_ERR	= IB_UVERBS_WC_RETRY_EXC_ERR,
> +	IB_WC_RNR_RETRY_EXC_ERR	= IB_UVERBS_WC_RNR_RETRY_EXC_ERR,
> +	IB_WC_LOC_RDD_VIOL_ERR	= IB_UVERBS_WC_LOC_RDD_VIOL_ERR,
> +	IB_WC_REM_INV_RD_REQ_ERR= IB_UVERBS_WC_REM_INV_RD_REQ_ERR,
> +	IB_WC_REM_ABORT_ERR	= IB_UVERBS_WC_REM_ABORT_ERR,
> +	IB_WC_INV_EECN_ERR	= IB_UVERBS_WC_INV_EECN_ERR,
> +	IB_WC_INV_EEC_STATE_ERR = IB_UVERBS_WC_INV_EEC_STATE_ERR,
> +	IB_WC_FATAL_ERR		= IB_UVERBS_WC_FATAL_ERR,
> +	IB_WC_RESP_TIMEOUT_ERR	= IB_UVERBS_WC_RESP_TIMEOUT_ERR,
> +	IB_WC_GENERAL_ERR	= IB_UVERBS_WC_GENERAL_ERR,
>  };
>  
>  const char *__attribute_const__ ib_wc_status_msg(enum ib_wc_status status);
> diff --git a/include/uapi/rdma/ib_verbs.h b/include/uapi/rdma/ib_verbs.h
> index c40c00b..fbadb29 100644
> --- a/include/uapi/rdma/ib_verbs.h
> +++ b/include/uapi/rdma/ib_verbs.h
> @@ -55,4 +55,29 @@ enum ib_uverbs_wc_flags {
>  	IB_UVERBS_WC_WITH_NETWORK_HDR_TYPE	= (1 << 6),
>  };
>  
> +enum ib_uverbs_wc_status {
> +	IB_UVERBS_WC_SUCCESS,
> +	IB_UVERBS_WC_LOC_LEN_ERR,
> +	IB_UVERBS_WC_LOC_QP_OP_ERR,
> +	IB_UVERBS_WC_LOC_EEC_OP_ERR,
> +	IB_UVERBS_WC_LOC_PROT_ERR,
> +	IB_UVERBS_WC_WR_FLUSH_ERR,
> +	IB_UVERBS_WC_MW_BIND_ERR,
> +	IB_UVERBS_WC_BAD_RESP_ERR,
> +	IB_UVERBS_WC_LOC_ACCESS_ERR,
> +	IB_UVERBS_WC_REM_INV_REQ_ERR,
> +	IB_UVERBS_WC_REM_ACCESS_ERR,
> +	IB_UVERBS_WC_REM_OP_ERR,
> +	IB_UVERBS_WC_RETRY_EXC_ERR,
> +	IB_UVERBS_WC_RNR_RETRY_EXC_ERR,
> +	IB_UVERBS_WC_LOC_RDD_VIOL_ERR,
> +	IB_UVERBS_WC_REM_INV_RD_REQ_ERR,
> +	IB_UVERBS_WC_REM_ABORT_ERR,
> +	IB_UVERBS_WC_INV_EECN_ERR,
> +	IB_UVERBS_WC_INV_EEC_STATE_ERR,
> +	IB_UVERBS_WC_FATAL_ERR,
> +	IB_UVERBS_WC_RESP_TIMEOUT_ERR,
> +	IB_UVERBS_WC_GENERAL_ERR
> +};
The same as in previous mail, mark it as a _STATUS_ in the name.
> +
>  #endif /* _UAPI_RDMA_IB_VERBS_H */
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
