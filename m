Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795298674;
	b=fS2A3aVaPWM//gZMsgPPEBekhcudlVdViJot1InmaH3fCT8LqPYN8AIht2Z4uapaRXtf
	 XPawtGgA7H42HXmfOvOD7da+inC0W60SSBHkE12YrCSjdj5R8zHL5GAxbCLiwHUzZhGAm
	 q57RLzYUXBIYvmn11itRpvJnJ+P9Lnvk+PzHnzbwI7eKT1wYbVF7oxJw7HFALiMmLn7jR
	 c5EOdTd+Nd5E9z87AF1mmUHgjKHX/wIWdJ7lyx6p/PXDk0W59CddaF/kW1saioiTq58Ml
	 v/FiYGRh5ybopyRnGHrwImwKpFjhJocDdQ1bfAc2KDsnbYEyptkuTQw0GNDK4wIN1Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795298674;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ht6uG6TvnKJwpB4c3+v9bBdg22eNynuy4UFw+ZnDkek=;
	b=IGhj33KsZ70jIkDHt9XcTEk3A77cW9ki2M0WPok+74Bz5jB5DWuC2xAKXXuhzSHd4655
	 Zd8Chev7DFA4Vn2qZJFaCxaf6JKvmQ2wqtciLfZPxyZa+sariFrdz9gW4VVEXm9/Qn77w
	 Y6/rTYVCYWAp82htmZ6btYEAjEwh7VyAWrmV4uhJYiC6woKrH3rSD4GZ3aJ8SncPdGSUh
	 3AGPYQHNU/rPpls8ltkOFnLsyorKPTOZansPiPK5Fvl0nsBV5R1suFNXkRChsxOnMjEZ4
	 3E8+otXuGXAu+2EmCXr+rnnlfeRn/WQBHROsSac36rIfwMSEdV/Cw/L5qxnty4v1H6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nPXFFhzT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036BB606A320
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 22:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nPXFFhzT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A041F000C0;
	Sat, 21 Nov 2026 22:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795298673;
	bh=ht6uG6TvnKJwpB4c3+v9bBdg22eNynuy4UFw+ZnDkek=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nPXFFhzTanGIHv56CqRzkrYxJjCDWnRBDLIL+KUBTmiy5PQ2QWy5ykROyIdM4RJbL
	 tPqz0ND4a6yx+QiuAkkxKaxvMpqQPf1VWlKgh/N49V6ZFbAFhGain8r/VUkPcww5tF
	 w+A2Pa64yiUPHU17AiCplcM5G404QTw5Yu8OXykm5LoIk/S6xScFpLahqkMM5TRMGL
	 EpV+F99QuIkXQfueOT1/fVYDtAEOa9YGA3fC2hsPp2MZvt1Or63cz+F4HmQVGSppwC
	 px51nVe9Kd+mIPfykw2YxKxXYX5+KRkoWu9u70sVhKZM29IbUHuIRBsMxWS6cqr/8B
	 s+N/IXZ8Bij4Q==
Message-ID: <sashiko-outbox-227431@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/rxe: reject ODP accesses that wrap the iova
 space
Reply-To: sashiko-reviews@lists.linux.dev
To: "Cygnus Qiu" <eritque-arcus@ikuyo.dev>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261121215426.50988-1-eritque-arcus@ikuyo.dev>
References: <20261121215426.50988-1-eritque-arcus@ikuyo.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 22:04:33 +0000
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
>=20
> Fixes: 2fae67ab63db ("RDMA/rxe: Add support for Send/Recv/Write/Read with=
 ODP")
> Cc: stable@vger.kernel.org # 6.15.x: 7797bbb0e86f: RDMA/rxe: bound the OD=
P page index against the umem in rxe_check_pagefault()
> Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> Signed-off-by: Cygnus Qiu <eritque-arcus@ikuyo.dev>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261121215426.5098=
8-1-eritque-arcus@ikuyo.dev?part=3D1
