Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1C7542EFD;
	Wed, 14 Oct 2026 14:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791987403; cv=none; b=c00uPZU65HxwqX/mJU0yD9VSh8kUfh7PufZaFdVH5ihWZwjI9ZV3UY9LrZDedkQ93I5iC0IImby5hzpM++mfQ5muKIYwstLUWI5H20fp0G0443HApAINgnHOorqFo5bSL7Bqh5cIiO3EulVp+zXBvggPrKBtDabvmfm6hha7zjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791987403; c=relaxed/simple;
	bh=gwZwIDXWH6+oX/jdGf1vh+hw9D/uky5YsV+364tExaI=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qiFqhkksOX1a6FdQY9pwymvmtcKE7ERhWhtp1AlguYqUL5TPqtJtFHM3RLclZIK9r363ToPoKx8eVa6aZODF43IY5BGU6r8QxA4Znw/x6nbkeC+Gs4Dveq9WqT0MhxDmLsYVO/phR2YHZsf7ETP+T6qGWCqd4yEfRjypviNslaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iZeEocH4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iZeEocH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389FE1F000D4;
	Wed, 14 Oct 2026 14:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791987400;
	bh=K7vsT8RC9p9fOYHpYIE8xbjNZ8+LExI8FP2yP+i0sqk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=iZeEocH4uZ82CarWi/H3zlsVTfh9SLIyBxISWf/oJAfSzIFitloOejriv3kVPpv/W
	 Rin2xi2RavGiefLkeIiiTeJzmYC1dw4UeeIE40+Ndw53O2+6ym71Eack60QmUtXlXk
	 /nW2VVcChMqzipvocV1WJo9kGUAs/o/EK/Ldx4JBrJYbEyoex2gEVl+hoHgvnGSiIr
	 qPlo5L+YOtBiZffmASK/Sv1RtAkAAeZnKf/y8slsI3FO2QFzDf51YO9SEzf5nznK8V
	 kweC7DXWyfl0+4qpoIKzBI/hx1OE4WqTbQ5FGRhQ8/NFN1vk/IYHE0oRay5hQlkrER
	 Ud23X4Vj3vplA==
Subject: Re: [PATCH net v10] net/smc: fix lgr/lnk lifetime vs diag reader race
From: netdev-bot+sashiko@kernel.org
To: mjambigi@linux.ibm.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, hidayath@linux.ibm.com,
 pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, stable@vger.kernel.org, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Date: Wed, 14 Oct 2026 14:16:38 +0000
Message-ID: <179198739873.434549.14480502288349527609@kernel.org>
In-Reply-To: <20261013141510.2621698-1-mjambigi@linux.ibm.com>
References: <20261013141510.2621698-1-mjambigi@linux.ibm.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 1 (1) · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix still leaves a use-after-free between the diag reader
  and the lgr.
- [Medium] Switching to link->ibname removes the NULL dereference through
  link->smcibdev->ibdev.
- [Low] SMC_DIAG_LGRINFO now reports link->ibname, which
  smcr_copy_dev_info_to_link() (smc_core.c:783-784) caches at link…

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the teardown
  sites it touches have a deadlock.

--

net/smc: fix lgr/lnk lifetime vs diag reader race

This patch tries to close races between the SMC sock_diag dump and the
teardown of conn/lgr/lnk state. It skips the extension attributes for
sockets in SMC_INIT or SMC_CLOSED and orders sk_state with acquire/release.
It also unhashes the socket before several smc_conn_free() and
smcd_buf_detach() calls, and uses the cached link->ibname in the LGRINFO
dump.

[ ... ]

> diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
> index bb0313ef5f7c1..aa6363abdd747 100644
> --- a/net/smc/smc_close.c
> +++ b/net/smc/smc_close.c

[ ... ]

> @@ -433,6 +435,7 @@ static void smc_close_passive_work(struct work_struct *work)
>  		sk->sk_state_change(sk);
>  		if ((sk->sk_state == SMC_CLOSED) &&
>  		    (sock_flag(sk, SOCK_DEAD) || !sk->sk_socket)) {
> +			sk->sk_prot->unhash(sk);
>  			smc_conn_free(conn);

[Severity: High]
This is a pre-existing issue and was not introduced by this patch. Can this
smc_conn_free() call deadlock against abort_work?

smc_close_passive_work() holds lock_sock(sk) here. For SMC-R,
smc_conn_free() then does:

		if (current_work() != &conn->abort_work)
			cancel_work_sync(&conn->abort_work);

The connection is still registered at this point. A CDC message with
failover_validation and a seqno ahead can make smc_cdc_msg_validate()
queue abort_work on smc_close_wq, and it does this without the socket lock.
smc_close_wq can run that work alongside close_work, and
smc_conn_abort_work() starts with:

	lock_sock(&smc->sk);
	smc_conn_kill(conn, true);

If abort_work is already running and blocked in lock_sock(), would this
thread wait forever in cancel_work_sync() while it holds that same socket
lock? The current_work() check only stops abort_work from cancelling
itself.

smc_close_active_abort() also reaches smc_conn_free() with the socket lock
held.

>  			if (smc->clcsock)
>  				release_clcsock = true;

[ ... ]

> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
> index bf0beaa23bdb6..36a3b8f31f28d 100644
> --- a/net/smc/smc_diag.c
> +++ b/net/smc/smc_diag.c

[ ... ]

> @@ -103,6 +104,9 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>  	if (nla_put(skb, SMC_DIAG_FALLBACK, sizeof(fallback), &fallback) < 0)
>  		goto errout;
>  
> +	if (r->diag_state == SMC_INIT || r->diag_state == SMC_CLOSED)
> +		goto out;
> +
>  	if ((req->diag_ext & (1 << (SMC_DIAG_CONNINFO - 1))) &&
>  	    smc->conn.alert_token_local) {
>  		struct smc_connection *conn = &smc->conn;

[Severity: High]
Does this guard miss a fallback socket in SMC_ACTIVE that still has a stale
alert_token_local after its lgr reference was dropped?

On the server side, the peer can answer with a CLC DECLINE that has the
first contact bit set instead of a CONFIRM. smc_clc_wait_msg() then does:

net/smc/smc_clc.c:smc_clc_wait_msg() {
    ...
		if ((dclc->hdr.typev2 & SMC_FIRST_CONTACT_MASK) &&
		    smc->conn.lgr) {
			smc->conn.lgr->sync_err = 1;
			smc_lgr_terminate_sched(smc->conn.lgr);
		}
    ...
}

smc_lgr_terminate_sched() calls list_del_init(&lgr->list).

The handshake then aborts through
smc_listen_decline()->smc_conn_abort()->smc_conn_free(). At that point
lgr->list is empty:

	if (!list_empty(&lgr->list)) {
		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
		smc_lgr_unregister_conn(conn);
	}

So the connection is not unregistered and alert_token_local stays
non-zero, but smc_lgr_put() still drops the lgr reference. The socket then
falls back, smc_listen_out_connected() stores SMC_ACTIVE, and the socket
stays hashed.

Later, terminate_work runs __smc_lgr_terminate():

		lock_sock(&smc->sk);
		smc_conn_kill(conn, soft);
		release_sock(&smc->sk);
	...
	smc_lgr_cleanup(lgr);
	smc_lgr_free(lgr);

For SMC-R and non-nocopy SMC-D, smc_conn_kill() does not unhash the
socket. Nothing on this path takes the smc hash write_lock either.

A diag reader that already saw a non-zero alert_token_local holds only
read_lock(&smc_hash->lock). Can it then read conn->sndbuf_desc->len and
conn->rmb_desc->len after smc_lgr_free() has freed them? The same question
applies to conn->lgr->is_smcd and lgr->list in the LGRINFO/DMBINFO
conditions.

On non-RT kernels the window is small, but on PREEMPT_RT the read_lock is
preemptible.

Would it work to unregister the connection, or clear alert_token_local, in
smc_conn_free() even when lgr->list is empty? Another option is to skip
the CONNINFO/LGRINFO/DMBINFO blocks when conn->freed is set.

[ ... ]

> @@ -154,8 +158,7 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>  			.lnk[0].link_id = link->link_id,
>  		};
>  
> -		memcpy(linfo.lnk[0].ibname, link->smcibdev->ibdev->name,
> -		       sizeof(link->smcibdev->ibdev->name));
> +		memcpy(linfo.lnk[0].ibname, link->ibname, sizeof(link->ibname));

[Severity: Medium]
The commit message says this change is meant "to avoid racing with link
clearing during SMC-R link failover". It removes the NULL dereference
through link->smcibdev->ibdev, but is the race itself still there?

This block loads link = smc->conn.lnk with a plain load. It then copies
ibport, link_id, ibname, gid and peer_gid while holding only
read_lock(&smc_hash->lock).

At the same time, smcr_link_down()->smc_switch_conns()->
smc_switch_link_and_count() can run:

	atomic_dec(&conn->lnk->conn_cnt);
	smcr_link_put(conn->lnk);
	conn->lnk = to_lnk;

This runs under lgr->conns_lock and conn->send_lock, and the diag reader
takes neither. smcr_link_clear() then does the final
smcr_link_put()->__smcr_link_clear():

	memset(lnk, 0, sizeof(struct smc_link));
	lnk->state = SMC_LNK_UNUSED;

smcr_link_init() can later reuse the slot. smc_cdc_msg_validate() also
rewrites conn->lnk under send_lock.

The link is embedded in lgr->lnk[], so this is not a use-after-free.
However, could user space get an SMC_DIAG_LGRINFO record with an empty
ibname, ibport 0, link_id 0 and all-zero GIDs, or a mix of two links?

Would taking conn->send_lock around the conn->lnk load and the copy, or
holding a link reference, give a consistent snapshot? If not, could the
commit message say that only the NULL dereference is avoided?

[Severity: Low]
This isn't a bug, but link->ibname is only written by
smcr_copy_dev_info_to_link() when the link is created. SMC_NLA_DEV_IB_NAME
in smc_nl_handle_smcr_dev() and the pnet table still use the live
smcibdev->ibdev->name.

After an ib_device_rename(), the name in SMC_DIAG_LGRINFO will not match
the SMC device dump or the pnet configuration. The commit message
documents this, and it matches the existing SMC_NLA_LINK_IB_DEV link dump.

>  		smc_gid_be16_convert(linfo.lnk[0].gid, link->gid);
>  		smc_gid_be16_convert(linfo.lnk[0].peer_gid, link->peer_gid);

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261013141510.2621698-1-mjambigi%40linux.ibm.com
