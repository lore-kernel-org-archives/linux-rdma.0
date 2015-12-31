From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/6] IB/uapi: expose uverbs send WR flags
Date: Thu, 31 Dec 2015 16:45:25 +0200
Message-ID: <56853F85.4060100@mellanox.com>
References: <1450967967-12479-1-git-send-email-hch@lst.de>
 <1450967967-12479-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450967967-12479-3-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 24/12/2015 16:39, Christoph Hellwig wrote:
> This exposes the send WR flags supported by uverbs as part of the uapi
> headers.  It follows the same scheme as the WR opcodes.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/mlx5_ib.h |  6 +++---
>  include/rdma/ib_verbs.h              | 14 ++++++--------
>  include/uapi/rdma/ib_verbs.h         |  9 +++++++++
>  3 files changed, 18 insertions(+), 11 deletions(-)
> 

> diff --git a/include/uapi/rdma/ib_verbs.h b/include/uapi/rdma/ib_verbs.h
> index 330175e..3be3152 100644
> --- a/include/uapi/rdma/ib_verbs.h
> +++ b/include/uapi/rdma/ib_verbs.h
> @@ -20,4 +20,13 @@ enum ib_uverbs_wr_opcode {
>  	IB_UVERBS_WR_END			= 9,
>  };
>  
> +enum ib_uverbs_send_flags {
> +	IB_UVERBS_SEND_FENCE			= (1 << 0),
> +	IB_UVERBS_SEND_SIGNALED			= (1 << 1),
> +	IB_UVERBS_SEND_SOLICITED		= (1 << 2),
> +	IB_UVERBS_SEND_INLINE			= (1 << 3),
> +	IB_UVERBS_SEND_IP_CSUM			= (1 << 4),
> +	IB_UVERBS_SEND_END			= (1 << 5),

Do you think we need a check in ib_uverbs_post_send to see only 
user flags are passed? I think it would be safer.

Other than that,
Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
