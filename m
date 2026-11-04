Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793783604;
	b=s0j5uMuqCtMdHdmRkTnJOy+JL0NuRlk/DvsWELacrelBrd7KWTw+vNwOK+vX9BWa3lzs
	 hlm2uATEGqv9xrs8DZ7zmAPcc2QnXTiW/7Tc5JwsmvqugvODEp23A8tjFhVnAdWPBwW96
	 3X3DX0B8K7TXBDn4/nHFjxCapinwRuXxBwtttj30WGVaXrtBKA1PbzSYCeOK0vDsvMVo0
	 lKcg1h7bNVaLd4KiK1Jg01oFi6jnNRixqzQX2q7OrDlWTz6K9r92GZz641SxSNLPoMPKb
	 XIBN4U0MeFrbyD7XH/xC5DXe8b3ucqtKTp+CgcpOUQJMD3W3WS1ja4dNKXYNB93eMag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793783604;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=604ovO8F4OusDJhTNnwd7uj/IMILuERfkeuCWRtMf3c=;
	b=XFXXB+7fKpxNmabY/nCOUgx2mBMqn8X2lWer+XIdwRiSR8BiXV+yRdWcGNclwkxKunjX
	 rSpuCf8aUG6D/B3oFnJcl9oDH9QnycYe8Nn+GG4yn+hVhll4Wzv9a9idgrkXmXDCnO/QE
	 UkxXE8YE9plqk+gUnAkqMYBy6xlWmz1m2LWL1UyTykvmc05awDonYggDyKvhnupjsqZmH
	 ZiuP27kQY5ks7JuzLEjKANb2UwvFTk8ODCS++z05vkMCPNGEIeje8M9UZ21x4/cMyO7uK
	 v+lC61JvmEhV3yLU3VAQWAfmfxqpOVZd/e0aASiYJAbb3MX2P40VasWhbaF5jcUmiSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lYra6Lg+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A6D606A31B
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 09:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lYra6Lg+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6EC1F00919;
	Wed,  4 Nov 2026 09:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793783603;
	bh=604ovO8F4OusDJhTNnwd7uj/IMILuERfkeuCWRtMf3c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lYra6Lg+LUE+7CCjWIpn/FYnEH++SegyXFWkwE/BZJLwfhKTiQhMc+nzVnIDezcee
	 //GUgJtxQibsEOCrY/w5F1XMxTXZ/W2QRxMJj/wIchnSeZOoSk2ZWRq4jgcYLRi3Sb
	 xoEW3rXQUFQKunvySKfo0g3pUrdvH2aJ9UkhX/byAO65vWoTN5bg2tzZUl0t4isyXe
	 6ys6alQ4n9CKb7MtNtT9xnNJRTp+hB2PonTZiFeavat5QEsO367bF3YE43WmlWJBhE
	 NtTotcCieM57sWGHbrDIybiu5SEhIqkxdPqksKJ+EwPPG8ry3R8zYBBkniONEEB1/o
	 kRndALVUcNGIg==
Message-ID: <sashiko-outbox-196936@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/siw: Ignore peer close events on listening
 endpoints
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jaeyeong Lee" <lee@jaeyeong.cc>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <179378222423.73361.5194383282780549988@jaeyeong.cc>
References: <179378222423.73361.5194383282780549988@jaeyeong.cc>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 09:13:23 +0000
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
- [Critical] RDMA/siw: listen() before setting SIW_EPSTATE_LISTENING in siw=
_create_listen()
- [High] RDMA/siw: lost peer close when child socket closes before kernel_a=
ccept()
--

commit 4ef3f34aa3f1c3ee451c3e1beb79ef0ea51f6cdf
Author: Jaeyeong Lee <lee@jaeyeong.cc>

RDMA/siw: Ignore peer close events on listening endpoints

This commit ignores TCP_CLOSE and TCP_CLOSE_WAIT state change notifications=
 in
siw_cm_llp_state_change() when cep->state is SIW_EPSTATE_LISTENING to preve=
nt
a child socket closed before kernel_accept() from queueing a PEER_CLOSE work
item against the listening endpoint.

> diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/s=
iw/siw_cm.c
> index ed49818793dde..518f09a2d37cf 100644
> --- a/drivers/infiniband/sw/siw/siw_cm.c
> +++ b/drivers/infiniband/sw/siw/siw_cm.c
> @@ -1361,6 +1361,8 @@ static void siw_cm_llp_state_change(struct sock *sk)
> =20
>  	case TCP_CLOSE:
>  	case TCP_CLOSE_WAIT:
> +		if (cep->state =3D=3D SIW_EPSTATE_LISTENING)
> +			break;

[Severity: Critical]
Does this check leave a window during listener creation where the same
use-after-free can still happen?

In drivers/infiniband/sw/siw/siw_cm.c:siw_create_listen(), the socket is
associated with cep and placed into TCP_LISTEN while cep->state is still
SIW_EPSTATE_IDLE, before a sleepable kmalloc_obj() call and before cep->sta=
te
is set to SIW_EPSTATE_LISTENING:

drivers/infiniband/sw/siw/siw_cm.c:siw_create_listen() {
	...
	cep =3D siw_cep_alloc(sdev);
	if (!cep) {
		rv =3D -ENOMEM;
		goto error;
	}
	siw_cep_socket_assoc(cep, s);
	...
	rv =3D s->ops->listen(s, backlog);
	if (rv) {
		siw_dbg(id->device, "listen error %d\n", rv);
		goto error;
	}
	cep->cm_id =3D id;
	id->add_ref(id);
	...
	if (!id->provider_data) {
		id->provider_data =3D
			kmalloc_obj(struct list_head);
		if (!id->provider_data) {
			rv =3D -ENOMEM;
			goto error;
		}
		INIT_LIST_HEAD((struct list_head *)id->provider_data);
	}
	list_add_tail(&cep->listenq, (struct list_head *)id->provider_data);
	cep->state =3D SIW_EPSTATE_LISTENING;
	...
}

If a remote peer completes a TCP handshake and sends RST or FIN after
s->ops->listen() but before cep->state =3D SIW_EPSTATE_LISTENING,
siw_cm_llp_state_change() runs on the child socket while cep->state is still
SIW_EPSTATE_IDLE. Wouldn't that bypass the SIW_EPSTATE_LISTENING check and
still queue SIW_CM_WORK_PEER_CLOSE against the listening cep, freeing it via
siw_cm_work_handler() while it remains on id->provider_data?

[Severity: High]
Also, if the peer closes or resets the child socket before siw_accept_newco=
nn()
runs, won't the SIW_CM_WORK_PEER_CLOSE notification for the accepted connec=
tion
be lost completely?

The commit message notes that once the child is accepted, its sk_user_data
points to the new endpoint and close notifications continue through the nor=
mal
path. However, kernel_accept() succeeds and dequeues the child socket from
icsk_accept_queue even when new_s->sk->sk_state is already TCP_CLOSE or
TCP_CLOSE_WAIT:

drivers/infiniband/sw/siw/siw_cm.c:siw_accept_newconn() {
	...
	rv =3D kernel_accept(s, &new_s, O_NONBLOCK);
	if (rv !=3D 0) {
		/*
		 * Connection already aborted by peer..?
		 */
		siw_dbg_cep(cep, "kernel_accept() error: %d\n", rv);
		goto error;
	}
	new_cep->sock =3D new_s;
	siw_cep_get(new_cep);
	new_s->sk->sk_user_data =3D new_cep;
	...
	if (atomic_read(&new_s->sk->sk_rmem_alloc)) {
		/*
		 * MPA REQ already queued
		 */
		...
		rv =3D siw_proc_mpareq(new_cep);
	...
}

Unlike the receive data path where siw_accept_newconn() checks sk_rmem_alloc
after setting sk_user_data =3D new_cep, siw_accept_newconn() neither holds
sk_callback_lock while updating sk_user_data nor checks new_s->sk->sk_state
afterward.

If the transition to TCP_CLOSE_WAIT or TCP_CLOSE already fired while
sk_user_data pointed to the listening cep, no further sk_state_change callb=
ack
will fire for that transition. If the peer sent an MPA request with private
data followed by FIN before kernel_accept(), siw_recv_mpa_rr() reads the MPA
request without consuming the EOF, siw_proc_mpareq() delivers
IW_CM_EVENT_CONNECT_REQUEST, and siw_accept() cancels mpa_timer and moves t=
he
QP to RTS on a half-closed TCP_CLOSE_WAIT socket that never receives
SIW_CM_WORK_PEER_CLOSE. If the peer sent RST or FIN without a complete MPA
request, new_cep still holds new_s and listen_cep until MPAREP_TIMEOUT
expires.

Should siw_accept_newconn() serialize the sk_user_data update with
sk_callback_lock and inspect new_s->sk->sk_state after associating new_cep?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/179378222423.73361.=
5194383282780549988@jaeyeong.cc?part=3D1
