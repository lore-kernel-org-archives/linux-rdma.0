Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792987407;
	b=Q3eTRTzXX6P52Ov2a4reIEr+1M2LGnA6kxN3MzxW35LI2m7tKilFTe6b1dNf+ZKRcE7M
	 h+itOagY0tZDPyaJ7ytouvUSX+iPyMByeJtIvzyIAqGEBqH2FWblyhuZKJ2V0NmCbuZs+
	 qoJidxkQn2BjieMdDIQ0JThhpXB8xvI3y+/zcwv6US29gojIt8CnIrRLi3gB46SfcesfX
	 WLeSL3wyLAvYmFoIgnQdPTmmVmGRYnpxFRmWNZaK7WpALue+tnV0tNT6GdLktOtFLAEZM
	 O9B8MfFAm1cE2w4s0BwOX9hGsEb72L4/PKV2IUE8M5joeXSCCSgwb5jtoGAHrY/K4UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792987407;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=UZp1COSWoy3dkBmZ5MRFM90yfnQonoRTNPpwCNCjHug=;
	b=aOKV5FkTDbZbzsiVQvrclyI/vgBAXlZ41Rohe68f8Ge3XYBw/QC3PDnDDwWsOjrJc6AM
	 X9iUXBagT2Kdcc8Gi/FnVKf4aEqApHR+mvwLD5nEDDafdDyEh/N8bcHvN0pI1VTRNnzBQ
	 mmqYm1AGSHbRT9tcqpsXypdcwgYNg4/L5KQPy4Fd63aNvbUiiZEeNlkhULLsTQHGjPby/
	 mWsoJYSGdLukA/umbUALQ9/HaIhzzrHNQAMmhZZefB6w2h2IIED3xAwQRW0djnlW+v44B
	 18Xn7S4UpVQk6UC8RodjHZ+KCn7Ee9Lk90rYekOsp2ZGlpR01U/1+H1LVm8jRSxH29A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DfhiwTzG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7072B606A31A;
	Mon, 26 Oct 2026 04:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DfhiwTzG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6FA1F01828;
	Mon, 26 Oct 2026 04:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792987407;
	bh=UZp1COSWoy3dkBmZ5MRFM90yfnQonoRTNPpwCNCjHug=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DfhiwTzGhrkrmFd8KTV214mmP5j7/awrNrnh+nOWI5SIKKr9L0eiTrE/8oWbe/s6N
	 RjrsPFDleF4hAK8spNotN8YbI3F4uVgik+cONew5J1dIItQ+/g/t54D26/7juBw7hU
	 g+bYWGdlHwnpHeN+yVC1ZWYsZdPimPa8wvqRowhlIWhLMBJYgE22dAIY04SvE1mmSf
	 cdcnKR0qDJ0p8nZW0ahn2PRF5ZGx7i+y+opHRWHrgw3wzSdFcIIK+LhGMVNiEin8Ls
	 HYrVBXTv17jvboZU8LI1kO08lHkMtRBs8i7Me1wv7Ki1/m7F+Vpylz1D95TkI1JihD
	 2atJr1OiXhkJw==
Message-ID: <sashiko-outbox-184612@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] net/smc: fix possible recursive locking in
 __smc_lgr_terminate()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anfernee Cao" <anferneemelokc5@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <179290097759.51540.15412712294727302463@gmail.com>
References: <179290097759.51540.15412712294727302463@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 04:03:26 +0000
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
- [High] net/smc: self-deadlock in __smc_lgr_terminate() masked by lock_soc=
k_nested()
- [Medium] net/smc: lockdep subclass inversion and unannotated relock in sm=
c_conn_kill()
--

commit 7303e5e7071cf52d837c7140d6a0e1615372a594
Author: Anfernee Cao <anferneemelokc5@gmail.com>

net/smc: fix possible recursive locking in __smc_lgr_terminate()

This commit replaces lock_sock() with lock_sock_nested() in
__smc_lgr_terminate() to suppress a lockdep recursive locking warning when
smc_listen_work() aborts a connection and cleans up the link group early.

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 6021322253e93..64c5ee592e641 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1579,7 +1579,7 @@ static void __smc_lgr_terminate(struct smc_link_gro=
up *lgr, bool soft)
>  		smc =3D container_of(conn, struct smc_sock, conn);
>  		sock_hold(&smc->sk); /* sock_put below */
>  		read_unlock_bh(&lgr->conns_lock);
> -		lock_sock(&smc->sk);
> +		lock_sock_nested(&smc->sk, SINGLE_DEPTH_NESTING);

[Severity: High]
Can this mask a real self-deadlock on new_smc->sk rather than a false
positive?

The commit description assumes smc_conn_free() always unregisters new_smc
from lgr->conns_all before smc_conn_abort() calls smc_lgr_cleanup_early().
However, in net/smc/smc_core.c, smc_conn_free() only unregisters the
connection if lgr->list is non-empty:

net/smc/smc_core.c:smc_conn_free() {
	...
	if (!list_empty(&lgr->list)) {
		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
		smc_lgr_unregister_conn(conn);
	}
	...
}

When smc_listen_work() in net/smc/af_smc.c holds lock_sock(&new_smc->sk) and
waits for a confirm message via smc_clc_wait_msg(), a peer decline message
with the first-contact flag set causes smc_clc_wait_msg() in
net/smc/smc_clc.c to schedule link group termination before returning:

net/smc/smc_clc.c:smc_clc_wait_msg() {
	...
		if ((dclc->hdr.typev2 & SMC_FIRST_CONTACT_MASK) &&
		    smc->conn.lgr) {
			smc->conn.lgr->sync_err =3D 1;
			smc_lgr_terminate_sched(smc->conn.lgr);
		}
	...
}

smc_lgr_terminate_sched() runs list_del_init(&lgr->list) and queues
lgr->terminate_work asynchronously while lgr->terminating is still 0.

When smc_listen_work() then calls
smc_listen_decline() -> smc_conn_abort() -> smc_conn_free(),
list_empty(&lgr->list) is already true, so smc_lgr_unregister_conn(conn) is
skipped and new_smc->conn remains in lgr->conns_all:

net/smc/af_smc.c:smc_conn_abort() {
	...
	smc_conn_free(conn);
	if (local_first && lgr_valid)
		smc_lgr_cleanup_early(lgr);
}

If smc_lgr_cleanup_early() -> __smc_lgr_terminate() runs before
lgr->terminate_work sets lgr->terminating, rb_first(&lgr->conns_all) returns
new_smc->conn itself. Using lock_sock_nested() here hides the recursive lock
acquisition from lockdep by assigning subclass 1 while the current task
already holds &new_smc->sk at subclass 0, causing the worker to hang in
__lock_sock(). The same sequence also applies to client first-contact setup
in smc_connect_rdma() and smc_connect_ism().

>  		smc_conn_kill(conn, soft);

[Severity: Medium]
Even when __smc_lgr_terminate() locks a different socket on the link group,
does using subclass 1 here invert the existing lockdep subclass hierarchy a=
nd
leave unannotated relocks inside smc_conn_kill()?

In net/smc/af_smc.c, smc_release() locks listening sockets with subclass 1
before smc_close_active() -> smc_close_cleanup_listen() ->
smc_close_non_accepted() locks child sockets at subclass 0:

net/smc/af_smc.c:smc_release() {
	...
	if (sk->sk_state =3D=3D SMC_LISTEN)
		/* smc_close_non_accepted() is called and acquires
		 * sock lock for child sockets again
		 */
		lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
	else
		lock_sock(sk);
	...
}

Locking a connection socket with subclass 1 in __smc_lgr_terminate() while
smc_listen_work() holds new_smc->sk at subclass 0 establishes the reverse
0 -> 1 ordering.

In addition, smc_conn_kill() calls smc_close_active_abort() in
net/smc/smc_close.c, which drops the socket lock and re-acquires it at
subclass 0 via smc_close_cancel_work() and when releasing clcsock:

net/smc/smc_close.c:smc_close_cancel_work() {
	struct sock *sk =3D &smc->sk;

	release_sock(sk);
	if (cancel_work_sync(&smc->conn.close_work))
		sock_put(sk);
	if (cancel_delayed_work_sync(&smc->conn.tx_work))
		sock_put(sk);
	lock_sock(sk);
}

net/smc/smc_close.c:smc_close_active_abort() {
	...
	if (release_clcsock) {
		release_sock(sk);
		smc_clcsock_release(smc);
		lock_sock(sk);
	}
	...
}

Wouldn't those plain lock_sock(sk) calls still trigger the recursive locking
warning against new_smc->sk when killing another active connection in the
link group?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/179290097759.51540.=
15412712294727302463@gmail.com?part=3D1
