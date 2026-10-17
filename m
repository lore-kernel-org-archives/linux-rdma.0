Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEB0303A04
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 01:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792201703; cv=none; b=m/czidTVcQ1FxfcdoJPTibTd/k4MnBVZFRHUAIiNAHXFbKB0fYfsbS5HtfaeaNHXYFmNgVGpNMMU8ik3sz04a0l8gSs3XpBXn6Y3hvstm6ZiCOjlNL8MIPZxMheRajle47A7qS7nWwirpfj5R8rHXAtIBbFab7myWWFnD3xPLiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792201703; c=relaxed/simple;
	bh=7eZaFGB0CuXJUvDjLkhX1TMM8oBitoCkSj2ZzMcvZ7s=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=uWPEXuQPXJokH9WYDgbqvc7Vwb/QHfWhwmp+7QJz68riOIUiGnVRlziEE0yy81LfJfezAtJMKBo5y6M/qJc3omclN0jCuTO3gvhvxhCBbVs+vb2vLyf34GcGmFQy3r4hpv2OCk/CUhVDFi3BSzrqwgJXxyRWwdgtCn+2HHjTHbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mHk3t9eC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mHk3t9eC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF011F000C4;
	Sat, 17 Oct 2026 01:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792201702;
	bh=eciTVGWnqdQDszGjvNV+wv1r1bNpIKCojO73aAnu3hI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mHk3t9eCyUq4NAAilGh86XM8ZEzEujJgs2tJHMcXgsGjKGxGqSKhtlro2HLMXLMSR
	 u7n0qwom6bzNrHjb5o7gk6bkaemOoCInc7R255zpoSd4AMedtb+eo5MDYLvM4Jyuoi
	 bPleI3YnEAYa9FxvCTk9cBe+6+y8pNUWHojI09yghTrhf54FFEza9eBMtU2yB/0K4N
	 noxtzTDdlmAwa9cFuNm1fxfppP2qzJH9ksuiEEA9Lc1S9BjFTL1h8sLT/w+yCD+imO
	 1uETDgEXlGzDSFPXfNmyy79968xO/oFS8c7d58LwTf6xiZVLgumpvWOSwEjL/yglmK
	 BHj6MAQExL/OA==
Message-ID: <sashiko-outbox-175154@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/rxe: Clear pkt->qp before the early drop exits
 in rxe_rcv()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhiwei Zhang" <202275009@qq.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <tencent_FBB0EE9F592FD21FD4B0F3BFAD3336765209@qq.com>
References: <20261016020835.41630-1-202275009@qq.com>
 <tencent_FBB0EE9F592FD21FD4B0F3BFAD3336765209@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 01:48:21 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rxe_rcv() puts pkt->qp at its drop label, but leaves pkt->qp
> uninitialized on the two paths that take an early goto:
>=20
> 	if (unlikely(skb->len < RXE_BTH_BYTES))
> 		goto drop;
>=20
> 	if (rxe_chk_dgid(rxe, skb) < 0)
> 		goto drop;
>=20
> 	pkt->opcode =3D bth_opcode(pkt);
> 	pkt->psn =3D bth_psn(pkt);
> 	pkt->qp =3D NULL;		<- too late for the gotos above
> 	...
> drop:
> 	if (pkt->qp)
> [ ... ]
>=20
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Assisted-by: LLM
> Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> Signed-off-by: Zhiwei Zhang <202275009@qq.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_FBB0EE9F592=
FD21FD4B0F3BFAD3336765209@qq.com?part=3D1

