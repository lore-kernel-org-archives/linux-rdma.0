Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B9F4317D;
	Wed,  9 Sep 2026 12:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788956147; cv=none; b=djtv87hHCapfRWI8jmL5BMansVtjkzYf6e6PCzmxNQfX++6grK1ELQ+Cvw7lXWdyoMeBtqnRgpjMnBP/oM8v0sbqXVR2ExLT5uTBCbmgs1qY42KjFnwr34gO3kDZWdskER3tbduoYtYzTFOy/hldu+6ydn6Lu8/Z032qauWk0Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788956147; c=relaxed/simple;
	bh=9Elz70sprz2mHx7hwE4XTXp7M453PMiA1Le4CZ1uVRg=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XWHeTa4TaN0TyQFjZ+9WVbIGFjkfu+qn8dDWFmgTT97+ErqbY9i9gxUiqYxV0PFw745vhieN0waby02jYveNogs1Cj+tj25GSv52ClG3FaFVwlx2Id4XKpuRx+EZZgZ21Qh8czD1p+aYA6lP/fvGheDhKez0xVV28slohNZyuYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OUPkUjzT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OUPkUjzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894591F00A3A;
	Wed,  9 Sep 2026 12:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788956145;
	bh=YEBpeLVH/7XPGWdIJ4tKqiidSSg0qXXWJQlmAYH7iwc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=OUPkUjzTScUWCEyk0KIgklG71TRigzXIb5a0baIx9BMe7U+FEnEOO9Lb6lG5l5AUy
	 fKhf1g9Dh9zMKsyxtOf0RW8wY944bOUh365HVCcOXyqMqMUDr84eBA2JvXCEQblK3e
	 izA6Df5qIwT0I+sOrC0gKCUUdHvFr94BcBpVq3+6eL2iCJf4n7rjYXQ/8euB83hHG1
	 uFRIlAAKRDsMeaYscDA80FGTEnoCsHGkHasNHnnoMde+sCqRbvviG179NIEXj27XhC
	 ZetjFA+5N8nfSURpJkCYjjRON0VToWWRTxbQwxF1x9iPtAc9m3mIVIJWZaKI5CsKD2
	 t27EpYD0jmZ+g==
Subject: Re: [PATCH net V2 1/4] net/mlx5: SD, serialize SD LAG init/cleanup
 against LAG mode changes
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 agoldberger@nvidia.com, edwards@nvidia.com, gal@nvidia.com, kees@kernel.org,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 msanalla@nvidia.com, mbloch@nvidia.com, ohartoov@nvidia.com, parav@nvidia.com,
 phaddad@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com, horms@kernel.org
Date: Wed, 09 Sep 2026 12:15:44 +0000
Message-ID: <178895614406.219967.15894719869066376557@kernel.org>
In-Reply-To: <20260906071332.3759199-2-tariqt@nvidia.com>
References: <20260906071332.3759199-2-tariqt@nvidia.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 1 · Medium: 0 (1) · Low: 0

- [High] New unbounded `msleep(100)` wait loops in `sd_lag_init()` and
  `sd_lag_cleanup()` (drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c)…

Pre-existing issues:
- [Medium] `sd_lag_cleanup()`
  (drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c:386-412) dismantles…

--

net/mlx5: SD, serialize SD LAG init/cleanup against LAG mode changes

This makes sd_lag_init() and sd_lag_cleanup() wait for
ldev->mode_changes_in_progress to reach zero before touching ldev, folds
the SD shared-FDB teardown in mlx5_lag_disable_change() into the main
locked section, and moves mlx5_sd_eswitch_mode_set() in
mlx5_eswitch_disable() after mlx5_lag_enable_change(). A couple of
questions below about the new wait loop and about the group_id handling in
the relocated teardown loop.

[ ... ]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> index 2285c889c215e..aee5ce471eba7 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> @@ -2589,6 +2589,8 @@ void mlx5_lag_disable_change(struct mlx5_core_dev *dev)
>  	mpesw = ldev->mode == MLX5_LAG_MODE_MPESW;
>  	if (mpesw)
>  		mlx5_mpesw_sd_devcoms_lock(ldev);
> +	else if (sd_devcom)
> +		mlx5_devcom_comp_lock(sd_devcom);
>  	mutex_lock(&ldev->lock);
>  
>  	ldev->mode_changes_in_progress++;
> @@ -2599,26 +2601,22 @@ void mlx5_lag_disable_change(struct mlx5_core_dev *dev)
>  			mlx5_disable_lag(ldev);
>  	}
>  
> +	if (sd_devcom) {
> +		mlx5_lag_for_each(i, 0, ldev, MLX5_LAG_FILTER_ALL) {
> +			pf = mlx5_lag_pf(ldev, i);
> +			if (pf->dev == dev && pf->sd_fdb_active) {
> +				mlx5_lag_shared_fdb_destroy(ldev, pf->group_id);
> +				break;
> +			}
> +		}
> +	}

[Severity: Medium]

This is a pre-existing issue and not introduced by this patch, but since
the loop is being relocated here: pf->group_id is passed to
mlx5_lag_shared_fdb_destroy() without checking that it is non-zero, and
mlx5_lag_shared_fdb_destroy() in lag/shared_fdb.c treats zero as
"everything":

	u32 filter = group_id ? group_id : MLX5_LAG_FILTER_ALL;
	...
	if (filter == MLX5_LAG_FILTER_PORTS || filter == MLX5_LAG_FILTER_ALL) {
		err = mlx5_deactivate_lag(ldev);

while lag.h documents group_id 0 as "not SD":

	u32 group_id;        /* SD group ID, 0 = not SD */
	bool sd_fdb_active;  /* set on all SD group members */

sd_lag_cleanup() zeroes group_id but never looks at sd_fdb_active, and
mlx5_lag_shared_fdb_create() sets sd_fdb_active on every member of the
group, so the primary can be left with sd_fdb_active == true and
group_id == 0. sd_lag_init()'s error path produces the same combination.

Do the normal teardown paths hide this because
mlx5_unload_one_devl_locked() calls mlx5_eswitch_disable() before
mlx5_detach_device(), so sd_fdb_active is already false by the time
sd_lag_cleanup() runs?

What happens on a manual auxiliary driver unbind, where mlx5e_remove() ->
mlx5_sd_cleanup() -> sd_lag_cleanup() runs with the eswitch still in
switchdev and the SD shared FDB armed? From there it looks like the
per-group single-FDB association, the peer-miss rules and the secondary
FDB-root alias are left installed, sd_cmd_unset_secondary() goes on to
silence the secondary TX root and destroy the alias flow table object, and
a later mlx5_lag_disable_change() reaching the loop above with
group_id == 0 would take the MLX5_LAG_FILTER_ALL / mlx5_deactivate_lag()
path rather than the SD group path.

Would it make sense for sd_lag_cleanup() to call
mlx5_lag_shared_fdb_destroy(ldev, group_id) (or at least warn when
sd_fdb_active is set) before erasing the group's lag_func entries?

> +
>  	mutex_unlock(&ldev->lock);
>  	if (mpesw)
>  		mlx5_mpesw_sd_devcoms_unlock(ldev);
> +	else if (sd_devcom)
> +		mlx5_devcom_comp_unlock(sd_devcom);
>  	mlx5_devcom_comp_unlock(primary->priv.hca_devcom_comp);
> -
> -	if (!sd_devcom)
> -		return;
> -
> -	/* Teardown SD shared FDB for this device's group if active */
> -	mlx5_devcom_comp_lock(sd_devcom);
> -	mutex_lock(&ldev->lock);
> -	mlx5_lag_for_each(i, 0, ldev, MLX5_LAG_FILTER_ALL) {
> -		pf = mlx5_lag_pf(ldev, i);
> -		if (pf->dev == dev && pf->sd_fdb_active) {
> -			mlx5_lag_shared_fdb_destroy(ldev, pf->group_id);
> -			break;
> -		}
> -	}
> -	mutex_unlock(&ldev->lock);
> -	mlx5_devcom_comp_unlock(sd_devcom);
>  }
>  
>  void mlx5_lag_enable_change(struct mlx5_core_dev *dev)
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c
> index 4cdc50cd6f038..99cf455a61e1a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c
> @@ -345,7 +345,14 @@ static void sd_lag_init(struct mlx5_core_dev *dev)
>  		return;
>  	}
>  
> +recheck:
>  	mutex_lock(&ldev->lock);
> +	if (ldev->mode_changes_in_progress) {
> +		mutex_unlock(&ldev->lock);
> +		msleep(100);
> +		goto recheck;
> +	}
> +

[Severity: High]

Can this loop sleep while holding the locks that the mode-change thread
needs in order to make progress?

sd_lag_init() is called from mlx5_sd_init() with sd->devcom held, and
mlx5_sd_init() itself runs from adrv->probe/resume, i.e. inside the
hca_devcom_comp write semaphore taken by mlx5_attach_device() /
mlx5_register_device(). The same is true of the copy of this loop in
sd_lag_cleanup(), reached via mlx5_detach_device() -> mlx5e_suspend() /
mlx5e_remove() -> mlx5_sd_cleanup(). So the msleep() poll runs with two
devcom write semaphores held.

On the other side, mlx5_lag_disable_change() raises
mode_changes_in_progress and then drops every lock, and code running
inside that window re-takes hca_devcom_comp:

mlx5_devlink_eswitch_mode_set()
  mlx5_lag_disable_change(esw->dev)   /* mode_changes_in_progress++, locks dropped */
  esw_offloads_start()
    esw_mode_change()
      mlx5_devcom_comp_lock(esw->dev->priv.hca_devcom_comp)  /* blocks */
  mlx5_lag_enable_change(esw->dev)    /* never reached, counter stays > 0 */

and mlx5_devcom_comp_lock() is a write semaphore shared by all devices
matching the same sw system image GUID:

drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c:
void mlx5_devcom_comp_lock(struct mlx5_devcom_comp_dev *devcom)
{
	if (!devcom)
		return;
	down_write(&devcom->comp->sem);
}

The two threads can be on different devlink instances (mode change on one
PF, aux probe/remove on another PF of the same ldev), so the devlink lock
does not serialize them. msleep() is uninterruptible and the loop has no
timeout or bail-out, and since the wait is a poll on a plain int it is
also invisible to lockdep.

The commit message says the new loop is "mirroring mlx5_lag_remove_mdev()"
- mlx5_lag_remove_mdev() polls the same counter but holds no devcom
semaphore. Is the mirror still valid for callers that do hold sd->devcom
and hca_devcom_comp?

>  	pf = mlx5_lag_pf_by_dev(ldev, primary);
>  	if (!pf) {
>  		sd_warn(primary, "%s: primary not registered in ldev, skipping\n",
> @@ -388,7 +395,13 @@ static void sd_lag_cleanup(struct mlx5_core_dev *dev)
>  	if (!ldev)
>  		return;
>  
> +recheck:
>  	mutex_lock(&ldev->lock);
> +	if (ldev->mode_changes_in_progress) {
> +		mutex_unlock(&ldev->lock);
> +		msleep(100);
> +		goto recheck;
> +	}
>  	mlx5_sd_for_each_secondary(i, primary, pos)
>  		mlx5_ldev_remove_mdev(ldev, pos);
>

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260906071332.3759199-1-tariqt%40nvidia.com
