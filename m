From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] IB/mlx5: Fix memory leak in mlx5_ib_create_flow
Date: Fri, 8 Jun 2018 17:08:35 -0600
Message-ID: <20180608230835.GA24392@ziepe.ca>
References: <20180607191915.GA9092@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180607191915.GA9092@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Raed Salem <raeds@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 07, 2018 at 02:19:15PM -0500, Gustavo A. R. Silva wrote:
> In case memory resources for *ucmd* were allocated, release them
> before return.
> 
> Addresses-Coverity-ID: 1469857 ("Resource leak")
> Fixes: 3b3233fbf02e ("IB/mlx5: Add flow counters binding support")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>  drivers/infiniband/hw/mlx5/main.c | 33 +++++++++++++++++++++------------
>  1 file changed, 21 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index e52dd21..0472e6c 100644
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -3546,29 +3546,35 @@ static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
>  			return ERR_PTR(-ENOMEM);
>  
>  		err = ib_copy_from_udata(ucmd, udata, required_ucmd_sz);
> -		if (err) {
> -			kfree(ucmd);
> -			return ERR_PTR(err);
> -		}
> +		if (err)
> +			goto free_ucmd;
>  	}
>  
> -	if (flow_attr->priority > MLX5_IB_FLOW_LAST_PRIO)
> -		return ERR_PTR(-ENOMEM);
> +	if (flow_attr->priority > MLX5_IB_FLOW_LAST_PRIO) {
> +		err = -ENOMEM;
> +		goto free_ucmd;
> +	}
>  
>  	if (domain != IB_FLOW_DOMAIN_USER ||
>  	    flow_attr->port > dev->num_ports ||
>  	    (flow_attr->flags & ~(IB_FLOW_ATTR_FLAGS_DONT_TRAP |
> -				  IB_FLOW_ATTR_FLAGS_EGRESS)))
> -		return ERR_PTR(-EINVAL);
> +				  IB_FLOW_ATTR_FLAGS_EGRESS))) {
> +		err = -EINVAL;
> +		goto free_ucmd;
> +	}
>  
>  	if (is_egress &&
>  	    (flow_attr->type == IB_FLOW_ATTR_ALL_DEFAULT ||
> -	     flow_attr->type == IB_FLOW_ATTR_MC_DEFAULT))
> -		return ERR_PTR(-EINVAL);
> +	     flow_attr->type == IB_FLOW_ATTR_MC_DEFAULT)) {
> +		err = -EINVAL;
> +		goto free_ucmd;
> +	}
>  
>  	dst = kzalloc(sizeof(*dst), GFP_KERNEL);
> -	if (!dst)
> -		return ERR_PTR(-ENOMEM);
> +	if (!dst) {
> +		err = -ENOMEM;
> +		goto free_ucmd;
> +	}
>  
>  	mutex_lock(&dev->flow_db->lock);
>  
> @@ -3640,6 +3646,9 @@ static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
>  	kfree(ucmd);
>  	kfree(handler);
>  	return ERR_PTR(err);
> +free_ucmd:
> +	kfree(ucmd);
> +	return ERR_PTR(err);
>  }

This hunk is a bit wonky, can we do this instead? handle never needs
to be freed.

destroy_ft:
	put_flow_table(dev, ft_prio, false);
	if (ft_prio_tx)
		put_flow_table(dev, ft_prio_tx, false);
unlock:
	mutex_unlock(&dev->flow_db->lock);
	kfree(dst);
free_ucmd:
	kfree(ucmd);
	return ERR_PTR(err);
}


Jason
