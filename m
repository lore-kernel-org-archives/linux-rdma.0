From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [for-next 01/11] net/mlx5: E-Switch, Refactor vport
 representors initialization
Date: Wed, 20 Dec 2017 12:57:34 -0500 (EST)
Message-ID: <20171220.125734.63810464667583004.davem@davemloft.net>
References: <20171219203340.2600-1-saeedm@mellanox.com>
        <20171219203340.2600-2-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171219203340.2600-2-saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Tue, 19 Dec 2017 12:33:30 -0800

> +int esw_offloads_init_reps(struct mlx5_eswitch *esw)
> +{
> +	struct mlx5_core_dev *dev = esw->dev;
> +	struct mlx5_esw_offload *offloads;
> +	struct mlx5_eswitch_rep *rep;
> +	int total_vfs = MLX5_TOTAL_VPORTS(dev);
> +	u8 hw_id[ETH_ALEN];
> +	int vport;

Reverse christmas-tree please.

> +	esw->offloads.vport_reps =
> +		kcalloc(total_vfs, sizeof(struct mlx5_eswitch_rep),
> +			GFP_KERNEL);

That looks really unpleasant:

	x = kcalloc(y,
		    z, GFP_KERNEL);

would look so much nicer.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
