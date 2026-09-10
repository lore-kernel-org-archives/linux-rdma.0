Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E0332AAA8;
	Thu, 10 Sep 2026 01:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789002187; cv=none; b=dfb5WBo5YutEfu9aZB8QyOvGI9YwKdQCmAM6tOMY49advnnMlEYnZc54qhTawG5ttBJohAkLuRqfwLZdjZMLGpnxqT+iwZRVtUHx9bn0yvyDB+Ehb1lB4hfEkvYMjjz1zsYAEwVFFU2NWUcf/MhzeoIFYg1LZkPMY6/bIEE57IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789002187; c=relaxed/simple;
	bh=gCZrb71Bv4zRfNQQ+5BzDpOADRm7L/zvdxOXhUiKh3c=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=C5hXLbBNqVcic8K/KJhKAX+MYC97Tt+ItpAk4esDEVnIUh4mhs/Zn/wVx4Mf0z6lWkuUJMRmRJQvKD/NxjFjyvmzi6MkXAmilFYJQCygqfpEFg8agWP3Wu4m6l6EF4rjLhDX38Wi+J8sU0VKoj8wzjK+3ANRzhCI+r3xWD1hXVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iiazVTLK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iiazVTLK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B35C1F000FF;
	Thu, 10 Sep 2026 01:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789002185;
	bh=+zYLQYlgkSd5N4WkoEgPyW6TOZtQGMTb1OImKHeoai8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=iiazVTLK5yYs3IKQSE5kah3TjVTw6yMwxAoMUfYIyGy04p9Z6TmXrdiH+rRKqr4XZ
	 e4HwgtSi8HHEaSrHXaw4mc5jD80doRGxpsg1yWJA0cT1hh7H+3ndn6U/BaGmUxLdQ2
	 zas3aE2Cz/v4LztfarqMkh3ef2+FKjvYAkKUn6icjc0SJTktKm5h1F+4+TfsPNOwJM
	 HK/Q9tolQtsxWRf8dgVIOTgEJuKumZjzq/W/VwHm2G1AwJtvOn6s7plNKJ3HzpqnJP
	 08W28own4aGifo1HiScLcEAU5kHxGyO+QY6lHlN6GQ1N00s1AqKJYTMZgRdAnYfiLW
	 Ax+189C01p1jA==
Subject: Re: [PATCH net-next 4/6] net/rds: wait for connections to be freed on
 transport unload
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Thu, 10 Sep 2026 01:03:05 +0000
Message-ID: <178900218508.219967.15363319078412796930@kernel.org>
In-Reply-To: <20260904070248.160384-5-achender@kernel.org>
References: <20260904070248.160384-5-achender@kernel.org>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 4 potential
issue(s) to consider:

Critical: 0 · High: 3 · Medium: 1 · Low: 0

- [High] rds_conn_wait_conns_freed() (net/rds/connection.c) is the entire
  enforcement mechanism the commit adds, but it is a `void` function…
- [High] The IB call site violates the documented precondition of the new
  helper.
- [High] The new wait is placed in rds_tcp_exit()/rds_ib_exit() *after*
  rds_tcp_destroy_conns()/rds_ib_destroy_nodev_conns() have returned, so…
- [Medium] Series ordering: this commit repairs a hazard that the
  immediately preceding commit in the same series creates.

--

net/rds: wait for connections to be freed on transport unload

This adds a per-transport live connection count (t_conn_count) that is
incremented when a connection is published in __rds_conn_create() and
decremented at the end of rds_conn_destroy_fini().  The transport exit
paths then call a new rds_conn_wait_conns_freed() helper that waits, with
a 10 second bound, for that count to drop to zero before unloading.

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index df26959b0fdce..90d660a45662e 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c

[ ... ]

> @@ -633,7 +638,31 @@ static void rds_conn_destroy_fini(struct kref *kref)
>  	spin_lock_irqsave(&rds_conn_lock, flags);
>  	rds_conn_count--;
>  	spin_unlock_irqrestore(&rds_conn_lock, flags);
> +
> +	/* only after everything the transport module owns has been
> +	 * freed above may its unload proceed
> +	 */
> +	if (!atomic_dec_return(&trans->t_conn_count))
> +		wake_up_all(&rds_conn_freed_waitq);
> +}

[Severity: Medium]

A question about the ordering of this series rather than this hunk itself.

The commit "net/rds: split connection destroy into quiesce and kref-governed
free" is described as functionally equivalent, since the initial reference is
still the only one, so the free continues to happen inline in
rds_conn_destroy().

The commit "net/rds: hold connection references in lookup, sockets and
c_passive" appears to be the first point at which rds_conn_lookup(), rs_conn
and c_passive hold real references, i.e. the first point at which
rds_conn_destroy() can return with c_trans->conn_free() still pending.

The wait that covers that window only arrives here, one commit later.  Does
the tree therefore pass through a state where rmmod rds_tcp / rmmod rds_rdma
racing a pending free has no barrier at all?  Would it make sense to place
this wait ahead of (or squash it into) the commit that adds the extra
reference holders, or at least mention the dependency in that commit
message?

> +
> +/* Wait for all of @trans's connections to be freed; the free runs
> + * asynchronously once rds_conn_destroy() has quiesced a connection.
> + * Called on transport module unload, after the transport destroyed
> + * all of its connections: anything still holding a connection
> + * reference at that point is a short-lived lookup-style holder, so
> + * a bounded wait suffices - but warn if it expires, since the frees
> + * that follow the unload will then touch freed module text.
> + */
> +void rds_conn_wait_conns_freed(struct rds_transport *trans)
> +{
> +	if (!wait_event_timeout(rds_conn_freed_waitq,
> +				!atomic_read(&trans->t_conn_count),
> +				msecs_to_jiffies(RDS_CONN_FREE_TIMEOUT_MS)))
> +		WARN(1, "RDS/%s: %d connection(s) not freed\n",
> +		     trans->t_name, atomic_read(&trans->t_conn_count));
>  }
> +EXPORT_SYMBOL_GPL(rds_conn_wait_conns_freed);

[Severity: High]

Is the use-after-free this patch describes still reachable through the
timeout branch of rds_conn_wait_conns_freed()?

The helper returns void, so on expiry it warns and returns, and none of the
three callers can react.  Teardown then continues unconditionally:

  rds_tcp_exit()
	rds_conn_wait_conns_freed(&rds_tcp_transport);	/* may time out */
	rds_trans_unregister(&rds_tcp_transport);
	rds_tcp_recv_exit();
	kmem_cache_destroy(rds_tcp_conn_slab);

  rds_ib_exit()
	rds_conn_wait_conns_freed(&rds_ib_transport);	/* may time out */
	...
	rds_ib_recv_exit();		/* destroys rds_ib_incoming_slab,
					 * rds_ib_frag_slab */
	rds_trans_unregister(&rds_ib_transport);
	rds_ib_mr_exit();

  rds_loop_exit() returns into rds_exit()/rds_conn_exit(), which destroys
  rds_conn_slab.

When the pending free finally runs, rds_conn_destroy_fini() does two things
that touch the unloaded module:

	for (i = 0; i < npaths; i++)
		rds_conn_path_free(&conn->c_path[i]);	/* -> c_trans->conn_free() */
	...
	if (!atomic_dec_return(&trans->t_conn_count))

The first is an indirect call into freed module text; the second is a write
into the module's freed data image.  For TCP the deferred
rds_tcp_conn_free() also lands in kmem_cache_free() on the already destroyed
rds_tcp_conn_slab, and for IB rds_ib_recv_free_caches() frees into slabs
destroyed by rds_ib_recv_exit().

The comment added on t_conn_count in rds.h says unload "has to wait for this
to reach zero", and the commit message says "if it expires anyway, warn - the
pending frees will touch freed module text".  Since a WARN is a diagnostic
rather than synchronisation, would an unbounded wait, a per-connection
module reference on trans->t_owner, or moving the transport-owned frees off
the asynchronous path be a better fit here?

As a side effect, does rmmod now block for up to 10 seconds, and does the
WARN take down machines running with panic_on_warn=1?

[Severity: High]

Can the deferred free write into an already popped stack frame?

The wait is placed after rds_tcp_destroy_conns() and
rds_ib_destroy_nodev_conns() have returned, so it cannot keep their
stack-local list heads alive:

net/rds/tcp.c:rds_tcp_destroy_conns() {
	LIST_HEAD(tmp_list);
	...
		if (!list_has_conn(&tmp_list, tc->t_cpath->cp_conn))
			list_move_tail(&tc->t_tcp_node, &tmp_list);
	...
	list_for_each_entry_safe(tc, _tc, &tmp_list, t_tcp_node)
		rds_conn_destroy(tc->t_cpath->cp_conn);
}

Entries whose free is deferred stay linked in tmp_list, and
t_tcp_node_detached is left false, so the deferred free later does:

net/rds/tcp.c:rds_tcp_conn_free() {
	spin_lock_irqsave(&rds_tcp_conn_lock, flags);
	if (!tc->t_tcp_node_detached)
		list_del(&tc->t_tcp_node);
	spin_unlock_irqrestore(&rds_tcp_conn_lock, flags);
	...
}

For an entry adjacent to the dead &tmp_list head, list_del() writes two
pointers into that popped frame, while the exit thread is sitting in
rds_conn_wait_conns_freed() -> wait_event_timeout() -> schedule_timeout()
on the same stack region.

The IB side is the same shape, with an unconditional list_del():

net/rds/ib_rdma.c:rds_ib_destroy_nodev_conns() {
	LIST_HEAD(tmp_list);
	spin_lock_irq(&ib_nodev_conns_lock);
	list_splice(&ib_nodev_conns, &tmp_list);
	spin_unlock_irq(&ib_nodev_conns_lock);
	...
}

net/rds/ib_cm.c:rds_ib_conn_free() {
	spin_lock_irq(lock_ptr);
	list_del(&ic->ib_node);
	spin_unlock_irq(lock_ptr);
	...
}

Note that rds_conn_destroy_fini() calls conn_free() before decrementing
t_conn_count, so the exit thread cannot observe completion ahead of the
write.  A conn already marked c_destroy_in_prog is guaranteed not to be
freed inside the destroy loop, since rds_conn_destroy() returns immediately
for it.

Would moving the wait inside the destroy helpers, or splicing onto a
non-stack list head, address this?  rds_loop_exit() looks safe only
incidentally, because its tmp_list and the wait share one frame.  The same
pattern appears in rds_tcp_kill_sock() and rds_loop_kill_conns() on netns
teardown.

> diff --git a/net/rds/ib.c b/net/rds/ib.c
> index 9fe3b9951bd32..7556905833259 100644
> --- a/net/rds/ib.c
> +++ b/net/rds/ib.c
> @@ -538,6 +538,15 @@ void rds_ib_exit(void)
>  #endif
>  	rds_ib_unregister_client();
>  	rds_ib_destroy_nodev_conns();
> +	rds_conn_wait_conns_freed(&rds_ib_transport);

[Severity: High]

Does this call site meet the precondition stated in the new helper's
comment, that it is called "after the transport destroyed all of its
connections"?

Connections still attached to a device do not appear to be destroyed by
either preceding call.  ib_unregister_client() -> rds_ib_remove_one() ->
rds_ib_dev_shutdown() only queues work:

net/rds/ib.c:rds_ib_dev_shutdown() {
	spin_lock_irqsave(&rds_ibdev->spinlock, flags);
	list_for_each_entry(ic, &rds_ibdev->conn_list, ib_node)
		rds_conn_path_drop(&ic->conn->c_path[0], true);
	spin_unlock_irqrestore(&rds_ibdev->spinlock, flags);
}

and rds_conn_path_drop() does queue_work(cp->cp_wq, &cp->cp_down_w) on the
per-path ordered workqueue, which the flush_workqueue(rds_wq) inside
rds_ib_unregister_client() does not drain.

An rds_ib_connection whose cp_down_w has not completed rds_ib_conn_shutdown()
-> rds_ib_remove_conn() is still on rds_ibdev->conn_list rather than
ib_nodev_conns, and rds_ib_destroy_nodev_conns() only walks ib_nodev_conns:

net/rds/ib_rdma.c:rds_ib_destroy_nodev_conns() {
	spin_lock_irq(&ib_nodev_conns_lock);
	list_splice(&ib_nodev_conns, &tmp_list);
	spin_unlock_irq(&ib_nodev_conns_lock);

	list_for_each_entry_safe(ic, _ic, &tmp_list, ib_node)
		rds_conn_destroy(ic->conn);
}

If such a connection's initial reference is never dropped, can t_conn_count
ever reach zero?  That would make the 10 second stall plus WARN the ordinary
outcome of rmmod rds_rdma with live IB connections, leave the module unloaded
with a live connection, and leak the rds_ib_connection along with its device
reference (so rds_ib_dev_free() never runs and the PD and MR pools are never
released).

Would draining the per-path workqueues, or destroying the per-device
conn_lists, before waiting cover these connections?

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

[ ... ]

> diff --git a/net/rds/rds.h b/net/rds/rds.h
> index e27e5e2e33293..35760dd6b077f 100644
> --- a/net/rds/rds.h
> +++ b/net/rds/rds.h
> @@ -553,6 +553,12 @@ struct rds_transport {
>  	unsigned int		t_prefer_loopback:1,
>  				t_mp_capable:1;
>  	unsigned int		t_type;
> +	/* Connections of this transport not yet freed; freeing runs
> +	 * asynchronously once rds_conn_destroy() has quiesced a
> +	 * connection, so transport module unload has to wait for this
> +	 * to reach zero (rds_conn_wait_conns_freed()).
> +	 */
> +	atomic_t		t_conn_count;

[ ... ]

> diff --git a/net/rds/tcp.c b/net/rds/tcp.c
> index 774a71f88d375..2685ee21a22d1 100644
> --- a/net/rds/tcp.c
> +++ b/net/rds/tcp.c
> @@ -805,6 +805,7 @@ static void rds_tcp_exit(void)
>  #endif
>  	unregister_pernet_device(&rds_tcp_net_ops);
>  	rds_tcp_destroy_conns();
> +	rds_conn_wait_conns_freed(&rds_tcp_transport);
>  	rds_trans_unregister(&rds_tcp_transport);
>  	rds_tcp_recv_exit();
>  	kmem_cache_destroy(rds_tcp_conn_slab);

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260904070248.160384-1-achender%40kernel.org
