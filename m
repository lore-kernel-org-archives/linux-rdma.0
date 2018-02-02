From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] net: mlx5: remove pointless memcpy
Date: Fri, 2 Feb 2018 12:06:00 -0700
Message-ID: <20180202190600.GD9080@ziepe.ca>
References: <20180202154636.1624079-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180202154636.1624079-1-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 02, 2018 at 04:46:30PM +0100, Arnd Bergmann wrote:
> gcc-8 notices that the memcpy in mlx5_core_query_xsrq() makes no
> sense because the source and destination variables are identical:
> 
> drivers/net/ethernet/mellanox/mlx5/core/transobj.c: In function 'mlx5_core_query_xsrq':
> drivers/net/ethernet/mellanox/mlx5/core/transobj.c:347:3: error: 'memcpy' source argument is the same as destination [-Werror=restrict]
> 
> Either one of the pointers should be something else, or the code is
> completely bogus. Removing the memcpy() won't change the behavior
> but gets rid of the warning.
> 
> Fixes: 01949d0109ee ("net/mlx5_core: Enable XRCs and SRQs when using ISSI > 0")
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> Please review carefully, I have no idea what the author actually
> intended here.

I think they intended to adjust the command return between
mlx5_ifc_query_srq_out_bits and mlx5_ifc_query_xrc_srq_out_bits?

> index 9e38343a951f..75450f7d53bf 100644
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/transobj.c
> @@ -332,20 +332,12 @@ int mlx5_core_destroy_xsrq(struct mlx5_core_dev *dev, u32 xsrqn)
>  int mlx5_core_query_xsrq(struct mlx5_core_dev *dev, u32 xsrqn, u32 *out)
>  {
>  	u32 in[MLX5_ST_SZ_DW(query_xrc_srq_in)] = {0};
> -	void *srqc;
> -	void *xrc_srqc;
>  	int err;
>  
>  	MLX5_SET(query_xrc_srq_in, in, opcode,   MLX5_CMD_OP_QUERY_XRC_SRQ);
>  	MLX5_SET(query_xrc_srq_in, in, xrc_srqn, xsrqn);
>  	err = mlx5_cmd_exec(dev, in, sizeof(in), out,
>  			    MLX5_ST_SZ_BYTES(query_xrc_srq_out));
> -	if (!err) {
> -		xrc_srqc = MLX5_ADDR_OF(query_xrc_srq_out, out,
> -					xrc_srq_context_entry);
> -		srqc = MLX5_ADDR_OF(query_srq_out, out, srq_context_entry);
> -		memcpy(srqc, xrc_srqc, MLX5_ST_SZ_BYTES(srqc));
> -	}

Probably should add a

BUILD_BUG_ON(MLX5_BYTE_OFF(query_xrc_srq_out, xrc_srq_context_entry) == MLX5_BYTE_OFF(query_srq_out, srq_context_entry));

Just for clarity that the SRQ and XRC_SRQ are being used interchangeably.

and the 'err' variable can be eliminated.

Curious though that I can't find a call site for it, and removing the
prototype doesn't break the build.. Seems like dead code.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
