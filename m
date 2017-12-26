From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/6] net/mlx5: Add DCT command interface
Date: Tue, 26 Dec 2017 16:14:32 +0200
Message-ID: <CAJ3xEMhxL3sPELRAQiLt4n+C_mc-5eu=XFNm2p67w5EioFvDTg@mail.gmail.com>
References: <20171226091634.2352-1-leon@kernel.org> <20171226091634.2352-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171226091634.2352-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 26, 2017 at 11:16 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> +int mlx5_core_create_dct(struct mlx5_core_dev *dev,
> +                        struct mlx5_core_dct *dct,
> +                        u32 *in, int inlen)
> +{
> +       struct mlx5_core_qp *qp = &dct->mqp;
> +       u32 out[MLX5_ST_SZ_DW(create_dct_out)]   = {0};
> +       u32 din[MLX5_ST_SZ_DW(destroy_dct_in)]   = {0};
> +       u32 dout[MLX5_ST_SZ_DW(destroy_dct_out)] = {0};
> +       int err;

hey it's EOY now... can we do better with respect to reverse xmas tree here?


> +
> +       init_completion(&dct->drained);
> +       MLX5_SET(create_dct_in, in, opcode, MLX5_CMD_OP_CREATE_DCT);
> +
> +       err = mlx5_cmd_exec(dev, in, inlen, &out, sizeof(out));
> +       if (err) {
> +               mlx5_core_warn(dev, "create DCT failed, ret %d\n", err);
> +               return err;
> +       }
> +
> +       qp->qpn = MLX5_GET(create_dct_out, out, dctn);
> +       err = create_resource_common(dev, qp, MLX5_RES_DCT);
> +       if (err)
> +               goto err_cmd;
> +
> +       return 0;
> +err_cmd:
> +       MLX5_SET(destroy_dct_in, din, opcode, MLX5_CMD_OP_DESTROY_DCT);
> +       MLX5_SET(destroy_dct_in, din, dctn, qp->qpn);
> +       mlx5_cmd_exec(dev, (void *)&in, sizeof(din), (void *)&out, sizeof(dout));
> +       return err;
> +}
> +EXPORT_SYMBOL_GPL(mlx5_core_create_dct);
> +
>  int mlx5_core_create_qp(struct mlx5_core_dev *dev,
>                         struct mlx5_core_qp *qp,
>                         u32 *in, int inlen)
> @@ -197,7 +246,7 @@ int mlx5_core_create_qp(struct mlx5_core_dev *dev,
>         qp->qpn = MLX5_GET(create_qp_out, out, qpn);
>         mlx5_core_dbg(dev, "qpn = 0x%x\n", qp->qpn);
>
> -       err = create_qprqsq_common(dev, qp, MLX5_RES_QP);
> +       err = create_resource_common(dev, qp, MLX5_RES_QP);
>         if (err)
>                 goto err_cmd;
>
> @@ -220,6 +269,47 @@ int mlx5_core_create_qp(struct mlx5_core_dev *dev,
>  }
>  EXPORT_SYMBOL_GPL(mlx5_core_create_qp);
>
> +static int mlx5_core_drain_dct(struct mlx5_core_dev *dev,
> +                              struct mlx5_core_dct *dct)
> +{
> +       struct mlx5_core_qp *qp = &dct->mqp;
> +       u32 out[MLX5_ST_SZ_DW(drain_dct_out)] = {0};
> +       u32 in[MLX5_ST_SZ_DW(drain_dct_in)]   = {0};

same comment


> +
> +       MLX5_SET(drain_dct_in, in, opcode, MLX5_CMD_OP_DRAIN_DCT);
> +       MLX5_SET(drain_dct_in, in, dctn, qp->qpn);
> +       return mlx5_cmd_exec(dev, (void *)&in, sizeof(in),
> +                            (void *)&out, sizeof(out));
> +}
> +
> +int mlx5_core_destroy_dct(struct mlx5_core_dev *dev,
> +                         struct mlx5_core_dct *dct)
> +{
> +       struct mlx5_core_qp *qp = &dct->mqp;
> +       u32 out[MLX5_ST_SZ_DW(destroy_dct_out)] = {0};
> +       u32 in[MLX5_ST_SZ_DW(destroy_dct_in)]   = {0};
> +       int err;

same comment
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
