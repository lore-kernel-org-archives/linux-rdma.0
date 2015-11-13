From: Sudip Mukherjee <sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/13] staging/rdma/hfi1: Use BIT macro
Date: Fri, 13 Nov 2015 18:45:58 +0530
Message-ID: <20151113131558.GC18741@sudip-pc>
References: <1447227213-15122-1-git-send-email-jubin.john@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447227213-15122-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 11, 2015 at 02:33:21AM -0500, Jubin John wrote:
> This patch fixes the checkpatch issue:
> CHECK: Prefer using the BIT macro
> 
> Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
<snip>
>  
> diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
> index 8666f3a..680f877 100644
> --- a/drivers/staging/rdma/hfi1/init.c
> +++ b/drivers/staging/rdma/hfi1/init.c
> @@ -252,7 +252,7 @@ struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u32 ctxt)
>  		/* Validate and initialize Rcv Hdr Q variables */
>  		if (rcvhdrcnt % HDRQ_INCREMENT) {
>  			dd_dev_err(dd,
> -				   "ctxt%u: header queue count %d must be divisible by %d\n",
> +				   "ctxt%u: header queue count %d must be divisible by %lud\n",

This is an unrelated change. If you are sending the series based on
Dan's comment on 12/13 then please remove this also.

regards
sudip
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
