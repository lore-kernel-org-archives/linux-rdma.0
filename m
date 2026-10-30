Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336024;
	b=Id3Wjh+uOBKHCSW4AJg0ThUxmtVrZmkQHzXrR8pxLbDP5YJEWwNRbYdmRwHhnGf99iTg
	 oMQu1Ep42Z3bbKqxczK2FPrbCyZKdL/oOoHdqnB49rY+O9SH8ob0CerALZaIkAMFvgJ99
	 /JrpdbHsNRTtL5k9ThwJpVWdYOgw9Ublu751f+MzdZ72RspWoMOtb9QT+IzNAUsVEhidC
	 CFBBIBBBU+D/g/zNO228HDVCcYavyGSk+pdjo4DRnajbseUqel3HkcM6PPcq6xAhZL7aV
	 2WlslOr6f7Oe0Kfd20aZXJ5aveZWR1yu9algmulHb6zvgb+hz3NRkJxmqT73teJhdaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336024;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=KFlDDkkWEadt7ec8GnHna3ph2n7/1eYBXrJVXmpd8So=;
	b=YCPOIiymMONQD9Qp9llocU1+N3M9Iv/C7nNDkby3EG8sZKsEbIH8iv4Y6vMU7g867L1x
	 Ns4Wj2cjg/1cVI4TQh+zntIgH2FeJeWuLI1hgSSD3fUUdiMI8rnYwVnC24dHRe+fxslis
	 AC0bOb17Xn+CaOmpAV7enJHoic+op2otVH02aqOB1HYZoNxUfz3vInLEZMSYIP2/K1Erp
	 eaqr/BCgDgjluqJSOn3F1zBlcoBz03uQ9Qz7HwKw8HJMhGD7KQSFfY5YyJoCgCI9bMKlL
	 a5ktufR4iFDt2rtxi5qyI9ffzMBTUiz1RZGs7wP3mynrKNldaXED6cK68o8ii16DWSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e8IMV9Ql;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD05606A31C
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e8IMV9Ql
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6491F000C1;
	Fri, 30 Oct 2026 04:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336023;
	bh=KFlDDkkWEadt7ec8GnHna3ph2n7/1eYBXrJVXmpd8So=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e8IMV9QlWuodiNjRBl7WqS8bcbofZOZE9D1i9M8bWrPTUphLuwkiqIoNZ0n2woChQ
	 febI1BkD0YSCv9LZNa2VYaRBEI7EB8VeEXKFSop3nKJMbrWyORN8Fd7NEPfR17f2JA
	 FhiJD2P3cJEZxD/2rkfnA8TFvjDZXFyZFrWX8pugG5jsW5pMhrEoRXGSX6ntzdTmVd
	 HhgmtvITbR7VZ1eCQy8+tfuwpTdBV6W2AG3hifP5RtxKmexumY2b/URU9lUyLyAAgc
	 fVeRthbPwPfyxuJ7sz2SKNmdcJ8jNlDAm47326xT4G4mr8jsUNHcNcIN6Qf4/DxLh5
	 rX9eBp4m7+5QA==
Message-ID: <sashiko-outbox-190341@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net V4 1/4] net/mlx5: SD: Serialize init/cleanup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260428060111.221086-2-tariqt@nvidia.com>
References: <20260428060111.221086-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:53:43 +0000
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
- [Critical] Missing mlx5_devcom_comp_set_ready(false) on early exit paths =
of mlx5_sd_cleanup() leads to UAF and NULL pointer dereference.
- [High] Debugfs entries are leaked and cause Use-After-Free because `sd->d=
fs` is stored locally instead of on the primary device.
--

commit 6ffe25861472680c980f1d8be7eb7a46e94f2aad
Author: Shay Drory <shayd@nvidia.com>

net/mlx5: SD: Serialize init/cleanup

This commit protects the Socket-Direct (SD) init/cleanup paths with the
devcom component lock and tracks the SD group state on the primary device.
It skips init if the primary is already UP, and skips cleanup unless the
primary is UP, serializing the bring-up/tear-down sequence across PFs.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/lib/sd.c
> index 762c783156b4..d42c283cbb38 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c

[ ... ]

> @@ -491,22 +507,34 @@ void mlx5_sd_cleanup(struct mlx5_core_dev *dev)
>  {
>  	struct mlx5_sd *sd =3D mlx5_get_sd(dev);
>  	struct mlx5_core_dev *primary, *pos;
> +	struct mlx5_sd *primary_sd;
>  	int i;
> =20
>  	if (!sd)
>  		return;
> =20
> +	mlx5_devcom_comp_lock(sd->devcom);
>  	if (!mlx5_devcom_comp_is_ready(sd->devcom))
> -		goto out;
> +		goto out_unlock;
> =20
>  	primary =3D mlx5_sd_get_primary(dev);
> +	if (!primary)
> +		goto out_unlock;
> +
> +	primary_sd =3D mlx5_get_sd(primary);
> +	if (primary_sd->state !=3D MLX5_SD_STATE_UP)
> +		goto out_unlock;

If the device is unbound during the race window where the devcom component
is ready but the state is still MLX5_SD_STATE_DOWN (for example, just after
sd_register() finishes but before mlx5_sd_init() sets the state to UP), does
this early exit leave the component marked as ready?

Since mlx5_devcom_comp_set_ready(sd->devcom, false) was moved out of
sd_unregister() and into this function, skipping it here means the device w=
ill
unregister and free its struct mlx5_sd while the group is still ready.

Could a concurrent mlx5_sd_init() on another peer acquire the devcom lock,
observe that it is ready, and proceed? If the unregistered device was the
primary, mlx5_get_sd(primary) would return NULL, causing a NULL pointer
dereference at primary_sd->state. If it was a secondary, mlx5_sd_init()
would iterate over primary_sd->secondaries and access the freed device
structure, resulting in a use-after-free.

> +
>  	mlx5_sd_for_each_secondary(i, primary, pos)
>  		sd_cmd_unset_secondary(pos);
>  	sd_cmd_unset_primary(primary);
>  	debugfs_remove_recursive(sd->dfs);

This isn't a regression introduced in this patch, but does storing sd->dfs
locally instead of on the primary device cause debugfs entries to leak?

If a different peer is unbound first, its sd->dfs is NULL, making the call
to debugfs_remove_recursive() a no-op. The cleanup then finishes and marks
the group as unready.

When the original device that created the debugfs directory is later unboun=
d,
it sees the group is no longer ready and skips this block entirely, never
freeing its sd->dfs. Since these files hold pointers to the mlx5_core_dev
structs, accessing them from userspace after the devices are freed could
trigger a use-after-free.

I note this was fixed later in the series by commit "net/mlx5: SD, Keep
multi-pf debugfs entries on primary", but wanted to highlight it here.

> =20
>  	sd_info(primary, "group id %#x, uncombined\n", sd->group_id);
> -out:
> +	primary_sd->state =3D MLX5_SD_STATE_DOWN;
> +	mlx5_devcom_comp_set_ready(sd->devcom, false);
> +out_unlock:
> +	mlx5_devcom_comp_unlock(sd->devcom);
>  	sd_unregister(dev);
>  	sd_cleanup(dev);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260428060111.2210=
86-1-tariqt@nvidia.com?part=3D1
