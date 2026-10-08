Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87E73F9278;
	Thu,  8 Oct 2026 11:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791458710; cv=none; b=kMwEURF3RP7fbAh3D1laQY5p1muOgnz/ZiiWWmpn2BghrCsIgNrKMVKB63riNiUktYxQJIHlxP0lgccfBGYc4UC0U+Iu0d1pimZ6rMbYcIAWQ/8gTOfo0yGRtPYFTg2VCpXcPMOTpsDlRwsF2Cq/LhKitZLHYZd+V4gyKD2mVNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791458710; c=relaxed/simple;
	bh=n1zXg+ubN5fMmYdyWRd04OhARz9l/0jBEVVvFXlnO4A=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HrAgy7+iCKEWYWdHtIlHlIgOmKkbFzLKoRNVv0uMzzwRkA/LIOpI1ruzazM3AH9d2FPTlLR1YH52SfjsOtBQ4Ei92B4NsRpBYkGUQx8p21x3DZxyTWB/4/DS+4PK4dUJ8q9LK1irzw7ZQ0uoiiJ2OHabYPag6xmF/eT7PmCCqfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ps1HK+Jh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ps1HK+Jh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61DC1F000FF;
	Thu,  8 Oct 2026 11:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791458709;
	bh=FLHQ3z0rCPAU/bcGQQoije/kQRz+r11dxAy44WD1rb8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Ps1HK+JhbffBvuxRoj/rHaqI5HPo1Pa7JQMfDh/5TfM3gyn4fEczTX2+fxdov+e8E
	 5rXoJ8F6GhGxaF7zLWy10Xwzowbqf6H/MXLyhAnLOiJZDEYEnzFIVH/cBu+Gfb0N9i
	 rIYUxiSYGg7NlL5nqtk7aD1QG+Qr1bRlQ3mCh5hkNtwzwfZtNzrPJVOgsDFFZMnTdz
	 mh6Uf2cKjBtGNPDiyzd/ZJGQ72E2Yi2EPf+2MCnSW2mFG9aJHoNol7Q3yWWywz2D+B
	 3TT96Rw7KclX2YhaBdZAFnOiZjCI/7vL9y7nAtLPwuuL/oITX1rTQZm7G8r6lcWave
	 7TxPDFQgPl0Kw==
Subject: Re: [PATCH net V2] net/mlx5: Lag, reset vport speed on MPESW teardown
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 edwards@nvidia.com, gal@nvidia.com, kees@kernel.org, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, msanalla@nvidia.com,
 mbloch@nvidia.com, moshe@nvidia.com, ohartoov@nvidia.com, saeedm@nvidia.com,
 shayd@nvidia.com
Date: Thu, 08 Oct 2026 11:25:08 +0000
Message-ID: <179145870829.434549.18408966313287855938@kernel.org>
In-Reply-To: <20261006112415.259157-1-tariqt@nvidia.com>
References: <20261006112415.259157-1-tariqt@nvidia.com>
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

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The fix says it removes stale cached and FW-configured vport
  speeds after MPESW teardown, and it relies on…

--

net/mlx5: Lag, reset vport speed on MPESW teardown

This adds a call to mlx5_lag_reset_vports_speed() in
mlx5_lag_disable_mpesw(). Regular LAG teardown in mlx5_do_bond() already
makes this call, and the MPESW path now matches it. The goal is to stop
cached and FW-configured vport speeds from going stale after MPESW
teardown.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
> index abf72026c7513..e0a57b7dd82ed 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
> @@ -157,6 +157,7 @@ void mlx5_lag_disable_mpesw(struct mlx5_lag *ldev)
>  	if (ldev->mode != MLX5_LAG_MODE_MPESW)
>  		return;
>  
> +	mlx5_lag_reset_vports_speed(ldev);

[Severity: Medium]
The commit message says this addresses "stale cached and FW-configured
speeds after MPESW is torn down". Does mlx5_lag_reset_vports_speed()
actually put the vports back into their pre-LAG unset state?

The helper reads the current uplink oper speed and writes it as a non-zero
value:

drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:mlx5_lag_reset_vports_speed() {
    ...
		ret = mlx5_port_oper_linkspeed(mdev, &speed);
    ...
		speed = speed / MLX5_MAX_TX_SPEED_UNIT;
		mlx5_lag_modify_device_vports_speed(mdev, speed);
}

mlx5_lag_modify_device_vports_speed() then caches that value. It also
programs the value into FW for every enabled non-uplink vport:

		vport->agg_max_tx_speed = speed;
    ...
		ret = mlx5_modify_vport_max_tx_speed(mdev, op_mod,
						     vport->vport, true, speed);

Elsewhere, 0 looks like the "no override" value. mlx5_esw_vport_enable()
only programs a speed when the cached value is non-zero:

	if (vport->agg_max_tx_speed)
		mlx5_esw_vport_set_max_tx_speed(esw, vport);

mlx5_ib_query_port_speed_from_vport() falls back to the live port speed
only when max_tx_speed is 0:

	if (vport_state == VPORT_STATE_DOWN || max_tx_speed == 0)
		/* Value 0 indicates field not supported, fallback */

After teardown, nothing refreshes this snapshot.
mlx5_mpesw_speed_update_work() only acts when ldev->mode is still
MLX5_LAG_MODE_MPESW.

Say the uplink later renegotiates to a different speed. Would the vports
keep reporting the teardown-time speed, with FW still holding it as
max_tx_speed? VFs created after the LAG is gone would also get the
snapshot through mlx5_esw_vport_enable().

There is also the failure path. If mlx5_port_oper_linkspeed() fails during
the reset, the helper skips that device:

		if (ret) {
			mlx5_core_dbg(mdev, ...);
			continue;
		}

That leaves the full MPESW aggregate in both agg_max_tx_speed and FW for
that device. Isn't that the same stale state this commit is meant to
remove?

Should teardown clear the override back to 0 instead of writing a
snapshot of the current oper speed?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261006112415.259157-1-tariqt%40nvidia.com
