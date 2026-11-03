Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793696528;
	b=h/1Ak1mIksKe7EauuJef0VOTBKNW68n88uKA1m9ka9UX+4ymB8ZBnuyIw8s4l1MIV3ku
	 U+WSnmVu8E/te1M+7lWT4GlfVFbOK32cO4RQjBWI51HjMRBBzC7kWwYH5pnrD/hrV20M/
	 slM1i2MN2IAVM1RwvxaA+WdDK5Y/Z/WP6v6wg5R7zdkCfPPI0zzQXRzHNUZWGsycp2ROF
	 9bysa4TNxi+szQQnKrtelcdCJzpDmrF4162RPE28SFh9+/q9FF2kWwFKcAfqK3qCBieOV
	 PSdD58JPZZYjGRoQZswwJFs12TJ/33iafRKcaXseIL2EHUofxL1oStSNbo1qzfYgq4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793696528;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jsJ7sW1KC3tBNSorCngbp70ttoW2hVFVPEq47Vp31e0=;
	b=ZN2Qn5ko8wC9JltPQnEuTWeqhb6vjDdO/LnMR4jYdNTepZUbm1/dTSBdLvmD/V/5A8hy
	 ulg0iF7o63EWcx/C/81XFvG1K2Fy165sIiUqiWd0PZ/KMDfIvrgBawMYY8Px3x7iES8sZ
	 4+BAIWQ+JWyFi0XK+MODztEHJfUhF8hkikBOW/P1ZcqROEAdGYbcomnt//HHCdWxr2TDt
	 4roJJC5RlkFbX8tThKdFHQ69L3aDcaXAVR+73M6SknwsvYt8GRuN/QWBA8xWDSQPawMIS
	 vaEMV7uDK3Kmj5ojSrDxoewojPs4nO+uVsSQnsOtZhXI0g05NkefM1RLp5yZ2Nm7j9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OmnsIqDy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021DB606A332;
	Tue,  3 Nov 2026 09:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OmnsIqDy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7525E1F00919;
	Tue,  3 Nov 2026 09:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793696527;
	bh=jsJ7sW1KC3tBNSorCngbp70ttoW2hVFVPEq47Vp31e0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OmnsIqDyj8Q1ATyHbCtWMwpt6GNAipQ0nNPEfwcR9BI1u3rvFsoPw11uzUvgOLvA7
	 Az60Np7gmuBJV13144GqU76hKG+GHuZpgm91QN1jbqhXlJYTqZAPkxYHMCWMBj3rQd
	 5TgHxInJozerVGm7r6aphmCP9E9C5CwCzX0C4bpMM3NAMJWfhANBPw8A9ubcbNuLfa
	 52weTjgJzbhXphce6wxD0z7wsSuQpTSB8Yi0Kt/7V1qdCidnyLrwBzjDdjG6cryCvL
	 XZVTWs6xK+KEKxbEY78NwJasHciMlsd4y1tBWdvXxZObYaHAsmgXn10q9KruoUSRVQ
	 qP3z48NzIru/g==
Message-ID: <sashiko-outbox-194913@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 03/19] PCI/P2PDMA: Derive routing from directional
 ACS controls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261103-fix-p2p-acs-v4-0-v12-3-912101f93517@nvidia.com>
References: <20261103-fix-p2p-acs-v4-0-v12-0-912101f93517@nvidia.com>
 <20261103-fix-p2p-acs-v4-0-v12-3-912101f93517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 09:02:07 +0000
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
> pci_bridge_has_acs_redir() treats Request and Completion Redirect as
> interchangeable. On asymmetric fabrics, a control for only the reverse TLP
> direction can unnecessarily force P2PDMA through the host bridge.
>=20
> Evaluate Request Redirect for the Requester's Requests and Completion
> Redirect for the Completer's read Completions. Continue treating enabled
> Egress Control conservatively as a Request redirect.
>=20
> Fixes: 52916982af48 ("PCI/P2PDMA: Support peer-to-peer memory")
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103-fix-p2p-ac=
s-v4-0-v12-0-912101f93517@nvidia.com?part=3D3

