Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894979;
	b=WmO+0UN2XHStDBDKz7d0LgzMBCbpnq9jOuGCXbt/zuctzQ0rSZQNDuor39RNnQ4hmHku
	 OA6ZlyKEEQlkKxj3X/GnwVjZBLHdn3zOpftL0wj5sLa+47phLPsVQ9OXz8A9yEMM6XDYW
	 Xc8aXeDuwLEllWpbICQuW1YeR54vIJAGTlSroweEbj/SY7DdnOuFizRpDCpYnebNLbjT7
	 al3bOo0WW9voUXTGAOLJhGrWnhLwolOhWs4cqlXtrr7J9pUcVEFPGtt0sSrBY4D0FbjRv
	 MP1KCxH3Yt6tcC0xkr2zXQaR2p2/3F9iq1ZdHC9Wfa6wra7+BGmMxMVT7GzB5S7QLSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894979;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=vik5xnQMgSHVlufZULBuJL8EITfgAURbjEo8+5ocuD0=;
	b=GUtUtEr4oiiBAvZeHzFC7kSzCCES4R/cTtaxe86PSrHSSwJXAp9SWMBF/smcbAXSCtRS
	 Df7cRHNVtuSqN5+h3BFYmR96jcaijlsHft0Ekhh2MjPR7Dmyd+cDVRkKg5dYvp9CoI3Ys
	 /U8ZHQ221n2IWpjflwDsn4JEzwANcuMBSdGkhK6ChfG8/eAI12rpeHbqFzk4o5JevwR+7
	 +btLYfqzkwjDJlJ4YUbp93ZUoAOl+4BRgDfqs1luBr9v52JGCLji/5MQYs0tePw1KonxT
	 yzMtyYMjb/C14bJm+fDY++T6RBo+atx2psM8l6r3Rsq94Oa6EQpamTUT1s9ARiW4yFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kTbi5FwI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C98606BE9E
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 16:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kTbi5FwI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022E01F0093A;
	Thu,  5 Nov 2026 16:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894978;
	bh=vik5xnQMgSHVlufZULBuJL8EITfgAURbjEo8+5ocuD0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kTbi5FwIjpWO3OcWeEQG4JKThMCpcrxwBB/A60ok7PvXmLDBKZP/TXY2D43guAwa1
	 l6/NYhpsv8cTWTShjunYUR+bmFhz8SQCyFweqXJ4VUZebFnYiCGoZx5Nz4H/ZpMsln
	 rSQgbA9BMG8tjtcg/7tqbok4kDau7oo2T87C7PVilxw+f6Uodb0FZfHwoR3SeIYK1A
	 UKaD5Rck9TWYtXDdye8RonXrzO9KunblK8WeAVGIGM1dX8imy2kOgkX+CW9YmQ3tC7
	 sLRCPSoJvK66Auz9ajY8FyNFbT0Yj/NJOn9oE7cETvWmveSseROBVotnqi4ThVVRVV
	 4LPx/ZZybrH+Q==
Message-ID: <sashiko-outbox-199435@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 13/15] RDMA/xsc: add QP verbs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104155720.37053-14-tianx@yunsilicon.com>
References: <20261104155650.37053-1-tianx@yunsilicon.com>
 <20261104155720.37053-14-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 16:09:37 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 12 potential issue=
(s) to consider:
- [Critical] RDMA/xsc: heap out-of-bounds write in create_user_qp() when hw=
_npages is 0
- [High] RDMA/xsc: NULL CQ dereference in create_qp_common() debug formatti=
ng
- [High] RDMA/xsc: 32-bit overflow in create_user_qp() sq.offset calculation
- [High] RDMA/xsc: incomplete and racy err_state_qp_list cleanup in xsc_ib_=
destroy_qp()
- [High] RDMA/xsc: leaked error nodes and unlocked WQ reset in xsc_ib_modif=
y_qp()
- [High] RDMA/xsc: SRQ WR leak and qp_num corruption across QP state transi=
tions
- [High] RDMA/xsc: uninitialized kernel memory leak to user in xsc_ib_query=
_qp()
- [Medium] RDMA/xsc: insufficient udata->inlen checks in create_user_qp()
- [Medium] RDMA/xsc: uninitialized stack variable offset logged in create_u=
ser_qp()
- [Medium] RDMA/xsc: integer truncation in set_rq_size() before max_wqes ch=
eck
- [Medium] RDMA/xsc: IB_MTU_8192 misreported as IB_MTU_4096 in xsc_ib_query=
_qp()
- [Medium] RDMA/xsc: premature ctx mutation and wrong page_shift in QP verbs
--

commit f535ae7002b2233def13ec88aba5f48f2448d9b9
Author: Xin Tian <tianx@yunsilicon.com>

RDMA/xsc: add QP verbs

This commit implements queue pair creation, modification, query, and
destruction callbacks for the xsc IB driver, supporting RC, MAD QP0/QP1, and
raw packet queue pairs for both kernel and user-space callers.

> diff --git a/drivers/infiniband/hw/xsc/qp.c b/drivers/infiniband/hw/xsc/q=
p.c
> index a41d880cf03d9..0dfb102949070 100644
> --- a/drivers/infiniband/hw/xsc/qp.c
> +++ b/drivers/infiniband/hw/xsc/qp.c
[ ... ]
> +static int set_rq_size(struct xsc_ib_dev *dev, struct ib_qp_init_attr *i=
nit_attr,
> +		       int has_rq, struct xsc_ib_qp *qp, struct xsc_ib_create_qp *ucmd)
> +{
> +	u32 wqe_cnt =3D init_attr->cap.max_recv_wr ?
> +		roundup_pow_of_two(init_attr->cap.max_recv_wr) : 0;
> +
> +	if (init_attr->srq)
> +		wqe_cnt =3D to_xsrq(init_attr->srq)->xsrq.max;
> +
> +	if (wqe_cnt > dev->xdev->caps.max_wqes) {
> +		ibdev_err(&dev->ib_dev, "max_recv_wr:%d exceed max rq depth\n",
> +			  init_attr->cap.max_recv_wr);
> +		return -EINVAL;
> +	}
[ ... ]
> +static int calc_sq_size(struct xsc_ib_dev *dev, struct ib_qp_init_attr *=
attr,
> +			struct xsc_ib_qp *qp)
> +{
> +	int wqe_size;
> +	size_t wq_size;
> +
> +	if (!attr->cap.max_send_wr) {
> +		ibdev_err(&dev->ib_dev, "invalid max_send_wr:%d\n", attr->cap.max_send=
_wr);
> +		return -1;
> +	}
> +
> +	wqe_size =3D 1 << dev->xdev->caps.send_wqe_shift;
> +	qp->max_inline_data =3D (dev->xdev->caps.send_ds_num - 2) * sizeof(stru=
ct xsc_wqe_data_seg);
> +	attr->cap.max_inline_data =3D qp->max_inline_data;
> +
> +	attr->cap.max_send_wr =3D min_t(u32, attr->cap.max_send_wr, dev->xdev->=
caps.max_wqes);
> +	qp->sq.wqe_cnt =3D roundup_pow_of_two(attr->cap.max_send_wr);

[Severity: Medium]
In set_rq_size(), if init_attr->cap.max_recv_wr is greater than 0x80000000U
and init_attr->srq is NULL, roundup_pow_of_two(init_attr->cap.max_recv_wr)
returns 1UL << 32 on 64-bit platforms (or invokes shift undefined behavior =
on
32-bit platforms) and truncates to 0 when assigned to u32 wqe_cnt.

When wqe_cnt truncates to 0, the wqe_cnt > dev->xdev->caps.max_wqes check is
bypassed and, for kernel QPs, qp->rq.wqe_cnt and qp->rq.max_post remain 0
even though qp->has_rq is 1.

Also, in calc_sq_size(), attr->cap.max_send_wr is silently clamped to
dev->xdev->caps.max_wqes with min_t() instead of returning -EINVAL when the
requested depth exceeds device limits.

Should set_rq_size() and calc_sq_size() validate init_attr->cap.max_recv_wr
and attr->cap.max_send_wr against dev->xdev->caps.max_wqes before calling
roundup_pow_of_two()?

[ ... ]
> +static int create_user_qp(struct xsc_ib_dev *dev, struct ib_pd *pd,
> +			  struct xsc_ib_qp *qp, struct ib_udata *udata,
> +			  struct xsc_ib_create_qp *ucmd,
> +			  struct xsc_create_qp_mbox_in **in, int *inlen)
> +{
> +	int page_shift;
> +	int npages;
> +	u32 offset;
> +	int ncont;
> +	int err;
> +	int hw_npages;
> +	u32 sq_shift, rq_shift;
> +	u32 sq_wqe_cnt, rq_wqe_cnt;
> +	struct ib_umem_dmabuf *umem_dmabuf;
> +
> +	ibdev_dbg(&dev->ib_dev, "buf_addr:0x%lx db_addr:0x%lx sq cnt:%u, rq cnt=
:%u, rq shift:%u\n",
> +		  (uintptr_t)ucmd->buf_addr, (uintptr_t)ucmd->db_addr,
> +		    ucmd->sq_wqe_count, ucmd->rq_wqe_count, ucmd->rq_wqe_shift);
> +
> +	sq_shift =3D dev->xdev->caps.send_wqe_shift;
> +	rq_shift =3D ucmd->rq_wqe_shift;
> +	if (sq_shift < XSC_BASE_WQE_SHIFT || sq_shift > 31 ||
> +	    (ucmd->rq_wqe_count &&
> +	     (rq_shift < XSC_BASE_WQE_SHIFT || rq_shift > 31))) {
> +		ibdev_err(&dev->ib_dev, "invalid user queue parameters\n");
> +		return -EINVAL;
> +	}
> +
> +	if (ucmd->sq_wqe_count) {
> +		if (!is_power_of_2(ucmd->sq_wqe_count) ||
> +		    ucmd->sq_wqe_count < (1u << (sq_shift - XSC_BASE_WQE_SHIFT))) {
> +			ibdev_err(&dev->ib_dev, "invalid user sq parameters\n");
> +			return -EINVAL;
> +		}
> +		sq_wqe_cnt =3D ucmd->sq_wqe_count >> (sq_shift - XSC_BASE_WQE_SHIFT);
> +	} else {
> +		sq_wqe_cnt =3D 0;
> +	}
> +
> +	if (ucmd->rq_wqe_count) {
> +		if (!is_power_of_2(ucmd->rq_wqe_count) ||
> +		    ucmd->rq_wqe_count < (1u << (rq_shift - XSC_BASE_WQE_SHIFT))) {
> +			ibdev_err(&dev->ib_dev, "invalid user rq parameters\n");
> +			return -EINVAL;
> +		}
> +		rq_wqe_cnt =3D ucmd->rq_wqe_count >> (rq_shift - XSC_BASE_WQE_SHIFT);
> +	} else {
> +		rq_wqe_cnt =3D 0;
> +	}
> +
> +	if (sq_wqe_cnt > dev->xdev->caps.max_wqes ||
> +	    rq_wqe_cnt > dev->xdev->caps.max_wqes) {
> +		ibdev_err(&dev->ib_dev, "user queue depth exceeds max %u\n",
> +			  dev->xdev->caps.max_wqes);
> +		return -EINVAL;
> +	}
> +
> +	qp->sq.ds_cnt =3D ucmd->sq_wqe_count;
> +	qp->sq.wqe_cnt =3D sq_wqe_cnt;
> +	qp->sq.wqe_shift =3D sq_wqe_cnt ? sq_shift : 0;
> +	qp->sq.max_gs =3D dev->xdev->caps.send_ds_num - XSC_CTRL_SEG_NUM - XSC_=
RADDR_SEG_NUM;
> +	qp->rq.ds_cnt =3D ucmd->rq_wqe_count;
> +	qp->rq.wqe_cnt =3D rq_wqe_cnt;
> +	qp->rq.wqe_shift =3D rq_wqe_cnt ? rq_shift : 0;
> +	if (rq_wqe_cnt) {
> +		qp->rq.max_gs =3D 1;
> +		qp->rq.max_post =3D rq_wqe_cnt;
> +	}
> +
> +	qp->rq.offset =3D 0;
> +	qp->sq.offset =3D (u32)qp->rq.wqe_cnt << qp->rq.wqe_shift;
> +	qp->buf_size =3D (u64)qp->sq.offset +
> +		       ((u64)qp->sq.wqe_cnt << qp->sq.wqe_shift);
> +	if (qp->buf_size > (u64)U16_MAX * XSC_PAGE_SIZE_4K) {
> +		ibdev_err(&dev->ib_dev, "QP buffer size too large\n");
> +		return -EINVAL;
> +	}

[Severity: High]
Can the 32-bit shift in qp->sq.offset =3D (u32)qp->rq.wqe_cnt <<
qp->rq.wqe_shift overflow and bypass the qp->buf_size check in
create_user_qp()?

Because rq_shift is permitted up to 31 and struct xsc_ib_wq defines offset =
as
a signed 32-bit int, a user supplying ucmd->rq_wqe_shift =3D 31 and
ucmd->rq_wqe_count =3D 1U << 28 gets rq_wqe_cnt =3D 2 (which passes the max=
_wqes
check), while (u32)qp->rq.wqe_cnt << qp->rq.wqe_shift wraps in 32-bit
arithmetic to 0.

When qp->sq.offset wraps to 0, qp->buf_size only accounts for the SQ size a=
nd
passes the U16_MAX * XSC_PAGE_SIZE_4K check, so the driver pins and populat=
es
PAS entries only for the SQ while create_qp_common() programs
in->req.log_rq_sz =3D ilog2(qp->rq.ds_cnt) (a 4 GiB RQ) into the hardware.
Similarly, if ucmd->sq_wqe_count is 0, create_user_qp() allocates 0 bytes f=
or
the SQ in qp->buf_size, whereas create_qp_common() still sets
in->req.log_sq_sz =3D ilog2(0x80) in the firmware request.

> +	hw_npages =3D DIV_ROUND_UP(qp->buf_size, XSC_PAGE_SIZE_4K);
> +
> +	if (udata->inlen >=3D offsetofend(typeof(*ucmd), dmabuf_fd) &&
> +	    ucmd->dmabuf_fd !=3D -1) {
> +		if (ucmd->dmabuf_sz < qp->buf_size) {

[Severity: Medium]
In create_user_qp(), does the dmabuf check verify enough of udata->inlen
before reading ucmd->dmabuf_sz?

Checking udata->inlen >=3D offsetofend(typeof(*ucmd), dmabuf_fd) only ensur=
es
the buffer covers dmabuf_fd (36 bytes), not the following dmabuf_sz field (=
up
to 48 bytes). Also, in create_qp_common(), ib_copy_from_udata() copies
min(udata->inlen, sizeof(ucmd)) without checking that udata->inlen is at
least offsetofend(struct xsc_ib_create_qp, flags) for the mandatory base
fields.

Should create_qp_common() reject udata->inlen smaller than
offsetofend(typeof(ucmd), flags) and create_user_qp() check
offsetofend(typeof(*ucmd), dmabuf_sz)?

> +			ibdev_err(&dev->ib_dev, "dmabuf_sz %llu < qp buf_size %llu\n",
> +				  ucmd->dmabuf_sz, qp->buf_size);
> +			return -EINVAL;
> +		}
> +
> +		umem_dmabuf =3D ib_umem_dmabuf_get_pinned(&dev->ib_dev, 0, ucmd->dmabu=
f_sz,
> +							ucmd->dmabuf_fd, IB_ACCESS_LOCAL_WRITE);
[ ... ]
> +	err =3D xsc_ib_get_buf_offset(ucmd->buf_addr, page_shift, &offset);
> +	if (err) {
> +		ibdev_err(&dev->ib_dev, "bad offset:%d\n", offset);
> +		goto err_umem;
> +	}

[Severity: Medium]
In create_user_qp(), offset is declared on the stack without initialization.
Looking at xsc_ib_get_buf_offset() in drivers/infiniband/hw/xsc/mem.c:

	if (buf_off & off_mask)
		return -EINVAL;

	*offset =3D buf_off >> ilog2(off_size);
	return 0;

When ucmd->buf_addr fails the alignment check, xsc_ib_get_buf_offset()
returns -EINVAL without initializing *offset, so ibdev_err() prints
uninitialized kernel stack memory. Also, when offset is non-zero, hw_npages=
 =3D
DIV_ROUND_UP(qp->buf_size, XSC_PAGE_SIZE_4K) does not account for the
sub-page offset if the buffer crosses a 4K page boundary, and offset is nev=
er
passed to firmware.

> +	ibdev_dbg(&dev->ib_dev, "npage:%d, page_shift:%d, ncont:%d, offset:%u, =
hw_npages %d\n",
> +		  npages, page_shift, ncont, offset, hw_npages);
> +
> +	*inlen =3D sizeof(**in) + (size_t)hw_npages * sizeof((*in)->req.pas[0]);
> +	*in =3D xsc_vzalloc(*inlen);
> +	if (!*in) {
> +		err =3D -ENOMEM;
> +		goto err_umem;
> +	}
> +	xsc_ib_populate_pas(dev, qp->umem, page_shift, (*in)->req.pas, hw_npage=
s, true);

[Severity: Critical]
Can create_user_qp() trigger an out-of-bounds heap write into (*in)->req.pas
when hw_npages is 0?

If userspace passes ucmd->sq_wqe_count =3D=3D 0 and ucmd->rq_wqe_count =3D=
=3D 0 (or
triggers the 32-bit overflow in qp->sq.offset with sq_wqe_count =3D=3D 0),
qp->buf_size is 0 and hw_npages is 0. If userspace also provides a valid
ucmd->dmabuf_fd !=3D -1 with ucmd->dmabuf_sz >=3D PAGE_SIZE, the check
ucmd->dmabuf_sz < qp->buf_size is false and ib_umem_dmabuf_get_pinned()
returns a non-empty umem.

create_user_qp() then allocates *in with *inlen =3D sizeof(**in) (zero elem=
ents
in req.pas[]) and calls xsc_ib_populate_pas() -> __xsc_ib_populate_pas() wi=
th
num_pages =3D 0:

drivers/infiniband/hw/xsc/mem.c:__xsc_ib_populate_pas()
	pas[idx] =3D cpu_to_be64(cur);
	...
	i++;

	/* Stop after num_pages reached */
	if (i >> shift >=3D offset + num_pages)
		return;

Because __xsc_ib_populate_pas() writes pas[0] before checking whether
num_pages has been reached, this overwrites 8 bytes past the end of *in.
Should create_user_qp() reject qp->buf_size =3D=3D 0 (or both sq_wqe_count =
=3D=3D 0
and rq_wqe_count =3D=3D 0)?

[ ... ]
> +static int create_qp_common(struct xsc_ib_dev *dev, struct ib_pd *pd,
> +			    struct ib_qp_init_attr *init_attr,
> +			    struct ib_udata *udata, struct xsc_ib_qp *qp)
> +{
[ ... ]
> +	if (init_attr->send_cq) {
> +		qp->send_cq =3D init_attr->send_cq;
> +		in->req.cqn_send =3D to_xcq(init_attr->send_cq)->xcq.cqn;
> +		in->req.cqn_send =3D cpu_to_be16(in->req.cqn_send);
> +	}
> +
> +	if (init_attr->recv_cq) {
> +		qp->recv_cq =3D init_attr->recv_cq;
> +		in->req.cqn_recv =3D to_xcq(init_attr->recv_cq)->xcq.cqn;
> +		in->req.cqn_recv =3D cpu_to_be16(in->req.cqn_recv);
> +	}
[ ... ]
> +	err =3D xsc_core_create_qp(dev->xdev, &qp->xqp, in, inlen);
> +	if (err) {
> +		ibdev_err(&dev->ib_dev, "create qp failed, err=3D%d\n", err);
> +		goto err_create;
> +	}
> +
> +	qp->doorbell_qpn =3D qp->xqp.qpn;
> +
> +	qp->xqp.qp_type =3D init_attr->qp_type;
> +	ret +=3D snprintf(ptr + ret, 256 - ret, "pdn=3D%d,", to_xpd(pd)->pdn);
> +	ret +=3D snprintf(ptr + ret, 256 - ret, "log_rq_sz=3D%d,", in->req.log_=
rq_sz);
> +	ret +=3D snprintf(ptr + ret, 256 - ret, "log_sq_sz=3D%d,", in->req.log_=
sq_sz);
> +	ret +=3D snprintf(ptr + ret, 256 - ret, "scqn=3D%d,", to_xcq(init_attr-=
>send_cq)->xcq.cqn);
> +	ret +=3D snprintf(ptr + ret, 256 - ret, "rcqn=3D%d", to_xcq(init_attr->=
recv_cq)->xcq.cqn);

[Severity: High]
Earlier in create_qp_common(), init_attr->send_cq and init_attr->recv_cq are
checked for NULL before dereferencing, and get_cqs() also guards both
pointers.

However, these two snprintf() calls unconditionally dereference
to_xcq(init_attr->send_cq) and to_xcq(init_attr->recv_cq). Since ibcq is at
offset 0 of struct xsc_ib_cq, won't creating a QP with a NULL send_cq or
recv_cq cause a NULL pointer dereference here right after xsc_core_create_q=
p()
has already created the QP in firmware?

[ ... ]
> +int xsc_ib_destroy_qp(struct ib_qp *qp, struct ib_udata *udata)
> +{
> +	struct xsc_ib_dev *dev =3D to_xdev(qp->device);
> +	struct xsc_ib_qp *xqp =3D to_xqp(qp);
> +	struct xsc_err_state_qp_node *tmp =3D NULL, *err_rq_node =3D NULL, *err=
_sq_node =3D NULL;
> +	struct xsc_srq_qp_node *qp_node =3D NULL, *tmp_qp_node =3D NULL;
> +	unsigned long flags;
> +	struct xsc_ib_srq *xsrq;
> +
> +	if (qp->qp_type =3D=3D IB_QPT_RC) {
> +		if (xqp->recv_cq) {
> +			spin_lock_irq(&to_xcq(xqp->recv_cq)->err_state_qp_lock);
> +			list_for_each_entry_safe(err_rq_node, tmp,
> +						 &to_xcq(xqp->recv_cq)->err_state_qp_list, entry) {
> +				if (err_rq_node->qp_id =3D=3D xqp->xqp.qpn && !err_rq_node->is_sq) {
> +					list_del(&err_rq_node->entry);
> +					kfree(err_rq_node);
> +				}
> +			}
> +			spin_unlock_irq(&to_xcq(xqp->recv_cq)->err_state_qp_lock);
> +		}
> +
> +		if (xqp->send_cq) {
> +			spin_lock_irq(&to_xcq(xqp->send_cq)->err_state_qp_lock);
> +			list_for_each_entry_safe(err_sq_node, tmp,
> +						 &to_xcq(xqp->send_cq)->err_state_qp_list, entry) {
> +				if (err_sq_node->qp_id =3D=3D xqp->xqp.qpn && err_sq_node->is_sq) {
> +					list_del(&err_sq_node->entry);
> +					kfree(err_sq_node);
> +				}
> +			}
> +			spin_unlock_irq(&to_xcq(xqp->send_cq)->err_state_qp_lock);
> +		}
> +	}

[Severity: High]
Can xsc_ib_destroy_qp() leak err_state_qp_node entries or race with concurr=
ent
CQ polling when cleaning err_state_qp_list?

First, xsc_ib_modify_qp() and xsc_poll_one() call xsc_ib_err_state_qp() for
any kernel QP transitioning to XSC_QP_STATE_ERR regardless of qp_type, but
xsc_ib_destroy_qp() only purges err_state_qp_list when qp->qp_type =3D=3D
IB_QPT_RC. If a non-RC kernel QP (such as IB_QPT_GSI, IB_QPT_SMI, or
IB_QPT_RAW_PACKET) enters IB_QPS_ERR and is destroyed, its err_rq_node and
err_sq_node entries remain on the CQs' err_state_qp_list.

Second, even for IB_QPT_RC QPs, xsc_ib_destroy_qp() purges err_state_qp_list
before destroy_qp_common() moves the hardware QP to XSC_QP_STATE_RST and
cleans the CQs under xsc_ib_lock_cqs(). While xsc_core_qp_modify() is
sleeping in destroy_qp_common(), a concurrent xsc_ib_poll_cq() on another C=
PU
can poll an error CQE for this QP and call xsc_ib_err_state_qp(), inserting
new nodes onto err_state_qp_list after this cleanup loop has already run, a=
nd
xsc_generate_flush_err_cqe() walks err_state_qp_list without holding cq->lo=
ck
while destroy_qp_kernel() frees the QP work queue buffers.

Should the err_state_qp_list removal happen for all kernel QP types inside
destroy_qp_common() while holding the CQ locks after the QP has been moved =
to
RESET?

[ ... ]
> +static inline void xsc_set_qp_access_flag(struct xsc_modify_qp_mbox_in *=
in,
> +					  struct xsc_qp_context *context, int access_flags)
> +{
> +	in->hdr.ver =3D cpu_to_be16(XSC_QP_CONTEXT_V1);
> +	context->qp_access_flags =3D 0;
[ ... ]
> +static int __xsc_ib_modify_qp(struct ib_qp *ibqp,
> +			      const struct ib_qp_attr *attr, int attr_mask,
> +			      enum ib_qp_state cur_state, enum ib_qp_state new_state,
> +			      const struct xsc_ib_modify_qp *ucmd,
> +			      struct ib_udata *udata)
> +{
> +	struct xsc_ib_dev *dev =3D to_xdev(ibqp->device);
> +	struct xsc_ib_qp *qp =3D to_xqp(ibqp);
> +	struct xsc_ib_cq *send_cq, *recv_cq;
> +	struct xsc_qp_context *context;
> +	struct xsc_modify_qp_mbox_in *in;
> +	struct xsc_qp_path path =3D {};
> +	int err;
> +	char buf[256] =3D {0};
> +	char *ptr =3D buf;
> +	int ret =3D 0;
> +	struct xsc_core_device *xdev =3D dev->xdev;
> +
> +	in =3D kzalloc_obj(*in, GFP_KERNEL);
> +	if (!in)
> +		return -ENOMEM;
> +
> +	context =3D &qp->ctx;

[Severity: Medium]
In __xsc_ib_modify_qp(), context points directly to &qp->ctx and mutates the
cached context in place before xsc_set_path() or xsc_core_qp_modify()
succeeds, and transitioning to IB_QPS_RESET never clears stale fields in
qp->ctx. In addition, xsc_set_qp_access_flag() sets in->hdr.ver =3D
cpu_to_be16(XSC_QP_CONTEXT_V1) only when IB_QP_ACCESS_FLAGS is present in
attr_mask, so on subsequent transitions where IB_QP_ACCESS_FLAGS is omitted,
in->hdr.ver remains 0 even though the cached context->qp_access_flags is
copied into in->ctx.

Also, in create_qp_common(), in->req.page_shift is set to PAGE_SHIFT even
though create_user_qp() and create_kernel_qp() always compute hw_npages
(in->req.pa_num) and populate in->req.pas[] in 4 KB units (XSC_PAGE_SIZE_4K=
 /
XSC_PAGE_SHIFT_4K). On architectures with 64 KB pages (PAGE_SHIFT =3D=3D 16=
),
won't passing PAGE_SHIFT to firmware mismatch the 4 KB PAS entries?

[ ... ]
> +	/*
> +	 * If we moved a kernel QP to RESET, clean up all old CQ
> +	 * entries and reinitialize the QP.
> +	 */
> +	if (new_state =3D=3D IB_QPS_RESET && !ibqp->uobject) {
> +		get_cqs(qp->xqp.qp_type, qp->ibqp.send_cq, qp->ibqp.recv_cq, &send_cq,=
 &recv_cq);
> +		xsc_ib_cq_clean(recv_cq, qp->xqp.qpn);
> +		if (send_cq !=3D recv_cq)
> +			xsc_ib_cq_clean(send_cq, qp->xqp.qpn);
> +
> +		qp->rq.head =3D 0;
> +		qp->rq.tail =3D 0;
> +		qp->sq.head =3D 0;
> +		qp->sq.tail =3D 0;
> +		qp->sq.cur_post =3D 0;
> +		qp->sq.last_poll =3D 0;
> +		qp->sq.last_comp_ce_wqe =3D -1;
> +		qp->sq.last_post_ce_wqe =3D -1;
> +		qp->has_trig_cq_comp_handle =3D false;
> +	}
[ ... ]
> +	err =3D __xsc_ib_modify_qp(ibqp, attr, attr_mask, cur_state, new_state,=
 &ucmd, udata);
> +
> +	if (!err && (attr_mask & IB_QP_STATE) && !udata) {
> +		bool trigger;
> +
> +		get_cqs(qp->xqp.qp_type, qp->send_cq, qp->recv_cq, &send_cq, &recv_cq);
> +		xsc_ib_lock_cqs(send_cq, recv_cq);
> +		err =3D xsc_ib_err_state_qp(dev, qp, to_xsc_state(cur_state),
> +					  to_xsc_state(new_state), &trigger);
> +		xsc_ib_unlock_cqs(send_cq, recv_cq);
> +
> +		if (!err && trigger)
> +			xsc_ib_trigger_cq_comp_handler(qp->send_cq, qp->recv_cq);
> +	}

[Severity: High]
When a kernel QP enters error state via a hardware error CQE in
xsc_poll_one(), xsc_ib_err_state_qp() queues err_rq_node and err_sq_node on=
to
the CQs' err_state_qp_list and sets qp->has_trig_cq_comp_handle =3D true, b=
ut
qp->state remains at its previous software state (such as IB_QPS_RTS).

When xsc_ib_modify_qp() later resets the QP to IB_QPS_RESET, cur_state is
taken from qp->state (not IB_QPS_ERR), so the removal branch in
xsc_ib_err_state_qp() (cur_state =3D=3D XSC_QP_STATE_ERR && state !=3D
XSC_QP_STATE_ERR) is not taken. Because __xsc_ib_modify_qp() also resets
qp->has_trig_cq_comp_handle =3D false, won't the existing err_rq_node and
err_sq_node be leaked on err_state_qp_list and duplicated if the QP enters
error state again?

Furthermore, in __xsc_ib_modify_qp(), qp->rq and qp->sq indices are zeroed
without holding cq->lock, qp->rq.lock, or qp->sq.lock before
xsc_ib_err_state_qp() removes the QP from err_state_qp_list, and
qp->rq.flush_wqe_cnt, qp->sq.flush_wqe_cnt, and qp->sq.need_flush[] are not
cleared. Can a concurrent xsc_ib_poll_cq() running
xsc_generate_flush_err_cqe() race with this reset?

> +
> +	if (!err && !udata && (attr_mask & IB_QP_STATE) && ibqp->srq &&
> +	    cur_state =3D=3D IB_QPS_RESET && new_state =3D=3D IB_QPS_INIT) {
> +		srq =3D to_xsrq(ibqp->srq);
> +		spin_lock_irqsave(&srq->lock, flags);
> +		srq->qp_num++;
> +		wr_num =3D XSC_SRQ_MIN_WR_NUM;
> +		ibdev_dbg(&dev->ib_dev,
> +			  "SRQ %d: qp %d to INIT, post %d srq wrs, qp_num %d\n",
> +			   srq->xsrq.srqn, qp->xqp.qpn, wr_num, srq->qp_num);
> +		xsc_post_cache_wrs(srq, qp, wr_num, true);
> +		spin_unlock_irqrestore(&srq->lock, flags);
> +	}

[Severity: High]
Can kernel QPs attached to an SRQ leak cached WRs and corrupt srq->qp_num
across QP creation, reset, and destruction?

1. In create_qp_common(), a kernel QP with init_attr->srq is added to
   xsrq->xsrq.srq_qp_list while still in IB_QPS_RESET and without
   incrementing xsrq->qp_num. If xsc_ib_post_srq_recv() runs before the QP
   transitions to IB_QPS_INIT, it sees the QP on srq_qp_list with
   flush_wqe_cnt =3D=3D 0 and calls xsc_post_cache_wrs(srq, qp, wr_num, fal=
se),
   posting WQEs and ringing the RX doorbell on a RESET QP. When
   xsc_ib_modify_qp() then transitions the QP from IB_QPS_RESET to
   IB_QPS_INIT, xsc_post_cache_wrs(srq, qp, wr_num, true) overwrites
   qp->srq_head_wr because init is true, leaking the previously attached
   ib_recv_wr and sg_list allocations.

2. When a kernel QP with an SRQ is modified back to IB_QPS_RESET in
   __xsc_ib_modify_qp(), qp->rq.head and qp->rq.tail are zeroed without
   calling xsc_restore_cache_srq_wrs(), resetting qp->rq.flush_wqe_cnt, or
   decrementing srq->qp_num. Transitioning from IB_QPS_RESET to IB_QPS_INIT
   again increments srq->qp_num a second time and overwrites qp->srq_head_w=
r.
   Conversely, if a QP is destroyed in IB_QPS_RESET before ever reaching
   IB_QPS_INIT, xsc_ib_destroy_qp() decrements srq->qp_num even though it w=
as
   never incremented.

3. In xsc_ib_destroy_qp(), list_empty(&to_xsrq(qp->srq)->xsrq.srq_qp_list) =
is
   checked outside xsrq->lock (which races with list_sort() in
   xsc_ib_post_srq_recv()), and xsc_restore_cache_srq_wrs() is called before
   destroy_qp_common() transitions the QP to RESET.

[ ... ]
> +int xsc_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr, int =
qp_attr_mask,
> +		    struct ib_qp_init_attr *qp_init_attr)
> +{
> +	struct xsc_ib_dev *dev =3D to_xdev(ibqp->device);
> +	struct xsc_ib_qp *qp =3D to_xqp(ibqp);
> +	struct xsc_query_qp_mbox_out *outb;
> +	struct xsc_qp_context *context;
> +	int err =3D 0;
> +
> +	mutex_lock(&qp->mutex);

[Severity: High]
Does xsc_ib_query_qp() leak uninitialized kernel memory to userspace?

In drivers/infiniband/core/uverbs_cmd.c, ib_uverbs_query_qp() allocates attr
and init_attr with kmalloc_obj() (not kzalloc), and ib_query_qp() only zero=
es
the two sgid_attr pointers before calling the driver's query_qp callback.

Because xsc_ib_query_qp() does not memset() qp_attr or qp_init_attr before
populating a subset of fields, uninitialized heap bytes in fields such as
path_mig_state, qkey, qp_access_flags, pkey_index, min_rnr_timer, timeout,
alt_port_num, alt_timeout, ah_attr (including 32 bytes of GRH/dgid data when
the uninitialized ah_flags byte has IB_AH_GRH set), and qp_init_attr are
copied back to userspace in struct ib_uverbs_query_qp_resp.

> +
> +	outb =3D kzalloc_obj(*outb, GFP_KERNEL);
> +	if (!outb) {
> +		err =3D -ENOMEM;
> +		goto out;
> +	}
> +	context =3D &outb->ctx;
> +	err =3D xsc_core_qp_query(dev->xdev, &qp->xqp, outb, sizeof(*outb));
> +	if (err)
> +		goto out_free;
> +
> +	if (qp->xqp.err_occurred) {
> +		qp->state =3D IB_QPS_ERR;
> +		qp->xqp.err_occurred =3D 0;
> +	}
> +	qp_attr->qp_state	     =3D qp->state;
> +	qp_attr->path_mtu	     =3D context->mtu_mode ? IB_MTU_4096 : IB_MTU_102=
4;
> +	qp_attr->rq_psn		     =3D be32_to_cpu(context->next_recv_psn) & 0xfffff=
f;
> +	qp_attr->sq_psn		     =3D be32_to_cpu(context->next_send_psn) & 0xfffff=
f;
> +	qp_attr->dest_qp_num	     =3D be32_to_cpu(context->remote_qpn) & 0xffff=
ff;
> +	qp_attr->sq_draining =3D 0;
> +	qp_attr->retry_cnt	    =3D context->retry_cnt;
> +	qp_attr->rnr_retry	    =3D context->rnr_retry;
> +	qp_attr->cur_qp_state	     =3D qp_attr->qp_state;
> +	qp_attr->cap.max_recv_wr     =3D qp->rq.wqe_cnt;
> +	qp_attr->cap.max_recv_sge    =3D qp->rq.max_gs;
> +	qp_attr->max_rd_atomic =3D context->max_sra;
> +	qp_attr->max_dest_rd_atomic =3D context->max_rra;
> +	qp_attr->port_num =3D 1;
> +
> +	if (!ibqp->uobject) {
> +		qp_attr->cap.max_send_wr  =3D qp->sq.wqe_cnt;
> +		qp_attr->cap.max_send_sge =3D qp->sq.max_gs;
> +	} else {
> +		qp_attr->cap.max_send_wr  =3D qp->sq.wqe_cnt;
> +		qp_attr->cap.max_send_sge =3D qp->sq.max_gs;
> +	}

[Severity: Medium]
In __xsc_ib_modify_qp(), context->mtu_mode is set to 0 for IB_MTU_1024, 1 f=
or
IB_MTU_4096, and 2 for IB_MTU_8192, but xsc_ib_query_qp() decodes
context->mtu_mode ? IB_MTU_4096 : IB_MTU_1024, reporting IB_MTU_4096 when
mtu_mode is 2. Should xsc_ib_query_qp() map mtu_mode =3D=3D 2 to IB_MTU_819=
2?

Also, both branches of if (!ibqp->uobject) in xsc_ib_query_qp() are
identical, and the static helpers to_ib_qp_state() and to_ib_mig_state()
defined just above xsc_ib_query_qp() are unused.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104155650.3705=
3-1-tianx@yunsilicon.com?part=3D13
