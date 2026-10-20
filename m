Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792514872;
	b=HSQLtX4lmDuf6esyHkW4fK8Hd1S2c3ad6IRyA8dUe+2Yx6u7kr5EQ1chEyexetK+vTPS
	 wKoqa5Xj/gomgyECRr0iSI+QGFPkCi3HpVgTdI8J3in/7vqd333WofRgJb9ja/8X1hp4n
	 Z5o1QGGs3T1arp0O18VSPS6FDB7VJC5WCxVOrOBvB/ZRFFF287krNtXEMQyL0QTmxxkl+
	 ThzoHXXzLgHPtla505RFmiDiOp1WZcssfgHR94m9DGeygg+oSETX+ZpFBooyTvvb3Vi4E
	 DP3W5CG0gTsJtXC+3PVAto+l4zUCXQ0CDvdYDJvbtxd5nD4fgkjByPasIqDPWX8n8/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792514872;
	h=Received:Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 X-sashiko-severity:Content-Type:Content-Transfer-Encoding:
	 MIME-Version;
	bh=IO+RdfSgg+iO9BLu43VpKXaQsv4LWOE8tdPSlKLB4S8=;
	b=Nt+xhZ/DRGVAfLz+8Pu9LjifyP3qQN2FnbKMbyfaZDh2yuZ5ZWbuJUfgHbQXLeTyTmn7
	 aeUkSB1wfncPWdRxCOvbiRVkReKpgCT30TmeK6rC8LMqV0/WufSgKp2WVtyNrLNpQJvuQ
	 cNhPEA2ZpGOyaYJVSApvZ7UghwToxQCLvROd437ciUpv0RgpPXzuPlbPh89g27ZW7wHFR
	 v8BIvPw8IN0JKec4fOcBVKXqacvPIe7wG1lekk5WgXoJvEM6WfRIFOWU1UiBGOpVCRLeI
	 ADjebK8O0n4yusFPPrv3jINVw30RFfz/qgy+IP2lD92P4ZR8dBUQE121z+FThPXmJqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8795606D54D;
	Tue, 20 Oct 2026 16:47:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF5F1F000CB;
	Tue, 20 Oct 2026 16:47:50 +0000 (UTC)
Subject:
 Re: [PATCH net-next v7 04/13] net: mana: swap queue sets in mana_set_channels
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
Date: Tue, 20 Oct 2026 16:47:19 +0000
Message-ID: <179251483988.3135.18174536583131851095@kernel.org>
In-Reply-To: =?utf-8?q?=3Cec57f3853ef344a7d5ec8907ba530313b0163bae=2E1791710?=
 =?utf-8?q?735=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
References: =?utf-8?q?=3Cec57f3853ef344a7d5ec8907ba530313b0163bae=2E17917107?=
 =?utf-8?q?35=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
X-sashiko-severity: Low
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

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] Old RX queues are marked retiring before the TX drain wait, while
  RSS still sends all RX traffic to them.

Pre-existing issues:
- [Low] Concern: the live replacement path throws away a user-configured
  RSS indirection table without calling ethtool_rxfh_indir_lost().
- [Low] Concern: the 120 s TX drain in mana_publish_qset(), with all
  queues stopped and carrier on, lets dev_watchdog (watchdog_timeo =…

--

net: mana: swap queue sets in mana_set_channels

This commit changes mana_set_channels() to build a replacement queue set
first, quiesce TX, drain the old TX queues for up to 120 seconds and then
publish the new set, with a rollback path, instead of doing a
detach/attach cycle. It adds per-RXQ drain_stats and a retiring flag, so
that retiring RX queues stop writing the shared per-index counters; the
private counters are folded into rxq_stats_ret[] later. It also gates
mana_select_queue() on port_is_up and keeps carrier off after a failed
rollback.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 744d5ebe8dbbb..c80a06ffbe508 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c

[ ... ]

> @@ -4053,9 +4155,305 @@ int mana_alloc_qset(struct mana_port_context *apc,

[ ... ]

> +int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
> +		      struct mana_qset *out_old)
> +{
> +	struct net_device *ndev = apc->ndev;
> +	int err;
> +
> +	ASSERT_RTNL();

[ ... ]

> +	netif_tx_disable(ndev);
> +
> +	mana_qset_snapshot(apc, out_old);
> +
> +	/* Mark before the grace period so old completions cannot wake the
> +	 * replacement's stopped queue.
> +	 */
> +	mana_qset_set_retiring(out_old, newq, true);

[Severity: Low]
Can this freeze the visible RX counters for the whole TX drain wait?

This call sets rxq->retiring on the old RX queues before synchronize_net()
and mana_wait_qset_txqs(), and that wait can last up to 120 seconds. RSS
still sends all RX traffic to these old queues during the wait.

Once retiring is set, mana_rxq_stats() picks the private counters:

    return READ_ONCE(rxq->retiring) ? &rxq->drain_stats : rxq->stats;

>From then on, updates from mana_rx_skb(), mana_run_xdp() and
mana_process_rx_cqe() go into rxq->drain_stats. mana_get_stats64() and the
ethtool stats code read only rxq_stats[] and rxq_stats_ret[]. The counters
users see therefore stop moving until mana_fold_qset_rx_stats() or
mana_destroy_rxq() folds them in later.

mana_update_rx_dim() also returns early for retiring RX queues, so adaptive
RX moderation stops for the same window.

The window is usually a few milliseconds, but it reaches 120 seconds on the
drain timeout path. The same pattern stays in place for full rebuilds and
for the retiring tail in channel reductions later in the series.

The early marking only seems needed for the TX wakeup race. Could the RX
retiring flag be set later, just before mana_config_rss() steers traffic to
the replacement queues, while the TX retiring flag stays where it is?

> +
> +	/* Drain TX/XDP readers past the gate and polls missing retiring. */
> +	synchronize_net();
> +
> +	err = mana_wait_qset_txqs(apc);
> +	if (err)
> +		goto resume_old;

[Severity: Low]
This isn't a bug introduced by this patch, but while mana_wait_qset_txqs()
waits up to 120 seconds with every TX queue stopped and carrier still on,
dev_watchdog (watchdog_timeo is 15*HZ) can call mana_tx_timeout(). That
queues queue_reset_work, which then runs after mana_publish_qset() returns.

The baseline path had the same window. mana_detach() called
netif_tx_disable(), and mana_dealloc_queues() then waited up to 120 seconds
under RTNL with carrier on.

On the drain timeout path here, the reset only runs after newq has been
freed, so it does not invalidate the replacement queues. In effect it is
the existing recovery for TX queues that really are stuck.

Is that interaction intended for the new publish path?

[ ... ]

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> index 43c5c3bf5c408..913349edfe13c 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c

[ ... ]

> +	err = mana_alloc_qset(apc, scratch, new_count, apc->rx_queue_size,
> +			      apc->tx_queue_size, apc->priv_flags, &newq);
> +	if (err)
> +		goto free_scratch;

[Severity: Low]
This is a pre-existing issue, not one introduced by this patch.
mana_alloc_qset() always resets the replacement set's indirection table
with mana_rss_table_init(scratch). A live set_channels therefore discards
a user-configured RSS indirection table without calling
ethtool_rxfh_indir_lost().

The baseline mana_alloc_queues() did the same on every detach/attach.

A later patch in the series fixes this ("net: mana: keep a user-configured
RSS table across a queue rebuild"). It adds mana_rss_table_keep() to the
split, grow and full-rebuild allocators and calls ethtool_rxfh_indir_lost()
after a successful publish.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1791710735.git.weh%40linux.microsoft.com
