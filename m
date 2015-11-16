From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH libmlx5 v1  2/5] libmlx5: Add QPs and XSRQs resource
 tracking
Date: Mon, 16 Nov 2015 18:42:56 +0200
Message-ID: <20151116164256.GC21849@x-vnc01.mtx.labs.mlnx>
References: <1447587059-26725-1-git-send-email-hagaya@dev-l-vrt-198-005.mtl.labs.mlnx>
 <1447587059-26725-3-git-send-email-hagaya@dev-l-vrt-198-005.mtl.labs.mlnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447587059-26725-3-git-send-email-hagaya-15NSNdRadKCMbgUxWz6G6EUdt8N5EOSuJ7HPLuWx/II@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hagay Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 15, 2015 at 01:30:56PM +0200, Hagay Abramovsky wrote:
> From: Haggai Abramonvsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> +
> +int32_t mlx5_store_uidx(struct mlx5_context *ctx, void *rsc)
> +{
> +	int32_t tind;
> +	int32_t ret = -1;
You don't need this variable. Just initialize uidx and return uidx
always.
> +	int32_t uidx;
> +
> +	pthread_mutex_lock(&ctx->uidx_table_mutex);
> +	uidx = get_free_uidx(ctx);
> +	if (uidx < 0)
> +		goto out;
> +
> +	tind = uidx >> MLX5_UIDX_TABLE_SHIFT;
> +
> +	if (!ctx->uidx_table[tind].refcnt) {
> +		ctx->uidx_table[tind].table = calloc(MLX5_UIDX_TABLE_MASK + 1,
> +						     sizeof(void *));
> +		if (!ctx->uidx_table[tind].table)
> +			goto out;
> +	}
> +
> +	++ctx->uidx_table[tind].refcnt;
> +	ctx->uidx_table[tind].table[uidx & MLX5_UIDX_TABLE_MASK] = rsc;
> +	ret = uidx;
> +
> +out:
> +	pthread_mutex_unlock(&ctx->uidx_table_mutex);
> +	return ret;
> +}
> +
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
