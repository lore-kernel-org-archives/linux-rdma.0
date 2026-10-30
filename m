Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336025;
	b=OET8RzhSAEyPAYyTPFj9W7/LEv3gYk2tpuJBJEkXUvjcCa+2boUEi0nQ2JWPoDy1tK8I
	 Ixgd4betGDFREG6vkVpWXQnWLYNQuOkB4rupFnMvSTS6QiCp7pNwXvhqpC3QIAK73uJgr
	 CmrVpxrZpYQmOuL4j+xAampM6/Mz4NdlhMplhzKeziZGNoxQtt2ozcV19860e/rIpVzfB
	 1Ay9g/sMnGtUS/5Nf7be9TMNFAaPIlPf1yIwBrcROJZejmw+z/WXtCQsIQL6h3yiopUrI
	 cohAfnMqnLBexk9cODXuaI6VhdfmtPKkA2fPkmzXmCPk7dssr3ZPft+fAnNQ1QnUyMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336025;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0qH+kvDvBlZcdeEiKE1EnKDlqUqZI6HQ/LlPwjTLqmg=;
	b=nFMwEe/wZ+9ajHzjJZ0VGdBsinRg70Sq0C5LY5s/TfZ3aZrUpfAXl+5A0fGucuPvMLAt
	 E4bI7fxWuRnl0v8VSvX9K6yeyQBB+U9uIzyEfHwJYCF6Twv7XErPul1H3TsAslZKJL+3i
	 sI2vDFxbr4ujaXJ04dzAMW9kZrsXB0h3917/i3I2J5kjJEBp7LpB0Ae+BJlfIusUKAG4o
	 R4USOmz2oPat+CDx9Qgz+Vx4+xkpPXxDX3Nnwkg9AM1v7KUxA5XNLBFZU5+6yUA0+ScdT
	 OeasKBdjKlBdF1nHi1Cjd0SCw52CxPpoZCZNU66VFteKCPUW6UdGudwd/ZUul5K5tOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VMKU7dRa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34677606A31E
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VMKU7dRa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05741F000C1;
	Fri, 30 Oct 2026 04:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336025;
	bh=0qH+kvDvBlZcdeEiKE1EnKDlqUqZI6HQ/LlPwjTLqmg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VMKU7dRaUomQn3vHiIQPyM8tLDNE/ENWIV3P56xrDLx6BOk9a9aqp64uRqT+c1j7F
	 slJIylVvFjDhq7NjIbaBRtbxNQ55SeWU0i6yOS7AtEOcrZBhFyBMkVxAz224Sst4xw
	 7c0P/952DASH4vVa77TsJ7UBzvPPcxRkUKdvNH3icbY5GObAIE+Fwt9RVs7f9n6sDS
	 Wyoi7Zh+rSE4FAuVhQ3W5Q11D/kiYOb0vwY4JSXKE5P30HhvZKBumc6vlmI4kuxDVv
	 a/N6+tynS/v2hpOVnR+QJcoEAzGFCJRykSoV2aNEPYR7c0TOoTY8NXeGmG2mePlJuC
	 iYf10AXDligtg==
Message-ID: <sashiko-outbox-190343@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net V4 4/4] net/mlx5e: SD, Fix race condition in
 secondary device probe/remove
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260428060111.221086-5-tariqt@nvidia.com>
References: <20260428060111.221086-5-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:53:44 +0000
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
- [High] Lockless TOCTOU race in `mlx5_sd_get_adev()` leads to Use-After-Fr=
ee and NULL pointer dereference when the primary device is concurrently rem=
oved.
- [Medium] Acquiring `device_lock` on a sibling auxiliary device triggers l=
ockdep recursive locking warnings.
--

commit 9c77a050b30dc8aa500a42a2128a1abf3209674c
Author: Shay Drory <shayd@nvidia.com>

net/mlx5e: SD, Fix race condition in secondary device probe/remove

This commit updates secondary devices to acquire the device lock of the
primary auxiliary device during probe, suspend, resume, and remove
operations. It introduces mlx5_sd_get_adev() and mlx5_sd_put_adev() to
manage this lock ordering and add a second devcom readiness check.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/lib/sd.c
> index 7a1787f15320..a43ae482a679 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c

[ ... ]

> @@ -563,5 +567,18 @@ struct auxiliary_device *mlx5_sd_get_adev(struct mlx=
5_core_dev *dev,
>  	if (dev =3D=3D primary)
>  		return adev;
> =20
> +	device_lock(&primary->priv.adev[idx]->adev.dev);

If mlx5_devcom_comp_is_ready() returned true just before this, but the
secondary thread is preempted before reaching device_lock(), could a
concurrent removal of the primary device cause primary->priv.adev[idx]
to become NULL or freed?

It looks like the removal path (such as mlx5_unregister_device) frees the
mlx5_adev memory and explicitly sets primary->priv.adev[idx] to NULL. If
the secondary thread then resumes, it might dereference a NULL or freed
pointer when attempting to acquire the lock.

Since the second readiness check happens after the device_lock() call, does
this leave a window where memory corruption or a panic can still occur?

Additionally, since the driver core already holds device_lock(&adev->dev)
for the secondary device during callbacks like probe() and remove(), will
acquiring the primary device's lock here trigger a lockdep warning for
possible recursive locking?

Both the primary and secondary auxiliary devices use the same generic lock
class assigned in device_initialize(). While the fixed secondary to primary
ordering avoids an actual deadlock, lockdep might not distinguish between
the two mutexes without explicit lockdep subclassing.

> +	/* In case primary finish removing its adev */
> +	if (!mlx5_devcom_comp_is_ready(sd->devcom)) {
> +		device_unlock(&primary->priv.adev[idx]->adev.dev);
> +		return NULL;
> +	}
>  	return &primary->priv.adev[idx]->adev;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260428060111.2210=
86-1-tariqt@nvidia.com?part=3D4
