Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A7852CCDD
	for <linux-rdma@vger.kernel.org>; Thu,  1 Oct 2026 15:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790869031; cv=none; b=Cby6+k6z5hRadO8uhZfeX2oJbl/OssVK684F0xgAWsUZCZqaH8elP2qKMWRHBeZb0mnpntur6lch/V1+9MnmIhp017o7JMKx+0DCYPmxP6i/p0IZNfKBQ+kGSb64X7KJGKu5prPeEVqcaD6q0vbGP1xp91MEJMHN9+Ywf/zBrTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790869031; c=relaxed/simple;
	bh=o9zxpCcTN0UKBjQuGStoRMUv8WpzPkpEDkZNeRaajqY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KH9+nicpL+m2GppxHNiBxptSKwTK0eT6l9INizWF4YhycYC16ZHRKCf8R9Vt52yOLKoR5/kGV6u0PlDe/y7ozK8wuzcUhGmwdepdcFoFBj3SuLK1uO4iHl4A9URBmVEguuR055MA8yQZpRRi9qvPJl14uNTUxGABh+xP432LYyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=El8ItSCA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="El8ItSCA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB971F000FF;
	Thu,  1 Oct 2026 15:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790869029;
	bh=o9zxpCcTN0UKBjQuGStoRMUv8WpzPkpEDkZNeRaajqY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=El8ItSCAT+flD9KG3NzfVv5O44crEKTOZ+gOde/hNfPyucPVNdBMDLykuIkb2MkID
	 WBOOt+he3QkcvuCuYwEwPDgPH/h8NN92Ub6gTcOPmuTcVDoCcYAXxvIVCFkdM4RdHH
	 LYYDYjbl9jPZXKluO+n97ASk8hdsTQp454pbx1JpxlSdjGULmpsFX2MXWJnezEgIV4
	 IKEuQf47boaIUNwleSTn6VZFvUsFKTVfnrGsGmPfWwx7moNZRM/N8c1UjKeFlDOFBk
	 REPrEwNkCFb/gxoy4i9kSepBQGS+wEU8xEzIWxMkIUgnaEUQOVmEeYFjnyrnI66+4G
	 fx1xsBsXobsZA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/rxe: bound the ODP page index against the umem
 in rxe_check_pagefault()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Youngsung Ahn" <ays511.kr@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261001152325.3258902-1-ays511.kr@gmail.com>
References: <20260930175145.2491352-1-ays511.kr@gmail.com>
 <20261001152325.3258902-1-ays511.kr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 15:37:09 +0000
Message-Id: <20261001153709.9AB971F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> An ODP MR's page array map.pfn_list[] is sized from the umem's
> start, but rxe_check_pagefault() indexes it with an iova taken
> relative to that start, while the access was range-checked against
> the MR's iova (ibmr.iova). reg_mr only requires start and hca_va to
> share a page offset, so a user can register with hca_va =3D
> start + N*PAGE, and the index skew (hca_va - start) >> PAGE_SHIFT
> then lands out of bounds of pfn_list[], which is read with no bound
> check. An unprivileged local user reaches this with a single RDMA
> operation on a self-connected rxe QP: observed as a KASAN
> slab-out-of-bounds read and, when the out-of-bounds qword looks like
> a writable HMM pfn, a write into an attacker-influenced page.
>=20
> Reject an index that leaves the umem and force the fault path, which
> fails the out-of-range access via the umem range check in
> ib_umem_odp_map_dma_and_lock(). The downstream pfn_list[] users
> (__rxe_odp_mr_copy() and the atomic helpers) run only after a
> successful map, so this check protects them as well.
>=20
> Fixes: 2fae67ab63db ("RDMA/rxe: Add support for Send/Recv/Write/Read with=
 ODP")
> Cc: stable@vger.kernel.org
> Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001152325.3258=
902-1-ays511.kr@gmail.com?part=3D1

