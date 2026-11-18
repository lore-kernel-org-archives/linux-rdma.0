Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795010656;
	b=DSk4CszQWux2SmDcdpV0QMdnpJLZWPaeVPyuYMThdCn31OyEki1+dp9JXgx0r37+PnUT
	 N4C49zhvLDZuwbgPNG8KLiS3DMK/8Uf7SWnu+71ykvcc7jdgb7tnmDjdK7ee4FsTYhgA0
	 o1yAd2FCAThUSkzCHZ4QjT7yMinICmfiPbelOqxmeoBwkf8Nu4WxqezY211p9fChsn4sM
	 0Dl/OiDKgDR/JsDgPl76XqC8x24l5jp/v81g8fYvnxyQQMdNAQmHzn4JkGoGIKZL6Ugdu
	 Oa7htoxm0VOplFf6Jw45f7QfGmVE6FvxJyM5W9HadgNsFQbAdqMlFmgJAiHGwZkG2SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795010656;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Mqt4IDKhrzkIPe+802FcFTq4JN5YXLl35H4YdSANXcs=;
	b=DdFy4hO0w+9dw0mnZ7AZZoK+cP7UHXkTIV+/V7KGllYokyq7kqUvda2QiYb7J7aOxYRi
	 RWfhCjCIhN3cbOjXvVDW6FnvjRjSEm+TQ/fz7U02bio/S9j1bbkix3AW0vumYVJIxGPnz
	 ESn1/BPUBDBckG/WE92ea2tF6w6TgVK5l9g5G1xkLvpDkScWkpxbMcEpaYUEAg1xc0wNN
	 68o8+rTpE4C4e7BWI9uKOcCAcBxM2WdTO4tfLj1hXTGMkQYgmN9QhihTFuGdnEqwQsB2X
	 1pFOj2oWMj1zA7TVoVEJVRwWaKxVnyUiWAe+QdjizUTcXrV4WPSxp7kXejSSs3vpDuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Clv6A4Xg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD55606A333
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 14:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Clv6A4Xg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB791F000C5;
	Wed, 18 Nov 2026 14:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795010656;
	bh=Mqt4IDKhrzkIPe+802FcFTq4JN5YXLl35H4YdSANXcs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Clv6A4XgaEo2Pwo6CZRbAYB50jNEs7B36g5Jwid2zV4hZnfBsgnkZd+FxBCaVMcQ2
	 /2X0VgxpAcU+ZJTGlI1v1EO+J8zEgna/FcfWDxJlYPTmaf1HjdQS4a5ALXOgvnOwVC
	 VJi/Y7pdywR12LFLRjG7bWesz63x2gFa3J4Peox1d0+yHQumiY7tNoO+PNcSAoKfZp
	 Oh+RNPO/4OP0ofwdwWraimJRkCFrfeiGj4MUx0ZKyaRZ1jaZkUp6TUrDo7dNbVePmG
	 KhLBu7Sz/jx6HFtpdSTtNZQpXJuYl3jxHQVECOekDqgb4MGw4uCCo3oomfJH7nuTRs
	 dEbpohOMNctMQ==
Message-ID: <sashiko-outbox-221132@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 03/11] RDMA/mlx5: Select the PD and SRQ core
 device through the PD
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Srouji" <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117-mlx5-sd-prep-v1-3-8efd124c7895@nvidia.com>
References: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
 <20261117-mlx5-sd-prep-v1-3-8efd124c7895@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 14:04:15 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Akiva Goldberger <agoldberger@nvidia.com>
>=20
> An SRQ is tied to a PD when it is allocated. Use the SRQ's PD to select
> the backend mlx5_core_dev for all SRQ flows that require it.
>=20
> Add helpers pd_to_mdev() and srq_to_mdev() to replace dev->mdev
> references in the SRQ flows, and allocate and free the PD itself on
> the core device pd_to_mdev() returns.
>=20
> Also, enforce a single naming scheme for dev/mdev resolvers in mlx5_ib.
> A resolver is named <resource>_to_mdev() or <resource>_to_dev() after
> the resource it takes, as the helpers renamed in the previous patch
> already are. Where several resource types have to be accepted, as an
> ib_pd and an mlx5_ib_pd are for pd_to_mdev(), the resolver is a
> _Generic() over per-type helpers.
>=20
> No functional change.
>=20
> Signed-off-by: Akiva Goldberger <agoldberger@nvidia.com>
> Reviewed-by: Michael Gur <michaelgur@nvidia.com>
> Signed-off-by: Edward Srouji <edwards@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117-mlx5-sd-pr=
ep-v1-0-8efd124c7895@nvidia.com?part=3D3

