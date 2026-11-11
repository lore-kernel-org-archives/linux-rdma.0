Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794432561;
	b=Pr56iUJyPCrgrFq98YB+TCuC+f3/t5tIv087SeDGIWvC9gTkR1KwQXgR/xzBLP2S5grg
	 vNles+NvCvxWzGgnuymTrP+6fkGISH2DH0x0r4tb38ha0HLrPxtZmqRNgiEyr0FI0fK++
	 EcGE1hLE0j+z21iBzfG+vx7vqDalFEGnscjKGQx+NTpa6YTT8VtDxvPfSrBl+M5HtqoI4
	 RNaGme3nWUqKqmEhuB7oqQ/MkyW8JD0nf6EA5bjqIoLDFCGWReS3iJM/MNDVUyK49Qjht
	 h1YOyz84gcSoo6l0aXjCl+b9SNEAYt7wCeJN81hVCM6+N7s6cgaluLzFacPbM4gW17w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794432561;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=VApbm77dz29aNz+Amn2HSvzQFJ7RcIUsAN+hrR5d+ZA=;
	b=nRJF9RXcwo+ItF+NBVwB9OmpiO81APxQwvVh8hGkzOzD1TqLwOiccnR2DVdzD1eXwng2
	 RhgZzGijy+a0VpJvLLH7FvscGKLCiIy0g5TSYW3kZxDXwSXUpIyEqeLSO9BKWp1RudB2D
	 9k/bzbu6DEqtiannwEzD1wiFRzAwBF+7ilnap1hiecjJM4L1RHdq4ThQYnUgnnoYx3MJ4
	 hcSMIffnim0Dt/ztA5v4Ss26ZgKot+WG2KZPnlQgovuDeFd9S6+voPffKzf2m3CSqj+22
	 6iX1186NGaA9SVRiSrKH5zcynyL3FuhsSLpGOGotDUVLwZ/DByO3AazX0JqfPfye+gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hl+K2rjZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0153C606A31C;
	Wed, 11 Nov 2026 21:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hl+K2rjZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A581E1F00A05;
	Wed, 11 Nov 2026 21:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794432560;
	bh=VApbm77dz29aNz+Amn2HSvzQFJ7RcIUsAN+hrR5d+ZA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Hl+K2rjZd+CLZS2Vbq+GNytGPxglv7o6wjMXPRn2tkTdkdGiuCmVILCciJuuiP3LW
	 nyikYTeX5eRGrSV4fhlFgcNB05YBmN72SDCWbhhJmnYd/MTkOaSkWNeomt6bkKy2ld
	 vX/T5lAX4U3/Vi0v5jjJLf7jl/b0u4JfGzWyLs89UaKlv6I1uyBDOk+liNxI03yhjn
	 +KZhCM57TBbkpyksu8ey8C7fI9BPM6sEgdv8bBhl7ARv4R2u2HZHQi4+0aLyaTzd19
	 0Har2I6jcZgafR3rC91BK+uK8ZJuon+2NGD5CxfLfkzs+kujt3qd87E9hhMQdWMAUT
	 yhhqnI2STD5qw==
Subject: Re: [PATCH net] net/mlx5: E-switch, Query port function mac only when
 vport is enabled
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 ajayachandra@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 moshe@nvidia.com, saeedm@nvidia.com, udar@nvidia.com
Date: Wed, 11 Nov 2026 21:29:19 +0000
Message-ID: <179443255917.2199510.5948232347809644575@kernel.org>
In-Reply-To: <20261110092648.2511196-1-tariqt@nvidia.com>
References: <20261110092648.2511196-1-tariqt@nvidia.com>
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

- [Medium] The new `if (vport->enabled)` guard in
  mlx5_devlink_port_fn_hw_addr_get()…

--

net/mlx5: E-switch, Query port function mac only when vport is enabled

This commit wraps the mlx5_query_nic_vport_mac_address() call in
mlx5_devlink_port_fn_hw_addr_get() in a vport->enabled check. The goal is
to stop QUERY_NIC_VPORT_CONTEXT from failing in firmware when a port
function is dumped while its vport is not enabled.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index c712848b202db..b83c6c02670f8 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> @@ -5121,8 +5121,9 @@ int mlx5_devlink_port_fn_hw_addr_get(struct devlink_port *port,
>  
>  	mutex_lock(&esw->state_lock);
>  
> -	mlx5_query_nic_vport_mac_address(esw->dev, vport->vport, true,
> -					 vport->info.mac);
> +	if (vport->enabled)
> +		mlx5_query_nic_vport_mac_address(esw->dev, vport->vport, true,
> +						 vport->info.mac);

[Severity: Medium]
Can this check ever be false here? The commit message says "A port
function can be dumped while its vport is not enabled". The ordering of
devlink port registration against vport enable/disable seems to rule
that out.

mlx5_devlink_port_fn_hw_addr_get() is reachable only through the
.port_fn_hw_addr_get op in mlx5_esw_pf_vf_dl_port_ops and
mlx5_esw_dl_sf_port_ops. Devlink calls that op only on registered ports.

Those ports are registered in mlx5_esw_offloads_devlink_port_register(),
via mlx5_esw_offloads_load_rep(). That happens only after the vport has
been enabled:

drivers/net/ethernet/mellanox/mlx5/core/eswitch.c:mlx5_eswitch_load_vport() {
    ...
	err = mlx5_esw_vport_enable(esw, vport, enabled_events);
	if (err)
		return err;

	err = mlx5_esw_offloads_load_rep(esw, vport);
    ...
}

On teardown, the devlink port is unregistered before the vport is
disabled:

drivers/net/ethernet/mellanox/mlx5/core/eswitch.c:mlx5_eswitch_unload_vport() {
	mlx5_esw_offloads_unload_rep(esw, vport);
	mlx5_esw_vport_disable(esw, vport);
}

mlx5_esw_vport_enable() and mlx5_esw_vport_disable() are the only places
that write vport->enabled. Rep netdev notifications that reach this op
also run inside the same window. So every dump, doit or notify that gets
here should already see vport->enabled == true.

If so, would the quoted QUERY_NIC_VPORT_CONTEXT "bad parameter(0x3),
syndrome (0x29d722)" error still occur after this patch?

One possibility is a vport the driver has enabled but firmware still
rejects for the query, such as an inactive SF. In that case this query
still runs and still fails.

Another candidate is the unconditional query that the same Fixes commit
eea31f21dce1 added to esw_vport_setup(). It runs on every vport enable,
including bulk SF creation:

drivers/net/ethernet/mellanox/mlx5/core/eswitch.c:esw_vport_setup() {
    ...
	mlx5_query_nic_vport_mac_address(esw->dev, vport_num, true,
					 vport->info.mac);
    ...
}

This patch leaves that query unchanged. Was the failing path confirmed
to be mlx5_devlink_port_fn_hw_addr_get() and not esw_vport_setup()?

>  	ether_addr_copy(hw_addr, vport->info.mac);
>  	*hw_addr_len = ETH_ALEN;
>  	mutex_unlock(&esw->state_lock);

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261110092648.2511196-1-tariqt%40nvidia.com
