From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/5] mlx5: Fix mlx5_srq_attr.pas endianness annotation
Date: Tue, 6 Dec 2016 15:55:12 +0200
Message-ID: <20161206135512.GB2437@mtr-leonro.local>
References: <9ff07804-492c-c67a-e729-b31e0f863027@sandisk.com>
 <3d4f5ffa-e9bf-cd28-d200-74c5dd3d68ce@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3d4f5ffa-e9bf-cd28-d200-74c5dd3d68ce-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 05, 2016 at 05:19:29PM -0800, Bart Van Assche wrote:
> Detected by sparse.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks Bart,
It is fixed in Dave's tree.
https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git/commit/include/linux/mlx5/srq.h?id=dd257efb1e0f8875ed7e42b88837a8dada0d0e41


> ---
>  include/linux/mlx5/srq.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/mlx5/srq.h b/include/linux/mlx5/srq.h
> index 33c97dc900f8..1cde0fd53f90 100644
> --- a/include/linux/mlx5/srq.h
> +++ b/include/linux/mlx5/srq.h
> @@ -55,7 +55,7 @@ struct mlx5_srq_attr {
>  	u32 lwm;
>  	u32 user_index;
>  	u64 db_record;
> -	u64 *pas;
> +	__be64 *pas;
>  };
>  
>  struct mlx5_core_dev;
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
