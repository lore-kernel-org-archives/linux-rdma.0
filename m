Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310614E8DF0
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 11:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730194; cv=none; b=ZfV5+ovfpIykMxO4b5tqGE4deGoCyIgESlcHfamvP0xP5mDRMbbjPMFqFnea87YQrMWJosDHk+IVte+v49I/ZyH1xAzJTLFDsDWG5seFlKhXusrbjGSWmTGdmqd1SfKprKS4TpdG9QOaGcQ9yEiIHVRrZ7xX9zaatv9p5zRlD18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730194; c=relaxed/simple;
	bh=HHJuMTRaDB9R4JidtJTpauwse1R/bagqMVyqg2VHa5k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=r17me1Vs9rLrJsxhq3vocoyPq5mvfoLTugzRpjAqz6ZtLiW333mA+06un+/syUGTkTECiQpYjMvjvXiAJ8PhLEkVa0ldQBdpNvIOoy6izfIkI0Pc5SZ4DAKtS5VgvDvVhSh2PPxVaIizKIMcrLvMvD4qZy1Xn/HOTcvHrMB8mm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PY8bE+bj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PY8bE+bj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBAD81F00898;
	Fri, 18 Sep 2026 11:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730193;
	bh=JSZIGaaKJhJHgCMImEcAjNmfOWaWPjWKltSV1BpqGPY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PY8bE+bjb6eWzdztjKm001CnP0igEIjoaYHfEq3aqhIf7tN62QcjsgfqFAJR+t7I4
	 PNZfbYxcDS3fyZVQk1jXPTlEZGwN6hSYipdbzsYSJD06eimsZHQiznEwFkFq2qZIGk
	 wb2XbX0H3tfPSLScHZp0C9USaivO3ruE8xe2Szf9w5gKaUiWs8ZvhEZbMK19VRBrAn
	 LqngO/A3t6oE5ml9gxkJfbGLGgDJqhA85dT0TxIot983RzEV+rGJIukaeZysjJCKRo
	 m8c+D6EdHCmaNE7f0S9vnjZOXtcFrvZYx5yp8zcVlsd5QyAcWeLWzEL28GU8isFZJH
	 Mcr7o9AusDDwA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH mlx5-next 08/10] RDMA/mlx5: Consolidate data direct
 state into one object
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917111422.4054862-9-tariqt@nvidia.com>
References: <20260917111422.4054862-1-tariqt@nvidia.com>
 <20260917111422.4054862-9-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:16:32 +0000
Message-Id: <20260918111632.EBAD81F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> There are three per device data direct objects: mlx5_data_direct_dev,
> mlx5_data_direct_resources and mlx5_data_direct_registration with
> separate allocations. This patch consolidates all of them into the
> registration object.
>=20
> For this, a few things needed to happen:
>=20
> - mlx5_ib_dev keeps a pointer to mlx5_data_direct.
> - mlx5_data_direct_dev is now accessible from mlx5_data_direct.
>   mlx5_data_direct_get_dev() is added as a helper to access
>   the device pointer.
> - Since mlx5_data_direct is part of mlx5_data_direct_registration,
>   getting to the registration is a simple container_of. No need
>   for searching the list.
>=20
> Since mlx5_data_direct_resources no longer has an accurate name,
> this patch renames it.
>=20
> This is a preparation for the upcoming move of data_direct to
> mlx5_core.
>=20
> This patch has no functional changes.
>=20
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917111422.4054=
862-1-tariqt@nvidia.com?part=3D8

