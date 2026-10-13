Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0EC3F485E;
	Tue, 13 Oct 2026 10:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791887137; cv=none; b=GWIt1LGGDFBaR2m8e+iL9mc1VQ6fAUdfdlR7rpGoKKQDlIksfOyKtSIgM9ZrJ/AM2hQKkDn5QsnSBqtwSBM6T0h/Eoq7VKpjcVJ61Ryb7cXOETnPwUIMjsYUqIP9Qyr1DVLW04P2Xh+XiRXvOMFlaPD9FYUD83OM1n069ni5p2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791887137; c=relaxed/simple;
	bh=9IS4tJhckiGJ8BxKmoljWf8k9/WOYJOox6WgbjWD2Xk=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZXnxlffDn6mYsz1xZ2ea7TBqdcpgRkaIZ7NomQEmTazq8ueM7vEefGbbz4TReJnCWX4hASL0DUGFZ9ehQavjfpTOvYzqypYXBNllGQNmE34Upb18f9ekfne6+myarySt9oVSuIPasP/hy7wvpDTpDf6Fr4cYGm8CwwYqqei1/aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mUjz5sLn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mUjz5sLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B51D1F000FF;
	Tue, 13 Oct 2026 10:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791887135;
	bh=Ju32O3/kwQg+IOA3Ruu5zdEPslNO4TgTcZRe2EAX9lE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=mUjz5sLnccksSGKBLPgxEkeZYXgzH7QPz4P9xXMFrWfdqW4JNaOpao8HX94BzdmYp
	 VKgqf78Ae99BrbQ4hxnwt/pgoA6rYsB6BCXSJdbqotq0T+fLTUrDcG2badD1IDjNAA
	 85qSsvP2dfF++0HYCTs+2qDA10DB8cKP6X3xcmmONzHOs6J7suc8O3iK2auSsLXizn
	 rfb9dwkg8hBF2M/KVxyC4U1b4YXn/t0iG8Sw3E85nYpIDoqO1kBRZW2vMgpXQNy3+Q
	 3VAXoeZFB/24Js7rCFjjjXQIjRDyQv/Fsi8NF+6wL0BuaX9CF3rIAzqlhkgHlktE1f
	 hOnSdndVpPaLw==
Subject: Re: [PATCH net v2 1/2] net/mlx5: HWS, fix reformat pool creation race
From: netdev-bot+sashiko@kernel.org
To: acassen@corp.free.fr
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, moshe@nvidia.com, kliteyn@nvidia.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Date: Tue, 13 Oct 2026 10:25:34 +0000
Message-ID: <179188713478.434549.9962943324361402162@kernel.org>
In-Reply-To: <20261012100555.1317878-2-acassen@corp.free.fr>
References: <20261012100555.1317878-2-acassen@corp.free.fr>
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

Critical: 0 · High: 0 (1) · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The commit message says the race is reachable because 'RDMA
  flow actions on the FDB don't' serialize reformat allocations.

Pre-existing issues:
- [High] mlx5_cmd_hws_packet_reformat_dealloc() releases
  MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL reformats into the wrong pool.

--

net/mlx5: HWS, fix reformat pool creation race

This patch replaces xa_insert() in mlx5_fs_get_pr_encap_pool() with
xa_cmpxchg(). When two callers create the first reformat pool of a given
size at the same time, the loser now frees its pool and returns the
existing one instead of failing with -EBUSY.

> TC serializes these
> allocations under encap_tbl_lock while RDMA flow actions on the FDB
> don't.

[Severity: Medium]
Can the RDMA trigger described here actually be reached? In
drivers/infiniband/hw/mlx5/fs.c, the
MLX5_IB_METHOD_FLOW_ACTION_CREATE_PACKET_REFORMAT handler calls
mlx5_ib_flow_action_packet_reformat_valid() first, and that returns false
for FDB tables:

    if (!mlx5_ib_flow_action_packet_reformat_valid(mdev, dv_prt, ft_type))
        return -EOPNOTSUPP;

The encap types are only accepted for MLX5_IB_UAPI_FLOW_TABLE_TYPE_NIC_TX,
which mlx5_ib_ft_type_to_namespace() maps to MLX5_FLOW_NAMESPACE_EGRESS.

HWS cmds are only installed on the FDB root, because
mlx5_flow_root_namespace_set_mode() rejects anything other than FS_FT_FDB.
So RDMA requests never seem to reach mlx5_cmd_hws_packet_reformat_alloc().

The race does look reachable through TC. mlx5e_encap_put() drops
encap_tbl_lock before it calls mlx5e_encap_dealloc():

    mutex_unlock(&esw->offloads.encap_tbl_lock);

    mlx5e_encap_dealloc(priv, e);

On that path, the L2_TO_L3_TUNNEL case in
mlx5_cmd_hws_packet_reformat_dealloc() can create an el2tol2tnl pool (see
below). That can happen at the same time as a TC allocation made under
encap_tbl_lock.

Could the commit message name the path that actually reaches
mlx5_fs_get_pr_encap_pool() without serialization?

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
>  
> -cleanup_pr_pool:
>  	mlx5_fs_hws_pr_pool_cleanup(pr_pool);
> +	kfree(pr_pool);
> +	return xa_is_err(old) ? ERR_PTR(xa_err(old)) : old;
> +
>  free_pr_pool:
>  	kfree(pr_pool);
>  	return ERR_PTR(err);

[Severity: High]
This isn't a bug introduced by this patch, but one of the other callers of
mlx5_fs_get_pr_encap_pool() looks up the wrong pool for
MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL:

drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c:mlx5_cmd_hws_packet_reformat_dealloc() {
    ...
	case MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL:
		pr_pool = mlx5_fs_get_pr_encap_pool(dev, &hws_pool->el2tol2tnl_pools,
						    MLX5HWS_ACTION_TYP_REFORMAT_L2_TO_TNL_L2,
						    pr_data->data_size);
		break;
    ...
}

The alloc side in mlx5_cmd_hws_packet_reformat_alloc() uses
el2tol3tnl_pools and MLX5HWS_ACTION_TYP_REFORMAT_L2_TO_TNL_L3. Should the
dealloc case use them too?

The lookup is get-or-create, so the free path can allocate a new L2 pool.
If that allocation fails, "Failed release packet-reformat" is logged and
the function returns early. Does that leak pr_data->data and the pool
index?

mlx5_fs_hws_pr_pool_release_pr()->mlx5_fs_pool_release_index() then takes
the L2 pool's pool_lock and updates the L2 pool's counters. On a fresh
pool, used_units goes negative, and the owning L3 pool's used_units is
never decremented.

When the last entry of the bulk is released, this runs against the L2
pool:

	if (bulk_free_amount == bulk->bulk_len) {
		list_del(&bulk->pool_list);
		if (fs_pool->available_units > fs_pool->threshold)
			mlx5_fs_pool_free_bulk(fs_pool, bulk);
		else
			list_add(&bulk->pool_list, &fs_pool->unused);
	}

The bulk is still linked on the L3 pool's partially_used list, and the L3
pool_lock is not held here.

mlx5e_encap_put() calls the dealloc after it drops encap_tbl_lock. Could a
concurrent L3 acquire, holding only the L3 pool_lock, race with this
list_del() and mlx5_fs_pool_free_bulk()? That could corrupt the list or
cause a use-after-free of the bulk and its hws_action.

If the bulk goes onto the L2 pool's unused list instead, could later
L2_TO_L2_TUNNEL encaps be given an L3 tunnel hws_action? The hardware
would then apply the wrong reformat.

This can be reached with an MPLSoUDP encap on a switchdev eswitch that uses
HMFS FDB steering. The code comes from aecd9d1020e3, the same commit named
in this patch's Fixes: tag.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261012100555.1317878-1-acassen%40corp.free.fr
