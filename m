Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60363502558;
	Mon, 21 Sep 2026 18:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790016554; cv=none; b=H/oOjdmbjpg3SG+b5pZsFl3QnTtAK4ZG/w6NhUz1IxwOgL/hrk0LJs3/X2bkKxVR80rOTzQzodQ+2hgE7UihOORLq7qQvu8s0FfriY7+xcq/0AsgHm4sI+4iH+ETgyubBvJTTrKrD1HyPJpw/NOEUMxe0TvfFNgG1dFPaGKGPQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790016554; c=relaxed/simple;
	bh=vuY8KG10pagboVJ5dXQwMcgVYVcz5AMOsQ4b7zoI8iU=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=D1UpCwwjhVgi8P33/Il+eRGHH86udivh5353XDhGX7iJExH9onDpluyZaatMZdLSD/fnIWrq9DiAVbh9O1HDitXUb0BzQmK7JnNUqUEGsE52Ya0VYc+/dPMSXbPlllkdOCTG1r0R+nAdNsAXnW7lrHfh95TA3WE9+cVv4ET1xtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IWdrdjum; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IWdrdjum"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED091F00893;
	Mon, 21 Sep 2026 18:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790016551;
	bh=IG/RHXsig+RuWbBup77kJPOrmhxMzzPIGTMKwsxrrbQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=IWdrdjumTW61AsXsbuE+Zt1XKlLu0CffoNXL2KY+fGDzv9s6UrafFi3/ieCQMWm63
	 dRhHWIoqr/qS6fC131r8gIGVtuRz3eStZX3LFH3o6J9BD7VHCvxyN8ER26lNyay3KX
	 QjORDVWEFSRI+aIoQ7niQWFQRWfEfsJXWd5TD10ncQ+LcY6GndFdZUyzs6kwNs+8g8
	 SWIJ+jmy0vtD47pEk3ZZTM0OFl7gjmLFpoEDYT7aYdI0odyTQF3yMJdR1uG/Ct6JyP
	 zyRvH3z3dYsL0+v+y2kHoM9lxWwHsx5bxznLY3ZUNxJzKPSBpeUZC4MuJzZsbpDXip
	 UJ3sRKEG/fP2A==
Subject:
 Re: [PATCH net 5/7] net/mlx5e: macsec: Delete remaining SecYs during cleanup
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
Date: Mon, 21 Sep 2026 18:49:10 +0000
Message-ID: <179001655003.2160803.16514719175726487697@kernel.org>
In-Reply-To: <20260917175433.4090878-6-tariqt@nvidia.com>
References: <20260917175433.4090878-6-tariqt@nvidia.com>
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

Critical: 0 · High: 2 (1) · Medium: 0 (1) · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] mlx5e_macsec_cleanup() frees the MACsec context and sets
  `priv->macsec = NULL` (macsec.c:1826-1827) without ever withdrawing…
- [High] mlx5e_macsec_cleanup() takes macsec->lock only for the new SecY-
  deletion sweep (macsec.c:1814-1819), then drops it and destroys/frees…

Pre-existing issues:
- [High] macsec_del_rxsc_ctx() (macsec.c:820-849), which this patch newly
  invokes from the bulk cleanup path, releases the RX-SC's xarray…
- [Medium] Suspend-time cleanup now deletes every programmed SecY, SA,
  encryption key, MACsec HW object and steering rule…

--

net/mlx5e: macsec: Delete remaining SecYs during cleanup

The patch factors the SecY teardown out of mlx5e_macsec_del_secy() into a
new macsec_del_secy() helper, and calls it for every remaining entry of
macsec->macsec_device_list_head from mlx5e_macsec_cleanup().  It also
adds xa_destroy(), clears mdev->macsec_fs and clears priv->macsec at the
end of cleanup.

A few questions below about the teardown ordering and about the callbacks
that remain registered after cleanup has run.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> index 20eec345b36cd..84ce388d3846e 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c

[ ... ]

> @@ -1272,7 +1260,7 @@ static int mlx5e_macsec_del_secy(struct macsec_context *ctx)
>  
>  	list = &macsec_device->macsec_rx_sc_list_head;
>  	list_for_each_entry_safe(rx_sc, tmp, list, rx_sc_list_element)
> -		macsec_del_rxsc_ctx(macsec, rx_sc, ctx->secy->netdev);
> +		macsec_del_rxsc_ctx(macsec, rx_sc, netdev);

[Severity: High]

This isn't a bug introduced by this patch, but since the cleanup sweep is
now a second caller of macsec_del_rxsc_ctx() it seems worth asking about
the lifetime of rx_sc->sc_xarray_element there:

drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c:macsec_del_rxsc_ctx() {
	...
	list_del_rcu(&rx_sc->rx_sc_list_element);
	xa_erase(&macsec->sc_xarray, rx_sc->sc_xarray_element->fs_id);
	dst_release(&rx_sc->md_dst->dst);
	kfree(rx_sc->sc_xarray_element);
	kfree_rcu_mightsleep(rx_sc);
}

The RX datapath loads that element under RCU:

drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c:mlx5e_macsec_offload_handle_rx_skb() {
	...
	rcu_read_lock();
	sc_xarray_element = xa_load(&macsec->sc_xarray, fs_id);
	rx_sc = sc_xarray_element ? sc_xarray_element->rx_sc : NULL;
	if (rx_sc && rx_sc->md_dst) {
	...
}

Only rx_sc is freed via kfree_rcu_mightsleep(); sc_xarray_element is freed
with plain kfree() right after xa_erase().  Can a reader that already
obtained sc_xarray_element from xa_load() then dereference freed memory for
sc_xarray_element->rx_sc, and go on to dereference the resulting garbage
pointer at rx_sc->md_dst?

The comment just above those lines says:

	/* At this point the relevant MACsec offload Rx rule already removed at
	 * mlx5e_macsec_cleanup_sa need to wait for datapath to finish current
	 * Rx related data propagating using xa_erase which uses rcu to sync,
	 * once fs_id is erased then this rx_sc is hidden from datapath.
	 */

xa_erase() stores NULL into the slot but does not wait for a grace period,
so is the stated justification for the immediate kfree() of
sc_xarray_element accurate?

>  
>  	kfree(macsec_device->dev_addr);
>  	macsec_device->dev_addr = NULL;
> @@ -1280,7 +1268,24 @@ static int mlx5e_macsec_del_secy(struct macsec_context *ctx)
>  	list_del_rcu(&macsec_device->macsec_device_list_element);
>  	--macsec->num_of_devices;
>  	kfree(macsec_device);
> +}
> +
> +static int mlx5e_macsec_del_secy(struct macsec_context *ctx)
> +{
> +	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
> +	struct mlx5e_macsec *macsec = priv->macsec;
> +	struct mlx5e_macsec_device *macsec_device;
> +	int err = 0;
>  
> +	mutex_lock(&macsec->lock);
> +	macsec_device = mlx5e_macsec_get_macsec_device_context(macsec, ctx);
> +	if (!macsec_device) {
> +		netdev_err(ctx->netdev, "MACsec offload: Failed to find device context\n");
> +		err = -EINVAL;
> +		goto out;
> +	}
> +
> +	macsec_del_secy(macsec, macsec_device);
>  out:
>  	mutex_unlock(&macsec->lock);
>  
> @@ -1796,6 +1801,7 @@ int mlx5e_macsec_init(struct mlx5e_priv *priv)
>  
>  void mlx5e_macsec_cleanup(struct mlx5e_priv *priv)
>  {
> +	struct mlx5e_macsec_device *macsec_device, *tmp;
>  	struct mlx5e_macsec *macsec = priv->macsec;
>  	struct mlx5_core_dev *mdev = priv->mdev;
>  
> @@ -1803,9 +1809,20 @@ void mlx5e_macsec_cleanup(struct mlx5e_priv *priv)
>  		return;
>  
>  	mlx5_notifier_unregister(mdev, &macsec->nb);
> -	mlx5_macsec_fs_cleanup(mdev->macsec_fs);
>  	destroy_workqueue(macsec->wq);
> +
> +	mutex_lock(&macsec->lock);
> +	list_for_each_entry_safe(macsec_device, tmp,
> +				 &macsec->macsec_device_list_head,
> +				 macsec_device_list_element)
> +		macsec_del_secy(macsec, macsec_device);
> +	mutex_unlock(&macsec->lock);

[Severity: Medium]

This is a pre-existing restoration gap rather than something this patch
introduces, and the commit message already says fixing it is out of scope,
but it may be worth spelling out what the observable result is.

After this sweep plus mlx5_macsec_fs_cleanup(), every SecY, SA, encryption
key, MACsec object and steering rule is gone, while the MACsec upper
netdevices stay registered with their SecYs still marked offloaded.
mlx5e_macsec_init() on resume only allocates a fresh context, an empty
sc_xarray, a new ASO and a new flow-steering instance, with no replay.

So on resume, does offloaded TX end up dropping frames here?

drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c:mlx5e_macsec_handle_tx_skb() {
	...
	fs_id = mlx5_macsec_fs_get_fs_id_from_hashtable(macsec->mdev->macsec_fs,
							&md_dst->u.macsec_info.sci);
	if (!fs_id)
		goto err_out;
	...
}

and do later control operations on those retained SecYs fail with -EINVAL
from the device-context lookup in mlx5e_macsec_del_secy(), which also makes
macsec_update_offload() abort the transition?

> +
> +	xa_destroy(&macsec->sc_xarray);
> +	mlx5_macsec_fs_cleanup(mdev->macsec_fs);
> +	mdev->macsec_fs = NULL;
>  	mlx5e_macsec_aso_cleanup(&macsec->aso, mdev);
>  	mutex_destroy(&macsec->lock);
>  	kfree(macsec);

[Severity: High]

macsec->lock is released before mutex_destroy() and kfree(macsec), and
priv->macsec is cleared only after the free.  Every offload callback reads
priv->macsec locklessly and then blocks on that same mutex, for example
mlx5e_macsec_add_secy() and the rewritten mlx5e_macsec_del_secy():

	struct mlx5e_macsec *macsec = priv->macsec;
	...
	mutex_lock(&macsec->lock);

mlx5e_macsec_cleanup() runs from mlx5e_nic_disable() after rtnl_unlock(),
while the MACsec core dispatches the mdo_* ops under rtnl (macsec_newlink()
-> mdo_add_secy, macsec_upd_offload() -> macsec_update_offload()), so rtnl
does not serialize the two paths and macsec->lock is the only mutual
exclusion:

CPU0 (netlink, rtnl held)
mlx5e_macsec_add_secy()
	macsec = priv->macsec;		/* still non-NULL */
	mutex_lock(&macsec->lock);	/* blocks */

CPU1 (devlink reload / health recovery / suspend, no rtnl)
mlx5e_macsec_cleanup()
	mutex_unlock(&macsec->lock);
	...
	mutex_destroy(&macsec->lock);
	kfree(macsec);
	priv->macsec = NULL;

Can CPU0 then acquire a mutex inside freed memory, list_add a new
macsec_device into the freed macsec_device_list_head, and mutex_unlock()
freed memory?  A SecY added in that window would also be leaked, which is
the case this patch is trying to close.  Would clearing the gating state
(and withdrawing the offload registration) before dropping the lock and
freeing be a better ordering?

> +	priv->macsec = NULL;
>  }

[Severity: High]

Clearing priv->macsec here leaves the offload registration in place.
netdev->macsec_ops and NETIF_F_HW_MACSEC are set once in
mlx5e_macsec_build_netdev(), called from mlx5e_build_nic_netdev() at netdev
creation, and nothing in mlx5e_macsec_cleanup() reverses that.  The core
only checks those two fields:

drivers/net/macsec.c:macsec_check_offload() {
	...
		return macsec->real_dev->features & NETIF_F_HW_MACSEC &&
		       macsec->real_dev->macsec_ops;
	...
}

There is no netif_device_present() test there, and none of the mlx5e
callbacks NULL-check priv->macsec; they all start with
mutex_lock(&priv->macsec->lock), and the rewritten mlx5e_macsec_del_secy()
does:

	struct mlx5e_macsec *macsec = priv->macsec;
	...
	mutex_lock(&macsec->lock);

Since mlx5e_macsec_cleanup() is called from mlx5e_nic_disable() after
rtnl_unlock() and with the netdev still registered (only
netif_device_detach()'ed), can "ip link del macsec0" reach
macsec_common_dellink() -> mdo_del_secy -> mlx5e_macsec_del_secy() with
priv->macsec == NULL and oops on the mutex_lock()?

The same applies indefinitely if mlx5e_macsec_init() fails on resume, since
mlx5e_nic_enable() only logs the error:

drivers/net/ethernet/mellanox/mlx5/core/en_main.c:mlx5e_nic_enable() {
	...
	err = mlx5e_macsec_init(priv);
	if (err)
		mlx5_core_err(mdev, "MACsec initialization failed, %d\n", err);
	...
}

so priv->macsec stays NULL while the ops remain advertised.  The TX helpers
reached from en_accel.h have the same exposure, for instance
mlx5e_macsec_handle_tx_skb() dereferencing macsec->mdev->macsec_fs with no
NULL check on macsec.  Should cleanup also drop macsec_ops and
NETIF_F_HW_MACSEC, or should the callbacks check priv->macsec?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260917175433.4090878-1-tariqt%40nvidia.com
