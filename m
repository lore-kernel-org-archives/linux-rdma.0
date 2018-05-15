From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2] {net, IB}/mlx5: Use 'kvfree()' for memory allocated
 by 'kvzalloc()'
Date: Tue, 15 May 2018 16:21:25 -0600
Message-ID: <20180515222125.GA20160@ziepe.ca>
References: <20180513070041.24246-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180513070041.24246-1-christophe.jaillet@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: saeedm@mellanox.com, matanb@mellanox.com, leon@kernel.org, dledford@redhat.com, davem@davemloft.net, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sun, May 13, 2018 at 09:00:41AM +0200, Christophe JAILLET wrote:
> When 'kvzalloc()' is used to allocate memory, 'kvfree()' must be used to
> free it.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> v1 -> v2: More places to update have been added to the patch
> ---
>  drivers/infiniband/hw/mlx5/cq.c                            | 2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/vport.c            | 6 +++---
>  3 files changed, 5 insertions(+), 5 deletions(-)

I agree with Eric on the need for fixes lines in v3..

> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
> index 77d257ec899b..6d52ea03574e 100644
> --- a/drivers/infiniband/hw/mlx5/cq.c
> +++ b/drivers/infiniband/hw/mlx5/cq.c
> @@ -849,7 +849,7 @@ static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *udata,
>  	return 0;
>  
>  err_cqb:
> -	kfree(*cqb);
> +	kvfree(*cqb);

For the infiniband part:

Acked-by: Jason Gunthorpe <jgg@mellanox.com>

Since this is mostly ethernet, can it go through netdev? thanks

Jason
