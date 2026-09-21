Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D724C463B7C;
	Mon, 21 Sep 2026 09:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789982137; cv=none; b=Y28jCotqFSyzLv3OCqx0IYprIbO0HY6sGbb+mLOG2k/Sheejr8tRk8c4kBgCJBhjnKQEx6TyGZA8b/WchA+5m8yrD2zS2tackxOIhQxArSFwprCwamkOJtOsMt1HH/cpQlfAz6uybvYL5wO3FmngJjPpl6nUPjPVP4YeFq1evQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789982137; c=relaxed/simple;
	bh=U/XfiB/2EmSEMiySH9gC3Qtzm+ehPz/21PyCh048dWY=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JQtrq0AMsE6Tw8vkHE3ErpUyaruUnX5W2ih+Mabuq4jxCb0mnspj+YgWHb17IeA0A3rXh7j4saaK4Nnf5b8yVxv4mtgUqeFIsGcoM34pzZ2YgX/oAPrL1fbf8Wnr67A5awT46xC6Y5P41FmR3Lx8VCty32ujH213fIqCR5jmoLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ImjLAf/l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ImjLAf/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3691F00893;
	Mon, 21 Sep 2026 09:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789982135;
	bh=T6h0b7Y9D0NJ+Dy6jdsXv0KHFG+MxxZXj/31JmaMw78=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ImjLAf/ldHxojeITxmsqCUQYxCrrYlnkixok+rg1T/kbjd9MnRZvhoSYA9SkiYKeL
	 tRiCU+MVthlXO4cehMRxwUfyTtzSAXSQp2PTUB1qUuqGN786cEDOrEtxJOkpS2Lirz
	 u6g8p42PUwNPhu5v0TMIdF3xfjr7rBlPpqpbkNe+7/Cq5HGunzLtFy+s+Kc1ODoAAi
	 hE7wBQKy3mROUb5aXOfH1PE9XsBjbu1wRX6RT3geq3XSxexzy6+E9EuXv6gx199UxG
	 xSjxW5iInv1l9NYzej+l0YF/kNZr+fj/JFRHV2oQPtSqsb+m8fI5dEQI2gqrM36DdU
	 EWSp1medcRuyQ==
Subject: Re: [PATCH net-next v4 05/12] net/rds: split connection destroy into
 quiesce and kref-governed free
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Mon, 21 Sep 2026 09:15:34 +0000
Message-ID: <178998213442.2160803.13266512446171309846@kernel.org>
In-Reply-To: <20260917073958.174056-6-achender@kernel.org>
References: <20260917073958.174056-6-achender@kernel.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The freeing half of teardown (destroy_workqueue() of the per-path
  workqueues in rds_conn_path_free(), net/rds/connection.c:565-576, plus…
- [Low] The destruction-protocol comments state that every site arming a
  path work tests rds_destroy_pending() inside one rcu_read_lock()…
- [Low] The new duplicate-call branch in rds_conn_destroy()
  (net/rds/connection.c:646-651) returns as soon as c_destroy_in_prog is…

Pre-existing issues:
- [High] Unsupported-protocol-version handling deadlocks the RDS/IB
  connection teardown: rds_rdma_cm_event_handler_cmn()…

--

net/rds: split connection destroy into quiesce and kref-governed free

This patch adds a kref to struct rds_connection, keeps the synchronous
quiesce work in rds_conn_destroy() and moves the actual frees (transport
conn_free, path workqueues, c_path array, slab object) into
rds_conn_destroy_fini(), which runs from the last rds_conn_put().
rds_conn_get()/rds_conn_put() plus an inline rds_conn_get_unless_zero()
are exported for the reference holders added in the following patches.

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
This isn't a bug introduced by this patch, but since the quiesce (and its
flush_work()) stays synchronous inside rds_conn_destroy(), can this
teardown still deadlock when a peer negotiates an unsupported protocol
version?

The RDMA-CM handler calls the transport callback with the connection
management mutex held:

net/rds/rdma_transport.c:rds_rdma_cm_event_handler_cmn() {
	...
	mutex_lock(&conn->c_cm_lock);
	...
	trans->cm_connect_complete(conn, event);
}

and for a version mismatch that callback destroys the connection:

net/rds/ib_cm.c:rds_ib_cm_connect_complete() {
	...
	rds_conn_destroy(conn);
}

rds_conn_destroy() -> rds_conn_path_quiesce() then queues cp_down_w and
waits for it:

net/rds/connection.c:rds_conn_path_quiesce() {
	...
	rds_conn_path_drop(cp, true);
	flush_work(&cp->cp_down_w);
}

while the worker it waits for needs the same mutex:

net/rds/connection.c:rds_conn_shutdown() {
	...
	mutex_lock(&cp->cp_cm_lock);
}

For IB (single path) net/rds/rds_single_path.h aliases c_cm_lock to
c_path[0].cp_cm_lock, so the CM handler and the shutdown worker are
waiting on each other, and the version field comes from the peer's CM
private data.

Upstream commit f97d8c7bab78 ("rds: ib: use rds_conn_drop() on protocol
version mismatch", Cc: stable) addresses exactly this by not calling
rds_conn_destroy() there, but that change is not in this baseline -
rds_ib_cm_connect_complete() still calls rds_conn_destroy() both here and
at the tip of this series.  The later series patch "net/rds: pin the
connection across RDMA-CM event handling" states that the call was already
removed; is that accurate for this tree?

At the tip of the series this also turns transport unload into an
unbounded wait, since rds_conn_wait_conns_freed() in rds_ib_exit() polls
for a t_conn_count that a never-freed connection cannot drop.

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

[Severity: Low]
Would it be worth spelling out the calling-context contract that
rds_conn_put() now carries?

kref_put() runs the release in the caller's context, and
rds_conn_destroy_fini() -> rds_conn_path_free() sleeps:

	if (cp->cp_wq != rds_wq) {
		destroy_workqueue(cp->cp_wq);

destroy_workqueue() calls drain_workqueue(), mutex_lock(&wq->mutex) and
kthread_stop(), and in this commit rds_conn_destroy_fini() also takes
rds_conn_lock, so a last put issued under rds_conn_lock would recurse on
it.  That rds_conn_lock use is removed later in the series by "net/rds:
drop rds_conn_count in favor of t_conn_count", but the sleeping part
remains.

At this commit the only put site is the tail of rds_conn_destroy(), which
is process context and holds no lock, so nothing is broken today.  Should
rds_conn_put() carry a might_sleep() and a comment on the prototype, so
the future holders added by the follow-up patches have the requirement
stated in the header rather than only in commit messages?

>  /*
>   * Stop and free a connection.
>   *

[ ... ]

> @@ -584,11 +634,23 @@ void rds_conn_destroy(struct rds_connection *conn)
>  	 * sites (which all test rds_destroy_pending() under
>  	 * rcu_read_lock()) from queueing new work on the path
>  	 * workqueues once we start cancelling and destroying them.

[Severity: Low]
This isn't a bug, but is the "all test rds_destroy_pending() under
rcu_read_lock()" wording too broad?

The workers requeue themselves without the predicate and without an RCU
section:

net/rds/threads.c:rds_send_worker() {
	...
	case -EAGAIN:
		rds_stats_inc(s_send_immediate_retry);
		queue_delayed_work(cp->cp_wq, &cp->cp_send_w, 0);
}

net/rds/threads.c:rds_recv_worker() {
	...
	case -EAGAIN:
		rds_stats_inc(s_recv_immediate_retry);
		queue_delayed_work(cp->cp_wq, &cp->cp_recv_w, 0);
}

The same claim also appears on c_destroy_in_prog in net/rds/rds.h ("A
site that arms a path work must test the predicate and queue the work
inside one rcu_read_lock() section").  The self-requeues are safe because
rds_conn_path_quiesce() cancels those works with
cancel_delayed_work_sync(), which is what the earlier series patch
"net/rds: guard every work-requeueing site with rds_destroy_pending()"
explains, and the over-broad clause came from "net/rds: make
rds_destroy_pending() cover single-connection destroy" rather than this
patch.  Could both comments be qualified with something like "apart from
the workers' own self-requeues"?

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

[Severity: Low]
What does a second caller learn from this early return?  c_destroy_in_prog
is set here, before synchronize_rcu() and before any path is quiesced, so
on return the first caller may still be inside rds_conn_path_quiesce().

Meanwhile the new comment in net/rds/rds.h promises unconditionally:

	/* rds_conn_destroy() quiesces the connection synchronously;
	 * freeing it - the connection memory, the path workqueues and
	 * the transport's per-connection state - is deferred until the
	 * last reference is dropped via rds_conn_put().
	 */

The only real second destroyer today is rds_ib_cm_connect_complete()
racing the rds_ib_exit() sweep; the TCP and loopback sweeps unlink each
node under the transport lock first, and rds_ib_remove_one() only drops
the path.  The next patch in the series adds rds_conn_wait_conns_freed()
to rds_ib_exit(), which closes the window where the sweep returns while
another thread is still quiescing, so this is only about the wording.
Could the rds.h comment note that a duplicate rds_conn_destroy() call
returns without waiting for the in-flight quiesce?

> diff --git a/net/rds/rds.h b/net/rds/rds.h
> index 50b08c28ab865..defda3ddefa32 100644
> --- a/net/rds/rds.h
> +++ b/net/rds/rds.h
> @@ -137,6 +137,12 @@ struct rds_conn_path {
>  /* One rds_connection per RDS address pair */
>  struct rds_connection {
>  	struct hlist_node	c_hash_node;
> +	/* rds_conn_destroy() quiesces the connection synchronously;
> +	 * freeing it - the connection memory, the path workqueues and
> +	 * the transport's per-connection state - is deferred until the
> +	 * last reference is dropped via rds_conn_put().
> +	 */
> +	struct kref		c_refcount;

[ ... ]

> @@ -826,6 +832,13 @@ struct rds_connection *rds_conn_create_outgoing(struct net *net,
>  void rds_conn_shutdown(struct rds_conn_path *cpath);
>  void rds_conn_destroy(struct rds_connection *conn);
> +void rds_conn_get(struct rds_connection *conn);
> +void rds_conn_put(struct rds_connection *conn);
> +/* take a reference unless the connection is already being freed */
> +static inline bool rds_conn_get_unless_zero(struct rds_connection *conn)
> +{
> +	return kref_get_unless_zero(&conn->c_refcount);
> +}

Thanks for looking at these.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260917073958.174056-1-achender%40kernel.org
