Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8027148CD77
	for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 10:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246505; cv=none; b=TIT0ykvxGhg4BIteg05WzGlkQSnX9lsHPLOiQf++YPlS+jPAor5E7j43a1YidfrrjmootYSnzN0N9aFb+HcE84FRFtglUV1R0YH08sMB7QMngBQnzmYxNREibkyBsPukLhTNc8MsIoSjX0cIvAnW0rP9y3WwSHzj8P2XnNkNeTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246505; c=relaxed/simple;
	bh=HI5e9N150YTuKijOEq0eP1x68pBiLmu9X6cVsyKiPjk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VgQn1HO4NqBG4h36QZEiTQST6Uhr4nC7X75bexp4o/xSl4u0DqOPkjhpTjfOAnmDmrlK+1B8CkK0QBoc1w8VJphFnA1CmpLIak5Z1TTJmSeoxghTuEerBp4+8tHF4gS5UZ6gLkOJjqrUW7u/3pviAEP7zLs7bGe7fw7bxUQTO3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WQVbobvo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WQVbobvo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8368F1F0089C;
	Thu, 24 Sep 2026 10:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790246502;
	bh=HKDjBereDEaycjbKAqDFl/1pacr3EAmDZUjoXBvi6jk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WQVbobvo4LFZipT2s/z0AtpBljCovVfR8WYhaTddISLUDuPwC59+31KMSIAj7Vf4l
	 cuFZnUQOz5fb2nL6NEz0i0Sw7PG5V8YoryNOFClpA8COPwPBRr7V+QBb7pYR+HT/qs
	 u5qivGwe4KaZ+KniLOwe4FuWiSUq4ihOpMarf8Yc1vf/ejfvaab2Z32Av/La+0CDiS
	 fSjWaRi2C//+1AFivXrKu595R0vz9TJcUBFc9ExPilha1Awioeif1BuNnHXrsPWGSl
	 CykSqF38vBpVWsenzXmC2nuegUVU9tmX6YoQeNwk0dqRp/BrTFdqzqCNHzxO3NCA79
	 w/iS/uhxEeTWQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 04/13] net/mlx5: LAG, allocate port-indexed
 scratch buffers dynamically
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260923103830.1183-5-tariqt@nvidia.com>
References: <20260923103830.1183-1-tariqt@nvidia.com>
 <20260923103830.1183-5-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 10:41:42 +0000
Message-Id: <20260924104142.8368F1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] net/mlx5: heap buffer overflow in MLX5 LAG configuration arrays
- [Medium] net/mlx5: partial LAG hardware state update on ENOMEM
--

commit 5ce8c0ac5b16870dc2d8dca3c2afacfca478bc6b
Author: Shay Drory <shayd@nvidia.com>
Subject: net/mlx5: LAG, allocate port-indexed scratch buffers dynamically

This patch changes the MLX5 LAG configuration functions to dynamically
allocate their scratch arrays based on the ldev->ports count instead of
using stack buffers sized to MLX5_MAX_PORTS. It also adds error handling
for these new allocations.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/=
net/ethernet/mellanox/mlx5/core/lag/lag.c
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> @@ -63,19 +63,25 @@ static int get_port_sel_mode(enum mlx5_lag_mode mode,=
 unsigned long flags)
[ ... ]
> -static u8 lag_active_port_bits(struct mlx5_lag *ldev,
> -			       struct lag_tracker *tracker)
> +static int lag_active_port_bits(struct mlx5_lag *ldev,
> +				struct lag_tracker *tracker)
>  {
> -	u8 enabled_ports[MLX5_MAX_PORTS] =3D {};
>  	u8 active_port =3D 0;
> +	u8 *enabled_ports;
>  	int num_enabled;
>  	int idx;
> =20
> +	enabled_ports =3D kcalloc(ldev->ports, sizeof(*enabled_ports),
> +				GFP_KERNEL);
> +	if (!enabled_ports)
> +		return -ENOMEM;
> +
>  	mlx5_infer_tx_enabled(tracker, ldev, enabled_ports,
>  			      &num_enabled);

[Severity: Medium]
Can mlx5_infer_tx_enabled() write past the end of enabled_ports?

The array is now strictly sized to ldev->ports. However,
mlx5_infer_tx_enabled() calls mlx5_ldev_for_each(), which iterates over
the pfs xarray. If hardware misbehaves and more PCI functions match the
GUID than the reported capacity, the xarray could contain up to
MLX5_MAX_PORTS items, overflowing this buffer.

[ ... ]
> @@ -240,22 +254,31 @@ static void mlx5_lag_print_mapping(struct mlx5_core=
_dev *dev,
>  				   struct lag_tracker *tracker,
>  				   unsigned long flags)
>  {
> -	char buf[MLX5_MAX_PORTS * 10 + 1] =3D {};
> -	u8 enabled_ports[MLX5_MAX_PORTS] =3D {};
> +	u8 *enabled_ports =3D NULL;
>  	int written =3D 0;
>  	int num_enabled;
> +	char *buf;
>  	int idx;
>  	int err;
>  	int i;
>  	int j;
> =20
> +	buf =3D kcalloc(ldev->ports * 10 + 1, sizeof(*buf), GFP_KERNEL);
> +	if (!buf)
> +		return;
> +
>  	if (test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &flags)) {
> +		enabled_ports =3D kcalloc(ldev->ports, sizeof(*enabled_ports),
> +					GFP_KERNEL);

[Severity: Medium]
Similar to the above, can the string building loop that uses this buffer
exceed ldev->ports iterations if mlx5_ldev_for_each() encounters more
xarray items than expected?

[ ... ]
> @@ -668,20 +696,28 @@ static bool __mlx5_lag_is_sd_active(struct mlx5_lag=
 *ldev,
[ ... ]
> -static void mlx5_infer_tx_affinity_mapping(struct lag_tracker *tracker,
> -					   struct mlx5_lag *ldev,
> -					   u8 buckets,
> -					   u8 *ports)
> +static int mlx5_infer_tx_affinity_mapping(struct lag_tracker *tracker,
> +					  struct mlx5_lag *ldev,
> +					  u8 buckets,
> +					  u8 *ports)
>  {
> -	int disabled[MLX5_MAX_PORTS] =3D {};
> -	int enabled[MLX5_MAX_PORTS] =3D {};
>  	int disabled_ports_num =3D 0;
>  	int enabled_ports_num =3D 0;
> +	int *disabled;
> +	int *enabled;
> +	int err =3D 0;
>  	int idx;
>  	u32 rand;
>  	int i;
>  	int j;
> =20
> +	enabled =3D kcalloc(ldev->ports, sizeof(*enabled), GFP_KERNEL);
> +	disabled =3D kcalloc(ldev->ports, sizeof(*disabled), GFP_KERNEL);
> +	if (!enabled || !disabled) {
> +		err =3D -ENOMEM;
> +		goto out;
> +	}
> +
>  	mlx5_ldev_for_each(i, 0, ldev) {
>  		if (tracker->netdev_state[i].tx_enabled &&
>  		    tracker->netdev_state[i].link_up)
>  			enabled[enabled_ports_num++] =3D i;
>  		else
>  			disabled[disabled_ports_num++] =3D i;

[Severity: Medium]
Does this iteration risk writing out of bounds into the enabled and disabled
arrays if mlx5_ldev_for_each() yields more items than ldev->ports?

[ ... ]
> @@ -816,7 +857,10 @@ static int _mlx5_modify_lag(struct mlx5_lag *ldev,
>  		    !MLX5_CAP_PORT_SELECTION(dev0, port_select_flow_table_bypass))
>  			return ret;
> =20
> -		active_ports =3D lag_active_port_bits(ldev, tracker);
> +		ret =3D lag_active_port_bits(ldev, tracker);
> +		if (ret < 0)
> +			return ret;

[Severity: Medium]
Does returning early here leave the hardware and software states out of syn=
c?

Just before this snippet in _mlx5_modify_lag(), mlx5_lag_port_sel_modify()
is called to update the hardware definers. If lag_active_port_bits() now
fails due to ENOMEM, we skip sending the active port command.

This error also propagates up to mlx5_modify_lag(), which then jumps to
the error path and skips updating the software state:

mlx5_modify_lag() {
        ...
        err =3D _mlx5_modify_lag(ldev, tracker, ports);
        if (err) {
                mlx5_core_err(dev0, "Failed to modify LAG (%d)\n", err);
                goto out;
        }
        memcpy(ldev->v2p_map, ports, ...);
        ...
}

Should there be a rollback mechanism for mlx5_lag_port_sel_modify() if
we hit this new error path?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923103830.1183=
-1-tariqt@nvidia.com?part=3D4
