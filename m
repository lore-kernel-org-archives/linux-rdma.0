Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794837300;
	b=aZTj0FSwdKIu7maeSK74Y716q1PUAAbHV0e06B04ljE0/a0oiL0B8FUCC74951auV2lE
	 8mA7s7jlAwbqhJKiLGJP4sZn+SzfoNdyD7zEJD0N6P/OFMlzKelwBR6tYyRS6dGiDmT1m
	 dQTYRMIKZVrGSgbpdcyUOI/XtryUm4LIFcIHQMS3g6zzi27kOvpIT4P8hm4KcfYiSXN7f
	 TqdqIRVOuOO6dQZAsaeD0o3hrbFB45Qrv//PViLU+XgeD6bz5kb7fcOGS/vcMYBFDhRpe
	 ggknCtYsMOKLA+O6HQBCr+hewngM+XETNB5nMB6hmKLaCxiuEk1rMXEvP3xlcjqrOYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794837300;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=QFu8Ujh/cTsZqGkdnK/upGMSOxvB/uMyMwCper4UbWY=;
	b=wy4e+DpbAjZ2RLPJhNnBOdpAVP6+YTxZgnoqJD8bHUNynMCUHqewdZhsw3nyoq08oFAM
	 T6eqhjySHUeBEQOGXTmeqVW0Cs6WG+iujwCmBq+yhD4GyAXZPnursxGX7/A2iqFAmQgDB
	 VS3OfNXcp7ZJXHrQVJ3jHJXCrlp7CLXplqFyncD/zCiCsdX3lb+VFHA5q+btWeYvATq3y
	 gUB0JZAEkVZuCBeuxDs4UY6w9kiehTQeq5eguAn5p48a5I0SF008vvYDA4huS752M71dX
	 Aq2BvMHPBNHwEvqbq2JnkTGxoDpDBFDXnWHxQHkXLh7viOurmUlJQsBUn2D4PGScnSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SWuapJb4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9B8606A891;
	Mon, 16 Nov 2026 13:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SWuapJb4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD48C1F000C8;
	Mon, 16 Nov 2026 13:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794837299;
	bh=QFu8Ujh/cTsZqGkdnK/upGMSOxvB/uMyMwCper4UbWY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=SWuapJb4vNuXxhh/NLQozt2oDDvs3tqsSKfMebV+h+jeE7bZGbp5AleKIDT22A0Gh
	 3mlwofPCt9me3uUwtyzjuVt7q0yaXZ8p7xP7UXJkC8BcFR3FbTRPRD49VuPUGL78t5
	 5s12WunQc0FGYhSHiCVRSzmLoZg1dftER9Tn9Yqw8l7TXK5yMOUZXuc3FGTBaRLlDD
	 jHNU9sr7NPp0GsCPcF2+CHqmBfeQQa2Hsq+6APIjJklRaXh3Ow5DVjBU6m2LvD8F44
	 2HhtknTGX9zw89wbfxivNzHkiEgVWhRX8us2k7sEB6YT50y5zqPPW7nPWOlY9+Za4v
	 /w16MquByzcaw==
Subject: Re: [PATCH net-next] net: mana: Add CQE polling as first-level TX
 timeout recovery
From: netdev-bot+sashiko@kernel.org
To: sahilchandna@linux.microsoft.com
Cc: haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, weh@microsoft.com,
 kotaranov@microsoft.com, horms@kernel.org, ernis@linux.microsoft.com,
 gargaditya@linux.microsoft.com, leitao@debian.org,
 linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Date: Mon, 16 Nov 2026 13:54:58 +0000
Message-ID: <179483729831.3136.3233216496914201382@kernel.org>
In-Reply-To: <20261112105752.978446-1-sahilchandna@linux.microsoft.com>
References: <20261112105752.978446-1-sahilchandna@linux.microsoft.com>
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

Thank you for your contribution! Sashiko AI review found 4 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 3

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] Level 1 of the new recovery only calls napi_schedule() on the
  TX CQ that stalled, in mana_tx_timeout()…
- [Low] The commit message says the patch makes TX timeout recovery
  'three-tiered' and lists 'Level 3: device reset(FLR)' as the step…
- [Low] apc->last_tx_timeout is cleared in only one place: the post-
  attach tail of mana_per_port_queue_reset_work_handler()…
- [Low] The new comment in mana_tx_timeout() (mana_en.c:990-996) says
  escalation happens because 'the earlier CQE poll did not help and…

--

net: mana: Add CQE polling as first-level TX timeout recovery

This commit changes mana_tx_timeout() so that the first TX timeout, or
one arriving more than 2 minutes after the previous one, schedules NAPI on
the stalled queue's TX CQ instead of resetting the port. A further timeout
on any queue within 2 minutes escalates to the existing per-port
detach/attach reset, and a new tx_cqe_poll_recovery ethtool counter tracks
the CQE poll attempts.

> This makes the TX timeout recovery three-tiered:
>
>   Level 1: CQE poll via napi_schedule() (this patch)
>   Level 2: Port queue reset (detach/attach)
>   Level 3: device reset(FLR)

[Severity: Low]
Is the Level 3 step accurate for the TX timeout path? When
mana_pre_alloc_rxbufs(), mana_detach() or mana_attach() fails in
mana_per_port_queue_reset_work_handler(), the handler only logs:

	err = mana_attach(ndev);
	if (err)
		netdev_err(ndev, "mana_attach failed: %d\n", err);

It doesn't call mana_schedule_serv_work() or set GC_IN_SERVICE. In
mana_en.c, mana_schedule_serv_work() is only called from
mana_gf_stats_work_handler() on an HWC timeout. gdma_main.c calls it for
hardware service EQEs.

So when a port reset fails or doesn't help, the next timeout triggers
another port reset, or after 2 minutes goes back to Level 1. It never
reaches an FLR.

Could the commit message describe the FLR as a separate existing
mechanism, rather than as the third tier of this escalation?

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index e6d494df22e4d..0d8c8b8fbc83f 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -336,6 +336,9 @@ static void mana_per_port_queue_reset_work_handler(struct work_struct *work)
>  	if (err)
>  		netdev_err(ndev, "mana_attach failed: %d\n", err);
>  
> +	/* Let the next TX timeout try a CQE poll recovery first */
> +	WRITE_ONCE(apc->last_tx_timeout, 0);
> +

[Severity: Low]
Is this the only place last_tx_timeout gets cleared? The other paths
that tear down and rebuild the TX queues don't touch it. These include
mana_close()/mana_open(), the other mana_detach()/mana_attach() callers
(channel, MTU and XDP changes), and the service/FLR resume through
mana_probe().

Suppose a Level 1 CQE poll ran at T0 and one of those paths then rebuilt
the queues. A TX timeout on the new queues before
T0 + MANA_TX_TIMEOUT_RESET_THRESHOLD still sees a recent, non-zero last
in mana_tx_timeout():

	if (last &&
	    time_after(last, jiffies - MANA_TX_TIMEOUT_RESET_THRESHOLD)) {
		queue_work(ac->per_port_queue_reset_wq, &apc->queue_reset_work);
		return;
	}

It would then go straight to a port reset, without a CQE poll on queues
that were never polled.

Should the timestamp also be cleared when queues are rebuilt outside this
worker, for example in mana_open() or mana_attach()?

>  dealloc_pre_rxbufs:
>  	mana_pre_dealloc_rxbufs(apc);
>  clear_flag:

[ ... ]

> @@ -980,11 +984,30 @@ static void mana_tx_timeout(struct net_device *netdev, unsigned int txqueue)
>  	if (test_bit(GC_IN_SERVICE, &gc->flags))
>  		return;
>  
> -	/* Note: If there are pending queue reset work for this port(apc),
> -	 * subsequent request queued up from here are ignored. This is because
> -	 * we are using the same work instance per port(apc).
> +	if (!apc->port_is_up)
> +		return;
> +
> +	/* If the previous timeout fired less than
> +	 * MANA_TX_TIMEOUT_RESET_THRESHOLD ago, the earlier CQE poll did not
> +	 * help and queue stalled again	: escalate to a port reset.

[Severity: Low]
This isn't a bug, but there's a stray tab between "again" and the colon.

The comment also suggests the same queue stalled again. However,
last_tx_timeout is a single per-port field in struct mana_port_context,
so a timeout on any queue within the threshold escalates. That includes
a queue that never had a CQE poll.

For example, queue A might be polled, and queue B might time out about
15 seconds later (watchdog_timeo). B then goes straight to a port reset.

Could the comment say that a timeout on any queue of the port escalates?

> +	 * Note: If there is pending queue reset work for this port (apc),
> +	 * subsequent requests queued up from here are ignored, because the
> +	 * same work instance is used per port (apc).
>  	 */
> -	queue_work(ac->per_port_queue_reset_wq, &apc->queue_reset_work);
> +	if (last &&
> +	    time_after(last, jiffies - MANA_TX_TIMEOUT_RESET_THRESHOLD)) {
> +		queue_work(ac->per_port_queue_reset_wq, &apc->queue_reset_work);
> +		return;
> +	}
> +
> +	/* First timeout, or the previous one was long ago: try to recover by
> +	 * polling the TX CQ for completions before escalating to a reset.
> +	 */
> +	if (txqueue < apc->num_queues && apc->tx_qp && apc->tx_qp[txqueue]) {
> +		WRITE_ONCE(apc->last_tx_timeout, jiffies);
> +		apc->eth_stats.tx_cqe_poll_recovery++;
> +		napi_schedule(&apc->tx_qp[txqueue]->tx_cq.napi);

[Severity: Medium]
Does this recover the case where the MSI-X interrupt for the queue's EQ
was lost? This only schedules NAPI on the TX CQ, and the NAPI path
re-arms only the CQ in mana_cq_handler():

	if (w < cq->budget) {
		mana_gd_ring_cq(gdma_queue, SET_ARM_BIT);

The only EQ re-arm is at the end of mana_gd_process_eq_events(), which
runs from the EQ interrupt:

	mana_gd_ring_doorbell(gc, eq->gdma_dev->doorbell, eq->type, eq->id,
			      head, SET_ARM_BIT, 0);

The TX CQ and the RX CQ of queue i share the same parent EQ:

mana_create_txq():
		spec.cq.parent_eq = apc->eqs[i].eq;

mana_create_rxq() (called with &apc->eqs[i]):
	spec.cq.parent_eq = eq->eq;

Suppose the EQ interrupt was lost and the EQ stays un-armed. TX would
make progress briefly. New TX CQEs would then post EQEs into an un-armed
EQ, no interrupt would fire, and TX would stall again. This path never
polls the RX CQ on the same EQ, so RX on queue i would stay stalled.

Before this patch, the first watchdog firing did a detach/attach, which
rebuilt and re-armed the EQ. Now escalation only happens if the next TX
timeout arrives within 2 minutes.

With light TX load on that queue, timeouts could be more than 2 minutes
apart. Each one would then be handled as another Level 1 poll, and RX on
queue i might never recover.

The driver code doesn't show the exact hardware semantics of the GDMA EQ
arm bit, so this depends on whether an interrupt consumes the arm state.

Does the commit message claim of "recovering missed-interrupt scenarios
without queue reset" apply only to CQ-level misses? Or should Level 1
also handle the EQ and the RX CQ that shares it?

> +	}
>  }
>  
>  static int mana_shaper_set(struct net_shaper_binding *binding,

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261112105752.978446-1-sahilchandna%40linux.microsoft.com
