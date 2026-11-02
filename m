Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793637730;
	b=wz9V9C+CqWTu5+REe4OyL+3sDo49fTqfUsiJ42oFzRKe4wX+uKGgRq4f2J8lqPapXpsI
	 Do+7fqhlUdju2VAXK/x720FtR8oTEQP2HAnYB53ky41vnHB/aA6IVDV6jO7rmlDHXdJbq
	 gfVFj2RvapyLnHEd/U1xgGI+Sk32J05Z8lKNXXs9lOjIbfV5hv33L4DP7O7SRA49lPZlE
	 NxuCCEk9+Ce1L/NjkPPfEmQGfZODxlPtSJfks/Y9kulU4Kb2RUsLuGss1AlAEzbzk0Kyl
	 TFGVRQw2HMzUEp1H5uv6Asucc4tDqVHuYXltSo+1g0Uv0epMlU/22fgpd3N4G80IFAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793637730;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=NiNX2lKlmi1qCjYUitTBQuTctOil5falK/ExW9OsRnY=;
	b=enWcrI9iAJmwCSfiHl0P9o/LA6qJ7/FnL5uAfYMvHXzPd6enE22fRVRT4GTs/qgJwdTP
	 KFLmB7GwIPMWAVwetZdQ5eEQOunYLix2OaxbTfRos6l0RTh4KkvInGfqwkgdzqvDtl37g
	 T4X72u7X8QNbTzdcUtslsH6bBjY6J4a8/8+cvPzHe2uiJXRGZY1yiEt9xi0c3s2SKTOTj
	 TGxBHIkEf55lK1UBC7ULkLyvTaxVldTYh1Ymcqx4UZQB5WpM/bVMYkbvwIl1aEHj5xhUc
	 NyaBOR5YuKOyrkmGmdlniBOnBeTCZLwmD2l2pGLIPmnc0CYhne/HsCFYiKdtbXEc4IQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FbfarSi4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F271606BA4A
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 16:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FbfarSi4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11231F00A16;
	Mon,  2 Nov 2026 16:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793637730;
	bh=NiNX2lKlmi1qCjYUitTBQuTctOil5falK/ExW9OsRnY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FbfarSi47RIIWpQShhEvbnX3foJ/psW4rR9+1RUV7eCoKZK1mv1J7ec32UIga+YpP
	 qNuWQs8IvgGXfFSOShHp4iduHLaMQdteR/ejRFZuGNKT0CPvyzPlzFwS1g3o0muC10
	 CfVlLnWcJGNTJ9yCeFfdjreueSPPZkCCSVbr5z0QRSCepN1Ij6LqtjSp8RjlOg3sXC
	 Wt1brG+RUK73UOffxy2fj+k65Q49WS9oLvn/YTurYd9KK3s4rbt3pMkHlagXI4yCqB
	 xkoYB/QnjOg0X3OgKmME85/+ypp6h7/a5FD+rurStciNf3g6d8Q+jPptbnMRN6gEpm
	 I+Z/smc0ARDJw==
Message-ID: <sashiko-outbox-193761@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v7 6/9] RDMA/mana_ib: Post send and
 memory-management WRs on RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261102162505.501853-7-kotaranov@linux.microsoft.com>
References: <20261102162505.501853-1-kotaranov@linux.microsoft.com>
 <20261102162505.501853-7-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 16:42:09 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] RDMA/mana_ib: __le32 to u32 Sparse type mismatch in mana_ib_post_sq=
()
--

commit 8ccaec72f638cf8641d6fe111aeda1bd2485a4f2
Author: Konstantin Taranov <kotaranov@microsoft.com>

RDMA/mana_ib: Post send and memory-management WRs on RC QPs

This commit implements send work request posting for RC QPs, routing
communication WRs to the send queue and memory management WRs to the memory
management queue. It also advertises IB_DEVICE_MEM_MGT_EXTENSIONS on
adapters supporting extended WQEs.

> diff --git a/drivers/infiniband/hw/mana/wr.c b/drivers/infiniband/hw/mana=
/wr.c
> index 5d42af91fce4a..d5dec02aa70a7 100644
> --- a/drivers/infiniband/hw/mana/wr.c
> +++ b/drivers/infiniband/hw/mana/wr.c

[ ... ]

> @@ -224,6 +289,294 @@ static int mana_ib_post_send_ud(struct mana_ib_qp *=
qp, const struct ib_send_wr *
>  	return err;
>  }
> =20
> +static int mana_ib_post_sq(struct mana_ib_qp *qp, const struct ib_send_w=
r *wr)
> +{

[ ... ]

> +	switch (wr->opcode) {
> +	case IB_WR_SEND_WITH_INV:
> +		send_oob.rc_send.invalidate_key =3D wr->ex.invalidate_rkey;
> +		wqe_req.flags |=3D GDMA_WR_CHECK_SN;
> +		break;
> +	case IB_WR_SEND_WITH_IMM:
> +		send_oob.rc_send.immediate =3D cpu_to_le32(be32_to_cpu(wr->ex.imm_data=
));
> +		fallthrough;
> +	case IB_WR_SEND:
> +		wqe_req.flags |=3D GDMA_WR_CHECK_SN;
> +		break;
> +	case IB_WR_RDMA_WRITE_WITH_IMM:
> +		send_oob.immediate_ext =3D cpu_to_le32(be32_to_cpu(wr->ex.imm_data));

[Severity: Low]
In mana_ib_post_sq(), both IB_WR_SEND_WITH_IMM and IB_WR_RDMA_WRITE_WITH_IMM
assign the restricted __le32 value returned by cpu_to_le32() to
send_oob.rc_send.immediate and send_oob.immediate_ext, which are declared as
plain u32 in struct rdma_send_oob in drivers/infiniband/hw/mana/mana_ib.h:

	union {
		u32 immediate;
		u32 invalidate_key;
	} rc_send;
	...
	union {
		u32 immediate_ext;

When building with C=3D1, does this trigger Sparse endianness type-mismatch
warnings? Should those fields be annotated as __le32, or assigned using
be32_to_cpu(wr->ex.imm_data) to match the host-endian u32 fields in
struct rdma_send_oob?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102162505.5018=
53-1-kotaranov@linux.microsoft.com?part=3D6
