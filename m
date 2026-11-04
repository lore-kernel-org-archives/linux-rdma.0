Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793812429;
	b=UJOWw08i0tWPWFvwSSxp+gjkYznl6yvpmtuQWmM3b/0Xmvq1l8ri5Jy7TfQM0/6OpeWr
	 WZd2RzMZZ7k3hmy0cNnNZBDSxDkasFWqmkU0sEpT0ugFM/38+3RhbTXgd4F0r8pxCxrxl
	 6ala5BFpZmh/svql0/hpsw1tVH3CUF8UH7yX0hHsNB4j9J8A2Kt1FwLNo7TA9BRxMqx6M
	 3diDZ3Ps/6ouWA/inSIGLq5CC7WOBbqZQHW5vz48d8UzKacJUjkovZ64Ka5c9BoJkety9
	 infD0nZkMnEyJDwvH1oktXPOeYhAhh02Pa3Bkh4w/DdCw8mVrNdPH9JoyJ+M6c+tzIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793812429;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=uQxxJ4cQvAZJyc6lZsbEcTAblLxQDmIFmAjuXuDUuQw=;
	b=DzGsdwSSFGkF+lZldLOx/h2ljIs3yuq0OlbT1d/RkZzoi9BE/oX8AmO7uGBmAqDMC1Bq
	 TINyzpQh5u7dInreW0gNaF5h0r3rRuTv8fi05q0xp4W/wvNI5N+6aX+Mnvrne8FMX9gg5
	 dhti1mfIpREDnmfW4iuaPjdcDx+k+zXu0qx0Hywdv2Hzvkb2lwOSVjQ+M9X/oqfbjOn4B
	 CAw05ayU1LfiMCxIA69kT4ViQmoeozq5rcFQJbGy1BfiO0tj1p7I37yIUQHu499gUKkth
	 HRs/Kj4UK1C8JGmdwR7VsK+KxxjjF9fKvFiY8cAXZr3i8zcz7Ai3fZkfaTKyl8Go89Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nXEmmV7G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7C3606D807
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 17:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nXEmmV7G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028931F00A16;
	Wed,  4 Nov 2026 17:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793812429;
	bh=uQxxJ4cQvAZJyc6lZsbEcTAblLxQDmIFmAjuXuDUuQw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nXEmmV7GJStLLlMRvtWkMnjiBJDPaV1QqSifDhcDBnSf9ymrlAWHxJhi5LZlhaBmE
	 bc+rjQLqzSiPn5edMwpCqwBcdsf2FbhDyh3VAq2FbX74OR3bKzhFusDhHOOlJfpnaq
	 ypVFu1KVNfbh85xfZrPF8yMjnN8zAcLkaM7Vhhl8Ih3V6v6t0AwOgFfLhFJS6R3iMB
	 gOWP65VLj+Rq1tiH7jZvf3C7NwnfKyKfDzQvKe7VIw1HO6Zj/tTaHtP9dz8Mwddld4
	 aga4N/qRext+OI2wrvbTosUTloZexpPbseg17Pfjs7+lYD+e/I0gxXhGHkHUIjoQK6
	 64r4usWYPheMA==
Message-ID: <sashiko-outbox-197736@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 09/15] net/mlx5: LAG, drop MLX5_MAX_PORTS
 scratch array from device rescan
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103171009.563034-10-tariqt@nvidia.com>
References: <20261103171009.563034-1-tariqt@nvidia.com>
 <20261103171009.563034-10-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 17:13:48 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Shay Drory <shayd@nvidia.com>
>=20
> mlx5_lag_rescan_devices_locked_filter() collected the participating LAG
> members into a fixed-size devs[MLX5_MAX_PORTS] array only to iterate
> over it a second time for the rescan calls. Drop the scratch array and
> re-walk the members directly with mlx5_lag_for_each().
>=20
> This removes another dependency on the compile-time MLX5_MAX_PORTS bound
> with no functional change.
>=20
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103171009.5630=
34-1-tariqt@nvidia.com?part=3D9

