From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH] IB-mlx5: Return EINVAL when caller specifies too many
 SGEs
Date: Thu, 28 Jul 2016 13:08:56 +0000
Message-ID: <DB5PR05MB1848930C5B1D2D52CD2AC3AAC5000@DB5PR05MB1848.eurprd05.prod.outlook.com>
References: <20160727193718.29482.73416.stgit@manet.1015granger.net>
 <20160728052246.GM4628@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160728052246.GM4628-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I am not sure I agree with this. I intentionally put ENOMEM since this indicates that the WQ buffer is not large enough to contain all the s/g entries. I return EINVAL if the opcode is invalid for example.

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Leon Romanovsky
Sent: Thursday, July 28, 2016 12:23 AM
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: [PATCH] IB-mlx5: Return EINVAL when caller specifies too many SGEs

On Wed, Jul 27, 2016 at 03:38:36PM -0400, Chuck Lever wrote:
> Other similar functions (mlx5_ib_post_recv being the closest) return 
> EINVAL in this case.
> 
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Thanks Chuck,
You are absolutely right, it should be EINVAL error.
Do you mind if I submit it by myself together with other mlx5 fixes?

Looks ok, except title :)
Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

> ---
> Hi Matan, Leon-
> 
> I noticed this nit while debugging a problem in xprtrdma.
> 
>  drivers/infiniband/hw/mlx5/qp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/qp.c 
> b/drivers/infiniband/hw/mlx5/qp.c index ce0a7ab..b0e5498 100644
> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -3436,7 +3436,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
>  		num_sge = wr->num_sge;
>  		if (unlikely(num_sge > qp->sq.max_gs)) {
>  			mlx5_ib_warn(dev, "\n");
> -			err = -ENOMEM;
> +			err = -EINVAL;
>  			*bad_wr = wr;
>  			goto out;
>  		}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" 
> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo 
> info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
