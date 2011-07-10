From: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>
Subject: Re: [PATCH] drivers/infiniband/hw/qib/qib_iba7322: remove double
 define
Date: Mon, 11 Jul 2011 00:32:38 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1107110032300.2818@swampdragon.chaosbits.net>
References: <1310334587-26731-1-git-send-email-edwin@cheatah.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1310334587-26731-1-git-send-email-edwin-D/SLrjtaAwnz+pZb47iToQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Edwin van Vliet <edwin-D/SLrjtaAwnz+pZb47iToQ@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org, mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org, ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, 10 Jul 2011, Edwin van Vliet wrote:

> Double define removed.
> 
> Signed-off-by: Edwin van Vliet <edwin-D/SLrjtaAwnz+pZb47iToQ@public.gmane.org>
> ---
>  drivers/infiniband/hw/qib/qib_iba7322.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
> index 8ec5237..821226c 100644
> --- a/drivers/infiniband/hw/qib/qib_iba7322.c
> +++ b/drivers/infiniband/hw/qib/qib_iba7322.c
> @@ -397,7 +397,6 @@ MODULE_PARM_DESC(txselect, \
>  #define crp_txdroppedpkt CREG_IDX(TxDroppedPktCnt)
>  #define crp_txhdrerr CREG_IDX(TxHeadersErrCnt)
>  #define crp_txlenerr CREG_IDX(TxLenErrCnt)
> -#define crp_txlenerr CREG_IDX(TxLenErrCnt)
>  #define crp_txminmaxlenerr CREG_IDX(TxMaxMinLenErrCnt)
>  #define crp_txsdmadesc CREG_IDX(TxSDmaDescCnt)
>  #define crp_txunderrun CREG_IDX(TxUnderrunCnt)
> 
Reviewed-by: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>

-- 
Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
