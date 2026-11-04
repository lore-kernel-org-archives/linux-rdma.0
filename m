Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793789093;
	b=PsqdjhAGVL7EvASw8XC8UodMby7uN6kydGrDajybVkNsNgVMTUhctp/W/tWxlRM9k6E+
	 tSfMTEZ22DxJE21ZcTc0jkySRXpb7QPgYzDT9nVwTe4whVlHl0waOlF8P0OMSn2TE9kRs
	 AkgniLmIB3wOi08GIS9MJF5LO+FL4PZiSGPbrh/5cWKgGDiLaLZg5jHoXbJHjdgfndu/4
	 n6Ht/4pswmNmwWvrKhH27AHhdlh6JBVv1hEJDHKZA1Qxz6PblCk6IIbhvyOI1YdCcon/z
	 XSrql4KEN/5FkQf8k1SGLj9KlPtkrpB9TlVrfPtOiG05rtPdrz3LEwUsyPVfX7wFmvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793789093;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=YTcUB0AWBog1PcKF6bk90f6K7HQvKLRkKOwP6nNCvi8=;
	b=kBFElhbQKyM1FZuDXHbKZCTwmu2j63hv92ZxIGyomDRGuwwp73XUUkpCbFsWr7kLCsIR
	 T64ZMWXZZ/+T9RSqjdMsdePrXlfXd8Z9OuFP/cZPMJi69lnCNzFRXyahGaG2lDYw1wmnp
	 Zb9JXorwN9Y1WAs+Kfik2PpGZiAs4ksT1LDuYqhEo0bQNuRLSjupPrtSs3Rn6F1PuCc0A
	 cEKln06aFdagoIMZtN2m/WdeNfQkL/LkxHnQPAuyVdxGNvN4MEsNUmqksyaz+eH0hNVyi
	 805KWSyqKHjAUlMvWtZgtu7LJp2SLQ2q8pfpQtDjIDWakid6gFHZQx4DQ4YmuraMiOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="O/pnIGdK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FC0606A32E
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 10:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O/pnIGdK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E591F00A24;
	Wed,  4 Nov 2026 10:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793789092;
	bh=YTcUB0AWBog1PcKF6bk90f6K7HQvKLRkKOwP6nNCvi8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O/pnIGdKrgBLE3RquKHe3+PcBTL4KpR+KGoqx76YYN8QZhOs3qqEzvySId00xcMPu
	 8elrs7QBF/5gnM9EIi+5v8kgbPw9ZzrJDL8VD5JGW9dg35Fqk6BepQbso027Mnp6v+
	 BD5y822Vu0IAfXBkoN5BjNRCfsFRgaNoD8cADGz+zVH8G8s5u+ZoeIOxoIuGjCFcEt
	 17A3SqEtcllpGznpNcX7ThNXo/M4CVi/xXTtoHj81i8DHnPxACQveDW4Xo8fMMcYez
	 7kkWxz2K6oD82D6r8S/EwdzllzmPju3P3LDgxR7hy36P7UMJqjA0zk3Zvja0D/PqD6
	 FCJZ4vNvg78Xw==
Message-ID: <sashiko-outbox-197117@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/siw: Fix early peer close handling on listeners
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jaeyeong Lee" <lee@jaeyeong.cc>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104100953.125140-1-lee@jaeyeong.cc>
References: <20261104100953.125140-1-lee@jaeyeong.cc>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 10:44:52 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] RDMA/siw: siw_accept_newconn() drops connections in post-listen ID=
LE window
--

commit fd783e525f31231ba5b3c0e855c9ecc089f5379f
Author: Jaeyeong Lee <lee@jaeyeong.cc>

RDMA/siw: Fix early peer close handling on listeners

This commit prevents a use-after-free in siw_destroy_listen() when a TCP
child socket closes before kernel_accept() associates it with a new
connection endpoint. It ignores close notifications on listening and
unaccepted post-listen IDLE endpoints, and serializes the accepted-socket
handoff in siw_accept_newconn() while rejecting child sockets that have
already reached TCP_CLOSE or TCP_CLOSE_WAIT.

> diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/s=
iw/siw_cm.c
> index ed49818793dde..92fcbcabb5984 100644
> --- a/drivers/infiniband/sw/siw/siw_cm.c
> +++ b/drivers/infiniband/sw/siw/siw_cm.c
> @@ -973,6 +973,7 @@ static void siw_accept_newconn(struct siw_cep *cep)
>  	struct socket *s =3D cep->sock;
>  	struct socket *new_s =3D NULL;
>  	struct siw_cep *new_cep =3D NULL;
> +	bool peer_closed;
>  	int rv =3D 0; /* debug only. should disappear */
> =20
>  	if (cep->state !=3D SIW_EPSTATE_LISTENING)
> @@ -1009,11 +1010,23 @@ static void siw_accept_newconn(struct siw_cep *ce=
p)
>  	}
>  	new_cep->sock =3D new_s;
>  	siw_cep_get(new_cep);
> -	new_s->sk->sk_user_data =3D new_cep;
> =20
>  	if (siw_tcp_nagle =3D=3D false)
>  		tcp_sock_set_nodelay(new_s->sk);
> +
> +	lock_sock(new_s->sk);
> +	write_lock_bh(&new_s->sk->sk_callback_lock);
>  	new_cep->state =3D SIW_EPSTATE_AWAIT_MPAREQ;
> +	new_s->sk->sk_user_data =3D new_cep;
> +	peer_closed =3D new_s->sk->sk_state =3D=3D TCP_CLOSE ||
> +		      new_s->sk->sk_state =3D=3D TCP_CLOSE_WAIT;
> +	write_unlock_bh(&new_s->sk->sk_callback_lock);
> +	release_sock(new_s->sk);
> +
> +	if (peer_closed) {
> +		rv =3D -ECONNRESET;
> +		goto error;
> +	}
> =20
>  	rv =3D siw_cm_queue_work(new_cep, SIW_CM_WORK_MPATIMEOUT);
>  	if (rv)
> @@ -1361,6 +1374,10 @@ static void siw_cm_llp_state_change(struct sock *s=
k)
> =20
>  	case TCP_CLOSE:
>  	case TCP_CLOSE_WAIT:
> +		if (cep->state =3D=3D SIW_EPSTATE_LISTENING ||
> +		    (cep->state =3D=3D SIW_EPSTATE_IDLE &&
> +		     !READ_ONCE(sk->sk_socket)))
> +			break;

[Severity: High]
When a connection arrives during the post-listen SIW_EPSTATE_IDLE window
in siw_create_listen(), can the SIW_CM_WORK_ACCEPT work item run before
cep->state transitions to SIW_EPSTATE_LISTENING and strand the child
socket in the TCP accept queue?

In siw_create_listen(), s->ops->listen() is called while cep->state is
still SIW_EPSTATE_IDLE and cep->in_use is not held:

drivers/infiniband/sw/siw/siw_cm.c:siw_create_listen() {
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
		...
	}
	list_add_tail(&cep->listenq, (struct list_head *)id->provider_data);
	cep->state =3D SIW_EPSTATE_LISTENING;
}

If a peer completes a TCP handshake during this window,
siw_cm_llp_state_change() queues SIW_CM_WORK_ACCEPT with delay 0, and if
the peer also closes, the new check ignores TCP_CLOSE / TCP_CLOSE_WAIT
because cep->state is SIW_EPSTATE_IDLE and sk->sk_socket is NULL.

However, if siw_cm_work_handler() runs siw_accept_newconn(cep) before
siw_create_listen() sets cep->state =3D SIW_EPSTATE_LISTENING,
siw_accept_newconn() bails out without calling kernel_accept():

drivers/infiniband/sw/siw/siw_cm.c:siw_accept_newconn() {
	...
	if (cep->state !=3D SIW_EPSTATE_LISTENING)
		goto error;
}

Because the SIW_CM_WORK_ACCEPT work item is consumed and never re-queued
when cep->state becomes SIW_EPSTATE_LISTENING, the unaccepted child socket
is left at the head of icsk_accept_queue. A live connection will hang
unaccepted, or if the peer closed it during the IDLE window, the dead
child socket will be dequeued by the next connection's SIW_CM_WORK_ACCEPT
and trigger the new peer_closed abort, stranding the subsequent valid
connection.

Would holding siw_cep_set_inuse(cep) or setting cep->state =3D
SIW_EPSTATE_LISTENING before calling s->ops->listen() in
siw_create_listen() avoid this post-listen IDLE window altogether?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104100953.1251=
40-1-lee@jaeyeong.cc?part=3D1
