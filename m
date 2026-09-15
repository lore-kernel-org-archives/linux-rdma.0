Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488A43CF1E7;
	Tue, 15 Sep 2026 01:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789437089; cv=none; b=m4dWndfYVcB17BL7bPgbyf2tPVqq0/hrY7Z34JBPH+MPUnKhp7FAWth9WNJ/2tKHIGZF0Bzpbbw4k40yetNXhqTLRTkB3aZ++KP19zeQpuOSWyyValSZzRHbN3oStRFlK2McXDERgVjCqa6BORWnJ7PNboWt/CNQghJScJJUlNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789437089; c=relaxed/simple;
	bh=mnP3evdne3Vv+zanyYu5fjJ9Y/SY81wP8USKa1XMItA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EHrDug0P96GaKtQBsSD6HUWMlO2P6x8sjcvv0tkvkYhL8iRqdD+uJfbTdwCthTz6iZW0KooWv4iAdl4NJCGzwd34v5ya2xFhv6ChL3tTIo+8wTFmwOXgECpzBqfJydMVex0LMQ9xeHnJdJnuSPMjSKPfG9Nu7UImOjctPhuPcO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mcnFEpv5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mcnFEpv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1491E1F00893;
	Tue, 15 Sep 2026 01:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789437086;
	bh=AQgbCBlbWirjTgFqDqfc+LO8fR5+9UluyEPABYNUWh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mcnFEpv5261c/sPy0QpMv17e2KhZKTGEloS9Wo2mcJBmgbRzn/7D5MB5sbxGq8ly7
	 j+mxEwe9C8gj9hTB9LSkIAp/Zng90s8RZ6ygS+VVU1mRw8vT+pMPGBdjANau5mMk28
	 N2Pe3/7+mXmF+uLdQWlBvXQVDyccNtf7lcLDlGe6PG13fY7AXdiXmUTRF5kqH7thFm
	 o2rK9MW1+JDB/J9YbNAF+tsmsWapsExhpn9DEC5uSc9+daE86z1PGnPbPV2vYtF5Vc
	 i+xqqrIlV/Fy3AG84YuIPH+IumjA7y4P2z/jAIcFvskG8k0Q4oYuJl2NhkCngC6mUS
	 yPQzBzZEeYjNg==
From: Jakub Kicinski <kuba@kernel.org>
To: tariqt@nvidia.com
Cc: Jakub Kicinski <kuba@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	edwards@nvidia.com,
	gal@nvidia.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	msanalla@nvidia.com,
	mbloch@nvidia.com,
	ohartoov@nvidia.com,
	saeedm@nvidia.com,
	shayd@nvidia.com
Subject: Re: [PATCH net 4/5] net/mlx5: Lag, limit aggregated TX speed by PCIe bandwidth
Date: Mon, 14 Sep 2026 18:51:25 -0700
Message-ID: <20260915015125.875497-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910102432.3845360-5-tariqt@nvidia.com>
References: <20260910102432.3845360-5-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
net/mlx5: Lag, limit aggregated TX speed by PCIe bandwidth

This adds a new helper mlx5_pcie_bandwidth() that derives a PCIe bandwidth
from PCI_EXP_LNKSTA, and uses it to clamp each uplink's contribution to the
aggregated LAG TX speed in mlx5_lag_get_devices_oper_speed(),
mlx5_lag_get_devices_max_speed() and mlx5_lag_reset_vports_speed().  A few
questions below about how the bandwidth is computed and where the clamp is
applied.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
> index df2e3ad01819f..81f3dc3b8034f 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c

[ ... ]

> @@ -40,6 +41,25 @@
>  
>  static DEFINE_IDA(mlx5_adev_ida);
>  
> +#define MLX5_PCIE_MIN_SPEED_MBPS	(2500)
> +
> +u32 mlx5_pcie_bandwidth(struct mlx5_core_dev *dev)
> +{
> +	u16 lnksta;
> +	int speed;
> +	u32 width;
> +
> +	if (pcie_capability_read_word(dev->pdev, PCI_EXP_LNKSTA, &lnksta))
> +		return 0;
> +
> +	width = FIELD_GET(PCI_EXP_LNKSTA_NLW, lnksta);
> +	speed = pcie_link_speed_mbps(dev->pdev);
> +	if (speed < MLX5_PCIE_MIN_SPEED_MBPS)
> +		return 0;
> +
> +	return speed * width;
> +}

[Severity: Medium]
Is speed * width the same quantity the PCI core calls PCIe bandwidth?

pcie_link_speed_mbps() returns the raw per-lane transfer rate, while
pcie_bandwidth_available() in drivers/pci/pci.c applies the line encoding
correction and walks upstream taking the minimum:

  drivers/pci/pci.h:
  #define PCIE_SPEED2MBS_ENC(speed) \
	((speed) == PCIE_SPEED_64_0GT ? 64000*1/1 : \
	 (speed) == PCIE_SPEED_32_0GT ? 32000*128/130 : \
	 ...
	 (speed) == PCIE_SPEED_5_0GT  ?  5000*8/10 : \
	 (speed) == PCIE_SPEED_2_5GT  ?  2500*8/10 : \

  drivers/pci/pci.c:pcie_bandwidth_available() {
	...
		next_bw = next_width * PCIE_SPEED2MBS_ENC(next_speed);
		/* Check if current device limits the total bandwidth */
		if (!bw || next_bw <= bw) {
	...
		dev = pci_upstream_bridge(dev);
  }

For a Gen2 x8 link the helper here yields 5000 * 8 = 40000 Mb/s, whereas the
core helper yields 4000 * 8 = 32000 Mb/s.  Does that make
min(speed, pci_bw) a no-op for a 40GbE uplink on a bus that cannot sustain
it?  On Gen3 and later the difference is about 1.5%, which is still larger
than the MLX5_MAX_TX_SPEED_UNIT (100 Mb/s) granularity the value is
programmed at.

The same driver already computes this quantity for the same pdev with the
core helper:

  drivers/net/ethernet/mellanox/mlx5/core/en/params.c:slow_pci_heuristic() {
	...
	pci_bw = pcie_bandwidth_available(mdev->pdev, NULL, NULL, NULL);
	mlx5_core_dbg(mdev, "Max link speed = %d, PCI BW = %d\n", link_speed,
		      pci_bw);
	...
  }

Should mlx5_pcie_bandwidth() use pcie_bandwidth_available() as well, so the
driver does not carry two different definitions of PCI bandwidth for one
device?

[Severity: Low]
Can the width and speed here come from two different link states?  The width
is taken from the local snapshot in lnksta, but the speed comes from a second
independent read of the very same register:

  drivers/pci/pci.c:pcie_link_speed_mbps() {
	err = pcie_capability_read_word(pdev, PCI_EXP_LNKSTA, &lnksta);
	if (err)
		return err;

	return pcie_dev_speed_mbps(to_pcie_link_speed(lnksta));
  }

PCI_EXP_LNKSTA_NLW and PCI_EXP_LNKSTA_CLS both live in the word already held
in lnksta, and the callers hold only ldev->lock, which does not serialise
link retraining, autonomous width/speed changes, bandwidth control speed
changes or a function reset during health recovery.  If the link changes
between the two reads, speed * width is a bandwidth the link never had.
Would deriving the speed from the existing snapshot with
pcie_dev_speed_mbps(to_pcie_link_speed(lnksta)) be both cheaper and
consistent?

> +
>  static bool is_eth_rep_supported(struct mlx5_core_dev *dev)
>  {
>  	if (!IS_ENABLED(CONFIG_MLX5_ESWITCH))
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> index 76b574fa0d7a6..fd91becd6848f 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c

[ ... ]

> @@ -1452,6 +1453,9 @@ static int mlx5_lag_get_devices_oper_speed(struct mlx5_lag *ldev,
>  			return ret;
>  		}
>  
> +		pci_bw = mlx5_pcie_bandwidth(pf_mdev);
> +		if (pci_bw)
> +			speed = min(speed, pci_bw);
>  		*sum_speed += speed;
>  	}

[Severity: Medium]
Does clamping per uplink and then summing actually bound the aggregate for
the two PFs of a dual-port adapter?  Both PFs sit on the same physical PCIe
link and read the same PCI_EXP_LNKSTA, so each contributes up to that single
link's bandwidth.

For a dual-port 200GbE adapter on Gen4 x16, mlx5_pcie_bandwidth() returns
16000 * 16 = 256000 for both PFs, each contributes min(200000, 256000) =
200000, and the aggregate becomes 400000 Mb/s, roughly 1.6x the shared link.

That aggregate is stored in ldev->agg_speed_mbps and then programmed into
every vport:

  mlx5_lag_set_vports_agg_speed() {
	...
	speed = speed / MLX5_MAX_TX_SPEED_UNIT;

	mlx5_ldev_for_each(pf_idx, 0, ldev) {
	...
		mlx5_lag_modify_device_vports_speed(mdev, speed);
  }

Should the PCIe bandwidth instead be applied to the summed value, i.e. after
aggregation, so PFs sharing one link are not counted twice?  Only the
take_max (active-backup) path stays bounded today.

>  
> @@ -1488,6 +1493,9 @@ static int mlx5_lag_get_devices_max_speed(struct mlx5_lag *ldev, u32 *max_speed)
>  			return ret;
>  		}
>  
> +		pci_bw = mlx5_pcie_bandwidth(pf_mdev);
> +		if (pci_bw)
> +			speed = min(speed, pci_bw);
>  		*max_speed = take_max ?
>  			max(*max_speed, speed) : *max_speed + speed;
>  	}

[Severity: Medium]
The same double counting applies in this fallback when take_max is false,
which is the case for LACP and XOR and is forced for MPESW.

[Severity: Low]
Unrelated to the clamp itself, but the caller's comment no longer matches
this helper:

  mlx5_lag_update_agg_speed() {
	...
	/* If speed is not set, use the sum of max speeds of all PFs */
	if (!speed && mlx5_lag_get_devices_max_speed(ldev, &speed))
		return;
  }

With take_max = ldev->tracker.tx_type == NETDEV_LAG_TX_TYPE_ACTIVEBACKUP,
the fallback returns max(*max_speed, speed) rather than a sum in
active-backup mode.  The comment was accurate in the baseline, where
mlx5_lag_sum_devices_max_speed() unconditionally did *sum_speed += speed;
should it be updated to describe the policy dependent behaviour?

>  
> @@ -1609,6 +1618,9 @@ void mlx5_lag_reset_vports_speed(struct mlx5_lag *ldev)
>  			continue;
>  		}
>  
> +		pci_bw = mlx5_pcie_bandwidth(mdev);
> +		if (pci_bw)
> +			speed = min(speed, pci_bw);
>  		speed = speed / MLX5_MAX_TX_SPEED_UNIT;
>  		mlx5_lag_modify_device_vports_speed(mdev, speed);
>  	}

[Severity: Medium]
This is the value restored into vport max_tx_speed on LAG teardown, so if
mlx5_pcie_bandwidth() over-estimates the bus bandwidth (raw rate, no
encoding correction, endpoint link only), the restored value is the
over-estimated one rather than what FW originally programmed.  Does that
still match the commit message claim that FW initializes max_tx_speed to the
minimum of the port speed and the PCI bandwidth?
