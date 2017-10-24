From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-next] RDMA/cxgb4: Remove unnecessary conversion from __be32 to cpu format
Date: Tue, 24 Oct 2017 13:42:16 -0500
Message-ID: <067301d34cf7$d0872ff0$71958fd0$@opengridcomputing.com>
References: <20171024182848.7945-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171024182848.7945-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> The scqe.stag is actually declared in u32 format and don't need
> conversion from __be32 to cpu format.
> 
> Remove the be32_to_cpu() and avoid the following sparse error.
>   drivers/infiniband/hw/cxgb4/cq.c:754:52: warning: cast to restricted __be32
> 
> Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/hw/cxgb4/t4.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/cxgb4/t4.h
b/drivers/infiniband/hw/cxgb4/t4.h
> index 2b44fa850bbb..a16f3596f5a8 100644
> --- a/drivers/infiniband/hw/cxgb4/t4.h
> +++ b/drivers/infiniband/hw/cxgb4/t4.h
> @@ -234,7 +234,7 @@ struct t4_cqe {
> 
>  /* used for SQ completion processing */
>  #define CQE_WRID_SQ_IDX(x)	((x)->u.scqe.cidx)
> -#define CQE_WRID_FR_STAG(x)     (be32_to_cpu((x)->u.scqe.stag))
> +#define CQE_WRID_FR_STAG(x)     ((x)->u.scqe.stag)

This is incorrect.  The stag is filled in by HW which is BE.  The declaration of
scqe.stag needs to be __be32.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
