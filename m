From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 5/8] mlx4: Add ability to poll CQs through
 iterator's style API
Date: Wed, 25 Jan 2017 10:04:13 -0700
Message-ID: <20170125170413.GC16579@obsidianresearch.com>
References: <1485355791-27646-1-git-send-email-yishaih@mellanox.com>
 <1485355791-27646-6-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485355791-27646-6-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 25, 2017 at 04:49:48PM +0200, Yishai Hadas wrote:
> diff --git a/providers/mlx4/mlx4.h b/providers/mlx4/mlx4.h
> index 5ab083c..cb4c8d4 100644
> +++ b/providers/mlx4/mlx4.h
> @@ -59,12 +59,20 @@ enum {
>  
>  #ifndef likely
>  #ifdef __GNUC__
> -#define likely(x)       __builtin_expect(!!(x),1)
> +#define likely(x)       __builtin_expect(!!(x), 1)
>  #else
>  #define likely(x)      (x)
>  #endif
>  #endif
>  
> +#ifndef unlikely
> +#ifdef __GNUC__
> +#define unlikely(x)	    __builtin_expect(!!(x), 0)
> +#else
> +#define unlikely(x)	   (x)
> +#endif
> +#endif

Also move all the copies of these into util/compiler.h instead of
adding more.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
