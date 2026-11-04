Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810633;
	b=J7/6vj/QkAj6EkxPOyzB+tkth/EhEj0Qv5jkumEaNMgmww9vR/riYbpfCznAN7t9kETh
	 m/qypsEBEd6rDcQumpapb5lj2UHzOTniaKSya8VBSyTJHeQCA7Fw88Sebn08BGt1VTP+b
	 qhZ7TGfJSqp6lA9URzXql8g983Ck6P0lOntqgfpISfw4cDxom63XnmVyyHrLLye97OMyY
	 ALJI5uS9SzheAUAsfKxgBYVffifjOCAd/UM8f0M2Wdn+SMSWtbNWEWp5gpV8XGTLOGGaZ
	 CRAKgDQ/x8aR3pfmvY+UF/XCGw7NM4Sbvr5TbBM2zIoUXtug4JU+jGSQg5gOkoOczyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810633;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=eFjWSqSc7UPnmL4/uNBinRf1+qNfQ9Y/vJjgTlMjQmo=;
	b=Kl83cDCwofylFLGf+EghZ/5/pgoKORdEvAoKH/ab69yfhAM40dNgnbt0iflEWXj4VW8N
	 3CF37vQyGUFAfpA/cViK6jsW8w+qNGxoIuKo5AVzZW0nOKC50/B8CmwzfSO0ZL54Bewg+
	 /zAg6LzkEAW75amk4A2bcET0yA3Hb8d7I/z/k5WqRQB10dN2dw4Rs3iEZHqM03UJXLpZC
	 hSjXCgCI2u904hhJayx9LqOnqxpCn3fZ+ZnHnHlf/4mrJvXHf64QPh6bupxvb/bysxLdh
	 rdbamwbYm1YD5ApJ7GySf28cGMLW2wkW6JM0QBxE2R96X51TjDgx0RQ47YFYNL8V2zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BkGG+fEa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE72606D809
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 16:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BkGG+fEa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F9F1F00A02;
	Wed,  4 Nov 2026 16:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810632;
	bh=eFjWSqSc7UPnmL4/uNBinRf1+qNfQ9Y/vJjgTlMjQmo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BkGG+fEa5lRFPRlgHWKWA9BhJqyfLfKvJ/nWGT7rhhK1LiNPEPCOGfSuchOcjLTjj
	 gNF9UKKFkFTw78i76jMEj1KKcK7su4vA9Fj6lh+9A3CZ+l4D531FQsS0lsPlJ8d4PX
	 ADQk65CWYPKY7c2/mKhKm4PbKuoAghqJImld4Y2WRuLuW18Ip9siIP9Mjo3xTg+33H
	 OzqLp46jR/qgyODheVZ58HdjBtNlDUQRA8OAe9zS0WSZk9M4UmD6gf1VuXHRzWFw5l
	 LbqRS5VFsDOutn2fszwtnkPlRJF4p9MUoEqacIDv3zg84e2kSsahtbRhvNjnOb9uuA
	 +W96eStjW7E5Q==
Message-ID: <sashiko-outbox-197672@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 19/23] RDMA/mlx5: Clamp log_max_cq_sz shift in
 CQ size checks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103163949.1554-20-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-20-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 16:43:52 +0000
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
- [High] RDMA/mlx5: 32-bit entries * cqe_size overflow in CQ create and res=
ize
--

commit 23d4d478ec288a1c091e2edf580c64eccf4e7c49
Author: Yishai Hadas <yishaih@nvidia.com>

RDMA/mlx5: Clamp log_max_cq_sz shift in CQ size checks

This commit replaces the 32-bit shift of log_max_cq_sz with
MLX5_CAP_GEN_LOGSZ_U64(), rounds up the requested CQ entry count using 64-b=
it
arithmetic, and rejects rounded-up entry counts above INT_MAX in the CQ cre=
ate
and resize paths.

> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5=
/cq.c
> index f955eb762051d..25344dfba1c12 100644
> --- a/drivers/infiniband/hw/mlx5/cq.c
> +++ b/drivers/infiniband/hw/mlx5/cq.c
> @@ -1117,6 +1117,15 @@ static void notify_soft_wc_handler(struct work_str=
uct *work)
>  	cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context);
>  }
> =20
> +/*
> + * Next power of 2 above entries. It can be 2^32, which doesn't fit the
> + * unsigned long of roundup_pow_of_two() on 32-bit archs.
> + */
> +static u64 cq_roundup_entries(u64 entries)
> +{
> +	return 1ULL << fls64(entries);
> +}
> +
>  int mlx5_ib_create_user_cq(struct ib_cq *ibcq,
>  			   const struct ib_cq_init_attr *attr,
>  			   struct uverbs_attr_bundle *attrs)
> @@ -1124,7 +1133,7 @@ int mlx5_ib_create_user_cq(struct ib_cq *ibcq,
>  	struct ib_udata *udata =3D &attrs->driver_udata;
>  	struct ib_device *ibdev =3D ibcq->device;
>  	struct mlx5_ib_create_cq_resp uresp =3D {};
> -	int entries =3D attr->cqe;
> +	u64 entries =3D attr->cqe;
>  	int vector =3D attr->comp_vector;
>  	struct mlx5_ib_dev *dev =3D to_mdev(ibdev);
>  	struct mlx5_ib_cq *cq =3D to_mcq(ibcq);
> @@ -1136,15 +1145,17 @@ int mlx5_ib_create_user_cq(struct ib_cq *ibcq,
>  	int cqe_size;
>  	int eqn;
>  	int err;
> +	u64 max_cq_entries =3D MLX5_CAP_GEN_LOGSZ_U64(dev->mdev, log_max_cq_sz);
> =20
> -	if (attr->cqe > (1 << MLX5_CAP_GEN(dev->mdev, log_max_cq_sz)))
> +	if (attr->cqe > max_cq_entries)
>  		return -EINVAL;
> =20
>  	if (check_cq_create_flags(attr->flags))
>  		return -EOPNOTSUPP;
> =20
> -	entries =3D roundup_pow_of_two(entries + 1);
> -	if (entries > (1 << MLX5_CAP_GEN(dev->mdev, log_max_cq_sz)))
> +	entries =3D cq_roundup_entries(entries);
> +	/* cq->ibcq.cqe and create_cq_user() take an int */
> +	if (entries > max_cq_entries || entries > INT_MAX)
>  		return -EINVAL;
> =20
>  	cq->ibcq.cqe =3D entries - 1;
> @@ -1214,7 +1225,7 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const str=
uct ib_cq_init_attr *attr,
>  		      struct uverbs_attr_bundle *attrs)
>  {
>  	struct ib_device *ibdev =3D ibcq->device;
> -	int entries =3D attr->cqe;
> +	u64 entries =3D attr->cqe;
>  	int vector =3D attr->comp_vector;
>  	struct mlx5_ib_dev *dev =3D to_mdev(ibdev);
>  	struct mlx5_ib_cq *cq =3D to_mcq(ibcq);
> @@ -1226,12 +1237,14 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const s=
truct ib_cq_init_attr *attr,
>  	int cqe_size;
>  	int eqn;
>  	int err;
> +	u64 max_cq_entries =3D MLX5_CAP_GEN_LOGSZ_U64(dev->mdev, log_max_cq_sz);
> =20
> -	if (attr->cqe > (1 << MLX5_CAP_GEN(dev->mdev, log_max_cq_sz)))
> +	if (attr->cqe > max_cq_entries)
>  		return -EINVAL;
> =20
> -	entries =3D roundup_pow_of_two(entries + 1);
> -	if (entries > (1 << MLX5_CAP_GEN(dev->mdev, log_max_cq_sz)))
> +	entries =3D cq_roundup_entries(entries);
> +	/* cq->ibcq.cqe and create_cq_kernel() take an int */
> +	if (entries > max_cq_entries || entries > INT_MAX)
>  		return -EINVAL;
> =20
>  	cq->ibcq.cqe =3D entries - 1;
> @@ -1532,18 +1545,22 @@ int mlx5_ib_resize_cq(struct ib_cq *ibcq, unsigne=
d int entries,
>  	int inlen;
>  	int cqe_size;
>  	unsigned long flags;
> +	u64 entries64 =3D entries;
> +	u64 max_cq_entries =3D MLX5_CAP_GEN_LOGSZ_U64(dev->mdev, log_max_cq_sz);
> =20
>  	if (!MLX5_CAP_GEN(dev->mdev, cq_resize)) {
>  		pr_info("Firmware does not support resize CQ\n");
>  		return -ENOSYS;
>  	}
> =20
> -	if (entries > (1 << MLX5_CAP_GEN(dev->mdev, log_max_cq_sz)))
> +	if (entries64 > max_cq_entries)
>  		return -EINVAL;
> =20
> -	entries =3D roundup_pow_of_two(entries + 1);
> -	if (entries > (1 << MLX5_CAP_GEN(dev->mdev, log_max_cq_sz)) + 1)
> +	entries64 =3D cq_roundup_entries(entries64);
> +	/* resize_user() and resize_kernel() take an int */
> +	if (entries64 > max_cq_entries + 1 || entries64 > INT_MAX)
>  		return -EINVAL;
> +	entries =3D entries64;

[Severity: High]
When an untrusted NIC reports log_max_cq_sz >=3D 24, bounding the rounded-up
entry count only by INT_MAX allows power-of-two values of entries from 2^24
up to 2^30 to reach the downstream buffer size calculations. Can those 32-b=
it
multiplications by cqe_size still overflow?

In mlx5_ib_create_user_cq() -> create_cq_user(), entries (int) is multiplied
by ucmd.cqe_size (__u32, validated as 64 or 128) in 32-bit unsigned
arithmetic before widening to size_t:

drivers/infiniband/hw/mlx5/cq.c:create_cq_user() {
	...
	cq->buf.umem =3D ib_umem_get_cq_buf_or_va(&dev->ib_dev, attrs,
						ucmd.buf_addr,
						entries * ucmd.cqe_size,
						IB_ACCESS_LOCAL_WRITE);
	...
}

For entries in 2^25..2^30 with ucmd.cqe_size =3D=3D 128 (or 2^26..2^30 with
ucmd.cqe_size =3D=3D 64), entries * ucmd.cqe_size wraps to 0, which lets a
1-page user buffer pass the min_size check in ib_umem_get_desc_check() while
programming log_cq_size =3D 25..30 in the CQ context.

Similarly, in mlx5_ib_create_cq() -> create_cq_kernel() ->
alloc_cq_frag_buf() and mlx5_ib_resize_cq() -> resize_kernel() ->
alloc_cq_frag_buf(), nent * cqe_size is evaluated as a signed 32-bit int and
passed as int size to mlx5_frag_buf_alloc_node():

drivers/infiniband/hw/mlx5/cq.c:alloc_cq_frag_buf() {
	...
	err =3D mlx5_frag_buf_alloc_node(dev->mdev,
				       nent * cqe_size,
				       frag_buf,
				       dev->mdev->priv.numa_node);
	...
}

For nent =3D=3D 2^24 (with cqe_size =3D=3D 128) or nent =3D=3D 2^25 (with c=
qe_size =3D=3D 64),
nent * cqe_size overflows to INT_MIN, and for nent >=3D 2^25 (cqe_size =3D=
=3D 128)
or nent >=3D 2^26 (cqe_size =3D=3D 64), it wraps to 0. When size is 0,
mlx5_frag_buf_alloc_node() sets frag_buf->frags =3D ZERO_SIZE_PTR and retur=
ns 0,
and init_cq_frag_buf() then dereferences ZERO_SIZE_PTR when iterating over
buf->nent:

drivers/infiniband/hw/mlx5/cq.c:init_cq_frag_buf() {
	for (i =3D 0; i < buf->nent; i++) {
		cqe =3D mlx5_frag_buf_get_wqe(&buf->fbc, i);
		cqe64 =3D buf->cqe_size =3D=3D 64 ? cqe : cqe + 64;
		cqe64->op_own =3D MLX5_CQE_INVALID << 4;
	}
}

Would it make sense to cap entries so that entries * cqe_size cannot overfl=
ow
int (or use check_mul_overflow() in create_cq_user() and alloc_cq_frag_buf(=
))?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103163949.1554=
-1-yishaih@nvidia.com?part=3D19
