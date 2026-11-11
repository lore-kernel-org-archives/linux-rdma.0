Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404805;
	b=CtQXoFwXvFAzl8nZkWgr7eb9/DQRptm/ZgSl9K/H1+2aEB6maj6lCPN6BntWol5UMUkl
	 ZRAwlWWyxIxap2vzByObKJi4StJPXrGVwEs8RIdyfQxDD9OzJQbOxKm9vLYZvDjvNfybH
	 QTmw0ZseySoHAUpeeHwHve/FdkoW3jFOh6JrDpLBoJShbpu5ddm5UNBF98sHd7zatQf7L
	 RsbJ7UMB+6sqczePfYnaLaR3xpdr8gUaIaqAy2rhc8gIxvfn4ACS30lgyKJ27O4tUOu5B
	 ut8kwqXlNIcEJ3WeB8MURyN8Ji8BMpDZeFfuc/Opo0TSzTjEXv6OggSq/d+t4kJ0qVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404805;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Bfffzgaz89mseLqot3jchv9+/IWcdAa8r9vEwyZx/y8=;
	b=cRtsMf6zzfbM1+doMNvu7MoyNFnI/1Z9E72IlGKry5AVc/Mymv3ACp5RWnQR7qezPQuq
	 66FQVKeMO5kCLk99qNEn1VjthizcN9/Sk+HHUrk5HvkY/QnjKtEaqApfIbT9ywqSIiTvF
	 KEbEurNq6E1K7Hy5V6e6vhpoIqZAjFXPjsw+8/37MiEj8tfLSk6bgS5MB3Cp4d5jYsmlJ
	 VHaMC1hm+RM+cKeXKM5sfw1hHPK0EXCjtEq/lRcBBA5nO1OlpzbYcyvV7NHaTZowj5m40
	 9qFFtVPLnHBCIrESYu5Vq44OsdwgAzSNv8tNZBMv4DAMb9ORETLrGrQR+C/MqZzaicA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VwIsYXbk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC8D606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VwIsYXbk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10F61F00A05;
	Wed, 11 Nov 2026 13:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794404804;
	bh=Bfffzgaz89mseLqot3jchv9+/IWcdAa8r9vEwyZx/y8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VwIsYXbkQkMGspSSGKN2fDiqfNTgsq3ob2DfrzuZ1u2Cyl3HXzqIKdgBm+nUEZyak
	 H156e/8EWWcQpmX2GIPyCNmzLlWLDW3bIQlg8n+npDc1thpWenOWkZJEQnD2XncrRH
	 giy+7qNyVgpfiH+4KGa6yAJJVRosb5LgqzuFC3oPB3A5QAGmzNQ6w2KFNfOokJmCkD
	 tgniHEVAL/3BG70XK3SeTJGtzKyzVE5s/uV5w8wAoWMhiwEyXV8pnCw/KUE+mJVuMA
	 woYKbOU6HPDyRLUibW3eBJAQ3gNM8ZoO13ZDfkeVzgF+0xCBlgLUmD37lKH/EqvqF9
	 ChX5HF0bOAW8g==
Message-ID: <sashiko-outbox-209086@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 01/24] net/mlx5: Add
 mlx5_trigger_health_work_force()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110134320.34408-2-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-2-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:46:44 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] net/mlx5: stale force_fatal_report_work unloads device after
  recovery
--

commit 0df37fc156d59f375d27165a97578e68ca1e9e3f
Author: Yishai Hadas <yishaih@nvidia.com>

net/mlx5: Add mlx5_trigger_health_work_force()

This commit adds mlx5_trigger_health_work_force() to queue a dedicated
health recovery work item that stops the firmware and forces the device
into MLX5_DEVICE_STATE_INTERNAL_ERROR even when the health sensors do not
report a fault.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/health.c
> index aeeb136f5ebc7..e76351860b154 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
> @@ -627,18 +627,11 @@ mlx5_fw_fatal_reporter_dump(struct devlink_health_r=
eporter *reporter,
>  	return err;
>  }
> =20
> -static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
> +static void mlx5_fw_fatal_reporter_err(struct mlx5_core_dev *dev, bool f=
orced)
>  {
>  	struct mlx5_fw_reporter_ctx fw_reporter_ctx;
> -	struct mlx5_core_health *health;
> -	struct mlx5_core_dev *dev;
> -	struct devlink *devlink;
> -	struct mlx5_priv *priv;
> -
> -	health =3D container_of(work, struct mlx5_core_health, fatal_report_wor=
k);
> -	priv =3D container_of(health, struct mlx5_priv, health);
> -	dev =3D container_of(priv, struct mlx5_core_dev, priv);
> -	devlink =3D priv_to_devlink(dev);
> +	struct mlx5_core_health *health =3D &dev->priv.health;
> +	struct devlink *devlink =3D priv_to_devlink(dev);
> =20
>  	mutex_lock(&dev->intf_state_mutex);
>  	if (test_bit(MLX5_DROP_HEALTH_WORK, &health->flags)) {
> @@ -646,8 +639,39 @@ static void mlx5_fw_fatal_reporter_err_work(struct w=
ork_struct *work)
>  		mutex_unlock(&dev->intf_state_mutex);
>  		return;
>  	}
> +	if (forced) {
> +		int err;
> +
> +		/*
> +		 * Once the interface is down, the unload already removed the
> +		 * consumers that need the error flow. Once the cmd interface
> +		 * is down, the path that brought it down owns the flush and
> +		 * the recovery.
> +		 */
> +		if (mlx5_cmd_is_down(dev) ||
> +		    !test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
> +			mutex_unlock(&dev->intf_state_mutex);
> +			return;
> +		}
> +		/*
> +		 * The firmware might still be running, so stop it first. Do it
> +		 * under intf_state_mutex, so the cmd interface is valid.
> +		 */
> +		mlx5_stop_health_poll(dev, false);
> +		err =3D mlx5_cmd_fast_teardown_hca(dev);
> +		if (err)
> +			err =3D mlx5_cmd_force_teardown_hca(dev);
> +		if (err)
> +			mlx5_core_err(dev, "Failed to stop the device before forcing the erro=
r state, err %d\n",
> +				      err);
> +	}

[Severity: Medium]
Can a force_fatal_report_work queued while recovery is already running on
health->wq tear down and unload the device right after it recovers?

Recovery runs synchronously on the single-threaded health->wq via
devlink_health_report() -> ... -> mlx5_recover_device() ->
mlx5_load_one_devl_locked(), which brings the command interface and
MLX5_INTERFACE_STATE_UP back up before the first work item finishes.
Consumers remain attached until mlx5_detach_device() runs during the
unload phase of recovery (for example while crdump collection or software
reset is in progress), and neither mlx5_unload_one_devl_locked() nor
mlx5_load_one_devl_locked() cancels a pending force_fatal_report_work:

health->wq                        consumer
mlx5_fw_fatal_reporter_err()
  enter_error_state(dev, ...)
                                  mlx5_trigger_health_work_force(dev)
                                    queue_work(..., &force_fatal_report_wor=
k)
  devlink_health_report(...)
    ...
      mlx5_recover_device(dev)
        mlx5_load_one_devl_locked(dev, true)
          /* cmd and interface are back UP */
mlx5_fw_fatal_reporter_force_err_work()
  mlx5_fw_fatal_reporter_err(dev, true)
    /* mlx5_cmd_is_down() is false and
     * MLX5_INTERFACE_STATE_UP is set */
    mlx5_cmd_fast_teardown_hca(dev)
    enter_error_state(dev, true)
    devlink_health_report(...) -> -ECANCELED
    mlx5_unload_one(dev, false)   <-- unloads recovered device

Because fw_fatal_reporter is still within its graceful period from the
recovery that just completed, devlink_health_report() returns -ECANCELED
and mlx5_fw_fatal_reporter_err() unloads the freshly recovered driver.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110134320.3440=
8-1-yishaih@nvidia.com?part=3D1
