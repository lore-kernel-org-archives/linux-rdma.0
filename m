Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536B1400963;
	Mon, 12 Oct 2026 10:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791802003; cv=none; b=IBM44G3nMDD8wWj1EnxE9D/05KxnUQEfEClu4EqCcBoh/MtZit4pIyXIliPkjtwT2es5FmBSZ8Qq0p7Ntbi1hGUcrRP+hFYUMTN+tAbavJ1VUrpcNiC6eQcSIcwX13zxkJ+OKgnSdxCsCTR6fAI3g3taDH+AcmAjSG9Fp45WYyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791802003; c=relaxed/simple;
	bh=4NL+mB+RX/nrfT90myn8aGSNWvZIL2UvX273dsrjMKw=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=W4KQFxU+oJAqEyS4n7DtDbBfjt31OiVMz3hve3zOASiLlbidTHcTyi5MHW4B4vE1yrA1it6gGAvqdVOt4GzaR7fB+iKdX+ic/RtGcqfNb2T6XqiY8FEkBeiYq126Oxy9kua9RDXB4dtikYImsHpBW1BvT9tXvvByCI/uCZlTdtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lbFyzVuf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lbFyzVuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B0A1F0089B;
	Mon, 12 Oct 2026 10:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791802001;
	bh=d5re0EvHAIZUDyjXiVwEAkGMunPdjYyERnAW/tgATpw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=lbFyzVufCRL/q0IQ/gSsgeRuzRg35R6t5ELp6qsuVGnJGE8jRCge7f4XECa8dkG21
	 +Ep3j3N4hVuVNoLqHieZPxKolyXepj2Dfbr/IlI7Ro1za5jnc6d8zD0oFQUNROTgfo
	 lRQLSM/Pc2tfMEqXIvFA3edZw87mC/vBljZHhD4uhCmN+ImtquMEzzinVD3p1MCmTR
	 Hu2msB85BTV/IfmoHb0fUPqJaplXZkwfxn4qlSBkCsZv3b+r3wHMndCgqfLhhI58Yh
	 UYQPfirZhqM2QfiNGyaG2paacwKVA2pxvnPk4XNr6FHJ/maOuCRzORfha21e0pcyjK
	 igsTYhDkZkPpg==
Subject:
 Re: [PATCH net-next] net/mlx5: Add reset_prepare and reset_done callbacks
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 agoldberger@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 moshe@nvidia.com, saeedm@nvidia.com
Date: Mon, 12 Oct 2026 10:46:40 +0000
Message-ID: <179180200063.434549.10327994167294532133@kernel.org>
In-Reply-To: <20261011094809.790798-1-tariqt@nvidia.com>
References: <20261011094809.790798-1-tariqt@nvidia.com>
X-sashiko-severity: Critical
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 1 · High: 0 · Medium: 2 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Critical] mlx5_pci_reset_prepare() calls mlx5_enter_error_state(dev,
  true) on a healthy HCA that is still bus-mastering, then runs…
- [Medium] mlx5_pci_reset_prepare() decides a PCI reset belongs to the FW
  reset flow only because mlx5_fw_reset_in_progress() is true.
- [Medium] dev->pci_reset_in_progress is consulted only by
  mlx5_sync_reset_request_event().

--

net/mlx5: Add reset_prepare and reset_done callbacks

This commit adds reset_prepare and reset_done PCI error handlers to
mlx5_core so the driver can unload before a PCI reset and reload after it.
It also adds a pci_reset_in_progress device flag. The flag is meant to
serialize PCI reset with FW reset, and to skip the unload/reload when the
reset is owned by the FW reset hot-reset flow.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
> index 7c0585fe1ee7..2ba2f6dac263 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
> @@ -501,6 +501,13 @@ static void mlx5_sync_reset_request_event(struct work_struct *work)
>  		return;
>  	}
>  
> +	if (dev->pci_reset_in_progress) {
> +		err = mlx5_fw_reset_set_reset_sync_nack(dev);
> +		mlx5_core_warn(dev, "PCI reset in progress, Sync FW Update Reset Nack %s",
> +			       err ? "Failed" : "Sent");
> +		goto unlock;
> +	}

[Severity: Medium]
This is the only place outside the new callbacks that checks
dev->pci_reset_in_progress. Should other paths that already refuse to run
during a FW reset check it too?

For example, mlx5_devlink_eswitch_mode_set() only checks
mlx5_fw_reset_in_progress():

	if (mlx5_fw_reset_in_progress(esw->dev)) {
		NL_SET_ERR_MSG_MOD(extack, "Can't change eswitch mode during firmware reset");
		return -EBUSY;
	}

DEVLINK_CMD_ESWITCH_SET uses devlink_nl_pre_doit, which takes devl_lock
but not device_lock. mlx5_pci_reset_prepare() drops devl_lock after it sets
the flag. So an eswitch mode change can run between reset_prepare and
reset_done, while:

  - the device is unloaded
  - dev->state is MLX5_DEVICE_STATE_INTERNAL_ERROR
  - esw->mode has been cleared by mlx5_eswitch_disable()

The handler would then update MLX5_PRIV_FLAGS_SWITCH_LEGACY and call
esw_offloads_start()/mlx5_eswitch_enable_locked() on a device whose
commands all fail with -ENXIO or return faked results.

Could this leave the eswitch state different from what the user asked for
once reset_done reloads the driver?

Devlink reload looks safe. DEVLINK_CMD_RELOAD uses
devlink_nl_pre_doit_dev_lock, which takes device_lock(&pdev->dev). That is
the same lock held across reset_prepare and reset_done.

> +
>  	if (mlx5_sync_reset_set_reset_requested(dev))
>  		goto unlock;
>  
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> index 1a45474ce03d..fe7c0331b183 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> @@ -2138,10 +2138,97 @@ static void mlx5_pci_resume(struct pci_dev *pdev)
>  		       !err ? "recovered" : "Failed");
>  }
>  
> +static void mlx5_pci_reset_prepare(struct pci_dev *pdev)
> +{
> +	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
> +	struct devlink *devlink;
> +	bool fw_reset_in_prog;
> +
> +	if (!dev)
> +		return;
> +
> +	devlink = priv_to_devlink(dev);
> +
> +	devl_lock(devlink);
> +	fw_reset_in_prog = mlx5_fw_reset_in_progress(dev);
> +	if (!fw_reset_in_prog)
> +		dev->pci_reset_in_progress = true;
> +	devl_unlock(devlink);
> +
> +	if (fw_reset_in_prog) {
> +		mlx5_core_info(dev,
> +			       "%s: fw reset in progress, leaving drain to fw_reset flow\n",
> +			       __func__);
> +		return;
> +	}

[Severity: Medium]
Can an unrelated PCI reset be mistaken here for one owned by the FW reset
flow?

mlx5_sync_reset_request_event() sets MLX5_FW_RESET_FLAGS_RESET_IN_PROGRESS
when it ACKs the request, before any reset is issued. It is also set for
the link-toggle method, which never calls reset_prepare. The bit stays set
until one of these clears it, which can take up to PCI_SYNC_UPDATE:

  - mlx5_fw_reset_complete_reload()
  - mlx5_sync_reset_abort_event()
  - mlx5_sync_reset_timeout_work()

A sysfs reset, VFIO, or pci_reset_function() can land in that window. Then
mlx5_pci_reset_prepare() returns without unloading, and
mlx5_pci_reset_done() sees pci_reset_in_progress == false and skips the
reload. The function is reset under a fully loaded driver.

If FW then aborts or the sync times out, the bit is cleared and nothing
reloads the driver:

mlx5_sync_reset_abort_event()
    clear_bit(MLX5_FW_RESET_FLAGS_RESET_IN_PROGRESS, &fw_reset->reset_flags);

Only a later health poll detection might recover the device.

mlx5_fw_reset_complete_reload() also has a gap. The device is fully
reloaded and devl_lock is released before the bit is cleared:

		mlx5_load_one(dev, true);
		devl_lock(devlink);
		devlink_remote_reload_actions_performed(...);
		devl_unlock(devlink);
	}

	clear_bit(MLX5_FW_RESET_FLAGS_RESET_IN_PROGRESS, &fw_reset->reset_flags);

A PCI reset in that gap would hit a live device, and both callbacks would
skip it.

The commit message says the flag is there "to serialize PCI reset flows
with other reset flows, namely FW reset". Would it be more reliable to tie
the ownership check to the FW reset actually issuing the reset? For
example, a marker could be set around pci_reset_bus() in
mlx5_pci_reset_bus().

> +
> +	mlx5_core_info(dev, "%s: resetting, device state = %d, pci_status = %d, intf_state = 0x%lx\n",
> +		       __func__, dev->state, dev->pci_status, dev->intf_state);
> +
> +	mlx5_enter_error_state(dev, true);
> +	mlx5_drain_health_wq(dev);
> +	mlx5_unload_one(dev, false);
> +	mlx5_pci_disable_device(dev);

[Severity: Critical]
Can the HCA still DMA into memory that mlx5_unload_one() frees here?

On a healthy device, mlx5_enter_error_state(dev, true) only changes
software state. Nothing tells the firmware to stop.

Once dev->state is MLX5_DEVICE_STATE_INTERNAL_ERROR, mlx5_cmd_is_down() is
true and cmd_exec() returns -ENXIO without reaching firmware.
mlx5_internal_err_ret_value() then reports success for TEARDOWN_HCA,
DISABLE_HCA, MANAGE_PAGES and the DESTROY_EQ/CQ/QP/SQ/RQ/MKEY commands.

So mlx5_unload_one() frees and unmaps the EQ, CQ, SQ and RQ rings and the
RX buffers. mlx5_reclaim_startup_pages()->reclaim_pages_cmd() also takes
the forced reclaim path:

drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c:reclaim_pages_cmd() {
    ...
	/* If FW is gone (-ENXIO), proceed to forceful reclaim */
	if (err != -ENXIO)
		return err;

	/* No hard feelings, we want our pages back! */
    ...
}

That frees the firmware ICM pages while the firmware is still running.

Bus Master is cleared only afterwards, by mlx5_pci_disable_device().
pci_dev_save_and_disable() writes PCI_COMMAND only after reset_prepare
returns. During the whole unload, can the device keep writing received
packets, CQEs/EQEs and ICM updates into pages that are back in the page
allocator?

Other paths that force error state stop the hardware first. For example,
mlx5_try_fast_unload():

	ret = mlx5_cmd_fast_teardown_hca(dev);
	...
succeed:
	mlx5_enter_error_state(dev, true);

mlx5_pci_err_detected() instead uses force=false together with
mlx5_error_sw_reset(), and runs with the link already frozen.

Should mlx5_pci_reset_prepare() do a fast or force teardown, or otherwise
quiesce DMA, before forcing error state?

Before this patch there was no reset_prepare. The PCI core cleared Bus
Master and reset the device while driver memory was still allocated, so
this window looks new. It can be reached through
/sys/bus/pci/devices/<BDF>/reset, VFIO, or pci_reset_function() on a bound,
healthy function.

> +}
> +
> +static void mlx5_pci_reset_done(struct pci_dev *pdev)
> +{
> +	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
> +	struct devlink *devlink;
> +	int err;
> +
> +	if (!dev)
> +		return;
> +
> +	devlink = priv_to_devlink(dev);
> +
> +	if (!dev->pci_reset_in_progress) {
> +		mlx5_core_info(dev,
> +			       "%s: reset owned by fw_reset flow, leaving reload to it\n",
> +			       __func__);
> +		return;
> +	}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261011094809.790798-1-tariqt%40nvidia.com
