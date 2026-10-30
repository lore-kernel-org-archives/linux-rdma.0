Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793374783;
	b=snPO85XmUyKPVXct10acNuKxRGuuY+CP4avPWatX8znTI5aLgAl2nJi5XDzKaMmsH1tU
	 EQL4QqViiL7H91j1ka/LRl4HUQ3bjyw+F7stXmESnYCLH6waEcvTU0BuJ5JDoDn2XJV2R
	 zHzhUrw0vNmI7rvOAG4dl+XK4RcI+1ZhGu9l5Qaew+4jm43ciV9GZxoJsTgv3A9llPU2z
	 CRYcWGRYiU3RHPkQT7zu57Vf/xCySPAVUdMNYMkAqBhjhvK5azU4213BrsSrBftIrnCfP
	 sQFI4E+JTAC/eQxGLqNMUPFoAKzXooiqnC9UEgQQAAniCa9SktrGGlgDr8fWtXxMCBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793374783;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=QTk7xFMaFdFmBponqg2u5oMEMQNlZMSskvCMyr9PvX0=;
	b=suuYW8wVt33BlOPmWdFFk/5SECW11FvSRerFoQw6XoQu8F4Yspd1Olbiiu3icc+b0A8n
	 jMxzfzKDrpcTEUaP37cXo/uf6tenH0OoGAkuqwJOKmYgOpHijlK+prrPELVXs1LFnAT5D
	 M832sWzAkFlcSM4zN59PqjONHMa3+WdVqdtaeqr588J64NDoSXm+YeFqx0x2Exr8gXCaf
	 VU/dv/3mFyMXPJ5haNJwSiU2n235XxC3+Tgdz+PiEXYgzehe+JnWA3rQxug44Hhll3iba
	 PIKb7J49MFQkJo3UiubsF5lGh0O4/M6Gv2RJBbtlLCyAZ9f6TXUuGl79QQ1Ii8Mp/Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="bKhro/IU";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE9C606A31A
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 15:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bKhro/IU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736F51F000C1;
	Fri, 30 Oct 2026 15:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793374782;
	bh=QTk7xFMaFdFmBponqg2u5oMEMQNlZMSskvCMyr9PvX0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bKhro/IUt5kCCNFTlVRA1VZKZkAgt0ATjGesQRqzDzjINF27bP2KJ54ITvAs4hY/V
	 2CQXbN5Gn7vuYlAxxqCWf3uqGVaAsi27/XPGhWLInRBXRtMH9HTZGrUzk3UC3oZeyu
	 BE20UEOH8AqmmUTMedgvHlk2py01EcANLYnm7gWKljBW3pZEYFqVK2VTh/lRx06DiD
	 +yvaqRg1Vf3k3DDZrWMSLkr5LqoWDFf6q8Gtb//Wlu9Eo27w5gNHxwomL/AC9kYioF
	 FI7vXD0t16Gi7v+cmymxBhie0ilHxQJoRglwWSXDdy/fbkEj5o7rDL8I4uBjg5Kn4P
	 rS+Mz4YZ+5DUQ==
Message-ID: <sashiko-outbox-191181@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 2/2] RDMA/rxe: copy send WQE to kernel buffer in
 completer path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tristan Madani" <tristmd@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261030151558.1458444-3-tristan@talencesecurity.com>
References: <20261030151558.1458444-1-tristan@talencesecurity.com>
 <20261030151558.1458444-3-tristan@talencesecurity.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 15:39:42 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] RDMA/rxe: missing rxe_comp_writeback_wqe() before retry loses READ=
 progress
- [High] RDMA/rxe: missing comp_wqe_valid invalidation in COMPST_RNR_RETRY
--

commit 7163a14999e322c25c58445d22fa6ea5241151a2
Author: Tristan Madani <tristmd@gmail.com>

RDMA/rxe: copy send WQE to kernel buffer in completer path

This commit copies the send WQE from userspace-mapped shared memory into a
completer-private kernel buffer in get_wqe() to prevent TOCTOU races, while
caching the copy across multi-packet responses and writing back modified WQE
fields on completion.

> diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw=
/rxe/rxe_comp.c
> index 1390e861bd1d7..cd4085a1bf2f8 100644
> --- a/drivers/infiniband/sw/rxe/rxe_comp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_comp.c
> @@ -137,22 +137,87 @@ void rxe_comp_queue_pkt(struct rxe_qp *qp, struct s=
k_buff *skb)
>  	rxe_sched_task(&qp->send_task);
>  }
> =20
> +/* Write back completer WQE fields to shared memory */
> +static void rxe_comp_writeback_wqe(struct rxe_qp *qp)
> +{
> +	struct rxe_send_wqe *shared =3D qp->comp.shared_wqe;
> +	struct rxe_send_wqe *local =3D &qp->comp.comp_wqe.wqe;
> +
> +	if (!qp->comp.comp_wqe_valid || !shared)
> +		return;
> +
> +	WRITE_ONCE(shared->status, local->status);
> +	WRITE_ONCE(shared->has_rd_atomic, local->has_rd_atomic);
> +	WRITE_ONCE(shared->dma.resid, local->dma.resid);
> +	WRITE_ONCE(shared->dma.cur_sge, local->dma.cur_sge);
> +	WRITE_ONCE(shared->dma.sge_offset, local->dma.sge_offset);
> +}

[ ... ]

> @@ -454,6 +519,8 @@ static void do_complete(struct rxe_qp *qp, struct rxe=
_send_wqe *wqe)
>  	if (post)
>  		make_send_cqe(qp, wqe, &cqe);
> =20
> +	rxe_comp_writeback_wqe(qp);
> +	qp->comp.comp_wqe_valid =3D false;
>  	queue_advance_consumer(qp->sq.queue, QUEUE_TYPE_FROM_CLIENT);
> =20
>  	if (post)
> @@ -788,6 +855,7 @@ int rxe_completer(struct rxe_qp *qp)
>  							RXE_CNT_COMP_RETRY);
>  					qp->req.need_retry =3D 1;
>  					qp->comp.started_retry =3D 1;
> +					qp->comp.comp_wqe_valid =3D false;
>  					qp->req.again =3D 1;
>  				}
>  				goto done;

[Severity: High]
As reported by Sashiko on v6 [1], does invalidating qp->comp.comp_wqe_valid
in COMPST_ERROR_RETRY without calling rxe_comp_writeback_wqe(qp) first lose
DMA progress for partially completed multi-packet RDMA read operations?

During a multi-packet RDMA read, rxe_requester() sends a request packet with
payload =3D=3D 0 and leaves shared_wqe->dma.resid equal to wqe->dma.length =
in
qp->sq.queue. As non-final read response packets arrive in rxe_completer(),
do_read() calls copy_data(), advancing wqe->dma.resid, wqe->dma.cur_sge, and
wqe->dma.sge_offset in the local qp->comp.comp_wqe.wqe copy, and returns
COMPST_UPDATE_COMP:

drivers/infiniband/sw/rxe/rxe_comp.c:do_read() {
	ret =3D copy_data(qp->pd, IB_ACCESS_LOCAL_WRITE,
			&wqe->dma, payload_addr(pkt),
			payload_size(pkt), RXE_TO_MR_OBJ);
	if (ret) {
		wqe->status =3D IB_WC_LOC_PROT_ERR;
		return COMPST_ERROR;
	}

	if (wqe->dma.resid =3D=3D 0 && (pkt->mask & RXE_END_MASK))
		return COMPST_COMP_ACK;

	return COMPST_UPDATE_COMP;
}

Because rxe_comp_writeback_wqe() is only called in do_complete() when the W=
QE
finishes and is popped from the send queue, clearing qp->comp.comp_wqe_valid
in COMPST_ERROR_RETRY discards the updated local DMA state before req_retry=
()
runs on the shared WQE:

drivers/infiniband/sw/rxe/rxe_req.c:req_retry() {
			if (mask & WR_READ_MASK) {
				npsn =3D (wqe->dma.length - wqe->dma.resid) /
					qp->mtu;
				wqe->iova +=3D npsn * qp->mtu;
			}
}

With shared_wqe->dma.resid still equal to wqe->dma.length, npsn evaluates to
0 and the retried read restarts from offset 0 with cur_sge =3D=3D 0 and
sge_offset =3D=3D 0 instead of resuming from the partial offset. Should
rxe_comp_writeback_wqe(qp) be called before clearing comp_wqe_valid on retry
(or after copy_data() in do_read())?

[Severity: High]
As reported by Sashiko on v6 [2], what happens in rxe_completer() when an R=
NR
NAK triggers COMPST_RNR_RETRY right below this hunk?

drivers/infiniband/sw/rxe/rxe_comp.c:rxe_completer() {
		case COMPST_RNR_RETRY:
			/* we come here if we received an RNR NAK */
			if (qp->comp.rnr_retry > 0) {
				if (qp->comp.rnr_retry !=3D 7)
					qp->comp.rnr_retry--;

				/* don't start a retry flow until the
				 * rnr timer has fired
				 */
				qp->req.wait_for_rnr_timer =3D 1;
				rxe_dbg_qp(qp, "set rnr nak timer\n");
				// TODO who protects from destroy_qp??
				mod_timer(&qp->rnr_nak_timer,
					  jiffies + rnrnak_jiffies(aeth_syn(pkt)
						& ~AETH_TYPE_MASK));
				goto exit;
			}
}

Unlike COMPST_ERROR_RETRY, COMPST_RNR_RETRY does not clear
qp->comp.comp_wqe_valid, and when rnr_nak_timer expires and rxe_requester()
calls req_retry(), only qp->req.send_wqe_valid is cleared. Once
rxe_requester() retransmits the WQE and sets shared_wqe->state back to
wqe_state_pending with updated first_psn and last_psn values, won't get_wqe=
()
see:

	if (qp->comp.comp_wqe_valid && qp->comp.shared_wqe =3D=3D wqe &&
	    qp->comp.comp_wqe.wqe.state =3D=3D state) {
		wqe =3D &qp->comp.comp_wqe.wqe;
		*wqe_p =3D wqe;
		goto check_state;
	}

and reuse the stale pre-retry qp->comp.comp_wqe copy, causing check_ack() to
compare the retried response against stale first_psn and last_psn values and
fail with COMPST_ERROR?

[1] https://lore.kernel.org/r/20261026001405.1698455-3-tristan@talencesecur=
ity.com
[2] https://lore.kernel.org/r/20261026001405.1698455-3-tristan@talencesecur=
ity.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030151558.1458=
444-1-tristan@talencesecurity.com?part=3D2
