From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 8/8] IB/mlx5: Exposure offload arithmetic
 operations
Date: Mon, 29 Feb 2016 00:40:52 +0200
Message-ID: <56D37774.2010800@mellanox.com>
References: <1455954465-15141-1-git-send-email-leon@leon.nu>
 <1455954465-15141-9-git-send-email-leon@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1255"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455954465-15141-9-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 2/20/2016 9:47 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Advertise the offload arithmetic operations support.
>
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   drivers/infiniband/hw/mlx5/main.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index 03c418c..9e92f48 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -549,6 +549,9 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
>   	if (MLX5_CAP_GEN(mdev, cd))
>   		props->device_cap_flags |= IB_DEVICE_CROSS_CHANNEL;
>
> +	if (MLX5_CAP_GEN(dev->mdev, vector_calc))
> +		props->device_cap_flags |= IB_DEVICE_VECTOR_CALC;

won't you like to advertise max_vector_count cap ?

props->calc_caps.max_vector_count =
                 MLX5_CAP_VECTOR_CALC(dev->mdev, max_vec_count);


> +
>   	return 0;
>   }
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
