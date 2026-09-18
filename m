Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9004E77FD
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 11:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730192; cv=none; b=uHMFjd7lNstz1uIHJmxrOYO8dz7WlmG9kjZQOJUpZkKDX5l4/mFzewAKZuY2gReUZjJgeNKtdNB6nF3Nq8YXPeueV/I2fzgwjwHrv1KDOp+MV7nWJ1j8uZS/SU3tKLYfAgUlOfMcvGOAEdIHHj8aSpGF67UF+Oc+9kXYTewYBb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730192; c=relaxed/simple;
	bh=/7Uh6l+sae24lh/Q/MdscB9eBibS5I7PeOiSnCaAbS4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=J+CbfxxXUV6QQRnLBQR8NcorENh5RjVyaCxs3fX7zOl+WxJ1fvcGBKIqGvbvkP4mmSZXbkaymc03u0Q4YfCZzd3xfVDO9Xq8X62rPqPhXXC0U0zneswohwz9S8+EiLuJ5HGEH2MjAN2LpqGodTKrMS/Y3JbMbX1W+nUj6PO1DsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LXW+CuT7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LXW+CuT7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2671F00898;
	Fri, 18 Sep 2026 11:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730190;
	bh=/7Uh6l+sae24lh/Q/MdscB9eBibS5I7PeOiSnCaAbS4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LXW+CuT7AmExnoqgMlIgxY2r4JMkba22IRJh75sAJeoygWnzOfQUpZO9U8FYAyh5a
	 V440APOYrAxwGU62nbZPoIyOYQzM/6PIXxTQBSbUy7MDtjBQNqNIns45lm03kMIeQy
	 sRsJN4OZbnEIA7fu3rpGh3zxcRxQEj8EWaYQP8qLob44L2PDvuFnqLTdrjv3VROuxN
	 rEeom9Mx6QKnvI4/J0pF6BgwkkWSjLZfq+kBcPlfFWvhf2noGjAISFz42rniiAwPRo
	 5qYwDrlpx8RFuVfXPx/mAdRBdrpmW8clf3U1GFfBTe7EfrTWCsAzEgiHZbBFKoG+EY
	 FG+W2s8gHeuzQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH mlx5-next 04/10] RDMA/mlx5: Give the data direct PCI
 driver a proper name
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917111422.4054862-5-tariqt@nvidia.com>
References: <20260917111422.4054862-1-tariqt@nvidia.com>
 <20260917111422.4054862-5-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:16:29 +0000
Message-Id: <20260918111630.4A2671F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Dragos Tatulea <dtatulea@nvidia.com>
>=20
> The data direct PCI driver uses KBUILD_MODNAME as its driver name,
> which resolves to "mlx5_ib". This is misleading (the driver binds
> the data direct PCIe function, not an IB device) and would silently
> change to "mlx5_core" when the driver is relocated there.
>=20
> Name the driver explicitly "mlx5_dd".
>=20
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917111422.4054=
862-1-tariqt@nvidia.com?part=3D4

