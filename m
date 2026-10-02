Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B474657F5
	for <linux-rdma@vger.kernel.org>; Fri,  2 Oct 2026 09:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790932384; cv=none; b=p6U7hhExaIQ5SIL64UQIgyHfORmGDSwY/Ov0+Sm54uVgp3L7tNGWHM4K3VWBA3lDrZqGtlUNTBM2edkV2hUMTcAWhXPyv8YST4LkGzwqqH3x2desu3tT70HEFPmLofnkwauNY4U9G1PCr+lal7EmdkbF6FUD+zHgLawC5VVogtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790932384; c=relaxed/simple;
	bh=n2+VPZDBJkPZ+TIX0KQEiad0fOp5iHYsgow+Zz804N4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Pht9kMZNYy0frcLcvbH7U7nGVVmNDPpI38nsoWLG9lArHv2GOeV2JW64MZKoA+s3//Ozfx8DFBgeBZS7RDVzD3omo28dbTjAzqQM4mNzNRYNSiLfJ3Hb8oBOkeL2wWwlelgLzYkRA6JE3dLZijtABqWnh4glKRl5SZm89TeI8o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P001jx3D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P001jx3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318241F00899;
	Fri,  2 Oct 2026 09:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790932383;
	bh=+n6nd7pe4b+FLK/IAOPt/UEiBcypl7LPohpIG0M3kNE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P001jx3D4W8SOM8Y2Ndl55vJwSXiwV/s4Sm3ixXHfb7crgu1eGVH3OJ1uGHTghXem
	 Te75AXnko7SyoTenAMFGdU3FMuH0AYOXmCy6guKVX0NZS/P9+1ATLJFAaEW0K27zeF
	 yxq7aLLJMbfLbPANWEcwlxn0uclB8JmDMzgB96w63WKoKs3VVAYKBy77Az6XbI/uPF
	 LMhWwxEHPgzsSARbxeeFonjsXnx/y046mBtAgPgDzeq5/JQ4Y7tQOFeMhY+yhwk3E4
	 ws4N53+wyw0kLNDYIyeSDcgCrBmgRLOknSTDo79P69KBFF+7IXo1uuV6NhM318XFy8
	 MxFjcK6yEWG3g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 07/10] RDMA/mana_ib: Poll RC completions using
 PSN and FSN progress
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261001182015.1757203-8-kotaranov@linux.microsoft.com>
References: <20261001182015.1757203-1-kotaranov@linux.microsoft.com>
 <20261001182015.1757203-8-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 02 Oct 2026 09:13:02 +0000
Message-Id: <20261002091303.318241F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] rdma/mana_ib: interrupt storm from psn+1 arming on unsignaled WQEs
--

commit f323a2eb29a1338a158b3fde42ecaf1e6e1cc432
Author: Konstantin Taranov <kotaranov@microsoft.com>
Subject: RDMA/mana_ib: Poll RC completions using PSN and FSN progress

This commit decodes RC receive completions, armed-PSN notifications, and
MMQ completions. It retires requester and MMQ shadow entries using sequence
numbers, honors cross-queue fence dependencies, and suppresses successful W=
Cs
for unsignaled work requests.

> diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana=
/cq.c
> index 843e2c64b32bc..0ceb67ed62afa 100644
> --- a/drivers/infiniband/hw/mana/cq.c
> +++ b/drivers/infiniband/hw/mana/cq.c
[ ... ]
> @@ -422,17 +422,104 @@ static void handle_rq_cqe(struct mana_ib_qp *qp, s=
truct gdma_comp *cqe,
[ ... ]
> +static bool handle_psn_cqe(struct mana_ib_qp *qp, u32 psn,
> +			   struct mana_cq_poll *poll)
> +{
> +	struct mana_ib_dev *mdev =3D container_of(qp->ibqp.device, struct mana_=
ib_dev, ib_dev);
> +	struct shadow_wqe_header *shadow_wqe;
> +	struct gdma_queue *recv_q;
> +	bool consumed;
> +	u32 arm_psn;
> +
> +	if (qp->ibqp.qp_type !=3D IB_QPT_RC)
> +		return true;
> +
> +	recv_q =3D qp->rc_qp.queues[MANA_RC_RECV_QUEUE_REQUESTER].kmem;
> +
> +	consumed =3D mana_advance_send(qp, false, psn, poll);
> +	if (consumed) {
> +		shadow_wqe =3D shadow_queue_get_next_to_signal(&qp->shadow_sq);
> +		arm_psn =3D shadow_wqe ? shadow_wqe->wqe_offset_or_psn : psn + 1;
> +		mana_gd_wq_ring_doorbell_ext(mdev_to_gc(mdev), recv_q, arm_psn,
> +					     SET_ARM_BIT, MANA_PSN_CLIENT_OFFSET);
> +	}
> +
> +	return consumed;
> +}

[Severity: High]
Does unconditionally arming psn + 1 here when shadow_wqe is NULL trigger an
interrupt storm?

When processing an ARMED_CMPL CQE here in handle_psn_cqe(), if there are no
pending signaled WQEs (because shadow_queue_get_next_to_signal() skips over
unsignaled ones and returns NULL), the driver unconditionally arms psn + 1.

The hardware then generates a CQE for the very next packet. handle_psn_cqe()
will process this, find no signaled WQEs again, and arm psn + 2.

Does this cycle force the hardware to generate an interrupt and CQE for eve=
ry
single packet of every unsignaled WQE, defeating the unsignaled optimizatio=
n?

Could arming logic be initiated during post_send() when a signaled WQE is
posted, rather than relying on sequential fallback in the completion handle=
r?

> diff --git a/drivers/infiniband/hw/mana/shadow_queue.h b/drivers/infiniba=
nd/hw/mana/shadow_queue.h
> index b5d6bb28bd452..9abf390cf3a30 100644
> --- a/drivers/infiniband/hw/mana/shadow_queue.h
> +++ b/drivers/infiniband/hw/mana/shadow_queue.h
[ ... ]
> @@ -105,4 +108,23 @@ static inline void shadow_queue_advance_consumer(str=
uct shadow_queue *queue)
>  	smp_store_release(&queue->cons_idx, queue->cons_idx + 1);
>  }
> =20
> +static inline struct shadow_wqe_header *
> +shadow_queue_get_next_to_signal(struct shadow_queue *queue)
> +{
> +	struct shadow_wqe_header *wqe =3D NULL;
> +	/* Inspect only entries that have been fully published by posting. */
> +	u64 prod_idx =3D smp_load_acquire(&queue->prod_idx);
> +
> +	queue->next_to_signal_idx =3D max(queue->next_to_signal_idx,
> +					queue->cons_idx);
> +	while (queue->next_to_signal_idx < prod_idx) {
> +		wqe =3D shadow_queue_get_element(queue, queue->next_to_signal_idx);
> +		queue->next_to_signal_idx++;
> +		if (!(wqe->flags & MANA_WQ_NO_SIGNAL_WC))
> +			return wqe;
> +	}
> +
> +	return NULL;
> +}

[Severity: High]
Since this loop skips unsignaled WQEs and returns NULL when only unsignaled
WQEs are pending, does it force the fallback psn + 1 arming behavior in
handle_psn_cqe() mentioned above?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001182015.1757=
203-1-kotaranov@linux.microsoft.com?part=3D7
