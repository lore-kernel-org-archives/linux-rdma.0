From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] rdma/ucm: Fix race in ucma_create_id
Date: Wed, 23 Mar 2011 16:38:35 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25DC5EF0E6@orsmsx501.amr.corp.intel.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC6C536C@orsmsx501.amr.corp.intel.com>
 <AANLkTinE3hzALRn9=5QOHiZCOGJU8RYm77c2vb_qzW5P@mail.gmail.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25CCB3A08D@orsmsx501.amr.corp.intel.com>
 <AANLkTi=O+An6XSFR-jWnYjQzsED63=DRnTBGF=itgAR3@mail.gmail.com>
 <AANLkTi=jDsCFEsfhT0Vwq2APQKmF5ZYFFV91=rEMUe=+@mail.gmail.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25DC5EF0A5@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25DC5EF0A5-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ignore this - there are 2 locks being used in ucma_create_id

I will resubmit


> diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
> index ca12acf..fd6b980 100644
> --- a/drivers/infiniband/core/ucma.c
> +++ b/drivers/infiniband/core/ucma.c
> @@ -384,31 +384,32 @@ static ssize_t ucma_create_id(struct ucma_file *file,
> 
>  	mutex_lock(&file->mut);
>  	ctx = ucma_alloc_ctx(file);
> -	mutex_unlock(&file->mut);
> -	if (!ctx)
> +	if (!ctx) {
> +		mutex_unlock(&file->mut);
>  		return -ENOMEM;
> +	}
> 
>  	ctx->uid = cmd.uid;
>  	ctx->cm_id = rdma_create_id(ucma_event_handler, ctx, cmd.ps);
>  	if (IS_ERR(ctx->cm_id)) {
>  		ret = PTR_ERR(ctx->cm_id);
> -		goto err1;
> +		goto err;
>  	}
> 
>  	resp.id = ctx->id;
>  	if (copy_to_user((void __user *)(unsigned long)cmd.response,
>  			 &resp, sizeof(resp))) {
>  		ret = -EFAULT;
> -		goto err2;
> +		goto err;
>  	}
> +	mutex_unlock(&file->mut);
>  	return 0;
> 
> -err2:
> -	rdma_destroy_id(ctx->cm_id);
> -err1:
> -	mutex_lock(&mut);
> +err:
>  	idr_remove(&ctx_idr, ctx->id);
>  	mutex_unlock(&mut);
> +	if (!IS_ERR(ctx->cm_id))
> +		rdma_destroy_id(ctx->cm_id);
>  	kfree(ctx);
>  	return ret;
>  }
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
