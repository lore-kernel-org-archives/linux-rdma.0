From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH V4 for-next 10/10] IB/mlx5: Add RSS QP support
Date: Sun, 29 May 2016 16:16:37 +0300
Message-ID: <574AEBB5.70004@grimberg.me>
References: <1464006056-19653-1-git-send-email-yishaih@mellanox.com>
 <1464006056-19653-11-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464006056-19653-11-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> +/* RX Hash function flags */
> +enum mlx5_rx_hash_function_flags {
> +	MLX5_RX_HASH_FUNC_TOEPLITZ	= 1 << 0,
> +};
> +
> +/*
> + * RX Hash flags, these flags allows to set which incoming packet's field should
> + * participates in RX Hash. Each flag represent certain packet's field,
> + * when the flag is set the field that is represented by the flag will
> + * participate in RX Hash calculation.
> + * Note: *IPV4 and *IPV6 flags can't be enabled together on the same QP
> + * and *TCP and *UDP flags can't be enabled together on the same QP.
> +*/
> +enum mlx5_rx_hash_fields {
> +	MLX5_RX_HASH_SRC_IPV4	= 1 << 0,
> +	MLX5_RX_HASH_DST_IPV4	= 1 << 1,
> +	MLX5_RX_HASH_SRC_IPV6	= 1 << 2,
> +	MLX5_RX_HASH_DST_IPV6	= 1 << 3,
> +	MLX5_RX_HASH_SRC_PORT_TCP	= 1 << 4,
> +	MLX5_RX_HASH_DST_PORT_TCP	= 1 << 5,
> +	MLX5_RX_HASH_SRC_PORT_UDP	= 1 << 6,
> +	MLX5_RX_HASH_DST_PORT_UDP	= 1 << 7
> +};

I never really understood why these should be driver specific but I
know it was decided so...

Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
