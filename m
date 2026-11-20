Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795137615;
	b=O/h+b5jyK8steRvOwhe3QiRMtl9dinZrFwC/97iQqUsyQKkDa9+GwREvXmMDe2U6hZ2k
	 LUF2o1sk8/mTk3HG6yAERL1mdJlFUWNQyW//vvgq0e3MJSIsxArnwBTMg3eh85spY9EhF
	 1FvR1S/ycrJstKlaLNuPI8uFO5KGgk6u2vKSZsVcbvto63ZpyHB60n8U/6K0BpPVoP5J4
	 hxOtF3Gvm//YvWU/BynHScl0AeGP4SYAaqhuykUlt1F4oUUWLX9nOvCIJKE9ggQFRKPbz
	 wck4O8ia6RICfQsJsmmbfG1IzhL4s26MffzaNY/SkJ4WTl3A70JxhJbkit1l7vkmb4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795137615;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=thBIBX164cz0kU1ZFJXVnGd62qa2HtFkCl2PdbdNui4=;
	b=RRXErDIcFFnTb8RqdbiiWJsxqC9JjpGuXrSUb370CpCQYpBj/GRTGXuQTcqVZWJnW982
	 rCdVaqg2bbJILJAMoiNoAJJ3XXL61UBVZi7QN24VxOSOJzYimWSPuyM3/x15n9x03I5Cr
	 XWYPVrj2S98Z2Tnya9M3XfLLqK88D837UW8AGnvopnP5ejyExRpV2XFxgnuySuGoPlneO
	 DAaEqdf5B+gfMSoiM2b9Vd9V2plmwKyqm0F6eYX2pjCmAAT8ue3qTaVaWogeC1Urtrx7a
	 Bm/wo6FqScfDI/VWTeYj+BBgvf0s16ipvB69GtcLl+cJanYDpzbJvFLPrmW/sl489rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GtjKFOLa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9AD606A325
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 01:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GtjKFOLa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61531F000D2;
	Fri, 20 Nov 2026 01:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795137615;
	bh=thBIBX164cz0kU1ZFJXVnGd62qa2HtFkCl2PdbdNui4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GtjKFOLamiBzAfsFS6jv24Fmowr7syRpvMaywYwK7Hq4WfQkG594jYUN77OMSITsa
	 SVufm98jEPUN4InRsBxqVXJYM/Q3JwKaQhRbuWx0gMaaFPioUdopk8j1imxzbBS6QJ
	 OGgXZhME23NKxv5n61B6UQWnWfKCYwh2LuhQgPmaOu1611sxaqHNnn2nrpa9XjO7En
	 YeaKpF+sR7jkc1gIU1++yPF/3YjQLUieWqQzs74cAZfkncZQoNLMqLYdXWyhwO9uXy
	 BLF68hDGu9Q5Y4Tlu26gNTffSCbjVHYA9aemV4PcPGd64ROGe9yvBo2dAOMnNPJp9/
	 qlNvLdVWd4V8g==
Message-ID: <sashiko-outbox-224293@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next] RDMA/mana_ib: support enhanced connection
 establishment
Reply-To: sashiko-reviews@lists.linux.dev
To: "Snehal Sanghvi" <snsanghvi@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261120010851.616472-1-snsanghvi@linux.microsoft.com>
References: <20261120010851.616472-1-snsanghvi@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 01:20:14 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 2 related pre-existing issues it does not
introduce:
- [Critical] RDMA/mana_ib: null pointer dereference in
  mana_ib_gd_create_rc_qp() [1]
- [High] RDMA/mana_ib: integer overflow in mana_ib_create_rc_qp() [2]
--

commit e575bd297d63089e7e8cc394cb0a9db17a952542
Author: Snehal Sanghvi <snsanghvi@microsoft.com>

RDMA/mana_ib: support enhanced connection establishment

This commit exposes enhanced connection establishment (ECE) capabilities
to user space when supported by firmware, returns firmware ECE offers on
RC and UC QP creation, and uses the RNIC V4 set-state layout during QP
modifications to exchange ECE options with firmware.

> diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/ma=
na/main.c
> index 8181b0cecdef0..75403e6bdfcb6 100644
> --- a/drivers/infiniband/hw/mana/main.c
> +++ b/drivers/infiniband/hw/mana/main.c
[ ... ]
> @@ -1054,7 +1056,8 @@ int mana_ib_gd_destroy_cq(struct mana_ib_dev *mdev,=
 struct mana_ib_cq *cq)
>  }
> =20
>  int mana_ib_gd_create_rc_qp(struct mana_ib_dev *mdev, struct mana_ib_qp =
*qp,
> -			    struct ib_qp_init_attr *attr, u32 doorbell, u64 flags)
> +			    struct ib_qp_init_attr *attr, u32 doorbell, u64 flags,
> +			    u32 *ece_options)
>  {
>  	struct mana_ib_cq *send_cq =3D container_of(qp->ibqp.send_cq, struct ma=
na_ib_cq, ibcq);
>  	struct mana_ib_cq *recv_cq =3D container_of(qp->ibqp.recv_cq, struct ma=
na_ib_cq, ibcq);

[Severity: Critical]
This problem wasn't introduced by this patch, but can qp->ibqp.send_cq
and qp->ibqp.recv_cq be NULL here [1]?

When user space creates an RC, UC, or UD QP via UVERBS_METHOD_QP_CREATE
with an indirection table (rwq_ind_tbl) and max_send_wr =3D 0, the uverbs
core treats both CQs as optional and leaves qp->ibqp.send_cq and
qp->ibqp.recv_cq NULL.  Applying container_of() to them and reading
send_cq->cq_handle and recv_cq->cq_handle in mana_ib_gd_create_rc_qp()
(as well as mana_ib_gd_create_uc_qp(), mana_ib_gd_create_ud_qp(), and
mana_remove_qp_from_cqs()) causes a NULL pointer dereference.

> diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana=
/qp.c
> index 62980e0762f78..dec4a84f5c150 100644
> --- a/drivers/infiniband/hw/mana/qp.c
> +++ b/drivers/infiniband/hw/mana/qp.c
> @@ -656,7 +656,7 @@ static int mana_ib_create_rc_qp(struct ib_qp *ibqp, s=
truct ib_pd *ibpd,
>  		qp->rc_qp.wqe_size_in_bu =3D wqe_size / GDMA_WQE_BU_SIZE;
>  	}
> =20
> -	err =3D mana_ib_gd_create_rc_qp(mdev, qp, attr, doorbell, flags);
> +	err =3D mana_ib_gd_create_rc_qp(mdev, qp, attr, doorbell, flags, &resp.=
ece_options);

[Severity: High]
This problem wasn't introduced by this patch, but can an unvalidated
attr->cap.max_send_sge overflow the 32-bit wqe_size calculation in
mana_ib_fixed_wqe_size() [2]?

drivers/infiniband/hw/mana/qp.c:mana_ib_wqe_size() {
	u32 wqe_size =3D sge * sizeof(struct gdma_sge) + sizeof(struct gdma_wqe) +=
 oob_size;

	return ALIGN(wqe_size, GDMA_WQE_BU_SIZE);
}

drivers/infiniband/hw/mana/qp.c:mana_ib_fixed_wqe_size() {
	return roundup_pow_of_two(mana_ib_wqe_size(sge, oob_size));
}

When MANA_IB_RC_QP_FIXED_WQE is set, user-controlled
attr->cap.max_send_sge is passed to mana_ib_fixed_wqe_size() without a
bounds check against mdev->adapter_caps.max_send_sge_count.  If sge is
0x0ffffffc, ALIGN(wqe_size, GDMA_WQE_BU_SIZE) wraps to 0 and
roundup_pow_of_two(0) performs an out-of-bounds shift (1UL << 64), or if
wqe_size exceeds 0x80000000, roundup_pow_of_two() returns 0x100000000UL
which truncates to 0 in u32 and sets qp->rc_qp.wqe_size_in_bu to 0.

[1] https://sashiko.dev/#/bug/linux-86b919ff-d815-475b-90a6-38b75879f413
[2] https://sashiko.dev/#/bug/linux-c09403d1-5db1-420f-88f0-f4df2a2d57af

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120010851.6164=
72-1-snsanghvi@linux.microsoft.com?part=3D1
