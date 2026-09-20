Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC5C3C4557
	for <linux-rdma@vger.kernel.org>; Sun, 20 Sep 2026 06:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789886658; cv=none; b=Kfv/vkE9GWRWajiGqu5HPQRjDdM2ObXRCRDGhAgtnbhyI6L4XrTSmpJQkm4GTHg312RQHL6YlaiL5X9/rEKK2g/wGwIh3YOuUe1KrkAc0NhgM+fzb++T/wMlRY/tBKJcZOZO+36CUbABwjLg+3RxMHdLN9ZfJrf0NQVOTnLIn5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789886658; c=relaxed/simple;
	bh=Z2d7GiR0BbPv0BIqwCSCoq6xVwqgHUn7aCgbYUx6VQo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NTpeshg1D9ryRF0egInDw1SeIqN6OKKQOlJkYDvrfKTYVYGaCaf2sDBtkEEX5XgPYXnvNJlOic4OUqRX3DxnHEWAndDJoZrq2/2ZQA/nBstqcwcO3X1bALn5Pc3P97l1xX3GtSTdUz+ZM7cyRQvE4vevF5srwI0KmRKvobCww18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lGsmZMqP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lGsmZMqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08ED1F000FF;
	Sun, 20 Sep 2026 06:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789886656;
	bh=6N2BMv8UUVqNZKNT/bTcj8I5TqToX6z9wOCwkZlpYhk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lGsmZMqPtG324pAqi3LtE3AvRWwfBJovuPvRMPoKCcLoxeWAjzciQKfXaXohm8nOf
	 sJp7zFP+JktvEjCpBVp2DFTlMZ1UTEJW36EyMsPmyi59Gt2w0r2P6x8WVQgYxWhrN8
	 4tXeBalFDHhjpGyto52ds8bZJ3QJiVi9oDwNbMvNf9oKdmC38ZMrA1yI8p1JuLvHGL
	 7CSWSLEIzawqZG5Gq+I2Zwn0XkcIrjqxhH7BKjF2X/fPi2DInxdb5D3qqup7Cp27sh
	 HVN1sJPeM6Vol/WCKkLjkh9hxrhWl9DSPJIU6Frg/Na/sr+NsiaIOCzQ5u+9YIxBzH
	 CBwZAr+DkJV6g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] rds: ib: Clear the sg list when mapping an MR fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dongliang Qin" <cccccccccccc777777@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260920063449.1594203-1-cccccccccccc777777@gmail.com>
References: <20260920063449.1594203-1-cccccccccccc777777@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 20 Sep 2026 06:44:15 +0000
Message-Id: <20260920064415.E08ED1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rds_ib_map_frmr() stores the caller's scatterlist in the MR before DMA
> mapping and registration can fail. On failure, __rds_rdma_map() unpins
> the pages and frees the scatterlist, but rds_ib_free_frmr() can still
> return the MR to the pool with the stale pointer set.
>=20
> This leaves the pool with a dangling scatterlist and can lead to local
> privilege escalation. KASAN detects the resulting use-after-free when the
> MR is later torn down:
>=20
> BUG: KASAN: slab-use-after-free in __rds_ib_teardown_mr
> Read of size 8
>=20
> Call Trace:
>  __rds_ib_teardown_mr
>  rds_ib_unreg_frmr
>  rds_ib_flush_mr_pool
>  rds_ib_flush_mrs
>  rds_free_mr
>  rds_setsockopt
>=20
> Clear the scatterlist fields before returning an error so the caller
> retains sole ownership of the scatterlist and its pinned pages. Route a
> zero-length DMA mapping through the same cleanup path, and skip unmap
> when no mapping was created.
>=20
> Fixes: 1659185fb4d0 ("RDS: IB: Support Fastreg MR (FRMR) memory registrat=
ion mode")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dongliang Qin <cccccccccccc777777@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260920063449.1594=
203-1-cccccccccccc777777@gmail.com?part=3D1

