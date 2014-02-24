From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH v5 04/10] IB/mlx5: Initialize mlx5_ib_qp signature
 related
Date: Sun, 23 Feb 2014 22:46:16 -0800
Message-ID: <1393224376.22656.13.camel@haakon3.risingtidesystems.com>
References: <1393157953-24834-1-git-send-email-sagig@mellanox.com>
	 <1393157953-24834-5-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393157953-24834-5-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, 2014-02-23 at 14:19 +0200, Sagi Grimberg wrote:
> If user requested signature enable we Initialize
> relevant mlx5_ib_qp members. we mark the qp as sig_enable
> and we increase the effective SQ size, but still
> limit the user max_send_wr to original size computed.
> We also allow the create_qp routine to accept sig_enable
> create flag.
> 
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/mlx5_ib.h |    3 +++
>  drivers/infiniband/hw/mlx5/qp.c      |   12 +++++++++---
>  include/linux/mlx5/qp.h              |    1 +
>  3 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> index 79c4f14..e438f08 100644
> --- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> @@ -189,6 +189,9 @@ struct mlx5_ib_qp {
>  
>  	int			create_type;
>  	u32			pa_lkey;
> +
> +	/* Store signature errors */
> +	bool			signature_en;
>  };
>  
>  struct mlx5_ib_cq_buf {
> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
> index 7dfe8a1..01999f3 100644
> --- a/drivers/infiniband/hw/mlx5/qp.c
> +++ b/drivers/infiniband/hw/mlx5/qp.c

<SNIP>

> @@ -665,7 +671,7 @@ static int create_kernel_qp(struct mlx5_ib_dev *dev,
>  	int err;
>  
>  	uuari = &dev->mdev.priv.uuari;
> -	if (init_attr->create_flags)
> +	if (init_attr->create_flags & ~IB_QP_CREATE_SIGNATURE_EN)
>  		return -EINVAL;
>  
>  	if (init_attr->qp_type == MLX5_IB_QPT_REG_UMR)


FYI, this particular block doesn't apply against >= v3.14-rc2 code.

Dropping it for now, and applying the rest as #5.

Please fix if necessary.

--nab

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
