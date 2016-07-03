From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 3/3] IB/mlx5: Fix mlx5_set_path for Raw Packet QP
Date: Mon, 4 Jul 2016 00:55:36 +0300
Message-ID: <CAJ3xEMhZiBjQwjgXj8peLYW4wETEE96UJ8BC7TLyO0G_jn-iBg@mail.gmail.com>
References: <1467549727-23479-1-git-send-email-leon@kernel.org> <1467549727-23479-4-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467549727-23479-4-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 3, 2016 at 3:42 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c
> @@ -2175,7 +2175,8 @@ static int mlx5_set_path(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
>         }
>
>         if (ll == IB_LINK_LAYER_ETHERNET) {
> -               if (!(ah->ah_flags & IB_AH_GRH))
> +               if (!(ah->ah_flags & IB_AH_GRH) &&
> +                   (qp->ibqp.qp_type != IB_QPT_RAW_PACKET))
>                         return -EINVAL;
>                 memcpy(path->rmac, ah->dmac, sizeof(ah->dmac));
>                 path->udp_sport = mlx5_get_roce_udp_sport(dev, port,

As you can see here, that code was written with RoCE state of mind,
e.g they set the remote mac and udp source port, with both being
irrelevant for RAW packet QPs. So in that respect, your fix is wrong.
Make the code clear and correct in what they set to RoCE QPs, to RAW
Packet QPs and to both.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
