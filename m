Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6584F4B4022;
	Thu, 17 Sep 2026 09:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789637928; cv=none; b=FtQjvBcjDedm2mOYG1j/xaSk45DtD+KmWKQkZM9eouuSXzEOoTsNr7XJCOzia/huDkLr+A7Hhs0EDfgP75BH05WlN8pcNysWZLYpxYMHP2rAQMMXMRDRToyu2XyAJoZQnEyi/vwFNF0yQg7vCe5pFpALusC9dX2Lz0YexPBI6aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789637928; c=relaxed/simple;
	bh=03fcm39QP8FsPXkd9yoYj1PqTEBcosscg3dhMT1zh9c=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=V0SHVmHRafvc/I0da+XGf6DZDUS65A8VFSbBR2wXCpqr+G2qTZ4pMpgP8/E5u5qDMclwHafmslw5vRvqvdCg71oeFdnoQL8mxhhDdUyI9oF09IEwn+JfWnhF6wCOCa3i8AacjyWgTyQy1eadbjl8MHKNlYY5oFnMhx5KRMRuAEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j/x//PJ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j/x//PJ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6526A1F00899;
	Thu, 17 Sep 2026 09:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789637921;
	bh=6Xqc/jLT6Nk5J+wArf7gchZ4fMvlWZkM07w0ZPqa5n8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=j/x//PJ9IwaQnN3vBtdvT/zmJXjMYhBD9B34Vwqrd3QRXn9fa9gNkeNNnbx6XqMJb
	 U7mXaP/eSaA28DxYJVa8i/Gx4m6o5bqhoLkK6FS81TpYDbnYO3qE38Eg/ftnD866vK
	 Tq5IxVWhJirvb9HyNM4dZtvnJBH0bK7npt9UDb34DIKWJb3wu9XKwOsGkk8pWrWPfI
	 SihApEFRVAu2aoI59TOQ/ot1gD3fRGkWRfVxQaOLal7k/uatubDjmy5I46rJ0iceln
	 ggGtAh3rFSvbdpsygHASb0dUCajdh6y8A8rlGji0H6OzoV+tx17hSEQhv8LwViej3p
	 1I9gheys8EQYQ==
Subject: Re: [PATCH net-next v3 04/13] net/rds: make rds_destroy_pending()
 cover single-connection destroy
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Thu, 17 Sep 2026 09:38:40 +0000
Message-ID: <178963792099.22033.12908187315848342047@kernel.org>
In-Reply-To: <20260914033719.138057-5-achender@kernel.org>
References: <20260914033719.138057-5-achender@kernel.org>
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
issue(s) to consider:

Critical: 0 · High: 0 (1) · Medium: 1 · Low: 1 (1)

- [Medium] The new c_destroy_in_prog + synchronize_rcu() guard only
  covers requeue sites that acquire the struct rds_connection pointer…
- [Low] The two comments this patch adds overstate the invariant they
  document.

Pre-existing issues:
- [High] AB-BA deadlock on the single-connection destroy path that this
  patch is written to protect.
- [Low] The header comment above rds_conn_destroy()
  (net/rds/connection.c, immediately above the function this patch…

--

net/rds: make rds_destroy_pending() cover single-connection destroy

This adds a per-connection c_destroy_in_prog flag, set by
rds_conn_destroy() before the unhash and synchronize_rcu(), and tests it
from rds_destroy_pending() so that the predicate also covers the destroy
of a single connection.  The now-unreferenced RDS_DESTROY_PENDING cp_flags
bit and its dead test in rds_ib_is_unloading() are removed.

No Link: tags in the commit header.

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index a96569a3ee9ad..242ca0570a47e 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c
> @@ -579,6 +579,14 @@ void rds_conn_destroy(struct rds_connection *conn)
>  		 "%pI4\n", conn, &conn->c_laddr,
>  		 &conn->c_faddr);
>  
> +	/* Make rds_destroy_pending() true for this conn.  Together with
> +	 * the synchronize_rcu() below this stops the work-requeueing
> +	 * sites (which all test rds_destroy_pending() under
> +	 * rcu_read_lock()) from queueing new work on the path
> +	 * workqueues once we start cancelling and destroying them.
> +	 */
> +	WRITE_ONCE(conn->c_destroy_in_prog, true);
> +

[Severity: Low]
Is the parenthetical "which all test rds_destroy_pending() under
rcu_read_lock()" accurate?  The same claim appears in the new
c_destroy_in_prog comment in net/rds/rds.h ("A site that arms a path work
must test the predicate and queue the work inside one rcu_read_lock()
section") and in the commit message ("all of those sites guard the queueing
with rds_destroy_pending() under rcu_read_lock() (the last stragglers were
converted by the previous patch)").

There appear to be four arming sites in net/rds/threads.c that do neither.
rds_send_worker() re-arms cp_send_w with no predicate and no RCU section:

	case -EAGAIN:
		rds_stats_inc(s_send_immediate_retry);
		queue_delayed_work(cp->cp_wq, &cp->cp_send_w, 0);
		break;
	case -ENOMEM:
		rds_stats_inc(s_send_delayed_retry);
		queue_delayed_work(cp->cp_wq, &cp->cp_send_w, 2);

and rds_recv_worker() does the same for cp_recv_w.

rds_conn_path_drop() is a fifth site, and it deliberately bypasses the
predicate:

	rcu_read_lock();
	if (!destroy && rds_destroy_pending(cp->cp_conn)) {
		rcu_read_unlock();
		return;
	}
	queue_work(cp->cp_wq, &cp->cp_down_w);

For the threads.c self-requeues the thing that keeps them off a destroyed
workqueue looks like the cancel/disable semantics of
cancel_delayed_work_sync() rejecting a requeue issued from inside the work
being cancelled, not the RCU and predicate pairing these comments name.
Would it make sense to either name these exceptions in the two comments, or
convert those sites like the others?

I checked the end of the series and both comments and all four threads.c
sites are unchanged there.

[Severity: Low]
This isn't a bug introduced by this patch, but the header comment a dozen
lines above the new store still reads:

	/*
	 * Stop and free a connection.
	 *
	 * This can only be used in very limited circumstances.  It assumes that once
	 * the conn has been shutdown that no one else is referencing the connection.
	 * We can only ensure this in the rmmod path in the current code.
	 */

That contract is contradicted by rds_ib_cm_connect_complete() in
net/rds/ib_cm.c, which destroys a single connection from an RDMA CM event
on a protocol version mismatch, and by the comment this patch adds just
below, which documents the function as fencing off concurrent requeuers for
exactly that non-rmmod case.  Should the stale header comment be refreshed
in the same patch?

For the record, the next patch in the series, "net/rds: split connection
destroy into quiesce and kref-governed free", rewrites this comment block,
so the contradiction does not survive the series.

[Severity: High]
This is a pre-existing issue, but since this is the per-connection destroy
path the commit message relies on, is there an AB-BA deadlock on it?

rds_rdma_cm_event_handler_cmn() in net/rds/rdma_transport.c takes
mutex_lock(&conn->c_cm_lock) and holds it across the whole event switch:

	if (conn) {
		mutex_lock(&conn->c_cm_lock);
	...
	case RDMA_CM_EVENT_ESTABLISHED:
		if (conn)
			trans->cm_connect_complete(conn, event);
	...
	out:
		if (conn)
			mutex_unlock(&conn->c_cm_lock);

The ESTABLISHED case reaches rds_ib_cm_connect_complete(), which for a peer
whose negotiated version is neither RDS_PROTOCOL_VERSION nor
RDS_PROTOCOL_COMPAT_VERSION calls rds_conn_destroy(conn).  The chain is:

rds_conn_destroy() -> rds_conn_path_destroy() ->
	rds_conn_path_drop(cp, true);
	flush_work(&cp->cp_down_w);

rds_conn_path_drop() with destroy == true sets cp_state to RDS_CONN_ERROR
and unconditionally queues cp_down_w, then the flush blocks the CM handler
thread while it still holds c_cm_lock.

The flushed worker runs rds_conn_shutdown(), where the DOWN to DOWN
transition fails because the state is RDS_CONN_ERROR, so it proceeds to:

	if (!rds_conn_path_transition(cp, RDS_CONN_DOWN, RDS_CONN_DOWN)) {
		/* ... else we may be deadlocking with the CM handler ... */
		mutex_lock(&cp->cp_cm_lock);

IB is not t_mp_capable, and net/rds/rds_single_path.h has:

	#define c_cm_lock		c_path[0].cp_cm_lock

so cp->cp_cm_lock is the very mutex the blocked CM handler thread holds.
Can either side make progress here?  Only the shutdown worker sets
RDS_CONN_DOWN, and its transition cannot succeed after the
atomic_set(RDS_CONN_ERROR), so mutex_lock() looks unavoidable.

The protocol major and minor come from the peer's rdma_cm private data via
rds_ib_set_protocol(), so a remote IB peer advertising an unsupported RDS
version reaches this.

As a secondary note, if the flush ever did return, the trailing
mutex_unlock(&conn->c_cm_lock) in rds_rdma_cm_event_handler_cmn() would
touch a conn that rds_conn_destroy() already kmem_cache_free()d.

The drop plus flush and the shutdown-side mutex_lock() are identical at the
baseline, and both are still present at the end of the series.

>  	/* Ensure conn will not be scheduled for reconnect */
>  	spin_lock_irq(&rds_conn_lock);
>  	hlist_del_init_rcu(&conn->c_hash_node);

[ ... ]

> diff --git a/net/rds/rds.h b/net/rds/rds.h
> index 2db49573dacd5..50b08c28ab865 100644
> --- a/net/rds/rds.h
> +++ b/net/rds/rds.h

[ ... ]

> @@ -994,7 +1001,8 @@ void __rds_put_mr_final(struct kref *kref);
>  
>  static inline bool rds_destroy_pending(struct rds_connection *conn)
>  {
> -	return !check_net(rds_conn_net(conn)) ||
> +	return READ_ONCE(conn->c_destroy_in_prog) ||
> +	       !check_net(rds_conn_net(conn)) ||
>  	       (conn->c_trans->t_unloading && conn->c_trans->t_unloading(conn));
>  }

[Severity: Medium]
Does the READ_ONCE() here rely on the caller having obtained the conn
pointer inside the same rcu_read_lock() section as the check and the queue?

At this commit struct rds_connection has no reference count, and
rds_conn_destroy() runs destroy_workqueue(cp->cp_wq), kfree(conn->c_path)
and kmem_cache_free(rds_conn_slab, conn) synchronously after the
synchronize_rcu().  Callers that hold a long-lived, non-refcounted pointer
instead of looking the conn up under RCU do exist: rs->rs_conn cached by
rds_sendmsg(), and ic->conn used by the IB completion handlers.

For those holders the deferred-send requeue in net/rds/send.c looks like it
can read the flag from freed slab memory and still queue onto a freed
workqueue:

	rcu_read_lock();
	if (rds_destroy_pending(cpath->cp_conn))
		ret = -ENETUNREACH;
	else
		queue_delayed_work(cpath->cp_wq, &cpath->cp_send_w, 1);
	rcu_read_unlock();

The single-connection destroy this patch targets,
rds_ib_cm_connect_complete() on a version mismatch, is exactly where such
stale pointers exist, so does the RCU flag alone close the
requeue-onto-freed-workqueue class the commit message describes, or does
that need the connection refcounting?

Later patches in this series do close it: "net/rds: split connection
destroy into quiesce and kref-governed free" moves destroy_workqueue(),
kfree(c_path) and kmem_cache_free() into rds_conn_destroy_fini() driven by
kref_put(), and "net/rds: hold connection references in lookup, sockets and
c_passive" makes rds_conn_lookup(), __rds_conn_create() and the rs_conn
cache own references.  Since this commit carries a Fixes: tag and may be
backported on its own, would it be worth noting in the commit message that
the guard is complete only with those follow-ups?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260914033719.138057-1-achender%40kernel.org
