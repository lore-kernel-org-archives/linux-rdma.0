Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793009601;
	b=0lILwsB5VSSOHnG0iin7Kkh8RR7M+5sxawGlKFsjUFBob8JHMcP2nqpIuL07XTbEy8Mu
	 NXr3djMusMFR3TA7/RPmE5uats/QdJNRj2IzNd+64vKgLaYuBdIYQERefn6wu6y4ifnld
	 KWGGzNg7afFeRxysdXSbXVIM1eXZdB4XStHX+T5T9Yp7reRKKBk1Lz60zaKv/r66uBHVH
	 fXigBUSVbEXbHRmpyCOofvSGzTZahi91uJOV3GZv/f4QvxkwDiZMV13reAJiLCltAJjNA
	 netO//9MvUAgnib3udtuP+F1G9lKHzKCpaQqSB/6TFZONOMJQtZLHLBLdY5tZZKryrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793009601;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ctP5bPFDX4KIFn3TqZCYF3Jz9juF406IGdKjgARwmBQ=;
	b=uqR4mxlfaM+3hNjjIhMvKYgu+CSOjS/htzZ01Ble4W/YlDInF6TwdBLYvcMFRTktwUVl
	 M9G6B1AW5D3A2gLYBLEraD8xHUvLAXTau9Vp9QryI5TKZdnEGuj55lMcIlEyx1/P7+c8j
	 mVIetGasjGB3sOmo6+Oyf7Rr1T1trtEBQXIOl8pF4uXvpIBsR1VFKKaZq4EaEccVaENrT
	 9t0vPyHlc2gTkO00ou62u4S5HVGs9NodPmG5sldHs0/jMuEhrTpdag4k9BAzk+qhD9ok1
	 JDFT96jyJO90XogSD/eND14l7WZcQqaNVvkPlEP44vUj9xJoacASWnvzu8gdAfmtMEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KhYefhCf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E051606A325
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 10:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KhYefhCf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC66C1F01825;
	Mon, 26 Oct 2026 10:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793009600;
	bh=ctP5bPFDX4KIFn3TqZCYF3Jz9juF406IGdKjgARwmBQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KhYefhCfObNtXcwtU/7YLH3neuCE8nFPFKvgcEkR021crX/xXVyO5lDy3SV2rWbgF
	 BohbGfAkWexza/Zbwxt6p7VoJvuTHPIv23tcomkJg1I7zOx2pov+yROoaO+DR2XZpA
	 58LcbQ4akdt8RemgXeLoFeZZNftaLO9EiYJ5FL/7LpAzUvcRwdicjPVTjpJ80E6wZT
	 wM+S3a0LeQvny6nsPYImpEI6jyxSghR5SotfZQuSIZCoXQrCiymduRkV9Xp3POmmx7
	 7ajuK/01EmFXCN4Pp2LgW9SfkPebWykV6NvHbCAYiZU26bEnveJESUHaTMTvP29Z3A
	 fjVKsV2fZJDiQ==
Message-ID: <sashiko-outbox-184899@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 24/26] treewide: Rename dma_buf_dynamic_attach() to
 dma_buf_sgt_dynamic_attach()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alistair Popple" <apopple@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261026053623.202642-25-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-25-apopple@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 10:13:20 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Jason Gunthorpe <jgg@nvidia.com>
>=20
> This attach function always creates a SGT mapping type importer.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026053623.2026=
42-1-apopple@nvidia.com?part=3D24

