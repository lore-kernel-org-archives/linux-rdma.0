Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB9A72630;
	Wed, 30 Sep 2026 00:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790729511; cv=none; b=i6bWs3EFT2l/L/bdKwUXvgzKR4WFsxekiFrlpTqEDigOcTlhLYT8JONnDSq/j2UVPts1Ex5ZnadeF3HgRrXhgXGkKcJS4AhgerNoPuMhou4dCvW/hqNie2FX/vKaAXfpBHOewWFtDM61TjP18CSPnFwEXexQ1USFPWW4Xkx92G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790729511; c=relaxed/simple;
	bh=Y8Yv86j45dAUDm+HTINjd9b13trqoVz9QNDts84BzNI=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Jt/tnchdrxFJL70DBlDopQMlpt0ERiKvyuMEpK6Zv2YBMdU7iP8nm69GiixWUIbJ1Bp/n3Tqt1edCQWejsiFNrIDf68jDiVp6J4fVOm6fJ9CF0JFiGq2zlx1uxnL7kqvyFl5EWXOiWVMSZMFgF9S5lsfHfIAjZSBDvF9TdnHY6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b0ZHVNMr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b0ZHVNMr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71A91F000FF;
	Wed, 30 Sep 2026 00:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790729509;
	bh=hIa8l3Wv1305+cLt2p2PWVQHZKo3oSVWoXD8VqI9hSY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=b0ZHVNMr5sTipzrZOTLqNz5Szch/mQAHrFSQLLzVhYFMKGgcjG0CGISKNzao2HKqr
	 PwvZIShFNv1oxI0DgScbUPx8V5ikIwzTyJ63eVQWKVQXiHPxw0by2ZdtY5aiK3nKcX
	 qfNB8zNSUr3hhz26hhyUQ20kUF3lOUbm3YZntmnS6VSocpqma2Riil0dvAHwi82ZRm
	 PvucIz7h749B2ByNDqwKLXJhb0jWrjuHKKJnE5RhyaalO1EcvpZ/nT2WNuCDlJqqSL
	 6j73XnoYlk0mw3hl4QpTZAtFrD/Q5t8jeire5gS34+02/TzQFepwr1ltUmbLCOfqGc
	 Mz69MASmsFsIw==
Subject: Re: [PATCH net v6] net/smc: fix lgr/lnk lifetime vs diag reader race
From: netdev-bot+sashiko@kernel.org
To: mjambigi@linux.ibm.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, hidayath@linux.ibm.com,
 pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, stable@vger.kernel.org, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Date: Wed, 30 Sep 2026 00:51:48 +0000
Message-ID: <179072950825.434549.9827562031861482481@kernel.org>
In-Reply-To: <20260926065023.1629497-1-mjambigi@linux.ibm.com>
References: <20260926065023.1629497-1-mjambigi@linux.ibm.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 4 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 2 (1) · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The patch leaves open another window of the class it says it
  closes ('a hashed socket has freed or partially freed conn/lgr/lnk…
- [Medium] The new early exit in __smc_diag_dump()
  (net/smc/smc_diag.c:107-108, `if (sk->sk_state == SMC_INIT ||…
- [Medium] For the smc_conn_abort() path, the patch's only protection
  against dereferencing a freed conn->lgr in __smc_diag_dump() is two…
- [Low] The second race the patch fixes is smcd_buf_detach() freeing
  conn->sndbuf_desc in smc_conn_kill() while the socket is hashed and…

Pre-existing issues:
- [Medium] This problem wasn't introduced by this patch, but
  smc_diag_handler_dump() (net/smc/smc_diag.c:245-260) starts the dump…

--

net/smc: fix lgr/lnk lifetime vs diag reader race

This patch aims to close races between the SMC sock_diag dump and the
teardown of conn/lgr/lnk state. It unhashes the socket before
smc_conn_free() in the close paths and at the top of smc_conn_kill(). It
also makes __smc_diag_dump() skip the lgr->is_smcd load, and all extension
blocks, for SMC_INIT and SMC_CLOSED sockets.

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 9974149659c2f..663926465ba7f 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1517,6 +1517,7 @@ static void smc_conn_kill(struct smc_connection *conn, bool soft)
>  {
>  	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
>  
> +	smc->sk.sk_prot->unhash(&smc->sk);
>  	if (conn->lgr->is_smcd && conn->lgr->peer_shutdown)
>  		conn->local_tx_ctrl.conn_state_flags.peer_conn_abort = 1;
>  	else

[Severity: Low]
Should this patch also have a Fixes: tag for ae2be35cbed2?

The commit message says this hunk is needed because smcd_buf_detach()
frees conn->sndbuf_desc in smc_conn_kill() on the dmb_nocopy path:

smcd_buf_detach() {
    ...
	buf_desc = conn->sndbuf_desc;
	conn->sndbuf_desc = NULL;
	kfree(buf_desc);
}

That path was added by ae2be35cbed2 ("net/smc: {at|de}tach sndbuf to peer
DMB if supported"). It was moved to its current place by 36cdf5d48ca1
("net/smc: unregister the connection before draining the rx tasklet"),
which itself has Fixes: ae2be35cbed2.

Both tags in this patch, f16a7dd5cf27 and 9dbe086c69b8, are older than the
dmb_nocopy detach code. Without a tag for ae2be35cbed2, stable trees that
lack dmb_nocopy would get the unconditional unhash, but the stated reason
for it would not apply there.

> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
> index bf0beaa23bdb6..b29bd34acf7b5 100644
> --- a/net/smc/smc_diag.c
> +++ b/net/smc/smc_diag.c
> @@ -90,7 +90,8 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>  	r->diag_state = sk->sk_state;
>  	if (smc->use_fallback)
>  		r->diag_mode = SMC_DIAG_MODE_FALLBACK_TCP;
> -	else if (smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
> +	else if (sk->sk_state != SMC_INIT &&
> +		 smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
>  		r->diag_mode = SMC_DIAG_MODE_SMCD;
>  	else
>  		r->diag_mode = SMC_DIAG_MODE_SMCR;

[Severity: Medium]
Is a plain read of sk->sk_state enough to stop this from reading a freed
lgr?

smc_conn_free() never clears conn->lgr. On the smc_conn_abort() path the
writer does the following under lock_sock(), using only plain stores:

smc_conn_abort()
  smc_conn_free()
    smc_lgr_unregister_conn()     /* alert_token_local = 0 */
  smc_lgr_cleanup_early(lgr)
    __smc_lgr_terminate()
      smc_lgr_free()              /* lgrA freed, conn->lgr dangling */

One of two things follows:

- smc_switch_to_fallback() and then sk_state = SMC_ACTIVE, for example in
  smc_connect_fallback().
- In the ISM/RDMA v2 server retry loops, smc_conn_create() sets
  conn->lgr = lgrB with a new token, and then
  newsmcsk->sk_state = SMC_ACTIVE.

The reader here holds only the hash read_lock. There is no READ_ONCE(), and
nothing orders the sk_state load before the later loads of
conn->alert_token_local, conn->lgr and lgr->is_smcd. The control dependency
on the sk_state test does not order those later loads.

On weakly ordered CPUs such as arm64 or POWER, could this see SMC_ACTIVE
with use_fallback still false, together with a stale token or the stale
lgrA pointer, and then read lgrA->is_smcd after it was freed?

This sk_state test and the second one below are separate reads, so within
one dump they can return different values. KCSAN would likely report both
as data races.

> @@ -103,6 +104,9 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>  	if (nla_put(skb, SMC_DIAG_FALLBACK, sizeof(fallback), &fallback) < 0)
>  		goto errout;
>  
> +	if (sk->sk_state == SMC_INIT || sk->sk_state == SMC_CLOSED)
> +		goto out;
> +

[Severity: Medium]
Does this drop CONNINFO, LGRINFO and DMBINFO for SMC_CLOSED sockets whose
connection is still registered and valid?

A hashed socket can reach SMC_CLOSED with its connection intact. For
example, after shutdown(SHUT_WR) in SMC_APPCLOSEWAIT1 the socket is in
SMC_APPCLOSEWAIT2, and then the peer aborts:

smc_close_passive_work()
  smc_close_passive_abort_received()
	case SMC_APPCLOSEWAIT2:
	case SMC_PEERFINCLOSEWAIT:
		sk->sk_state = SMC_CLOSED;

The fd is still open, so smc_close_passive_work() skips both the new
unhash and smc_conn_free():

		if ((sk->sk_state == SMC_CLOSED) &&
		    (sock_flag(sk, SOCK_DEAD) || !sk->sk_socket)) {
			sk->sk_prot->unhash(sk);
			smc_conn_free(conn);

The socket therefore stays hashed with alert_token_local and conn->lgr
still valid.

With this patch, every caller of smc_conn_free() unhashes first:
smc_close_active_abort(), smc_close_passive_work() and __smc_release(). It
looks like any SMC_CLOSED socket still in the hash has valid connection
state. If so, the SMC_CLOSED half of this check only hides valid data that
smcss -D and smcss -R used to report when the matching diag_ext bits were
set.

The commit message describes only the narrower sk_state != SMC_INIT guard
on the is_smcd load. This early exit appears only in the v5 and v6
changelog below the --- line, which is dropped when the patch is applied.

Could the SMC_CLOSED part be removed, or described in the commit message if
it is intended?

>  	if ((req->diag_ext & (1 << (SMC_DIAG_CONNINFO - 1))) &&
>  	    smc->conn.alert_token_local) {
>  		struct smc_connection *conn = &smc->conn;

[Severity: Medium]
This is a pre-existing issue and was not introduced by this patch, but is
req->diag_ext always inside the request payload here?

smc_diag_handler_dump() starts the dump without checking the request
length:

	if (h->nlmsg_type == SOCK_DIAG_BY_FAMILY &&
	    h->nlmsg_flags & NLM_F_DUMP) {
		{
			struct netlink_dump_control c = {
				.dump = smc_diag_dump,

The generic check in __sock_diag_cmd() only compares against struct
sock_diag_req (2 bytes), not struct smc_diag_req (52 bytes). inet_diag,
unix_diag, packet_diag, netlink_diag, tipc_diag and vsock_diag all check
nlmsg_len(h) against their own request size.

With a 2-byte payload, diag_ext at offset 3 falls in skb tailroom that
netlink_sendmsg() did not initialize. When a live SMC connection exists,
whether CONNINFO, LGRINFO and DMBINFO appear in the reply would reveal bits
of that uninitialized memory to an unprivileged local user. KMSAN would
likely report this as an uninit-value use.

Should smc_diag_handler_dump() reject requests where nlmsg_len(h) is less
than sizeof(struct smc_diag_req)?

[ ... ]

> @@ -185,6 +189,7 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>  			goto errout;
>  	}
>  
> +out:
>  	nlmsg_end(skb, nlh);
>  	return 0;
>  

[Severity: High]
The commit message says the patch closes windows where "a hashed socket has
freed or partially freed conn/lgr/lnk state". It also cites 9dbe086c69b8
("net/smc: fix invalid link access in dumping SMC-R connections"). Is SMC-R
link failover still exposed to the same race?

The LGRINFO block above this label runs under only the hash read_lock:

	if (smc_conn_lgr_valid(&smc->conn) && !smc->conn.lgr->is_smcd &&
	    (req->diag_ext & (1 << (SMC_DIAG_LGRINFO - 1))) &&
	    !list_empty(&smc->conn.lgr->list)) {
		struct smc_link *link = smc->conn.lnk;
		...
		memcpy(linfo.lnk[0].ibname, link->smcibdev->ibdev->name,
		       sizeof(link->smcibdev->ibdev->name));

At the same time, smcr_link_down() or smc_llc_process_srv_delete_link() can
run:

smc_switch_conns()
  smc_switch_link_and_count()
    smcr_link_put(conn->lnk);
    conn->lnk = to_lnk;
smcr_link_clear(lnk)
  __smcr_link_clear()
    memset(lnk, 0, sizeof(struct smc_link));

The link switch takes only conn->send_lock. The socket stays SMC_ACTIVE and
hashed, and the lgr stays on its list. So neither the new
SMC_INIT/SMC_CLOSED check nor the list_empty() check skips this block.

If a reader has already loaded the old conn->lnk, could it dereference a
NULL link->smcibdev? Could it instead report fields from a different link
that has reused the lgr->lnk[] slot?

The v2 posting protected the conn->lnk swap in smc_switch_link_and_count()
with lgr_lnk_lock. v3 dropped that, and nothing has replaced it.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260926065023.1629497-1-mjambigi%40linux.ibm.com
