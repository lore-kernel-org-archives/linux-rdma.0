Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795611616;
	b=otpmUVG/YTu7iSPnhvE9CjYJWtehNEQ9PGna/5WUyTlbiQ9H7MI5knRKvHt3XPoVgd7I
	 WtZDK5mYrecMAlvnld3L29X2YPyuddxAt5BEQTRdi7fgbGZq346LV7edaw13YXBf9dG1+
	 fS7vAiOaDGo9IVyghd5jU9iUjMT/xEioot50C1QmpQv8RbaN4KVZIF1xFLjpevLj+QQng
	 Ns4yODA2sPXL4JnwXWSc7nvWcSRmd/qStqCjL0ew0YqASa61/apY66rRy69pvA/cMCx4m
	 EBngDSzvucMcT9rxxKgbQg697a9rEuZjUpu/tj41SRZg76O+b+mq+ZFZL4twul1/jBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795611616;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/iuk8QgrVpCcJVCdhvjkWg58grJ7Swi9i8JMWBRo+Wo=;
	b=lRnLcLz9s2+54p9U3UJ8RpV8At1fZNLXPA1+B94S6DMk0dgMa9k8uCQkwGfWwkCliGev
	 CB66FG8bwDydFq8tSe+SY4ONtmvC/6gbl8HcsfjCX6JyRDWJ+YeT47zlymSVGImaMB7ix
	 Wr3B6bsibe00AIUHrW+5YOPCD3rMwOrbjSgJDGhJtwdqo13fCQ/n0C4/urlRYCL2c1PRK
	 bgA81VUKXdKLvRNV6gJGpX8ks0QG8DV/rbxAtiJ+FYvFIYewsarcOXpyqwMtKvo29HmGL
	 LbQMczb2epCJvZ6p8LosFRKNLEetULBxNB3sEIw7HyY3qPrst/HSkrySgyRtYEPG8qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eMjyqp8C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F272660A2600;
	Wed, 25 Nov 2026 13:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eMjyqp8C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543FF1F000CF;
	Wed, 25 Nov 2026 13:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795611615;
	bh=/iuk8QgrVpCcJVCdhvjkWg58grJ7Swi9i8JMWBRo+Wo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eMjyqp8C2BWmc5S+iH2IPp3iuhqS87whgPYvFF+wpd5vU17E7CclCObYbTEROUodk
	 m96oG9ngFTcoPWePCSRzUMFs28wzrWXxF6NWuOJgQRvn1wF/KH5vNzalkkPDNf8qf7
	 kFg1g5cjPeLrNgI3pr51Rn04s4yj4JFfnEaCj9hlWhiQOvnb0sy2zmaArLXV2P+h9c
	 uA2fDaeyhzMo6bUPBevYIovWpeoy1SECv7q0tX0QAGwnAtPtpTFDNKWptotlyewFgJ
	 0kzpquysNH7kDavTSDALabErpxlREqqQJSSfVxSDg7VYFXoobJe89jiXghryvfI1YN
	 YtgvYatOIAxWw==
Message-ID: <sashiko-outbox-233422@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 12/15] eth: mlx5e: Receive into XDP-only memory
 providers
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, bpf@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261124125654.183091-12-bjorn@kernel.org>
References: <20261124112707.118678-1-bjorn@kernel.org>
 <20261124125654.183091-12-bjorn@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 13:00:14 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] net/mlx5e: NAPI busy loop and refill rollback in
  mlx5e_post_rx_wqes()
- [High] net/mlx5e: deferred close in mlx5e_switch_priv_channels()
  starves XDP-only MP
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [Critical] net/mlx5e: missing bounds check in
  mlx5e_skb_from_cqe_linear() [1]
--

commit 6c6731701cc9a2c8380223f3b08de0cdf6d5c368
Author: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>

eth: mlx5e: Receive into XDP-only memory providers

This commit enables mlx5e receive queues with an attached XDP program to
use XDP-only memory providers and allows queue restarts while an XDP
program is attached.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en_main.c
> index 06a8a4be4be7c..a8d46508b6fc3 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -1012,6 +1012,9 @@ static int mlx5e_alloc_rq(struct mlx5e_params *para=
ms,
> =20
>  		pp_params.order     =3D pool_order;
>  		pp_params.flags     =3D PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
> +		/* Trap and PTP RQs use queue 0 too, without a program */
> +		if (params->xdp_prog)
> +			pp_params.flags |=3D PP_FLAG_ALLOW_XDP_ONLY_NETMEM;

[Severity: High]
Can a full channel switch via mlx5e_safe_switch_params() (such as on an
MTU or ring-size change) leave a queue backed by an XDP-only memory
provider with zero posted RX WQEs on devices with tis_tir_td_order?

When MLX5_CAP_GEN(priv->mdev, tis_tir_td_order) is set,
mlx5e_switch_priv_channels() only closes legacy XSK RQs before calling
mlx5e_activate_priv_channels(), deferring mlx5e_close_channels(old_chs)
until after the new channels have been activated:

drivers/net/ethernet/mellanox/mlx5/core/en_main.c:mlx5e_switch_priv_channel=
s() {
    ...
	if (!MLX5_CAP_GEN(priv->mdev, tis_tir_td_order))
		mlx5e_close_channels(old_chs);
	else
		mlx5e_close_channels_xsk(old_chs);
	priv->profile->update_rx(priv);

	mlx5e_selq_apply(&priv->selq);
out:
	mlx5e_activate_priv_channels(priv);
    ...
}

Because an XDP-only memory provider backs c->rq.page_pool rather than
c->xskrq, old_chs->c[i]->rq and its page_pool are still open when
mlx5e_activate_priv_channels() schedules the initial NAPI poll on the new
channel.  During that poll, sink->released is still empty, and any chunks
in sink->fq that previously cycled through the old page_pool still have
netmem_get_pp(netmem) =3D=3D old_pp, so xsk_sink_take_fill() returns them to
old_pp->ring instead of the new page_pool.  The new RQ fails to allocate
any buffers and NAPI completes with zero posted RX WQEs; when
mlx5e_close_channels(old_chs) finally destroys old_pp, nothing re-triggers
NAPI on the new channel, wedging RX on that queue.

> @@ -3050,6 +3053,14 @@ static int mlx5e_wait_channels_min_rx_wqes(struct =
mlx5e_channels *chs)
>  		if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
>  			continue;
> =20
> +		/* An RQ that an XDP-only provider backs fills from the FILL
> +		 * ring of its socket, which stays empty until the socket
> +		 * gets its chunks back, so a queue that restarts under a
> +		 * slow reader would never meet the bound.
> +		 */
> +		if (netif_rxq_has_xdp_only_mp(c->netdev, c->ix))
> +			continue;

[Severity: High]
On a cyclic RQ (MLX5_WQ_TYPE_CYCLIC), what happens when the XDP-only
provider's FILL ring is empty or has fewer entries than wqe_bulk?

Unlike mlx5e_post_rx_mpwqes(), which posts partial batches and only
returns busy =3D true when rq->xsk_pool is set, mlx5e_post_rx_wqes() calls
mlx5e_refill_rx_wqes(rq, head, wqe_bulk) for the entire missing ring size.
If the FILL ring cannot satisfy the full wqe_bulk at once,
mlx5e_refill_rx_wqes() frees all descriptors it just allocated and returns
0, and mlx5e_post_rx_wqes() unconditionally sets busy =3D true:

drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:mlx5e_post_rx_wqes() {
    ...
	count =3D mlx5e_refill_rx_wqes(rq, head, wqe_bulk);

	mlx5_wq_cyc_push_n(wq, count);
	if (unlikely(count !=3D wqe_bulk)) {
		rq->stats->buff_alloc_err++;
		busy =3D true;
	}
    ...
}

When busy is true, mlx5e_napi_poll() returns full budget without calling
napi_complete_done(), spinning NAPI in softirq with zero posted RX WQEs
instead of posting available descriptors and waiting for wakeup.

[ ... ]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_rx.c
> index 22fea4739a2c9..130e54f81293a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c

[ ... ]

> @@ -1585,7 +1585,7 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, stru=
ct mlx5e_wqe_frag_info *wi,
>  	dma_addr_t addr;
>  	u32 frag_size;
> =20
> -	va             =3D netmem_address(frag_page->netmem) + wi->offset;
> +	va             =3D xdp_netmem_address(frag_page->netmem) + wi->offset;
>  	data           =3D va + rx_headroom;
>  	frag_size      =3D MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt);

[Severity: Critical]
This problem wasn't introduced by this patch, but can an oversized
cqe_bcnt from a malfunctioning or compromised device [1] cause
mlx5e_skb_from_cqe_linear() to write skb_shared_info out of bounds?

Unlike mlx5e_skb_from_cqe_mpwrq_linear(), mlx5e_skb_from_cqe_linear() does
not check cqe_bcnt against rq->hw_mtu or the fragment stride before
computing frag_size =3D MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt) and passing
it to mlx5e_build_linear_skb() -> napi_build_skb(), which places
skb_shinfo() at the end of frag_size past the allocated buffer.

[1] https://sashiko.dev/#/bug/linux-f8009756-e155-49d4-89b6-f278e7d2f08e

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124112707.1186=
78-1-bjorn@kernel.org?part=3D12
