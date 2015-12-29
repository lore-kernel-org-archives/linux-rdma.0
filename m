From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2] IB/mlx5: Unify CQ create flags check
Date: Tue, 29 Dec 2015 16:47:55 +0200
Message-ID: <56829D1B.50206@mellanox.com>
References: <1451400097-17252-1-git-send-email-leon@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1451400097-17252-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/29/2015 4:41 PM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> The create_cq() can receive creation flags which were used
> differently by two commits which added create_cq extended
> command and cross-channel. The merged code caused to not
> accept any flags at all.
>
> This patch unifies the check into one function and one return
> error code.
>
> Fixes: 972ecb821379 ("IB/mlx5: Add create_cq extended command")
> Fixes: 051f263098a9 ("IB/mlx5: Add driver cross-channel support")
>
> ---
> Changes from v1:
>    * Remove links to linux-rdma from commit message
>    * Placed change log under git comment section (---)
> Changes from v0:
>    * Add Fixes tag
>
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
wrong placing. Needs to be before the 1st --- and w.o blank lines after 
the Fixes: lines please

Please use dry runs to get this to run (...) correctly


> ---
>   drivers/infiniband/hw/mlx5/cq.c      | 9 +--------
>   drivers/infiniband/hw/mlx5/mlx5_ib.h | 3 ++-
>   2 files changed, 3 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
> index b14316603e44..7ddc790b1819 100644
> --- a/drivers/infiniband/hw/mlx5/cq.c
> +++ b/drivers/infiniband/hw/mlx5/cq.c
> @@ -757,10 +757,6 @@ static void destroy_cq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq)
>   	mlx5_db_free(dev->mdev, &cq->db);
>   }
>   
> -enum {
> -	CQ_CREATE_FLAGS_SUPPORTED = IB_CQ_FLAGS_TIMESTAMP_COMPLETION
> -};
> -
>   struct ib_cq *mlx5_ib_create_cq(struct ib_device *ibdev,
>   				const struct ib_cq_init_attr *attr,
>   				struct ib_ucontext *context,
> @@ -778,13 +774,10 @@ struct ib_cq *mlx5_ib_create_cq(struct ib_device *ibdev,
>   	int eqn;
>   	int err;
>   
> -	if (check_cq_create_flags(attr->flags))
> -		return ERR_PTR(-EINVAL);
> -
>   	if (entries < 0)
>   		return ERR_PTR(-EINVAL);
>   
> -	if (attr->flags & ~CQ_CREATE_FLAGS_SUPPORTED)
> +	if (check_cq_create_flags(attr->flags))
>   		return ERR_PTR(-EOPNOTSUPP);
>   
>   	entries = roundup_pow_of_two(entries + 1);
> diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> index d4b227126265..fbf14a768105 100644
> --- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> @@ -692,6 +692,7 @@ static inline u32 check_cq_create_flags(u32 flags)
>   	 * It returns non-zero value for unsupported CQ
>   	 * create flags, otherwise it returns zero.
>   	 */
> -	return (flags & ~IB_CQ_FLAGS_IGNORE_OVERRUN);
> +	return (flags & ~(IB_CQ_FLAGS_IGNORE_OVERRUN |
> +			  IB_CQ_FLAGS_TIMESTAMP_COMPLETION));
>   }
>   #endif /* MLX5_IB_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
