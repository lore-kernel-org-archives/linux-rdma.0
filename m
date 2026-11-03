Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793694228;
	b=atwUiILTZGSKxPd2EafBxeo25DzZ7wDACn7Y/LWUrW7YVmdS7G+bIPSryQ+HvUHx6tdP
	 8ehs9a87xkW6hvAypYeg1a8neZgVl5tcy07G7urbCO+/KgIl3958/LfNf4l7ubJ4vGVao
	 olHGFk6PReuxTACghQhedejNd+BYrMimA36khBcikVIIS8LUdJ0EP4sEHOD9VhLvFPZfM
	 UYmzPpGmY4ub2BrJkHUDEDiV2HZDuAywfBpz6M6za37VjS+5HzEWIAl9UcBkfdi2O7AL4
	 onwkzWIdOIc+hvujw8wCHFVyW3+DIEENwAKBnYDdXMuo5G81tBeoO9/xkHVhyEAfULw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793694228;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=UGq4qwUbUCz6tWuKs9lMIUkymO4AU0+Tysfvnyj8lZY=;
	b=JyU6VuBIsYNKvUvlEPmkGNwzVpuofZ7X+7pu3rphS85FTl8ldKdOkBOfO8yrj1/qWpOK
	 PmXNhQOjsBx4AuMB02WpuzjlJVvId8b77sJELrXPBCY2l1zRKK5n6wtJwO3YaUBKHwJSD
	 EeCRK6sXJwjfBvRaPJ9eOzjqL9CtRufr6t3N83Pk6VUPFEQZfzDsWFj2Qudq7Wsl9CcvI
	 3FQfX5BzyDQFhTlP1bZ3mH5sejOX0EnRj+RfJHVLLW6ppPMGBcZAtnYp91e4jkTr79bna
	 X72vxiNRxCF1MVv9/mXqlG6vY1QIhmFKhGoLUFMnKiWwa513I+KSPos9V3Hh/vgKosA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Eb5/JCwe";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF919606A33A
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 08:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Eb5/JCwe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C321F00A20;
	Tue,  3 Nov 2026 08:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694227;
	bh=UGq4qwUbUCz6tWuKs9lMIUkymO4AU0+Tysfvnyj8lZY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Eb5/JCweBnO1OVs5xb6XHj9CRqiiR4z1vSw3YHgdzEwRxg5ddHWdZdDZCdXiIFjxg
	 vPJvOFSmMiXZlY8lum1rLB4hpJw9ylhuho3SoYAw9Is5Ls4qyJKPl9v4PgKyow3Yo0
	 Hu9/YuHDRHJgO858aCLAucMnLP8XRtWDTFxivSYWPPIRonr4UajqToGUonvwnIIffS
	 LYt9dSPDnXMiMMx15jcUcZaizsfW9Gr+alr4IGGTJlKI0W6GwqnhfeE+bSy2zdIP/B
	 n3L5UET/A0aJLpM/XaBeKqt6Jd7j+ifl4AXVbABkcQY6dMG57UiSPsTbfSiIgfqs4Z
	 wu+AL7eyurT1A==
Message-ID: <sashiko-outbox-194821@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/qedr: Release user memory on MR registration
 failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wentao Liang" <vulab@iscas.ac.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103081615.1143267-1-vulab@iscas.ac.cn>
References: <20261103081615.1143267-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 08:23:46 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> qedr_reg_user_mr() acquires user memory before initializing the PBL and
> allocating and registering a hardware TID. The error paths after that
> acquisition release the MR storage and PBL resources, but skip
> ib_umem_release(), leaving the user pages pinned and DMA mapped.
>=20
> Release the umem at err1, which is reached after a successful acquisition.
> The failure path of ib_umem_get_va() still jumps directly to err0 and
> never passes its error pointer to ib_umem_release().
>=20
> Fixes: e0290cce6ac0 ("qedr: Add support for memory registeration verbs")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103081615.1143=
267-1-vulab@iscas.ac.cn?part=3D1

