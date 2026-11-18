Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794997920;
	b=qBqCqWGwSuQR5aJiC9Z1VVRhIgS5lKmSY87J7VfsR5x8eaT3aC4t/G62NAcXi5ihzWFG
	 OZSfxHyNUMmS2xxiwlKSb4FbC70cTnGtXyzCotax+F/o1w58o2QtpILUjAitEthXMYLeN
	 7cd2vH9/g7vNLRcobjWtBNAzdKz8PG4j8uSVLB95HCDqYH8wGcCPIXVuSkB/rWh94ddrJ
	 THkxGJVCU6MMcR8QfQsc6kruc8b1F2rhm18BI2wq9L7Xsk6GOjejQs+CeI8Wss6qDZmtT
	 jnTlq+vil3NmM5gh3vUaegBfx3ifve1kU38cWor0RoCopLy1p6NayoAodqqXapGYUBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794997920;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=vUDaTvuHrh3mVBGV0XI8KLL+YVaBFwQcVx5vyMv/fyk=;
	b=n2cDAzeWvk34IWBz5/qI87GWmooJz44BnwhNKCbcSdopt6QzUSg9tOF6Z1h7gaWsRpiU
	 lfAChPxhNBvUfyroAN1ZPQUf6mwEamhXAfVjWsIkgzCJ7UZhjwAD+00lY49QPTI8tRzsp
	 L1UNfYuPaXPugqrkS58xbUJtTa9eAnPHEvskIag5sn47k0isDbRVgt7yqz11ZPHhID362
	 3acVwSetmgumDKw75/ANxZXFdO4hTZd5Sc01OpVXn7+uW22rC5RcblHkzHK0EgwjICObT
	 wUjI4R1dLcAK6Cj72rWcfu6tlyxc+wRY3ALDgoHVW59LuHaz4dOeVdRwb4uHsFThf7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T1K8suaz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D544B60A2631;
	Wed, 18 Nov 2026 10:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T1K8suaz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A186E1F000CF;
	Wed, 18 Nov 2026 10:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794997920;
	bh=vUDaTvuHrh3mVBGV0XI8KLL+YVaBFwQcVx5vyMv/fyk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=T1K8suazXDmkT4riBj91hegerc2qOlLW/WEaQImrD0tHjRrQ8fc01GVHxt5rBk4Wf
	 kkRV/jhnf5bfYz2aqHVO+RBy5/CuuUU7/6TjczXvxSk+i5zyO4QZD/qRCjDx9x2QlZ
	 iXoKfeB5sNebEjiI6/L24gcWYwQ7bujKzZh759winvp9YzGQF+3xjnIz06ctsv+3o3
	 P+C6ksxX7kWscwZYy6bGy0PPphmAl71vF9x+NfcrLtOIdwFKWwoyDVHQ96oi5MGRQk
	 JCoofy4QLZVMMLBg9c6U/J+Kr7wIifwZEnFBbtMU2lF/JmF9b3i70omzfXbbwEhP1D
	 6YhetRzj1e9CQ==
Subject: Re: [PATCH net-next V2 09/10] net/mlx5: LAG, drop MLX5_MAX_PORTS
 scratch array from device rescan
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 cjubran@nvidia.com, cratiu@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 moshe@nvidia.com, ohartoov@nvidia.com, phaddad@nvidia.com, saeedm@nvidia.com,
 shayd@nvidia.com, udar@nvidia.com
Date: Wed, 18 Nov 2026 10:31:59 +0000
Message-ID: <179499791924.3136.16901930891335328702@kernel.org>
In-Reply-To: <20261116103010.1129666-10-tariqt@nvidia.com>
References: <20261116103010.1129666-10-tariqt@nvidia.com>
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

- [High] In mlx5_lag_rescan_devices_locked_filter()
  (drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c), this patch…

--

net/mlx5: LAG, drop MLX5_MAX_PORTS scratch array from device rescan

This commit removes the devs[MLX5_MAX_PORTS] array from
mlx5_lag_rescan_devices_locked_filter(). The post-unlock rescan loop now
walks the LAG members again with mlx5_lag_for_each(). The commit message
describes this as having no functional change.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> index a7b12353b7225..3e88b3f51612e 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c

[ ... ]

> @@ -1356,12 +1354,16 @@ static void mlx5_lag_rescan_devices_locked_filter(struct mlx5_lag *ldev,
>  			fn->dev->priv.flags &= ~MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
>  		else
>  			fn->dev->priv.flags |= MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
> -		devs[num_devs++] = fn->dev;
>  	}
>  
>  	mlx5_lag_drop_lock_for_reps(ldev, filter);
> -	for (i = 0; i < num_devs; i++)
> -		mlx5_rescan_drivers_locked(devs[i]);
> +	mlx5_lag_for_each(i, 0, ldev, filter) {
> +		fn = mlx5_lag_fn(ldev, i);
> +		if (fn->dev->priv.flags & MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV)
> +			continue;
> +
> +		mlx5_rescan_drivers_locked(fn->dev);
> +	}

[Severity: High]
This loop now walks ldev->fns after mlx5_lag_drop_lock_for_reps() has
released ldev->lock. Can a concurrent SD member removal free a lag_fn
while the walk is in progress?

On each step, mlx5_get_next_lag_func() reads xarray entries and fn->dev.
mlx5_lag_fn() then does an xa_load(), and the loop dereferences
fn->dev->priv.flags. The only thing guarding membership while the lock is
dropped is ldev->mode_changes_in_progress. The comment in
mlx5_lag_drop_lock_for_reps() says:

	/* Keep PF membership stable while ldev->lock is dropped. Device add
	 * and remove paths observe mode_changes_in_progress and retry.
	 */

The SD paths in lib/sd.c don't appear to check that counter, though.
sd_lag_cleanup() takes the lock directly:

	mutex_lock(&ldev->lock);
	mlx5_sd_for_each_secondary(i, primary, pos)
		mlx5_ldev_remove_mdev(ldev, pos);

mlx5_ldev_remove_mdev() then frees the entry right away, with no RCU
deferral:

	fn->dev = NULL;
	dev->priv.lag = NULL;
	xa_erase(&ldev->fns, fn->idx);
	kfree(fn);

sd_lag_cleanup() is serialized only by sd->devcom. For
MLX5_LAG_FILTER_ALL, this function runs under the HCA devcom instead.
mlx5_do_bond_work() takes only the HCA devcom trylock plus ldev->lock, and
not mlx5_mpesw_sd_devcoms_lock(). It reaches this function as follows:

mlx5_do_bond_work()
  mlx5_do_bond()
    mlx5_lag_shared_fdb_create(ldev, ..., MLX5_LAG_MODE_SRIOV, 0)
      mlx5_lag_remove_devices_filter(ldev, MLX5_LAG_FILTER_ALL)
        mlx5_lag_rescan_devices_locked_filter()

mlx5_disable_lag() -> mlx5_lag_shared_fdb_destroy(ldev, 0) reaches it the
same way. Group id 0 maps to MLX5_LAG_FILTER_ALL, which matches every
member, SD secondaries included.

At the same time, removing an SD member's eth aux driver can run:

mlx5e_remove() / mlx5e_suspend()
  mlx5_sd_cleanup()
    sd_lag_cleanup()
      mlx5_ldev_remove_mdev()

This removal can come from a sysfs unbind of mlx5_core.eth.N. It can also
come from a reload of an SD secondary whose hca_devcom_comp is NULL or in a
different component. Neither case holds the HCA devcom that the bond work
holds.

If that happens, mlx5_get_next_lag_func() could read fn->dev from a freed
lag_fn. mlx5_lag_fn() could also return NULL after xa_erase(), and the
loop would then dereference it.

The old loop touched only the devs[] core_dev pointers once the lock was
dropped. Those pointers stay valid across an aux unbind, so lag_fn and
xarray state was never accessed without the lock.

A similar question applies to sd_lag_init(), which also takes ldev->lock
without checking mode_changes_in_progress and calls mlx5_ldev_add_mdev().
Could the second loop then rescan a newly added member whose
MLX5_PRIV_FLAGS_DISABLE_IB_ADEV flag the first loop never updated?

Given the above, is the "no functional change" statement in the commit
message accurate?

Would it be safer to keep a snapshot taken under the lock? For example, a
dynamically sized array, or a reference on each core_dev collected before
mlx5_lag_drop_lock_for_reps().

As far as I can tell, the last patch in the series doesn't touch this
function or the SD paths, so this would still be present at the end of the
series.

>  	mlx5_lag_retake_lock_after_reps(ldev);
>  }
>

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116103010.1129666-1-tariqt%40nvidia.com
