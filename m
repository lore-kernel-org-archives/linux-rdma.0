Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795615713;
	b=hwHJiqx80oBBTdZhC553fv4yZxMbTZK74RcXsxEjMds6DoMXATxvo6nDV2bxtc54/C+w
	 r5K5dpFt6mHRE6YPXkyDLEOZ5m1+jmyusaGrzuYKdsCCuPdxHXtnmYkWVrm6SOM7QdVIW
	 B8fV772/S6fQHYNCYuS8yqoHJ2aHLzrRmDZIKO1QFe8GC8il0+HY1AF7s669Q/iXxzzto
	 CqMOnpCWpfNXaya6+AGees7m3U1F3iFqp9zIifTqiKdhbQ/6myadSFj+RWTG6cE5SIIGO
	 Feof2oKhp/GWuCNS+3sQ13AvBi9wR04+QiRxFAatcI235DN4VsulYE3wq8W2HHVDGMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795615713;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=b09hhgWjhTUr1ufEegNZrG6hsijrw5UpXsQzYbBJZIk=;
	b=QAfK3jOqTuPg9ShEoHYgnthxPbuaBRZpH7qzplgg/KiWWEUGb79jVUCuJlsgVQ2Ff9Ow
	 M0V7LKsr1Wa+FB1JjtHG4kUgESNxtfyk9iyOtk6XK4x+7PsiCLsBRi6bo/RXujHHtoD4c
	 eh/9x/cEhKF1nTUUnvu99JCqSU3FG0/Nvz2C5+F3C+Lhz2iiKadguqoxmfmIwSMV3S0S4
	 mBvz+2/Ve197jaAGMb4j5zO+tjhw1jh72I2jJWYrjpB57fOvkAmoRKWS645rLPtOnhtZC
	 GPCDGKm7zKxiV3+vdDozehDlFm5Gd2e7kNlp8yWYUFJZHX99xkc2FAEwtroEuHMXC0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aAXFma8M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DFA606A689;
	Wed, 25 Nov 2026 14:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aAXFma8M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D06C1F000C6;
	Wed, 25 Nov 2026 14:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795615712;
	bh=b09hhgWjhTUr1ufEegNZrG6hsijrw5UpXsQzYbBJZIk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=aAXFma8Mu84w7CroG/zNy+2h2yIwb3Rxj3uTXEvqsUjTZ3V847fnYsi94ZhF7LFzE
	 B+EA+vkYMuoPCceSmsVHBviuSnK7pu9fPfwWioLfGa380gMa5ABKGF/4ZeSAqTuxsZ
	 6nZ0MsLGHEmv60x/O9U/ISc7+QWLUdHNG7Z/N5VXqa2rm4dHQF9hhkmlWfkJMURQ0+
	 /X2wMTgycnditRoM/2BBG8TcPNQu3GysCvyCOBVl0xudmfRmjdQEuApoxNdWRIm217
	 sYFVBRlaPGezXpWtQF5hAiYxKOBI7ASfWeTiwLw2M+PltCQv+u/cd0kkt0zv4Il1eX
	 qxbuU5MpRYCdA==
Subject:
 Re: [PATCH net-next 12/15] eth: mlx5e: Receive into XDP-only memory providers
From: netdev-bot+sashiko@kernel.org
To: bjorn@kernel.org
Cc: magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
 john.fastabend@gmail.com, andrii@kernel.org, eddyz87@gmail.com,
 memxor@gmail.com, ilias.apalodimas@linaro.org, alexanderduyck@fb.com,
 saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
 michael.chan@broadcom.com, pavan.chebbi@broadcom.com, corbet@lwn.net,
 shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
 stuclar@meta.com, sdf@fomichev.me, horms@kernel.org, martin.lau@linux.dev,
 almasrymina@google.com, song@kernel.org, yonghong.song@linux.dev,
 jolsa@kernel.org, emil@etsalapatis.com, ihor.solodrai@linux.dev,
 rdunlap@infradead.org, kernel-team@meta.com, dimitri.daskalakis1@gmail.com,
 bobbyeshleman@meta.com, mohsin.bashr@gmail.com, kees@kernel.org,
 leitao@debian.org, maxime.chevallier@bootlin.com, cuitao@kylinos.cn,
 vadim.fedorenko@linux.dev, mike.marciniszyn@gmail.com, kuniyu@google.com,
 jiayuan.chen@linux.dev, mkarsten@uwaterloo.ca, razor@blackwall.org,
 dw@davidwei.uk, asml.silence@gmail.com, linux-rdma@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2026 14:08:28 +0000
Message-ID: <179561570896.3135.8953893024403211017@kernel.org>
In-Reply-To: <20261124125654.183091-12-bjorn@kernel.org>
References: <20261124125654.183091-12-bjorn@kernel.org>
X-sashiko-severity: High
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

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 2 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] net/mlx5e: deferred close in mlx5e_switch_priv_channels()
  starves XDP-only MP
- [High] net/mlx5e: NAPI busy loop and refill rollback in
  mlx5e_post_rx_wqes()
- [Medium] The mlx5 patch lets the nonlinear striding RQ take an XDP-only
  (AF_XDP sink) provider, but the commit message only describes the…

--

eth: mlx5e: Receive into XDP-only memory providers

This patch lets the page pools of mlx5 RQs that run an XDP program take
XDP-only memory providers such as the AF_XDP sink. It also allows queue
restarts while a program is attached, and it skips the minimum posted
WQE wait for provider-backed RQs. Buffer addresses are now taken with
xdp_netmem_address() so XDP-only net_iovs are covered.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 06a8a4be4be7c..a8d46508b6fc3 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -1012,6 +1012,9 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
>  
>  		pp_params.order     = pool_order;
>  		pp_params.flags     = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
> +		/* Trap and PTP RQs use queue 0 too, without a program */
> +		if (params->xdp_prog)
> +			pp_params.flags |= PP_FLAG_ALLOW_XDP_ONLY_NETMEM;

[Severity: Medium]
How does this behave for the nonlinear striding RQ? The flag is also set
there, but the commit message only talks about the linear striding RQ:

    The RQ keeps its layout. A stride of the linear striding RQ still
    holds the shared info of the skb that XDP_PASS builds, ...

The nonlinear striding RQ is used with XDP when the program is frags
aware and the MTU is above the linear XDP limit. With a program attached,
mlx5e_skb_from_cqe_mpwrq_nonlinear() builds an empty head in the linear
page:

drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:mlx5e_skb_from_cqe_mpwrq_nonlinear() {
    ...
	if (prog) {
		...
		va = mlx5e_mpwqe_get_linear_page_frag(rq);
		...
		linear_hr = XDP_PACKET_HEADROOM;
		linear_data_len = 0;
    ...
}

mlx5e_mpwqe_linear_page_refill() allocates that linear page from
rq->page_pool. With this flag set, the page is a UMEM chunk taken from
the socket's FILL ring, and it is only ever used for empty heads.

mlx5e_fill_mxbuf() calls xdp_prepare_buff(..., true), so the program can
call bpf_xdp_adjust_meta() into that headroom. When an empty head
reaches the sink, xsk_sink_rcv() does this:

net/xdp/xsk_sink.c:xsk_sink_rcv() {
    ...
	if (!hlen) {
		/* An empty linear part, as mlx5 builds for nonlinear RQs */
		empty = niov;
		headroom = 0;
	} else {
    ...
	if (metalen > headroom)
		goto drop;
    ...
}

Won't every packet on this RQ type whose program wrote metadata (RX hash,
timestamp and so on) be dropped and counted in rx_dropped? The same
program works on the linear striding RQ and on the cyclic RQ.

That also seems to contradict the documentation added in this series,
which says bpf_xdp_adjust_meta() and the RX metadata kfuncs work as with
pages.

Should the commit message and docs describe the nonlinear striding RQ
case, both the dropped metadata and the UMEM chunks spent on empty heads?
Or should this mode be handled differently?

>  		pp_params.pool_size = pool_size;
>  		pp_params.nid       = node;
>  		pp_params.dev       = rq->pdev;

[ ... ]

> @@ -3050,6 +3053,14 @@ static int mlx5e_wait_channels_min_rx_wqes(struct mlx5e_channels *chs)
>  		if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
>  			continue;
>  
> +		/* An RQ that an XDP-only provider backs fills from the FILL
> +		 * ring of its socket, which stays empty until the socket
> +		 * gets its chunks back, so a queue that restarts under a
> +		 * slow reader would never meet the bound.
> +		 */
> +		if (netif_rxq_has_xdp_only_mp(c->netdev, c->ix))
> +			continue;
> +
>  		err |= mlx5e_wait_for_min_rx_wqes(&c->rq, timeout);
>  
>  		/* Don't wait on the XSK RQ, because the newer xdpsock sample

[Severity: High]
How does this behave on a cyclic RQ? The flag is set for both RQ
types, and mlx5e_skb_from_cqe_linear() and
mlx5e_skb_from_cqe_nonlinear() now take XDP-only net_iovs. A provider
can therefore back an RQ that runs with striding RQ disabled through
the priv flag, or on a device that lacks it.

There, rq->post_wqes is mlx5e_post_rx_wqes(), which asks
mlx5e_refill_rx_wqes() for the whole missing part of the ring as one
wqe_bulk. The FILL ring of the socket may hold fewer chunks than
that, which is the normal case at bind time and under a slow reader.
mlx5e_alloc_rx_wqes() then stops short, and mlx5e_refill_rx_wqes()
jumps to err_free. It frees everything it allocated with
mlx5e_free_rx_wqes() and returns 0.

mlx5e_post_rx_wqes() then sees count != wqe_bulk and sets busy
regardless of rq->xsk_pool. mlx5e_napi_poll() returns the full budget
without calling napi_complete_done(). NAPI keeps rescheduling itself
in softirq, posts nothing to the hardware, and never parks to wait
for the socket to wake it. If the UMEM has fewer chunks than the
ring, the bulk can never be satisfied and the CPU spins
indefinitely.

The striding path posts what it got and only reports busy when
rq->xsk_pool is set, so it idles until xsk_sink_wakeup(). Should the
cyclic path do the same for a provider-backed RQ, posting partial
bulks and not reporting busy? Or should
PP_FLAG_ALLOW_XDP_ONLY_NETMEM be limited to the striding RQ until it
does?

[Severity: High]
Can the new RQ end up with no posted WQEs at all when the channels
are switched while a provider is bound? Before this change, the wait
here would at least time out and queue rx_timeout_work. Now the RQ is
skipped silently.

On devices with tis_tir_td_order, mlx5e_switch_priv_channels() only
deactivates the old channels. mlx5e_close_channels_xsk() then closes
just the RQs that have MLX5E_CHANNEL_STATE_XSK set. The regular RQ of
old_chs and its page_pool stay open while
mlx5e_activate_priv_channels() activates the new channels and
mlx5e_trigger_napi_icosq() runs their first refill.
mlx5e_safe_switch_params() closes old_chs only after that.

The chunks that the old page_pool has taken from the provider keep it
as their owner. When the new RQ refills, sink->released is still
empty. A chunk from the FILL ring that the old pool owned is put back
into the old pool's ring rather than handed to the new one. The
allocation fails. mlx5e_post_rx_mpwqes() posts nothing and returns
false, since rq->xsk_pool is NULL, and NAPI completes.

When mlx5e_close_channels(old_chs) later destroys the old pool, its
chunks move to sink->released, but nothing schedules NAPI on the new
channel. No RX WQEs are posted and no UMR is in flight on the ICOSQ,
so no completion will arrive to wake it. The queue stops receiving.

This is reachable from MTU changes, ethtool ring and channel changes,
priv flag changes, and mlx5e_safe_reopen_channels() during recovery.
Should the RQ that a provider backs be closed before the new channels
are activated, as is already done for the XSK RQ? Or should NAPI on
the new channel be kicked once old_chs is closed?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261124112707.118678-1-bjorn%40kernel.org
