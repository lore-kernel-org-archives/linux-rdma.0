Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792794574;
	b=pnaA/XiJjD4E8+P8JjF70+9x22HbEb65EiJXkWqoHXpY+welta8UBwBjDvZxkmfTB3XM
	 6IhhCnRkWwf9UeDmTQZo4HVg+ytASONc1aqe4oawzil6mfNWUbYTgucj1nO4UWLOxMZNY
	 qGPkgihOGgU1EmfcFCX5DASbN1KkcQ4/B8AD+yNcYcEtxs8dSf+bH4EXyzoCDkYalwFFn
	 uRqXVo1EWvfZsFAKTlcncAPO0FroOhBUE2K6nBvC4EzhTVFZeoYiF12yR4MahMnZHAYw/
	 UD+m+Xh3imfwpRZYyd+jzsm9AdE8TQGFzG8aUACD6Z7cPGVdfycLcg3+7AG7TJPjIeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792794574;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=yO8/3UjBnXkWO9R0y13x9W0JK5UzRvNulcz22iWa8S4=;
	b=sP8AJWS8jhUEuPJDAAbwvwSYGFMNkQDBpqwbQ4v0/Dyv3QDwcbuPpc48JDuot0NApwyI
	 6HSH7KbZ6gIWS/FujdWDRoDgIz15zbbq4a9H9aDf9yZ82ubC7/Gb/f+5Ttk4tg0HkKQG2
	 lHSygmomJ2Fgzk1RJLie6H3EDrg5SWO1lhJQUdjQrHNzxitXTZyLA1apY/qmucK59tPFh
	 iIP0mgPWaNVepLZ8PUAHNANTzzvYC+LgPnGYkOvqlRY3yjin4HDK99iScP8/drROe0rES
	 FqsmRN5YZSeBEs7EeN81j6mY8kuZmh02CZTTyefhpLLW6RXj3J4YLDMfLdRf89QnKbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZGydxJEx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18454606A31D;
	Fri, 23 Oct 2026 22:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZGydxJEx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9821F1F01825;
	Fri, 23 Oct 2026 22:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792794573;
	bh=yO8/3UjBnXkWO9R0y13x9W0JK5UzRvNulcz22iWa8S4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ZGydxJExDTH26vno3gePfM1I9M7/DPUldclF22GV00+W8niwMoLOytbaAP0JN0ulr
	 +EsECA7DfBoJ2e8n8YudJJq/4CZH5cUXDEyzTfrqth9a7JBi5PR4tHdJeBvgQ53fKx
	 MEzd9nU7zQM9uJmISCQFVbhBIfxlo6fFar6x3ANs/FcCElOJRXMF0ymRDxM2YVm21f
	 9WvvkyNPPXKudEmnhh+NGXhdm9TgZMwpw3uCcPN4dQL7/sTcaUAwLbNQzSAh/h1xc2
	 U53cKcvQUUgUbdaapCxQjr1+IlEjqKlCLCWmnGwhDxEwabxQLvTGEFPeqhVvrJETTc
	 +ChfPcBJA1POw==
Subject: Re: [PATCH net] net/mlx5: Bridge, fix bogus MDB offload errors
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, alazar@nvidia.com,
 bsoares.it@gmail.com, cratiu@nvidia.com, gal@nvidia.com, kees@kernel.org,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 maord@nvidia.com, mbloch@nvidia.com, roid@nvidia.com, saeedm@nvidia.com,
 vladbu@nvidia.com
Date: Fri, 23 Oct 2026 22:29:32 +0000
Message-ID: <179279457212.3134.243255340288032723@kernel.org>
In-Reply-To: <20261021122115.3737284-1-tariqt@nvidia.com>
References: <20261021122115.3737284-1-tariqt@nvidia.com>
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

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] In drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c,
  mlx5_esw_bridge_port_mdb_add() now returns 0 when the bridge port…

--

net/mlx5: Bridge, fix bogus MDB offload errors

This patch changes mlx5_esw_bridge_port_mdb_add() so that it returns 0
instead of -EINVAL when the bridge port or the port vlan cannot be found.
It also lowers the log level from warn to info. The goal is to stop the
error messages that appear when a 'bridge vlan del' overtakes a deferred
MDB add.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
> index b4cf3c5ac0dde..7c32dc9db098e 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
> @@ -1867,26 +1867,27 @@ int mlx5_esw_bridge_port_mdb_add(struct net_device *dev, u16 vport_num, u16 esw_
>  
>  	port = mlx5_esw_bridge_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
>  	if (!port) {
> -		esw_warn(br_offloads->esw->dev,
> +		/* MDB is added asynchronously from the switchdev deferred
> +		 * queue while port might have been deleted concurrently.
> +		 */
> +		esw_info(br_offloads->esw->dev,
>  			 "Failed to lookup bridge port to add MDB (MAC=%pM,vport=%u)\n",
>  			 addr, vport_num);
> -		NL_SET_ERR_MSG_FMT_MOD(extack,
> -				       "Failed to lookup bridge port to add MDB (MAC=%pM,vport=%u)",
> -				       addr, vport_num);
> -		return -EINVAL;
> +		return 0;
>  	}
>  
>  	bridge = port->bridge;
>  	if (bridge->flags & MLX5_ESW_BRIDGE_VLAN_FILTERING_FLAG && vid) {
>  		vlan = mlx5_esw_bridge_vlan_lookup(vid, port);
>  		if (!vlan) {
> -			esw_warn(br_offloads->esw->dev,
> +			/* MDB is added asynchronously from the switchdev
> +			 * deferred queue while vlan might have been deleted
> +			 * concurrently.
> +			 */
> +			esw_info(br_offloads->esw->dev,
>  				 "Failed to lookup bridge port vlan metadata to create MDB (MAC=%pM,vid=%u,vport=%u)\n",
>  				 addr, vid, vport_num);
> -			NL_SET_ERR_MSG_FMT_MOD(extack,
> -					       "Failed to lookup vlan metadata for MDB (MAC=%pM,vid=%u,vport=%u)",
> -					       addr, vid, vport_num);
> -			return -EINVAL;
> +			return 0;
>  		}
>  	}

[Severity: Medium]
Both of these early exits now return 0. Will the bridge then report the
MDB entry as offloaded, even though nothing was programmed in the
eswitch?

The return value passes unchanged through mlx5_esw_bridge_port_obj_add()
and switchdev_port_obj_add_deferred() to the completion callback:

net/bridge/br_switchdev.c:br_switchdev_mdb_complete() {
	if (err == -EOPNOTSUPP)
		goto out_free;
    ...
		old_flags = p->flags;
		br_multicast_set_pg_offload_flags(p, !err);
    ...
}

When err == 0, br_multicast_set_pg_offload_flags() sets
MDB_PG_FLAGS_OFFLOAD, and __mdb_entry_fill_flags() exports it to user
space as MDB_FLAGS_OFFLOAD. 'bridge mdb show' and RTM_NEWMDB dumps would
then show 'offload' for an entry that has no hardware rule. Before this
patch, the same entry showed 'offload_failed'.

The entry also stays in the bridge MDB after the vlan del race.
__vlan_del() removes port groups only through
br_multicast_toggle_one_vlan(). That function does nothing unless
per-vlan snooping (BR_VLFLAG_MCAST_ENABLED) is enabled. So the wrong flag
stays until the entry times out, and for a permanent entry it never goes
away.

The !vlan branch can also be hit without any race:

- With per-vlan snooping off, br_mdb_add() accepts 'bridge mdb add ...
  vid X' for a VID that is not configured on the port.

- mlx5_esw_bridge_port_vlan_add() can return -EOPNOTSUPP when the
  reformat caps are missing. __vlan_vid_add() then falls back to
  vlan_vid_add(), and the bridge keeps a vlan that mlx5 never created.

The result also differs from mlx5_esw_bridge_port_mdb_attach(). That
function already uses -EOPNOTSUPP for the not-offloaded case:

	if (!(bridge->flags & MLX5_ESW_BRIDGE_MCAST_FLAG))
		return -EOPNOTSUPP;

The new return 0 runs before that check. With multicast offload disabled,
the same unoffloaded entry would be marked offloaded when the vlan is
missing, and left untouched when the vlan is present.

The commit message says:

    the errno only flags the entry as offload failed.
    The end result is correct either way, ...

That does not cover the case where the entry is now flagged as offloaded.

The FDB precedent also seems to work differently. FDB offload state is
set only by an explicit SWITCHDEV_FDB_OFFLOADED notification, so skipping
an FDB offload does not leave a flag behind.

Would returning -EOPNOTSUPP here work instead?
switchdev_port_obj_add_deferred() does not log -EOPNOTSUPP, so the bogus
netdev_err would still go away. br_switchdev_mdb_complete() would also
leave the flags untouched.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261021122115.3737284-1-tariqt%40nvidia.com
