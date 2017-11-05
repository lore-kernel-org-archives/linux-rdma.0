From: Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] net/mlx5e/core/en_fs: fix pointer dereference after free
 in mlx5e_execute_l2_action
Date: Sat, 4 Nov 2017 21:43:14 -0700
Message-ID: <CALzJLG-YW_5AH__q2XHgaQM=xeLy+31LSeQdPAs7RhS=rLpJPw@mail.gmail.com>
References: <20171105035453.GA10908@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171105035453.GA10908-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gustavo A. R. Silva" <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
Cc: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Linux Netdev List <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jes Sorensen <jsorensen-b10kYP2dOMg@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Nov 4, 2017 at 8:54 PM, Gustavo A. R. Silva
<garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org> wrote:
> hn is being kfree'd in mlx5e_del_l2_from_hash and then dereferenced
> by accessing hn->ai.addr
>
> Fix this by copying the MAC address into a local variable for its safe use
> in all possible execution paths within function mlx5e_execute_l2_action.
>
> Addresses-Coverity-ID: 1417789
> Fixes: eeb66cdb6826 ("net/mlx5: Separate between E-Switch and MPFS")
> Signed-off-by: Gustavo A. R. Silva <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>

Acked-by: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Looks good.
Thank you Gustavo.

> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_fs.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
> index 850cdc9..4837045 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
> @@ -365,21 +365,24 @@ static void mlx5e_execute_l2_action(struct mlx5e_priv *priv,
>                                     struct mlx5e_l2_hash_node *hn)
>  {
>         u8 action = hn->action;
> +       u8 mac_addr[ETH_ALEN];
>         int l2_err = 0;
>
> +       ether_addr_copy(mac_addr, hn->ai.addr);
> +
>         switch (action) {
>         case MLX5E_ACTION_ADD:
>                 mlx5e_add_l2_flow_rule(priv, &hn->ai, MLX5E_FULLMATCH);
> -               if (!is_multicast_ether_addr(hn->ai.addr)) {
> -                       l2_err = mlx5_mpfs_add_mac(priv->mdev, hn->ai.addr);
> +               if (!is_multicast_ether_addr(mac_addr)) {
> +                       l2_err = mlx5_mpfs_add_mac(priv->mdev, mac_addr);
>                         hn->mpfs = !l2_err;
>                 }
>                 hn->action = MLX5E_ACTION_NONE;
>                 break;
>
>         case MLX5E_ACTION_DEL:
> -               if (!is_multicast_ether_addr(hn->ai.addr) && hn->mpfs)
> -                       l2_err = mlx5_mpfs_del_mac(priv->mdev, hn->ai.addr);
> +               if (!is_multicast_ether_addr(mac_addr) && hn->mpfs)
> +                       l2_err = mlx5_mpfs_del_mac(priv->mdev, mac_addr);
>                 mlx5e_del_l2_flow_rule(priv, &hn->ai);
>                 mlx5e_del_l2_from_hash(hn);
>                 break;
> @@ -387,7 +390,7 @@ static void mlx5e_execute_l2_action(struct mlx5e_priv *priv,
>
>         if (l2_err)
>                 netdev_warn(priv->netdev, "MPFS, failed to %s mac %pM, err(%d)\n",
> -                           action == MLX5E_ACTION_ADD ? "add" : "del", hn->ai.addr, l2_err);
> +                           action == MLX5E_ACTION_ADD ? "add" : "del", mac_addr, l2_err);
>  }
>
>  static void mlx5e_sync_netdev_addr(struct mlx5e_priv *priv)
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
