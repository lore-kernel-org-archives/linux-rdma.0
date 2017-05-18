From: Yuval Shaia <yuval.shaia@oracle.com>
Subject: Re: [PATCH net-next] net/mlx5e: Fix possible memory leak
Date: Thu, 18 May 2017 18:58:10 +0300
Message-ID: <20170518155807.GC10691@yuval-lap>
References: <20170518153441.24398-1-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170518153441.24398-1-weiyj.lk@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>, Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Hadar Hen Zion <hadarh@mellanox.com>, Wei Yongjun <weiyongjun1@huawei.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 18, 2017 at 03:34:41PM +0000, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> 'encap_header' is malloced and should be freed before leaving from
> the error handling cases, otherwise it will cause memory leak.
> 
> Fixes: 232c001398ae ("net/mlx5e: Add support to neighbour update flow")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index 11c27e4..a72ecbc 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -1404,8 +1404,8 @@ static int mlx5e_create_encap_header_ipv4(struct mlx5e_priv *priv,
>  
>  	if (!(nud_state & NUD_VALID)) {
>  		neigh_event_send(n, NULL);
> -		neigh_release(n);
> -		return -EAGAIN;
> +		err = -EAGAIN;
> +		goto out;
>  	}
>  
>  	err = mlx5_encap_alloc(priv->mdev, e->tunnel_type,
> @@ -1510,8 +1510,8 @@ static int mlx5e_create_encap_header_ipv6(struct mlx5e_priv *priv,
>  
>  	if (!(nud_state & NUD_VALID)) {
>  		neigh_event_send(n, NULL);
> -		neigh_release(n);
> -		return -EAGAIN;
> +		err = -EAGAIN;
> +		goto out;
>  	}

Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>

>  
>  	err = mlx5_encap_alloc(priv->mdev, e->tunnel_type,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
