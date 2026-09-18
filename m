Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21333AD52D
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 14:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789741241; cv=none; b=GY42/wCXTZN5v9uDHtUOP1063wavGMpCAAcT/ZBuyCp+YUWDGJNyETP+h0AtW1A1Mn5g6pwcTC0fdu/Z2GStl12EJp/mzJzyzsv314LbbrWNv6YL9Xo6fqeCUIQOGJ7ow8pZWkFwp+l8ow30yefOFGJG5WNGSE6GjsbazOiR8vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789741241; c=relaxed/simple;
	bh=Qj7hnpX+uxhHOKYM6lh0FkinQnhcKzVo1KEERbWnx0k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FXjPKqluMT0D9JYgS2QYJV59PsjaJTOUINkPmt+8N8k6PRmzkhSeI3yCLnHcON27CK0S5vys4dEe5BQMDgqpMgXIEFVoJxMrdRqIs8Yu4N90DN96WsgSC84KTzAcPjVYiGvJ4Jcx4371l4194I6MB+pk86A2Y3simHPGfj7low0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l7mAslSw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l7mAslSw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5964D1F00898;
	Fri, 18 Sep 2026 14:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789741239;
	bh=OxwqC9V7zkypVk7wzS+F7DuEjgwBjxdvVSN+aKbmkR8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l7mAslSwOt7ICnRJlX7ocZo6hZbz+B15glx5QdpuOAft/Vmfn0SzMLx9eDhByvZHb
	 magRK1khcBLNsBePIDP22Xeb9fplsvIntTaF1KoWejiccpvY0CK7+789Nb81Tm+l/p
	 vlYKFJzRejqTf02/AQ0xf1ANIcCarroEQfz4WEatAAC1kHVG471AWq70ayLxQC2CDw
	 xkJb6ACmeRtHIK+zP+84g9ZKnFV0eUg8cBtZ0GeAv9fuIN99k3JWGw84LeTyTk8nYo
	 s/zAlBEKgLtf5W17FYObP5SXu9C4weN3Vlft+56m8nvag8swU/wRmE4VMLdJhNhPls
	 zBVRRFaXbROew==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 5/5] RDMA/mana_ib: Poll UD completions and
 flush software error QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260918140407.2922819-6-kotaranov@linux.microsoft.com>
References: <20260918140407.2922819-1-kotaranov@linux.microsoft.com>
 <20260918140407.2922819-6-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 14:20:38 +0000
Message-Id: <20260918142039.5964D1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] RDMA/mana_ib: Send Queue deadlock when handling unsignaled Work Re=
quests
--

commit d64ff9be78f7ee54ec40f144bfa6a3c96bf9df22
Author: Konstantin Taranov <kotaranov@microsoft.com>
RDMA/mana_ib: Poll UD completions and flush software error QPs

This commit updates the driver to build UD and GSI work completions directly
from each hardware CQE and shadow entry. It introduces a WC-budgeted poll
context and replaces the all-QP CQ membership list with persistent send and
receive error-QP lists.

> diff --git a/drivers/infiniband/hw/mana/wr.c b/drivers/infiniband/hw/mana=
/wr.c
> index eb671b45b2976..15faca66179d1 100644
> --- a/drivers/infiniband/hw/mana/wr.c
> +++ b/drivers/infiniband/hw/mana/wr.c
[ ... ]
> @@ -144,6 +145,7 @@ static int mana_ib_post_send_ud_one(struct mana_ib_qp=
 *qp, const struct ib_ud_wr
>  	memset(shadow_wqe, 0, sizeof(*shadow_wqe));
>  	shadow_wqe->wr_id =3D wr->wr.wr_id;
>  	shadow_wqe->wqe_size_in_bu =3D wqe_info.wqe_size_in_bu;
> +	shadow_wqe->wqe_offset_or_psn =3D wqe_info.wqe_offset;
>  	shadow_queue_advance_producer(&qp->shadow_sq);
> =20
>  	return 0;

[Severity: High]
Does this code lose track of which Work Requests were posted as unsignaled?

In mana_ib_post_send_ud_one(), shadow_wqe is zeroed out, but the
MANA_WQ_NO_SIGNAL_WC flag is never conditionally set in shadow_wqe->flags b=
ased
on the unsignaled status of the WR.

> diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana=
/cq.c
> index 6764e2de0c9f9..55d7a7d1cd69b 100644
> --- a/drivers/infiniband/hw/mana/cq.c
> +++ b/drivers/infiniband/hw/mana/cq.c
[ ... ]
> @@ -236,126 +288,156 @@ int mana_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq=
_notify_flags flags)
[ ... ]
> +static void handle_ud_sq_cqe(struct mana_ib_qp *qp, struct mana_rdma_cqe=
 *rdma_cqe,
> +			     struct mana_cq_poll *poll)
>  {
> +	struct shadow_wqe_header *wqe =3D shadow_queue_get_next_to_consume(&qp-=
>shadow_sq);
> +	u32 offset =3D rdma_cqe->ud_send.tx_wqe_offset & MANA_WQE_OFFSET_MASK;
> =20
> +	if (!wqe || wqe->wqe_offset_or_psn !=3D offset)
>  		return;
> =20
> +	mana_complete_send(qp, poll, rdma_cqe->ud_send.vendor_error);
>  }

[Severity: High]
Can this strict offset check cause the Send Queue to become permanently
deadlocked if the user posts an unsignaled Work Request?

When an unsignaled WR is posted and succeeds, the hardware will skip
generating a CQE for it. The next CQE generated will belong to a subsequent
signaled WR.

Because there is no loop here to advance the shadow queue past unsignaled W=
Rs,
wqe will continue to point to the older unsignaled WR, while offset belongs
to the newer signaled WR. This mismatch causes handle_ud_sq_cqe() to return
immediately. The CQE is discarded and the shadow queue is never advanced,
permanently stalling the queue.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918140407.2922=
819-1-kotaranov@linux.microsoft.com?part=3D5
