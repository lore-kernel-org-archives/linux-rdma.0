From: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [bug report] net/mlx5: E-Switch, Add control for inline mode
Date: Tue, 29 Nov 2016 17:06:55 +0200
Message-ID: <fa981369-2032-eb9e-6307-f3055297e7e6@mellanox.com>
References: <20161129105258.GA31063@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161129105258.GA31063@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 29/11/2016 12:52, Dan Carpenter wrote:
> Hello Roi Dayan,
>
> The patch bffaa916588e: "net/mlx5: E-Switch, Add control for inline
> mode" from Nov 22, 2016, leads to the following static checker
> warning:
>
> 	drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c:950 mlx5_eswitch_inline_mode_get()
> 	error: uninitialized symbol 'prev_mlx5_mode'.
>
> drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
>     932  int mlx5_eswitch_inline_mode_get(struct mlx5_eswitch *esw, int nvfs, u8 *mode)
>     933  {
>     934          struct mlx5_core_dev *dev = esw->dev;
>     935          int vport;
>     936          u8 prev_mlx5_mode, mlx5_mode = MLX5_INLINE_MODE_L2;
>                     ^^^^^^^^^^^^^^
>     937
>     938          if (!MLX5_CAP_GEN(dev, vport_group_manager))
>     939                  return -EOPNOTSUPP;
>     940
>     941          if (esw->mode == SRIOV_NONE)
>     942                  return -EOPNOTSUPP;
>     943
>     944          if (MLX5_CAP_ETH(dev, wqe_inline_mode) !=
>     945              MLX5_CAP_INLINE_MODE_VPORT_CONTEXT)
>     946                  return -EOPNOTSUPP;
>     947
>     948          for (vport = 1; vport <= nvfs; vport++) {
>     949                  mlx5_query_nic_vport_min_inline(dev, vport, &mlx5_mode);
>     950                  if (vport > 1 && prev_mlx5_mode != mlx5_mode)
>                                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> No idea what prev_mlx5_mode is supposed to be for.
>
>     951                          return -EINVAL;
>     952                  prev_mlx5_mode = mlx5_mode;
>     953          }
>     954
>     955          *mode = mlx5_mode;
>     956          return 0;
>     957  }
>
> regards,
> dan carpenter

Hi Dan,

I really didn't see this. sparse and smatch didn't catch this. I use 
FC24 and gcc 6.2.1 for compilation and it doesn't give me any warning.
Did another check with an old rhel machine with gcc 4.4.6 and I got a 
warning about it there.
Can you tell me which tool you used?

This is a false positive because of the first check if vport > 1, we 
actually check prev_mlx5_mode from the second for-loop
iteration and on the first loop iteration we set a value (in line 952).
It is used to check if all vports are set with the same inline mode.

Thanks,
Roi

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
