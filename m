From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 02/15] net/mlx5: Set software owner ID during
 init HCA
Date: Mon, 25 Dec 2017 00:00:43 +0200
Message-ID: <CAJ3xEMiq-4DGFW-Z3hX3NfsSGXD6bm_uarGF_cm6K7+YuutJBQ@mail.gmail.com>
References: <20171224125741.25464-1-leon@kernel.org> <20171224125741.25464-3-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171224125741.25464-3-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 24, 2017 at 2:57 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Generate a unique 128bit identifier for each host and pass that value to
> firmware in the INIT_HCA command if it reports the sw_owner_id
> capo ability. This value is used by FW to determine if functions are in
> use by the same host.

"capo ability"?

did you want to say the same driver instance? b/c multiple instances
of the driver can run on a host


> Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/fw.c        | 10 +++++++++-
>  drivers/net/ethernet/mellanox/mlx5/core/main.c      |  6 +++++-
>  drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h |  2 +-
>  include/linux/mlx5/device.h                         |  5 +++++
>  include/linux/mlx5/mlx5_ifc.h                       |  5 ++++-
>  5 files changed, 24 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
> index 5ef1b56b6a96..9d11e92fb541 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
> @@ -195,12 +195,20 @@ int mlx5_query_hca_caps(struct mlx5_core_dev *dev)
>         return 0;
>  }
>
> -int mlx5_cmd_init_hca(struct mlx5_core_dev *dev)
> +int mlx5_cmd_init_hca(struct mlx5_core_dev *dev, uint32_t *sw_owner_id)
>  {
>         u32 out[MLX5_ST_SZ_DW(init_hca_out)] = {0};
>         u32 in[MLX5_ST_SZ_DW(init_hca_in)]   = {0};
> +       int i;
>
>         MLX5_SET(init_hca_in, in, opcode, MLX5_CMD_OP_INIT_HCA);
> +
> +       if (MLX5_CAP_GEN(dev, sw_owner_id)) {
> +               for (i = 0; i < 4; i++)
> +                       MLX5_ARRAY_SET(init_hca_in, in, sw_owner_id, i,
> +                                      sw_owner_id[i]);
> +       }
> +
>         return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
>  }
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> index 5f323442cc5a..5f3dc0ede917 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> @@ -75,6 +75,8 @@ static unsigned int prof_sel = MLX5_DEFAULT_PROF;
>  module_param_named(prof_sel, prof_sel, uint, 0444);
>  MODULE_PARM_DESC(prof_sel, "profile selector. Valid range 0 - 2");
>
> +static u32 sw_owner_id[4];
> +
>  enum {
>         MLX5_ATOMIC_REQ_MODE_BE = 0x0,
>         MLX5_ATOMIC_REQ_MODE_HOST_ENDIANNESS = 0x1,
> @@ -1052,7 +1054,7 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
>                 goto reclaim_boot_pages;
>         }
>
> -       err = mlx5_cmd_init_hca(dev);
> +       err = mlx5_cmd_init_hca(dev, sw_owner_id);
>         if (err) {
>                 dev_err(&pdev->dev, "init hca failed\n");
>                 goto err_pagealloc_stop;
> @@ -1574,6 +1576,8 @@ static int __init init(void)
>  {
>         int err;
>
> +       get_random_bytes(&sw_owner_id, sizeof(sw_owner_id));
> +
>         mlx5_core_verify_params();
>         mlx5_register_debugfs();
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
> index ff4a0b889a6f..b05868728da7 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
> @@ -86,7 +86,7 @@ enum {
>
>  int mlx5_query_hca_caps(struct mlx5_core_dev *dev);
>  int mlx5_query_board_id(struct mlx5_core_dev *dev);
> -int mlx5_cmd_init_hca(struct mlx5_core_dev *dev);
> +int mlx5_cmd_init_hca(struct mlx5_core_dev *dev, uint32_t *sw_owner_id);
>  int mlx5_cmd_teardown_hca(struct mlx5_core_dev *dev);
>  int mlx5_cmd_force_teardown_hca(struct mlx5_core_dev *dev);
>  void mlx5_core_event(struct mlx5_core_dev *dev, enum mlx5_dev_event event,
> diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
> index 409ffb14298a..18c041966ab8 100644
> --- a/include/linux/mlx5/device.h
> +++ b/include/linux/mlx5/device.h
> @@ -79,6 +79,11 @@
>                      << __mlx5_dw_bit_off(typ, fld))); \
>  } while (0)
>
> +#define MLX5_ARRAY_SET(typ, p, fld, idx, v) do { \
> +       BUILD_BUG_ON(__mlx5_bit_off(typ, fld) % 32); \
> +       MLX5_SET(typ, p, fld[idx], v); \
> +} while (0)
> +

Parav, Dan, we I pointed to you during the dscp trust mode work, changes
to this area of the code should have the RB sig of Eli Cohen or Saeed if you
can't get Eli, please do that.


>  #define MLX5_SET_TO_ONES(typ, p, fld) do { \
>         BUILD_BUG_ON(__mlx5_st_sz_bits(typ) % 32);             \
>         *((__be32 *)(p) + __mlx5_dw_off(typ, fld)) = \
> diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
> index 38a7577a9ce7..b1c81d7a86cb 100644
> --- a/include/linux/mlx5/mlx5_ifc.h
> +++ b/include/linux/mlx5/mlx5_ifc.h
> @@ -1066,7 +1066,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
>         u8         reserved_at_5f8[0x3];
>         u8         log_max_xrq[0x5];
>
> -       u8         reserved_at_600[0x200];
> +       u8         reserved_at_600[0x1e];
> +       u8         sw_owner_id;
> +       u8         reserved_at_61f[0x1e1];
>  };
>
>  enum mlx5_flow_destination_type {
> @@ -5531,6 +5533,7 @@ struct mlx5_ifc_init_hca_in_bits {
>         u8         op_mod[0x10];
>
>         u8         reserved_at_40[0x40];
> +       u8         sw_owner_id[4][0x20];
>  };

can we do here just a plane addition of bits? don't have the code
infront of me, but seems suspicious
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
