From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/8] staging/rdma/hfi1: remove unneeded goto done
Date: Wed, 11 Nov 2015 12:01:08 +0300
Message-ID: <20151111090108.GB18797@mwanda>
References: <1447220589-9067-1-git-send-email-ira.weiny@intel.com>
 <1447220589-9067-5-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447220589-9067-5-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 11, 2015 at 12:43:05AM -0500, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> This goto done is followed by an if (ret) break in the outer switch clause.  It
> is unnecessary.
> 
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/staging/rdma/hfi1/diag.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
> index 2bb857b2a103..556a47591989 100644
> --- a/drivers/staging/rdma/hfi1/diag.c
> +++ b/drivers/staging/rdma/hfi1/diag.c
> @@ -1053,7 +1053,6 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
>  				break;
>  			default:
>  				ret = -EINVAL;
> -				goto done;
>  			}
>  			ret = set_link_state(ppd, dev_state);
>  			break;

Wut?  No it's not.

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
