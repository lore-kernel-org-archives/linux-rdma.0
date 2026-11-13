Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794612514;
	b=DPdDTog/OW6u666PhxuoTStUOuVFYivlfoxcmHBLGDooMtYXd4OV2nmhtEriPvXn8iyK
	 JfSwGGM5oHB8oGp+Gsf6gBECUiWoApMpGYR4JVlPqjDFA56nT3yDp3LKgxBH7/O++cApc
	 BGIpwmX9IHyj1ALo/17bAsH7m1q4IyGmaZmEu9eFJSwiKWPeQUDmiQP/Usm1aIIP5egaI
	 dz6eQkfeOyJjedMpWpuikM6pQoo+DagFUbtV2nC5gnBDG6JvYEq6UY6L25BWiBG3Boomq
	 E4eAxZSiELBe/zjgiw9rhY8txFYHOFZyrewbl2iSq5OFrJNU0Zu3rZEMMen0nS6A6Eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794612514;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=WZ5znOiMLBJbpcQZyi5x4qvANKBgf2eS6xhfrDHnbKQ=;
	b=EpZ415QSdJ/Kr4Bgz2jFqZAGFKQT33hhhQQcdPGogQV79hypE+ZBhKo7P7sQeumDE0Vn
	 vwZcq5vFWAMBtaFgjon4nxKI6iY61naoZ+XUYAou/Ag7g6p849QNYL+SjBCBW7vcchF1R
	 JJ/hZzO2Lu7pTVjYcswNAlHQkqxubAL4XF87I0o6LJl3oFSyGmt+GQKv3nnw9sL8hutRu
	 zY38WQQ/g9BBgkl156xNW68+HLW8Gnw31Ls2SaNeJh5IU71Tag9RORNkKtYYQ50FVHU0u
	 HiCSF0zije/+z398JbfG8BvJ8DuOtzn9cmYLNw42hWqD36BnC512LXcEFy9knJ+hxhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AuEh89PO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F828606A338
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 23:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AuEh89PO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C751F000C6;
	Fri, 13 Nov 2026 23:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794612514;
	bh=WZ5znOiMLBJbpcQZyi5x4qvANKBgf2eS6xhfrDHnbKQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AuEh89PO0uB0th5XhuYDysVjF9c15Qr6z657ivUb95vbiL6RcpPsF0JPOQ1Nt9uRj
	 ct/RFGNdFYi9JMPzQKmyFepgU3OE/wfFkTNPcwN6vc9B6J5JIOzpXPDMITbEXA0MOu
	 oPt7tHfNdOnSsDhBbqLAifFiE3CRRkHu29kEP91ug+2Lzmiqfg3MFk0ot1/0XJWaju
	 EDm9L0plr7w56L3nMGLi0T8Zu+wtN04Bb8gbyLorgaXz5bZjPJa6vffRSI8GN5JKgd
	 NJeinwkp7ywOYFRPzzYYOlkrRqU1VOwG0tOnYUJhLDg/vdpp0ppn7OiuUFcMmMGEYe
	 xjQS6fMSmTLuw==
Message-ID: <sashiko-outbox-213867@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/rxe: Do not re-execute completed local ops after a
 retry
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mohamed Khalfella" <mkhalfella@purestorage.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261113230831.2682071-1-mkhalfella@purestorage.com>
References: <20261113230831.2682071-1-mkhalfella@purestorage.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 23:28:33 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] RDMA/rxe: completer consumer index can overtake wqe_index in
  rxe_requester()
--

commit d3f6a5448675a7f592bfd812042efdb600a6a02c
Author: Mohamed Khalfella <mkhalfella@purestorage.com>

RDMA/rxe: Do not re-execute completed local ops after a retry

This commit skips local operation WQEs that are already in wqe_state_done
when rxe_requester() walks the send queue again after a retry rewind.

> diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/=
rxe/rxe_req.c
> index 6e01fb18893bf..ee89468435902 100644
> --- a/drivers/infiniband/sw/rxe/rxe_req.c
> +++ b/drivers/infiniband/sw/rxe/rxe_req.c
> @@ -781,6 +781,20 @@ int rxe_requester(struct rxe_qp *qp)
>  		goto err;
>  	}
> =20
> +	/*
> +	 * A retry rewinds wqe_index to the send queue consumer. Local
> +	 * operations that were already executed may still sit in the
> +	 * queue behind an unacked wqe waiting for in-order completion.
> +	 * Re-executing them fails (e.g. REG_MR on an MR that is no
> +	 * longer free) and would move the QP to the error state, so
> +	 * skip them instead.
> +	 */
> +	if ((wqe->mask & WR_LOCAL_OP_MASK) &&
> +	    wqe->state =3D=3D wqe_state_done) {
> +		qp->req.wqe_index =3D queue_next_index(q, qp->req.wqe_index);
> +		goto done;
> +	}
> +
>  	if (rxe_wqe_is_fenced(qp, wqe)) {
>  		qp->req.wait_fence =3D 1;
>  		goto exit;

[Severity: High]
Can the send queue consumer index in rxe_completer() overtake
qp->req.wqe_index after a retry?

rxe_sender() alternates one call to rxe_requester(), which advances
qp->req.wqe_index by at most one WQE per call before jumping to done,
with one call to rxe_completer(), where complete_wqe() loops back to
COMPST_GET_WQE and completes all consecutive wqe_state_done WQEs at the
head of the send queue in a single pass:

drivers/infiniband/sw/rxe/rxe_comp.c:get_wqe() {
	...
	/* WQE does not require an ack */
	if (wqe->state =3D=3D wqe_state_done)
		return COMPST_COMP_WQE;
	...
}

After req_retry() rewinds qp->req.wqe_index on a queue with SEND(A)
followed by REG_MR(B) in wqe_state_done and SEND(B), rxe_requester()
resends SEND(A) and advances qp->req.wqe_index to REG_MR(B).  If
rxe_completer() then processes a cumulative ACK or PSN sequence error NAK
that completes SEND(A), its loop immediately completes REG_MR(B) as well,
advancing the consumer index past qp->req.wqe_index (the same happens when
two completed local ops sit back to back).  Once the consumer index
overtakes qp->req.wqe_index, newly posted WQEs that wrap the ring can
either stall the send queue when __req_next_wqe() sees index =3D=3D prod or=
 be
fetched and executed out of order and a second time when qp->req.wqe_index
catches up.

In addition, because this check is placed after req_next_wqe(), if the QP
is in IB_QPS_SQD when qp->req.wqe_index reaches a wqe_state_done local op,
req_next_wqe() returns NULL because wqe->state !=3D wqe_state_processing,
preventing req_check_sq_drain_done() from seeing index =3D=3D cons.

Could req_next_wqe() instead loop past wqe_state_done local ops before the
IB_QPS_SQD check so qp->req.wqe_index always stays ahead of the completer?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113230831.2682=
071-1-mkhalfella@purestorage.com?part=3D1
