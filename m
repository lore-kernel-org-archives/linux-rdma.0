Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2B1531600;
	Thu, 24 Sep 2026 17:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271959; cv=none; b=SwWsjAqyGsxDcyLuugOz+Ae/uuk9oOiGQwYOuRHbsvHpqi2oojmR8to5CN2Lc8BRjOJPYenNyIRTCLcrlZRsHcGBixOHr6g1Li/F9zSFbvUxDHMMDdXHaxqDNJ+ROXUMyKcdnSXohIK1VNiwjj7Vc9tsdaWW9VKlEi64xCKPMuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271959; c=relaxed/simple;
	bh=YKEWxaoix9dEUcgkUkfKhEem0sLY/FFpb1hZ9Nw6by4=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tw0OeZ8ZMnFZOPt7O+qTOcVOAVFwaWt2lEwU1dwEGVUVPOd4UJmoBZgOXSuEQOZ2GpvVMt8VFLLWhFZ7A/XPrwIYNWqe5UIAcqYkt/yWvKQ3avBSwbU9PFmq4HXyvDXFAtf4XL3sBOlQQo3GH1Ix2S1oMyLVNAHdHqHsAch1Ty0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CcSBHBEZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CcSBHBEZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC431F00893;
	Thu, 24 Sep 2026 17:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790271957;
	bh=TwLnZ4tFNLK+swABQKDoWJQE21Op+rJmtaW/pA1y2kw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=CcSBHBEZ723ZqoHXc3fQx/Q9dnVNCNgd1Q8CimtSslSNArv2lIrRL1MFaH7APodUj
	 7ZkwaHeehXGlh4GvM/dxQ8cU5zcm+4B/7RuAan5SiQqX8722EYTc+YJEphVnskCThZ
	 nQpRROq16mBUVLQJrsw3UTzK/a+Uhj/q1qG+QPIkf6n6OJqjEg3ordfPpEmuhtg5p/
	 1tatIKtf2swt9ysq4XmOTF9t8BO8e6vaPgVBjRne9oqeVMXFqAeBPj93a3fp/Gh6G2
	 OpY9ibnhU/2SE6+Bfi4mUTzkDrfOA3z5x0tnANlWIuueau7x6oEEZSmLpMBzecGgaq
	 tFUWOiZcc9zMA==
Subject: Re: [PATCH net-next 04/13] net/mlx5: LAG, allocate port-indexed
 scratch buffers dynamically
From: netdev-bot+sashiko@kernel.org
To: tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 agoldberger@nvidia.com, cratiu@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 moshe@nvidia.com, ohartoov@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com
Date: Thu, 24 Sep 2026 17:45:55 +0000
Message-ID: <179027195585.2160803.1977712235305526325@kernel.org>
In-Reply-To: <20260923103830.1183-5-tariqt@nvidia.com>
References: <20260923103830.1183-5-tariqt@nvidia.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 · Low: 0 (1)

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] _mlx5_modify_lag()
  (drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c) can now leave a…
- [Medium] net/mlx5: heap buffer overflow in MLX5 LAG configuration
  arrays

Pre-existing issues:
- [Low] Concern: lag_active_port_bits() builds a bitmask of up to 8 bits
  (MLX5_MAX_PORTS = 8), but mlx5_ifc_lagc_bits.active_port is only 4…

--

net/mlx5: LAG, allocate port-indexed scratch buffers dynamically

This patch replaces the MLX5_MAX_PORTS-sized stack arrays in
lag_active_port_bits(), mlx5_lag_print_mapping() and
mlx5_infer_tx_affinity_mapping() with kcalloc(ldev->ports, ...)
allocations. lag_active_port_bits() and mlx5_infer_tx_affinity_mapping()
now return int, and their callers get -ENOMEM on allocation failure.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> index 00b0159cb422f..93ead56641528 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c

[ ... ]

> @@ -105,13 +111,21 @@ static int mlx5_cmd_create_lag(struct mlx5_core_dev *dev, struct mlx5_lag *ldev,
>  		MLX5_SET(lagc, lag_ctx, tx_remap_affinity_1, ports[idx0]);
>  		MLX5_SET(lagc, lag_ctx, tx_remap_affinity_2, ports[idx1]);
>  		break;
> -	case MLX5_LAG_PORT_SELECT_MODE_PORT_SELECT_FT:
> +	case MLX5_LAG_PORT_SELECT_MODE_PORT_SELECT_FT: {
> +		u8 active_port;
> +		int ret;
> +
>  		if (!MLX5_CAP_PORT_SELECTION(dev, port_select_flow_table_bypass))
>  			break;
>  
> -		MLX5_SET(lagc, lag_ctx, active_port,
> -			 lag_active_port_bits(ldev, tracker));
> +		ret = lag_active_port_bits(ldev, tracker);
> +		if (ret < 0)
> +			return ret;
> +
> +		active_port = ret;
> +		MLX5_SET(lagc, lag_ctx, active_port, active_port);

[Severity: Low]
This is a pre-existing issue and was not introduced by this patch.
lag_active_port_bits() can build a mask up to 8 bits wide
(MLX5_MAX_PORTS is 8), but the lagc active_port field is only 4 bits wide:

include/linux/mlx5/mlx5_ifc.h:mlx5_ifc_lagc_bits {
	...
	u8         reserved_at_20[0xc];
	u8         active_port[0x4];
	...
}

MLX5_SET() masks the value to the field width. Bits 4..7 would be
silently dropped here, and also in mlx5_cmd_modify_active_port().

In hash LAG with port_select_flow_table_bypass, would ports 5..8 ever be
reported to FW as active? It's not clear whether FW offers bypass on
devices with more than 4 LAG ports.

>  		break;
> +	}
>  	default:
>  		break;
>  	}

[ ... ]

> @@ -816,7 +857,10 @@ static int _mlx5_modify_lag(struct mlx5_lag *ldev,
>  		    !MLX5_CAP_PORT_SELECTION(dev0, port_select_flow_table_bypass))
>  			return ret;
>  
> -		active_ports = lag_active_port_bits(ldev, tracker);
> +		ret = lag_active_port_bits(ldev, tracker);
> +		if (ret < 0)
> +			return ret;

[Severity: Medium]
Can a failed kcalloc() in lag_active_port_bits() leave a hash-based LAG
only partly reprogrammed?

By the time lag_active_port_bits() runs, mlx5_lag_port_sel_modify() has
already rewritten the FT rule destinations in hardware:

_mlx5_modify_lag()
  mlx5_lag_port_sel_modify(ldev, ports)
    mlx5_lag_modify_definers_destinations()
      __mlx5_lag_modify_definers_destinations()
        mlx5_modify_rule_destination()
  lag_active_port_bits()
    kcalloc() fails -> return -ENOMEM

If that happens, mlx5_cmd_modify_active_port() is never sent. The FW
active_port bitmask used by bypass traffic still lists the old active
uplinks, which could include a port whose link just went down.

mlx5_modify_lag() then takes the error path and skips the v2p_map update:

	err = _mlx5_modify_lag(ldev, tracker, ports);
	if (err) {
		...
		goto out;
	}
	memcpy(ldev->v2p_map, ports,
	       ldev->ports * MLX5_LAG_MAX_HASH_BUCKETS);

Both mlx5_modify_lag() and __mlx5_lag_modify_definers_destinations()
skip entries where ports[idx] == v2p_map[idx]. Suppose the tracker later
returns to the state that matches the stale v2p_map. Would the FT rules
then stay on the intermediate mapping, with nothing to reprogram them?

A FW failure in mlx5_cmd_modify_active_port() could already cause this
before the patch. This patch adds a software failure point between the
two hardware steps.

The bitmask doesn't seem to need a scratch buffer. Could it be built
directly while walking mlx5_ldev_for_each()? Alternatively, could it be
computed before mlx5_lag_port_sel_modify() touches the hardware?

> +		active_ports = ret;
>  
>  		return mlx5_cmd_modify_active_port(dev0, active_ports);
>  	}

[ ... ]

> @@ -668,20 +696,28 @@ static bool __mlx5_lag_is_sd_active(struct mlx5_lag *ldev,
>   * If there are ports that are disabled fill the relevant slots
>   * with mapping that points to active ports.
>   */
> -static void mlx5_infer_tx_affinity_mapping(struct lag_tracker *tracker,
> -					   struct mlx5_lag *ldev,
> -					   u8 buckets,
> -					   u8 *ports)
> +static int mlx5_infer_tx_affinity_mapping(struct lag_tracker *tracker,
> +					  struct mlx5_lag *ldev,
> +					  u8 buckets,
> +					  u8 *ports)
>  {
> -	int disabled[MLX5_MAX_PORTS] = {};
> -	int enabled[MLX5_MAX_PORTS] = {};
>  	int disabled_ports_num = 0;
>  	int enabled_ports_num = 0;
> +	int *disabled;
> +	int *enabled;
> +	int err = 0;
>  	int idx;
>  	u32 rand;
>  	int i;
>  	int j;
>  
> +	enabled = kcalloc(ldev->ports, sizeof(*enabled), GFP_KERNEL);
> +	disabled = kcalloc(ldev->ports, sizeof(*disabled), GFP_KERNEL);
> +	if (!enabled || !disabled) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +
>  	mlx5_ldev_for_each(i, 0, ldev) {
>  		if (tracker->netdev_state[i].tx_enabled &&
>  		    tracker->netdev_state[i].link_up)

[Severity: Medium]
The old stack arrays were sized by MLX5_MAX_PORTS, which is also the
limit on how many entries ldev->pfs can hold. The new buffers are sized
by ldev->ports instead. However, the loops that fill them still walk
the xarray with mlx5_ldev_for_each() and index by a running count:

mlx5_infer_tx_affinity_mapping()
  mlx5_ldev_for_each(i, 0, ldev)
    enabled[enabled_ports_num++] = i;
    or disabled[disabled_ports_num++] = i;

mlx5_infer_tx_enabled() / mlx5_infer_tx_disabled()
  ports[(*num_enabled)++] = i;

None of these helpers checks the count against ldev->ports.

Is there anything that guarantees the number of PFs added to ldev->pfs
never exceeds ldev->ports (num_lag_ports)? Suppose devcom pairs more
functions sharing the same system image GUID than FW reported in
num_lag_ports. Then these buffers would be written past the end of
their kcalloc() allocations:

  enabled[] and disabled[] in mlx5_infer_tx_affinity_mapping()
  enabled_ports in lag_active_port_bits()
  enabled_ports in mlx5_lag_print_mapping()

Before this patch the same situation stayed inside the MLX5_MAX_PORTS
stack arrays.

The same applies to buf in mlx5_lag_print_mapping(). It is now sized
ldev->ports * 10 + 1, but the non-hash branch emits one " port %d:%d"
per iterated port and bucket, so an extra PF would push the
scnprintf() writes past the allocation.

If the invariant holds, could it be enforced where a PF is added to
ldev->pfs? Alternatively, could these loops bound the count by
ldev->ports, so an unexpected extra PF can't turn into a heap
overwrite?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260923103830.1183-1-tariqt%40nvidia.com
