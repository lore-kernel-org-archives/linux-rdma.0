From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] mlx4: Add inline-receive support
Date: Mon, 11 Sep 2017 10:05:08 -0600
Message-ID: <20170911160508.GA32117@obsidianresearch.com>
References: <1505036749-12297-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1505036749-12297-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Sep 10, 2017 at 12:45:49PM +0300, Yishai Hadas wrote:

> diff --git a/providers/mlx4/libmlx4.map b/providers/mlx4/libmlx4.map
> index 0e53f83..6de4348 100644
> +++ b/providers/mlx4/libmlx4.map
> @@ -3,5 +3,7 @@
>  MLX4_1.0 {
>  	global:
>  		mlx4dv_init_obj;
> +		mlx4dv_query_device;
> +		mlx4dv_create_qp;

NAK please read Documentation/versioning.md and do this properly.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
