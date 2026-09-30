Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2095B51EDEE
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 18:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793299; cv=none; b=L4Y8tLfENt/NNXKv+65pkT0fwP4LJeyeaACzuXUFdAscPLzUleJBD6LU5ClG2GfE1n3K4116bugDkewsqRRc6SH5Ly68QgcmTZ8mNSwR3lFihk4Xc3niavKnjV1ZSqrmhyf7ZGdyBP6oWHUvV4CNAUa++ZjO9Bh+oGDNxYTxjjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793299; c=relaxed/simple;
	bh=iyx3zxFwLTDe4bDhrU+NUwO0wGjB2KAqT0+y+u1N0Ic=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fhrQhKpysAkVoxHhyzTo82E6DOhptE9K+huj2mCD2JwfhA6yktjvADNJcRuI9Zo/IRPfeWqFjHUXBjmgph7X4FKGH5YNk1KJcxuTHpifHeusv1sJbz4gMYsATYqFwjDRa1uu1ES7EgcJOBO/yEY96eBlDmXZ8TKuOgjBvlDtoVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nLDcEr0s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nLDcEr0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6451F00898;
	Wed, 30 Sep 2026 18:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790793297;
	bh=zAg3JTvSpm+7sFHbI8lnqHDKlR5hoa8/ZQJ9rcsmoxY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nLDcEr0sr7ki+V9+D9tgitxOBkrF19WfYG9QhyGf/XmADhPml6CVmkJdRZ16o7IIy
	 1k9ikMFLsu3SNKSbFiIQNuXqZTqQ6/vyXgIuAsccm0vhsYNFp7m9mExpfOarmJ8PbG
	 0jCkMj+RBR2Gj+V6fOj59kfYrJvpIG1o3TP6qrfsGydgf5KvSwgSREWIy5LU8Fx1op
	 gAqKtYpNg3Q15x0E7KAQ/GmvsI4iQNZYmmg3af4nbnJSr7UIDJSSOZdKUONUciuXFL
	 CG/Sv6UmSHc7MKk85MmteO1FzWdLYByzBbR2jsMO72mu8g+bsPtN74MBb4PPU3iXN6
	 WmOAdSHSPHIEQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/rxe: reject IB_WR_REG_MR from user QPs in
 rxe_reg_fast_mr()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Youngsung Ahn" <ays511.kr@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260930182126.2510559-1-ays511.kr@gmail.com>
References: <20260930182126.2510559-1-ays511.kr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 18:34:57 +0000
Message-Id: <20260930183457.8A6451F00898@smtp.kernel.org>
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
> Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930182126.2510=
559-1-ays511.kr@gmail.com?part=3D1

