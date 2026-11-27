Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795771954;
	b=tUsqdjKIcYLmxK8ykmVjp6MlmqcvtSsTl9+KT0f46tMVA63vJYKBLJdkDSdKvnGKZo08
	 fSrNS6hq8U3VpqMCWosuHjVpTL0FbpUpY3JrAnU3DAtKAuA9wjy4qiXtLiEK7Vh5SI1rS
	 q7AtV+R95NZ26g4pkJ4kLhMPTkh8iFt5tSOAWn4wSaURB/csy3tfwa+tH7yD26A5em4uH
	 fD2etB9wKmlZUjWd4t4ZDBfkGC4V8ExCTId6ZmgB0+CVKJLBNOZiEvh5e6UORwr9zjcvS
	 nqKTzJgxPE6LmLNVhtTK05+l6yzcMISyknWXuRLFIcQT+3H09/d4V8UO5DHhGyJWG6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795771954;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=I+yexljqZ8dH7oYYYT3kCGp9Kqah9eMG4Yd5LvFz2ME=;
	b=GjS+w6+RkxK9eIJYsN8SEaQqct0SKuuSEun3rb75MHxJNxbmg9vVcj8HydmJ77BksUZb
	 zIz6gO4SvPhUu19ivpXiG+nldBXoMQVN6VzEchHuOg1qk3yiIW0z0UcSDljPeFueV2JKF
	 AFVERp8657PuWt8wA8v3qW/EZGlBx0lTkzo4vhuztmWGzPIYTGPtnX0lgfmKpzxP6st90
	 E7XlFkDjXYF5VVUqwUMrGSxoKD9RA/JxdkcjV4IM90Qh+qnMX20szPdqjP1ZpX84iFUAF
	 3Yw/46JnL24iYprLnmfi3zyuotZqnbPUNS2tQL/KguOxYmQkYoIQTR9+NnbcPh9XGvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ORCVgFvy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B98606A32E;
	Fri, 27 Nov 2026 09:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ORCVgFvy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6641F00899;
	Fri, 27 Nov 2026 09:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795771954;
	bh=I+yexljqZ8dH7oYYYT3kCGp9Kqah9eMG4Yd5LvFz2ME=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ORCVgFvyxPS3SGECYpWmuQnGPSJL0E3pCF182JH+3BKzttCpfgBbADUiDiWQgqWbu
	 yWdVpQZY15U6TRaviH7GFNS5nYVhVgK7dpwmQG2vNFb4mkBIJ0TscMmQkEMOYbo/R4
	 wELCniGx/SRLWwiKAwDyvjvRpm67PDOc46Frl5Stic1+gEhEeGAceRGjdIpwjfBDPU
	 4W16JsUyM5f6lJyK8/fdRWJ5Ggc7TaMWknRV3KIIK1eU91mLFfG6AJogk8jJjdHghG
	 7nPyF8RX1+fqn+ueXC9z5YB+p02tyCvaro98txq5O7Wv1ITibNR8oWuRihLBDPrQSY
	 vIx3ZwVWphoWA==
Subject:
 Re: [PATCH net v5] net: mana: Avoid waiting on dead HWC after device reset
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
Date: Fri, 27 Nov 2026 09:32:32 +0000
Message-ID: <179577195250.3135.5489299451914207495@kernel.org>
In-Reply-To: <20261126093032.816436-1-sahilchandna@linux.microsoft.com>
References: <20261126093032.816436-1-sahilchandna@linux.microsoft.com>
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

Critical: 0 · High: 0 · Medium: 2 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] mana_dealloc_queues()
  (drivers/net/ethernet/microsoft/mana/mana_en.c) used to wait up to 120…
- [Medium] mana_dealloc_queues() sets hwc_dead only when
  mana_gd_dev_reset() returns 0.

--

net: mana: Avoid waiting on dead HWC after device reset

This patch drops the 120s sleep-based TX drain in mana_dealloc_queues().
It now polls each queue's CQ synchronously for about 300 ms and resets
the device if sends are still outstanding. A successful reset sets a new
hwc_dead flag, which makes mana_hwc_send_request() fail fast and skips
mana_fence_rqs() and the SHM teardown handshake.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 95bf153c3e1a8..cf0409704b08b 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c

[ ... ]

> @@ -3802,31 +3813,83 @@ static int mana_dealloc_queues(struct net_device *ndev)
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
> +	 * the hardware is not responding: reset the device.

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

[Severity: Medium]
Is 300 ms long enough to decide that the hardware is unresponsive?

mana_dealloc_queues() runs on every mana_detach() path, not only on
unload or after a hang:

  - ndo_close
  - mana_change_mtu()
  - XDP install in mana_bpf.c
  - the ethtool channel, ring and priv-flag paths
  - mana_per_port_queue_reset_work_handler()

The driver itself expects TX to stall for seconds on working hardware:

mana_init_net_dev() {
    ...
	/* Recommended timeout based on HW FPGA re-config scenario. */
	ndev->watchdog_timeo = 15 * HZ;
    ...
}

Say a slow but working device still has completions outstanding 300 ms
after TX is stopped. An MTU change or ethtool -L would then go:

mana_detach()
  mana_dealloc_queues()
    mana_gd_dev_reset()   /* pcie_flr() on PCI, cdx_dev_reset() on CDX */
    WRITE_ONCE(hwc->hwc_dead, true)
mana_attach()
  -> fails with -ETIMEDOUT from mana_hwc_send_request()

The reset covers the whole function. Would the other vPorts and mana_ib
on the same gdma_context lose their HWC as well?

On PCI, recovery seems to depend on mana_gf_stats_work_handler() seeing
-ETIMEDOUT and calling mana_schedule_serv_work(gc,
GDMA_EQE_HWC_RESET_REQUEST). That runs a full suspend, 10 s sleep and
resume cycle, which also tears down RDMA.

mana_cdx_bus_ops has .dev_reset but no .schedule_serv_work, so
mana_schedule_serv_work() returns -EOPNOTSUPP there. Does that leave the
CDX netdev unusable until the device is unbound and rebound?

Nothing is logged in mana_dealloc_queues() when the reset succeeds. Also,
mana_need_log() now suppresses -ETIMEDOUT logging while hwc_dead is set.
Could these resets be hard to diagnose?

The commit message says the 300 ms "is not based on a hardware limit".
The commit being fixed, a7dfeda6fdec, picked 120 seconds as "more than
long enough for functional hardware to complete any sends".

This patch is tagged for stable. Could the commit message say that a
routine reconfiguration of one port can now reset the whole function?

[ ... ]

> +		if (trigger_flr && !READ_ONCE(hwc->hwc_dead)) {
> +			/* Completions never arrived: the device is
> +			 * unresponsive, so reset it. Mark the HWC dead only
> +			 * if the reset succeeds, so that later HWC commands
> +			 * fail fast. If it fails, the device may still access
> +			 * memory, so the teardown commands are still posted
> +			 * and the first one waits the full hwc_timeout.
> +			 */
> +			err = mana_gd_dev_reset(gd->gdma_context);
> +			if (err) {
> +				netdev_err(ndev, "device reset failed %d with %d pkts pending in txq %u\n",
> +					   err, flr_pending, flr_txq_id);
> +			} else {
> +				WRITE_ONCE(hwc->hwc_dead, true);
>  			}
>  		}

[Severity: Medium]
Is it right to treat every non-zero return from mana_gd_dev_reset() as
meaning the device may not have been reset?

pcie_flr() can fail after the FLR has already been issued:

drivers/pci/pci.c:pcie_flr() {
    ...
	pcie_capability_set_word(dev, PCI_EXP_DEVCTL, PCI_EXP_DEVCTL_BCR_FLR);
    ...
	msleep(100);

	ret = pci_dev_wait(dev, "FLR", PCIE_RESET_READY_POLL_MS);
done:
	pci_dev_reset_iommu_done(dev);
	return ret;
}

Only two failures happen before the reset starts: the -ENOTTY return
when pci_dev_config_accessible() is false, and a failing
pci_dev_reset_iommu_prepare().

If pci_dev_wait() times out, the function's state, including the HWC
queues, has already been reset, or the function is stuck in reset. In
that case hwc_dead stays false.

The driver will already have spent up to PCIE_RESET_READY_POLL_MS in
pci_dev_wait(). Would it then also:

  - post MANA_CONFIG_VPORT_RX and wait the full hwc_timeout
  - run mana_fence_rqs(), which sleeps 100 ms per RX queue on error
  - run mana_smc_teardown_hwc() from mana_hwc_destroy_channel()
    against a function that cannot answer

RTNL could then be held for well over 120 s. That is the hung-task
symptom this patch sets out to remove.

The commit message says "If the reset fails, the device may not have
been reset and may still access memory". Could the case where the FLR
was issued but the wait failed be told apart, or the device's reset
state be checked, so that this path also fails fast?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261126093032.816436-1-sahilchandna%40linux.microsoft.com
