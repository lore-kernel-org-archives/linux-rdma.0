From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v4 for-4.13 2/6] mlx5: move affinity hints assignments
        to generic code
Date: Wed, 7 Jun 2017 10:22:00 +0200
Message-ID: <20170607082200.GB24774@lst.de>
References: <1496814868-22070-1-git-send-email-sagi@grimberg.me> <1496814868-22070-3-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1496814868-22070-3-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 07, 2017 at 08:54:24AM +0300, Sagi Grimberg wrote:
> generic api takes care of spreading affinity similar to
> what mlx5 open coded (and even handles better asymmetric
> configurations). Ask the generic API to spread affinity
> for us, and feed him pre_vectors that do not participate
> in affinity settings (which is an improvement to what we
> had before).
> 
> The affinity assignments should match what mlx5 tried to
> do earlier but now we do not set affinity to async, cmd
> and pages dedicated vectors.
> 
> Also, remove mlx5e_get_cpu routine as we have generic helpers
> to get cpumask and node given a irq vector, so use them
> directly.
> 
> Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 12 ++--
>  drivers/net/ethernet/mellanox/mlx5/core/main.c    | 83 ++---------------------
>  include/linux/mlx5/driver.h                       |  1 -
>  3 files changed, 10 insertions(+), 86 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 2a3c59e55dcf..ebfda1eae6b4 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -1565,11 +1565,6 @@ static void mlx5e_close_cq(struct mlx5e_cq *cq)
>  	mlx5e_free_cq(cq);
>  }
>  
> -static int mlx5e_get_cpu(struct mlx5e_priv *priv, int ix)
> -{
> -	return cpumask_first(priv->mdev->priv.irq_info[ix].mask);
> -}
> -
>  static int mlx5e_open_tx_cqs(struct mlx5e_channel *c,
>  			     struct mlx5e_params *params,
>  			     struct mlx5e_channel_param *cparam)
> @@ -1718,11 +1713,11 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
>  {
>  	struct mlx5e_cq_moder icocq_moder = {0, 0};
>  	struct net_device *netdev = priv->netdev;
> -	int cpu = mlx5e_get_cpu(priv, ix);
>  	struct mlx5e_channel *c;
>  	int err;
>  
> -	c = kzalloc_node(sizeof(*c), GFP_KERNEL, cpu_to_node(cpu));
> +	c = kzalloc_node(sizeof(*c), GFP_KERNEL,
> +		pci_irq_get_node(priv->mdev->pdev, MLX5_EQ_VEC_COMP_BASE + ix));
>  	if (!c)
>  		return -ENOMEM;
>  
> @@ -1730,7 +1725,8 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
>  	c->mdev     = priv->mdev;
>  	c->tstamp   = &priv->tstamp;
>  	c->ix       = ix;
> -	c->cpu      = cpu;
> +	c->cpu      = cpumask_first(pci_irq_get_affinity(priv->mdev->pdev,
> +			MLX5_EQ_VEC_COMP_BASE + ix));

->cpu is only used to call cpu_to_node on it.  So remove it and switch
the users to

	pci_irq_get_node(priv->mdev->pdev)

instead.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
