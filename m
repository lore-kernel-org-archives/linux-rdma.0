Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED309488741;
	Thu, 10 Sep 2026 12:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789044386; cv=none; b=UgEkugsPM5AYrq5zbTgM3b5ZpjeOwuG7QZA2VVN4HsvpSdKdXdyXKN007tONZPbG8EvBYhujEMNt6bEG4S9es606TX9FV4yxA9flJQdjepkje2igcfWMiaCsKTL/kbrvPzt9EuuA2d4ft4K+WeGHIywATs87aMp83I44lB7O7ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789044386; c=relaxed/simple;
	bh=PPTZOOwrBo0xAyIDhPi/8KGdNalSXPAwU0S7x0iveAk=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Wg/S4xz1eTSb3tqDPxR8KgzzLc1Ii/zQwZxm/TZD1xaXTZPytuxCsIjMig4+RvyZoYlf1+sn42wKvSXHZZUNjdfR8J9iZzm2OMV7/BAsCG2fxRHNH5Cs9oa7sLd4vjj6A7WO02+y+ffmah+VEPwJ1cOMUeyccstS5wj08lzQy5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=axfB2bZy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="axfB2bZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC291F00893;
	Thu, 10 Sep 2026 12:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789044382;
	bh=cwYOsc4JExSInv+TOcwbAh1z0HVTWDEwXBC25sOTT0c=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=axfB2bZyHV7N1y//Ra/oW2XdwWi9t7ABVh4HMe62P6CtbN+BxWHARB9uSWl4rpWRM
	 raXjBezauUqkMPDZGtBkCbKoci0a7yzzIbv8rbkpdtYiMsd4C52XwAfKfoagYVRXjt
	 lGKgM9XHJX0wcwT5aFYLAqSxyhJnb5FxSenEIm2QvI//lMOGxJuvAc6P/XeI9tOIMt
	 XXRm3hofUJofDMZjrseh026Rm8SFPcbrJSljRX8sZzZWtoV1yT1CuBXZ7BxHKqoN/R
	 JwDK1+Iv2FT0nTtEDYwHhdVkiYg2IbFGUqDtd+CmqwkXPl22BSMyOSp3nf16kzE6xP
	 oxaSOS7LhqO1w==
Subject: Re: [PATCH net] net: mana: do not discard an ethtool-configured RSS
 table on a queue rebuild
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
Date: Thu, 10 Sep 2026 12:46:20 +0000
Message-ID: <178904438067.219967.6198285642265210218@kernel.org>
In-Reply-To: <20260905004401.3937066-1-longli@microsoft.com>
References: <20260905004401.3937066-1-longli@microsoft.com>
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

Critical: 0 · High: 0 · Medium: 1 · Low: 2 (1)

- [Medium] Undisclosed TX-side consequence of preserving the indirection
  table.
- [Low] The commit message states: "The driver never clears the core's
  IFF_RXFH_CONFIGURED, so netif_is_rxfh_configured() keeps reporting a…
- [Low] When the surviving table cannot be honoured (an entry >=
  apc->num_queues after mana_init_port() lowered the queue count),…

Pre-existing issues:
- [Low] Incomplete lockset for apc->indir_table on the ethtool read side.

--

net: mana: do not discard an ethtool-configured RSS table on a queue rebuild

mana_alloc_queues() no longer regenerates the RSS indirection table from the
driver default when the table was installed by the user, so an "ethtool -X"
table now survives operations that rebuild the queues.  A table whose
entries point past the last queue is still replaced by the default.  The RSS
ethtool operations are also opted into rtnl_lock() via
ETHTOOL_OP_NEEDS_RTNL_RSS.

A couple of questions about the commit message and the new code below.

>     The driver never clears the core's IFF_RXFH_CONFIGURED, so
>     netif_is_rxfh_configured() keeps reporting a user table while the
>     hardware has been reprogrammed with the default one.

[Severity: Low]
Is IFF_RXFH_CONFIGURED still the right name here?  A tree-wide grep for
IFF_RXFH_CONFIGURED at this commit returns nothing.  The state that
netif_is_rxfh_configured() consults is now:

net/ethtool/common.c:
bool netif_is_rxfh_configured(const struct net_device *dev)
{
	return dev->ethtool->rss_indir_user_size;
}

set and cleared by the core in net/ethtool/rss.c and net/ethtool/ioctl.c.
The mechanism described matches, only the symbol name looks stale.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 45a7520491a65..396b741fa86ed 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -3310,6 +3310,28 @@ static void mana_rss_table_init(struct mana_port_context *apc)
>  			ethtool_rxfh_indir_default(i, apc->num_queues);
>  }
>  
> +/* Whether the current indirection table can be kept for apc->num_queues,
> + * rather than rebuilt from the driver default.
> + *
> + * Only a user table ("ethtool -X") is worth keeping; a driver-generated one
> + * is rebuilt so that it spreads over every queue. An entry pointing past the
> + * last queue cannot be kept: mana_config_rss() uses these entries to index
> + * apc->rxqs[], which holds apc->num_queues pointers.
> + */
> +static bool mana_rss_table_keep(struct mana_port_context *apc)
> +{
> +	u32 i;
> +
> +	if (!netif_is_rxfh_configured(apc->ndev))
> +		return false;
> +
> +	for (i = 0; i < apc->indir_table_sz; i++)
> +		if (apc->indir_table[i] >= apc->num_queues)
> +			return false;
> +
> +	return true;
> +}

[Severity: Medium]
Does keeping the table also pin the TX side?  In this driver
apc->indir_table selects the transmit queue too:

mana_en.c:mana_get_tx_queue() {
	...
	txq = apc->indir_table[hash & (apc->indir_table_sz - 1)];
	...
}

reached from mana_select_queue(), and the struct member itself is commented
"Indirection Table for RX & TX" in include/net/mana/mana.h.

Before this change every rebuild ran mana_rss_table_init() and restored
index % num_queues, so this sequence ended up with both RX and TX spread
over all 16 queues:

	ethtool -X ens1 equal 2
	ethtool -L ens1 combined 16

After the change mana_rss_table_keep() returns true, since every entry (0
and 1) is below the new apc->num_queues of 16, so the two-entry table
survives mana_set_channels() -> mana_attach() -> mana_alloc_queues().
netif_set_real_num_tx_queues() then publishes 16 TX queues while
mana_get_tx_queue() can only ever return 0 or 1.

The changelog lists the rebuild paths that are affected but describes the
change purely in terms of the RSS indirection table.  Would it be worth
mentioning that TX queue selection becomes sticky in the same way?

> @@ -3625,7 +3647,20 @@ int mana_alloc_queues(struct net_device *ndev)
>  		goto destroy_rxq;
>  	}
>  
> -	mana_rss_table_init(apc);
> +	/* Keep a user-configured table across the rebuild: its entries are
> +	 * queue indices and stay meaningful while they are all still in range.
> +	 * Only a driver-generated table is regenerated here.
> +	 *
> +	 * A table that cannot be kept is replaced by the default without
> +	 * telling the core, which keeps reporting the table as user
> +	 * configured. That is what this function did for every table before,
> +	 * and reporting it here is not an option: ethtool_rxfh_indir_lost()
> +	 * sends ETHTOOL_MSG_RSS_NTF, which requires the netdev instance lock,
> +	 * and this runs both with that lock held (ndo_open) and without it
> +	 * (mana_attach() from the reset and resume paths).
> +	 */
> +	if (!mana_rss_table_keep(apc))
> +		mana_rss_table_init(apc);

[Severity: Low]
This is the acknowledged case, so mostly a question about whether it can be
narrowed rather than a new problem.

When mana_attach() -> mana_init_port() lowers apc->num_queues and an entry
falls out of range, this branch installs the driver default while
dev->ethtool->rss_indir_user_size stays set, so netif_is_rxfh_configured()
and "ethtool -x" keep advertising a user table the user never installed.

The stated reason for skipping ethtool_rxfh_indir_lost() does hold up: its
own assert accepts RTNL,

net/ethtool/common.c:ethtool_rxfh_indir_lost() {
	WARN_ONCE(!rtnl_is_locked() &&
		  !lockdep_is_held_type(&dev->ethtool->rss_lock, -1),
		  "RSS context lock assertion failed\n");
	...
	dev->ethtool->rss_indir_user_size = 0;
	ethtool_rss_notify(dev, ETHTOOL_MSG_RSS_NTF, 0);
}

but the notification lands in ethnl_notify(), which runs
netdev_assert_locked_ops_compat(dev).  mana registers net_shaper_ops, so
with CONFIG_NET_SHAPER=y that reduces to lockdep_assert_held(&dev->lock),
which the rtnl-only reset and resume paths do not hold.

Is there a way to reach the same result without the notification, so that
the core's view and the programmed table agree in this case?

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> index ece7ff9cc409a..e3acaf17efabc 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
> @@ -871,7 +871,8 @@ const struct ethtool_ops mana_ethtool_ops = {
>  	.op_needs_rtnl		= ETHTOOL_OP_NEEDS_RTNL_SCHANNELS |
>  				  ETHTOOL_OP_NEEDS_RTNL_SRINGPARAM |
>  				  ETHTOOL_OP_NEEDS_RTNL_SPFLAGS |
> -				  ETHTOOL_OP_NEEDS_RTNL_GLINK,
> +				  ETHTOOL_OP_NEEDS_RTNL_GLINK |
> +				  ETHTOOL_OP_NEEDS_RTNL_RSS,

[Severity: Low]
This isn't a problem introduced by this patch, but does the new flag cover
the read side as well?

The core only consults ETHTOOL_OP_NEEDS_RTNL_RSS for ETHTOOL_MSG_RSS_SET
and for the SRSSH / SRXFH / SRXFHINDIR ioctls:

net/ethtool/common.h:
	case ETHTOOL_MSG_RSS_SET:
		return ops->op_needs_rtnl & ETHTOOL_OP_NEEDS_RTNL_RSS;

so mana_get_rxfh() still runs with the netdev instance lock plus rss_lock
only, while the rebuild writes the same array entry by entry holding RTNL
alone when it comes from mana_attach():

mana_en.c:mana_rss_table_init() {
	for (i = 0; i < apc->indir_table_sz; i++)
		apc->indir_table[i] =
			ethtool_rxfh_indir_default(i, apc->num_queues);
}

CPU0: mana_per_port_queue_reset_work_handler() -> rtnl_lock() ->
      mana_attach() -> mana_alloc_queues() -> mana_rss_table_init()
CPU1: ethtool -x -> rss_prepare_get() -> mana_get_rxfh()

Can "ethtool -x" print a mix of old and new entries in that window?  The
hardware itself is programmed from the driver copy by mana_config_rss(), so
this looks limited to the reported table.  The write/read race the patch set
out to close on the set side does get closed by the new flag.

For what it is worth, the freed-table variant of this does not appear to
exist: mana_attach()'s failure path calls mana_cleanup_port_context(), which
only frees apc->rxqs and the debugfs dentry, and mana_cleanup_indir_table()
is only reached from mana_probe_port() before register_netdev() and from
mana_remove() after unregister_netdevice().

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260905004401.3937066-1-longli%40microsoft.com
