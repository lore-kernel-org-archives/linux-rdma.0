From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/2] mlx5: Use non-cached mapping when
 Blueflame is not used
Date: Sun, 29 Oct 2017 11:33:44 -0600
Message-ID: <20171029173344.GA4488@ziepe.ca>
References: <1509282070-1391-1-git-send-email-yishaih@mellanox.com>
 <1509282070-1391-2-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1509282070-1391-2-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 29, 2017 at 03:01:09PM +0200, Yishai Hadas wrote:

> diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
> index ffe2c55..9e20a25 100644
> +++ b/providers/mlx5/mlx5dv.h
> @@ -632,6 +632,11 @@ enum mlx5dv_set_ctx_attr_type {
>  	MLX5DV_CTX_ATTR_BUF_ALLOCATORS = 1,
>  };
>  
> +enum {
> +	MLX5_MMAP_GET_REGULAR_PAGES_CMD	= 0,
> +	MLX5_MMAP_GET_NC_PAGES_CMD	= 3,
> +};
> +

These are added to a public header, but I couldn't see where they
would get used by a DV user??

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
