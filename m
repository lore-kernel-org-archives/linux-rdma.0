Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F9826D4C3;
	Mon, 12 Oct 2026 21:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791838835; cv=none; b=kEclmx8ZXTrsumuvAf8LARilLIXt9e5/36CXxv4c+CLeszTHOK0egUcUeI6A/NchAYu1KWZoeo4R1EkpLvXQ4HhE+AvIwWJNuAUU9fooBU5bquOobvpKjamVSwTKYxPwJaFCDkrE7PiYSY2vlwhUFppYtUI3QwNmOvo22o7p30o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791838835; c=relaxed/simple;
	bh=te27NsuNKUh72Po9/i4mVVC/0BxZ7RTEDm0ilKN37m0=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gFhWvcI6L9JewhO3GpSJaucsK+IJyRhFXtfxabB+IzslL1u9iLAODUOyiKm/V7YDFH8EFgEMYPPYFH4yJF0w/PmTk15f+9KfTd1M2IKKfLJJ99aO2jiq4JJSt7g0eIMX8agTPQc2dhDOTRJshOAyI2wXjNY7ncBZbjoxOMwVqxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J4TFIM82; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J4TFIM82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67C41F0089B;
	Mon, 12 Oct 2026 21:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791838834;
	bh=UwYN5wXLGK3YCUzPomG3PRuTVSWp5Pqf4mVm/nf8gus=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=J4TFIM82d1JJCSg0YiurgvQND22gT76+rxSAXrGLm+HMoaomEFX2NDQqAw/OB5GIA
	 Vio9KUtIWXoZeRl2MUOiHn6hOgutT1RmMwNnLuVXbT2+IqB4fXAzv5/WDuzvcg/4IH
	 MDdFIaKScrcFZyKOvKyCflyL5s1z9gYubF3V8ahPIu1vwhgk7+j75cRC/WsIrT1zdE
	 g9gxAYF27E0OfYCF96P00/+oFLcop5RWJoGI/ktbZArEFJQXN1vX3bZoHSicHMCoN0
	 61XFQb0rRPGQSKpYSO9Rf6m/0OHxkHO/vEUf6ef1d5eZoaDySTvFrk3rwaD6n8W87a
	 UY/FXLux8xf0w==
Subject: Re: [PATCH net 1/2] net/mlx5: HWS, fix reformat pool creation race
From: netdev-bot+sashiko@kernel.org
To: acassen@corp.free.fr
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, moshe@nvidia.com, kliteyn@nvidia.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Date: Mon, 12 Oct 2026 21:00:33 +0000
Message-ID: <179183883330.434549.745280802261352249@kernel.org>
In-Reply-To: <20261008204230.3222198-2-acassen@corp.free.fr>
References: <20261008204230.3222198-2-acassen@corp.free.fr>
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

Critical: 0 · High: 0 (1) · Medium: 1 (1) · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The commit message names the unserialized trigger as "RDMA
  flow actions on the FDB".

Pre-existing issues:
- [High] In mlx5_cmd_hws_packet_reformat_dealloc()
  (drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c), the…
- [Medium] Baseline decision is false: this is resolved later in the
  series.

--

net/mlx5: HWS, fix reformat pool creation race

This patch changes mlx5_fs_get_pr_encap_pool() to use xa_cmpxchg()
instead of xa_insert(). When two callers race to create the first
reformat pool of a given size, the loser now frees its own pool and
returns the one already published, instead of failing with -EBUSY.

> TC serializes these
> allocations under encap_tbl_lock while RDMA flow actions on the FDB
> don't.

[Severity: Medium]
Can the RDMA path actually reach mlx5_fs_get_pr_encap_pool()?

The only RDMA caller of mlx5_packet_reformat_alloc() is the
MLX5_IB_METHOD_FLOW_ACTION_CREATE_PACKET_REFORMAT handler in
drivers/infiniband/hw/mlx5/fs.c. It validates the request first:

	if (!mlx5_ib_flow_action_packet_reformat_valid(mdev, dv_prt, ft_type))
		return -EOPNOTSUPP;

mlx5_ib_flow_action_packet_reformat_valid() accepts encap types only for
NIC_TX and decap types only for NIC_RX. It returns false for FDB.

NIC_TX and NIC_RX map to the EGRESS and BYPASS namespaces, which use the
fw cmds. HWS cmds are only installed on an FDB root:

drivers/net/ethernet/mellanox/mlx5/core/fs_core.c:mlx5_flow_namespace_set_mode() {
	if (root->table_type != FS_FT_FDB)
		return -EOPNOTSUPP;
	...
	else if (mode == MLX5_FLOW_STEERING_MODE_HMFS)
		cmds = mlx5_fs_cmd_get_hws_cmds();
}

The unserialized caller that does reach these pools seems to be the TC
free path, mlx5e_encap_put()->mlx5e_encap_dealloc(). That call runs after
encap_tbl_lock has been dropped:

	mutex_unlock(&esw->offloads.encap_tbl_lock);

	mlx5e_encap_dealloc(priv, e);

That path only creates a pool because of the L2_TO_L3_TUNNEL lookup in
mlx5_cmd_hws_packet_reformat_dealloc(), described below.

Could the commit message name the concurrent creator that actually
exists?

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
> index 5a172c572a68f..66edb42268cbd 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c

[ ... ]

> @@ -1242,13 +1242,14 @@ mlx5_fs_get_pr_encap_pool(struct mlx5_core_dev *dev, struct xarray *pr_pools,
>  	err = mlx5_fs_hws_pr_pool_init(pr_pool, dev, size, reformat_type);
>  	if (err)
>  		goto free_pr_pool;
> -	err = xa_insert(pr_pools, index, pr_pool, GFP_KERNEL);
> -	if (err)
> -		goto cleanup_pr_pool;
> -	return pr_pool;
> +	old = xa_cmpxchg(pr_pools, index, NULL, pr_pool, GFP_KERNEL);
> +	if (!old)
> +		return pr_pool;

[Severity: High]
This is a pre-existing issue and was not introduced by this patch, but
does mlx5_cmd_hws_packet_reformat_dealloc() return L2_TO_L3_TUNNEL
reformats to the wrong pool?

The alloc side takes the bulk from the L2->L3 xarray:

mlx5_cmd_hws_packet_reformat_alloc() {
	case MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL:
		...
		pr_pool = mlx5_fs_get_pr_encap_pool(dev, &hws_pool->el2tol3tnl_pools,
						    MLX5HWS_ACTION_TYP_REFORMAT_L2_TO_TNL_L3,
						    params->size);
}

The dealloc side looks it up in the L2->L2 xarray instead:

mlx5_cmd_hws_packet_reformat_dealloc() {
	case MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL:
		pr_pool = mlx5_fs_get_pr_encap_pool(dev, &hws_pool->el2tol2tnl_pools,
						    MLX5HWS_ACTION_TYP_REFORMAT_L2_TO_TNL_L2,
						    pr_data->data_size);
}

mlx5_fs_get_pr_encap_pool() creates and publishes a pool on a miss. So
the free path can create an empty L2->L2 pool, or adopt an existing one,
and release the bulk into it.

mlx5_fs_pool_release_index() then updates that pool's available_units
and used_units, and used_units can go negative. It also calls list_del()
or list_add() on a bulk that is linked on the L3 pool's lists, while
holding only the L2 pool's pool_lock.

The bulk can end up on the L2 pool's unused list. Could a later
VXLAN/NVGRE/L2-tunnel encap of the same header size then be served from
it, and program an L2_TO_TNL_L3 hws_action in hardware?

mlx5e_encap_put() calls mlx5e_encap_dealloc() outside encap_tbl_lock.
Can this list manipulation also race with an allocation that holds only
the L3 pool_lock?

A single thread seems able to trigger this on an HMFS switchdev eswitch:

1. Add and delete a TC MPLSoUDP encap rule.
2. Add and delete a second MPLSoUDP rule with the same header size.
3. Add a VXLAN encap rule with that header size.

Should the dealloc case use el2tol3tnl_pools and
MLX5HWS_ACTION_TYP_REFORMAT_L2_TO_TNL_L3? That change might also remove
the unserialized pool creation this patch addresses.

>  
> -cleanup_pr_pool:
>  	mlx5_fs_hws_pr_pool_cleanup(pr_pool);
> +	kfree(pr_pool);
> +	return xa_is_err(old) ? ERR_PTR(xa_err(old)) : old;
> +
>  free_pr_pool:
>  	kfree(pr_pool);
>  	return ERR_PTR(err);

[Severity: Medium]
This isn't a bug introduced by this patch, but the modify header pools in
the same file have a similar create-on-miss race.

mlx5_cmd_hws_modify_header_alloc() scans mh_pools without a lock and uses
the running count as the new index:

	xa_for_each(&hws_pool->mh_pools, i, pool) {
		if (mlx5_fs_hws_mh_pool_match(pool, &pattern)) {
			known_pattern = true;
			break;
		}
		cnt++;
	}

mlx5_fs_create_mh_pool() still uses xa_insert(). Two concurrent first
creators can therefore pick the same index, and the second one fails
with -EBUSY.

The error path can also destroy a pool that another caller has already
found:

destroy_pool:
	if (!known_pattern)
		mlx5_fs_destroy_mh_pool(pool, &hws_pool->mh_pools, cnt);

The next patch in this series, "net/mlx5: HWS, fix modify header pool
creation race", appears to fix this. It takes a new mh_pools_lock around
the lookup and creation, and it removes the destroy_pool path.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261008204230.3222198-1-acassen%40corp.free.fr
