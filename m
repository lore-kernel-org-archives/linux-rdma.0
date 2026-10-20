Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792514936;
	b=xLtFXf5jG+ePqCjWIU4cTflfY0GpdBRwJKmV3WgZFWP2vLJw4ZaBTQsg6k/r3dqWnhnh
	 NawrUJZGxhkZOhjHj9WeJPvW0f2xFeaGgcVkxAOwvrgZDpuMMxwxrnHC9QgABUiTFxOy1
	 oDhg2esp6aATrWCNysWHfuaeJzm8Vlsen9wBgscX37ZGJqtZ/VDPx/NchKUwZeeIxqGxv
	 7AQ7WAsBGH90FziBGAM7O3KX9P4JW7aUQYty5VEWnTgflNWiWforpfPdpXlqhW1nlOOnn
	 DQJOS7osrhr7BjAjYZ4XAOWtJz1Awj0+TmnIRqLAQKOhKtZg7FCyhBjiTx2ggYJ2frg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792514936;
	h=Received:Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 X-sashiko-severity:Content-Type:Content-Transfer-Encoding:
	 MIME-Version;
	bh=dEPBoh5eatFrlNajXHLKC32XKu7ihCvs7f0OiCqPty8=;
	b=gAXNwn2PhzxwCcBJEaEQxli4AN0Y0PWQa8ivSNo+Le2+a1/TvEYQGEf1yrTkqzthK9GW
	 /GWyJEX//zPYEtTleLZ7X+47s4q6QpOIYHpKG3/v/wjDvnwFBkMBFmtk57ygtjZdSgGKo
	 puxweaeFaGMBZDeCzFm4AQXHl5IjGKiJe1QVPNG1dY8r0ml9NuPMjAsYzosFcVsSa3k+Z
	 sYs+TIb7c0yjjpucOedZhkSAsMP2apOGQPgnPR0+d58tEHsrHJiqW1mYc7MFsO1n9Gnak
	 wKUAnZvIh5LDb4JCUVYJU09mVHv0yaNikin4MrPGVWIixj6dmlcLe9YuTcZUsml+H+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4F6606D54E;
	Tue, 20 Oct 2026 16:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F68C1F0157E;
	Tue, 20 Oct 2026 16:48:54 +0000 (UTC)
Subject: Re: [PATCH net-next v7 11/13] net: mana: keep a user-configured RSS
 table across a queue rebuild
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
Date: Tue, 20 Oct 2026 16:48:23 +0000
Message-ID: <179251490382.3135.11269934246103660165@kernel.org>
In-Reply-To: =?utf-8?q?=3Ce3a74aa4b30eb004c9a9f16168b734c563f27a15=2E1791710?=
 =?utf-8?q?735=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
References: =?utf-8?q?=3Ce3a74aa4b30eb004c9a9f16168b734c563f27a15=2E17917107?=
 =?utf-8?q?35=2Egit=2Eweh=40linux=2Emicrosoft=2Ecom=3E?=
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

- [Medium] In mana_alloc_queues()
  (drivers/net/ethernet/microsoft/mana/mana_en.c:3961-3963),…
- [Low] The publish-time loss notification added by this patch can never
  fire.
- [Low] Before this patch, mana_alloc_queues() and mana_alloc_qset()
  called mana_rss_table_init() unconditionally.
- [Low] The patch deletes the comment `/* Vport identity and port debugfs
  outlive queue sets.

--

net: mana: keep a user-configured RSS table across a queue rebuild

This commit keeps a user-configured RSS indirection table across queue
rebuilds when every entry is valid for the new queue count. Otherwise it
regenerates the driver default table. A lost user table is reported
through ethtool_rxfh_indir_lost() after a queue set is published, and
RSS setters now require RTNL.

> Preserve a user RSS table whenever all entries fit the requested queue
> count. Regenerate driver defaults. On growth, a retained user table does
> not steer RSS traffic to the added queues until the user updates it.

[Severity: Low]
This isn't a bug, but before this patch mana_alloc_queues() and
mana_alloc_qset() both called mana_rss_table_init() unconditionally.
That dropped a user "ethtool -X" table on every rebuild (down/up,
reset/resume, MTU, ring, priv-flag and XDP changes), while the core's
rss_indir_user_size stayed set.

Since this fixes a bug users can see, should the commit message say so
and carry a Fixes: tag?

The message also doesn't mention that adding ETHTOOL_OP_NEEDS_RTNL_RSS is
part of the fix. It doesn't mention the dependency on the earlier
queue-set swap patches either.

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 2aa18cb10d902..7cf7ce9bfa28c 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c

[ ... ]

> @@ -3936,7 +3958,9 @@ int mana_alloc_queues(struct net_device *ndev)
>  		goto destroy_rxq;
>  	}
>  
> -	mana_rss_table_init(apc);
> +	/* Loss notification needs a netdev instance lock we may lack. */
> +	if (!mana_rss_table_keep(apc, apc->num_queues, &indir_lost))
> +		mana_rss_table_init(apc);

[Severity: Medium]
When mana_rss_table_keep() sets indir_lost here, the value is thrown away
and ethtool_rxfh_indir_lost() is never called. Doesn't that leave
dev->ethtool->rss_indir_user_size set? If so, netif_is_rxfh_configured()
keeps returning true for what is now the driver default table.

This looks like the one loss path that can actually be reached. On reset
or resume, mana_attach()->mana_init_port() queries the vPort again and
clamps the queue count:

	if (apc->num_queues > apc->max_queues)
		apc->num_queues = apc->max_queues;

On resume, gc->max_num_queues_vport is also recomputed in
mana_gd_setup()->mana_gd_query_max_resources() from num_online_cpus()
and the MSI-X count. If the port was down during the reset, the same loss
happens later in mana_open()->mana_alloc_queues(), which also drops
indir_lost.

The kernel-doc for ethtool_rxfh_indir_lost() describes this exact case
("typically after a HW fault recovery that reduced the maximum queue
count"). The helper also clears the configured state, not just sends a
notification:

	dev->ethtool->rss_indir_user_size = 0;
	ethtool_rss_notify(dev, ETHTOOL_MSG_RSS_NTF, 0);

With the configured flag left set, ethtool_get_max_rxfh_channel() reads
the regenerated default table, and that table spans every queue.
ethtool_check_max_channel() would then reject every later channel
reduction with -EINVAL until the user runs "ethtool -X <dev> default".
Later rebuilds would also accept the defaults as a user table in
mana_rss_table_keep(), and no ETHTOOL_MSG_RSS_NTF is ever sent.

The comment is right that the netdev instance lock may not be held here.
mana_per_port_queue_reset_work_handler() holds only RTNL, and the resume
loop in mana_probe() drops netdev_lock() just before mana_attach().

Could mana_alloc_queues()/mana_attach() return or record the lost state
instead? Callers could then call ethtool_rxfh_indir_lost() under RTNL
plus netdev_lock(), as mlx5e_attach_netdev() does. mana_open() already
holds both locks and could report the loss directly.

The commit message says this path "replaces invalid tables silently". It
doesn't mention that the core's configured state is left stale. The
indir_lost value still appears to be dropped at this call site at the end
of the series.

>  
>  	err = mana_config_rss(apc, TRI_STATE_TRUE, true, true);
>  	if (err) {
> @@ -4094,9 +4118,10 @@ static void mana_qset_snapshot(const struct mana_port_context *ctx,
>  	out->priv_flags		= ctx->priv_flags;
>  	out->mtu		= ctx->configured_mtu;
>  	out->bpf_prog		= ctx->bpf_prog;
> +
> +	out->rxfh_indir_lost	= false;
>  }
>  
> -/* Vport identity and port debugfs outlive queue sets. */
>  static void mana_qset_install(struct mana_port_context *ctx,
>  			      const struct mana_qset *qset)

[Severity: Low]
This isn't a bug, but was this comment meant to be removed? The change
looks unrelated to keeping the RSS table, and the commit message doesn't
mention it.

The comment explains why mana_qset_install() leaves port_handle, the MAC
address and mana_port_debugfs alone. The function still works that way,
and the comment isn't added back later in the series.

[ ... ]

> @@ -4432,6 +4463,10 @@ int mana_publish_qset(struct mana_port_context *apc, struct mana_qset *newq,
>  	WRITE_ONCE(apc->port_is_up, true);
>  	mana_start_txqs(apc);
>  
> +	/* Report a lost user table only after successful publication. */
> +	if (newq->rxfh_indir_lost)
> +		ethtool_rxfh_indir_lost(ndev);

[Severity: Low]
Can newq->rxfh_indir_lost ever be true here?

mana_change_mtu(), mana_set_ringparam(), mana_set_priv_flags() and
mana_xdp_set() all rebuild at the current num_queues. At that count the
live table is already valid: mana_set_rxfh() rejects entries >=
num_queues, and mana_alloc_queues() regenerates invalid tables.

mana_set_channels() is the only path that changes the count. Both the
netlink and ioctl set-channels handlers call ethtool_check_max_channel()
before the driver runs:

	max_rxfh_in_use = ethtool_get_max_rxfh_channel(dev);
	if (channels.combined_count + channels.rx_count <= max_rxfh_in_use) {

That check rejects any count that would invalidate a user-configured
table. So it seems mana_rss_table_keep() can never report a loss on the
swap path. The same is true for mana_split_qset() and mana_grow_qset()
later in the series.

If that's right, the rxfh_indir_lost field and this call cover a case
that can't happen. Meanwhile the loss that can happen, in
mana_alloc_queues(), is never reported. Should the commit message
sentence "Report table loss only after successful queue-set publication"
be reworded, or this code dropped?

>  
>  	return 0;
>  
>  rollback:

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1791710735.git.weh%40linux.microsoft.com
