Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795342854;
	b=oHO7PvRee/CErq6ubqkXEKrV8OV8hGXsmhGDfJHCwnWPFjjsGDHiRfg3d38koOU0lB90
	 p7KZQLjEwfJ/ZVtaxNERpLi4H1Jc2srQEQGDGEDxuQTti0NMq094DAzcYa7rNugvcrTX1
	 KPZbfr7KQYdubG+Q+XuFt0Rt8Vn5TH8rAe39RdQPUIpHnFCs+aL9FhN4U0264CqIQD7fF
	 hCPs9tdbgLXEyEQBt3osMWqs3Q2WSYAvCz3urMkCTbG0Nn5omRU0dZkhjaBMYxyYA3gRh
	 3nK7zBFweIngaCyLGNo3VjdBOTAw7x8gTnENMjrOp7zvVsxbWVswgqzyRkb/yJdw2LQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795342854;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=XbK8dY1xzsejjPb1arOv0xhaSlwRdVDea8jWM8dUcuw=;
	b=NkVul1LzrTiWsA2s/oe8gAbmWQmRr57nedKKtoclplem4vNCVDQtv5CV7aNHiUS6G7FV
	 e83eXt6t8/VfcHbNt7f1meJtUB89HLpUuIBSmRRsyJw96cqTlTXUqFB5qM6tqd7KiG5p3
	 gPpeYo+5Fk6hAkT1XLExNUmo8IPLwNGmyOxpFuTMxC1wfZCxC/+K8aoonTlWEYvj1U0rw
	 oBFQu+eJyiFB3VUjxpxcKN2AWdM+tELl0rnsvy2b/iUbtl4J7GfPNoIXEPcdWe6N/U1po
	 SIVkP5t4V++Upi5yQePQdrQdumpPcPQ1ev9oFXHHDfiTQ7f+WoeGsaAHplelmfmd80w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mMmNtnZr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D19A606A32A;
	Sun, 22 Nov 2026 10:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mMmNtnZr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878FA1F000C6;
	Sun, 22 Nov 2026 10:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795342853;
	bh=XbK8dY1xzsejjPb1arOv0xhaSlwRdVDea8jWM8dUcuw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=mMmNtnZrSH+8Fu0k2sBGHx8qLNCtqxiRysbBRUqoLOP8sLKPr06zw2itooghmi4HC
	 P40foT0++CDz3OcI9OMtIqw2sa1SUkGI5PGVOmDhff/0bM2agSy0QG0SairNUhzvKl
	 Q08FSk81UfGsOfwCVCYSBgOiWSwTHb6zCgTkjNCkT//UPEPoDciPGsgAlOTR8KYTnq
	 AmEcN1ZHCWcK6mlK2z5v5l4xPbVmPfn8IXahxWaTb/+Fj8toobQpeYperK1thd6ViH
	 hF8puGlWgj2OElfYcwEMDeQ/HxyM05KVV+QOb4wvoa68xGFFg9bErrQldoDBLKEIK0
	 oAgELJ3Di7FSQ==
Subject:
 Re: [PATCH net v4] net: mana: Avoid waiting on dead HWC after device reset
From: netdev-bot+sashiko@kernel.org
To: sahilchandna@linux.microsoft.com
Cc: haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, kotaranov@microsoft.com, horms@kernel.org,
 ernis@linux.microsoft.com, gargaditya@linux.microsoft.com,
 mawasthi@linux.microsoft.com, kees+treewide@kernel.org,
 schakrabarti@linux.microsoft.com, leitao@debian.org,
 linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 stable@vger.kernel.org
Date: Sun, 22 Nov 2026 10:20:52 +0000
Message-ID: <179534285205.3135.17134166045415765008@kernel.org>
In-Reply-To: <20261118091436.3985155-1-sahilchandna@linux.microsoft.com>
References: <20261118091436.3985155-1-sahilchandna@linux.microsoft.com>
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

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] In mana_dealloc_queues()
  (drivers/net/ethernet/microsoft/mana/mana_en.c), the patch cuts the…
- [Low] When mana_gd_dev_reset() fails in mana_dealloc_queues(), hwc_dead
  is deliberately left clear, and v4 dropped the hwc_timeout reduction…

--

net: mana: Avoid waiting on dead HWC after device reset

This commit replaces the 120 second sleep-based TX drain in
mana_dealloc_queues() with synchronous CQ polling. Each queue gets about
300 ms, and the device is reset if sends are still outstanding after that.
After a successful reset a new hwc_dead flag is set, so that
mana_hwc_send_request() fails fast with -ETIMEDOUT, and mana_fence_rqs() and
the SHM teardown handshake are skipped.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 7e9223143fc75..5e4379107b457 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c

[ ... ]

> @@ -3774,19 +3780,24 @@ int mana_attach(struct net_device *ndev)
>  	return 0;
>  }
>  
> +#define MANA_TX_DRAIN_RETRIES	3
> +
>  static int mana_dealloc_queues(struct net_device *ndev)
>  {

[ ... ]

> @@ -3799,31 +3810,79 @@ static int mana_dealloc_queues(struct net_device *ndev)
>  	 * to false, but it doesn't matter since mana_start_xmit() drops any
>  	 * new packets due to apc->port_is_up being false.
>  	 *
> -	 * Drain all the in-flight TX packets.
> -	 * A timeout of 120 seconds for all the queues is used.
> -	 * This will break the while loop when h/w is not responding.
> -	 * This value of 120 has been decided here considering max
> -	 * number of queues.
> +	 * Drain the in-flight TX completions for each queue. TX is already
> +	 * stopped, so pending_sends can no longer grow. For each queue,
> +	 * disable NAPI so it cannot run at the same time as this drain,
> +	 * then poll its CQ for up to 300 ms. If sends are still missing,
> +	 * the hardware is not responding: reset the device and mark the
> +	 * HWC dead so that later HWC commands fail fast.
>  	 */
>  
>  	if (apc->tx_qp) {
>  		for (i = 0; i < apc->num_queues; i++) {

[ ... ]

> +				tx_cq->budget = 0;
> +				for (retry = 0; retry <= MANA_TX_DRAIN_RETRIES;
> +				     retry++) {
> +					do {
> +						tx_cq->work_done = 0;
> +						mana_poll_tx_cq(tx_cq);
> +					} while (tx_cq->work_done);
> +
> +					if (!atomic_read(&txq->pending_sends) ||
> +					    trigger_flr ||
> +					    READ_ONCE(hwc->hwc_dead))
> +						break;
> +					if (retry < MANA_TX_DRAIN_RETRIES)
> +						msleep(100);
>  				}
> -				break;
> +			}
> +
> +			pending = atomic_read(&txq->pending_sends);
> +
> +			if (!trigger_flr && pending > 0) {
> +				trigger_flr = true;
> +				flr_txq_id = txq->gdma_txq_id;
> +				flr_pending = pending;
> +			}
> +		}

[Severity: Medium]
Before, the driver waited up to 120 seconds for completions before deciding
the device was unresponsive. Now it waits about 300 ms per queue. Is 300 ms
a safe threshold for a function-wide reset?

mana_dealloc_queues() runs during routine operations. These include
mana_close(), mana_change_mtu(), mana_set_channels(), mana_set_ringparam(),
mana_set_priv_flags(), mana_xdp_set() and the per-port queue reset work.

Suppose a device works but is slow, and a TX completion is still outstanding
after the fourth poll. Then trigger_flr is set and mana_gd_dev_reset() runs:

drivers/net/ethernet/microsoft/mana/gdma_pci.c:mana_pci_dev_reset() {
	return pcie_flr(to_pci_dev(gc->dev));
}

On CDX this is cdx_dev_reset() instead. Both reset the whole function. That
hits every vPort on the gdma_context and any mana_ib user, not just the port
being torn down. Also, pcie_flr() here does not save and restore config
space.

A successful reset sets hwc->hwc_dead. Nothing clears it until
mana_hwc_destroy_channel() frees the hwc and a new one is allocated. Until
then mana_hwc_send_request() fails at once:

	if (READ_ONCE(hwc->hwc_dead))
		return -ETIMEDOUT;

Wouldn't the mana_attach() that follows mana_detach() then fail and leave
the interface down?

On PCI, recovery seems to happen only when mana_gf_stats_work_handler()
sees -ETIMEDOUT and schedules a service reset.

The CDX bus_ops have no schedule_serv_work callback, so
mana_schedule_serv_work() returns -EOPNOTSUPP there. Would a CDX device stay
down until the driver is rebound?

The commit message says the budget "is not based on a hardware limit". It
also says that in testing the late completions had all arrived "by its
second poll", which comes after the first 100 ms sleep. That is about a 3x
margin for a decision that resets the whole device, in a patch marked for
stable.

> +
> +		if (trigger_flr && !READ_ONCE(hwc->hwc_dead)) {
> +			/* Completions never arrived: the device is
> +			 * unresponsive. Issue device reset and
> +			 * mark the HWC dead so subsequent HWC commands
> +			 * fail fast instead of each waiting the full
> +			 * hwc_timeout.
> +			 */
> +			err = mana_gd_dev_reset(gd->gdma_context);
> +			if (err) {
> +				netdev_err(ndev, "device reset failed %d with %d pkts pending in txq %u\n",
> +					   err, flr_pending, flr_txq_id);
> +			} else {
> +				WRITE_ONCE(hwc->hwc_dead, true);
>  			}
>  		}

[Severity: Low]
Two comments here say that missing sends lead to a reset and to the HWC
being marked dead so later commands fail fast. One is the block comment at
the top of the drain, the other is the comment just above
mana_gd_dev_reset(). But hwc_dead is only set when the reset succeeds. Do
these comments match the error path?

If mana_gd_dev_reset() fails, hwc_dead stays false and hwc_timeout is not
changed (v4 dropped the step that lowered it). The next call is
mana_disable_vport_rx()->mana_hwc_send_request(). It passes both hwc_dead
checks, posts MANA_CONFIG_VPORT_RX, and then waits:

	timeout = READ_ONCE(hwc->hwc_timeout);
	if (!wait_for_completion_timeout(&ctx->comp_event,
					 (msecs_to_jiffies(timeout)))) {

That wait uses the full firmware value, 60s on the tested system.
mana_fence_rqs() also still runs on this path and sleeps 100 ms per RX queue
on error. pcie_flr() can itself block in pci_dev_wait() before it fails.

This is still shorter than the old 120s drain plus 60s wait. Item 2 of the
commit message also says that posting teardown commands after a failed reset
is intentional.

Could the comments and the commit message say that RTNL can still be held
for the full hwc_timeout on this path?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261118091436.3985155-1-sahilchandna%40linux.microsoft.com
