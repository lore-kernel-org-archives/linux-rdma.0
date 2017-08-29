From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/qedr: Missing error code in qedr_init_user_queue()
Date: Mon, 28 Aug 2017 20:36:12 -0400
Message-ID: <1503966972.52034.21.camel@redhat.com>
References: <20170825081839.5ahvp6pehrhyyf2z@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170825081839.5ahvp6pehrhyyf2z@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Michal <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-08-25 at 11:18 +0300, Dan Carpenter wrote:
> We should return -ENOMEM if the kzalloc() fails.  We currently return
> success.
> 
> Fixes: 69ad0e7fe845 ("RDMA/qedr: Add support for iWARP in user
> space")
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Thanks, applied on top of my k.o/net-next-based branch.

> 
> diff --git a/drivers/infiniband/hw/qedr/verbs.c
> b/drivers/infiniband/hw/qedr/verbs.c
> index 4e14a558734b..bce4f79370e6 100644
> --- a/drivers/infiniband/hw/qedr/verbs.c
> +++ b/drivers/infiniband/hw/qedr/verbs.c
> @@ -821,8 +821,10 @@ static inline int qedr_init_user_queue(struct
> ib_ucontext *ib_ctx,
>  				   FW_PAGE_SHIFT);
>  	} else {
>  		q->pbl_tbl = kzalloc(sizeof(*q->pbl_tbl),
> GFP_KERNEL);
> -		if (!q->pbl_tbl)
> +		if (!q->pbl_tbl) {
> +			rc = -ENOMEM;
>  			goto err0;
> +		}
>  	}
>  
>  	return 0;
-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
