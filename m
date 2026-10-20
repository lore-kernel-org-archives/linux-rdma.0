Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792514840;
	b=11qoCKYhN6k3dQ2GNI5kdGUCClpJKCS1ZcpvgVGAVkE8vQNqwcQPsIIm4drFs9a0TqyA
	 hdwYq6lV6b2josCbRJKAk4320YEcqWE2sTI4u8KTm2WxdhVAAaDO5A+XwNN9G3qAGptiO
	 csSPjc3Jb+vYzbT5n2pKmhlWpweQtSLEMU73g+8GfwALvHYERjOIcvaJB6zAK+6+HP+Y3
	 Rotjy9xFL0w8lsGaTk9+7Pt/zhh5j/hC+t5jBW92un13/xt4RMj1+ivtaiPV0+BIWrqc0
	 OPEU2xY1XgwQfg/5/zWgtVzE7lnOGo0382Sxp8COCYUp/zy73a9gNp0+18YSf4JkEAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792514840;
	h=Received:Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 X-sashiko-severity:Content-Type:Content-Transfer-Encoding:
	 MIME-Version;
	bh=n+oKGk1imSqXHlpcQPQgdWOn1hEEDsQt0rvGO+83lJA=;
	b=cpIvgSnAr9j+m5VKsxaoJa57KaLp664NTBch3waYNG7GVJo+3mUhG6KgE1sbc/8Y3Drj
	 Eparvv9/5URO1zSiwJDss3dGLEfcebQ9Kfr368cuLXH6lcdybR1EffRHv6P6XyyuoLH6E
	 smL4pg/0N+z1BxGydZ7Zfj/FaLawpEwDAIf4SsMqRMf0fsyV8i0VTqI4oO84Z66Lvr1ln
	 eYJBQmmjEUouARuu0eXvvQOkBOn2W1bAhLx30BY5QgW6yITD5VjgKjjgbAd+KPoxAJ3oW
	 WMIzp0MywUXegTsSwigwpc15acoLYQLA0V6XkCzBdJOEPYScjXiGpzfqKm9OOK6Rr4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B00E606A325;
	Tue, 20 Oct 2026 16:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552A91F000CB;
	Tue, 20 Oct 2026 16:47:18 +0000 (UTC)
Subject: Re: [PATCH net-next v7 03/13] net: mana: keep per-queue statistics in
 the port context
From: netdev-bot+sashiko@kernel.org
To: weh@linux.microsoft.com
Cc: longli@kernel.org, kotaranov@microsoft.com, kuba@kernel.org,
 davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 andrew+netdev@lunn.ch, jgg@ziepe.ca, leon@kernel.org, haiyangz@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, shradhagupta@linux.microsoft.com,
 horms@kernel.org, ernis@linux.microsoft.com, stephen@networkplumber.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, sdf@fomichev.me, daniel@iogearbox.net, hawk@kernel.org,
 ast@kernel.org, john.fastabend@gmail.com, weh@microsoft.com,
 edumazet@kernel.org
Date: Tue, 20 Oct 2026 16:46:47 +0000
Message-ID: <179251480798.3135.10568539204327471791@kernel.org>
In-Reply-To: =?utf-8?q?=3Cb27034466c0db8228409db5473e747db7c3177c5=2E1791710?=
 =?utf-8?q?735=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
References: =?utf-8?q?=3Cb27034466c0db8228409db5473e747db7c3177c5=2E17917107?=
 =?utf-8?q?35=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1 (1)

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] mana_get_stats64()
  (drivers/net/ethernet/microsoft/mana/mana_en.c:608) bounds its RX/TX…
- [Low] Commit message / metadata concern for commit "net: mana: keep
  per-queue statistics in the port context".

Pre-existing issues:
- [Low] This problem wasn't introduced by this patch, but mana_xdp_xmit()
  (drivers/net/ethernet/microsoft/mana/mana_bpf.c:74) updates…

--

net: mana: keep per-queue statistics in the port context

This commit moves the per-queue RX/TX statistics out of the mana_rxq and
mana_txq objects and into port-lifetime arrays sized by max_queues. The
arrays are allocated at probe and freed after the netdev is unregistered.
ndo_get_stats64 and the ethtool stats now read from these arrays and keep
reporting while the port is down.

> Prepare port-lifetime RX/TX statistics before introducing live queue
> replacement. Allocate max_queues slots before netdev registration,

[ ... ]

> Make ndo_get_stats64 and ethtool statistics independent of replaceable
> queue objects. Preserve counters while down, gating only the PHY
> query.

[Severity: Low]
The message presents this as preparation for live queue replacement. Does
it also change behaviour that users can already see today?

Before this patch the RX/TX counters lived in mana_rxq and mana_txq. Those
are freed and reallocated on every mana_detach()/mana_attach(): ifdown/ifup,
MTU change, ethtool -L/-G, XDP install/remove, TX timeout reset and
suspend/resume. So the counters were reset each time. mana_get_stats64()
also returned early when !port_is_up.

After this patch the counters persist across all of those paths, and
mana_get_stats64() sums over max_queues instead of num_queues.

"Preserve counters while down" does hint at this. Could the message state
the change for the existing paths more explicitly?

Documentation/networking/statistics.rst asks for statistics to persist
across down/up. Would it make sense to split that part out as a separate
fix with a Fixes: tag?

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
> index ec708f3401a05..2008c17416543 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
> @@ -68,7 +68,7 @@ int mana_xdp_xmit(struct net_device *ndev, int n, struct xdp_frame **frames,
>  		count++;
>  	}
>  
> -	tx_stats = &apc->tx_qp[q_idx]->txq.stats;
> +	tx_stats = apc->tx_qp[q_idx]->txq.stats;
>  
>  	u64_stats_update_begin(&tx_stats->syncp);
>  	tx_stats->xdp_xmit += count;

[Severity: Low]
This isn't a bug introduced by this patch, but can two CPUs update the
same xdp_xmit counter at the same time here?

mana_xdp_xmit() picks the slot with:

	q_idx = smp_processor_id() % ndev->real_num_tx_queues;

mana_xdp_tx() holds the TX queue lock only around mana_start_xmit():

	__netif_tx_lock(ndevtxq, smp_processor_id());
	rc = mana_start_xmit(skb, ndev);
	__netif_tx_unlock(ndevtxq);

So the xdp_xmit update after the loop runs without that lock.

Devmap bulk queues are per-CPU (bq_enqueue() in kernel/bpf/devmap.c). With
more CPUs than TX queues, two CPUs can flush to the same q_idx and run the
+= on the same counter concurrently. Doesn't that break the u64_stats rule
that writers of a given syncp must be mutually exclusive?

MANA depends on X86_64 || ARM64, so the seqcount compiles away and the only
effect is lost xdp_xmit counts. The baseline code has the same pattern,
and it is still there at the end of the series.

[ ... ]

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 4b2c8039b8fa3..744d5ebe8dbbb 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c

[ ... ]

> @@ -597,15 +597,15 @@ static void mana_get_stats64(struct net_device *ndev,
>  			     struct rtnl_link_stats64 *st)
>  {
>  	struct mana_port_context *apc = netdev_priv(ndev);
> -	unsigned int num_queues = apc->num_queues;
>  	struct mana_stats_rx *rx_stats;
>  	struct mana_stats_tx *tx_stats;
> +	unsigned int num_queues;
>  	unsigned int start;
>  	u64 packets, bytes;
>  	int q;
>  
> -	if (!apc->port_is_up)
> -		return;
> +	/* Report even while down; dev_get_stats() zeroes its output. */
> +	num_queues = apc->max_queues;

[Severity: Medium]
Is apc->max_queues stable enough to use as the bound here?

mana_alloc_queue_stats() sizes rxq_stats, rxq_stats_ret and txq_stats from
apc->max_queues at probe time, and that capacity is not stored anywhere
else.

mana_init_port() runs again on every mana_attach(), including the resume
path in mana_probe(), and it can lower max_queues:

	max_queues = min_t(u32, max_txq, max_rxq);
	if (apc->max_queues > max_queues)
		apc->max_queues = max_queues;
	if (apc->max_queues > gc->max_num_queues_vport)
		apc->max_queues = gc->max_num_queues_vport;

On resume, mana_gd_query_max_resources() recomputes the limits from:

	gc->max_num_queues = num_online_cpus();

So fewer online CPUs, or a smaller vPort max_txq/max_rxq, can shrink
max_queues, for example from 16 to 8. Slots 8..15 still hold accumulated
counts, but this loop stops summing them. The rtnl_link_stats64 RX/TX
totals would then go backwards, against the persistence rule in
Documentation/networking/statistics.rst.

Indexing stays in bounds because max_queues only shrinks after probe.

Would it be better to record the allocated slot count separately, or to
fold the excluded slots into a lifetime aggregate?

There is a related effect. mana_get_ethtool_stats(), along with the
sset_count and strings callbacks, still iterates over apc->num_queues.
After ethtool -L reduces the channel count, the ip -s link totals include
slots in [num_queues, max_queues) that ethtool -S never shows. The
per-queue values then no longer add up to the totals. Is that intended?

This code is still the same at the end of the series.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1791710735.git.weh%40linux.microsoft.com
