Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53D418DF80;
	Fri, 11 Sep 2026 00:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789086253; cv=none; b=TYOm7aMJzkdY2Y5eelzvhfZCS46yKliKz2swYHjifKzjwKy8Q9/cUN3nd4CzJeyJkli8+b+uVSgIqdQCAMWvI2Mm3p2yP3xcfQQ4VEsF1WNcvVbo/GcqAfqSDQ4m/dvm4n1oMAqQroQ53bSbAM1kWbVm3uDy19nMmXOkN7+KSEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789086253; c=relaxed/simple;
	bh=AKtsfH5QrpHgr2A2NJf3MtAl/FrzCpaTYaZeAF7SbfM=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=T9UXg1IVdWmQD13Hmb8pVI04U+9LUi4tNKguzbnF9TZx9tX9HB5Vb3ZiWAxBTNlKSCwNZGPDQYGWSP2z3bmVf3OEeiN2zRX89Xe16TlzSCRMmFvkBZIP60EUMXiIMkdDm1rZM+KpiHMN+SNoBJn72RyRpmmKOqSW/+X6sA7oV3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l7SyL2HH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l7SyL2HH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E4F1F000FF;
	Fri, 11 Sep 2026 00:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789086251;
	bh=gZsBbz8/MMxuPqcNJbO9PzEltgloSr2936xZcIVzJ0k=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=l7SyL2HHwJ7ASTUdSB6sklx+GXhLf1qiAG+CRw31vXUJDmtwmygHerUj2keiIaHwN
	 331Nh4IaRyKztdTXS+Zo0+c5XoZtI/a8seKcNpnAFQxsi3wVJDqd1zOC6OMv624rDO
	 s1bCbfgYCsoAi7QIxyKNaJ6ZOgRPW9buJnZbSZIrcYauXHx6wOP6AZZLWTuqT6ae8L
	 K4gu45aeTtLtziY0zPO3sjycnqMnio3QmLdXxN7j3XX51gT3Qi17m7/RNE2Vao6vPp
	 W30YEZUlvGkOvWPSfcmVtDj8NOQPawwnffm0xzVTgyJePBwoUwTrW8YHZBfA3974EP
	 QiORZ7trdhs2w==
Subject: Re: [PATCH net v3] net/smc: fix lgr/lnk lifetime vs diag reader race
From: netdev-bot+sashiko@kernel.org
To: mjambigi@linux.ibm.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, pasic@linux.ibm.com,
 horms@kernel.org, tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
 hidayath@linux.ibm.com, stable@vger.kernel.org, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Date: Fri, 11 Sep 2026 00:24:09 +0000
Message-ID: <178908624996.219967.16908117009364362685@kernel.org>
In-Reply-To: <20260908092252.3832975-1-mjambigi@linux.ibm.com>
References: <20260908092252.3832975-1-mjambigi@linux.ibm.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider:

Critical: 0 · High: 2 (1) · Medium: 0 · Low: 0

- [High] The commit message asserts the invariant "any socket still
  visible to the diag reader under the hash read_lock has valid…
- [High] The unconditional smc_conn_unhash() added at the head of
  smc_conn_free() (net/smc/smc_core.c:1284) removes the socket from the…

Pre-existing issues:
- [High] smc_cdc_msg_validate() (net/smc/smc_cdc.c:308-327) retargets
  conn->lnk to the link a stray failover-validation CDC message arrived…

--

net/smc: fix lgr/lnk lifetime vs diag reader race

This patch adds smc_conn_unhash() plus a per-connection unhashed flag and
calls it at the top of smc_conn_free(), so the socket leaves the SMC socket
hash before the connection-owned lgr and lnk references are dropped.
__smc_release() is changed to use the new helper for non-fallback sockets
and keeps the direct sk->sk_prot->unhash() call for fallback sockets.

A few questions below about the paths that reach smc_conn_free() and about
the invariant described in the changelog.

> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index e9f93b3ab435b..8c781a4a4485b 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -310,7 +310,15 @@ static int __smc_release(struct smc_sock *smc)
>  		smc_restore_fallback_changes(smc);
>  	}
>  
> -	sk->sk_prot->unhash(sk);
> +	/* Fallback sockets never call smc_conn_free(), so unhash directly.
> +	 * Non-fallback sockets use smc_conn_unhash() so that the conn->unhashed
> +	 * flag keeps the unhash exactly once even when smc_conn_free() already ran
> +	 * first (e.g. via smc_conn_kill()).
> +	 */
> +	if (smc->use_fallback)
> +		sk->sk_prot->unhash(sk);
> +	else
> +		smc_conn_unhash(&smc->conn);

[Severity: High]
Is the premise "Fallback sockets never call smc_conn_free()" accurate?
smc_listen_decline() calls smc_conn_abort() first and only afterwards turns
the socket into a fallback socket:

net/smc/af_smc.c:smc_listen_decline() {
	/* RDMA setup failed, switch back to TCP */
	smc_conn_abort(new_smc, local_first);
	if (reason_code < 0 ||
	    smc_switch_to_fallback(new_smc, reason_code)) {
	...
	smc_listen_out_connected(new_smc);
}

net/smc/af_smc.c:smc_conn_abort() {
	...
	smc_conn_free(conn);
	...
}

The client side does the same via smc_connect_rdma()'s connect_abort label
followed by smc_connect_decline_fallback().

Beyond the comment, smc_conn_free() is also reached for connection
*attempts* on sockets that stay alive afterwards, and there is no path that
re-inserts the socket into the hash.  Can this make live sockets invisible
to smc_diag for the rest of their lifetime?

For the server ISM retry loop:

net/smc/af_smc.c:smc_listen_ism_init() {
	rc = smc_buf_create(new_smc, true);
	if (rc) {
		smc_conn_abort(new_smc, ini->first_contact_local);
		...
}

net/smc/af_smc.c:smc_find_ism_v2_device_serv() {
	for (i = 0; i < matches; i++) {
		...
		rc = smc_listen_ism_init(new_smc, ini);
		if (rc) {
			smc_init_info_store_rc(rc, ini);
			/* try next active ISM device */
			continue;
		}
		return; /* matching and usable V2 ISM device found */
	}
}

The failed attempt unhashes the socket through smc_conn_free(), the next
ISM device then succeeds, and smc_conn_create() only does
"conn->unhashed = 0" without calling sk->sk_prot->hash() again.  The same
shape exists for the v2 -> v1 RDMA fallthrough in
smc_find_rdma_v2_device_serv() -> smc_listen_find_device().

smc_diag_dump_proto() walks only that hash:

net/smc/smc_diag.c:smc_diag_dump_proto() {
	read_lock(&prot->h.smc_hash->lock);
	head = &prot->h.smc_hash->ht;
	...
	sk_for_each(sk, head) {
	...
}

so an established SMC-D/SMC-R connection or an active TCP-fallback
connection produced by these paths would no longer show up in ss --smc or
smcss, including the SMC_DIAG_MODE_FALLBACK_TCP reporting.  The same early
unhash also hides sockets that user space still has open after
__smc_lgr_terminate() -> smc_conn_kill() -> smc_close_active_abort() ->
smc_conn_free().  Should the unhash be restricted to terminal teardown, or
should the abort paths re-hash the socket?

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 04aedd957543a..e302221c35e3f 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1251,6 +1251,20 @@ static void smc_buf_unuse(struct smc_connection *conn,
>  	}
>  }
>  
> +/* unhash the socket once; owns the single unhash for all non-fallback paths.
> + * Every caller holds lock_sock for this socket, so conn->unhashed is protected
> + * by that lock and no separate synchronisation is needed.
> + */
> +void smc_conn_unhash(struct smc_connection *conn)
> +{
> +	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
> +
> +	if (!conn->unhashed) {
> +		conn->unhashed = 1;
> +		smc->sk.sk_prot->unhash(&smc->sk);
> +	}
> +}
> +
>  /* remove a finished connection from its link group */
>  void smc_conn_free(struct smc_connection *conn)
>  {
> @@ -1263,6 +1277,11 @@ void smc_conn_free(struct smc_connection *conn)
>  		return;
>  
>  	conn->freed = 1;
> +	/* Unhash before dropping lgr/lnk refs so the diag reader, which
> +	 * iterates under the socket hash read_lock, cannot see a connection whose
> +	 * lgr or lnk is being freed concurrently.
> +	 */
> +	smc_conn_unhash(conn);

[Severity: High]
The changelog states the invariant as "any socket still visible to the diag
reader under the hash read_lock has valid conn->lgr and conn->lnk
pointers".  Does the SMC-R link failover path still break that for
conn->lnk?

smc_switch_link_and_count() drops the connection-owned link reference and
republishes conn->lnk while the socket stays hashed:

net/smc/smc_core.c:smc_switch_link_and_count() {
	atomic_dec(&conn->lnk->conn_cnt);
	/* link_hold in smc_conn_create() */
	smcr_link_put(conn->lnk);
	conn->lnk = to_lnk;
	...
}

It runs under conn->send_lock and lgr->conns_lock only, never under the
socket hash lock and without unhashing, so a reader that already
snapshotted the old link keeps using it:

net/smc/smc_diag.c:__smc_diag_dump() {
	struct smc_link *link = smc->conn.lnk;
	...
	memcpy(linfo.lnk[0].ibname, link->smcibdev->ibdev->name,
	       sizeof(link->smcibdev->ibdev->name));
	smc_gid_be16_convert(linfo.lnk[0].gid, link->gid);
	...
}

Once the last connection has been migrated off the old link,
smcr_link_clear() -> smcr_link_put() -> __smcr_link_clear() zeroes the
whole structure:

net/smc/smc_core.c:__smcr_link_clear() {
	put_device(&lnk->smcibdev->ibdev->dev);
	smcibdev = lnk->smcibdev;
	memset(lnk, 0, sizeof(struct smc_link));
	lnk->state = SMC_LNK_UNUSED;
	...
}

so link->smcibdev becomes NULL and the dereference above is a NULL
dereference, with the device reference already dropped.  This looks like
the same class of access the cited "Fixes: 9dbe086c69b8 (net/smc: fix
invalid link access in dumping SMC-R connections)" refers to, and the
reader/writer lock sets (hash read_lock versus send_lock/conns_lock/
llc_conf_mutex) do not intersect.  The v2 posting of this series protected
smc_switch_link_and_count() with lgr_lnk_lock; is anything replacing that
protection in v3, or should the invariant in the changelog be narrowed to
conn->lgr?

[Severity: High]
This is a pre-existing issue and not introduced by this patch, but it also
bears on the conn->lnk invariant being asserted: the reference that
smc_conn_free() releases is not always the one the connection holds.

smc_cdc_msg_validate() retargets conn->lnk with no reference transfer,
reached from smc_cdc_msg_recv() when the peer sets
prod_flags.failover_validation and the seqno is stale:

net/smc/smc_cdc.c:smc_cdc_msg_validate() {
	diff = conn->local_rx_ctrl.seqno - recv_seq;
	if (diff < 0) { /* diff larger than 0x7fff */
		...
		spin_lock_bh(&conn->send_lock);
		conn->local_tx_ctrl.conn_state_flags.peer_conn_abort = 1;
		conn->lnk = link;
		spin_unlock_bh(&conn->send_lock);
	...
}

There is no smcr_link_hold() on the new link and no smcr_link_put() on the
old one, while the counted reference was taken in smc_conn_create():

	smcr_link_hold(conn->lnk); /* link_put in smc_conn_free() */

and smc_conn_free() later releases whatever conn->lnk points at:

	if (!lgr->is_smcd)
		smcr_link_put(conn->lnk); /* link_hold in smc_conn_create() */

In a multi-link link group, does this over-put the new link and leak a
reference on the old one?  The over-put can take the new link's refcount to
zero while other connections still cache it in conn->lnk, running
__smcr_link_clear() (put_device() plus memset()) before its QP is
destroyed, after which smcr_link_clear() returns early on the
SMC_LNK_UNUSED state.  The leaked reference on the old link would keep its
__smcr_link_clear() and the nested smc_lgr_put() from ever running.

>  	if (!smc_conn_lgr_valid(conn))
>  		/* Connection has already unregistered from
>  		 * link group.
> @@ -2053,6 +2072,7 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
>  	if (!conn->lgr->is_smcd)
>  		smcr_link_hold(conn->lnk); /* link_put in smc_conn_free() */
>  	conn->freed = 0;
> +	conn->unhashed = 0;

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260908092252.3832975-1-mjambigi%40linux.ibm.com
