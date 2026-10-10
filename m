Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF4C358363;
	Sat, 10 Oct 2026 16:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791650727; cv=none; b=VXewYUoB4wiZFcg6pPIU3tPIm/3a+n68Ajf6gmdF0bQt53AjLQP/GzZjToBwPWSG+YoSlsOuw1BczeH+l9y4CeztFL7rjSVZyapmKnTGI2nR2ZY4ThgQNZALSSFsP78B4rU6IKOvymttp1aTNzEVSfqaH2S/IdetM+2VRkZrmA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791650727; c=relaxed/simple;
	bh=BjQcWrxxEzY2pQplQyWwEqszwZkK5CivOSc9qGwM60A=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oJF5+Mq/Au9kfdA1bZ3EyIvhmW+0OVzvpfpK7aqfFUlP8eQctA418SELEIkJNg6zAzSrJaocu3c8d+kcV2q6Pzfn3GHlpBRi8v01BwiugRQ1IGJLtJEJ2HyNkR68cuJO00scViA1ltAe3xV2dIphTW3n+gO3zF4qA427+cAtd6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bossdBL+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bossdBL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2C71F00893;
	Sat, 10 Oct 2026 16:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791650725;
	bh=WsUaTQW16T+VJ/IXuKMk2nCrenXhAlNwSmjK48HhIf0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=bossdBL+e4oI2KCDhndhK/ogW5fFjXO36mLNSUPi1FY9LHtuk/+09ELXOXOSBu+e2
	 fOhvoF+zWqTAfwoWfXQ1dhIikZTNNhRwpTq4Vs7NPhA5L4ohUlDfmODq6Ws/BG3yZs
	 es5vzZ8J8lMBDSbhtpFMcwS9rnUNZBFcm7TnUmvAdnfSzyaesS8ulqC2+HZVgr2h74
	 9ge9UcyZJQTPGRnjsqjBF9rG8k0obkxhqrL8/eD6zX25s/MI/FLoA9557I3AYaO7ah
	 PQPeeK09TwvMNd6j1lOD97HQfjjIOaK/6z4lTsi0LFG2ZvDPnl5Y4FwT4T62tVr7RE
	 8Cots2c/vBcbA==
Subject: Re: [net-next v2 3/3] bnge: reserve TX/completion rings for the RoCE
 MPC channel
From: netdev-bot+sashiko@kernel.org
To: siva.kallam@broadcom.com
Cc: leonro@nvidia.com, jgg@nvidia.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, horms@kernel.org, vikas.gupta@broadcom.com,
 ajit.khaparde@broadcom.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 sachin.holla@broadcom.com, dharmender.garg@broadcom.com
Date: Sat, 10 Oct 2026 16:45:24 +0000
Message-ID: <179165072406.434549.12670474627195598439@kernel.org>
In-Reply-To: <20261006161256.1493672-4-siva.kallam@broadcom.com>
References: <20261006161256.1493672-4-siva.kallam@broadcom.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 2 · Medium: 1 · Low: 0 (1)

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] In bnge_reserve_rings()
  (drivers/net/ethernet/broadcom/bnge/bnge_resc.c:347-353), the new RoCE…
- [High] The patch adds an MPC TX ring and CQ on top of the L2 demand.
- [Medium] The commit message says the bng_re driver allocates its own
  TX/CQ rings for an MPC control channel from the per-function FW ring…

Pre-existing issues:
- [Low] bnge_reserve_rings() now reads bnge_is_roce_en() separately for
  need_reserve, tx_demand/hwr.tx (line 312), hwr.cmpl (line 317) and the…

--

bnge: reserve TX/completion rings for the RoCE MPC channel

When RoCE is enabled, this patch makes bnge_reserve_rings() request one
extra TX ring and one extra completion ring for an MPC control channel
that the commit says bng_re owns. Once firmware has made the reservation,
the extra TX ring is taken out of the L2 TX count. If firmware did not
grant the full TX demand, the function returns -ENOMEM.

> diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_resc.c b/drivers/net/ethernet/broadcom/bnge/bnge_resc.c
> index 4711dd4945ffe..9dfb22b7c7c7a 100644
> --- a/drivers/net/ethernet/broadcom/bnge/bnge_resc.c
> +++ b/drivers/net/ethernet/broadcom/bnge/bnge_resc.c
> @@ -110,9 +110,24 @@ static u16 bnge_nqs_demand(struct bnge_dev *bd)
>  	return bd->nq_nr_rings + bnge_aux_get_msix(bd);
>  }
>  
> +static u16 bnge_tx_rings_demand(struct bnge_dev *bd)
> +{
> +	u16 tx_rings = bd->tx_nr_rings;
> +
> +	if (bnge_is_roce_en(bd))
> +		tx_rings += 1; /* For MPC TX ring */

[Severity: Medium]

The commit message says:

  When RoCE is enabled, the bng_re driver allocates its own TX/CQ rings
  for the MPC control channel out of the same per-function FW ring pool.

Is there an in-tree user of this ring? In
drivers/infiniband/hw/bng_re/bng_dev.c, the only firmware ring allocation
is in bng_re_dev_init(), and it allocates an NQ for the CREQ:

bng_re_dev_init() {
    ...
	type = RING_ALLOC_REQ_RING_TYPE_NQ;
	creq = &rdev->rcfw.creq;
    ...
	rc = bng_re_net_ring_alloc(rdev, &rattr, &creq->ring_id);
    ...
}

Nothing else calls bng_re_net_ring_alloc(), and the matching free in
bng_re_dev_uninit() is also for the NQ. A search for mpc in bng_re and
bnge only turns up the comments this patch adds.

In the current tree, each RoCE-enabled function gives up one TX ring and
one completion ring that nothing uses. The "pool overflow" in the commit
message also doesn't look reachable.

If this prepares for a future bng_re MPC series, could the commit message
say so, or could the patch go in with that series? The same goes for the
"it is owned by RoCE driver" comment in bnge_reserve_rings().

> +
> +	return tx_rings;
> +}
> +
>  static u16 bnge_cprs_demand(struct bnge_dev *bd)
>  {
> -	return bd->tx_nr_rings + bd->rx_nr_rings;
> +	u16 cprs = bd->tx_nr_rings + bd->rx_nr_rings;
> +
> +	if (bnge_is_roce_en(bd))
> +		cprs += 1; /* For MPC CQ ring */
> +
> +	return cprs;
>  }

[Severity: High]

Can the extra ring push the request past the firmware pool it is meant
to protect?

The L2 maximums still let L2 take the whole TX pool:

_bnge_get_max_rings() {
    ...
	*max_tx = hw_resc->max_tx_rings;
    ...
}

The RoCE branch of bnge_get_dflt_rings() lowers max_cp, max_irq and
max_stat, but leaves max_tx alone:

	max_cp -= BNGE_MIN_ROCE_CP_RINGS;
	max_irq -= BNGE_MIN_ROCE_CP_RINGS;
	max_stat -= BNGE_MIN_ROCE_STAT_CTXS;
	...
	rc = bnge_adjust_rings(bd, max_rx, max_tx, max_cp, shared);

Shared mode is the only mode used, via bnge_net_init_dflt_rings(bd, true).
In that mode TX and RX are each clamped to max_cp, not their sum.

bnge_net_init_dflt_rings() then does:

	bd->tx_nr_rings_per_tc = min_t(u16, dflt_rings, max_tx_rings);

If max_tx_rings is at or below netif_get_num_default_rss_queues(),
tx_nr_rings equals max_tx_rings. bnge_tx_rings_demand() then asks for
max_tx_rings + 1, and __bnge_hwrm_reserve_pf_rings() passes that to
FUNC_CFG as is:

	req->num_tx_rings = cpu_to_le16(hwr->tx);
	...
	req->num_cmpl_rings = cpu_to_le16(hwr->cmpl);

Completion rings have the same problem. _bnge_get_max_rings() only
enforces rx + tx <= max_cp, so rx + tx + 1 can go over it.

>From there firmware has two options:

- Reject FUNC_CFG. bnge_reserve_rings() then returns before any counts
  are adjusted.
- Grant at most max_tx_rings. That hits the new -ENOMEM check below.

In both cases the retry in bnge_net_init_dflt_rings() sends the same
request again and probe fails, even though (L2 TX - 1) plus MPC would fit.

Should the L2 max/default calculation hold back one TX ring and one
completion ring for MPC when RoCE is enabled? Relaxing the check below
would not fix the FUNC_CFG rejection case.

[ ... ]

> @@ -293,11 +309,12 @@ int bnge_reserve_rings(struct bnge_dev *bd)
>  		hwr.nq = bnge_nqs_demand(bd);
>  	}
>  
> -	hwr.tx = bd->tx_nr_rings;
> +	tx_demand = bnge_tx_rings_demand(bd);
> +	hwr.tx = tx_demand;
>  	hwr.rx = bd->rx_nr_rings;
>  	if (bd->flags & BNGE_EN_SHARED_CHNL)
>  		sh = true;
> -	hwr.cmpl = hwr.rx + hwr.tx;
> +	hwr.cmpl = bnge_cprs_demand(bd);

[Severity: Low]

This is a pre-existing issue and was not introduced by this patch. Could
BNGE_EN_ROCE change between reads here? bnge_reserve_rings() now reads
bnge_is_roce_en() in four places:

- bnge_need_reserve_rings()
- the tx_demand calculation
- bnge_cprs_demand()
- the MPC subtraction after the firmware exchange

The flag can be cleared without holding rtnl or the netdev lock:

bnge_rdma_aux_device_add() {
    ...
	bd->flags &= ~BNGE_EN_ROCE;
    ...
}

bnge_probe_one() calls this after bnge_netdev_alloc() has registered the
netdev. So ndo_open->bnge_open_core()->bnge_reserve_rings() could run at
the same time.

I don't think the result is harmful:

- If the flag clears between tx_demand and hwr.cmpl,
  bnge_hwrm_get_rings() sees cp < rx + tx and trims the reserved TX/RX
  counts through bnge_fix_rings_count().
- If it clears before the subtraction, L2 keeps one extra TX ring. That
  ring still fits inside the firmware reservation, and
  bnge_adjust_rings() clamps it.

At worst, one TX ring stays over-reserved until the next reservation.

Both the unlocked flag clear and the earlier flag-dependent reads (via
bnge_aux_get_msix() and bnge_aux_get_stat_ctxs()) existed before this
patch.

>  
>  	hwr.vnic = bnge_get_total_vnics(bd, hwr.rx);
>  
> @@ -327,6 +344,13 @@ int bnge_reserve_rings(struct bnge_dev *bd)
>  	if (hwr.stat > bnge_aux_get_stat_ctxs(bd))
>  		hwr.stat -= bnge_aux_get_stat_ctxs(bd);
>  	hwr.nq = min_t(u16, hwr.nq, hwr.stat);
> +	/* Drop MPC TX ring from L2 TX ring count; it is owned by RoCE driver */
> +	if (bnge_is_roce_en(bd)) {
> +		if (hwr.tx >= tx_demand)
> +			hwr.tx -= 1;
> +		else
> +			return -ENOMEM;
> +	}

[Severity: High]

Does this make any partial TX grant from firmware a hard failure?

By this point bnge_copy_reserved_rings() has replaced hwr.tx with the
granted count. That count can't be larger than tx_demand, so the check
in effect requires the full tx_nr_rings + 1.

bnge_hwrm_get_rings() can lower resv_tx_rings even when the HWRM command
succeeds. Firmware may return a smaller alloc_tx_rings, or the count is
trimmed to fit the granted completion rings:

	if (cp < (rx + tx)) {
		rc = bnge_fix_rings_count(&rx, &tx, cp, false);
		...
		hw_resc->resv_tx_rings = tx;

For example, take 8 L2 TX rings and 8 RX rings. The request is 9 TX and
17 completion rings. If firmware grants 16 completion rings, TX is
trimmed to 8. Since 8 < 9, this returns -ENOMEM, even though 7 L2 TX
rings plus MPC would have fit.

Before this patch, bnge_adjust_rings() absorbed a short grant and
bd->tx_nr_rings was set to the granted value.

Now the return comes after firmware has committed the reservation and
hw_resc has been updated. It also comes before any of these are updated:

- bd->tx_nr_rings, bd->rx_nr_rings and bd->nq_nr_rings
- the RSS table
- the aux MSI-X/stat-ctx split

tx_nr_rings is never lowered, so bnge_need_reserve_rings() stays true.
The re-reserve retry in bnge_net_init_dflt_rings() then sends the same
demand and fails again:

	if (bnge_need_reserve_rings(bd)) {
		rc = bnge_reserve_rings(bd);
		...
	}
	if (rc) {
		bd->tx_nr_rings = 0;
		bd->rx_nr_rings = 0;
	}

That leads to bnge_probe_one() failing with "Error setting up default
cfg". bnge_open_core() hits the same check, so the interface couldn't be
opened either.

There may also be a knock-on effect on the RSS table. rss_indir_tbl is
allocated with kmalloc_array() and only initialized when the reserved RX
count changes:

	if (old_rx_rings != bd->hw_resc.resv_rx_rings)
		bnge_set_dflt_rss_indir_tbl(bd);

Suppose a reservation changes resv_rx_rings and then fails here. A later
successful call with the same RX grant would then skip the
initialization. bnge_fill_hw_rss_tbl() uses the stale or uninitialized
entries as indexes:

	j = bd->rss_indir_tbl[i];
	rxr = &bn->rx_ring[j];

Can that index past the end of bn->rx_ring[]?

Would it work to only require room for MPC plus one L2 TX ring here? For
example, hwr.tx >= 2, like the hwr.rx >= 2 aggregation check above, and
then let bnge_adjust_rings() scale down as before.

>  
>  	/* Adjust the rings */
>  	rc = bnge_adjust_rings(bd, &rx_rings, &hwr.tx, hwr.nq, sh);

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261006161256.1493672-1-siva.kallam%40broadcom.com
