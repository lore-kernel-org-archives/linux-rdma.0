Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2451C342509
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 01:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792028199; cv=none; b=GOSGqEXX9xE2hr6le9N8U2cJ4SVTHsLr8PPC1BO7W6PIZpvw+WtHjzsHHSPfnp/9YgK+d77SEZtb6I4N3ya94yIH8PnTPsDNwGxXCspmxrmuYS9dKOAPzOoKsxk8zTyNSd4elXJyenTykL54v+QFbRXJcL2UoG2xI4+bgeMSv10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792028199; c=relaxed/simple;
	bh=2Sf8Vj4VWd0J5lxfatednGC423CmzmXchJcDypAm2q0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=a6fDarfRjXKOI7n/LMbkH+83tvHSfHpI/eyhH7HAXwhNu6FqG7YjL19EFBzfwkNMRnCKukJf72Wjf2ROWAUIvxNoVi2EYczrYd7xDc8Y2BgdMF5swnUYmCwH+2qXgZXo/G7Eq9HeMVwP0Rb5ehvJ8ze4lMaumhhI3IlS4n/RPOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bsSPNMQu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bsSPNMQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886171F000C4;
	Thu, 15 Oct 2026 01:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792028197;
	bh=MSxdjz5JMeKXs/WTn1iatpL+9J0F8w4o+LO5YMBsC68=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bsSPNMQuYdXkslCBvZlUlfC0LdA0JiX0BM1C2nm0bvSNN4XKgS/adHJjLuBRV5OLn
	 xm7/aBDAm1vCg3TCEyhulBwq1YZqZPUmBOP25pf5waCSJW/oJpbdRkB7a9F/aoSdLx
	 Ad/HGIGJT83IFQqYmmSOP5+FbIFSk/F88ELAGJk7qBvHydiYdIw8Sf7+OQf5IIYsRh
	 E4HoL1OD/Rmm1mHf5/LoiNMQXv2iUOuhZ5b7cB58MJIUjRhMD5R+PHnZxs4Pd+l6lo
	 4IzdeuchGVmrRlCvgaT4faoWzdZu47HVUitGaLZXLejOqfDhYDEJ3hqV2wGIyVyJL7
	 NE6vZiIkzq48g==
Message-ID: <sashiko-outbox-172100@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 3/6] RDMA/irdma: Support UMEM attribute for
 QP creation
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hu" <dhu@x6u.co>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261015011940.4122452-4-dhu@x6u.co>
References: <20261015011940.4122452-1-dhu@x6u.co>
 <20261015011940.4122452-4-dhu@x6u.co>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 01:36:37 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] rdma: resource leak of qp_num in irdma_create_qp() error path
--

commit c4616d335368961fe171e368fb4fc4f2e2fa096d
Author: David Hu <xuehaohu@google.com>
RDMA/irdma: Support UMEM attribute for QP creation

This commit introduces support for the standard 1-step queue buffer creation
model for QPs by using UVERBS_ATTR_CREATE_QP_BUF_UMEM and ib_umem_get_attr(=
).
It allocates the backing MR and programs the hardware pble directly from the
pinned umem, adding cleanup routines to irdma_free_qp_rsrc() upon destructi=
on.

> diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/=
irdma/verbs.c
> index b2ffdc8e3d677..ab25445f38282 100644
> --- a/drivers/infiniband/hw/irdma/verbs.c
> +++ b/drivers/infiniband/hw/irdma/verbs.c
[ ... ]
> @@ -713,6 +708,52 @@ static int irdma_setup_umode_qp(struct irdma_ucontex=
t *ucontext,
>  		ukinfo->rq_size =3D ukinfo->rq_depth >> ukinfo->rq_shift;
>  	}
> =20
> +	if (attrs && uverbs_attr_is_valid(attrs, UVERBS_ATTR_CREATE_QP_BUF_UMEM=
)) {
> +		struct irdma_mem_reg_req qp_req =3D {};
> +		struct ib_umem *umem;
> +		u32 total;
> +
> +		/* Legacy context does not provide depth info */
> +		if (!ucontext->use_raw_attrs)
> +			return -EOPNOTSUPP;
> +
> +		qp_req.sq_pages =3D DIV_ROUND_UP(ukinfo->sq_depth * IRDMA_QP_WQE_MIN_S=
IZE,
> +					       IRDMA_HW_PAGE_SIZE);
> +		/* In case srq is used, this will be a single page */
> +		qp_req.rq_pages =3D DIV_ROUND_UP(ukinfo->rq_depth * IRDMA_QP_WQE_MIN_S=
IZE,
> +					       IRDMA_HW_PAGE_SIZE);
> +		total =3D qp_req.sq_pages + qp_req.rq_pages + IRDMA_SHADOW_PGCNT;
> +
> +		umem =3D ib_umem_get_attr(&iwdev->ibdev, attrs,
> +					UVERBS_ATTR_CREATE_QP_BUF_UMEM,
> +					total << IRDMA_HW_PAGE_SHIFT,
> +					IB_ACCESS_LOCAL_WRITE);
> +		if (IS_ERR(umem))
> +			return PTR_ERR(umem);
> +
> +		iwqp->iwpbl =3D irdma_setup_q_pbl_from_umem(iwdev, umem,
> +							  iwqp->ibqp.pd,
> +							  IRDMA_MEMREG_TYPE_QP,
> +							  &qp_req);
> +		if (IS_ERR(iwqp->iwpbl)) {
> +			ret =3D PTR_ERR(iwqp->iwpbl);
> +			iwqp->iwpbl =3D NULL;
> +			ib_umem_release(umem);
> +			return ret;
> +		}

[Severity: Medium]
If the newly added UMEM QP setup fails and returns an error here,
irdma_create_qp() will jump to its error path:

drivers/infiniband/hw/irdma/verbs.c:irdma_create_qp() {
    ...
    if (udata) {
        ...
        err_code =3D irdma_setup_umode_qp(ucontext, &ureq, iwdev, iwqp,
                                        &init_info, init_attr, attrs);
    } else {
    ...
    if (err_code) {
        ibdev_dbg(&iwdev->ibdev, "VERBS: setup qp failed\n");
        goto error;
    }
    ...
error:
    irdma_free_qp_rsrc(iwqp);
    return err_code;
}

However, at this point irdma_sc_qp_init() has not yet been executed, so
iwqp->sc_qp.qp_uk.qp_id is still uninitialized (0).

Does this cause irdma_free_qp_rsrc() to read a 0 value for qp_num and bypass
the deallocation logic (if (qp_num > 2)), permanently leaking the allocated
QP ID from the rf->allocated_qps bitmap?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015011940.4122=
452-1-dhu@x6u.co?part=3D3
