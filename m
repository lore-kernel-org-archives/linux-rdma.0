Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE0F355813
	for <linux-rdma@vger.kernel.org>; Sun,  4 Oct 2026 15:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791128455; cv=none; b=pq2F3Gc9dz2U0mZ3AUI407xP8fyxYgtpjXLbQvVnZmhuhSc9Fv9x5Vjf1Qdzj43IyKbegaKKYF7M3AeGy4TvYjN+GlSUBEYOlXs49Fpb5xaDG7zhaLPrsydSZ8Y2MWjhxgzH4pRucslc+aOfuc9RJtBMtkABm0ejfpl5tLkMHXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791128455; c=relaxed/simple;
	bh=Oz82mvgbhs+mhYYTtxur/e5fpjKVewtVPPadIy0elPc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CxPhFtHwcZYI6XwlFgWX1wJHeRYhQcmCUZdEwI/kb+isHMw7s1F1jvXyKD2kh++aaLefu+WZ51uc+pO8zQyZIM8RQEunBEq0Dg+ZNn7C5W5hgCWf1h0s0NPO6Xb3vxgGztZ0tj/POOqs+A2riyo9Lq7WqnQ1Ig+ck278nE2BaAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZfrhzA8K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZfrhzA8K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D1B1F000FF;
	Sun,  4 Oct 2026 15:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791128452;
	bh=PkJ/f6Z0e7xHjXHBTgFfucJXediMEB+i9r29DxV17HE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZfrhzA8KZZINmx79enPbV5e4PjugMIux3vSnf03L2lhfh75L/FyPkHW+Gl4xkQKvO
	 ureVJt26niApNdLv4b5kMfan4PtNSXE9zCy8f/M3UT2Uytd2UUigiVUczvwgl8D6Vh
	 CfchORIR7HkklvY4NJrCKi1aSvm4ZMXAnFQ0HNaX3TBScvDQmJ2NvM3ngK7Tt5rgxy
	 PZPF2R+4tSlVjIbmHsXVMDcLXrP5o1mS0vGl/ZQrcmN8TA3DtMQZxLJMHdW07iAj47
	 nOjJYMwHsC1WAUsqYcfWuz7vrw9fSI4UxhEOkFM3gm462KeEIUgnzqOb/DL4VU69Pk
	 +K8T9m6JeKcoQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] RDMA/rxe: validate cur_sge on the receive path
 before indexing dma->sge[]
Reply-To: sashiko-reviews@lists.linux.dev
To: "Youngsung Ahn" <ays511.kr@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261004153325.2952372-1-ays511.kr@gmail.com>
References: <20261004153325.2952372-1-ays511.kr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 04 Oct 2026 15:40:51 +0000
Message-Id: <20261004154052.65D1B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> A user QP's receive queue is an mmap'd ring. The user provider writes
> the WQEs into it and post_recv never touches them, so every field of
> struct rxe_recv_wqe comes from user space. When the responder picks up a
> WQE it only checks dma.num_sge (in rxe_get_recv_wqe() and
> get_srq_wqe()). dma.cur_sge, dma.sge_offset and dma.resid are copied
> into qp->resp.srq_wqe without any check.
>=20
> copy_data() then uses cur_sge as an index right away:
>=20
> 	struct rxe_sge *sge =3D &dma->sge[dma->cur_sge];
>=20
> It dereferences that pointer (sge->length) before the in-loop
> "dma->cur_sge >=3D dma->num_sge" test, which only runs after the first
> sge++. cur_sge is a u32, so the pointer can land far outside
> dma->sge[], which has RXE_MAX_SGE entries and sits inside the
> [ ... ]
> retransmit path reaches dma->sge[] through advance_dma_data(), which
> still has the same unchecked index. I will send those separately.
>=20
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261004153325.2952=
372-1-ays511.kr@gmail.com?part=3D1

