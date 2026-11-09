Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794235923;
	b=TenABA3MtYFmWIUsJn2U8m1z3a8ApCcpjPPVA/a5T9QLK0+gZKvLaLzVSREO00yu9vwI
	 zU7AzBUNYx6WxXo2GWA0oHipllktmwTZf9XEktGodMyC0cKYP54n/1fuULIl0ckg8h4M+
	 aOZJO7TwiPOXbsPpS/G6ww3ILaU5tIBo0P57gVvzQWH04WQ4rqwsjFWntUoHrz+vFuGQm
	 F/+cwtCrMEsP0tkapgF4gXdJlF1GceiCB5z+BojKSuMVuJX62Xua7ogNvv7cvut9OmyoM
	 z69PYcGYNT9lvertP7OIVfK+pOhfC6eev5OKi6P51O54QJWP41ZSNmbRZbwMIGXgDDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794235923;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=H1ycjNp1FpVD83aupsGyF2+nao+v2if0Nu2MqxeK9cU=;
	b=N2Z9Hvq+nUogvJJk9+mmXQLmNNeTsyxZQ1rzOzQgHOuldEpU+Ub1Q+QW+kmhAQg+zjjb
	 qHq8jejnu3VJNgWwa8qlnGxGrqSvPU8QjHdQuN91Uik1FtOTL3SRnTMp130e4esT2U67H
	 dnwRxYpP2k+ZqBPF/chdoXlXgC/kuiymJBQRIuPmn2HLR9L18JrlXWFTruRlHzHyr+ZD1
	 GDx4i3+OTV5EH5a+Ly1+qyDnY8sEHHeBoa1DFXGaMpG5jlIVIKbvfHI6nziiC8QQiq5Yy
	 zom9gUDsHaksiFzFvYQnHbBZPnN7w/sl/fUT7aFrV/kw0lnF6RRuYW9pUW5YJ9Rf4EA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fhRKzOOh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C160B606A31C
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 14:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fhRKzOOh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7530F1F0089F;
	Mon,  9 Nov 2026 14:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794235922;
	bh=H1ycjNp1FpVD83aupsGyF2+nao+v2if0Nu2MqxeK9cU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fhRKzOOhn8YZm77eICHJYVQ/0mikRmhDrCyGZUNEXZ2puyCH+RvtAh/QLjTuL+abN
	 J3C7/JBa0MREElFrhtpwAfJnL+OpZ44wz64wujT/w023KcIU/k80wZN1dBMA2Ckgpz
	 88+KUk1hLjbt5JA5Ljs8nhHhn1QfvFwIbnNJslA9iDjp8cSbOMK4Kpx5UJJKZ1hr98
	 2hNLAH80zkX/NwJH+AaPXDigR74x/YKSNRcAnd37YnzRr58kt2UCXirilPsEzACW/7
	 gRpJSJ9q6dwpc/0qS4FlPKrci46f9cuH7kv5T0a1npQvqbraSfp8rr3qQyODc899nR
	 h0QFtxSS/6xEg==
Message-ID: <sashiko-outbox-205134@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 1/2] RDMA/mlx5: Fix DEVX UMEM mailbox size
 truncation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Srouji" <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109-devx-umem-mailbox-overflow-v1-1-4a63baab25dc@nvidia.com>
References: <20261109-devx-umem-mailbox-overflow-v1-0-4a63baab25dc@nvidia.com>
 <20261109-devx-umem-mailbox-overflow-v1-1-4a63baab25dc@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 14:52:02 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Medium] RDMA/mlx5: devx_umem_find_best_pgsize() ignores pgsz_bitmap
  after halving page_size [1]
--

commit bd5b83068caa4612b47dcf836a1a42f89cbb5cc5
Author: Uri Dar <udar@nvidia.com>

RDMA/mlx5: Fix DEVX UMEM mailbox size truncation

This commit changes cmd->inlen in struct devx_umem_reg_cmd to int and adds
overflow checks when computing the CREATE_UMEM mailbox size in
devx_umem_reg_cmd_alloc().

> diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/ml=
x5/devx.c
> index fc6f793dcc658..1da6c0e440d6e 100644
> --- a/drivers/infiniband/hw/mlx5/devx.c
> +++ b/drivers/infiniband/hw/mlx5/devx.c

[ ... ]

> @@ -2361,9 +2362,12 @@ static int devx_umem_reg_cmd_alloc(struct mlx5_ib_=
dev *dev,
>  	if (!page_size)
>  		return -EINVAL;
> =20
> -	cmd->inlen =3D MLX5_ST_SZ_BYTES(create_umem_in) +
> -		     (MLX5_ST_SZ_BYTES(mtt) *
> -		      ib_umem_num_dma_blocks(obj->umem, page_size));
> +	num_mtt =3D ib_umem_num_dma_blocks(obj->umem, page_size);
> +	if (check_add_overflow(MLX5_ST_SZ_BYTES(create_umem_in),
> +			       size_mul(MLX5_ST_SZ_BYTES(mtt), num_mtt),
> +			       &cmd->inlen))
> +		return -EINVAL;

[Severity: Medium]
This problem wasn't introduced by this patch, but can
devx_umem_find_best_pgsize() return a page_size that is not set in
pgsz_bitmap [1]?

drivers/infiniband/hw/mlx5/devx.c:devx_umem_find_best_pgsize() {
	...
	page_size =3D ib_umem_find_best_pgoff(umem, pgsz_bitmap, U64_MAX);
	if (!page_size)
		return 0;
	...
	while ((ib_umem_dma_offset(umem, page_size) !=3D 0 ||
		(umem->length % page_size) !=3D 0) &&
		page_size > PAGE_SIZE)
		page_size /=3D 2;

	return page_size;
}

When a physically contiguous umem is registered with a restricted
MLX5_IB_ATTR_DEVX_UMEM_REG_PGSZ_BITMAP, ib_umem_find_best_pgoff() selects
the largest matching bit regardless of DMA offset or total length, and the
loop then halves page_size without checking that the reduced size is still
present in pgsz_bitmap.  devx_umem_reg_cmd_alloc() then registers the umem
with a page size that userspace excluded instead of returning -EINVAL.

[1] https://sashiko.dev/#/bug/linux-6cd20db6-58c6-4b3d-8dd9-c9ee893d4041

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-devx-umem-=
mailbox-overflow-v1-0-4a63baab25dc@nvidia.com?part=3D1
