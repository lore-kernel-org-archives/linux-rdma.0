Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B25244064B;
	Thu, 24 Sep 2026 21:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790284828; cv=none; b=AZLUD2U6YouPLhYFSt2KUgsaFajZb24gXW6tAcyrMfZNkIWi2pIMSD1m7EoHE3IX6wJP7uywSm5427jKWipm+dj3W5w1HuBJoCc9Hu8nuKWwJlaSsxpB98w9Ok0we8gnlCRCQg4IWZfm8rvHlP2NZl9XVFhNqPo6vO2D5pP8LL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790284828; c=relaxed/simple;
	bh=kXF28IrmiDh6AomOc/ZeVOggxZiCslyj+4IGuAV48Po=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dniQXj2Bh0KHqpxa+UWAgsjYICG4EBi58drPVVNr8C/H0e9lc3NPetsYm0gksMazRa93RdXqvW2dyR7VS45oHsuDJIOtYDm1ba/7FdnfOUenMP+A9Br5V8LbBCPQObepNDhvFUtIz7lCDldQCANXMje77K2tlLaetc4IYpoK+qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E9zz8U5+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E9zz8U5+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42AFB1F000FF;
	Thu, 24 Sep 2026 21:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790284823;
	bh=GVQAIAg59pu685FlDOVyfu4sQ6kohSvOpnFlYhYtsS4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=E9zz8U5+79tVg4QNcZXW1CbDqAGXIj284aT0SrUGCPQGWjFAD5jgQsWVXnuqh5SIg
	 uWaLIMo/J1ve2chTfy/YS72hwxiDwfmfHjDfiUoQwgaeTAOrN4P6Hodialj6L3lDBr
	 fdJcbF6f8xO24k8kL7mS594aEibtrkfkK8zz2/2FBPECxCorl4P/q5JZ9bBTP2Qn5a
	 pZIbn+YM9Ft1pbRHj9rz1qC3OFF5UW/AFj7f3as6AqojOTYwYjE0nbVQzy88lKk7WR
	 4FJiVSq3I4qoyVmHua6JRMw0zgx2N6NQ7vKSUC+Tp00fInNS+u3mTYX4JBwtHlthSG
	 4V3JwBGknWhEQ==
Subject: Re: [PATCH net v5] net/smc: fix lgr/lnk lifetime vs diag reader race
From: netdev-bot+sashiko@kernel.org
To: mjambigi@linux.ibm.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, hidayath@linux.ibm.com,
 pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, stable@vger.kernel.org, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Date: Thu, 24 Sep 2026 21:20:21 +0000
Message-ID: <179028482174.2160803.16069872683642574185@kernel.org>
In-Reply-To: <20260923061716.1970059-1-mjambigi@linux.ibm.com>
References: <20260923061716.1970059-1-mjambigi@linux.ibm.com>
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

Critical: 0 · High: 2 (1) · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] __smc_diag_dump() (net/smc/smc_diag.c:91-96) still reads
  `smc->conn.lgr->is_smcd` to work out r->diag_mode.
- [High] In the SMC_DIAG_LGRINFO block, __smc_diag_dump() does `struct
  smc_link *link = smc->conn.lnk;` and then dereferences…
- [Medium] The commit message says the socket is unhashed "before
  smc_conn_free() is called at the two terminal teardown sites".

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the patch
  leaves it open while adding an unhash that runs too late on the same…

--

net/smc: fix lgr/lnk lifetime vs diag reader race

This patch unhashes SMC sockets in smc_close_active_abort() and
smc_close_passive_work() before smc_conn_free() drops the lgr/lnk
references. It also makes __smc_diag_dump() skip the conn/lgr/lnk
attribute blocks when the socket is in SMC_INIT or SMC_CLOSED state. The
goal is to keep the diag reader from dereferencing a freed link group or
link.

> diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
> index bb0313ef5f7c1..3940098c651d9 100644
> --- a/net/smc/smc_close.c
> +++ b/net/smc/smc_close.c
> @@ -130,6 +130,11 @@ void smc_close_active_abort(struct smc_sock *smc)
>  	struct sock *sk = &smc->sk;
>  	bool release_clcsock = false;
>  
> +	/*
> +	 * Unhash before any branch calls smc_conn_free() and drops lgr/lnk refs;
> +	 * the diag reader must not see a hashed socket with freed lgr/lnk.
> +	 */
> +	sk->sk_prot->unhash(sk);

[Severity: Medium]
The commit message says the socket is unhashed "before smc_conn_free() is
called at the two terminal teardown sites". This unhash, though, runs
unconditionally for every state. Is that intended?

The SMC_ACTIVE, SMC_APPCLOSEWAIT1 and SMC_APPCLOSEWAIT2 branches never call
smc_conn_free(). They only set SMC_CLOSED and call sock_put(). SMC_INIT,
SMC_PEERABORTWAIT and SMC_CLOSED don't call it either. Neither does the early
break taken when smc_close_cancel_work() changes the state.

On link group termination, smc_conn_kill() calls smc_close_active_abort()
for every connection:

net/smc/smc_core.c:smc_conn_kill() {
    ...
    smc_lgr_unregister_conn(conn);
    smc_close_active_abort(smc);
}

Doesn't this make killed SMC_ACTIVE sockets vanish from smc_diag/smcss
right away instead of at close? The application still has them open, and
their lgr/lnk references are still held.

These sockets reach smc_conn_free() later in __smc_release(), which already
unhashes first. smc_release() is also a third caller of
smc_close_active_abort(), and the commit message doesn't mention it.

Would it be narrower to unhash only right before the two smc_conn_free()
calls in the SMC_PEERCLOSEWAIT1/2/SMC_PEERFINCLOSEWAIT and
SMC_PROCESSABORT/SMC_APPFINCLOSEWAIT branches?

[Severity: High]
This is a pre-existing issue, not one introduced by this patch. Still, on
the smc_conn_kill() path this new unhash runs too late to protect against
it.

On SMC-D with dmb_nocopy (for example loopback-ism), smc_conn_kill() frees
the sndbuf descriptor before it unregisters the conn and before it calls
smc_close_active_abort():

net/smc/smc_core.c:smc_conn_kill() {
    ...
    if (smc_ism_support_dmb_nocopy(conn->lgr->smcd))
        smcd_buf_detach(conn);
    ...
    smc_lgr_unregister_conn(conn);
    smc_close_active_abort(smc);
}

smcd_buf_detach() does this:

    buf_desc = conn->sndbuf_desc;
    conn->sndbuf_desc = NULL;
    kfree(buf_desc);

During that window the socket is still hashed and still in SMC_ACTIVE, so
it passes the new diag guard. alert_token_local is also still set. That
means __smc_diag_dump() enters the SMC_DIAG_CONNINFO block and evaluates:

    .sndbuf_size = conn->sndbuf_desc ?
        conn->sndbuf_desc->len : 0,

These are plain loads, and only the hash read_lock is held. Could this
dereference NULL, or read ->len from an smc_buf_desc that has been kfree'd?
The lock_sock() in __smc_lgr_terminate() does not exclude the diag reader.

Would unhashing at the start of smc_conn_kill(), before smcd_buf_detach(),
close this as well?

>  	if (sk->sk_state != SMC_INIT && smc->clcsock && smc->clcsock->sk) {
>  		sk->sk_err = ECONNABORTED;
>  		if (smc->clcsock && smc->clcsock->sk)

[ ... ]

> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
> index bf0beaa23bdb6..fe32091e37dab 100644
> --- a/net/smc/smc_diag.c
> +++ b/net/smc/smc_diag.c
> @@ -103,6 +103,9 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>  	if (nla_put(skb, SMC_DIAG_FALLBACK, sizeof(fallback), &fallback) < 0)
>  		goto errout;
>  
> +	if (sk->sk_state == SMC_INIT || sk->sk_state == SMC_CLOSED)
> +		goto out;
> +

[Severity: High]
Does this guard cover the lgr dereference earlier in __smc_diag_dump() that
sets r->diag_mode?

net/smc/smc_diag.c:__smc_diag_dump() {
    ...
    if (smc->use_fallback)
        r->diag_mode = SMC_DIAG_MODE_FALLBACK_TCP;
    else if (smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
        r->diag_mode = SMC_DIAG_MODE_SMCD;
    ...
}

That load happens before the new SMC_INIT/SMC_CLOSED check, and only the
smc hash read_lock is held.

The commit message says this guard handles the smc_conn_abort() SMC_INIT
case. Take a handshake failure such as smc_listen_decline() ->
smc_conn_abort(new_smc, local_first). The socket is still hashed in
SMC_INIT and use_fallback has not been set yet:

net/smc/af_smc.c:smc_conn_abort() {
    ...
    smc_conn_free(conn);
    if (local_first && lgr_valid)
        smc_lgr_cleanup_early(lgr);
}

The following chain then frees the lgr synchronously:

smc_lgr_cleanup_early()
  __smc_lgr_terminate()
    smc_lgr_free()
      smc_lgr_put()
        __smc_lgr_free()
          kfree(lgr)

Nothing on this path takes the hash write_lock, and conn->lgr is never
cleared. smc_conn_lgr_valid() is only plain loads of conn->lgr and
conn->alert_token_local.

Can a diag reader pass smc_conn_lgr_valid() just before the conn is
unregistered, and then read lgr->is_smcd after the kfree()?

smc_diag_handler_dump() has no capability check, and a remote peer can
cause the handshake failure. Would checking the state (or use_fallback)
before any conn.lgr access close this?

>  	if ((req->diag_ext & (1 << (SMC_DIAG_CONNINFO - 1))) &&
>  	    smc->conn.alert_token_local) {
>  		struct smc_connection *conn = &smc->conn;

[Severity: High]
Sockets in SMC_ACTIVE and the closing states still get past this guard. Is
the SMC_DIAG_LGRINFO block further down still exposed to a concurrent link
switch?

net/smc/smc_diag.c:__smc_diag_dump() {
    ...
    struct smc_link *link = smc->conn.lnk;
    ...
    memcpy(linfo.lnk[0].ibname, link->smcibdev->ibdev->name,
           sizeof(link->smcibdev->ibdev->name));
    ...
}

Only the hash read_lock is held here. During SMC-R link failover,
smcr_link_down() -> smc_switch_conns() -> smc_switch_link_and_count()
replaces conn->lnk under conn->send_lock and drops the conn's reference on
the old link:

net/smc/smc_core.c:smc_switch_link_and_count() {
    ...
    smcr_link_put(conn->lnk);
    conn->lnk = to_lnk;
    ...
}

When smcr_link_clear() drops the last reference, __smcr_link_clear() calls
put_device() on the ibdev and then memset(lnk, 0). The lgr stays on its
list during failover, so the !list_empty(&smc->conn.lgr->list) check does
not stop the reader.

Suppose a reader loads the old link pointer just before the switch. Can it
then see link->smcibdev == NULL and oops? That is the same signature that
9dbe086c69b8 fixed. It could also read the name of an ibdev that has
already been released.

Unhashing before smc_conn_free() does not cover this path. The v2
serialisation of the conn->lnk swap against the reader was dropped in this
version, and nothing replaces it.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260923061716.1970059-1-mjambigi%40linux.ibm.com
