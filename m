Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022021;
	b=gsoQYNmMo0Sheqo2av8PO1Vx4VP3lF9ZtidsNqivg1gp1M3m8ydBnp64jLu6D1HYcCBJ
	 5r4pW35Y0wHzXyCwi3iJn+z/o/DeN/nVY6oF12lcgJp5o2XYP5TiYguJMdW7xUwuw/Ly3
	 Saz14WRdmRa1IPa/IUrA2J9uRJD+OEL+KoxsXEZNGNjE190CVfdUOlwjIEtVqFiUGoGQV
	 J1PDa6PjSRTKMN88fqKSvTeczgd7dCAFZymlNph9Ve98n12Byd5yMZ3uUo6Yakj/jxUVB
	 v4kCCKea6ghkMp9+JXuZUxoHLgW+dwXe6OgjNqPkiz9qmRLj1nd0bkYAPTLDfSqkXyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022021;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=61kZmMnY/FjKE6Ai7uCSidnAa4W9sT/wNd0Bo57aTZs=;
	b=FL1tFXRvvVnlJGxltH054cZbgbPJ4MeJ4ZHy7Dgs9/nktv5YX3NtrfdEBAkuY5cbEUth
	 vlf2Iziunatqud3akQNczxUQHXU3OBPDDPOl/UbRnHBtnmeuPEr88wlKl/BkivjBEnibm
	 kjlu6sWM/+1axsQP5oN7QRkkgUKf/AklLO7UR7zm8anzP7tYF/CjC0pWoGFzEQqONQPiz
	 c3Ex+wsufQyoZ0WjkG+Oe96bGEYuUR4fDeHQvm/9VbXNOuWW77fchKfGIQVhjJgjRYsG8
	 0ZhIUNyv/802J7FYLWZujQQjriCDu87cZ/q+NyDdEP+dlwJ4RsfvQMxt7nzycWFckng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ghAPJHQ+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F79606A330
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 17:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ghAPJHQ+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B3D1F000C7;
	Wed, 18 Nov 2026 17:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795022020;
	bh=61kZmMnY/FjKE6Ai7uCSidnAa4W9sT/wNd0Bo57aTZs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ghAPJHQ+HnZYI5dGz5RwEzxRzD7df7jB4g+EWopbVHqBEpdW2l5qMyF5RnO4Kr2i1
	 pU2WC7/2QUDOXt12lgSXhmb6Dg6YOVBkz0nE1YTZql65hhl3QDQjr/m7xLpMEHRP4w
	 iwuvqE/9lHEK4U3D7vm2SsA9zim0qNBbz+fDAYOwulzmdqgPyaZ0Ei5c8JoRA1GTPT
	 G0W7/MTLPBM9Pl6bduM1Pj+u2x7InvCV8z7TusyBtVZkwbAS2V9oxKxcsyP6bIDCr1
	 EpGG8nqOVwEOBrS03I3CRV/+wZZ3Qswh+NfRRCfdIHALYdI+w3ml3ZmT93Ye2yGOto
	 IzLeRRrqmtZcw==
Message-ID: <sashiko-outbox-221602@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V2 rdma-next 01/21] net/mlx5: Add
 mlx5_trigger_health_work_force()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117170914.27410-2-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-2-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 17:13:40 +0000
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
- [Medium] net/mlx5: uncanceled force_fatal_report_work tears down
  recovered device
--

commit 8880445e0e3559ece304416ceb136dde00d937a0
Author: Yishai Hadas <yishaih@nvidia.com>

net/mlx5: Add mlx5_trigger_health_work_force()

This commit adds mlx5_trigger_health_work_force() to queue a dedicated
health work item that stops the firmware and forces the device into the
internal error state even when the health sensors report no fault.

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
Can a queued force_fatal_report_work run right after an in-progress
recovery completes on health->wq and tear down the newly recovered device?

Because force_fatal_report_work is a separate work_struct on the
single-threaded health->wq and neither mlx5_unload_one_devl_locked() nor
mlx5_function_teardown() cancels it, a forced trigger that races with a
fatal sensor error queues force_fatal_report_work behind fatal_report_work:

CPU0 (health->wq)                 CPU1
poll_health()
  queue_work(fatal_report_work)
                                  mlx5_trigger_health_work_force()
                                    queue_work(force_fatal_report_work)
mlx5_fw_fatal_reporter_err_work()
  devlink_health_report()
    ...
      mlx5_health_try_recover()
        mlx5_unload_one_devl_locked()
        mlx5_recover_device()
          mlx5_load_one_devl_locked()
            /* restores CMDIF_STATE_UP and INTERFACE_STATE_UP */
mlx5_fw_fatal_reporter_force_err_work()
  /* mlx5_cmd_is_down() is false, INTERFACE_STATE_UP is set */
  mlx5_cmd_fast_teardown_hca()    <-- tears down recovered HCA
  enter_error_state(dev, true)
  devlink_health_report()         <-- returns -ECANCELED (grace period)
  mlx5_unload_one(dev, false)

When fatal_report_work finishes, the device is back up, so the
mlx5_cmd_is_down() and MLX5_INTERFACE_STATE_UP checks pass.
force_fatal_report_work then stops the healthy HCA, forces
MLX5_DEVICE_STATE_INTERNAL_ERROR, hits -ECANCELED in
devlink_health_report() because the reporter is still within the
post-recovery graceful period, and unloads the driver.  The same thing
happens if mlx5_trigger_health_work_force() is called during devlink
reload while mlx5_unload_one_devl_locked() is detaching consumers before
mlx5_load_one_devl_locked() brings the interface back up.

Cancelling force_fatal_report_work during teardown (or draining it before
bringing the interface back up) would prevent stale forced work from
acting on the new device instance.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117170914.2741=
0-1-yishaih@nvidia.com?part=3D1
