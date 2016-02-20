From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH rdma-next 3/8] net/mlx5_core: Introduce offload
 arithmetic hardware capabilities
Date: Sat, 20 Feb 2016 17:13:41 +0200
Message-ID: <20160220151341.GJ30450@leon.nu>
References: <1455954465-15141-1-git-send-email-leon@leon.nu>
 <1455954465-15141-4-git-send-email-leon@leon.nu>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1455954465-15141-4-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug

On Sat, Feb 20, 2016 at 09:47:40AM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

I had a problem with my git setup and created author field wrongly.
It should be "From: Sagi Grimeberg <sagigo-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>" and not as
written.

Do you want me to resend whole series with appropriate version
number and changelog?

> 
> Define the necessary hardware structures for the offload
> arithmetic capabilities and read/cache them on driver load.
> 
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/fw.c |  6 ++++++
>  include/linux/mlx5/device.h                  |  6 ++++++
>  include/linux/mlx5/mlx5_ifc.h                | 31 +++++++++++++++++++++++++++-
>  3 files changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
> index fe6dfd8..75c7ae6 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
> @@ -145,6 +145,12 @@ int mlx5_query_hca_caps(struct mlx5_core_dev *dev)
>  			return err;
>  	}
>  
> +	if (MLX5_CAP_GEN(dev, vector_calc)) {
> +		err = mlx5_core_get_caps(dev, MLX5_CAP_VECTOR_CALC);
> +		if (err)
> +			return err;
> +	}
> +
>  	return 0;
>  }
>  
> diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
> index 987764a..1f2cedf 100644
> --- a/include/linux/mlx5/device.h
> +++ b/include/linux/mlx5/device.h
> @@ -1196,6 +1196,8 @@ enum mlx5_cap_type {
>  	MLX5_CAP_FLOW_TABLE,
>  	MLX5_CAP_ESWITCH_FLOW_TABLE,
>  	MLX5_CAP_ESWITCH,
> +	MLX5_CAP_RESERVED,
> +	MLX5_CAP_VECTOR_CALC,
>  	/* NUM OF CAP Types */
>  	MLX5_CAP_NUM
>  };
> @@ -1258,6 +1260,10 @@ enum mlx5_cap_type {
>  #define MLX5_CAP_ODP(mdev, cap)\
>  	MLX5_GET(odp_cap, mdev->hca_caps_cur[MLX5_CAP_ODP], cap)
>  
> +#define MLX5_CAP_VECTOR_CALC(mdev, cap) \
> +	MLX5_GET(vector_calc_cap, \
> +		 mdev->hca_caps_cur[MLX5_CAP_VECTOR_CALC], cap)
> +
>  enum {
>  	MLX5_CMD_STAT_OK			= 0x0,
>  	MLX5_CMD_STAT_INT_ERR			= 0x1,
> diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
> index 455d9cc..d34ad50 100644
> --- a/include/linux/mlx5/mlx5_ifc.h
> +++ b/include/linux/mlx5/mlx5_ifc.h
> @@ -617,6 +617,33 @@ struct mlx5_ifc_odp_cap_bits {
>  	u8         reserved_at_80[0x720];
>  };
>  
> +struct mlx5_ifc_calc_op {
> +	u8        reserved_at_0[0x10];
> +	u8        reserved_at_10[0x9];
> +	u8        op_swap_endianness[0x1];
> +	u8        op_min[0x1];
> +	u8        op_xor[0x1];
> +	u8        op_or[0x1];
> +	u8        op_and[0x1];
> +	u8        op_max[0x1];
> +	u8        op_add[0x1];
> +};
> +
> +struct mlx5_ifc_vector_calc_cap_bits {
> +	u8         calc_matrix[0x1];
> +	u8         reserved_at_1[0x1f];
> +	u8         reserved_at_20[0x8];
> +	u8         max_vec_count[0x8];
> +	u8         reserved_at_30[0xd];
> +	u8         max_chunk_size[0x3];
> +	struct mlx5_ifc_calc_op calc0;
> +	struct mlx5_ifc_calc_op calc1;
> +	struct mlx5_ifc_calc_op calc2;
> +	struct mlx5_ifc_calc_op calc3;
> +
> +	u8         reserved_at_e0[0x720];
> +};
> +
>  enum {
>  	MLX5_WQ_TYPE_LINKED_LIST  = 0x0,
>  	MLX5_WQ_TYPE_CYCLIC       = 0x1,
> @@ -781,7 +808,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
>  	u8         cd[0x1];
>  	u8         reserved_at_22c[0x1];
>  	u8         apm[0x1];
> -	u8         reserved_at_22e[0x7];
> +	u8         vector_calc[0x1];
> +	u8         reserved_at_22f[0x6];
>  	u8         qkv[0x1];
>  	u8         pkv[0x1];
>  	u8         reserved_at_237[0x4];
> @@ -1918,6 +1946,7 @@ union mlx5_ifc_hca_cap_union_bits {
>  	struct mlx5_ifc_flow_table_nic_cap_bits flow_table_nic_cap;
>  	struct mlx5_ifc_flow_table_eswitch_cap_bits flow_table_eswitch_cap;
>  	struct mlx5_ifc_e_switch_cap_bits e_switch_cap;
> +	struct mlx5_ifc_vector_calc_cap_bits vector_calc_cap;
>  	u8         reserved_at_0[0x8000];
>  };
>  
> -- 
> 2.1.4
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
