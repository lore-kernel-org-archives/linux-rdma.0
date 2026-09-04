Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321EC40B0F7;
	Fri,  4 Sep 2026 04:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788497222; cv=none; b=uGL+lENnkZgQqFn+OrATyBdsfOKotyorT277v1Ye8/35RqiHWx8lE5Y0PBG+SdZB2LXPdRjEGQJGv+6yliKb2MuE18oUHqr3qhlY7+1/Y46Cd6taKiAXuux5241i+9ZA3tLI3b/B4zKfd17FVO/V2/YIrlDzLb9mruJavEDAUJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788497222; c=relaxed/simple;
	bh=Ifu4+1U98z+2NuAZCZKtUkVz/xvsI50uK4KQ7FNqHlU=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uT4ixRBDSr8s2LivB9T4zN0KL9MuFXA0i9jX90ZP+NOjRrRUEGvGuRW4n7N6KW0VH5Q9NXqz26GGBDswFZFBsR4gPG3gJ3BIzxPnPkLSZQqNUWf4QRebGgFDwnz2iAL8bZFZOl/Ee9pgUpBEXqV8Ufgh8A9OgLArjz9QbQVNwEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QhuQPxB7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QhuQPxB7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40971F00ACF;
	Fri,  4 Sep 2026 04:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788497216;
	bh=F2GiotPcOhKO759+SeFyJe8VEBH1J78CNf5rqAoLHQQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=QhuQPxB7IOc+3G3Xj1JazfJwYRa37lkAh3EBEucICUpHMseu/uKb+JwB5q/VEgu/U
	 ssp4O/j+HjM62JXJm0KU2n0v7ielHLCRQzvIAU26IoRRQCARXy5AowQSw7vXO/Qux4
	 nM8k6qzVGy1srTQmF0H3fpuwFrvMuH3qCExrUEQ9KLZNXmJibWveDaMrhaFcnd3prH
	 iMEqJgOgdjFa3uoi0kxXpGscVHSrSFwS+fulRNuPc/zQBE/T24LJiIoVjUEinAjniz
	 JlhqZC6qaDHCVpTrd5O6tZTYGlwyrDdoCgAQGIRxxwLu5S9LdOZ7kpJJtfiye8F6gq
	 jSlZA1yUOjYxg==
Subject: Re: [PATCH net-next v3 11/13] net: mana: keep a user-configured RSS
 table across a queue rebuild
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
Date: Fri, 04 Sep 2026 04:46:55 +0000
Message-ID: <178849721538.4131868.12369566910595448575@kernel.org>
In-Reply-To: <20260901014442.2945689-12-longli@microsoft.com>
References: <20260901014442.2945689-12-longli@microsoft.com>
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

- [Medium] In mana_alloc_queues() the loss is reported before the driver
  state it describes is updated: ethtool_rxfh_indir_lost(ndev) is called…
- [Low] Commit message and the in-code comment describe a narrower rule
  than the code implements.
- [Low] The patch is a user-visible bug fix (a user-installed `ethtool
  -X` indirection table was silently replaced by the driver default on…

--

net: mana: keep a user-configured RSS table across a queue rebuild

The patch stops mana from unconditionally regenerating the RSS indirection
table when the queues are rebuilt, so a table installed with "ethtool -X"
survives a reconfiguration.  A table that cannot be applied to the new
queue count is reported to the core with ethtool_rxfh_indir_lost(), and for
the swap path that report is deferred until the new set is live.

A couple of questions below about the described condition, the missing
Fixes: tag, and the ordering of the loss report in mana_alloc_queues().

> Carry it over instead when the queue count is unchanged: the entries are
> queue indices, so they stay meaningful.

[Severity: Low]
Is "when the queue count is unchanged" the condition the code actually
implements?  mana_rss_table_keep() tests netif_is_rxfh_configured() plus a
per-entry bounds check against the requested count:

	if (!netif_is_rxfh_configured(apc->ndev))
		return false;

	for (i = 0; i < apc->indir_table_sz; i++) {
		if (apc->indir_table[i] >= num_queues) {

and mana_alloc_qset() passes the new count, which mana_set_channels() only
reaches when new_count differs from apc->num_queues.

So "ethtool -L" also carries a user table over now instead of rebuilding
it.  Growing 4 -> 8 combined channels leaves every old entry in range, the
table is copied verbatim, and the four new RX queues get no steered
traffic.  mana_get_tx_queue() indexes apc->indir_table[] too, so the new TX
queues stay unused as well until the user re-runs "ethtool -X".

The semantics match what other drivers do (ice, mlx5, bnxt, idpf and others
skip default regeneration when netif_is_rxfh_configured() is set), so could
the changelog state the real predicate (entries still in range for the new
count) and mention the "ethtool -L" effect?

[Severity: Low]
Should this carry a Fixes: tag?  In the baseline tree mana_alloc_queues()
called mana_rss_table_init(apc) unconditionally, so every detach/attach
cycle (reset recovery, resume, MTU/ringparam/channel/priv-flag/XDP
reconfiguration) overwrote apc->indir_table with the driver default while
the core kept IFF_RXFH_CONFIGURED set, since netif_is_rxfh_configured()
reads dev->ethtool->rss_indir_user_size and the driver never cleared it.

That is a user-visible loss of configuration, which makes this part a fix.
The unconditional initialization came in with ca9c54d2d6a5 ("net: mana: Add
a driver for Microsoft Azure Network Adapter (MANA)"), which also added
mana_set_rxfh().  Would a Fixes: trailer, or splitting the
mana_alloc_queues() change out as a standalone fix, be appropriate here?

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 2295769da0306..6769faada11bc 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c

[ ... ]

> @@ -3949,7 +3982,18 @@ int mana_alloc_queues(struct net_device *ndev)
>  		goto destroy_rxq;
>  	}
>  
> -	mana_rss_table_init(apc);
> +	/* Keep a user-configured RSS table across a rebuild; the entries are
> +	 * queue indices, so they stay meaningful as long as the queue count
> +	 * is unchanged. Only a driver-generated table is regenerated here.
> +	 *
> +	 * Nothing to roll back to here, so report the loss as soon as it is
> +	 * decided and keep the table and the core's view of it in step.
> +	 */
> +	if (!mana_rss_table_keep(apc, apc->num_queues, &indir_lost)) {
> +		if (indir_lost)
> +			ethtool_rxfh_indir_lost(ndev);
> +		mana_rss_table_init(apc);
> +	}

[Severity: Medium]
Can this report the wrong table to userspace?  ethtool_rxfh_indir_lost() is
not just a flag clear:

net/ethtool/common.c:ethtool_rxfh_indir_lost() {
	...
	dev->ethtool->rss_indir_user_size = 0;
	ethtool_rss_notify(dev, ETHTOOL_MSG_RSS_NTF, 0);
	...
}

That notification re-enters the driver synchronously:

ethtool_rss_notify()->ethnl_notify()->ethnl_default_notify()->
  rss_prepare_data()->rss_prepare()->rss_prepare_get()

net/ethtool/rss.c:rss_prepare_get() {
	...
	ret = ops->get_rxfh(dev, &rxfh);
	...
}

and mana_get_rxfh() copies apc->indir_table[] verbatim.  At that point
mana_rss_table_init(apc) has not run yet, so the broadcast RSS_NTF carries
the table that mana_rss_table_keep() just rejected (it has at least one
entry >= apc->num_queues), and mana_config_rss() has not programmed
anything.  No further notification is emitted once the default table is
installed, so a listener caching notification state keeps the discarded
table.

Reachable in the documented case: mana_init_port() clamps apc->num_queues
down to a smaller device-reported max after a reset, and a user table with
a higher entry then makes mana_rss_table_keep() set *lost.

Would swapping the two statements, so the loss is reported after
mana_rss_table_init(apc), be better?  That matches the ordering of the
other new call site, which reports only once the new set is live:

	if (newq->rxfh_indir_lost)
		ethtool_rxfh_indir_lost(ndev);

>  
>  	err = mana_config_rss(apc, TRI_STATE_TRUE, true, true);
>  	if (err) {

[ ... ]

> @@ -4333,9 +4382,19 @@ int mana_alloc_qset(struct mana_port_context *apc,
>  	if (err)
>  		goto cleanup_rxq;
>  
> -	mana_rss_table_init(scratch);
> +	/* Carry a user-configured RSS table over to the new set. The entries
> +	 * are queue indices, so mana_config_rss() in mana_publish_qset() maps
> +	 * them onto the new set's RX objects. A driver-generated table is
> +	 * rebuilt instead, so it covers every queue of the new set.
> +	 */
> +	if (mana_rss_table_keep(apc, num_queues, &indir_lost))
> +		memcpy(scratch->indir_table, apc->indir_table,
> +		       apc->indir_table_sz * sizeof(*apc->indir_table));
> +	else
> +		mana_rss_table_init(scratch);
>  
>  	mana_qset_snapshot(scratch, out);
> +	out->rxfh_indir_lost = indir_lost;
>  	return 0;

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260901014442.2945689-1-longli%40microsoft.com
