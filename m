Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E623264E3;
	Thu, 10 Sep 2026 01:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789002194; cv=none; b=kRW0paaF6z5mU8SZg2hTz71iaJe7XK5Tp8l/FRFgRfNGm7J61lXkSOWIhDcTBErRr5H1DFL9r8h0UsVQzzLTu3Ixj+jDbBWK6qD+vCsZ8+8SY1hGoBsxcPZBGSmg942s1pnXHxRiN+rL69r/51iDHZhdskqQcI9EeNTElM20rsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789002194; c=relaxed/simple;
	bh=juQ6tUjELG1HNg+wfrJDtaO05aBJA92Ob89+Q94dldU=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=o3L8TTW6nTOR8XChHHbMBSKYboARdf/Jm+FqpIG3hm16D2ZZVnKADQ5mQ6yoCceJam80xU1gF5F2QfSz9aI0/5wvIkjGRo68Yd8zJswMj5iLXIStWAbLw3duJcz1EIO2J22EHTL7XJm0rhJk5NY6LSikE1dkK/ogGxH8pfwRO2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CBegCl+o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CBegCl+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0AD1F00898;
	Thu, 10 Sep 2026 01:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789002184;
	bh=JAWXunqe4e0rH6SMzQ4biopCQgD50Rl9AKPcTCZp5Os=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=CBegCl+oJpVL0ZMSDR5mAprT0R/8JDpX9zTqVUhY5M14sqH9FBmdyPVl5wRCjQGKa
	 NSynAr8rRyZlIoCB6Ylg3zfPEtagicrX+r0V+WaFmrAVW2X+BRL2BmRHK/Xk3gvdM7
	 Bu3pBzvfytA/h2v+VbzWyFjsUDWloM44cj5lhmQtw/HxPpKJ7Oi5u0NFZY6S5tRLNU
	 Do6/NKFvOp4H/Lzrf6jRHhn1Hd6K/bwOYS6WG4SjOO/NOPp/OU69uJqKussb6ZCE4b
	 IdXEapjTtZhPAK1B8m77foTQomIPr9lksL8YqGSWqPvjPXQPlqPsFmz2MpQqQfz3f6
	 RRQL2inkd2YVw==
Subject: Re: [PATCH net-next 3/6] net/rds: hold connection references in
 lookup, sockets and c_passive
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Thu, 10 Sep 2026 01:03:03 +0000
Message-ID: <178900218397.219967.1429437591238114023@kernel.org>
In-Reply-To: <20260904070248.160384-4-achender@kernel.org>
References: <20260904070248.160384-4-achender@kernel.org>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 7 potential
issue(s) to consider:

Critical: 0 · High: 2 · Medium: 3 · Low: 2

- [High] Transport per-connection nodes can stay linked into a stack-
  local temporary list after rds_conn_destroy() returns, and the…
- [High] The commit asserts that cm_id->context may stay reference-free
  because "connection destroy tears down the cm_id before the connection…
- [Medium] rds_sendmsg() now declares and enforces rs->rs_lock as the
  serialization for rs->rs_conn (plain load under rs_lock at…
- [Medium] The new reference model makes parent->c_passive own a
  reference that is only dropped when the *parent* is destroyed, but…
- [Medium] parent->c_passive becomes a concurrently written, RCU-consumed
  pointer with no RCU annotations.
- [Low] The patch closes a syzbot-reported KCSAN data race on rs->rs_conn
  (Reported-by/Closes tags present) and removes stale-pointer reuse of a…
- [Low] The new comment in rds_conn_lookup() asserts that an RCU
  traversal of rds_conn_hash may legitimately encounter a connection…

--

net/rds: hold connection references in lookup, sockets and c_passive

This hands out real references wherever a struct rds_connection pointer
used to escape bare: rds_conn_lookup() and __rds_conn_create() return a
held reference, the rs->rs_conn sendmsg cache owns one and is serialized
under rs_lock, and parent->c_passive owns one dropped when the parent is
destroyed.  The cm_id->context back-pointers are left reference-free by
design.

Link: https://syzkaller.appspot.com/bug?extid=879c1877016972360186

>     Reported-by: syzbot+879c1877016972360186@syzkaller.appspotmail.com
>     Closes: https://syzkaller.appspot.com/bug?extid=879c1877016972360186

[Severity: Low]
The changelog closes a reported KCSAN data race but carries no Fixes: tag
for the commit that introduced the unsynchronized rs_conn cache (git blame
points at 5c11559046c4 "RDS: send.c").

Should a Fixes: tag be added, or if the patch is intentionally not a stable
candidate because it depends on the earlier patches in this series, could
the changelog say so explicitly?

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index f45fd1fb1843d..df26959b0fdce 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c

[ ... ]

> @@ -96,6 +99,13 @@ static struct rds_connection *rds_conn_lookup(struct net *net,
>  		    conn->c_tos == tos &&
>  		    net == rds_conn_net(conn) &&
>  		    conn->c_dev_if == dev_if) {
> +			/* An entry whose refcount already dropped to
> +			 * zero has been unhashed and is about to be
> +			 * freed; an RCU traversal may still come
> +			 * across it.  Treat it as absent.
> +			 */
> +			if (!kref_get_unless_zero(&conn->c_refcount))
> +				continue;
>  			ret = conn;
>  			break;
>  		}

[Severity: Low]
Can an RCU traversal of rds_conn_hash actually observe an entry whose
refcount has already reached zero?  rds_conn_destroy() unhashes the node
under rds_conn_lock, calls synchronize_rcu(), and only then drops the
initial reference, so a reader that can still reach the node appears to be
inside a grace period where the refcount is at least one.

If the state the comment describes were reachable, would the guard even
help?  rds_conn_destroy_fini() frees immediately at the final put:

net/rds/connection.c:rds_conn_destroy_fini() {
	...
	kfree(conn->c_path);
	kmem_cache_free(rds_conn_slab, conn);
}

and rds_conn_init() creates the cache without SLAB_TYPESAFE_BY_RCU:

	rds_conn_slab = KMEM_CACHE(rds_connection, 0);

so the c_faddr/c_laddr/c_trans comparisons above the guard would already be
reads of freed or recycled memory.

kref_get_unless_zero() itself is a harmless idiom here; could the comment
be reworded so a later reader does not conclude that zero-refcount entries
are safely traversable?

> @@ -197,7 +207,14 @@ static struct rds_connection *__rds_conn_create(struct net *net,
>  		 * We need a second connection object into which we
>  		 * can stick the other QP. */
>  		parent = conn;
> +		/* The c_passive pointer holds a reference which is only
> +		 * dropped one synchronize_rcu() after the pointer is
> +		 * cleared, so within this RCU section a fetched pointer
> +		 * is always safe to take a reference on.
> +		 */
>  		conn = parent->c_passive;
> +		if (conn)
> +			rds_conn_get(conn);
>  	}
>  	rcu_read_unlock();
>  	if (conn)

[Severity: Medium]
Nothing here tests c_destroy_in_prog on the passive child, and nothing
clears the parent's c_passive when the passive connection itself is
destroyed - rds_conn_destroy() only clears its own c_passive:

net/rds/connection.c:rds_conn_destroy() {
	...
	if (conn->c_destroy_in_prog) {
		spin_unlock_irq(&rds_conn_lock);
		return;
	}
	...
	passive = conn->c_passive;
	conn->c_passive = NULL;
}

Since a quiesced connection now stays alive until its last reference goes
away, can this hand an already-destroyed passive conn, with a fresh
reference, back to rds_ib_cm_handle_connect()?

The quiesce leaves the path in RDS_CONN_DOWN with ic->i_cm_id == NULL, so
the DOWN->CONNECTING transition succeeds and a new cm_id is installed,
rds_ib_setup_qp() runs and rdma_accept() is called.  A second
rds_conn_destroy() then returns early on the c_destroy_in_prog guard, so
that state is never torn down and rds_conn_destroy_fini() only calls
conn_free(), which kfree()s the rds_ib_connection with the QP and CQs still
armed.

The one single-conn destroy path for IB is the version-mismatch drop in
rds_ib_cm_connect_complete(); would refusing to return a conn with
c_destroy_in_prog set (or invalidating the parent's pointer when the child
is destroyed) close this?

Separately, even without reuse, does the new c_passive reference keep a
quiesced passive conn - its transport state and its per-path workqueue -
pinned for the whole lifetime of the parent?

> @@ -316,12 +333,32 @@ static struct rds_connection *__rds_conn_create(struct net *net,
>  	spin_lock_irqsave(&rds_conn_lock, flags);
>  	if (parent) {
>  		/* Creating passive conn */
> -		if (parent->c_passive) {
> +		if (READ_ONCE(parent->c_destroy_in_prog)) {
> +			/* The parent's destroy has begun (it sets the
> +			 * flag and snatches c_passive under this
> +			 * lock); do not install a new passive conn
> +			 * that nothing would ever destroy.
> +			 */
> +			trans->conn_free(conn->c_path[0].cp_transport_data);
> +			free_cp = conn->c_path;
> +			kmem_cache_free(rds_conn_slab, conn);
> +			conn = ERR_PTR(-ENETDOWN);
> +		} else if (parent->c_passive) {
> +			rds_conn_get(parent->c_passive);
>  			trans->conn_free(conn->c_path[0].cp_transport_data);
>  			free_cp = conn->c_path;
>  			kmem_cache_free(rds_conn_slab, conn);
>  			conn = parent->c_passive;
>  		} else {
> +			/* The initial reference belongs to whoever
> +			 * destroys the conn (the transport's conn
> +			 * lists, as for any other conn).  Take one
> +			 * for the c_passive pointer - dropped when
> +			 * the parent is destroyed - and one for our
> +			 * caller.
> +			 */
> +			rds_conn_get(conn);	/* c_passive */
> +			rds_conn_get(conn);	/* caller */
>  			parent->c_passive = conn;
>  			rds_cong_add_conn(conn);
>  			rds_conn_count++;

[Severity: Medium]
The install of the passive conn is a plain store consumed by a reader that
holds only rcu_read_lock():

	parent->c_passive = conn;

Should this be rcu_assign_pointer(), with rcu_dereference() at the read
site above and a __rcu annotation on the field in struct rds_connection?

The initialising stores to c_trans, c_path and the transport data are
ordered only by the rds_conn_lock unlock, which gives nothing to a reader
that never acquires that lock.  On a weakly ordered CPU, can the RCU reader
in __rds_conn_create() see c_passive != NULL with those fields still stale,
and then pass that pointer to rds_ib_cm_handle_connect(), which
dereferences them?

[ ... ]

> @@ -646,6 +690,16 @@ void rds_conn_destroy(struct rds_connection *conn)
>  
>  	/* Ensure conn will not be scheduled for reconnect */
>  	hlist_del_init_rcu(&conn->c_hash_node);
> +
> +	/* Snatch c_passive while holding the lock:
> +	 * __rds_conn_create() dereferences it under rcu_read_lock()
> +	 * (and refuses to install a new one once c_destroy_in_prog is
> +	 * set, which it checks under this lock).  After the
> +	 * synchronize_rcu() below no one can pick the pointer up any
> +	 * more and its reference can be dropped.
> +	 */
> +	passive = conn->c_passive;
> +	conn->c_passive = NULL;
>  	spin_unlock_irq(&rds_conn_lock);
>  	synchronize_rcu();

[Severity: Medium]
This adds a second concurrent writer of c_passive as a plain store.  Before
this patch c_passive was written once and never cleared, so the unlocked
read in __rds_conn_create() had no competing writer.

The reader takes rcu_read_lock() but not rds_conn_lock, so the two accesses
share no lock.  Is this pair reportable by KCSAN in the same way as the
rs_conn race the changelog fixes, and would WRITE_ONCE()/rcu_assign_pointer()
here plus rcu_dereference() at the read site be preferable?

> @@ -663,6 +717,10 @@ void rds_conn_destroy(struct rds_connection *conn)
>  	 */
>  	rds_cong_remove_conn(conn);
>  
> +	/* drop the reference our c_passive pointer held, if any */
> +	if (passive)
> +		rds_conn_put(passive);
> +
>  	/* drop the initial reference; the connection is freed from
>  	 * rds_conn_destroy_fini() once every holder has dropped theirs
>  	 */

[Severity: High]
Now that real holders exist (the socket rs_conn cache, an in-flight
sendmsg, c_passive, lookup callers), rds_conn_destroy() can return with the
connection still alive and trans->conn_free() deferred to the final put.

Do the transport teardown helpers still rely on conn_free() unlinking the
per-connection node before they return?  They keep the node linked into a
list head on their own stack:

net/rds/ib_rdma.c:rds_ib_destroy_nodev_conns() {
	LIST_HEAD(tmp_list);

	spin_lock_irq(&ib_nodev_conns_lock);
	list_splice(&ib_nodev_conns, &tmp_list);
	spin_unlock_irq(&ib_nodev_conns_lock);

	list_for_each_entry_safe(ic, _ic, &tmp_list, ib_node)
		rds_conn_destroy(ic->conn);
}

and the unlink happens much later, from the deferred free:

net/rds/ib_cm.c:rds_ib_conn_free() {
	...
	spin_lock_irq(lock_ptr);
	list_del(&ic->ib_node);
	spin_unlock_irq(lock_ptr);
}

For a node whose neighbour is the tmp_list head, does that list_del() write
ic->ib_node.prev->next and .next->prev into a stack frame that has already
returned?

The same shape appears in rds_tcp_destroy_conns() and rds_tcp_kill_sock(),
where the node moved to tmp_list is not marked t_tcp_node_detached, so
rds_tcp_conn_free() takes the list_del() branch:

net/rds/tcp.c:rds_tcp_conn_free() {
	...
	if (!tc->t_tcp_node_detached)
		list_del(&tc->t_tcp_node);
}

and in rds_loop_kill_conns() with rds_loop_conn_free()'s
list_del(&lc->loop_node).

The later series patch that waits for connections to be freed on transport
unload does not appear to cover these: rds_ib_exit() calls
rds_ib_destroy_nodev_conns() and only then
rds_conn_wait_conns_freed(&rds_ib_transport), and rds_tcp_exit() waits
after rds_tcp_destroy_conns() has returned; the netns paths
(rds_tcp_kill_sock, rds_loop_kill_conns) get no wait at all.

Would unlinking the node (or marking it detached, as rds_tcp_kill_sock
already does for the secondary nodes) before rds_conn_destroy() can return,
or using a list head that outlives the pending frees, avoid this?

> diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
> index 4feb0edc360c8..24e538c253a7a 100644
> --- a/net/rds/ib_cm.c
> +++ b/net/rds/ib_cm.c
> @@ -924,8 +924,14 @@ int rds_ib_cm_handle_connect(struct rdma_cm_id *cm_id,
>  		rds_ib_conn_error(conn, "rdma_accept failed\n");
>  
>  out:
> -	if (conn)
> +	if (conn) {
>  		mutex_unlock(&conn->c_cm_lock);
> +		/* The conn stays reachable through cm_id->context
> +		 * without a reference of its own: connection destroy
> +		 * shuts the cm_id down before the conn is freed.
> +		 */
> +		rds_conn_put(conn);
> +	}
>  	if (err)
>  		rdma_reject(cm_id, &err, sizeof(int),
>  			    IB_CM_REJ_CONSUMER_DEFINED);

[Severity: High]
Is anything enforcing the invariant in this comment, that destroy tears the
cm_id down before the conn can be freed?

The CM event handler picks up the back-pointer with no reference and locks
a mutex that lives inside the separately freed c_path array
(c_cm_lock is c_path[0].cp_cm_lock per net/rds/rds_single_path.h):

net/rds/rdma_transport.c:rds_rdma_cm_event_handler_cmn() {
	struct rds_connection *conn = cm_id->context;
	...
	if (conn)
		mutex_lock(&conn->c_cm_lock);
	...
	case RDMA_CM_EVENT_ESTABLISHED:
		... rds_ib_cm_connect_complete(conn, event);
	...
	if (conn)
		mutex_unlock(&conn->c_cm_lock);
}

and for an unsupported peer protocol version that ESTABLISHED handling
destroys the conn from inside the callback:

net/rds/ib_cm.c:rds_ib_cm_connect_complete() {
	...
	rds_conn_destroy(conn);
}

Since this hunk drops the caller reference at out:, can that destroy be the
final put, so rds_conn_destroy_fini() kfree()s c_path and the conn before
the handler's mutex_unlock(&conn->c_cm_lock) runs on freed memory?

On the same path, does destroy deadlock the rdma_cm event workqueue?

rds_conn_destroy()
  rds_conn_path_quiesce()
    rds_conn_path_drop(cp, true)
    flush_work(&cp->cp_down_w)
      rds_shutdown_worker() -> rds_conn_shutdown()
        mutex_lock(&cp->cp_cm_lock)   <- already held by this CM callback

Also, rds_ib_cm_handle_connect() does not re-check rds_destroy_pending(conn)
after taking c_cm_lock.  When a destroy's quiesce has already completed, the
path is back in RDS_CONN_DOWN, so can this still win the DOWN->CONNECTING
transition, install ic->i_cm_id and cm_id->context, set up the QP and
accept, after which the new rds_conn_put() here is the final put and frees
the conn and its rds_ib_connection with the cm_id and QP still armed?

Would a real reference for the CM back-pointer (kref_get_unless_zero()) or
an rds_destroy_pending() re-check under c_cm_lock be needed to make the
comment's claim hold?

> diff --git a/net/rds/send.c b/net/rds/send.c
> index 1afa981e5c06d..036a68372e2f4 100644
> --- a/net/rds/send.c
> +++ b/net/rds/send.c

[ ... ]

> @@ -1340,11 +1341,29 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
>  	rm->m_daddr = daddr;
>  
>  	/* rds_conn_create has a spinlock that runs with IRQ off.
> -	 * Caching the conn in the socket helps a lot. */
> -	if (rs->rs_conn && ipv6_addr_equal(&rs->rs_conn->c_faddr, &daddr) &&
> -	    rs->rs_tos == rs->rs_conn->c_tos) {
> -		conn = rs->rs_conn;
> +	 * Caching the conn in the socket helps a lot.
> +	 *
> +	 * The cached rs_conn holds a connection reference; take one of
> +	 * our own for the duration of this call (dropped on both exit
> +	 * paths), so that neither a concurrent sender replacing the
> +	 * cache nor rds_conn_destroy() can free the connection under
> +	 * us.  A cached connection whose destruction has begun is not
> +	 * reused: dropping it here lets the next sendmsg look up or
> +	 * create a live one instead of returning -EAGAIN forever.
> +	 */
> +	spin_lock_irqsave(&rs->rs_lock, flags);
> +	conn = rs->rs_conn;
> +	if (conn && ipv6_addr_equal(&conn->c_faddr, &daddr) &&
> +	    rs->rs_tos == conn->c_tos && !rds_destroy_pending(conn)) {
> +		rds_conn_get(conn);
>  	} else {
> +		conn = NULL;
> +	}
> +	spin_unlock_irqrestore(&rs->rs_lock, flags);
> +
> +	if (!conn) {
> +		struct rds_connection *old;
> +
>  		conn = rds_conn_create_outgoing(sock_net(sock->sk),
>  						&rs->rs_bound_addr, &daddr,
>  						rs->rs_transport, rs->rs_tos,
> @@ -1352,9 +1371,17 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
>  						scope_id);
>  		if (IS_ERR(conn)) {
>  			ret = PTR_ERR(conn);
> +			conn = NULL;
>  			goto out;
>  		}
> +		/* hand the cache its own reference */
> +		rds_conn_get(conn);
> +		spin_lock_irqsave(&rs->rs_lock, flags);
> +		old = rs->rs_conn;
>  		rs->rs_conn = conn;
> +		spin_unlock_irqrestore(&rs->rs_lock, flags);
> +		if (old)
> +			rds_conn_put(old);
>  	}

[Severity: Medium]
The changelog says "reads and updates of rs_conn are serialized by
rs_lock", but rds_ioctl(SIOCRDSSETTOS) still reads rs_conn and writes
rs_tos under an unrelated global lock:

net/rds/af_rds.c:rds_ioctl() {
	...
	spin_lock_bh(&rds_sock_lock);
	if (rs->rs_tos || rs->rs_conn) {
		spin_unlock_bh(&rds_sock_lock);
		return -EINVAL;
	}
	rs->rs_tos = tos;
	spin_unlock_bh(&rds_sock_lock);
}

The two paths share no lock.  Is the plain load of rs->rs_conn there still
racing with the plain store of rs->rs_conn here, on the same eight-byte
field that the KCSAN report names?

The ioctl's "TOS cannot change once a connection exists" test also looks
like a check-then-act across the two locks:

ioctl(SIOCRDSSETTOS)                sendmsg()
  reads rs->rs_conn == NULL
                                      rds_conn_create_outgoing(..., rs->rs_tos, ...)
  rs->rs_tos = tos;
                                      rs->rs_conn = conn;

Can that leave a cached connection whose c_tos no longer matches rs_tos, so
every later sendmsg fails the rs->rs_tos == conn->c_tos test above and
recreates or re-looks-up a connection?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260904070248.160384-1-achender%40kernel.org
