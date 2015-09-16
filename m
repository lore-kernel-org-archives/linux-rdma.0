From: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
Subject: Re: [patch] IB/hfi1: info leak in get_ctxt_info()
Date: Wed, 16 Sep 2015 08:25:00 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1509160824370.2049@localhost6.localdomain6>
References: <20150916062142.GB21542@mwanda>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150916062142.GB21542@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 16 Sep 2015, Dan Carpenter wrote:

> The cinfo struct has a hole after the last struct member so we need to
> zero it out.  Otherwise we don't disclose some uninitialized stack data.

I think the "don't" wasn't intended in the second sentence?

julia

> 
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> 
> diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
> index 4698617..2c43ca5 100644
> --- a/drivers/staging/rdma/hfi1/file_ops.c
> +++ b/drivers/staging/rdma/hfi1/file_ops.c
> @@ -1181,6 +1181,7 @@ static int get_ctxt_info(struct file *fp, void __user *ubase, __u32 len)
>  	struct hfi1_filedata *fd = fp->private_data;
>  	int ret = 0;
>  
> +	memset(&cinfo, 0, sizeof(cinfo));
>  	ret = hfi1_get_base_kinfo(uctxt, &cinfo);
>  	if (ret < 0)
>  		goto done;
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
