Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795163444;
	b=FpFN/jft1jjNlOOU1I0O0D9FBNPAzmnvGxZISPIdAoAuyc1kgtBbOuLX7uDS6Cp2bXs9
	 TBhPaTQCmW5QUlM9Db/JodkQ+TbUtvGX/qdStvjJvRrKKV9XyKG/hgu66ugR++GdFGv1+
	 G+3TGLEhzyPXDiQbGqdznLkPYV0YwmVjW+ZiYDE7KR5zs9+xhfYNwocj51HiLKW+b+uVz
	 OvRSX0gYcx1+lK8q0RWxM4I6Qd/gRcuTSW5uXPP1yUmc1AIHmpAYV6kP6blEdFCfXJ6ru
	 pqnRQrRza5qz6a3Binc7gNYYi+2MNKGw28GdwEv+qv1yHMLlpCRmsdjj9NbAc1bQ0oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795163444;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9azA+CJb6wGNLKjTNUxbZrhIMGQnKirYpwE0iZVPchQ=;
	b=e2UNL7bYgjPLzYa4epO7uNh7Nzb9rVZINIEa5KhSSyEXRJezSvgS0XIxmHcFs7QPcmH8
	 Is2wrzkylpp3qMBQ8NyLSRymz4PHa2YmzixSUaEPLjkcsI11sGbRu+AGIzU7DYv6REDGS
	 jrCCO6ZsM0nC8+ljzvTlB7rjhJp/UtHshK2yqBi5KpKTUDzD1HcWrN0KJQJb2I68/DCKZ
	 8v0titsSPNSyH0WshOpRM2rm2u7gqCpEVAqvKS2U51E0zyAulgbweDYadEIgHRiGT6367
	 F0p2Xz5xz1s/Y9wCKKYT9+30SfFrnjTx80ZfxBQatxg/B6M1bE+NW5KiCM4j19/YDbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JKcZm60a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C95C606A32A
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 08:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JKcZm60a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D2D1F000CF;
	Fri, 20 Nov 2026 08:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795163444;
	bh=9azA+CJb6wGNLKjTNUxbZrhIMGQnKirYpwE0iZVPchQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JKcZm60aIBG3J4jFdi3ViAFHMaQKcy0WzII+bho59NXKbU7/P+Obe+x5s3PYnVETn
	 Tmt7CP+7XU+YB2thZbjI7zBLeo2LBbjp3SJuxu8m7gzDFfkhUMSOa5mYtYL2bg7yy6
	 is3/PwsittRv+8wdXzYDMT3d4qsENBIV4YlFqSUrn231NU4A3172b5I5jFsrN+n3nH
	 41nf+G2HTMaskcXXHxJVRak6Ub3J+lX48mKDxbaH22M0UD9SFvIzqplkYiUvRHWcWO
	 Xa/LVptzPszl7RnraIrhBvlMJujSXBqleN91PYq83ALyVDzZmJk3iL/0kH8uweagpK
	 7rJQ6u14u1T2A==
Message-ID: <sashiko-outbox-224737@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 2/2] net/mlx5: Declare no DMA segment boundary
 for data direct device
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261120081819.2538191-3-tariqt@nvidia.com>
References: <20261120081819.2538191-1-tariqt@nvidia.com>
 <20261120081819.2538191-3-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 08:30:43 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Yishai Hadas <yishaih@nvidia.com>
>=20
> The PCI core initialises every PCI device with a DMA segment boundary
> mask of 0xffffffff in pci_device_add(), which forbids any segment from
> crossing a 4GB-aligned address regardless of its length. The data direct
> device raises the default maximum segment size to 2GB but keeps that
> boundary, although it has no such limitation.
>=20
> Declare that explicitly, in line with mlx5_core, to avoid a mismatch
> between the declared constraints and the hardware capabilities.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120081819.2538=
191-1-tariqt@nvidia.com?part=3D2

