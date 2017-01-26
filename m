From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/7] mlx5: Add mlx5 direct verbs files
Date: Thu, 26 Jan 2017 10:27:42 -0700
Message-ID: <20170126172742.GC16562@obsidianresearch.com>
References: <1485446182-5109-1-git-send-email-yishaih@mellanox.com>
 <1485446182-5109-2-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485446182-5109-2-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 26, 2017 at 05:56:16PM +0200, Yishai Hadas wrote:

> +add_subdirectory(include)

No need for a subdirectory. I've been flattening things for a while

> +/* Always inline the function */
> +#ifdef __GNUC__
> +#define MLX5DV_ALWAYS_INLINE inline __attribute__((always_inline))
> +#else
> +#define MLX5DV_ALWAYS_INLINE inline
> +#endif

I doubt this is necessary... static inline is fine these days.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
