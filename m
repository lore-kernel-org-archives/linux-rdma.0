Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB026470E8F;
	Thu, 23 Jul 2026 10:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784801583; cv=none; b=D2A/Whg8hce3/S7bBfOx44cMjyv/Fe5IF9Nkes3XYFj0D8z+wBLoxMdJvfF/uLJN1Eg5jnPfa7D921zsZGozkzch8v3Je5Cf8H1DAE/pC+hlPIIbFi4e2v508MtWLkClWW1s7XB0n+UPnXhY2Cq750ZMrtFAh5rIgrLDVSl9zNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784801583; c=relaxed/simple;
	bh=GiktL62H5OWU3TSce5mzV0wZIpcHwr6k0iFxnw2TvvM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hamreU+ig8w031wabAjS9clV6Gf5SJutj/NntG96lYTKGdv5jtEbuzCWlYQTfrAHCztRN7thwvPj45bGse8qQCXLby1OeSOwY6xrb2WNMgdIIUoB5JQyEN2WVt6GPJInzPitAqeQ7XfYPhDTitA4pjQKyLIuAEU1OOhBqF6mOaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD6D1F000E9;
	Thu, 23 Jul 2026 10:13:01 +0000 (UTC)
Date: Thu, 23 Jul 2026 13:12:55 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
	Mark Bloch <mbloch@nvidia.com>, Nimrod Oren <noren@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next 3/3] net/mlx5: add debugfs stats for doorbell
 dma pools
Message-ID: <20260723101255.GG110966@unreal>
References: <20260723072222.1863558-1-tariqt@nvidia.com>
 <20260723072222.1863558-4-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723072222.1863558-4-tariqt@nvidia.com>

On Thu, Jul 23, 2026 at 10:22:22AM +0300, Tariq Toukan wrote:
> From: Nimrod Oren <noren@nvidia.com>
> 
> Add a debugfs file exposing per-node DMA pool usage for doorbell
> allocations.
> 
>   # cat /sys/kernel/debug/mlx5/<dev>/db_dma_pools
>   node  block_size  used_blocks  allocated_blocks
>      0          64            0                 0
>      1          64            0                 0
> 
> Signed-off-by: Nimrod Oren <noren@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/alloc.c   | 30 +++++++++++++++++++
>  include/linux/mlx5/driver.h                   |  1 +
>  2 files changed, 31 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
> index 3975c726d35c..60ff413999f7 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
> @@ -437,11 +437,37 @@ void mlx5_frag_buf_free(struct mlx5_core_dev *dev, struct mlx5_frag_buf *buf)
>  }
>  EXPORT_SYMBOL_GPL(mlx5_frag_buf_free);
>  
> +static int mlx5_db_dma_pools_debugfs_show(struct seq_file *file, void *priv)
> +{
> +	struct mlx5_core_dev *dev = file->private;
> +	int node;
> +
> +	mlx5_dma_pools_debugfs_print_header(file);
> +
> +	if (!dev->priv.db_node_pools)
> +		return 0;

According to patch #1, this check is useless. You are failing mlx5 probe
function if DMA pools initialization failed.

Thanks

> +
> +	for_each_node_state(node, N_POSSIBLE) {
> +		struct mlx5_dma_pool *pool = dev->priv.db_node_pools[node];
> +
> +		if (!pool)
> +			continue;
> +
> +		mlx5_dma_pool_debugfs_stats_print(file, pool);
> +	}
> +
> +	return 0;
> +}
> +DEFINE_SHOW_ATTRIBUTE(mlx5_db_dma_pools_debugfs);
> +
>  void mlx5_db_pools_cleanup(struct mlx5_core_dev *dev)
>  {
>  	struct mlx5_priv *priv = &dev->priv;
>  	int node;
>  
> +	debugfs_remove(priv->dbg.db_dma_pools_debugfs);
> +	priv->dbg.db_dma_pools_debugfs = NULL;
> +
>  	for_each_node_state(node, N_POSSIBLE)
>  		if (priv->db_node_pools[node])
>  			mlx5_dma_pool_destroy(priv->db_node_pools[node]);
> @@ -471,6 +497,10 @@ int mlx5_db_pools_init(struct mlx5_core_dev *dev)
>  		priv->db_node_pools[node] = pool;
>  	}
>  
> +	priv->dbg.db_dma_pools_debugfs =
> +		debugfs_create_file("db_dma_pools", 0444, priv->dbg.dbg_root,
> +				    dev, &mlx5_db_dma_pools_debugfs_fops);
> +
>  	return 0;
>  }
>  
> diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
> index 2c56bb1d676d..83d0a83bbfbc 100644
> --- a/include/linux/mlx5/driver.h
> +++ b/include/linux/mlx5/driver.h
> @@ -548,6 +548,7 @@ struct mlx5_debugfs_entries {
>  	struct dentry *cq_debugfs;
>  	struct dentry *cmdif_debugfs;
>  	struct dentry *frag_buf_dma_pools_debugfs;
> +	struct dentry *db_dma_pools_debugfs;
>  	struct dentry *pages_debugfs;
>  	struct dentry *lag_debugfs;
>  };
> -- 
> 2.44.0
> 
