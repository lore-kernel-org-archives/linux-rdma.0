Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793812432;
	b=XZctSKzYXC/A0dOUo+x5Yf2XwBcqOvxvt2VPQU9YSG2k3f/4C7qB7y10fv3YoBx39GMY
	 9uEFAHqzfrTdCucqjMsw4HgQSuooyh8XkSjLbSG+bbRzV4XKx2U8B6hWDjHFyFWaUwFRM
	 rQwsC9GcPIXv6gRH50IBZRxfkAPm5UmzHpV4MhtfO+Sze1GDCOqmcEW6YRUy40HV8tThr
	 pMVE6Mnk7lVyKX2dj6giRmZCdCYEUTDX/QkL39kufgyQWGkkDzlXFdblpX6plI7Ag2Orj
	 K5A6ANR6n5HDfHc1QFyCYAle7A0S0ZWyHGut4pN5mx7ZLegFX5Yvkhp76wO2yRt+Srw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793812432;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=k8AOw2s7iNaNuSft5Peqi7cGAeI5/eN7pqDNUSyb1MA=;
	b=KdT32k3clDNXTCOn7loBrZk6QPK777Y131aJ2XOCb5bDMFQxpOoYqIyo74u6dSvtBJj+
	 a/x1x0vGKEoAUoBLnT0jUa6WGLrhuMzNMeP3mwj9wEnRNGc3CKYqc3xMGt+56YHB4u30D
	 aAM7/5p/whoQVUb1G5wF8nS2ZgjCAFy2okbsUAmJOlTsM2CTGLm4YezA1hi7EtGGKxKij
	 Gbut/OCUwZ3rblJRDvqeSFDHwU/imKrqttv+ZtypgxMrYjO5a7CpJCggWNCdXxR2iuaQv
	 1Xvik2nYjhwPpSoYZSbZ4IkXmjmGdgFzfhHuLtFzq0i2OsGn/9AGaicqqrLESD+RQUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QXLWs5xN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22ED606D803
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 17:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QXLWs5xN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0941F00A16;
	Wed,  4 Nov 2026 17:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793812431;
	bh=k8AOw2s7iNaNuSft5Peqi7cGAeI5/eN7pqDNUSyb1MA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QXLWs5xNcDCEabSf+ZNfyO2xe3mT7hE5DdBtQeNbSsUgaolR7WSchTtXSO6Syn50b
	 G82t6eRQqUkvXh50bRfYIRdAn7oRGVkSsyY7cANmruZIvUaAJxKxj8T0NS2ZEGwrQO
	 O16h9+25mgFYvg++wmhhAR7/GHYcA2LSy8v7fwhE8G7R5IL3z6D22AzCfhv+RGEPV1
	 d/M2szhU0QqlApyAKOfVt+0jEgJ/GL8mJRmCfT5O1Q79OfWJRMLRVSNCNbYIgoqIHJ
	 +OdRxZzM0I5U5n5W5vnEsGySs5f0xZV0mXsaIWFiY0gM7/vH7XIFoGwDp3rZXgcKHD
	 GSIA4HIsikgfA==
Message-ID: <sashiko-outbox-197740@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 13/15] net/mlx5: E-switch, drop master egress
 rule under a SW vport LAG
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103171009.563034-14-tariqt@nvidia.com>
References: <20261103171009.563034-1-tariqt@nvidia.com>
 <20261103171009.563034-14-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 17:13:51 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Shay Drory <shayd@nvidia.com>
>=20
> VPORT_LAG steers all traffic of a LAG slave to the LAG master. The
> eswitch master egress rule does the opposite direction: it bounces
> traffic that reached the master's manager vport into the slave eswitch.
> With a FW vport LAG the FW steers that bounced packet to the LAG master,
> so the two coexist.
>=20
> The software vport LAG emulation cannot. It is a catch-all rule in the
> slave eswitch's egress ACL that forwards to the master's manager vport,
> while the master egress rule redirects the packet after the FDB - past
> the point where the slave egress rule is evaluated - so the bounced
> packet never reaches it.
>=20
> The two therefore cannot coexist: drop the master egress rule when the
> [ ... ]
>=20
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103171009.5630=
34-1-tariqt@nvidia.com?part=3D13

