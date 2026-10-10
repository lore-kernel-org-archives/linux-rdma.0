Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B60742AA9
	for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 07:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791616541; cv=none; b=lPrZ5l2QPiPphExfHQLUUG3tDX4eYOliqagB9tk5CRMIitGRloeV+hz2/jS6IRjVKvqQOjelj47BakDQtM3Ex6UHJovqbM/a70AJaeSMVkegqAWSQ63pAbsL7uDMgBDm7jsG13+jgTFFnr2IJM0a+BINeA5a+MFZ7yoRiey6tag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791616541; c=relaxed/simple;
	bh=b1gpTEjR1SuO8kt6VhlCD2mnIeg7oe4kvzwFBPmpOK0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=n9nRieHkypgSmbvj8Ix7547pWdbyS4V9S1ogWaI0k7i0xBzLdHvGhNsdC1w1kBzZ+K5i/MWB0uPQnsLtrrrvUZHnpXmrxAk32EOqOhw11i1huabaGepyGFFrfZN3EkGTDe7V979PfWFVT8R+IYuo91AM8ei+ioB4bRkdH6ZmDTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Igec1nXK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Igec1nXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C221F000FF;
	Sat, 10 Oct 2026 07:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791616539;
	bh=vPunYP22Os+AS80GlBbE1ukJdZC1I0QhLqADdP36GtQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Igec1nXKcOjTVw9hOJ9vhZnG0rmkmlFdpLHNfdtmWkYjyfu8DNSj8B/TQuYnDTou5
	 DMnQajHoyWfTJ+i8JIGW7HMMumK0sQVJCqD2ANpdz6X7trneBVyunROoI6PEnxnbCR
	 Lp8dT3rBDM4j44zeDMuKF15MvsfRGW7srUXqN6TqLYgWEW7EjAcO1+xmCkUWR2JN9f
	 Q9pqMIfk2B79/7i34qGUrOxLgzEN6Oq3j8TsPYfZ+YP6Cxol3ShvRhz698By1VRvgE
	 VvCQCWRp0PcymsZlxtXKf7o5t7mWzAaxSXTWyBobQx381NHUwT84NphfQeSWIMwfHX
	 VhjZU+qkH8KkQ==
Message-ID: <sashiko-outbox-166307@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v4 06/10] RDMA/mana_ib: Post send and
 memory-management WRs on RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261010065443.3554193-7-kotaranov@linux.microsoft.com>
References: <20261010065443.3554193-1-kotaranov@linux.microsoft.com>
 <20261010065443.3554193-7-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 10 Oct 2026 07:15:38 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] rdma/mana_ib: integer overflow in msg_sz causes silent data corrup=
tion
- [High] rdma/mana_ib: shadow queue stall due to leaked unsignaled MMQ WQEs
- [High] rdma: mana_ib: shadow queue leak on unsignaled fenced WQEs
--

commit b07a49d6904077b337ee7637a4f192e98b247c4a
Author: Konstantin Taranov <kotaranov@microsoft.com>
RDMA/mana_ib: Post send and memory-management WRs on RC QPs

This commit implements send work request posting for RC QPs. It posts
communication WRs to the send queue and memory WRs to the memory
management queue.

> diff --git a/drivers/infiniband/hw/mana/wr.c b/drivers/infiniband/hw/mana=
/wr.c
> index 5d42af91fce4a..6cc67537c6557 100644
> --- a/drivers/infiniband/hw/mana/wr.c
> +++ b/drivers/infiniband/hw/mana/wr.c
[ ... ]
> @@ -224,6 +289,287 @@ static int mana_ib_post_send_ud(struct mana_ib_qp *=
qp, const struct ib_send_wr *
>  	return err;
>  }
> =20
> +static int mana_ib_post_sq(struct mana_ib_qp *qp, const struct ib_send_w=
r *wr)
> +{
[ ... ]
> +	u32 msg_sz =3D 0;
> +	int err, i;
> +
> +	if (shadow_queue_full(&qp->shadow_sq))
> +		return -ENOMEM;
> +
> +	if (wr->num_sge > MAX_TX_WQE_SGL_ENTRIES)
> +		return -EINVAL;
> +
> +	for (i =3D 0; i < wr->num_sge; i++)
> +		msg_sz +=3D wr->sg_list[i].length;

[Severity: High]
Does this loop overflow msg_sz if a userspace application posts an RDMA
READ/WRITE or SEND WR with a total SGL length exceeding 4GB?

The IB core does not validate total SGL length, so drivers usually enforce
their own hardware limits.

[ ... ]
> +	switch (wr->opcode) {
> +	case IB_WR_SEND_WITH_INV:
[ ... ]
> +	case IB_WR_RDMA_WRITE_WITH_IMM:
> +		send_oob.immediate_ext =3D cpu_to_le32(be32_to_cpu(wr->ex.imm_data));
> +		fallthrough;
> +	case IB_WR_RDMA_WRITE:
> +	case IB_WR_RDMA_READ:
> +		send_oob.rdma.address_hi =3D upper_32_bits(rdma_wr(wr)->remote_addr);
> +		send_oob.rdma.address_low =3D lower_32_bits(rdma_wr(wr)->remote_addr);
> +		send_oob.rdma.rkey =3D rdma_wr(wr)->rkey;
> +		send_oob.rdma.dma_len =3D msg_sz;

If msg_sz overflows, would this instruct the hardware to silently truncate
the transfer while completing with success?

[ ... ]
> +	err =3D mana_gd_post_work_request(sq, &wqe_req, &wqe_info);
> +	if (err)
> +		return err;
> +
> +	shadow_wqe->wr_id =3D wr->wr_id;
> +	shadow_wqe->send_opcode =3D convert_wr_to_wc(wr->opcode);
> +	if (!signaled)
> +		shadow_wqe->flags |=3D MANA_WQ_NO_SIGNAL_WC;
> +	else if ((wr->send_flags & IB_SEND_FENCE) || qp->pending_mmq_fence)
> +		shadow_wqe->flags |=3D MANA_WQ_FENCE_WC;

[Severity: High]
Does the else if prevent an unsignaled work request from recording its
fence dependency in the shadow queue?

The RDMA verb API allows posting unsignaled WQEs that have fencing
requirements (either explicitly via IB_SEND_FENCE or implicitly via
pending_mmq_fence).

If MANA_WQ_FENCE_WC is missing on an unsignaled fenced WQE, it seems
the CQ polling logic won't evaluate the fence dependency. Could this leave
dependent WQEs leaked in the fixed-size shadow queue, eventually leading
to -ENOMEM failures?

> +	shadow_wqe->wqe_offset_or_psn =3D qp->sq_psn + mana_count_packets(msg_s=
z, qp->mtu);

Also related to the msg_sz overflow above, could the wrapped msg_sz
cause the software PSN to be advanced by a smaller amount than the hardware
transmits, desynchronizing the software PSN from the hardware PSN and
tearing down the QP?

[ ... ]
> +static int mana_ib_post_mmq(struct mana_ib_qp *qp, const struct ib_send_=
wr *wr)
> +{
[ ... ]
> +	shadow_wqe->wr_id =3D wr->wr_id;
> +	shadow_wqe->send_opcode =3D convert_wr_to_wc(wr->opcode);
> +	if (!signaled)
> +		shadow_wqe->flags |=3D MANA_WQ_NO_SIGNAL_WC;
> +	else if (wr->send_flags & IB_SEND_FENCE)
> +		shadow_wqe->flags |=3D MANA_WQ_FENCE_WC;

[Severity: High]
Does this else if block similarly prevent an unsignaled fenced WQE on
the MMQ from recording its fence dependency?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261010065443.3554=
193-1-kotaranov@linux.microsoft.com?part=3D6
