Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AB8525A66
	for <linux-rdma@vger.kernel.org>; Thu,  1 Oct 2026 15:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790869201; cv=none; b=CrAxVhwvHYZUrHl2AXVQwDNECtDtoUXjjhe3J0yGTKsUXo/TR+rMx9jV+luOmBva21eUYhLXBdWQRYSSLf/8EcXIv6TbgwH43P9pR7JiBAKgJvdOzbzgTVKdTV8rjZTCenv9LAG+1ncIj6mc/wL0EkvCe+0YQf/80EegyGb1Tp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790869201; c=relaxed/simple;
	bh=jGszdIC7BtYgURf3Rkx5dnq6H/KF0JMmJHTwhsu2BVQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LdnZ8zHhS7HAsEks61h6sgaiQiEbTOcFpXF9NziD3OONsoyGN+0rEJFnBuBEn7LtS535ANb6/s+2fsUVV89GkH+tKe5A+w9mt5v6ACjEsMgtdX90qJOiBWUPKVdMX87LWoc5/5lu05cKzpBJ1Szs6kxj46Uk/9/YDpSJpIVDNvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gR2fb7ZZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gR2fb7ZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E29D1F000FF;
	Thu,  1 Oct 2026 15:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790869198;
	bh=RFHti611fbwfslRXVk8gJOaZbc/5SfMOZSOivIszKx0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gR2fb7ZZgSflT171hwpjMvvnfcEJQL5tc/4i0pMFoyN5y5R2mQVRhRk3ygYbq3tvw
	 IrZhjA0NehBRo8vVNUbNUH3rzaEyj45meqjTkGwFbx44FS8QapuNm9jsUf3vuHKgBl
	 05hkeNea9LCu6FJrKSOl1a/7BPYRPadNM4obeRNIkw2TuxOaIcO7uQqKTkcZmomF6/
	 +lxazDbbw79Gz2X/xmxqteRGLITYkV1ZpICoZq96ErlE4kuy4incGARNKJIHZ5DcW3
	 WC4W0WC7/3RleFrQ7RakL58HxIAgWyK/XXMXMyHc32UMJr08TMKP31iTXtVeFB/uv/
	 3vs9lb1pfXHWw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/rxe: reject IB_WR_REG_MR from user QPs in
 rxe_reg_fast_mr()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Youngsung Ahn" <ays511.kr@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261001152426.3259522-1-ays511.kr@gmail.com>
References: <20260930182126.2510559-1-ays511.kr@gmail.com>
 <20261001152426.3259522-1-ays511.kr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 15:39:58 +0000
Message-Id: <20261001153958.8E29D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> IB_WR_REG_MR is documented as kernel-only ("can not be issued by
> userspace"), but nothing enforces it.
> rxe_wr_opcode_info[IB_WR_REG_MR] sets WR_LOCAL_OP_MASK for IB_QPT_RC,
> a QP type userspace can create, so a user QP that writes
> opcode =3D IB_WR_REG_MR into its mmap'd SQ ring reaches
> rxe_do_local_ops() -> rxe_reg_fast_mr(). That function then trusts
> the ring-supplied fields:
>=20
> 	struct rxe_mr *mr =3D to_rmr(wqe->wr.wr.reg.mr);
> 	...
> 	if (unlikely(mr->state !=3D RXE_MR_STATE_FREE))    /* deref */
> 	...
> 	mr->access =3D access;                             /* write */
>=20
> For a user QP wqe->wr.wr.reg.mr is a fully attacker-chosen pointer,
> so this is an arbitrary-kernel-address dereference (arbitrary read
> confirmed, oops). No existing check distinguishes a user QP on this
> path.
>=20
> Reject IB_WR_REG_MR for user QPs before dereferencing the supplied
> pointer.
>=20
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001152426.3259=
522-1-ays511.kr@gmail.com?part=3D1

