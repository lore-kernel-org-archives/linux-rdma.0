From: Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH v2] net/mlx4_core: Fix error handling in
 mlx4_init_port_info.
Date: Mon, 14 May 2018 12:08:59 +0300
Message-ID: <02b1c1aa-9d40-78ac-8136-f2c46d0e2424@mellanox.com>
References: <20180513233845.135290-1-tarick@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180513233845.135290-1-tarick@google.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Tarick Bedeir <tarick@google.com>, tariqt@mellanox.com, gthelen@google.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
List-Id: linux-rdma@vger.kernel.org



On 14/05/2018 2:38 AM, Tarick Bedeir wrote:
> Avoid exiting the function with a lingering sysfs file (if the first
> call to device_create_file() fails while the second succeeds), and avoid
> calling devlink_port_unregister() twice.
> 
> In other words, either mlx4_init_port_info() succeeds and returns zero, or
> it fails, returns non-zero, and requires no cleanup.
> 
> Fixes: 096335b3f983 ("mlx4_core: Allow dynamic MTU configuration for IB
> ports")
> Signed-off-by: Tarick Bedeir <tarick@google.com>
> ---
> v1 -> v2: Added "Fixes" tag.
> ---
>   drivers/net/ethernet/mellanox/mlx4/main.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
> index 4d84cab77105..e8a3a45d0b53 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/main.c
> @@ -3007,6 +3007,7 @@ static int mlx4_init_port_info(struct mlx4_dev *dev, int port)
>   		mlx4_err(dev, "Failed to create file for port %d\n", port);
>   		devlink_port_unregister(&info->devlink_port);
>   		info->port = -1;
> +		return err;
>   	}
>   
>   	sprintf(info->dev_mtu_name, "mlx4_port%d_mtu", port);
> @@ -3028,9 +3029,10 @@ static int mlx4_init_port_info(struct mlx4_dev *dev, int port)
>   				   &info->port_attr);
>   		devlink_port_unregister(&info->devlink_port);
>   		info->port = -1;
> +		return err;
>   	}
>   
> -	return err;
> +	return 0;
>   }
>   
>   static void mlx4_cleanup_port_info(struct mlx4_port_info *info)
> 

Thanks for you patch.
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>

Dave, please queue for -stable.

Best,
Tariq
