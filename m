Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A5539E9DD;
	Thu, 17 Sep 2026 09:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789637943; cv=none; b=UZqp29i5f8j/h2LvT2wcWNqO0B97HjlO9SDWyYYQqXACSt9mCbDhss0yQT/VOcQS5ALeYFQG6MouG2zANaTHlDY/wbEG45EG7MYUNyV0/CLCp//LD0ruxf2XbQ/Ut6TbWJwM9vYJpEBSv5gE9tLoGLUr2Vdyli/cJt3s/pIRrA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789637943; c=relaxed/simple;
	bh=UGYBGfUKGk+SKXZogoNXY1jZP8lsu1Tv2vaA7SjKF84=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TzrDYCAAAM++u2i/VBmT0yE5aILQYRxfjQVlXPmFmlQJqO5LGPgUQ+3Kk5rQDf5b6eW/DR6luoSIXcBHJNFlkEiAma2DJ7He8gfFRetMqyPtUoarMQzFIRgwzrFrQPiM/mm+uae9tOBspM5jGAfQcR+oo2jp9wjTaf+FCH7iFy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UBqrjkJa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UBqrjkJa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A5E1F0089A;
	Thu, 17 Sep 2026 09:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789637922;
	bh=HV3cZsjmKcXchNl+p70G5gP4tCOyjw5B57zvF7lMgi4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=UBqrjkJaqteXsCHCFh0vbj8VQ3/A+gYQYcnxDM1pJ3f8FCRtPNT62P9MuSJh0XPRF
	 Qr/5kwNX03JAStBg7wfneiVeKLDD3p57aY8BcUV5NpS7K+LLziBaHaTuWX+7hMTnZ6
	 7+NR9K3o9jQID65S05tgY7k65vn81Z0CQZX0lX80/Wib59GB6uJvXyKpPxOPkLOt+c
	 wSnJqJSvIn5uaAulKy0aY4QUWoXYTyalefwn7nNoH5r3TGud+ttpyB07agHBBlZ7gV
	 g8QzkEls65S1yY6q2Fhbd2QRBAJjEHDyaWoKMQeGGUCMahVBvS8i3uVVYqZ4BVSn7a
	 Beo64ld8/wIYw==
Subject: Re: [PATCH net-next v3 05/13] net/rds: split connection destroy into
 quiesce and kref-governed free
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Thu, 17 Sep 2026 09:38:41 +0000
Message-ID: <178963792196.22033.18199579151065119958@kernel.org>
In-Reply-To: <20260914033719.138057-6-achender@kernel.org>
References: <20260914033719.138057-6-achender@kernel.org>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider:

Critical: 0 · High: 1 (2) · Medium: 0 · Low: 2 (1)

- [High] The new double-destroy guard in rds_conn_destroy() is not backed
  by a reference and does not synchronize the losing caller, yet its…
- [Low] Concern (assessed INVALID for this series): the deferred
  rds_conn_destroy_fini() can run transport-module code (conn_free),…
- [Low] Concern (assessed INVALID): the new c_refcount comment in
  net/rds/rds.h ("Free of the connection memory (not the teardown of its…

Pre-existing issues:
- [High] Per-path ordered workqueues allocated in __rds_conn_create() are
  leaked for every connection that goes through the loopback-transport…
- [High] Destroying an IB connection from the RDMA-CM ESTABLISHED
  callback self-deadlocks.
- [Low] Concern (assessed INVALID for this series): because no holder
  takes a reference in this patch, the peer-triggered rds_conn_destroy()…

--

net/rds: split connection destroy into quiesce and kref-governed free

This adds a kref to struct rds_connection, initialized in
__rds_conn_create().  rds_conn_destroy() keeps quiescing the connection
synchronously, while the frees (the transport's conn_free, the path
workqueues, the c_path array and the slab object) move to the new
rds_conn_destroy_fini(), which runs from the last rds_conn_put().

A few questions below.

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index 242ca0570a47e..a44aa4d2a5e8b 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c

[ ... ]

> @@ -520,10 +522,12 @@ void rds_conn_shutdown(struct rds_conn_path *cp)
>  		conn->c_trans->conn_slots_available(conn, false);
>  }
>  
> -/* destroy a single rds_conn_path. rds_conn_destroy() iterates over
> - * all paths using rds_conn_path_destroy()
> +/* quiesce a single rds_conn_path: shut it down and tear down any
> + * queued messages.  rds_conn_destroy() iterates over all paths using
> + * rds_conn_path_quiesce(); the transport state and the workqueue are
> + * freed later, from rds_conn_path_free().
>   */
> -static void rds_conn_path_destroy(struct rds_conn_path *cp)
> +static void rds_conn_path_quiesce(struct rds_conn_path *cp)
>  {
>  	struct rds_message *rm, *rtmp;
>  

[Severity: High]

This isn't a bug introduced by this patch, but since the changelog calls
out the rds_ib_cm_connect_complete() destroy path explicitly: can that
path deadlock on the synchronous half that rds_conn_path_quiesce()
inherits?

rds_conn_path_quiesce() still does:

	rds_conn_path_drop(cp, true);
	flush_work(&cp->cp_down_w);

and rds_rdma_cm_event_handler_cmn() holds mutex_lock(&conn->c_cm_lock)
across trans->cm_connect_complete(), unlocking only at the out: label.
net/rds/rds_single_path.h has:

	#define c_cm_lock		c_path[0].cp_cm_lock

so that is the same mutex as cp->cp_cm_lock for the path being torn down.

rds_conn_path_drop() sets cp_state to RDS_CONN_ERROR before queueing
cp_down_w, so the flushed rds_shutdown_worker() -> rds_conn_shutdown()
takes the

	if (!rds_conn_path_transition(cp, RDS_CONN_DOWN, RDS_CONN_DOWN)) {

branch and calls mutex_lock(&cp->cp_cm_lock).  The chain looks like:

rds_rdma_cm_event_handler_cmn()          [holds c_cm_lock]
  rds_ib_cm_connect_complete()
    rds_conn_destroy()
      rds_conn_path_quiesce()
        flush_work(&cp->cp_down_w)       [waits for the worker]

cp_down_w -> rds_shutdown_worker() -> rds_conn_shutdown()
  mutex_lock(&cp->cp_cm_lock)            [waits for the handler]

The trigger is a remote peer completing a connection with c_version below
RDS_PROTOCOL_VERSION and not equal to RDS_PROTOCOL_COMPAT_VERSION.  Both
waits are unbounded, and one of the stuck threads is the RDMA-CM event
delivery context.  This is unchanged from the baseline
rds_conn_path_destroy() and is still present at the end of the series.

> @@ -552,6 +556,16 @@ static void rds_conn_path_destroy(struct rds_conn_path *cp)
>  	WARN_ON(delayed_work_pending(&cp->cp_recv_w));
>  	WARN_ON(delayed_work_pending(&cp->cp_conn_w));
>  	WARN_ON(work_pending(&cp->cp_down_w));
> +}
> +
> +/* free a quiesced rds_conn_path's transport state and workqueue; runs
> + * from rds_conn_destroy_fini() once the last connection reference is
> + * dropped.
> + */
> +static void rds_conn_path_free(struct rds_conn_path *cp)
> +{
> +	if (!cp->cp_transport_data)
> +		return;
>  
>  	if (cp->cp_wq != rds_wq) {
>  		destroy_workqueue(cp->cp_wq);
> @@ -561,16 +575,52 @@ static void rds_conn_path_destroy(struct rds_conn_path *cp)
>  	cp->cp_conn->c_trans->conn_free(cp->cp_transport_data);
>  }

[Severity: Low]

conn_free() is transport module text and destroy_workqueue() plus
kmem_cache_free(rds_conn_slab, conn) now run from the deferred path, so a
reference dropped after rds_conn_destroy() returned can execute them.
rds_tcp_exit(), rds_ib_exit(), rds_loop_exit() and rds_conn_exit() at this
commit have no barrier that waits for outstanding references before
rds_trans_unregister() and kmem_cache_destroy().

This looks fine as of this commit, since the initial reference is the only
one and the release is still synchronous, and the following patch adds
struct rds_transport::t_conn_count plus rds_conn_wait_conns_freed() called
from rds_tcp_exit(), rds_ib_exit() and rds_loop_exit().  Would it help to
say in the changelog that the unload barrier arrives in the next patch, so
that this one is not read as already allowing deferred frees past module
unload?

>  
> +/* Free a connection.  This runs from rds_conn_put() when the last
> + * reference is dropped, after rds_conn_destroy() has quiesced the
> + * connection and dropped the initial reference.
> + */
> +static void rds_conn_destroy_fini(struct kref *kref)
> +{
> +	struct rds_connection *conn = container_of(kref, struct rds_connection,
> +						   c_refcount);
> +	int npaths = (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
> +	unsigned long flags;
> +	int i;
> +
> +	for (i = 0; i < npaths; i++)
> +		rds_conn_path_free(&conn->c_path[i]);
> +
> +	kfree(conn->c_path);
> +	kmem_cache_free(rds_conn_slab, conn);

[Severity: High]

This is a pre-existing issue and not introduced by this patch, but the
split moves the workqueue destruction here, so it is worth asking: does
this leak the per-path workqueues of a loopback-substituted connection?

__rds_conn_create() computes npaths from the caller's transport:

	int npaths = (trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);

allocates that many ordered workqueues:

	for (i = 0; i < npaths; i++) {
		...
		conn->c_path[i].cp_wq =
			alloc_ordered_workqueue("krds_cp_wq#%lu/%d", 0,
						rds_conn_count, i);

but the loopback substitution before that loop can replace trans:

			trans = &rds_loop_transport;
	...
	conn->c_trans = trans;

rds_tcp_transport has .t_prefer_loopback = 1 and .t_mp_capable = 1, while
rds_loop_transport has t_mp_capable == 0.  So an outgoing RDS-TCP
connection to a local address allocates RDS_MPATH_WORKERS workqueues, and
rds_conn_destroy_fini() recomputes npaths from conn->c_trans, which is now
the loop transport, i.e. 1.  Paths 1 and up are never visited and
kfree(conn->c_path) then drops the only pointers to their cp_wq.

Separately, rds_conn_path_free() returns before destroy_workqueue():

	if (!cp->cp_transport_data)
		return;

	if (cp->cp_wq != rds_wq) {
		destroy_workqueue(cp->cp_wq);

so a path that got a workqueue but no transport data leaks it even when it
is visited.  The create-side error path in the later series patch loops
over the local npaths and destroys every cp_wq != rds_wq unconditionally,
which suggests the teardown side wants the same treatment.  Repeated
netns create/send/exit cycles would leak these workqueues without bound.

> +
> +	spin_lock_irqsave(&rds_conn_lock, flags);
> +	rds_conn_count--;
> +	spin_unlock_irqrestore(&rds_conn_lock, flags);
> +}
> +
> +void rds_conn_get(struct rds_connection *conn)
> +{
> +	kref_get(&conn->c_refcount);
> +}
> +EXPORT_SYMBOL_GPL(rds_conn_get);
> +
> +void rds_conn_put(struct rds_connection *conn)
> +{
> +	kref_put(&conn->c_refcount, rds_conn_destroy_fini);
> +}
> +EXPORT_SYMBOL_GPL(rds_conn_put);
> +

[ ... ]

> @@ -584,11 +634,23 @@ void rds_conn_destroy(struct rds_connection *conn)
>  	 * sites (which all test rds_destroy_pending() under
>  	 * rcu_read_lock()) from queueing new work on the path
>  	 * workqueues once we start cancelling and destroying them.
> +	 *
> +	 * Now that the transport state stays discoverable (e.g. on the
> +	 * transports' connection lists) until the final rds_conn_put(),
> +	 * a conn can be handed to rds_conn_destroy() more than once -
> +	 * e.g. dropped for a protocol version mismatch and then found
> +	 * again at module unload.  Only the first caller proceeds; the
> +	 * unhash also happens under rds_conn_lock, so a looked-up conn
> +	 * can never be quiesced twice.
>  	 */
> +	spin_lock_irq(&rds_conn_lock);
> +	if (conn->c_destroy_in_prog) {
> +		spin_unlock_irq(&rds_conn_lock);
> +		return;
> +	}
>  	WRITE_ONCE(conn->c_destroy_in_prog, true);

[Severity: High]

The comment says "Only the first caller proceeds" and "a looked-up conn
can never be quiesced twice", but the guard itself is not backed by a
reference.  Can reading conn->c_destroy_in_prog here be the
use-after-free it is meant to prevent?

Three of the four rds_conn_destroy() callers reach the conn through a
transport-private list whose node is unlinked only by the deferred
conn_free().  For example net/rds/ib_rdma.c:

rds_ib_destroy_nodev_conns()
	list_for_each_entry_safe(ic, _ic, &tmp_list, ib_node)
		rds_conn_destroy(ic->conn);

rds_tcp_kill_sock()/rds_tcp_destroy_conns() pass tc->t_cpath->cp_conn and
rds_loop_exit()/rds_loop_kill_conns() pass lc->conn with the same shape.

If a concurrent destroyer, i.e. rds_ib_cm_connect_complete() reacting to a
peer that advertised an unsupported protocol version, has already reached
rds_conn_destroy_fini(), the conn is gone:

rds_conn_destroy_fini()
	kmem_cache_free(rds_conn_slab, conn);

so the guard reads freed slab memory, and a recycled object whose
c_destroy_in_prog happens to read 0 would be quiesced again.

The second half is the losing caller.  It returns immediately while the
winner is still inside cancel_delayed_work_sync()/flush_work() and before
conn_free() and destroy_workqueue() have run.  The winner's conn_free()
then does:

rds_ib_conn_free()
	spin_lock_irqsave(lock_ptr, flags);
	list_del(&ic->ib_node);
	spin_unlock_irqrestore(lock_ptr, flags);
	...
	kfree(ic);

which list_del()s a node still linked on the loser's stack-local tmp_list
and frees ic while the loser's list_for_each_entry_safe() keeps walking
it.

Should the guard be paired with an acquire that cannot resurrect a dead
object, and with a wait for the in-progress destroy?  rds_conn_get() as
added here is a plain kref_get(), so a non-RCU list holder has no way to
take a reference safely.  The later patches "unlink transport nodes before
a possibly deferred connection free" and "wait for connections to be freed
on transport unload" cover part of this, but at the end of the series the
three transport walkers still pass a bare ic->conn, lc->conn and
tc->t_cpath->cp_conn with no reference, and rds_ib_destroy_nodev_conns()
is additionally re-invoked as the resweep callback of
rds_conn_wait_conns_freed(), precisely while conns are quiesced but not
yet freed.

>  
>  	/* Ensure conn will not be scheduled for reconnect */
> -	spin_lock_irq(&rds_conn_lock);
>  	hlist_del_init_rcu(&conn->c_hash_node);
>  	spin_unlock_irq(&rds_conn_lock);
>  	synchronize_rcu();

[ ... ]

> @@ -607,12 +669,10 @@ void rds_conn_destroy(struct rds_connection *conn)
>  	 */
>  	rds_cong_remove_conn(conn);
>  
> -	kfree(conn->c_path);
> -	kmem_cache_free(rds_conn_slab, conn);
> -
> -	spin_lock_irqsave(&rds_conn_lock, flags);
> -	rds_conn_count--;
> -	spin_unlock_irqrestore(&rds_conn_lock, flags);
> +	/* drop the initial reference; the connection is freed from
> +	 * rds_conn_destroy_fini() once every holder has dropped theirs
> +	 */
> +	rds_conn_put(conn);
>  }
>  EXPORT_SYMBOL_GPL(rds_conn_destroy);

[Severity: Low]

This is a pre-existing exposure and not introduced by this patch, noting
it only because the changelog names these holders.  With no other holders
yet, this put still frees the conn before rds_conn_destroy() returns, so
rds_ib_cm_connect_complete()'s destroy leaves
rds_rdma_cm_event_handler_cmn() to run

out:
	if (conn)
		mutex_unlock(&conn->c_cm_lock);

on freed memory, and rds_sendmsg() still reads the unreferenced
rs->rs_conn cache.

Both are closed later in the same series: "hold connection references in
lookup, sockets and c_passive" makes rs_conn own a reference, and "pin the
connection across RDMA-CM event handling" takes
rds_conn_get_unless_zero() at handler entry and puts it after
mutex_unlock().  Would it be worth a sentence here noting that the
existing bare-pointer holders remain uncovered until those patches?

> diff --git a/net/rds/rds.h b/net/rds/rds.h
> index 50b08c28ab865..49629108c22ad 100644
> --- a/net/rds/rds.h
> +++ b/net/rds/rds.h
> @@ -137,6 +137,12 @@ struct rds_conn_path {
>  /* One rds_connection per RDS address pair */
>  struct rds_connection {
>  	struct hlist_node	c_hash_node;
> +	/* Free of the connection memory (not the teardown of its
> +	 * transport state - that stays synchronous in
> +	 * rds_conn_destroy()) is deferred until the last reference is
> +	 * dropped via rds_conn_put().
> +	 */
> +	struct kref		c_refcount;

[Severity: Low]

This isn't a bug, but the wording reads as if nothing about the transport
state is deferred, while conn_free() and destroy_workqueue() did move into
rds_conn_path_free().  The distinction the code makes is that the teardown,
conn->c_trans->conn_path_shutdown() driven from rds_conn_shutdown() via
rds_conn_path_drop(cp, true) plus flush_work(&cp->cp_down_w), stays
synchronous, while the free of that state is deferred.  Could this comment
spell that out, for instance by saying the transport state is shut down
synchronously but freed from rds_conn_destroy_fini()?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260914033719.138057-1-achender%40kernel.org
