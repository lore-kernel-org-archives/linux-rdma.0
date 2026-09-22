Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAB133C1B6
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 03:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790047516; cv=none; b=XQamCmf9aJAN4iBks7PZfyeqPdh0iidZumaKAftkuyKoQr0Ld4/K3Z4+CmdlWR6y6LmIg9LqRXL7cDL/IYezyeGWZ7oDccnJeA4gzrbEzi8aUd8JMzC1szrzhRspwaBl+k5UhukKiM/8rCk+pN0Uo9ukkH38dVnGVKcAeDtgLyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790047516; c=relaxed/simple;
	bh=Mp9RPjheMljMNPGJG1VVf1Gs8lCPBWfymVFW9yTPtOI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LsFbMrLZq+vQcoxDTYMIFX5li7C/tiUmptILXp5Iy6B+gGLHv+FESXs7+8bZO4uZClFudXIZ1x5sFaNKzLmUkjsyBQ69Ib+St6I6oK0frOyppEzVfs8yAGhskPwGZlhvPvO2DppUMXqUZMYCHq13V2C3p+nm9ZRzwpofYiD8wvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g7X5gwsx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g7X5gwsx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140431F000FF;
	Tue, 22 Sep 2026 03:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790047514;
	bh=i2rWsKawjRgaVDEvBrYeXuCvj7mlVqwtyXYj+uLU2a8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g7X5gwsx6tj/37q89qP74ig9G4DqptfD9ZgUIHy+dgyA7oObTbzKmVQ4f6aDi4Yzp
	 nrkSMPUGZO0RvqBvM9sH7iK6GhF4tUyYC0FxTUiix4r2D1tw0gQR4yeBCE2L9XbUzG
	 rGBkC8Ivi5A3Wx4pdzYE0gTCdqow7bmpCe8ffPz7fmgRlQ24vTh8ep7Jh83wEns+O+
	 m9PYdPZ8yzBa/bjp8Y3Zxbgwd4bT2k+e9HTc01t45gGSWCzJrV9Zfxw3gqRj4lhEEQ
	 0PoKuJ/BhP888OMkisqVj4+vLIpvzhXBMsoZFxUN3TVD3z1LaxOiaMRPGbUVIdSWuD
	 7aD4BOEkKJ9KQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2] rds: ib: Clear the sg list when mapping an MR
 fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dongliang Qin" <cccccccccccc777777@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922031546.3874605-1-cccccccccccc777777@gmail.com>
References: <20260922031546.3874605-1-cccccccccccc777777@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 03:25:13 +0000
Message-Id: <20260922032514.140431F000FF@smtp.kernel.org>
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
> Store the scatterlist in the MR only after DMA mapping succeeds. If DMA
> mapping fails, return directly while the MR fields remain clear; the call=
er
> keeps ownership of the scatterlist and its pinned pages. If a later
> registration step fails, unmap the scatterlist and clear the MR fields
> before returning.
>=20
> Fixes: 1659185fb4d0 ("RDS: IB: Support Fastreg MR (FRMR) memory registrat=
ion mode")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dongliang Qin <cccccccccccc777777@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922031546.3874=
605-1-cccccccccccc777777@gmail.com?part=3D1

