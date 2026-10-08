Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37EBF38AC99;
	Thu,  8 Oct 2026 16:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791476001; cv=none; b=EuJil/DEBMOxwKIB8q1boVD6it3nfO5wGObpPvuVR5Adg1QI9fdpdzQg/XRW6+p/dxx73lsB7z+r4L3U8YVZh3aD8sWp1PZV5WiD9RAvDc4e7QlXoMtKVRsJ4rF1U59RaLrBdsZiboOVeoc27C/oD5NI9KKvfTpONzxlc87LCMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791476001; c=relaxed/simple;
	bh=I+xC+WZE121bT0mroLJdu1L8ddUbslmzPDc4dujPHac=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Yf63hxSRR1EbLJ1Ge0NayoZPHJNiheNRI7iHKdzLLhfr58RQftA4CQ34JsN5vM1ilgm0cQg/ZLiqAsLHhYxCNrg2eT/UYzcEquHcjeJI2i+qp7GYR4EiFXX131kByl4sx6FDiiQlE4FIBnDd13jzyWGIl0SQ6YrYewzFJp2/ijs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m3MQrl45; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m3MQrl45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89A21F0089E;
	Thu,  8 Oct 2026 16:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791475999;
	bh=bR3lSv4dtTfWpHF6ntHioN9j/2JEJW6KkCIUr1O2GkU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=m3MQrl45/OFi0u+vQPtD9nCP88Q+TCS8U/vZG4QTBVfNYOFDYTfyyCwTRIFxJhJkX
	 XM1bPBBkjDdfaAmMt6Nx7sfw7IZgEmBRQzJyFvPOi7jrW9dPTfIkQzyK0WpATL9CJ4
	 g2xdPJMhRBph1nRsPZywG7BUjDRCZ2+zNq7CUiTLfcrfhJ+oig7QHveFp5S1NF3nCO
	 hvtadbFAgj97fJbb1dgeDZkX1juX5n8ZSwvG4drtuC2KAYRTdM738hTyWLR1p9gGpN
	 1IeX2LXld5Hy1UdzwjIqG+GV5uyVqXDK9gw3UJuZHKPEIy99H4tGtSi3CbecbC7GXq
	 LhkrNLUEqgKBg==
Subject: Re: [PATCH net v8] net/smc: fix lgr/lnk lifetime vs diag reader race
From: netdev-bot+sashiko@kernel.org
To: mjambigi@linux.ibm.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, hidayath@linux.ibm.com,
 pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, stable@vger.kernel.org, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Date: Thu, 08 Oct 2026 16:13:18 +0000
Message-ID: <179147599850.434549.17282557208373125996@kernel.org>
In-Reply-To: <20261005131241.1575131-1-mjambigi@linux.ibm.com>
References: <20261005131241.1575131-1-mjambigi@linux.ibm.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The commit message says the conn/lgr/lnk blocks of
  __smc_diag_dump() are guarded for SMC_INIT and SMC_CLOSED sockets.
- [Low] In __smc_diag_dump() (net/smc/smc_diag.c:93-97) the new
  `r->diag_state != SMC_INIT &&` check in the diag_mode selection sends…

--

net/smc: fix lgr/lnk lifetime vs diag reader race

The patch closes races between the SMC diag dump and connection teardown.
It skips the conn/lgr/lnk attribute blocks for SMC_INIT and SMC_CLOSED
sockets, and pairs smp_load_acquire()/smp_store_release() on sk_state. It
also unhashes the socket before smc_conn_free() or smcd_buf_detach() in
several teardown paths, and copies the cached link->ibname.

> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
> index bf0beaa23bdb6..36a3b8f31f28d 100644
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
>  		r->diag_mode = SMC_DIAG_MODE_SMCD;
>  	else
>  		r->diag_mode = SMC_DIAG_MODE_SMCR;

[Severity: Low]
Is this change to diag_mode intended? With the new r->diag_state !=
SMC_INIT check, every non-fallback SMC_INIT socket falls into the else
branch and is reported as SMC_DIAG_MODE_SMCR.

Before this patch, an SMC_INIT socket with a registered SMC-D link group
was reported as SMC_DIAG_MODE_SMCD.

On the client side, this window runs from smc_conn_create() in
smc_connect_ism() until the smp_store_release() to SMC_ACTIVE. On the
server side it lasts until smc_listen_out_connected(), which includes
waiting for the peer's CLC CONFIRM. During that time, sock_diag users see
an SMC-D connection labelled as SMC-R. The "Mode of a connection" enum in
include/uapi/linux/smc_diag.h has no "unknown" value for this case.

The commit message says:

  "Guard the conn/lgr/lnk blocks in __smc_diag_dump() for SMC_INIT and
   SMC_CLOSED sockets; smcss already suppresses these attributes for
   closed/unconnected sockets so there is no observability regression."

It doesn't mention the diag_mode change, which only appears in the v6
changelog below the --- line.

Could the transport type be recorded in a field of struct smc_sock when
the lgr is assigned? That would avoid both the lgr dereference and the
wrong mode.

[ ... ]

> @@ -103,6 +104,9 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>  	if (nla_put(skb, SMC_DIAG_FALLBACK, sizeof(fallback), &fallback) < 0)
>  		goto errout;
>  
> +	if (r->diag_state == SMC_INIT || r->diag_state == SMC_CLOSED)
> +		goto out;
> +

[Severity: Medium]
The commit message says the conn/lgr/lnk blocks are guarded for both
SMC_INIT and SMC_CLOSED. The diag_mode selection above excludes only
SMC_INIT, and it runs before this early exit.

For an SMC_CLOSED socket, can __smc_diag_dump() still call
smc_conn_lgr_valid() and then dereference smc->conn.lgr->is_smcd?

In the server handshake error path, a CLOSED socket stays hashed after
its conn has been freed:

smc_listen_decline()
  smc_conn_abort()
    smc_conn_free()
      smc_lgr_unregister_conn()
        write_lock_bh(&lgr->conns_lock);
        __smc_lgr_unregister_conn()
          conn->alert_token_local = 0;
        write_unlock_bh(&lgr->conns_lock);
      smcr_link_put(conn->lnk);
      smc_lgr_put(lgr);          <-- conn->lgr is left set
  smc_listen_out_err()
    newsmcsk->sk_state = SMC_CLOSED;

The SMC_CLOSED store in smc_listen_out_err() is a plain store, not the
smp_store_release() this patch adds for SMC_ACTIVE.

Between the alert_token_local reset and the CLOSED store, the only
operations are release-ordered ones: write_unlock_bh(),
refcount_dec_and_test() via smcr_link_put()/smc_lgr_put(), and
sock_put(). None of them orders the later CLOSED store.

On a weakly ordered CPU such as arm64, could the reader's
smp_load_acquire() see SMC_CLOSED while alert_token_local still reads as
non-zero? The reader would then dereference an lgr that the connection no
longer holds a reference to. If link-group freeing runs concurrently,
that read is a use-after-free.

This needs a non-local-first lgr with a negative reason code, so that
smc_lgr_cleanup_early() is not called. The window is narrow.

Would it help to exclude SMC_CLOSED from the diag_mode condition as well,
or to move this early exit ahead of the diag_mode selection? Publishing
SMC_CLOSED in smc_listen_out_err() with smp_store_release() would also
close the gap.

>  	if ((req->diag_ext & (1 << (SMC_DIAG_CONNINFO - 1))) &&
>  	    smc->conn.alert_token_local) {
>  		struct smc_connection *conn = &smc->conn;

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261005131241.1575131-1-mjambigi%40linux.ibm.com
