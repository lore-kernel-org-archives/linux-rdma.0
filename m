From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH -next] RDMA/core: Properly return the error code of
 rdma_set_src_addr_rcu
Date: Wed, 19 Sep 2018 10:14:26 -0600
Message-ID: <20180919161426.GC9867@ziepe.ca>
References: <20180919122838.28184-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180919122838.28184-1-yuehaibing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: dledford@redhat.com, leon@kernel.org, parav@mellanox.com, danielj@mellanox.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 19, 2018 at 08:28:38PM +0800, YueHaibing wrote:
> rdma_set_src_addr_rcu should check copy_src_l2_addr fails,
> rather than always return 0. Also copy_src_l2_addr should return
> 'ret' as its return value while rdma_translate_ip fails.
> 
> Fixes: c31d4b2ddf07 ("RDMA/core: Protect against changing dst->dev during destination resolve")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Reviewed-by: Parav Pandit <parav@mellanox.com>
> ---
>  drivers/infiniband/core/addr.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)

Applied to for-next, thanks

> diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
> index 7a0356c..8a31b11 100644
> --- a/drivers/infiniband/core/addr.c
> +++ b/drivers/infiniband/core/addr.c
> @@ -468,7 +468,7 @@ static int addr_resolve_neigh(const struct dst_entry *dst,
>  	return ret;
>  }
>  
> -static void copy_src_l2_addr(struct rdma_dev_addr *dev_addr,
> +static int copy_src_l2_addr(struct rdma_dev_addr *dev_addr,
>  			     const struct sockaddr *dst_in,
>  			     const struct dst_entry *dst,
>  			     const struct net_device *ndev)

I fixed the indenting as Parav pointed out

> @@ -492,6 +492,8 @@ static void copy_src_l2_addr(struct rdma_dev_addr *dev_addr,
>  						RDMA_NETWORK_IPV6;
>  	else
>  		dev_addr->network = RDMA_NETWORK_IB;
> +
> +	return ret;
>  }
>  
>  static int rdma_set_src_addr_rcu(struct rdma_dev_addr *dev_addr,
> @@ -499,6 +501,7 @@ static int rdma_set_src_addr_rcu(struct rdma_dev_addr *dev_addr,
>  				 const struct sockaddr *dst_in,
>  				 const struct dst_entry *dst)
>  {
> +	int ret;
>  	struct net_device *ndev = READ_ONCE(dst->dev);
>  
>  	*ndev_flags = ndev->flags;
> @@ -515,8 +518,8 @@ static int rdma_set_src_addr_rcu(struct rdma_dev_addr *dev_addr,
>  			return -ENODEV;
>  	}
>  
> -	copy_src_l2_addr(dev_addr, dst_in, dst, ndev);
> -	return 0;
> +	ret = copy_src_l2_addr(dev_addr, dst_in, dst, ndev);
> +	return ret;
>  }

And made this just 'return copy_src_l2_addr' without the ret.

Jason
