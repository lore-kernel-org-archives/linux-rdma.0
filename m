Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795874373;
	b=dLoQDtkGXX7YrNCv/y4oWcYNyW7H0UL1kKP19TyaGaRMHNKzIL6x6wG3UL+GQiE3eDvl
	 I6Lib11c5gqHIICxi2Uq25i28F964IQi2DDaeRbLyPhUGjSR3MXB/sqTeppIWEMAS0F15
	 pdKH9ANE0Y4HZ2euZOZuNJbeGVp5Pk/ojBWGaXjCIdiNEP5JV1FVA3I1WLCKFdX817H2z
	 hw3j5Jk9LVG7artb4Xe8Q2H2RMOPMPGlhfI+ORS9AreREUUD37sqLNcgt7qaPy0x1i0ri
	 rEHuM5na1D1th27YLg9s7Bx4NR9rb81hiC81FxiBTKwWCel4sxkTHEGDfa0/2OupFiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795874373;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=pAyFWspsg2KJzxteq2b2BD5vP7dS0KowKr45fpgf8N8=;
	b=pn4bbLVa5lROP9HAY5jXoKqYZ2f0HNHzBgXOxHPd0VlFJmzJkEQroi9t81hD+1f7Yp8z
	 PA8F/g996V05KS4PKA+zniagBoapMRnAJ5pWx8JIv1cNR9+b0c1h8YC5lVCDFcJw2v/1D
	 fEQirbtBdGW1V0jpdZEASiBfyOqZbPi8LjjiS7lpUCOkBE6vsuxLpdm2JRPCvGuVpU6hz
	 wIueXsoMSqarF+E8r1zXV16TOi6sgwL8+fDxqJwH7SFA8qH82FEpnaTTvDQ536g1WX0Z3
	 YsJh4CDUTo8Ng6yWi5wyKeIpT33Cf5frviJ9Ix3JFXWO3pu1gqMKsA2ApIp/3qPqB1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mSkUJkPW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC470606A31C
	for <linux-rdma@vger.kernel.org>; Sat, 28 Nov 2026 13:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mSkUJkPW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552431F000C1;
	Sat, 28 Nov 2026 13:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795874373;
	bh=pAyFWspsg2KJzxteq2b2BD5vP7dS0KowKr45fpgf8N8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mSkUJkPWNt+KSTddnKVo/yDNvLBrSF8ttrhFhyIHq4GjozcPAa41srsmdKQgCVW6L
	 b15bbX7WceK4Q+ysAu/9EZ8Jgjda8YGTwghSbA6MrnoPWdT4ZVMWfAzji1tpmJgIBL
	 wIlHka3raQOeaYlGk7AvwcVXrbneoUrb6LCDVOswhhvEQPDOsdW1oA27WkrsmMTbYN
	 9nahD9I0HvIjSjcgOcaL/lbJ20Vqnbw+ElHLPLJHlplZnJ0HfLYTpz2pDtXMEDF5ZM
	 lnH179JvpgeAYnAWLhZFkdWEEanWYWiL28+VYtdkKgOvyZb9yRkoItJq3XF0S7JZfo
	 STJV/rulHlnEA==
Message-ID: <sashiko-outbox-238737@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 3/3] RDMA/mlx5: Try pinned revocable dmabuf
 import by default
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Srouji" <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org, media-ci@linuxtv.org
In-Reply-To: <20261128-mlx5-pinned-revocable-dmabuf-v1-3-a4cde143a58e@nvidia.com>
References: <20261128-mlx5-pinned-revocable-dmabuf-v1-0-a4cde143a58e@nvidia.com>
 <20261128-mlx5-pinned-revocable-dmabuf-v1-3-a4cde143a58e@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 28 Nov 2026 13:59:32 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] RDMA/mlx5: user-triggerable WARN_ON(!page_size) in
  alloc_cacheable_mr()
--

commit d5740621fb40d604a240c4d889b540a19d43d88d
Author: Yishai Hadas <yishaih@nvidia.com>

RDMA/mlx5: Try pinned revocable dmabuf import by default

This commit attempts a pinned, revocable dma-buf attachment by default
when registering dma-buf MRs so the mkey can be sized exactly, falling
back to movable ODP dma-buf import when the exporter does not support it.

> diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5=
/mr.c
> index 4bd911e0596c6..55e6d8656692e 100644
> --- a/drivers/infiniband/hw/mlx5/mr.c
> +++ b/drivers/infiniband/hw/mlx5/mr.c
> @@ -430,7 +430,7 @@ static struct mlx5_ib_mr *alloc_cacheable_mr(struct i=
b_pd *pd,
>  	struct mlx5_ib_mr *mr;
>  	unsigned long page_size;
> =20
> -	if (umem->is_dmabuf)
> +	if (umem->is_dmabuf && !to_ib_umem_dmabuf(umem)->pinned)
>  		page_size =3D mlx5_umem_dmabuf_default_pgsz(umem, iova);
>  	else
>  		page_size =3D mlx5_umem_mkc_find_best_pgsz(dev, umem, iova,

[Severity: Medium]
Can an unprivileged user trigger the WARN_ON(!page_size) right below this
in alloc_cacheable_mr() when registering a pinned dmabuf MR?

UVERBS_METHOD_REG_DMABUF_MR only checks that offset and iova share the
same sub-page alignment, and ib_umem_dmabuf_get_pinned_revocable_and_lock()
validates offset + size against the dmabuf size without checking iova.
Previously, dmabuf MRs used mlx5_umem_dmabuf_default_pgsz() here and
checked mlx5_umem_dmabuf_find_best_pgsz() later in
mlx5_ib_dmabuf_mr_update_pas(), which returns -EINVAL without warning when
page_size is 0.

With pinned dmabuf MRs now calling mlx5_umem_mkc_find_best_pgsz() ->
ib_umem_find_best_pgsz() in alloc_cacheable_mr(), a user-supplied iova
where iova + length - 1 overflows u64 causes ib_umem_find_best_pgsz() to
return 0 and hit WARN_ON(!page_size) (likewise if KSM alignment constraints
clear the page-size bitmap).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261128-mlx5-pinne=
d-revocable-dmabuf-v1-0-a4cde143a58e@nvidia.com?part=3D3
