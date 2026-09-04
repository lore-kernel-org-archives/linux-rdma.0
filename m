Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A9E40B0F3;
	Fri,  4 Sep 2026 04:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788497222; cv=none; b=SuRNx9ro8aPLSFjczwpVyH2yvN/YBejubWhge0qPps9877SDKcrqiaZaJx0Dredcf1ZqVka9qeKx/nDZAopaNZUvtA8XfpAFuMQd1dKepsKiSBfgQcM0NZK3elBhFDVo/C7L3ATUTkA1znO4w1UtZWWvkOtx3DJn45x5R7RSpV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788497222; c=relaxed/simple;
	bh=BHx2hCZL4elRaUXLkrffoY1DIyhf89MCUcEwMX6Or4g=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PWvZ7NbBpbL9oLEyNx/JZ7/obq8+Flg1QmLH0/OmDj4e1ITtHgfjZjKqwpLuK2g+KBeqfaYP72UQkyiwLke2r4gFdw3loPRJAA9RPIN07alW3wDILuiW77VgKh8fU9Qxx4FoV6u30Z9jGZaoniE5q5DUOwk/+8+eoVC+M6S0zOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I+zg8eKF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I+zg8eKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1001F00A3F;
	Fri,  4 Sep 2026 04:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788497213;
	bh=jkLiJs8V9+9fRKNYjIp1LhRreBKokkDmOeq1xxXbCR8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=I+zg8eKFayLa6X7sfyx65+fgyXTJPHdFrSDxt5RA9yBwcLYLgjnAgMkMZgpKjl6HO
	 +ZDo1ufHrk4PuD8zqWXM3aqGu42WLQxZziLYLEs8NlhnIetRQAoANhUJx+ncGdAnvl
	 YBIDqHX+yzyZ07FJgcoKUl9m1bOOYMCv23MVXbYyS20SzN42ogvUflwhxF1V//VdHe
	 Q3LPjhOqUoTlmh78FGSPNqwPqk5g9cdvLXRtBTKAGxkbH2uNtidBDs6WsTLu4Y8eC8
	 ymGjQYQ7ie92F75zojiXRaC3qT8Q6drxTRWpQTYmcWPiWxoqfCBEC2L66p/NcJztda
	 VdOGvge+84w5A==
Subject: Re: [PATCH net-next v3 09/13] net: mana: keep per-queue statistics in
 the port context
From: netdev-bot+sashiko@kernel.org
To: longli@microsoft.com
Cc: kotaranov@microsoft.com, kuba@kernel.org, davem@davemloft.net,
 pabeni@redhat.com, edumazet@google.com, andrew+netdev@lunn.ch, jgg@ziepe.ca,
 leon@kernel.org, haiyangz@microsoft.com, kys@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, shradhagupta@linux.microsoft.com,
 horms@kernel.org, ernis@linux.microsoft.com, stephen@networkplumber.org,
 shirazsaleem@microsoft.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Fri, 04 Sep 2026 04:46:51 +0000
Message-ID: <178849721196.4131868.9700658737002631939@kernel.org>
In-Reply-To: <20260901014442.2945689-10-longli@microsoft.com>
References: <20260901014442.2945689-10-longli@microsoft.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 1 · Low: 2

- [Medium] mana_get_stats64() keeps the `if (!apc->port_is_up) return;`
  early return above the new port-lifetime accumulation, so the counters…
- [Low] mana_update_rx_dim() now feeds net_dim() from
  rxq->stats->packets/bytes, which after this patch is…
- [Low] The writer invariant documented for the new statistics arrays is
  contradicted by the code added in the same patch.

--

net: mana: keep per-queue statistics in the port context

This moves the per-queue RX/TX statistics out of struct mana_rxq and
struct mana_txq into arrays owned by the port context, sized to
max_queues and allocated at probe time.  A retiring RX queue counts into
a private drain_stats which is folded into a per-index "retired" array,
and ndo_get_stats64() adds the live and retired slots for every index.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 5c5d1edd20f84..69e34fab8fe8e 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c

[ ... ]

> @@ -639,9 +639,9 @@ static void mana_get_stats64(struct net_device *ndev,
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
> @@ -649,6 +649,12 @@ static void mana_get_stats64(struct net_device *ndev,
>  	if (!apc->port_is_up)
>  		return;
>  
> +	/* Walk every slot, not just the queues currently open: counters
> +	 * accumulated on queues that a later reconfiguration removed must
> +	 * still be reported, or the interface totals would go backwards.
> +	 */
> +	num_queues = apc->max_queues;
> +

[Severity: Medium]
Does the retained port_is_up gate above this still let rx_bytes be
observed going backwards through the very operation the commit message
describes?

mana_publish_qset() clears the flag on entry and only sets it again at the
very end:

	WRITE_ONCE(apc->port_is_up, false);
	...
	netif_tx_disable(ndev);
	mana_qset_set_retiring(out_old, newq, true);
	synchronize_net();
	...
	netif_set_real_num_tx_queues() / netif_set_real_num_rx_queues()
	mana_chn_setxdp()
	mana_config_rss()
	...
	WRITE_ONCE(apc->port_is_up, true);

so the flag is false across the whole ethtool channel/ring/priv-flag, MTU
and XDP-attach window, and stays false indefinitely on the
mana_publish_give_up() dead ends.

Readers are not serialized against it.  netstat_show() (sysfs
statistics/rx_bytes) and dev_seq_show() (/proc/net/dev) reach
dev_get_stats() under rcu_read_lock() only, never RTNL, and dev_get_stats()
zeroes the storage before calling the driver:

net/core/dev.c:dev_get_stats() {
	...
	if (ops->ndo_get_stats64) {
		memset(storage, 0, sizeof(*storage));
		ops->ndo_get_stats64(dev, storage);
	...
}

Returning early therefore publishes zeros rather than the previous values,
so a reader polling during "ethtool -L" would still see
4475831638 -> 0 -> N.

Since the arrays are now port-owned and valid whether or not a queue
exists at that index, could they be reported unconditionally?
mana_get_ethtool_stats() carries the same "if (!apc->port_is_up) return;"
gate, which also makes the newly persistent per-queue counters unreadable
while the port is administratively down.

[ ... ]

> @@ -1092,6 +1112,122 @@ static void mana_cleanup_port_context(struct mana_port_context *apc)
>  	apc->rxqs = NULL;
>  }
>  
> +/* Counters belong to the port, not the queues, so a queue-set replacement
> + * does not reset them. Sized to max_queues, allocated once.
> + *
> + * A swap adds no writer to a TX slot. RX slots do overlap briefly, since a
> + * retiring rxq keeps its NAPI until mana_free_qset() destroys it. MANA is
> + * 64-bit only, so u64_stats_sync has no seqcount and at worst a few
> + * increments are lost; the alternatives are a lock in the receive path or
> + * per-set slots that make ndo_get_stats64() dip during a swap.
> + */
> +static int mana_alloc_queue_stats(struct mana_port_context *apc)

[Severity: Low]
This isn't a bug, but does this comment contradict the one added to struct
mana_port_context in the same patch?

Here the RX live slots are described as having overlapping writers:

	"RX slots do overlap briefly, since a retiring rxq keeps its NAPI
	 until mana_free_qset() destroys it ... at worst a few increments
	 are lost"

while the header says:

	"rxq_stats[] is written by the live RX queue at that index and
	 rxq_stats_ret[] only under RTNL, by mana_destroy_rxq() folding in
	 what a retiring queue counted while it drained. One writer each;
	 readers add the two."

The header is the text a later auditor is likely to consult when deciding
whether these bare u64_stats_sync updates need a lock.

[ ... ]

> @@ -2672,8 +2811,15 @@ static void mana_update_rx_dim(struct mana_cq *cq)
>  	if (!smp_load_acquire(&apc->rx_dim_enabled))
>  		return;
>  
> -	dim_update_sample(READ_ONCE(cq->dim_event_ctr), rxq->stats.packets,
> -			  rxq->stats.bytes, &dim_sample);
> +	/* A retiring queue counts elsewhere and is about to be destroyed, so
> +	 * there is no moderation left to tune and its samples would step off
> +	 * the shared slot onto a counter that restarts at zero.
> +	 */
> +	if (READ_ONCE(rxq->retiring))
> +		return;
> +
> +	dim_update_sample(READ_ONCE(cq->dim_event_ctr), rxq->stats->packets,
> +			  rxq->stats->bytes, &dim_sample);
>  	net_dim(&cq->dim, &dim_sample);
>  }

[Severity: Low]
After this change the DIM input is apc->rxq_stats[rxq_idx], a per-index
counter shared by every queue generation that served that index, while
cq->dim.start_sample belongs to one queue instance.  When the retiring flag
is cleared again on the rollback path, is anything re-basing cq->dim?

mana_publish_qset() rollback:

	mana_qset_set_retiring(newq, out_old, true);
	synchronize_net();
	mana_qset_set_retiring(out_old, NULL, false);

The restored @out_old queues resume sampling with the start_sample they
captured before the swap, at which point the shared slot held X.  The
@newq queues were unmarked and installed earlier and may have advanced the
same slot to Y > X (steering can already point at them when
mana_config_rss() fails part-way), so the first dim_update_sample() after
the rollback attributes another queue's packets and bytes to this queue.

mana_dim_change() memsets cq->dim on enable for what looks like the same
reason:

	if (enable) {
		memset(&cq->dim, 0, sizeof(cq->dim));

Also, the commit message describes the change as moving statistics storage
only, and does not mention that the RX interrupt-moderation input source
and its new skip condition changed.  Should that be called out?

[ ... ]

> @@ -4230,16 +4382,33 @@ static void mana_start_txqs(struct mana_port_context *apc)
>   * A queue both sets own must end up unmarked, so callers mark the leaving set
>   * first and unmark the incoming one second.
>   */
> -static void mana_qset_set_retiring(struct mana_qset *qset, bool retiring)
> +static void mana_qset_set_retiring(struct mana_qset *qset,
> +				   const struct mana_qset *keep, bool retiring)
>  {
>  	unsigned int q;
>  
> -	if (!qset->tx_qp)
> -		return;
> -
>  	for (q = 0; q < qset->num_queues; q++) {
> -		if (qset->tx_qp[q])
> +		if (qset->tx_qp && qset->tx_qp[q])
>  			WRITE_ONCE(qset->tx_qp[q]->txq.retiring, retiring);
> +
> +		if (!qset->rxqs || !qset->rxqs[q])
> +			continue;
> +
> +		/* A queue @keep carries over serves the same index before and
> +		 * after, so it stays the live writer of that index. Marking it
> +		 * would strand the counts it takes during the swap in
> +		 * drain_stats, which only mana_destroy_rxq() drains.
> +		 */

[Severity: Low]
Same comment inconsistency as above: "which only mana_destroy_rxq()
drains" is no longer true once the rollback path below calls
mana_fold_qset_rx_stats().

[ ... ]

> @@ -4384,8 +4553,23 @@ int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
>  	/* The roles are swapped now: @newq is the set going away and @out_old
>  	 * is live again. Same ordering rule, leaving set first.
>  	 */
> -	mana_qset_set_retiring(newq, true);
> -	mana_qset_set_retiring(out_old, false);
> +	mana_qset_set_retiring(newq, out_old, true);
> +
> +	/* Same grace period as the forward path: a poll that sampled the flag
> +	 * before the line above must finish before @out_old is unmarked, or
> +	 * both sets would briefly count into apc->rxq_stats[].
> +	 */
> +	synchronize_net();
> +
> +	mana_qset_set_retiring(out_old, NULL, false);
> +
> +	/* @out_old counted into drain_stats while it was marked, and it is
> +	 * about to serve again rather than be destroyed, so nothing else
> +	 * would ever publish those packets. Fold them now, once the polls
> +	 * that still saw the flag above have finished writing.
> +	 */
> +	synchronize_net();
> +	mana_fold_qset_rx_stats(apc, out_old);

[Severity: Low]
This is the second writer of apc->rxq_stats_ret[] that the header comment
and mana_qset_set_retiring() both say does not exist.  Both writers do run
under RTNL, so the serialization holds; only the documentation is stale.

[ ... ]

> diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
> index 61d136736cf6c..9a43856760776 100644
> --- a/include/net/mana/mana.h
> +++ b/include/net/mana/mana.h

[ ... ]

> @@ -415,7 +419,23 @@ struct mana_rxq {
>  
>  	u32 buf_index;
>  
> -	struct mana_stats_rx stats;
> +	/* Points into apc->rxq_stats[], which outlives the queue. Only the
> +	 * live queue at this index writes there; once retiring is set this
> +	 * queue counts into drain_stats instead, so the slot has one writer.
> +	 * Use mana_rxq_stats() rather than either directly.
> +	 */
> +	struct mana_stats_rx *stats;
> +
> +	/* Set under RTNL before a different queue takes over this index. A
> +	 * queue carried across a swap keeps serving its index and is never
> +	 * marked.
> +	 */
> +	bool retiring;
> +
> +	/* What this queue counted after it stopped being the live one.
> +	 * Folded into apc->rxq_stats_ret[] when the queue is destroyed.
> +	 */
> +	struct mana_stats_rx drain_stats;

[Severity: Low]
"Folded into apc->rxq_stats_ret[] when the queue is destroyed" - the
rollback path folds drain_stats for queues that are not destroyed but
resume service.  Could this be reworded to cover both cases?

> @@ -623,6 +643,19 @@ struct mana_port_context {
>  	unsigned int max_queues;
>  	unsigned int num_queues;
>  
> +	/* Per-queue counters, max_queues entries each. Allocated at probe and
> +	 * freed at remove, never on queue teardown, so a reconfiguration does
> +	 * not reset them.
> +	 *
> +	 * rxq_stats[] is written by the live RX queue at that index and
> +	 * rxq_stats_ret[] only under RTNL, by mana_destroy_rxq() folding in
> +	 * what a retiring queue counted while it drained. One writer each;
> +	 * readers add the two.
> +	 */

[Severity: Low]
"only under RTNL, by mana_destroy_rxq()" and "One writer each" are the two
claims that the mana_alloc_queue_stats() comment and the
mana_fold_qset_rx_stats() call in mana_publish_qset()'s rollback path
contradict.  Should this describe both rxq_stats_ret[] writers, and drop
the "One writer each" statement for the live slots?

> +	struct mana_stats_rx *rxq_stats;
> +	struct mana_stats_rx *rxq_stats_ret;
> +	struct mana_stats_tx *txq_stats;
> +

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260901014442.2945689-1-longli%40microsoft.com
