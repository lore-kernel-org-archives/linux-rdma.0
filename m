Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2973372618;
	Mon, 21 Sep 2026 18:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790016545; cv=none; b=CMdNU/biXTDp//B4MjprsGqkOc5PShL2sZ243tALu4nLbbjRkt1z/BdNqyJKuEfsp5yaBP102BkOJYb79U9LZg9+tlTX4SHjuggVlhrbxcuxgqCgMaHUADijZbQ2SubuN7gzUGoa4Qu8rh0iFVj99MMK3t4BEv/yGhAfu95h6VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790016545; c=relaxed/simple;
	bh=bYoV4ac+ByHFszr44RZZsqVOqcCekHPJCFcuRTvwiTQ=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Dsfw5iNNmDhAq97e06XtYehGG8iuHzChLyx/XQeCQoUsa0rxF7K+hNxlBqVD27fXmug8TydOz8p9Nn0hklTO2r5q0hNgnkNRkvcyLnWo1RCGmt4s0e/fSgpSNdwh/tX01neUxvL8kJ7PJB228VpvLp+Jj+lR9kd9ONgZKpiM5T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dxYwtnIq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dxYwtnIq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE461F00898;
	Mon, 21 Sep 2026 18:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790016543;
	bh=i0g5jY5uAgqSTPkkPjTSAM5Pp+ApHo0ckOc9B9VGkHM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=dxYwtnIq2SoTET15zvYXk8WWSO9u5SFPMoPJ0po7WESGzUHvbEhHoEXnifeAo8mgr
	 8AIabNdILh4RgAG/SHFbDOnP6gCjPJL+BOSDhkw6G3pEVbJFhn/JbF1MqTHCmlt87o
	 we1GbDFjX2ieib5YmZEiDNAmki+t8cYTWrayt+XLW3BiIEMgMUGYP0vLRr9LbAyDC0
	 0Is5jgoWrLomAxSWXqRQTVgFXmY2Ed7F9W1aIAK2ilL1+GCJLHS8H9MqUtrbL9UKYw
	 r/iq8rcTsnT/LZKmf61CpYFi4PIxSvTkMfEemmvC7sdUD1KjnKE+t9kNrzIZvRhEf6
	 N91tM5n2Jbleg==
Subject: Re: [PATCH net 1/7] net/mlx5e: ipsec: Block eswitch mode changes
 during policy creation
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 sd@queasysnail.net, borisp@nvidia.com, cjubran@nvidia.com, cratiu@nvidia.com,
 daniel.zahka@gmail.com, dtatulea@nvidia.com, ehakim@nvidia.com,
 gal@nvidia.com, jianbol@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, liorna@nvidia.com,
 mbloch@nvidia.com, parav@nvidia.com, raeds@nvidia.com, rrameshbabu@nvidia.com,
 roid@nvidia.com, saeedm@nvidia.com, steffen.klassert@secunet.com
Date: Mon, 21 Sep 2026 18:49:01 +0000
Message-ID: <179001654155.2160803.10642575868860131608@kernel.org>
In-Reply-To: <20260917175433.4090878-2-tariqt@nvidia.com>
References: <20260917175433.4090878-2-tariqt@nvidia.com>
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

Critical: 0 · High: 0 · Medium: 1 · Low: 0 (1)

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] `mlx5e_xfrm_add_policy()`
  (drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c:1268-1274)…

Pre-existing issues:
- [Low] Incomplete-fix concern: at this commit `mlx5e_xfrm_add_state()`
  (drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c:781-813)…

--

net/mlx5e: ipsec: Block eswitch mode changes during policy creation

This moves the eswitch mode block in mlx5e_xfrm_add_policy() to the top of
the function, before priv->ipsec is checked and the policy is validated, and
releases it once the flow table holds its own block or after unwinding.
A check_users argument is added to mlx5_eswitch_block_mode() /
mlx5_esw_try_lock() so the new temporary block does not reject policies while
TC users are present.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> index db260e3d1412f..841ecdc2c4d9e 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> @@ -806,7 +806,7 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
>  		goto err_xfrm;
>  	}
>  
> -	err = mlx5_eswitch_block_mode(priv->mdev);
> +	err = mlx5_eswitch_block_mode(priv->mdev, true);
>  	if (err)
>  		goto unblock_ipsec;

[Severity: Low]
This isn't a bug introduced by this patch, but as of this commit
mlx5e_xfrm_add_state() still has the ordering the changelog describes as
unsafe: priv->ipsec is tested, cached into ipsec and sa_entry->ipsec, and
dereferenced through mlx5e_ipsec_fs_tunnel_allowed(sa_entry) before the
mode block above is taken.

	priv = netdev_priv(dev);
	if (!priv->ipsec)
		return -EOPNOTSUPP;

	ipsec = priv->ipsec;
	...
	err = mlx5_eswitch_block_mode(priv->mdev, true);

The immediately following patch in the series, "net/mlx5e: ipsec: Block
eswitch mode changes before accessing priv->ipsec", moves the block to the
top of mlx5e_xfrm_add_state() and adds the matching unblock_mode: unwind, so
the ordering is consistent again at the end of the series. Would it be worth
mentioning in this changelog that the SA path is handled in the next patch,
so this intermediate state is not read as an oversight?

> @@ -1266,18 +1266,28 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
>  	int err;
>  
>  	priv = netdev_priv(netdev);
> +	/* Block esw mode changes until the policy holds its own block. */
> +	err = mlx5_eswitch_block_mode(priv->mdev, false);
> +	if (err) {
> +		NL_SET_ERR_MSG_MOD(extack, "Eswitch busy, can't add policy");
> +		return err;
> +	}
> +

[Severity: Medium]
Can this make policy adds fail spuriously with -EINVAL?

The new block is taken on every policy add, and mlx5_esw_try_lock() bails out
before the check_users test:

drivers/net/ethernet/mellanox/mlx5/core/eswitch.c:mlx5_esw_try_lock() {
	if (down_write_trylock(&esw->mode_lock) == 0)
		return -EINVAL;
	...
}

So passing check_users=false does not help when the mode_lock is simply held
by someone else at that moment. A concrete reader is the TC path, which holds
the read side across the whole flow creation:

drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:mlx5e_configure_flower() {
	if (!mlx5_esw_hold(priv->mdev))
		return -EBUSY;
	...
	err = mlx5e_tc_add_flow(priv, f, flags, dev, &flow);
	...
	mlx5_esw_release(priv->mdev);
}

mlx5e_ipsec_block_tc_offload(), mlx5_eswitch_unblock_mode() and
mlx5_devlink_switchdev_active_mode_change() take the write side with a
blocking down_write().

The errno is passed straight to userspace:

net/xfrm/xfrm_device.c:xfrm_dev_policy_add() {
	err = dev->xfrmdev_ops->xdo_dev_policy_add(xp, extack);
	if (err) {
		...
		return err;
	}
}

Before this change, a policy add that reused already-created tables never ran
a trylock at all:

drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c:rx_get() {
	if (rx->ft.refcnt)
		goto skip;

	err = mlx5_eswitch_block_mode(mdev, true);
	...
}

which is the same "TC rule on a VF representor" case the changelog wants to
keep working. Would an ip xfrm policy add now fail immediately, with no wait
and no retry, whenever it overlaps a tc filter add on a representor?

Also, the extack text says "Eswitch busy" while the returned errno can be
-EINVAL, which the kernel-doc updated by this patch defines as "lock is
already held" rather than a busy/retriable condition. Should the transient
trylock collision be reported as -EBUSY so userspace can tell it apart from a
permanent validation rejection?

>  	if (!priv->ipsec) {
>  		NL_SET_ERR_MSG_MOD(extack, "Device doesn't support IPsec packet offload");
> -		return -EOPNOTSUPP;
> +		err = -EOPNOTSUPP;
> +		goto unblock_mode;
>  	}
>  
>  	err = mlx5e_xfrm_validate_policy(priv->mdev, x, extack);
>  	if (err)
> -		return err;
> +		goto unblock_mode;
>  
>  	pol_entry = kzalloc_obj(*pol_entry);
> -	if (!pol_entry)
> -		return -ENOMEM;
> +	if (!pol_entry) {
> +		err = -ENOMEM;
> +		goto unblock_mode;
> +	}
>  
>  	pol_entry->x = x;
>  	pol_entry->ipsec = priv->ipsec;
> @@ -1293,6 +1303,7 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
>  		goto err_fs;
>  
>  	x->xdo.offload_handle = (unsigned long)pol_entry;
> +	mlx5_eswitch_unblock_mode(priv->mdev);
>  	return 0;
>  
> err_fs:
> @@ -1300,6 +1311,8 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
> ipsec_busy:
>  	kfree(pol_entry);
>  	NL_SET_ERR_MSG_MOD(extack, "Device failed to offload this policy");
> +unblock_mode:
> +	mlx5_eswitch_unblock_mode(priv->mdev);
>  	return err;
>  }

[ ... ]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> index fc197d1dc9dfe..0b48cc7a67343 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> @@ -3005,21 +3005,22 @@ void mlx5_esw_put(struct mlx5_core_dev *mdev)
>  /**
>   * mlx5_esw_try_lock() - Take a write lock on esw mode lock.
>   * @esw: eswitch device.
> + * @check_users: reject the lock if eswitch users exist.
>   *
>   * Should be called by esw mode change routine.
>   *
>   * Return:
> - * * 0       - esw mode if successfully locked and refcount is 0.
> - * * -EBUSY  - refcount is not 0.
> - * * -EINVAL - In the middle of switching mode or lock is already held.
> + * * >= 0    - esw mode if successfully locked.
> + * * -EBUSY  - mode change in progress or users exist with check_users set.
> + * * -EINVAL - lock is already held.
>   */
> -int mlx5_esw_try_lock(struct mlx5_eswitch *esw)
> +int mlx5_esw_try_lock(struct mlx5_eswitch *esw, bool check_users)
>  {
>  	if (down_write_trylock(&esw->mode_lock) == 0)
>  		return -EINVAL;
>  
>  	if (esw->eswitch_operation_in_progress ||
> -	    atomic64_read(&esw->user_count) > 0) {
> +	    (check_users && atomic64_read(&esw->user_count) > 0)) {
>  		up_write(&esw->mode_lock);
>  		return -EBUSY;
>  	}

[ ... ]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index eb74b62601682..996490e116253 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> @@ -4351,8 +4351,7 @@ int mlx5_eswitch_block_mode(struct mlx5_core_dev *dev)
>  	if (!mlx5_esw_allowed(esw))
>  		return 0;
>  
> -	/* Take TC into account */
> -	err = mlx5_esw_try_lock(esw);
> +	err = mlx5_esw_try_lock(esw, check_users);
>  	if (err < 0)
>  		return err;

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260917175433.4090878-1-tariqt%40nvidia.com
