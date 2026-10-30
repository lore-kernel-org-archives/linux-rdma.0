Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793389841;
	b=1OwGzlYHUI2SekXFYPijywZvQGthUgKXJq90HP8ewzwhaU5uX4DfY/530OiNUdNtfOPE
	 xXTsP6kFMybDy6WV1Ul4Ijm2QTcNkykAK3bzGG7dg/FltrmdLEWKOu2fH7vRLDXuOjkXy
	 B3II6CiVrbyMWTiaXT4tI6Cr75TucxKwjTMYp8LRBnnFT9923G2WLVlsj/jWT4TbkfCIW
	 5p6NwGSVI3UWgYs0Oh4762NcAdYzjc350PiJvD89mY9oE+aN/N71VlgrVZcyJlDwEOV0f
	 J4vudUGisl9rZHjPV7x3czdYRhLOgwgfqRirJTywEdlxoFAszX61MCBvpw75JqvapPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793389841;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9Mzoyzs+6/bW9PIZ9Nxq7dlQxFMUuENKi36vdhme58c=;
	b=U5OMpRcxnGp1yleNYcR1eT3FHHo4N0fEbEgBq44tkliVYLEVZBjKskiD7vIBVDbXAd4H
	 93F6syuoBqF7TnqcYBkNNfrd04h3/AJgyXghQeybUI7OrodN7eg16YZTmWCrnpwy3j2vH
	 qWyslT8216wCvvrIZMTdXkad/o/Rtkrbo9Z9RidJfC07mZQzzE/i0wrgYT4+tba7YTeAP
	 O7tVOttUyhK8E7sM9Ef4o6GaPO/gnzLfuFpQakAHhRC/JdclHXjBK0/aQaQY4kFOvHSRw
	 leTRFwwxpHqQ9iBVZrUk9MZUZtFXMjIIOKsWsaRth7jIr+a78hBdOjXE47KX9R3GrtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TCYDzPo7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51CF606A31A
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 19:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TCYDzPo7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C96A1F0093A;
	Fri, 30 Oct 2026 19:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793389840;
	bh=9Mzoyzs+6/bW9PIZ9Nxq7dlQxFMUuENKi36vdhme58c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TCYDzPo7C/uHKKRM3ceVdc8J2tUDdFHCfmYfdhDb5ZTVqu+0HmGyaZUTrUbg6Uixq
	 PKbVyGYcrQjTSEAsi7Qm0lt78wHJi01yQEAql023gsRVMB+xr1nEzLmvvywWZYJSmV
	 pggdpZNFC2GdXC3oye5q3cGiLVz84mTLbdEGyFzM6kaVxg9jwbXefP/DFkh+x4DkGL
	 JftZMEwq3xiRvBtjoT9TEXONfv3MXLrPC9RS/+96NKG+4bsXKXkcoTWnaUqa8n7/JF
	 M0bgS944Wlw3X1yWs67oEK0vOGxW1PWhDGq7CPXEz7rBLbXE7V91aHW43LoGNYctP+
	 vysJWXl8VcYcQ==
Message-ID: <sashiko-outbox-191455@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 2/2] RDMA/rxe: copy send WQE to kernel buffer in
 completer path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tristan Madani" <tristmd@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261030193235.3470653-3-tristan@talencesecurity.com>
References: <20261030193235.3470653-1-tristan@talencesecurity.com>
 <20261030193235.3470653-3-tristan@talencesecurity.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 19:50:39 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> The completer reads send WQEs from the same userspace-mapped shared
> queue as the requester. Even after the requester copies the WQE to a
> kernel-private buffer (previous patch), the completer still reads
> directly from shared memory, leaving it exposed to the same TOCTOU
> races.
>=20
> Fix by copying the WQE in get_wqe() to a completer-private buffer
> using the full queue element data size. The local copy is reused
> when the same WQE is being processed with unchanged state, which
> preserves DMA progress across multi-packet RDMA READ responses.
> A fresh copy is taken when the state changes or a new WQE appears.
>=20
> After copying, reject invalid opcodes (above IB_WR_REG_MR), out-of-
> bounds num_sge, and invalid cur_sge by transitioning the QP to error
> state through COMPST_ERROR. This prevents invalid SGE walks in
> [ ... ]
> after retransmission with updated PSN bounds.
>=20
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tristan Madani <tristan@talencesecurity.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030193235.3470=
653-1-tristan@talencesecurity.com?part=3D2

