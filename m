Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795013395;
	b=UTtJ4rpv5Y4RQ/l1Nd9cbd+hXHNvW2NFwwlBXhKCnEtN59HRipoo5FQFgPjBsxTLIWdY
	 xxdjm8+ycdhrrvDv8yTOKNwejPA52kcP0EnFl1FAYCla+8AfJ3BHn6FwBaEa6vQogaB+W
	 DG/Z+d2oKKQF8tqe3/mYWQuhm1nf3SmHokAu2RBtdvd8LZqIwgaCHNRHTDSaiFxVKSVOT
	 b5Z4rCVLTRyMCXJ8A3UKwTgPLVp/xt/s+j2FdcHLvB3K6nkEoA9BlYjGOinfEdSl2FsfN
	 xzG/Nwkaubq8Ou+FD0k+Oq8O8XHgyRbhZXRKO9LImnlmUsWlKoGFiKd6L71aUp/XO2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795013395;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=wMWIoLOYWXfZO2U53tHus7HBrSMAyDaE8UunQuNVVoE=;
	b=yvpnf8rj2H1EYDEk9im/Zk4deXBMZXCeIU3cSXLWlIZQkZvwfG36nbAo7yy49BbWkdIh
	 Ikim7x6I/0ocilABOneL0Ts9bq/ZJLMHGHDfxXBRbJcHWKQoDPkS0kilsGGP5R+9F18Cq
	 /hyiWCW3WcDwfEK42fWtGW3SDViS8D0xkpU2V+TSEAerPVKSFzUHg4TGUyYCVtAU1Y2Mg
	 vggVP4Cq7VvBmqPy0ey3vp29T9Dp6DBpBF5Rky9KdC+PocU6yU+XR61I70uG0fBiuYBsk
	 1yUzUuwKssN8S3sMlIiW41WWAwq32cetpL0xjalxIaX/37sy3GIvdWS81FgpO9jhAgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FKWJzlBk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D12606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 14:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FKWJzlBk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20391F000C4;
	Wed, 18 Nov 2026 14:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795013394;
	bh=wMWIoLOYWXfZO2U53tHus7HBrSMAyDaE8UunQuNVVoE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FKWJzlBkaTt5vBSF8Bq1Nc3TujeQU8y4x9O9q5ewmGScW+YmwO5+A1mDn1n5aTVG6
	 vu4qN4yGr75gHZzcEMUoNRjwSFRre0x0BCCjbrtidc9X7nsZlZb6axecjAMHFJ2zGz
	 Q+nqjPN7FxDXNp4Io59LksV64vxFqYj28oWE454CvIPDGQOOEBIccbGzAOJV0UJA8I
	 Jxwer0WVqr4F1UO26uEl0UCJDRb9eB5XOVEXkErq3s/G1OM/Lgy1IKKVQ7HYO2VTUd
	 PWS3oZ1KEOOi4VGwLKHkfA91lqvFzDbBNtmmf+sljIneHoBdQUTiBroLpfsiUwFRDl
	 PXFbB/dnBJhpg==
Message-ID: <sashiko-outbox-221255@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5e: Release FIB event work flows before
 dropping RTNL
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261118143653.1915247-1-tariqt@nvidia.com>
References: <20261118143653.1915247-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 14:49:54 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Gal Pressman <gal@nvidia.com>
>=20
> The FIB event work, neigh update work and the neigh stats work all use
> flow->tmp_list to hold the encap flows they work on, while RTNL is what
> keeps them from using it at the same time.
>=20
> mlx5e_tc_fib_event_work() drops RTNL before it is done with its list.
> A neigh work can then take the same flows while the FIB work is still
> walking them, and the two overwrite each other's list.
>=20
> Release the flow list before dropping RTNL.
>=20
> The issue was hit once in our regression testing (OVS connection
> tracking with the VXLAN endpoint on a VF, KASAN build):
>   BUG: KASAN: stack-out-of-bounds in mlx5e_flow_put+0x23/0x80 [mlx5_core]
> [ ... ]
>=20
> Fixes: 8914add2c9e5 ("net/mlx5e: Handle FIB events to update tunnel endpo=
int device")
> Signed-off-by: Gal Pressman <gal@nvidia.com>
> Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118143653.1915=
247-1-tariqt@nvidia.com?part=3D1

