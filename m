From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH net-next] net/mlx5e: fix error return code in
 mlx5e_alloc_rq()
Date: Wed, 10 Jan 2018 15:08:12 +0100
Message-ID: <20180110150812.4ced3f5a@redhat.com>
References: <1515569453-63865-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1515569453-63865-1-git-send-email-weiyongjun1@huawei.com>
Sender: netdev-owner@vger.kernel.org
To: Wei Yongjun <weiyongjun1@huawei.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>, Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, brouer@redhat.com
List-Id: linux-rdma@vger.kernel.org


On Wed, 10 Jan 2018 07:30:53 +0000 Wei Yongjun <weiyongjun1@huawei.com> wrote:

> Fix to return a negative error code from the xdp_rxq_info_reg() error
> handling case instead of 0, as done elsewhere in this function.
> 
> Fixes: 0ddf543226ac ("xdp/mlx5: setup xdp_rxq_info")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 539bd1d..6ba6671 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -582,7 +582,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
>  		goto err_rq_wq_destroy;
>  	}
>  
> -	if (xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq->ix) < 0)
> +	err = xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq->ix);
> +	if (err < 0)
>  		goto err_rq_wq_destroy;
>  
>  	rq->buff.map_dir = rq->xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;

Reviewed-by: Jesper Dangaard Brouer <brouer@redhat.com>

Thanks for fixing this.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
