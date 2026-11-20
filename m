Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795155003;
	b=nieb0dgoZMjpmysuJpAeo0NfwSW6mxeHsx+ENS/bD8QAtiyQ3fi0PjMXtfJu+4npv5VZ
	 dHH421UjhLU2E4S573Y2xv/ZubM8b26JOhGvKZaqv0TZ+e20vLHlwNe3BOyChe0SQIUc/
	 gaeD+T0/Xtfmc8ZDlvDhWJUVaQg7OLRZucrasxX6aZ02yFbV28H7tFPX+i8Hq3E1q7+no
	 /FR6mhCs+16a1fhitNDY6usOYwCMudkU8scGXDUuASi7yCED4Iszzya88P+YRaOq7Wfu5
	 kkchbqO5diHX2AnY8d8s0zZxMQx+NRoaKnjRNPDBTg5xgUnf6Ypg5ipB2Kk40qIG2mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795155003;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=anWx0nR3OcgLoHvHZkSELvtCw30VVF0D46s6K2HkQLk=;
	b=jhj8elk4OMVC5gvfFWx1yMMv9nFGB7/GsNkCGnRjMox0fU6FH6J2k1bTm8hvd4rfCGP/
	 o6Pce0TwGUf2qdoToA/MQlpLgknYwTOMsEOO/C7Tjh6Ez6gLvYW3XziFgUs9YXpQtEm21
	 +Xqk+9rueQgPhBMC0z3mvgK0iXf6Aj16Vu6mwYCoJmyDdhNBVb87L1weU17D+JgLpJ09X
	 rbJnS1zqmVDWEaQLzpDL61+SyOeQkY3UZgipzwGMJ/t3fsqE2fXHbPA9v7v+2K2FOzIDO
	 uvKrnkBw0uamWaBgI5IJ0LVuWSC+juGzybm/7y2G9m6miqyGIlWZDrAMOTu2iv/fJ2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FEdZyXdP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDFA606A529
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 06:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FEdZyXdP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097D41F000D0;
	Fri, 20 Nov 2026 06:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795155003;
	bh=anWx0nR3OcgLoHvHZkSELvtCw30VVF0D46s6K2HkQLk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FEdZyXdP9sD6TavhUA0ylJGb1OS9ekFi3HgJOmATookQEH+891AcSySCN0eZT5iCZ
	 rBntjh8rGdN4fNvmUWu8CIfDyaXGlKzW+7+xatCL4pwejPg8fMhOy5zOKr2tqo9R2D
	 9/DxrQIb+gij+zJzPPcICKsBz6YH0s88MZuyEs1+q/abvrDwppz6tK2tOT3lM9xmWr
	 9angIRNl3j8o/BbxOWk98ZN/Xek9hXvRoI25Samd28Hh8Svk9Wbc7loQ5u6BRScfta
	 KZHLQuAPZSPflPqAthD+IHEk3Mt400q11TScIcVi670gVBmQKa6b/0Whg6VGEhqA7o
	 zJW259hUPMT0Q==
Message-ID: <sashiko-outbox-224537@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/rxe: reject ODP accesses that wrap the iova space
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yiran Qiu" <eritque-arcus@ikuyo.dev>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261120060000.302440-1-eritque-arcus@ikuyo.dev>
References: <20261120060000.302440-1-eritque-arcus@ikuyo.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 06:10:02 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> rxe_check_pagefault() decides whether an ODP access needs a page fault
> by walking its pages, and bounds the page index against the umem inside
> that walk. When iova + length wraps past 2^64 the loop does not run, so
> neither that bound nor the HMM_PFN_VALID and HMM_PFN_WRITE checks apply,
> and no fault is taken. __rxe_odp_mr_copy() and the atomic write and
> flush helpers then index map.pfn_list[] with (iova - ib_umem_start()) >>
> page_shift, which the registrant controls: ib_uverbs_reg_mr() only
> requires the MR's iova to share the page offset of the user address. The
> entry read past pfn_list[] goes to hmm_pfn_to_page(), and that page is
> copied to or from the peer.
>=20
> rxe_check_pagefault() also keeps the index in an int, so an index of
> 2^32 or more can be truncated to a value that passes the bound, while
> the flush and atomic write helpers use the full unsigned long.
>=20
> [ ... ]
> with and without this patch.
>=20
> Fixes: 2fae67ab63db ("RDMA/rxe: Add support for Send/Recv/Write/Read with=
 ODP")
> Cc: stable@vger.kernel.org # 6.15.x: 7797bbb0e86f: RDMA/rxe: bound the OD=
P page index against the umem in rxe_check_pagefault()
> Signed-off-by: Yiran Qiu <eritque-arcus@ikuyo.dev>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120060000.3024=
40-1-eritque-arcus@ikuyo.dev?part=3D1

