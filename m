Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793517354;
	b=zpp68KLEvZPRiXooYriVP31FgE8U8GM3fDFpSmaFKaTOgqCbxUMuMKe6Tw6pbnQvYKPG
	 rlx6YUMmtjQEL3Ebo4kNDRgFasGEiGaRAPWiHFEruSbtgcAlPDR/YK4tF7inhLR6565eT
	 BTjsn7JUKg/mOVcWJx0SBxQwD4rhwTFnyejtTpDrfDjzYDKd25DPMrCUEkDvfEDymUoqR
	 F+/5OB3JQmOOXt7Ca/kC0d4WQIGqSAoS836w3Dm7QTPnAO0B7evchAgjfJT15ZJMzM0Q2
	 ogsy28xF9CogceU9kQS9TRIZenK4VaGwiQVKKLCFcUhp9SDo4EAMkxYG5mjA6SyVEEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793517354;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=YvzwzUPJNamEKyfoAp0xhvLbUbROhQ47J0KFrOAYx5U=;
	b=nqlzp5vM3E6EWzltIAGeCJfx9jUQgBevzSlGgHhrNjOhnf4sS9JX5x9sXB9mdV9h5vT5
	 4eUgCN1+mW6vIj3KOl+cP9xsyOLWe94OLeTZ24Xz7VT+LiXiRMuJPwjYobJUGcNJCCAYr
	 kbqLZGpUEpWj1ztYOzJ5xcRdaFAAphcvRUxdcw0tM3P/+Ke6WRKUNkjXvtFOVdXAM1kpE
	 vmOEiUweGuqGZgPlyfMbqodWp1TetKXrwccTgZ58okWnxZWlNxRH5dmzKqNdTkTB1eJXs
	 c0OeSy2nDytPI5tlM+EppW236TneavsXp0wKXGlmVrzrbRpMaP1kBYTYKa0jsXukWqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XfxBGnwh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D455D606A324;
	Sun,  1 Nov 2026 07:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XfxBGnwh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637351F000C1;
	Sun,  1 Nov 2026 07:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793517353;
	bh=YvzwzUPJNamEKyfoAp0xhvLbUbROhQ47J0KFrOAYx5U=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=XfxBGnwhb8vp1blw7XelyO1gyCeW3xZYD2dZT8yw4d+oK/TSPKcWgIh/3xxfjxNMN
	 UInJRmd3vI3FzYC73yZPyV6Ac8U9Y8ShDt/u+5AdSUx9NZ6MxDAbO8kNyhuP8KAR19
	 mnnhJckKeAl2uYJroyZEAh6iJvBQCYGbMNIjVnaCQadItC7XlBqdPqsywr3e787A9v
	 EO8IofPzHBHLdbqKi55s6ZEafjBJcXvWCqQbOr3W65Z3PNJ+yyu64j2lRvbV3pn2/9
	 fPqw2cpOd4wxRivufRaAXcEp9KqA6MEef4z6j2zKHWKjuOu8SHD29NciOOvAndStgM
	 0s0sC1ox4zwRQ==
Subject: Re: [PATCH net v14] net/smc: fix lgr/lnk lifetime vs diag reader race
From: netdev-bot+sashiko@kernel.org
To: mjambigi@linux.ibm.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, hidayath@linux.ibm.com,
 pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, stable@vger.kernel.org, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Date: Sun, 01 Nov 2026 07:15:51 +0000
Message-ID: <179351735189.3131.9219259330792018704@kernel.org>
In-Reply-To: <20261028070210.1685136-1-mjambigi@linux.ibm.com>
References: <20261028070210.1685136-1-mjambigi@linux.ibm.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 1 (2) · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix is incomplete.
- [Medium] After this patch, __smc_diag_dump() (net/smc/smc_diag.c)
  reports SMC_DIAG_MODE_SMCR for every non-fallback socket in SMC_INIT…
- [Low] The commit message's 'Fourth' item says the
  smp_store_release(&newsmcsk->sk_state, SMC_CLOSED) in…

Pre-existing issues:
- [Medium] This problem wasn't introduced by this patch, but
  smc_conn_free() (net/smc/smc_core.c:1281-1282) calls…
- [Medium] This problem wasn't introduced by this patch, but
  smc_diag_handler_dump() (net/smc/smc_diag.c) never checks that the…

--

net/smc: fix lgr/lnk lifetime vs diag reader race

This patch tries to close races between the SMC sock_diag dump and the
teardown of conn/lgr/lnk state. __smc_diag_dump() now skips the extension
attributes and the lgr based diag_mode test for sockets in SMC_INIT,
SMC_CLOSED or fallback, and several teardown paths unhash the socket
before smc_conn_free() or smcd_buf_detach(). It also adds acquire/release
ordering on sk_state and copies the cached link->ibname.

> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index d10244af5bd29..ec5980add7a9d 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c

[ ... ]

> @@ -1971,7 +1971,7 @@ static void smc_listen_out_err(struct smc_sock *new_smc)
>  	this_cpu_inc(net->smc.smc_stats->srv_hshake_err_cnt);
>  	if (newsmcsk->sk_state == SMC_INIT)
>  		sock_put(&new_smc->sk); /* passive closing */
> -	newsmcsk->sk_state = SMC_CLOSED;
> +	smp_store_release(&newsmcsk->sk_state, SMC_CLOSED);

[Severity: Low]

The commit message says:

  Fourth, smc_listen_out_err() sets sk_state = SMC_CLOSED with a plain
  store after smc_conn_abort() -> smc_conn_free() has already cleared
  alert_token_local under write_lock_bh(). On weakly ordered CPUs a
  concurrent diag reader using smp_load_acquire() on sk_state can observe
  SMC_CLOSED while the preceding store to alert_token_local has not yet
  become visible, causing it to dereference an lgr whose reference was
  already dropped.

Is this still accurate with the current __smc_diag_dump()?

A reader that sees SMC_CLOSED now skips the conn->lgr dereference in the
diag_mode test, and the new goto out skips the extension blocks.

Before this store the state is SMC_INIT. smc_listen_work() holds the
socket lock until smc_listen_out(), so close_work can't change it in
between, and SMC_INIT is skipped the same way.

So whichever value the reader sees, it never reads alert_token_local or
conn->lgr, and the release ordering doesn't seem to protect anything the
reader relies on. The commit message already says this for the
stale-token case ("the SMC_CLOSED check in __smc_diag_dump() keeps the
reader from dereferencing conn->lgr").

This reasoning seems to date from v9, before v14 added SMC_CLOSED to the
diag_mode test. Could the fourth item be described as hardening, or
dropped, so stable backporters don't treat the barrier as a required
standalone fix?

>  
>  	smc_listen_out(new_smc);
>  }
> diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
> index a8d4b4b65f244..e26586114f802 100644
> --- a/net/smc/smc_close.c
> +++ b/net/smc/smc_close.c

[ ... ]

> @@ -437,6 +439,7 @@ static void smc_close_passive_work(struct work_struct *work)
>  		sk->sk_state_change(sk);
>  		if ((sk->sk_state == SMC_CLOSED) &&
>  		    (sock_flag(sk, SOCK_DEAD) || !sk->sk_socket)) {
> +			sk->sk_prot->unhash(sk);
>  			smc_conn_free(conn);

[Severity: Medium]

This is a pre-existing issue and wasn't introduced by this patch. Does
smc_conn_free() leak the socket reference held by abort_work when it
cancels a pending abort_work?

smc_conn_free() in net/smc/smc_core.c does:

	} else {
		smc_cdc_wait_pend_tx_wr(conn);
		if (current_work() != &conn->abort_work)
			cancel_work_sync(&conn->abort_work);
	}

and ignores the return value. The only code that schedules abort_work is
smc_cdc_msg_validate(), and it hands a reference to the work:

		sock_hold(&smc->sk); /* sock_put in abort_work */
		if (!queue_work(smc_close_wq, &conn->abort_work))
			sock_put(&smc->sk);

smc_conn_abort_work() drops that reference when it runs. Suppose
abort_work is still pending when an SMC-R connection reaches
smc_conn_free() from outside abort_work, for example via __smc_release().
Then cancel_work_sync() returns true, nobody drops the reference, and the
smc_sock is never freed.

smc_close_cancel_work() handles close_work the same way with:

	if (cancel_work_sync(&smc->conn.close_work))
		sock_put(sk);

Should smc_conn_free() do the same for abort_work?

[ ... ]

> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
> index bf0beaa23bdb6..7b4656d6560a6 100644
> --- a/net/smc/smc_diag.c
> +++ b/net/smc/smc_diag.c
> @@ -87,10 +87,11 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>  
>  	r = nlmsg_data(nlh);
>  	smc_diag_msg_common_fill(r, sk);
> -	r->diag_state = sk->sk_state;
> +	r->diag_state = smp_load_acquire(&sk->sk_state);
>  	if (smc->use_fallback)
>  		r->diag_mode = SMC_DIAG_MODE_FALLBACK_TCP;
> -	else if (smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
> +	else if (r->diag_state != SMC_INIT && r->diag_state != SMC_CLOSED &&
> +		 smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
>  		r->diag_mode = SMC_DIAG_MODE_SMCD;
>  	else
>  		r->diag_mode = SMC_DIAG_MODE_SMCR;

[Severity: Medium]

With this change every non-fallback socket in SMC_INIT or SMC_CLOSED is
reported as SMC_DIAG_MODE_SMCR. That includes SMC-D connections, which
used to report SMC_DIAG_MODE_SMCD.

include/uapi/linux/smc_diag.h defines diag_mode as:

/* Mode of a connection */
enum {
	SMC_DIAG_MODE_SMCR,
	SMC_DIAG_MODE_FALLBACK_TCP,
	SMC_DIAG_MODE_SMCD,
};

It has no "unknown" value. Is it intended that an SMC-D connection is
reported as SMC-R here?

Live SMC-D sockets can stay hashed in SMC_CLOSED with a valid lgr and
alert_token_local. smc_close_passive_work() or
smc_close_passive_abort_received() can move a socket to SMC_CLOSED while
the fd is still open. smc_close_passive_work() only unhashes and frees
when:

		if ((sk->sk_state == SMC_CLOSED) &&
		    (sock_flag(sk, SOCK_DEAD) || !sk->sk_socket)) {

SMC-D sockets in SMC_INIT after smc_conn_create() are affected the same
way. A tool that filters by mode (smcss -D / -R style) would put these
sockets in the wrong group.

Could the race be avoided without misreporting? For example, is_smcd
could be cached in the smc_sock, or SMC-D could be inferred from
conn.lgr != NULL && conn.lnk == NULL, which only reads pointers and
doesn't dereference the lgr.

>  	user_ns = sk_user_ns(NETLINK_CB(cb->skb).sk);
>  	if (smc_diag_msg_attrs_fill(sk, skb, r, user_ns))
>  		goto errout;
> @@ -103,6 +104,10 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>  	if (nla_put(skb, SMC_DIAG_FALLBACK, sizeof(fallback), &fallback) < 0)
>  		goto errout;
>  
> +	if (r->diag_state == SMC_INIT || r->diag_state == SMC_CLOSED ||
> +	    smc->use_fallback)
> +		goto out;
> +

[Severity: High]

Can a socket whose connection was already released by smc_conn_abort()
still move into a state this guard doesn't cover?

The guard only checks the sk_state snapshot. Take a client handshake
that fails with a negative rc after smc_conn_create():

smc_connect_rdma()
  connect_abort:
    smc_conn_abort()
      smc_conn_free()   /* sets conn->freed, drops lgr/lnk refs */

smc_connect_decline_fallback() returns early without changing the state,
and smc_connect_work() only does:

	rc = __smc_connect(smc);
	if (rc < 0)
		smc->sk.sk_err = -rc;

So the socket stays hashed in SMC_INIT with use_fallback == false.

Suppose smc_lgr_terminate_sched() had already emptied lgr->list, which
is the stale-token case the changelog mentions. Then smc_conn_free()
skips the unregister:

	if (!list_empty(&lgr->list)) {
		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
		smc_lgr_unregister_conn(conn);
	}

alert_token_local stays non-zero and the conn stays in lgr->conns_all.

smc_cdc_rx_handler() doesn't check conn->freed:

	conn = smc_lgr_find_conn(ntohl(cdc->token), lgr);
	if (!conn || conn->out_of_sync) {

So a close or peer-abort CDC can still queue close_work. Once the
handshake thread drops the socket lock, smc_close_passive_work() does:

	case SMC_INIT:
		sk->sk_state = SMC_APPCLOSEWAIT1;
		break;

Or smc_close_passive_abort_received() moves SMC_INIT to
SMC_PROCESSABORT. Both are plain stores, and neither path reaches the
new unhash plus smc_conn_free() branch.

A diag reader under read_lock(&h->lock) would then see APPCLOSEWAIT1 or
PROCESSABORT and pass both new checks. It would find
smc_conn_lgr_valid() true, because conn->lgr is never cleared. It then
dereferences smc->conn.lgr->is_smcd, conn->sndbuf_desc, conn->rmb_desc
and lgr->list.

Meanwhile terminate_work runs
__smc_lgr_terminate()->smc_conn_kill()->smc_close_active_abort(). Its
ACTIVE/APPCLOSEWAIT branch goes to SMC_CLOSED without unhashing:

	case SMC_ACTIVE:
	case SMC_APPCLOSEWAIT1:
	case SMC_APPCLOSEWAIT2:
		sk->sk_state = SMC_PEERABORTWAIT;
		smc_close_cancel_work(smc);
		if (sk->sk_state != SMC_PEERABORTWAIT)
			break;
		sk->sk_state = SMC_CLOSED;
		sock_put(sk); /* (postponed) passive closing */

So the hash write_lock is never taken before smc_lgr_free() drops the
last lgr reference. Wouldn't the reader then be dereferencing a freed
smc_link_group?

There is also a weaker variant, where the token is cleared normally and
the lgr is freed synchronously via smc_lgr_cleanup_early(). Safety then
depends on the token clear being visible to a reader that acquire-loads
an sk_state written with a plain store. This is probably ordered in
practice through lock_sock()/release_sock(), but the patch doesn't
establish it.

Separately, after a failed handshake the same SMC_INIT to
SMC_APPCLOSEWAIT1 transition later runs the "postponed passive closing"
sock_put() in smc_close_active() or smc_close_active_abort(). But
smc_connect_decline_fallback() has already dropped that reference.

Would one of these work better?

- unhash a socket whose conn was freed by smc_conn_abort(), or
  otherwise hide it from diag
- cancel close_work, or check conn->freed in smc_cdc_rx_handler() and
  in the diag reader
- pin the lgr for as long as stale conn state is visible

>  	if ((req->diag_ext & (1 << (SMC_DIAG_CONNINFO - 1))) &&
>  	    smc->conn.alert_token_local) {

[Severity: Medium]

This is a pre-existing issue and wasn't introduced by this patch. Is
req->diag_ext guaranteed to be inside the request payload here?

smc_diag_handler_dump() starts the dump after checking only:

	if (h->nlmsg_type == SOCK_DIAG_BY_FAMILY &&
	    h->nlmsg_flags & NLM_F_DUMP) {

The generic __sock_diag_cmd() only checks for a struct sock_diag_req:

	if (nlmsg_len(nlh) < sizeof(*req))
		return -EINVAL;

That struct is 2 bytes. So an unprivileged SOCK_DIAG_BY_FAMILY |
NLM_F_DUMP request for AF_SMC with a 2 byte payload is accepted. diag_ext
is at payload offset 3, past skb->len, in tailroom that
netlink_sendmsg() never initialized.

Those uninitialized bits then decide whether SMC_DIAG_CONNINFO,
SMC_DIAG_LGRINFO and SMC_DIAG_DMBINFO are emitted. That exposes the bits
to the requester, and KMSAN would report it as uninit-value.

inet_diag and unix_diag reject requests shorter than their family
request struct. Should smc_diag_handler_dump() also reject
nlmsg_len(h) < sizeof(struct smc_diag_req)?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261028070210.1685136-1-mjambigi%40linux.ibm.com
