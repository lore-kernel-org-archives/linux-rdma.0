Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6849254A7C8;
	Wed,  9 Sep 2026 11:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788954548; cv=none; b=Xi6vYyNa9HL7domXsGmwUYimwIRsqjOq7cVVAj1Df9kFNmtL5LNisp2+IBQcqGo53U5/RRaio3jK9XvjIWU6b91Oga89U7zwDvu9cG1VX1j0ffo7FXdpvmvJrJvnEHgB4VJ/QlrdfVCAkYhMGyFQFgyk8FTPiAcovDL5JNumwwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788954548; c=relaxed/simple;
	bh=JtujcukiK4NZk8OOLPyaWdgV0nzDdyb4bcMKglBlWJA=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BMqUpgmN0YetRGvOLn/FOqwvYbdGxchvWNicoTjMoj90S2S9k9ufz9M/LmbUNbiHT3ZcoS0E5bdooQGeKp0qZijMBVJmUN7n5qZas4YzIEkkn4An8+6QmjGBgd1awYPSHCW8ArWUmbOKq56I/WjyllJx6C8c0GLWf4JIB2MjuR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h80Rm3tm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h80Rm3tm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176BC1F00A3A;
	Wed,  9 Sep 2026 11:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788954546;
	bh=SEEAUrjNGcocwZXt7qLm2N6q7XwrilrtZoreKPI+Bzs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=h80Rm3tmRcSivHT2XMh2LaLoNPeCvrwhu7HNiGKR8+ILEWjeSpe626IBxklVbwk86
	 4Wh5oQ769LEWzYv0vOgLZsNt5wTTXqjcRAsAxmbV6whCOaiqWwTp/66tJXuOLznqyF
	 oiIJLRHyHLa9YzKG6BgCjVFuW/5ZJ6b6PCh6Ni7pAolZaWLO9t1C4fDbWhttc4JxL3
	 tCbD4NWWfH9bvhWmjmsbEcxXraMtuS4cpD3xpVJBT2/R74tcvlZOfeivpm81jJhFvF
	 7iSsnhWFT6EgjanKaf3WoKGyYxQS+o4YQtYexH//4P0kTQb9A3UD/baPVv1NnJC+qu
	 6z8RU50eWIOjw==
Subject:
 Re: [PATCH net v2] net/smc: fix abort_work termination in smc_conn_free()
From: netdev-bot+sashiko@kernel.org
To: hidayath@linux.ibm.com
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com, andrew+netdev@lunn.ch,
 tonylu@linux.alibaba.com, guwen@linux.alibaba.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 pasic@linux.ibm.com, linux-s390@vger.kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org
Date: Wed, 09 Sep 2026 11:49:04 +0000
Message-ID: <178895454461.219967.1315505922405395089@kernel.org>
In-Reply-To: <20260907114721.1303498-1-hidayath@linux.ibm.com>
References: <20260907114721.1303498-1-hidayath@linux.ibm.com>
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

Critical: 0 · High: 1 · Medium: 1 · Low: 0

- [High] New lock-drop window in smc_conn_free() invalidates the
  smc_cdc_wait_pend_tx_wr() barrier before the connection buffers/link…
- [Medium] smc_conn_free() silently changes its locking contract without
  documenting or asserting it, and its callers were not audited for the…

--

net/smc: fix abort_work termination in smc_conn_free()

This moves the abort_work cancel in smc_conn_free() into a new helper
smc_conn_cancel_abort_work() which drops the socket lock around
cancel_work_sync() and drops the socket reference when a pending item was
removed.  It also makes smc_conn_abort_work() skip smc_conn_kill() when
conn->freed is already set.

Link: https://lore.kernel.org/netdev/20260806081549.595001-1-hidayath@linux.ibm.com/

A couple of questions about the new lock drop below.

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 04aedd957543a..9a109eae73b92 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1251,6 +1251,25 @@ static void smc_buf_unuse(struct smc_connection *conn,
>  	}
>  }
>  
> +/* Cancel a pending abort work item.  smc_conn_abort_work() takes the socket
> + * lock, so the lock has to be dropped here.  Otherwise cancel_work_sync()
> + * waits for a worker that is itself blocked on the caller.  This is the idiom
> + * smc_close_cancel_work() already uses for close_work.
> + */
> +static void smc_conn_cancel_abort_work(struct smc_connection *conn)
> +{
> +	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
> +	struct sock *sk = &smc->sk;
> +
> +	if (current_work() == &conn->abort_work)
> +		return;
> +

[Severity: Medium]
Should the new "caller must hold the socket lock" requirement be documented
or asserted?  smc_conn_free() is declared cross-file in net/smc/smc_core.h
as

    void smc_conn_free(struct smc_connection *conn);

and its comment still reads only "remove a finished connection from its
link group", yet for lgr->is_smcd == false it now unlocks and relocks the
socket.  There is no sock_owned_by_me() or lockdep_assert_held() to catch a
caller that does not hold it.

All current call sites do hold the lock (__smc_release(),
smc_close_active_abort(), smc_close_passive_work(), smc_conn_abort()), so
nothing is unbalanced today.  A backport or a new error path that reaches
smc_conn_free() without the lock would call release_sock() on a lock it does
not own and then return with the lock held.

There is also a caller-visible half.  The tree's idiom around a
lock-dropping cancel revalidates state afterwards, as in
smc_close_active_abort():

    sk->sk_state = SMC_PEERABORTWAIT;
    smc_close_cancel_work(smc);
    if (sk->sk_state != SMC_PEERABORTWAIT)
        break;
    sk->sk_state = SMC_CLOSED;
    smc_conn_free(&smc->conn);
    release_clcsock = true;
    sock_put(sk); /* passive closing */

The smc_conn_free() calls in smc_close_active_abort(),
smc_close_passive_work() and __smc_release() revalidate nothing and act on
state that was observed before the new window (release_clcsock = true, the
"passive closing" sock_put()).

Does this also invalidate the invariant declared in smc_listen_work()?

    lock_sock(&new_smc->sk); /* release in smc_listen_out() */

On an SMC-R handshake abort, smc_listen_work() -> smc_conn_abort() ->
smc_conn_free() now drops that lock in the middle, so another thread (for
example __smc_lgr_terminate(), which does lock_sock() before
smc_conn_kill()) can run against a half-set-up socket.

The changelog describes the change as a local fix to the cancel; would it be
worth stating that the calling convention of smc_conn_free() changed for
every call site?

> +	release_sock(sk);
> +	if (cancel_work_sync(&conn->abort_work))
> +		sock_put(sk); /* sock_hold done by schedulers of abort_work */
> +	lock_sock(sk);
> +}
> +

[Severity: High]
Does dropping the socket lock here void the pending-TX drain that
smc_conn_free() performs immediately before this call?

The SMC-R branch of smc_conn_free() is now:

    smc_cdc_wait_pend_tx_wr(conn);      /* cdc_pend_tx_wr drains to 0 */
    smc_conn_cancel_abort_work(conn);   /* release_sock() ... lock_sock() */
    ...
    smc_buf_unuse(conn, lgr);           /* zeroes sndbuf, used = 0 */
    smc_lgr_unregister_conn(conn);

release_sock() on an SMC socket is not a passive unlock.  sk_prot->release_cb
is smc_release_cb(), and net/smc/af_smc.c has:

    if (smc->conn.tx_in_release_sock) {
        smc_tx_pending(&smc->conn);
        smc->conn.tx_in_release_sock = false;
    }

conn->tx_in_release_sock is set from BH in smc_cdc_tx_handler(), on the very
completion that lets smc_cdc_wait_pend_tx_wr() return, when the socket is
owned by the task:

    if (sock_owned_by_user(&smc->sk))
        conn->tx_in_release_sock = true;
    else
        smc_tx_pending(conn);

    if (unlikely(wq_has_sleeper(&conn->cdc_pend_tx_wq)))
        wake_up(&conn->cdc_pend_tx_wq);

So smc_tx_pending() -> smc_tx_sndbuf_nonempty() -> smcr_tx_sndbuf_nonempty()
can post RDMA writes out of conn->sndbuf_desc and a CDC send, re-incrementing
conn->cdc_pend_tx_wr, inside the window this patch opens.
smc_tx_sndbuf_nonempty() only gates on sk_err, an empty send queue, peer RMBE
space and:

    if (conn->killed ||
        conn->local_rx_ctrl.conn_state_flags.peer_conn_abort) {
        rc = -EPIPE;    /* connection being aborted */
        goto out;
    }

conn->freed is never consulted on that path.

Is there a reachable state where sk_err and conn->killed are both clear while
staged data is still present?  Closing an SMC-R socket with SO_LINGER=0 or
from an exiting task returns from smc_close_stream_wait() immediately:

    if (!timeout)
        return;

    if (!smc_tx_prepared_sends(&smc->conn))
        return;

which leaves prepared sends outstanding and the state at SMC_PEERCLOSEWAIT1,
so __smc_release() does not free the connection.  When the peer closes,
smc_close_passive_work() reaches

    smc_conn_free(conn);

with sk_err == 0, conn->killed == 0 and data still staged.

After lock_sock() returns, smc_buf_unuse() does memzero_explicit() on the
send buffer and sets used = 0, returning the descriptor to the link-group
pool while the HCA may still be reading it, and smcr_link_put() /
smc_lgr_put() then run with cdc_pend_tx_wr non-zero, so a later
smc_cdc_tx_handler() completion dereferences pend->conn and the link WR
structures.

Note also that conn->tx_work is not cancelled here, while
smc_close_cancel_work() does cancel_delayed_work_sync(&conn->tx_work).  A
tx_work armed from BH via mod_delayed_work() in smcr_tx_sndbuf_nonempty()
can take the socket lock in the same window and post the same way.

Before this patch cancel_work_sync() ran with the socket lock held, so no
lock-taking tx path could interpose between the drain and the buffer release.

Would it work to cancel abort_work (and tx_work) before
smc_cdc_wait_pend_tx_wr(), or to repeat the drain after lock_sock() returns
and gate smc_tx_pending() on conn->freed?

>  /* remove a finished connection from its link group */
>  void smc_conn_free(struct smc_connection *conn)
>  {
> @@ -1276,8 +1295,7 @@ void smc_conn_free(struct smc_connection *conn)
>  			smcd_buf_detach(conn);
>  	} else {
>  		smc_cdc_wait_pend_tx_wr(conn);
> -		if (current_work() != &conn->abort_work)
> -			cancel_work_sync(&conn->abort_work);
> +		smc_conn_cancel_abort_work(conn);
>  	}
>  	if (!list_empty(&lgr->list)) {
>  		smc_buf_unuse(conn, lgr); /* allow buffer reuse */

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260907114721.1303498-1-hidayath%40linux.ibm.com
