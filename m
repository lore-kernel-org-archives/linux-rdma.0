From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/uverbs: Fix the check for port number
Date: Mon, 7 Aug 2017 14:03:08 +0300
Message-ID: <20170807110307.GB2462@yuvallap>
References: <1501085686-12916-1-git-send-email-mustafa.ismail@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1501085686-12916-1-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, "# v4 . 2-v4 . 9" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 26, 2017 at 11:14:46AM -0500, Mustafa Ismail wrote:
> The port number is only valid if IB_QP_PORT is set in the mask.
> So only check port number if it is valid to prevent modify_qp
> from failing due to an invalid port number.
> 
> Fixes: 5ecce4c9b17b("Check port number supplied by user verbs cmds")
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.2-v4.9
> Cc: <security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Upstream commit 5a7a88f1b488("Fix the check for port number")
> Modified from upstream commit: helper function rdma_is_port_valid does not
> exist in these kernel versions.
> ---
>  drivers/infiniband/core/uverbs_cmd.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> index 01e3a37..d118ffe 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -2342,8 +2342,9 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
>  	if (copy_from_user(&cmd, buf, sizeof cmd))
>  		return -EFAULT;
>  
> -	if (cmd.port_num < rdma_start_port(ib_dev) ||
> -	    cmd.port_num > rdma_end_port(ib_dev))
> +	if ((cmd.attr_mask & IB_QP_PORT) &&
> +	    (cmd.port_num < rdma_start_port(ib_dev) ||
> +	     cmd.port_num > rdma_end_port(ib_dev)))

Please use rdma_is_port_valid

>  		return -EINVAL;
>  
>  	INIT_UDATA(&udata, buf + sizeof cmd, NULL, in_len - sizeof cmd,
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
