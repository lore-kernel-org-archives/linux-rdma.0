Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDFB3D88F7;
	Sat, 26 Sep 2026 09:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790416121; cv=none; b=SvLxtNKCsUILumD1rEGoaDxLbmfQlS0X+Sk/levMolcK+j64Ab1Y2wzl5v0yvwmKnQ7bRPHlWFeI98m8b4eV4LfQnziV8UVP19Z1X2/9Yf8B4u4gi9pPXh7BGRcSSoCc5b48FEa3oISgbLhEftVK8pAZ1zXnx+IR0VBU1CXYLK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790416121; c=relaxed/simple;
	bh=gTSxljHUpmh9/2p3Qdne1LBOt4xyTS3Ty4YmdJRxu2Y=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Q6GX22dKXfgy20W1JtDzjevyTic3e+OeFtfvLCuZuvGGLKjmqntV2rO8HsP1rHHSBLFsmPRPMyLXAvtnCZm+6es1wt1D3phgBr7As67e+lyQftkxxc+MUixly3CGF3TDhu4RlmiRICx3nIJzVqhr1NDILBzOXR6MCs7/7ryGoVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lxKiNydk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lxKiNydk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2734E1F00893;
	Sat, 26 Sep 2026 09:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790416119;
	bh=YgHtQE2IuSN89tSltJ3Om1vnMazh2KoT3xzKhuRib+U=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=lxKiNydk55R20wKVGIssH6Npw2ZCH19VGhkUca/Hdv7egHck9AEtMw8lSa3T/zuBl
	 hC4B1YKI7ZQ3Oyfk5UEPm0D99wgsHXkKCKe17qLuRGj8W45JR7BhUHB2Cfa9vCKYHR
	 bCzDArTNpAHCOiekG/x548PKhWamc3N/qzulbCpY7sdl8Z4qy6PZVpftZQczHA+4dA
	 cFH0/g9tOTK5oT/UQfT1cHsM5GOJx11LhgyhipMKN/aw4QAmLDit9z1EBkRzYZWkPv
	 KnK7dMYq+s53qz3W3+ANG2IBVShVfAAOPy6Q9LZBN/xkVuXGY6V3XkHcDU2szJpzDl
	 GQQpVlXsHE02w==
Subject: Re: [PATCH net-next v6 05/12] net/rds: split connection destroy into
 quiesce and kref-governed free
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Sat, 26 Sep 2026 09:48:38 +0000
Message-ID: <179041611870.2160803.17897372905160921333@kernel.org>
In-Reply-To: <20260922085410.391323-6-achender@kernel.org>
References: <20260922085410.391323-6-achender@kernel.org>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 0 (1) · Medium: 2 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The changelog justifies the refcounting rework (and the new
  one-shot `c_destroy_in_prog` guard) with a call path that does not…
- [Medium] The new `c_destroy_in_prog` test in `rds_conn_destroy()`
  (net/rds/connection.c:646-651) makes a second or concurrent caller…
- [Low] The rds.h comment documenting `c_destroy_in_prog`
  (net/rds/rds.h:156-162) states it is "Set once, by rds_conn_destroy(),…

Pre-existing issues:
- [High] Per-path workqueue leak for loopback-converted connections:
  `__rds_conn_create()` computes `npaths` from the *incoming* transport…

--

net/rds: split connection destroy into quiesce and kref-governed free

This patch adds a kref to struct rds_connection and splits rds_conn_destroy()
into a synchronous quiesce plus a deferred free (rds_conn_destroy_fini()) that
runs when the last reference is dropped.  rds_conn_get()/rds_conn_put() are
exported and a new one-shot c_destroy_in_prog test under rds_conn_lock makes
repeated destroy calls return early.  No Link: tags are present in the commit
header.

A few questions below.

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index 242ca0570a47e..a44aa4d2a5e8b 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c

[ ... ]

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

[Severity: High]

This isn't a leak introduced by this patch - the old rds_conn_path_destroy()
already had the same !cp->cp_transport_data early return ahead of
destroy_workqueue() - but the patch moves destroy_workqueue() into
rds_conn_path_free(), reached from a freshly recomputed npaths loop, so it may
be worth addressing here.  Does this leak the per-path workqueues of a
loopback-converted connection?

__rds_conn_create() computes npaths from the incoming transport:

net/rds/connection.c:__rds_conn_create() {
	int npaths = (trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
	...
}

For an outgoing RDS/TCP connection to a local address that is 8, and 8 ordered
workqueues get allocated:

	for (i = 0; i < npaths; i++) {
		...
		conn->c_path[i].cp_wq =
			alloc_ordered_workqueue("krds_cp_wq#%lu/%d", 0,
						rds_conn_count, i);

But trans is replaced before it is stored in conn->c_trans:

			if (likely(is_outgoing)) {
				...
				trans = &rds_loop_transport;

rds_loop_transport has t_mp_capable == 0, so both rds_conn_destroy() and the
new rds_conn_destroy_fini() recompute npaths as 1 and only visit path 0.  And
even if paths 1..7 were visited, rds_loop_conn_alloc() sets cp_transport_data
only on path 0, so rds_conn_path_free() would take the !cp->cp_transport_data
return before reaching destroy_workqueue().  kfree(conn->c_path) then drops
the last pointers to the remaining 7 workqueues, once per destroyed
connection, on every netns teardown (rds_loop_kill_conns()) or module unload
(rds_loop_exit()).

For contrast, the allocation rollback in __rds_conn_create() iterates the
entry-time npaths and destroys every workqueue that is not rds_wq.  Should the
teardown path use the same bound, e.g. by recording npaths in the connection?

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
>  /*
>   * Stop and free a connection.
>   *
> - * This can only be used in very limited circumstances.  It assumes that once
> - * the conn has been shutdown that no one else is referencing the connection.
> - * We can only ensure this in the rmmod path in the current code.
> + * Quiesces the connection synchronously (workers cancelled, transport
> + * connections shut down, queued messages dropped) and drops the
> + * initial reference.  The memory - including the transport's
> + * per-connection state and the path workqueues - is freed once the
> + * last rds_conn_put() runs, which may be after this returns.
>   */
>  void rds_conn_destroy(struct rds_connection *conn)
>  {
> -	unsigned long flags;
>  	int i;
>  	struct rds_conn_path *cp;
>  	int npaths = (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
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

[Severity: Medium]

Is the protocol-version-mismatch example still reachable?  The changelog says:

    "Today, connections are also destroyed on network namespace teardown
    (rds_tcp_kill_sock() and rds_loop_kill_conns()) and, one at a time,
    when a peer negotiates an unsupported protocol version
    (rds_ib_cm_connect_complete())."

In this tree that branch drops the connection rather than destroying it:

net/rds/ib_cm.c:rds_ib_cm_connect_complete() {
	...
	if (conn->c_version < RDS_PROTOCOL_VERSION) {
		...
		rds_conn_drop(conn);
		return;
	}
	...
}

git grep rds_conn_destroy net/rds/ finds call sites only in ib_rdma.c
(rds_ib_destroy_nodev_conns), loop.c and tcp.c - none in ib_cm.c.  Commit
f97d8c7bab78 ("rds: ib: use rds_conn_drop() on protocol version mismatch")
made that change, and the preceding patch in this series says the same thing
("the last single-connection caller ... was turned into a drop by commit
f97d8c7bab78").

The same example is now also in the permanent comment above ("e.g. dropped for
a protocol version mismatch and then found again at module unload").  Could
the changelog and the comment use an example that can still happen?

> +	spin_lock_irq(&rds_conn_lock);
> +	if (conn->c_destroy_in_prog) {
> +		spin_unlock_irq(&rds_conn_lock);
> +		return;
> +	}
>  	WRITE_ONCE(conn->c_destroy_in_prog, true);

[Severity: Medium]

The flag is tested and set at the very top of rds_conn_destroy(), ahead of
synchronize_rcu(), the per-path rds_conn_path_quiesce() calls and
rds_cong_remove_conn().  So a caller that finds the flag already set returns
before anything has been quiesced, and there is no completion or state wait on
the early-return path:

	if (conn->c_destroy_in_prog) {
		spin_unlock_irq(&rds_conn_lock);
		return;
	}

That window contains a full synchronize_rcu() plus
cancel_delayed_work_sync(cp_send_w), cancel_delayed_work_sync(cp_recv_w) and
flush_work(cp_down_w) in rds_conn_path_quiesce().

The function's own new block comment states the contract without
qualification:

 * Quiesces the connection synchronously (workers cancelled, transport
 * connections shut down, queued messages dropped) and drops the
 * initial reference.

and so does the new c_refcount comment in rds.h ("rds_conn_destroy()
quiesces the connection synchronously").  Neither holds on the early-return
path, and the void return gives the caller no way to tell.

I could not find a second destroy caller today - all five sites detach the
transport node under the transport lock first, and netns exit and module
unload are excluded by pernet_ops_rwsem - so should the documentation say the
quiesce and the reference drop only happen for the first caller?  If a second
caller ever does appear, would rds_tcp_kill_sock()/rds_loop_kill_conns()
proceed while the transport socket and the workers are still live?

[Severity: Low]

This isn't a bug, but the existing comment on c_destroy_in_prog in rds.h now
describes fewer access rules than the code relies on:

	/* Set once, by rds_conn_destroy(), before it cancels the path
	 * works; read through rds_destroy_pending().
	 ...
	 */

The new "only the first caller proceeds" guarantee depends on the plain read
plus WRITE_ONCE() being an atomic test-and-set under rds_conn_lock.  Should
the comment mention that?  A future writer following only the documented rule
would store the flag without rds_conn_lock, as the code did before this patch,
and a reader following "read through rds_destroy_pending()" would get a
different predicate, since rds_destroy_pending() is also true for netns
teardown and for ->t_unloading.

> +
>  	/* Ensure conn will not be scheduled for reconnect */
> -	spin_lock_irq(&rds_conn_lock);
>  	hlist_del_init_rcu(&conn->c_hash_node);
>  	spin_unlock_irq(&rds_conn_lock);
>  	synchronize_rcu();

[ ... ]

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

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260922085410.391323-1-achender%40kernel.org
