Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DBE47DFBF
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 09:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792143309; cv=none; b=C5aaApFy2gXL8V09yv3HwM/RNYKZJm+h5yzYxFX0Sgp+oW3eVIR+Rj8Edevm0JTSVmsbi/Lrzv3Eut2nkZHaVbRYDveUNlaTCe4gA2S7ptuRlgudMxW99rOjzmJts3hOQRGh7A3I5mMm9Emw7ItACilE1HfHGIp01RPRxVeeWV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792143309; c=relaxed/simple;
	bh=0lZgiHtNGaP4+VfQSfRBG7VJk1kD4u/xMu+fWU9Jsfw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=otPB7FoV59b1CsgX2ZNrafLYvqaJNICuV3Xq6DiMWCuyd28WrXNx5F+tycTNoBgk/lFZbwyVm/qBpa02FuKFFeEXYXPEKGsR2Uqz+MB+kfLZUPA0IaQDfX3C1oyD9VfX098R61tMlvLob26pNgPR5a8cUgzDS0YtUNWebFyYLDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XOe7eNOr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XOe7eNOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651691F000C4;
	Fri, 16 Oct 2026 09:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792143307;
	bh=NdDPW6hlkpQ79Yg6IoqKqf/z4UCiZGu3xOJybdg87Kk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XOe7eNOrUul+eP46+c6GlNtx7TFAUsmqbp2GjZm+JK69NarxvfSOiG0F4QI1VnsNQ
	 kjjjU3lmp2lmOoReZVr2bXbDaFspvSGj5m+z60tXmeUdq3LY9njym71EoNbn3SoozW
	 EUGgjUqjT5lSoM6TlB0rOmIFgbiF7UHgcOsG98Ue0dK5Hl66ApdkmoPrsbHKcIYNRZ
	 QdoQUkcUMIpdvd0cksnjFtE2xfZEiLSrfERfBlpMMCn+gVL2AbthoKXeYnPHWZIJs3
	 Fi6KWbY9g8PRC1IGcrkSoiAlmvVL47KJSpNploeZI2Ew2PDjnZVSninRVyF4d6syzl
	 kXNoEqTMxwgaQ==
Message-ID: <sashiko-outbox-174082@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5: Fix lock dependency cycle on uplink
 unbind in switchdev mode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261015093419.1150837-1-tariqt@nvidia.com>
References: <20261015093419.1150837-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 09:35:06 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] net/mlx5: race condition in mlx5_eswitch_safe_aux_devs_remove() te=
ardown
--

commit 2e432cf53969d688514fb1e87aa9e496706a3090
Author: Shay Drory <shayd@nvidia.com>

net/mlx5: Fix lock dependency cycle on uplink unbind in switchdev mode

This commit addresses a lockdep cycle involving mode_lock, reps_lock, and
rtnl_mutex. It resolves the cycle by setting the eswitch_operation_in_progr=
ess
flag, dropping the mode_lock before removing auxiliary devices, and retaking
it afterward to keep mode_lock and reps_lock un-nested.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b=
/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index eb74b62601682..f934cb2b26b08 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c

[ ... ]

> @@ -4455,9 +4476,19 @@ void mlx5_eswitch_safe_aux_devs_remove(struct mlx5=
_core_dev *dev)
>  		}
>  	}
>  	if (hold_esw) {
> +		/* Keep mode_lock and reps_lock unnested. The operation flag
> +		 * excludes mode users while mode_lock is dropped before the
> +		 * REPs removal takes reps_lock.
> +		 */
> +		esw->eswitch_operation_in_progress =3D true;
> +		mlx5_esw_unlock(esw);

[Severity: High]
Does this safely prevent concurrent devlink commands from executing?

This teardown path drops mode_lock and relies on eswitch_operation_in_progr=
ess
to prevent concurrent mode changes.

However, devlink callbacks like mlx5_devlink_switchdev_active_mode_change()
do not seem to check this flag via mlx5_esw_try_lock(). Instead, they
unconditionally acquire the lock:

mlx5_devlink_switchdev_active_mode_change() {
    down_write(&esw->mode_lock);
    esw->offloads_inactive =3D !esw->offloads_inactive;
    esw->eswitch_operation_in_progress =3D true;
    up_write(&esw->mode_lock);
   =20
    ...
   =20
    down_write(&esw->mode_lock);
    esw->eswitch_operation_in_progress =3D false;
    up_write(&esw->mode_lock);
}

If a concurrent devlink command runs after mode_lock is dropped here, could
it acquire the lock, unconditionally overwrite the flag, execute, and then
clear the flag to false upon exit?

If this happens, it would prematurely clear the flag while
mlx5_core_reps_aux_devs_remove() is still actively tearing down the auxilia=
ry
devices, potentially exposing the un-nested lock region to other concurrent
mode transitions or TC offloads.

>  		if (mlx5_eswitch_mode(dev) =3D=3D MLX5_ESWITCH_OFFLOADS)
>  			mlx5_core_reps_aux_devs_remove(dev);
> -		mlx5_esw_release(dev);
> +
> +		down_write(&esw->mode_lock);
> +		esw->eswitch_operation_in_progress =3D false;
> +		mlx5_esw_unlock(esw);
>  	}
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015093419.1150=
837-1-tariqt@nvidia.com?part=3D1
