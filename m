Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7491F349B19
	for <linux-rdma@vger.kernel.org>; Sat, 26 Sep 2026 07:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790406911; cv=none; b=pldianYUx0/Nlq4S9v+a/thnAtM15u0S5nASbABH0j+w2/crA4j7R+ifwkDvWmys1L6UXqjEe4dTG/0pAb59tgo4s4mer8IQ97GIlMDTIkCVpns18kphX8jbCluLnUCqdG9KWnWkFr12X39CZgtgSPBC5tipdN87LH7K8Tkeqa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790406911; c=relaxed/simple;
	bh=uvXauOMv9gVez8iHYcgY6b4BoFeZltXkFm0c9gaBZy4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LFX7rkHT6JACjlGxttzZLv3LAoZzfUWiN8AZro6s7CspDkAZrED3YCxCL/A8Leh3yoTPiHb/oReV0LHr984D7Lv5r47wY/PMLQQ/ilws1KiCqYglBfiqs3qvzNKuM8cFOrx4udZG1zIDFbxNYKtyZ7xPlMxuId7V9LxVD0UhNjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HlNC61B+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HlNC61B+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61B21F000FF;
	Sat, 26 Sep 2026 07:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790406910;
	bh=MudZIO6139CHgSTLNegZKO6pLCL26oV9X0P6H+YNzzM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HlNC61B+AK6dVjXkM9NCqV4ASpLj12rLHz9ITp5YjWI+lEEYAC51ABIFGAgeffJ6o
	 hr3q/hUkYPprgGi489/u43mGPwwKfx2T2SP3xIe/W3Z+AoQ0evjFoK6iAVitfbKzqi
	 AVGzvh7QBgRMhKPaih6DZCsblQX+VYbImLmJpYz1EcHCLLYGX7vcKqbFk1gN98fI4t
	 WIq4nwuWllPCog9soDE5lFdXSzitZvfxcEcmIHwMMrUJxb9vcRa2vqxbMSHzxv3tSE
	 6CMjI7QgdSswFGE/PLhqwAfFKDR1RG+453YAc6OKu6fPPGVgDIdzUFkDwu+54NvjHV
	 pAK/WpDdw0PuA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/rxe: Validate inline data range in user WQEs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiale Yao" <yaojiale02@163.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260926070403.3005250-1-yaojiale02@163.com>
References: <20260926070403.3005250-1-yaojiale02@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 26 Sep 2026 07:15:08 +0000
Message-Id: <20260926071509.D61B21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] RDMA/rxe: incomplete TOCTOU fix due to missing READ_ONCE()
--

commit e7e4b53005e1e5706321c684271dff347a0b85b9
Author: Jiale Yao <yaojiale02@163.com>

RDMA/rxe: Validate inline data range in user WQEs

This commit addresses a vulnerability where userspace can provide an
out-of-bounds sge_offset for an inline WQE in the mmap'd send queue ring.
It validates the offset and copies it to a local variable to prevent a
TOCTOU race.

Link: https://lore.kernel.org/all/20260708224534.1206-1-security@auditcode.=
ai/

> diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/=
rxe/rxe_req.c
> index 53f7c1e7fe55b..fd2f248a1f448 100644
> --- a/drivers/infiniband/sw/rxe/rxe_req.c
> +++ b/drivers/infiniband/sw/rxe/rxe_req.c

[ ... ]

> @@ -510,12 +511,19 @@ static int finish_packet(struct rxe_qp *qp, struct =
rxe_av *av,
> =20
>  	if (pkt->mask & RXE_WRITE_OR_SEND_MASK) {
>  		if (wqe->wr.send_flags & IB_SEND_INLINE) {
> -			u8 *tmp =3D &wqe->dma.inline_data[wqe->dma.sge_offset];
> +			sge_offset =3D wqe->dma.sge_offset;
> +			if (unlikely(sge_offset > qp->sq.max_inline ||
> +				     payload >
> +				     qp->sq.max_inline - sge_offset)) {
> +				rxe_dbg_qp(qp, "invalid inline data range in send wqe\n");
> +				return -EINVAL;
> +			}
> =20
> -			memcpy(payload_addr(pkt), tmp, payload);
> +			memcpy(payload_addr(pkt),
> +			       &wqe->dma.inline_data[sge_offset], payload);

[Severity: High]
Does this code still leave a TOCTOU window open?

In drivers/infiniband/sw/rxe/rxe_req.c:finish_packet(), the value of
wqe->dma.sge_offset is read from shared memory into the local variable
sge_offset using a standard assignment.

Without a READ_ONCE() wrapper, the compiler is free to optimize out the loc=
al
variable and emit multiple memory loads directly from the shared memory
pointer. If a local attacker modifies the mmap'd wqe->dma.sge_offset value
concurrently after the bounds check but before the memcpy executes, the
compiler might reload the modified value for the memcpy indexing.

Could this regression result in an out-of-bounds kernel memory read,
leading to sensitive information disclosure or a KASAN vmalloc-out-of-bounds
panic?

> =20
>  			wqe->dma.resid -=3D payload;
> -			wqe->dma.sge_offset +=3D payload;
> +			wqe->dma.sge_offset =3D sge_offset + payload;
>  		} else {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260926070403.3005=
250-1-yaojiale02@163.com?part=3D1
