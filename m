Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9B23EEAF8;
	Fri,  4 Sep 2026 04:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788497204; cv=none; b=j44AgPuGx4cuyyDNrEh93zK1++1Le+VCUhj+AgkC/DZce99gZJwSa98wCqG0jrdHZbK5huPz8KwrgGhB4IC5s/Fi2gmrtkfhH1uvkyySyPY6PNUsZOqnXCyfzI1nb6kniinz8TUujiONpENqHUo1y/2UBi+8J0WONkhWWsRtAHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788497204; c=relaxed/simple;
	bh=KKxMKi2Ad2ocu8E/x81T4ZGbH0/kca2xsnqqlLTZfB4=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QPzcgbOMAdQy0js8V8/1jWUzW5iNLyu5Z+B3jrBUhGLvvhZJv8iLvhg/u/29MjYfwJCOYx0JMaLU31rJaXbRPgE7gU1EpA3yz+peH8z4nvCHNN1pSGp8J5wmFmEYytaf5G2s7pyXe3v5QSM7y8C1kNGwzUPxULic38GkKXmitOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=URcQRPGk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="URcQRPGk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745F81F00A3D;
	Fri,  4 Sep 2026 04:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788497202;
	bh=L5slc6qY+F4kJDTZaBAu5W5VcprXuE1/qxIaNbX7m9A=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=URcQRPGkCaVPrY4ZsnQ8vixM+Uhb6tj6AuR3ywnErpCHHmb+slVKJQMPu21pMaRl/
	 yQLF3K//5jN9E7FZLbUQxEa3fURHKdwf8VDRRc+8Qh3LeHriDyJX+gYe2TSFXCNN+1
	 5eoz3hM/XTUn7ERWnLl80/Vv8ohlytFLEbRojlV1yBCOcYqUvgyT+Df7rLOu4jm0NS
	 giPjpA5VGC0OLDpy10qBm7Cfm8Wt6aoGy5BOmyVn3A5ZOOviHxmy5u1aEre/AjEQcv
	 z/9nNQRe+s42k66h1LfluMjmvLatmGXIO/lKoaDSGXHsGSZuiZTGsLnjjwKkPMQb7o
	 27f7NigpvUIdg==
Subject:
 Re: [PATCH net-next v3 03/13] net: mana: swap queue sets in mana_set_channels
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
Date: Fri, 04 Sep 2026 04:46:41 +0000
Message-ID: <178849720105.4131868.15360479367304801896@kernel.org>
In-Reply-To: <20260901014442.2945689-4-longli@microsoft.com>
References: <20260901014442.2945689-4-longli@microsoft.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 6 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 3 · Low: 3

- [Medium] The commit message ("If the swap itself fails the previous set
  is put back and the port keeps running on it") and the…
- [Medium] mana_publish_qset() lowers ndev->real_num_rx_queues to the new
  (smaller) count before the retiring RX queues stop delivering.
- [Medium] mana_publish_qset() reopens the datapath with 'smp_wmb();
  WRITE_ONCE(apc->port_is_up, true); mana_start_txqs(apc);' and…
- [Low] mana_set_channels() builds the complete replacement queue set
  with mana_alloc_qset() while the current set is still instantiated on…
- [Low] The comment on struct mana_port_context::channel_changing in
  include/net/mana/mana.h still describes the flag as covering…
- [Low] The new inline port-down branch of mana_set_channels() writes
  apc->num_queues = new_count and resizes apc->rxqs, but unlike every…

--

net: mana: swap queue sets in mana_set_channels

The channel count path stops using detach/attach: mana_set_channels() now
builds a replacement queue set, hands it to a new mana_publish_qset() that
swaps it in under RTNL, and retires the old set afterwards. Two new port
context fields (publish_dead_end, carrier_forced_off) record the case where
neither the new nor the old set could be installed.

A few questions about the new paths below.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index bd80658cf3efc..880a3ba37fd3e 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c

[ ... ]

> @@ -4094,6 +4145,289 @@ int mana_alloc_qset(struct mana_port_context *apc,
>  	return err;
>  }
>  
> +/* Close a port mana_publish_qset() gave up on; does nothing otherwise. Under
> + * RTNL.
> + *
> + * The caller releases the unpublished set first: closing destroys the shared
> + * EQ pool its CQs attach to, and only the caller knows whether it owns its
> + * queues or shares them with the live set. RX is already off.
> + *
> + * Merely stopping the port would leave port_is_up false with queues still
> + * allocated, so mana_detach() skips teardown and the next open trips
> + * WARN_ON(apc->eqs).
> + */
> +void mana_publish_close_if_needed(struct mana_port_context *apc)
> +{
> +	ASSERT_RTNL();
> +
> +	if (!apc->publish_dead_end)
> +		return;
> +
> +	apc->publish_dead_end = false;
> +
> +	/* mana_dealloc_queues() requires the port already marked down, which
> +	 * mana_publish_qset() did before the swap it is unwinding.
> +	 */
> +	if (mana_dealloc_queues(apc->ndev))
> +		netdev_err(apc->ndev,
> +			   "failed to close the port after a failed rollback\n");
> +}
> +
> +/* Start only the netdev queues that can take work. A carried-over queue may
> + * still have a full ring, and restarting it would just make mana_start_xmit()
> + * drop; leave it for mana_poll_tx_cq() to wake. Must run after port_is_up is
> + * set, or that wakeup is gated off.
> + */
> +static void mana_start_txqs(struct mana_port_context *apc)
> +{
> +	struct net_device *ndev = apc->ndev;
> +	unsigned int i;
> +
> +	if (!apc->tx_qp)
> +		return;
> +
> +	for (i = 0; i < apc->num_queues; i++) {
> +		if (!apc->tx_qp[i])
> +			continue;
> +
> +		if (mana_can_tx(apc->tx_qp[i]->txq.gdma_sq))
> +			netif_tx_wake_queue(netdev_get_tx_queue(ndev, i));
> +	}
> +}

[ ... ]

> +static void mana_publish_give_up(struct mana_port_context *apc)
> +{
> +	int err;
> +
> +	apc->rss_state = TRI_STATE_FALSE;
> +
> +	err = mana_disable_vport_rx(apc);
> +	if (err && mana_en_need_log(apc, err))
> +		netdev_err(apc->ndev, "failed to disable vPort RX: %d\n", err);
> +

[ ... ]

> +	apc->carrier_forced_off = netif_carrier_ok(apc->ndev);
> +	netif_carrier_off(apc->ndev);
> +	apc->publish_dead_end = true;
> +}

[ ... ]

> +	err = netif_set_real_num_tx_queues(ndev, apc->num_queues);
> +	if (err)
> +		goto rollback;
> +
> +	err = netif_set_real_num_rx_queues(ndev, apc->num_queues);
> +	if (err)
> +		goto rollback;

[Severity: Medium]
When the channel count is reduced, does lowering ndev->real_num_rx_queues
here happen before the retiring RX queues stop delivering?

At this point mana_publish_qset() has only installed the new (smaller) set.
The old RQs with rxq_idx >= the new count still have buffers posted and
their NAPIs enabled; they are only disabled much later, in
mana_free_qset() -> mana_destroy_rxqs() -> mana_destroy_rxq(), after
mana_config_rss() (an HWC round trip plus mana_fence_rqs(), up to 10s per
queue), a synchronize_net() and mana_drain_txqs() (bounded at 120s).

Everything those queues complete in that window is stamped with their own
index:

mana_rx_skb()
	...
	skb_record_rx_queue(skb, rxq_idx);

and that index then reaches the core:

net/core/dev.c:netif_get_rxqueue() {
	...
	if (unlikely(index >= dev->real_num_rx_queues)) {
		WARN_ONCE(dev->real_num_rx_queues > 1,
			  "%s received packet on queue %u, but number "
			  "of RX queues is %u\n",
			  dev->name, index, dev->real_num_rx_queues);
	...
}

netif_get_rxqueue() is reached from get_rps_cpu() whenever RPS/RFS is
configured and from netif_receive_generic_xdp(), so an 8 -> 4 reduction
under RX load looks like it can produce that warning plus a fallback to
rxqueue 0's RPS state. With the old detach/attach flow every RQ was
destroyed by mana_dealloc_queues() before the counts changed, so this
window did not exist.

Would it work to postpone netif_set_real_num_rx_queues() until after the
retiring queues have been quiesced?

> +
> +	/* Carry the XDP program over before steering can reach the new RXQs:
> +	 * they were created with bpf_prog == NULL, so a packet arriving first
> +	 * would bypass an attached program. This also takes the per-queue
> +	 * references that mana_free_qset() drops for the old set.
> +	 */
> +	mana_chn_setxdp(apc, mana_xdp_get(apc));
> +
> +	err = mana_config_rss(apc, TRI_STATE_TRUE, true, true);
> +	if (err)
> +		goto rollback;
> +
> +	/* Pair with the queue-state stores above: a datapath reader that sees
> +	 * the gate open must also see the queue set it is about to index.
> +	 */
> +	smp_wmb();
> +
> +	WRITE_ONCE(apc->port_is_up, true);
> +	mana_start_txqs(apc);

[Severity: Medium]
Is a store-store barrier enough here, given that mana_start_txqs() then
loads queue state?

smp_wmb() does not order the store to apc->port_is_up against the following
load of the SQ head/tail inside mana_can_tx(), so this is the store-buffer
pattern:

CPU0 (ethtool, RTNL)			CPU1 (NAPI)
WRITE_ONCE(apc->port_is_up, true);	mana_move_wq_tail();  /* frees room */
mana_start_txqs()			smp_mb(); smp_rmb();
  mana_can_tx() -> ring still full	  reads apc->port_is_up == false
  no netif_tx_wake_queue()		  no netif_tx_wake_queue()

The completion side is gated on a plain read:

mana_poll_tx_cq() {
	...
	/* Ensure checking txq_stopped before apc->port_is_up. */
	smp_rmb();

	if (txq_stopped && !READ_ONCE(txq->retiring) && apc->port_is_up &&
	    avail_space >= MAX_TX_WQE_SIZE) {
		netif_tx_wake_queue(net_txq);
	...
}

A fence on only one side of the store-buffer test still allows both loads
to return stale values, since CPU0's store to port_is_up can sit in its
store buffer while CPU0's load of the ring executes.

All queues are XOFF at that point because of the netif_tx_disable() earlier
in this function, and mana_start_txqs() is the only thing that can restart
them; once pending_sends is drained no further completion retries. Does
that leave the netdev TX queue stopped until the 15s watchdog fires
ndo_tx_timeout and resets the port?

The same pattern is repeated on the rollback path below, where the restored
old queues keep their rings and can legitimately be full. Would an smp_mb()
after the port_is_up store (or before reading it in mana_poll_tx_cq()) close
this?

> +
> +	return 0;
> +
> +rollback:
> +	netdev_err(ndev, "%s failed: %d, restoring previous queue set\n",
> +		   __func__, err);

[ ... ]

> +	if (netif_set_real_num_tx_queues(ndev, apc->num_queues) ||
> +	    netif_set_real_num_rx_queues(ndev, apc->num_queues)) {

[ ... ]

> +		netdev_err(ndev, "failed to restore queue counts, closing the port\n");
> +		mana_publish_give_up(apc);
> +		return err;
> +	}
> +
> +	if (mana_config_rss(apc, TRI_STATE_TRUE, true, true)) {

[ ... ]

> +		netdev_err(ndev, "failed to restore RSS steering, closing the port\n");
> +		mana_publish_give_up(apc);
> +		return err;
> +	}

[Severity: Medium]
The commit message says:

  "If the swap itself fails the previous set is put back and the port keeps
  running on it."

Do these two branches match that description?  Both call
mana_publish_give_up(), which disables vport RX, forces the carrier down and
sets apc->publish_dead_end, and the caller then reaches
mana_publish_close_if_needed() -> mana_dealloc_queues().

The result is a third outcome: the interface stays administratively up but
carries no traffic until an admin does a down/up. netif_set_real_num_rx_queues()
can return -ENOMEM from the sysfs/kobject update, and mana_config_rss() can
fail on an ordinary HWC error or timeout, so it is reachable.

Could the changelog describe that outcome, along with the two new fields
(publish_dead_end, carrier_forced_off) and the mana_open() /
mana_link_state_handle() carrier arbitration that exist only to make it
recoverable?

The same applies to the function comment added in mana_ethtool.c below,
which promises "On failure the existing queues keep running".

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> index ece7ff9cc409a..2ef3d461e7072 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> @@ -648,52 +648,98 @@ static int mana_set_coalesce(struct net_device *ndev,

[ ... ]

> +/* Build the new queue set while the current one keeps serving traffic, then
> + * swap. On failure the existing queues keep running and the requested value is
> + * never replaced by a fallback. The vport is never torn down, so RDMA cannot
> + * take it mid-reconfiguration.
>   */
>  static int mana_set_channels(struct net_device *ndev,
>  			     struct ethtool_channels *channels)
>  {

[ ... ]

> +	mutex_lock(&apc->vport_mutex);
> -	if (!apc->port_is_up && apc->vport_use_count) {
> +	if (!apc->port_is_up) {
> +		struct mana_rxq **rxqs;
> +
> +		if (apc->vport_use_count) {
> +			mutex_unlock(&apc->vport_mutex);
> +			return -EBUSY;
> +		}
> +
> +		rxqs = kzalloc_objs(struct mana_rxq *, new_count);
> +		if (!rxqs) {
> +			mutex_unlock(&apc->vport_mutex);
> +			return -ENOMEM;
> +		}
> +
> +		kfree(apc->rxqs);
> +		apc->rxqs = rxqs;
> +		apc->num_queues = new_count;
> +		mutex_unlock(&apc->vport_mutex);
> +		return 0;
> +	}

[Severity: Low]
Should this port-down branch also update the netdev core counters and the
RSS table?

Every other writer of apc->num_queues pairs it with them:

mana_alloc_queues() {
	...
	err = netif_set_real_num_tx_queues(ndev, apc->num_queues);
	...
	err = netif_set_real_num_rx_queues(ndev, apc->num_queues);
	...
	mana_rss_table_init(apc);
}

and mana_publish_qset() added in this patch does the same. Here only
apc->num_queues and apc->rxqs change, yet mana_get_channels() reports the
new value immediately:

	channels->combined_count = apc->num_queues;

So after "ip link set eth0 down; ethtool -L eth0 combined 4", does
"ethtool -l" advertise 4 while real_num_tx_queues / real_num_rx_queues and
the sysfs queue listing still describe the old count, and can "ethtool -x"
return indirection entries >= 4, until the next mana_open() quietly fixes
both?

> +	if (apc->channel_changing) {
>  		mutex_unlock(&apc->vport_mutex);
>  		return -EBUSY;
>  	}
>  	apc->channel_changing = true;
>  	mutex_unlock(&apc->vport_mutex);
>  
> -	err = mana_pre_alloc_rxbufs(apc, ndev->mtu, new_count);
> -	if (err) {
> -		netdev_err(ndev, "Insufficient memory for new allocations");
> +	scratch = mana_qset_scratch_alloc(apc);
> +	if (!scratch) {
> +		err = -ENOMEM;
>  		goto clear_flag;
>  	}
>  
> -	err = mana_detach(ndev, false);
> -	if (err) {
> -		netdev_err(ndev, "mana_detach failed: %d\n", err);
> -		goto out;
> -	}
> +	err = mana_alloc_qset(apc, scratch, new_count, apc->rx_queue_size,
> +			      apc->tx_queue_size, apc->priv_flags, &newq);
> +	if (err)
> +		goto free_scratch; /* current qset untouched, nothing to undo */

[Severity: Low]
Building the whole replacement set here means old_count + new_count SQ and
RQ work-queue objects have to coexist on the same vport, but the only
validation is new_count <= apc->max_queues, and apc->max_queues is itself
clamped to the firmware-reported per-vport limits:

mana_query_vport_cfg() {
	...
	*max_sq = resp.max_num_sq;
	*max_rq = resp.max_num_rq;
}

Can "ethtool -L ethX combined N" now be rejected by the device at
MANA_CREATE_WQ_OBJ time for values that the previous detach/attach
implementation accepted, because old + new exceeds max_num_sq /
max_num_rq?

Later patches in this series appear to remove this condition:
mana_split_qset() re-partitions the existing queues and mana_grow_qset()
only fills the [old_count, new_count) slots, so the peak returns to
max(old_count, new_count). Is it worth folding that reduction in earlier, or
noting the temporary doubled peak in the changelog?

> diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
> index 2117a30116c26..dd767ab623912 100644
> --- a/include/net/mana/mana.h
> +++ b/include/net/mana/mana.h
> @@ -639,6 +639,21 @@ struct mana_port_context {
>  	 */
>  	bool channel_changing;

[Severity: Low]
Could the comment above this field be refreshed?  It currently reads:

	/* Set by mana_set_channels() under vport_mutex to block RDMA
	 * from grabbing the vport during the detach/attach window.
	 * Checked by mana_cfg_vport() when called from the RDMA path.
	 */

After this patch mana_set_channels() has no detach/attach window (the vport
is never released), and mana_cfg_vport() is no longer the only reader:
mana_set_channels() itself now tests the flag and returns a new -EBUSY.

The other writer also still claims parity that no longer holds:

mana_per_port_queue_reset_work_handler() {
	...
	/* Block RDMA from grabbing the vport during the detach/attach
	 * window, same as mana_set_channels().
	 */
	mutex_lock(&apc->vport_mutex);
	apc->channel_changing = true;

It sets the flag unconditionally rather than following the new
test-then-set protocol. Both writers run under RTNL today, so nothing
misbehaves, but should they use the same protocol so a future caller that
does not hold RTNL cannot lose the -EBUSY or clear the flag early?

> +	/* mana_publish_qset() could neither publish the new set nor restore the
> +	 * old one. Vport RX is already off; the port still has to be closed,
> +	 * which mana_publish_close_if_needed() does once the caller has
> +	 * released the set that failed.
> +	 */
> +	bool publish_dead_end;
> +
> +	/* The dead end above took the carrier down for a software reason, not
> +	 * a link event, so nothing else will ever put it back: the link
> +	 * handler only runs on a real HWC_DATA_HW_LINK_* transition. Remember
> +	 * it so the next successful open restores it, which is what makes the
> +	 * documented "recoverable with a down/up" actually true.
> +	 */
> +	bool carrier_forced_off;

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260901014442.2945689-1-longli%40microsoft.com
