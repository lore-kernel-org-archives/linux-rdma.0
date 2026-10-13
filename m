Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DAF4F3EA3
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 11:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791891976; cv=none; b=dfJdRK/Ob2eik2BK0ARqWgeygGVWOJgfNtVzc3pEZ9+q/HQ8lNziYYubYUPbjN8Fe/2tF+39Ns++q8XNubhsRABY//urfEqwlxNV9jTA+MqPVfqc3L5vM4mLllZmfLGpiKLNKW/MKh7PYOBXh1V4pJinlVjenu+1FyC3rO7T45M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791891976; c=relaxed/simple;
	bh=j/1jesqEh+icJ35iuYYWe4Zd4A3rXSHojbv8r47XCV0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=N/RLwcrtfR8/e8BTaPLMHb88TcHQKR8VMBcTaOvMm1WaBmlZZm3muIIrFzYalYay537SXiYBzQ4xC/YWF2Na1yaNmNVpgXkeq9CHl/Y9a+Yw1AhVs4LsUUrRHoQ4gZ9Yo+VeZtmvQeP1eLFD9laWDpbhFUHJk9H9BPxtPX/kvb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MWC4QOS6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MWC4QOS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8DF81F00893;
	Tue, 13 Oct 2026 11:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791891975;
	bh=29oPmVYibWsaIBXdva8/Fyo0BjT88vaXqBT8+EcKY7k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MWC4QOS6ajg75+JqVlTAsDbO64UzvE9EwP8BAL/hILc9s3/7kwbiwx0cah9AqaGXR
	 97KLaaoiYHdnBg6zY/992X9pOaZ3jDcn7ycFmuKpW/aLs5agTxE/egpzY5ZOw56z1S
	 V5ifpphZTqZ1LPrB4v6xNkvdmpeJ99eLl8vM9Yz7N+C3qRW6ektBfXR7IJR07Lk5q7
	 Is0b7crOdG0oKSMct1D+PimDGYsqusK8icmuAZe6wNBOUHWX714b55TJfYsrPbl5ci
	 tpcIZEQGjAQ2TVLCb5VFK+qMim3tpp1roBU1Eo0hky9hYml26Wk/IJeg0QSl1w5qLr
	 x/ANrISvfAsKw==
Message-ID: <sashiko-outbox-169651@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 13/15] yunsilicon: add the RDMA send path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261012114423.2471317-14-tianx@yunsilicon.com>
References: <20261012114352.2471317-1-tianx@yunsilicon.com>
 <20261012114423.2471317-14-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 11:46:14 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 18 potential issue=
(s) to consider:
- [Critical] rdma: inline data payload overwrites remote address segment in=
 RDMA Read/Write
- [Critical] rdma: hardware DMA buffer overflow due to overriding SGE lengt=
h with maximum MTU
- [High] rdma: silent drop of remaining WRs in chain on zero-length RDMA RE=
AD
- [High] rdma: stack use-after-free in xsc_ib_drain_rq_done and xsc_ib_drai=
n_sq_done
- [High] rdma: stack out-of-bounds read and kernel panic during UD QP drain
- [High] rdma: unaligned 32-bit pointer assignment causes kernel panics
- [High] rdma: uninitialized receive WQE segments leave hardware exposed to=
 stale physical addresses
- [High] rdma: early return in QP drain routines causes Use-After-Free by b=
reaking synchronous drain contract
- [High] rdma: set_data_inl_seg buffer overflow and RAddr segment corruption
- [High] rdma/xsc: buffer overflow and data corruption in set_data_inl_seg =
for multiple inline SGEs
- [High] xsc: wild pointer dereference in xsc_ib_drain_sq() for UD QPs
- [High] xsc: silent data loss when posting zero-length RDMA READ in a chain
- [Medium] rdma: unaligned multi-byte memory accesses on stack array in xsc=
_icrc_hdr
- [Medium] rdma: read-modify-write on DMA memory and uninitialized WQE cont=
rol fields
- [Medium] rdma: xsc_icrc_hdr unconditionally adds UDP header size, breakin=
g RoCEv1 packets
- [Medium] rdma/xsc: QP drain routines deadlock on IB_POLL_DIRECT CQs
- [Low] rdma: xsc_icrc_hdr returns negative error code for unsigned return =
type
- [Low] xsc: global namespace pollution by redefining struct rxe_bth
--

commit fdfdd79a8a3fbba8cb02ffc2535c12c0197fac66
Author: Xin Tian <tianx@yunsilicon.com>
Subject: yunsilicon: add the RDMA send path

This commit introduces the RDMA send path for the Yunsilicon XSC driver.=20
It implements the work request processing for various operation types,=20
QP1 MAD header construction, doorbell updates, and completion queue drains.

> diff --git a/drivers/infiniband/hw/xsc/qp.c b/drivers/infiniband/hw/xsc/q=
p.c
> index 6a83adc9c833f..9c79e09a7fd1f 100644
> --- a/drivers/infiniband/hw/xsc/qp.c
> +++ b/drivers/infiniband/hw/xsc/qp.c
[ ... ]
> +static int set_data_inl_seg(struct xsc_ib_qp *qp, const struct ib_send_w=
r *wr, void *ctrl)
> +{
> +	struct xsc_wqe_data_seg *data_seg;
> +	unsigned int seg_index;
> +	void *addr;
> +	int len;
> +	int i;
> +
> +	for (i =3D 0, seg_index =3D 1; i < wr->num_sge; ++i, ++seg_index) {
> +		if (likely(wr->sg_list[i].length)) {
> +			addr =3D (void *)wr->sg_list[i].addr;
> +			len  =3D wr->sg_list[i].length;
> +
> +			if (unlikely(len > qp->max_inline_data))
> +				return -ENOMEM;
> +
> +			data_seg =3D get_seg_wqe(ctrl, seg_index);
> +			data_seg->in_line =3D 1;
> +			data_seg->len =3D len;
> +			memcpy(data_seg->in_line_data, addr, len);
> +		}
> +	}
> +
> +	return 0;
> +}

[Severity: Critical]
By hardcoding seg_index =3D 1 here, does this overwrite the remote address=
=20
(RAddr) segment for RDMA Write and Read requests? xsc_ib_post_send appears=
=20
to place the RAddr at seg_index =3D 1 right before invoking this inline dat=
a=20
logic.

Additionally, since seg_index is only incremented by 1 per SGE, what happen=
s=20
if an inline SGE is larger than 16 bytes? The memcpy will spill across=20
multiple hardware WQE segments, but the loop will write the next SGE's data=
=20
at seg_index + 1, overwriting the tail of the previous SGE's payload.=20

Finally, the bounds check len > qp->max_inline_data only checks each SGE=20
individually. If wr->num_sge > 1, does the sum of the SGE lengths overflow=
=20
the pre-allocated WQE slot boundary and corrupt adjacent WQEs in the SQ=20
ring buffer?

[ ... ]
> +static u32 xsc_icrc_hdr(struct xsc_ib_dev *dev, void *pkt, u32 size, u32=
 *icrc)
> +{
> +	struct iphdr *ip4h =3D NULL;
> +	struct ipv6hdr *ip6h =3D NULL;
> +	struct udphdr *udph;
> +	struct ib_unpacked_eth *eth;
> +	struct rxe_bth *bth;
> +	struct ib_unpacked_deth *deth;
> +	struct ib_unpacked_vlan *vlan;
> +	int crc;
> +	int crc_field_len;
> +	__be16 l3_type;
> +	u8 *l3_start;
> +
> +	int hdr_size;
> +
> +	/* pseudo header buffer size is calculate using ipv6 header size since
> +	 * it is bigger than ipv4
> +	 */
> +	u8 pshdr[sizeof(struct udphdr) +
> +		sizeof(struct ipv6hdr) +
> +		sizeof(*bth) + sizeof(*deth)];

[Severity: Medium]
Since pshdr is allocated as a byte array (u8) on the stack, it is only=20
guaranteed to be 1-byte aligned. Does casting this buffer to struct iphdr *=
=20
and struct rxe_bth * and performing multi-byte writes trigger alignment=20
traps on architectures with strict memory alignment requirements?

[Severity: Low]
This function internally uses struct rxe_bth and struct rxe_deth. Does=20
using another software driver's prefix (rxe_) pollute the global structure=
=20
namespace and cause BTF deduplication conflicts? Should it use standard=20
RDMA core structures like ib_unpacked_bth instead?

> +
> +	eth =3D pkt;
> +
> +	if (eth->type =3D=3D htons(ETH_P_8021Q)) {
> +		vlan =3D (struct ib_unpacked_vlan *)(eth + 1);
> +		l3_type =3D vlan->type;
> +		l3_start =3D (u8 *)(vlan + 1);
> +		size -=3D 4;
> +	} else {
> +		l3_type =3D eth->type;
> +		l3_start =3D (u8 *)(eth + 1);
> +	}
> +
> +	hdr_size =3D sizeof(struct udphdr) +
> +		(l3_type =3D=3D htons(ETH_P_IP) ?
> +		sizeof(struct iphdr) : sizeof(struct ipv6hdr));
> +
> +	crc_field_len =3D hdr_size + sizeof(*bth) + sizeof(*deth);
> +
> +	if (crc_field_len !=3D size) {
> +		ibdev_err(&dev->ib_dev, "Unmatched hdr: expect %d actual %d\n",
> +			  crc_field_len, size);
> +		return -EINVAL;
> +	}

[Severity: Low]
Does returning -EINVAL from a function returning u32 implicitly cast the=20
error code to a large positive integer, making it difficult for callers=20
to properly check for errors?

[Severity: Medium]
Does hdr_size unconditionally adding sizeof(struct udphdr) break support=20
for RoCEv1 (IBoE) packets? For RoCEv1, there is no UDP header, meaning=20
crc_field_len !=3D size will always evaluate to true, rejecting the packet.

[ ... ]
> +static void zero_send_ds(struct xsc_ib_qp *qp, int idx)
> +{
> +	void *seg;
> +	int i;
> +	int ds_num;
> +	u64 *p;
> +
> +	ds_num =3D XSC_SEND_SEG_NUM << (qp->sq.wqe_shift - XSC_SEND_WQE_SHIFT);
> +	seg =3D (void *)xsc_get_send_wqe(qp, idx);
> +	for (i =3D 1; i < ds_num; i++) {
> +		p =3D get_seg_wqe(seg, i);
> +		p[0] =3D 0;
> +		p[1] =3D 0;
> +	}
> +}

[Severity: Medium]
Since this loop explicitly starts at i =3D 1, the control segment (i =3D 0)=
 is=20
left uninitialized. Later in xsc_ib_post_send, the driver modifies bitfield=
s=20
(ctrl->se, ctrl->ce) on this uninitialized memory. Does this perform unsafe=
=20
read-modify-write operations on DMA-mapped memory and leave unassigned=20
fields with stale values from previous work requests?

[ ... ]
> +		if (unlikely(wr->opcode =3D=3D IB_WR_RDMA_READ && msg_len =3D=3D 0)) {
> +			ibdev_err(&dev->ib_dev, "rdma read, msg len should not be 0\n");
> +			/* workaround, return success for posting zero-length read */
> +			err =3D 0;
> +			goto out;
> +		}

[Severity: High]
Does this workaround silently drop the current work request and any remaini=
ng=20
linked work requests in the wr->next chain? By returning success without=20
generating completion entries for the dropped WRs, ULPs will hang=20
indefinitely waiting for them. Zero-length RDMA READs are explicitly valid=
=20
in the RDMA specification.

[ ... ]
> +			crc =3D xsc_crc32(dev, crc, mad_send_base + sg.length, ctrl->msg_len);
> +			ctrl->msg_len +=3D sg.length;
> +			seg_index++;
> +
> +			*(u32 *)&mad_send_base[ctrl->msg_len] =3D ~crc;

[Severity: High]
Since ctrl->msg_len might not be 4-byte aligned, will this direct pointer=20
cast and assignment cause unaligned 32-bit writes? Architectures lacking=20
hardware support for unaligned access will panic here. Should this use=20
put_unaligned instead?

[ ... ]
> +		for (i =3D 0; i < wr->num_sge; ++i) {
> +			if (unlikely(!wr->sg_list[i].length))
> +				continue;
> +			data_seg =3D get_seg_wqe(recv_head, i);
> +			data_seg->in_line =3D 0;
> +			WR_LE_64(data_seg->va, wr->sg_list[i].addr);
> +			WR_LE_32(data_seg->mkey, wr->sg_list[i].lkey);
> +			if (is_qp1(qp->xqp.qp_type))
> +				WR_LE_32(data_seg->seg_len, xdev->caps.rx_pkt_len_max);
> +			else
> +				WR_LE_32(data_seg->seg_len, wr->sg_list[i].length);
> +		}

[Severity: High]
If an SGE length is 0, the loop skips it via continue, failing to initializ=
e=20
the corresponding WQE segment. Because receive WQEs are reused from a ring=
=20
buffer without zeroing, does this leave stale memory keys and physical=20
addresses for the hardware to process, potentially DMAing incoming data=20
into arbitrary memory?

[Severity: Critical]
For QP1 (GSI), the driver unconditionally overrides the consumer-provided=20
buffer length (wr->sg_list[i].length) with the global max packet length=20
xdev->caps.rx_pkt_len_max. Does this instruct the hardware that it can DMA=
=20
data far beyond the actual bounds of the software-allocated scatter/gather=
=20
buffer, causing memory corruption?

[ ... ]
> +static void xsc_ib_drain_rq_done(struct ib_cq *cq, struct ib_wc *wc)
> +{
> +	struct xsc_ib_drain_cqe *cqe =3D container_of(wc->wr_cqe,
> +						     struct xsc_ib_drain_cqe, cqe);
> +	struct xsc_ib_dev *dev =3D to_xdev(cq->device);
> +
> +	complete(&cqe->done);
> +	ibdev_dbg(&dev->ib_dev, "QP %d ib_drain_rq done!", cqe->qpn);
> +}

[Severity: High]
Since cqe is allocated on the stack in xsc_ib_drain_rq, the moment=20
complete(&cqe->done) is called, the blocked thread can wake up and destroy=
=20
the stack frame. Does the subsequent access to cqe->qpn dereference a=20
potentially freed stack pointer, causing a use-after-free race? The same=20
pattern is present in xsc_ib_drain_sq_done.

[ ... ]
> +void xsc_ib_drain_sq(struct ib_qp *qp)
> +{
[ ... ]
> +	const struct ib_send_wr swr =3D {
> +		.next =3D NULL,
> +		{ .wr_cqe	=3D &sdrain.cqe, },
> +		.opcode	=3D IB_WR_RDMA_WRITE,
> +		.send_flags =3D IB_SEND_SIGNALED,
> +	};
[ ... ]
> +	ret =3D xsc_ib_post_send(qp, &swr, &bad_swr);
> +	if (ret) {
> +		ibdev_err(&dev->ib_dev, "failed to drain send queue: %d\n", ret);
> +		return;
> +	}
> +	xqp->post_send_invalid =3D true;
> +
> +	xcq->xcq.comp(&xcq->xcq);
> +	wait_for_completion(&sdrain.done);
> +}

[Severity: High]
For UD QPs, xsc_ib_post_send unconditionally forwards this dummy WR to=20
build_qp1_send_v2. Because swr is allocated purely as a base struct=20
ib_send_wr, when build_qp1_send_v2 casts it to struct ib_ud_wr and=20
dereferences ud_wr(wr)->ah, won't this read out-of-bounds stack garbage=20
and cause a kernel panic?

[Severity: High]
The RDMA API requires the drain functions to block until all in-flight WQEs=
=20
complete. By returning early when xsc_ib_post_send fails, does this break=20
the synchronous drain contract, allowing the ULP to free memory while the=20
hardware is still asynchronously processing in-flight WQEs?

[Severity: Medium]
If the CQ uses IB_POLL_DIRECT, there is no background task polling it. Will=
=20
wait_for_completion block indefinitely unless a concurrent thread happens t=
o=20
poll the CQ? The core RDMA layer fallback handles this by calling=20
ib_process_cq_direct(cq, -1) in a loop. Additionally, unconditionally calli=
ng=20
xcq->xcq.comp(&xcq->xcq) will trigger a warning in ib_cq_completion_direct.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012114352.2471=
317-1-tianx@yunsilicon.com?part=3D13
