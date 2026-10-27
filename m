Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793114146;
	b=Eay1jgSQ0/m0PWQF/5xNGQ8bcHqv6b+3nKRFbhj9wvdRzPqmlZR64lSgJOeM+qs4nRne
	 H8GhtTPt5Qm3A9g49TQ5UI4Q7nvT0DN7ZGl+XEkUOY5qLH1hZeHP0HFyCdslNQ+D9UdMG
	 pRI6b+JdzDQxqrUFkePnRu9s3z7vfXmXlX2X6QDFLj2ZNQuBKN0TGnHSpS69GEmXySbvI
	 pKD6DqxwHPYX2SOTz2DfZQmtp9c783MlOYl9fTfzm947YUI896g3o21bcrOXoH7B+wlrM
	 Vwj/s/qPMp/zi44Q19oS+zRHt7we4VMWEhCpb9AiSeSc8eXuW4RU8rlrQZdTbo/n4oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793114146;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=IvZFZXIpdj4sFPxJ4kZaPc0Pvo8gnHI83xUdJmroOIw=;
	b=UDDHMOn3sM+bWKEn1QjSFSXbOprRxs8/RUs6NIW/qai6NBpJ7vT4sqp7sLxxz/J00jG7
	 GDKK1vrLtNd4R/+fvLBDNqptGpChnj2+jdkBbdMLGlhxRk5WE2JfOwoXGuKEWw1QdPwuq
	 96FPStUvOE1g3ulLCh4GH6f8lJZ9QhZsSK4TumPcxzu/68EHEqu4pWAzYHC+9ggjQq7Sm
	 4AHcLJiT0gjylvsqjNMQVtEN1u306xCG4t4xfgyZ0lLSso51jCDg3q0kiagDoxaGSX0mh
	 hWYp8AyVdEBngBWs9JfLbfRk5DFrnjEwJG2RmI1SiExQL7IjWSooGcaeQWGDu99ZDWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="oqP/TSLl";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4243E606A31E;
	Tue, 27 Oct 2026 15:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oqP/TSLl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC9A1F01829;
	Tue, 27 Oct 2026 15:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793114146;
	bh=IvZFZXIpdj4sFPxJ4kZaPc0Pvo8gnHI83xUdJmroOIw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=oqP/TSLl7GUDp1RRDJr64m0QXWHfFn4SS0GytZtETmTR1XkBYuPqdqeD5DxgLQ4q2
	 bVhY5zA6w5vSErcJuqfrwZMSIXmP5f3pPgwFdI6KvMJPGf+oPe2Q2uMKXsF60WVo8A
	 jGpZBJseB9W3QK3yvvKEhJ9WI/ewhwtuJVVJTEoBL5PCzTLf7iEmymloEXd9N808bU
	 DWg9t6WNcrlraYwmmvUCGTrm61BIrEUgG6BerZ5gS3PHwFRffjqivK08MwgDXXq1Lw
	 p9DV8k9r26TneeqBLpHSxovmgONKTn/FEj7N7C5BVtAizwwJ3Ni48/N2DMLOJPYpI4
	 1esRJffeVcQ0A==
Subject: Re: [PATCH net v13] net/smc: fix lgr/lnk lifetime vs diag reader race
From: netdev-bot+sashiko@kernel.org
To: mjambigi@linux.ibm.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, hidayath@linux.ibm.com,
 pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, stable@vger.kernel.org, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Date: Tue, 27 Oct 2026 15:15:44 +0000
Message-ID: <179311414480.3134.15723255171112798704@kernel.org>
In-Reply-To: <20261023150317.1163397-1-mjambigi@linux.ibm.com>
References: <20261023150317.1163397-1-mjambigi@linux.ibm.com>
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] Use-after-free read of the link group in __smc_diag_dump()
  (net/smc/smc_diag.c, lines 93-94) for hashed SMC_CLOSED sockets that…
- [Medium] The new state-based guard in __smc_diag_dump() (smc_diag.c:93
  and 107-109) can be bypassed by a stale-registration socket that…

--

net/smc: fix lgr/lnk lifetime vs diag reader race

This patch tries to close several windows where the SMC sock_diag dump
can dereference a freed or partially freed conn/lgr/lnk on a socket that
is still hashed. It adds an SMC_INIT/SMC_CLOSED/fallback guard in
__smc_diag_dump(), pairs it with acquire/release on sk_state, and unhashes
sockets before smc_conn_free() and smcd_buf_detach() in the teardown
paths. It also uses the cached link->ibname for the LGRINFO attribute.

[ ... ]

> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
> index bf0beaa23bdb6..84c45aabc196c 100644
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
> +	else if (r->diag_state != SMC_INIT &&
> +		 smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)

[Severity: High]
Can this still dereference a freed link group for a hashed socket in
SMC_CLOSED?

The diag_mode check here only excludes SMC_INIT. The new SMC_INIT /
SMC_CLOSED / use_fallback guard comes later, after
smc->conn.lgr->is_smcd has already been loaded.

The v13 changelog describes how a stale alert_token_local can survive.
Once smc_lgr_terminate_sched() has emptied lgr->list, smc_conn_free()
skips the unregister but still drops the references:

net/smc/smc_core.c:smc_conn_free() {
    ...
	if (!list_empty(&lgr->list)) {
		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
		smc_lgr_unregister_conn(conn);
	}
    ...
lgr_put:
	if (!lgr->is_smcd)
		smcr_link_put(conn->lnk); /* link_hold in smc_conn_create() */
	smc_lgr_put(lgr); /* lgr_hold in smc_conn_create() */
}

On the server side this looks reachable as:

smc_listen_work()
  smc_conn_create()          <- joins existing SMC-R lgr L
                             <- smc_lgr_terminate_sched(L) empties L->list
  smc_clc_wait_msg()         <- peer resets, rc < 0 (-ECONNRESET/-EPROTO)
  smc_listen_decline()
    smc_conn_abort()
      smc_conn_free()        <- unregister skipped, token stays set
    smc_listen_out_err()     <- SMC_CLOSED, use_fallback false, hashed

Since rc < 0 there is no fallback. The socket stays hashed in the accept
queue or until smc_close_non_accepted() takes the sock lock. Later,
terminate_work runs:

__smc_lgr_terminate()
  smc_conn_kill()            <- clears token under conns_lock
    smc_close_active_abort() <- SMC_CLOSED case just breaks, no unhash
  smc_lgr_cleanup()
  smc_lgr_free()
    smc_lgr_put()
      __smc_lgr_free()       <- kfree(lgr)

Nothing in that sequence synchronizes with the hash read_lock that the
diag reader holds. A reader could see the non-zero token in
smc_conn_lgr_valid() and then load smc->conn.lgr->is_smcd after the
kfree. That would read freed memory.

The "Fourth" paragraph of the commit message says this case must not
happen: observing SMC_CLOSED and dereferencing an lgr whose reference was
already dropped. The smp_store_release() added in smc_listen_out_err()
only helps when the token was actually cleared, and here it was not.

The client close() path (SMC_INIT -> SMC_CLOSED in smc_close_active())
doesn't seem to be exploitable this way. The reader's read_lock blocks
the unhash in __smc_release() while the sock lock is held. The server
path above has no such protection.

Could the SMC_INIT / SMC_CLOSED / use_fallback check move ahead of the
diag_mode computation? Adding r->diag_state != SMC_CLOSED to this
condition would also work.

>  		r->diag_mode = SMC_DIAG_MODE_SMCD;
>  	else
>  		r->diag_mode = SMC_DIAG_MODE_SMCR;
> @@ -103,6 +104,10 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>  	if (nla_put(skb, SMC_DIAG_FALLBACK, sizeof(fallback), &fallback) < 0)
>  		goto errout;
>  
> +	if (r->diag_state == SMC_INIT || r->diag_state == SMC_CLOSED ||
> +	    smc->use_fallback)
> +		goto out;
> +

[Severity: Medium]
Can a stale-registration socket get past this guard if it leaves
SMC_INIT through passive close instead of fallback?

Here is a scenario on an SMC-R client:

smc_connect_rdma()
  smc_conn_create()             <- registers conn in existing lgr L
                                <- smc_lgr_terminate_sched(L) empties
                                   L->list
  smc_clc_send_confirm() fails  <- rc < 0
  smc_conn_abort()
    smc_conn_free()             <- unregister skipped, lgr/lnk refs
                                   dropped
smc_connect_decline_fallback()  <- rc < 0, returns without fallback

A positive decline code followed by a failing smc_clc_send_decline()
ends up in the same place.

The socket stays hashed in SMC_INIT with use_fallback false. The conn is
still in L->conns_all with its alert_token_local set, so
smc_cdc_rx_handler() -> smc_lgr_find_conn() still finds it. The peer has
the token from the confirm, or can guess it from the sequential counter.

A CDC with close or abort flags then queues close_work, which moves the
socket out of SMC_INIT:

smc_close_passive_work():
	case SMC_INIT:
		sk->sk_state = SMC_APPCLOSEWAIT1;

smc_close_passive_abort_received():
	case SMC_INIT:
	case SMC_ACTIVE:
	case SMC_APPCLOSEWAIT1:
		sk->sk_state = SMC_PROCESSABORT;

At that point the state is neither SMC_INIT nor SMC_CLOSED, use_fallback
is false, and smc_conn_lgr_valid() is true because of the stale token.
The reader then dereferences:

- smc->conn.lgr->is_smcd
- conn->sndbuf_desc->len and conn->rmb_desc->len (still on L's lists,
  since smc_buf_unuse() was skipped)
- lgr->list and lgr->role
- the conn->lnk fields

Meanwhile __smc_lgr_terminate() -> smc_conn_kill() clears the token and
calls smc_close_active_abort():

- The ACTIVE/APPCLOSEWAIT branch never unhashes.
- The PROCESSABORT branch now unhashes, but smc_conn_free() returns early
  because conn->freed is already set.

smc_lgr_free() -> __smc_lgr_free() then frees the buffers and kfree()s L.

What makes that free wait for a diag reader that has already passed the
token check? The v13 changelog names this stale-registration case, but it
seems to handle only the variant where the socket falls back.

>  	if ((req->diag_ext & (1 << (SMC_DIAG_CONNINFO - 1))) &&
>  	    smc->conn.alert_token_local) {
>  		struct smc_connection *conn = &smc->conn;

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261023150317.1163397-1-mjambigi%40linux.ibm.com
