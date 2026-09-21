Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1EC449B1A;
	Mon, 21 Sep 2026 09:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789982138; cv=none; b=kNbW+aGwm6EONz4hg4PXkHKwhTozPMrM4qHA8KBAHZlI71pLl7y2HKX0GjVCJlY6XyryEh9LbPQupg/Jpr7UBiBrb/rYsBYzaWI5qJT/opYor5gTci8Wkx8RJGEyQTX7m6fYc3kEbcSzaYWUowymAozqorUVErTosIWg3qfDOIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789982138; c=relaxed/simple;
	bh=qN7gG5b1C+U7px7izUcJy0CNchUKQboQ4/Qv0yXZS4k=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=C5BZ/sgRMGUEr2nRC3R65O/QqF8mIVIwU9St6ReQaiFBkWin0YMevqMxRbmIoUOCm/du0QCo5g9vXU801aPDgKmrK3YQSKJDcf/EbgRViKmV7oeQl76Bf+G5njfM8kneG0Csw3GYEe/HLqkxworZEF7MQWABwoqs/OBuj/fYINg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WsH2kvTw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WsH2kvTw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015F81F00899;
	Mon, 21 Sep 2026 09:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789982136;
	bh=i/PBbqEm1JaAl01goNd4kc52tXY3AKKduRUtFfdPH6A=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=WsH2kvTw9V0bl9+6XrefP9d7mdQSi68+AK7qRiux3SZox4o9UL94k44JG2IKCAXPP
	 m6LX5Nb13Ab+e1kZ7iPWm4F3DFHhIeBHaKI7MuTPqF8Rkdbkr49PHMi7mwfu4X1/PT
	 cp0CnwCoeHOIVAJJ8Cgw3xUTxfaqyTJQLa9kMSnkNwH8+CBOMwV66ir8c/cS3DW7oK
	 9/SCH6rjZfR/0wSS7IWhh1YYyZKzulqOQEWO/Y1sMRw89eUie6dOxmUitqohcjoDnk
	 evs3zpXXZgZK8ndF9EIjwTYYBGk2p1rKkqjUILCpOwBGDJfYWHHcaRvexDAIqvvc0E
	 JufbAwgwaRUBA==
Subject: Re: [PATCH net-next v4 06/12] net/rds: wait for connections to be
 freed on transport unload
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Mon, 21 Sep 2026 09:15:35 +0000
Message-ID: <178998213555.2160803.8966490607902071321@kernel.org>
In-Reply-To: <20260917073958.174056-7-achender@kernel.org>
References: <20260917073958.174056-7-achender@kernel.org>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 5 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 2 (1) · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] rds_ib_exit()'s new wait can never complete for a connection
  whose rds_conn_destroy() is issued from the RDMA-CM event handler, so…
- [Medium] rds_conn_wait_conns_freed() (net/rds/connection.c) is an
  unbounded TASK_UNINTERRUPTIBLE poll loop executed from module exit…
- [Medium] At this commit, list_splice_init() empties ib_nodev_conns
  while the swept connections' ib_node entries sit on the rmmod thread's…
- [Low] Undocumented, load-bearing semantic change in net/rds/ib_rdma.c:
  rds_ib_destroy_nodev_conns() is switched from list_splice() to…
- [Low] The kernel-doc-style comment on rds_conn_wait_conns_freed()
  states a precondition its own IB caller deliberately violates: 'Called…

Pre-existing issues:
- [Medium] Queued incoming datagrams hold no connection reference at this
  commit, so t_conn_count can reach zero and permit transport unload…

--

net/rds: wait for connections to be freed on transport unload

This adds a per-transport live-connection counter (t_conn_count),
incremented when a connection is published in __rds_conn_create() and
decremented at the end of rds_conn_destroy_fini().  The transport exit
paths (rds_ib_exit(), rds_tcp_exit(), rds_loop_exit()) then poll that
count until it reaches zero before letting the module unload proceed.

A few questions below.

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index a44aa4d2a5e8b..1d48da1a794fa 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c

[ ... ]

> @@ -596,7 +601,52 @@ static void rds_conn_destroy_fini(struct kref *kref)
>  	spin_lock_irqsave(&rds_conn_lock, flags);
>  	rds_conn_count--;
>  	spin_unlock_irqrestore(&rds_conn_lock, flags);
> +
> +	/* only after everything the transport module owns has been
> +	 * freed above may its unload proceed
> +	 */
> +	if (!atomic_dec_return(&trans->t_conn_count))
> +		wake_up_all(&rds_conn_freed_waitq);

[Severity: Medium]

This isn't a bug introduced by this patch, but at this commit a queued
incoming datagram holds no connection reference: rds_inc_init() and
rds_inc_path_init() in net/rds/recv.c store inc->i_conn without calling
rds_conn_get().

So t_conn_count can reach zero and let the transport unload while an
unread inc still carries inc->i_conn and dispatches through that
transport's callbacks:

net/rds/recv.c:rds_inc_put() {
	...
	inc->i_conn->c_trans->inc_free(inc);
}

The commit message is explicit that this only closes "once the following
patches make incs hold a connection reference", and the later patch
"net/rds: hold a connection reference from struct rds_incoming" does add
rds_conn_get() in rds_inc_init()/rds_inc_path_init().  Noting it here only
so the intermediate state in the series is on record - would it be worth
saying in the changelog that the guarantee is incomplete until that patch
lands?

> +}
> +
> +/* Wait for all of @trans's connections to be freed; the free runs
> + * asynchronously once rds_conn_destroy() has quiesced a connection.
> + * Called on transport module unload, after the transport has destroyed
> + * all of its connections.  A connection reference can be held for an
> + * application-controlled time - once incs hold one, an unread datagram
> + * pins the inc that carries it, and thus the connection - so the wait
> + * is unbounded: the
> + * frees that run after unload call into this module's text (conn_free,
> + * inc_free) and free into its slabs, so proceeding while any remain
> + * would be a use-after-free, not a leak.  Warn periodically so a stuck
> + * count is diagnosable, but never stop waiting.  This matches the
> + * historical RDS contract that teardown does not discard queued data.
> + */

[Severity: Low]

Is the stated precondition the one the code actually has?  The comment
says the function is "Called on transport module unload, after the
transport has destroyed all of its connections", but rds_ib_exit() calls
it while connections are still attached to devices and migrating to
ib_nodev_conns asynchronously - which is why it passes
rds_ib_destroy_nodev_conns as the resweep callback and why the loop body
calls resweep() after every timeout.

Could the comment describe the real contract instead, i.e. that the caller
does an initial sweep and the resweep destroys late arrivals during the
wait?

Also, the sentence "so the wait is unbounded: the" / "frees that run after
unload call into this module's text" looks like a mangled line break.

> +void rds_conn_wait_conns_freed(struct rds_transport *trans,
> +			       void (*resweep)(void))
> +{
> +	unsigned long warn_interval =
> +			msecs_to_jiffies(RDS_CONN_FREE_WARN_INTERVAL_MS);
> +	unsigned long warn_at = jiffies + warn_interval;
> +
> +	while (!wait_event_timeout(rds_conn_freed_waitq,
> +				   !atomic_read(&trans->t_conn_count),
> +				   msecs_to_jiffies(RDS_CONN_FREE_POLL_MS))) {

[Severity: Medium]

Can an unprivileged application wedge rmmod permanently here?  The loop
has no timeout, no signal check and no bail-out, and wait_event_timeout()
sleeps in TASK_UNINTERRUPTIBLE.

By the end of the series an inc holds a connection reference, so a process
that binds an AF_RDS socket, receives one datagram and never calls
recvmsg() keeps t_conn_count non-zero for as long as it likes.

The transport module reference a bound socket holds does not cover this
case: rds_bind() can take rs->rs_transport preset via SO_RDS_TRANSPORT,
and rds_find_bound() does not filter on transport, so the socket pinning
an IB connection's inc need hold no rds_rdma reference at all - which the
commit message itself notes.

delete_module() has already moved the module to MODULE_STATE_GOING before
calling mod->exit(), so at that point the module can neither finish
unloading nor be re-inserted, and the rmmod task is unkillable.  The same
applies to rds_tcp_exit(), where the wait runs after
unregister_pernet_device() and rds_tcp_destroy_conns(), and to
rds_loop_exit() in the core module.

Was having long-term reference holders take a module reference considered
instead, so delete_module() fails with -EBUSY rather than blocking inside
->exit()?

> +		/* A transport whose teardown is asynchronous (IB moves a
> +		 * connection off its device from the shutdown work) gives
> +		 * us a resweep to destroy what has arrived since.
> +		 */
> +		if (resweep)
> +			resweep();
> +		if (time_after_eq(jiffies, warn_at)) {
> +			pr_warn("RDS/%s: still waiting for %d connection(s) to be freed before unload\n",
> +				trans->t_name,
> +				atomic_read(&trans->t_conn_count));
> +			warn_at = jiffies + warn_interval;
> +		}
> +	}
>  }
> +EXPORT_SYMBOL_GPL(rds_conn_wait_conns_freed);
>  
>  void rds_conn_get(struct rds_connection *conn)
>  {
> diff --git a/net/rds/ib.c b/net/rds/ib.c
> index 9fe3b9951bd32..3fc2de9d19d55 100644
> --- a/net/rds/ib.c
> +++ b/net/rds/ib.c
> @@ -537,7 +537,24 @@ void rds_ib_exit(void)
>  	rds_info_deregister_func(RDS6_INFO_IB_CONNECTIONS, rds6_ib_ic_info);
>  #endif
>  	rds_ib_unregister_client();
> +
> +	/* rds_ib_dev_shutdown() only dropped the connections still
> +	 * attached to a device; each moves itself to ib_nodev_conns
> +	 * from its shutdown work.  Destroy what is there now and keep
> +	 * sweeping the list while the wait sees connections outstanding,
> +	 * so a late arrival is destroyed rather than waited on forever.
> +	 */
>  	rds_ib_destroy_nodev_conns();
> +	rds_conn_wait_conns_freed(&rds_ib_transport,
> +				  rds_ib_destroy_nodev_conns);

[Severity: High]

Can this wait ever finish for a connection whose destroy was issued from
the RDMA-CM event handler?

net/rds/ib_cm.c:rds_ib_cm_connect_complete() destroys the connection on a
protocol version mismatch:

	rds_conn_destroy(conn);
	return;

and it runs with conn->c_cm_lock (c_path[0].cp_cm_lock) held by
rds_rdma_cm_event_handler_cmn() in net/rds/rdma_transport.c:

	if (conn) {
		mutex_lock(&conn->c_cm_lock);
	...
	case RDMA_CM_EVENT_ESTABLISHED:
		if (conn)
			trans->cm_connect_complete(conn, event);

The destroy path is then:

rds_conn_destroy() -> rds_conn_path_quiesce()
    rds_conn_path_drop(cp, true)   /* always queues cp_down_w */
    flush_work(&cp->cp_down_w)
        rds_shutdown_worker() -> rds_conn_shutdown()
            mutex_lock(&cp->cp_cm_lock);   /* held by this thread */

rds_conn_destroy_fini() is never reached, so
atomic_dec_return(&trans->t_conn_count) never runs and this wait loops
forever, printing the 10 s warning indefinitely, with no indication of
which connection is stuck.  The protocol version that triggers it is
chosen by the remote peer.

This state persists to the end of the series: net/rds/ib_cm.c still calls
rds_conn_destroy(conn) at that site, even though the later commit
"net/rds: pin the connection across RDMA-CM event handling" says it was
switched to rds_conn_drop().  Should that conversion come with this patch,
since this is the change that turns a stuck destroy into an unbounded
uninterruptible wait?

Separately, the changelog states the wake at the end of
rds_conn_destroy_fini() "can run from a thread executing transport module
text, but never as that thread's last use of it".  Only a few core-module
calls separate the wait's return from the module text being freed - is
there anything in the code that enforces that ordering, or is it an
argument about the current call sites only?

> +
> +	/* Tearing down the last connection may have dropped the final
> +	 * reference on a device, deferring rds_ib_dev_free() to rds_wq.
> +	 * Drain it before the module goes away; it queues nothing
> +	 * further on rds_wq.
> +	 */
> +	flush_workqueue(rds_wq);
> +
>  	rds_ib_sysctl_exit();
>  	rds_ib_recv_exit();
>  	rds_trans_unregister(&rds_ib_transport);
> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
> index db7e92e7bd29f..a9b27f06cbfcf 100644
> --- a/net/rds/ib_rdma.c
> +++ b/net/rds/ib_rdma.c
> @@ -165,7 +165,7 @@ void rds_ib_destroy_nodev_conns(void)
>  
>  	/* avoid calling conn_destroy with irqs off */
>  	spin_lock_irq(&ib_nodev_conns_lock);
> -	list_splice(&ib_nodev_conns, &tmp_list);
> +	list_splice_init(&ib_nodev_conns, &tmp_list);
>  	spin_unlock_irq(&ib_nodev_conns_lock);

[Severity: Low]

Could this one-line change get a mention in the changelog?  It looks
load-bearing for the new resweep: rds_ib_exit() now passes
rds_ib_destroy_nodev_conns as the resweep callback, so it runs every
100 ms, and plain list_splice() leaves ib_nodev_conns still pointing at
entries that were moved onto the caller's stack list, since __list_splice()
does not re-init the source head.  The commit message describes the resweep
at length but not this fix, which also reads like a separate preparatory
change.

[Severity: Medium]

At this commit, does emptying ib_nodev_conns while the swept entries live
on the rmmod thread's stack list conflict with rds_ib_add_conn()?  That
function still has:

net/rds/ib_rdma.c:rds_ib_add_conn() {
	spin_lock_irq(&ib_nodev_conns_lock);
	BUG_ON(list_empty(&ib_nodev_conns));
	BUG_ON(list_empty(&ic->ib_node));
	list_del(&ic->ib_node);
	...
}

A connect worker already in flight when rds_ib_exit() runs would either hit
the assertion or unlink an entry from the sweeper's stack-local list.

The next patch in the series, "net/rds: unlink transport nodes before a
possibly deferred connection free", removes both BUG_ONs and rewrites the
sweep to take a reference per entry and list_del_init() each node under the
lock just before its destroy, so the window is confined to this commit -
would it be simpler to fold the two together?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260917073958.174056-1-achender%40kernel.org
