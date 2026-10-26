Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792981229;
	b=j1tT2b+f2d3BGgQnoRkB+18E2x0tpCHO95QC4KOBoP6li/So05fJCOQE1jCF3vfDCrDn
	 zbUxopmx7aaTb5SCkm5z34NgaCoCtiBWYF5p2OinF17HFzUcLVz5ZMulH07bg8jYGm9LH
	 dMlr7TlDP8Kg4v/JX8OEnX1Syf+ZZKXgLZeHQgGatPaUW7+c3Z9V92FJhzTZRl8HzRPdJ
	 efmnhKR3LJ1ZGhsm2iZy2QjGmElhpAOVdVJJP/0Zx78IoTHINm7I+byQxCUW7c1UuQO9M
	 1FvaCdFngY8YVmuQrf17C80Mm0/XDClvzM/QSvgUuTTPtyP2m7LetmcHQA7IzkUiM1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792981229;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=haLXzM0ke6R+wmsJQ7Of1dImWzpo1cfeJdFwqrxPad0=;
	b=dzEcGgZ3xWJT9F6pu1s/Ht+vrLXawDpaDOucM6emG4M4wXFgz4cxrT9VIv+LGl64FZb3
	 qZbWh+eCXGBCX1FFW89y1RIlzBHF4YVjQHdmF7fgDl4efpC2gbnMXlGmSOjJ1K2bTDGfU
	 rYAb0b3LgiwIgCLB+96+IZy81W2fNuXzGcC+Kj9D3g33POrUh4tOd7O6/QMogqOVe8Q0E
	 zsLhQPV5050QXhI21OpxBUtNYFzo8mftdxARX//v/gxIqOW+6TBZxUmOqrVI6YDpu7BhR
	 N+FG9NQlviXKDPd3I4VESasMMoxLTQ+oHyMmUDsl7iAhpzG4PoW3xeJojbPAvqbrszA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EOaiGWij;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C8E606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 02:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EOaiGWij
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31ABD1F031E4;
	Mon, 26 Oct 2026 02:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792981229;
	bh=haLXzM0ke6R+wmsJQ7Of1dImWzpo1cfeJdFwqrxPad0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EOaiGWijAIrYlRtYlxXuBUP4oh+LGjPv0udBTCTN2DtXSfvLs4Qo6+MH6VHToW4ot
	 QxrlYejKGewy/9Wg1y49JwAOr3dnlfQp6IdJb8JCd0GXeTklwajWGJC1cUh/uNKww9
	 GCpSMj5Dn/tEKF7D0506DvlWym1fOcrJqYyGE4DBz6hCnGwfed6tFzQX3+SMhKxdgA
	 A2MwzuhaFgrz45Ue/Msl8LBpHswPbJnzZHjklPukqoO2JxO4P9+wArquXNOMZGyduC
	 5VDXwzWFXD8UyNm2g6ofwT45sLVb+3CxolXHQj4lU7SeQlOPA1buV1aBF+uYLqSNoQ
	 VXQ5ebLgTTznQ==
Message-ID: <sashiko-outbox-184597@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/uverbs: Don't return the shared zero page from
 rdma_umap_fault()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zi Yan" <ziy@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261025-fix-rdma_umap_fault-zero-page-v1-1-186255624f1f@nvidia.com>
References: <20261025-fix-rdma_umap_fault-zero-page-v1-1-186255624f1f@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 02:20:28 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> After disassociation, rdma_umap_fault() returns the shared zero page from
> ->fault for VMAs without VM_WRITE and VM_MAYWRITE. Such VMAs come from
> rdma_user_mmap_io() in drivers that clear VM_MAYWRITE and they are shared
> VM_PFNMAP. A page returned from ->fault is mapped as a normal page and go=
es
> through rmap code. Two issues:
>=20
> 1. shared zero page causes VM_WARN_ONs in rmap code,
>=20
> 2. normal pages in shared VM_PFNMAP VMAs cause accounting leak on arch
>    without pte_special(), namely the page refcount, mapcount, and vm stats
>    are never dropped.
>=20
> Map ufile->disassociate_page for VMAs without VM_WRITE and VM_MAYWRITE,
> with vmf_insert_pfn(). The page lives until ib_uverbs_release_file(), whi=
ch
> cannot run while a VMA holds a reference to the file.
>=20
> Writable VMAs keep returning disassociate_page in vmf->page, thus its
> accounting leak on arch without pte_special() needs a separate fix.
>=20
> Userspace can see two differences after the patch. A mapping without
> VM_WRITE and VM_MAYWRITE now reads what was written through writable
> mappings of the same uverbs file instead of zeroes; after disassociation
> both are dummy data. The first fault now allocates the page and fails with
> VM_FAULT_SIGBUS if the allocation fails, as a write fault already does.
>=20
> Fixes: 67f269b37f9b ("RDMA/ucontext: Fix regression with disassociate")
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261025-fix-rdma_u=
map_fault-zero-page-v1-1-186255624f1f@nvidia.com?part=3D1

