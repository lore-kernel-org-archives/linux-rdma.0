Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D5C47CC67
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 09:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790157567; cv=none; b=i/ntBKFL96r1yJOBVJjq7fPBJjw8oXba6ARdLVUsde58ih9gC5yx/E4gi6t+Ms2c+QrKrdFJjfXo7DkY7DZ5ISiuLL2PYjkWST6FHJdRlZjc9fzpLx1lgvJkEAVfVqmZPgRVZ34KLc5wFaVo3i9tdlgRX9CkXCWU9dP6Qe8QKs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790157567; c=relaxed/simple;
	bh=nzcXFEu0GBkvGfrI848TFW9QDho4R/B/CbfNtlHtpSA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=g7+YMTf6NqIzDeqAu7ng3D5lE07Vk+fG3DzonrFaJ+rSTc1QsjtJ40aRuGukCcC2egI/OfGGIBV6lUGRg/qzN3cjRKurd0d+sfrOo9RRb1Mogv4N8FXOJ9vaOd1Ij3tn9kQ517MMwdxcaJTwwWr+DkpIkT50EKbf9vjZLXS31Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=br3C8fV1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="br3C8fV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2121B1F000FF;
	Wed, 23 Sep 2026 09:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790157565;
	bh=x/IMcwUavePnsgYJI3oDLp7jH2nF59ANk11GHNGTSJw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=br3C8fV11BsK1oo/Ck++YkUfv+meYuMH+OS2pWvWx9ggMluHLtShxS+G4s1Q17XYk
	 msg7YJnuLR/FbBdz2L9J8kTr9LeiYsHb7XxLOE/mlj6i66gh5JuYuzzCsyBChc39K6
	 nkJFQSTE/BaK1hA0td+XWoT7kflqsu3FJsi3/O2QowNgnnp6iFlTnvu6GlPa7+gdgP
	 bTmbvIJpMecUr1htEGAsz+I66tmY8/SH5+82oxa3AmP2srUhpnxDNBJEYde2tawvv5
	 ZeFxQ272N01AsKAVeuB9qqmQntnFFXUgmw5uEPJLDEg61fRbThE2rO9DCIxKEatyB+
	 cwFBYxbfBfWjw==
From: sashiko-bot@kernel.org
Subject: Re: [for-next v2 4/5] RDMA/ionic: add Shared receive queue (SRQ)
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922095724.3683011-5-abhijit.gangurde@amd.com>
References: <20260922095724.3683011-1-abhijit.gangurde@amd.com>
 <20260922095724.3683011-5-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 09:59:24 +0000
Message-Id: <20260923095925.2121B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] rdma/ionic: Invalid pointer dereference in ionic_create_qp when re=
cv_cq is NULL
- [Medium] rdma/ionic: Missing assignment of negotiated max_sge in ionic_cr=
eate_srq()
- [Medium] rdma/ionic: Missing ABI validation for reserved bytes in ionic_s=
rq_req
- [Medium] rdma/ionic: Incorrect TEARDOWN flag in ionic_modify_srq_cmd mask=
s hardware errors
--

commit d35f9d0b1f3bb4677ebdb531833d86b7ea9eaeb7
Author: Amit Kumar <a.k@amd.com>

RDMA/ionic: add Shared receive queue (SRQ) support

Implement device supported verb APIs for shared receive queue.
SRQ is supported for userspace only. ionic_create_srq() returns
-EOPNOTSUPP when there is no ucontext, so kernel ULPs cannot create an
SRQ.

> diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/in=
finiband/hw/ionic/ionic_controlpath.c
> index 7f0e8b63ed76c..ec9e1188f556f 100644
> --- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
> +++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
[ ... ]
> @@ -2360,22 +2401,25 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib=
_qp_init_attr *attr,
[ ... ]
> +	} else {
> +		if (udata && (req.rq_cmb & IONIC_CMB_ENABLE))
> +			qp->rq.cmb =3D req.rq_cmb;
> +
> +		/* for non-srq qps, rq qid is same as qpid */
> +		qp->rq.qid =3D qp->qpid;
> +		rc =3D ionic_rq_init(dev, ctx, &qp->rq, &req.rq, &rq_buf,
> +				   attr->cap.max_recv_wr, attr->cap.max_recv_sge,
> +				   req.rq_spec, udata);
>  	}
> +	if (rc)
> +		goto err_rq;
> =20
>  	rc =3D ionic_create_qp_cmd(dev, pd,
>  				 to_ionic_vcq_cq(attr->send_cq, qp->udma_idx),
>  				 to_ionic_vcq_cq(attr->recv_cq, qp->udma_idx),
>  				 qp, &sq_buf, &rq_buf, attr, req.ionic_flags);

[Severity: High]
Since this patch adds SRQ support, it permits QPs to be created without a
receive CQ, meaning attr->recv_cq can be NULL.

However, to_ionic_vcq_cq() calculates an offset from its argument.
If attr->recv_cq is NULL, won't to_ionic_vcq_cq() return a non-NULL offset
pointer?

That invalid pointer is passed into ionic_create_qp_cmd() where it gets
unconditionally dereferenced to access recv_cq->cqid:

	} else {
		wr.wqe.cmd.create_qp.rq_tbl_index_srq_id =3D cpu_to_le32(qp->srq->rq.qid);
		wr.wqe.cmd.create_qp.rq_cq_id =3D cpu_to_le32(recv_cq->cqid);
	}

Would this cause a kernel panic upon dereference?

[ ... ]
> +static int ionic_modify_srq_cmd(struct ionic_ibdev *dev, u32 srqid,
> +				u16 srq_limit)
> +{
> +	struct ionic_admin_wr wr =3D {
> +		.work =3D COMPLETION_INITIALIZER_ONSTACK(wr.work),
> +		.wqe =3D {
> +			.op =3D IONIC_V1_ADMIN_MODIFY_SRQ,
> +			.len =3D cpu_to_le16(IONIC_ADMIN_MODIFY_SRQ_IN_V1_LEN),
> +			.cmd.modify_srq =3D {
> +				.qid =3D cpu_to_le32(srqid),
> +				.low_wqes_limit =3D cpu_to_le16(srq_limit),
> +			},
> +		}
> +	};
> +
> +	if (dev->lif_cfg.admin_opcodes <=3D IONIC_V1_ADMIN_MODIFY_SRQ)
> +		return -EOPNOTSUPP;
> +
> +	ionic_admin_post(dev, &wr);
> +
> +	return ionic_admin_wait(dev, &wr, IONIC_ADMIN_F_TEARDOWN);

[Severity: Medium]
Does using IONIC_ADMIN_F_TEARDOWN here mask hardware errors?

If the device is resetting, ionic_admin_wait() will return 0 instead of
-ENODEV. This would cause ionic_modify_srq() to incorrectly assume success
and update the software srq->srq_limit, permanently desynchronizing it from
the actual hardware limit.

> +}
> +
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

[Severity: Medium]
The ib_copy_validate_udata_in() macro checks that any userspace bytes beyond
the req struct are zeroed, but it doesn't validate the contents of the rsvd
array within the struct itself.

Is there a missing check to ensure req.rsvd is strictly zeroed? Without it,
buggy userspace applications could pass garbage in these reserved bytes,
preventing them from being safely repurposed for future ABI extensions.

[ ... ]
> +		if (srq->rq.cmb & IONIC_CMB_ENABLE) {
> +			ionic_rq_mmap_cmb(dev, ctx, &srq->rq, &resp.rq_cmb_offset);
> +			if (!srq->rq.mmap_cmb) {
> +				rc =3D -ENOMEM;
> +				goto err_srq_cmd;
> +			}
> +
> +			resp.rq_cmb =3D srq->rq.cmb;
> +		}
> +
> +		rc =3D ib_respond_udata(udata, resp);
> +		if (rc)
> +			goto err_srq_cmd;
> +	}
> +
> +	ionic_pgtbl_unbuf(dev, &buf);
> +
> +	attr->attr.max_wr =3D srq->rq.q.mask;
> +
> +	return 0;

[Severity: Medium]
This updates the negotiated max_wr, but is it missing an assignment to
attr->attr.max_sge before returning? Without it, userspace wouldn't receive
the actual negotiated max_sge limits.

> +
> +err_srq_cmd:
> +	ionic_destroy_srq_cmd(dev, srq->rq.qid);
> +err_cmd:
> +	ionic_pgtbl_unbuf(dev, &buf);
> +	ionic_rq_destroy(dev, ctx, &srq->rq);
> +
> +	return rc;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922095724.3683=
011-1-abhijit.gangurde@amd.com?part=3D4
