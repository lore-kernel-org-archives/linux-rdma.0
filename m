Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793046732;
	b=32Rm+ptXLaMPzwcFH6PLPxi7CSAFYsNXv/6U+Ieolt1D2Mj+q4gSwX2CNpavNPEqtPgP
	 j4AU+hWnF6Js1MiaOMWlI5ljFwGEDsGSZVniG/necIDzM/OR0xRaA8Zoli/1SCD4DvI3y
	 hStrIKIyswG61ZPOBF5QTWqYctUhzyR1I8T7LcC/Ex3GG0LfOy9pAERtpGFSkP6KqzpWg
	 HU53i2kSs6uSharoIkivTAvUeEAmZkQ4WWidsdhv7ZXDkSFQJ5OI06bTyJ97raAX2htS+
	 6w88zC62UWBH3aMpaeS2jf0jHga1K/qyQEuG1pH5Kj0FFj7c6c2+swZBvPIHUQImw2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793046732;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=x85SkJHkrTtOkmIsAB3pzSmboG3EvzzSJhuAm6ganBs=;
	b=Va6Jej6SXbGXaMkWRY+uYSqFX82YFIB99qVYtQXwCcjqywMDCnM5nkqlaJhS59qb9UVX
	 B5VnRiZApFRIsxkdjN1n5tzIj7YQjcxRG+BIxuUmUXIgVd48vlhvcDnXy/cOR0o7OFUt4
	 07+jYcSH84x+v3Ka6JHU0tjW+uKlfPOgAp0Qn6RuU1CwX6RgKRmQVxy2EUqG3neE062jS
	 jRvE/WOagIHu6y+O2qa4tiMyabuWhWmvV5yTWAkE2a5SKB77+s3l5S5y9HJ+bo+i2SWRa
	 uacym3tNvhwX6GEE4TNrqPfeOs/8Ll4qdPH5AnAoaStUVR6j33WLKQjo8JK2RczFRPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="brqzO2/I";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1F3606A31B;
	Mon, 26 Oct 2026 20:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=brqzO2/I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325671F01828;
	Mon, 26 Oct 2026 20:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793046731;
	bh=x85SkJHkrTtOkmIsAB3pzSmboG3EvzzSJhuAm6ganBs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=brqzO2/IqbZHPnb17BNm9HrDIE4pxBfGB+PdvrA1sF63Au7PZpyK5QwVkPHKzIQOx
	 TVSk77mS+zLdpyslLjlaUiKM0DB3ZIhkoq2hD09+0XOUI1oJBOYWHsO3Vp6eMuUX90
	 Dh5WIkshlht/yxuwHGpuoUC6nYCB1rqCnfh4W8HWaBg9/aE+KoEnlC8ZEc1+T881CI
	 qeN1gMXkHZ+xl+0fDdg8wFXwKDjo5Ee7AFcU49lmeK/9yGXAICW3pmYOV21GTkSPnv
	 PVMisBhV6fqAFgrglV+TaAXOvPZDOn1OquL66oYqWSTt8bZr4DV12oBEOvUbaHrmST
	 TzrYPr8lhtHDw==
Subject: Re: [PATCH net V2 2/4] net/mlx5: Lag, limit aggregated TX speed by
 PCIe bandwidth
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 bhelgaas@google.com, cjubran@nvidia.com, cratiu@nvidia.com,
 edwards@nvidia.com, gal@nvidia.com, jgg@ziepe.ca, kees@kernel.org,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
 linux-rdma@vger.kernel.org, msanalla@nvidia.com, mbloch@nvidia.com,
 ohartoov@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com
Date: Mon, 26 Oct 2026 20:32:09 +0000
Message-ID: <179304672970.3134.8594452655497704375@kernel.org>
In-Reply-To: <20261022193053.3815866-3-tariqt@nvidia.com>
References: <20261022193053.3815866-3-tariqt@nvidia.com>
X-sashiko-severity: Medium
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

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] mlx5_lag_dev_pcie_bw()
  (drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c) skips the PCIe…
- [Low] This mlx5 'Fixes:' patch adds a new exported PCI core API,
  pcie_bandwidth_mbps() in drivers/pci/pci.c, declared in…
- [Low] Concern: at this commit, mlx5_lag_reset_vports_speed() (lag.c),
  called from mlx5_do_bond() when LAG is disabled, still writes each…

--

net/mlx5: Lag, limit aggregated TX speed by PCIe bandwidth

This patch clamps the aggregated LAG TX speed, and the max speed sent to
vports, by the PCIe bandwidth of the ports that contribute to it. In
Socket Direct groups, the bandwidth of each mdev is summed per port. It
also adds a new PCI core helper, pcie_bandwidth_mbps(). If the PCIe
bandwidth cannot be read, the speed calculation now fails, except for RC
integrated endpoints.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> index 57755ceab8a75..05e6d0aa31fcf 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> @@ -1432,10 +1432,55 @@ static bool mlx5_lag_should_disable_lag(struct mlx5_lag *ldev, bool do_bond)
>  	       ldev->mode != MLX5_LAG_MODE_MPESW;
>  }
>  
> +static int mlx5_lag_dev_pcie_bw(struct mlx5_core_dev *dev, u32 *bw)
> +{
> +	if (pci_pcie_type(dev->pdev) == PCI_EXP_TYPE_RC_END) {
> +		*bw = U32_MAX;
> +		return 0;
> +	}
> +
> +	*bw = pcie_bandwidth_mbps(dev->pdev);
> +	return *bw ? 0 : -EIO;
> +}

[Severity: Medium]

PCI_EXP_TYPE_RC_END is the only case exempted here. What happens for a
bonded PF where pci_is_pcie() is false? One example is a VFIO-assigned
PF on a conventional PCI segment of a q35 guest, where the Express
capability is hidden.

In that case pcie_capability_reg_implemented() returns false, so the
LNKSTA read reports success and leaves the value at 0:

drivers/pci/access.c:pcie_capability_read_word() {
	*val = 0;
    ...
	if (pcie_capability_reg_implemented(dev, pos)) {
    ...
	}
    ...
	return 0;
}

CLS 0 maps to PCI_SPEED_UNKNOWN, so pcie_dev_speed_mbps() returns
-EINVAL and pcie_bandwidth_mbps() returns 0. Since pcie_flags_reg is 0,
pci_pcie_type() reports PCI_EXP_TYPE_ENDPOINT. The RC_END check does not
match, and this function returns -EIO. The same thing happens for any CLS
value from 7 to 0xF, which pcie_link_speed[] maps to PCI_SPEED_UNKNOWN.

If so, wouldn't mlx5_lag_get_devices_oper_speed() and
mlx5_lag_get_devices_max_speed() fail on every call?

mlx5_do_bond()
  mlx5_lag_set_vports_agg_speed()
    mlx5_lag_update_agg_speed()
      mlx5_lag_get_devices_oper_speed()
        mlx5_lag_port_pcie_bw()
          mlx5_lag_dev_pcie_bw()   <- -EIO

mlx5_lag_update_agg_speed() then stores SPEED_UNKNOWN:

	err = mlx5_lag_get_devices_oper_speed(ldev, &speed);
	if (err) {
		WRITE_ONCE(ldev->agg_speed_mbps, SPEED_UNKNOWN);
		return err;
	}

Because of this, mlx5_lag_set_vports_agg_speed() returns early and never
propagates vport max_tx_speed. mlx5_lag_query_aggregated_speed() also
returns -ENODATA to mlx5_ib_query_port_speed_from_bond(), both for RoCE
LAG and for the SR-IOV LAG uplink rep. Before this patch these paths
returned a valid speed.

The commit message says:

  A device that has no Link Status register, an RC integrated endpoint,
  has no PCIe budget to apply and is not clamped.

pcie_bandwidth_mbps() returns the same 0 whether Link Status is missing,
the read failed, or the CLS encoding is unknown, so callers cannot tell
these cases apart. Should the "not clamped" case cover every device
without an implemented Link Status register, not just RC_END?

The later patch in this series, "net/mlx5: Lag, save and restore vport
max_tx_speed across LAG", treats pcie_bandwidth_mbps() == 0 as "no
clamp" in mlx5_lag_get_restore_speed(). That does not match the -EIO
handling here.

[ ... ]

> @@ -1539,10 +1598,26 @@ static int mlx5_lag_get_devices_max_speed(struct mlx5_lag *ldev, u32 *max_speed)

[ ... ]

> +		if (take_max) {
> +			speed = min(speed, dev_pci_bw);
> +			*max_speed = max(*max_speed, speed);
> +		} else {
> +			pci_bw = min(pci_bw, dev_pci_bw);
> +			*max_speed += speed;
> +		}
>  	}
>  
> +	if (!take_max)
> +		*max_speed = min(*max_speed, pci_bw);
> +
>  	return 0;
>  }

[Severity: Low]

The commit message says FW programs max_tx_speed as the minimum of port
speed and PCIe bandwidth, and that writing a value computed by other
rules changes the meaning of the field. At this commit, the LAG disable
path still writes an unclamped value:

mlx5_do_bond()
  mlx5_lag_should_disable_lag()
  mlx5_lag_reset_vports_speed()

drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:mlx5_lag_reset_vports_speed() {
    ...
		ret = mlx5_port_oper_linkspeed(mdev, &speed);
    ...
		speed = speed / MLX5_MAX_TX_SPEED_UNIT;
		mlx5_lag_modify_device_vports_speed(mdev, speed);
    ...
}

After LAG teardown, can vports end up with a max_tx_speed above the
PCIe link bandwidth?

The last patch in this series, "net/mlx5: Lag, save and restore vport
max_tx_speed across LAG", rewrites mlx5_lag_reset_vports_speed(). It
restores the per-vport value that FW programmed, and its fallback in
mlx5_lag_get_restore_speed() is clamped by pcie_bandwidth_mbps(). So
this only affects the bisection window between this patch and that one.

> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 8cc6a89130b53..064eef237d6f4 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -6006,6 +6006,22 @@ int pcie_link_speed_mbps(struct pci_dev *pdev)
>  }
>  EXPORT_SYMBOL(pcie_link_speed_mbps);
>  
> +u32 pcie_bandwidth_mbps(struct pci_dev *pdev)
> +{
> +	u16 lnksta;
> +	u32 width;
> +	int speed;
> +
> +	if (pcie_capability_read_word(pdev, PCI_EXP_LNKSTA, &lnksta))
> +		return 0;
> +	speed = pcie_dev_speed_mbps(to_pcie_link_speed(lnksta));
> +	if (speed <= 0)
> +		return 0;
> +	width = FIELD_GET(PCI_EXP_LNKSTA_NLW, lnksta);
> +	return speed * width;
> +}
> +EXPORT_SYMBOL_GPL(pcie_bandwidth_mbps);

[Severity: Low]

This isn't a bug, but this mlx5 Fixes: patch adds a new exported PCI core
API with no kernel-doc, and the commit has no Acked-by from the PCI
maintainer.

The name is close to pcie_bandwidth_available(), whose kernel-doc also
says it returns Mb/s, but the two behave differently.
pcie_bandwidth_available() walks upstream bridges and subtracts encoding
overhead:

	next_bw = next_width * PCIE_SPEED2MBS_ENC(next_speed);

pcie_bandwidth_mbps() returns the nominal rate times width for the
endpoint link only. It also returns 0 on any failure, while
pcie_link_speed_mbps() just above returns a negative errno.

Could the nominal, endpoint-only behaviour and the 0-on-error convention
be documented in a kernel-doc comment here, instead of only in the
changelog?

Is EXPORT_SYMBOL_GPL intentional? The neighbouring pcie_link_speed_mbps()
and pcie_bandwidth_available() both use EXPORT_SYMBOL.

The include/linux/pci.h hunk also adds a stray blank line after the new
declaration.

mlx5's en/params.c already compares link speed against
pcie_bandwidth_available(). With this patch the same driver has two
different definitions of the PCIe budget.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261022193053.3815866-1-tariqt%40nvidia.com
