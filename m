Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795001765;
	b=JUrrppY0eOMiNTrXG/CUUBDhNUwINKh/RG/PBlXHVsPgj2EXytkdF3Mwn5BebcQVVzwG
	 otbEXncBGTVnu8x/yEFyjva3ozvad2hs3PHmDAgIJaZXLxHRJyZGzQAw3vtWPjsTRtxln
	 G3OILsTZzSBJK3CtoWMOBFN272Ig1mwZWw4wcAJYRYZXvUZbPLYA68KTD7ckZwtc64ey6
	 l6OSuP0J1rr4o8PPV9mCZdLhePrd7wFtfyDukXDrExaQLGRcEH28KLiPD0AyzWKfKrtog
	 Ouq4ZfiYYpH/WHuawBpfHOZ7AQeQktgFzPqsKsDawTYn5hUjY4SBgUVyLcrnFO++e4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795001765;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=kL+ltwoRYDod2TVqQCsenDgzrOs6pRfiJMw6WMH2x64=;
	b=VZ/izlG8drYrVex02RFbyaSLV4XhrbLbcUZx5Q/bSQx4dz7JVbw/fIsux6Eb7DYrkWzd
	 vH22BGolbMDLIVIVkf5cknPWsTyigAMHcQiAS/P00PoieeQNueqVoCTv18ZUuzy4rrNRP
	 zf5ZI6k2ICmkEa8lFzNTMZY2ABJltLRWyU8Y2s4gFbwArUC5mp4Fmc0e4DfkIzE1DASKH
	 JzN7KJWMOfMgcXAiIUj9Dswk9S1Xe0ucDumWt6gr9mIQC8uJ00RhuBKC0siQf1GBzVnCD
	 Yfp7spIEnExcs+jL1n88PUEH/HWNRyq7hyL7dOe+g/R7QNGq3ZbWfPJaTcNq5/c3feQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jOFMiqYm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F74606A32A
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 11:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jOFMiqYm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D663C1F000C4;
	Wed, 18 Nov 2026 11:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795001765;
	bh=kL+ltwoRYDod2TVqQCsenDgzrOs6pRfiJMw6WMH2x64=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jOFMiqYmdDsZ85chnRS7HiohtF2MiMmjmbwC+62nfTe2M1k7sbrDHIG2hNF0Z5pZq
	 mMQ0jQe63Yq1bPtT0U0XCiYZEp9xmW9t19YbJAL59Hf0iqPgCWT/d4mvibGkVPm3Nc
	 /g5QS73sodhBDeuogrlVrK8Dy7ptAiEvL/bTz7YJ/BSGUOxDTTaylGijVfiD/X7aK0
	 TChNv6z5w6QcPNQs9/jVg9CFwsdoVtAUm3k24WbXuwIp1mtIU5/qKiRofc3B86ff9L
	 e1cu9z6eQ+DHZjurcGNeng10ExEasxdaKA20eycAEO6owQtkHyRuKulf3pHVyUpq6A
	 tRCqFKSW3WP5Q==
Message-ID: <sashiko-outbox-220829@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC 3/4] RDMA/core: Add ib_dma_buf_dynamic_attach()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anuj Gupta" <anuj20.g@samsung.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261118103327.1788667-4-anuj20.g@samsung.com>
References: <20261118103327.1788667-1-anuj20.g@samsung.com>
 <CGME20261118103455epcas5p22384b4ed044dbf65efe94d6a910e4325@epcas5p2.samsung.com>
 <20261118103327.1788667-4-anuj20.g@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 11:36:04 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> ULPs must not use the DMA device of an ib_device directly, but a ULP
> importing a dma-buf has to attach it to that device.
>=20
> Add a helper that attaches a dma-buf to the DMA device of an ib_device.
> Devices using virtual DMA, such as rxe and siw, have no DMA device and
> are rejected with -EOPNOTSUPP.
>=20
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118103327.1788=
667-1-anuj20.g@samsung.com?part=3D3

