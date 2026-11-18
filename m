Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794970979;
	b=n3tGs2bVNUZk+vo1Cim3CWqWEtxlDzNsvZ7qizNezw97W6ucwdAm7CGEidYmbl7jx3y8
	 v940xf20TfxmgmOYL2ohLI9gNA0mzQUDwWaoqJSAmvY/IkyMB7LBNkdH9Sh2msp3iZXhd
	 Rkwabd0N6N8Rg0JkN798abHqG8aa+TF94pNhYj38/c2XSLm/Ccj4Snp/i9T7ZeCZh9lw4
	 JMPk/qdkbPITCRNXTa3qK+XFQpB+eBGFI4v9NWg6X8zo7FXjTd7W1eantTCnv3075dl0O
	 /wJ8RhV7MHZprI6ffuwD5nyiBTKHg1FGVjMCVHKZ+IH+Bp/dXY9xRDIoInRxsYarZng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794970979;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=K9HGqnNfm7bxk5iLD1W8H2E9zvYe2lpvm6SmKe/Tjv4=;
	b=FIPV6Rk4YMC0VzRbGEbfy3U1WMmEiM3tlh07LLJplTTIpin+0adySLEy43i3aAcmGAxx
	 ygDU5GlUQCWDENbm2ldBl9aICxektaILkqyOsZr2c67blYhVsTdmrKO5gz6LNcG12DKpV
	 2jlH32q0K8exR9ORh2v8mn5CCIYTpw8pkCZb8bdFXSHQcRUyWB5orAM+lj8Z0Ol0lTGow
	 2fyLJ/fZ5dr7gCuitBLDcOe0w0hmuEKW7aszHYtCLCdlCwOHI4jMQfmX9cF9uyFzP6auk
	 gKGlaLaNbkFwYBShLJLz4E8O2NT7zp+gcCCwHqwX+JM83Th4Cu2u0p9eVSCZ9+dV1gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ICwqTsSW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF90D606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 03:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ICwqTsSW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445181F000C4;
	Wed, 18 Nov 2026 03:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794970979;
	bh=K9HGqnNfm7bxk5iLD1W8H2E9zvYe2lpvm6SmKe/Tjv4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ICwqTsSWtEJNhi48bF7bcS1fclgEPbNDw/kXfbzH4vgeZSpBRKWE7vtOiR8Oh3gDV
	 ML9XVknVQJ42rj5V+YA0jX63RXii5IJofqxgFedM1qOecAvQkG6dfHW7G65Yozswet
	 FsRyHsYCTxBvLc8AStFXCq5irtZ489h/QkU3FA3wKXPsi1G8fx6uWxGsTlyI8AFfm2
	 tuThzo9IZ8Lm4wdCaF1HaiLQ9cZ1DDjIZFSqzp1sqNa637ylPeV+VLkEarublg2CnO
	 MJQ2n0s340XM419g+NQWrz5kW3SrDBnxK99OY98SkNGQT3xORjJwSGkFUj8xIb7xuH
	 4DLEv1VDyDcmA==
Message-ID: <sashiko-outbox-219994@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2] net/mlx5e: kTLS, Simplify error unwind in
 mlx5e_ktls_set_feature_rx()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xuanqiang Luo" <xuanqiang.luo@linux.dev>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261118025846.3377199-1-xuanqiang.luo@linux.dev>
References: <20261118025846.3377199-1-xuanqiang.luo@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 03:02:58 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
>=20
> mlx5e_ktls_set_feature_rx() has become harder to follow: the error
> handling is nested in the conditions and the main flow is conditional.
>=20
> Handle the disable case first, handle the error cases in conditionals,
> and keep the main flow unconditional. Use goto to unlock on the early
> returns.
>=20
> No functional change intended.
>=20
> Suggested-by: Simon Horman <horms@kernel.org>
> Suggested-by: Tariq Toukan <tariqt@nvidia.com>
> Link: https://lore.kernel.org/all/20261029134019.GG257209@horms.kernel.or=
g/
> Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118025846.3377=
199-1-xuanqiang.luo@linux.dev?part=3D1

