From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] net/mlx5: Fix mlx5_get_vector_affinity function
Date: Sat, 5 May 2018 07:38:38 -0700
Message-ID: <20180505143838.GA12621@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Israel Rukshin <israelr@mellanox.com>
Cc: Max Gurtovoy <maxg@mellanox.com>, Matan Barak <matanb@mellanox.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 12, 2018 at 09:49:11AM +0000, Israel Rukshin wrote:
> Adding the vector offset when calling to mlx5_vector2eqn() is wrong.
> This is because mlx5_vector2eqn() checks if EQ index is equal to vector number
> and the fact that the internal completion vectors that mlx5 allocates
> don't get an EQ index.
> 
> The second problem here is that using effective_affinity_mask gives the same
> CPU for different vectors.
> This leads to unmapped queues when calling it from blk_mq_rdma_map_queues().
> This doesn't happen when using affinity_hint mask.
> 
Except that affinity_hint is only defined if SMP is enabled. Without:

include/linux/mlx5/driver.h: In function ‘mlx5_get_vector_affinity_hint’:
include/linux/mlx5/driver.h:1299:13: error:
        ‘struct irq_desc’ has no member named ‘affinity_hint’

Note that this is the only use of affinity_hint outside kernel/irq.
Don't other drivers have similar problems ?

Guenter

> Fixes: 2572cf57d75a ("mlx5: fix mlx5_get_vector_affinity to start from completion vector 0")
> Fixes: 05e0cc84e00c ("net/mlx5: Fix get vector affinity helper function")
> Signed-off-by: Israel Rukshin <israelr@mellanox.com>
> Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> ---
>  drivers/infiniband/hw/mlx5/main.c |  2 +-
>  include/linux/mlx5/driver.h       | 12 +++---------
>  2 files changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index daa919e5a442..241cf4ff9901 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -4757,7 +4757,7 @@ mlx5_ib_get_vector_affinity(struct ib_device *ibdev, int comp_vector)
>  {
>  	struct mlx5_ib_dev *dev = to_mdev(ibdev);
>  
> -	return mlx5_get_vector_affinity(dev->mdev, comp_vector);
> +	return mlx5_get_vector_affinity_hint(dev->mdev, comp_vector);
>  }
>  
>  /* The mlx5_ib_multiport_mutex should be held when calling this function */
> diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
> index 767d193c269a..2a156c5dfadd 100644
> --- a/include/linux/mlx5/driver.h
> +++ b/include/linux/mlx5/driver.h
> @@ -1284,25 +1284,19 @@ enum {
>  };
>  
>  static inline const struct cpumask *
> -mlx5_get_vector_affinity(struct mlx5_core_dev *dev, int vector)
> +mlx5_get_vector_affinity_hint(struct mlx5_core_dev *dev, int vector)
>  {
> -	const struct cpumask *mask;
>  	struct irq_desc *desc;
>  	unsigned int irq;
>  	int eqn;
>  	int err;
>  
> -	err = mlx5_vector2eqn(dev, MLX5_EQ_VEC_COMP_BASE + vector, &eqn, &irq);
> +	err = mlx5_vector2eqn(dev, vector, &eqn, &irq);
>  	if (err)
>  		return NULL;
>  
>  	desc = irq_to_desc(irq);
> -#ifdef CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK
> -	mask = irq_data_get_effective_affinity_mask(&desc->irq_data);
> -#else
> -	mask = desc->irq_common_data.affinity;
> -#endif
> -	return mask;
> +	return desc->affinity_hint;
>  }
>  
>  #endif /* MLX5_DRIVER_H */
> -- 
> 2.7.4
