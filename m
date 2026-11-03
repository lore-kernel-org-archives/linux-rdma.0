Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793704343;
	b=IbnmY2AgHsEERMJdQ35doggLgyGted+4aS0fbN0jrSCzk72g6U2ZX4BTJ7jrv2VANK90
	 GLxydH3KMnbfRZ00ttIR6RCEISu6ltHZLQChnLTZeE+omIRRLMq116tBgDeI6rFgsOq9L
	 ZdxQl2VzZ9h2/A9YTiTESCFs/rWeIs7AL4vI04y89WCYLKeAlk+ZO6vvDjpc6GhqHIxyq
	 NXDIYiiCYO1QS0Z2A4DpPZhjOJ4n3F2qsaLyQ/+mdtNP7V16wYs1awF5/igRooRu1jPnZ
	 IXw/xEGYF1Qn3bX3Xy7n0cUCjiIoKY4BsnU2krpfx8oogaf8dbf44VRHfh956ArATJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793704343;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=gsXaHh1ZsicVKDnKNW5k0/VP5zTJ413aiugM0n7w/GU=;
	b=FWAJ9kUUFnWg81/hp/Ts57fv8e4o/X5P6HVj81xR6VHMT/6voX+3BJmwQrdSziJxqF4q
	 LnQBTqUIECLOLFSKmrpFIwzAd+XQh8sqrL2PTUWUWMM/KqEGx4iX2h/FcDJ6x8442IM0z
	 w0K17WC3cJGOzwLVs9uqcvzGuSA8oM5zTD40/RI/Vv+p8dCcxiuXgVnhyvVEdIrCKhAnj
	 F3Eqw13hBGtrGIaqBSuBSC7ZTTUS9QyGaLrNmjtlLmzlQsBz3F6tKRJ/F2CCjWyT9/N3g
	 NVlDZqsL7e69/SHBI1W6UP64y1Zw2r6QNC4ig0Wog8RYvbAsXPn1eD0fCvYhxryNAfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KAdfhyk0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFE5606FAE8;
	Tue,  3 Nov 2026 11:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KAdfhyk0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768DB1F000C1;
	Tue,  3 Nov 2026 11:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793704342;
	bh=gsXaHh1ZsicVKDnKNW5k0/VP5zTJ413aiugM0n7w/GU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KAdfhyk0ZQntPV/zG2QBrNrWlmjaEBkpymkcJNNKyuqgwFkcetfD2CJSUqilPXOM5
	 3bf+XcPeGRR29v2oA4qLGjgh8xc2r6zACnpR1/l1Fm5qDqnbqh0y1gAQmUjZSnKNHB
	 chKLUSnn27ylcWbJWmkhdjzrGynghz9khJ2Rsu1FmzbAu5ajdJRepY89qmsJ7O6EAE
	 HO30VFtUHZ1zDC37KGzqtI7maV+HW/iBxEbMp1ciT4ZYciMC2tRbXX3eCO9QuaJGmS
	 BewD/NKK67KyV0zIeJkHW9n6UDOwUs7FVkJ07MyM8FTaRLJnCkCrR4e6O3gIcGP410
	 nyOv+jaNSCLDQ==
Message-ID: <sashiko-outbox-195122@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 16/19] PCI/P2PDMA: Document TLP-class routing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261103-fix-p2p-acs-v4-0-v12-16-912101f93517@nvidia.com>
References: <20261103-fix-p2p-acs-v4-0-v12-0-912101f93517@nvidia.com>
 <20261103-fix-p2p-acs-v4-0-v12-16-912101f93517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 11:12:22 +0000
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
> The P2PDMA documentation leaves Relaxed Ordering and ATS-translated
> Requests undefined, although routing now depends on their attributes.
>=20
> Describe the three TLP-sensitive ACS controls and the outcomes for each
> class. Clarify that Direct Translated P2P and Relaxed Ordering cannot
> create an internal route between sibling functions when hardware lacks th=
at
> route.
>=20
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103-fix-p2p-ac=
s-v4-0-v12-0-912101f93517@nvidia.com?part=3D16

