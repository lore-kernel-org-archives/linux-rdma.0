Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793166818;
	b=4hWax8UkguI1rBWLPVVaONj+xw4XJwYIW2dyISlabU2Ds/j8sts0XNv9uxQzD6tAYH4O
	 nvDX7NNGuBV5O2dF1P5Aw9ZzMOlVIK+k1h5AxeTbrX2GZhvVvCcucG1+81Pz8lxTgzJYO
	 bDVNhs4X4Lx0TBw421hq8VAOjYoEuW2gedlwjnYe9Xaq0BiuY9kNOCPpXf4QCx2LW7z8M
	 ADAM5A0ErSSR4mnJ9V98jBTsZWSUWvrIb1OOkxHO0IlTk7bj0oxe6BPY/Sz7Im95wnwQ5
	 IQ+s+BULvluwww4y9HjEti/CZjAYrpmffcF+9Ivhyy8gOIiRfaf5TSGNfp8rbufLY6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793166818;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=BsLt1EPEEaqFaSgA0npJ6ZrvbI2wkE13bMuA21eEQkM=;
	b=oZeqbGHWKW/GE9WAG9ZBDtwCkrSjS8c5gWBJmjdQaBrbi9qWAIz/R9SzILYQSk2Q7cKB
	 fm5tLTFCgWJorQxsw/8RsUHEwriALOYvBEQRhVjtsJYsSeKd2hXzh0+CYnmEwyOqB2hjK
	 2TWqF0uzonrRF11lzGtDXS+xBmoKTGpz8XTmFnTThvhMopcSKzRyMiYGS6LYgI8nR8/li
	 NV8z1eJ4mUQy2hzA6o7uN6MsqeTBpnjXjtC+Lk2cNDBv3fVMx23iZd3tjwH0UudAO1lbt
	 +Svnkcbk0rhPVTPL4pj4QltQky7CJxSAHPSLiIyWl6nAPDZeI6MzaFgnauEG9UgqScQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OAmAHjNL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2964A606A31A
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 05:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OAmAHjNL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD0E1F01825;
	Wed, 28 Oct 2026 05:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793166817;
	bh=BsLt1EPEEaqFaSgA0npJ6ZrvbI2wkE13bMuA21eEQkM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OAmAHjNLpo5bpm6eS/St7z0RZdeLGSTrhTuIA9yqh384b0jlxKECTnhJZn8RnwxcA
	 lu7HZIyB13dWyklGEOhCynwaKqcR6zfj/E7YMzCnrHQSZWUcLpq2g5RR5cE+sqAMrB
	 4w6enkBt4cG0Tl92akic+s79u+DtFdLsOu/JyE2P5GNHLb8r6Xg9dMG9CaKP2DAfFc
	 ouTtvGBky6fGrYePb5xQLgaJ7M4sSZnMrZlLDVZ0T3vk9vuOJHFqvdPsyhcEscybMf
	 744q4vm4liua7gqikYB1coopV1cdQo4gYEUXisDojvyHFY7Xr5ZZhIVGhrDLOc2iu6
	 54EfG4XlA8Cmg==
Message-ID: <sashiko-outbox-187545@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: RDMA/mlx5: question about a failed destroy in the SRQ create
 error path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yuho Choi" <oss.patchbox@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261028053903.209809-2-oss.patchbox@gmail.com>
References: <20261028053903.209809-2-oss.patchbox@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 05:53:37 +0000
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
- [High] RDMA/mlx5: untrack on SRQ destroy failure in mlx5_ib_create_srq() =
leaks state
--

commit f69cb08a14ff31d19dd980f3ad4d401e7db6be8d
Author: Yuho Choi <oss.patchbox@gmail.com>

RDMA/mlx5: question about a failed destroy in the SRQ create error path

This commit proposes untracking a newly created firmware SRQ and leaking its
user buffer and doorbell record when ib_respond_udata() fails in
mlx5_ib_create_srq() and the subsequent mlx5_cmd_destroy_srq() call fails.

> diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx=
5/srq.c
> index 6a4a937d97ce9..ab67ccd9bb845 100644
> --- a/drivers/infiniband/hw/mlx5/srq.c
> +++ b/drivers/infiniband/hw/mlx5/srq.c
> @@ -310,7 +310,15 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
>  	return 0;
> =20
>  err_core:
> -	mlx5_cmd_destroy_srq(dev, &srq->msrq);
> +	/*
> +	 * Only user SRQs get here. If a DEVX object still uses the SRQ, the
> +	 * firmware may refuse to destroy it; leak the buffer and doorbell
> +	 * record rather than free pages the device can still access.
> +	 */
> +	if (mlx5_cmd_destroy_srq(dev, &srq->msrq)) {
> +		mlx5_cmd_untrack_srq(dev, &srq->msrq);
> +		return err;
> +	}

[Severity: High]
If mlx5_cmd_destroy_srq() fails here and mlx5_ib_create_srq() untracks the
SRQ and returns err without calling destroy_srq_user(), doesn't that orphan
the live firmware SRQ without any kernel handle to retry destroying it once
the dependent DEVX object is cleaned up, blocking destruction of its parent
objects and leaving a dangling entry on context->db_page_list?

When mlx5_cmd_create_srq() creates the firmware SRQ in mlx5_ib_create_srq(),
the hardware resource is bound to in.pd, in.cqn (either the user CQ or the
device-global kernel CQ dev->devr.c0 for IB_SRQT_BASIC), and in.xrcd (either
the user XRCD or dev->devr.xrcdn0).

When mlx5_ib_create_srq() returns an error to ib_create_srq_user(), the RDMA
core assumes the hardware SRQ was destroyed, decrements usecnt on the parent
objects, and frees srq:

drivers/infiniband/core/verbs.c:ib_create_srq_user() {
	ret =3D pd->device->ops.create_srq(srq, srq_init_attr, udata);
	if (ret) {
		rdma_restrack_put(&srq->res);
		atomic_dec(&pd->usecnt);
		if (srq->srq_type =3D=3D IB_SRQT_XRC && srq->ext.xrc.xrcd)
			atomic_dec(&srq->ext.xrc.xrcd->usecnt);
		if (ib_srq_has_cq(srq->srq_type))
			atomic_dec(&srq->ext.cq->usecnt);
		kfree(srq);
		return ERR_PTR(ret);
	}
}

Because the ib_uobject was never initialized with the SRQ and
mlx5_cmd_untrack_srq() removed srq->msrq from dev->srq_table, nothing in the
kernel will ever re-issue the firmware destroy command for srq->msrq.srqn,
even after the dependent DEVX object is destroyed.

As a result, the firmware SRQ stays bound to its PD, CQ, and XRCD forever.
When the user closes the file descriptor, uverbs_destroy_ufile_hw() will try
to destroy those parent objects after cleaning up DEVX objects, which will
fail in firmware and trigger the cleanup warning and forced teardown:

drivers/infiniband/core/uverbs_main.c:uverbs_destroy_ufile_hw() {
	while (!list_empty(&ufile->uobjects) &&
	       !__uverbs_cleanup_ufile(ufile, reason)) {
	}

	if (WARN_ON(!list_empty(&ufile->uobjects)))
		__uverbs_cleanup_ufile(ufile, RDMA_REMOVE_DRIVER_FAILURE);
}

For IB_SRQT_BASIC SRQs, the orphaned firmware SRQ also remains bound to
dev->devr.c0 and dev->devr.xrcdn0, causing ib_destroy_cq(devr->c0) to fail
during device teardown in mlx5_ib_dev_res_cleanup().

In addition, skipping destroy_srq_user() skips mlx5_ib_db_unmap_user() and
ib_umem_release(srq->umem). During create_srq_user(),
mlx5_ib_db_map_user_desc() allocates a struct mlx5_ib_user_db_page, grabs
current->mm, and links page->list onto &context->db_page_list:

drivers/infiniband/hw/mlx5/doorbell.c:mlx5_ib_db_map_user_desc() {
	page->umem =3D umem;
	if (page->desc.type =3D=3D IB_UVERBS_BUFFER_TYPE_VA) {
		mmgrab(current->mm);
		page->mm =3D current->mm;
	}
	list_add(&page->list, &context->db_page_list);

found:
	db->dma =3D sg_dma_address(page->umem->sgt_append.sgt.sgl) +
		  (desc->addr & ~PAGE_MASK);
	db->u.user_page =3D page;
	++page->refcnt;
}

Because mlx5_ib_dealloc_ucontext() does not drain context->db_page_list,
skipping mlx5_ib_db_unmap_user() leaves page->list linked to
context->db_page_list after ufile_destroy_ucontext() frees context, while
permanently leaking srq->umem, page->umem, pinned user pages, and the
mmgrab(current->mm) reference.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028053903.2098=
09-2-oss.patchbox@gmail.com?part=3D1
