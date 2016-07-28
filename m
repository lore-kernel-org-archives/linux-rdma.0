From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH libmlx5 5/6] fix alloc of mlx5_resource table
Date: Thu, 28 Jul 2016 18:25:58 +0300
Message-ID: <25aa7d7a-a12f-3232-8c5f-ead4e512bf3b@dev.mellanox.co.il>
References: <1469647047-7544-1-git-send-email-jarod@redhat.com>
 <1469647047-7544-6-git-send-email-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469647047-7544-6-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/27/2016 10:17 PM, Jarod Wilson wrote:
> Defect type: CLANG_WARNING
>
> libmlx5-1.2.1/src/mlx5.c:184:33: note: Result of 'calloc' is converted
> to a pointer of type 'struct mlx5_resource *', which is incompatible with
> sizeof operand type 'void *'
>
>  #                 ctx->uidx_table[tind].table = calloc(MLX5_UIDX_TABLE_MASK + 1,
>  #                                               ^~~~~~
>  #   182|
>  #   183|   	if (!ctx->uidx_table[tind].refcnt) {
>  #   184|-> 		ctx->uidx_table[tind].table = calloc(MLX5_UIDX_TABLE_MASK + 1,
>  #   185|   						     sizeof(void *));
>  #   186|   		if (!ctx->uidx_table[tind].table)
>
> Use sizeof(struct mlx5_resource *) for calloc size argument instead.
>
> CC: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  src/mlx5.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/src/mlx5.c b/src/mlx5.c
> index a5f8daf..99221e6 100644
> --- a/src/mlx5.c
> +++ b/src/mlx5.c
> @@ -182,7 +182,7 @@ int32_t mlx5_store_uidx(struct mlx5_context *ctx, void *rsc)
>
>  	if (!ctx->uidx_table[tind].refcnt) {
>  		ctx->uidx_table[tind].table = calloc(MLX5_UIDX_TABLE_MASK + 1,
> -						     sizeof(void *));
> +						     sizeof(struct mlx5_resource *));

As both are pointers the allocation size is equal in both cases and code 
is safe. However, to prevent this CLANG WARNING will take this change, 
thanks.

>  		if (!ctx->uidx_table[tind].table)
>  			goto out;
>  	}
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
