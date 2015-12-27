From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH 4/6] IB/uapi: expose uverbs WC flags
Date: Sun, 27 Dec 2015 08:15:45 +0200
Message-ID: <20151227061545.GC8501@leon.nu>
References: <1450967967-12479-1-git-send-email-hch@lst.de>
 <1450967967-12479-5-git-send-email-hch@lst.de>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1450967967-12479-5-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 24, 2015 at 03:39:25PM +0100, Christoph Hellwig wrote:
> This exposes the WC flags supported by uverbs as part of the uapi
> headers.  It follows the same scheme as the WR opcodes.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  include/rdma/ib_verbs.h      | 14 +++++++-------
>  include/uapi/rdma/ib_verbs.h | 10 ++++++++++
>  2 files changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 7dce204..337db70 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -835,13 +835,13 @@ enum ib_wc_opcode {
>  };
>  
>  enum ib_wc_flags {
> -	IB_WC_GRH		= 1,
> -	IB_WC_WITH_IMM		= (1<<1),
> -	IB_WC_WITH_INVALIDATE	= (1<<2),
> -	IB_WC_IP_CSUM_OK	= (1<<3),
> -	IB_WC_WITH_SMAC		= (1<<4),
> -	IB_WC_WITH_VLAN		= (1<<5),
> -	IB_WC_WITH_NETWORK_HDR_TYPE	= (1<<6),
> +	IB_WC_GRH			= IB_UVERBS_WC_GRH,
> +	IB_WC_WITH_IMM			= IB_UVERBS_WC_WITH_IMM,
> +	IB_WC_WITH_INVALIDATE		= IB_UVERBS_WC_WITH_INVALIDATE,
> +	IB_WC_IP_CSUM_OK		= IB_UVERBS_WC_IP_CSUM_OK,
> +	IB_WC_WITH_SMAC			= IB_UVERBS_WC_WITH_SMAC,
> +	IB_WC_WITH_VLAN			= IB_UVERBS_WC_WITH_VLAN,
> +	IB_WC_WITH_NETWORK_HDR_TYPE	= IB_UVERBS_WC_WITH_NETWORK_HDR_TYPE,
>  };
>  
>  struct ib_wc {
> diff --git a/include/uapi/rdma/ib_verbs.h b/include/uapi/rdma/ib_verbs.h
> index fd7a393..c40c00b 100644
> --- a/include/uapi/rdma/ib_verbs.h
> +++ b/include/uapi/rdma/ib_verbs.h
> @@ -45,4 +45,14 @@ enum ib_uverbs_wc_opcode {
>  	IB_UVERBS_WC_RECV_END			= (1 << 7) + 1,
>  };
>  
> +enum ib_uverbs_wc_flags {
> +	IB_UVERBS_WC_GRH			= (1 << 0),
> +	IB_UVERBS_WC_WITH_IMM			= (1 << 1),
> +	IB_UVERBS_WC_WITH_INVALIDATE		= (1 << 2),
> +	IB_UVERBS_WC_IP_CSUM_OK			= (1 << 3),
> +	IB_UVERBS_WC_WITH_SMAC			= (1 << 4),
> +	IB_UVERBS_WC_WITH_VLAN			= (1 << 5),
> +	IB_UVERBS_WC_WITH_NETWORK_HDR_TYPE	= (1 << 6),
> +};
It will be great to add _FLAGS_ mark in the name and add _LAST too.
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
