Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81092D1907;
	Wed, 16 Sep 2026 04:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789533407; cv=none; b=pbzgKRmKRr8zN4QohFp9YDem9C39M1KE0/iJaYmNPyTD7aqTIE5i/+Vs7BPDNsGc1H7hTdwW2WMTQaBL0xODcNUGUw8jdl4tXDRyF4w+01I6b8tbF/jWWPQRcHOeVTtKlKqjmVHqS0tJHeSsxnp0wGwvE1dmJM4fVxDtaTvrN3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789533407; c=relaxed/simple;
	bh=+d7u2b+2j8vUvv5X9lPGSeT5NkbNlceNdGYBgbLOcUA=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gNFQr0OKzzR5ijhGgMJHwBHH5Q9FEJznn5wpCB17xemlI3hwX+ha/TcVVmTYgJSzk8cvjjjQ/fI4+0PuvLdDkR9HikjW4BjRLA1nxzBsPx6zjg09EZvPJr4dwRHK8hi4lGLCWxj13XHq1l5wivF9dGIqboe4tLwvkL9EgVeyZw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C/XD8HRz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C/XD8HRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1791F00893;
	Wed, 16 Sep 2026 04:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789533405;
	bh=8G3rYLRUNgjk2h95WPti9gHchmuSQLofkzmMwS+I6AM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=C/XD8HRzVfTysT1vt6/mfstl7GfGiZ+LQJxRCeZGrtVRBhHMdt0IOu2n8enOnQRyl
	 IWB5ZFbTLOURuGjOeLzNZn6mGau8TWej61IspKM8sj2MlVsMGYd+STAWWFAC3WhgqU
	 DwtqvG+U2B7w6YYxRyczrd6Qca4fzcgXFQpGxOPRHmeOe0Xl9tHWd2N5P3GxHGIx7R
	 uhT9O2D6MvH3DhJtBSkY/NSCXvAMhdlV65MgWD4HH1faYu0Ati8Q+IjcxrXoyzJ+cK
	 /OMAZRZmACg4xddZpPGjh+S/PhsMlvVJQUttujRKT0AbGEkn38qXmMu1pqvbJCdRSD
	 sByFVhJi4mtPw==
Subject: Re: [PATCH net-next v2 2/9] net/rds: make rds_destroy_pending() cover
 single-connection destroy
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Wed, 16 Sep 2026 04:36:44 +0000
Message-ID: <178953340453.22033.3272399861070164947@kernel.org>
In-Reply-To: <20260912035027.27447-3-achender@kernel.org>
References: <20260912035027.27447-3-achender@kernel.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 0 (2) · Medium: 0 · Low: 1 (2)

- [Low] The commit message and both new comments assert an invariant the
  tree does not hold.

Pre-existing issues:
- [High] Deadlock in the very single-connection destroy path this patch
  is written for.
- [High] Reported concern (judged resolved later in the series):
  rds_destroy_pending() now dereferences conn->c_destroy_in_prog, but…
- [Low] Reported concern (judged invalid at the end of the series):
  rds_conn_destroy()'s header comment at net/rds/connection.c:558-565…
- [Low] Reported concern (judged a false positive): that
  rds_conn_path_drop(cp, destroy=true) (net/rds/connection.c:997-1008)…

--

net/rds: make rds_destroy_pending() cover single-connection destroy

This adds a per-connection c_destroy_in_prog flag, set by
rds_conn_destroy() before the unhash plus synchronize_rcu() sequence, and
tests it in rds_destroy_pending() so that a single-connection destroy is
covered by the same predicate the work-requeueing sites already consult.
The now-unreferenced RDS_DESTROY_PENDING cp_flags bit and its dead test in
rds_ib_is_unloading() are removed.

A few questions below.

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index b6c4beb50eaf0..50e1b6bfceeab 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c
> @@ -574,6 +574,14 @@ void rds_conn_destroy(struct rds_connection *conn)
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
Is the "which all test rds_destroy_pending() under rcu_read_lock()" part
accurate for the current tree?  rds_send_worker() and rds_recv_worker() in
net/rds/threads.c re-arm their own works with no predicate test and no RCU
read-side section:

net/rds/threads.c:rds_send_worker() {
	...
	switch (ret) {
	case -EAGAIN:
		rds_stats_inc(s_send_immediate_retry);
		queue_delayed_work(cp->cp_wq, &cp->cp_send_w, 0);
		break;
	case -ENOMEM:
		rds_stats_inc(s_send_delayed_retry);
		queue_delayed_work(cp->cp_wq, &cp->cp_send_w, 2);
	...
}

rds_recv_worker() does the same for cp_recv_w.

Those two do look safe, but for a different reason than the one documented
here: rds_conn_path_destroy() runs cancel_delayed_work_sync(&cp->cp_send_w)
and cancel_delayed_work_sync(&cp->cp_recv_w), and __cancel_work_sync()
disables the work for the duration of the cancel, so a self-requeue from the
still-running worker is dropped and the worker cannot requeue once the sync
cancel has returned.

The commit message makes the same universal claim:

    since all of those sites guard the queueing with rds_destroy_pending()
    under rcu_read_lock() (the last stragglers were converted by the
    previous patch)

Could both the comment and the commit message be reworded so the two
self-requeue sites in threads.c are not covered by the statement?

> +	WRITE_ONCE(conn->c_destroy_in_prog, true);
> +
>  	/* Ensure conn will not be scheduled for reconnect */
>  	spin_lock_irq(&rds_conn_lock);
>  	hlist_del_init_rcu(&conn->c_hash_node);

[Severity: High]
This isn't a bug introduced by this patch, but the single-connection destroy
path the commit message names as the motivation looks like it deadlocks
before the new flag matters.

rds_ib_cm_connect_complete() calls rds_conn_destroy() synchronously from
inside the RDMA CM event handler, which still holds conn->c_cm_lock (that is
c_path[0].cp_cm_lock, see #define c_cm_lock c_path[0].cp_cm_lock in
net/rds/rds_single_path.h):

rds_rdma_cm_event_handler_cmn()
  mutex_lock(&conn->c_cm_lock);
  rds_ib_cm_connect_complete()
    rds_conn_destroy()
      rds_conn_path_destroy()
        rds_conn_path_drop(cp, true);   /* cp_state = RDS_CONN_ERROR,
                                           queue_work(cp_down_w) */
        flush_work(&cp->cp_down_w);

The queued pass then blocks on the mutex the flushing thread still holds:

rds_shutdown_worker()
  rds_conn_shutdown(cp)
    /* DOWN->DOWN transition fails, state is RDS_CONN_ERROR */
    mutex_lock(&cp->cp_cm_lock);

The handler cannot reach its mutex_unlock() until rds_conn_destroy() returns,
and rds_conn_destroy() cannot return until cp_down_w completes.  Can this
hang both the rdma_cm event worker and the path workqueue worker, with the
connection left in DISCONNECTING/ERROR?

There appears to be a second cycle on the same path: if the shutdown pass
ever got past the mutex, rds_ib_conn_path_shutdown() calls
rdma_destroy_id(ic->i_cm_id) on the very cm_id whose event is being handled,
which waits on id_priv->handler_mutex held by the same stuck thread.

The deciding input is peer supplied: the branch is taken when the peer's
accept private data decodes to a protocol version below 3.1, with
RDS_PROTOCOL_VERSION == RDS_PROTOCOL_COMPAT_VERSION == 0x0301.

> diff --git a/net/rds/rds.h b/net/rds/rds.h
> index 2db49573dacd5..50b08c28ab865 100644
> --- a/net/rds/rds.h
> +++ b/net/rds/rds.h

[ ... ]

> @@ -148,6 +147,14 @@ struct rds_connection {
>  				c_pad_to_32:29;
>  	int			c_npaths;
>  	bool			c_with_sport_idx;
> +	/* Set once, by rds_conn_destroy(), before it cancels the path
> +	 * works; read through rds_destroy_pending().  A site that arms
> +	 * a path work must test the predicate and queue the work inside
> +	 * one rcu_read_lock() section: the synchronize_rcu() that
> +	 * follows the store is what keeps a queue issued after the
> +	 * cancellation from landing on a destroyed workqueue.
> +	 */
> +	bool			c_destroy_in_prog;
>  	struct rds_connection	*c_passive;
>  	struct rds_transport	*c_trans;
>  
> @@ -994,7 +1001,8 @@ void __rds_put_mr_final(struct kref *kref);
>  
>  static inline bool rds_destroy_pending(struct rds_connection *conn)
>  {
> -	return !check_net(rds_conn_net(conn)) ||
> +	return READ_ONCE(conn->c_destroy_in_prog) ||
> +	       !check_net(rds_conn_net(conn)) ||
>  	       (conn->c_trans->t_unloading && conn->c_trans->t_unloading(conn));
>  }

[Severity: High]
This isn't a bug introduced by this patch, but rds_destroy_pending() now
dereferences the conn to read c_destroy_in_prog, while at this commit
rds_conn_destroy() still frees the conn synchronously right after the paths
are torn down:

net/rds/connection.c:rds_conn_destroy() {
	...
	kfree(conn->c_path);
	kmem_cache_free(rds_conn_slab, conn);
}

Several sites that evaluate the predicate hold raw, unreferenced conn
pointers: rs->rs_conn in rds_sendmsg(), tc->t_cpath->cp_conn reached from
sk->sk_user_data in the TCP callbacks, and ic->conn on the IB side.  Can
such a reader evaluate READ_ONCE(conn->c_destroy_in_prog) on freed slab
memory and, on a stale false, go on to queue work on a cp_wq that
destroy_workqueue() has already freed?

Later patches in this series do supply the liveness the new guard needs:
"net/rds: split connection destroy into quiesce and kref-governed free"
moves conn_free, destroy_workqueue, kfree(c_path) and kmem_cache_free into
rds_conn_destroy_fini() at the last rds_conn_put(); "net/rds: hold
connection references in lookup, sockets and c_passive" gives rs->rs_conn
its own reference; and "net/rds: pin the connection across RDMA-CM event
handling" pins the conn around the CM handler.  Would it be clearer to order
this patch after those, or to note the dependency in the commit message?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260912035027.27447-1-achender%40kernel.org
