Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924ED29B228;
	Mon, 21 Sep 2026 09:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789982136; cv=none; b=MkJWUTAjmeNZrfTGMRNlzNZ0A1hjwRgcBgAbV/kmL/jAKCHYfXvNymCV/XakaZh4aNGLpOV/rgkqvDIFpCzDJ+QoEtkH5f2cEvare/NLnkemSl0RimfX1mWmbxVfAz2ERnpgFWOyXLKFJvcVfiC+kQ/PUsPravv+5ocL2YGymOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789982136; c=relaxed/simple;
	bh=ffe3EmiWoqs0wgj72JGzeRbA91yvVS0eAGY0++OaqVY=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BAR9l7IdEqu9n0vG1Fjs1NmRDoUIBrnU4tLiz0+S3N0P1GpmsAHBtoU10o1AVihfGJHFHhBEugHs6nTPZfxAo1q3QDsXQyd6yd70yYxKt45AFIfLG0RmSviTWqGE0rEFNrR4aq5CiQW+e7U8CUKaic3Tt+mD8mBMgBBxWShhO2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oRNxLc4u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oRNxLc4u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71361F000FF;
	Mon, 21 Sep 2026 09:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789982134;
	bh=HYC1/+ShuQtT43BdR4gPqhb6cb0IUyWurIDPv4ajWEE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=oRNxLc4udi645IUPybeb799jQIuWX4fEnovafvWse5TUCdfwbir3x4yqJ7p19T8eq
	 NACnJpj0gfyUNc5WaVouwC6MmGv57GMnVp5HEuaJOeHJCh+XnzPjAb4RAXjsazdlRo
	 DNQHSl82ZGQQfZrR5322KSv8kEUHMrVTol5xaRlvI5hfXH0yip8BA44Hpw5AGJuq1p
	 j/fOQ7SphUJwA4Z+lOWIZ203CozXGp8qXUzWnAgGOiAMmkSo7gxykJxTlulNFJDKqa
	 t7I30I/+6wMK17ULRn35QXrHlcOQ1jUiyvR3nW3lBoKMj0gtjiZi44MNFRqFgX6me5
	 SZ9z2oE2uNuoQ==
Subject: Re: [PATCH net-next v4 04/12] net/rds: make rds_destroy_pending()
 cover single-connection destroy
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Mon, 21 Sep 2026 09:15:33 +0000
Message-ID: <178998213334.2160803.15450306445342965822@kernel.org>
In-Reply-To: <20260917073958.174056-5-achender@kernel.org>
References: <20260917073958.174056-5-achender@kernel.org>
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
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 1 (1)

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] Unconditional self-deadlock in the very per-connection destroy
  path this patch is written for.
- [Low] The two comments added by this patch state an invariant the tree
  does not maintain.

Pre-existing issues:
- [Low] Stale contract comment above rds_conn_destroy()
  (net/rds/connection.c:564-570) still claims 'We can only ensure this…

--

net/rds: make rds_destroy_pending() cover single-connection destroy

This adds a per-connection conn->c_destroy_in_prog flag, set by
rds_conn_destroy() before the unhash plus synchronize_rcu() sequence, and
tests it from rds_destroy_pending() so that the work-requeueing sites stop
arming path works on a connection that is being torn down.  The now unused
RDS_DESTROY_PENDING cp_flags bit and its dead test in
rds_ib_is_unloading() are removed.

A few questions on the new comments and on the per-connection destroy path
this is aimed at.

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index a96569a3ee9ad..242ca0570a47e 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c
> @@ -579,6 +579,14 @@ void rds_conn_destroy(struct rds_connection *conn)

[Severity: Low]

This isn't a bug introduced by this patch, but the contract comment
immediately above rds_conn_destroy() still reads:

  /*
   * Stop and free a connection.
   *
   * This can only be used in very limited circumstances.  It assumes that once
   * the conn has been shutdown that no one else is referencing the connection.
   * We can only ensure this in the rmmod path in the current code.
   */

The flag added below, and its comment in net/rds/rds.h, describe protection
for the non-rmmod case, and in-tree callers such as
rds_ib_cm_connect_complete() (net/rds/ib_cm.c) destroy a single connection
outside rmmod.  Later in this series "net/rds: split connection destroy into
quiesce and kref-governed free" replaces that comment, so is it worth
refreshing it here so the two do not disagree in between?

>  		 "%pI4\n", conn, &conn->c_laddr,
>  		 &conn->c_faddr);
>  
> +	/* Make rds_destroy_pending() true for this conn.  Together with
> +	 * the synchronize_rcu() below this stops the work-requeueing
> +	 * sites (which all test rds_destroy_pending() under
> +	 * rcu_read_lock()) from queueing new work on the path
> +	 * workqueues once we start cancelling and destroying them.
> +	 */

[Severity: Low]

Is the parenthetical "which all test rds_destroy_pending() under
rcu_read_lock()" accurate for the tree as it stands?  The same claim is made
unconditionally in the new struct rds_connection comment:

  /* ... A site that arms
   * a path work must test the predicate and queue the work inside
   * one rcu_read_lock() section: ...
   */

Three arming sites do neither.  rds_send_worker() and rds_recv_worker() in
net/rds/threads.c re-arm their own works with no predicate and no RCU
section:

	switch (ret) {
	case -EAGAIN:
		rds_stats_inc(s_send_immediate_retry);
		queue_delayed_work(cp->cp_wq, &cp->cp_send_w, 0);
		break;
	case -ENOMEM:
		rds_stats_inc(s_send_delayed_retry);
		queue_delayed_work(cp->cp_wq, &cp->cp_send_w, 2);
		break;

And rds_conn_path_drop() bypasses the predicate on purpose for destroy:

net/rds/connection.c:rds_conn_path_drop() {
	rcu_read_lock();
	if (!destroy && rds_destroy_pending(cp->cp_conn)) {
		rcu_read_unlock();
		return;
	}
	queue_work(cp->cp_wq, &cp->cp_down_w);
	rcu_read_unlock();
}

that being the call rds_conn_path_destroy() makes with destroy == true,
after c_destroy_in_prog has already been set.  The commit message does note
the worker self-requeues and the sync cancel that covers them, but the
in-tree comments do not mention either exception.  Could the comments spell
out that the workers and the destroy == true drop are covered by the sync
cancel and by the destroy path driving its own final shutdown pass instead?

> +	WRITE_ONCE(conn->c_destroy_in_prog, true);

[Severity: High]

Can the single-connection destroy this flag is written for actually
complete?  The RDMA CM handler holds conn->c_cm_lock (which is
conn->c_path[0].cp_cm_lock, see net/rds/rds_single_path.h) across the
ESTABLISHED dispatch:

net/rds/rdma_transport.c:rds_rdma_cm_event_handler_cmn() {
	if (conn) {
		mutex_lock(&conn->c_cm_lock);
	...
	case RDMA_CM_EVENT_ESTABLISHED:
		if (conn)
			trans->cm_connect_complete(conn, event);
		break;
	...
}

and the version-mismatch destroy runs from inside that dispatch:

net/rds/ib_cm.c:rds_ib_cm_connect_complete() {
	if (conn->c_version < RDS_PROTOCOL_VERSION) {
		if (conn->c_version != RDS_PROTOCOL_COMPAT_VERSION) {
			pr_notice(...);
			rds_conn_destroy(conn);
			return;
	...
}

rds_conn_destroy() then reaches rds_conn_path_destroy(), which queues
cp_down_w with the guard bypassed and waits for it while still holding
cp_cm_lock:

net/rds/connection.c:rds_conn_path_destroy() {
	rds_conn_path_drop(cp, true);	/* cp_state = RDS_CONN_ERROR, queue */
	flush_work(&cp->cp_down_w);
	...
}

The shutdown worker fails the DOWN to DOWN transition because the state is
RDS_CONN_ERROR, and then takes the mutex the flusher owns:

net/rds/connection.c:rds_conn_shutdown() {
	if (!rds_conn_path_transition(cp, RDS_CONN_DOWN, RDS_CONN_DOWN)) {
		...
		mutex_lock(&cp->cp_cm_lock);
	...
}

IB is not t_mp_capable, so npaths is 1 and the path being destroyed is
exactly the one whose cp_cm_lock is held.  ERROR to DISCONNECTING is only
performed under cp_cm_lock, so no other pass can unblock the transition
either.  Does this leave the CM event thread parked in flush_work() holding
cp_cm_lock and the path worker parked in mutex_lock() behind it, with the
peer-supplied CM private data (major 3, minor 0) as the trigger?

If so, the motivating scenario in the commit message, "queue_delayed_work()
on a cp_wq that destroy_workqueue() has already freed", would not be
reachable from this caller, because the destroy hangs before
destroy_workqueue() runs.

There is a related use-after-free on the same path at the handler tail:

net/rds/rdma_transport.c:rds_rdma_cm_event_handler_cmn() {
out:
	if (conn)
		mutex_unlock(&conn->c_cm_lock);
	...
}

which runs on memory already returned by kfree(conn->c_path) and
kmem_cache_free(rds_conn_slab, conn) in rds_conn_destroy().  That part is
addressed later in this series by "net/rds: pin the connection across
RDMA-CM event handling", but the lock re-entry above appears to survive to
the end of the series, where rds_conn_path_quiesce() still does
rds_conn_path_drop(cp, true) plus flush_work(&cp->cp_down_w) and
net/rds/ib_cm.c still calls rds_conn_destroy() from the CM callback.  Would
deferring that destroy out of the CM callback be the better fix for this
site?

>  	/* Ensure conn will not be scheduled for reconnect */
>  	spin_lock_irq(&rds_conn_lock);
>  	hlist_del_init_rcu(&conn->c_hash_node);

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260917073958.174056-1-achender%40kernel.org
