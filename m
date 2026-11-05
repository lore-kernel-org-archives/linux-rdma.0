Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894978;
	b=m4sNisjmchCb6fhIiiBMMyDcixYxWyXX9HrA1d0pSP6ct06mdGeaPl+6b0vQyMTmSxL2
	 NXdWJ7ZuipQ52sBGYt5kE05aesIR0JF1WhkhuG7pBiizYe8CnNb8+xkSzsFijntfXBozX
	 +ZBk8TB+qV4KA3HqIml59LagYOEDV3bVOALANDqEd4kgdKCcY6rfSZcsQqeVhNdtRWisP
	 sZkE/I+bNu/IZFm0WWmm38F1P0Z75pheqsTa31KGjnvfKXHEbnPI5aH3eatvxXqopAGiH
	 y+x+Tj5NOpFEc50R2Uon5MPfRCtL3GtTBDREpYCI4v/GCuv/kErGJL0Ko+1jn6b7oqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894978;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3qsmPFtqWjGxASIjjsEGEUNAvReggKxuHfJ5HcPqdI8=;
	b=m+m11PsMzX0D1jaYEYYhHMTMxxPH2cnqIAwnlULz616Qz3spQKT41jomrOA73aNMxW3y
	 kvvJukdtgJB2bnn0S8w2t2TJGrka0iMAShpxOkNEFwDvBVM/kw5jVjR1VsRJOOhi3rj9P
	 FSSRqypRmde30BChBVU0CWw76VmUIFKZBbBw+zO1zXRgEECyy1e59GnfImmz9TZNIYQpO
	 QpbGnPdyRBcQXhVM3uLExYiK++OobpQNR05xE2QodZ1QZCKoOqCMCPcCfh4VLmH5PCJ1M
	 2zIGgBIFgthSxi6mWHZitCJL21iG+kF8+RMCQzO4QteZgAiFk4vPtH75rMxcXsYOBkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UwXt4cb9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8248606BEA6
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 16:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UwXt4cb9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53EA21F00919;
	Thu,  5 Nov 2026 16:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894977;
	bh=3qsmPFtqWjGxASIjjsEGEUNAvReggKxuHfJ5HcPqdI8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UwXt4cb9k/oyzjKCYoFOGD0hgZgfLPK5be0pSrjhYqHsmoi6j7p7x0Zqwg3ku2QgP
	 u9E+CfZ7jzXjJ4M7oH+ARI0iSKNHqDKGpIkgYxezm2vKYEh1vIRHei0xxlKPhlO9g9
	 PumRU3ObX5yC3Mb8ieSpY6oBjl3tj63TZeoGN878/aWiL1E7g04weg4quQTSBmO5eW
	 q08/3E0hdPlvuCQlk7aZd3NyXXkwq0cVuJvgvG3ID0N+WKO9bDbOyR1oLZ0z+NKdi3
	 jxogKmkAPTP1G9QjgXLqbu3o710cQLFwNidXH3gwqIYfnAS0cSPrqBuuj8uZjMFvXp
	 LfEEr91A7dGBw==
Message-ID: <sashiko-outbox-199434@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 12/15] RDMA/xsc: add RDMA CQ/SRQ/AH
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104155718.37053-13-tianx@yunsilicon.com>
References: <20261104155650.37053-1-tianx@yunsilicon.com>
 <20261104155718.37053-13-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 16:09:36 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 13 potential issue=
(s) to consider:
- [Critical] RDMA/xsc: use-after-free via stale tail_wr in SRQ WR cache man=
agement
- [High] RDMA/xsc: validate attr->cqe, udata, and 64B CQE size in xsc_ib_cr=
eate_cq()
- [High] RDMA/xsc: fix lost-CQE handling and permanent CQ invalidation in x=
sc_poll_one()
- [High] RDMA/xsc: fix races and unlocked cur_qp use in QP error flush hand=
ling
- [High] RDMA/xsc: missing create_user_ah callback in xsc_ib_dev_setting()
- [High] RDMA/xsc: broken error CQE flushing and state tracking in cq.c and=
 qp.c
- [High] RDMA/xsc: missing SRQ WR replenishment, sge validation, and max_wr=
 sync
- [Medium] RDMA/xsc: fix flow_label order, udp_sport endianness, and tclass=
 in create_ib_ah()
- [Medium] RDMA/xsc: fix data_seg->va endianness and DMA sync in xsc_handle=
_rdma_mad_resp_recv()
- [Medium] RDMA/xsc: initialize CQ lists/locks before publishing CQ and gua=
rd comp_handler
- [Medium] RDMA/xsc: lost generated flow_label and endian mismatch in creat=
e_ib_ah()
- [Medium] RDMA/xsc: shift-out-of-bounds in __xsc_ib_cont_pages() from crea=
te_cq_user()
- [Low] RDMA/xsc: fix xsc_vector2eqn() pointer-sign and endianness in xsc_i=
b_create_cq()
--

commit 26a9accc1990ad9da5c91694c9f25f02f7b052ac
Author: Xin Tian <tianx@yunsilicon.com>

RDMA/xsc: add RDMA CQ/SRQ/AH

This commit adds completion queue, shared receive queue, and address handle
verb implementations for the Yunsilicon xsc RDMA driver.

> diff --git a/drivers/infiniband/hw/xsc/ah.c b/drivers/infiniband/hw/xsc/a=
h.c
> new file mode 100644
> index 0000000000000..4d916dbe7dd25
> --- /dev/null
> +++ b/drivers/infiniband/hw/xsc/ah.c
> @@ -0,0 +1,144 @@

[ ... ]

> +static u16 xsc_ah_get_udp_sport(const struct xsc_ib_dev *dev,
> +				struct rdma_ah_attr *ah_attr)
> +{
> +	enum ib_gid_type gid_type =3D ah_attr->grh.sgid_attr->gid_type;
> +	u16 sport =3D 0;
> +	u32 fl =3D 0;
> +
> +	if (gid_type =3D=3D IB_GID_TYPE_ROCE_UDP_ENCAP &&
> +	    (rdma_ah_get_ah_flags(ah_attr) & IB_AH_GRH) &&
> +	    (ah_attr->grh.flow_label & IB_GRH_FLOWLABEL_MASK)) {
> +		fl =3D ah_attr->grh.flow_label;
> +	} else {
> +		/*generate a 20bit flow_label and output to user layer*/
> +		fl =3D xsc_calc_roce_udp_flow_label();
> +		ah_attr->grh.flow_label =3D fl;
> +	}
> +
> +	sport =3D rdma_flow_label_to_udp_sport(fl);
> +	ibdev_dbg(&dev->ib_dev, "fl=3D0x%x,sport=3D0x%x\n", fl, sport);
> +	return sport;
> +}
> +
> +static struct ib_ah *create_ib_ah(struct xsc_ib_dev *dev,
> +				  struct xsc_ib_ah *ah,
> +				  struct rdma_ah_attr *ah_attr)
> +{
> +	enum ib_gid_type gid_type;
> +
> +	if (rdma_ah_get_ah_flags(ah_attr) & IB_AH_GRH) {
> +		const struct ib_global_route *grh =3D rdma_ah_read_grh(ah_attr);
> +
> +		memcpy(ah->av.rgid, &grh->dgid, 16);
> +		ah->av.grh_gid_fl =3D cpu_to_be32(grh->flow_label |
> +						(1 << 30) |
> +						grh->sgid_index << 20);
> +		ah->av.hop_limit =3D grh->hop_limit;
> +		ah->av.tclass =3D grh->traffic_class;
> +	}
> +
> +	ah->av.stat_rate_sl =3D (rdma_ah_get_static_rate(ah_attr) << 4);
> +
> +	if (ah_attr->type =3D=3D RDMA_AH_ATTR_TYPE_ROCE) {
> +		gid_type =3D ah_attr->grh.sgid_attr->gid_type;
> +
> +		memcpy(ah->av.rmac, ah_attr->roce.dmac,
> +		       sizeof(ah_attr->roce.dmac));
> +
> +		ah->av.udp_sport =3D xsc_ah_get_udp_sport(dev, ah_attr);
> +		ah->av.stat_rate_sl |=3D (rdma_ah_get_sl(ah_attr) & 0x7) << 1;
> +		if (gid_type =3D=3D IB_GID_TYPE_ROCE_UDP_ENCAP)
> +#define XSC_ECN_ENABLED BIT(1)
> +			ah->av.tclass |=3D XSC_ECN_ENABLED;

[Severity: Medium]
Does create_ib_ah() lose the generated flow label and store udp_sport with
the wrong byte order?

When IB_AH_GRH is set, create_ib_ah() packs grh->flow_label into
ah->av.grh_gid_fl (without masking with IB_GRH_FLOWLABEL_MASK) before
calling xsc_ah_get_udp_sport(dev, ah_attr). When ah_attr->grh.flow_label is
0, xsc_ah_get_udp_sport() generates a random 20-bit flow label and writes
it to ah_attr->grh.flow_label, but ah->av.grh_gid_fl has already been
populated with 0 and is never updated, so xsc_ib_query_ah() later reports a
flow label of 0.

In addition, struct xsc_av declares udp_sport as __be16:

drivers/net/ethernet/yunsilicon/xsc/common/qp.h:
	union {
		__be16	rlid;
		__be16	udp_sport;
	};

However, xsc_ah_get_udp_sport() returns a host-endian u16 from
rdma_flow_label_to_udp_sport(fl), and create_ib_ah() assigns it directly to
ah->av.udp_sport without cpu_to_be16().

Finally, create_ib_ah() sets XSC_ECN_ENABLED in ah->av.tclass for RoCEv2,
and xsc_ib_query_ah() passes ah->av.tclass directly to rdma_ah_set_grh()
without masking out XSC_ECN_ENABLED, reporting a modified traffic_class to
callers. Should xsc_ah_get_udp_sport() run before packing ah->av.grh_gid_fl,
convert udp_sport with cpu_to_be16(), and avoid leaking XSC_ECN_ENABLED in
xsc_ib_query_ah()?

> diff --git a/drivers/infiniband/hw/xsc/cq.c b/drivers/infiniband/hw/xsc/c=
q.c
> new file mode 100644
> index 0000000000000..36d122f8d46fb
> --- /dev/null
> +++ b/drivers/infiniband/hw/xsc/cq.c
> @@ -0,0 +1,940 @@

[ ... ]

> +static void xsc_handle_rdma_mad_resp_recv(struct xsc_ib_cq *cq,
> +					  struct xsc_ib_qp **cur_qp,
> +					  struct ib_wc *wc,
> +					  struct xsc_cqe *cqe,
> +					  u8 opcode)
> +{
> +	struct xsc_ib_dev *dev =3D to_xdev(cq->ibcq.device);
> +	void *recv;
> +	struct xsc_wqe_data_seg *data_seg;
> +	struct iphdr *ip4h =3D NULL;
> +	struct ipv6hdr *ip6h;
> +	struct udphdr *udph;
> +	struct ib_unpacked_eth *eth;
> +	struct ib_unpacked_vlan *vlan;
> +	struct ib_grh *grh;
> +	struct ib_mad *mad;
> +	struct rxe_bth *bth;
> +	struct rxe_deth *deth;
> +	unsigned int pading_sz =3D 0;
> +	struct xsc_ib_wq *wq;
> +	int idx;
> +	u16 eth_type;
> +	void *l3_start;
> +
> +	wq =3D &(*cur_qp)->rq;
> +	idx =3D wq->tail & (wq->wqe_cnt - 1);
> +
> +	handle_responder(wc, cqe, *cur_qp, opcode);
> +
> +	data_seg =3D get_seg_wqe(get_recv_wqe(*cur_qp, idx), 0);
> +	recv =3D xsc_ib_recv_mad_sg_virt_addr(&dev->ib_dev, wc, data_seg->va);
> +
> +	eth =3D (struct ib_unpacked_eth *)recv;
> +	grh =3D (struct ib_grh *)recv;
> +	if (eth->type =3D=3D htons(ETH_P_8021Q)) {
> +		vlan =3D (struct ib_unpacked_vlan *)(eth + 1);
> +		eth_type =3D ntohs(vlan->type);
> +		l3_start =3D vlan + 1;
> +
> +		wc->vlan_id =3D ntohs(vlan->tag) & 0x0fff;
> +		wc->sl =3D (ntohs(vlan->tag) >> 13) & 0x7;
> +		wc->wc_flags |=3D IB_WC_WITH_VLAN;
> +	} else {
> +		eth_type =3D ntohs(eth->type);
> +		l3_start =3D eth + 1;
> +	}
> +
> +	if (eth_type =3D=3D ETH_P_IP) {
> +		ip4h =3D (struct iphdr *)l3_start;
> +		udph =3D (struct udphdr *)(ip4h + 1);
> +	} else {
> +		ip6h =3D (struct ipv6hdr *)l3_start;
> +		udph =3D (struct udphdr *)(ip6h + 1);
> +	}
> +	bth =3D (struct rxe_bth *)(udph + 1);
> +	deth =3D (struct rxe_deth *)(bth + 1);
> +	mad =3D (struct ib_mad *)(deth + 1);
> +
> +	if (eth_type =3D=3D ETH_P_IP) {
> +		pading_sz =3D sizeof(*grh) - sizeof(*ip4h);
> +		memmove((u8 *)(grh + 1) - sizeof(*ip4h), ip4h, sizeof(*ip4h));
> +		memset(grh, 0, pading_sz);
> +	} else {
> +		memmove(grh, ip6h, sizeof(*ip6h));
> +	}
> +	memmove(grh + 1, mad, sizeof(*mad));

[Severity: Medium]
In xsc_handle_rdma_mad_resp_recv(), data_seg->va is declared as __le64 in
struct xsc_wqe_data_seg and written via WR_LE_64(data_seg->va,
wr->sg_list[i].addr) in xsc_ib_post_recv(), but it is passed directly to
xsc_ib_recv_mad_sg_virt_addr() (and in commit c77226a0e2a3 to
xsc_ib_mad_sg_virt_addr()) without le64_to_cpu(). On big-endian systems,
won't this translate a byte-swapped DMA address and corrupt memory in
memmove() and memset()?

Also, the IB MAD layer maps the receive buffer with
ib_dma_map_single(..., DMA_FROM_DEVICE) when posting the receive WR and
only unmaps it in ib_mad_recv_done() after poll_cq returns. Is DMA
synchronization via dma_sync_single_for_cpu() and
dma_sync_single_for_device() needed around the in-place header rewrite here?

[ ... ]

> +static int xsc_poll_one(struct xsc_ib_cq *cq,
> +			struct xsc_ib_qp **cur_qp,
> +			struct ib_wc *wc, bool *trigger)
> +{
> +	struct xsc_ib_dev *dev =3D to_xdev(cq->ibcq.device);
> +	struct xsc_core_qp *xqp;
> +	struct xsc_ib_wq *wq;
> +	u8 opcode;
> +	u32 qpn;
> +	int idx;
> +	int ret;
> +	struct xsc_cqe *cqe;
> +	u32 *p =3D NULL;
> +	struct xsc_ib_srq *xsrq;
> +
> +	*trigger =3D false;
> +	cqe =3D get_sw_cqe(cq, cq->xcq.cons_index);
> +	if (!cqe)
> +		return -EAGAIN;
> +
> +	++cq->xcq.cons_index;

[ ... ]

> +	switch (opcode) {
> +	case XSC_OPCODE_RDMA_REQ_SEND_IMMDT:
> +	case XSC_OPCODE_RDMA_REQ_WRITE_IMMDT:
> +		wc->wc_flags |=3D IB_WC_WITH_IMM;
> +		fallthrough;
> +	case XSC_OPCODE_RDMA_REQ_SEND:
> +	case XSC_OPCODE_RDMA_REQ_WRITE:
> +	case XSC_OPCODE_RDMA_REQ_READ:
> +	case XSC_OPCODE_RDMA_MAD_REQ_SEND:
> +		wq =3D &(*cur_qp)->sq;
> +		idx =3D xsc_get_cqe_wqe_id(dev->xdev, cqe) >> (wq->wqe_shift - XSC_BAS=
E_WQE_SHIFT);
> +		idx &=3D (wq->wqe_cnt - 1);
> +		if (wq->prev_ce_wqe[idx] !=3D wq->last_comp_ce_wqe) {
> +			xsc_generate_lost_cqe(dev, wq, qpn, idx, wc);
> +			cq->invalid =3D 1;
> +			break;
> +		}

[ ... ]

> +	case XSC_OPCODE_RDMA_REQ_ERROR:
> +		wq =3D &(*cur_qp)->sq;
> +		idx =3D xsc_get_cqe_wqe_id(dev->xdev, cqe) >> (wq->wqe_shift - XSC_BAS=
E_WQE_SHIFT);
> +		idx &=3D (wq->wqe_cnt - 1);
> +
> +		if (!wq->need_flush[idx]) {
> +			unsigned int i;
> +			unsigned int tmp;
> +			unsigned int prev =3D -1;
> +
> +			for (i =3D wq->tail; i !=3D wq->head; i++) {
> +				tmp =3D i & (wq->wqe_cnt - 1);
> +				if (tmp =3D=3D idx)
> +					break;
> +				if (wq->need_flush[tmp])
> +					prev =3D tmp;
> +			}
> +
> +			if (prev !=3D -1) {
> +				if (wq->prev_ce_wqe[prev] !=3D wq->last_comp_ce_wqe) {
> +					xsc_generate_lost_cqe(dev, wq, qpn, prev, wc);
> +					cq->invalid =3D 1;
> +					break;
> +				}
> +			}
> +		} else {
> +			if (wq->prev_ce_wqe[idx] !=3D wq->last_comp_ce_wqe) {
> +				xsc_generate_lost_cqe(dev, wq, qpn, idx, wc);
> +				cq->invalid =3D 1;
> +				break;
> +			}
> +		}

[Severity: High]
How is a CQ supposed to recover after xsc_poll_one() detects a lost CQE?

At the start of xsc_poll_one(), ++cq->xcq.cons_index consumes the hardware
CQE for WQE idx. When wq->prev_ce_wqe[idx] !=3D wq->last_comp_ce_wqe,
xsc_generate_lost_cqe() synthesizes an IB_WC_GENERAL_ERR completion for the
earlier lost_cqe_idx, dropping the already-consumed hardware CQE for idx.

Those paths also set cq->invalid =3D 1, which is never cleared anywhere in
the driver, and they do not call xsc_ib_err_state_qp() to place the QP onto
cq->err_state_qp_list. On every subsequent call to xsc_ib_poll_cq(),
cq->invalid causes the poll loop to immediately break with err =3D -EINVAL,
permanently blocking all completions on this CQ (even for other QPs sharing
the CQ) and leaving the QP's remaining WQEs unflushed.

Furthermore, in the XSC_OPCODE_RDMA_REQ_ERROR branch when
!wq->need_flush[idx] (an unsignaled WQE completed with error), the loop
finds the preceding uncompleted signaled WQE prev (where
wq->need_flush[prev] is still set). Because prev itself is an uncompleted
signaled WQE prior to idx, if only prev was lost then
wq->prev_ce_wqe[prev] =3D=3D wq->last_comp_ce_wqe; checking
wq->prev_ce_wqe[prev] !=3D wq->last_comp_ce_wqe misses the case where prev
itself is the lost WQE (and xsc_generate_lost_cqe() starts at
wq->prev_ce_wqe[prev] instead of prev).

[ ... ]

> +static inline int xsc_generate_flush_err_cqe(struct ib_cq *ibcq,
> +					     int ne, int *npolled, struct ib_wc *wc)
> +{
> +	u32 qp_id =3D 0;
> +	int flush_wqe_cnt =3D 0;
> +	int sw_npolled =3D 0;
> +	u32 idx =3D 0;
> +	struct xsc_err_state_qp_node *err_qp_node;
> +	struct xsc_core_qp *xqp;
> +	struct xsc_ib_cq *cq =3D to_xcq(ibcq);
> +	struct xsc_ib_wq *wq;
> +	struct xsc_ib_dev *dev =3D to_xdev(cq->ibcq.device);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&cq->err_state_qp_lock, flags);
> +	list_for_each_entry(err_qp_node, &cq->err_state_qp_list, entry) {
> +		if (!err_qp_node)
> +			break;
> +
> +		sw_npolled =3D 0;
> +		qp_id =3D err_qp_node->qp_id;
> +		xqp =3D __xsc_qp_lookup(dev->xdev, qp_id);
> +		if (unlikely(!xqp)) {
> +			ibdev_warn(&dev->ib_dev, "CQE@CQ %d for unknown QPN %d\n",
> +				   cq->xcq.cqn, qp_id);
> +			continue;
> +		}
> +		wq =3D err_qp_node->is_sq ? &(core_to_xqp(xqp)->sq) : &(core_to_xqp(xq=
p)->rq);
> +		flush_wqe_cnt =3D atomic_read(&wq->flush_wqe_cnt);
> +		ibdev_dbg(&dev->ib_dev, "is_sq %d, flush_wq_cnt %d, ne %d, npolled %d,=
 qp_id %d, cqn %d\n",
> +			  err_qp_node->is_sq, flush_wqe_cnt, ne, *npolled, qp_id, cq->xcq.cqn=
);
> +
> +		while (wq->tail !=3D wq->head) {
> +			idx =3D wq->tail & (wq->wqe_cnt - 1);
> +			if (err_qp_node->is_sq && !wq->need_flush[idx]) {
> +				wq->tail++;
> +				continue;
> +			} else {
> +				gen_flush_err_cqe(err_qp_node, &(core_to_xqp(xqp)->ibqp), wq,
> +						  idx, wc + *npolled + sw_npolled);
> +				++sw_npolled;
> +			}
> +
> +			if (sw_npolled =3D=3D ne - *npolled)
> +				break;
> +		}
> +		*npolled +=3D sw_npolled;
> +		if (*npolled =3D=3D ne)
> +			break;
> +	}
> +	spin_unlock_irqrestore(&cq->err_state_qp_lock, flags);
> +
> +	return 0;
> +}
> +
> +int xsc_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
> +{
> +	struct xsc_ib_cq *cq =3D to_xcq(ibcq);
> +	struct xsc_core_cq *xcq =3D &cq->xcq;
> +	struct xsc_ib_qp *cur_qp =3D NULL;
> +	bool trigger =3D false;
> +	int npolled =3D 0;
> +	int err =3D 0;
> +	unsigned long flags;
> +	u32 next_cid;
> +
> +	spin_lock_irqsave(&cq->lock, flags);
> +	next_cid =3D xcq->cons_index;
> +
> +	for (npolled =3D 0; npolled < num_entries; npolled++) {
> +		if (cq->invalid) {
> +			err =3D -EINVAL;
> +			break;
> +		}
> +		err =3D xsc_poll_one(cq, &cur_qp, wc + npolled, &trigger);
> +		if (err)
> +			break;
> +		if (trigger) {
> +			npolled++;
> +			break;
> +		}
> +	}
> +
> +	if (err) {
> +		if (npolled < num_entries && !(list_empty(&cq->err_state_qp_list)))
> +			xsc_generate_flush_err_cqe(ibcq, num_entries, &npolled, wc);
> +	}
> +
> +	if (next_cid !=3D xcq->cons_index)
> +		xsc_update_cq_ci(xcq->dev, xcq->cqn, xcq->cons_index);
> +
> +	spin_unlock_irqrestore(&cq->lock, flags);
> +
> +	if (trigger)
> +		xsc_ib_trigger_cq_comp_handler(cur_qp->ibqp.send_cq,
> +					       cur_qp->ibqp.recv_cq);
> +
> +	return npolled;
> +}

[Severity: High]
Can xsc_ib_poll_cq() dereference cur_qp after it has been freed, or race on
the WQ state during error flushing?

1. In xsc_poll_one(), cur_qp is looked up via __xsc_qp_lookup() without
taking a reference count, relying on cq->lock to serialize against QP
destruction. However, xsc_ib_poll_cq() drops cq->lock before dereferencing
cur_qp->ibqp.send_cq and cur_qp->ibqp.recv_cq in the if (trigger) branch,
so a concurrent xsc_ib_destroy_qp() can free cur_qp right after cq->lock is
released.

2. In xsc_ib_poll_cq(), list_empty(&cq->err_state_qp_list) is checked
without holding cq->err_state_qp_lock, and xsc_generate_flush_err_cqe()
reads and updates wq->head, wq->tail, wq->wrid[idx], wq->wr_opcode[idx], and
wq->need_flush[idx] without holding wq->lock (qp->rq.lock or qp->sq.lock),
racing with concurrent xsc_ib_post_recv() or xsc_ib_post_send().

> +static int xsc_cqe_is_empty(struct xsc_ib_cq *cq)
> +{
> +	struct xsc_cqe *cqe =3D get_sw_cqe(cq, cq->xcq.cons_index);
> +
> +	if (cq->invalid)
> +		return 1;
> +
> +	if (!cqe)
> +		return 1;
> +
> +	return 0;
> +}

[Severity: High]
Won't breaking out of xsc_ib_poll_cq() on trigger while xsc_cqe_is_empty()
ignores cq->err_state_qp_list stall software flush completions on
IB_POLL_SOFTIRQ CQs?

When xsc_poll_one() processes XSC_OPCODE_RDMA_REQ_ERROR or
XSC_OPCODE_RDMA_RSP_ERROR, it calls xsc_ib_err_state_qp(), which adds the
QP to cq->err_state_qp_list and sets *trigger =3D true, while xsc_poll_one()
returns 0. In xsc_ib_poll_cq(), if (trigger) increments npolled and breaks
out of the loop with err =3D=3D 0, skipping xsc_generate_flush_err_cqe() (w=
hich
only runs when err !=3D 0) and returning a partial count npolled < num_entr=
ies.

For an IB_POLL_SOFTIRQ CQ polled from ib_poll_handler() -> __ib_process_cq(=
):
1. Returning npolled < IB_POLL_BATCH stops __ib_process_cq() immediately.
2. xsc_ib_trigger_cq_comp_handler() calls ib_cq_completion_softirq() ->
   irq_poll_sched(&cq->iop) before irq_poll_complete(&cq->iop) has run,
   which is a no-op because IRQ_POLL_F_SCHED is still set.
3. ib_poll_handler() then calls irq_poll_complete(&cq->iop) and
   ib_req_notify_cq(cq, IB_POLL_FLAGS) -> xsc_ib_arm_cq().
4. Because xsc_cqe_is_empty() only checks get_sw_cqe() and ignores pending
   entries in cq->err_state_qp_list, xsc_ib_arm_cq() returns 0 and cq->iop
   is never rescheduled, stranding all remaining WRs in
   cq->err_state_qp_list and hanging callers such as ib_drain_qp().

[ ... ]

> +static int create_cq_user(struct xsc_ib_dev *dev, struct ib_udata *udata,
> +			  struct ib_ucontext *context, struct xsc_ib_cq *cq,
> +			  int entries, struct xsc_create_cq_ex_mbox_in **cqb,
> +			  int *cqe_size, int *index, int *inlen)
> +{
> +	struct xsc_ib_create_cq ucmd;
> +	int page_shift;
> +	int npages;
> +	int ncont;
> +	int err;
> +	int log_cq_sz;
> +	int hw_npages;
> +	struct ib_umem_dmabuf *umem_dmabuf;
> +
> +	if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd)))
> +		return -EFAULT;
> +
> +	if (ucmd.cqe_size !=3D sizeof(struct xsc_cqe))
> +		return -EINVAL;
> +
> +	*cqe_size =3D ucmd.cqe_size;
> +
> +	if (ucmd.dmabuf_fd !=3D -1) {
> +		size_t cq_ring_sz =3D (size_t)entries * ucmd.cqe_size;
> +
> +		if (ucmd.dmabuf_sz < cq_ring_sz)
> +			return -EINVAL;
> +
> +		umem_dmabuf =3D ib_umem_dmabuf_get_pinned(&dev->ib_dev, 0, ucmd.dmabuf=
_sz,
> +							ucmd.dmabuf_fd, IB_ACCESS_LOCAL_WRITE);
> +
> +		if (IS_ERR(umem_dmabuf)) {
> +			ibdev_warn(&dev->ib_dev, "umem_dmabuf get failed by fd %d (%ld)\n",
> +				   ucmd.dmabuf_fd, PTR_ERR(umem_dmabuf));
> +			return -ENOMEM;
> +		}
> +
> +		cq->buf.umem =3D &umem_dmabuf->umem;
> +		ibdev_dbg(&dev->ib_dev, "get umem_dmabuf success by fd %d, umem_dmabuf=
_addr %p\n",
> +			  ucmd.dmabuf_fd, umem_dmabuf);
> +	} else {
> +		cq->buf.umem =3D cq_umem_get(dev, udata, context, entries, &ucmd);
> +	}
> +
> +	if (IS_ERR(cq->buf.umem)) {
> +		err =3D PTR_ERR(cq->buf.umem);
> +		return err;
> +	}
> +
> +	xsc_ib_cont_pages(cq->buf.umem, ucmd.buf_addr, &npages, &page_shift,
> +			  &ncont);

[Severity: Medium]
Can calling xsc_ib_cont_pages() with ucmd.buf_addr trigger a 64-bit shift
out of bounds in __xsc_ib_cont_pages()?

When creating a dmabuf-backed user CQ (or any user CQ where ucmd.buf_addr <
PAGE_SIZE), ucmd.buf_addr is 0. xsc_ib_cont_pages() calls
__xsc_ib_cont_pages() with max_page_shift =3D 0:

drivers/infiniband/hw/xsc/mem.c:__xsc_ib_cont_pages() {
	addr =3D addr >> page_shift;
	tmp =3D (unsigned long)addr;
	m =3D find_first_bit(&tmp, BITS_PER_LONG);
	if (max_page_shift)
		m =3D min_t(unsigned long, max_page_shift - page_shift, m);
	for_each_sgtable_dma_sg(&umem->sgt_append.sgt, sg, entry) {
		len =3D sg_dma_len(sg) >> page_shift;
		pfn =3D sg_dma_address(sg) >> page_shift;
		if (base + p !=3D pfn) {
			tmp =3D (unsigned long)(pfn | p);
			if (!IS_ALIGNED(tmp, 1UL << m))
				m =3D find_first_bit(&tmp, BITS_PER_LONG);
}

When addr >> page_shift is 0, find_first_bit(&tmp, BITS_PER_LONG) returns
BITS_PER_LONG (64 on 64-bit platforms). Because max_page_shift is 0, m is
not clamped, and on the first scatterlist entry (where base is ~0ULL),
!IS_ALIGNED(tmp, 1UL << m) evaluates 1UL << 64.

[ ... ]

> +int xsc_ib_create_cq(struct ib_cq *ibcq,
> +		     const struct ib_cq_init_attr *attr,
> +		     struct uverbs_attr_bundle *attrs)
> +{
> +	struct ib_device *ibdev =3D ibcq->device;
> +	struct ib_udata *udata =3D attrs ? &attrs->driver_udata : NULL;
> +	int entries =3D attr->cqe;
> +	int vector =3D attr->comp_vector;
> +	struct xsc_create_cq_ex_mbox_in *cqb =3D NULL;
> +	struct xsc_ib_dev *dev =3D to_xdev(ibdev);
> +	struct xsc_ib_cq *cq;
> +	int index;
> +	int inlen =3D 0;
> +	int cqe_size;
> +	int irqn;
> +	int err;
> +	unsigned int eqn;
> +
> +	entries =3D roundup_pow_of_two(entries);
> +
> +	ibdev_dbg(&dev->ib_dev, "entries:%d, vector:%d, max_cqes:%d\n", entries=
, vector,
> +		  dev->xdev->caps.max_cqes);
> +
> +	if (entries > dev->xdev->caps.max_cqes)
> +		entries =3D dev->xdev->caps.max_cqes;
> +	cq =3D to_xcq(ibcq);
> +	cq->ibcq.cqe =3D entries;
> +	mutex_init(&cq->resize_mutex);
> +	spin_lock_init(&cq->lock);
> +	cq->resize_buf =3D NULL;
> +	cq->resize_umem =3D NULL;
> +	cq->create_flags =3D attr->flags;
> +	cq->invalid =3D 0;
> +
> +	if (udata) {
> +		err =3D create_cq_user(dev, udata, NULL, cq, entries,
> +				     &cqb, &cqe_size, &index, &inlen);
> +		if (err)
> +			goto err_create;
> +	} else {
> +		cqe_size =3D is_support_cqe64(dev->xdev) ?
> +			sizeof(struct xsc_cqe64) : sizeof(struct xsc_cqe);
> +		err =3D create_cq_kernel(dev, cq, entries, cqe_size, &cqb, &index, &in=
len);
> +		if (err)
> +			goto err_create;
> +	}

[Severity: High]
Does xsc_ib_create_cq() properly validate attr->cqe, udata lengths, and
64-byte CQE sizes for user CQs?

1. attr->cqe (an unsigned int from userspace) is assigned to signed int
entries and passed to roundup_pow_of_two(entries) before checking
dev->xdev->caps.max_cqes. If attr->cqe is in [0x40000001, 0x7fffffff],
roundup_pow_of_two(entries) returns 0x80000000UL, overflowing signed int
entries to INT_MIN; if attr->cqe >=3D 0x80000000, entries is negative and
sign-extends in roundup_pow_of_two(), causing a 1UL << 64 shift UB. Both
bypass the entries > dev->xdev->caps.max_cqes check. Even when entries >
dev->xdev->caps.max_cqes without overflowing, silently clamping entries to
dev->xdev->caps.max_cqes instead of returning -EINVAL creates a hardware CQ
smaller than the ring buffer allocated by userspace.

2. On hardware where is_support_cqe64(dev->xdev) is true,
xsc_ib_alloc_ucontext() advertises XSC_HW_FEATURE_FLAG_SUPPORT_CQE64 to
userspace, and xsc_ib_create_cq() uses sizeof(struct xsc_cqe64) (64 bytes)
for kernel CQs. However, create_cq_user() checks:

	if (ucmd.cqe_size !=3D sizeof(struct xsc_cqe))
		return -EINVAL;

which rejects 64-byte CQEs from userspace (or maps only half the required
pages if userspace passes 32 on 64-byte CQE hardware). In addition,
create_cq_user() never initializes cq->xcq.cqe_sz, unlike
create_cq_kernel().

3. Neither create_cq_user() nor xsc_ib_create_cq() checks udata->inlen or
udata->outlen before calling ib_copy_from_udata() and ib_copy_to_udata(),
and unsupported bits in attr->flags are not rejected.

> +	cq->cqe_size =3D cqe_size;
> +	cqb->ctx_ex.ctx.log_cq_sz =3D ilog2(entries);
> +	cqb->ctx_ex.ctx.glb_func_id =3D cpu_to_be16(dev->xdev->glb_func_id);
> +
> +	err =3D xsc_vector2eqn(dev->xdev, vector, &eqn, &irqn);
> +	if (err)
> +		goto err_cqb;
> +
> +	cqb->ctx_ex.ctx.eqn =3D eqn;
> +	cqb->ctx_ex.ctx.eqn =3D cpu_to_be16(cqb->ctx_ex.ctx.eqn);

[Severity: Low]
In drivers/net/ethernet/yunsilicon/xsc/common/driver.h, xsc_vector2eqn() is
declared as:

int xsc_vector2eqn(struct xsc_core_device *xdev, int vector, int *eqn,
		   unsigned int *irqn);

In xsc_ib_create_cq(), eqn is declared as unsigned int and irqn as int,
which triggers -Wpointer-sign warnings on both arguments when calling
xsc_vector2eqn(dev->xdev, vector, &eqn, &irqn).

Also, cqb->ctx_ex.ctx.eqn is __be16; assigning host-endian eqn to it before
calling cpu_to_be16(cqb->ctx_ex.ctx.eqn) triggers sparse endianness
warnings. Should this be cqb->ctx_ex.ctx.eqn =3D cpu_to_be16(eqn) with eqn
declared as int and irqn as unsigned int?

> +	cqb->ctx_ex.page_shift =3D XSC_PAGE_SHIFT_4K;
> +	if (cq->create_flags & IB_UVERBS_CQ_FLAGS_IGNORE_OVERRUN)
> +		cqb->ctx_ex.overrun_ignore =3D 1;
> +
> +	/* the cq becomes visible to the event handlers once
> +	 * xsc_core_create_cq() inserts it into the tree, so the
> +	 * callbacks must be in place before that
> +	 */
> +	cq->xcq.comp  =3D xsc_ib_cq_comp;
> +	cq->xcq.event =3D xsc_ib_cq_event;
> +
> +	err =3D xsc_core_create_cq(dev->xdev, &cq->xcq, cqb, inlen);
> +	if (err)
> +		goto err_cqb;
> +
> +	ibdev_dbg(&dev->ib_dev, "succeeded to create cqn %d, vector=3D%d, cq_sz=
=3D%d, eqn=3D%d\n",
> +		  cq->xcq.cqn, vector, entries, eqn);
> +	cq->xcq.irqn =3D irqn;
> +
> +	if (udata) {
> +		if (ib_copy_to_udata(udata, &cq->xcq.cqn, sizeof(__u32))) {
> +			err =3D -EFAULT;
> +			goto err_cmd;
> +		}
> +	}
> +
> +	INIT_LIST_HEAD(&cq->send_qp_list);
> +	INIT_LIST_HEAD(&cq->recv_qp_list);
> +	INIT_LIST_HEAD(&cq->err_state_qp_list);
> +	spin_lock_init(&cq->err_state_qp_lock);

[Severity: Medium]
Should send_qp_list, recv_qp_list, err_state_qp_list, and err_state_qp_lock
be initialized before calling xsc_core_create_cq(), and should
xsc_ib_cq_comp() guard against a NULL comp_handler?

xsc_core_create_cq() inserts &cq->xcq into xdev->dev_res->cq_table.tree and
immediately arms the CQ in hardware via xsc_arm_cq(xdev, cq->cqn, 0, 0). At
that point, the CQ is visible to EQ interrupts (and for kernel CQs created
via __ib_alloc_cq(), ibcq->comp_handler is not set until after
ops.create_cq() returns, while xsc_ib_cq_comp() calls ibcq->comp_handler
unconditionally). Initializing the lists and err_state_qp_lock after
xsc_core_create_cq() and after the ib_copy_to_udata() error path leaves
them uninitialized while the CQ is already live.

> diff --git a/drivers/infiniband/hw/xsc/main.c b/drivers/infiniband/hw/xsc=
/main.c
> index a212a5888b214..c3f1046158c4b 100644
> --- a/drivers/infiniband/hw/xsc/main.c
> +++ b/drivers/infiniband/hw/xsc/main.c
> @@ -511,9 +511,16 @@ static void xsc_ib_dev_setting(struct xsc_ib_dev *de=
v)
> =20
>  	dev->ib_dev.ops.alloc_pd		=3D xsc_ib_alloc_pd;
>  	dev->ib_dev.ops.dealloc_pd		=3D xsc_ib_dealloc_pd;
> +	dev->ib_dev.ops.create_ah		=3D xsc_ib_create_ah;
> +	dev->ib_dev.ops.query_ah		=3D xsc_ib_query_ah;
> +	dev->ib_dev.ops.destroy_ah		=3D xsc_ib_destroy_ah;

[Severity: High]
Should xsc_ib_dev_setting() also wire dev->ib_dev.ops.create_user_ah =3D
xsc_ib_create_ah?

In drivers/infiniband/core/uverbs_cmd.c, UVERBS_OBJECT_AH requires
UAPI_DEF_OBJ_NEEDS_FN(create_user_ah), and _rdma_create_ah() in
drivers/infiniband/core/verbs.c calls device->ops.create_user_ah(ah,
&init_attr, udata) when udata is non-NULL, while calling
device->ops.create_ah(ah, &init_attr, NULL) only for kernel callers. Without
create_user_ah set, userspace cannot create AHs via uverbs, and the udata
response handling in xsc_ib_create_ah() is unreachable.

> diff --git a/drivers/infiniband/hw/xsc/qp.c b/drivers/infiniband/hw/xsc/q=
p.c
> new file mode 100644
> index 0000000000000..a41d880cf03d9
> --- /dev/null
> +++ b/drivers/infiniband/hw/xsc/qp.c
> @@ -0,0 +1,257 @@

[ ... ]

> +static int is_qp1(enum ib_qp_type qp_type)
> +{
> +	return qp_type =3D=3D IB_QPT_GSI;
> +}

[Severity: Low]
At this commit, is_qp1() has no callers in drivers/infiniband/hw/xsc/qp.c
(callers are added in the next commit in the series, f535ae7002b2
("RDMA/xsc: add QP verbs")), which triggers a -Wunused-function warning
during bisection when building at this commit. Could is_qp1() be moved to
the commit that introduces its callers?

[ ... ]

> +int xsc_ib_err_state_qp(struct xsc_ib_dev *dev, struct xsc_ib_qp *qp,
> +			enum xsc_qp_state cur_state, enum xsc_qp_state state,
> +			bool *triggered)
> +{
> +	struct xsc_err_state_qp_node *tmp =3D NULL, *err_rq_node =3D NULL, *err=
_sq_node =3D NULL;
> +	struct xsc_ib_cq *send_xcq, *recv_xcq;
> +	unsigned long flags;
> +
> +	*triggered =3D false;
> +	ibdev_dbg(&dev->ib_dev, "modify qp: qpid %d, cur_qp_state %d, qp_state =
%d\n",
> +		  qp->xqp.qpn, cur_state, state);
> +	if (cur_state =3D=3D XSC_QP_STATE_ERR && state !=3D XSC_QP_STATE_ERR) {
> +		if (!qp->ibqp.srq && qp->recv_cq) {
> +			recv_xcq =3D to_xcq(qp->recv_cq);
> +			spin_lock_irqsave(&recv_xcq->err_state_qp_lock, flags);
> +			list_for_each_entry_safe(err_rq_node, tmp,
> +						 &recv_xcq->err_state_qp_list, entry) {
> +				if (err_rq_node->qp_id =3D=3D qp->xqp.qpn && !err_rq_node->is_sq) {
> +					list_del(&err_rq_node->entry);
> +					kfree(err_rq_node);
> +				}
> +			}
> +			spin_unlock_irqrestore(&recv_xcq->err_state_qp_lock, flags);
> +		}
> +
> +		if (qp->send_cq) {
> +			send_xcq =3D to_xcq(qp->send_cq);
> +			spin_lock_irqsave(&send_xcq->err_state_qp_lock, flags);
> +			list_for_each_entry_safe(err_sq_node, tmp,
> +						 &send_xcq->err_state_qp_list, entry) {
> +				if (err_sq_node->qp_id =3D=3D qp->xqp.qpn && err_sq_node->is_sq) {
> +					list_del(&err_sq_node->entry);
> +					kfree(err_sq_node);
> +				}
> +			}
> +			spin_unlock_irqrestore(&send_xcq->err_state_qp_lock, flags);
> +		}
> +		return 0;
> +	}
> +
> +	if (cur_state !=3D XSC_QP_STATE_ERR && state =3D=3D XSC_QP_STATE_ERR &&
> +	    !qp->has_trig_cq_comp_handle) {
> +		if (!qp->ibqp.srq && qp->recv_cq) {
> +			err_rq_node =3D kzalloc_obj(*err_rq_node, GFP_ATOMIC);
> +			if (!err_rq_node)
> +				return -ENOMEM;
> +			err_rq_node->qp_id =3D qp->xqp.qpn;
> +			err_rq_node->is_sq =3D false;
> +			recv_xcq =3D to_xcq(qp->recv_cq);
> +			spin_lock_irqsave(&recv_xcq->err_state_qp_lock, flags);
> +			list_add_tail(&err_rq_node->entry, &recv_xcq->err_state_qp_list);
> +			spin_unlock_irqrestore(&recv_xcq->err_state_qp_lock, flags);
> +		}
> +
> +		if (qp->send_cq) {
> +			err_sq_node =3D kzalloc_obj(*err_sq_node, GFP_ATOMIC);
> +			if (!err_sq_node) {
> +				if (err_rq_node) {
> +					spin_lock_irqsave(&recv_xcq->err_state_qp_lock, flags);
> +					list_del(&err_rq_node->entry);
> +					spin_unlock_irqrestore(&recv_xcq->err_state_qp_lock, flags);
> +					kfree(err_rq_node);
> +				}
> +				return -ENOMEM;
> +			}
> +			err_sq_node->qp_id =3D qp->xqp.qpn;
> +			err_sq_node->is_sq =3D true;
> +			send_xcq =3D to_xcq(qp->send_cq);
> +			spin_lock_irqsave(&send_xcq->err_state_qp_lock, flags);
> +			list_add_tail(&err_sq_node->entry, &send_xcq->err_state_qp_list);
> +			spin_unlock_irqrestore(&send_xcq->err_state_qp_lock, flags);
> +		}
> +
> +		qp->has_trig_cq_comp_handle =3D true;
> +		*triggered =3D true;
> +	}
> +	return 0;
> +}

[Severity: High]
Can xsc_ib_err_state_qp() leave stale or duplicate xsc_err_state_qp_node
entries on cq->err_state_qp_list?

1. When xsc_poll_one() calls xsc_ib_err_state_qp(dev, *cur_qp,
(*cur_qp)->state, XSC_QP_STATE_ERR, trigger), (*cur_qp)->state is an enum
ib_qp_state (not converted to enum xsc_qp_state), and (*cur_qp)->state is
not updated to reflect the error state. When the QP is later modified out
of error (e.g. to RESET), cur_state =3D=3D XSC_QP_STATE_ERR is false, so the
err_rq_node and err_sq_node entries are never removed from
err_state_qp_list. Moreover, the removal branch does not reset
qp->has_trig_cq_comp_handle =3D false.

2. qp->has_trig_cq_comp_handle is tested and set without holding a per-QP
lock. If a QP has distinct send_cq and recv_cq that are polled concurrently
on two CPUs when both queues encounter an error CQE, both CPUs can see
!qp->has_trig_cq_comp_handle and insert duplicate err_rq_node and
err_sq_node entries onto the CQs' err_state_qp_list.

> diff --git a/drivers/infiniband/hw/xsc/srq.c b/drivers/infiniband/hw/xsc/=
srq.c
> new file mode 100644
> index 0000000000000..b791fc97f6861
> --- /dev/null
> +++ b/drivers/infiniband/hw/xsc/srq.c
> @@ -0,0 +1,462 @@

[ ... ]

> +void xsc_restore_cache_srq_wrs(struct xsc_ib_srq *srq, struct xsc_ib_qp =
*qp)
> +{
> +	int srqn =3D srq->xsrq.srqn;
> +	struct xsc_srq_cache_wr *cache_wr =3D srq->xsrq.cache_wr;
> +
> +	if (!qp->srq_head_wr)
> +		return;
> +
> +	if (qp->srq_tail_wr)
> +		qp->srq_tail_wr->next =3D cache_wr[srqn].head_wr;
> +	cache_wr[srqn].head_wr =3D qp->srq_head_wr;
> +	qp->srq_head_wr =3D NULL;
> +	qp->srq_tail_wr =3D NULL;
> +}
> +
> +void xsc_free_one_cache_srq_wr(struct xsc_ib_srq *srq, struct xsc_ib_qp =
*qp, u64 wr_id)
> +{
> +	struct ib_recv_wr *tmp_wr, *prev_wr =3D NULL;
> +	int srqn =3D srq->xsrq.srqn;
> +	struct xsc_srq_cache_wr *cache_wr =3D srq->xsrq.cache_wr;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&srq->lock, flags);
> +	tmp_wr =3D qp->srq_head_wr;
> +	for (; tmp_wr; tmp_wr =3D tmp_wr->next) {
> +		if (tmp_wr->wr_id =3D=3D wr_id) {
> +			if (prev_wr)
> +				prev_wr->next =3D tmp_wr->next;
> +			else
> +				qp->srq_head_wr =3D tmp_wr->next;
> +			if (qp->srq_tail_wr =3D=3D tmp_wr)
> +				qp->srq_tail_wr =3D prev_wr;
> +
> +			kfree(tmp_wr->sg_list);
> +			kfree(tmp_wr);
> +			cache_wr[srqn].wr_num--;
> +			break;
> +		}
> +		prev_wr =3D tmp_wr;
> +	}
> +	spin_unlock_irqrestore(&srq->lock, flags);
> +}

[ ... ]

> +int xsc_ib_create_srq(struct ib_srq *ib_srq,
> +		      struct ib_srq_init_attr *init_attr,
> +		      struct ib_udata *udata)
> +{

[ ... ]

> +	if (udata) {
> +		struct xsc_ib_create_srq_resp resp =3D {
> +			.srqn =3D srq->xsrq.srqn,
> +		};
> +
> +		if (ib_copy_to_udata(udata, &resp,
> +				     min(udata->outlen, sizeof(resp)))) {
> +			ibdev_dbg(&dev->ib_dev, "copy to user failed\n");
> +			err =3D -EFAULT;
> +			goto err_rsp;
> +		}
> +	} else {
> +		err =3D xsc_init_cache_wr(init_attr, srq);
> +		if (err)
> +			goto err_rsp;
> +		INIT_LIST_HEAD(&srq->xsrq.srq_qp_list);
> +	}
> +
> +	init_attr->attr.max_wr =3D srq->xsrq.max - 1;

[ ... ]

> +static int xsc_cache_srq_wr(struct xsc_ib_srq *srq, const struct ib_recv=
_wr *wr, int *nreq)
> +{
> +	int i, n;
> +	int srqn =3D srq->xsrq.srqn;
> +	struct xsc_srq_cache_wr *cache_wr =3D srq->xsrq.cache_wr;
> +	struct ib_recv_wr *head_wr =3D NULL, *new_wr =3D NULL, *prev_wr =3D NUL=
L;
> +	const struct ib_recv_wr *tmp;
> +
> +	for (n =3D 0, tmp =3D wr; tmp; tmp =3D tmp->next, n++)
> +		;
> +
> +	if (cache_wr[srqn].wr_num + n > cache_wr[srqn].max_wr_num)
> +		return -1;
> +
> +	for (n =3D 0; wr; wr =3D wr->next, n++) {
> +		new_wr =3D kcalloc(1, sizeof(*new_wr), GFP_ATOMIC);
> +		if (!new_wr)
> +			goto err;
> +		new_wr->sg_list =3D kcalloc(wr->num_sge, sizeof(*new_wr->sg_list),
> +					  GFP_ATOMIC);
> +		if (!new_wr->sg_list) {
> +			kfree(new_wr);
> +			goto err;
> +		}
> +		new_wr->wr_id =3D wr->wr_id;
> +		for (i =3D 0; i < wr->num_sge; i++)
> +			memcpy(&new_wr->sg_list[i], &wr->sg_list[i],
> +			       sizeof(struct ib_sge));
> +		new_wr->num_sge =3D wr->num_sge;
> +		if (prev_wr)
> +			prev_wr->next =3D new_wr;
> +		else
> +			head_wr =3D new_wr;
> +		prev_wr =3D new_wr;
> +	};
> +
> +	if (!cache_wr[srqn].head_wr)
> +		cache_wr[srqn].head_wr =3D head_wr;
> +	else
> +		cache_wr[srqn].tail_wr->next =3D head_wr;
> +
> +	cache_wr[srqn].tail_wr =3D new_wr;
> +	cache_wr[srqn].wr_num +=3D n;
> +	*nreq =3D n;
> +
> +	return 0;
> +
> +err:
> +	xsc_free_all_cache_wrs(head_wr);
> +	return -ENOMEM;
> +}
> +
> +void xsc_post_cache_wrs(struct xsc_ib_srq *srq, struct xsc_ib_qp *qp, in=
t wr_num, bool init)
> +{
> +	int srqn =3D srq->xsrq.srqn;
> +	struct xsc_srq_cache_wr *cache_wr =3D srq->xsrq.cache_wr;
> +	int err =3D 0;
> +	int i;
> +	const struct ib_recv_wr *tmp_wr;
> +	const struct ib_recv_wr *bad_wr;
> +	struct ib_recv_wr *wr_head, *next_wr;
> +	struct ib_recv_wr *prev_tail;
> +
> +	if (!cache_wr[srqn].head_wr)
> +		return;
> +
> +	wr_head =3D cache_wr[srqn].head_wr;
> +	next_wr =3D cache_wr[srqn].head_wr;
> +	prev_tail =3D qp->srq_tail_wr;
> +
> +	if (init || !qp->srq_tail_wr)
> +		qp->srq_head_wr =3D wr_head;
> +	else
> +		qp->srq_tail_wr->next =3D wr_head;
> +
> +	qp->srq_tail_wr =3D wr_head;
> +	for (i =3D 0; next_wr && i < (wr_num - 1); i++) {
> +		next_wr =3D next_wr->next;
> +		if (next_wr)
> +			qp->srq_tail_wr =3D next_wr;
> +	}
> +
> +	cache_wr[srqn].head_wr =3D qp->srq_tail_wr->next;
> +	qp->srq_tail_wr->next =3D NULL;
> +	tmp_wr =3D wr_head;
> +	err =3D xsc_ib_post_recv(&qp->ibqp, tmp_wr, &bad_wr);
> +	if (err) {
> +		qp->srq_tail_wr->next =3D cache_wr[srqn].head_wr;
> +		qp->srq_tail_wr =3D NULL;
> +		for (; wr_head && wr_head !=3D bad_wr; wr_head =3D wr_head->next)
> +			qp->srq_tail_wr =3D wr_head;
> +
> +		if (!qp->srq_tail_wr) {
> +			cache_wr[srqn].head_wr =3D wr_head;
> +			if (prev_tail && !init) {
> +				prev_tail->next =3D NULL;
> +				qp->srq_tail_wr =3D prev_tail;
> +			} else {
> +				qp->srq_head_wr =3D NULL;
> +			}
> +		} else {
> +			cache_wr[srq->xsrq.srqn].head_wr =3D qp->srq_tail_wr->next;
> +			qp->srq_tail_wr->next =3D NULL;
> +		}
> +	}
> +}

[Severity: Critical]
Can xsc_cache_srq_wr() cause a use-after-free via a stale
cache_wr[srqn].tail_wr pointer?

1. When xsc_post_cache_wrs() moves all cached WRs from
cache_wr[srqn].head_wr onto an attached QP, cache_wr[srqn].head_wr becomes
NULL, but cache_wr[srqn].tail_wr is not cleared and remains pointing to the
last WR now owned by the QP.
2. When that WR completes on the QP, xsc_free_one_cache_srq_wr() frees it
with kfree(tmp_wr), leaving cache_wr[srqn].tail_wr as a dangling pointer.
3. If xsc_restore_cache_srq_wrs() is then called while
cache_wr[srqn].head_wr is NULL (or if xsc_ib_post_recv() fails inside
xsc_post_cache_wrs() when cache_wr[srqn].head_wr was emptied),
cache_wr[srqn].head_wr becomes non-NULL again without updating
cache_wr[srqn].tail_wr.
4. On the next call to xsc_ib_post_srq_recv() -> xsc_cache_srq_wr(),
cache_wr[srqn].head_wr is non-NULL, so it executes:

	cache_wr[srqn].tail_wr->next =3D head_wr;

which writes to the freed tmp_wr slab object (or corrupts an active QP WR
chain) and leaks head_wr.

Also, if xsc_ib_post_srq_recv() is called with wr =3D=3D NULL while
cache_wr[srqn].head_wr is non-NULL, xsc_cache_srq_wr() sets
cache_wr[srqn].tail_wr =3D new_wr (NULL), causing a NULL pointer dereference
on the subsequent xsc_cache_srq_wr() call.

> +int xsc_ib_post_srq_recv(struct ib_srq *ibsrq, const struct ib_recv_wr *=
wr,
> +			 const struct ib_recv_wr **bad_wr)
> +{
> +	struct xsc_ib_srq *srq =3D to_xsrq(ibsrq);
> +	struct xsc_ib_dev *dev =3D to_xdev(ibsrq->device);
> +	struct xsc_srq_qp_node *qp_node;
> +	struct xsc_ib_qp *qp;
> +	unsigned long flags;
> +	int err =3D 0;
> +	int flush_wqe_cnt =3D 0;
> +	int nreq =3D 0;
> +	int wr_num =3D 0;
> +
> +	spin_lock_irqsave(&srq->lock, flags);
> +
> +	err =3D xsc_cache_srq_wr(srq, wr, &nreq);
> +	if (err =3D=3D -ENOMEM) {
> +		ibdev_err(&dev->ib_dev, "failed to cache SRQ WRs, err=3D%d\n", err);
> +		*bad_wr =3D wr;
> +		goto out;
> +	}
> +	if (err) {
> +		ibdev_err(&dev->ib_dev, "No more space to cache SRQ WRs...");
> +		err =3D -EINVAL;
> +		*bad_wr =3D wr;
> +		goto out;
> +	}
> +
> +	if (list_empty(&srq->xsrq.srq_qp_list))
> +		goto out;
> +
> +	list_sort(NULL, &srq->xsrq.srq_qp_list, cmp_flush_wqe_cnt);
> +
> +	list_for_each_entry(qp_node, &srq->xsrq.srq_qp_list, entry) {
> +		if (!qp_node || nreq <=3D 0)
> +			break;
> +
> +		qp =3D to_xqp(qp_node->ibqp);
> +		flush_wqe_cnt =3D atomic_read(&qp->rq.flush_wqe_cnt);
> +		if (flush_wqe_cnt >=3D XSC_SRQ_MIN_WR_NUM)
> +			continue;
> +		wr_num =3D min_t(int, nreq, XSC_SRQ_MIN_WR_NUM - flush_wqe_cnt);
> +		nreq -=3D wr_num;
> +		ibdev_dbg(&dev->ib_dev, "srq_qp_list qp node qp %d, flush cnt %d, nreq=
 %d, wr_num %d\n",
> +			  qp_node->qp_id, flush_wqe_cnt, nreq, wr_num);
> +		xsc_post_cache_wrs(srq, qp, wr_num, false);
> +	}

[Severity: High]
How are attached QPs replenished once their initial 32 WRs
(XSC_SRQ_MIN_WR_NUM) complete?

1. When > 32 WRs are posted to an SRQ, xsc_ib_post_srq_recv() posts at most
XSC_SRQ_MIN_WR_NUM (32) WRs to each attached QP and leaves the rest in
cache_wr[srqn].head_wr. When those WRs complete on a QP in xsc_poll_one()
-> xsc_free_one_cache_srq_wr(), the completed WR is freed and
cache_wr[srqn].wr_num is decremented, but xsc_post_cache_wrs() is never
called to replenish the QP's RQ from cache_wr[srqn].head_wr. Moreover,
xsc_ib_post_srq_recv() bounds wr_num by nreq (the count from the current
call) rather than the total cached WRs in cache_wr[srqn].head_wr, leaving
previously cached WRs stranded.

2. In xsc_ib_create_srq(), xsc_init_cache_wr(init_attr, srq) is called
before init_attr->attr.max_wr =3D srq->xsrq.max - 1, so
cache_wr[srqn].max_wr_num stores the unrounded max_wr while
xsc_ib_create_srq() and xsc_ib_query_srq() report srq->xsrq.max - 1. Posting
up to the reported max_wr will then fail with -EINVAL in xsc_cache_srq_wr().

3. Neither xsc_ib_create_srq() nor xsc_cache_srq_wr() validates max_sge or
wr->num_sge against srq->xsrq.max_gs (or < 0). If a WR with num_sge >
qp->rq.max_gs is cached in xsc_cache_srq_wr(), xsc_ib_post_recv() inside
xsc_post_cache_wrs() rejects it with -EINVAL, and xsc_post_cache_wrs()
places bad_wr back at the head of cache_wr[srqn].head_wr while
xsc_ib_post_srq_recv() returns 0, permanently blocking subsequent SRQ posts
from reaching attached QPs.

> diff --git a/drivers/infiniband/hw/xsc/xsc_ib.h b/drivers/infiniband/hw/x=
sc/xsc_ib.h
> index eb4d9e6309744..d7b0ff1768383 100644
> --- a/drivers/infiniband/hw/xsc/xsc_ib.h
> +++ b/drivers/infiniband/hw/xsc/xsc_ib.h
> @@ -324,8 +325,25 @@ void __xsc_ib_cq_clean(struct xsc_ib_cq *cq, u32 qpn=
);
>  void xsc_ib_cq_clean(struct xsc_ib_cq *cq, u32 qpn);
> =20
>  int xsc_ib_query_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr);
> +
> +/*
> + * Wake the CQ completion handlers of a QP that has just moved to ERR.  =
Must
> + * be called with no cq->lock held: the handler may poll or rearm the CQ,
> + * which takes that lock again.
> + */
> +static inline void xsc_ib_trigger_cq_comp_handler(struct ib_cq *send_cq,
> +						  struct ib_cq *recv_cq)
> +{
> +	if (send_cq)
> +		send_cq->comp_handler(send_cq, send_cq->cq_context);
> +
> +	if (recv_cq && send_cq !=3D recv_cq)
> +		recv_cq->comp_handler(recv_cq, recv_cq->cq_context);
> +}

[Severity: Medium]
What happens in xsc_ib_trigger_cq_comp_handler() when a kernel CQ uses
IB_POLL_DIRECT or has a NULL comp_handler?

For CQs allocated with IB_POLL_DIRECT, cq->comp_handler is set to
ib_cq_completion_direct() in drivers/infiniband/core/cq.c, which triggers
WARN_ONCE(1, "got unsolicited completion for CQ %p\n", cq). Should
xsc_ib_trigger_cq_comp_handler() check that comp_handler is non-NULL and
that poll_ctx !=3D IB_POLL_DIRECT before invoking comp_handler?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104155650.3705=
3-1-tianx@yunsilicon.com?part=3D12
