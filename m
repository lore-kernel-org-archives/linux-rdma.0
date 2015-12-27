From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH 3/6] IB/uapi: expose uverbs WC opcodes
Date: Sun, 27 Dec 2015 08:12:02 +0200
Message-ID: <20151227061202.GB8501@leon.nu>
References: <1450967967-12479-1-git-send-email-hch@lst.de>
 <1450967967-12479-4-git-send-email-hch@lst.de>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1450967967-12479-4-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 24, 2015 at 03:39:24PM +0100, Christoph Hellwig wrote:
> This exposes the WC opcodes supported by uverbs as part of the uapi
> headers.  It follows the same scheme as the WR opcodes.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  include/rdma/ib_verbs.h      | 29 +++++++++++++----------------
>  include/uapi/rdma/ib_verbs.h | 16 ++++++++++++++++
>  2 files changed, 29 insertions(+), 16 deletions(-)
> 
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 5dccc6a..7dce204 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -819,22 +819,19 @@ enum ib_wc_status {
>  const char *__attribute_const__ ib_wc_status_msg(enum ib_wc_status status);
>  
>  enum ib_wc_opcode {
> -	IB_WC_SEND,
> -	IB_WC_RDMA_WRITE,
> -	IB_WC_RDMA_READ,
> -	IB_WC_COMP_SWAP,
> -	IB_WC_FETCH_ADD,
> -	IB_WC_LSO,
> -	IB_WC_LOCAL_INV,
> -	IB_WC_REG_MR,
> -	IB_WC_MASKED_COMP_SWAP,
> -	IB_WC_MASKED_FETCH_ADD,
> -/*
> - * Set value of IB_WC_RECV so consumers can test if a completion is a
> - * receive by testing (opcode & IB_WC_RECV).
> - */
> -	IB_WC_RECV			= 1 << 7,
> -	IB_WC_RECV_RDMA_WITH_IMM
> +	IB_WC_SEND		= IB_UVERBS_WC_SEND,
> +	IB_WC_RDMA_WRITE	= IB_UVERBS_WC_RDMA_WRITE,
> +	IB_WC_RDMA_READ		= IB_UVERBS_WC_RDMA_READ,
> +	IB_WC_COMP_SWAP		= IB_UVERBS_WC_COMP_SWAP,
> +	IB_WC_FETCH_ADD		= IB_UVERBS_WC_FETCH_ADD,
> +	IB_WC_LSO		= IB_UVERBS_WC_SEND_END,
> +	IB_WC_LOCAL_INV		= IB_UVERBS_WC_SEND_END + 1,
> +	IB_WC_REG_MR		= IB_UVERBS_WC_SEND_END + 2,
> +	IB_WC_MASKED_COMP_SWAP	= IB_UVERBS_WC_SEND_END + 3,
> +	IB_WC_MASKED_FETCH_ADD	= IB_UVERBS_WC_SEND_END + 4,
As you did it in the first patch, just don't assign after IB_WC_LOCAL_INV.
Compiler will handle IB_UVERS_WC_SEND_END + X calculations by itself.
> +
> +	IB_WC_RECV		= IB_UVERBS_WC_RECV,
> +	IB_WC_RECV_RDMA_WITH_IMM = IB_UVERBS_WC_RECV_END,
>  };
>  
>  enum ib_wc_flags {
> diff --git a/include/uapi/rdma/ib_verbs.h b/include/uapi/rdma/ib_verbs.h
> index 3be3152..fd7a393 100644
> --- a/include/uapi/rdma/ib_verbs.h
> +++ b/include/uapi/rdma/ib_verbs.h
> @@ -29,4 +29,20 @@ enum ib_uverbs_send_flags {
>  	IB_UVERBS_SEND_END			= (1 << 5),
>  };
>  
> +enum ib_uverbs_wc_opcode {
> +	IB_UVERBS_WC_SEND			= 0,
> +	IB_UVERBS_WC_RDMA_WRITE			= 1,
> +	IB_UVERBS_WC_RDMA_READ			= 2,
> +	IB_UVERBS_WC_COMP_SWAP			= 3,
> +	IB_UVERBS_WC_FETCH_ADD			= 4,
> +	IB_UVERBS_WC_SEND_END			= 5,
> +
> +	/*
> +	 * Set value of IB_WC_RECV so consumers can test if a completion is a
> +	 * receive by testing (opcode & IB_WC_RECV).
> +	 */
> +	IB_UVERBS_WC_RECV			= 1 << 7,
> +	IB_UVERBS_WC_RECV_END			= (1 << 7) + 1,
> +};
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
