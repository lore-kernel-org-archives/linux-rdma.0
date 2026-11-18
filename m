Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017095;
	b=LWSCCX1aWwwiAZDKo2X/QVDypiDeAcvxcRARVaskrFMIa9jtQ6eVpzug1NptjfuM7B9u
	 V3Vf692p9SdiWT3cDzBHzgqasw9RqKKhI5+0H1YK6ijMebEP2MPCov+UpaY7jjl6rZB90
	 gwyINXu4Dm2RKxVE13f8vJFed5ia5j/xVEJFCCbsqVJgcNSONsgwGI+YmoWI4adlFGahD
	 m/O13T0QCDwNf14U4aOgGarX85tU2qyUm31+UcERLXVNWp1f8ezS4ZT4fVhJUD7tTbiXw
	 snNW9iUeejJ/Q8NliKL2Nr2nPhaAvRlMeaU8AI9bdeJeO+OCyMRyQe1Ue/eDNyxbQbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017095;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=QpcoJLuVDAAaVAXIbn/tkzr9PuXz47Jbw1SraJjpLWI=;
	b=kfoSUTRfh2qM9CjvLg9KrHIbduafUilyij4/5OcOYikt72ydDr6AMW6CLnzQJc5MKNF0
	 r/CITmqj2NBF7zD6KNhfTOi/btTTuoUs77C9HYdAfdwTsVicu1ImD+wgOsbwDxCPALmhD
	 oKGjNH9ueXy4BxgabHHGNp2VQtXs/HDF526/OpeeXgBf7yGYdgS4EN8GZazI450bkGtcC
	 d84NGHy4AgO/ORDDWUTQYjk9L1ngn2iI7ae4Hn0aD9qtYeRwJzP3l6lU6Yj+uOCfgkYqy
	 KoEybGtMWaFRAsys1wv4C7DI5Kb7/1uCt+Gd4sxUBuY+T6NF/AMMYQtH6Y++ZLifH/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kmCKUztL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071DB606A332
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 15:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kmCKUztL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A304C1F000C4;
	Wed, 18 Nov 2026 15:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795017094;
	bh=QpcoJLuVDAAaVAXIbn/tkzr9PuXz47Jbw1SraJjpLWI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kmCKUztL8RQgAs94LJ8vbaHl8K9zGLWmLHPfwS0qHUbXvtkYXD+GiFRnilLCkaAgB
	 AjrW7ygxBVfs/TqCHEMTAKwwwuhDaCLSxOsqGZsJsawH0UJT3b013ipMy9pdLkZfNi
	 dfDQhIFbrIOccQ5nSpy0soHJ1u5ugBIES+MnnvRNKjbJ1wdyQe6oHRLace+UKGnkql
	 yq2MYCGCrwxyM0GMX7k0m+7HuIRujmceK8/N8U3zTv67444tMFQW3s5t3jsiUzKLkZ
	 y0Uqg0T0EH2cjJUsgZfCgSOUwRmI8Krzc/D683g8csOYAu0b20+qRcosjQvjyTITEk
	 M95OOJk29AF2w==
Message-ID: <sashiko-outbox-221381@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [for-next v1 2/2] RDMA/ionic: Accept QP SQ and RQ rings as
 ioctl umem attributes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261118152313.113714-3-abhijit.gangurde@amd.com>
References: <20261118152313.113714-1-abhijit.gangurde@amd.com>
 <20261118152313.113714-3-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 15:51:34 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] RDMA/ionic: double-fetch of buffer descriptor in
  ionic_get_user_q_umem()
- [Medium] RDMA/ionic: missing DMABUF addr=3D=3D0 handling in CQ and QP
  qdesc validation
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [Critical] RDMA/ionic: validation bypass via undefined behavior in
  ionic_validate_qdesc() [1]
--

commit 2a0ba584011ea872720029ef7dae9322c2160a45
Author: Abhijit Gangurde <abhijit.gangurde@amd.com>

RDMA/ionic: Accept QP SQ and RQ rings as ioctl umem attributes

This commit adds support for pinning QP SQ and RQ rings from the
UVERBS_ATTR_CREATE_QP_SQ_BUF_UMEM and UVERBS_ATTR_CREATE_QP_RQ_BUF_UMEM
ioctl buffer descriptor attributes, splitting queue geometry validation into
ionic_validate_qdesc_geom() for dma-buf descriptors.

> diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/in=
finiband/hw/ionic/ionic_controlpath.c
> index 11458262f280d..02f1972126ed0 100644
> --- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
> +++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
> @@ -14,13 +14,9 @@
>  #define ionic_set_ecn(tos)   (((tos) | 2u) & ~1u)
>  #define ionic_clear_ecn(tos)  ((tos) & ~3u)
> =20
> -static int ionic_validate_qdesc(struct ionic_qdesc *q)
> +static int ionic_validate_qdesc_geom(struct ionic_qdesc *q)
>  {
> -	if (!q->addr || !q->size || !q->mask ||
> -	    !q->depth_log2 || !q->stride_log2)
> -		return -EINVAL;
> -
> -	if (q->addr & (PAGE_SIZE - 1))
> +	if (!q->size || !q->mask || !q->depth_log2 || !q->stride_log2)
>  		return -EINVAL;
> =20
>  	if (q->mask !=3D BIT(q->depth_log2) - 1)
> @@ -32,6 +28,14 @@ static int ionic_validate_qdesc(struct ionic_qdesc *q)
>  	return 0;
>  }
> =20
> +static int ionic_validate_qdesc(struct ionic_qdesc *q)
> +{
> +	if (!q->addr || (q->addr & (PAGE_SIZE - 1)))
> +		return -EINVAL;
> +
> +	return ionic_validate_qdesc_geom(q);
> +}

[Severity: Critical]
This problem wasn't introduced by this patch, but can a user bypass the que=
ue
size check in ionic_validate_qdesc_geom() [1] when q->depth_log2 +
q->stride_log2 is 64 or greater?

drivers/infiniband/hw/ionic/ionic_controlpath.c:ionic_validate_qdesc_geom()=
 {
	...
	if (q->size < BIT_ULL(q->depth_log2 + q->stride_log2))
		return -EINVAL;

	return 0;
}

Neither q->depth_log2 nor q->stride_log2 is bounded before the shift, so a
sum of 64 or more triggers shift undefined behavior (wrapping the shift cou=
nt
modulo 64 on x86_64) and lets a small q->size pass validation before the
out-of-bounds queue parameters are sent to firmware.

> @@ -1993,10 +1997,57 @@ static void ionic_qp_sq_destroy_cmb(struct ionic_=
ibdev *dev,
>  	ionic_put_cmb(dev->lif_cfg.lif, qp->sq_cmb_pgid, qp->sq_cmb_order);
>  }
> =20
> +static int ionic_get_user_q_umem(struct ionic_ibdev *dev, struct ionic_q=
desc *q,
> +				 const struct uverbs_attr_bundle *attrs,
> +				 u16 attr_id, struct ib_umem **umem_out)
> +{
> +	struct ib_uverbs_buffer_desc desc;
> +	struct ib_umem *umem;
> +	int rc;
> +
> +	if (attrs && uverbs_attr_is_valid(attrs, attr_id)) {
> +		rc =3D uverbs_get_buffer_desc(attrs, attr_id, &desc);
> +		if (rc)
> +			return rc;
> +
> +		if (desc.length !=3D q->size)
> +			return -EINVAL;
> +
> +		if (desc.type =3D=3D IB_UVERBS_BUFFER_TYPE_DMABUF) {
> +			if (desc.addr & (PAGE_SIZE - 1))
> +				return -EINVAL;
> +
> +			rc =3D ionic_validate_qdesc_geom(q);

[Severity: Medium]
Should the IB_UVERBS_BUFFER_TYPE_DMABUF branch also reject non-zero q->addr,
and does CQ creation need the same qdesc handling when req_cq->addr is zero?

The commit message notes that qdesc.addr is zero for a dma-buf descriptor,
which is why ionic_validate_qdesc_geom() is split out here, but this branch
does not check that q->addr is zero.  Meanwhile, ionic_create_cq_common() in
commit "RDMA/ionic: Accept CQ ring buffers as ioctl umem attributes" still
calls ionic_validate_qdesc(req_cq) unconditionally before
ionic_cq_get_user_umem():

drivers/infiniband/hw/ionic/ionic_controlpath.c:ionic_create_cq_common() {
	...
	if (udata) {
		rc =3D ionic_validate_qdesc(req_cq);
		if (rc)
			goto err_qdesc;

		rc =3D ionic_cq_get_user_umem(dev, cq, req_cq, attrs, udma_idx);
	...
}

Because ionic_validate_qdesc() rejects !q->addr, creating a dma-buf CQ with
req_cq->addr set to 0 always fails with -EINVAL.

> +		} else if (desc.type =3D=3D IB_UVERBS_BUFFER_TYPE_VA &&
> +			   desc.addr =3D=3D q->addr) {
> +			rc =3D ionic_validate_qdesc(q);
> +		} else {
> +			rc =3D -EINVAL;
> +		}
> +		if (rc)
> +			return rc;
> +
> +		umem =3D ib_umem_get_attr_or_va(&dev->ibdev, attrs, attr_id,
> +					      q->addr, q->size, 0);

[Severity: Medium]
Does calling ib_umem_get_attr_or_va() here re-fetch struct
ib_uverbs_buffer_desc from user memory after desc has already been validate=
d?

UVERBS_ATTR_UMEM is defined without UA_ALLOC_AND_COPY and struct
ib_uverbs_buffer_desc is 32 bytes (not inline), so ib_umem_get_attr_or_va()
-> ib_umem_resolve_desc() -> uverbs_get_buffer_desc() performs a second
copy_from_user() of the descriptor and only checks that umem->length >=3D
q->size.  A concurrent userspace thread modifying the descriptor between the
two reads can bypass the checks on desc.addr page alignment, desc.length =
=3D=3D
q->size, and desc.type, programming firmware with a mismatched or unaligned
ring mapping.  Pinning the validated local descriptor via
ib_umem_get_desc(&dev->ibdev, &desc, 0) would avoid the second copy.

[1] https://sashiko.dev/#/bug/linux-f6f7b3eb-a66a-4c37-9e7c-001f6bd900bf

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118152313.1137=
14-1-abhijit.gangurde@amd.com?part=3D2
