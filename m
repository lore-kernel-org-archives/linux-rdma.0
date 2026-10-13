Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF594F30F8
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 11:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791891974; cv=none; b=ADzhI0cT5X82mxNtVPNNN7gvryXjqZlADM0OgBImBDFPDcmEGC3Urt3AGYCblVWZbuGL+DATK5vrX0X1aHuFpws23lzfJOowr6ZEW8ogaYVgl/UgsDzagSwGQgQa/wxgOWWvrt68NlRXAaJIvsYNE5z28mTc9FpIJqTbyqktLaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791891974; c=relaxed/simple;
	bh=xgH5jSF5M9DZptDb3DFWn+ixUR8rX+ZPDjVLxJ9eRu0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Rzm/pVYmqg4/c9YFwC3McA2LNwjcsWObJyRXyi3Jg1Qb4oKRjzHB6It9IQHUoV8ta+gkOy6eG2aaZVIFB66yk0Px4hfdoiv/0Ds0gnbp0RLvUyyPkMDyjBwaQudZYAHujafLQggwi8QNJt8AO50Rzl1q8WyI2vEbRc37jW7dYTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FFj1wSly; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FFj1wSly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4FF1F0089A;
	Tue, 13 Oct 2026 11:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791891973;
	bh=vIp+45hj61pZutvP3PwVcvAAXqtcn73op9HsOVpcTyI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FFj1wSlyUKXgmKrCUftpjV43MAEyHuwyNt4NPIZlEngnhf3ud4v1U03ibqLXRPmqc
	 d+W3dfscqzc8gEZPD0ZjgldNI83ZKvcvPNes3wWe2S5DhyAnWoeuLH5SxsZc7yZB6X
	 l2HMfl5qjr4Xcw0uvg5j0+00ZE0/Yv+WkXb1HvguPDu8pXBp+meP2orshd0bD25zom
	 vhNuQQvFhZFi14LN9XFMb8VzPMxPy5nGqzFSm9apeef8/LL88H3b2JFxTbpM/TE02j
	 MIQCu+QxfZpRCKpoBC56xCF0sh7DYLaMHSOQfyjDmra3WzXYdims3jHS2A0e28eNy7
	 Zj8fAsHgYzByA==
Message-ID: <sashiko-outbox-169648@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 11/15] yunsilicon: add RDMA CQ/SRQ/AH
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261012114418.2471317-12-tianx@yunsilicon.com>
References: <20261012114352.2471317-1-tianx@yunsilicon.com>
 <20261012114418.2471317-12-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 11:46:12 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 13 potential issue=
(s) to consider:
- [Critical] core: hardware DMA buffer overflow in QP1 (MAD) receive path
- [High] locking: AB-BA deadlock between cq->lock and srq->lock
- [High] mm: sleeping in atomic context due to GFP_KERNEL allocations under=
 spinlocks
- [High] mm: missing kcalloc NULL check in xsc_cache_srq_wr causes immediat=
e panic
- [High] core: dangling tail pointer leads to Use-After-Free list corruptio=
n in SRQ cache
- [High] locking: unprotected list modification on cross-CQ err_state_qp_li=
st
- [High] core: SRQ destruction UAF race with global ID reclamation
- [High] core: skipping zero-length SGEs leaves uninitialized hardware WQE =
gaps
- [High] core: uninitialized cqe_sz variable breaks error CQ cleaning for u=
serspace CQs
- [High] rdma/xsc: memory leak and subsequent NULL dereference in xsc_post_=
cache_wrs error path
- [Medium] net: out-of-bounds read when parsing MAD headers from truncated =
packets
- [Medium] core: max_cqes truncation introduces non-power-of-two mask index=
ing vulnerability
- [Low] core: xsc_ib_query_ah drops cached RoCE destination MAC address
--

commit 362ed58c2fd14cd6742383cf2e788372cccd3288
Author: Xin Tian <tianx@yunsilicon.com>

yunsilicon: add RDMA CQ/SRQ/AH

Add the completion queues, shared receive queues and address handles: the
create/destroy/query/modify verbs and the CQ poll and completion
processing.

The QP receive helper and error-state tracking are included here
because the CQ and SRQ paths reference them.

> diff --git a/drivers/infiniband/hw/xsc/ah.c b/drivers/infiniband/hw/xsc/a=
h.c
> --- /dev/null
> +++ b/drivers/infiniband/hw/xsc/ah.c
[ ... ]
> @@ -112,23 +112,33 @@ int xsc_ib_query_ah(struct ib_ah *ibah, struct rdma=
_ah_attr *ah_attr)
>  {
>  	struct xsc_ib_ah *ah =3D to_xah(ibah);
>  	u32 tmp;
> =20
>  	memset(ah_attr, 0, sizeof(*ah_attr));
>  	ah_attr->type =3D ibah->type;
[ ... ]
>  	rdma_ah_set_static_rate(ah_attr, ah->av.stat_rate_sl >> 4);
>  	if (ah_attr->type =3D=3D RDMA_AH_ATTR_TYPE_ROCE) {
>  		rdma_ah_set_sl(ah_attr, (ah->av.stat_rate_sl >> 1) & 0x7);
>  	} else {

[Severity: Low]
Does this code intentionally omit restoring the dmac field for RoCE
connections? During xsc_ib_create_ah(), the destination MAC address is
saved into ah->av.rmac, but the query path appears to leave it zeroed out
here, which might cause the driver to report a zeroed MAC address.

> diff --git a/drivers/infiniband/hw/xsc/cq.c b/drivers/infiniband/hw/xsc/c=
q.c
> --- /dev/null
> +++ b/drivers/infiniband/hw/xsc/cq.c
[ ... ]
> @@ -201,15 +201,17 @@ static void xsc_handle_rdma_mad_resp_recv(struct xs=
c_ib_cq *cq,
>  	if (eth_type =3D=3D ETH_P_IP) {
>  		pading_sz =3D sizeof(*grh) - sizeof(*ip4h);
>  		memmove((u8 *)(grh + 1) - sizeof(*ip4h), ip4h, sizeof(*ip4h));
>  		memset(grh, 0, pading_sz);
>  	} else {
>  		memmove(grh, ip6h, sizeof(*ip6h));
>  	}
>  	memmove(grh + 1, mad, sizeof(*mad));

[Severity: Medium]
Is it possible for memmove to read out of bounds here if an attacker or
misconfigured node sends a truncated packet? There does not seem to be a
check against the overall packet length (wc->byte_len) before copying
sizeof(*mad) bytes.

[ ... ]
> @@ -375,14 +375,16 @@ int xsc_ib_create_cq(struct ib_cq *ibcq,
>  	int irqn;
>  	int err;
>  	unsigned int eqn;
> =20
>  	entries =3D roundup_pow_of_two(entries);
> =20
>  	ibdev_dbg(&dev->ib_dev, "entries:%d, vector:%d, max_cqes:%d\n", entries=
, vector,
>  		  dev->xdev->caps.max_cqes);
> =20
>  	if (entries > dev->xdev->caps.max_cqes)
>  		entries =3D dev->xdev->caps.max_cqes;

[Severity: Medium]
Could capping entries at max_cqes break the power-of-two invariant
established just above it? If the hardware reports a max_cqes value that
is not a power of two, the polling paths that use bitwise AND masking to
calculate ring buffer indices might experience discontinuous indices and re=
ad
out of bounds.

>  	cq =3D to_xcq(ibcq);
>  	cq->ibcq.cqe =3D entries;
[ ... ]
>  	cq->create_flags =3D attr->flags;
>  	cq->invalid =3D 0;
> =20
>  	if (udata) {
>  		err =3D create_cq_user(dev, udata, NULL, cq, entries,
>  				     &cqb, &cqe_size, &index, &inlen);
>  		if (err)
>  			goto err_create;
>  	} else {
>  		cqe_size =3D is_support_cqe64(dev->xdev) ?
>  			sizeof(struct xsc_cqe64) : sizeof(struct xsc_cqe);
>  		err =3D create_cq_kernel(dev, cq, entries, cqe_size, &cqb, &index, &in=
len);
>  		if (err)
>  			goto err_create;
>  	}
> =20
>  	cq->cqe_size =3D cqe_size;

[Severity: High]
Does the userspace CQ creation path leave cq->xcq.cqe_sz uninitialized?
create_cq_kernel() sets it internally, but create_cq_user() does not appear
to. If it remains 0, the flush-cleanup routine __xsc_ib_cq_clean() might
fail to step through the buffer array correctly when overwriting matching
QP elements.

> diff --git a/drivers/infiniband/hw/xsc/qp.c b/drivers/infiniband/hw/xsc/q=
p.c
> --- /dev/null
> +++ b/drivers/infiniband/hw/xsc/qp.c
[ ... ]
> @@ -100,18 +100,20 @@ int xsc_ib_err_state_qp(struct xsc_ib_dev *dev, str=
uct xsc_ib_qp *qp,
>  	if (cur_state !=3D XSC_QP_STATE_ERR && state =3D=3D XSC_QP_STATE_ERR &&
>  	    !qp->has_trig_cq_comp_handle) {
>  		if (!qp->ibqp.srq && qp->recv_cq) {
>  			err_rq_node =3D kzalloc_obj(*err_rq_node, GFP_KERNEL);

[Severity: High]
Can this allocation trigger a scheduling while atomic panic?
xsc_ib_err_state_qp() is called from xsc_poll_one() during CQ polling,
which holds cq->lock via spin_lock_irqsave. Calling kzalloc_obj with
GFP_KERNEL under a spinlock might sleep.

>  			if (!err_rq_node)
>  				return -ENOMEM;
>  			err_rq_node->qp_id =3D qp->xqp.qpn;
>  			err_rq_node->is_sq =3D false;
>  			recv_xcq =3D to_xcq(qp->recv_cq);
>  			list_add_tail(&err_rq_node->entry, &recv_xcq->err_state_qp_list);

[Severity: High]
Does this introduce unprotected list modifications? Since this is called
synchronously while holding only the lock for the CQ currently being
polled (e.g., the send CQ), modifying the receive CQ's err_state_qp_list
appears to happen locklessly. This might corrupt the double-linked list
if a concurrent polling thread traverses it.

[ ... ]
> @@ -131,10 +131,11 @@ static int xsc_wq_overflow(struct xsc_ib_wq *wq, in=
t nreq, struct xsc_ib_cq *cq)
>  {
>  	unsigned int cur;
> =20
>  	cur =3D wq->head - wq->tail;
>  	if (likely(cur + nreq < wq->max_post))
>  		return 0;
> =20
>  	spin_lock(&cq->lock);

[Severity: High]
Could this lead to a circular locking deadlock between cq->lock and
srq->lock?

Path A acquires cq->lock first, then srq->lock:
xsc_ib_poll_cq() -> acquires cq->lock
   xsc_poll_one()
      xsc_free_one_cache_srq_wr() -> acquires srq->lock

Path B acquires srq->lock first, then cq->lock:
xsc_ib_post_srq_recv() -> acquires srq->lock
   xsc_post_cache_wrs()
      xsc_ib_post_recv()
         xsc_wq_overflow() -> acquires cq->lock

This might trigger a hard kernel deadlock when receive operations coincide
with polling.

[ ... ]
> @@ -186,13 +186,17 @@ int xsc_ib_post_recv(struct ib_qp *ibqp, const stru=
ct ib_recv_wr *wr,
>  		recv_head =3D get_recv_wqe(qp, idx);
> =20
>  		for (i =3D 0; i < wr->num_sge; ++i) {
>  			if (unlikely(!wr->sg_list[i].length))
>  				continue;

[Severity: High]
Does skipping zero-length SGEs here leave uninitialized gaps in the
hardware WQE? By using continue, the data_seg at index i is skipped. If
the hardware descriptor ring contains stale data from previous work
requests, the NIC might execute the stale SGE and cause spurious DMA
mapping faults.

>  			data_seg =3D get_seg_wqe(recv_head, i);
>  			data_seg->in_line =3D 0;
>  			WR_LE_64(data_seg->va, wr->sg_list[i].addr);
>  			WR_LE_32(data_seg->mkey, wr->sg_list[i].lkey);
>  			if (is_qp1(qp->xqp.qp_type))
>  				WR_LE_32(data_seg->seg_len, xdev->caps.rx_pkt_len_max);

[Severity: Critical]
Could instructing the hardware to use rx_pkt_len_max for QP1 packets
cause a DMA buffer overflow? MAD receive buffers allocated by the IB core
are typically only large enough for GRH + MAD (~300 bytes). If an incoming
padded or malformed packet arrives, writing up to the port MTU size might
corrupt remote kernel memory.

>  			else
>  				WR_LE_32(data_seg->seg_len, wr->sg_list[i].length);
>  		}

> diff --git a/drivers/infiniband/hw/xsc/srq.c b/drivers/infiniband/hw/xsc/=
srq.c
> --- /dev/null
> +++ b/drivers/infiniband/hw/xsc/srq.c
[ ... ]
> @@ -51,11 +51,13 @@ void xsc_free_one_cache_srq_wr(struct xsc_ib_srq *srq=
, struct xsc_ib_qp *qp, u64
>  		if (tmp_wr->wr_id =3D=3D wr_id) {
>  			if (prev_wr)
>  				prev_wr->next =3D tmp_wr->next;
>  			else
>  				qp->srq_head_wr =3D tmp_wr->next;
> =20
>  			kfree(tmp_wr->sg_list);
>  			kfree(tmp_wr);
>  			break;
>  		}

[Severity: High]
If the item being freed is the tail of the list (tmp_wr =3D=3D qp->srq_tail=
_wr),
does qp->srq_tail_wr need to be updated? If it is left dangling, a
subsequent call to xsc_post_cache_wrs() with init=3Dfalse might execute
qp->srq_tail_wr->next =3D wr_head, leading to a use-after-free.

[ ... ]
> @@ -279,15 +279,16 @@ int xsc_ib_destroy_srq(struct ib_srq *srq, struct i=
b_udata *udata)
>  {
>  	struct xsc_ib_srq *xsrq =3D to_xsrq(srq);
>  	struct xsc_ib_dev *dev =3D to_xdev(srq->device);
> =20
>  	xsc_core_destroy_srq(dev->xdev, &xsrq->xsrq);
>  	if (xsrq->create_type =3D=3D XSC_SRQ_USER) {
>  		destroy_srq_user(xsrq, NULL);
>  	} else {
>  		xsc_destroy_cache_wr(xsrq);
>  		destroy_srq_kernel(dev, xsrq);
>  	}

[Severity: High]
Is there a race condition between releasing the SRQ ID globally and
clearing its local data? xsc_core_destroy_srq() frees the ID for immediate
reuse. If a concurrent thread creates an SRQ and reuses srqn before
xsc_destroy_cache_wr() executes memset(&cache_wr[srqn], 0, ...), it might
wipe out the newly allocated cache list of the new SRQ.

[ ... ]
> @@ -290,14 +290,17 @@ static int xsc_cache_srq_wr(struct xsc_ib_srq *srq,=
 const struct ib_recv_wr *wr,
>  {
>  	int i, n;
>  	int srqn =3D srq->xsrq.srqn;
>  	struct xsc_srq_cache_wr *cache_wr =3D srq->xsrq.cache_wr;
>  	struct ib_recv_wr *head_wr =3D NULL, *new_wr =3D NULL, *prev_wr =3D NUL=
L;
> =20
>  	for (n =3D 0; wr; wr =3D wr->next, n++) {
>  		new_wr =3D kcalloc(1, sizeof(struct ib_recv_wr), GFP_KERNEL);

[Severity: High]
Can these allocations trigger a scheduling while atomic panic?
xsc_ib_post_srq_recv() acquires srq->lock with spin_lock_irqsave before
calling xsc_cache_srq_wr(), meaning this kcalloc(..., GFP_KERNEL) happens
with interrupts disabled.

>  		if (prev_wr)
>  			prev_wr->next =3D new_wr;
>  		else
>  			head_wr =3D new_wr;
>  		new_wr->wr_id =3D wr->wr_id;
>  		new_wr->sg_list =3D kcalloc(wr->num_sge, sizeof(struct ib_sge), GFP_KE=
RNEL);

[Severity: High]
Are NULL checks missing for the kcalloc() returns? If either allocation
fails, dereferencing new_wr->wr_id or passing new_wr->sg_list to memcpy()
will cause a deterministic NULL pointer dereference.

>  		for (i =3D 0; i < wr->num_sge; i++)
>  			memcpy(&new_wr->sg_list[i], &wr->sg_list[i], sizeof(struct ib_sge));

[ ... ]
> @@ -355,14 +355,15 @@ void xsc_post_cache_wrs(struct xsc_ib_srq *srq, str=
uct xsc_ib_qp *qp, int wr_num
> =20
>  	cache_wr[srqn].head_wr =3D qp->srq_tail_wr->next;
>  	qp->srq_tail_wr->next =3D NULL;
>  	tmp_wr =3D wr_head;
>  	err =3D xsc_ib_post_recv(&qp->ibqp, tmp_wr, &bad_wr);
>  	if (err) {
>  		qp->srq_tail_wr->next =3D cache_wr[srqn].head_wr;
>  		qp->srq_tail_wr =3D NULL;
>  		for (; wr_head && (bad_wr->wr_id !=3D wr_head->wr_id); wr_head =3D wr_=
head->next)
>  			qp->srq_tail_wr =3D wr_head;
> =20
>  		if (!qp->srq_tail_wr) {
>  			cache_wr[srqn].head_wr =3D wr_head;
>  			qp->srq_head_wr =3D NULL;
>  		} else {

[Severity: High]
Does this error path lead to memory leaks and a subsequent NULL pointer
dereference? If xsc_ib_post_recv() fails on the very first element (e.g.,
due to WQ overflow), qp->srq_tail_wr is left as NULL. The code then
executes qp->srq_head_wr =3D NULL, orphaning all previously successfully
posted Work Requests and leaking their memory.

Additionally, because qp->srq_tail_wr is left as NULL, the next
invocation of xsc_post_cache_wrs() with init =3D false will execute:

qp->srq_tail_wr->next =3D wr_head;

This will cause a deterministic NULL pointer dereference.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012114352.2471=
317-1-tianx@yunsilicon.com?part=3D11
