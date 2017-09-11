From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/2] mlx5: Report if kernel allows using MPW in
 SQ
Date: Mon, 11 Sep 2017 10:42:57 -0600
Message-ID: <20170911164257.GA2403@obsidianresearch.com>
References: <1505130185-32658-1-git-send-email-yishaih@mellanox.com>
 <1505130185-32658-2-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1505130185-32658-2-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 11, 2017 at 02:43:04PM +0300, Yishai Hadas wrote:
>  	MLX5DV_CONTEXT_FLAGS_CQE_V1	= (1 << 0),
> -	MLX5DV_CONTEXT_FLAGS_MPW	= (1 << 1),
> +	MLX5DV_CONTEXT_FLAGS_MPW	= (1 << 1), /* Obsoleted */
> +	MLX5DV_CONTEXT_FLAGS_MPW_ALLOWED = (1 << 2),
>  };
>  
>  enum mlx5dv_cq_init_attr_mask {
> diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
> index fc63ae9..0e8a9a3 100644
> +++ b/providers/mlx5/verbs.c
> @@ -1965,8 +1965,8 @@ int mlx5_query_device_ex(struct ibv_context *context,
>  	attr->rss_caps.rx_hash_function = resp.rss_caps.rx_hash_function;
>  	attr->packet_pacing_caps = resp.packet_pacing_caps.caps;
>  
> -	if (resp.support_multi_pkt_send_wqe)
> -		mctx->vendor_cap_flags |= MLX5_VENDOR_CAP_FLAGS_MPW;
> +	if (resp.support_multi_pkt_send_wqe & MLX5_ALLOW_MPW)
> +		mctx->vendor_cap_flags |= MLX5_VENDOR_CAP_FLAGS_MPW_ALLOWED;

Er, you can't just drop setting MLX5DV_CONTEXT_FLAGS_MPW? That would
break compat.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
