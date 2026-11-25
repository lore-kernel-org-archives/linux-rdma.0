Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795639945;
	b=P+wLfZLBO3JMrWvzdw+NaQ3f/9/sgU2BK8u5ryoitiswtciBeI4uLNJQp+1h1aVsUSlA
	 NACiRF9H/xUKsuQV+vGlUTsfStSP+Zle9egItuqMVZ+N0EnuwguRemxtddesL2q4dyMSY
	 QWI51jRRhPl7VwH+aqdAro+ni6xmXT8qeoABGCrpWtjjuNsaJudkmYqxdH31mHapNi27u
	 Q7HDAlibaUx1Ew4zwAWatGWIY9oC0sp+9oCff90EdJaAlDabrVb6FuvRLfgxvASDmGh/p
	 tHsoPhWOzp+fAfBwPsi579jyq/yshT2252anF7BacqBkmnkbq3JZ8iXfwAvyUToCzrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795639945;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=nfRKL8rRTYxcFiuJalslt5p2VH07YS9D6zGBhi/2Z4Y=;
	b=pdYttm2RUQhY8D8yKK4zvdV828KU7EIiEWDw5LxDmtWgq493pco4aTD1W+HIOjq9ojfz
	 b1YXGrduQ+r9gBv692Yfw7rMAdHl7xh2kEjS30PhvlKpbaFTpPycogxqPqRfj3edC805F
	 i8gwzXDNg0Tb4b04lQPA/3Qm9/VhL/yZg5u9iem5/bURmAtrH1KVMrdrK4PHKJoTLZEar
	 DmB0LvYcnRTS4b3ZGMpCIPTIE4DUO5H6vnCMJuaKfLsP8iI35OUAfNqvRDvdycHYs2XcO
	 kHjP0DA6yNfcLNiqxpO0JXMoAlvPZnTOUSqnM5DeAxvH3iHc8sB9/GwVyfW3RYp0VGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NwBI53Ve;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D29606A335
	for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 20:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NwBI53Ve
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCBA1F000C6;
	Wed, 25 Nov 2026 20:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795639945;
	bh=nfRKL8rRTYxcFiuJalslt5p2VH07YS9D6zGBhi/2Z4Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NwBI53VexwCoFRcaw4utM5t9UuQ3y3pxdaHxFeyxRoACC0zOyMIYvbE11HE7cOih2
	 deGE+ng7AvRvcR1bK8op5ASnixXQNHjQAidh4/4dUJMuC2vK3De5B32qztU/qOi/mT
	 MI0nvHaVKUUjXU0me/wBjqxp5YuwNmGQBOqwRvyF+3uWPr0ph6oV16uVmh8K9r4MUF
	 mvQBTq0VwEdOVk7MBZn3r+0SrO2gImWmJ9SnoJD5nfNJcFxA6paV/3Z9JS34v0JB89
	 S+5e+jQZRO1DuXdA+WFsFZHfBmeU2lCrVy9mLQ+tCzz8uyZ93hK9CooFrmgpZUC6d9
	 uKkPAYeItj79Q==
Message-ID: <sashiko-outbox-234150@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] RDMA/rxe: reject MRs whose iova range wraps, keep
 ODP lengths unsigned
Reply-To: sashiko-reviews@lists.linux.dev
To: "Cygnus Qiu" <eritque-arcus@ikuyo.dev>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261125204024.517458-1-eritque-arcus@ikuyo.dev>
References: <20261125204024.517458-1-eritque-arcus@ikuyo.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 20:52:24 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> rxe_check_pagefault() bounds the ODP page index against the umem inside
> a loop over the pages of the access. When the access ends at 2^64,
> iova + length is 0 and the loop does not run, so neither that bound nor
> the HMM_PFN_VALID and HMM_PFN_WRITE checks apply. mr_check_range()
> admits such an access when the MR's own iova range ends at 2^64, which
> rxe_reg_user_mr() accepts. __rxe_odp_mr_copy() and the atomic write and
> flush helpers then index map.pfn_list[] with (iova - ib_umem_start()) >>
> page_shift, which the registrant controls, and the page derived from the
> entry past pfn_list[] is copied to or from the peer.
>=20
> rxe_check_pagefault() also keeps the index in an int, so an index of
> 2^32 or more passes the bound truncated, while the atomic write and
> flush helpers use all of it.
>=20
> Reject an MR whose iova + length overflows u64 in rxe_reg_user_mr();
> [ ... ]
> rdma-core v65.0 tests, ODP included, pass with and without this patch.
>=20
> Fixes: 2fae67ab63db ("RDMA/rxe: Add support for Send/Recv/Write/Read with=
 ODP")
> Cc: stable@vger.kernel.org # 6.15.x: 7797bbb0e86f: RDMA/rxe: bound the OD=
P page index against the umem in rxe_check_pagefault()
> Signed-off-by: Cygnus Qiu <eritque-arcus@ikuyo.dev>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125204024.5174=
58-1-eritque-arcus@ikuyo.dev?part=3D1
