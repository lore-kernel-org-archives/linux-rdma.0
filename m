From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next 3/3] IB/mlx5: Expose dump and fill memory key
Date: Wed, 4 Jul 2018 13:09:37 -0600
Message-ID: <20180704190937.GA15732@ziepe.ca>
References: <20180619054724.32677-1-leon@kernel.org>
 <20180619054724.32677-4-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180619054724.32677-4-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Yonatan Cohen <yonatanc@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 19, 2018 at 08:47:24AM +0300, Leon Romanovsky wrote:
> From: Yonatan Cohen <yonatanc@mellanox.com>
> 
> MLX5 IB HCA offers the memory key, dump_fill_mkey to boost
> performance, when used in a send or receive operations.
> 
> It is used to force local HCA operations to skip the PCI bus access,
> while keeping track of the processed length in the ibv_sge handling.
> 
> Meaning, instead of a PCI write access the HCA leaves the target
> memory untouched, and skips filling that packet section. Similar
> behavior is done upon send, the HCA skips data in memory relevant
> to this key and saves PCI bus access.
> 
> This functionality saves PCI read/write operations.
> 
> Signed-off-by: Yonatan Cohen <yonatanc@mellanox.com>
> Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
> Reviewed-by: Guy Levi <guyle@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>  drivers/infiniband/hw/mlx5/main.c | 16 +++++++++++++++-
>  include/uapi/rdma/mlx5-abi.h      |  3 ++-
>  2 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index c29c7c838980..97113957398d 100644
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -1634,6 +1634,7 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
>  	int err;
>  	size_t min_req_v2 = offsetof(struct mlx5_ib_alloc_ucontext_req_v2,
>  				     max_cqe_version);
> +	u32 dump_fill_mkey;
>  	bool lib_uar_4k;
>  
>  	if (!dev->ib_active)
> @@ -1743,8 +1744,12 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
>  		}
>  
>  		err = mlx5_ib_devx_create(dev, context);
> +	}
> +
> +	if (MLX5_CAP_GEN(dev->mdev, dump_fill_mkey)) {
> +		err = mlx5_cmd_dump_fill_mkey(dev->mdev, &dump_fill_mkey);
>  		if (err)
> -			goto out_td;
> +			goto out_mdev;
>  	}

Dropping the if (err) after mlx5_ib_devx_create is a rebasing error,
right?

Jason
