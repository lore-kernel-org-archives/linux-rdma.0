Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793812427;
	b=lhri32t2LL4mnMaN2TIq6e2zhWo059DmYjuhOmgtrbZbJrs3H82oM6bFwB0JRp3e7m26
	 bhBp37ZAB6WlLZP35BEWAbxXYzBWVqCd8k3B3Gf3yH8kw2H66EpPP/e9/tCVsg45MQHKZ
	 1omDvrWpBSKcMhlxoiIFHrvm/xDSR85r7v8qAHpZdRt+7vfBP7WttHB1QNONDAV21zftP
	 B3wk19euUMH401lZ99O1dv3WC8TogGmkAlxtQFXIdhK2+FV8lLl8nyr6Mn+pS5j8Mp444
	 +oJAna2Iws8wP0B446x2s+eOjWlNRBkkgWKhXiwdkC8A3doqig4JuVZ0i9IhuFtgirw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793812427;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=83Qbd3jB+OOqHnFbxdLH5xQZWheXaJDOF8tcxU2n/Rs=;
	b=nLNvrMYkfYEvwvHMMV3EsplQLzvhZu7v3NTOHD1Mjsals+Mm6gPnr/7/3vpLjG0WmnjU
	 I8TC1UkbOMKtcIs1EfefL+7B0COR/45rf2ooEn/2fetgod1xnUpZaB9064k6xn34lKxMh
	 TSlp1/tpd3dHJm6YnbWB5z6JGh9LZtAlRDZaHrBwrM7ePR6KKgYOwUKA8r2+049H5UFgh
	 Q681eYbvoKT4e7u+tUWqA0wSEr2qVOB8+efC76VjUwZe4F9OUJSMx96Ty6C5IXihMt/Zt
	 ak2RDpOPgzSz/VpkNXZ8UOS0CXlmIbtp2TUKURndkZ5Vcx7XrhTzYr+FhEoMkOEmITw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lxQvGrNd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B79606A334
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 17:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lxQvGrNd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CB91F00919;
	Wed,  4 Nov 2026 17:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793812426;
	bh=83Qbd3jB+OOqHnFbxdLH5xQZWheXaJDOF8tcxU2n/Rs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lxQvGrNdRpPpDw73+gEvxMq5N04YEaK9gTmLOiFUhDiTInsLBBwuLi0D/46N66F6z
	 aaEuhh0tF7Be0CLAaX4NbuDZtd/5BCQm/RdIrxwm3fuk0s+KX4eTJTp5TTifWD6f56
	 +3Bc0h3iNMGCA/VqbSk8TWllz9xa7+b+G1zOxYZG8/w+vyLVFUafreZf+SSxD3+OEF
	 6hfprM5O1TDucmB9bDSZ7EvHWZtuoKWB/hWqpeOqDsmAvs3d4PpstVoC2eSbD4oYma
	 GP+LkQMuLvUTdvqEVkrPDzdLCLnxp8RLPQFNe80jmwprjnOaA8GYAh/TuHVMT0dnkR
	 hFQKZ68ProAEQ==
Message-ID: <sashiko-outbox-197732@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 05/15] net/mlx5: LAG, decouple iteration
 end-of-walk from MLX5_MAX_PORTS
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103171009.563034-6-tariqt@nvidia.com>
References: <20261103171009.563034-1-tariqt@nvidia.com>
 <20261103171009.563034-6-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 17:13:46 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] net/mlx5: LAG, wrong loop sentinel check in mlx5_handle_changeup=
per_event()
--

commit 2ad8acabb3b31aebe50252b21fd494729c3bdc6a
Author: Shay Drory <shayd@nvidia.com>

net/mlx5: LAG, decouple iteration end-of-walk from MLX5_MAX_PORTS

This commit introduces ldev->max_funcs to replace MLX5_MAX_PORTS as the
end-of-walk sentinel for LAG xarray iterators and updates callers and
xa_alloc() bounds accordingly.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/=
net/ethernet/mellanox/mlx5/core/lag/lag.c
> index b2ac5c671ae60..73bce918cddba 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
> @@ -395,6 +395,7 @@ static struct mlx5_lag *mlx5_lag_dev_alloc(struct mlx=
5_core_dev *dev)
>  		mlx5_core_err(dev, "Failed to init multipath lag err=3D%d\n",
>  			      err);
> =20
> +	ldev->max_funcs =3D ldev->ports;
>  	return ldev;
> =20
>  err_wq:

[ ... ]

> @@ -2095,7 +2096,7 @@ static int mlx5_handle_changeupper_event(struct mlx=
5_lag *ldev,
>  				break;
>  			}
>  		}
> -		if (i < MLX5_MAX_PORTS) {
> +		if (i < ldev->ports) {
>  			if (netif_is_bond_master(upper)) {
>  				slave =3D bond_slave_get_rcu(ndev_tmp);
>  				if (slave)

[Severity: Medium]
Should the check in mlx5_handle_changeupper_event() compare i against
ldev->max_funcs instead of ldev->ports?

In mlx5_handle_changeupper_event(), the loop uses mlx5_ldev_for_each():

	for_each_netdev_in_bond_rcu(upper, ndev_tmp) {
		mlx5_ldev_for_each(i, 0, ldev) {
			pf =3D mlx5_lag_pf(ldev, i);
			if (pf->netdev =3D=3D ndev_tmp) {
				idx++;
				break;
			}
		}
		if (i < ldev->ports) {
			...
			bond_status |=3D (1 << idx);
		}

mlx5_ldev_for_each() calls mlx5_get_next_lag_func(), which now returns
ldev->max_funcs when the walk reaches the end without a match.

If ldev->max_funcs has grown past ldev->ports and a port function resides at
an xarray index i where ldev->ports <=3D i < ldev->max_funcs, a matching
ndev_tmp will increment idx and break out of the loop, but (i < ldev->ports)
will be false, skipping the has_inactive and bond_status updates for that
slave.

Additionally, in mlx5_lag_dev_alloc(), ldev->ports is initialized and
register_netdevice_notifier_net() registers mlx5_lag_netdev_event() before
mlx5_lag_mp_init() and before ldev->max_funcs =3D ldev->ports. If a
NETDEV_CHANGEUPPER event runs during that window while ldev->max_funcs is 0
and ldev->ports >=3D 2, mlx5_ldev_for_each() finishes immediately with i =
=3D=3D 0
and idx =3D=3D -1, causing (i < ldev->ports) to evaluate to true and execute
bond_status |=3D (1 << -1).

Would it make sense to compare i < ldev->max_funcs in
mlx5_handle_changeupper_event() and initialize ldev->max_funcs alongside
ldev->ports before registering the netdevice notifier in
mlx5_lag_dev_alloc()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103171009.5630=
34-1-tariqt@nvidia.com?part=3D5
