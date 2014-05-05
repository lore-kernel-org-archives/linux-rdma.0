From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 4/4] RDMA/cxgb4: add missing padding at end of struct c4iw_alloc_ucontext_resp
Date: Mon, 5 May 2014 10:06:19 -0500
Message-ID: <005401cf6873$9216f6e0$b644e4a0$@opengridcomputing.com>
References: <cover.1399216475.git.ydroneaud@opteya.com> <2236129ab4aa1ad1562858f363fb6fef0d6bc93b.1399216475.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2236129ab4aa1ad1562858f363fb6fef0d6bc93b.1399216475.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Yann Droneaud' <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, 'Steve Wise' <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, 'Roland Dreier' <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

<snip>

> diff --git a/drivers/infiniband/hw/cxgb4/provider.c
b/drivers/infiniband/hw/cxgb4/provider.c
> index a94a3e12c349..9ba01d524f51 100644
> --- a/drivers/infiniband/hw/cxgb4/provider.c
> +++ b/drivers/infiniband/hw/cxgb4/provider.c
> @@ -122,7 +122,7 @@ static struct ib_ucontext *c4iw_alloc_ucontext(struct ib_device
*ibdev,
>  	INIT_LIST_HEAD(&context->mmaps);
>  	spin_lock_init(&context->mmap_lock);
> 
> -	if (udata->outlen < sizeof(uresp)) {
> +	if (udata->outlen < sizeof(uresp) - sizeof(uresp.reserved)) {
>  		if (!warned++)
>  			pr_err(MOD "Warning - downlevel libcxgb4 (non-fatal), device
status
> page disabled.");
>  		rhp->rdev.flags |= T4_STATUS_PAGE_DISABLED;
> @@ -134,13 +134,13 @@ static struct ib_ucontext *c4iw_alloc_ucontext(struct ib_device
> *ibdev,
>  		}
> 
>  		uresp.status_page_size = PAGE_SIZE;
> 
>  		spin_lock(&context->mmap_lock);
>  		uresp.status_page_key = context->key;
>  		context->key += PAGE_SIZE;
>  		spin_unlock(&context->mmap_lock);
> 
> -		ret = ib_copy_to_udata(udata, &uresp, sizeof(uresp));
> +		ret = ib_copy_to_udata(udata, &uresp, sizeof(uresp) -
sizeof(uresp.reserved));
>  		if (ret)
>  			goto err_mm;
> 

This chunk doesn't apply.  Not sure why.  I can use -F 6 with patch, but it should apply
cleanly. Can you please respin this against 89ca3b8 Linux 3.15-rc4?

I'll test the cxgb4 stuff today. 

Thanks,

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
