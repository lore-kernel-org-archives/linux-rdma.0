Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFC6308F07;
	Wed,  7 Oct 2026 00:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334273; cv=none; b=t+1uPrhEMo4uvKH9xUCK0vXBhrbkXQ9EwVxewyXiSMG8ZX63fTA06NVNZsHBaXTAlsPeXjyYe76g9Nec/xf0AN8le/Ut8wiUEcJKc6jwKc2ocUm129jovpFh6KsPoZ2gDYj3kZ4LlBTTNEjF2VZgafFzcO6I4GiaDZ32cxeLPF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334273; c=relaxed/simple;
	bh=lIQZ7eq6UC5pl2Vc5WNTuNSuPRM7XmllbT3i+7AQdlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efAn1I8iTBRuBG7R3p8fokphsq5hyOu+Xb74r8HarvEFxspXXkm1Ekg/ECbjyYQxdEsaQtPdLEuaSGCOwsXCgq5ya5ajoaqDggUMHhDeNRKot5TR2JT0sxWN+RDfMkGHbvQjjkYMpBqbXNUKCblkIucjnLgDgps4JxJpGVRhhd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TGrky32N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TGrky32N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3149D1F0089F;
	Wed,  7 Oct 2026 00:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791334271;
	bh=lyJYA6zWZIgvnYgMlO8dRgk6YnVqnolEHHJmiel5PpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TGrky32NQXYXgTDkCRfR1Xx+UlUlQ4BdqVjDwh7FuOKz9SNV2SDZy0xrEm+TqxPUp
	 WCnbPn+5oM9S/v/hlpoABNHBTI5htxsn7WFxtc6K+I8HsX+gVdwGIiJpbTxClHyOgn
	 j3ONlGbp/7tFdSViGZVtBb4K0oQF9nGwzILTSf64krozg+jWV5HnJ52IK0YmtlDgib
	 drQKM0ZIrBfj6POk6PnR1XLUxVTGVDJDY4xKBZnVh/Dvwkdw4SiHbqHCe22JnzkVCJ
	 JZN4HwEOl0VkLYbaFGx7k83a9Y0tcExFawjXkm61BtDzBzzN7PAJiDlxGfjuqagPoD
	 cf1ORNM/F5hKg==
From: Jakub Kicinski <kuba@kernel.org>
To: tariqt@nvidia.com
Cc: Jakub Kicinski <kuba@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	parri.andrea@gmail.com,
	borisp@nvidia.com,
	cjubran@nvidia.com,
	cratiu@nvidia.com,
	dtatulea@nvidia.com,
	fmancera@suse.de,
	gal@nvidia.com,
	jianbol@nvidia.com,
	kees@kernel.org,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	mbloch@nvidia.com,
	parav@nvidia.com,
	phaddad@nvidia.com,
	raeds@nvidia.com,
	roid@nvidia.com,
	saeedm@nvidia.com,
	steffen.klassert@secunet.com
Subject: Re: [PATCH net V2 1/4] net/mlx5e: ipsec: Block eswitch mode changes during policy creation
Date: Tue,  6 Oct 2026 17:51:09 -0700
Message-ID: <20261007005109.2944293-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930121119.141953-2-tariqt@nvidia.com>
References: <20260930121119.141953-2-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email says "Auto-emailing seemed not to have triggered."
---
net/mlx5e: ipsec: Block eswitch mode changes during policy creation

This commit takes a temporary eswitch mode block at the start of
mlx5e_xfrm_add_policy() and releases it once the flow tables hold their
own reference. It also adds a check_users argument to
mlx5_eswitch_block_mode() and mlx5_esw_lock(), and switches
mlx5_eswitch_block_mode() from mlx5_esw_try_lock() to mlx5_esw_lock().

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> index db260e3d1412f..841ecdc2c4d9e 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c

[ ... ]

> @@ -1266,18 +1266,28 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
>  	int err;
>  
>  	priv = netdev_priv(netdev);
> +	/* Block esw mode changes until the policy holds its own block. */
> +	err = mlx5_eswitch_block_mode(priv->mdev, false);

[Severity: High]

Can priv->mdev be NULL at this point? mlx5_eswitch_block_mode() reads
dev->priv.eswitch right away.

mlx5e_priv_cleanup() does memset(priv, 0, sizeof(*priv)), but the netdev
stays registered and keeps its xfrmdev_ops. One case is the
switchdev->legacy profile swap in mlx5e_vport_uplink_rep_unload(). The
state becomes permanent if a profile change and its rollback both fail.

xfrm_dev_policy_add() only checks that xdo_dev_policy_add exists, so this
path looks reachable:

xfrm_dev_policy_add()
  mlx5e_xfrm_add_policy()
    mlx5_eswitch_block_mode(NULL, false)
      esw = dev->priv.eswitch;

Before this patch, the !priv->ipsec check ran first and returned
-EOPNOTSUPP.

The next patch in the series, "net/mlx5e: ipsec: Block eswitch mode
changes before accessing priv->ipsec", adds a !mdev check before this
call. Without that patch, this commit oopses with CONFIG_MLX5_ESWITCH=y.

[Severity: High]

Can this blocking down_write() deadlock against driver unload or devlink
reload? The xfrm core calls this callback with a netdev reference held.
xfrm_dev_policy_add() takes it with dev_get_by_index(), and the call runs
under xfrm_cfg_mutex.

On the unload side, mlx5_eswitch_safe_aux_devs_remove() holds
esw->mode_lock for read across the uplink netdev unregister:

CPU1
_mlx5e_remove()
  mlx5_eswitch_safe_aux_devs_remove()
    mlx5_esw_hold()                  /* mode_lock held for read */
    mlx5_core_reps_aux_devs_remove()
      ...
      mlx5e_vport_uplink_rep_unload()
        unregister_netdev()
          netdev_wait_allrefs_any()  /* waits for CPU0's netdev ref */

CPU0
xfrm_dev_policy_add()
  dev_get_by_index()
  mlx5e_xfrm_add_policy()
    mlx5_eswitch_block_mode()
      mlx5_esw_lock()
        down_write(&esw->mode_lock)  /* waits for CPU1's read hold */

CPU0's policy isn't inserted yet, so the unregister flush never reaches
it. Each task then waits on the other forever. xfrm_cfg_mutex stays held,
so XFRM configuration in the netns would hang as well.

Before this patch, mlx5_eswitch_block_mode() used down_write_trylock()
and failed at once. mlx5e_xfrm_add_state(), rx_get() and tx_get() get the
same trylock-to-blocking change. The mlx5_eswitch_unblock_mode() on the
success path here is another down_write().

At baseline, mlx5e_ipsec_block_tc_offload()->mlx5_esw_lock() already
took the lock in a similar blocking way. The later patch "net/mlx5e:
Serialize TC and IPsec offload exclusion counters" removes that
acquisition, which leaves these block_mode/unblock_mode calls as the ones
that can trigger the hang. The lock is now also taken for policies that
fail validation and for devices without IPsec.

> +	if (err) {
> +		NL_SET_ERR_MSG_MOD(extack, "Eswitch busy, can't add policy");
> +		return err;
> +	}
> +
>  	if (!priv->ipsec) {
>  		NL_SET_ERR_MSG_MOD(extack, "Device doesn't support IPsec packet offload");
> -		return -EOPNOTSUPP;
> +		err = -EOPNOTSUPP;
> +		goto unblock_mode;
>  	}

[ ... ]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> index 8ffa8068e90ac..cd7ff36135244 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> @@ -1127,7 +1127,7 @@ static int rx_get(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
>  	if (rx->ft.refcnt)
>  		goto skip;
>  
> -	err = mlx5_eswitch_block_mode(mdev);
> +	err = mlx5_eswitch_block_mode(mdev, true);
>  	if (err)
>  		return err;

[Severity: High]

This is a pre-existing issue and was not introduced by this patch. This
patch adds more blocking down_write() sites on mode_lock, though. Can
the release side of this reference self-deadlock during driver unload or
devlink reload in switchdev mode?

mlx5_eswitch_safe_aux_devs_remove() holds esw->mode_lock for read while
it unregisters the uplink netdev. NETDEV_UNREGISTER then flushes the
offloaded policies in the same task:

mlx5_eswitch_safe_aux_devs_remove()
  mlx5_esw_hold()            /* down_read_trylock(&esw->mode_lock) */
  mlx5_core_reps_aux_devs_remove()
    ...
    mlx5e_vport_uplink_rep_unload()
      unregister_netdev()
        xfrm_dev_unregister()
          xfrm_dev_policy_flush()
            xfrm_policy_kill()
              xfrm_dev_policy_delete()
                mlx5e_xfrm_del_policy()
                  mlx5e_accel_ipsec_fs_del_pol()
                    rx_ft_put_policy()
                      rx_put()
                        mlx5_eswitch_unblock_mode()
                          down_write(&esw->mode_lock)

tx_put() has the same pattern. An rwsem read hold can't be upgraded to a
write hold.

Wouldn't the task hang whenever an offloaded IPsec policy exists on the
uplink at unload time? The read hold comes from commit 2ae8c7edea87f5,
and this path is still there at the end of the series.

[ ... ]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index eb74b62601682..95e856f8d834d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> @@ -4343,7 +4343,7 @@ static int esw_inline_mode_to_devlink(u8 mlx5_mode, u8 *mode)
>  	return 0;
>  }
>  
> -int mlx5_eswitch_block_mode(struct mlx5_core_dev *dev)
> +int mlx5_eswitch_block_mode(struct mlx5_core_dev *dev, bool check_users)
>  {
>  	struct mlx5_eswitch *esw = dev->priv.eswitch;
>  	int err;
> @@ -4351,9 +4351,8 @@ int mlx5_eswitch_block_mode(struct mlx5_core_dev *dev)
>  	if (!mlx5_esw_allowed(esw))
>  		return 0;
>  
> -	/* Take TC into account */
> -	err = mlx5_esw_try_lock(esw);
> -	if (err < 0)
> +	err = mlx5_esw_lock(esw, check_users);
> +	if (err)
>  		return err;

[Severity: Medium]

This replaces mlx5_esw_try_lock() with mlx5_esw_lock(). The old function
used down_write_trylock() and returned -EINVAL when mode_lock was held.
The new one does an unconditional down_write().

All existing callers now sleep waiting for mode_lock where they used to
fail right away. That covers mlx5e_xfrm_add_state(), rx_get() and
tx_get(). rx_get() and tx_get() run under rx->ft.mutex and tx->ft.mutex.

The commit message only says:

    To avoid that, I was forced to separate the mode blocking from the TC
    check by introducing a check_users argument to
    mlx5_eswitch_block_mode().

Could the commit message also mention the switch from trylock to a
blocking acquisition? It adds a new lock dependency, as described in the
deadlock question in mlx5e_xfrm_add_policy() above.
