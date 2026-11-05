Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894979;
	b=Cnjgovou6luX9iifAnADhCV8TQ3ob2LL/HiGgaYv+XUHRaCbQz0myjepQVgXI3V/Xkjg
	 3wqjxQLATxT3q9fFKrgnKyr6kqU1Yqv02qr2E/benTfYSozm1YiAAK4xK/iY6CJh+SF8T
	 sV7Yny6JG5DTAahMXBAK4AQu+XHtaGWHP7mRhm8RT3+oJdbfwF+YhwgbGtIDIRkE6n5k/
	 5UWBPuczGvusoWU5gvX20myhoRe2yyznVCDghZOXmrv2tXbD+0KAydCKbZlkAa0CFVSlm
	 /2B8jn/l99PV7BCXUlvbJLS/dv+vv1Mw1E69ZDE8x1UDE12JxROpl+kYMpdBBLikAGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894979;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=w4eHZdllpcI+7j3pGCWdAOmLFyHyYsiLLKwFHedzzvM=;
	b=cgZfALbf2tZ0Eg6KDzJy4p8M/Sa7Z9w5A1cFQJzWv4hMG4YGQe9Ka0UUjx2f/JaXJNMj
	 UN+YeVtK5Tkunpei0082yvfLDqS4zSv0+AnwjtA7TnbE6IziP6uiDGFGz1Q+t9+Sj9J+l
	 3Jx8DEmHMp56+gr6+IQZ/lcwGyRhqt3Jqd+RubBmE0FhEyXXZGi8mcv6KFcUk4Rqsple9
	 kiuSuEm1RqZ8I8rgRUZejghcW6/mIwXj9vbwnj1wuYoEU4Zt8KmtfUwBjKagPxKmCU/mw
	 UBmSq7FV+VY7ndRQUkMDTY9VozLXo4Xqjr5699AJKc8Zh6gKAhu/D9q8Zv6Sl8Nni3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A4Y1DDDO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A42F606BEAB
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 16:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A4Y1DDDO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0961F000C1;
	Thu,  5 Nov 2026 16:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894979;
	bh=w4eHZdllpcI+7j3pGCWdAOmLFyHyYsiLLKwFHedzzvM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A4Y1DDDOk0QqXGyVJZsLVrPgr4IbPtREodlBVK+PwX/8K4Am4+KNww5EDy+er9+YN
	 /TxmWaI/HDvU0N1LRN19vb9peOfKspUvZ3Q4VdWEYRkrthiIMYBAN3Q+e9gsRSGJbO
	 ngEEcC953zAfWRvjJplga0I0g0cCZULdofyaITtKzYG1A7uy4MqkxUL3VpZS40/pR7
	 2QgiSiQZg7CI4N81dg7RzFO7axrqRHOCacrslK+BTRYMDeBVoXJEOFk4MmbW0kJ7xy
	 CfwNK9pix19M2+izZPiktxprDy5O3G2UjNbgZVuujaFYhQAb52faBxPmcZGPzlY/3V
	 YmiussUYaIF0w==
Message-ID: <sashiko-outbox-199436@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 14/15] RDMA/xsc: add the RDMA send path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104155723.37053-15-tianx@yunsilicon.com>
References: <20261104155650.37053-1-tianx@yunsilicon.com>
 <20261104155723.37053-15-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 16:09:38 +0000
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
- [Critical] RDMA/xsc: stack OOB read in build_qp1_send_v2() from xsc_ib_dr=
ain_sq()
- [Critical] RDMA/xsc: hdr_buf DMA buffer overflow on MAD/UD send in xsc_ib=
_post_send()
- [High] RDMA/xsc: broken inline ds_data_num and zero-length SGEs in xsc_ib=
_post_send()
- [High] RDMA/xsc: completion deadlock and lost wakeup in xsc_ib_drain_sq()=
 and rq
- [High] RDMA/xsc: stale zero_length_read state corrupts completions in xsc=
_poll_one()
- [High] RDMA/xsc: missing endian conversions on ctrl->msg_len and crc in x=
sc_ib_post_send()
- [High] RDMA/xsc: missing le64_to_cpu() on data_seg->va in xsc_handle_rdma=
_mad_resp_recv()
- [High] RDMA/xsc: unsynchronized WQ access in xsc_generate_flush_err_cqe()=
 and post paths
- [Medium] RDMA/xsc: broken IB_WR_SEND_WITH_IMM header packing in build_qp1=
_send_v2()
- [Low] RDMA/xsc: duplicate crc32_le() implementation and inaccurate IOMMU =
comment
- [Low] RDMA/xsc: unbalanced flush_wqe_cnt for MAD sends in xsc_ib_post_sen=
d()
- [Low] RDMA/xsc: wrong format specifier %ld for size_t in build_qp1_send_v=
2()
- [Low] RDMA/xsc: comment in xsc_ib.h falsely claims QP1 creation is refuse=
d on UNKNOWN IOMMU
--

commit c77226a0e2a3291230f2f8d59b1b33bb5ef256ca
Author: Xin Tian <tianx@yunsilicon.com>

RDMA/xsc: add the RDMA send path

This commit implements the RDMA send path for the xsc driver, including
xsc_ib_post_send() for RC and QP1/UD traffic, zero-length RDMA read
handling, and the xsc_ib_drain_sq() and xsc_ib_drain_rq() helpers.

> diff --git a/drivers/infiniband/hw/xsc/cq.c b/drivers/infiniband/hw/xsc/c=
q.c
> index 36d122f8d46fb..a5ab8d00d9a6b 100644
> --- a/drivers/infiniband/hw/xsc/cq.c
> +++ b/drivers/infiniband/hw/xsc/cq.c
[ ... ]
> @@ -173,7 +173,13 @@ static void xsc_handle_rdma_mad_resp_recv(struct xsc=
_ib_cq *cq,
>  	handle_responder(wc, cqe, *cur_qp, opcode);
> =20
>  	data_seg =3D get_seg_wqe(get_recv_wqe(*cur_qp, idx), 0);
> -	recv =3D xsc_ib_recv_mad_sg_virt_addr(&dev->ib_dev, wc, data_seg->va);
> +	recv =3D xsc_ib_mad_sg_virt_addr(&dev->ib_dev, data_seg->va);

[Severity: High]
In xsc_handle_rdma_mad_resp_recv(), data_seg->va is a __le64 field populated
in xsc_ib_post_recv() via WR_LE_64(data_seg->va, wr->sg_list[i].addr).

Should data_seg->va be converted with le64_to_cpu() before passing it as a
dma_addr_t to xsc_ib_mad_sg_virt_addr() so that the DMA address is not
byte-swapped on big-endian architectures?

> diff --git a/drivers/infiniband/hw/xsc/main.c b/drivers/infiniband/hw/xsc=
/main.c
> index 138ca1a80083b..0574687982c24 100644
> --- a/drivers/infiniband/hw/xsc/main.c
> +++ b/drivers/infiniband/hw/xsc/main.c
> @@ -474,6 +474,22 @@ static int init_node_data(struct xsc_ib_dev *dev)
>  	return 0;
>  }
> =20
> +static void crc_table_init(struct xsc_ib_dev *dev)
> +{
> +	u32 c, i, j;
> +
> +	for (i =3D 0; i < 256; i++) {
> +		c =3D i;
> +		for (j =3D 0; j < 8; j++) {
> +			if (c & 1)
> +				c =3D 0xedb88320L ^ (c >> 1);
> +			else
> +				c =3D c >> 1;
> +		}
> +		dev->crc_32_table[i] =3D c;
> +	}
> +}

[Severity: Low]
This isn't a bug, but drivers/infiniband/hw/xsc/qp.c already includes
linux/crc32.h, which provides crc32_le() using the same 0xedb88320 polynomi=
al.

Could xsc_icrc_hdr() and xsc_ib_post_send() use crc32_le() directly instead=
 of
maintaining dev->crc_32_table[], crc_table_init(), and xsc_crc32()?

> diff --git a/drivers/infiniband/hw/xsc/qp.c b/drivers/infiniband/hw/xsc/q=
p.c
> index 0dfb102949070..46ca3dd95df35 100644
> --- a/drivers/infiniband/hw/xsc/qp.c
> +++ b/drivers/infiniband/hw/xsc/qp.c
[ ... ]
> @@ -1437,13 +1532,538 @@ static int xsc_wq_overflow(struct xsc_ib_wq *wq,=
 int nreq)
>  	return cur + nreq >=3D wq->max_post;
>  }
> =20
> +static inline void xsc_post_send_db(struct xsc_ib_qp *qp,
> +				    struct xsc_core_device *xdev,
> +				    int nreq)
> +{
> +	u32 next_pid;
> +
> +	if (unlikely(!nreq))
> +		return;
> +
> +	qp->sq.head +=3D nreq;
> +
> +	next_pid =3D qp->sq.head << (qp->sq.wqe_shift - XSC_BASE_WQE_SHIFT);
> +	xsc_update_tx_db(xdev, qp->doorbell_qpn, next_pid);
> +}

[Severity: High]
Can xsc_post_send_db() and xsc_ib_post_recv() race with
xsc_generate_flush_err_cqe() during QP drain or error transitions?

xsc_ib_post_send() holds only qp->sq.lock while populating qp->sq.wrid[idx],
qp->sq.wqe_head[idx], qp->sq.need_flush[idx], and qp->sq.wr_opcode[idx], and
then xsc_post_send_db() advances qp->sq.head before the barrier in
xsc_update_tx_db(). Similarly, xsc_ib_post_recv() holds only qp->rq.lock.

Meanwhile, in drivers/infiniband/hw/xsc/cq.c, xsc_ib_poll_cq() calls
xsc_generate_flush_err_cqe() while holding only cq->lock and
cq->err_state_qp_lock:

drivers/infiniband/hw/xsc/cq.c:xsc_generate_flush_err_cqe() {
	...
		while (wq->tail !=3D wq->head) {
			idx =3D wq->tail & (wq->wqe_cnt - 1);
			if (err_qp_node->is_sq && !wq->need_flush[idx]) {
				wq->tail++;
				continue;
			} else {
				gen_flush_err_cqe(err_qp_node, &(core_to_xqp(xqp)->ibqp), wq,
						  idx, wc + *npolled + sw_npolled);
				++sw_npolled;
			}
	...
}

When xsc_ib_drain_sq() or xsc_ib_drain_rq() moves the QP to IB_QPS_ERR first
and then posts the drain WR, could xsc_generate_flush_err_cqe() on another =
CPU
observe the updated wq->head alongside a stale wq->need_flush[idx] or
wq->wrid[idx], skipping the drain WR or invoking a stale wr_cqe callback?

[ ... ]
> +/* Routine for sending QP1 packets for RoCE V2 */
> +static int build_qp1_send_v2(struct xsc_ib_dev *dev,
> +			     struct xsc_ib_qp *qp,
> +			     const struct ib_send_wr *wr,
> +			     struct ib_sge *sge,
> +			     int payload_size, u32 *crc)
> +{
> +	struct xsc_ib_ah *ah =3D container_of(ud_wr((struct ib_send_wr *)wr)->a=
h, struct xsc_ib_ah,
> +					    ibah);
> +	const struct ib_gid_attr *sgid_attr =3D ah->ibah.sgid_attr;

[Severity: Critical]
Does draining a GSI or UD send queue via xsc_ib_drain_sq() read past the end
of the stack-allocated work request in build_qp1_send_v2()?

In xsc_ib_drain_sq(), swr is declared on the stack as a base struct ib_send=
_wr
with .opcode =3D IB_WR_RDMA_WRITE:

xsc_ib_drain_sq()
  -> xsc_ib_post_send(qp, &swr, &bad_swr)
       -> case IB_QPT_UD / IB_QPT_GSI:
            -> build_qp1_send_v2(dev, qp, wr, &sg, msg_len, &crc)

Because xsc_ib_post_send() does not check for drain WRs or validate wr->opc=
ode
in the IB_QPT_UD and IB_QPT_GSI cases, build_qp1_send_v2() casts &swr via
ud_wr(wr)->ah, reading past the end of struct ib_send_wr on the stack and
dereferencing ah->ibah.sgid_attr.

Also, for IB_QPT_SMI or IB_QPT_RAW_PACKET QPs, doesn't xsc_ib_post_send() h=
it
the default branch and fail xsc_ib_drain_sq() with -EPERM?

[ ... ]
> +	is_eth =3D true;
> +	is_vlan =3D (vlan_id && (vlan_id < 0x1000)) ? true : false;
> +
> +	ib_ud_header_init(payload_size, !is_eth, is_eth, is_vlan, false,
> +			  ip_version, true, 0, &qp->qp1_hdr);
[ ... ]
> +	/* BTH */
> +	if (wr->opcode =3D=3D IB_WR_SEND_WITH_IMM) {
> +		qp->qp1_hdr.bth.opcode =3D IB_OPCODE_UD_SEND_ONLY_WITH_IMMEDIATE;
> +		qp->qp1_hdr.immediate_present =3D 1;
> +	} else {
> +		qp->qp1_hdr.bth.opcode =3D IB_OPCODE_UD_SEND_ONLY;
> +	}

[Severity: Medium]
When wr->opcode =3D=3D IB_WR_SEND_WITH_IMM in build_qp1_send_v2(),
ib_ud_header_init() is called with immediate_present =3D 0, and
qp->qp1_hdr.immediate_present is later set to 1 without setting
qp->qp1_hdr.immediate_data or increasing sge->length by 4 bytes.

Doesn't ib_ud_header_pack() then write 4 uninitialized bytes of immediate_d=
ata
at the end of the header that are excluded from the IP/UDP lengths and
sge->length, and then overwritten when xsc_ib_post_send() copies the payload
to mad_send_base + sg.length?

[ ... ]
> +	rc =3D xsc_icrc_hdr(dev, hdr_buf, sge->length - sizeof(struct ib_unpack=
ed_eth), crc);
> +	if (rc) {
> +		ibdev_err(&dev->ib_dev, "CRC error: hdr size %ld\n",
> +			  sge->length - sizeof(struct ib_unpacked_eth));
> +	}
> +	return rc;
> +}

[Severity: Low]
In build_qp1_send_v2(), sge->length - sizeof(struct ib_unpacked_eth) has ty=
pe
size_t. Should the format specifier be %zu instead of %ld to avoid -Wformat
warnings on 32-bit COMPILE_TEST builds?

[ ... ]
> +		for (i =3D 0; i < wr->num_sge; ++i) {
> +			if (likely(wr->sg_list[i].length))
> +				msg_len +=3D wr->sg_list[i].length;
> +		}
> +		ctrl->msg_len =3D msg_len;

[Severity: High]
In struct xsc_send_wqe_ctrl_seg, ctrl->msg_len is declared as __le32.

In xsc_ib_post_send(), msg_len is assigned to ctrl->msg_len without
cpu_to_le32(), and in the IB_QPT_UD / IB_QPT_GSI branch below:

	crc =3D xsc_crc32(dev, crc, mad_send_base + sg.length, ctrl->msg_len);
	ctrl->msg_len +=3D sg.length;
	seg_index++;

	put_unaligned(~crc, (u32 *)&mad_send_base[ctrl->msg_len]);
	ctrl->msg_len +=3D sizeof(crc);
	sg.length =3D ctrl->msg_len;

ctrl->msg_len is used directly in host-endian arithmetic and array indexing,
and ~crc is written in host byte order with put_unaligned() instead of
put_unaligned_le32(). Won't this corrupt the WQE length, buffer offset, and
ICRC on big-endian systems?

[ ... ]
> +			if (unlikely(wr->opcode =3D=3D IB_WR_RDMA_READ && msg_len =3D=3D 0)) {
> +				ibdev_dbg(&dev->ib_dev, "post zero-length read wr\n");
> +				/* HW rejects zero-length reads; poll backfills the
> +				 * READ opcode from qp->sq.zero_length_read[]
> +				 */
> +				ctrl_val |=3D FIELD_PREP(XSC_WQE_CTRL_SEG_DATA0_MSG_OPCODE_MASK,
> +						       dev->opcode_map[IB_WR_RDMA_WRITE]);
> +				qp->sq.zero_length_read[idx] =3D 1;
> +			} else {
> +				ctrl_val |=3D FIELD_PREP(XSC_WQE_CTRL_SEG_DATA0_MSG_OPCODE_MASK,
> +						       dev->opcode_map[wr->opcode]);
> +			}
> +			break;

[Severity: High]
Can qp->sq.zero_length_read[idx] remain set across WQE slot reuse and corru=
pt
a later completion in xsc_poll_one()?

In xsc_ib_post_send(), qp->sq.zero_length_read[idx] is set to 1 for any
zero-length IB_WR_RDMA_READ, and the else branch does not clear it to 0. In
xsc_poll_one(), wq->zero_length_read[idx] is only cleared when a normal or
error hardware CQE is polled for that idx.

If a zero-length RDMA read is posted unsignaled (!ce), or if it is completed
via xsc_generate_lost_cqe() or software flush in gen_flush_err_cqe(), or if
set_data_inl_seg() fails later in xsc_ib_post_send(), zero_length_read[idx]
stays 1 and will overwrite the completion opcode of a subsequent signaled S=
END
or WRITE that reuses slot idx.

> +		case IB_QPT_UD:
> +		case IB_QPT_GSI:
> +			ctrl_val |=3D FIELD_PREP(XSC_WQE_CTRL_SEG_DATA0_MSG_OPCODE_MASK,
> +					       xsc_ib_opcode->mad);
> +			ds_data_num++;
> +			data_seg =3D get_seg_wqe(ctrl, seg_index);
> +			mad_send_base =3D (u8 *)qp->sq.hdr_buf +
> +				MAX_QP1_SQ_HDR_SIZE_V2 * qp->sq.mad_index;
> +
> +			err =3D build_qp1_send_v2(dev, qp, wr, &sg, msg_len, &crc);
> +			if (err) {
> +				*bad_wr =3D wr;
> +				goto out;
> +			}
> +
> +			cur_p =3D mad_send_base + sg.length;
> +			for (i =3D 0; i < wr->num_sge; ++i) {
> +				if (likely(wr->sg_list[i].length)) {
> +					vaddr =3D xsc_ib_mad_sg_virt_addr(&dev->ib_dev,
> +									wr->sg_list[i].addr);
> +					if (unlikely(!vaddr)) {
> +						ibdev_err(&dev->ib_dev,
> +							  "cannot map MAD sg entry %d to a virtual address\n",
> +							  i);
> +						err =3D -EOPNOTSUPP;
> +						*bad_wr =3D wr;
> +						goto out;
> +					}
> +					memcpy(cur_p, vaddr, wr->sg_list[i].length);
> +				}
> +				cur_p +=3D wr->sg_list[i].length;
> +			}
> +			crc =3D xsc_crc32(dev, crc, mad_send_base + sg.length, ctrl->msg_len);
> +			ctrl->msg_len +=3D sg.length;
> +			seg_index++;
> +
> +			put_unaligned(~crc, (u32 *)&mad_send_base[ctrl->msg_len]);

[Severity: Critical]
Can this memcpy() and put_unaligned() overflow the 512-byte slot in
qp->sq.hdr_buf?

In create_kernel_qp(), qp->sq.hdr_buf is allocated with MAD_QUEUE_DEPTH slo=
ts
of MAX_QP1_SQ_HDR_SIZE_V2 (512) bytes each, while xsc_port_immutable() sets
immutable->max_mad_size =3D IB_MGMT_MAD_SIZE * 2 (512 bytes).

In xsc_ib_post_send(), build_qp1_send_v2() writes up to 86 bytes of RoCEv2
headers into mad_send_base, and then xsc_ib_post_send() copies msg_len bytes
of SGE payload plus 4 bytes of ICRC immediately after sg.length without
checking that sg.length + msg_len + sizeof(crc) fits within
MAX_QP1_SQ_HDR_SIZE_V2. A 512-byte MAD (or any UD payload over 422 bytes) w=
ill
write up to 602 bytes into the 512-byte slot and past the end of
qp->sq.hdr_buf on the last slot.

[ ... ]
> +		ctrl_val |=3D FIELD_PREP(XSC_WQE_CTRL_SEG_DATA0_DS_DATA_NUM_MASK, ds_d=
ata_num);
> +		ctrl->data0 |=3D cpu_to_le32(ctrl_val);
> +		ctrl->data3 =3D cpu_to_le32((wr->send_flags & IB_SEND_SOLICITED ?
> +					   XSC_WQE_CTRL_SEG_DATA3_SE : 0) |
> +					  (ce ? XSC_WQE_CTRL_SEG_DATA3_CE : 0));
> +
> +		if (wr->send_flags & IB_SEND_INLINE && wr->num_sge) {
> +			unsigned int segs_used;
> +
> +			err =3D set_data_inl_seg(qp, wr, ctrl, seg_index, &segs_used);
> +			if (unlikely(err)) {
> +				*bad_wr =3D wr;
> +				ibdev_err(&dev->ib_dev, "inline layout failed, err %d\n", err);
> +				goto out;
> +			}
> +			ds_data_num =3D segs_used - 1;
> +		} else {
> +			for (i =3D 0; i < sg_n; ++i, ++seg_index) {
> +				if (likely(sgl[i].length)) {
> +					data_seg =3D get_seg_wqe(ctrl, seg_index);
> +					set_local_data_seg(dev->xdev, data_seg, &sgl[i]);
> +				}
> +			}
> +		}

[Severity: High]
There appear to be three issues with how ds_data_num and the data segments =
are
populated here in xsc_ib_post_send():

1. ctrl->data0 is written with ds_data_num before the IB_SEND_INLINE block
   runs, so ds_data_num =3D segs_used - 1 after set_data_inl_seg() is never
   written to ctrl->data0.

2. For IB_QPT_UD and IB_QPT_GSI, sg_n is set to 0 after copying the payload
   into qp->sq.hdr_buf, but the inline check tests wr->num_sge instead of
   sg_n, which would cause set_data_inl_seg() to append extra inline segmen=
ts
   on UD/GSI QPs.

3. In the non-inline else loop, seg_index is incremented on every iteration
   even when sgl[i].length =3D=3D 0 and set_local_data_seg() is skipped, wh=
ile
   ds_data_num still includes zero-length SGEs, leaving zeroed segment holes
   in the WQE.

> +		qp->sq.wrid[idx] =3D wr->wr_id;
> +		qp->sq.wqe_head[idx] =3D qp->sq.head + nreq;
> +		qp->sq.cur_post +=3D 1;
> +		if (ce) {
> +			atomic_inc(&qp->sq.flush_wqe_cnt);
> +			qp->sq.need_flush[idx] =3D 1;
> +			qp->sq.prev_ce_wqe[idx] =3D qp->sq.last_post_ce_wqe;
> +			qp->sq.last_post_ce_wqe =3D idx;
> +		}
> +		qp->sq.wr_opcode[idx] =3D wr->opcode;

[Severity: Low]
When ce is true in xsc_ib_post_send(), qp->sq.flush_wqe_cnt is incremented =
for
all QP types including IB_QPT_GSI, but in drivers/infiniband/hw/xsc/cq.c,
xsc_poll_one() skips decrementing it when a MAD send completes:

drivers/infiniband/hw/xsc/cq.c:xsc_poll_one() {
	...
		if (opcode !=3D XSC_OPCODE_RDMA_MAD_REQ_SEND)
			atomic_dec(&wq->flush_wqe_cnt);
	...
}

Doesn't this cause qp->sq.flush_wqe_cnt to grow on every signaled MAD send?

[ ... ]
> +void xsc_ib_drain_rq(struct ib_qp *qp)
> +{
> +	struct ib_cq *cq =3D qp->recv_cq;
> +	struct xsc_ib_cq *xcq =3D to_xcq(cq);
> +	struct xsc_ib_qp *xqp =3D to_xqp(qp);
> +	struct ib_qp_attr attr =3D { .qp_state =3D IB_QPS_ERR };
> +	struct xsc_ib_drain_cqe rdrain;
> +	const struct ib_recv_wr rwr =3D {
> +		.next =3D NULL,
> +		{.wr_cqe =3D &rdrain.cqe,},
> +	};
> +	const struct ib_recv_wr *bad_rwr;
> +	int ret;
> +	struct xsc_ib_dev *dev =3D to_xdev(qp->device);
> +
> +	ret =3D ib_modify_qp(qp, &attr, IB_QP_STATE);
> +	if (ret) {
> +		ibdev_err(&dev->ib_dev, "failed to drain recv queue: %d\n", ret);
> +		return;
> +	}
> +
> +	rdrain.cqe.done =3D xsc_ib_drain_rq_done;
> +	init_completion(&rdrain.done);
> +
> +	ret =3D xsc_ib_post_recv(qp, &rwr, &bad_rwr);
> +	if (ret) {
> +		ibdev_err(&dev->ib_dev, "failed to drain recv queue: %d\n", ret);
> +		return;
> +	}
> +	xqp->post_recv_invalid =3D true;
> +
> +	if (cq->poll_ctx =3D=3D IB_POLL_DIRECT)
> +		while (wait_for_completion_timeout(&rdrain.done, HZ / 10) <=3D 0)
> +			ib_process_cq_direct(cq, -1);
> +	else
> +		xcq->xcq.comp(&xcq->xcq);
> +	wait_for_completion(&rdrain.done);
> +}
> +
> +void xsc_ib_drain_sq(struct ib_qp *qp)
> +{
> +	struct ib_cq *cq =3D qp->send_cq;
> +	struct xsc_ib_cq *xcq =3D to_xcq(cq);
> +	struct xsc_ib_qp *xqp =3D to_xqp(qp);
> +	struct ib_qp_attr attr =3D { .qp_state =3D IB_QPS_ERR };
> +	struct xsc_ib_drain_cqe sdrain;
> +	const struct ib_send_wr *bad_swr;
> +	const struct ib_send_wr swr =3D {
> +		.next =3D NULL,
> +		{ .wr_cqe	=3D &sdrain.cqe, },
> +		.opcode	=3D IB_WR_RDMA_WRITE,
> +		.send_flags =3D IB_SEND_SIGNALED,
> +	};
> +	int ret;
> +	struct xsc_ib_dev *dev =3D to_xdev(qp->device);
> +
> +	ret =3D ib_modify_qp(qp, &attr, IB_QP_STATE);
> +	if (ret) {
> +		ibdev_err(&dev->ib_dev, "failed to drain send queue: %d\n", ret);
> +		return;
> +	}
> +
> +	sdrain.cqe.done =3D xsc_ib_drain_sq_done;
> +	init_completion(&sdrain.done);
> +
> +	ret =3D xsc_ib_post_send(qp, &swr, &bad_swr);
> +	if (ret) {
> +		ibdev_err(&dev->ib_dev, "failed to drain send queue: %d\n", ret);
> +		return;
> +	}
> +	xqp->post_send_invalid =3D true;
> +
> +	if (cq->poll_ctx =3D=3D IB_POLL_DIRECT)
> +		while (wait_for_completion_timeout(&sdrain.done, HZ / 10) <=3D 0)
> +			ib_process_cq_direct(cq, -1);
> +	else
> +		xcq->xcq.comp(&xcq->xcq);
> +	wait_for_completion(&sdrain.done);
> +}

[Severity: High]
Can xsc_ib_drain_rq() and xsc_ib_drain_sq() hang when waiting for the drain
completion?

1. When cq->poll_ctx =3D=3D IB_POLL_DIRECT, wait_for_completion_timeout() i=
n the
   while loop condition consumes rdrain.done / sdrain.done when it returns a
   positive value, and then the unconditional wait_for_completion() after t=
he
   if/else block waits a second time on the already-consumed completion.
   Additionally, ib_modify_qp() transitions the QP to IB_QPS_ERR, which cal=
ls
   xsc_ib_trigger_cq_comp_handler() and triggers the WARN_ONCE() in
   ib_cq_completion_direct() for IB_POLL_DIRECT CQs.

2. For IB_POLL_SOFTIRQ CQs, ib_modify_qp() schedules cq->iop before the dra=
in
   WR is posted. If ib_poll_handler() finishes polling before the drain WR =
is
   posted, and xcq->xcq.comp(&xcq->xcq) runs before ib_poll_handler() calls
   irq_poll_complete(), irq_poll_sched() is a no-op while IRQ_POLL_F_SCHED =
is
   still set. When ib_poll_handler() then calls ib_req_notify_cq() ->
   xsc_ib_arm_cq(), xsc_cqe_is_empty() only checks hardware CQEs via
   get_sw_cqe() and ignores software flush entries on cq->err_state_qp_list,
   so cq->iop is never rescheduled and wait_for_completion() hangs.

3. If the SQ or RQ is already full when drain is called, xsc_wq_overflow() =
in
   xsc_ib_post_send() / xsc_ib_post_recv() will reject the drain WR with
   -ENOMEM and return early without draining the queue.

> diff --git a/drivers/infiniband/hw/xsc/xsc_ib.h b/drivers/infiniband/hw/x=
sc/xsc_ib.h
> index 126fcf7892a12..fe111b2c61370 100644
> --- a/drivers/infiniband/hw/xsc/xsc_ib.h
> +++ b/drivers/infiniband/hw/xsc/xsc_ib.h
[ ... ]
> @@ -402,6 +407,23 @@ static inline enum ib_mtu xsc_net_to_ib_mtu(unsigned=
 int mtu)
>  		return 0;
>  }
> =20
> +/*
> + * MMIO doorbells and MAD payloads are accessed by the CPU, so the driver
> + * needs the kernel virtual address behind a DMA address.  There is no s=
uch
> + * conversion API, so the address space is classified once at probe time=
 and
> + * the matching trick is used:
> + *
> + *   NORMAL  - an IOMMU DMA domain is attached; iova_to_phys() is availa=
ble.
> + *   DISABLE - no IOMMU translation, DMA address =3D=3D physical address.
> + *   UNKNOWN - address translation exists but is not owned by the IOMMU
> + *             layer (forced software bounce buffering, or a hypervisor =
that
> + *             translates DMA addresses), so neither trick works.
> + *
> + * UNKNOWN is not supported: MAD and doorbell traffic cannot be addresse=
d by
> + * the CPU there, and QP1 (SMI/GSI) creation is refused as a result, whi=
ch
> + * disables SA/CM on such a system.  Systems with an IOMMU or without any
> + * translation are unaffected.
> + */

[Severity: Low]
This comment states that QP1 (SMI/GSI) creation is refused when the IOMMU
state is UNKNOWN, but xsc_ib_create_qp() in drivers/infiniband/hw/xsc/qp.c
does not check dev->iommu_state and instead allows QP1 creation to succeed,
failing later in xsc_ib_post_send() and xsc_handle_rdma_mad_resp_recv().

Should either xsc_ib_create_qp() reject IB_QPT_GSI when dev->iommu_state =
=3D=3D
XSC_IB_IOMMU_MAP_UNKNOWN_DOMAIN, or this comment be updated to match the co=
de?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104155650.3705=
3-1-tianx@yunsilicon.com?part=3D14
