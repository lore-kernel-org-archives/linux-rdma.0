Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA74F4915B7
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 09:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788945025; cv=none; b=Oe/1GvI9dpf0I3lCUfePW+l8dtGy/cNMEnj3/HwzwQWXRoCLkeHsLksiRqnb24s6l5FKf+Jq6ovLyAAs5EwbZHFqYnfzVDT1dZb8MhSu23Vw4dzQ1qWY3C8rzGyIsSBx7fFB6VpbRzHjb97eymwi0yEiMBmEAp8d1oRKOSzHeo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788945025; c=relaxed/simple;
	bh=w+aePnt6PgBwvUWCrjtzSph8Au6B0jiqIhUlEx64FdY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VE1extDSkWbU5XrFVytcZGxssfyvOkS9UYPgjXmw9Va2YUlg7Law/oDCtD2DERXBj7VGvvX7q6ks1e/oGh2AUlmCn3ipIUxhlDeMr/rkHXgSM2XUXjWCX8y+5HvHCjGoyyvClyDxhTQYK1qNVcpek+Vadk0F0+gTDdzolrt1JEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I7ipqrvf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I7ipqrvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9211F00A3A;
	Wed,  9 Sep 2026 09:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788945023;
	bh=PHM/SsSsjre+55Vvw+tLA8SMdADzlTtK/D1H5gkGsEQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I7ipqrvfAE/J88zWQEoJtwp8o8V+PXgfJNwm4KAmlnCiRFrZ45K9q1+p4Nk5eiCEX
	 Dr+AMwwj41wr39rK7IomeT4apeLeeoJoqBy6zyd7PKBBY0GyrN7wgGgBnA8s3FHC28
	 oaZyuM8cnp37wWda/Fc3QLFapswH/z5zJfgLyAhEcQfkxQMI9X32q/ZDljEdsRwqZh
	 UU/d3x+E3HewECRwQid0e1TxqwOwKnHFMLcTO5CZbVqmzMJPyhE7ak5bbYmvWV26Yy
	 MD2Xtl04iat5WFSW9mObmitXLcPiKvhzuXzH9dRnVseRXRNI4qaZ+BdIs839p12+ZP
	 HQANCGrPSl4jA==
From: sashiko-bot@kernel.org
Subject: Re: [for-next v1 4/5] RDMA/ionic: add Shared receive queue (SRQ)
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260908090802.152142-5-abhijit.gangurde@amd.com>
References: <20260908090802.152142-1-abhijit.gangurde@amd.com>
 <20260908090802.152142-5-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 09:10:22 +0000
Message-Id: <20260909091023.1C9211F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:

New issues:
- [High] Kernel CQ polling is broken for SRQ-attached QPs, leading to a per=
manent CQ stall and dmesg log flood.
- [High] DMA API Violation: Stale CPU cache reads of `resp_buf` on non-cach=
e-coherent architectures.
- [Medium] Unprivileged userspace can trigger unrestricted kernel log spam =
via conflicting CMB flags.
- [Medium] SRQ Controller Memory Buffer (CMB) initialization is dead code b=
ecause `srq->rq.cmb` is uninitialized and firmware flags are omitted.
- [Medium] API Contract Violation: `ionic_create_srq` fails to update `attr=
->attr.max_sge`.

Pre-existing issues:
- [High] Double free / Use-After-Free of `mmap_cmb` entries on error handli=
ng paths.
--

commit d21e90481932bd4c2be24a16e0cc7eedd7d8fe39
Author: Amit Kumar <a.k@amd.com>

RDMA/ionic: add Shared receive queue (SRQ) support

This commit implements device-supported verb APIs for shared receive
queues (SRQ) in the ionic RDMA driver.

> diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/in=
finiband/hw/ionic/ionic_controlpath.c
> index 884f5665e7a08..6979e0c5a25c2 100644
> --- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
> +++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
[ ... ]
> @@ -2069,6 +2074,42 @@ static void ionic_qp_sq_destroy(struct ionic_ibdev=
 *dev,
>  		ionic_queue_destroy(&qp->sq, dev->lif_cfg.hwdev);
>  }
> =20
> +static void ionic_rq_mmap_cmb(struct ionic_ibdev *dev,
> +			      struct ionic_ctx *ctx,
> +			      struct ionic_rq *rq,
> +			      u64 *cmb_offset)
> +{
> +	bool wc;
> +
> +	/* set mapping by default to uncached for
> +	 * expdb (to guarantee writes order) otherwise
> +	 * writecombine, unless this default is
> +	 * overridden by userspace
> +	 */
> +	if ((rq->cmb & (IONIC_CMB_WC | IONIC_CMB_UC)) =3D=3D
> +		(IONIC_CMB_WC | IONIC_CMB_UC)) {
> +		ibdev_warn(&dev->ibdev,
> +			   "Both rq_cmb flags IONIC_CMB_WC and IONIC_CMB_UC set, using defaul=
t driver mapping\n");

[Severity: Medium]
Can an unprivileged user trigger unrestricted kernel log spam here?

Since ionic_rq_mmap_cmb() is reachable from userspace QP or SRQ creation
without rate limiting, passing both IONIC_CMB_WC and IONIC_CMB_UC in the
init attributes can flood the dmesg log.

> +		rq->cmb &=3D ~(IONIC_CMB_WC | IONIC_CMB_UC);
> +	}
[ ... ]
> +static int ionic_create_srq_cmd(struct ionic_ibdev *dev,
> +				struct ionic_ctx *ctx,
> +				struct ionic_srq *srq,
> +				struct ionic_pd *pd,
> +				struct ionic_tbl_buf *buf,
> +				u8 udma_mask)
> +{
> +	struct ionic_admin_create_srq_resp *resp_buf;
> +	const u16 dbid =3D ionic_ctx_dbid(dev, ctx);
> +	struct ionic_admin_wr wr =3D {
> +		.work =3D COMPLETION_INITIALIZER_ONSTACK(wr.work),
> +		.wqe =3D {
> +			.op =3D IONIC_V1_ADMIN_CREATE_SRQ,
> +			.len =3D cpu_to_le16(IONIC_ADMIN_CREATE_SRQ_IN_V1_LEN),
> +			.cmd.create_srq =3D {
> +				.pd_id =3D cpu_to_le32(pd->pdid),
> +				.depth_log2 =3D srq->rq.q.depth_log2,
> +				.stride_log2 =3D srq->rq.q.stride_log2,
> +				.page_size_log2 =3D buf->page_size_log2,
> +				.map_count =3D cpu_to_le32(buf->tbl_pages),
> +				.dma_addr =3D ionic_pgtbl_dma(buf, 0),
> +				.dbid =3D cpu_to_le16(dbid),
> +				.qid =3D cpu_to_le32(srq->rq.qid),
> +				.low_wqes_limit =3D cpu_to_le16(srq->srq_limit),
> +				.udma_mask =3D udma_mask,
> +			}

[Severity: Medium]
Is the IONIC_SRQF_CMB flag missing from this firmware command?

The flags field is left uninitialized (0), so IONIC_SRQF_CMB is never sent
to the firmware even if the user requested a Controller Memory Buffer.

> +		}
> +	};
[ ... ]
> +	ionic_admin_post(dev, &wr);
> +
> +	rc =3D ionic_admin_wait(dev, &wr, 0);
> +	if (rc)
> +		goto err_admin;
> +
> +	if (be32_to_cpu(wr.cqe.status_length) < IONIC_ADMIN_CREATE_SRQ_OUT_V1_L=
EN) {
> +		rc =3D -EOPNOTSUPP;
> +		goto err_admin;
> +	}
> +
> +	srq->rq.qid =3D le32_to_cpu(resp_buf->id);
> +	srq->udma_idx =3D resp_buf->udma_idx;
> +
> +err_admin:
> +	dma_unmap_single(dev->lif_cfg.hwdev, resp_buf_dma, sizeof(*resp_buf),
> +			 DMA_FROM_DEVICE);

[Severity: High]
Will this result in stale cache reads on non-cache-coherent architectures?

The CPU accesses resp_buf->id and resp_buf->udma_idx before calling
dma_unmap_single(). On platforms without hardware cache coherency, this
can read stale zeroes from the CPU cache instead of the DMA-written values,
breaking SRQ usage.

> +err_dma:
> +	kfree(resp_buf);
> +
> +	return rc;
> +}
[ ... ]
> +int ionic_create_srq(struct ib_srq *ibsrq, struct ib_srq_init_attr *attr,
> +		     struct ib_udata *udata)
> +{
[ ... ]
> +	udma_mask =3D BIT(dev->lif_cfg.udma_count) - 1;
> +	if (udata) {
> +		rc =3D ib_copy_validate_udata_in(udata, req, rsvd);
> +		if (rc)
> +			return rc;
> +
> +		udma_mask &=3D req.udma_mask;
> +	}
> +
> +	if (!udma_mask)
> +		return -EINVAL;
> +
> +	rc =3D ionic_rq_init(dev, ctx, &srq->rq, &req.rq, &buf,
> +			   attr->attr.max_wr, attr->attr.max_sge,
> +			   req.rq_spec, udata);

[Severity: Medium]
Does this ignore the user's req.rq_cmb request?

Unlike QP creation which assigns qp->rq.cmb =3D req.rq_cmb, SRQ creation fa=
ils
to copy the field. Because srq is kzalloc'd, srq->rq.cmb remains 0, bypassi=
ng
CMB allocation entirely.

> +	if (rc)
> +		return rc;
> +
> +	srq->srq_limit =3D attr->attr.srq_limit;
[ ... ]
> +	ionic_pgtbl_unbuf(dev, &buf);
> +	attr->attr.max_wr =3D srq->rq.q.mask;
> +
> +	return 0;

[Severity: Medium]
Is an assignment to attr->attr.max_sge missing here?

Userspace applications rely on the returned capability boundaries. Without
informing the ULP or application of the actual allocated scatter-gather
element limit, they might post too many SGEs.

> +err_resp:
> +	if (udata && (srq->rq.cmb & IONIC_CMB_ENABLE))
> +		rdma_user_mmap_entry_remove(srq->rq.mmap_cmb);
> +err_mmap_rq:
> +	ionic_destroy_srq_cmd(dev, srq->rq.qid);
> +err_cmd:
> +	ionic_pgtbl_unbuf(dev, &buf);
> +	ionic_rq_destroy(dev, ctx, &srq->rq);

[Severity: High]
This is a pre-existing issue, but does this error path result in a
double-free or use-after-free of the mmap entry?

If ib_respond_udata() fails, rdma_user_mmap_entry_remove(srq->rq.mmap_cmb)
is explicitly called, but the pointer is not zeroed. The cleanup then falls
through to ionic_rq_destroy(), which calls ionic_rq_destroy_cmb() and frees
the exact same pointer again.

> +
> +	return rc;
> +}
[ ... ]
> diff --git a/drivers/infiniband/hw/ionic/ionic_datapath.c b/drivers/infin=
iband/hw/ionic/ionic_datapath.c
> index 9c40b54123d5f..e2d4d441052e6 100644
> --- a/drivers/infiniband/hw/ionic/ionic_datapath.c
> +++ b/drivers/infiniband/hw/ionic/ionic_datapath.c
> @@ -1311,7 +1311,7 @@ static int ionic_post_recv_common(struct ionic_ibde=
v *dev,
>  	if (!bad)
>  		return -EINVAL;
> =20
> -	if (!qp->has_rq) {
> +	if (qp->srq) {
>  		*bad =3D wr;
>  		return -EINVAL;
>  	}

[Severity: High]
Does kernel CQ polling break for SRQ-attached QPs, leading to a permanent
CQ stall and dmesg log flood?

When a userspace application polls the CQ, the kernel's ionic_poll_vcq_cq()
sees IONIC_V1_CQE_TYPE_RECV and calls ionic_poll_recv(). Because SRQ QPs
do not use qp->rq, qp->rq.q is zero-initialized and ionic_queue_empty()
returns true:

ionic_poll_recv() {
    if (ionic_queue_empty(&qp->rq.q)) {
        ibdev_warn(&dev->ibdev, "qp %u is empty\n", qp->qpid);
        return -EIO;
    }
    ...
}

When -EIO is returned, ionic_poll_vcq_cq() skips consuming the CQE:

ionic_poll_vcq_cq() {
    ...
    case IONIC_V1_CQE_TYPE_RECV:
        spin_lock(&qp->rq.lock);
        rc =3D ionic_poll_recv(dev, cq, qp, cqe, wc + npolled);
        spin_unlock(&qp->rq.lock);

        if (rc < 0)
            goto out;
    ...
}

This can permanently wedge the hardware CQ and allow an unprivileged
user to spam the kernel log.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090802.1521=
42-1-abhijit.gangurde@amd.com?part=3D4
