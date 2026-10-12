Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A769347CA88
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 09:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791798663; cv=none; b=BRKCdxjMSyzeOwoypbPrz4w54mHMPzwnrdCN0EgMgCE8XdVLYs6wwLDvVMIVF3eHf9unGjy6v+TOrSIJtXIKOzWuX1QOb9veIHbSc/H1VgD63eT8C6yhMbP4yy+aq+Wyp2Rc5knrYYmtrF8zBhqOkAVt/DJvoZWKGFLddLJ7rDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791798663; c=relaxed/simple;
	bh=jzQlPVoNzHF/gOHw0nE4aPZE2MtyJgID/cfZBIlmkFQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Ah4BDXMuJ6lirqWSMUk1jQzJzKtbnmqIu8hfkOkr7pWSDthnBj9SQ1XDKmrDs0zGzGPPp4/Q3ic58GWZ4CkY9GEgW4ZI1m/jqSmHWyfoHg/Aw8I1ZB3nTu5LQmhb+7LwT7w+lSrazt96dsmyt+9jhezZsTqhMCB5JUkgSfnZLX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DsF2C5Ka; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DsF2C5Ka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA6C1F0089C;
	Mon, 12 Oct 2026 09:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791798655;
	bh=tmfqJZyCbxgP+6ltsQ9fShwL9XXd43C5GUYTZ+Go+GA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DsF2C5KaJGRrjNmWqWEgIIOoB6XXj2czCdiYy+oYCoJ56os1uXi60H7QSIEEgjViB
	 vzyoFxuoSLXkkfQ8FlwfSfkFdGcEx/pB6VAxw+nOsWxJBRCDeB9AHZDJUiTXr4rrxm
	 rxseyGRPKnNQgZo34P6hrE+hD+24QQGdY5/EhijKCvm4thA8qR5QcnsYY2oRyebvWX
	 1VfYbtohKiBivVJZ4iqC43igjWT/mPS2ZEZmROJtCTDf9aQDO6QPvLgdZWh32a41Ti
	 k5HeS2Q8K2h7yqANBbV8x+EeHBJ4W7TNMnU+OuIuHLXOFcXqTLksYs9uaAOD7BiFq1
	 Z+jJ/+EagsExQ==
Message-ID: <sashiko-outbox-167908@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next] net/mlx5: Add reset_prepare and reset_done
 callbacks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261011094809.790798-1-tariqt@nvidia.com>
References: <20261011094809.790798-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 09:50:55 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] net/mlx5: concurrent external PCI reset skips driver teardown
--

commit c754f5586b2dc54ce6e7b9bf66e23475b9b184d4
Author: Akiva Goldberger <agoldberger@nvidia.com>

net/mlx5: Add reset_prepare and reset_done callbacks

This commit adds reset_prepare and reset_done callbacks for the mlx5 driver
to quiesce and restore resources around a PCI reset. It also adds a flag to
serialize PCI resets with other flows like FW reset.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net=
/ethernet/mellanox/mlx5/core/main.c
> index 1a45474ce03db..fe7c0331b183b 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> @@ -2138,10 +2138,97 @@ static void mlx5_pci_resume(struct pci_dev *pdev)
[ ... ]
> +static void mlx5_pci_reset_prepare(struct pci_dev *pdev)
> +{
> +	struct mlx5_core_dev *dev =3D pci_get_drvdata(pdev);
> +	struct devlink *devlink;
> +	bool fw_reset_in_prog;
> +
> +	if (!dev)
> +		return;
> +
> +	devlink =3D priv_to_devlink(dev);
> +
> +	devl_lock(devlink);
> +	fw_reset_in_prog =3D mlx5_fw_reset_in_progress(dev);
> +	if (!fw_reset_in_prog)
> +		dev->pci_reset_in_progress =3D true;
> +	devl_unlock(devlink);
> +
> +	if (fw_reset_in_prog) {
> +		mlx5_core_info(dev,
> +			       "%s: fw reset in progress, leaving drain to fw_reset flow\n",
> +			       __func__);
> +		return;
> +	}

[Severity: High]
Does this early return assume the caller is the FW reset flow?

If mlx5_sync_reset_request_event() sets MLX5_FW_RESET_FLAGS_RESET_IN_PROGRE=
SS
while waiting for the FW to send a tear-down event, and a concurrent extern=
al
PCI reset (e.g., via sysfs) invokes pci_reset_function() during this window,
it will call mlx5_pci_reset_prepare().

Since fw_reset_in_prog would be true, it returns immediately, skipping
mlx5_unload_one().

Can this cause the PCI core to perform a physical reset on the device
while the driver is fully active, allowing active DMA queues to access wiped
hardware and potentially leading to crashes or hardware errors?

> +
> +	mlx5_core_info(dev, "%s: resetting, device state =3D %d, pci_status =3D=
 %d, intf_state =3D 0x%lx\n",
> +		       __func__, dev->state, dev->pci_status, dev->intf_state);
> +
> +	mlx5_enter_error_state(dev, true);
> +	mlx5_drain_health_wq(dev);
> +	mlx5_unload_one(dev, false);
> +	mlx5_pci_disable_device(dev);
> +}
> +
> +static void mlx5_pci_reset_done(struct pci_dev *pdev)
> +{
> +	struct mlx5_core_dev *dev =3D pci_get_drvdata(pdev);
> +	struct devlink *devlink;
> +	int err;
> +
> +	if (!dev)
> +		return;
> +
> +	devlink =3D priv_to_devlink(dev);
> +
> +	if (!dev->pci_reset_in_progress) {
> +		mlx5_core_info(dev,
> +			       "%s: reset owned by fw_reset flow, leaving reload to it\n",
> +			       __func__);
> +		return;
> +	}

[Severity: High]
Will this early return prevent the driver from reloading after the external
sysfs reset mentioned above?

It seems this could leave the software state permanently out-of-sync with t=
he
reset hardware.

> +
> +	err =3D mlx5_pci_enable_device(dev);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261011094809.7907=
98-1-tariqt@nvidia.com?part=3D1
