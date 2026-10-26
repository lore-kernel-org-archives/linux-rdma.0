Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793046735;
	b=u0iJgzn95PKV/xxetxaa2uy3boTILqN3NY/dFN+q6vb9Y/CHThV5tamvKt38XAMQdqhB
	 q/145LeZeKrboTF75yIhctHEQX6IIbw6rBfR/h/6bIPnJbv+arGaSbGtU3Dew2LJhh/BZ
	 LOdOBBoTc4bfGEBq6jlYE2R9FoXCoUTNGdNIIbwq+cKqliZVC06T7JRZ12TdOxnXBZj5O
	 i20y7PDpWVsp9kF/gs/f6DI9QNvD5sfet9roH8Cl6u5a15ssxF7+fe7h3GGEEvE8gbVTG
	 7WUrLAJsWX8AFLVoOdNJ/IML/S0dTQFwRqIbXbkERuT+RB5GmvBPJmW/XTjDTv6zkLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793046735;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=R3ND/zRroCPy3olb6Q5mBbP8BOpmU+o557H0KoMUBFE=;
	b=er6K+aOV/aifz4RWYuPL6v0aTy5ynRLeK3o3/qic36wAWnwn06qIoQ00RoOj7Ff1AL0O
	 3R3C0wNZvdFD92BvvjodSVN5EIvHPg9WNTVXkWIflxhy4Hdbh9U91j1yO9nMhIaeReaMS
	 yHkkZmIScbKHQc64m05kLK1nBJcPyX/AKAzy9fWD6L26OpF+B/jsM+9DVkCgaror4E8px
	 da8tmaOfx/IOo2XRHfdF9lsAxXyZH07hO2n9hCrPiR/33+uCd/eOJ7p0JrAAgpMryiauf
	 1k2yER3gBLLvbVMS0cUjY/vyua4WA4zn/2FRO3TNlBToh9oEEXh0ld4ubqyeOM2W8PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="UNS/KxAg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D94606A31F;
	Mon, 26 Oct 2026 20:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UNS/KxAg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05151F01825;
	Mon, 26 Oct 2026 20:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793046735;
	bh=R3ND/zRroCPy3olb6Q5mBbP8BOpmU+o557H0KoMUBFE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=UNS/KxAgupqUJ4yjVXmq7zY+x5+VP+M+1x1VJdK8Q7GTv1EFMfrbX0nO0sDiewmqL
	 eywPtgTvEz4kEFhXapxBjzv5pVKTmbVJoSfbJy1KobGP7zRJzsPB9EtWWnHXiMFD/V
	 Z50tQZHzrv9f9b2S8YTiTzjXyk/6Fu8ciRlwg/Wt0LtM2Y6lHOa6/jBc6LgxpREP8A
	 TGj6HGjaDRMxCmMoqHFQrAXGdM8EUtzsIiRDoUz5qNaWXvYhrFX5DTas4CVl+OurJx
	 DuitGxMxixlkiNZvObuAVoaLqindJIUNjkD6jk0sh51rS+fjPOSGQnCfHGxpCAudOW
	 UJspPqxNIz3Wg==
Subject: Re: [PATCH net V2 4/4] net/mlx5: Lag, save and restore vport
 max_tx_speed across LAG
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 bhelgaas@google.com, cjubran@nvidia.com, cratiu@nvidia.com,
 edwards@nvidia.com, gal@nvidia.com, jgg@ziepe.ca, kees@kernel.org,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
 linux-rdma@vger.kernel.org, msanalla@nvidia.com, mbloch@nvidia.com,
 ohartoov@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com
Date: Mon, 26 Oct 2026 20:32:13 +0000
Message-ID: <179304673356.3134.5707726348290129321@kernel.org>
In-Reply-To: <20261022193053.3815866-5-tariqt@nvidia.com>
References: <20261022193053.3815866-5-tariqt@nvidia.com>
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

Thank you for your contribution! Sashiko AI review found 7 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 5 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] mlx5_esw_vport_save_max_tx_speed() (eswitch.c:948) treats a non-
  zero agg_max_tx_speed during an active LAG as meaning the aggregate is…
- [Medium] The new restore logic only runs on one LAG teardown path.
- [Medium] vport->max_tx_speed is read from FW only once per mlx5_vport
  object, because of the `|| vport->max_tx_speed) return;` early return…
- [Medium] In mlx5_lag_reset_vports_speed(), when
  mlx5_modify_vport_max_tx_speed() fails for an enabled vport, the loop…
- [Medium] mlx5_lag_reset_vports_speed() records agg_max_tx_speed = 0 in
  two cases where FW still holds the LAG aggregate.
- [Medium] The save gate in mlx5_esw_vport_save_max_tx_speed() uses
  mlx5_lag_is_active(), which reads ldev->mode under lag_lock.
- [Low] The fallback in mlx5_lag_get_restore_speed() clamps with the raw
  per-device pcie_bandwidth_mbps(mdev->pdev).

--

net/mlx5: Lag, save and restore vport max_tx_speed across LAG

This commit reads each vport's max_tx_speed from FW when the vport is
enabled. At LAG teardown it writes that saved value back per vport,
instead of writing the oper link speed. If nothing was saved, it falls
back to a link-derived speed clamped by PCIe bandwidth, and disabled
vports get their saved value as agg_max_tx_speed for the next enable.

Link: https://lore.kernel.org/all/20260915015118.875210-1-kuba@kernel.org/

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> index fc197d1dc9dfe..7cf9c15ec65d2 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> @@ -935,6 +935,27 @@ static void esw_vport_cleanup(struct mlx5_eswitch *esw, struct mlx5_vport *vport
>  	esw_vport_cleanup_acl(esw, vport);
>  }
>  
> +static void mlx5_esw_vport_save_max_tx_speed(struct mlx5_eswitch *esw,
> +					     struct mlx5_vport *vport)
> +{
> +	u16 op_mod = MLX5_VPORT_STATE_OP_MOD_ESW_VPORT;
> +	int ret;
> +
> +	if (!MLX5_CAP_ESW(esw->dev, esw_vport_state_max_tx_speed) ||
> +	    vport->vport == MLX5_VPORT_UPLINK || vport->max_tx_speed)
> +		return;

[Severity: Medium]
Once vport->max_tx_speed is non-zero, this returns early. Nothing in the
patch ever sets it back to 0. Can the saved value go stale?

The mlx5_vport objects are allocated once, in mlx5_esw_vports_init()
from mlx5_init_once(). They survive devlink reload, fw_activate, sync
reset and health recovery, because mlx5_load_one_devl_locked() only
runs mlx5_function_setup() and mlx5_load().

After such a reset, FW may recompute its per-vport default (the lower
of port speed and PCIe bandwidth). If the PCIe link or port speed has
changed, mlx5_lag_get_restore_speed() still uses the old saved value at
the next teardown.

For disabled vports, the old value is copied into agg_max_tx_speed.
Since that field is never cleared, mlx5_esw_vport_enable() writes it on
every later enable, even when no LAG is configured.

Should max_tx_speed be reset on reload/reset, or read again from FW
when no LAG is active?

> +
> +	if (mlx5_lag_is_active(esw->dev) && !vport->agg_max_tx_speed)
> +		return;

[Severity: High]
This check reads a non-zero agg_max_tx_speed during an active LAG as
"the aggregate is pending and FW still holds the original". Is that
always the case?

mlx5_lag_modify_device_vports_speed() sets agg_max_tx_speed for every
vport. For enabled vports it also writes the aggregate to FW right away:

    vport->agg_max_tx_speed = speed;

    if (!vport->enabled)
        continue;

    ret = mlx5_modify_vport_max_tx_speed(mdev, op_mod, vport->vport, true, speed);

Nothing clears agg_max_tx_speed once it has been applied.
mlx5_esw_vport_disable() doesn't touch agg_max_tx_speed or
max_tx_speed either.

So take a vport with max_tx_speed == 0 while FW already holds the
aggregate. That state is reachable in two ways:

- An earlier save query failed (only logged at debug level).
- The vport was enabled while mlx5_lag_is_active() was true and
  agg_max_tx_speed was 0, so the save was skipped. One example is an
  SD-only shared FDB: __mlx5_lag_is_sd_active() makes
  mlx5_lag_is_active() return true, but no aggregate is applied. A
  later aggregate, for example from MPESW enable, then lands on the
  enabled vport.

If that vport is disabled and re-enabled while the LAG is still active,
this check passes. The query then stores the FW aggregate in
vport->max_tx_speed.

At teardown, mlx5_lag_get_restore_speed() returns that value and the
aggregate is written back. Because max_tx_speed is never reset, every
later LAG cycle restores the same wrong baseline.

That seems to contradict the commit message:

    If the max_tx_speed of a vport could not be saved, it stays zero and
    mlx5_lag_get_restore_speed() falls back to a link-derived speed at
    teardown.

Is a separate marker needed here, one that can tell "aggregate pending"
apart from "aggregate applied"?

[Severity: Medium]
Does mlx5_lag_is_active() stay consistent with agg_max_tx_speed here?

mlx5_lag_is_active() reads ldev->mode under lag_lock. ldev->mode is
written under ldev->lock only, in mlx5_activate_lag() and
mlx5_deactivate_lag(). agg_max_tx_speed and the FW aggregate are
written in a separate esw->state_lock section.

On activation, mlx5_do_bond()->mlx5_lag_shared_fdb_create() sets the
mode and drops ldev->lock for rep rescans and reloads. Only after that
does it call mlx5_lag_set_vports_agg_speed().

A vport can be enabled in that window. One way is mlx5_eswitch_enable()
when the FDB already exists: toggle_lag is false, so
mlx5_lag_disable_change() doesn't serialize it. SF/ECPF function
changes are another way. Such a vport sees an active LAG with
agg_max_tx_speed == 0. It skips the save even though FW still holds the
original, and then receives the aggregate.

On teardown, mlx5_do_bond() does:

    mlx5_lag_reset_vports_speed(ldev);
    mlx5_disable_lag(ldev);

The mode is still set after mlx5_lag_reset_vports_speed() drops
state_lock. A vport enabled in that window also skips the save.

Either way, the vport ends up with max_tx_speed == 0 while FW holds the
aggregate. Isn't that the precondition for the saved-baseline problem
described above?

> +
> +	ret = mlx5_query_vport_max_tx_speed(esw->dev, op_mod, vport->vport,
> +					    true, &vport->max_tx_speed, NULL);
> +	if (ret)
> +		mlx5_core_dbg(esw->dev,
> +			      "Failed to save vport %d max tx speed, err=%d\n",
> +			      vport->vport, ret);
> +}

[ ... ]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> index afe0b9909f2dc..3e623c96b2a1d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> @@ -1712,11 +1712,37 @@ void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev)
>  	}
>  }
>  
> +static int mlx5_lag_get_restore_speed(struct mlx5_core_dev *mdev,
> +				      struct mlx5_vport *vport, u32 *speed)
> +{
> +	u32 pci_bw;
> +
> +	if (vport->max_tx_speed) {
> +		*speed = vport->max_tx_speed;
> +		return 0;
> +	}
> +
> +	*speed = 0;
> +	mlx5_port_oper_linkspeed(mdev, speed);
> +	if (!*speed && mlx5_port_max_linkspeed(mdev, speed))
> +		return -ENODATA;
> +
> +	pci_bw = pcie_bandwidth_mbps(mdev->pdev);
> +	if (pci_bw)
> +		*speed = min(*speed, pci_bw);

[Severity: Low]
This might not be an issue, but the fallback clamps with the per-device
pcie_bandwidth_mbps(mdev->pdev). The aggregate path uses
mlx5_lag_port_pcie_bw() instead, which sums bandwidth across
Socket-Direct group members and treats RC_END as unlimited.

The restore value is per vport, and the FW default is described as
coming from the endpoint's own link status. So the per-device clamp may
be intended. For RC_END, pcie_bandwidth_mbps() returns 0 and the
if (pci_bw) check skips the clamp.

Could a short comment explain why the per-device value is used here
rather than the SD-aware helper?

> +	*speed /= MLX5_MAX_TX_SPEED_UNIT;
> +	return 0;
> +}

[ ... ]

> @@ -1728,17 +1754,39 @@ void mlx5_lag_reset_vports_speed(struct mlx5_lag *ldev)
>  		mdev = pf->dev;
>  		if (!mdev)
>  			continue;
> -
> -		ret = mlx5_port_oper_linkspeed(mdev, &speed);
> -		if (ret) {
> -			mlx5_core_dbg(mdev,
> -				      "Failed to reset vports speed for device %s. Oper speed is not available (err=%d)\n",
> -				      dev_name(mdev->device), ret);
> +		esw = mdev->priv.eswitch;
> +		if (!esw || !MLX5_CAP_ESW(mdev, esw_vport_state_max_tx_speed))
>  			continue;
> -		}
>  
> -		speed = speed / MLX5_MAX_TX_SPEED_UNIT;
> -		mlx5_lag_modify_device_vports_speed(mdev, speed);
> +		mutex_lock(&esw->state_lock);
> +		mlx5_esw_for_each_vport(esw, i, vport) {

[Severity: Medium]
mlx5_lag_reset_vports_speed() is only called from the
mlx5_lag_should_disable_lag() branch of mlx5_do_bond(). That predicate
excludes MPESW:

    return !do_bond && __mlx5_lag_is_active(ldev) &&
           ldev->mode != MLX5_LAG_MODE_MPESW;

Should the other teardown paths restore vport speeds as well?

mlx5_lag_disable_change() goes straight to mlx5_lag_disable_mpesw() or
mlx5_disable_lag(). It is called from mlx5_eswitch_enable(),
mlx5_eswitch_disable() and the devlink eswitch mode change.

Explicit MPESW disable goes through
mlx5_mpesw_work()->mlx5_lag_disable_mpesw()->mlx5_lag_shared_fdb_destroy(),
and doesn't restore either.

The aggregate is still applied when these LAGs come up, through
mlx5_lag_shared_fdb_create()->mlx5_lag_set_vports_agg_speed() and
mlx5_mpesw_speed_update_work().

After those teardowns, FW and agg_max_tx_speed both still hold the
aggregate. mlx5_esw_vport_enable() writes it again on every later
enable.

With the new save step, a vport whose max_tx_speed is still 0 then
reads the leftover aggregate from FW and keeps it as its saved
original. Every later mlx5_do_bond() teardown then restores the
aggregate.

The missing restore calls on these paths were already there before
this patch. But the commit message says the saved value is restored
"at teardown", and the interaction with the new save step is new.

> +			if (!vport || vport->vport == MLX5_VPORT_UPLINK)
> +				continue;
> +
> +			if (!vport->enabled) {
> +				vport->agg_max_tx_speed = vport->max_tx_speed;
> +				continue;
> +			}
> +
> +			if (mlx5_lag_get_restore_speed(mdev, vport,
> +						       &restore_speed)) {
> +				vport->agg_max_tx_speed = 0;
> +				continue;
> +			}

[Severity: Medium]
Both of these branches set agg_max_tx_speed to 0 without writing FW.
Could FW still hold the aggregate in either case?

For a disabled vport with max_tx_speed == 0, the pending restore is
dropped. That vport may have been enabled partway through the LAG
without a saved value (the mlx5_lag_is_active() check skipped the save,
or the query failed). It then received the aggregate and was disabled
before teardown.

The patch already assumes FW keeps max_tx_speed across a vport disable.
That is why disabled vports get a replay value.

For an enabled vport, mlx5_lag_get_restore_speed() returns -ENODATA
when nothing was saved and the PTYS query fails.

In both cases, the next mlx5_esw_vport_enable() after the LAG is gone
sees max_tx_speed == 0 and an inactive LAG. It queries FW and saves the
leftover aggregate as the original.

Before this patch, disabled vports got agg_max_tx_speed set to the oper
speed, so re-enabling them corrected FW.

The commit message covers "a vport disabled for the entire LAG period".
Does the same reasoning hold for a vport that was disabled partway
through the LAG?

> +
> +			ret = mlx5_modify_vport_max_tx_speed(mdev, op_mod,
> +							     vport->vport,
> +							     true,
> +							     restore_speed);
> +			if (ret) {
> +				mlx5_core_dbg(mdev,
> +					      "Failed to restore vport %d max tx speed, err=%d\n",
> +					      vport->vport, ret);
> +				continue;
> +			}

[Severity: Medium]
If mlx5_modify_vport_max_tx_speed() fails here, agg_max_tx_speed keeps
the LAG aggregate. Is that intended?

Before, mlx5_lag_modify_device_vports_speed() set agg_max_tx_speed to
the teardown speed before trying the FW write. A later enable would
then retry with a non-LAG value.

Now, on a later enable with no LAG active, mlx5_esw_vport_enable()
runs:

    if (vport->agg_max_tx_speed)
        mlx5_esw_vport_set_max_tx_speed(esw, vport);

which writes the stale aggregate to FW again. If max_tx_speed is still
0, the save step runs first and records the aggregate still in FW as
the baseline.

That looks like the state the commit message says is fixed:

    leaving the aggregate in FW and in agg_max_tx_speed

Would setting vport->agg_max_tx_speed = restore_speed in this failure
branch let the next enable retry the restore?

> +			vport->agg_max_tx_speed = 0;
> +		}
> +		mutex_unlock(&esw->state_lock);

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261022193053.3815866-1-tariqt%40nvidia.com
