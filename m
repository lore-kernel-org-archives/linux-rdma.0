From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH RESEND 10/11] staging/rdma/hfi1: Eliminate WARN_ON when
 VL is invalid
Date: Fri, 6 Nov 2015 19:26:14 -0800
Message-ID: <20151107032614.GB4920@kroah.com>
References: <1446858426-30509-1-git-send-email-jubin.john@intel.com>
 <1446858426-30509-11-git-send-email-jubin.john@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1446858426-30509-11-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 06, 2015 at 08:07:05PM -0500, Jubin John wrote:
> From: Ira Weiny <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> sdma_select_engine_vl only needs to protect itself from an invalid VL.
> Something higher up the stack should be warning the user when they try
> to use an SL which maps to an invalid VL.
> 
> Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Ira Weiny <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/staging/rdma/hfi1/sdma.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
> index 2a1da21..998bf43 100644
> --- a/drivers/staging/rdma/hfi1/sdma.c
> +++ b/drivers/staging/rdma/hfi1/sdma.c
> @@ -777,8 +777,14 @@ struct sdma_engine *sdma_select_engine_vl(
>  	struct sdma_map_elem *e;
>  	struct sdma_engine *rval;
>  
> -	if (WARN_ON(vl > 8))
> -		return NULL;
> +	/* NOTE This should only happen if SC->VL changed after the initial
> +	 *      checks on the QP/AH
> +	 *      Default will return engine 0 below
> +	 */
> +	if (unlikely(vl >= num_vls)) {

Can you prove that unlikely() makes a measured difference here?  If not,
please remove it.  If you can, please provide the proof in the changelog
when you resend it.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
