Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456E051DE0A
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 18:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791422; cv=none; b=sLNi9wT7FVKT0hICKeKhkd+7Ze7EbZbn08Umy6RigWXeG/U6S0nC+woVEmOE9YtO5UZTzVIFNKeJZLVqMV/D/EL28z8qmdW8eiO83iCgoIveT5r2SQqCla99IVY1orkHNdnGHPQ5h2YCyC7krDPMId+fms4Ew5wwJ9qJL7Nt85A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791422; c=relaxed/simple;
	bh=I/EGXcIdiqM935b+YmLNA+czuCbrMTZTcy05P7U907g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RLEC74uuI2OcrrsCryG6r8baab5tzoWNklwVJMrknM4jkSGFOM6PuoTtSNmlv4/CbUdjoVkvnZx+Gj2HEAQIz9wF2ZQxzprLA3YJl/e3dIAnIlOc4EJZ4Rqd90DvxKwPKn054WWkaVaYd+ljbENCsal5ojv0bCjbtuXXw3cQa78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FUMlxDV9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FUMlxDV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4301F00898;
	Wed, 30 Sep 2026 18:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790791421;
	bh=I/EGXcIdiqM935b+YmLNA+czuCbrMTZTcy05P7U907g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FUMlxDV9jUbyLZB4DWV6vdEi54nu21/N/73DreOvwomew8OR78ZOeExDisC1kpajk
	 /NQJtsqc9equNdnCSx9DR2LVtpKhF8Nkup8NubkZaBrJXyzvOENZsy91t04YpDfGXa
	 ikR0qkWgOCzIwDPflkSgFnLGTZnOQnhx1VaacrDbbDnY3M1uGV1rZePq+ViDTUpnJ9
	 gvNJwMoIkp1AxeIMi5uJqMt+fqGvVPvq4una3fXTyf0705z3zoYKxbolShqA9o+Bo7
	 BhWNSOQPVedm73VmDf0wfN5QIYuwGzi3aM9p3AdF2xC5RilO9Ni54zw+uGLJ18k8At
	 irp3R/vv/tn/w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/rxe: bound the ODP page index against the umem in
 rxe_check_pagefault()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Youngsung Ahn" <ays511.kr@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260930175145.2491352-1-ays511.kr@gmail.com>
References: <20260930175145.2491352-1-ays511.kr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 18:03:40 +0000
Message-Id: <20260930180341.0C4301F00898@smtp.kernel.org>
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
> Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930175145.2491=
352-1-ays511.kr@gmail.com?part=3D1

