Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792494641;
	b=WMq0yDHh3GBfRpfLCp5nnJDUkL+H2FiWVZxu3Hpzn3+xxugWUfs5gny6gLm1L8UfzaZP
	 qnqgMiXkuv8Dwb3vzUovzzKTw+j+x8R02omERbDgszYb6ELeYFFviWP5w4aYzM2yRyKG4
	 1tTfbRRrI/4N768nKcENdJnwqfS6f8KRNO3StOUUzoYmSAMcm7+y0q4ViE1+iM9UEG8vm
	 1sLcbXyZPwJYsAsazqQxlPJHWJQYTX8YU0bQItMd0N4SsCPgZQ2N8ForD1/nrLJ8s8lS1
	 dgKXk1VhNh40G59pe0p1kZ/KTi/91u5cdyFDDC0NXclD2ND0fLFXQhjYZQeXPeMHbRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792494641;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=nSRnuD0h7o9UaoP3tl+kI1Fx5NlfccpV/hYQcB9Oe5o=;
	b=MtbBn+p+1M4nnTuaBAc8pjhEfEJJPRiUAfQS/ve3nDwbkrvCQmOdrZnGhgKI9UCRsyVd
	 BOV4ymc+BHAvWZJthH3vGKO9R4PyXt7wvjL0tworJHuAJPjvKi9fVgp0BU4caDdP1SlvQ
	 eXO3wI94N5kRFpZJKP3EYNWLOkmV1s+fV8USOvkl9/wfVgW0EdGupwuhqNPJisyPdGX1K
	 9Ry1NqFCzS8+NC4YXAQTyxn6bi3InKejLlde/jyebBm0BElA+JSF8hF6mNxXuxYTLdqbK
	 PLNrW/u4Whl5XAyNQxvR+gDK2ste0l8bhnJotdfDmtJ2i3XUZaHXBvUrCTtN7FibZgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X0lUNzxy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C39606A31A;
	Tue, 20 Oct 2026 11:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X0lUNzxy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FCC71F000C5;
	Tue, 20 Oct 2026 11:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792494641;
	bh=nSRnuD0h7o9UaoP3tl+kI1Fx5NlfccpV/hYQcB9Oe5o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X0lUNzxyWKer2YGEGlIJy91k9++71see2qybQ0L99ClpDHpCuHpX53XuGRNkDU/Zn
	 XFBI2jF0anxgj/m8cf+BvD4fZ4F6HrX1OmyvRE5Vrp4dr9ruJF+eVv+Cq1Pi2Vadws
	 mCyVb31hIFv7MNLGFmiyv3sk49jfDQo4ITQwGuMrNpS3Vo/G0hOD1Lng3hJYPRfPBz
	 2Iz4s/mDNBhXwTLbVuppl4cZYsQNBHi6KKw7pwzP6hTjfa7kvII7Y1w/vl68xxotMO
	 LKPsilIhqs8mOmVLr5sNYbo4HSZykV6G2W3oYmMSEcUOKiAqzgVsEO1zbTQW4qc8Os
	 BEF+hbHZOvkug==
Message-ID: <sashiko-outbox-178883@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v12] net/smc: fix lgr/lnk lifetime vs diag reader
 race
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mahanta Jambigi" <mjambigi@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261019111008.3367567-1-mjambigi@linux.ibm.com>
References: <20261019111008.3367567-1-mjambigi@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 11:10:40 +0000
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
- [Critical] net/smc: race in smc_lgr_schedule_free_work() can arm free_wor=
k before kfree
- [High] net/smc: missing release barrier on client SMC_INIT to SMC_CLOSED =
transition
--

commit ac5d5191510569377b3ad3881fe61cfb7d941a9d
Author: Mahanta Jambigi <mjambigi@linux.ibm.com>

net/smc: fix lgr/lnk lifetime vs diag reader race

This commit addresses several races between SMC socket/link group teardown
and concurrent sock_diag readers by adjusting sk_state ordering, unhashing
sockets earlier in teardown paths, skipping extended diag attributes in
SMC_INIT/SMC_CLOSED, and unconditionally unregistering connections in
smc_conn_free().

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 9974149659c2f..9d8165d1b40c5 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -84,7 +84,7 @@ static void smc_lgr_schedule_free_work(struct smc_link_=
group *lgr)
>  	 * creation. For client use a somewhat higher removal delay time,
>  	 * otherwise there is a risk of out-of-sync link groups.
>  	 */
> -	if (!lgr->freeing) {
> +	if (!lgr->freeing && !lgr->terminating) {
>  		mod_delayed_work(system_percpu_wq, &lgr->free_work,
>  				 (!lgr->is_smcd && lgr->role =3D=3D SMC_CLNT) ?
>  						SMC_LGR_FREE_DELAY_CLNT :
> @@ -1279,10 +1279,9 @@ void smc_conn_free(struct smc_connection *conn)
>  		if (current_work() !=3D &conn->abort_work)
>  			cancel_work_sync(&conn->abort_work);
>  	}
> -	if (!list_empty(&lgr->list)) {
> +	if (!list_empty(&lgr->list))
>  		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
> -		smc_lgr_unregister_conn(conn);
> -	}
> +	smc_lgr_unregister_conn(conn);
> =20
>  	if (!lgr->conns_num)
>  		smc_lgr_schedule_free_work(lgr);

[Severity: Critical]
Can smc_lgr_schedule_free_work() still race with __smc_lgr_terminate() and
re-arm lgr->free_work right before lgr is freed?

In smc_lgr_cleanup_early(), the link group is unlinked from lgr->list while
both lgr->freeing and lgr->terminating are still 0, and then
__smc_lgr_terminate() cancels free_work before setting lgr->terminating:

net/smc/smc_core.c:__smc_lgr_terminate() {
	if (lgr->terminating)
		return;	/* lgr already terminating */
	/* cancel free_work sync, will terminate when lgr->freeing is set */
	cancel_delayed_work(&lgr->free_work);
	lgr->terminating =3D 1;
	...
}

Because smc_conn_free() now calls smc_lgr_unregister_conn(conn)
unconditionally and invokes smc_lgr_schedule_free_work(lgr) outside
lgr->conns_lock, can the following interleaving occur when another
connection on the same link group is concurrently freed?

CPU0 (smc_conn_free)                   CPU1 (smc_lgr_cleanup_early)
--------------------                   ----------------------------
smc_lgr_unregister_conn(conn)
  lgr->conns_num becomes 0
smc_lgr_schedule_free_work(lgr)
  sees !lgr->freeing &&
       !lgr->terminating
                                       __smc_lgr_terminate(lgr, true)
                                         cancel_delayed_work(&lgr->free_wor=
k)
                                         lgr->terminating =3D 1
                                         ...
                                         smc_lgr_free(lgr)
                                           smc_lgr_put(lgr)
  mod_delayed_work(..., &lgr->free_work, ...)
smc_lgr_put(lgr)
  __smc_lgr_free(lgr)
    kfree(lgr)

If that happens, wouldn't lgr be freed via kfree(lgr) while lgr->free_work
remains queued in system_percpu_wq?

[ ... ]

> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
> index bf0beaa23bdb6..36a3b8f31f28d 100644
> --- a/net/smc/smc_diag.c
> +++ b/net/smc/smc_diag.c
> @@ -87,10 +87,11 @@ static int __smc_diag_dump(struct sock *sk, struct sk=
_buff *skb,
> =20
>  	r =3D nlmsg_data(nlh);
>  	smc_diag_msg_common_fill(r, sk);
> -	r->diag_state =3D sk->sk_state;
> +	r->diag_state =3D smp_load_acquire(&sk->sk_state);
>  	if (smc->use_fallback)
>  		r->diag_mode =3D SMC_DIAG_MODE_FALLBACK_TCP;
> -	else if (smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
> +	else if (r->diag_state !=3D SMC_INIT &&
> +		 smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
>  		r->diag_mode =3D SMC_DIAG_MODE_SMCD;
>  	else
>  		r->diag_mode =3D SMC_DIAG_MODE_SMCR;

[Severity: High]
Should this condition also exclude r->diag_state =3D=3D SMC_CLOSED, or shou=
ld
smc_close_active() use smp_store_release() when transitioning from SMC_INIT
to SMC_CLOSED?

On the client side, if smc_connect_rdma() or smc_connect_ism() fails after
smc_conn_create() and jumps to connect_abort, smc_conn_abort() calls
smc_conn_free() and smc_lgr_cleanup_early(), which clears
conn->alert_token_local and frees conn->lgr while leaving conn->lgr non-NUL=
L.

If fallback is not possible in smc_connect_decline_fallback() (or fails in
smc_connect_fallback()), smc->use_fallback remains false and sk->sk_state
remains SMC_INIT.

When the socket is then closed via smc_release() -> __smc_release() ->
smc_close_active(), sk->sk_state is set to SMC_CLOSED with a plain store
while the socket is still hashed:

net/smc/smc_close.c:smc_close_active() {
	...
	switch (sk->sk_state) {
	case SMC_INIT:
		sk->sk_state =3D SMC_CLOSED;
		break;
	...
}

On weakly ordered CPUs, if a concurrent reader in __smc_diag_dump() observes
r->diag_state =3D=3D SMC_CLOSED from that plain store, there is no release
barrier ordering the earlier conn->alert_token_local =3D 0 store before the
sk_state transition, and the diag_mode check here only filters out SMC_INIT
(unlike the SMC_INIT || SMC_CLOSED check further down). Could
__smc_diag_dump() then see a stale non-zero alert_token_local and
dereference the freed smc->conn.lgr->is_smcd?

[ ... ]

> @@ -103,6 +104,9 @@ static int __smc_diag_dump(struct sock *sk, struct sk=
_buff *skb,
>  	if (nla_put(skb, SMC_DIAG_FALLBACK, sizeof(fallback), &fallback) < 0)
>  		goto errout;
> =20
> +	if (r->diag_state =3D=3D SMC_INIT || r->diag_state =3D=3D SMC_CLOSED)
> +		goto out;
> +
>  	if ((req->diag_ext & (1 << (SMC_DIAG_CONNINFO - 1))) &&
>  	    smc->conn.alert_token_local) {
>  		struct smc_connection *conn =3D &smc->conn;

[ ... ]

>
> base-commit: 07bd391eb9572e74f073c49acef327611234f9bb

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019111008.3367=
567-1-mjambigi@linux.ibm.com?part=3D1
