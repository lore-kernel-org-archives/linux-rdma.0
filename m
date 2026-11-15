Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794766146;
	b=FfRF6BViw+WRrDatvGdk7dXJu0Hri7DQWn27Fw9s+XMC7mFUlIFmSgLBjfrAcJKRV5NC
	 ACkIZdAz3up01RO7Nl/fXy6YdXCoSbR6P7JhvhcQjvGgPW3+rkqd+fQOsYJafgW3Q50LR
	 1StKNYyjsP1oruvEYhUoWVrahQILzKA1c3VoLikFxcIcucl/OdhzP/fWBdK5P0Da8Yb7v
	 vTaNC/zOpbGn08V+x+V8SZ43rU4T9FRSC7hrGj4gLFLISRfeAR4nVDAPWapydKb05y058
	 nIhVfSj6Y3SXaZd7GbTNO4mAWUqPtoWW9je8ql/yy63hCsuA2vnLCrB/BsYRq21fjig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794766146;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=gTCqtpkUEegYLXyC3P80w91P/EHHq0LQpOFEURzxrEE=;
	b=tdKVxztg4lSuKUfzwYy6+2LjNGFt2UjzZcbPzMBknYfPyFyZuf4e2hVqX9J4jUlPKcsF
	 B3bA75vNfH2F95Sneh9v6oQfQzJtb/xeCIT+2ii5q6iziU8QM1zdHhVkjOr9RS79B3W4y
	 9ReJYapkqusFTig0BYX/kth0XGcoZpc+XNqUwbBoOMnLXGZnnbme7dy8JgeWna2/FIeUI
	 W1wygTiYuYxaiaXUqSDnHW1Rwv72HLhXTlqOwD0p+77hHDaR2cAZk/VIOPbgVQSJci/1K
	 iSY3PkGh595/Cy6Vfa84eDJRD0QsR5BNFab4mdCa8YgY5qY0jDlCxQnAv7JQbcJkKIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VhOr9Wmc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2B0606A323
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 18:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VhOr9Wmc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5384E1F000C4;
	Sun, 15 Nov 2026 18:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794766146;
	bh=gTCqtpkUEegYLXyC3P80w91P/EHHq0LQpOFEURzxrEE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VhOr9WmcSJWedvh6K8vwa+dvD6FPOFZ8Kwf0vxZ10wOaTiW9E81d0P0V/wNQHt6IB
	 ipCEXiyFZF6vIy3LegzX5BsZ7Bfg0priStKNfUBZA9GiYqATnMjfRqTHRI9L/AZ4WI
	 ONeo5S2Auylgb1EetzxWwFyAOiTd5poVK9XJ6qxM5CNEQnl9lns6oM+wDbhvgnMHrh
	 lII15spea64liFKzXsJmMM6yU3tIXMqRDZh14gGoFIGMuoirsIJKmuoNv4dyT1v1nb
	 BkX7fyT4tMeOB42XuImPbfxSAS8uqPo5QK8s4+myVtht9x9qRcOxwxjyGr+1guzdOE
	 TDNw1K2iz5nwg==
Message-ID: <sashiko-outbox-215703@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/rxe: Do not re-execute completed local ops after a
 retry
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mohamed Khalfella" <mkhalfella@purestorage.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261115173618.GD34016-mkhalfella@purestorage.com>
References: <20261113230831.2682071-1-mkhalfella@purestorage.com>
 <e432178a-6e73-4096-9f59-5c5d2bc9d682@linux.dev>
 <20261115173618.GD34016-mkhalfella@purestorage.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 18:09:05 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] RDMA/rxe: commit message is a raw email quote lacking
  Signed-off-by and Fixes
- [High] RDMA/rxe: send queue deadlock in rxe_requester() on fenced
  local op retry
- [High] RDMA/rxe: rxe_completer() consumer index can overtake wqe_index
  on retry
--

commit 03cee754f61f7db50a040ae8dc15771bcd9a4803
Author: Mohamed Khalfella <mkhalfella@purestorage.com>

> RDMA/rxe: Do not re-execute completed local ops after a retry
>=20
> On Sat 2026-11-14 11:05:39 -0800, Zhu Yanjun wrote:
> >
> > =E5=9C=A8 2026/11/13 15:08, Mohamed Khalfella =E5=86=99=E9=81=93:
> > > Local operations (IB_WR_REG_MR, IB_WR_LOCAL_INV, IB_WR_BIND_MW) are
> > > executed inline by rxe_requester() through rxe_do_local_ops(), which
> > > marks the wqe wqe_state_done and advances qp->req.wqe_index past it.
> > > Unlike wire operations, nothing is posted to the network and no ack is
> > > expected.
> > >
> > > The completer only consumes wqes from the head of the send queue, in
> > > order. A done local op wqe therefore stays in the queue until every
> > > older wqe has completed, so it can sit behind a SEND or RDMA WRITE th=
at
> > > is still waiting for an ack. With nvme-rdma, which posts REG_MR + SEND
> > > for every I/O, the queue regularly looks like:
> > >
> > >    SEND(A) pending, REG_MR(B) done, SEND(B) pending, REG_MR(C) done .=
..
> > >
> > > When a retransmit timeout fires or a NAK arrives, req_retry() rewinds
> > > qp->req.wqe_index to the consumer so that every unacked wqe is resent.
> > > Its loop skips wqe_state_done entries when resetting DMA state, but
> > > rxe_requester() itself has no such check. After the rewind it walks
> > > forward through the queue, reaches REG_MR(B), sees WR_LOCAL_OP_MASK a=
nd
> > > calls rxe_do_local_ops() on it a second time.
> > >
> > > rxe_reg_fast_mr() rejects the repeated registration because the MR is
> > > already RXE_MR_STATE_VALID, not FREE. The wqe is given
> > > IB_WC_LOC_QP_OP_ERR and the QP is moved to the error state. The
> > > completer then flushes the entire send queue with IB_WC_WR_FLUSH_ERR,
> > > including the wqe that failed, so the consumer never sees the real
> > > error status. nvme-rdma logs only "SEND ... failed with status WR
> > > flushed (5)" and tears down the controller.
> > >
> > > Any packet loss that triggers a retry while a later request is queued
> > > is enough to hit this. On a soft-RoCE setup with a few hundred lost
> > > frames per run every controller reconnect traced back to the same
> > > rxe_dbg_mr() line:
> > >
> > >    rxe1: mr#776 rxe_reg_fast_mr:  mr->lkey =3D 0x3084c not free
> > >
> > > Skip local op wqes that are already done when the requester reaches
> > > them again after a rewind. Advance wqe_index past them exactly as a
> > > successful execution would and continue with the next wqe. The MR kee=
ps
> > > its registered state and the completer still reports the wqe in order
> > > with its original status. Only local ops can be in wqe_state_done ahe=
ad
> > > of the consumer on an RC QP, since wire operations stay pending until
> > > acked, so the check cannot match anything else.
> > >
> > > Fixes: 001345339f4c ("RDMA/rxe: Separate HW and SW l/rkeys")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Mohamed Khalfella <mkhalfella@purestorage.com>
> > > ---
> > >   drivers/infiniband/sw/rxe/rxe_req.c | 14 ++++++++++++++
> > >   1 file changed, 14 insertions(+)
> > >
> > > diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband=
/sw/rxe/rxe_req.c
> > > index 4f353abd76f5..fdb55366d668 100644
> > > --- a/drivers/infiniband/sw/rxe/rxe_req.c
> > > +++ b/drivers/infiniband/sw/rxe/rxe_req.c
> > > @@ -723,6 +723,20 @@ int rxe_requester(struct rxe_qp *qp)
> > >             goto err;
> > >     }
> > >
> > > +   /*
> > > +    * A retry rewinds wqe_index to the send queue consumer. Local
> > > +    * operations that were already executed may still sit in the
> > > +    * queue behind an unacked wqe waiting for in-order completion.
> > > +    * Re-executing them fails (e.g. REG_MR on an MR that is no
> > > +    * longer free) and would move the QP to the error state, so
> > > +    * skip them instead.
> > > +    */
> > > +   if ((wqe->mask & WR_LOCAL_OP_MASK) &&
> > > +       wqe->state =3D=3D wqe_state_done) {
> > > +           qp->req.wqe_index =3D queue_next_index(q, qp->req.wqe_ind=
ex);
> > > +           goto done;
> > > +   }
> >
> > I understand the need for this check to prevent already-completed local
> > operations from
> >
> > being re-executed after a retry rewinds the WQE index.
> >
> > However, this check is currently placed in the common `rxe_requester()`
> > path, so it is evaluated
> >
> > for every WQE, including normal SEND and RDMA WRITE operations.
> >
> > Since this condition is only relevant when a retry causes the requester
> > to revisit an already-completed
> >
> > local operation, it is expected to be very rare in the normal execution
> > path.
> >
> > Could we move this check into the existing `WR_LOCAL_OP_MASK` handling
> > path, or at least mark
> >
> > the condition with `unlikely()`?
> >
> > I would prefer moving it into the local operation handling path, if the
> > control flow allows it, so that normal wire
> >
> > operations do not pay the cost of an additional state check.
> >
> > This would keep the fix while minimizing its impact on the common fast =
path.

[Severity: High]
The commit message is a raw quoted email reply containing the v1 diff and
review discussion, and its Signed-off-by: and Fixes: trailers are buried
inside quoted text where git and kernel tooling ignore them.  Please replace
the body with an unquoted changelog ending with unquoted Fixes: 001345339f4c
("RDMA/rxe: Separate HW and SW l/rkeys") and Signed-off-by: trailers.

> diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/=
rxe/rxe_req.c
> index 6e01fb18893bf..25e4bd2bc51ab 100644
> --- a/drivers/infiniband/sw/rxe/rxe_req.c
> +++ b/drivers/infiniband/sw/rxe/rxe_req.c
> @@ -787,6 +787,13 @@ int rxe_requester(struct rxe_qp *qp)
>  	}
> =20
>  	if (wqe->mask & WR_LOCAL_OP_MASK) {
> +		/* Retry rewinds wqe_index, skip it if already done */
> +		if (unlikely(wqe->state =3D=3D wqe_state_done)) {

[Severity: High]
Can checking wqe->state =3D=3D wqe_state_done after rxe_wqe_is_fenced() dea=
dlock
the send queue on retry when a completed local op has IB_SEND_FENCE?

Suppose the send queue has WQE 0 (SEND), WQE 1 (REG_MR or BIND_MW with
IB_SEND_FENCE), and WQE 2 (RDMA READ or atomic).  On the initial pass, WQE 1
executes and enters wqe_state_done, and WQE 2 calls check_init_depth(), whi=
ch
decrements qp->req.rd_atomic and sets wqe->has_rd_atomic =3D 1.  If a retry
then rewinds qp->req.wqe_index to 0, req_retry() resets WQE 0 and WQE 2 to
wqe_state_posted while leaving WQE 2 holding its rd_atomic credit.

After WQE 0 is resent, rxe_requester() visits WQE 1 and evaluates
rxe_wqe_is_fenced() before reaching WR_LOCAL_OP_MASK:

drivers/infiniband/sw/rxe/rxe_req.c:rxe_wqe_is_fenced() {
	return (wqe->wr.send_flags & IB_SEND_FENCE) &&
		atomic_read(&qp->req.rd_atomic) !=3D qp->attr.max_rd_atomic;
}

Because WQE 2 still holds an rd_atomic credit, rxe_wqe_is_fenced() sets
qp->req.wait_fence =3D 1 and exits.  qp->req.wqe_index stays stuck at WQE 1
waiting for WQE 2's credit, while WQE 2 sits at index 2 in wqe_state_posted
and can never be resent to release that credit.  Similarly, if the QP is in
IB_QPS_SQD, req_next_wqe() returns NULL because WQE 1 is not in
wqe_state_processing, preventing the drain from advancing past WQE 1.

> +			qp->req.wqe_index =3D queue_next_index(q,
> +						qp->req.wqe_index);
> +			goto done;
> +		}

[Severity: High]
Can the send queue consumer index in rxe_completer() overtake
qp->req.wqe_index after req_retry() rewinds qp->req.wqe_index across
completed local ops?

rxe_sender() alternates between rxe_requester() and rxe_completer().  Each
call to rxe_requester() processes or skips only one WQE before jumping to
done, whereas rxe_completer() loops through COMPST_GET_WQE -> COMPST_COMP_W=
QE
and drains all consecutive wqe_state_done WQEs at the consumer head in one
call:

drivers/infiniband/sw/rxe/rxe_comp.c:get_wqe() {
    ...
	/* WQE does not require an ack */
	if (wqe->state =3D=3D wqe_state_done)
		return COMPST_COMP_WQE;
    ...
}

For example, if WQE 0 (SEND, PSN 100) is followed by WQE 1 (REG_MR,
wqe_state_done) and WQE 2 (SEND, PSN 101), req_retry() rewinds
qp->req.wqe_index to 0.  rxe_requester() resends WQE 0, advances
qp->req.wqe_index to 1, and returns.  If rxe_completer() then processes a
cumulative ACK or PSN sequence error NAK for PSN 101, it completes WQE 0
(consumer =3D 1) and immediately loops in the same invocation to complete W=
QE 1
because WQE 1 is in wqe_state_done, advancing the consumer index to 2 while
qp->req.wqe_index is still 1.  The same overtake happens without a cumulati=
ve
ACK whenever two completed local ops (such as LOCAL_INV + REG_MR) sit back =
to
back after WQE 0 completes: rxe_requester() skips WQE 1 and returns with
qp->req.wqe_index at 2, and rxe_completer() completes both WQE 1 and WQE 2,
advancing the consumer to 3.

Once the consumer index is ahead of qp->req.wqe_index, the slots in
[qp->req.wqe_index, consumer) are freed for producer reuse.  If the producer
fills the ring up to qp->req.wqe_index, __req_next_wqe() sees index =3D=3D =
prod
and returns NULL on a full queue, stalling the QP; if the producer wraps pa=
st
qp->req.wqe_index, rxe_requester() executes the newly posted WQE out of ord=
er
and then a second time when qp->req.wqe_index wraps around.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115173618.GD34=
016-mkhalfella@purestorage.com?part=3D1
