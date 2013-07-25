From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V8 libmlx4 1/2] Infra-structure changes to support verbs
 extensions
Date: Thu, 25 Jul 2013 11:19:56 -0600
Message-ID: <20130725171956.GB17616@obsidianresearch.com>
References: <1374741618-890-1-git-send-email-yishaih@mellanox.com>
 <1374741618-890-2-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1374741618-890-2-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 25, 2013 at 11:40:17AM +0300, Yishai Hadas wrote:
>  	pthread_spin_init(&context->uar_lock, PTHREAD_PROCESS_PRIVATE);
> +	ibv_ctx->ops = mlx4_ctx_ops;
> +	/* New verbs should be added as below
> +	* verbs_ctx->drv_new_func1 = mlx4_new_func1;
> +	*/

The comment needs revising to refer to verbs_set_ctx_op

>  static inline struct mlx4_device *to_mdev(struct ibv_device *ibdev)
>  {
> -	return to_mxxx(dev, device);
> +	/* ibv_device is first field of verbs_device
> +	  * see try_driver in libibverbs.
> +	*/
> +	return ((struct mlx4_device *)
> +	 ((void *)ibdev - offsetof(struct mlx4_device, verbs_dev)));
         ^^^^^^^^^^^^^^

container_of please

Also this can have my ack after these changes.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
