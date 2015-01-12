From: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
Subject: Re: [patch] IB/mlx5: fix error code in get_port_caps()
Date: Mon, 12 Jan 2015 09:35:55 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1501120934540.2476@hadrien>
References: <20150112081429.GA11818@mwanda>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150112081429.GA11818@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 12 Jan 2015, Dan Carpenter wrote:

> We should return -ENOMEM on allocation failure instead of success.

Probably not a big deal, but the commit message is not clear at all.  From
the fix, it doesn't look like the code was returning -ENOMEM on success.

julia

> Fixes: e126ba97dba9 ('mlx5: Add driver for Mellanox Connect-IB adapters')
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index 8a87404..cc4ac1e 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -997,7 +997,7 @@ static int get_port_caps(struct mlx5_ib_dev *dev)
>  	struct ib_device_attr *dprops = NULL;
>  	struct ib_port_attr *pprops = NULL;
>  	struct mlx5_general_caps *gen;
> -	int err = 0;
> +	int err = -ENOMEM;
>  	int port;
>
>  	gen = &dev->mdev->caps.gen;
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
