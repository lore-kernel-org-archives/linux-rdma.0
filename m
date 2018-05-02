From: Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH] net/mlx4_core: Fix error handling in mlx4_init_port_info.
Date: Wed, 2 May 2018 16:31:24 +0300
Message-ID: <7e5d6d30-ed89-8a8e-55c1-a25897937727@mellanox.com>
References: <20180427152015.185861-1-tarick@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180427152015.185861-1-tarick@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Tarick Bedeir <tarick@google.com>, tariqt@mellanox.com, gthelen@google.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 27/04/2018 6:20 PM, Tarick Bedeir wrote:
> Avoid exiting the function with a lingering sysfs file (if the first
> call to device_create_file() fails while the second succeeds), and avoid
> calling devlink_port_unregister() twice.
> 
> In other words, either mlx4_init_port_info() succeeds and returns zero, or
> it fails, returns non-zero, and requires no cleanup.
> 
> Signed-off-by: Tarick Bedeir <tarick@google.com>
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
Acked-by: Tariq Toukan <tariqt@mellanox.com>

Thanks Tarick.
