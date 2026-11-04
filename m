Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793796014;
	b=PedW0xDYleKOb/driltL4fHqh62b3VNfGdZ1dCnfHKL/p6AgQWzXpNfgRpGES9vf7AcU
	 YVAL8lZa6cwuW54AivO31jWXIrGKbvhD+6cRTc/4PXrD0A7i/qbxS7j5x8n0ZX2ADePQR
	 F+zlIfe3ESpxoVw01bB8sbrANrgR7XTNvtjQSpQURIfgJv5Sfh3OgTmUZUTR4U1xWYipa
	 N4Iz7uxupKbuaTtv29ekCVYb7NFT0wDRu+tg2EBSbBGHotDSZWHRFVLnlMW3EX2LY4djg
	 DKLt+DZWdTAeZu7NM4vRt95oqWwvNqffsWdbiSNnY1Dy9JTHzjs2nPZsxlApotU5sLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793796014;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=HmwZRIDXWrBpj2sZSITHJ9b0qDFSIwzwrskGykW8+Vo=;
	b=xX5w4n4Mt7v0DIofKyagWenkArYpeSpuvrLXkjFhTp6tKQ1g7K4DHlgM7Y8QJ/TAzphC
	 lBD08mxPHzNTT5O/YEs+8cSbcHnMszx68J03k9mx50N3S5xblR/TXU+ykocQSJ+IkfpLk
	 K61H6yE1tyQJggrEcE+MYC1JK0hJeTyZSreIDHVKVqfIKr1mRlAxFr8eMLSt2jQOF45/5
	 8LxFoHGi9R5SIyDYrERiyaXHLcv/twVFY2duYbdxFnu1a0sF3v2AgZwaF6V+SUgcuyaPT
	 pIsdlxDAhKoxGVIsg9SyQNfyZKul3cGWh0zowMr0pK5XTksD0yvnEq16sJGPI38MLOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gsST8B85;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037A2606A329;
	Wed,  4 Nov 2026 12:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gsST8B85
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5951F00919;
	Wed,  4 Nov 2026 12:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793796013;
	bh=HmwZRIDXWrBpj2sZSITHJ9b0qDFSIwzwrskGykW8+Vo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gsST8B85AowBQXTlkPG57duQGHyKfHVTdC5pwLZGucVgXGHYL4j74MOqMZcTtXoLM
	 i33QLgFgy2kCh2xkI2vRSoCMF+62OYukyVKUshIhQKTinmNW/X6QZR5ec/6O4Hkdvl
	 vrxmQlya35RBmjoJoNUfHiYbQ46sTXkXu0r7rny2auSeRr/kSRfVbvMbeiJrHQdpZD
	 XaJ18Aozl7JP/BBflK/GQjV/oSDrn9qka2O1GinbDbIrbiYvqHIep0yVrZedsS094Y
	 cvZrc4m1Wtw10+oXnC8TnPjTJfRTascVdpFXfBjmSI5iBddkHPsyLBNNTX1lkk2o82
	 A4kAcPSnDv+/g==
Message-ID: <sashiko-outbox-197280@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/smc: fix handshake abort on a terminating link
 group
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mahanta Jambigi" <mjambigi@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261103123955.47454-1-mjambigi@linux.ibm.com>
References: <20261103123955.47454-1-mjambigi@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 12:40:12 +0000
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
- [High] net/smc: rbtree corruption in smc_conn_kill() on device fallback r=
etry
- [High] net/smc: missing lgr->freeing check and set in smc_lgr_cleanup_ear=
ly()
--

commit e77e324c5a7154d6e8cb873cd42b560cca1a0bfa
Author: Mahanta Jambigi <mjambigi@linux.ibm.com>

net/smc: fix handshake abort on a terminating link group

This commit avoids calling __smc_lgr_terminate() in smc_lgr_cleanup_early()
when lgr->list is already empty, and updates smc_conn_kill() to unregister
and skip connections that already have conn->freed set.

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 6021322253e93..4e10da5bd8142 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -688,9 +688,15 @@ void smc_lgr_cleanup_early(struct smc_link_group *lg=
r)
> =20
>  	smc_lgr_list_head(lgr, &lgr_lock);
>  	spin_lock_bh(lgr_lock);
> +	if (list_empty(&lgr->list)) {
> +		/* another context already removed the link group from the
> +		 * list and will terminate it
> +		 */
> +		spin_unlock_bh(lgr_lock);
> +		return;
> +	}
>  	/* do not use this link group for new connections */
> -	if (!list_empty(&lgr->list))
> -		list_del_init(&lgr->list);
> +	list_del_init(&lgr->list);
>  	spin_unlock_bh(lgr_lock);
>  	__smc_lgr_terminate(lgr, true);
>  }

[Severity: High]
Should smc_lgr_cleanup_early() also check lgr->freeing and lgr->terminating,
and set lgr->freeing =3D 1 before dropping lgr_lock, similar to
smc_lgr_terminate_sched()?

In smc_smcd_terminate(), smc_smcd_terminate_all(), and
smc_smcr_terminate_all(), link groups are moved onto a stack-local
lgr_free_list and marked with lgr->freeing =3D 1 under lgr_lock before the
lock is dropped:

net/smc/smc_core.c:smc_smcd_terminate() {
	...
			list_move(&lgr->list, &lgr_free_list);
			lgr->freeing =3D 1;
		}
	}
	spin_unlock_bh(&dev->lgr_lock);

	/* cancel the regular free workers and actually free lgrs */
	list_for_each_entry_safe(lgr, l, &lgr_free_list, list) {
		list_del_init(&lgr->list);
		schedule_work(&lgr->terminate_work);
	}
}

If smc_lgr_cleanup_early() runs after dev->lgr_lock is released but before
the second loop runs list_del_init(&lgr->list), list_empty(&lgr->list) is
still false because lgr->list is linked into the other thread's stack-local
lgr_free_list. Wouldn't smc_lgr_cleanup_early() then corrupt lgr_free_list
with an unsynchronized list_del_init(&lgr->list) and proceed into
__smc_lgr_terminate() while holding the socket lock?

Conversely, when smc_lgr_cleanup_early() wins lgr_lock and unlinks
lgr->list without setting lgr->freeing =3D 1, __smc_lgr_terminate() only
calls non-synchronous cancel_delayed_work(&lgr->free_work), relying on
lgr->freeing to stop a concurrent smc_lgr_free_work():

net/smc/smc_core.c:smc_lgr_free_work() {
	...
	smc_lgr_list_head(lgr, &lgr_lock);
	spin_lock_bh(lgr_lock);
	if (lgr->freeing) {
		spin_unlock_bh(lgr_lock);
		return;
	}
	...
}

If smc_lgr_free_work() is already running and waiting on lgr_lock, or is
scheduled again before termination finishes, could it see lgr->freeing =3D=
=3D 0
and call smc_lgr_free(lgr) concurrently with __smc_lgr_terminate()?

> @@ -1519,6 +1525,17 @@ static void smc_conn_kill(struct smc_connection *c=
onn, bool soft)
>  {
>  	struct smc_sock *smc =3D container_of(conn, struct smc_sock, conn);
> =20
> +	if (conn->freed) {
> +		/* connection was already freed, e.g. by an aborted
> +		 * handshake, but kept its entry because smc_conn_free() skips
> +		 * the unregister for a link group that is no longer on the lgr
> +		 * list. Remove the stale entry, but do not kill a socket that
> +		 * may be an established fallback connection.
> +		 */
> +		smc_lgr_unregister_conn(conn);
> +		return;
> +	}

[Severity: High]
Can deferring smc_lgr_unregister_conn(conn) until smc_conn_kill() corrupt
lgr->conns_all or cause an infinite loop in __smc_lgr_terminate() when a
server handshake retries another device or SMC version on the same
new_smc->conn?

During server handshake in smc_listen_work(), lock_sock(&new_smc->sk) is
held across smc_listen_find_device(), which tries candidate ISM and RDMA
devices and versions in sequence:

  smc_listen_work()
    lock_sock(&new_smc->sk)
    smc_listen_find_device()
      smc_find_ism_v2_device_serv()
      smc_find_ism_v1_device_serv()
      smc_find_rdma_v2_device_serv()
      smc_find_rdma_v1_device_serv()

In each candidate helper, if smc_conn_create() registers new_smc->conn in
a link group (say lgr1) that is concurrently removed from lgr_list for
termination, the subsequent buffer creation or RMB registration (such as
smc_listen_rdma_reg() -> smcr_lgr_reg_rmbs() -> smc_llc_flow_initiate(),
which fails with -ENOLINK when list_empty(&lgr1->list) is true) fails and
calls smc_conn_abort(new_smc, ini->first_contact_local):

net/smc/af_smc.c:smc_find_rdma_v2_device_serv() {
	...
	rc =3D smc_listen_rdma_init(new_smc, ini);
	if (!rc) {
		rc =3D smc_listen_rdma_reg(new_smc, ini->first_contact_local);
		if (rc)
			smc_conn_abort(new_smc, ini->first_contact_local);
	}
	...
}

Because list_empty(&lgr1->list) is true, smc_conn_free() skips
smc_lgr_unregister_conn() and leaves new_smc->conn->alert_node in
lgr1->conns_all with a non-zero conn->alert_token_local, while
smc_lgr_cleanup_early() now returns immediately. Meanwhile,
__smc_lgr_terminate(lgr1) cannot run smc_conn_kill() yet because
smc_listen_work() still holds lock_sock(&new_smc->sk).

When smc_listen_find_device() moves on to the next candidate device or
version while still holding lock_sock(&new_smc->sk), it calls
smc_conn_create() -> smc_lgr_register_conn() again on the same
new_smc->conn:

net/smc/smc_core.c:smc_lgr_register_conn() {
	...
	if (!conn->lgr->is_smcd) {
		rc =3D smcr_lgr_conn_assign_link(conn, first);
		if (rc) {
			conn->lgr =3D NULL;
			return rc;
		}
	}
	/* find a new alert_token_local value not yet used by some connection
	 * in this link group
	 */
	sock_hold(&smc->sk); /* sock_put in smc_lgr_unregister_conn() */
	while (!conn->alert_token_local) {
		conn->alert_token_local =3D atomic_inc_return(&nexttoken);
		if (smc_lgr_find_conn(conn->alert_token_local, conn->lgr))
			conn->alert_token_local =3D 0;
	}
	smc_lgr_add_alert_token(conn);
}

At that point:

1. If the second smc_lgr_register_conn() succeeds on another link group
   lgr2, it sets conn->lgr =3D lgr2, takes a second sock_hold(&smc->sk),
   reuses the stale conn->alert_token_local, inserts conn->alert_node into
   lgr2->conns_all while it is still linked in lgr1->conns_all, and clears
   conn->freed =3D 0. When lock_sock(&new_smc->sk) is later released,
   __smc_lgr_terminate(lgr1) wakes up and runs smc_conn_kill(), which sees
   conn->freed =3D=3D 0, aborts the active connection on lgr2, and unregist=
ers
   conn from conn->lgr (lgr2) instead of lgr1.

2. If the second smc_lgr_register_conn() fails in
   smcr_lgr_conn_assign_link(), it sets conn->lgr =3D NULL. When
   __smc_lgr_terminate(lgr1) later acquires lock_sock(&new_smc->sk) and
   calls smc_conn_kill() -> smc_lgr_unregister_conn(conn),
   smc_conn_lgr_valid(conn) is false because conn->lgr is NULL, so
   conn->alert_node is never removed from rb_first(&lgr1->conns_all) and
   __smc_lgr_terminate(lgr1) loops forever.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103123955.4745=
4-1-mjambigi@linux.ibm.com?part=3D1
