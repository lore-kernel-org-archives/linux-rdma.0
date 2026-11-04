Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793787009;
	b=w2rpCx4XbJMKMgYIX/IT6hs6ZBF5q5lBeyjIvzFhiBUUuyKLAIQ+e6EwVWWQtNznXi/d
	 eznter0dmyEMD83I0tEM4y/wDUr0Rrc9UDjpxW8l/wWdcAQCpDSCJNp6K9iufoN+h8fOS
	 oOT+IdUItgl1cjTxWOEmG57V9wvT6fGp0OxEPwENmCT6pXG7LwhVVAyXci99VSY+y1apM
	 eDfg0rAkOsDrteuC2ToZEXRYmA6336nXFcERNwq/KrOlUF7FCYp1iUgVdBsp7bEd8j+UM
	 ugxzeLJC9ZA6eacfQi3HtCfDmxzMewsGPK8fDsQIBZwsGK8sc/+LAOgH8vG7xFf2UpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793787009;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=bbE/lgR9vBPLVJi5/1KALbz9FtBnYSUeZBwKK9/dS7U=;
	b=43leUvQL8+rd4xXcT/1G3MjFmj3JUwKsQY2DOED1Uty+PeyWnfQsR07WnsDdBb/keTit
	 iNgQOF18HwdkBL0niH1YJsVW55fwQrkyRhA5xeUWJjta0enUQ1zd1HRuefhRXojR0VdTu
	 HjUu/b5QIFPRlziBb8EPuxANQv9wdbAQjOaCzLQ/KJAahschCrIQbOKw7fJKxtX9axniT
	 DsW7X/vGTobhlHl7iZ6tq+665fBmEcwXoyoPJoo9wusytehzfAAAuH55qgWQuFfm2BMOq
	 w+NPXsbOWJBDQBhFlXogQlbqWrZCNCnXKWFnb4p4eIF+x0D3aRwyojZTy0j+EJstsMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=jaeyeong.cc;
	spf=pass smtp.mailfrom=jaeyeong.cc;
	dkim=pass header.d=jaeyeong.cc header.i=@jaeyeong.cc header.a=rsa-sha256 header.s=protonmail2 header.b=aMlFb3nM;
	arc=none smtp.remote-ip=109.224.244.21
Received: from mail-24421.protonmail.ch (mail-24421.protonmail.ch [109.224.244.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874BF606A328
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 10:10:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 874BF606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jaeyeong.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jaeyeong.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=jaeyeong.cc header.i=@jaeyeong.cc header.a=rsa-sha256 header.s=protonmail2 header.b=aMlFb3nM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaeyeong.cc;
	s=protonmail2; t=1793787004; x=1794046204;
	bh=bbE/lgR9vBPLVJi5/1KALbz9FtBnYSUeZBwKK9/dS7U=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=aMlFb3nMItkEa3XJpm3XcSxSP7RlORBVx04bwGnTaIdQOSnNRgBBW2rkE/EnC2oz0
	 eLshjsTRlX0zdb0tRcp9v2vze5qwn8wqeXbWd24Bank/ny9lwKriZGobAc3+8l8ck9
	 EYFN1FnNEJQFTrrpin8iekfhBp2Tkyw51EAUX66Q4+SzLzT+hrYNomzlQjC6cL3OI/
	 kzbgfXbbZNjBPD74OsrjOPC0tXxV5NLOpo3wV+3VDGgis3Sj9AUyP8LBaWzYze2C1I
	 x3U9/UQedLY/6oL8vSZ2pywb1Xu0Zs5HnC7h5JU4YsjbQkEFA2xvMj+bCjhA1qzbAm
	 DSz7Tue3931PQ==
Date: Wed, 04 Nov 2026 10:10:00 +0000
To: Bernard Metzler <bernard.metzler@linux.dev>
From: Jaeyeong Lee <lee@jaeyeong.cc>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] RDMA/siw: Fix early peer close handling on listeners
Message-ID: <20261104100953.125140-1-lee@jaeyeong.cc>
Feedback-ID: 177356447:user:proton
X-Pm-Message-ID: 6a45d80764dce613a8cdea825bddbeff5e30bf9a
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

A TCP child socket inherits the listener callbacks and sk_user_data before
kernel_accept() associates it with a new connection endpoint. If the peer
closes during this window, siw_cm_llp_state_change() queues a PEER_CLOSE
work item against the listening endpoint.

The worker releases that endpoint without removing it from the listener
list. A later listener teardown then walks the dangling entry, causing a
use-after-free in siw_destroy_listen().

Ignoring close notifications while the endpoint is LISTENING is not
sufficient. The endpoint remains IDLE for a short interval after listen()
starts accepting connections, and a close delivered before the accepted
socket is handed to its new endpoint would otherwise be lost.

Ignore close notifications from unaccepted child sockets during the IDLE
interval as well. During accept, serialize the endpoint handoff with TCP
state changes and reject a child that has already reached TCP_CLOSE or
TCP_CLOSE_WAIT. Live accepted sockets continue through the normal close
path.

The issue was found by static analysis. It was reproduced with SIW over
loopback in an x86_64 QEMU guest. KASAN reported the listener endpoint
use-after-free on the unpatched kernel. Tests covering RST before accept,
an MPA request followed by FIN, and an extended post-listen IDLE window
completed without KASAN or lockdep reports after this change.

Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
Cc: stable@vger.kernel.org
Signed-off-by: Jaeyeong Lee <lee@jaeyeong.cc>
---
Changes in v2:
- Cover the IDLE interval between listen() and the LISTENING transition.
- Serialize accepted-socket handoff and reject an already closed child.

 drivers/infiniband/sw/siw/siw_cm.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw=
/siw_cm.c
index ed49818793dde..92fcbcabb5984 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -973,6 +973,7 @@ static void siw_accept_newconn(struct siw_cep *cep)
 =09struct socket *s =3D cep->sock;
 =09struct socket *new_s =3D NULL;
 =09struct siw_cep *new_cep =3D NULL;
+=09bool peer_closed;
 =09int rv =3D 0; /* debug only. should disappear */
=20
 =09if (cep->state !=3D SIW_EPSTATE_LISTENING)
@@ -1009,11 +1010,23 @@ static void siw_accept_newconn(struct siw_cep *cep)
 =09}
 =09new_cep->sock =3D new_s;
 =09siw_cep_get(new_cep);
-=09new_s->sk->sk_user_data =3D new_cep;
=20
 =09if (siw_tcp_nagle =3D=3D false)
 =09=09tcp_sock_set_nodelay(new_s->sk);
+
+=09lock_sock(new_s->sk);
+=09write_lock_bh(&new_s->sk->sk_callback_lock);
 =09new_cep->state =3D SIW_EPSTATE_AWAIT_MPAREQ;
+=09new_s->sk->sk_user_data =3D new_cep;
+=09peer_closed =3D new_s->sk->sk_state =3D=3D TCP_CLOSE ||
+=09=09      new_s->sk->sk_state =3D=3D TCP_CLOSE_WAIT;
+=09write_unlock_bh(&new_s->sk->sk_callback_lock);
+=09release_sock(new_s->sk);
+
+=09if (peer_closed) {
+=09=09rv =3D -ECONNRESET;
+=09=09goto error;
+=09}
=20
 =09rv =3D siw_cm_queue_work(new_cep, SIW_CM_WORK_MPATIMEOUT);
 =09if (rv)
@@ -1361,6 +1374,10 @@ static void siw_cm_llp_state_change(struct sock *sk)
=20
 =09case TCP_CLOSE:
 =09case TCP_CLOSE_WAIT:
+=09=09if (cep->state =3D=3D SIW_EPSTATE_LISTENING ||
+=09=09    (cep->state =3D=3D SIW_EPSTATE_IDLE &&
+=09=09     !READ_ONCE(sk->sk_socket)))
+=09=09=09break;
 =09=09if (cep->qp)
 =09=09=09cep->qp->tx_ctx.tx_suspend =3D 1;
 =09=09siw_cm_queue_work(cep, SIW_CM_WORK_PEER_CLOSE);
--=20
2.43.0


