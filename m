Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795729520;
	b=r/QG2mlt/0LJLOCd/7PYVcfRKkcLK28nuuFJbIsiNNXp1vOmpE+FAu4tlNMQc1RBWKVr
	 hDyyBMhMh5PnGu55OFtlniepl6XJ41vA3CUvxCw4AMzKcTzCqVjLxoBQQGTa4R/GQqsL8
	 7IIq5Z31rqPVgCNhqZt8XU16xBEv3UljNU/cH5wPwmfnoYIryHzz2Cs+73SEvencKjEdd
	 KmY9D5leNlqhHalcBY49pb0KiFqIVi8P5eOes2NAPjjiimDy5560r1BzEsJ9G3tzL0p9F
	 0HZXnSycM5SBM0ufky5XYepY04O83wOKF59U9uy4yBOItNcPIKFP1yr+hVAGRxhugjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795729520;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=JRMBNQYtRA98LyRzp6hALbO2ol1NnounkrYHWIiByuQ=;
	b=EmMn0CjB6CS5zdpzCmlRivio9mQKP1PFHnWg0vxmxoFjgxdWBPnEZdFxCdNuEGMFZhae
	 4MwzzduBZx4PWiZpm4/7ge1cFUwP5j+6jRPkGOi4grX2BuWQc6wtV2k8GaqgAifiAvhU1
	 zhjlbpAtWB7ZTIdlHwvEbkrXUiDaWBxOhRX4A9gXYMmImgOnWvJJSCUZXJHsvX9PdeOLj
	 i5ulJRDRxpKTLB5isFX/1rla5A2CmZl1klMEs+0HdZS27XiVGrvJdrLcQsBVgAozhmuN7
	 4ZR+aOw9uxD+CzsT2LLUL843MvC20fvBpYsHtGpr+HvpX+SDqMD38Hky49m4V2RMoCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YIt1qUb7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DC0606A321;
	Thu, 26 Nov 2026 21:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YIt1qUb7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3721F00A2E;
	Thu, 26 Nov 2026 21:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795729519;
	bh=JRMBNQYtRA98LyRzp6hALbO2ol1NnounkrYHWIiByuQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=YIt1qUb7XakBpQxIaZ9BOvQMyjfS0HbR2XtHj8hvAORHsSMcKsVKr0nRQXVumQ7uD
	 M5bo87peyQeAlHiqA9FywvKWLS2I54Q4NqHjfllbs73lj6aVYhqj2TQzsAet+hZ0qB
	 XotjJT7G98Orpagsky4v6sA3mHqjoXL2mZTr24JiYpxcnI2TIrbLhD5clz4qLfiWON
	 MhiRrEjVRH4GK9ehNSu81SM/sHt8UKPBzgIn4hV6qV7UN7wDHCy4kKn8fucwvtsMmY
	 e/NDnx1i6zN9TOxWq9NyZNqB+BRoVwWJMvih2mrvPV/13kwlOER86mQCgmz5syKG/V
	 Kuu9UNBkETbyQ==
Subject:
 Re: [PATCH net] net/mlx5e: TC, use the owner eswitch for encap neigh updates
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 willemb@google.com, fmancera@suse.de, gal@nvidia.com, idosch@nvidia.com,
 jianbol@nvidia.com, kuniyu@google.com, leon@kernel.org,
 linux-rdma@vger.kernel.org, maord@nvidia.com, mbloch@nvidia.com,
 razor@blackwall.org, roid@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com
Date: Thu, 26 Nov 2026 21:45:17 +0000
Message-ID: <179572951791.3135.13703182913006010599@kernel.org>
In-Reply-To: <20261125210629.239095-1-tariqt@nvidia.com>
References: <20261125210629.239095-1-tariqt@nvidia.com>
X-sashiko-severity: High
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

Critical: 0 · High: 1 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix does not record the owner eswitch for encap entries
  created on a Socket Direct (SD) secondary eswitch, so the neigh-update…

--

net/mlx5e: TC, use the owner eswitch for encap neigh updates

The neigh update and neigh-used paths used to derive the eswitch from
netdev_priv(e->out_dev). In MPESW, an encap entry of one eswitch can route
through another eswitch's uplink, so that eswitch was not always the owner.
This patch records the owner eswitch uplink priv in the encap entry, uses it
for flow updates and entry release, and keeps out_dev for neigh handling.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> index 4f9f8beffbc8d..d23cf60613ea7 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c

[ ... ]

> @@ -871,6 +871,7 @@ int mlx5e_attach_encap(struct mlx5e_priv *priv,
>  	init_completion(&e->res_ready);
>  	entry_created = true;
>  	INIT_LIST_HEAD(&e->route_list);
> +	e->priv = netdev_priv(mlx5_eswitch_uplink_get_proto_dev(esw, REP_ETH));

[Severity: High]

Does this record the owner eswitch for encap entries created on a Socket
Direct secondary eswitch? mlx5_eswitch_uplink_get_proto_dev() redirects to
the SD primary:

void *mlx5_eswitch_uplink_get_proto_dev(struct mlx5_eswitch *esw, u8 rep_type)
{
	struct mlx5_core_dev *primary = mlx5_sd_get_primary(esw->dev);

	if (primary)
		esw = primary->priv.eswitch;

	return mlx5_eswitch_get_proto_dev(esw, MLX5_VPORT_UPLINK, rep_type);
}

SD secondaries also have no uplink representor of their own, as the comment
in mlx5_eswitch_reload_ib_reps() says:

	/* SD secondary devices share the primary's uplink and do not
	 * have their own uplink representor. Only load VF/SF vports.
	 */

Take a tc flower encap rule added on a VF representor of an SD secondary:

- is_peer_flow_needed() handles this case explicitly via
  mlx5_lag_is_sd(in_mdev) && !mlx5_sd_is_primary(in_mdev).
- mlx5e_tc_add_fdb_flow() installs the original flow in the secondary's
  chains.
- e goes into the secondary's encap_tbl under the secondary's
  encap_tbl_lock.
- mlx5e_tc_tun_create_header_ipv4() allocates e->pkt_reformat on the
  secondary mdev.

But e->priv->mdev->priv.eswitch is the SD primary's eswitch.

On a neighbour change, mlx5e_rep_neigh_update() calls
mlx5e_rep_update_flows(e->priv, ...). It looks like that would:

- take the primary's encap_tbl_lock while walking e->flows in
  mlx5e_take_all_encap_flows(). Meanwhile mlx5e_attach_encap() and
  mlx5e_detach_encap() change the same list under the secondary's lock.

- add and remove the slow path and encap rules through the primary's
  fs_chains, for flows whose rules live in the secondary's chains.

- allocate the replacement pkt_reformat on the primary mdev. Later,
  mlx5e_detach_encap() frees it through mlx5e_encap_dealloc(priv, e) with
  the secondary's priv.

The other converted paths have the same problem. When
mlx5e_get_next_matching_encap() calls mlx5e_encap_put(e->priv, e) on the
last reference, it would take the primary's lock and call hash_del_rcu() on
an entry in the secondary's encap_tbl. mlx5e_tc_update_neigh_used_value()
also walks e->flows under the primary's lock.

For SD, the old netdev_priv(e->out_dev) resolved to the same SD primary
uplink, so this behavior is not new. Still, the problem the commit message
describes stays reachable for SD secondary owners, including SD under MPESW.

Would it work better to record the owner eswitch or mdev directly, for
example priv->mdev->priv.eswitch without the SD primary redirection, instead
of an uplink priv?

>  
>  	tun_info = mlx5e_dup_tun_info(tun_info);
>  	if (!tun_info) {

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261125210629.239095-1-tariqt%40nvidia.com
