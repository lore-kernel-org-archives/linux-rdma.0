Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C776339395;
	Mon, 19 Oct 2026 09:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792402472; cv=none; b=bq6sxn8RfTF/+gQk/twM9Vii0rV5Vtx5ePMczo4TLR2huqJxSr8FQ0inVdMG4bhZ5hFSEOiZPcl/syr7vYZc/g75vKFfErx9tCpe72nNYCSMczCRjAsq73cJobr1EDTgitpQe6GkefQpMSvDdzN7Jo5uSyxI8JVlxbkFNUzrZoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792402472; c=relaxed/simple;
	bh=caRvRuMjeYeaeP+YT0oYWxMb1Ng0HxxgmWww1n0oODg=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LbASGaDkHD9St+ZuTjABNs4Mi8f5SU4FmUZdEIjDP7spSwudyXXX6CU5B2qigez9q3UYMPmWl1KLO3XaHi5tZm+SJ2eWsFS292/Cz2P6gTg+iGQIfSOaqUAFjonZ+C4zuYFf6hUsJNyn5oZOUTHqDsEUjRysAJjuzj1NiqfQAXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bISCu+iK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bISCu+iK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269631F000C4;
	Mon, 19 Oct 2026 09:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792402471;
	bh=fkCwsdlTkBZOLaKd75UQZ2GtICeTmC2dWIiAJMvcgbc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=bISCu+iKCbvgUr0pZhqIeKfrqVZ+RT8Vqw4SmbhUpJhtRLCtDftRht0nvSrFEgqmv
	 j/JQKWYY3RKgveBKPwGSWtweeqVVUTbgqma8F2kX0hkCykUNkkizrQvUMPpGoaanA/
	 OFtMYHaT1BkQHzuYaR1iAlLyV2Mh+C6ldioK0PcACIdCK6g+gdwckL5HQqLbQnx5LZ
	 wgT7GYuNJ/wCg4zoWVVOswSQqVjfIG7oYi7OWOZX5TyGbJ4bC9YJuDPFioDE2eI+/B
	 dG0Y1l2rP4/a2VUpXDoccwQdAotW0GNDispbT14sjwwlLfhho0wZZOSxl9Pe9YGTx7
	 +WUMYd5dL/KYg==
Subject: Re: [PATCH net] net/mlx5: Fix lock dependency cycle on uplink unbind
 in switchdev mode
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 agoldberger@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 saeedm@nvidia.com, shayd@nvidia.com, horms@kernel.org
Date: Mon, 19 Oct 2026 09:34:29 +0000
Message-ID: <179240246962.3135.13700501362385534607@kernel.org>
In-Reply-To: <20261015093419.1150837-1-tariqt@nvidia.com>
References: <20261015093419.1150837-1-tariqt@nvidia.com>
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

- [High] mlx5_eswitch_safe_aux_devs_remove() now sets
  esw->eswitch_operation_in_progress = true, drops mode_lock, removes…
- [Medium] The patch replaces the read trylock (mlx5_esw_hold(),
  down_read_trylock) with a write trylock in esw_try_lock_ignore_users()…

--

net/mlx5: Fix lock dependency cycle on uplink unbind in switchdev mode

This patch stops mlx5_eswitch_safe_aux_devs_remove() from holding
esw->mode_lock for read while it removes the REP aux devices. It now takes
mode_lock for write through a new esw_try_lock_ignore_users() helper, sets
eswitch_operation_in_progress, drops mode_lock, removes the REPs, and then
retakes mode_lock to clear the flag.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index eb74b6260168..f934cb2b26b0 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> @@ -4438,15 +4438,36 @@ static bool mlx5_devlink_switchdev_active_mode_change(struct mlx5_eswitch *esw,
>  #define MLX5_ESW_HOLD_TIMEOUT_MS 7000
>  #define MLX5_ESW_HOLD_RETRY_DELAY_MS 500
>  
> +/* Unlike mlx5_esw_try_lock(), don't refuse the lock over eswitch users.
> + * Teardown must run even with TC flows still offloaded, as those are only
> + * flushed once the REPs are removed.
> + */
> +static bool esw_try_lock_ignore_users(struct mlx5_eswitch *esw)
> +{
> +	if (!down_write_trylock(&esw->mode_lock))
> +		return false;
> +
> +	if (esw->eswitch_operation_in_progress) {
> +		up_write(&esw->mode_lock);
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
>  void mlx5_eswitch_safe_aux_devs_remove(struct mlx5_core_dev *dev)
>  {
> +	struct mlx5_eswitch *esw = dev->priv.eswitch;
>  	unsigned long timeout;
>  	bool hold_esw = true;
>  
> +	if (!mlx5_esw_allowed(esw))
> +		return;
> +
>  	/* Wait for any concurrent eswitch mode transition to complete. */
> -	if (!mlx5_esw_hold(dev)) {
> +	if (!esw_try_lock_ignore_users(esw)) {
>  		timeout = jiffies + msecs_to_jiffies(MLX5_ESW_HOLD_TIMEOUT_MS);
> -		while (!mlx5_esw_hold(dev)) {
> +		while (!esw_try_lock_ignore_users(esw)) {
>  			if (!time_before(jiffies, timeout)) {
>  				hold_esw = false;
>  				break;

[Severity: Medium]
Can concurrent TC flow insertion now make this loop time out?

The old mlx5_esw_hold() used down_read_trylock(), and other readers never
block that. esw_try_lock_ignore_users() uses down_write_trylock(), which
fails whenever any reader holds mode_lock.

mlx5e_configure_flower() holds mode_lock for read during the whole flow
insert, FW commands included:

drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:mlx5e_configure_flower() {
    ...
	if (!mlx5_esw_hold(priv->mdev))
		return -EBUSY;
    ...
}

TC offload on the REPs doesn't take rtnl, so several of these can run at
the same time. If flow inserts keep overlapping (for example under heavy
OVS offload), every 500 ms poll could find a reader. After
MLX5_ESW_HOLD_TIMEOUT_MS the loop sets hold_esw = false.

In that case the IB and ETH REP aux devices are never removed, and nothing
is logged. _mlx5e_remove() then goes on to tear down the uplink:

_mlx5e_remove()
    mlx5_eswitch_safe_aux_devs_remove(mdev);   <- REPs left bound
    mlx5_core_uplink_netdev_set(mdev, NULL);
    ...
    unregister_netdev() / mlx5e_destroy_netdev()

The uplink REP and the IB REP still reference that netdev. Could this bring
back the unregister_netdevice hang, or a later use of the freed netdev, that
commit 2ae8c7edea87 fixed?

> @@ -4455,9 +4476,19 @@ void mlx5_eswitch_safe_aux_devs_remove(struct mlx5_core_dev *dev)
>  		}
>  	}
>  	if (hold_esw) {
> +		/* Keep mode_lock and reps_lock unnested. The operation flag
> +		 * excludes mode users while mode_lock is dropped before the
> +		 * REPs removal takes reps_lock.
> +		 */
> +		esw->eswitch_operation_in_progress = true;
> +		mlx5_esw_unlock(esw);
> +
>  		if (mlx5_eswitch_mode(dev) == MLX5_ESWITCH_OFFLOADS)
>  			mlx5_core_reps_aux_devs_remove(dev);
> -		mlx5_esw_release(dev);
> +
> +		down_write(&esw->mode_lock);
> +		esw->eswitch_operation_in_progress = false;
> +		mlx5_esw_unlock(esw);

[Severity: High]
Does this flag really keep other writers out while mode_lock is dropped?

The commit message says "The flag keeps excluding concurrent mode
transitions and mode users while mode_lock is not held". However, several
devlink paths take mode_lock with a plain down_write(). They set and later
clear the flag without checking it first:

mlx5_devlink_eswitch_encap_mode_set() {
	down_write(&esw->mode_lock);
	...
	esw->eswitch_operation_in_progress = true;
	up_write(&esw->mode_lock);

	esw_destroy_offloads_fdb_tables(esw);
	...
	err = esw_create_offloads_fdb_tables(esw);
	...
	down_write(&esw->mode_lock);
	esw->eswitch_operation_in_progress = false;
    ...
}

mlx5_devlink_eswitch_inline_mode_set() does the same around
mlx5_esw_vports_inline_set(). mlx5_devlink_switchdev_active_mode_change()
does it around mlx5_esw_fdb_inactive() and mlx5_esw_fdb_active().
mlx5_devlink_eswitch_mode_set() calls that function before it calls
mlx5_esw_try_lock().

Before this patch, the read lock held across REP removal blocked all of
these in down_write(). The other flag setters run under devl_lock. The
unbind path (unbind_store->mlx5e_remove->_mlx5e_remove) doesn't take
devl_lock, so this setter can overlap them.

One possible interleaving:

CPU0 (unbind)                        CPU1 (devlink encap-mode set)
flag = true, up_write()
mlx5_core_reps_aux_devs_remove()
                                     down_write() succeeds
                                     flag = true, up_write()
                                     esw_destroy_offloads_fdb_tables()
down_write()
flag = false, up_write()
                                     esw_create_offloads_fdb_tables()

Once CPU0 clears the flag, mlx5e_configure_flower()->mlx5_esw_hold() can
succeed while CPU1 is still rebuilding the FDB tables.

The reverse order is possible too. If CPU1 finishes first, it clears the
flag while CPU0 is still removing REPs. A later
mlx5_devlink_eswitch_mode_set() can then pass mlx5_esw_try_lock() (when
user_count is 0) and start a mode transition in the middle of REP removal.

CPU0 checked mlx5_eswitch_mode() without holding mode_lock. When it
finishes, it also clears the flag that mode_set just raised.

This looks like a flag being used as a lock: set on entry and cleared on
exit. Should the other writers check the flag before setting it, or should
the bool be replaced with a real lock or a counter?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261015093419.1150837-1-tariqt%40nvidia.com
