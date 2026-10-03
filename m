Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D2731E106
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 06:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791010445; cv=none; b=gG5f1uOLxX411Rdar6x6WCgLt12c5R9GWK5vITvzUVeZNw9EtDhD0OTF8f7weGPhjZefQAoBwFz79tWH0Jyw+ovrI8a5soAx3STmNUnlN3uti+dnCNMGvgESyZUorrmmkFSH1F05m0Je/EJEQsSyQKr+78lVp6+a81Q0CaKFn84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791010445; c=relaxed/simple;
	bh=rH5r4DOENEefkpGg8PFDBytWGXCLjc9+YZGdMvJY76Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iyd36bk5I8/spoiJ2pxM3ap7qNEXFcmStKkw9oIFsn7iE/milaU3A1s0nvR4sDbCqtfziCP1YkGnJPJK5Ky2lJ98hAWQrVM91EGrr0wYjj8DtoAetWyhMbNDzcBpEx8vOvGWVSJ7LFzV+BWxJrvsd6QDpRp9GU48k0u6WmlYtV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HXo5K3I0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HXo5K3I0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440381F0089B;
	Sat,  3 Oct 2026 06:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791010444;
	bh=YGst2tGymOdBiabvYzVcCTCK5AZ4FGR/2GNRoNncjec=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HXo5K3I0CVq/KDydmzy0Gn8c/ofR5E0ISCAmGHpOOZJ+uTs47/f/o6BfpLBf3chQS
	 vbbPh56UCKCHic1mFGOUd66BR8ztTt10BG8cjmjiup/0G/djIBb2gp0CU7TgK4DfA1
	 Pp/qMZSMu+RuB6wFhXPVL+u6dll53H2dVFH32/AS0GZep++t2Uuv3zZsVxGxie0HHr
	 jF3NF9KQFoZJNi2//G6+SVqD6lRtXVEnyT+KF0tetd45GVsib9YJOoknb99M1EwSBY
	 l0MIQHHMY0UO4VlpGv4mH58W+xCb5+3SuoHs1SPVB6D+6A/OaXDHKE5+zFnfOuh4sO
	 U1gfC3fOlWf8g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 07/10] RDMA/mana_ib: Poll RC completions
 using PSN and FSN progress
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261003064037.2092669-8-kotaranov@linux.microsoft.com>
References: <20261003064037.2092669-1-kotaranov@linux.microsoft.com>
 <20261003064037.2092669-8-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 06:54:03 +0000
Message-Id: <20261003065404.440381F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] rdma/mana_ib: unmasked 25-bit PSN passed to hardware doorbell
--

commit 19943f505ee2f816323601ebe8474e1ded5ddb62
Author: Konstantin Taranov <kotaranov@microsoft.com>

    RDMA/mana_ib: Poll RC completions using PSN and FSN progress

    Decode RC receive completions, armed-PSN notifications, and MMQ
    completions. Retire requester and MMQ shadow entries using their
    sequence numbers, honor cross-queue fence dependencies, and suppress
    successful WCs for unsignaled work requests.

> diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana=
/cq.c
> --- a/drivers/infiniband/hw/mana/cq.c
> +++ b/drivers/infiniband/hw/mana/cq.c

[ ... ]

> @@ -390,17 +422,104 @@ static void handle_rq_cqe(struct mana_ib_qp *qp, s=
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

[Severity: High]
Does this code allow an unmasked 25-bit PSN to be passed to the hardware
doorbell?

If a packet with a PSN of 0xFFFFFF completes and there are no pending signa=
led
WQEs, shadow_wqe will be NULL, and psn + 1 will evaluate to 0x1000000.

This could cause arm_psn to be set to 0x1000000, which is then passed to
mana_gd_wq_ring_doorbell_ext() and written into the 32-bit tail_ptr field
of the hardware doorbell register.

Could this stall a long-running RC connection and cause it to fail to recei=
ve
completions when its PSN wraps? Any application transferring enough data to=
 wrap
the 24-bit PSN (approximately 16 million packets) might trigger this behavi=
or.

> +	}
> +
> +	return consumed;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003064037.2092=
669-1-kotaranov@linux.microsoft.com?part=3D7
