Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C08E52FE32;
	Thu, 24 Sep 2026 17:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271957; cv=none; b=LXNuoWJvrAFhp7pjxxUABn5PwFO42Yd+ccpZWqU5GLcxl1npI2gg76Uyiwiym76VRsgU9gOL3Fn2oQoSt5Wm18z5PvQBJP4nfcT+qdcjNOHaKdeTtHyqFo27G1K73MDC3mJKShDLu58FOLOnuEjHNXHz5acEEcz2ZdYfT1wP76s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271957; c=relaxed/simple;
	bh=PoYnrgZ5M3dQFuxfp8yUiwgbPUBbcsor0O9H7u4FQUo=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fMs5opWs4rS9twtb+WwXIduwfIBnDU+L2z8rPtXqXN81j9OX1f7x29rHoy9PehDUATXSjSBSCWpD2YE2tOf0F0acO7NIU+KySWBCjhyC+rkR9t79awBXecAng8YYJL72nHVzPwvobPMORB76Z/Zq3OlDxRqifOHk8FjoTfn+EeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZOuSjK21; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZOuSjK21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61711F000FF;
	Thu, 24 Sep 2026 17:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790271955;
	bh=OnXh3gg1QClPTZY1gQ2n+ix113GX/OM26W9FFVaC+Cg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ZOuSjK218jsEm5W5cm6/bYWduTfdLx+m5ufI99UvZhE1TRJIjYMmkF2lgL91ubx9Q
	 y7+/ISZ1v/LrNFARM1hdw3/uyH+bz22X+DgzKQn1ocf92tenYiwNd2tBLDQUNPyqx6
	 wYQw2tbNAkck63EsT7DsyvurpqrkUhcPAtwAvAKbIbKF6C5pmHS62trR4G7xI6wV9k
	 cPqWWfRgBEDk81M9/lsixu4QfHPt/eu32Yez4mC/w++76rc/NCKHhXuIyYK2X6Y9RR
	 HkdnYWBTKdGEcS2ErCcF0BM8+NsR/suW8CPmZjITKVxUvaHZjhJlNeKGsXkdMnHmDx
	 7Iq31jbVPkS5A==
Subject:
 Re: [PATCH net-next 03/13] net/mlx5: LAG, allocate v2p_map dynamically
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 agoldberger@nvidia.com, cratiu@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 moshe@nvidia.com, ohartoov@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com
Date: Thu, 24 Sep 2026 17:45:54 +0000
Message-ID: <179027195430.2160803.6909532515243574175@kernel.org>
In-Reply-To: <20260923103830.1183-4-tariqt@nvidia.com>
References: <20260923103830.1183-4-tariqt@nvidia.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] v2p_map and the scratch `ports` buffer in mlx5_modify_lag() are
  now sized ldev->ports * MLX5_LAG_MAX_HASH_BUCKETS, where ldev->ports…
- [Medium] Before this patch, mlx5_modify_lag()
  (drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:861) used a zeroed…

--

net/mlx5: LAG, allocate v2p_map dynamically

This commit turns the fixed-size v2p_map array in struct mlx5_lag into a
pointer allocated in mlx5_lag_dev_alloc(). The new size uses ldev->ports
instead of MLX5_MAX_PORTS. The scratch ports[] buffer in mlx5_modify_lag()
moves from the stack to a kcalloc() of the same size.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> index c655f6e32e9b0..00b0159cb422f 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c

[ ... ]

> @@ -330,11 +331,16 @@ static struct mlx5_lag *mlx5_lag_dev_alloc(struct mlx5_core_dev *dev)
>  	if (!ldev)
>  		return NULL;
>  
> +	ldev->ports = MLX5_CAP_GEN(dev, num_lag_ports);
> +	ldev->buckets = 1;
> +	ldev->v2p_map = kcalloc(ldev->ports * MLX5_LAG_MAX_HASH_BUCKETS,
> +				sizeof(*ldev->v2p_map), GFP_KERNEL);

[Severity: High]
Is ldev->ports the right bound for this allocation?

The users of v2p_map index it by the PF's slot in the ldev->pfs xarray, not
by a dense port number. For example, in mlx5_infer_tx_affinity_mapping():

	mlx5_ldev_for_each(i, 0, ldev) {
		for (j = 0; j < buckets; j++) {
			idx = i * buckets + j;
			ports[idx] = mlx5_lag_xa_to_dev_idx(ldev, i) + 1;
		}
	}

The slot comes from mlx5_ldev_add_mdev(), which allocates it from the full
MLX5_MAX_PORTS range:

	err = xa_alloc(&ldev->pfs, &idx, pf, XA_LIMIT(0, MLX5_MAX_PORTS - 1),
		       GFP_KERNEL);
	...
	if (group_id)
		return 0;

	xa_set_mark(&ldev->pfs, idx, MLX5_LAG_XA_MARK_PORT);

sd_lag_init() adds Socket-Direct secondaries to the same xarray. They take
slots but never get the PORT mark. Given that, can a port PF end up at a
slot >= ldev->ports?

Here is an example. With num_lag_ports = 4, both buffers are now 64 bytes.
Say the SD primary takes slot 0 and its secondary takes slot 1. The fourth
port PF then lands in slot 4. Because ports > 2,
mlx5_lag_set_port_sel_mode() sets ldev->buckets to
MLX5_LAG_MAX_HASH_BUCKETS, so that PF would use indices 64..79.

Would this write past the end of v2p_map through
mlx5_activate_lag()->mlx5_infer_tx_affinity_mapping()? Would it also write
past the new ports[] buffer through mlx5_modify_lag()?

These readers look like they would go past the end the same way:
mlx5_modify_lag(), mlx5_lag_print_mapping(),
__mlx5_lag_modify_definers_destinations(),
mlx5_lag_create_port_sel_table() and mlx5_lag_get_slave_port(). The
out-of-bounds bytes would then be passed to mlx5_lag_pf_by_dev_idx() as
1-based device indices, and also used to program the port-selection table
and tx_remap_affinity.

Before this patch, both buffers were
MLX5_MAX_PORTS * MLX5_LAG_MAX_HASH_BUCKETS bytes, which covers every
possible slot. The rules[] array in struct mlx5_lag_definer (port_sel.h) is
indexed the same way and is still that size.

With this in mind, is the "No functional change" statement in the commit
message accurate? Should the buffers be sized by the slot range, or should
the indexing use the dense port sequence instead? Later patches in the
series still size both buffers by ldev->ports, so this does not appear to
be fixed later on.

> +	if (!ldev->v2p_map)
> +		goto err_v2p_map;

[ ... ]

> @@ -864,6 +873,12 @@ void mlx5_modify_lag(struct mlx5_lag *ldev,
>  		return;
>  
>  	dev0 = mlx5_lag_pf(ldev, first_idx)->dev;
> +
> +	ports = kcalloc(ldev->ports * MLX5_LAG_MAX_HASH_BUCKETS,
> +			sizeof(*ports), GFP_KERNEL);
> +	if (!ports)
> +		return;

[Severity: Medium]
Before this patch, mlx5_modify_lag() could not fail once first_idx was
valid. Now, if this kcalloc() fails, the function returns without a
message and skips all of the following:

  _mlx5_modify_lag()
  the v2p_map update
  mlx5_lag_drop_rule_setup()
  the MLX5_DRIVER_EVENT_ACTIVE_BACKUP_LAG_CHANGE_LOWERSTATE notifier

The drop-rule setup and the notifier are skipped even when the mapping has
not changed.

mlx5_modify_lag() returns void, so its callers cannot see the failure or
retry. That covers mlx5_do_bond() (called from mlx5_do_bond_work()) and
mlx5_lag_set_port_affinity() in mp.c. By this point ldev->tracker already
holds the new lower state.

Could the hardware TX affinity then keep pointing at a failed port until
some unrelated bond event arrives?

The buffer is at most MLX5_MAX_PORTS * MLX5_LAG_MAX_HASH_BUCKETS = 128
bytes. Could it stay on the stack, or be preallocated with v2p_map, so this
path does not gain a new failure mode?

> +
>  	mlx5_infer_tx_affinity_mapping(tracker, ldev, ldev->buckets, ports);

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260923103830.1183-1-tariqt%40nvidia.com
