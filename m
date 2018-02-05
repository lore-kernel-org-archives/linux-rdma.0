From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH] mlx5: fix mlx5_get_vector_affinity to start from
 completion vector 0
Date: Mon, 5 Feb 2018 16:28:02 +0200
Message-ID: <64670132-9662-9bbe-9979-fd02260a7fb3@grimberg.me>
References: <20180205142452.7630-1-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180205142452.7630-1-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sorry, now my .gitaliases updated with Jason's correct email.


On 02/05/2018 04:24 PM, Sagi Grimberg wrote:
> The consumers of this routine expects the affinity map of of vector
> index relative to the first completion vector. The upper layers are
> not aware of internal/private completion vectors that mlx5 allocates
> for its own usage.
> 
> Hence, return the affinity map of vector index relative to the first
> completion vector.
> 
> Fixes: 05e0cc84e00c ("net/mlx5: Fix get vector affinity helper function")
> Reported-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
> Tested-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.15
> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> ---
>   include/linux/mlx5/driver.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
> index a0610427e168..b82c4ae92411 100644
> --- a/include/linux/mlx5/driver.h
> +++ b/include/linux/mlx5/driver.h
> @@ -1238,7 +1238,7 @@ mlx5_get_vector_affinity(struct mlx5_core_dev *dev, int vector)
>   	int eqn;
>   	int err;
>   
> -	err = mlx5_vector2eqn(dev, vector, &eqn, &irq);
> +	err = mlx5_vector2eqn(dev, MLX5_EQ_VEC_COMP_BASE + vector, &eqn, &irq);
>   	if (err)
>   		return NULL;
>   
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
