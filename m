Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E1F39099C;
	Mon, 19 Oct 2026 09:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792401545; cv=none; b=rRrsz6xYo7lDdhdv+cNAEJkkwIjfXxkIqPzvBxLsrG6e5bcjeKWGC/Jb4NGZ58TrljkVWEF9wfwmoEZQ2frQquNdMeEaRvJoy+pFbumg1KdVaAQHODlpEIZW1Shyid9mYCoPNxzcj0XsiTfeO8e48L79GKh+8pIKNspjV3AJJSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792401545; c=relaxed/simple;
	bh=+7YEmMh9hqu9EFqnLCRSsNJtJX3xTYVHHsuMazPAaZM=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DFDgADhB8QLJ1Ka3z9RL4ZrR6zxQBBzr1jVA5vqA8KEb8x0yzsmWlkfIREEACAm1HHB1FXthl+7jlkWj5lDvlP35YhI3QYMQ8j9fHVfEqgj1KiSrJ431nGQ5+qE3Zw06rri3w9YoSFJmDoaqGiacONFq7gnRjRAeOO7CiOaGx68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i19dov7+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i19dov7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350161F000C5;
	Mon, 19 Oct 2026 09:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792401544;
	bh=oN70H5R9ldPbMGdAr2ddG48R+ac02LOo0uRx3leltQU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=i19dov7+vGYjSHrO6jpb2nbQ4GIXDtxmwgJ1eZLG+iurtBU/w2rpNV3RI8TxKuEOq
	 rLAlAq9YQYe6dTie7MA8+ojwz534boCl+tizXrN95A0aV7vH7x6L4gi0xBSjbh7iZc
	 qDNAVSE95znBlVeZANVjVkm8JhNr0TAyQnAjlVh2z3HkAB8FR3bQFl20/qg6Lgc8t2
	 ENodISmPYwI/7bxlKDed0gJL9f5n48EiGZGnBU5z5mRQzMwv0HTwVYVA11wVesAjjv
	 UlRaka7UNppXEO8yC5iYmjlkru7U+aGc1YrYII3mV7sEyPeSUrSBbPy2Hlmt0eMvu8
	 Ei4Owapx6kabQ==
Subject: Re: [PATCH net v11] net/smc: fix lgr/lnk lifetime vs diag reader race
From: netdev-bot+sashiko@kernel.org
To: mjambigi@linux.ibm.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, hidayath@linux.ibm.com,
 pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, stable@vger.kernel.org, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Date: Mon, 19 Oct 2026 09:19:02 +0000
Message-ID: <179240154272.3135.17238777571997282600@kernel.org>
In-Reply-To: <20261015081349.1252391-1-mjambigi@linux.ibm.com>
References: <20261015081349.1252391-1-mjambigi@linux.ibm.com>
X-sashiko-severity: Critical
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 1 · High: 0 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Critical] The patch makes smc_conn_free() call
  smc_lgr_unregister_conn() unconditionally.

--

net/smc: fix lgr/lnk lifetime vs diag reader race

This patch closes races between the SMC sock_diag dump and teardown of
conn/lgr/lnk state. It unhashes sockets before smc_conn_free() and
smcd_buf_detach(), orders sk_state with acquire/release, skips the
extension attributes for sockets in SMC_INIT/SMC_CLOSED, and uses the
cached link->ibname. It also makes smc_conn_free() always call
smc_lgr_unregister_conn().

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 9974149659c2..6735f185cf48 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1279,10 +1279,9 @@ void smc_conn_free(struct smc_connection *conn)
>  		if (current_work() != &conn->abort_work)
>  			cancel_work_sync(&conn->abort_work);
>  	}
> -	if (!list_empty(&lgr->list)) {
> +	if (!list_empty(&lgr->list))
>  		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
> -		smc_lgr_unregister_conn(conn);
> -	}
> +	smc_lgr_unregister_conn(conn);
>  
>  	if (!lgr->conns_num)
>  		smc_lgr_schedule_free_work(lgr);

[Severity: Critical]
Now that the unregister is unconditional, can lgr->free_work get re-armed
on a link group that is already being torn down? If so, the lgr could be
freed while that timer is still pending.

smc_lgr_cleanup_early() unlinks the lgr but never sets lgr->freeing:

smc_lgr_cleanup_early() {
    ...
	if (!list_empty(&lgr->list))
		list_del_init(&lgr->list);
	spin_unlock_bh(lgr_lock);
	__smc_lgr_terminate(lgr, true);
}

smc_lgr_schedule_free_work() checks only lgr->freeing, not
lgr->terminating:

	if (!lgr->freeing) {
		mod_delayed_work(system_percpu_wq, &lgr->free_work, ...

__smc_lgr_terminate() cancels free_work once, before a loop that sleeps
in lock_sock(). After the loop it calls smc_lgr_free(), and nothing on
that path cancels free_work again:

__smc_lgr_terminate() {
    ...
	cancel_delayed_work(&lgr->free_work);
	lgr->terminating = 1;
	...
		lock_sock(&smc->sk);
		smc_conn_kill(conn, soft);
	...
	smc_lgr_cleanup(lgr);
	smc_lgr_free(lgr);
}

One possible sequence on an SMC-D server:

- Conn X creates a first-contact lgr L. smc_listen_work() releases
  smc_server_lgr_pending for SMC-D right after sending ACCEPT.

- Conn Y joins L. smc_conn_create() has no conns_num limit for SMC-D.

- X's CONFIRM fails:
  smc_listen_decline(X) -> smc_conn_abort() -> smc_conn_free(X), while
  L is still listed. Then smc_lgr_cleanup_early(L) runs list_del_init()
  and __smc_lgr_terminate(L) cancels free_work, sets terminating = 1 and
  blocks in lock_sock(Y). Y's listen worker holds that lock while it
  waits for its own CONFIRM.

- Y's CONFIRM also fails:
  smc_listen_decline(Y) -> smc_conn_abort() -> smc_conn_free(Y). The
  lgr list is now empty, but with this change smc_lgr_unregister_conn(Y)
  still runs. conns_num drops to 0, freeing is 0, so
  smc_lgr_schedule_free_work() arms free_work with
  SMC_LGR_FREE_DELAY_SERV.

- X's worker resumes, the loop ends, and smc_lgr_free(L) ->
  smc_lgr_put() -> __smc_lgr_free() -> kfree(L) runs while free_work is
  still pending.

Would the timer then fire on freed memory? If L were still alive at that
point, smc_lgr_free_work() would see freeing == 0 and an empty conns_all
and call smc_lgr_free() a second time.

Before this patch, smc_conn_free(Y) skipped smc_lgr_unregister_conn() when
the lgr list was empty, so conns_num stayed at 1 and free_work was not
re-armed.

The peer decides whether and when each CONFIRM fails, and with
loopback-ism the client can be a local unprivileged user.

Should smc_lgr_cleanup_early() set lgr->freeing like the other unlink
paths do? Alternatively, smc_lgr_schedule_free_work() could also check
lgr->terminating.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261015081349.1252391-1-mjambigi%40linux.ibm.com
