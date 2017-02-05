From: Tariq Toukan <ttoukan.linux@gmail.com>
Subject: Re: [patch net-next] net/mlx4_en: fix a condition
Date: Sun, 5 Feb 2017 10:26:54 +0200
Message-ID: <86df2437-317f-aaa3-fd33-406b3db30da3@gmail.com>
References: <20170203095459.GA5704@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20170203095459.GA5704@mwanda>
Sender: netdev-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Yishai Hadas <yishaih@mellanox.com>, Shaker Daibes <shakerd@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


On 03/02/2017 11:54 AM, Dan Carpenter wrote:
> There is a "||" vs "|" typo here so we test 0x1 instead of 0x6.
>
> Fixes: 1f8176f7352a ("net/mlx4_en: Check the enabling pptx/pprx flags in SET_PORT wrapper flow")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/net/ethernet/mellanox/mlx4/port.c b/drivers/net/ethernet/mellanox/mlx4/port.c
> index 5053c949148f..4e36e287d605 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/port.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/port.c
> @@ -1395,7 +1395,7 @@ static int mlx4_common_set_port(struct mlx4_dev *dev, int slave, u32 in_mod,
>   							  gen_context);
>   
>   			if (gen_context->flags &
> -			    (MLX4_FLAG_V_PPRX_MASK || MLX4_FLAG_V_PPTX_MASK))
> +			    (MLX4_FLAG_V_PPRX_MASK | MLX4_FLAG_V_PPTX_MASK))
>   				mlx4_en_set_port_global_pause(dev, slave,
>   							      gen_context);
>   
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Thanks Dan.
