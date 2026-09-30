Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECAC8521231
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 18:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793665; cv=none; b=HMfVSv866vpnRblYsDAJZ7VRjyNXVwFGfd1vFx/s8an3WJy8B7WmD7qpr2oibEbbrC1dzkfOSL2Wfwc7XYtWt238ADx4/KQlbZN2iJFmF9+fSKUH9vxoEHtK40UQeAgak7kU8h77IIhhztfCuRxa/vbX4qvDyfgMJiipnri7KBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793665; c=relaxed/simple;
	bh=9uAtlzPEbAzdtVfXSvAVUovZehu9ukHy7IIZho38wcY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=M4GfX09OxS4cY+rbE8XLVyvvrJJGl6xFCNN5ucsub8kPGUuqvN4nRcn6wfA0pu4B2FyttrHrivzlRt/ntyOe4jP/L688I1mEp+pdf6n7Ut4LHByWxweiQVKBz3TBBmjrmpOEgzVdQIihWGSSaFBQx/Yk0QamlSvkZu1t3dtFAnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hzM/Ex+0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hzM/Ex+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EF51F00898;
	Wed, 30 Sep 2026 18:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790793663;
	bh=d8B2wfqzO+sspj5+3+48IIH409UvgHDaft+vta15P9M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hzM/Ex+0uhwEz9WcXlXXfPiUJ/feGWMnst1lkn8Mx6zYH9QrYqtwQmEe4I1W43zRr
	 DmkmF2l14zFWTIpF5Ypb6BzB34xtkcumruJ+wjERtqHg9IkBqQt0WYzV4j8WG1TCsl
	 T49ge4RGb9H4WvX1MkhgeOPREg+7ZyKDioPVZaoB4M0T3h9h5EkLjiQB/pTRXyiEyS
	 mtYw8k8392v/MZO08EAJ+j9auPPnFNotRRhPW9mtCPE+GfqyGQyIe324Huz+iRk7Mr
	 GHzX4l9LWu0VwjiPPx3EBU6f5n92B1ha4Qs9Sk2nKuz1DtrYCbkprcBBTxjgZxLsDE
	 jtVMFLftEOM4w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/rxe: validate inline sge_offset in finish_packet()
 before indexing inline_data[]
Reply-To: sashiko-reviews@lists.linux.dev
To: "Youngsung Ahn" <ays511.kr@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260930182216.2510953-1-ays511.kr@gmail.com>
References: <20260930182216.2510953-1-ays511.kr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 18:41:02 +0000
Message-Id: <20260930184103.32EF51F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] rdma/rxe: TOCTOU bypass of sge_offset bounds check in finish_packe=
t()
--

commit cb139c29341b6f7fcb85c3b737c416392d13b68f
Author: Youngsung Ahn <ays511.kr@gmail.com>
Subject: RDMA/rxe: validate inline sge_offset in finish_packet() before ind=
exing inline_data[]

This commit aims to fix an out-of-bounds read by bounding sge_offset against
qp->sq.max_inline before copying inline data from the mmap'd send queue.

> diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/=
rxe/rxe_req.c
> index 53f7c1e7fe55b..887bceed6b5d1 100644
> --- a/drivers/infiniband/sw/rxe/rxe_req.c
> +++ b/drivers/infiniband/sw/rxe/rxe_req.c
> @@ -510,7 +510,14 @@ static int finish_packet(struct rxe_qp *qp, struct r=
xe_av *av,
> =20
>  	if (pkt->mask & RXE_WRITE_OR_SEND_MASK) {
>  		if (wqe->wr.send_flags & IB_SEND_INLINE) {
> -			u8 *tmp =3D &wqe->dma.inline_data[wqe->dma.sge_offset];
> +			u8 *tmp;
> +
> +			if (unlikely(wqe->dma.sge_offset > (u32)qp->sq.max_inline ||
> +				     payload > (u32)qp->sq.max_inline -
> +					       wqe->dma.sge_offset))
> +				return -EINVAL;

[Severity: High]
Since the send queue is mapped into user space, can a concurrent modificati=
on
to wqe->dma.sge_offset bypass this check?

It looks like the value is read multiple times directly from shared memory.
Could an attacker swap a valid offset with an invalid one immediately after
the bounds check succeeds?

> +
> +			tmp =3D &wqe->dma.inline_data[wqe->dma.sge_offset];

[Severity: High]
Does this setup an out-of-bounds pointer for the subsequent memcpy if
wqe->dma.sge_offset is modified after the validation above?

Would caching wqe->dma.sge_offset in a local variable via READ_ONCE()
prevent this race?

> =20
>  			memcpy(payload_addr(pkt), tmp, payload);
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930182216.2510=
953-1-ays511.kr@gmail.com?part=3D1
