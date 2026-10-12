Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B3E39CCFF
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 09:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791797536; cv=none; b=rgCbOQbdU0dVGPMbrPhKjIbq0IpQDq73aktIiSVV0CmJbgaPxtDrw+qtJp0w/GXHYyhSm1c8RQeqALfWbdFb6YIH8ZXoM2UVbx7cSXA5AszxG9xjEUDvlzOBp/flH9BbNeq/6JrntqEBKmJYQFs0/YIu0eedBJbLLGNOAxXPEHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791797536; c=relaxed/simple;
	bh=KYqI9HkXUwo3MXQthb8p9CSTwyDg+dp9wkTPlS2vQsk=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ZYIBFBomWY8KxkK5hDAQYvnGrd0u6nWgsjGSRZjzOFCSafsGKXazYn/eVkhTqnfz6rrTgpKCB2P5CyCQL3/Z0FjppVYg6oozNPraK1OqZ+2VYomIJpKXst4AdlOUmIRp5QKNRZhftYR+cEq/1ERr2raj6XcfZL2yClg5VMRs0NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hM0OBDCP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hM0OBDCP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253A01F0089B;
	Mon, 12 Oct 2026 09:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791797534;
	bh=tKkVoZ7c0xCcMGgYnhfgI6H1z+MwclkoKylD0quA7CA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hM0OBDCP4/mo60DLCU2pcZQrrgyOdSneoh5RZF0Or/VsA0l3Mqt9+Rv+QKxCkUCtv
	 +f6bPwGLpXwnhV5sb7ADDy00FWPdwzXxz9ixr+OA5yOiqB8GXsmiU9w3dRPiXz1lJo
	 Y1nfP+etILAeltyMK5QNeh1CqxY7qkRLhxQafU32JeIaJ863WJsRDDBwS8DUW0JMIh
	 flcr7m+0FFj9o3mVzY6ql7qj0Jh4cWPa11Ds75rkNUAlIMR5Ey+09yuVb2an7rqNrP
	 WmYObKtPhpvkfqrc3AVAURg4r3cya30mZxifXJTasYpPJBtD5QL2tjzcl3BlGxtBDL
	 TIXQG1O3iF1cw==
Message-ID: <sashiko-outbox-167900@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next] net/mlx5e: Rename state_destroy to
 rx_mode_active in flow steering
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261011093100.769149-1-tariqt@nvidia.com>
References: <20261011093100.769149-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 09:32:13 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] net/mlx5e: spurious WARN_ON_ONCE in mlx5e_del_vlan_rules() on error=
 paths
--

commit cc0cc005a261a4ae9c4dc0882c52ded86fc801c3
Author: Alexei Lazar <alazar@nvidia.com>

net/mlx5e: Rename state_destroy to rx_mode_active in flow steering

This commit renames the state_destroy flag to rx_mode_active to better
clarify its purpose in the flow steering code. It controls the enablement
of RX mode handling and acts as a safeguard during device teardown.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_fs.c
> index 12492c4a5d410..c19238bc821fb 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c

[ ... ]

> @@ -560,7 +560,7 @@ static void mlx5e_del_vlan_rules(struct mlx5e_flow_st=
eering *fs)
>  	for_each_set_bit(i, fs->vlan->active_svlans, VLAN_N_VID)
>  		mlx5e_fs_del_vlan_rule(fs, MLX5E_VLAN_RULE_TYPE_MATCH_STAG_VID, i);
> =20
> -	WARN_ON_ONCE(fs->state_destroy);
> +	WARN_ON_ONCE(fs->rx_mode_active);

[Severity: Low]
Does this trigger a spurious warning on error paths?

If mlx5e_attach_netdev() begins execution, it sets rx_mode_active to true.
If a subsequent function like profile->init_rx() fails (for example, if
mlx5e_ptp_alloc_rx_fs() fails), the error rollback path calls
mlx5e_destroy_vlan_table() which calls mlx5e_del_vlan_rules(). Since
rx_mode_active is still true, the WARN_ON_ONCE() is hit during the rollback.

[ ... ]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en_main.c
> index f90b5a34e0972..478b5956044bd 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -6557,8 +6557,9 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
> =20
>  	clear_bit(MLX5E_STATE_DESTROYING, &priv->state);
>  	if (priv->fs)
> -		mlx5e_fs_set_state_destroy(priv->fs,
> -					   !test_bit(MLX5E_STATE_DESTROYING, &priv->state));
> +		mlx5e_fs_set_rx_mode_active(priv->fs,
> +					    !test_bit(MLX5E_STATE_DESTROYING,
> +						      &priv->state));

[Severity: Low]
Because rx_mode_active is set to true early in device attachment here before
calling init_rx(), could it remain true when handling a failure and lead to
the spurious warning mentioned above?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261011093100.7691=
49-1-tariqt@nvidia.com?part=3D1
