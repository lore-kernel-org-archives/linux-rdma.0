Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794616387;
	b=d2TD1viMBcUmN6xg0yLb9VbM6VPkLQksAOCRhqDTAIdjHnJHRnWOaaAvuniNhMbZ1otc
	 uPzGxLans2Wotbag2MLaKKLfT7IoNcrSUzM+plfP7TYoxWOC6xXl3vLlT2nJ6WDSDRrA8
	 d6G+44K5cRLv9yfm+SUleolxI054JTG7YE/5ssTR63EQmpD6sUidL5JzP2SQpDNJdGDoX
	 GnJoUTGddus1May23qIPstlnUbwIJKYmDp8XH7iNRB4tf9nSsu0b17fenriA2lXfgEHSx
	 dR8hC/bCHGkW3uvWLO11cDsRv4NQWQsBDJL8vchmrE+NNbEKFJDM4U6/6usicdNiJKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794616387;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=CR/mSBqTjM2cXuEWsyodd1eK/6RniIw27h9vWPhxiAE=;
	b=vBarF7zcDjPQcIl7UObozi2v6KszSbgWY78O4rrk+F2ahNeTYu+lK55TRiiFY1byr/zL
	 g+7YI5B+dIlVPP1UXFvA30r7d7f7MIPlFLtHzZg93K58yW13ulJPuCVa7KqHwHJN2OnqX
	 pGkc7Dt1UcqDetcaltLPE3U9W/wvXcmWq9axze5kgfe9Ip0oo+h7WvYO43PPpwCMKuSVq
	 r1br1fCpzbH9RocPZAOZ6kerOVqxtzrBg7m0hawquP3dxaOFWTHPlKGzZyEBx2QKmkUTx
	 ic5dXXlOZZjpRUL4vJD3u+xsMWHRzSbBVFUtA6RYyq0NVLgp7sDI8kp534iZiruGIaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lRCgHrL0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B927606A33F;
	Sat, 14 Nov 2026 00:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lRCgHrL0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006DE1F000C5;
	Sat, 14 Nov 2026 00:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794616387;
	bh=CR/mSBqTjM2cXuEWsyodd1eK/6RniIw27h9vWPhxiAE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lRCgHrL0gn58YaNTyBV7XgCfXgZnFuc0XRTb5VR95635SG99u1rHdFgbWojlul6DO
	 cUTHOmS4nkag212XaOSRYT9jNrmMWcLz0+Z950u4PLQBUg884FUV/E5sJVkPAZldNb
	 OJN5A6RH6H8nToW87NF2iuOZ2HyASQT69tsIpJnCOAsOZJHrMw5M/0uNPdE/QitKaQ
	 CgS/DIqStBKNcFig04rnDW/mAI88cbxXPEsQGvcLnlAniKD+ta+Dw2oXtFg8kbj/Z7
	 FFOFyO5q++IbQJbw7zC5Oh9kqr/0UMTrVjfAIxzljDNbwcQAa8t5Nqs1RJlrFIZK74
	 /PFZ5rTh3rmOQ==
Message-ID: <sashiko-outbox-213928@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v6 2/3] net/smc: clear the buffer pointers before
 registering a connection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261112-b4-disp-1c8d3a53-v6-2-36a38ae35021@proton.me>
References: <20261112-b4-disp-1c8d3a53-v6-0-36a38ae35021@proton.me>
 <20261112-b4-disp-1c8d3a53-v6-2-36a38ae35021@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 00:33:06 +0000
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
- [High] net/smc: use-after-free in smc_cdc_msg_recv_action() when
  rmb_desc is cleared in smc_conn_create()
--

commit c3e0f3590aa6e2fc44b4f81762f89b1bd1bf1ccb
Author: Bryam Vargas <hexlabsecurity@proton.me>

net/smc: clear the buffer pointers before registering a connection

This commit clears conn->rmb_desc and conn->sndbuf_desc under the socket
spinlock in smc_conn_create() and checks conn->rmb_desc in
smc_cdc_msg_recv_action() to avoid using stale buffer pointers after a
failed handshake attempt.

> diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
> index ee5ba6c7a5b4a..b3bcc206efe3e 100644
> --- a/net/smc/smc_cdc.c
> +++ b/net/smc/smc_cdc.c
> @@ -334,6 +334,10 @@ static void smc_cdc_msg_recv_action(struct smc_sock =
*smc,
>  	struct smc_connection *conn =3D &smc->conn;
>  	int diff_cons, diff_prod, diff_tx;
> =20
> +	/* smc_conn_create() can have cleared rmb_desc */
> +	if (!smp_load_acquire(&conn->rmb_desc))
> +		return;
> +
>  	smc_curs_copy(&prod_old, &conn->local_rx_ctrl.prod, conn);
>  	smc_curs_copy(&cons_old, &conn->local_rx_ctrl.cons, conn);
>  	smc_cdc_msg_to_host(&conn->local_rx_ctrl, cdc, conn);
[ ... ]
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 02269cede641e..9ef9019bc4974 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -2024,6 +2024,15 @@ int smc_conn_create(struct smc_sock *smc, struct s=
mc_init_info *ini)
>  	spinlock_t *lgr_lock;
>  	int rc =3D 0;
> =20
> +	/* A retried handshake comes back with the buffer pointers of the
> +	 * failed attempt still set: clear them before the connection is
> +	 * registered. smc_cdc_msg_recv_action() tests rmb_desc under this lock.
> +	 */
> +	spin_lock_bh(&smc->sk.sk_lock.slock);
> +	WRITE_ONCE(conn->rmb_desc, NULL);
> +	WRITE_ONCE(conn->sndbuf_desc, NULL);
> +	spin_unlock_bh(&smc->sk.sk_lock.slock);
> +
>  	lgr_list =3D ini->is_smcd ? &ini->ism_dev[ini->ism_selected]->lgr_list :
>  				  &smc_lgr_list.list;
>  	lgr_lock =3D ini->is_smcd ? &ini->ism_dev[ini->ism_selected]->lgr_lock :

[Severity: High]
Can smc_cdc_msg_recv_action() still dereference freed conn->rmb_desc,
conn->sndbuf_desc and conn->lgr when the buffer pointers are cleared in
smc_conn_create() instead of smc_conn_free()?

In smc_conn_free(), smc_buf_unuse() releases or frees the buffers before
smc_lgr_unregister_conn() removes the connection from lgr->conns_all, and
smc_lgr_put() and smc_lgr_cleanup_early() then drop the link group:

net/smc/smc_core.c:smc_conn_free() {
	...
	if (!list_empty(&lgr->list))
		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
	smc_lgr_unregister_conn(conn);
	...
	smc_lgr_put(lgr); /* lgr_hold in smc_conn_create() */
}

Because bh_lock_sock(&smc->sk) in smc_cdc_msg_recv() only acquires
sk_lock.slock without waiting for process-context lock_sock(), an
incoming CDC message can run smc_cdc_msg_recv_action() before
smc_conn_create() is called (or when no retry occurs, such as when the
handshake aborts without a fallback device):

kworker                                   <softirq>
smc_listen_rdma_reg()
  ...
                                          smc_cdc_rx_handler()
                                            read_lock_bh(&lgr->conns_lock)
                                            conn =3D smc_lgr_find_conn(...)
                                            !smp_load_acquire(&conn->rmb_de=
sc)
                                            sock_hold(&smc->sk)
                                            read_unlock_bh(&lgr->conns_lock)
  smc_conn_abort()
    smc_conn_free()
      smc_buf_unuse()
        smc_buf_free() -> kfree(rmb_desc)
      smc_lgr_unregister_conn()
      smc_lgr_put()
    smc_lgr_cleanup_early()
                                            smc_cdc_msg_recv()
                                              bh_lock_sock(&smc->sk)
                                              smc_cdc_msg_recv_action()
                                                !smp_load_acquire(&conn->rm=
b_desc)
                                                conn->rmb_desc->len
                                                  <-- use-after-free

Even when a retry does reach smc_conn_create(), if the in-flight
smc_cdc_rx_handler() acquires bh_lock_sock(&smc->sk) after the retry has
called __smc_buf_create(), conn->rmb_desc is non-NULL again and
smc_cdc_msg_recv_action() applies the stale CDC from the aborted attempt
to the new connection.

Clearing conn->rmb_desc and conn->sndbuf_desc under sk_lock.slock in
smc_conn_free() after smc_lgr_unregister_conn() and before
smc_buf_unuse() would close both windows.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112-b4-disp-1c=
8d3a53-v6-0-36a38ae35021@proton.me?part=3D2
