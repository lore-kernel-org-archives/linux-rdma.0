Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293494718D9;
	Thu, 10 Sep 2026 21:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789077269; cv=none; b=o7mWpWBGT7yHfjAwt69Ya6vW8PH2EcRhao1ohSOUjNe81eKyS9+Ok/mDfMakdwvb6HLQcr6ghHrZgxrc98BVoTA8eTi6daGgoNI6WZEVBIEmC6Xb1wF7Zjce5uwBgiGPWZinRXgg8lXMD2sGYv+VJTIfoCcu7rVSV858QTQpbOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789077269; c=relaxed/simple;
	bh=OT6GnDgI18xsRP8hFAtxwkrxspEEHfCgg1qOln6kEsA=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UEfDIstNmd8aHJcb2FIgPIxaSVfxjqv+34OPm+VbluJ36Bz3oliRzJuu6vDZpNtvEAYwyBmoBNW5qSrqaP10nZDjQDGvi+PClEW7I2qq+U/lYmYONwKH/eTDamzrgmKrRAAm0yiut5SKiSrFFycMszc6GLYpSUG0xyPq/OOgr+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IUdtbNXZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IUdtbNXZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A871F000FF;
	Thu, 10 Sep 2026 21:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789077268;
	bh=Dd22KkAnH9jCQik7nISSCxzu2HoCC0m3CAnmozoRZpU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=IUdtbNXZubcmRsdb/lGUPFFcoywwv2CH9GA4V9PtWSWQ3nDaHg4F4wLwVSXiK4f6J
	 lHs7eU3hFkw1OIcHYRGjslfTXcIOgT3r0hy1dFrxzEWqKCZi2fiASyZLlH7qlYDrcQ
	 E2Lg53AFHZhkMgI140pHT8W7qI6FyvkPiLBffF0Fi7qrvC0AXP1DPT9I8eZPW6aXGc
	 jQDr7Z1gxGdS/ZYLR4YDt2fW/dJFFOL0GgAf7YRYu/VAJg/ZvMSfA3p+hqV83KyvAp
	 5o4mtrlaMJTF8WA5cIpsmx4LjPO1P3sBA4Am9pUhosz49vFesCKPtDnixZDL/c1da9
	 uveJAKQOdpTmQ==
Subject: Re: [PATCH net-next V4 01/14] net/mlx5e: Generalize TC <-> IPsec
 mutual exclusion
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 sd@queasysnail.net, bobbyeshleman@meta.com, borisp@nvidia.com,
 cjubran@nvidia.com, cratiu@nvidia.com, daniel.zahka@gmail.com, doruk@0sec.ai,
 dtatulea@nvidia.com, gal@nvidia.com, jianbol@nvidia.com, kees@kernel.org,
 leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, petrm@nvidia.com, raeds@nvidia.com, rrameshbabu@nvidia.com,
 saeedm@nvidia.com, shuah@kernel.org, skhan@linuxfoundation.org,
 horms@kernel.org, willemb@google.com, willemdebruijn.kernel@gmail.com
Date: Thu, 10 Sep 2026 21:54:25 +0000
Message-ID: <178907726586.219967.4695695146458742597@kernel.org>
In-Reply-To: <20260908065244.3799142-2-tariqt@nvidia.com>
References: <20260908065244.3799142-2-tariqt@nvidia.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider:

Critical: 0 · High: 0 (1) · Medium: 1 (1) · Low: 1

- [Medium] Silent removal of the eswitch-operation gate on the accel
  (IPsec packet-offload) rule-installation path.
- [Low] The patch fixes a real, pre-existing race on the TC/accel mutual-
  exclusion counters (both decrement paths were previously completely…

Pre-existing issues:
- [High] offload_block.num_accel is leaked on the driver's own flow-
  teardown path, permanently blocking all accel offload on the device.
- [Medium] Both unblock paths drop the counter before the corresponding
  hardware rules are actually gone, so the exclusion the mechanism…

--

net/mlx5e: Generalize TC <-> IPsec mutual exclusion

This generalizes the existing TC <-> IPsec mutual exclusion so other accel
protocols can use it: the helpers move to en_accel.h, the two mdev counters
move into a new offload_block struct, and the conditional eswitch write lock
is replaced by a dedicated mutex. Underflow warnings are added on both
decrement paths.

A few questions below.

The commit message says:

    - replace the conditional use of the esw write lock as a protection for
      incrementing the counter with a new mutex. The esw might not be
      available, and it wasn't used correctly on the decrement path anyway,
      allowing races to happen. Using a dedicated mutex for these counters
      makes it clear and avoids races.

[Severity: Low]

This paragraph describes an actual race fix, but the patch carries no
Fixes: tag; c8e350e62fc5 is only cited as background.

Before this patch both decrement sites were completely unserialized:

    static void mlx5e_ipsec_unblock_tc_offload(struct mlx5_core_dev *mdev)
    {
            mdev->num_block_tc--;
    }

and

    priv->mdev->num_block_ipsec--;

the latter reached from mlx5e_delete_flower(), which takes no esw lock at
all. Two concurrent unblocks on the same mlx5_core_dev (two xfrm SA
deletions, or an SA delete concurrent with tc filter del) can lose an
update and leave the counters wrong.

Would a Fixes: tag pointing at c8e350e62fc5 be appropriate here? As it
stands the race fix is entangled with the renames, the move to en_accel.h
and the new anonymous struct in include/linux/mlx5/driver.h, so it cannot
be picked up for stable as-is. Would splitting the locking fix from the
rename/move make that possible?

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
> index 3f212e46fc2f9..8a2ea76164404 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
> @@ -218,6 +218,28 @@ static inline void mlx5e_accel_tx_finish(struct mlx5e_txqsq *sq,
>  #endif
>  }
>  
> +static inline int mlx5e_accel_block_tc_offload(struct mlx5_core_dev *mdev)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&mdev->offload_block.lock);
> +	if (mdev->offload_block.num_accel)
> +		ret = -EBUSY;
> +	else
> +		mdev->offload_block.num_tc++;
> +	mutex_unlock(&mdev->offload_block.lock);
> +
> +	return ret;
> +}
> +
> +static inline void mlx5e_accel_unblock_tc_offload(struct mlx5_core_dev *mdev)
> +{
> +	mutex_lock(&mdev->offload_block.lock);
> +	if (!WARN_ON_ONCE(!mdev->offload_block.num_tc))
> +		mdev->offload_block.num_tc--;
> +	mutex_unlock(&mdev->offload_block.lock);
> +}
> +
>  static inline int mlx5e_accel_init_rx(struct mlx5e_priv *priv)
>  {
>  	return mlx5e_ktls_init_rx(priv);

[ ... ]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> index 329608c59313b..74e0aa5b61331 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> @@ -2574,53 +2575,12 @@ void mlx5e_accel_ipsec_fs_read_stats(struct mlx5e_priv *priv, void *ipsec_stats)
>  	}
>  }
>  
> -#ifdef CONFIG_MLX5_ESWITCH
> -static int mlx5e_ipsec_block_tc_offload(struct mlx5_core_dev *mdev)
> -{
> -	struct mlx5_eswitch *esw = mdev->priv.eswitch;
> -	int err = 0;
> -
> -	if (esw) {
> -		err = mlx5_esw_lock(esw);
> -		if (err)
> -			return err;
> -	}
> -
> -	if (mdev->num_block_ipsec) {
> -		err = -EBUSY;
> -		goto unlock;
> -	}
> -
> -	mdev->num_block_tc++;
> -
> -unlock:
> -	if (esw)
> -		mlx5_esw_unlock(esw);
> -
> -	return err;
> -}
> -#else

[ ... ]

>  int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
>  {
>  	int err;
>  
>  	if (sa_entry->attrs.type == XFRM_DEV_OFFLOAD_PACKET) {
> -		err = mlx5e_ipsec_block_tc_offload(sa_entry->ipsec->mdev);
> +		err = mlx5e_accel_block_tc_offload(sa_entry->ipsec->mdev);
>  		if (err)
>  			return err;
>  	}

[ ... ]

> @@ -2652,7 +2612,7 @@ void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
>  		mlx5_packet_reformat_dealloc(mdev, ipsec_rule->pkt_reformat);
>  
>  	if (sa_entry->attrs.type == XFRM_DEV_OFFLOAD_PACKET)
> -		mlx5e_ipsec_unblock_tc_offload(mdev);
> +		mlx5e_accel_unblock_tc_offload(mdev);
>  
>  	if (sa_entry->attrs.dir == XFRM_DEV_OFFLOAD_OUT) {
>  		tx_ft_put(sa_entry->ipsec, sa_entry->attrs.type);

[ ... ]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index b290beb4369ad..05c703795df4a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -4830,27 +4830,35 @@ static bool is_tc_ipsec_order_check_needed(struct net_device *filter, struct mlx
>  	return true;
>  }
>  
> -static int mlx5e_tc_block_ipsec_offload(struct net_device *filter, struct mlx5e_priv *priv)
> +static int mlx5e_tc_block_accel_offload(struct net_device *filter,
> +					struct mlx5e_priv *priv)
>  {
>  	struct mlx5_core_dev *mdev = priv->mdev;
> +	int ret = 0;
>  
> -	if (!is_tc_ipsec_order_check_needed(filter, priv))
> +	if (!is_tc_accel_check_needed(filter, priv))
>  		return 0;
>  
> -	if (mdev->num_block_tc)
> -		return -EBUSY;
> -
> -	mdev->num_block_ipsec++;
> +	mutex_lock(&mdev->offload_block.lock);
> +	if (mdev->offload_block.num_tc)
> +		ret = -EBUSY;
> +	else
> +		mdev->offload_block.num_accel++;
> +	mutex_unlock(&mdev->offload_block.lock);

[Severity: High]

This isn't a bug introduced by this patch, since the same asymmetry existed
with num_block_ipsec, but can offload_block.num_accel be leaked when the
driver tears down its own flows?

The increment here is only undone by mlx5e_tc_unblock_accel_offload() from
mlx5e_delete_flower() or the mlx5e_configure_flower() error label. Flows
destroyed by the driver go through the bulk destructor instead:

    static void _mlx5e_tc_del_flow(void *ptr, void *arg)
    {
            struct mlx5e_tc_flow *flow = ptr;
            struct mlx5e_priv *priv = flow->priv;

            mlx5e_tc_del_flow(priv, flow);
            kfree(flow);
    }

which is passed to rhashtable_free_and_destroy() from mlx5e_tc_nic_cleanup()
and mlx5e_tc_ht_cleanup(), and never decrements the counter.

mlx5e_tc_nic_cleanup() is reachable without unregistering the netdev:

  _mlx5e_suspend() -> mlx5e_detach_netdev() -> mlx5e_cleanup_nic_rx() ->
  mlx5e_tc_nic_cleanup() -> rhashtable_free_and_destroy(&tc->ht,
                                                        _mlx5e_tc_del_flow, NULL)

i.e. devlink dev reload, PCI suspend and FW-reset/health recovery. On those
paths the cls_flower filters are still installed and still in tc->ht, so
they were never removed via mlx5e_delete_flower().

Since offload_block lives on mlx5_core_dev and nothing else in the tree
resets num_tc/num_accel, wouldn't num_accel stay above zero for the
lifetime of the driver instance, making every later
mlx5e_accel_block_tc_offload() return -EBUSY even though no TC rule exists?
That would refuse IPsec packet offload, and after the rest of this series
also MACsec and PSP enablement, until the module is reloaded.

The new WARN_ON_ONCE() checks only catch the opposite direction.

Would calling mlx5e_tc_unblock_accel_offload() (or an mdev-only variant of
it) from _mlx5e_tc_del_flow(), or resetting the counters on profile
detach, be the right place to close this?

>  
> -	return 0;
> +	return ret;
>  }
>  
> -static void mlx5e_tc_unblock_ipsec_offload(struct net_device *filter, struct mlx5e_priv *priv)
> +static void mlx5e_tc_unblock_accel_offload(struct net_device *filter,
> +					   struct mlx5e_priv *priv)
>  {
> -	if (!is_tc_ipsec_order_check_needed(filter, priv))
> +	if (!is_tc_accel_check_needed(filter, priv))
>  		return;
>  
> -	priv->mdev->num_block_ipsec--;
> +	mutex_lock(&priv->mdev->offload_block.lock);
> +	if (!WARN_ON_ONCE(!priv->mdev->offload_block.num_accel))
> +		priv->mdev->offload_block.num_accel--;
> +	mutex_unlock(&priv->mdev->offload_block.lock);
>  }

[ ... ]

> @@ -4957,7 +4965,7 @@ int mlx5e_delete_flower(struct net_device *dev, struct mlx5e_priv *priv,
>  	trace_mlx5e_delete_flower(f);
>  	mlx5e_flow_put(priv, flow);
>  
> -	mlx5e_tc_unblock_ipsec_offload(dev, priv);
> +	mlx5e_tc_unblock_accel_offload(dev, priv);

[Severity: Medium]

This is a pre-existing ordering, unchanged by the patch (the old
mlx5e_tc_unblock_ipsec_offload() call sat in the same place), but is the
counter dropped before the hardware rules are actually gone?

mlx5e_flow_put() only removes the rules when the last reference goes away:

    void mlx5e_flow_put(struct mlx5e_priv *priv, struct mlx5e_tc_flow *flow)
    {
            if (refcount_dec_and_test(&flow->refcnt)) {
                    mlx5e_tc_del_flow(priv, flow);
                    kfree_rcu(flow, rcu_head);
            }
    }

Other contexts legitimately hold references via mlx5e_flow_get() in
en/tc_tun_encap.c (encap/neigh update work) and in mlx5e_stats_flower().
With refcnt still above one, the TC rules remain in hardware while
mlx5e_tc_unblock_accel_offload() sets num_accel back to 0, so a concurrent

  ip xfrm state add ... offload packet dev <uplink>

can pass mlx5e_accel_block_tc_offload() and install its flow_tag rule next
to the still-live TC flow_tag rule, which is the overwrite the commit
message says must not happen.

The same shape exists in mlx5e_accel_ipsec_fs_del_rule(), where
mlx5e_accel_unblock_tc_offload() runs while the trailer/auth/sa_sel/replay
rules and the RX/TX steering tables are still installed.

>  	mlx5_esw_put(priv->mdev);
>  	return 0;
>  
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> index b6e2c153b4f7d..8b36a96522ab7 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> @@ -3022,18 +3022,6 @@ int mlx5_esw_try_lock(struct mlx5_eswitch *esw)
>  	return esw->mode;
>  }
>  
> -int mlx5_esw_lock(struct mlx5_eswitch *esw)
> -{
> -	down_write(&esw->mode_lock);
> -
> -	if (esw->eswitch_operation_in_progress) {
> -		up_write(&esw->mode_lock);
> -		return -EBUSY;
> -	}
> -
> -	return 0;
> -}
> -

[Severity: Medium]

Does removing this also remove the eswitch-transition gate on the accel
side, and not just a counter lock?

mlx5_esw_lock() returned -EBUSY whenever esw->eswitch_operation_in_progress
was set, which aborted mlx5e_accel_ipsec_fs_add_rule() and
mlx5e_accel_ipsec_fs_add_pol() for the whole duration of a devlink eswitch
mode / inline-mode / encap-mode transition. That check was added on purpose
by commit baac8351f74c5 ("net/mlx5e: Reduce eswitch mode_lock protection
context"), which carried Fixes: c8e350e62fc5, and it mirrored the check
added to mlx5_esw_hold() for the TC path.

The replacement only takes the new private mutex:

    mutex_lock(&mdev->offload_block.lock);
    if (mdev->offload_block.num_accel)
            ret = -EBUSY;
    else
            mdev->offload_block.num_tc++;
    mutex_unlock(&mdev->offload_block.lock);

which the eswitch code knows nothing about. So

  ip xfrm state add ... offload packet dev <uplink>

can now proceed into rx_add_rule()/tx_add_rule() and create tables and rules
in the FDB namespace (ipsec_fs_get_ns() returns MLX5_FLOW_NAMESPACE_FDB for
XFRM_DEV_OFFLOAD_PACKET on an uplink rep) while
mlx5_devlink_eswitch_encap_mode_set() runs
esw_destroy_offloads_fdb_tables()/esw_create_offloads_fdb_tables() with
mode_lock dropped.

The commit message describes the esw lock only as "protection for
incrementing the counter" and doesn't mention the
eswitch_operation_in_progress -> -EBUSY behaviour going away. Was that
intentional? If so, could the commit message spell out why the gate is no
longer needed?

>  /**
>   * mlx5_esw_unlock() - Release write lock on esw mode lock
>   * @esw: eswitch device.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260908065244.3799142-1-tariqt%40nvidia.com
