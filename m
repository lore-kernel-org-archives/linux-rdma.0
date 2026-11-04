Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810622;
	b=gCT3phoFCYUm5XmQuTKc5YaTm4oCwXQ7cHhKmbFJP0Y2pI9pRvfxBJ+QWkbtnulv6Vu7
	 lbebaiwdB81K9te11vD+hRaeGijifVv8sbv+L4M9ir/9tamAB1Joy6hmLoZK4Nxd8E7Cu
	 iqeMo1cV6DwHXNez+nhGV9JZZYNg3kvunfsNhKPisWChpMmAnH9wRlHGYSmx1ljc/IqLX
	 i/muibw1pnmJRWXsKa24UNl+6TtiYssop3m9fa3Bq2NbR42AB95GoGWaWGuYiqsAFkWI+
	 884LpuOjHSevbkxsBfr8qwTsyPzu/AwNsz6ZYUEOMwJpDdLWh5SA2Y7Lyzm5INKS3tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810622;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=uI8UafVD+f5O57g+aLHaWJs9gyRQhCGoeaDEq085KzU=;
	b=VOF8mqRFb4C2z3+VTN4iuj09BYeKtofW7hBKyrPkYwDswuoqTMzZ6vItLB5LnUQmXTe6
	 ranh/lBXnLI/gyqCUMnWN0ANfnDi0+bkNwANHq789uD/7EVUQcbASCDX7GXYTvjSGHz2d
	 nhuCvHt+JDVmfVV4O9APXahhu72g9tatNisvd9LGZ05hW+h/26LrXVSInzBmXEMoC2KVJ
	 7F7GB4fMTQ1nDF3n7flKcCogcrevt2kdEBFbWzWXfxigUe6azmy8pwWpYlgnHcNMKI3Lk
	 wrvZQuBexJoFJJKzhDoYkdtSBNXHDAUT6YyuDElFwBQxgiR39bhV1DJGLVbiE5JdKJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=APb18OKu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133F8606A326
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 16:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=APb18OKu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E271F0093A;
	Wed,  4 Nov 2026 16:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810621;
	bh=uI8UafVD+f5O57g+aLHaWJs9gyRQhCGoeaDEq085KzU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=APb18OKuW5stjEUZvza4stS1YSJaYqI1Y0r+eILpWsglb5ufQRYM0L8mrP+0LOuy9
	 7M1O+6Wu/X4AKf8GBVxmpVbxsnih7oKSIplsrFokkOgnfSF3rHQqGjNbjiRTrvvOmI
	 2mhyBb1Sr7IomxAlPbur/Yf/R4e+eZ1kfVim20gPh7z750bvcHacRdfotaGzxd3kOn
	 JcbaRKQ3CQ3bchdli/8uYkJwtYh4WHgqClnkC6Wrpsi8NNupXCuinXEllYOu+dvEpy
	 JZ9nuY//JpnDZuSz9Nji2WYQGQONv/1Cj5T7sqVY+CbVYqPVYEQhaZE0WqnI1Rqmxx
	 iooUVl3z2mcbQ==
Message-ID: <sashiko-outbox-197655@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 02/23] net/mlx5: Derive adversarial mode from
 CC guest memory encryption
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103163949.1554-3-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-3-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 16:43:41 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Add mlx5_is_adversarial() to report whether the driver treats the NIC
> as untrusted. In a confidential computing guest, the hypervisor and any
> passthrough device are outside the guest's trust boundary, so the mode
> is derived from cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT).
>=20
> This turns adversarial mode on automatically in such guests, without
> any administrator configuration.
>=20
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103163949.1554=
-1-yishaih@nvidia.com?part=3D2

