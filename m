Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0076472061
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 11:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791891974; cv=none; b=YClcvu1oS1s5pGxNqYKoCmXmaBhoscHJXtMY41TBk6BpyprgPHJKWj/b72ZOLppOwwYnSpA8/gAUgx5Ihbd0Uhjp7tO023EuPA0Dz/wNrCzdaKvQdO6obEOXJrVtlgHgHf4jW/M0AMepBLyKHP2jXVd8pmv5Mm/0+oPU6vIf04I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791891974; c=relaxed/simple;
	bh=8zr60nnhEUWigPH7n5KfzpHp7dPMZrac5Ffl06ijTa8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=jtcPbkiiqUoKCyRCEvpmckGtoi9MOc/CX1rZXDeoH2uSWE+PfYWkEP4t/CUi0ZXfl3heNGpPkb2HcA1gJNmFxUlqPniuyBWBzpmHWFEkQ282E/+6sWnQ59qXuJy9OR/Y/Gi3/EsfhQ9ydVUWarEYlwLxAFDfHCroM8cIH52pr10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JaHcyKAf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JaHcyKAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E7E1F00893;
	Tue, 13 Oct 2026 11:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791891972;
	bh=74vgaOGH75tNviuH0hpI+Pd1nyDZd0SQR+Qk9ZSa7Jc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JaHcyKAf+wSecI5qrC/LSf7AJ/6PjBSyvAvr9I93Wl5PSnIQlTEITIJ0HV3jGV/OG
	 fAKsn/v/gxXNFPeGjLyiOy44MnxEM2nLpVe0GKgGAJzfuWHP9ZPEck/y1f2a/J8DEg
	 alChwyaz/5OgoFOyA8rseMw78Oav+vXNyMSmx1NzN9W3SOTk60pRphO/5HXG16mkyf
	 nY5Q6ptMm66w3NGUPbMvqIb5zvaFq2K6I7MYCXl9JyTEjxO/gbwetpQ2slHsQ27Sex
	 llnNcCyjv3ZSmmpyIgl+tqtQ2aFKb2v/kSOGHaBv9+fjcE0DtXD1en9vbq2jOEhQP0
	 oNB43V7M/r9MA==
Message-ID: <sashiko-outbox-169647@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 12/15] yunsilicon: add RDMA QP verbs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261012114421.2471317-13-tianx@yunsilicon.com>
References: <20261012114352.2471317-1-tianx@yunsilicon.com>
 <20261012114421.2471317-13-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 11:46:12 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 14 potential issue=
(s) to consider:
- [Critical] rdma: integer overflow on queue sizes leads to OOB DMA
- [High] rdma: uninitialized stack memory leaked to userspace in create_use=
r_qp
- [High] rdma: sleeping allocation with spinlocks held in xsc_ib_err_state_=
qp
- [High] rdma: UAF and HW resource leak on allocation failure in destroy_qp=
_common
- [High] rdma: UAF and HW resource leak on qp_node allocation failure in cr=
eate_qp_common
- [High] rdma: race condition adding QP node to SRQ list in create_qp_common
- [High] rdma: double byteswap and endianness corruption of qp_access_flags
- [High] infiniband/xsc: hardware DMA into stale memory due to uninitialize=
d SGEs in xsc_ib_post_recv
- [High] xsc: ABI breakage and OOB read in create_qp due to size_t and blin=
d copy
- [High] yunsilicon: dead code and missing error return in xsc_check_max_qp=
_depth
- [Medium] rdma: memory leak of mailbox in on error paths in create_qp_comm=
on
- [Medium] rdma: uninitialized stack memory copied to hardware context in x=
sc_set_path
- [Medium] rdma: undefined behavior due to negative shift in create_kernel_=
qp
- [Medium] rdma: passing struct size to sqd_event parameter in destroy_qp_c=
ommon
--

commit 624855b048b853b9911aa55007116f0a1e95d930
Author: Xin Tian <tianx@yunsilicon.com>
Subject: yunsilicon: add RDMA QP verbs

This commit adds the queue pair control path: create, destroy, modify and
query, for both kernel and user queue pairs, including the address path set=
up
for RoCE.

diff --git a/drivers/infiniband/hw/xsc/qp.c b/drivers/infiniband/hw/xsc/qp.c
index 28c8a1246dfae..6a83adc9c833f 100644
--- a/drivers/infiniband/hw/xsc/qp.c
+++ b/drivers/infiniband/hw/xsc/qp.c
@@ -101,11 +101,11 @@ static int calc_sq_size(struct xsc_ib_dev *dev, struc=
t ib_qp_init_attr *attr,
>  	qp->sq.wqe_cnt =3D roundup_pow_of_two(attr->cap.max_send_wr);
> =20
>  	check_res =3D xsc_check_max_qp_depth(dev->xdev, &qp->sq.wqe_cnt, dev->x=
dev->caps.max_wqes);
>  	if (check_res) {
>  		ibdev_err(&dev->ib_dev, "max_send_wr:%d exceed max sq depth\n",
>  			  attr->cap.max_send_wr);
>  		return -EINVAL;
>  	}

[Severity: High]
Does this error path ever execute?

The helper xsc_check_max_qp_depth() unconditionally returns false while
silently clamping the queue depth instead of indicating an error. This hides
invalid user requests.=20

Does clamping the queue depth break the power-of-two property if max_wqes is
not a power of two? This could break the wrapping logic in the post_send and
post_recv paths, potentially leading to memory corruption.

[ ... ]

>  	err =3D ib_copy_from_udata(&ucmd, udata, sizeof(ucmd));
>  	if (err) {
>  		ibdev_err(&dev->ib_dev, "failed to copy from udata, err=3D%d\n", err);
>  		return err;
>  	}

[Severity: High]
Is there a risk of an out-of-bounds memory read here?

This code reads sizeof(ucmd) bytes from userspace without verifying if
udata->inlen is large enough. If a 32-bit application or an older tool
passes a smaller struct, it might trigger an -EFAULT by crossing an unmapped
page boundary, or read uninitialized memory into fields like dmabuf_sz.

Also, does using size_t for dmabuf_sz in the xsc_ib_create_qp UAPI structure
break layout compatibility between 32-bit userspace and 64-bit kernels?

[ ... ]

>  	qp->sq.ds_cnt =3D ucmd.sq_wqe_count;
>  	qp->sq.wqe_cnt =3D ucmd.sq_wqe_count;
>  	qp->sq.wqe_shift =3D XSC_BASE_WQE_SHIFT;
>  	qp->rq.ds_cnt =3D ucmd.rq_wqe_count;
>  	qp->rq.wqe_cnt =3D ucmd.rq_wqe_count;
>  	qp->rq.wqe_shift =3D XSC_BASE_WQE_SHIFT;
> =20
>  	qp->buf_size =3D (qp->sq.wqe_cnt << qp->sq.wqe_shift) + (qp->rq.wqe_cnt=
 << qp->rq.wqe_shift);

[Severity: Critical]
Can this lead to an integer overflow and out-of-bounds DMA?

Unvalidated queue counts from userspace can overflow a 32-bit signed integer
when calculating qp->buf_size, resulting in a small allocation. However, the
hardware will receive the huge queue counts and expect a large ring buffer.
This could potentially allow malicious userspace to trigger out-of-bounds D=
MA
across host physical memory.

[ ... ]

>  	*inlen =3D sizeof(**in) + sizeof(*((*in)->req.pas)) * hw_npages;
>  	*in =3D xsc_vzalloc(*inlen);
>  	if (!*in) {
>  		err =3D -ENOMEM;
>  		goto err_umem;
>  	}
>  	xsc_ib_populate_pas(dev, qp->umem, page_shift, (*in)->req.pas, hw_npage=
s, true);
>  	(*in)->req.pa_num =3D cpu_to_be16(hw_npages);
> =20
>  	err =3D ib_copy_to_udata(udata, resp, sizeof(*resp));
>  	if (err) {

[Severity: High]
Does this leak uninitialized stack memory to userspace?

The resp structure is declared on the stack in create_qp_common() without
initialization, passed down to this function, and immediately copied to
userspace before any of its fields are populated.

[ ... ]

>  	sq_size =3D calc_sq_size(dev, init_attr, qp);
>  	if (sq_size < 0) {
>  		err =3D -EINVAL;
>  		ibdev_err(&dev->ib_dev, "err %d\n", err);
>  		return err;
>  	}
> =20
>  	qp->rq.ds_cnt =3D qp->rq.wqe_cnt << (qp->rq.wqe_shift - XSC_BASE_WQE_SH=
IFT);

[Severity: Medium]
Could this evaluate to a negative shift?

If a QP is created without a receive queue, set_rq_size() sets wqe_shift to
0. Since XSC_BASE_WQE_SHIFT is non-zero, this evaluates to a bitwise left
shift by a negative amount, which is undefined behavior.

[ ... ]

>  err_wrid:
>  	kfree(qp->sq.prev_ce_wqe);
>  	kfree(qp->sq.need_flush);
>  	kfree(qp->sq.wr_opcode);
>  	kfree(qp->sq.wqe_head);
>  	kfree(qp->sq.w_list);
>  	kfree(qp->sq.wrid);
>  	kfree(qp->sq.wr_data);
>  	kfree(qp->rq.wrid);
> =20
>  err_buf:
>  	xsc_buf_free(dev->xdev, &qp->buf);
>  	return err;

[Severity: Medium]
Does this error path leak the mailbox *in structure?

The memory is allocated with xsc_vzalloc() earlier in the function but does
not appear to be freed before returning here.

[ ... ]

>  	if (pd->uobject) {
>  		err =3D create_user_qp(dev, pd, qp, udata, &in, &resp, &inlen);
>  		if (err)
>  			ibdev_err(&dev->ib_dev, "failed to create user qp, err =3D %d\n", err=
);
>  	} else {
>  		err =3D create_kernel_qp(dev, init_attr, qp, &in, &inlen);
>  		if (err)
>  			ibdev_err(&dev->ib_dev, "failed to create kernel qp, err =3D %d\n", e=
rr);
>  		else
>  			qp->pa_lkey =3D to_xpd(pd)->pa_lkey;
>  	}
> =20
>  	if (err)
>  		return err;

[Severity: Medium]
If create_user_qp() or create_kernel_qp() fails, does returning err here
directly bypass the err_create label where the mailbox structure is supposed
to be freed?

[ ... ]

>  	if (!pd->uobject && init_attr->srq) {
>  		qp_node =3D kvzalloc_obj(*qp_node, GFP_KERNEL);
>  		if (!qp_node)
>  			goto err_create;

[Severity: High]
If kvzalloc_obj() fails here, err is 0, so the function will jump to
err_create but return success to the caller.

Does this result in the hardware QP remaining active while the software
buffers are freed? The QP might be left dangling in the CQ lists, which can
lead to a use-after-free and a resource leak.

>  		qp_node->ibqp =3D &qp->ibqp;
>  		qp_node->qp_id =3D qp->xqp.qpn;
>  		ibdev_dbg(&dev->ib_dev, "qpn:%u add into srq_qp_list\n", qp_node->qp_i=
d);
>  		list_add_tail(&qp_node->entry, &to_xsrq(init_attr->srq)->xsrq.srq_qp_l=
ist);

[Severity: High]
Is there a race condition here?

The QP node is being added to the SRQ tracking list without acquiring the
xsrq->lock. Concurrent QP creations or destructions on the same SRQ might
corrupt the linked list.

[ ... ]

>  static void destroy_qp_common(struct xsc_ib_dev *dev, struct xsc_ib_qp *=
qp)
>  {
>  	struct xsc_ib_cq *send_cq =3D NULL;
>  	struct xsc_ib_cq *recv_cq =3D NULL;
>  	struct xsc_modify_qp_mbox_in *in;
>  	int err;
> =20
>  	in =3D kzalloc_obj(*in, GFP_KERNEL);
>  	if (!in)
>  		return;

[Severity: High]
Does an early return here abort the cleanup and cause a use-after-free?

If allocation fails, the QP destruction process ends prematurely, meaning t=
he
hardware QP is not destroyed and it remains on the CQ lists. Since the call=
er
returns 0 unconditionally, the RDMA subsystem will free the struct ib_qp,
leaving dangling pointers behind.

> =20
>  	if (qp->xqp.qp_type_internal =3D=3D XSC_QUEUE_TYPE_RAW ||
>  	    qp->xqp.qp_type_internal =3D=3D XSC_QUEUE_TYPE_RAW_TSO ||
>  	    qp->xqp.qp_type_internal =3D=3D XSC_QUEUE_TYPE_RAW_TX ||
>  	    qp->state !=3D IB_QPS_RESET)
>  		if (xsc_core_qp_modify(dev->xdev, to_xsc_state(qp->state),
>  				       XSC_QP_STATE_RST, in, sizeof(*in), &qp->xqp))

[Severity: Medium]
Is sizeof(*in) the correct argument for the sqd_event parameter in
xsc_core_qp_modify()?

Passing a structure size to a parameter intended as an event flag or boolean
might be a type mismatch that corrupts hardware behavior.

[ ... ]

>  static int __xsc_ib_modify_qp(struct ib_qp *ibqp,
>  			      const struct ib_qp_attr *attr, int attr_mask,
>  			      enum ib_qp_state cur_state, enum ib_qp_state new_state,
>  			      const struct xsc_ib_modify_qp *ucmd,
>  			      struct ib_udata *udata)
>  {
>  	struct xsc_ib_dev *dev =3D to_xdev(ibqp->device);
>  	struct xsc_ib_qp *qp =3D to_xqp(ibqp);
>  	struct xsc_ib_cq *send_cq, *recv_cq;
>  	struct xsc_qp_context *context;
>  	struct xsc_modify_qp_mbox_in *in;
>  	struct xsc_qp_path path;

[ ... ]

>  	if (attr_mask & IB_QP_AV) {
>  		err =3D xsc_set_path(dev, &attr->ah_attr, &path,
>  				   attr_mask & IB_QP_PORT ? attr->port_num : qp->port,
>  				   attr_mask, 0, attr, qp);
>  		if (err)
>  			goto out;
> =20
>  		context->src_udp_port =3D path.sport;
>  		context->dscp =3D path.ecn_dscp;
>  		context->hop_limit =3D path.hop_limit;
>  		context->ip_type =3D (path.af_type =3D=3D AF_INET ? 0 : 1);
>  		context->ip_type =3D cpu_to_be16(context->ip_type);
>  		memcpy(context->dip, path.dip, sizeof(context->dip));
>  		memcpy(context->sip, path.sip, sizeof(context->sip));

[Severity: Medium]
Could this copy uninitialized stack memory into the hardware context?

The path structure is declared on the stack and passed to xsc_set_path().
For IPv4, only 4 bytes of sip and dip are populated. Copying the full
IPv6-sized array from path to context might leak uninitialized stack data to
the device firmware.

[ ... ]

>  	if (udata && udata->inlen && attr_mask & IB_QP_STATE && new_state =3D=
=3D IB_QPS_RTR) {
>  		if (!ucmd->profile &&
>  		    xdev->rdma_proto_mode =3D=3D RDMA_PROTO_VEROCE) {
>  			context->swith_qp_type =3D 1;
>  			context->qp_access_flags |=3D QP_ACCESS_MODIFY_QP_TYPE;
>  			context->qp_access_flags =3D cpu_to_be32(context->qp_access_flags);

[Severity: High]
Does this corrupt the endianness of qp_access_flags?

It looks like context->qp_access_flags was already converted to big-endian
earlier via cpu_to_be32() in xsc_set_qp_access_flag(). Applying a bitwise OR
directly to the big-endian variable and then byteswapping it a second time
will corrupt the flag bits on little-endian architectures.

[ ... ]

>  	if (!err && (attr_mask & IB_QP_STATE) && !udata) {
>  		get_cqs(qp->xqp.qp_type, qp->send_cq, qp->recv_cq, &send_cq, &recv_cq);
>  		xsc_ib_lock_cqs(send_cq, recv_cq);
>  		err =3D xsc_ib_err_state_qp(dev, qp, to_xsc_state(cur_state),
>  					  to_xsc_state(new_state));
>  		xsc_ib_unlock_cqs(send_cq, recv_cq);

[Severity: High]
Is there a sleeping allocation happening while holding spinlocks?

xsc_ib_lock_cqs() acquires spinlocks and disables interrupts. Inside
xsc_ib_err_state_qp(), memory is allocated using kzalloc_obj(..., GFP_KERNE=
L),
which can sleep and trigger a panic in an atomic context.

[ ... ]

>  		for (i =3D 0; i < wr->num_sge; ++i) {
>  			if (unlikely(!wr->sg_list[i].length))
>  				continue;
>  			data_seg =3D get_seg_wqe(recv_head, i);
>  			data_seg->in_line =3D 0;
>  			WR_LE_64(data_seg->va, wr->sg_list[i].addr);
>  			WR_LE_32(data_seg->mkey, wr->sg_list[i].lkey);
>  			if (is_qp1(qp->xqp.qp_type))
>  				WR_LE_32(data_seg->seg_len, xdev->caps.rx_pkt_len_max);
>  			else
>  				WR_LE_32(data_seg->seg_len, wr->sg_list[i].length);
>  		}

[Severity: High]
Can the hardware scatter incoming network data into stale memory addresses?

When this loop skips 0-length SGEs or when wr->num_sge is less than the
maximum permitted, it leaves trailing data segments in the Receive WQE
uninitialized. Since the receive queue is a ring buffer, these slots might
contain stale SGE data from previous work requests.

Without a control segment specifying the valid SGE count, the hardware could
process these stale entries and write into memory that has already been fre=
ed
or reallocated.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012114352.2471=
317-1-tianx@yunsilicon.com?part=3D12
