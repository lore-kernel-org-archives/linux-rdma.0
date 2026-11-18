Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794997917;
	b=O6OrxudKn4NbNpqrKry59V7wUV1kdgAacZVLEQlmFC18h+q/NYnHtrL5fyKJ0yHrOCG4
	 4bNw723uxAKwXkqSlr836U2IyHQaxTsFm8xcr6Etc0eArtc0ygHbgmank0bkF8vXxjwHU
	 NcOhD9dItqJfiPz5+vdzHQrauwKUa86003HoA5WHPr88ZzIEP69jTr9hLffve/uNbl3V6
	 BPygFFK7OicMfeYNV77otrGsejmjcwT41RfkwKsXvfRpi8Zhd25w4e8dVNvkpAIjMXsqk
	 6bRjKB0gY7bmVJGDOw3Nc1YMRUUqY240NDM9t07LCt0epF8eVeVP57z4GYRnqdm/Vxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794997917;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=K+3qy+pdgU4poU7W343gIQ62KQAmGsAKUXW1vCEZTnM=;
	b=3akZre7lzm4I5SrLTx2ajuVl93sEpwJ97Tn4apbpgJyC9Mwd8juq0g38yyCVvWxIoEmv
	 Y3dDHW3DYHqD3SvP6QuSlCA+vHZGKXmAP9mz8oZCcKlTKzUdqtec28dk8aU9sC2T/1BVH
	 IyQKkzi3s9Q2OFAi2QmUDutWLPscHkAFy979pLDCe0dhQR9rAZlt97tLj0OskS6ZkVZ3B
	 pI/1Qhk7ZinL+TepClnc+Y9nIVas5rAwvEClpT+5FkIqFMFMenTq6TEhXVM/kr0iIb+Er
	 PpPQKY+rD69VBHFoOJaNZgP46hiDpxvRPb6wq6IhSPGPtlIVYlcQZb7OjoHnIM2jKOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e6snppa8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF24606A33B;
	Wed, 18 Nov 2026 10:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e6snppa8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D671F000C4;
	Wed, 18 Nov 2026 10:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794997917;
	bh=K+3qy+pdgU4poU7W343gIQ62KQAmGsAKUXW1vCEZTnM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=e6snppa8sNdz1tlYA+wd2PBupoE9ThejL/9S3UWwrfjcgK7N19Hi5ESDldbB4UTAi
	 o112KloqmErLW/DcWkZtWBUTvHHsFamufQ1TeFPlmuqJV8FVjhunuayIWdH1ztSqq7
	 A4+bfSyaSdudEfLBU9IJyA3qIFtoHNXnurBy067oLFmzJC5p6doFv7vzbadZoXTOCm
	 +uoZVyIRFWxfkNkMkQV5B5ObdbONfIS5B38129fO36dr6Y3mFaSMaUaLUxYJ31wlk+
	 TkVCrHrRmnanI3vbtn12M7i7Minb6Z9c+NhgduqOZ4H2wTCRVqL0E+ZVGFG5SRM+wS
	 Ggyh98kwMbRwg==
Subject: Re: [PATCH net-next V2 06/10] net/mlx5: LAG, rename PF naming to fn
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 cjubran@nvidia.com, cratiu@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 moshe@nvidia.com, ohartoov@nvidia.com, phaddad@nvidia.com, saeedm@nvidia.com,
 shayd@nvidia.com, udar@nvidia.com
Date: Wed, 18 Nov 2026 10:31:56 +0000
Message-ID: <179499791613.3136.14627741130373185414@kernel.org>
In-Reply-To: <20261116103010.1129666-7-tariqt@nvidia.com>
References: <20261116103010.1129666-7-tariqt@nvidia.com>
X-sashiko-severity: Low
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

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit message misstates what this patch renames.

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but it is still
  present at the end of the series.

--

net/mlx5: LAG, rename PF naming to fn

This commit renames the LAG member bookkeeping from PF naming to fn. The
ldev->pfs xarray becomes ldev->fns, the mlx5_lag_pf*() helpers become
mlx5_lag_fn*(), and the pf locals become fn. The rename prepares for virt
LAG, where LAG members will not always be physical functions.

> Rename the xarray to ldev->fns, the helpers to mlx5_lag_fn*(), and the
> locals to fn, so the naming matches struct lag_fn.

[Severity: Low]
Is this description accurate? struct lag_fn doesn't exist before this
patch. The patch creates it by renaming the struct in lag.h:

-struct lag_func {
+struct lag_fn {

It also renames a field of struct mlx5_lag:

-	u8			  max_funcs;
+	u8			  max_fns;

The commit message mentions neither rename.

The patch also makes a few small changes that are not renames:

  - a new esw local in mlx5_lag_drop_rule_cleanup()
  - dev0/dev1 moved above the switch in mlx5_lag_set_port_affinity()
  - new mdev/affinity locals in mlx5_lag_create_port_sel_table() and
    __mlx5_lag_modify_definers_destinations()

Could the commit message mention these as well?

A few spots look like they were missed by the rename. The pf_idx and
pf_mdev locals remain in mlx5_lag_get_devices_oper_speed(),
mlx5_lag_get_devices_max_speed(), mlx5_lag_set_vports_agg_speed() and
mlx5_lag_reset_vports_speed():

	mlx5_ldev_for_each(pf_idx, 0, ldev) {
		...
		pf_mdev = fn->dev;

mlx5_get_next_lag_func() and mlx5_get_pre_lag_func() walk the renamed fns
xarray but keep their old names.

In mlx5_lag_mpesw_port_change_event(), the local now has the same name as
the struct tag. The container_of() continuation lines are still aligned for
the old, longer name:

	struct lag_fn *lag_fn = container_of(mlx5_nb,
						 struct lag_fn,
						 port_change_nb);

Was that intended?

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> index cbef6ab1e38a8..74e7e7161c95d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c

[ ... ]

> @@ -2390,24 +2392,24 @@ int mlx5_ldev_add_mdev(struct mlx5_lag *ldev,
>  void mlx5_ldev_remove_mdev(struct mlx5_lag *ldev,
>  			   struct mlx5_core_dev *dev)
>  {

[ ... ]

> -	pf->dev = NULL;
> +	fn->dev = NULL;
>  	dev->priv.lag = NULL;
> -	xa_erase(&ldev->pfs, pf->idx);
> -	kfree(pf);
> +	xa_erase(&ldev->fns, fn->idx);
> +	kfree(fn);
>  }

[Severity: High]
This is a pre-existing issue and was not introduced by this patch. Since
this code is being touched: is it safe to free the lag_fn here while
readers holding only lag_lock may still be using it?

mlx5_ldev_remove_mdev() runs with only ldev->lock held. It is called from:

  - mlx5_unload()->mlx5_lag_remove_mdev()
  - sd_lag_cleanup()
  - the error path of sd_lag_init()

It erases the entry and frees it right away with kfree(). There is no RCU
grace period, and lag_lock is not taken.

Several exported helpers walk the same ldev->fns xarray while holding only
lag_lock, without ldev->lock. For example:

mlx5_lag_get_next_peer_mdev() {
	spin_lock_irqsave(&lag_lock, flags);
	...
	mlx5_lag_for_each(idx, *i, ldev, mlx5_lag_get_filter(ldev, dev)) {
		fn = mlx5_lag_fn(ldev, idx);
		if (fn->dev != dev)
			break;
	}
	...
	fn = mlx5_lag_fn(ldev, idx);
	peer_dev = fn->dev;
	...
}

mlx5_lag_is_master(), mlx5_lag_is_shared_fdb() and mlx5_lag_is_sd() read
fn->dev, fn->group_id and fn->sd_fdb_active through mlx5_lag_get_filter()
and mlx5_lag_fn_by_dev(). mlx5_lag_get_slave_port() and
mlx5_lag_active_backup_get_netdev() also dereference entries while holding
only lag_lock.

Can this interleaving happen between two devices in the same ldev?

CPU0 (peer device A)             CPU1 (device B unload)
mlx5_esw_is_owner()
  mlx5_lag_is_master()
    spin_lock_irqsave(&lag_lock)
    mlx5_lag_get_filter()
      mlx5_lag_fn_by_dev()
        xa_for_each() loads fn
                                 mlx5_lag_remove_mdev()
                                   mutex_lock(&ldev->lock)
                                   mlx5_ldev_remove_mdev()
                                     xa_erase(&ldev->fns, fn->idx)
                                     kfree(fn)
        fn->dev == dev   <- reads freed memory

If mlx5_lag_get_next_peer_mdev() hits the same window, it returns the stale
fn->dev to its caller as a peer mlx5_core_dev pointer.

The baseline already has the same xa_erase() and kfree() in
mlx5_ldev_remove_mdev(), and nothing later in the series changes this.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116103010.1129666-1-tariqt%40nvidia.com
