Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793925632;
	b=U0eyCZIfzWD4hxDy2DDn7hVdQiGvIgd7m3P3joDV5xY7Xd74QSCTmZOTjtHlTrQI/V/8
	 D/uP96D/D0cV+kXh6IfT9Kmri9Shh1ybmVpSnCxCRbYu8+1uJCO0wHXZ1Hyk1rSYzuE9U
	 iHetnvozuFtTmcVE9ungVpP/z4fK/ehG/XqZl/wFiN5Wamgx//je1n4/lMRk7NEzhjPSW
	 ypGESV4gzclKkWkfLE8xp81YpbkiLN6IJAR/SOWY9H3Jz9X6uAhoRNgxEq2OkZEZOZ3RB
	 oz088i3dURtXYQCRGSPQL0ZimCgRqUthlvs8g6g77NZ/G/DL9Q2+yeaFjiGeNZLZYKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793925632;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=+VTnnReeTMGUa8p0Zi4PIK2C6S9LMHUZpVAmJU+0osw=;
	b=YUEOswJaU5aGt0vsOBbWRlyLns3pWdY8iE42VE1Nhqu6C4LxxgPfT4di/sXmjHk3d6vL
	 fASp72pQVRvvl/8wIKV5jfnsEt59LDiW3hJSPljrFIkdu91l+EHdhPIwTTulWbBhD6dR9
	 fzfEbrij4zUVR9kWq0YpTIPAl74vdy+eQAO56T4MRyKuPzv0CW+UEGNpbVkkqrtY0VvJq
	 tM2yMzB2Zx4Pa0uMjo9xJsODslEakxdx3JxX0mPuC3oaaUVDSKw0IZ/fT1wXXM0lM3o6/
	 5Qpf978NvIjEH5CxFPlTBlBVMWW0YNzMxDz61QrJle6R9guYwgUoadLmHT87FV6FNHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eEI3jxPh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24803606A31B;
	Fri,  6 Nov 2026 00:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eEI3jxPh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C317D1F008A1;
	Fri,  6 Nov 2026 00:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793925631;
	bh=+VTnnReeTMGUa8p0Zi4PIK2C6S9LMHUZpVAmJU+0osw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=eEI3jxPhCniy53wZTmteEvNL1J+te4fsqAE+R2hcvZ3xHg4ZC6mcqo7voWJ7qfPU3
	 E5Z3wkbGquhb/wuPOGyj+V5K4RVyeG3KG+QPSEDod00Qm8UIw6wLfcGygxNSkzt1Zh
	 mtPFnl3wFEUwI00cD7v1xDJNOKuZkQzqpMX1dRw2AXntQTNDnbSuDINJYnb1kv137U
	 i2+ezkB6GHcbgmn8I0zYzO1YH/MpfLu363sYzFWM8NNEOIEl+OBED46lSYQODGBgD0
	 TSm7ts9wx6YGKosHkklzc4K8g3nmHWCeWQQVzv7SeLY+KCvzX6RxzASgPnyYp2uxIQ
	 H/spUgZP6d4Vg==
Subject:
 Re: [PATCH net] net/smc: fix handshake abort on a terminating link group
From: netdev-bot+sashiko@kernel.org
To: mjambigi@linux.ibm.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, hidayath@linux.ibm.com,
 pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, stable@vger.kernel.org, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Date: Fri, 06 Nov 2026 00:40:30 +0000
Message-ID: <179392563025.994134.873801434242167831@kernel.org>
In-Reply-To: <20261103123955.47454-1-mjambigi@linux.ibm.com>
References: <20261103123955.47454-1-mjambigi@linux.ibm.com>
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

Critical: 0 · High: 2 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The patch leaves the stale lgr->conns_all entry in place.
- [High] The new ownership check in smc_lgr_cleanup_early()
  (net/smc/smc_core.c:691) only tests list_empty(&lgr->list).

--

net/smc: fix handshake abort on a terminating link group

This patch makes smc_lgr_cleanup_early() return early when the link group
has already been removed from the lgr list. It also makes smc_conn_kill()
only unregister a connection that is already freed, without the full
connection and socket teardown. The goal is to avoid a self-deadlock and a
wrong abort of a fallback clcsock when a handshake abort races with link
group termination.

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 6021322253e93..4e10da5bd8142 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -688,9 +688,15 @@ void smc_lgr_cleanup_early(struct smc_link_group *lgr)
>
>  	smc_lgr_list_head(lgr, &lgr_lock);
>  	spin_lock_bh(lgr_lock);
> +	if (list_empty(&lgr->list)) {
> +		/* another context already removed the link group from the
> +		 * list and will terminate it
> +		 */
> +		spin_unlock_bh(lgr_lock);
> +		return;
> +	}
>  	/* do not use this link group for new connections */
> -	if (!list_empty(&lgr->list))
> -		list_del_init(&lgr->list);
> +	list_del_init(&lgr->list);
>  	spin_unlock_bh(lgr_lock);
>  	__smc_lgr_terminate(lgr, true);
>  }

[Severity: High]

Is list_empty() enough to tell that another context already owns this link
group?

smc_smcd_terminate(), smc_smcd_terminate_all() and
smc_smcr_terminate_all(NULL) move the lgr onto a private list on the stack
while holding lgr_lock, and set lgr->freeing = 1. They then walk that list
with no lock held:

net/smc/smc_core.c:smc_smcd_terminate_all() {
    ...
	spin_lock_bh(&smcd->lgr_lock);
	list_splice_init(&smcd->lgr_list, &lgr_free_list);
	list_for_each_entry(lgr, &lgr_free_list, list)
		lgr->freeing = 1;
	spin_unlock_bh(&smcd->lgr_lock);

	list_for_each_entry_safe(lgr, lg, &lgr_free_list, list) {
		list_del_init(&lgr->list);
		__smc_lgr_terminate(lgr, false);
	}
    ...
}

While the lgr is on that private list, lgr->list is not empty. A
first-contact handshake abort that reaches smc_lgr_cleanup_early() in that
window still passes the new check.

In that case, list_del_init(&lgr->list) unlinks the lgr from the other
context's private list while that list is being walked without a lock. If
this lgr is the cached next entry, it is now linked to itself, and the
walk can loop on it.

__smc_lgr_terminate() would also run at the same time as the other
context's termination. The only thing serialising them is this unlocked
check:

	if (lgr->terminating)
		return;	/* lgr already terminating */
	...
	lgr->terminating = 1;

If smc_lgr_cleanup_early() ends up freeing the lgr,
smc_smcd_terminate_all() or smc_smcr_terminate_all() can later reach the
freed lgr as their cached next element. smc_smcd_terminate() can instead
call schedule_work() on the terminate_work inside the freed lgr.

The peer can trigger smc_smcd_terminate() by sending
ISM_EVENT_CODE_SHUTDOWN, which is one way to reach this window.

The commit message says "Do not terminate a link group that another
context has already removed from the link group list". These contexts
have already removed the lgr from dev->lgr_list or smc_lgr_list.

smc_lgr_terminate_sched() already uses:

	if (list_empty(&lgr->list) || lgr->terminating || lgr->freeing) {

lgr->freeing is written under the same lgr_lock that is held here. Could
this check also test lgr->freeing and lgr->terminating?

> @@ -1519,6 +1525,17 @@ static void smc_conn_kill(struct smc_connection *conn, bool soft)
>  {
>  	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
>
> +	if (conn->freed) {
> +		/* connection was already freed, e.g. by an aborted
> +		 * handshake, but kept its entry because smc_conn_free() skips
> +		 * the unregister for a link group that is no longer on the lgr
> +		 * list. Remove the stale entry, but do not kill a socket that
> +		 * may be an established fallback connection.
> +		 */
> +		smc_lgr_unregister_conn(conn);
> +		return;
> +	}
> +

[Severity: High]

Can the stale conns_all entry still be reached through the server
handshake retry path?

When smc_conn_free() sees list_empty(&lgr->list), it skips the
unregister:

net/smc/smc_core.c:smc_conn_free() {
    ...
	if (!list_empty(&lgr->list)) {
		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
		smc_lgr_unregister_conn(conn);
	}
    ...
}

After that, conn->alert_token_local is still non-zero, and conn->alert_node
is still linked in link group A's conns_all, with conn->freed = 1. Because
smc_lgr_cleanup_early() now returns early, the handshake thread carries
on instead of deadlocking.

The server device selection code can then call smc_conn_create() again on
the same new_smc->conn. One example is when smc_buf_create() fails inside
smc_listen_ism_init() with -ENOSPC on DMB exhaustion, or with -ENOMEM:

net/smc/af_smc.c:smc_find_ism_v2_device_serv() {
    ...
		rc = smc_listen_ism_init(new_smc, ini);
		if (rc) {
			smc_init_info_store_rc(rc, ini);
			/* try next active ISM device */
			continue;
		}
    ...
}

The same applies to the fall-through to ISM v1, SMC-R v2 and SMC-R v1,
and to the failure paths in smc_listen_rdma_init() and
smc_listen_rdma_reg().

On the second registration, smc_lgr_register_conn() runs:

	sock_hold(&smc->sk); /* sock_put in smc_lgr_unregister_conn() */
	while (!conn->alert_token_local) {
		...
	}
	smc_lgr_add_alert_token(conn);

The stale token means the token loop is skipped. smc_lgr_add_alert_token()
then inserts an alert_node that is still linked in A's tree into link
group B's tree. A second sock_hold() is taken, but only one sock_put()
will follow. smc_conn_create() then sets conn->freed = 0, so the new
conn->freed check in smc_conn_kill() no longer matches.

A's terminator cannot get in first, because it blocks in lock_sock() and
smc_listen_work() holds that lock for the whole handshake. Once it gets
the lock, smc_conn_kill() runs the full abort on the live connection,
which now belongs to B.

smc_lgr_unregister_conn() then erases the node from conn->lgr (B), not
from A. alert_token_local is now 0, so every later call returns early.
__smc_lgr_terminate(A) keeps getting the same node back from
rb_first(&lgr->conns_all) and never finishes.

If smcr_lgr_conn_assign_link() fails on the retry instead,
smc_lgr_register_conn() sets conn->lgr = NULL and conn->freed stays 1.
The new branch is taken, but smc_lgr_unregister_conn() returns early
because smc_conn_lgr_valid() fails, and the same endless loop follows.

Would it be more robust to do the unregister in
smc_conn_free()/smc_conn_abort() regardless of lgr->list? At minimum that
would be the rb_erase() plus clearing alert_token_local. It would replace
the conn->freed check added to smc_conn_kill().

>  	if (conn->lgr->is_smcd && conn->lgr->peer_shutdown)
>  		conn->local_tx_ctrl.conn_state_flags.peer_conn_abort = 1;
>  	else

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261103123955.47454-1-mjambigi%40linux.ibm.com
