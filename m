Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794445029;
	b=YmFn57c40D9xi8BzQYA4R2W+VDjhahMhQSL8f6Qkh/e7TUr7KY5cp9UVtFufsOBj5fKD
	 WvfS03d3mTJ+9sw2Do3W07+wu/kYygu83gQQd0qkhpPskd5Tp1XYyaslV04y4xHiyOf3V
	 FbsltTy33HbmZ/vVvmrpssXp9FAtcwwYpwkYn2Xk8wF1z0fQ6PWRHvVRR4jabAbfoFoSc
	 JaiJg/1TIOPKWClSrIPXxsP2c95Sz69NREb10+WHS95CqQcaEjLV1VcOEuBFaZwcUj2x9
	 td8v/zJi0IjXkS9g3LawdY/LWodtjpf4bhV1XDp6BjgYGuMPSTU69II96t+RON8FzaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794445029;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=nQy6w2WReI0xkks+j5nj8YGdh1gPpoHM8+qvtAaNlgk=;
	b=x9/nT9MnLr8LdWuvwvBoSjZfC+HpmzQ8yANpm23ssrOX70o+Czo8lSfFeZ+2Xfs+c3tt
	 s0Qi1BmgCCIy6144+h1LDRorg9pPkF/2IX3/xfihHdcMF2E9WNTlqXm7vVvm8azNId4CZ
	 Di/5w6aTll1BLcmYYhTW12CzPTF3fibW7BzcAJpWOR/SGa0zUAMJ1oSq3pRZmkRmRU7Rw
	 Eb3VWKXeg2BOudLTWvZrSHeNe0k9+G0c7gH8ut7JEPI10xMdlgzoUy8o1oNQyg5CGif7C
	 BygQBnMBAYFt6CmPz7gYWJJnOnol8JrvBn/jhmzzAFiwMC8ciaYfD4wGRle1dHw6r9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Us/o8Xke";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D358606A883
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 00:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Us/o8Xke
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320B21F00A05;
	Thu, 12 Nov 2026 00:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794445029;
	bh=nQy6w2WReI0xkks+j5nj8YGdh1gPpoHM8+qvtAaNlgk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Us/o8Xke/WRRS9YoD0fQq1x/ky8c0eWsyq3W0E9M1lJQ5x2dE7RXtJCe28nEwA3M6
	 J0fYyWHHQg0k2oTp/XRbMCkWXtS/AuLxvhFIpAJm43bN423OBTPzbYE+Ickh9MAds6
	 A7k8tm9GUv4Qqt86dcXoFdguIE1aD6sA6Uj/mEzhxOnfaa7wNnw6JfmKOlT1OcSfU2
	 w4A7iFnig8m7UGJi3/9nvxUtaNBaaMgZ3cU5MM5JzlPlKvJ6vwSt6Hpoabpdl15tke
	 BS/tFHpJhnfh9C/UMmFQGETFCBvUijEPLfLHNBSvFSs02mfZAajvGdAJCcDP4GouYU
	 WTmW6TfCjPWoA==
Message-ID: <sashiko-outbox-210017@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 14/15] selftests: tc-testing: add tests for
 the psp action
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111005533.6436-15-toddfreed@meta.com>
References: <20261111005533.6436-1-toddfreed@meta.com>
 <20261111005533.6436-15-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:57:08 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Add / replace / delete / flush psp decap actions, check that encap
> without an association, associations which don't exist, and decap with
> an association are rejected, and add flower filters matching on
> psp_spi, psp_ver and psp_dev, out of range psp_ver and psp_dev
> rejected.
>=20
> Creating associations takes the PSP netlink family and a PSP device,
> the drv-net psp.py test covers actions using them.
>=20
> The tests need a tc with the psp action and the flower psp_* keys; they
> skip without it (dependsOn).
>=20
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111005533.6436=
-1-toddfreed@meta.com?part=3D14

