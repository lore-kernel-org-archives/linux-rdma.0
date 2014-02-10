From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/ocrdma: fix traffic class shift
Date: Mon, 10 Feb 2014 12:28:21 +0300
Message-ID: <20140210092821.GA26776@mwanda>
References: <8b417e9b-fb15-4585-aba3-e9be06b7b12a@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8b417e9b-fb15-4585-aba3-e9be06b7b12a-3RiH6ntJJkOPfaB/Gd0HpljyZtpTMMwT@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 10, 2014 at 01:48:58PM +0530, Devesh Sharma wrote:
> Use correct value for obtaining traffic class from device
> response for Query QP request.
> 
> Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

regards,
dan carpenter

> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> index 7686dce..998f0de 100644
> --- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
> @@ -1415,7 +1415,7 @@ int ocrdma_query_qp(struct ib_qp *ibqp,
>  					  OCRDMA_QP_PARAMS_HOP_LMT_MASK) >>
>  						OCRDMA_QP_PARAMS_HOP_LMT_SHIFT;
>  	qp_attr->ah_attr.grh.traffic_class = (params.tclass_sq_psn &
> -					      OCRDMA_QP_PARAMS_SQ_PSN_MASK) >>
> +					      OCRDMA_QP_PARAMS_TCLASS_MASK) >>
>  						OCRDMA_QP_PARAMS_TCLASS_SHIFT;
>  
>  	qp_attr->ah_attr.ah_flags = IB_AH_GRH;
> -- 
> 1.7.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
