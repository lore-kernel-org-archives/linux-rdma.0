Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793704509;
	b=kSwo2rN/1bHP9j+cly6U9V/vjYQ7R294osJRdsO+bPFmy41mp0DnovbPCnWNtKb2HdYI
	 f95B4D0KOYkukgKDbXRFb4hTDkprY9un5Y8p88HPkqypWlCbslIsayFYQICx/jq52nBkA
	 v8WBG17YBBRJ5dSz+BT2xV3DCvdBZh68GpOG4usuhZHIJQHDSxSmpeh4B8cHf5i2/LVfA
	 ViA8j2oR+jBWvrfD374f7a+MRHpzUWbErV/nxlv9mfbmGvgU0fZKn7Ijwje/X4gg2R0kV
	 9I+rVifukK6KYk0koYCgg+hXaccNNPs3/Wk9Wvwst6Rf+3ZHttbxspKiH+yQ6sWVEDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793704509;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=kSyrYHjvvKZimb4YOPQN6fqogyw1h1LsvN3ph4J5nu8=;
	b=t5ytII24aD3MAioC2qYenuhFK9Lcw6MFrXSTmpkclC64Skwf4+drE+8PTV060RxVVPL9
	 PrgJWMgwiCF8LKPFTAIwfmEdoeZFSq0kX4S2XSLkzNpcI2fKljSJoJ4fDMypTxts2td3J
	 nUdy+TQut2u6Y9UE7rLZ+N6BCM60WARvvNo0HuDLH/NyEzWv0wBiz3xbiExQC8uwmb8NV
	 F71SzwLZ988Xz0AGoOoiMPV0vELm0hlgGI6AHe29tmsY3nLTEdXmUgjnsDvGTadwrqEeg
	 fBmIngc7BwD9NvzrOx3DW3KElP4tROTYtK6r2f/O4cXTiKj8H29yIkydmiLaKLVNiaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="oZ6I/6Bl";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1DC606A82A;
	Tue,  3 Nov 2026 11:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oZ6I/6Bl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4AD91F00A27;
	Tue,  3 Nov 2026 11:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793704508;
	bh=kSyrYHjvvKZimb4YOPQN6fqogyw1h1LsvN3ph4J5nu8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oZ6I/6BlI6MkFMvYoBShF0whiCCp/tqSYByvj1hOJTEG0fXkuCH9MblZaUNTnfIvQ
	 a5oBaZtigjxLmYOo7j+/eIhcfH2rlzJ0QcW2vY41ODeqo6hKDpci8eUWOo5dxCb4sS
	 PRCcqqBgC5NplgpXnrBIQ4XJBBC7YKdr/hKFVotVyKj81Z0xLMgKsi3iCrfVMT/4ZZ
	 viPLY1ysP5D3h53e387zjGit48HQ3Vx7dV0Hbuq0o/528ec8SxxbcujLfYuRqG2gKy
	 boZDCCPpLpauFyoEpVgyITNfaLk4TtjwDmgsjGnA8dTPqmwCK9juvYbEriyA9jaGL7
	 XOMVMC7642AYg==
Message-ID: <sashiko-outbox-195129@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 17/19] PCI/P2PDMA: Let a client declare that it
 selects ATS per mapping
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261103-fix-p2p-acs-v4-0-v12-17-912101f93517@nvidia.com>
References: <20261103-fix-p2p-acs-v4-0-v12-0-912101f93517@nvidia.com>
 <20261103-fix-p2p-acs-v4-0-v12-17-912101f93517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 11:15:08 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> The PCIe ATS Enable bit covers the whole device, so P2PDMA cannot tell
> from it whether a client will translate a given address. Most devices
> translate any address once ATS is enabled, but some choose ATS per DMA
> mapping and can still use bus addresses for the rest.
>=20
> Add pcim_p2pdma_set_ats_per_mapping() so the driver of such a device can
> declare that before P2PDMA starts treating clients with ATS enabled as
> translating everything. Keep it in the device's P2PDMA state, which
> already ends with the driver binding.
>=20
> Reviewed-by: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103-fix-p2p-ac=
s-v4-0-v12-0-912101f93517@nvidia.com?part=3D17

