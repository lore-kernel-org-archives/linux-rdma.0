Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755D8404BC8;
	Fri,  4 Sep 2026 04:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788497216; cv=none; b=FFqXXSxuoLC0+MLJLaCMvZiHJE/lfCguGFgEGDQX4sZozcEo/dn9eiVIo+0xemxG6QyyqJa1YPqrdo5Zo7fRSTW8LPsivo2UINfF8BAGQg2o2cIU4VYwhLvW7X0KkTAm4oSnXohpA6hnAkq8nd1eB8sQV4KeTK9cowfIHyGdFK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788497216; c=relaxed/simple;
	bh=6QaXqzvy4fOyQUYzn5Jb5QYwLipI/02Z5mT+ns+ZJGY=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nuBRduWDPjSBnJBJObBkJUhUOQctZBabzXaQE+LSjS/ODCkP/SZULNSRctMOQD0g5dduGihHtOhieuE/A98CA98K4jtURAc6KixziY3umtGS0BAdq83j6WwdsWGiv5JTykKNYxI99yLlbl8p9lZYdWPLgb8Oj5m8H+aL9rsm29Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ezyylc34; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ezyylc34"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E561F00A3E;
	Fri,  4 Sep 2026 04:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788497208;
	bh=XeHOhlquQFW7UEGANg5YhjOBiv+si49UrUHi497WpQo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ezyylc346iZY5AFi8Vee80r3Dlyt1eSSx24/B/yt8kCZIAxwlhx/I4OgFibpPhB5K
	 nMz4izbCxWp4KJ2ueUXzzqx9nYuSVUPpxb19eQgoliGZFiJj4YKVuows3gF1+gP+se
	 oNOzpqii8aFGH0hJgFMry4HoPSV+1I9OE1zv0FeYD3D4hdFEOX9Edioj4SZYhhKlBU
	 nB2RHc9i+k98iAtaBRwVzBUugL7XJGZ+10SPNgV8qsriDu6JK7wu/50lNTz0/w7BKt
	 8QdHxBpWFxS7WEa+aJwid9KdgmUHJCxMrEgXUX9X2MO5VahTPFDy+M4wutkPO+u0SC
	 MSZjVjJOonSgw==
Subject:
 Re: [PATCH net-next v3 06/13] net: mana: swap queue sets in mana_change_mtu
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
Date: Fri, 04 Sep 2026 04:46:46 +0000
Message-ID: <178849720665.4131868.15282701493753909076@kernel.org>
In-Reply-To: <20260901014442.2945689-7-longli@microsoft.com>
References: <20260901014442.2945689-7-longli@microsoft.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 1 · Low: 0

- [Medium] `mana_change_mtu()` now builds a complete second queue set —
  `mana_alloc_qset()` → `mana_create_txq()` + `mana_add_rx_queues()` on…

--

net: mana: swap queue sets in mana_change_mtu

The MTU becomes part of the queue-set configuration, so mana_change_mtu()
now pre-allocates a new queue set for the new MTU while the running set
still serves traffic. ndev->mtu is published in mana_publish_qset() once
the new set is live, instead of being written before mana_attach() and
rolled back on failure.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 880a3ba37fd3e..2c5aa5e5d1a11 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -917,35 +917,49 @@ int mana_pre_alloc_rxbufs(struct mana_port_context *mpc, int new_mtu, int num_qu
>  	return -ENOMEM;
>  }
>  
> +/* ndev->mtu is updated only once the new set is live (mana_publish_qset), so
> + * a failed allocation leaves the queues and the advertised MTU untouched.
> + */
>  static int mana_change_mtu(struct net_device *ndev, int new_mtu)
>  {
>  	struct mana_port_context *mpc = netdev_priv(ndev);
> -	unsigned int old_mtu = ndev->mtu;
> +	struct mana_port_context *scratch;
> +	struct mana_qset newq, oldq;
>  	int err;
>  
> -	/* Pre-allocate buffers to prevent failure in mana_attach later */
> -	err = mana_pre_alloc_rxbufs(mpc, new_mtu, mpc->num_queues);
> -	if (err) {
> -		netdev_err(ndev, "Insufficient memory for new MTU\n");
> -		return err;
> +	/* Port is down: no queues to rebuild, just record the new MTU.
> +	 * mana_open() will size the RX buffers accordingly.
> +	 */
> +	if (!mpc->port_is_up) {
> +		mpc->configured_mtu = new_mtu;
> +		WRITE_ONCE(ndev->mtu, new_mtu);
> +		return 0;
>  	}
>  
> -	err = mana_detach(ndev, false);
> -	if (err) {
> -		netdev_err(ndev, "mana_detach failed: %d\n", err);
> -		goto out;
> -	}
> +	scratch = mana_qset_scratch_alloc(mpc);
> +	if (!scratch)
> +		return -ENOMEM;
>  
> -	WRITE_ONCE(ndev->mtu, new_mtu);
> +	err = mana_alloc_qset(mpc, scratch, mpc->num_queues,
> +			      mpc->rx_queue_size, mpc->tx_queue_size,
> +			      mpc->priv_flags, new_mtu, &newq);
> +	if (err)
> +		goto free_scratch; /* current qset and ndev->mtu untouched */

[Severity: Medium]
Can an MTU change now be refused at high channel counts where the old
detach-then-attach sequence succeeded?

mana_alloc_qset() here builds a complete second set on the scratch
context, mana_alloc_qset()->mana_create_txq() plus
mana_alloc_qset()->mana_add_rx_queues(), so num_queues firmware SQ/RQ WQ
objects and their CQs come into existence while apc->tx_qp[] and
apc->rxqs[] still own theirs on the same vport. The transient peak is
2 * num_queues SQ/RQ objects, and twice the CQ count against
gc->max_num_cqs / gc->cq_table.

mana_init_port() clamps the ceiling to what the vport actually offers:

	max_queues = min_t(u32, max_txq, max_rxq);
	if (apc->max_queues > max_queues)
		apc->max_queues = max_queues;
	if (apc->max_queues > gc->max_num_queues_vport)
		apc->max_queues = gc->max_num_queues_vport;

and mana_set_channels() permits num_queues to reach that ceiling:

	if (new_count < 1 || new_count > apc->max_queues) {

So after "ethtool -L ens1 combined <max_queues>", does
"ip link set dev ens1 mtu 9000" ask the firmware for one more SQ/RQ than
the vport advertises? The RX-side DMA footprint doubles for the same
window as well.

The design comment this series adds ahead of mana_qset_snapshot() says
exactly that:

 * and the vport is never torn down, so RDMA cannot take it mid-swap. The cost
 * is room for both sets at once, so a rebuild at the vport's maximum queue
 * count can be refused; EQs are shared from a port-owned pool, not doubled.

The later patch "net: mana: keep the existing queues when the channel
count is raised" avoids that peak for the channel-count path by carrying
the existing queues over, but the MTU path still allocates a full second
set, both here and at the end of the series (bf2a8b43). Would it be worth
either applying a similar mitigation here or noting the new peak in the
changelog?

Failure itself looks graceful: mana_alloc_qset() tears down its partial
set and the live queues and ndev->mtu are untouched, so the visible
effect is the MTU change returning an error.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260901014442.2945689-1-longli%40microsoft.com
