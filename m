Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810622;
	b=aB8VANnnaOpcn25vtqWY/2gBB7m3T6lTbcUNDjbLTSTb3ndVUPjaQtNZVQaKGr+hjOJo
	 QKB6hf9CKzTglc0I7Rpi5EEMAgLPyFIR8d+crROrIK/CnybGwkuPk3DJbPL6yNUzGmAzL
	 T1jFy4R/tEMkMWM5i44gki4suiCV5didoPzW0M4C985bRMws0FjxJnRdeFinG1dBEhdD3
	 QsAhRBYwE0czUoJfS2WQ2q83x5zCn7yVl85aFcrx3+JurrBU0tQG12+1ZJlMDSqVpdD23
	 NHNg5jv+FkunqLlfxQ4aatggrReWn4kyvCeKSGVK9ZXOOgB7/EjfT5zqLluGiVh6R7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810622;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=gcmiqjZejsoRNuRu1TGwciuFZefNzWX5xuNMEttCbM4=;
	b=FMRgoVjbWGM8iryNX4gxvL3tYzRVv7DMt2YTplSCWeHLtYfrB41ypI0KCd7SX4wjg7/Q
	 6BiOZJtfn/TLK23LMcBVVesfFrVJdCOOwe75UfTaLDaN8fT4DFnUQ8Wmza+53iDN0DpOq
	 ZwJzpq53UxtMaBRF5KcAguQ2pH6NfrD7l/U3u8Ngqb8Mtuu7TBhlkwLLc/B6zz46SOD3u
	 iw94gWcognyWdp6LKeQcRQR7IV4HjWWbTMmIYkVSx/OhV0SUJxcgZ4M3pytJlopq2X7+f
	 eqFkkcWc6PXjN1uzMD4BZnIOG6TXaCriSZ0Sw6QsT/ZzjCVqGLDIGmxM4EXYXq+TBng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PCq7XbBp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EB6606A31B
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 16:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PCq7XbBp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4441F000C1;
	Wed,  4 Nov 2026 16:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810621;
	bh=gcmiqjZejsoRNuRu1TGwciuFZefNzWX5xuNMEttCbM4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PCq7XbBpFax4usVjzEVp0DAYzsRhFJr+c0jAZE6dyfmJTO1mFIk3lfGi8ifDjycoQ
	 zkhCCzt/2wn7xVguAg9ExRH90uRf0fER9Mp2dq6qFUwXyO6U4/9K1JTKN2igMyyxLJ
	 bsoTqS12Lov2ST/pCvA3emKs8jlD2BPFyH040RN2RnJyX4DXK5buksTlyb7PKFOgsu
	 7/i2hIz4EORVNipCSyxZYxcWRseSbD2N/C5I4FJ3Wj99aPtiAWo+I5roFEOXOesF1v
	 AlJUEqMrdOC392rzXtQ0OUDIvBawqbILdUGkPsSlSYN6h4awTYml2A9/vb1G9BVxpE
	 vOsxzioO/CYpg==
Message-ID: <sashiko-outbox-197654@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 01/23] net/mlx5: Add
 mlx5_trigger_health_work_force()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103163949.1554-2-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-2-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 16:43:40 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] net/mlx5: missing internal error check before mlx5_cmd_fast_teardo=
wn_hca()
- [High] net/mlx5: forced health work recovers device when interface is alr=
eady down
--

commit 2777ddd787832a64204ac170752c47964f6bf998
Author: Yishai Hadas <yishaih@nvidia.com>

net/mlx5: Add mlx5_trigger_health_work_force()

This commit adds mlx5_trigger_health_work_force() to queue a dedicated work
item that stops the health poller, runs fast HCA teardown, and forces the
device into MLX5_DEVICE_STATE_INTERNAL_ERROR before running health recovery,
even when the fatal health sensors report no error.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/health.c
> index aeeb136f5ebc7..d000ac335fa7a 100644
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
> @@ -646,8 +639,26 @@ static void mlx5_fw_fatal_reporter_err_work(struct w=
ork_struct *work)
>  		mutex_unlock(&dev->intf_state_mutex);
>  		return;
>  	}
> +	/*
> +	 * The firmware might still be running, so stop it first. Do it under
> +	 * intf_state_mutex and only while UP, so the cmd interface is valid.
> +	 */
> +	if (forced && test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
> +		int err;
> +
> +		mlx5_stop_health_poll(dev, false);
> +		err =3D mlx5_cmd_fast_teardown_hca(dev);
> +		if (err)
> +			mlx5_core_err(dev, "Failed to stop the device before forcing the erro=
r state, err %d\n",
> +				      err);
> +	}

[Severity: High]
Should mlx5_fw_fatal_reporter_err() also verify that dev->state is not
already MLX5_DEVICE_STATE_INTERNAL_ERROR before calling
mlx5_cmd_fast_teardown_hca(dev), similar to mlx5_try_fast_unload()?

drivers/net/ethernet/mellanox/mlx5/core/main.c:mlx5_try_fast_unload() {
    ...
	if (dev->state =3D=3D MLX5_DEVICE_STATE_INTERNAL_ERROR) {
		mlx5_core_dbg(dev, "Device in internal error state, giving up\n");
		return -EAGAIN;
	}
    ...
}

MLX5_INTERFACE_STATE_UP remains set when poll_health() or
mlx5_enter_error_state() transitions dev->state to
MLX5_DEVICE_STATE_INTERNAL_ERROR. When dev->state is already
MLX5_DEVICE_STATE_INTERNAL_ERROR, mlx5_cmd_is_down(dev) is true, so
mlx5_cmd_exec_inout() -> cmd_exec() aborts MLX5_CMD_OP_TEARDOWN_HCA with
-ENXIO without sending it to firmware, and mlx5_cmd_check() ->
mlx5_internal_err_ret_value() emulates MLX5_CMD_STAT_OK (0) with a zeroed
output buffer.

In mlx5_cmd_fast_teardown_hca(), this emulated success causes the driver to
write MLX5_INITIAL_SEG_NIC_INTERFACE_DISABLED to MMIO via
mlx5_set_nic_state() without firmware preparation and busy-wait in a loop
until the teardown timeout expires while holding dev->intf_state_mutex:

drivers/net/ethernet/mellanox/mlx5/core/fw.c:mlx5_cmd_fast_teardown_hca() {
    ...
	ret =3D mlx5_cmd_exec_inout(dev, teardown_hca, in, out);
	if (ret)
		return ret;

	state =3D MLX5_GET(teardown_hca_out, out, state);
	if (state =3D=3D MLX5_TEARDOWN_HCA_OUT_FORCE_STATE_FAIL) {
		mlx5_core_warn(dev, "teardown with fast mode failed\n");
		return -EIO;
	}

	mlx5_set_nic_state(dev, MLX5_INITIAL_SEG_NIC_INTERFACE_DISABLED);
    ...
}

In addition, because mlx5_health_check_fatal_sensors() checks for
MLX5_INITIAL_SEG_NIC_INTERFACE_DISABLED before sensor_fw_synd_rfr(dev),
overwriting the NIC state register masks MLX5_SENSOR_FW_SYND_RFR and
prevents mlx5_error_sw_reset() -> reset_fw_if_needed() from performing a
firmware SW reset.

> +
> +	/*
> +	 * Enter the error state before unlocking, or an unload could send
> +	 * TEARDOWN_HCA to the stopped NIC, fail and skip function disable.
> +	 */
> +	enter_error_state(dev, forced);
>  	mutex_unlock(&dev->intf_state_mutex);

[Severity: High]
What happens in mlx5_fw_fatal_reporter_err() when forced is true, but
MLX5_INTERFACE_STATE_UP is already cleared?

During a non-remove unload such as mlx5_suspend(), mlx5_devlink_reload_down=
(),
or mlx5_pci_err_detected(), mlx5_unload_one_devl_locked() clears
MLX5_INTERFACE_STATE_UP and calls mlx5_function_teardown(dev, false) ->
mlx5_function_disable(dev, false) -> mlx5_stop_health_poll(dev, false),
which stops the timer without setting MLX5_DROP_HEALTH_WORK:

drivers/net/ethernet/mellanox/mlx5/core/main.c:mlx5_unload_one_devl_locked(=
) {
    ...
	clear_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
	mlx5_unload(dev);
	mlx5_function_teardown(dev, false);
out:
	mutex_unlock(&dev->intf_state_mutex);
}

If mlx5_trigger_health_work_force() was queued just before the unload compl=
eted,
mlx5_fw_fatal_reporter_err(dev, true) sees MLX5_DROP_HEALTH_WORK =3D=3D 0 a=
nd
MLX5_INTERFACE_STATE_UP =3D=3D 0. It skips mlx5_cmd_fast_teardown_hca(), bu=
t still
calls enter_error_state(dev, true) and proceeds to devlink_health_report() /
mlx5_health_try_recover(), which will reset and reload a device that was
just suspended or unloaded (or tear down a device that just finished
devlink reload).

Should mlx5_fw_fatal_reporter_err() unlock dev->intf_state_mutex and return
early if !test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state) when forced
is true?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103163949.1554=
-1-yishaih@nvidia.com?part=3D1
