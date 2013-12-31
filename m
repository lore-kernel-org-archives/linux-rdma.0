From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 5/25] IB/mlx4: fix error return code
Date: Tue, 31 Dec 2013 09:52:34 +0200
Message-ID: <20131231095234.28f33123@jpm-OptiPlex-GX620>
References: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
	<1388357260-4843-6-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1388357260-4843-6-git-send-email-Julia.Lawall-L2FTfq7BK8M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 29 Dec 2013 23:47:20 +0100
Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org> wrote:

> diff --git a/drivers/infiniband/hw/mlx4/sysfs.c
> b/drivers/infiniband/hw/mlx4/sysfs.c index 97516eb..db2ea31 100644
> --- a/drivers/infiniband/hw/mlx4/sysfs.c
> +++ b/drivers/infiniband/hw/mlx4/sysfs.c
> @@ -582,8 +582,10 @@ static int add_port(struct mlx4_ib_dev *dev, int
> port_num, int slave) p->pkey_group.attrs =
>  		alloc_group_attrs(show_port_pkey, store_port_pkey,
>  				  dev->dev->caps.pkey_table_len[port_num]);
> -	if (!p->pkey_group.attrs)
> +	if (!p->pkey_group.attrs) {
> +		ret = -ENOMEM;
>  		goto err_alloc;
> +	}
>  
>  	ret = sysfs_create_group(&p->kobj, &p->pkey_group);
>  	if (ret)
> @@ -591,8 +593,10 @@ static int add_port(struct mlx4_ib_dev *dev, int
> port_num, int slave) 
>  	p->gid_group.name  = "gid_idx";
>  	p->gid_group.attrs = alloc_group_attrs(show_port_gid_idx,
> NULL, 1);
> -	if (!p->gid_group.attrs)
> +	if (!p->gid_group.attrs) {
> +		ret = -ENOMEM;
>  		goto err_free_pkey;
> +	}
>  

ACK. Julia's patch is correct -- this is indeed a bug-fix.

-Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
