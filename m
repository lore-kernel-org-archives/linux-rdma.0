Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792678389;
	b=hhO5JHZYZavBs9d8YMv8Sy/WC8Kg2YCV+86CyGkPFTCc2mHtoLJZXXeexicGcIwADh0H
	 lVYlKToPv7y11d6yShvp64mECewvXz8OgMTdexXpSTfRBmr8zUjqBQLveABzIRIJ/S1KL
	 v6sy1VlNUdML2gP9EIL0NJssX5ChxlPRnyc2Bsbu/Y+v1lsmXW9loRwkr0qVI1Ay5+naj
	 ixZSlwTk6sdaVlAlZETYo49lpsEfqAdBlIkRVm8ZsVWnsCG4W+amWDcO0smq76RvZoNwM
	 f1cXZRrBghDff+DjwM0Y9Bo7lMs7yfRweoD4/KgfRkm9u8OJMamMDHq0jYt5NGHM7sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792678389;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=lVyCsAyW+f6wFm05LptcX8c53okKTmSAzUoLzdTwIEs=;
	b=wJUVwb65GyzNBnmIgsZHTSC0188HScAi2H3c6aHGDhYK7rWSyq1coxDQd+yJW1LsMmf2
	 128UGxAErh/Zw69lnkMaaMhsEReZQM+uMnVl/M/+MJ8ICl2e3CkQWFYAcgZC9cAPRedGc
	 uqW0LVT9x1zirm2KttV54xPy3huamSHge0BV9jqjikR5nvI3WKoQMHWTfmf3vPJeQJfud
	 EBToCuG1kQx0tgzy2AF4MYRS3vpZaJkdLTS1myLurF2hry/+mOoavWDxrixJrryxc02eD
	 MT4LU5O8QRzYNHV4y2s5wUhJJu6X3iUdvSlkCQeoDw4PZtl1oLT3FIfsWWuSBK3FB2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GAkbFUMH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F76606A327;
	Thu, 22 Oct 2026 14:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GAkbFUMH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CEC21F000C1;
	Thu, 22 Oct 2026 14:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792678388;
	bh=lVyCsAyW+f6wFm05LptcX8c53okKTmSAzUoLzdTwIEs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=GAkbFUMHDzBKKbZkl3JMrYDZPR48XXJ7UUtT+UPPVA2uV+e+/Bb2HtlZP788n+FkH
	 ZMCCmB7P83Rnq5jHIygQZX/3sc84m8JA3yUPhoOMVVZOjr6jH3P+mKP7DGrQS/f5Tc
	 9n6bCpAiVJS84gXn3ReeSTa6C3CSBlrRDSieHtbCAc1yxtgIsQlFN5XnECNWJV6aZo
	 YCKLb7UyAUaRU03heJdoNcQVaunmPK1D9FqJziOtIoQVyS3lobaFqh1COvt6RL39OZ
	 pqT/zkr/kc4//vhqFCevmGdd8WrsWKwVYyUuAA2oIgVN225O3Jti6BCvh9bqk1uhE6
	 iYAEOnOxddusQ==
Subject: Re: [PATCH net v12] net/smc: fix lgr/lnk lifetime vs diag reader race
From: netdev-bot+sashiko@kernel.org
To: mjambigi@linux.ibm.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, hidayath@linux.ibm.com,
 pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, stable@vger.kernel.org, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Date: Thu, 22 Oct 2026 14:13:06 +0000
Message-ID: <179267838686.3135.11610279010793695525@kernel.org>
In-Reply-To: <20261019111008.3367567-1-mjambigi@linux.ibm.com>
References: <20261019111008.3367567-1-mjambigi@linux.ibm.com>
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

Critical: 0 · High: 1 · Medium: 0 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The v12 `!lgr->terminating` guard in
  smc_lgr_schedule_free_work() (net/smc/smc_core.c) does not close the…
- [Low] The commit message says "Other kill paths leave the socket
  hashed, since it can stay open until close()".
- [Low] The commit message's 'Fifth' paragraph gets the mechanism of its
  own example wrong.

--

net/smc: fix lgr/lnk lifetime vs diag reader race

This patch closes several windows where the SMC sock_diag dump can
dereference conn/lgr/lnk state that has already been freed. It skips the
CONNINFO/LGRINFO/DMBINFO attributes for SMC_INIT and SMC_CLOSED sockets,
orders sk_state with acquire/release, unhashes sockets before teardown in
several paths, and copies the cached link->ibname. It also unregisters
connections unconditionally in smc_conn_free() and stops arming free_work
on a terminating link group.

> Fifth, on the smc_lgr_cleanup_early() path (e.g. server CLC decline with
> SYNCERR) __smc_lgr_terminate() sets terminating=1 and unlinks the LGR
> without setting freeing=1.

[Severity: Low]
Is the SYNCERR example here accurate? On the server, smc_clc_wait_msg()
handles a DECLINE that carries SMC_FIRST_CONTACT_MASK like this
(smc_clc_send_decline() sets that mask for SMC_CLC_DECL_SYNCERR):

net/smc/smc_clc.c:smc_clc_wait_msg() {
    ...
		if ((dclc->hdr.typev2 & SMC_FIRST_CONTACT_MASK) &&
		    smc->conn.lgr) {
			smc->conn.lgr->sync_err = 1;
			smc_lgr_terminate_sched(smc->conn.lgr);
		}
    ...
}

smc_lgr_terminate_sched() then unlinks the LGR itself and sets freeing:

net/smc/smc_core.c:smc_lgr_terminate_sched() {
    ...
	list_del_init(&lgr->list);
	lgr->freeing = 1;
    ...
}

All of this happens before smc_listen_decline()->smc_conn_abort()->
smc_conn_free(). Also, smc_conn_abort() calls smc_conn_free() before it
calls smc_lgr_cleanup_early():

	smc_conn_free(conn);
	if (local_first && lgr_valid)
		smc_lgr_cleanup_early(lgr);

So in this example smc_lgr_terminate_sched() unlinks the LGR with freeing
== 1, and the new !lgr->terminating check has no effect.

The skipped smc_lgr_unregister_conn() that leaves alert_token_local
non-zero does look real on this path. However, it is caused by the
terminate_sched unlink, not by smc_lgr_cleanup_early(). The problem is
only in the cited example and its freeing claim.

Could this paragraph name smc_lgr_terminate_sched() for the SYNCERR case,
or use a different example for the smc_lgr_cleanup_early() path?

> diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
> index bb0313ef5f7c1..aa6363abdd747 100644
> --- a/net/smc/smc_close.c
> +++ b/net/smc/smc_close.c
> @@ -154,6 +154,7 @@ void smc_close_active_abort(struct smc_sock *smc)
>  		if (sk->sk_state != SMC_PEERABORTWAIT)
>  			break;
>  		sk->sk_state = SMC_CLOSED;
> +		sk->sk_prot->unhash(sk);
>  		smc_conn_free(&smc->conn);
>  		release_clcsock = true;
>  		sock_put(sk); /* passive closing */
> @@ -165,6 +166,7 @@ void smc_close_active_abort(struct smc_sock *smc)
>  		if (sk->sk_state != SMC_PEERABORTWAIT)
>  			break;
>  		sk->sk_state = SMC_CLOSED;
> +		sk->sk_prot->unhash(sk);
>  		smc_conn_free(&smc->conn);
>  		release_clcsock = true;
>  		break;

[Severity: Low]
The commit message says:

  Other kill paths leave the socket hashed, since it can stay open until
  close().

Does that match the code? Every smc_conn_kill() ends in
smc_close_active_abort(). These new unhash calls run in its
PEERCLOSEWAIT1/PEERCLOSEWAIT2/PEERFINCLOSEWAIT branch and its
PROCESSABORT/APPFINCLOSEWAIT branch.

Sockets whose fd is still open can be in those states:

  smc_close_shutdown_write()          ACTIVE -> SMC_PEERCLOSEWAIT1
  smc_close_passive_work()            -> SMC_APPFINCLOSEWAIT
                                      ("just shutdown, but not yet
                                       closed locally")
  smc_close_passive_abort_received()  -> SMC_PROCESSABORT

When the link group terminates through __smc_lgr_terminate()->
smc_conn_kill()->smc_close_active_abort(), these open sockets are removed
from the SMC hash, and sock_prot_inuse is decremented before close().

smc_close_active_abort() also sets SOCK_DEAD unconditionally. That means
the SOCK_DEAD-gated unhash added to smc_close_passive_work() can fire for
sockets whose fd is still open.

The dmb_nocopy unhash in smc_conn_kill() has a similar effect. It hides
ACTIVE/APPCLOSEWAIT sockets that stay open, but only on loopback-ism
devices.

The v10 changelog gives the opposite reasoning for the other paths ("they
must stay visible to smcss and keep their inuse accounting"). Could the
commit message say that killed sockets in these states are unhashed
before close()? Could it also say that visibility to smcss now depends on
the close state and the device type?

[ ... ]

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 9974149659c2f..9d8165d1b40c5 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -84,7 +84,7 @@ static void smc_lgr_schedule_free_work(struct smc_link_group *lgr)
>  	 * creation. For client use a somewhat higher removal delay time,
>  	 * otherwise there is a risk of out-of-sync link groups.
>  	 */
> -	if (!lgr->freeing) {
> +	if (!lgr->freeing && !lgr->terminating) {
>  		mod_delayed_work(system_percpu_wq, &lgr->free_work,
>  				 (!lgr->is_smcd && lgr->role == SMC_CLNT) ?
>  						SMC_LGR_FREE_DELAY_CLNT :

[Severity: High]
Does this check fully stop free_work from being re-armed on a
terminating link group? The flag check and mod_delayed_work() are not
done under any lock that __smc_lgr_terminate() also takes. On the other
side, the cancel happens before the flag store:

net/smc/smc_core.c:__smc_lgr_terminate() {
	if (lgr->terminating)
		return;	/* lgr already terminating */
	/* cancel free_work sync, will terminate when lgr->freeing is set */
	cancel_delayed_work(&lgr->free_work);
	lgr->terminating = 1;
    ...
}

smc_lgr_cleanup_early() never sets lgr->freeing, so on that path
terminating is the only thing protecting free_work.

On an SMC-D server, smc_listen_work() drops smc_server_lgr_pending right
after sending the ACCEPT:

	/* SMC-D does not need this lock any more */
	if (ini->is_smcd)
		mutex_unlock(&smc_server_lgr_pending);

So a second connection B can join the LGR of first-contact connection A.
Can the following interleaving happen?

CPU1 (connection A, CONFIRM wait failed)
smc_listen_decline()
  smc_conn_abort(A, 1)
    smc_conn_free(A)
      smc_lgr_unregister_conn()        /* conns_num 1 */

CPU2 (connection B)
smc_conn_free(B)
  smc_lgr_unregister_conn()            /* conns_num 0 */
  smc_lgr_schedule_free_work()
    if (!lgr->freeing && !lgr->terminating)   /* passes */

CPU1
    smc_lgr_cleanup_early()
      list_del_init(&lgr->list)
      __smc_lgr_terminate()
        cancel_delayed_work()          /* nothing pending yet */
        lgr->terminating = 1
        /* conns_all is empty, B is not waited for */
        smc_lgr_cleanup()
        smc_lgr_free()                 /* drops base reference */

CPU2
    mod_delayed_work(..., &lgr->free_work, ...)
  smc_lgr_put()                        /* last reference */
    __smc_lgr_free()
      kfree(lgr)

__smc_lgr_free() does not cancel free_work again. The timer would then
fire on freed memory after SMC_LGR_FREE_DELAY_SERV. The same window
exists if CPU2's check lands between the cancel and the terminating
store.

Before this patch the race could happen through B passing the
!list_empty(&lgr->list) check. With smc_lgr_unregister_conn() now called
unconditionally in smc_conn_free(), conns_num can reach 0 at any point up
to the terminating store.

Another question: terminating:1 is written without lgr_lock, and
freeing:1 is written under lgr_lock. Both share a bitfield byte with
sync_err:1. Can concurrent read-modify-writes lose one of the flags this
check relies on?

The comment in __smc_lgr_terminate() says "cancel free_work sync, will
terminate when lgr->freeing is set". However, the code uses a non-sync
cancel, and this path never sets freeing.

Would one of these work instead? Either publish terminating before the
cancel, under a lock that smc_lgr_schedule_free_work() also holds across
its check and mod_delayed_work(). Or do a cancel_delayed_work_sync() of
free_work before the final kfree(lgr) in __smc_lgr_free().

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261019111008.3367567-1-mjambigi%40linux.ibm.com
