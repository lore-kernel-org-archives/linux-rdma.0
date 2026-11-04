Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810634;
	b=A0qWGVGKuVVAC1MxzLFKLqgQszf4aFtRaIhiPmg0ZimqoD6w+L0Z0G0JKYbUybd76huL
	 DPRHtC7u9eFzMvixR/2tG573vLiW4Fl+Q5pLtMs/UQW0SdZsjBKa4n2DaYqeGPosH//cW
	 U2E1aLuBSwFUn6f+pvSbVbe9Ysh4GRd6jTXIuyyStD9l14sxRQ2LRxkf4jECkb9q29SNL
	 63sguTmb7cHrZ/juqSFz5YRh6PHen96vEHvroqCSGM4WrrctUmzIJwgL+yvjU6g3Pu7+r
	 nsYdbJkUNfcCJLfhAsOxlkuwEjhhwwDnYYgqeReinMoEqqV8iXrYI0DV4RzCqohZX/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810634;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=rRQIlginqZ2omfbAf6NNB80CSADAzdCk0YQEqDezqiM=;
	b=s2SfXGE4/5b5rYSpU2GH26sLY4Q/cZArcrR17v/O3nj+25EcCD9gPiMVL8tBP5Jf6iB3
	 20Fjgh7873DBV2gqZkloTyBXcl2XjQE2RHbI2/v9CmkmRSKACPAn+/uMoE2xLqPo04Sui
	 tbuZOmK9U9rl2df3Yorj+LHONkrMvUbMocSjdEjgiA5hyGdXVfX0IXd3dcUXUYev977qZ
	 CdlNNZDI5rEu4XDfy5NDhhaWb2LTxrnhTNZwcEX3bN5WMtphZxbxpibtdHBOOw/0fqtHF
	 wiisTQsoUu6JCY/0K86VwpHQl3ePgZUQoXZ2Vh0VWHYjIaokiI+qN1C2YR23NKQrskA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="KJnjzfZ/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF371606D816
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 16:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KJnjzfZ/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A06731F00919;
	Wed,  4 Nov 2026 16:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810633;
	bh=rRQIlginqZ2omfbAf6NNB80CSADAzdCk0YQEqDezqiM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KJnjzfZ/HRKnmkPMxb/Mr+TjsT8qwE6kyrsz69iGK93IwxGEIX5f4mLaCVR5NvhS2
	 rAhvnDPFAwqJi+4Jm7Rmz0caDxp8Wshh7HSh1//4aly4TLNvKjXmeZWQJNnLeCUF+Q
	 WT4n4SFt6MJEVwE0nBVzF24r/QrUUcw1mnAaK5oeVLzwYX3U8AZ6hLbsSTyVmeGdpw
	 L7Uo0rxuP3BGjrosIuXrUTYZbTyODkC6odA1yKTNgyYiRRFkZEoMH60pfhKLmiHQqw
	 fn7I1+q2WW6ZoxycSIhc6KYOWVZYHRJR/jlO8GVj05xNoR12TsaPkNG4dq6HnEmtHo
	 6HglGMY0h6Amg==
Message-ID: <sashiko-outbox-197674@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 21/23] RDMA/mlx5: Clamp log_max_* shifts in
 query_device and ucontext paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103163949.1554-22-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-22-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 16:43:53 +0000
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
- [High] RDMA/mlx5: integer overflow and size truncation in mlx5_ib_create_=
srq()
--

commit 9361613960626bd9707489f3ac7caf042edc2d19
Author: Yishai Hadas <yishaih@nvidia.com>

RDMA/mlx5: Clamp log_max_* shifts in query_device and ucontext paths

This commit replaces open-coded shifts of 8-bit log_max_* and log_pg_sz
firmware capabilities with MLX5_CAP_GEN_LOGSZ_U32() and
MLX5_CAP_GEN_LOGSZ_U64() in device, port, ucontext, and SRQ paths, and
saturates products that can now exceed 32 bits.

> diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx=
5/srq.c
> index 6a4a937d97ce9..3fbb0eaf12558 100644
> --- a/drivers/infiniband/hw/mlx5/srq.c
> +++ b/drivers/infiniband/hw/mlx5/srq.c
> @@ -198,7 +198,7 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
>  	size_t buf_size;
>  	int err;
>  	struct mlx5_srq_attr in =3D {};
> -	__u32 max_srq_wqes =3D 1 << MLX5_CAP_GEN(dev->mdev, log_max_srq_sz);
> +	__u32 max_srq_wqes =3D MLX5_CAP_GEN_LOGSZ_U32(dev->mdev, log_max_srq_sz=
);
>  	__u32 max_sge_sz =3D  MLX5_CAP_GEN(dev->mdev, max_wqe_sz_rq) /
>  			    sizeof(struct mlx5_wqe_data_seg);

[Severity: High]
With MLX5_CAP_GEN_LOGSZ_U32(), max_srq_wqes can now reach 2^31 (0x80000000U)
when the firmware reports log_max_srq_sz >=3D 31, which allows
init_attr->attr.max_wr values in [0x40000000, 0x7fffffff] to pass the
init_attr->attr.max_wr >=3D max_srq_wqes check in mlx5_ib_create_srq().

Can this overflow srq->msrq.max and truncate buf_size later in
mlx5_ib_create_srq()?

drivers/infiniband/hw/mlx5/srq.c:mlx5_ib_create_srq() {
	...
	srq->msrq.max    =3D roundup_pow_of_two(init_attr->attr.max_wr + 1);
	...
	buf_size =3D srq->msrq.max * desc_size;
	if (buf_size < desc_size)
		return -EINVAL;

	in.type =3D init_attr->srq_type;

	if (udata)
		err =3D create_srq_user(ib_srq->pd, srq, &in, udata, buf_size);
	else
		err =3D create_srq_kernel(dev, srq, &in, buf_size);
	...
}

In struct mlx5_core_srq (drivers/infiniband/hw/mlx5/srq.h), max is a signed
int:

	int max;

When init_attr->attr.max_wr is in [2^30, 2^31 - 1],
roundup_pow_of_two(init_attr->attr.max_wr + 1) evaluates to 2^31, which
overflows srq->msrq.max to INT_MIN. On 64-bit platforms,
srq->msrq.max * desc_size sign-extends srq->msrq.max to size_t before
multiplying by desc_size (a power of two >=3D 32), producing a large non-ze=
ro
size_t (for example, 0xfffffff000000000UL when desc_size =3D=3D 32) that pa=
sses
buf_size < desc_size.

Even when log_max_srq_sz is in [26, 30] and srq->msrq.max stays positive
(e.g. in [2^26, 2^30]), size_t buf_size is >=3D 2^31 and is passed to
create_srq_user() or create_srq_kernel(), both of which take int buf_size:

	static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
				   struct mlx5_srq_attr *in,
				   struct ib_udata *udata, int buf_size)

	static int create_srq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_srq *=
srq,
				     struct mlx5_srq_attr *in, int buf_size)

This truncates buf_size to 0 (when buf_size is a multiple of 2^32) or a
negative int.

In mlx5_ib_create_srq() -> create_srq_user(), buf_size =3D=3D 0 passes
min_size =3D 0 to ib_umem_get_attr_or_va(), bypassing the minimum buffer si=
ze
check on the UVERBS_ATTR_CREATE_SRQ_BUF_UMEM path; then
in.log_size =3D ilog2(srq->msrq.max) on a negative srq->msrq.max yields 63,
and mlx5_cmd_create_srq() -> create_srq_split() -> create_rmp_cmd() ->
get_pas_size() executes an undefined shift:

	u32 rq_sz =3D 1 << (log_srq_size + 4 + log_rq_stride);

followed by a WARN_ON in __set_srq_page_size().

In mlx5_ib_create_srq() -> create_srq_kernel(), buf_size =3D=3D 0 causes
mlx5_frag_buf_alloc_node() to allocate 0 pages (setting
srq->buf.frags =3D ZERO_SIZE_PTR) and return 0, so the WQE initialization l=
oop
in create_srq_kernel() dereferences ZERO_SIZE_PTR when srq->msrq.max > 0 (or
underflows srq->tail =3D srq->msrq.max - 1 when srq->msrq.max =3D=3D INT_MI=
N).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103163949.1554=
-1-yishaih@nvidia.com?part=3D21
