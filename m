From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [patch] IB/core: fix an error code in ib_core_init()
Date: Wed, 1 Jun 2016 05:20:49 +0000
Message-ID: <VI1PR05MB139180122CFC8788CDBE819AD2470@VI1PR05MB1391.eurprd05.prod.outlook.com>
References: <20160531160556.GA23959@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160531160556.GA23959@mwanda>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Yotam Kenneth (revoke on 13.10.15)" <yotamke-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Nice catch, looks good.

Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
> Sent: Tuesday, May 31, 2016 7:06 PM
> To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; Mark Bloch
> <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Hal Rosenstock
> <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>; Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Or
> Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Haggai
> Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Leon Romanovsky
> <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>; Yotam Kenneth (revoke on 13.10.15)
> <yotamke-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>; linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [patch] IB/core: fix an error code in ib_core_init()
> 
> We should return the error code if ib_add_ibnl_clients() fails.  The
> current code returns success.
> 
> Fixes: 735c631ae99d ('IB/core: Register SA ibnl client during ib_core
> initialization')
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> 
> diff --git a/drivers/infiniband/core/device.c
> b/drivers/infiniband/core/device.c
> index 5516fb0..8b8a8d9 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -1024,7 +1024,8 @@ static int __init ib_core_init(void)
>  		goto err_mad;
>  	}
> 
> -	if (ib_add_ibnl_clients()) {
> +	ret = ib_add_ibnl_clients();
> +	if (ret) {
>  		pr_warn("Couldn't register ibnl clients\n");
>  		goto err_sa;
>  	}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
