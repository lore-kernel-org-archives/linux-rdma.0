Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792989234;
	b=QZK4xXu0zcNyVFgyjpTAL28WXDECy3FSG5Qwq+1Vun189R/pNLIshzLb/NQHwPWUgvSB
	 f+cBl3phio0WTcSJIYaMWK5m/V7nqrsaueuVZgnY5jkMCn0N0f/gjDfrvLb5iF1PvLkPJ
	 nsTXySkoSo4bKZVn7jHMziAqtkpieoR7yaZRvFvkLOK3qoMgl4c2zwHPwndSDwmzTtY7+
	 9mz1fkP9Z9B4Gy69FQ8XiWDdsGtuTQgsZfxnmmoOVTyX0JzceBuXCh8pMUe8q/Ov0bVZ8
	 R3KYbw+9KGr4xEwmculnz8slYic6ThaLLVqYR6ll9hG0f8C0vTavLOLSb6a53d+d8rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792989234;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=zp+JxXwgQx3uq+loHTFsBZclGNcJgzZQrarebs928zE=;
	b=w3H2lUcQJjfULgo6jqgOfhzooX9JDr01k88VXAv4gkSiZNsyxSDJUX79QpPkupkFIZcW
	 YfUchaqC6W/LDxbiBtEaCllbuGo+dPWiLZLTOlyJjK24unVQiWJfWSAKyET1t1XUYLgHx
	 gHVfOHpOEJGMGw3E5phY4hkOzoYvuSxolNmCc8vjp7Ew/FfMzh6RuEv4f+RbwDagSN6JJ
	 XV5nWqsb/4cx45X4181xTMzuJdPypwGS+PAQcIstPJ4VZWGv/xC82bjcNP9Mj+ZwQjhY+
	 +azQJrVKsZY8JfxIzxS7gw1baz/2IGeprF43XvMUrR+zCaS8EjN8SFEDeMWwxMlubZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VoahMzMk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F39606A31A;
	Mon, 26 Oct 2026 04:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VoahMzMk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906C01F01825;
	Mon, 26 Oct 2026 04:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792989233;
	bh=zp+JxXwgQx3uq+loHTFsBZclGNcJgzZQrarebs928zE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=VoahMzMkvtdPbsD3uSmbKUJQqC5mf52O/YL/1w1xNSNqbIunhBSWoIVGr2d2DIAG/
	 1RvJrSiH3lJ7v6EESg0qLGws2oATxslZQG3E5qJb9pQwmuhf+AWcPN8umgfBmpMNlo
	 xmAv/yeAZ4czaj2Ge+2/gVK055CRKO7jXTggNvz55lKUVECagb6aUAVqAt05nt7u6k
	 grgZRXCW6SasKmRSo2Y51Bw4poS9LMXJQewIi61XNQcpMEbg2OVUdF0g348amJkdfs
	 y5hK0pLMVf1mMd4N0UcKwTDI5GIwcCFtoXnvv/8Swn+lOs304Fjw5JSUF9m9aJ8S5q
	 zup1RDlEGSmwQ==
Subject:
 Re: [PATCH] net/smc: fix possible recursive locking in __smc_lgr_terminate()
From: netdev-bot+sashiko@kernel.org
To: anferneemelokc5@gmail.com
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, linux-rdma@vger.kernel.org,
 linux-s390@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, kuba@kernel.org
Date: Mon, 26 Oct 2026 04:33:52 +0000
Message-ID: <179298923209.3134.328428879251012130@kernel.org>
In-Reply-To: <179290097759.51540.15412712294727302463@gmail.com>
References: <179290097759.51540.15412712294727302463@gmail.com>
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

Critical: 0 · High: 3 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The commit message says smc_conn_free() always unregisters
  new_smc from lgr->conns_all before early cleanup, so…
- [High] The new annotation in __smc_lgr_terminate()
  (net/smc/smc_core.c:1582) creates the lockdep dependency sk_lock-…
- [High] The new nesting annotation covers only the first acquisition of
  the per-connection socket in __smc_lgr_terminate()…

--

net/smc: fix possible recursive locking in __smc_lgr_terminate()

The patch switches the per-connection lock_sock() in __smc_lgr_terminate()
to lock_sock_nested(..., SINGLE_DEPTH_NESTING). The goal is to silence a
syzbot lockdep "possible recursive locking" report in the SMC listen path.
The commit message argues that the socket locked there is always a
different instance from the one the caller already holds.

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 6021322253e93..64c5ee592e641 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1579,7 +1579,7 @@ static void __smc_lgr_terminate(struct smc_link_group *lgr, bool soft)
>  		smc = container_of(conn, struct smc_sock, conn);
>  		sock_hold(&smc->sk); /* sock_put below */
>  		read_unlock_bh(&lgr->conns_lock);
> -		lock_sock(&smc->sk);
> +		lock_sock_nested(&smc->sk, SINGLE_DEPTH_NESTING);

[Severity: High]
The commit message says:

  smc_conn_free() unregisters new_smc from lgr->conns_all before the
  early cleanup, so __smc_lgr_terminate() walks the remaining
  connections and locks another socket, not the one already held.

Is that always true? smc_conn_free() only unregisters the conn while
lgr->list is still non-empty:

net/smc/smc_core.c:smc_conn_free() {
    ...
	if (!list_empty(&lgr->list)) {
		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
		smc_lgr_unregister_conn(conn);
	}
    ...
}

Suppose the peer answers ACCEPT with a CLC DECLINE that has
SMC_FIRST_CONTACT_MASK set. That arrives while smc_listen_work() is
waiting for CONFIRM and still holding new_smc->sk:

smc_listen_work()
  lock_sock(&new_smc->sk)
  smc_clc_wait_msg()
    smc_lgr_terminate_sched(smc->conn.lgr)
      list_del_init(&lgr->list);
      lgr->freeing = 1;
      schedule_work(&lgr->terminate_work);
  smc_listen_decline()
    smc_conn_abort()
      smc_conn_free()        <- lgr->list empty, conn stays in conns_all
      smc_lgr_cleanup_early()
        __smc_lgr_terminate()
          lock_sock_nested(&new_smc->sk, SINGLE_DEPTH_NESTING)

smc_lgr_terminate_sched() does not set lgr->terminating. If
terminate_work has not run yet, __smc_lgr_terminate() gets past its
terminating check, and rb_first(&lgr->conns_all) can return new_smc's own
conn.

smc_conn_abort() computes lgr_valid before it calls smc_conn_free(), so
the early cleanup still runs on this path.

Wouldn't the kworker then sleep forever in __lock_sock(), waiting for a
socket lock it already owns?

lock_sock() is just lock_sock_nested(sk, 0), so this change doesn't
alter runtime behavior. It only changes the lockdep subclass, which hides
the self-recursion report in this case.

Would the fix need to make sure the caller's own conn is unregistered, or
skipped in __smc_lgr_terminate(), rather than annotating the lock?

[Severity: High]
Can this annotation create a lockdep ordering inversion against
smc_release()?

With this patch, the listen and connect paths record
sk_lock-AF_SMC -> sk_lock-AF_SMC/1:

smc_listen_work()
  lock_sock(&new_smc->sk)                              subclass 0
  smc_listen_decline()->smc_conn_abort()->smc_lgr_cleanup_early()
    __smc_lgr_terminate()
      lock_sock_nested(&smc->sk, SINGLE_DEPTH_NESTING) subclass 1

smc_release() already records the opposite order when it closes a
listener that still has non-accepted children:

net/smc/af_smc.c:smc_release() {
    ...
	if (sk->sk_state == SMC_LISTEN)
		/* smc_close_non_accepted() is called and acquires
		 * sock lock for child sockets again
		 */
		lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
    ...
}

smc_release()
  lock_sock_nested(sk, SINGLE_DEPTH_NESTING)           listener, subclass 1
  __smc_release()->smc_close_active()->smc_close_cleanup_listen()
    smc_close_non_accepted()
      lock_sock(sk)                                    child, subclass 0

Lockdep keeps these dependencies for the whole boot. Once both orders
have been seen, wouldn't it report a possible circular locking dependency
between sk_lock-AF_SMC and sk_lock-AF_SMC/1, triggered by the same syzbot
scenario?

The sockets involved are different instances, so this may not be a real
deadlock. The splat would still fire, though, and lockdep would turn
itself off afterwards.

[Severity: High]
Does the nested annotation cover the whole time this socket lock is held?

smc_conn_kill() calls smc_close_active_abort(). For SMC_ACTIVE,
SMC_APPCLOSEWAIT1/2, SMC_PEERCLOSEWAIT1/2, SMC_PEERFINCLOSEWAIT,
SMC_PROCESSABORT and SMC_APPFINCLOSEWAIT, that goes through
smc_close_cancel_work():

net/smc/smc_close.c:smc_close_cancel_work() {
	release_sock(sk);
	if (cancel_work_sync(&smc->conn.close_work))
		sock_put(sk);
	if (cancel_delayed_work_sync(&smc->conn.tx_work))
		sock_put(sk);
	lock_sock(sk);
}

The release_clcsock branch at the end of smc_close_active_abort() also
takes the lock again with a plain lock_sock(sk).

Both of these take the conn socket again at subclass 0, while
smc_listen_work() still holds new_smc at subclass 0. Wouldn't lockdep
then report the same "possible recursive locking detected", this time
from smc_close_cancel_work()?

This looks reachable for SMC-D, because smc_listen_work() drops
smc_server_lgr_pending right after sending ACCEPT:

	/* SMC-D does not need this lock any more */
	if (ini->is_smcd)
		mutex_unlock(&smc_server_lgr_pending);

Another connection can then join the first-contact lgr and become
SMC_ACTIVE. If this handshake later fails, for example on a CONFIRM
timeout, a failed smc_clc_v2x_features_confirm_check() or a failed
smcd_buf_attach(), this path kills the SMC_ACTIVE conn:

smc_listen_decline()->smc_conn_abort()->smc_lgr_cleanup_early()
  ->__smc_lgr_terminate()

>  		smc_conn_kill(conn, soft);
>  		release_sock(&smc->sk);
>  		sock_put(&smc->sk); /* sock_hold above */

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/179290097759.51540.15412712294727302463%40gmail.com
