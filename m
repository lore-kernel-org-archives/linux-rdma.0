From: Yuval Shaia <yuval.shaia@oracle.com>
Subject: Re: [PATCH v3] net: mlx5: Add a missing check on idr_find, free buf
Date: Tue, 19 Mar 2019 18:03:59 +0200
Message-ID: <20190319160359.GD32657@lap1>
References: <20190319155524.6978-1-pakki001@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190319155524.6978-1-pakki001@umn.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Aditya Pakki <pakki001@umn.edu>
Cc: kjlu@umn.edu, Boris Pismenny <borisp@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, "David S. Miller" <davem@davemloft.net>, Ilya Lesokhin <ilyal@mellanox.com>, Wei Yongjun <weiyongjun1@huawei.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 19, 2019 at 10:55:20AM -0500, Aditya Pakki wrote:
> idr_find() can return a NULL value to 'flow' which is used without a check.
> The patch adds a check to avoid potential NULL pointer dereference.
> In case of mlx5_fpga_sbu_conn_sendmsg() failure, free buf allocated
> using kzalloc.
> 
> ---
> v2: failure to return in case of flow failure.
> v1: Failed to free buf in case of flow failure.
> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c
> index 5cf5f2a9d51f..224e0d7f6489 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c
> @@ -226,6 +226,11 @@ int mlx5_fpga_tls_resync_rx(struct mlx5_core_dev *mdev, u32 handle, u32 seq,
>  	rcu_read_lock();
>  	flow = idr_find(&mdev->fpga->tls->rx_idr, ntohl(handle));
>  	rcu_read_unlock();
> +	if (!flow) {
> +		WARN_ONCE(1, "Received NULL pointer for handle\n");
> +		kfree(buf);
> +		return -EINVAL;
> +	}
>  	mlx5_fpga_tls_flow_to_cmd(flow, cmd);
>  
>  	MLX5_SET(tls_cmd, cmd, swid, ntohl(handle));
> @@ -238,6 +243,8 @@ int mlx5_fpga_tls_resync_rx(struct mlx5_core_dev *mdev, u32 handle, u32 seq,
>  	buf->complete = mlx_tls_kfree_complete;
>  
>  	ret = mlx5_fpga_sbu_conn_sendmsg(mdev->fpga->tls->conn, buf);
> +	if (ret < 0)
> +		kfree(buf);
>  
>  	return ret;

Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>

>  }
> -- 
> 2.17.1
> 
