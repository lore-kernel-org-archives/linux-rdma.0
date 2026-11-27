Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795818728;
	b=ApyW2IMbsbVswARturWGNB1Fjt5e/2tMLRazHz4qj83+8rigT+R1G/4W+wUU+pvVkq7d
	 /5DCAe6mmZ5fBtF7q9xb+X6Fd7GEoaOdzb5gvTnvY9jJIofLvTag+KNYAAluF+TaCXwbX
	 8ELMZR3h7J/LmyyPcuXHU/8ftDwk/aX66T1S5sbAo5TffxY+q214WWb08rqakcNyRseFQ
	 YQJQpThMO8eek/UxtiYj0BBHhefcSr+UAqczKCkoKQc/JCTG01r4zuIOG/Pd9qzopQgSF
	 jlDdH5hXxudNVmNpIR6Z2Q9zY0mxMVMpf8VM+0OqQnvLDXrDEzM6CijyR4wIeBp32kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795818728;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=xWeuXFNJEh/jiSDnxzK517P8HlQSiTzBLoh84vujaF0=;
	b=m1DQF9v8uJlNkjcDsRkbdYNL5MEWoZQo+m/iAjmWpKn7gOvEfaILyxcd/mpnklMRduAx
	 xjkWUAyZRr1ixkvA0LWdK94QdXRAzeSwBIgatPZytVfQn/qkY4N1b2pWlG1SR07XAhhPj
	 v9j7NdnE/60kQKTwNMtOKsxO1f9a/h4KGetxp9KvyDuUx8ULU3MdHaTfK/K+fGRsH6EgT
	 0LMOnUkgJSo43qYbwhcYHJLgUr6aNWKqoPJZC5ZiWRgQ0WH/dQPJEyM22NQs+ozY3BVzd
	 ToJBkHljxJ5WTrtoH9ioi7tvHhJtZMrVexPS6WJ7ttjxf7BxNWiE3HAHhRBkNFaNI7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UUR9vJV1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17667606A31C;
	Fri, 27 Nov 2026 22:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UUR9vJV1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61FB71F000C1;
	Fri, 27 Nov 2026 22:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795818727;
	bh=xWeuXFNJEh/jiSDnxzK517P8HlQSiTzBLoh84vujaF0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=UUR9vJV1FHwKwPTjfB8sKjNThc/9dq9eWGfiz6h2BtiM5LkLgwIfzjA9YaL0HbB+n
	 JH5mkEyQz2aZFT/nhuCQdjCyX1xHSe0pNVBKbQ4YtKmaWtIyeVuzyTc/FMxRqT+vkY
	 fqdE5NMjtle7HZ9f0iOX8EZDDLeztx2w6PWJsie9EEO5T8LCw/SE/oTngRaogVBJge
	 xVVYc01nGpcq/8Th2eGkCitpqyZ3sKxLxrlux6GfF9IPddUfoQdqhz3mYDcwUR6TGw
	 EzEikFcxpd7pO+upHxkq7j2EsXGncObnnG9M/yCBMgV5StJ7O3odhq2h0+SC6EAzIu
	 kVXtYqOd1tYSw==
Subject: Re: [PATCH net 02/10] net/mlx5e: Stop counting packets dropped by
 IPsec RX SA rules
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 willemb@google.com, parri.andrea@gmail.com, borisp@nvidia.com,
 cratiu@nvidia.com, eedmunds@nvidia.com, gal@nvidia.com, jmassar@nvidia.com,
 jianbol@nvidia.com, kuniyu@google.com, leon@kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, phaddad@nvidia.com,
 raeds@nvidia.com, saeedm@nvidia.com, horms@kernel.org,
 sridhar.samudrala@intel.com, steffen.klassert@secunet.com
Date: Fri, 27 Nov 2026 22:32:05 +0000
Message-ID: <179581872594.3135.1501113897778355076@kernel.org>
In-Reply-To: <20261126215614.792598-3-tariqt@nvidia.com>
References: <20261126215614.792598-3-tariqt@nvidia.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] In rx_add_rule()
  (drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c), the…

--

net/mlx5e: Stop counting packets dropped by IPsec RX SA rules

This patch removes the COUNT action and the counter destination from the
RX SA rule used when attrs->drop is set. Packets dropped in hardware are
then no longer added to x->curlft.packets for packet offload. The goal is
to match crypto offload accounting, and the rule keeps CRYPTO_DECRYPT so
ESN state keeps updating.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> index 502d89a18f9ec..0facc54771558 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c

[ ... ]

> @@ -2103,17 +2102,24 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
>  	flow_act.crypto.type = MLX5_FLOW_CONTEXT_ENCRYPT_DECRYPT_TYPE_IPSEC;
>  	flow_act.crypto.obj_id = sa_entry->ipsec_obj_id;
>  	flow_act.flags |= FLOW_ACT_NO_APPEND;
> -	flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_CRYPTO_DECRYPT |
> -			   MLX5_FLOW_CONTEXT_ACTION_COUNT;
> -	if (attrs->drop)
> +	/* Keep decrypting packets even when dropped, to allow ESN state
> +	 * updates.
> +	 */
> +	flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_CRYPTO_DECRYPT;
> +	if (attrs->drop) {
>  		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_DROP;
> -	else
> -		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
> -	dest[0].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
> -	dest[0].ft = rx->ft.status;
> -	dest[1].type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
> -	dest[1].counter = counter;
> -	rule = mlx5_add_flow_rules(rx->ft.sa, spec, &flow_act, dest, 2);
> +		rule = mlx5_add_flow_rules(rx->ft.sa, spec, &flow_act, NULL, 0);

[Severity: Medium]
Could this cause x->curlft.packets to drift away from the hardware ASO
packet-lifetime counter for packet offload RX SAs?

The drop rule still decrypts against sa_entry->ipsec_obj_id, so the ASO
context for that object keeps being processed. For any finite packet limit,
mlx5e_ipsec_packet_setup() in ipsec_offload.c arms the lifetime counter in
the same ASO context without checking the direction:

	if (attrs->lft.hard_packet_limit != XFRM_INF) {
		MLX5_SET(ipsec_aso, aso_ctx, remove_flow_pkt_cnt,
			 attrs->lft.hard_packet_limit);
		MLX5_SET(ipsec_aso, aso_ctx, hard_lft_arm, 1);
		MLX5_SET(ipsec_aso, aso_ctx, remove_flow_enable, 1);
	}

x->curlft.packets, however, is derived only from the SA rule flow counter
in mlx5e_xfrm_update_stats():

	mlx5_fc_query_cached(ipsec_rule->fc, &bytes, &packets, &lastuse);
	success_packets = packets - auth_packets - trailer_packets - replay_packets;
	x->curlft.packets += success_packets;

Before this patch, both counts included packets received in the drop
state. After it, only the hardware counter would, assuming the device
decrements remove_flow_pkt_cnt for packets that are decrypted and then
dropped by the same FTE. The code does not show whether the device does
this. Keeping DECRYPT so the ASO state keeps updating suggests that it
might.

If so, when the hardware soft lifetime event fires,
mlx5e_ipsec_handle_limits() checks curlft once and marks the soft limit
as handled:

		sa_entry->limits.soft_limit_hit = true;
		/* Notify about soft limit */
		xfrm_state_check_expire(sa_entry->x);

At that point curlft can be short by the number of packets received while
attrs->drop was set. The soft expiry (rekey) would then be missed on this
path.

In the final round, attrs->lft.soft_packet_limit is set to XFRM_INF, so
mlx5e_ipsec_handle_event() no longer calls mlx5e_ipsec_handle_limits(). Since
remove_flow_enable is set, can the hardware retire the SA while the xfrm
state is still valid, and drop traffic until curlft catches up?

The software poller mlx5e_ipsec_handle_sw_limits() returns early without
requeueing whenever attrs.drop is set. So the catch-up might also not happen.

The commit message says:

    Remove the count action and counter destination from the drop rule
    so these dropped packets stay out of the lifetime, matching crypto
    offload accounting.

Crypto offload does not arm the ASO lifetime counter. Is it intended that
the hardware lifetime for packet offload RX SAs still counts these drops
while curlft no longer does?

> +	} else {
> +		struct mlx5_flow_destination dest[2];
> +
> +		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
> +				   MLX5_FLOW_CONTEXT_ACTION_COUNT;
> +		dest[0].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
> +		dest[0].ft = rx->ft.status;
> +		dest[1].type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
> +		dest[1].counter = counter;
> +		rule = mlx5_add_flow_rules(rx->ft.sa, spec, &flow_act, dest, 2);
> +	}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261126215614.792598-1-tariqt%40nvidia.com
