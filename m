Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795818738;
	b=mAu+JviCZ5H5jKdoWgobbhtxt6WmbYe+hwdunvkjUta0Np3/dwrCO4gpTJjRXqlBMOq1
	 ayjkQUmQip09XL6s4cdIZlccM/EpNStz2xeZbqkROwZOfYAfRdeyyokljjSvmcP9cL6f7
	 cFGeGB3yQgiN2hpk4exZBfUVD0JllQE6fJA4R0Y9SouMSvmfQmrlUe+9Fsfy1xzYCuAYE
	 7+HxxNUGBzXYymlxMig0hOl0at46P40aBdSDhR1VyOxr2lho32HbbmbDniACbthPDDiKd
	 zwnsfbcEFqEda7UKUg9scHDZ7eM9nyqiaUa7npVStb47inVrGVXly0PiTYXhrXJHqPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795818738;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Uy3i8hRJJm8f7lYjXs5CtnhHjt88mvlRID2CRQj4Jgs=;
	b=t1xItxZhBlH+SaPom2nKCHhElpykBAxf6i/pjSP3DXLKycpBt/YBOHd0N8VG98G1DEoy
	 19lyV4S3tEL8KJjIAjn47ryyECVfVWu8ZYritbk7Wtseb/cetZlG4+Zjb8UBRPS8LWSOP
	 3GEj2PkZ5Jqz0sQ+HIItZIhuWXGgX1OsvNMO+O6PzgGln52SwrplBuKHwoTYKAKpSl646
	 BFkxUNwAlANDcfWbwLbwSLfRXzvmtpMHu/CseGwCWUJyZTATeG7lBRY0Rl1yiaM6Xz35K
	 QxRAdJ6wv24KHTF3MXBhXS7DpswIKlQYZnIUPEcOOTLBsxkfWSYZL64yKlnnVPRjCpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hm7FCe3H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FB9606A31E;
	Fri, 27 Nov 2026 22:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hm7FCe3H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD0A1F00924;
	Fri, 27 Nov 2026 22:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795818737;
	bh=Uy3i8hRJJm8f7lYjXs5CtnhHjt88mvlRID2CRQj4Jgs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=hm7FCe3HTOWDXcyZNYiW66bk/NQGIp82cY6sGUIjnwzSIPwvc8+SsWMk8yUrBAJy9
	 3psQfYtCglb6p9u7Ur6ex0+TW9+tLeFfQff24prUlRKGVGXmEcHyqBeGpTj65lIdhi
	 MCL33DwVvkInRjIWwBm71vs9WuH9g0ui8R9XlG+bXu5tGhJc/4ItGt+Frvr0MhQ3Q5
	 NqtyV9uYSSX/JQIHrFI7TAR1NusU8b/UfUtxHCINTMLy5WZBStGab1y0OjLHHmzgjA
	 0Avz9vidcz0bvNzoPnU5Mj5VQ/u7DvUnw3iq4u/fTi4GG6OJ4E+Ph3hiNjqQEXFwlw
	 F7AA9B3WkxSDg==
Subject: Re: [PATCH net 08/10] net/mlx5e: Validate neighbour events before
 updating IPsec SAs
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 willemb@google.com, parri.andrea@gmail.com, borisp@nvidia.com,
 cratiu@nvidia.com, eedmunds@nvidia.com, gal@nvidia.com, jmassar@nvidia.com,
 jianbol@nvidia.com, kuniyu@google.com, leon@kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, phaddad@nvidia.com,
 raeds@nvidia.com, saeedm@nvidia.com, horms@kernel.org,
 sridhar.samudrala@intel.com, steffen.klassert@secunet.com
Date: Fri, 27 Nov 2026 22:32:15 +0000
Message-ID: <179581873585.3135.8443874889177753516@kernel.org>
In-Reply-To: <20261126215614.792598-9-tariqt@nvidia.com>
References: <20261126215614.792598-9-tariqt@nvidia.com>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 (1) · Low: 0 (1)

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] With nh.ifindex == 0, a foreign neighbour on any device in the
  same netns can still overwrite the hardware MAC.

Pre-existing issues:
- [Medium] In the route-resolved branch of mlx5e_ipsec_init_macs(),
  dst_neigh_lookup() can return an unresolved neighbour with an all-zero…
- [Low] In this commit, the per-SA MAC buffer work->data->addr has no
  synchronization.

--

net/mlx5e: Validate neighbour events before updating IPsec SAs

The patch stops matching neighbour events against the SA source and
destination addresses. Instead it saves a snapshot of the resolved nexthop
(neigh table, ifindex, key) in mlx5e_ipsec_init_macs() and matches events
against that. The ifindex is saved only when the nexthop device is the SA's
offload device (xso.dev); otherwise 0 is saved and any device in the netns
matches.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> index 4084f8a88695b..cc75fcb0aa152 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> @@ -256,6 +256,17 @@ static void mlx5e_ipsec_init_limits(struct mlx5e_ipsec_sa_entry *sa_entry,
>  	attrs->lft.numb_rounds_soft = (u64)n;
>  }
>  
> +static void mlx5e_ipsec_set_tnl_nh(struct mlx5e_ipsec_sa_entry *sa_entry,
> +				   struct mlx5_accel_esp_xfrm_attrs *attrs,
> +				   const struct neigh_table *tbl,
> +				   const struct net_device *dev,
> +				   const void *pkey)
> +{
> +	attrs->nh.tbl = tbl;
> +	attrs->nh.ifindex = dev == sa_entry->x->xso.dev ? dev->ifindex : 0;

[Severity: Medium]
If the nexthop device is not xso.dev, nh.ifindex is saved as 0.
mlx5e_ipsec_neigh_matches() then treats 0 as "any device":

    (!attrs->nh.ifindex || attrs->nh.ifindex == n->dev->ifindex) &&

In that case, can a foreign neighbour on another device in the same netns
still overwrite the programmed MAC?

This looks like it always happens in the bonding fallback path.
bond_ipsec_add_sa() calls:

    real_dev->xfrmdev_ops->xdo_dev_state_add(real_dev, xs, extack);

so mlx5e_xfrm_add_state() sets sa_entry->dev to the slave, while xso.dev is
the bond. The neigh: and IS_ERR branches of mlx5e_ipsec_init_macs() pass
that slave netdev, so ifindex 0 is saved. The route branch ends up the same
way whenever the route's output device is not xso.dev.

For example, a container behind a host-side veth could send an ARP request
with sip set to the nexthop IP and tip set to a host address.
arp_process()->neigh_event_ns() then creates a NUD_STALE neighbour on the
host veth and raises NETEVENT_NEIGH_UPDATE.

The table, the wildcard ifindex and the key all match. neigh_ha_snapshot()
copies the attacker's MAC, and the worker reprograms the TX dmac or RX smac.

The commit message documents the ifindex 0 trade-off. However, this looks
like the case it describes as fixed:

  "a foreign neighbour (veth, other netdev or netns) sharing the SA
   address overwrites the programmed MAC"

The only difference is that the nexthop IP is the target instead of the SA
IP.

Would a tighter match close this? For example, n->dev could be accepted
only when it is xso.dev or the nexthop device, instead of using a wildcard.

> +	memcpy(attrs->nh.key, pkey, tbl->key_len);
> +}

[ ... ]

> @@ -360,6 +372,7 @@ static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
>  	if (attrs->dir == XFRM_DEV_OFFLOAD_OUT &&
>  	    is_zero_ether_addr(addr))
>  		neigh_event_send(n, NULL);
> +	mlx5e_ipsec_set_tnl_nh(sa_entry, attrs, n->tbl, n->dev, n->primary_key);

[Severity: Medium]
This is a pre-existing issue and was not introduced by this patch. Should
the route branch of mlx5e_ipsec_init_macs() set attrs->drop while the
nexthop MAC is still zero?

dst_neigh_lookup() can return an unresolved neighbour whose ha is all
zeros. For IPv4, the route's neigh_lookup creates one if it is missing.
This branch already checks for that with is_zero_ether_addr(addr).

The zero address is still copied into attrs->dmac (OUT) or attrs->smac
(IN), and attrs->drop stays false.

The TX rule adds MLX5_FLOW_CONTEXT_ACTION_DROP only when attrs->drop is
set. setup_pkt_tunnel_reformat() copies attrs->dmac into the encap header
as is:

    ether_addr_copy(eth_hdr->h_dest, attrs->dmac);

Until the neighbour resolves and the netevent worker reprograms the rule,
could encrypted tunnel frames go out with destination MAC
00:00:00:00:00:00?

The fallback branch sets attrs->drop = true for the same unresolved state.
So does the IS_ERR case added by "net/mlx5e: Drop IPsec tunnel traffic if
the neigh cannot be created".

The problem is still there at the end of the series. This patch does make
the window shorter: gateway events now match, so the rule gets reprogrammed
once the gateway resolves.

>  	dst_release(rt_dst_entry);
>  	neigh_release(n);
>  	return;

[ ... ]

> @@ -988,21 +1018,9 @@ static int mlx5e_ipsec_netevent_event(struct notifier_block *nb,
>  
>  	ipsec = container_of(nb, struct mlx5e_ipsec, netevent_nb);
>  	xa_for_each_marked(&ipsec->sadb, idx, sa_entry, MLX5E_IPSEC_TUNNEL_SA) {
> -		attrs = &sa_entry->attrs;
> -
> -		if (attrs->addrs.family != n->tbl->family)
> +		if (!mlx5e_ipsec_neigh_matches(sa_entry, n))
>  			continue;

[ ... ]

>  		data = sa_entry->work->data;
>  
>  		neigh_ha_snapshot(data->addr, n, sa_entry->dev);

[Severity: Low]
This isn't a bug introduced by this patch, but nothing synchronizes access
to data->addr here. mlx5e_ipsec_netevent_event() writes it from the atomic
netevent chain. mlx5e_ipsec_handle_netdev_event() reads it from the
workqueue and programs the result into hardware:

    ether_addr_copy(attrs->dmac, data->addr);

Can a worker that is already running read a torn MAC while the notifier
rewrites the buffer? With the ifindex 0 wildcard, two notifier calls on
different CPUs could also write the buffer at the same time.

The next patch in the series, "net/mlx5e: Serialize IPsec netevent MAC
snapshots", appears to fix this. It adds a spinlock_t to struct
mlx5e_ipsec_netevent_data and takes spin_lock_bh() around
neigh_ha_snapshot(). The worker then copies data->addr into a local buffer
under the same lock.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261126215614.792598-1-tariqt%40nvidia.com
