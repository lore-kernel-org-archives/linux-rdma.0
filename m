Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8434F44F57A;
	Thu, 10 Sep 2026 21:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789077276; cv=none; b=i28HUxyvjUT9m4EzLX+iakGry6uoWrSQcWsr/LHdVbrNM3y/ZIna7Llv9fknYfuGDsGN97Ean8lb6TSxS/XOcUArUhJWLBgb+H3khboY8YQf4nh464n65Gi46BjSnZ0EYocj2nygapLTR/155lNWpnEwWXBOqWgWb1tQC+YTGd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789077276; c=relaxed/simple;
	bh=1Y3VzRTFlBrokFLTu3xRpPC6l5Oq5ZtvNMh55k4A3n4=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=atWYejpDy8SWMPCvxGkyqh6xxiMbrZ1ZTGJ5koROOhsx0n74i3Xb6aKWJ6P6DFeDO3v5EaTorQICQ9PL4+1FjRDAYKaOOSEYauluQn7oGcSmdeaWCq7+eDTzBbC7pZcWe/D8mNR02JfxJQ9r4eaCGQr74322zHePQFi4qRjWxDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WkC9UtKT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WkC9UtKT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881231F00898;
	Thu, 10 Sep 2026 21:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789077275;
	bh=qYbawNJsHUtq6q1bd9DO/sUtHz0H5c8qbmBt7m217hI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=WkC9UtKTGXyykFGzNqj3Rthp5i1XAhjn7S+J1xEITt3SPDC4z8GbGI3PmC0Yr4G4p
	 Cwm18BYPLTXGA4fl2iUXjhNISYCbP+fYD8ZI1eClDlbAHYRW4J/qMu8SGLTfaBsdWl
	 8hp5jQn4lHmiCt0ievTOKSfeq0X3KT76yZwNhwSwn8qDlenOOnuh8x0C02GrsKsIDo
	 nfUPewYfweWZCeJLJ32hx3/3iJYEb9VLWy/swKBytTVse+BKgran1K2FzYlfnSRRTy
	 BrfRj/M/0Ibd39pNhwKd5E7vZk92dXefQnuYCa7lR65lNmrTv33v5+hJN2ARf2MqI8
	 zOYhLF4aDJ91A==
Subject: Re: [PATCH net-next V4 10/14] net/mlx5e: shampo: Flush session on PSP
 mismatch
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 sd@queasysnail.net, bobbyeshleman@meta.com, borisp@nvidia.com,
 cjubran@nvidia.com, cratiu@nvidia.com, daniel.zahka@gmail.com, doruk@0sec.ai,
 dtatulea@nvidia.com, gal@nvidia.com, jianbol@nvidia.com, kees@kernel.org,
 leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, petrm@nvidia.com, raeds@nvidia.com, rrameshbabu@nvidia.com,
 saeedm@nvidia.com, shuah@kernel.org, skhan@linuxfoundation.org,
 horms@kernel.org, willemb@google.com, willemdebruijn.kernel@gmail.com
Date: Thu, 10 Sep 2026 21:54:33 +0000
Message-ID: <178907727309.219967.8541655657773031767@kernel.org>
In-Reply-To: <20260908065244.3799142-11-tariqt@nvidia.com>
References: <20260908065244.3799142-11-tariqt@nvidia.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 1 · Low: 0

- [Medium] Understated impact / missing Fixes: tag.

--

net/mlx5e: shampo: Flush session on PSP mismatch

This adds mlx5e_hw_gro_psp_match() and wires it into the SHAMPO session
match test in mlx5e_handle_rx_cqe_mpwrq_shampo(), so a session is flushed
when the PSP status changes, when SPI/version differ, or when the CQE
indicates a non-decapsulated PSP packet.

(No Link: tags present in the commit header.)

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> index e3f915beebe1..9eb11be7abe0 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> @@ -2224,6 +2224,33 @@ static bool mlx5e_hw_gro_skb_has_enough_space(struct sk_buff *skb,
>  		return page_size * nr_frags + data_bcnt <= GRO_LEGACY_MAX_SIZE;
>  }
>  
> +static bool mlx5e_hw_gro_psp_match(struct sk_buff *skb, struct mlx5_cqe64 *cqe)
> +{
> +#ifdef CONFIG_MLX5_EN_PSP
> +	struct psp_skb_ext *pse = skb_ext_find(skb, SKB_EXT_PSP);
> +	bool is_psp = mlx5e_psp_is_rx_flow(cqe);
> +
> +	if (likely(!is_psp && !pse))
> +		return true;
> +
> +	/* No match on PSP status change (no crypto -> crypto or vice-versa). */
> +	if (unlikely(is_psp != !!pse))
> +		return false;
> +
> +	/* SPI and version are only available in CQE metadata for decap flows.
> +	 * Non-decap PSP cannot be matched here, force a flush.
> +	 */
> +	if (unlikely(!mlx5e_psp_is_decap(cqe)))
> +		return false;

[Severity: Medium]
Is the commit message understating what this particular hunk fixes?  The
message says:

    The session is also forcefully flushed if non-decapsulated packets are
    received. This could happen if, for example, the decap table could not
    be created so HW GRO is active but there's no decapsulation.

At the baseline commit (bc6fe9d301d5), non-decap looks like the only PSP
RX mode rather than an exceptional fallback:
mlx5e_psp_offload_handle_rx_skb() in en_accel/psp_rxtx.c only calls
psp_dev_rcv(), and mlx5e_psp_update_rx()/shampo_enabled() coupling between
PSP and NETIF_F_GRO_HW is only added by a later patch in this series.

If that is right, does the following sequence mis-deliver payload bytes
today, without this patch?

mlx5e_handle_rx_cqe_mpwrq_shampo()
  -> HW coalesces several PSP datagrams sharing the outer IP/UDP 5-tuple
     (mlx5e_shampo_update_hdr() -> mlx5e_shampo_update_ipv4_udp_hdr()
      sets SKB_GSO_UDP_L4, so UDP flows are aggregated too)
  -> mlx5e_shampo_complete_rx_cqe():

	if (NAPI_GRO_CB(skb)->count != 1)
		return false;

	if (mlx5e_build_rx_skb(cqe, cqe_bcnt, rq, skb))
		return true;

so mlx5e_build_rx_skb() -> mlx5e_psp_offload_handle_rx_skb() ->
psp_dev_rcv() runs only for the first record of a session.  psp_dev_rcv()
in net/psp/psp_main.c strips one 16-byte PSP header plus one 16-byte
trailer and adjusts iph->tot_len once, so do the PSP headers and ICVs of
records 2..N remain embedded in the payload handed to the socket?

If so, should the commit message say that PSP + HW GRO
(ethtool -K <dev> rx-gro-hw on, also implied by tcp-data-split) is broken
in the current tree, and should the patch carry a Fixes: tag so stable
kernels shipping mlx5e PSP pick it up?  A natural candidate looks like
29d7f433fcec ("net/mlx5e: Add Rx data path offload"), even if a backport
needs adjustment because mlx5e_psp_is_decap() is new in this series.

> +
> +	/* No match on security parameters change. */
> +	return pse->spi == mlx5e_psp_get_spi(cqe) &&
> +		pse->version == mlx5e_psp_get_version(cqe);
> +#else
> +	return true;
> +#endif
> +}
> +
>  static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
>  {
>  	u16 data_bcnt		= mpwrq_get_cqe_byte_cnt(cqe) - cqe->shampo.header_size;
> @@ -2266,8 +2293,9 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
>  	}
>  
>  	if (*skb &&
> -	    !(match && mlx5e_hw_gro_skb_has_enough_space(*skb, data_bcnt,
> -							 page_size))) {
> +	    !(match &&
> +	      mlx5e_hw_gro_skb_has_enough_space(*skb, data_bcnt, page_size) &&
> +	      mlx5e_hw_gro_psp_match(*skb, cqe))) {
>  		match = false;
>  		mlx5e_shampo_flush_skb(rq, cqe, match);
>  	}

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260908065244.3799142-1-tariqt%40nvidia.com
