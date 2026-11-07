Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794083106;
	b=SFVuMdQbcGhWiIVxGoJRb2XX/Bn4zEaZnUAHrXd5vqzP/VGdjLR9c0iCkFrpnd919l1Q
	 j9rz4uzHTxdrJe1X2QeI6eojxta/8e28Bo6AVdAO/ExzCMs5blqvW9xQ0xEMc8zF3Zy4a
	 O2wjMbo8RqrXMVOEFFaCLwr3XqDjCgwyDwLizdmaMhfz4sjS4M/o4MBOMDtAFlWd/U3oa
	 0sucB0UrOse8dlMm5oRDNNocY+HB8yg0/Ya2RVApwH/z13i3hfqJrVbzTm6Pcu8qyy/Lq
	 XBeqtmtSSAQ+asSDI6gEtwksuHIc8Dh9yS8GdUSSYYpH9HRjdAApqSjW9cdiJtMhPKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794083106;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=u8Hdgh8QlUYNJeWOyQtm6kq20wm81S/bBQQZJgwtwCg=;
	b=qudDxZbUEDPMuUkvfuN9n/S0pyN+VD4efQoNu1F/uZz2q48uIPME5gqP9RpLmnHqN16q
	 09xLey4sA7rT19ElCTD3+bp8ENiYgl+rQDCIipjBLYSnhInX6H/BrBEwnrSOzMjIpLac1
	 Pa/GtDr1okiZVrFOOCP/oNPLxRWH044t5NknnObMSSZIVgg82srphS47SKeZco+Kdl9N8
	 OQ1C20kG8p5ij2GnYdcBxm3Sh7ulfH3QkRBbL/6kyFvS5T1zAOZwy22CBh+0vj5TOijE+
	 koqRjrYtfWmyUT2sMhWlgPEcJiUHRh7wbOiVlsod2znABOvIgZjcnvIl02UVrl3VmVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="AiNi/dtC";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18783606D836;
	Sat,  7 Nov 2026 20:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AiNi/dtC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02EBB1F008A1;
	Sat,  7 Nov 2026 20:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794083105;
	bh=u8Hdgh8QlUYNJeWOyQtm6kq20wm81S/bBQQZJgwtwCg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=AiNi/dtCroMm2W0X9/00WYMTfrrU6dWv+UrZJ6hpyefsG2k0jDI2CJACH9ULfuiZl
	 ZZ8THctwob0iMbcgWQJPi7Rd2IDlu4kBYoNAmqNu+/BwbTuxNGerg6d427J1M7h0UN
	 hSg48XiwS7Ry3qlUid+4f1gZ7U5gx5j73Wk7iYen0i3CUImH1p8eTA7FEjwbfX54rJ
	 0QQ8lPE+aIlERSRxRBvMKiDSmcOlKmZigaPRfHsOl2c2ktMI9GFUFPej+U89TmGyyx
	 I7Hj6i+9ZbB3O1NopeSu/VrLcSyQoENA36DaZvEYdO5c9eNFx4V6W7Hlun4xIflbCB
	 OehyTqn6yV4qg==
Subject: Re: [PATCH rdma-next 19/23] RDMA/mlx5: Clamp log_max_cq_sz shift in
 CQ size checks
From: netdev-bot+sashiko@kernel.org
To: yishaih@nvidia.com
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
 davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com,
 moshe@nvidia.com, maorg@nvidia.com
Date: Sat, 07 Nov 2026 20:25:04 +0000
Message-ID: <179408310459.994134.3829922527726679973@kernel.org>
In-Reply-To: <20261103163949.1554-20-yishaih@nvidia.com>
References: <20261103163949.1554-20-yishaih@nvidia.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The new `entries > INT_MAX` check only keeps the CQ entry count
  inside an int.

--

RDMA/mlx5: Clamp log_max_cq_sz shift in CQ size checks

This commit computes the CQ size limit with MLX5_CAP_GEN_LOGSZ_U64(), so
an untrusted log_max_cq_sz no longer causes an undefined shift. The
requested entry count is now rounded up in 64 bits. Sizes above INT_MAX
are rejected in the create and resize paths.

> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
> index f955eb762051d..25344dfba1c12 100644
> --- a/drivers/infiniband/hw/mlx5/cq.c
> +++ b/drivers/infiniband/hw/mlx5/cq.c

[ ... ]

> @@ -1226,12 +1237,14 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
>  	int cqe_size;
>  	int eqn;
>  	int err;
> +	u64 max_cq_entries = MLX5_CAP_GEN_LOGSZ_U64(dev->mdev, log_max_cq_sz);
>
> -	if (attr->cqe > (1 << MLX5_CAP_GEN(dev->mdev, log_max_cq_sz)))
> +	if (attr->cqe > max_cq_entries)
>  		return -EINVAL;
>
> -	entries = roundup_pow_of_two(entries + 1);
> -	if (entries > (1 << MLX5_CAP_GEN(dev->mdev, log_max_cq_sz)))
> +	entries = cq_roundup_entries(entries);
> +	/* cq->ibcq.cqe and create_cq_kernel() take an int */
> +	if (entries > max_cq_entries || entries > INT_MAX)
>  		return -EINVAL;

[Severity: High]
Is INT_MAX the right bound here? It keeps the entry count inside an int,
but the CQ buffer's byte size is still computed from it in 32-bit
arithmetic.

With a device-reported log_max_cq_sz of 26 or more, entries can now be up
to 2^30. They are then passed to create_cq_kernel() and on to
alloc_cq_frag_buf():

drivers/infiniband/hw/mlx5/cq.c:alloc_cq_frag_buf() {
    ...
	err = mlx5_frag_buf_alloc_node(dev->mdev,
				       nent * cqe_size,
				       frag_buf,
				       dev->mdev->priv.numa_node);
    ...
}

Both values are powers of two. So nent * cqe_size wraps to exactly 0 for
nent >= 2^26 with 64-byte CQEs. With 128-byte CQEs
(cache_line_size() == 128) it wraps at nent >= 2^25.

With size 0, mlx5_frag_buf_alloc_node() sets npages to 0, and
kcalloc_node(0, ...) returns ZERO_SIZE_PTR. The function then returns
success, and buf->nent is still set to the full count.

init_cq_frag_buf() then does:

	for (i = 0; i < buf->nent; i++) {
		cqe = mlx5_frag_buf_get_wqe(&buf->fbc, i);
		...
	}

Won't mlx5_frag_buf_get_wqe() dereference fbc->frags[0].buf through
ZERO_SIZE_PTR on the first iteration and oops?

mlx5_ib_resize_cq() with udata == NULL has the same INT_MAX-only check.
It reaches the same code through resize_kernel()->alloc_cq_frag_buf()->
init_cq_frag_buf().

The user path in mlx5_ib_create_user_cq() has a similar problem.
create_cq_user() passes this as the minimum umem size:

	cq->buf.umem = ib_umem_get_cq_buf_or_va(&dev->ib_dev, attrs,
						ucmd.buf_addr,
						entries * ucmd.cqe_size,
						IB_ACCESS_LOCAL_WRITE);

That is a 32-bit unsigned multiply, and it wraps to 0 the same way. On the
UMEM-attribute path, the only length check in ib_umem_get_desc_check() is
umem->length < min_size, so any umem passes. The device is still
programmed with log_cq_size = ilog2(entries). resize_user() already uses
(size_t)ucmd.cqe_size * entries for this.

The commit message says a large limit made the CQ size get "truncated
when passed on as an int". Since create_cq_kernel() still multiplies that
int by cqe_size, can this truncation still happen?

Should the bound account for the CQE size, for example by rejecting
entries > INT_MAX / 128? Another option would be to compute the byte size
in size_t with check_mul_overflow().

>
>  	cq->ibcq.cqe = entries - 1;

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103163949.1554-1-yishaih%40nvidia.com
