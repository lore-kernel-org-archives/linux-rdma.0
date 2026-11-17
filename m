Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794932176;
	b=x9MV6PKdlbTxgDB5OUfX3pzEpBDekoTPb06ZNqyZkK1ozgt18zV4DqHc4SMGhOWHO8jv
	 ufYi7OsITnB4OtcPkk8u9vX1KjqlBvVR5Uc74PFVIimbHG5Naui7hfRAicYrAztKNxB2b
	 asvYGKl4ApeSb+LUnu8HhzONq/gJp/csUIk6Zm0S1TDxPZTQfdXZ+6gqUkXsQPd8Wvae0
	 HY77eWBaClkBAPM3E2XO6z0QrHa58xcXIU/azaAmd2SauR1kF4/dvrrwzLS7NUdLBdBjg
	 H5MvUSHGTp1QJEbOaB/l3xInWkXwVldvOKLsMzPauCQtgdzRIdxfL6Jb1G5WHosXCWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794932176;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=XJIpSlrcSw4/DATVT2Pci+/JSpoMR8aOJK/sjGG0dgc=;
	b=BqXaNHWD96ARqVrK29GCPSTq0pjNtPGjPZbutzFWJ07tuT8y+XGr/yoV2wu8bAODnCah
	 uLE7xIXEF60JKv57AxdrD+/H9qkU+dFbWaUZNNem38lkelgXveB4RLnBav+EAnOVn0B94
	 /yOpa5OaZXm8N8Ex0BMbjcXZkiiF22D7hI9AozKq3cw8tASFmOiOdyXB6vRP/Xt2CUcIa
	 M3huvuQrSkjOWTsnOgqRxW/qmwSnlHinxhOSRKXRxtSCeDqV2C8g7aR/EH9OZ99BFWQ2A
	 GxHetUK0X2dUOA8u94z1LCEJI8YDvR1NG8wAs7tislBRU+Z81k1hj2gyO8sn2L6s0FA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="m/LmYuZ/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2113606A32C
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 16:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m/LmYuZ/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8674E1F000C5;
	Tue, 17 Nov 2026 16:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794932176;
	bh=XJIpSlrcSw4/DATVT2Pci+/JSpoMR8aOJK/sjGG0dgc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=m/LmYuZ/QmhIpFWlo2KiiMqTEbotxzBWdPNV0kB9NM3+zY9MX5jOPmHWSHT0eWKYu
	 OwYu+euicM0AtljEJ3Dg/XKwLdJjsAA722ChZ/qNPOZTmQ9IQVnn9gD6NTeuZUQi+A
	 Q8BShi2BBlCf54ih5LvSvLUX81HL2rUCtilI9YDVDAU7D91zDANTFL4Bem19kV70mj
	 p92/15GYwOTNE59p1/9frjztcfB/jthMQgUz72MxIIcB5LogdAxGPBhbu+O0+QYXXv
	 XK6mIog/627qDMDCLdVxrrF7/X7fKYn/GEcCc0XXIk12z8tUuT6eKT8WMC+lqwIPm9
	 mSgmGb0MLK1Zw==
Message-ID: <sashiko-outbox-219148@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 1/5] net/mlx4: factor VLAN parsing into
 mlx4_en_prep_vlan()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Joe Damato" <joe@dama.to>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117155353.2250540-2-joe@dama.to>
References: <20261117155353.2250540-1-joe@dama.to>
 <20261117155353.2250540-2-joe@dama.to>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 16:16:16 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Extract the code which converts an skb VLAN tag into WQE fields into a
> small helper. This helper will be used by a follow-up series implementing
> software USO, to avoid code duplication.
>=20
> Signed-off-by: Joe Damato <joe@dama.to>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117155353.2250=
540-1-joe@dama.to?part=3D1

