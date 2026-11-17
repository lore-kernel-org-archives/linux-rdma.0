Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794911805;
	b=17IPpp//ra+Frfn8qpChe4IGzENbFwXJkdbf4S9MBjfNVaPPrxMXpvx9qutQlmH2fDCR
	 MW/VQkq1bBS4k3RxslCoTJNaHHO49TyTeZUW8xI4Ga69xHrApEJ0i2Xy48herTY4i8yZM
	 wyqO8IkUf4aXiMwwFzHGSjKAZaHe6AHd7bTLVd/pNkSMhCwf58Cs5Bw/c8y0FUQjuOgXJ
	 /L17JJ2jlU2PTS1HqUxEDfBy1jD7WiMNcQSXMaiSYAJ/iDF3zak//PYOahT306DYMHYHG
	 7seKMGxjQBwQNKnYAnApZPUaAgxfeS02wobZcGwt8QmWPXYPA3xnEI/NFxM5byzpVnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794911805;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8HhSVtHYt9Io8gIM8eF/ZZTCTyogfngrxEIHSFWsAfk=;
	b=3a9Adj2oYMro+HaH5mQpGCybrSTuztD8KczABLuJMGrFDMasW0CkRbT8PRuSdBgAiFSn
	 hPkmjFEJ49BLM5+SupPhbSG4iUkzYIKlK75uQcBTQJNiSOkUOhaTxQcQuZR43lLqgfx2y
	 2iT2GYuFZ6xONnWVKk07L7OAwnh1+EgGLihrIge+rFKU86OEejEo4ApQ7FYsCtXL4qw/n
	 /xksa0gYhCzENn9DT7MGXcb1xevHEsm8JbXXEPskoIxStNtoJ8QSrff/5JYGyeFq+qz8I
	 FVm2E+AFDR7xKiswBftfvWVsU8qRTeBXSWlS4Zzbu2e+Bk1KNZdOZ+SQ41Vt5+ukxgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y9l0lPM6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B29606A32C
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 10:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y9l0lPM6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C601F000C4;
	Tue, 17 Nov 2026 10:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794911805;
	bh=8HhSVtHYt9Io8gIM8eF/ZZTCTyogfngrxEIHSFWsAfk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y9l0lPM60zycJTWw0Qd7YbQfoVeqYhSOwrIWWZPEcLgunq3JXoPRrmu14bcZrAeNO
	 LgG7KJ5nUFinRXrc6H0xPqqX+HuDA0AqnI9T0xdwaGy4srqAkKSvis2mJzzzAiNu9K
	 gEdmd/2PxtdRWd9y4GX78FnDmuKsoRldTjLHVYOf/eoSZcBlzt+AmucPUHzeX55s4/
	 F8XvN2s8nMlTiIwr6ENa8GbTU1hi+UDqElu6fqKcW8953+H3LHtoqzWHJUo65h+xdM
	 SF5nmyK8BmYHOcAI0supDxNFkJL4oOrX7tqlEpOKQCooclSF37l4hW1oMJnlN/yQJn
	 bhIYDvlTcmSwQ==
Message-ID: <sashiko-outbox-218633@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 05/10] net/mlx5: LAG, decouple iteration
 end-of-walk from MLX5_MAX_PORTS
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261116103010.1129666-6-tariqt@nvidia.com>
References: <20261116103010.1129666-1-tariqt@nvidia.com>
 <20261116103010.1129666-6-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 10:36:43 +0000
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
- [Medium] net/mlx5: LAG, max_funcs sentinel mismatch in changeupper and
  alloc
--

commit 78f2f8069167c6a38a6b670a3fc665eb9f73b7c1
Author: Shay Drory <shayd@nvidia.com>

net/mlx5: LAG, decouple iteration end-of-walk from MLX5_MAX_PORTS

This commit replaces MLX5_MAX_PORTS with a dynamic ldev->max_funcs ceiling
as the end-of-walk sentinel for LAG xarray iterators and removes the
MLX5_MAX_PORTS upper bound on xa_alloc().

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/=
net/ethernet/mellanox/mlx5/core/lag/lag.c
> index 669b2167a82d2..cbef6ab1e38a8 100644
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

> @@ -2094,7 +2095,7 @@ static int mlx5_handle_changeupper_event(struct mlx=
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
Should mlx5_handle_changeupper_event() check i < ldev->max_funcs instead of
i < ldev->ports, and should ldev->max_funcs be initialized before
registering the notifiers in mlx5_lag_dev_alloc()?

mlx5_ldev_for_each() terminates with i =3D=3D ldev->max_funcs when no match=
ing
netdev is found.  In mlx5_lag_dev_alloc(), register_netdevice_notifier_net()
and mlx5_lag_mp_init() run while ldev->max_funcs is still 0 and ldev->ports
is at least 2:

CPU0                                  CPU1
mlx5_lag_dev_alloc()
  ldev->ports =3D ...;
  register_netdevice_notifier_net()
                                      mlx5_lag_netdev_event()
                                        mlx5_handle_changeupper_event()
                                          mlx5_ldev_for_each(i, 0, ldev)
                                            /* ends with i =3D 0, idx =3D -=
1 */
                                          if (i < ldev->ports)
                                            bond_status |=3D (1 << idx);
                                              <-- shift by -1
  mlx5_lag_mp_init()
  ldev->max_funcs =3D ldev->ports;

Conversely, once xa_alloc() assigns a port an xarray index >=3D ldev->ports
and grows ldev->max_funcs, a matching slave increments idx and breaks out of
mlx5_ldev_for_each() with i >=3D ldev->ports, so if (i < ldev->ports) skips
updating bond_status and has_inactive for that slave.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116103010.1129=
666-1-tariqt@nvidia.com?part=3D5
