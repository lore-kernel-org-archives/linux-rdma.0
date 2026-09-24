Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4355326A7;
	Thu, 24 Sep 2026 17:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271962; cv=none; b=NwgQVtGcPMl2+8bzhwK/yuzPnOqiJpnldhsDQwFuW9KwxxKdqwl8vdDLwDMIDMqAo07kAz3nf5qmLN12r/NLptiWvAqdaa3TTy1x9OQHqsgZbSNimpQ+IiIx1GZsm3lUig/XwV5KakbCVYCJNfymhrgo3lLvH1kXflG9wr+yJns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271962; c=relaxed/simple;
	bh=q4IoQWdwXI6JoYFwTQBrjLAVydvB6NqYZoY96ZUKrtc=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pgVMqw9XVHxxNZqItyT5tlWfsWOgw5YqGOnFv1OK4WC2u59I2ElcGCShxsM4KvaFQRoQ+v6qDgLECQc1v/DPU7qHt9wxmm6eFuKJOWNhs3VK1iV0eRJm4es1BWuITDyIHqRrK5PBbsBU+7y/Hf+sq1Idprh3/IWQ+DMmAva65FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fNXWeyg6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fNXWeyg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ACA31F000FF;
	Thu, 24 Sep 2026 17:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790271960;
	bh=hhaHEG5fk5lli7bSnp0/dtz5H7RILhr4iO3JrrcCpg4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=fNXWeyg6Msez2y8Z4qzgT9divqePk2ZEsRf6RmU8QLJAWe2+yF6NL+haRh/jja7ii
	 bW/BBbzm1p2vaLY7dWcdfeF31U166k2Fjt4SS8hB12anRBsK5sS429uB/8Wwa65P7g
	 OJfqcdRV8xV6KEhAF/o5KjyS5IsAqh0leWWNJiJ0AncD771VNhlLNYdydCfEHMB4H7
	 VZ8pTruaXd12J6r9IK/Wmb2buwzuDbFVzmbe4afjj79AZg/P5yf9iexMzDIsz5Rl6H
	 k59/++/CUUPOzqQwZaKdNVrTCeJ3K/mRrW13vDNYh3jbuA4Nbr8tY0ZCUZiA5Ii8Yn
	 pY+EJTPRDU7dA==
Subject: Re: [PATCH net-next 07/13] net/mlx5e: TC, anchor peer-flow reverse
 index on the duplicated flow
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 agoldberger@nvidia.com, cratiu@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 moshe@nvidia.com, ohartoov@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com
Date: Thu, 24 Sep 2026 17:45:58 +0000
Message-ID: <179027195898.2160803.15871365996857154055@kernel.org>
In-Reply-To: <20260923103830.1183-8-tariqt@nvidia.com>
References: <20260923103830.1183-8-tariqt@nvidia.com>
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
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 (2) · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] This commit changes unpair-time cleanup in
  mlx5e_tc_clean_fdb_peer_flows()…

Pre-existing issues:
- [Medium] mlx5e_tc_add_fdb_peer_flow()
  (drivers/net/ethernet/mellanox/mlx5/core/en_tc.c) sets `int i =…
- [Medium] In mlx5e_add_fdb_flow()
  (drivers/net/ethernet/mellanox/mlx5/core/en_tc.c),…

--

net/mlx5e: TC, anchor peer-flow reverse index on the duplicated flow

This patch moves the eswitch peer-flow reverse index from the origin flow
onto each duplicate. Each flow now has one peer list node and a peer_orig
back-reference. These replace the origin's peer[] array, the peer_used
bitmap and peer_index, while the per-peer list heads stay keyed by the LAG
sequence number until the next patch.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index b290beb4369ad..fae4f8625da4d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c

[ ... ]

> @@ -4639,12 +4631,11 @@ static int mlx5e_tc_add_fdb_peer_flow(struct flow_cls_offload *f,
>  		goto out;
>  	}
>  
> -	peer_flow->peer_index = i;
> +	peer_flow->peer_orig = flow;
>  	list_add_tail(&peer_flow->peer_flows, &flow->peer_flows);
>  	flow_flag_set(flow, DUP);
>  	mutex_lock(&esw->offloads.peer_mutex);
> -	list_add_tail(&flow->peer[i], &esw->offloads.peer_flows[i]);
> -	set_bit(i, flow->peer_used);
> +	list_add_tail(&peer_flow->peer, &esw->offloads.peer_flows[i]);

[Severity: Medium]
This isn't a bug introduced by this patch, but can i be negative here?

i is set at the top of mlx5e_tc_add_fdb_peer_flow():

	int i = mlx5_lag_get_dev_seq(peer_esw->dev);

mlx5_lag_get_dev_seq() returns -ENOENT in three cases: there is no ldev,
no master matches the filter, or the device is not in the filtered LAG
set.

Nothing checks the range of i before it indexes the fixed
peer_flows[MLX5_MAX_PORTS] array in struct mlx5_esw_offload. With a
negative value, list_add_tail() would write list pointers into the fields
in front of that array.

mlx5e_tc_clean_fdb_peer_flows() does handle a negative return:

		i = mlx5_lag_get_dev_seq(peer_esw->dev);
		if (i < 0)
			continue;

The old flow->peer[i] line used the same unchecked index. The code does
not make it clear whether a devcom-paired peer can be outside the filtered
LAG set when a flow is added.

The next patch in the series, "net/mlx5e: TC, track peer flows in a
vhca_id xarray", replaces this lookup with xa_load(&esw->offloads.peer_flows,
peer_vhca_id), so the negative index goes away.

>  	mutex_unlock(&esw->offloads.peer_mutex);
>  
>  out:

[Severity: Medium]
This is a pre-existing issue, but does the error path in the caller,
mlx5e_add_fdb_flow(), leak the origin struct mlx5e_tc_flow?

__mlx5e_add_fdb_flow() has already allocated the flow with refcnt 1. If
mlx5_devcom_for_each_peer_begin() fails or mlx5e_tc_add_fdb_peer_flow()
returns an error, the flow ends up here:

drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:mlx5e_add_fdb_flow() {
    ...
peer_clean:
	mlx5e_tc_del_fdb_peers_flow(flow);
	mlx5_devcom_for_each_peer_end(devcom);
clean_flow:
	mlx5e_tc_del_fdb_flow(priv, flow);
	return err;
}

mlx5e_tc_del_fdb_flow() frees the attrs and rules but not the flow
itself. Since *__flow is never set, mlx5e_configure_flower() does not own
the flow either.

For comparison, the err_free path in __mlx5e_add_fdb_flow() calls
mlx5e_flow_put().

This leak has existed since commit b1661efa4dbbd7 and is still there at
the end of this series.

[ ... ]

> @@ -5539,21 +5530,19 @@ int mlx5e_tc_num_filters(struct mlx5e_priv *priv, unsigned long flags)
>  
>  void mlx5e_tc_clean_fdb_peer_flows(struct mlx5_eswitch *esw)
>  {

[ ... ]

>  	mlx5_devcom_for_each_peer_entry(devcom, peer_esw, pos) {
>  		i = mlx5_lag_get_dev_seq(peer_esw->dev);
>  		if (i < 0)
>  			continue;
>  
> -		list_for_each_entry_safe(flow, tmp, &esw->offloads.peer_flows[i], peer[i])
> -			mlx5e_tc_del_fdb_peers_flow(flow);
> +		list_for_each_entry_safe(peer_flow, tmp_peer_flow,
> +					 &esw->offloads.peer_flows[i], peer)
> +			mlx5e_tc_del_fdb_peer_flow(peer_flow);

[Severity: Medium]
The commit message says "No functional change". Doesn't this change what
mlx5e_tc_clean_fdb_peer_flows() removes at unpair time?

Before this patch, every entry on esw->offloads.peer_flows[i] was an
origin flow. mlx5e_tc_del_fdb_peers_flow(flow) walked that origin's
peer_used bitmap and removed its duplicates for every peer index. That
included lists this loop never visited.

After this patch, each entry is a single duplicate linked through
peer_flow->peer, and mlx5e_tc_del_fdb_peer_flow(peer_flow) removes only
that duplicate.

The loop still picks the list from the peer's current
mlx5_lag_get_dev_seq(). The duplicate, however, was filed under the seq
returned when mlx5e_tc_add_fdb_peer_flow() ran.

Suppose that index no longer matches any current peer seq when
mlx5_esw_offloads_unpair() calls this function. The device may have been
renumbered, or the lookup may now return -ENOENT. Would those duplicates
be left behind? With three or more devices, the old per-origin sweep
would still have removed them.

A leftover duplicate would keep its FDB rules on the peer after pairing is
gone, and it would stay linked on flow->peer_flows. A later deletion of
the origin would then do:

mlx5e_tc_del_flow()
  mlx5e_tc_del_fdb_peers_flow()
    mlx5e_tc_del_fdb_peer_flow()
      mlx5e_tc_del_fdb_flow(peer_flow->priv, peer_flow)

At that point the peer priv may already be unloaded.

The code does not make it clear whether the LAG seq can change before the
devcom unpair event, so this may not be reachable.

The next patch in the series, "net/mlx5e: TC, track peer flows in a
vhca_id xarray", keys the index by vhca_id and walks every entry with
xa_for_each(). That fixes the problem, so it only affects this
intermediate commit.

>  	}
>  }

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260923103830.1183-1-tariqt%40nvidia.com
