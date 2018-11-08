From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH mlx5-next 08/10] IB/mlx5: Call PAGE_FAULT_RESUME command
 asynchronously
Date: Thu, 8 Nov 2018 19:49:03 +0000
Message-ID: <20181108194857.GF5548@mellanox.com>
References: <20181108191017.21891-1-leon@kernel.org>
 <20181108191017.21891-9-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181108191017.21891-9-leon@kernel.org>
Content-Language: en-US
Content-ID: <333E3EC7DEEA6949A74981A65F964004@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 08, 2018 at 09:10:15PM +0200, Leon Romanovsky wrote:
> From: Moni Shoua <monis@mellanox.com>
>=20
> Telling the HCA that page fault handling is done and QP can resume
> its flow is done in the context of the page fault handler. This blocks
> the handling of the next work in queue without a need.
> Call the PAGE_FAULT_RESUME command in an asynchronous manner and free
> the workqueue to pick the next work item for handling. All tasks that
> were executed after PAGE_FAULT_RESUME need to be done now
> in the callback of the asynchronous command mechanism.
>=20
> Signed-off-by: Moni Shoua <monis@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>  drivers/infiniband/hw/mlx5/odp.c | 110 +++++++++++++++++++++++++------
>  include/linux/mlx5/driver.h      |   3 +
>  2 files changed, 94 insertions(+), 19 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx=
5/odp.c
> index abce55b8b9ba..0c4f469cdd5b 100644
> +++ b/drivers/infiniband/hw/mlx5/odp.c
> @@ -298,20 +298,78 @@ void mlx5_ib_internal_fill_odp_caps(struct mlx5_ib_=
dev *dev)
>  	return;
>  }
> =20
> +struct pfault_resume_cb_ctx {
> +	struct mlx5_ib_dev *dev;
> +	struct mlx5_core_rsc_common *res;
> +	struct mlx5_pagefault *pfault;
> +};
> +
> +static void page_fault_resume_callback(int status, void *context)
> +{
> +	struct pfault_resume_cb_ctx *ctx =3D context;
> +	struct mlx5_pagefault *pfault =3D ctx->pfault;
> +
> +	if (status)
> +		mlx5_ib_err(ctx->dev, "Resolve the page fault failed with status %d\n"=
,
> +			    status);
> +
> +	if (ctx->res)
> +		mlx5_core_res_put(ctx->res);
> +	kfree(pfault);
> +	kfree(ctx);
> +}
> +
>  static void mlx5_ib_page_fault_resume(struct mlx5_ib_dev *dev,
> +				      struct mlx5_core_rsc_common *res,
>  				      struct mlx5_pagefault *pfault,
> -				      int error)
> +				      int error,
> +				      bool async)
>  {
> +	int ret =3D 0;
> +	u32 *out =3D pfault->out_pf_resume;
> +	u32 *in =3D pfault->in_pf_resume;
> +	u32 token =3D pfault->token;
>  	int wq_num =3D pfault->event_subtype =3D=3D MLX5_PFAULT_SUBTYPE_WQE ?
> -		     pfault->wqe.wq_num : pfault->token;
> -	int ret =3D mlx5_core_page_fault_resume(dev->mdev,
> -					      pfault->token,
> -					      wq_num,
> -					      pfault->type,
> -					      error);
> -	if (ret)
> -		mlx5_ib_err(dev, "Failed to resolve the page fault on WQ 0x%x\n",
> -			    wq_num);
> +		pfault->wqe.wq_num : pfault->token;
> +	u8 type =3D pfault->type;
> +	struct pfault_resume_cb_ctx *ctx =3D NULL;
> +
> +	if (async)
> +		ctx =3D kmalloc(sizeof(*ctx), GFP_KERNEL);

Why not allocate this ctx ast part of the mlx5_pagefault and avoid
this allocation failure strategy?

Jason
