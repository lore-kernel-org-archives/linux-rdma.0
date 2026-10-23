Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792783926;
	b=vP1OTsaXhjwnPLs/12+xDTGTF4IGzmsubgW2Y+gUlb6s+Q47Mv9Yxk131Tdu5v2IjGnw
	 CYb1CRHi3C2KZPm8dK85dZrx0WjY7EK1w1YhG9hOWFcfaPGzj9q2oRypg9Mz0GZMuTbsv
	 RkQMpDI7nFfXM0tMRun2IlUDoQgbRVwQgqgNen+2Tj6PWHRJ/pFMgFdUCoP7I+w3pVJQo
	 ylcTtseKi438JoT3eSYgljMOw+z6dh+thVliLG7SiVBh0YVFZUteR2+sZR7qqbE/mPEab
	 v5LTOww6Diabvi5tl1QhkivH0FUsNr+2PZRVCVOJS+7R7/F+6o7fXBk2Do9LXN0TjGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792783926;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=K0h2RPvLu19xMok53kpbRFz17ViZnHdTQ/uB739akYw=;
	b=QlB9Uis5lQMdt556gVu1+UTjPQiNBvSBt6OYG9JmTJFGKdLTvu3U2yuRw8X6GkejCqta
	 2uOZHREAPXuig7QcErF3Z2pp+5L9riEiYFWTcWbM4OGOv8L5V5lbL5pxOMVGuGmCJB4KE
	 h7FIvNijwfDY+LocJBN2bJO5cv3r/BdiRgqFNBkbLjnARYnJXnN7KKEzWSzbgz9GvzphW
	 +4Z5Ja7VcHzZruQHMKwHZ3946kffIuiofh4bemZbXDXeAlMkRsEvVqr7TgmCJi/aHIt03
	 X2lBXc2pPfHS8xHJFNBqTNTQcTqum8ZUPAOAuLD3UkRQU6m0ErzQukVyGhLHsd7XdyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M8HlQn0W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8B3606A320;
	Fri, 23 Oct 2026 19:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M8HlQn0W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9821F01828;
	Fri, 23 Oct 2026 19:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792783925;
	bh=K0h2RPvLu19xMok53kpbRFz17ViZnHdTQ/uB739akYw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M8HlQn0WhRQ1FZ+LWxxWIqdIext+G6rE1Yf9QRUmCaWFpD3cfvpqz7Tv7vuV9dWzJ
	 lUmuasLrK3XVDM9d9JYuN1mk2mRAF81sF/I4lWEvncYgHFsZV88fFbi09FHFNZw9+l
	 VgPsalJbVTjKCMrBnzRsqa0vMz1hWzK77DZ5a0STluY1hRnvYbL5bDfgAvFMXeXmt1
	 2EHs104nEeR2pK/HRGxOIeJRGk/Afh6egS+N5H58awsjYPp3hUe1smpfVuLfV5awtU
	 jp0LxXV47Xv6sR3G28leAmRredf2CIrg1l0g2lH9QWaKtyYkc0Hb7uJt9W0J0MBzhR
	 WLQQy+tt9nPwQ==
Message-ID: <sashiko-outbox-183123@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net V2 4/4] net/mlx5: Lag, save and restore vport
 max_tx_speed across LAG
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261022193053.3815866-5-tariqt@nvidia.com>
References: <20261022193053.3815866-1-tariqt@nvidia.com>
 <20261022193053.3815866-5-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 19:32:05 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] net/mlx5: broken LAG state check in mlx5_esw_vport_save_max_tx_spe=
ed()
- [Medium] net/mlx5: unreset aggregate speed in mlx5_lag_reset_vports_speed=
()
- [Medium] net/mlx5: single-PF PCIe bandwidth clamp in mlx5_lag_get_restore=
_speed()
--

commit a16b0bd296f6ec7da26bed226c7219e07a503e4a
Author: Or Har-Toov <ohartoov@nvidia.com>

net/mlx5: Lag, save and restore vport max_tx_speed across LAG

This commit saves each vport's max_tx_speed when enabled so the original
rate limit can be restored on lag teardown even if the link is down. If the
rate was not saved, teardown falls back to a link-derived speed.

Link: https://lore.kernel.org/all/20260915015118.875210-1-kuba@kernel.org/

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/=
net/ethernet/mellanox/mlx5/core/eswitch.c
> index fc197d1dc9dfe..7cf9c15ec65d2 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> @@ -935,6 +935,27 @@ static void esw_vport_cleanup(struct mlx5_eswitch *e=
sw, struct mlx5_vport *vport
>  	esw_vport_cleanup_acl(esw, vport);
>  }
> =20
> +static void mlx5_esw_vport_save_max_tx_speed(struct mlx5_eswitch *esw,
> +					     struct mlx5_vport *vport)
> +{
> +	u16 op_mod =3D MLX5_VPORT_STATE_OP_MOD_ESW_VPORT;
> +	int ret;
> +
> +	if (!MLX5_CAP_ESW(esw->dev, esw_vport_state_max_tx_speed) ||
> +	    vport->vport =3D=3D MLX5_VPORT_UPLINK || vport->max_tx_speed)
> +		return;
> +
> +	if (mlx5_lag_is_active(esw->dev) && !vport->agg_max_tx_speed)
> +		return;
> +
> +	ret =3D mlx5_query_vport_max_tx_speed(esw->dev, op_mod, vport->vport,
> +					    true, &vport->max_tx_speed, NULL);

[Severity: High]
Does the check on mlx5_lag_is_active(esw->dev) and !vport->agg_max_tx_speed
in mlx5_esw_vport_save_max_tx_speed() match how vport->agg_max_tx_speed is
maintained across the driver?

In drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c,
mlx5_lag_modify_device_vports_speed() sets vport->agg_max_tx_speed =3D speed
on every vport and leaves it non-zero after programming firmware:

mlx5_lag_modify_device_vports_speed() {
    ...
		vport->agg_max_tx_speed =3D speed;

		if (!vport->enabled)
			continue;

		ret =3D mlx5_modify_vport_max_tx_speed(mdev, op_mod,
						     vport->vport, true, speed);
    ...
}

Similarly, mlx5_esw_vport_set_max_tx_speed() in
drivers/net/ethernet/mellanox/mlx5/core/eswitch.c writes
vport->agg_max_tx_speed to firmware on vport enable without clearing
vport->agg_max_tx_speed. As a result, while lag is active, vports whose
firmware has already been overwritten with the aggregate speed still have a
non-zero vport->agg_max_tx_speed.

Meanwhile, mlx5_lag_is_active() in
drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c returns true when Socket
Direct shared fdb is active, even when no lag bond is active and
vport->agg_max_tx_speed is 0:

drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:mlx5_lag_is_active() {
    ...
	res  =3D ldev && (__mlx5_lag_is_active(ldev) ||
			__mlx5_lag_is_sd_active(ldev, dev));
    ...
}

When switching a Socket Direct device to switchdev mode via
mlx5_sd_eswitch_mode_set() -> mlx5_sd_activate_shared_fdb() ->
mlx5_lag_shared_fdb_create() in
drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c,
pf->sd_fdb_active is set to true without calling
mlx5_lag_set_vports_agg_speed():

mlx5_lag_shared_fdb_create() {
    ...
		mlx5_lag_for_each(i, 0, ldev, filter) {
			pf =3D mlx5_lag_pf(ldev, i);
			pf->sd_fdb_active =3D true;
		}
    ...
	if (filter =3D=3D MLX5_LAG_FILTER_PORTS || filter =3D=3D MLX5_LAG_FILTER_A=
LL)
		mlx5_lag_set_vports_agg_speed(ldev);
}

The same state (mlx5_lag_is_active(esw->dev) returning true while
vport->agg_max_tx_speed is 0 and firmware still holds the pre-lag speed) al=
so
occurs during lag activation in mlx5_lag_shared_fdb_create() when ldev->lock
is dropped inside mlx5_lag_reload_ib_reps_from_locked() before
mlx5_lag_set_vports_agg_speed() runs, if mlx5_lag_update_agg_speed() fails,
or when creating adjacent vports via mlx5_esw_adj_vport_create().

If a vport is enabled in any of those states (or if the initial
mlx5_query_vport_max_tx_speed() call fails), vport->max_tx_speed remains 0.
Once lag applies the aggregate speed to firmware (setting
vport->agg_max_tx_speed !=3D 0) and that vport is later disabled and
re-enabled while lag is active, won't mlx5_esw_vport_save_max_tx_speed() see
vport->max_tx_speed =3D=3D 0 and vport->agg_max_tx_speed !=3D 0, query firm=
ware,
and overwrite vport->max_tx_speed with the active lag aggregate rate?

[ ... ]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/=
net/ethernet/mellanox/mlx5/core/lag/lag.c
> index afe0b9909f2dc..3e623c96b2a1d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> @@ -1712,11 +1712,37 @@ void mlx5_lag_set_vports_agg_speed(struct mlx5_la=
g *ldev)
>  	}
>  }
> =20
> +static int mlx5_lag_get_restore_speed(struct mlx5_core_dev *mdev,
> +				      struct mlx5_vport *vport, u32 *speed)
> +{
> +	u32 pci_bw;
> +
> +	if (vport->max_tx_speed) {
> +		*speed =3D vport->max_tx_speed;
> +		return 0;
> +	}
> +
> +	*speed =3D 0;
> +	mlx5_port_oper_linkspeed(mdev, speed);
> +	if (!*speed && mlx5_port_max_linkspeed(mdev, speed))
> +		return -ENODATA;
> +
> +	pci_bw =3D pcie_bandwidth_mbps(mdev->pdev);
> +	if (pci_bw)
> +		*speed =3D min(*speed, pci_bw);
> +	*speed /=3D MLX5_MAX_TX_SPEED_UNIT;
> +	return 0;
> +}

[Severity: Medium]
On Socket Direct devices where a single physical port spans multiple pcie
functions in the same group (port->group_id), calling
pcie_bandwidth_mbps(mdev->pdev) in mlx5_lag_get_restore_speed() only checks
a single function's pcie bandwidth.

Earlier in drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c,
mlx5_lag_port_pcie_bw() sums the bandwidth across all member functions in
the Socket Direct group:

drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:mlx5_lag_port_pcie_bw() {
    ...
	if (!port->group_id)
		return mlx5_lag_dev_pcie_bw(port->dev, bw);

	*bw =3D 0;
	mlx5_lag_for_each(idx, 0, ldev, port->group_id) {
		member =3D mlx5_lag_pf(ldev, idx);
		if (!member)
			continue;

		err =3D mlx5_lag_dev_pcie_bw(member->dev, &member_bw);
    ...
}

Should mlx5_lag_get_restore_speed() use mlx5_lag_port_pcie_bw() instead of
pcie_bandwidth_mbps(mdev->pdev) so that Socket Direct ports are not clamped
to a single function's pcie bandwidth on fallback restore?

> +
>  void mlx5_lag_reset_vports_speed(struct mlx5_lag *ldev)
>  {
> +	u16 op_mod =3D MLX5_VPORT_STATE_OP_MOD_ESW_VPORT;
>  	struct mlx5_core_dev *mdev;
> +	struct mlx5_eswitch *esw;
> +	struct mlx5_vport *vport;
>  	struct lag_func *pf;
> -	u32 speed;
> +	u32 restore_speed;
> +	unsigned long i;
>  	int pf_idx;
>  	int ret;
> =20
> @@ -1728,17 +1754,39 @@ void mlx5_lag_reset_vports_speed(struct mlx5_lag =
*ldev)
>  		mdev =3D pf->dev;
>  		if (!mdev)
>  			continue;
> -
> -		ret =3D mlx5_port_oper_linkspeed(mdev, &speed);
> -		if (ret) {
> -			mlx5_core_dbg(mdev,
> -				      "Failed to reset vports speed for device %s. Oper speed is not=
 available (err=3D%d)\n",
> -				      dev_name(mdev->device), ret);
> +		esw =3D mdev->priv.eswitch;
> +		if (!esw || !MLX5_CAP_ESW(mdev, esw_vport_state_max_tx_speed))
>  			continue;
> -		}
> =20
> -		speed =3D speed / MLX5_MAX_TX_SPEED_UNIT;
> -		mlx5_lag_modify_device_vports_speed(mdev, speed);
> +		mutex_lock(&esw->state_lock);
> +		mlx5_esw_for_each_vport(esw, i, vport) {
> +			if (!vport || vport->vport =3D=3D MLX5_VPORT_UPLINK)
> +				continue;
> +
> +			if (!vport->enabled) {
> +				vport->agg_max_tx_speed =3D vport->max_tx_speed;
> +				continue;
> +			}
> +
> +			if (mlx5_lag_get_restore_speed(mdev, vport,
> +						       &restore_speed)) {
> +				vport->agg_max_tx_speed =3D 0;
> +				continue;
> +			}
> +
> +			ret =3D mlx5_modify_vport_max_tx_speed(mdev, op_mod,
> +							     vport->vport,
> +							     true,
> +							     restore_speed);
> +			if (ret) {
> +				mlx5_core_dbg(mdev,
> +					      "Failed to restore vport %d max tx speed, err=3D%d\n",
> +					      vport->vport, ret);
> +				continue;
> +			}
> +			vport->agg_max_tx_speed =3D 0;
> +		}
> +		mutex_unlock(&esw->state_lock);
>  	}
>  }
>  #endif

[Severity: Medium]
What happens in mlx5_lag_reset_vports_speed() if a vport was enabled while
lag was active (so firmware was programmed with the aggregate speed), its
baseline vport->max_tx_speed was not saved (remaining 0), and the vport is
then disabled before lag teardown?

When mlx5_lag_reset_vports_speed() runs, the !vport->enabled branch sets
vport->agg_max_tx_speed =3D vport->max_tx_speed (0) instead of computing a
fallback speed via mlx5_lag_get_restore_speed(). When that vport is later
re-enabled after lag teardown in mlx5_esw_vport_enable():

drivers/net/ethernet/mellanox/mlx5/core/eswitch.c:mlx5_esw_vport_enable() {
    ...
	mlx5_esw_vport_save_max_tx_speed(esw, vport);
	if (vport->agg_max_tx_speed)
		mlx5_esw_vport_set_max_tx_speed(esw, vport);
    ...
}

mlx5_esw_vport_save_max_tx_speed() sees vport->max_tx_speed =3D=3D 0 and
!mlx5_lag_is_active(esw->dev), queries firmware (which still holds the
unrestored lag aggregate speed), and saves the aggregate speed into
vport->max_tx_speed, while skipping mlx5_esw_vport_set_max_tx_speed()
because vport->agg_max_tx_speed is 0.

Also, for an enabled vport, if mlx5_modify_vport_max_tx_speed() fails in
mlx5_lag_reset_vports_speed(), the error path continues before updating
vport->agg_max_tx_speed. Won't that leave the stale lag aggregate rate in
vport->agg_max_tx_speed, causing a subsequent disable and re-enable of the
vport outside of lag to replay the old lag aggregate speed into firmware?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022193053.3815=
866-1-tariqt@nvidia.com?part=3D4
