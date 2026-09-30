Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678934A263E
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 11:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790769364; cv=none; b=R9NXVpxBbItznzrcCyRsEjx+Vsi4dmziuSgnIXqEtPYpIYj1qUa9FJ/n5tdUgF5QJ2Z5ktBxRCIVc5sAdVoppMWd+eoax2CgulbugLN7wfjwKnl4m5TNQ7TFEEQLhzxQq0GYzI9qVhvWluIM46hrU2qdQQerAad1OyYLC72LCaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790769364; c=relaxed/simple;
	bh=BsxtoZWoXIyZJazyb5WelxUnBImDHL12lTAZU8VUdJw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YwD2BvcI+zmzRKsdL6WwLFKQNwuPTowutl0hkdwUFwJX2LobeeTot4pG5Vj0lBasplU9ykHKQwmDQY11YJbp0tUGDCxEDqldBYQ78NRWDR8N0Sv5JMpY/4upWb75Xe5K60XJCSIObntFo35vq30nFWxT6xV2BGZuv1+3p0wQRFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PEWdPNSY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PEWdPNSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB7F1F00898;
	Wed, 30 Sep 2026 11:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790769363;
	bh=dOB8qQoHrL0xFXJbP/8wakrsRIF6lwAXW5GxXNrpssg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PEWdPNSYxE821FBW50JNSWCXCX2RG5FfGAcWvVJ7ai2QBnmH9UhNN5dolLngK/YmC
	 P/bJxUgAZOE9JPXzHE0YkVBG7424pP1veedlam3jquocuD+v7Xf6lMKCXU8wQEHlNT
	 RvJyiMZDpLoFeeZ5NSkllNdJZzXFNOKNUezYU+APD885V4RxsbgZfzBXXV5Z/AkjCE
	 ChP8fDzm8CPdn1AVsmSfoX+ITy4YVAYjTUSuS8bHMmvlhgzWOZr3vqEMilnTbQygGv
	 JSApz9JqB1J/qfaokvrJ8cFGcxyUHDpTc5dx2Uma/eciMANsKBEZ2+mDvzazOhBPUe
	 DASgYePu6lxgQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH mlx5-next V2 08/10] RDMA/mlx5: Consolidate data direct
 state into one object
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260930114227.139274-9-tariqt@nvidia.com>
References: <20260930114227.139274-1-tariqt@nvidia.com>
 <20260930114227.139274-9-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 11:56:02 +0000
Message-Id: <20260930115603.2FB7F1F00898@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930114227.1392=
74-1-tariqt@nvidia.com?part=3D8

