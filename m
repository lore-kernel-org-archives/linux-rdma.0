Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF9D4D9553;
	Wed, 14 Oct 2026 09:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791969544; cv=none; b=Wf5n6z2JutVtCqmPHG/Z1+8KMJ3YCQ6VL/N0IkHOfzG3CewbPe2KTKXxLlZzyYlN4uXCssUv+h5fFXJQnmnYQhtImKNJRlO3TL2+vIwgvkyffbytk5KG+JsHR/EIqCCa+p6jkzEj+fG4Wjx7IzAQtdhzRRQclBdeozG6LrH5Zv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791969544; c=relaxed/simple;
	bh=aWoHk6bfCU6GEFGRBjDPmci3vy6gPcBSfm/Wo/0OwA0=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oZ2FwrgWWG3h/ukITPoaLlBTEePcCI0tLlIdOuQ53j/0EgdnrbzwGLnjYMzVlQps0VynFmU1eTIaZUAMJibRXYy1W1SQw4Y9KeETnGHf2oPf8gAJAJKj6pz4rQv/ypGYzyKxR29gdQ/1d2r/AcpHDXoT8A3knObQobvdqDo+Q6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UUCADQJ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UUCADQJ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60B31F00893;
	Wed, 14 Oct 2026 09:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791969541;
	bh=7/GazLolrh9SC1oM993KawgUj9hk+/fSIU/uyEmws8A=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=UUCADQJ1NZrvectXuiCTpvNrS9fOd4cMAA9nMcUgpfwGe5vksOWlTRy26G1MOmNkf
	 Tqfc71bQt9UWgyQfnPOtrtKsS1LqEXn7IVzSyZT+5SEuAQzu9fNgo+X6OVOpONCiIa
	 PnEYVCt/XeynT1qc9eJ3vTJnlAgiOxmN7/Z+o+3vsZU7jpI9jt8HK8vucZGx/FMrEx
	 A1I6xIYTAaAhwz2hENiMS7AdngiXKrHVKdcG1/Ck7IGK6jpzRI++JYfzKccGLPHF/d
	 /+qga1SG9w6SmKfDsDUVkFgIrvrZKe5LnFS/lLGINBaTG1VrArcvsVO+x268rgHoXa
	 RpajTiUO0JPoQ==
Subject: Re: [PATCH net v3 2/3] net/smc: serialize early link group cleanup
 with termination
From: netdev-bot+sashiko@kernel.org
To: nicoyip.dev@gmail.com
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 tonylu@linux.alibaba.com, guwen@linux.alibaba.com, horms@kernel.org,
 linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Wed, 14 Oct 2026 09:19:00 +0000
Message-ID: <179196954042.434549.15240033866309361464@kernel.org>
In-Reply-To: <20261013091716.1210420-3-nicoyip.dev@gmail.com>
References: <20261013091716.1210420-3-nicoyip.dev@gmail.com>
X-sashiko-severity: Medium
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

Critical: 0 · High: 0 · Medium: 1 (1) · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] This patch adds a new source of SMC_CLC_DECL_SYNCERR, and it
  uses that code for a purely local event.

Pre-existing issues:
- [Medium] This problem wasn't introduced by this patch, but
  smc_lgr_cleanup_early() now always hands teardown to the existing…

--

net/smc: serialize early link group cleanup with termination

With this patch, smc_lgr_cleanup_early() returns early if another teardown
path has already set lgr->freeing. It also adds temporary link group
references in smc_conn_abort() and around first-contact registration in
smc_conn_create(), and checks lgr->freeing under the list lock before the
first connection of a new link group is registered.

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 660cd41ec720a..c1bb284c42334 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -693,6 +693,10 @@ void smc_lgr_cleanup_early(struct smc_link_group *lgr)
>  
>  	smc_lgr_list_head(lgr, &lgr_lock);
>  	spin_lock_bh(lgr_lock);
> +	if (lgr->freeing) {
> +		spin_unlock_bh(lgr_lock);
> +		return;
> +	}

[Severity: Medium]
This is a pre-existing issue, not one introduced by this patch. With this
early return, the existing teardown owner is always the one that finishes
teardown. On some paths that means it kills a connection that
smc_conn_free() left registered.

smc_conn_free() only unregisters the connection while the lgr is still on
its list:

net/smc/smc_core.c:smc_conn_free() {
    ...
	if (!list_empty(&lgr->list)) {
		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
		smc_lgr_unregister_conn(conn);
	}
    ...
}

When they claim freeing, smc_lgr_terminate_sched() and the second loop of
smc_smcr_terminate_all() and smc_smcd_terminate_all() call list_del_init()
on lgr->list.

Take a client first-contact connect that has already registered its conn.
A terminator then claims the group. The trigger could be a link down, an
LLC delete link request, or a CLC decline with the first-contact bit
received in smcr_clnt_conf_first_link()->smc_clc_wait_msg():

smc_connect_rdma()
  connect_abort:
  smc_conn_abort(smc, 1)
    smc_conn_free()
      conn->freed = 1, link and lgr references dropped
      lgr->list is empty, smc_lgr_unregister_conn() skipped
    smc_lgr_cleanup_early()
      lgr->freeing is set, returns
__smc_connect()
  falls back to TCP, sk_state = SMC_ACTIVE, socket lock released

terminate worker:
__smc_lgr_terminate()
  conn still found in conns_all
  lock_sock(&smc->sk);
  smc_conn_kill(conn, soft);
    smc_close_active_abort()
      tcp_abort(smc->clcsock->sk, ECONNABORTED);

Could this reset a TCP fallback connection that userspace already sees as
established? The server side looks able to hit the same thing through
smc_listen_decline().

Before this patch, the early cleanup thread either ended up in this same
state, or ran __smc_lgr_terminate() itself and blocked in lock_sock() on
its own socket. The hang is gone, but the stale registration remains.

The commit message says:

  "Once the connection is unregistered, a termination worker can finish
  without taking its socket lock."

Does that still hold on this path, where smc_conn_free() skips the
unregistration?

>  	/* do not use this link group for new connections */
>  	if (!list_empty(&lgr->list))
>  		list_del_init(&lgr->list);

[ ... ]

> @@ -2049,15 +2054,25 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
>  		if (rc)
>  			goto out;
>  		lgr = conn->lgr;
> -		write_lock_bh(&lgr->conns_lock);
> -		rc = smc_lgr_register_conn(conn, true);
> -		write_unlock_bh(&lgr->conns_lock);
> +		spin_lock_bh(lgr_lock);
> +		if (lgr->freeing) {
> +			conn->lgr = NULL;
> +			rc = SMC_CLC_DECL_SYNCERR;

[Severity: Medium]
Is SMC_CLC_DECL_SYNCERR the right code for a purely local teardown race?

smc_clc.h defines it as a synchronization error. The comment earlier in
smc_conn_create() limits it to the case where the server reuses a link
group but the client wants a new one.

It also changes what goes on the wire. smc_clc_send_decline() sets
SMC_FIRST_CONTACT_MASK only for this code:

	dclc.hdr.typev2 = (peer_diag_info == SMC_CLC_DECL_SYNCERR) ?
					SMC_FIRST_CONTACT_MASK : 0;

and the peer reacts to it in smc_clc_wait_msg():

	if ((dclc->hdr.typev2 & SMC_FIRST_CONTACT_MASK) &&
	    smc->conn.lgr) {
		smc->conn.lgr->sync_err = 1;
		smc_lgr_terminate_sched(smc->conn.lgr);
	}

In the client role, a local teardown can set freeing after smc_lgr_create()
has published the group and before this check. That teardown could be
smc_smcr_terminate_all(NULL), smc_smcd_terminate() from an ISM peer
shutdown event, smc_smcd_terminate_all() or smc_lgr_terminate_sched().
The result is:

__smc_connect()
  smc_connect_decline_fallback(..., SMC_CLC_DECL_SYNCERR, ...)
    smc_clc_send_decline()   /* sets SMC_FIRST_CONTACT_MASK */

The server is waiting for the CLC confirm in smc_listen_work(), with
conn.lgr pointing at its new first-contact group. It then sets sync_err on
that group and schedules its termination, which empties lgr->list and sets
freeing.

>From there, smc_listen_decline()->smc_conn_abort(new_smc, 1)->smc_conn_free()
skips smc_lgr_unregister_conn() because lgr->list is empty.
smc_lgr_cleanup_early() then returns early because freeing is set.

The server then falls back to TCP, and smc_listen_out() drops the socket
lock. Wouldn't the terminate worker's __smc_lgr_terminate() then find the
still-registered conn and call smc_conn_kill()? That ends in tcp_abort()
on the server's fallback clcsock.

Would a code without the first-contact side effect, such as
SMC_CLC_DECL_INTERR, avoid resetting the peer's fallback connection here?

In the server-role case the peer's conn.lgr is still NULL, so there it
would only give the peer the wrong diagnosis and statistics.

> +		} else {
> +			write_lock_bh(&lgr->conns_lock);
> +			rc = smc_lgr_register_conn(conn, true);
> +			write_unlock_bh(&lgr->conns_lock);
> +		}
> +		spin_unlock_bh(lgr_lock);
>  		if (rc) {
>  			smc_lgr_cleanup_early(lgr);
> +			smc_lgr_put(lgr); /* lgr_hold in smc_lgr_create() */
>  			goto out;
>  		}
>  	}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261013091716.1210420-1-nicoyip.dev%40gmail.com
