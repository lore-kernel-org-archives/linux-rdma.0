Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231751DCB24
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 15:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791388297; cv=none; b=l+vg7J9DuZ7bhMwARTHQO1P7hd+ebRtmiDtaAL/HmJfROhru0gwqGzv1+7VcHvfoBqbedKl2R6xzVgDZeMs4QYBXzePUbX5s3973po9G3AUUT9Br4x3vVXW3spp+MJ8JLBtNzr8Cbx2FOz4HhdKWn49XtouUIJTtTzJtFjJ/7VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791388297; c=relaxed/simple;
	bh=X/R3hNnQ4Zh/aF2cuXpB/gMwW+9sIHbjtlHNkVbLulE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=HyibfBFGHPOsrebBRTV8y3tZM3GUP/s1IX/Qcqyny5O5IErRMa6x9s8+yxM8rLF6QX88Cfqt+T8zrhNMWCLpEIz027mgyAaWTqV6BAXAOw6VxnbdD94n3vFJVgfZl98teaKH2Yz3BflYy52QzbG82rv4BdnolbAVdx0O6hNyV/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BXZTbi81; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BXZTbi81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929AA1F000FF;
	Wed,  7 Oct 2026 15:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791388295;
	bh=3mckdnL9nULipfkmzER5PI9KwjPGJBSTx6DsT03dLW8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BXZTbi81mk/G4vJPxyFXVyc963eR4xnnM0y7Xr0ZoilAuIcXBv6xhG/Dg0N3E+MpQ
	 VO41PcoCtX3T5aZmQ6rKlOMRvNDz4JKCg56fsXTyy3oP0mT4LoX0+T5SL8srvslXcL
	 zNIXV5yzY6+k7lmawdtCxtZ1AOskBMveIILSYtOJ6VSXGzF4OQ8kTrvabJybYO1LnU
	 dGnGEmemTnLq+Il/MfYOt5BtZW1tc37aJITtqF+k/GmfR/GPI9uQgTVMojIlcEtxuG
	 J9pWpDYZh0WtlcoVOVC/xSn5LVxFn5mUIY74/XHDwktIpyXgAG4mp4Kj0O76SL8Rfb
	 4w1RgB9cXbzyg==
Message-ID: <sashiko-outbox-163167@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 09/10] RDMA/mana_ib: Handle error CQEs for
 RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261007153330.2979799-10-kotaranov@linux.microsoft.com>
References: <20261007153330.2979799-1-kotaranov@linux.microsoft.com>
 <20261007153330.2979799-10-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 15:51:35 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] RDMA/mana_ib: Inverted RC QP shadow queue mapping for GDMA receive=
 errors
- [High] RDMA/mana_ib: QP lookup drops error CQEs for RC RREQ and RRESP que=
ues
--

commit e1f8a51fcdc185eb1ad07f40a479febe1cbab173
Author: Konstantin Taranov <kotaranov@microsoft.com>

RDMA/mana_ib: Handle error CQEs for RC QPs

This commit decodes hardware error CQEs and processes them on the
corresponding work queue, completing the failing shadow entry with the
vendor status. It also defers transitioning RC QPs to the ERR state to
allow other work queues to be flushed.

> diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana=
/cq.c
> index f3002324754f7..18c8e8a98bb58 100644
> --- a/drivers/infiniband/hw/mana/cq.c
> +++ b/drivers/infiniband/hw/mana/cq.c

[ ... ]

> @@ -490,6 +513,71 @@ static bool handle_psn_cqe(struct mana_ib_qp *qp, u3=
2 psn,
>  	return consumed;
>  }
> =20
> +static bool mana_cqe_is_send(struct mana_ib_qp *qp, struct gdma_comp *cq=
e)
> +{
> +	u32 qtype =3D cqe->wq_num & MANA_QID_SUBTYPE_MASK;
> +
> +	if (qp->ibqp.qp_type !=3D IB_QPT_RC)
> +		return cqe->is_sq;
> +
> +	return cqe->is_sq ? (qtype =3D=3D MANA_QID_SUBTYPE_SREQ ||
> +			    qtype =3D=3D MANA_QID_SUBTYPE_MMQ) :
> +			    qtype =3D=3D MANA_QID_SUBTYPE_RREQ;

[Severity: High]
Does this logic invert the mapping for GDMA receive errors?

When cqe->is_sq is false, it returns true for Responder Requests (RREQ)
and false for Requester Responses (RRESP). Since RREQ consumes RECV WQEs and
RRESP consumes SEND WQEs, this seems to cause error completions to pop from
the wrong shadow queues.

Could this corrupt the shadow queues and user completions if a remote peer
sends a NAK or a packet drops, generating an error CQE on the GDMA receive
queue?

> +}
> +
> +static void mana_ib_schedule_qp_error(struct mana_ib_qp *qp)
> +{

[ ... ]

> @@ -521,6 +609,9 @@ static bool mana_handle_cqe(struct mana_ib_cq *cq, st=
ruct mana_ib_dev *mdev,
>  	case CQE_TYPE_LWR:
>  		consumed =3D handle_mmq_cqe(qp, rdma_cqe->rc_mm.fsn, poll);
>  		break;
> +	case CQE_TYPE_ERROR:
> +		consumed =3D handle_error_cqe(cq, qp, cqe, poll);

[Severity: High]
Will the QP lookup in mana_handle_cqe() successfully find the QP for RREQ
and RRESP error CQEs?

Earlier in mana_handle_cqe(), the QP is looked up via:

	struct mana_ib_qp *qp =3D mana_get_qp_ref(mdev, cqe->wq_num, cqe->is_sq);
	if (!qp)
		return true;

mana_get_qp_ref() searches for the base ID without MANA_SENDQ_MASK if
cqe->is_sq is false:

	qid &=3D ~MANA_QID_SUBTYPE_MASK;
	if (is_sq)
		qid |=3D MANA_SENDQ_MASK;
	qp =3D xa_load(&mdev->qp_table_wq, qid);

However, mana_table_store_qp() only inserts the SREQ (with MANA_SENDQ_MASK)
and Responder RQ (without the mask) into the QP table, omitting RREQ and
RRESP.

If the lookup fails, will this cause hardware error CQEs for the Requester
Receive Queue (RREQ) and Responder Send Queue (RRESP) to be silently droppe=
d?
This appears to lead to leaked shadow WQEs and indefinitely hung RDMA clien=
ts
during READ/ATOMIC response errors.

> +		break;
>  	case CQE_TYPE_UD_SEND:
>  		if (cqe->is_sq) {
>  			handle_ud_sq_cqe(qp, rdma_cqe, poll);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007153330.2979=
799-1-kotaranov@linux.microsoft.com?part=3D9
