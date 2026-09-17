Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32864BD344;
	Thu, 17 Sep 2026 23:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789689166; cv=none; b=D806er7V8urjcfGktOFmnhIfi1NLD/kLSnjxKs2A2cVjmaIJmCeI7djTZY2ddNbCV9oAHOAxti5SinQq19YXUg4xyQP3y2ao13UCObnvP7AeRc5TcwQNNeTdkVorRnnXq2JsdsW6u78ppY1YHpPQUs0fWBonLc6XtyqNNWBiSYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789689166; c=relaxed/simple;
	bh=4YJpnp99IyQEZnkdmGJ7sebDfI7gOQwlC5LbjRd2FWo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XTV96uuuhCBDznVVOBVfJTZIISehfDFq8YWDf72Bn9UpfE0BnCVfWQkTY90KkIqM/4oL3fFl3Ng/XuuU7tysaQpzXq9TlVpHLuJ9HXa5SBEb+Wzd+YA6VyqnJGncYLcQkbJGqfGaELF5Zpy8UwiPKENMDkpgehfFfff5e5KHd1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kXJN+APo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kXJN+APo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBBC1F000FF;
	Thu, 17 Sep 2026 23:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789689164;
	bh=4YJpnp99IyQEZnkdmGJ7sebDfI7gOQwlC5LbjRd2FWo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kXJN+APo2+ZdhULmbsqK26Dsdymw1M4PgBzBg62tHUOQKIveDCR8rMjP9UyYiREme
	 hf2P6Akq7k8NjwYLzDBffj81lJ4JjYD/lr1OGO0FA/BsuWig4FgkhO6B6d7qCYUnw3
	 RkYZtaSI1z5UpHhLKcPU/icRrWKhrjmBW5Ax0xQ3Qh0dFCE0bPg17kw1gLEOxcy5KJ
	 wmxQZd/m+CduTMEgr5ZEwnd7i1pkv3NUPZCnWQiaUw2kl3WEczkgpburcOc0M/nefW
	 CBFeos/j4VkzQG64ornrSZK0mJ8xDJSiKP/u4FNQFJIhVfGynzXqzXe5au3mLuHYO1
	 vdcATC+McZL7Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 04/10] net/mlx5: Add ONCE and MMIO accessor variants
 to mlx5_ifc_macros.h
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <4-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
References: <4-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 23:52:43 +0000
Message-Id: <20260917235244.3FBBC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Add MLX5_GET_ONCE / MLX5_SET_ONCE which include READ_ONCE/WRITE_ONCE
> semantics for touching ownership bits that hardware may read or write
> at any time. The kernel driver doesn't use the IFC struct for these
> ownership bits, but the VFIO driver will and needs these helpers.
>=20
> Add MLX5_GET_MMIO / MLX5_SET_MMIO for accessing the init seg using
> the IFC offsets. They embed a readl/writel using the IFC struct to
> generate the addressing.
>=20
> Add MLX5_ARRAY_GET64(), the missing counterpart to
> MLX5_ARRAY_SET64().
>=20
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0-v6-8af36cf7b73f+e=
2-mlx5st_jgg@nvidia.com?part=3D4

