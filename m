Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F59453A3A8
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 14:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175265; cv=none; b=T/jZUZ6uyJvuVMPJcaiZTOsufKb5WAR5uBcG91JumIg0Kh2j+dkdHd7dfdbB/DEj3mgymLTuOeuuovnqIOKPGqYezyD97v82XJHB+hyVsesEb0+Um9Kmrh7yk/xJjhEUy/69qcw+1mtPprDFUxX/3ZHWfT9vMk3OTeRP4lJpFwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175265; c=relaxed/simple;
	bh=yJmFP/AKYhvSsNmyhi535K67WdrnouFaTP0Qc78xUgE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SQiYN6B6rIAM+1jaf7+3QCGUUmNGRvFqLnD1GMEhkU95SsfACWkHB/FfsaqsUd/5OV7q/BJheRZcdFpKG5T0N/FYc4YehMVszFYb1IxUnSig9JwXsQBPXGLDOxQgeVP11ztojm6CWYHZrzZ4Ut0wSpjfLtXu4L4eBe137dt3cKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G5Xv5b94; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G5Xv5b94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1991F00893;
	Wed, 23 Sep 2026 14:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790175264;
	bh=vkCiopIUzkmckgpaq84kCqaE9WGPq9UavtIG8G5g+g4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G5Xv5b94YU0lCeHhOzZTStaZuaoTMpGMg/HaLn+FrSjgwNUqUXtbxg6XEBebR2Z8m
	 /0njcBNH6IPdM1P/IBlYEbh4uFGvbEtarpuau+TM75yEyRWRPXICa4W3Tvmv/mn8jz
	 4oeK2A/ETmeifhClmSRM/jcEsXN2hz9rM4lnH81Q4N6/lFEo2/8oyYcrNNszVioSTn
	 Ul2e+ZKcRXpU1jE8z910iWHVIaw6vFgOLhXNZ+lKyapKwHJ+tEOCfBk9+7KgFyWhCN
	 UN7Jt9utFh4tomHjhiZ8Odfxnew28pBHmWUMZX6zxpRSJ/S6qff1C7fbYuvqLf/R1L
	 20LUWSob9PXJg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/2] RDMA/rxe: Reject prefetch of a non-ODP MR
Reply-To: sashiko-reviews@lists.linux.dev
To: "Norbert Szetei" <norbert@doyensec.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260923-rxe-advise-mr-v3-v3-2-95e1a4077e4d@doyensec.com>
References: <20260923-rxe-advise-mr-v3-v3-0-95e1a4077e4d@doyensec.com>
 <20260923-rxe-advise-mr-v3-v3-2-95e1a4077e4d@doyensec.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 14:54:23 +0000
Message-Id: <20260923145424.2A1991F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Norbert Szetei <norbert@doyensec.com>
>=20
> rxe_ib_advise_mr_prefetch() and rxe_ib_prefetch_sg_list() look up the MR
> by lkey and hand it to rxe_odp_do_pagefault_and_lock() without checking
> that it is an ODP MR. That path runs to_ib_umem_odp() on mr->umem, and
> for a non-ODP MR mr->umem is a plain struct ib_umem from ib_umem_get(),
> so the container_of() in to_ib_umem_odp() lands past the end of the
> object and ib_umem_odp_map_dma_and_lock() reads its ib_umem_odp fields
> out of bounds.
>=20
> lookup_mr() validates the lkey, PD, access and state but not the MR
> type, and IB_UVERBS_ADVISE_MR_ADVICE_PREFETCH is accepted for any MR.
>=20
>  BUG: KASAN: slab-out-of-bounds in ib_umem_odp_map_dma_and_lock+0x884/0x8=
a0
>  Read of size 8 at addr ffff88810a3ebcf0 by task advi/921
> [ ... ]
> prefetch fails with -EINVAL.
>=20
> Fixes: 3576b0df1588 ("RDMA/rxe: Implement synchronous prefetch for ODP MR=
s")
> Cc: stable@vger.kernel.org
> Signed-off-by: Norbert Szetei <norbert@doyensec.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923-rxe-advise=
-mr-v3-v3-0-95e1a4077e4d@doyensec.com?part=3D2

