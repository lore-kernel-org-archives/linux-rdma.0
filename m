From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: linux-next: build failure after merge of the infiniband tree
Date: Mon, 15 Dec 2014 17:56:55 -0800
Message-ID: <CAG4TOxP9WFHALPb0y0eKFup6uhszXfd+hLcwZ98kZUVaR_9j4w@mail.gmail.com>
References: <20141216124750.153e3fdd@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141216124750.153e3fdd-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 15, 2014 at 5:47 PM, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org> wrote:
> Hi all,
>
> After merging the infiniband tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> drivers/infiniband/hw/mlx5/main.c: In function 'mlx5_ib_query_device':
> drivers/infiniband/hw/mlx5/main.c:248:34: error: 'MLX5_DEV_CAP_FLAG_ON_DMND_PG' undeclared (first use in this function)
>   if (dev->mdev->caps.gen.flags & MLX5_DEV_CAP_FLAG_ON_DMND_PG)
>                                   ^
> drivers/net/ethernet/mellanox/mlx5/core/fw.c: In function 'mlx5_query_odp_caps':
> drivers/net/ethernet/mellanox/mlx5/core/fw.c:79:30: error: 'MLX5_DEV_CAP_FLAG_ON_DMND_PG' undeclared (first use in this function)
>   if (!(dev->caps.gen.flags & MLX5_DEV_CAP_FLAG_ON_DMND_PG))
>                               ^
> drivers/net/ethernet/mellanox/mlx5/core/eq.c: In function 'mlx5_start_eqs':
> drivers/net/ethernet/mellanox/mlx5/core/eq.c:459:28: error: 'MLX5_DEV_CAP_FLAG_ON_DMND_PG' undeclared (first use in this function)
>   if (dev->caps.gen.flags & MLX5_DEV_CAP_FLAG_ON_DMND_PG)
>                             ^
>
> Really?  Code added half way though the merge window not even build
> tested?

It's not quite as bad as it seems.  The infiniband tree itself builds,
the problem is the merged tree.

The Mellanox guys merged the "cleanup"

commit 0c7aac854f52
Author: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Tue Dec 2 02:26:14 2014

    net/mlx5_core: Remove unused dev cap enum fields

    These enumerations are not used so remove them.

    Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
    Signed-off-by: David S. Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>

through davem's tree, and then went ahead and used at least
MLX5_DEV_CAP_FLAG_ON_DMND_PG (which that patch removes) in patches
they merged through my tree.

I'll add a partial revert of that patch to my tree to get back the
now-used enum values.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
