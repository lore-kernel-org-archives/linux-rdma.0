Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48773876B2;
	Wed, 16 Sep 2026 04:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789533408; cv=none; b=q+WA3+DMD0uw1dVIv13nrfJ4/S5ryu01bmwRaS+FBMUyGKcu4tbqvpR7r9e0XTiusr/3wBf+VuxdpPcV0xd74WnXTrCnxYryDY6y4ztS7yOHMoFP2vQs88/Ojzz1xJ5Nkf8YrPXYBqALLfhtV9t06hri5V6qciLR7d8q89QgbDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789533408; c=relaxed/simple;
	bh=OWvy9Kg5FaBHt5sCrj5aHfjhCR9EjDFdj+Mi4ChZTrA=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dAzP/xbmO7PPoLnhVccgMcca7Isvj5wfjfL8b/tChYNm/iFOpnY73YisHOyeeKJdfRpBWFkhL/PQPBIbjld5TMOv1xj4Oy2rYyW9y73dZZ5x0B2Bc+m3Xiibe74TM2JrhobwY0jBELXOhLHGF3B5NBNpW+NeHPtnPtsY6De9xzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dOfaxK5g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dOfaxK5g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77411F00898;
	Wed, 16 Sep 2026 04:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789533406;
	bh=hh6nGhWK79V5wXDzIC8bwsllqt9y0bttsCeUrVWPyGE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=dOfaxK5gyl2THxvWIPIHh68MYffMjVyKsu4c6fotK1Y/TRZBos4Df1voT2+eHWv68
	 hd2vkwmAfJSgxrED+2uE3k/+s2nPdQWjKX5UQb4rx91sH8cpW5ZCSxDz4rjxKDn4Px
	 QVPHpHpbED1P6iUXG1k+jBKi9wzXHtUIBdB/0Fqd0EkSw9L5+E+Bgp9LrP64l8Jh2w
	 40cjNJQLe8mTrzvfhmHMeeED34IICxlEH7R53u4EYiQ4jLj+j2Afe4D4OgAGc4pHdp
	 CxvOAq8GFVVHwzRtGNn7EINrVyodTORkO1CD2ccf+KhxEF5K7BxF0YWfIINLJP/hX3
	 5t5HzunOHnSrg==
Subject: Re: [PATCH net-next v2 3/9] net/rds: split connection destroy into
 quiesce and kref-governed free
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Wed, 16 Sep 2026 04:36:45 +0000
Message-ID: <178953340551.22033.6459094271945942505@kernel.org>
In-Reply-To: <20260912035027.27447-4-achender@kernel.org>
References: <20260912035027.27447-4-achender@kernel.org>
X-sashiko-severity: Low
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

Critical: 0 · High: 0 (1) · Medium: 0 · Low: 2

- [Low] The transport's conn_free() and destroy_workqueue() move out of
  the synchronous destroy path into the kref release callback…
- [Low] The new comment on struct rds_connection::c_refcount
  (net/rds/rds.h:140-144) states that only the connection memory free is…

Pre-existing issues:
- [High] Destroying an unsupported-version IB connection from the RDMA-CM
  ESTABLISHED callback deadlocks.

--

net/rds: split connection destroy into quiesce and kref-governed free

This adds a kref to struct rds_connection, keeps the quiesce half of
rds_conn_destroy() synchronous, and moves the frees (transport conn_free,
path workqueues, c_path array, slab object) into rds_conn_destroy_fini()
which runs on the last rds_conn_put().  rds_conn_get()/rds_conn_put() are
exported for holders added in later patches.

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index 50e1b6bfceeab..cc4e74b731df9 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c

[ ... ]

> @@ -547,6 +551,16 @@ static void rds_conn_path_destroy(struct rds_conn_path *cp)
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

[Severity: Low]
This moves the transport's conn_free() and destroy_workqueue() out of the
synchronous destroy path and into the kref release callback, and the same
patch exports rds_conn_get()/rds_conn_put().  Is there anything yet that
makes a transport module unload wait for outstanding references?

rds_tcp_exit() destroys the connections and then immediately proceeds to
rds_trans_unregister() and kmem_cache_destroy(rds_tcp_conn_slab), so a
deferred rds_conn_path_free() would call conn_free() in unloaded module
text and free into a destroyed slab cache.

The transport teardown helpers also splice their connection lists onto an
on-stack list and rely on conn_free() unlinking each node before the
helper returns:

net/rds/tcp.c:rds_tcp_destroy_conns() {
	...
	list_for_each_entry_safe(tc, _tc, &tmp_list, t_tcp_node)
		rds_conn_destroy(tc->t_cpath->cp_conn);
}

net/rds/ib_rdma.c:rds_ib_destroy_nodev_conns() {
	...
	list_for_each_entry_safe(ic, _ic, &tmp_list, ib_node)
		rds_conn_destroy(ic->conn);
}

with a deferred free, rds_tcp_conn_free()/rds_ib_conn_free() would
list_del() into a stack frame that no longer exists.

For what it is worth, this looks latent at this commit rather than
reachable: rds_conn_get() has no callers here and the only rds_conn_put()
is the one in rds_conn_destroy(), so kref_init()'s reference is always the
last and every conn_free()/destroy_workqueue() still completes before
rds_conn_destroy() returns.  The following patches in the series appear to
close both holes, with t_conn_count plus rds_conn_wait_conns_freed() in
rds_ib_exit()/rds_tcp_exit()/rds_loop_exit(), and with the transport nodes
being unlinked before the possibly deferred free.

Would it be worth mentioning in this commit message that the exported
get/put must not be used by anyone until those two patches land, or
ordering the unload barrier ahead of this split?

> @@ -556,16 +570,52 @@ static void rds_conn_path_destroy(struct rds_conn_path *cp)
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

[Severity: High]
This isn't a bug introduced by this patch, but since the commit message
names rds_ib_cm_connect_complete() as one of the supported entry points
into rds_conn_destroy(), can that caller actually complete?

The RDMA-CM handler holds the mutex across the transport callback:

net/rds/rdma_transport.c:rds_rdma_cm_event_handler_cmn() {
	...
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
}

and c_cm_lock is c_path[0].cp_cm_lock (net/rds/rds_single_path.h), the
mutex the path-0 shutdown worker takes.  For a peer below
RDS_PROTOCOL_VERSION that is not RDS_PROTOCOL_COMPAT_VERSION:

net/rds/ib_cm.c:rds_ib_cm_connect_complete() {
	...
		rds_conn_destroy(conn);
		return;
}

runs with that mutex still held.  rds_conn_destroy() then reaches:

net/rds/connection.c:rds_conn_path_quiesce() {
	...
	rds_conn_path_drop(cp, true);
	flush_work(&cp->cp_down_w);
}

rds_conn_path_drop() sets cp_state to RDS_CONN_ERROR before queueing
cp_down_w, so the flushed worker always fails the first transition in
rds_conn_shutdown() and falls into:

net/rds/connection.c:rds_conn_shutdown() {
	if (!rds_conn_path_transition(cp, RDS_CONN_DOWN, RDS_CONN_DOWN)) {
		...
		mutex_lock(&cp->cp_cm_lock);
}

Is this a circular wait?  The flushing thread cannot drop c_cm_lock until
rds_conn_destroy() returns, and rds_conn_destroy() cannot return until the
worker acquires the same mutex.  The negotiated version comes from the
peer's private data, so a remote peer advertising an old version appears to
be enough to trigger it, with no timing window involved.

The same code is present in the baseline (879e280b) and still present at
the end of this series (rds_ib_cm_connect_complete() still calls
rds_conn_destroy() from the callback, and the handler still unlocks
c_cm_lock only after the callbacks return), so this predates the series.
Should this destroy be deferred out of the CM callback instead?

[ ... ]

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
This isn't a bug, but does this comment contradict the other two comments
added by the same patch?

Here the claim is that the teardown of the transport state "stays
synchronous in rds_conn_destroy()", while rds_conn_path_quiesce() says
"the transport state and the workqueue are freed later, from
rds_conn_path_free()", and rds_conn_destroy() says "The memory - including
the transport's per-connection state and the path workqueues - is freed
once the last rds_conn_put() runs".

rds_conn_path_free() does call c_trans->conn_free() and
destroy_workqueue(), and it runs from rds_conn_destroy_fini(), so the
rds.h wording looks like the odd one out.  The same wording is still
present at the end of the series, where the deferral of the transport
state is what motivates the new unload wait.  Could this comment be
reworded to match?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260912035027.27447-1-achender%40kernel.org
