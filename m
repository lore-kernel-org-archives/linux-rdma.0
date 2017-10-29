From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/2] mlx5: Fix wrong bitmap table allocation
 size calculation
Date: Sun, 29 Oct 2017 11:37:03 -0600
Message-ID: <20171029173703.GB4488@ziepe.ca>
References: <1509282070-1391-1-git-send-email-yishaih@mellanox.com>
 <1509282070-1391-3-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1509282070-1391-3-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 29, 2017 at 03:01:10PM +0200, Yishai Hadas wrote:

> diff --git a/providers/mlx5/buf.c b/providers/mlx5/buf.c
> index 8196db6..0ba8188 100644
> +++ b/providers/mlx5/buf.c
> @@ -51,7 +51,7 @@ static int mlx5_bitmap_init(struct mlx5_bitmap *bitmap, uint32_t num,
>  	bitmap->avail = num;
>  	bitmap->mask = mask;
>  	bitmap->avail = bitmap->max;
> -	bitmap->table = calloc(BITS_TO_LONGS(bitmap->max), sizeof(uint32_t));
> +	bitmap->table = calloc(BITS_TO_LONGS(bitmap->max), sizeof(long));

bitmap->table is sensibly set to a 'unsigned long' but here, and in
several other related macros, 'long' is used instead.. Looks weird to
mix and match the sigend and unsigned versions.

Generally, I prefer:
	bitmap->table = calloc(BITS_TO_LONGS(bitmap->max),
	                       sizeof(*bitmap->table));

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
