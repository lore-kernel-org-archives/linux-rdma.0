Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F8E4854F6
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 09:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788945024; cv=none; b=nf6DdGXjdyn6hjJKxEM5oUeCLBGe+5uWSOX50tRgCh8FqZ+0MBDM40DpD7o1eocyI0kkeaZXtlKbIWILZ3vsoICacKKgGCaBT8AYAGH5vkx99yPGI3SSBZESyf2ArYloqvscaZqpCC3e8AUhDr1JT5RodWXQeKTUNPKxjx7liWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788945024; c=relaxed/simple;
	bh=ei96zE0ZrlHlMI2NhM1nKG30ywzB+YB0+6Nm2fEiy88=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BHVyi0u5bVMC656Lhspw+uldvs/BWyQOkO4XqS2G1dIcd0eIpWWyO4afMT0zylSr8QujLbKaG9SBS7ttKt8Bw2U36MYHIREtIi/+4nv6Yci8f4mIl4Qpew/WJmYaFsEMhKNLRCbDIK4xsEajhn/EGT6DJK6LL5QCJuLeaoLPfik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E9lbTZxt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E9lbTZxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D571F00A3D;
	Wed,  9 Sep 2026 09:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788945022;
	bh=OnVP3hcR/OazFbcgC6iSo8WqHgSMGM3Vr9KzbI+Xljg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=E9lbTZxtPmtks0eOj2dhYjfmTlelGjFeIs9Nlv3JtKh9T8Ewn8g4Kvcw67pujV7+5
	 VhK85vi781YEn9le16w6klAJhaOKjXGFoMBrZUWr7NQtnBX4Db3zFnm/BUVEr4sEUZ
	 bI4UFvQYY0BGcvOgSpNSOxxdk9SMps/6z6ee4hoyfy6z9RUzzrpm0oez00cVDTmCXx
	 FhhM030KqHcJAkBK1MYJAjU4nf3D4dYeTMfOaSQ1cvzkwFz5eLcUx/9UNyupgzaLt/
	 xHcJraBhFR1mOIHlQgUs3OnEhv7+nZAyn80fyuNcVUGLCzuoIqzUCAq8D6MYH3bGyq
	 z2HdCK1b3FEig==
From: sashiko-bot@kernel.org
Subject: Re: [for-next v1 3/5] RDMA/ionic: segregate rq related fields from
 ionic_qp into a new ionic_rq struct
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260908090802.152142-4-abhijit.gangurde@amd.com>
References: <20260908090802.152142-1-abhijit.gangurde@amd.com>
 <20260908090802.152142-4-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 09:10:22 +0000
Message-Id: <20260909091022.75D571F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Low] Incomplete refactoring and introduction of dead code in `struct ion=
ic_rq`.

Pre-existing issues:
- [High] Double free and use-after-free of rdma_user_mmap_entry structures =
on the error path in `ionic_create_qp`.
--

commit df35ccd280a5e88e710952bc7435abdf49666d70
Author: Amit Kumar <a.k@amd.com>

RDMA/ionic: segregate rq related fields from ionic_qp into a new ionic_rq s=
truct

This commit refactors the ionic_qp structure by segregating receive queue
related fields into a newly created ionic_rq struct. This is done to prepare
for upcoming SRQ support.

> diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/in=
finiband/hw/ionic/ionic_controlpath.c
> --- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
> +++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
[ ... ]
> @@ -2501,19 +2498,19 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib=
_qp_init_attr *attr,
>  	if (qp->has_rq) {
>  		cq =3D to_ionic_vcq_cq(attr->recv_cq, qp->udma_idx);
> =20
> -		attr->cap.max_recv_wr =3D qp->rq.mask;
> +		attr->cap.max_recv_wr =3D qp->rq.q.mask;
>  		attr->cap.max_recv_sge =3D
> -			ionic_v1_recv_wqe_max_sge(qp->rq.stride_log2,
> -						  qp->rq_spec,
> -						  qp->rq_cmb & IONIC_CMB_EXPDB);
> -		qp->rq_cqid =3D cq->cqid;
> +			ionic_v1_recv_wqe_max_sge(qp->rq.q.stride_log2,
> +						  qp->rq.spec,
> +						  qp->rq.cmb & IONIC_CMB_EXPDB);
> +		qp->rq.cqid =3D cq->cqid;
>  	}
> =20
>  	return 0;
> =20
>  err_resp:
> -	if (udata && (qp->rq_cmb & IONIC_CMB_ENABLE))
> -		rdma_user_mmap_entry_remove(qp->mmap_rq_cmb);
> +	if (udata && (qp->rq.cmb & IONIC_CMB_ENABLE))
> +		rdma_user_mmap_entry_remove(qp->rq.mmap_cmb);
>  err_mmap_rq:
>  	if (udata && (qp->sq_cmb & IONIC_CMB_ENABLE))
>  		rdma_user_mmap_entry_remove(qp->mmap_sq_cmb);
> @@ -2521,7 +2518,8 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_q=
p_init_attr *attr,
>  	ionic_destroy_qp_cmd(dev, qp->qpid);
>  err_cmd:
>  	ionic_pgtbl_unbuf(dev, &rq_buf);
> -	ionic_qp_rq_destroy(dev, ctx, qp);
> +	if (qp->has_rq)
> +		ionic_rq_destroy(dev, ctx, &qp->rq);
>  err_rq:
>  	ionic_pgtbl_unbuf(dev, &sq_buf);
>  	ionic_qp_sq_destroy(dev, ctx, qp);

[Severity: High]
This is a pre-existing issue, but can this sequence trigger a use-after-free
or double free of the mmap entries?

In ionic_create_qp(), if ib_respond_udata() fails, the unwind paths
at err_resp and err_mmap_rq manually call rdma_user_mmap_entry_remove() on
both qp->rq.mmap_cmb and qp->mmap_sq_cmb.

Because the pointers are not set to NULL, execution falls through to
err_cmd and err_rq, which invoke ionic_rq_destroy() and
ionic_qp_sq_destroy(). These downstream functions then call
ionic_rq_destroy_cmb() and ionic_qp_sq_destroy_cmb(), executing
rdma_user_mmap_entry_remove() unconditionally on the exact same
pointers again.

> diff --git a/drivers/infiniband/hw/ionic/ionic_ibdev.h b/drivers/infiniba=
nd/hw/ionic/ionic_ibdev.h
> --- a/drivers/infiniband/hw/ionic/ionic_ibdev.h
> +++ b/drivers/infiniband/hw/ionic/ionic_ibdev.h
[ ... ]
> @@ -241,6 +241,30 @@ struct ionic_rq_meta {
>  	u64			wrid;
>  };
> =20
> +struct ionic_rq {
> +	struct ionic_queue		q;
> +	u32				qid;
> +	u32				cqid;
> +	struct list_head		cq_flush;
> +	spinlock_t			lock; /* for posting and polling */
> +
> +	phys_addr_t			cmb_addr;
> +	void		__iomem		*cmb_ptr;
> +	struct rdma_user_mmap_entry	*mmap_cmb;
> +
> +	struct ionic_rq_meta		*meta;
> +	struct ionic_rq_meta		*meta_head;
> +	struct ib_umem			*umem;
> +
> +	int				spec;
> +	int				cmb_order;
> +	u32				cmb_pgid;
> +	u16				cmb_prod;
> +	u16				old_prod;
> +	u8				cmb;
> +	bool				flush;
> +};
> +

[Severity: Low]
Does this new structure introduce unused fields? The fields cq_flush,
cmb_ptr, and cmb_prod appear to be unreferenced dead code.

Additionally, it seems the actively used list head cq_flush_rq was left
behind in struct ionic_qp instead of being migrated here along with the
rest of the queue state.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090802.1521=
42-1-abhijit.gangurde@amd.com?part=3D3
