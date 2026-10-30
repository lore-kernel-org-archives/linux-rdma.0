Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336019;
	b=zcJ9bOknnsQwkSdZACDvUQBoy/frRAH0IHxNz6PO05W78kwWt/AlmB1sWBYV+jdFsec6
	 mIfCLbCQLNcYX9RvZ58k7yt+erEYVwOrQfQ2XmBBZa0GYXiF4OiHliSRq5v0bDEe/BSIe
	 XlaGqxVa39H0eOevvCYP5dAGqG5e3fFOYNZFZUmNAQ9fkJt6WmM59eqqFOj/P3GeXAps4
	 diPNfR/jNRpRfA1DWhkZG8U5uHkaszj8gJ+l9m/TQbPfhI9Jxn1kbNT7r9mifHIzl3j9p
	 JJtyDd4dvc0Yq0HW0AlF5av+0poLqvw7SKyv+IXvkc30PKCx34suAcc9Nuw0Nb3fP+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336019;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=hxbJ2k1m0YP6keF7KADzVMO/oKQ7COjMQFGpsKhTBUE=;
	b=xJZqLYQOmM/7Nf0bb7sGP3EV4CzcJTLM9KQ2Ztks4AZxyDiCSJ4ZMhc8uyMTknxplUN7
	 7yCZWYzgdDFyGx5DGZ9/qAPjDNG8lQXESEMs5dsFX2tLu+ZtC+18XBAWohUJBmeTIpykz
	 Ko2zYIHARPct2KKdIsbjJ6Ql5orp604KVVVFwoJB+4WMRw+8yv5Mb3vt4X6oXybEpZI4M
	 lkhmIQ3T+gWnK60XnUpG3eMTvEpovSsEyGY7BJv2Iok2IGjS6DBhsGT+ucOZJLaamoWZr
	 Hf0p4YZYpXYiKeqL5dgUJHC1sj6Y/oUvC7yEaX0PtEs/c0cXSYRrCwNA/rlbC8SXhpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dATabKW9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC89606A329
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dATabKW9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506161F0093A;
	Fri, 30 Oct 2026 04:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336019;
	bh=hxbJ2k1m0YP6keF7KADzVMO/oKQ7COjMQFGpsKhTBUE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dATabKW90GwTwHkJ+oRjrPxYu+THGFli92sWdAhan3Uiy1jkLjboCyvc8MfWM5XcD
	 wswQdUNxhIN3SFdueZ/pRSo/RpsJnpZ7k2tclXt04Rc0Za+P3fZD1AC8W14aKX2iQR
	 qInxuuAaFwSNBEx3PnVXXC3BLtn6RgvmUun4x8iQY+hwXHuR1yJYjR+gaRo2otUQJf
	 s8o3tIf5yLTwXiOxfw+2cGhmnmjxtigA+u4rM2qG/I+BN29yr9xzxfXYS+CHF3yZEk
	 JZZIBJc/v5nEYBPaXBBTFcYnoeIR8JglOLeL16ACwr+pk4ePk3s03J/56gwb2UJ8k/
	 sPL/zb658qsVg==
Message-ID: <sashiko-outbox-190330@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 3/3] net/mlx5: E-Switch, fix deadlock
 between devlink lock and esw->wq
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260428051018.219093-4-tariqt@nvidia.com>
References: <20260428051018.219093-4-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:53:38 +0000
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
- [High] Open-coded trylock retry loop used to bypass a lock ordering deadl=
ock, violating networking subsystem guidelines.
- [High] Unsynchronized atomic notifier unregistration creates a race condi=
tion that defeats the stale work filter, risking execution of old work on t=
orn-down state.
--

commit 1ce8a06ae391b110c8a8badeed88f41bec66031f
Author: Mark Bloch <mbloch@nvidia.com>

net/mlx5: E-Switch, fix deadlock between devlink lock and esw->wq

This commit aims to fix a deadlock during E-Switch cleanup by checking a
generation counter before taking the devlink lock in the workqueue handler,
and invalidating the workqueue around mode changes and teardown.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/=
net/ethernet/mellanox/mlx5/core/eswitch.c
> index 1986d4d0e886..8ec52498be3f 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c

[ ... ]

> @@ -1785,6 +1793,7 @@ void mlx5_eswitch_disable_locked(struct mlx5_eswitc=
h *esw)
> =20
>  	mlx5_eq_notifier_unregister(esw->dev, &esw->nb);
>  	mlx5_eswitch_event_handler_unregister(esw);
> +	mlx5_eswitch_invalidate_wq(esw);

Since mlx5_eq_notifier_unregister() uses atomic_notifier_chain_unregister(),
which does not wait for in-flight callbacks to complete on other CPUs, is
there a race condition here?

If a concurrent hardware event callback is already executing when
mlx5_eswitch_invalidate_wq() increments the generation counter, could the
callback read the new generation value and assign it to the new work item?

If that happens, the stale work might bypass the filter in esw_wq_handler()
and execute against torn-down state.

[ ... ]

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b=
/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> index 23af5a12dc07..9e2ae217c224 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c

[ ... ]

> @@ -3694,21 +3694,38 @@ static void esw_wq_handler(struct work_struct *wo=
rk)
>  	struct mlx5_host_work *host_work;
>  	struct mlx5_eswitch *esw;
>  	struct devlink *devlink;
> +	int work_gen;
> =20
>  	host_work =3D container_of(work, struct mlx5_host_work, work);
>  	esw =3D host_work->esw;
> +	work_gen =3D host_work->work_gen;
>  	devlink =3D priv_to_devlink(esw->dev);
> =20
> -	devl_lock(devlink);
> +	/* Do not block on devlink lock until stale work is filtered out.
> +	 * Teardown can invalidate the generation and then wait for this
> +	 * workqueue while holding devlink lock.
> +	 */
> +	for (;;) {
> +		if (work_gen !=3D atomic_read(&esw->generation))
> +			goto free;
> +
> +		if (devl_trylock(devlink))
> +			break;
> +
> +		wait_event_timeout(esw->work_queue_wait,
> +				   work_gen !=3D atomic_read(&esw->generation),
> +				   msecs_to_jiffies(60));
> +	}

Does this open-coded trylock retry loop mask a lock ordering issue?

The commit message mentions this is used to avoid an AB-BA deadlock when
mlx5_eswitch_cleanup() calls destroy_workqueue() while holding the devlink
lock. Using a trylock loop with a sleep fallback to bypass lock ordering
issues reimplements blocking without lockdep's deadlock detection, which
might indicate the teardown sequence itself needs adjustment.

> =20
>  	/* Stale work from one or more mode changes ago. Bail out. */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260428051018.2190=
93-1-tariqt@nvidia.com?part=3D3
