From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-next v3 17/24] IB/mlx4: Remove redundant attribute in
 mlx4_ib_create_qp_rss struct
Date: Thu, 24 Aug 2017 16:41:06 -0400
Message-ID: <1503607266.78641.49.camel@redhat.com>
References: <20170817125055.31424-1-leon@kernel.org>
         <20170817125055.31424-18-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170817125055.31424-18-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-08-17 at 15:50 +0300, Leon Romanovsky wrote:
> From: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> rss_key_len is not in use and need to be removed.

I fixed this commit message as I took this in.

> Fixes: 3078f5f1bd8b ("IB/mlx4: Add support for RSS QP")
> Signed-off-by: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  include/uapi/rdma/mlx4-abi.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/include/uapi/rdma/mlx4-abi.h b/include/uapi/rdma/mlx4-
> abi.h
> index 0e10102861b5..c55f60e05f86 100644
> --- a/include/uapi/rdma/mlx4-abi.h
> +++ b/include/uapi/rdma/mlx4-abi.h
> @@ -98,8 +98,7 @@ struct mlx4_ib_create_srq_resp {
>  struct mlx4_ib_create_qp_rss {
>  	__u64   rx_hash_fields_mask;
>  	__u8    rx_hash_function;
> -	__u8    rx_key_len;
> -	__u8    reserved[6];
> +	__u8    reserved[7];
>  	__u8    rx_hash_key[40];
>  	__u32   comp_mask;
>  	__u32   reserved1;
-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
