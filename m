Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792681199;
	b=KEPgDxRhD7Gkb+dEnQiAmnPgsuK/cAHAtiGcCWgvIbjEzzslEOnT88NoSRM1T2d2dDiA
	 wpIhf/MIhAbt/r4sHsozypjLKBwLiiyCSuVplMU0kOu5FMqnRrlrpLeGRfIgfWbEb6WBs
	 Hl/d+ROz18FCSzXpK9dqIKEiZHi8xJA2aXHFQAYr0peCMMuRtHo2QDRO0l6cgRn6dTlWY
	 3H9I+dXm7XTwHw7x0pAChwebqya75PcT7Uac9pdfC61urX3EJX5Hc+KhJKnvh/RNcf9xH
	 ps16GpM51pBN3Zid8eJd/SdL5/eiPRIHQixnArj5YwYYcM3ZPP7SKYzfazAkzYhpDUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792681199;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=EMK8ff4gDCLQQthwdNajnBjualPDoFPlRFZ7lSTwWXQ=;
	b=Y1ZZo6xHgZcHGSZ+WBUF1mKlOiS5ZsHawR9UyV94XMXJJ/Eq01DIChMLUNPwhLSgqv+c
	 50P1PP0TKZaWyFtycswZQuWCu4GDWPVrqTBNV72a9GYm7ll8qJzWwpEyAkA6Ll0MIhIfb
	 5nIIHTSrK/LZJ+B+AH8FV6wBUUtRYffMFuoJbBNRE/UzcU62gwIPp6WQFpiPCOMw6ie2J
	 VsGcjcsep8zAsWmF2FOVATh+zNnex5sSn54xSH8hkG0mtCLzr2qCw1w5ehOLmj7wi7GRX
	 tMkNNa552FaY395P5GMg2QedCIOJyhvzF6T6jk4ebDI1a/5dA99DamcFyyxP2fukN1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lEETWfvD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1C1606A319;
	Thu, 22 Oct 2026 14:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lEETWfvD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961F91F000C1;
	Thu, 22 Oct 2026 14:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792681198;
	bh=EMK8ff4gDCLQQthwdNajnBjualPDoFPlRFZ7lSTwWXQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lEETWfvD7YsumdrbhDUFv9qdbi7yX2z5E4GKoN3Zg+6xjXCVCM1BWlH8TzFeN+8NV
	 s0uczil0lzRDEjaNTqIQxxJJkAzPlhvgqypor7lKtf97ncruumIQhk/7BdMXo8p6Ln
	 NSbQR8d9N8d+fT6GPrqmYHY/t3rz7ssSWm58l0a6Z6shjz5rlsQmjULu0tkAyfQILE
	 Mj9HSwWSeQchRF/99XjdiJk2Bc6BQ9XM+tU9J/7fpOVUK0MU9BH0qHtWidVLw4ki3n
	 kTVURWqPFcDQ0Jo96vM2CKbsVkeB2jT+6xiDtbuKBVWy2T5WRg3GNzP6SmE5PFf7ft
	 +gUxp9u5BCuVg==
Message-ID: <sashiko-outbox-181668@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/2] RDMA/srpt: bound the indirect descriptor table
 to the IU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261022143901.2991062-2-yhlee@isslab.korea.ac.kr>
References: <20261022143901.2991062-1-yhlee@isslab.korea.ac.kr>
 <20261022143901.2991062-2-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 14:59:58 +0000
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
- [Medium] RDMA/srpt: signed division truncation in srpt_get_desc_tbl() roo=
m check
--

commit a65e69a3e5c91bb2033461a63cf75aa8305efc27
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

RDMA/srpt: bound the indirect descriptor table to the IU

This commit bounds the indirect descriptor count in srpt_get_desc_tbl()
against the remaining space in recv_ioctx->byte_len to prevent out-of-bounds
reads in srpt_alloc_rw_ctxs().

> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/u=
lp/srpt/ib_srpt.c
> index 7197d95f2216b..97758082f71d2 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -1117,6 +1117,8 @@ static int srpt_get_desc_tbl(struct srpt_recv_ioctx=
 *recv_ioctx,
>  		struct srp_indirect_buf *idb =3D srpt_get_desc_buf(srp_cmd);
>  		int nbufs =3D be32_to_cpu(idb->table_desc.len) /
>  				sizeof(struct srp_direct_buf);
> +		int desc_off =3D (u8 *)idb - (u8 *)srp_cmd;
> +		int room;
> =20
>  		if (nbufs >
>  		    (srp_cmd->data_out_desc_cnt + srp_cmd->data_in_desc_cnt)) {
> @@ -1128,6 +1130,14 @@ static int srpt_get_desc_tbl(struct srpt_recv_ioct=
x *recv_ioctx,
>  			return -EINVAL;
>  		}
> =20
> +		room =3D (recv_ioctx->byte_len - desc_off - (int)sizeof(*idb)) /
> +			(int)sizeof(struct srp_direct_buf);
> +		if (nbufs > room) {
> +			pr_err("received SRP_CMD with %d descriptors but room for %d in the I=
U\n",
> +			       nbufs, room);
> +			return -EINVAL;
> +		}
> +
>  		*data_len =3D be32_to_cpu(idb->len);
>  		return srpt_alloc_rw_ctxs(ioctx, idb->desc_list, nbufs,
>  				sg, sg_cnt);

[Severity: Medium]
The commit message notes:

"recv_ioctx->byte_len is signed, so a byte_len too small to cover even the
descriptor header yields a negative room and the same test refuses it."

In srpt_get_desc_tbl() in drivers/infiniband/ulp/srpt/ib_srpt.c, signed
integer division truncates toward zero. When recv_ioctx->byte_len is 1 to 15
bytes short of covering desc_off + sizeof(*idb), the numerator
(recv_ioctx->byte_len - desc_off - (int)sizeof(*idb)) is in [-15, -1], so
dividing by sizeof(struct srp_direct_buf) (16) produces room =3D=3D 0 rathe=
r than
a negative value.

Also, idb->table_desc.len is read before recv_ioctx->byte_len is checked:

	int nbufs =3D be32_to_cpu(idb->table_desc.len) /
			sizeof(struct srp_direct_buf);

If be32_to_cpu(idb->table_desc.len) < 16, nbufs is 0. With both nbufs =3D=
=3D 0
and room =3D=3D 0, the nbufs > room check passes on the truncated request,
allowing srpt_get_desc_tbl() to read idb->len past recv_ioctx->byte_len and
call srpt_alloc_rw_ctxs() with nbufs =3D=3D 0.

Can a truncated srp_cmd request bypass this bounds check when the byte
deficit is between 1 and 15 bytes and nbufs is 0?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022143901.2991=
062-1-yhlee@isslab.korea.ac.kr?part=3D1
