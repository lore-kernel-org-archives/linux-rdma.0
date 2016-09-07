From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Fix decision to avoid using MAD_IFC command in
 ISSI > 0 mode
Date: Wed, 7 Sep 2016 10:40:51 +0300
Message-ID: <CAJ3xEMjxr=qMjBo=Uq-bZ7RGwp9ekWpDACdDAJ0yR_AkZXcMEw@mail.gmail.com>
References: <1473232990-22766-1-git-send-email-dchang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473232990-22766-1-git-send-email-dchang-IBi9RG/b67k@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Chang <dchang-IBi9RG/b67k@public.gmane.org>, Meny Yossefi <menyy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doron Tsur <doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 7, 2016 at 10:23 AM, David Chang <dchang-IBi9RG/b67k@public.gmane.org> wrote:
> When using MAD_IFC command, we should also consider avoiding in
> ISSI > 0 mode, otherwise most of the MAD_IFC command features
> are deprecated and cannot be used.

Ofcourse!!

Mark/Meny, didn't you stpped on it / addressed that as part of some
other counters work?

Doron, don't you see this as repeated 100% failure e.g with Eth SRIOV
VFs and/or RoCE devices?

Or.

>
> Fixes: d603c809ef91 ("IB/mlx5: Fix decision on using MAD_IFC")
> Reported-by: Sujith Pandel <sujith_pandel-8PEkshWhKlo@public.gmane.org>
> Signed-off-by: David Chang <dchang-IBi9RG/b67k@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index 1b4094baa2de..0796fb2b04f1 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -288,7 +288,8 @@ __be16 mlx5_get_roce_udp_sport(struct mlx5_ib_dev *dev, u8 port_num,
>
>  static int mlx5_use_mad_ifc(struct mlx5_ib_dev *dev)
>  {
> -       return !MLX5_CAP_GEN(dev->mdev, ib_virt);
> +       return !dev->mdev->issi &&
> +               !MLX5_CAP_GEN(dev->mdev, ib_virt);
>  }
>
>  enum {
> --
> 2.6.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
