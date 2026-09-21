Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DA146A5F8;
	Mon, 21 Sep 2026 09:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789982140; cv=none; b=PrUgs+psyfCZ9tDc/cbwGxCkAo/pYmijH5o4WCOYNxFxBgl3EfEop29SECaaa2TcaM2zoOQvD1pJmGzQ8zwwZEjiMWTwJ7T83isuwRBkegjuQ2JdhkSi68GDHKfz0imF1eluOWVem3TqXmRc51b2WOIuPjpb0/HpSKBs5g3pyPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789982140; c=relaxed/simple;
	bh=eHaTNv4e1NTqGOaNL5DEbaU+oAlZGj4quNymDQv7ijo=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sfoFt20pZPFjGokOGjQJiIshncW7KSjLNGdy4RrW88CPlXYrhT+9T4XE7ji6XMoJYGCoGcQsokwXi3GBMYT1Mp8N4AzW1NRg110R/SCdF3DJomOVJJv96YG94namnWHa0vEcuJ1A4+69axm2Uxq4JTAEjYYWYKkBhTXR9o8oAxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nb1djbIW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nb1djbIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A4E1F00893;
	Mon, 21 Sep 2026 09:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789982138;
	bh=mCQYptPLJav4A/3qju8o7PVL691fyOAfgBtBtuXsrDQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=nb1djbIWRqeQNzYkbnXoOO11oh/SWjzrxeOjSMJHX+6QDjlFfsZQWpXx1uqJdwfOc
	 Mpk8+BBH/vT/Re4LopnvSK0Yn4baO2Oc+2m0+wBr347JDJn4RAnUtmEqJFQa9O3mwW
	 IakATKSVojKt+0K1sXFLhvQskBOiKeUetgnuBPYUufJLtD7Ym+UXjuW3RsDoO9rxF8
	 uRi/3iGda2iDyOs59tYF6JFtbr6Gg34ZhCWcJdC8mfPV8Iu5ho0Cfld9/Yk2kt35oJ
	 ZC/xiN4/kSqfDJzhPEpSu8bKnabiAiA/CARHhUV8HHkeMj555H/lAz3QmaFHvqVm94
	 XZ9J0hqRTGcJg==
Subject: Re: [PATCH net-next v4 08/12] net/rds: hold connection references in
 lookup, sockets and c_passive
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Mon, 21 Sep 2026 09:15:37 +0000
Message-ID: <178998213762.2160803.6825942941311619302@kernel.org>
In-Reply-To: <20260917073958.174056-9-achender@kernel.org>
References: <20260917073958.174056-9-achender@kernel.org>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 6 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 (1) · Low: 5 (1)

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The commit message asserts that the race it closes 'needs a
  connection destroyed under a live socket, which takes netns teardown,…
- [Low] The commit closes a real, syzbot-reported user-triggerable KCSAN
  data race in rds_sendmsg() (concurrent plain stores to rs->rs_conn)…
- [Low] net/rds/rds.h documents c_destroy_in_prog as 'Set once, by
  rds_conn_destroy(), before it cancels the path works; read through…
- [Low] The new struct-field comment for rs_conn in net/rds/rds.h states
  unconditionally that the cached connection pointer 'is read and…
- [Low] In rds_conn_destroy() the comment above the two new puts claims
  'neither can be the last, since the initial reference is dropped…
- [Low] The patch makes rs->rs_lock the serializing lock for rs_conn and
  moves the SIOCRDSSETTOS store of rs_tos under it, but rds_sendmsg()…

Pre-existing issues:
- [Medium] DISCARDED as pre-existing and Medium: the rds_sendmsg()
  connection-cache hit test compares only c_faddr, ToS and destroy…
- [Low] DISCARDED (resolved later in this series):
  rds_ib_cm_handle_connect() publishes the connection through…

--

net/rds: hold connection references in lookup, sockets and c_passive

This patch makes every escaping struct rds_connection pointer carry a real
reference: rds_conn_lookup() and __rds_conn_create() return a referenced
connection, the rs->rs_conn sendmsg cache owns one and is now serialized
under rs_lock, and parent->c_passive owns one and becomes RCU annotated.
It also closes a syzbot-reported KCSAN write/write race on rs->rs_conn
between concurrent rds_sendmsg() calls on the same socket.

Closes: https://syzkaller.appspot.com/bug?extid=879c1877016972360186

A few questions on the commit message first, then some inline.

>     Serializing the rs_conn cache under rs_lock also resolves a
>     syzbot-reported KCSAN data race between concurrent rds_sendmsg()
>     calls on the same socket, each installing the connection it created
>     into rs->rs_conn with a plain store:

[Severity: Low]
The trailer block carries Reported-by: and Closes: but no Fixes: tag for
the commit that introduced the unsynchronized rs_conn store
(5c11559046c4 "RDS: send.c").

Since the race is reachable by any unprivileged process with two threads
sending on one PF_RDS socket, should a Fixes: tag be added, together with
the existing note that this is not a standalone stable candidate?

>     This is not a stable candidate on its own: it depends on the
>     connection reference counting introduced by the preceding patches,
>     and the race it closes needs a connection destroyed under a live
>     socket, which takes netns teardown, module unload or device removal.

[Severity: Medium]
Is the list of destruction triggers complete here?  rds_ib_cm_connect_complete()
in net/rds/ib_cm.c destroys a connection based on the peer's advertised
protocol version:

	if (conn->c_version < RDS_PROTOCOL_VERSION) {
		if (conn->c_version != RDS_PROTOCOL_COMPAT_VERSION) {
			pr_notice("RDS/IB: Connection <%pI6c,%pI6c> version %u.%u no longer supported\n", ...);
			rds_conn_destroy(conn);
			return;
		}
	}

The version comes from event->param.conn.private_data via
rds_ib_set_protocol(), so a remote peer can have a socket-cached outgoing
connection destroyed during ordinary connection establishment, with no
netns teardown, module unload or device removal involved.  Could the
paragraph mention that path too, since it changes how reachable the fixed
race is?

> diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
> index d5defe9172e36..1cc20b5cfd213 100644
> --- a/net/rds/af_rds.c
> +++ b/net/rds/af_rds.c
> @@ -80,6 +80,14 @@ static int rds_release(struct socket *sock)
>  	rds_notify_queue_get(rs, NULL);
>  	rds_notify_msg_zcopy_purge(&rs->rs_zcookie_queue);
>  
> +	/* drop the cached connection reference; no sendmsg can race
> +	 * with us here, the socket is going away
> +	 */
> +	if (rs->rs_conn) {
> +		rds_conn_put(rs->rs_conn);
> +		rs->rs_conn = NULL;
> +	}
> +

[Severity: Low]
This access does not take rs->rs_lock, while the new struct field comment
added for rs_conn in net/rds/rds.h states unconditionally that it "is read
and written under rs_lock" (see the rds.h hunk below).

The access itself looks fine, since rds_release() runs from sock_close()
after the last file reference is gone, but the struct-level contract is the
one a later reader will consult.  Would it be worth noting the socket
teardown exception in the rds.h comment, so that someone adding a
lockdep_assert_held(&rs->rs_lock) to an rs_conn accessor does not get a
splat from here?

> @@ -267,18 +276,23 @@ static int rds_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
>  		else
>  			return -ENOIOCTLCMD;
>  
> -		spin_lock_bh(&rds_sock_lock);
> +		/* rs_conn is serialized by rs_lock (see rds_sendmsg());
> +		 * hold it across the "no connection yet" check and the
> +		 * rs_tos store so a racing sendmsg cannot cache a conn
> +		 * whose c_tos then disagrees with rs_tos.
> +		 */
> +		spin_lock_irqsave(&rs->rs_lock, flags);
>  		if (rs->rs_tos || rs->rs_conn) {
> -			spin_unlock_bh(&rds_sock_lock);
> +			spin_unlock_irqrestore(&rs->rs_lock, flags);
>  			return -EINVAL;
>  		}
>  		rs->rs_tos = tos;
> -		spin_unlock_bh(&rds_sock_lock);
> +		spin_unlock_irqrestore(&rs->rs_lock, flags);
>  		break;

[Severity: Low]
This is the plain store side of rs_tos, now under rs_lock.

In rds_sendmsg() the same field is still read without the lock and without
READ_ONCE() when it is handed to rds_conn_create_outgoing():

	conn = rds_conn_create_outgoing(sock_net(sock->sk),
					&rs->rs_bound_addr, &daddr,
					rs->rs_transport, rs->rs_tos,
					sock->sk->sk_allocation,
					scope_id);

The other two rs_tos reads in rds_sendmsg() (the cache hit test and the
c_tos re-check) are both under rs_lock, so the lockset for this one access
is empty while a SIOCRDSSETTOS store runs under rs_lock.  Is this
unmarked concurrent access intentional in a commit whose purpose is to
remove that class of KCSAN report?  A READ_ONCE() on the sample would
document it.

The value itself is re-validated under rs_lock before the connection is
installed, so no stale ToS is sent on.

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index 1d48da1a794fa..965d68e51a1c1 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c

[ ... ]

> @@ -215,7 +237,20 @@ static struct rds_connection *__rds_conn_create(struct net *net,
>  		 * We need a second connection object into which we
>  		 * can stick the other QP. */
>  		parent = conn;
> -		conn = parent->c_passive;
> +		/* The c_passive pointer holds a reference which is only
> +		 * dropped one synchronize_rcu() after the pointer is
> +		 * cleared, so within this RCU section a fetched pointer
> +		 * is always safe to take a reference on.  A passive conn
> +		 * whose own destroy has begun is not handed out, though:
> +		 * it is quiesced and about to clear the parent's pointer
> +		 * itself, and reusing it would re-arm a connection that
> +		 * nothing will tear down again.
> +		 */
> +		conn = rcu_dereference(parent->c_passive);
> +		if (conn && READ_ONCE(conn->c_destroy_in_prog))
> +			conn = NULL;
> +		if (conn)
> +			rds_conn_get(conn);
>  	}

[Severity: Low]
This reads c_destroy_in_prog directly, but net/rds/rds.h documents the
field as "Set once, by rds_conn_destroy(), before it cancels the path
works; read through rds_destroy_pending()".

rds_destroy_pending() also covers the netns and transport-unloading cases:

	static inline bool rds_destroy_pending(struct rds_connection *conn)
	{
		return READ_ONCE(conn->c_destroy_in_prog) ||
		       !check_net(rds_conn_net(conn)) ||
		       (conn->c_trans->t_unloading && conn->c_trans->t_unloading(conn));
	}

and the fresh-conn gate earlier in this same function still uses it:

	if (rds_destroy_pending(conn))
		ret = -ENETDOWN;
	else
		ret = trans->conn_alloc(conn, GFP_ATOMIC);

so __rds_conn_create() now expresses "this conn is going away" with two
different predicates.  Should these new sites use rds_destroy_pending(),
or should the rds.h comment be relaxed to sanction raw reads of the flag
and say why the netns/unloading components are deliberately excluded here?

> @@ -334,13 +369,44 @@ static struct rds_connection *__rds_conn_create(struct net *net,
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
> +			rds_conn_free_transport_data(conn, npaths);
> +			free_cp = conn->c_path;
> +			kmem_cache_free(rds_conn_slab, conn);
> +			conn = ERR_PTR(-ENETDOWN);
> +		} else if (rcu_access_pointer(parent->c_passive)) {
> +			struct rds_connection *passive;
> +
> +			passive = rds_conn_passive_locked(parent);
>  			rds_conn_free_transport_data(conn, npaths);
>  			free_cp = conn->c_path;
>  			kmem_cache_free(rds_conn_slab, conn);
> -			conn = parent->c_passive;
> +			if (READ_ONCE(passive->c_destroy_in_prog)) {

These are the other two raw reads of the flag referred to above.

> +				/* Its destroy will clear the parent's
> +				 * pointer under this lock shortly; until
> +				 * then there is no usable passive conn.
> +				 */
> +				conn = ERR_PTR(-ENETDOWN);
> +			} else {
> +				rds_conn_get(passive);
> +				conn = passive;
> +			}
>  		} else {
> -			parent->c_passive = conn;
> +			/* The initial reference belongs to whoever
> +			 * destroys the conn (the transport's conn
> +			 * lists, as for any other conn).  Take one
> +			 * for the c_passive pointer - dropped when
> +			 * the parent is destroyed - and one for our
> +			 * caller.
> +			 */
> +			rds_conn_get(conn);	/* c_passive */
> +			rds_conn_get(conn);	/* caller */
> +			rcu_assign_pointer(parent->c_passive, conn);
>  			rds_cong_add_conn(conn);
>  			rds_conn_count++;
>  			atomic_inc(&conn->c_trans->t_conn_count);

[ ... ]

> @@ -702,7 +777,38 @@ void rds_conn_destroy(struct rds_connection *conn)
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
> +	passive = rds_conn_passive_locked(conn);
> +	RCU_INIT_POINTER(conn->c_passive, NULL);
> +
> +	/* If we are a parent's passive twin, invalidate its pointer to
> +	 * us as well, so that __rds_conn_create() cannot hand out a
> +	 * connection whose teardown has begun.  The parent is the
> +	 * hashed connection for our key (a passive conn is never
> +	 * hashed, and we unhashed ourselves above); it holds its
> +	 * initial reference for as long as it is hashed, so the lookup
> +	 * reference dropped below cannot be its last.
> +	 */
> +	head = rds_conn_bucket(&conn->c_laddr, &conn->c_faddr);
> +	rcu_read_lock();
> +	parent = rds_conn_lookup(rds_conn_net(conn), head, &conn->c_laddr,
> +				 &conn->c_faddr, conn->c_trans, conn->c_tos,
> +				 conn->c_dev_if);
> +	rcu_read_unlock();
> +	if (parent && rds_conn_passive_locked(parent) == conn) {
> +		RCU_INIT_POINTER(parent->c_passive, NULL);
> +		was_passive = true;
> +	}
>  	spin_unlock_irq(&rds_conn_lock);
> +	if (parent)
> +		rds_conn_put(parent);
>  	synchronize_rcu();

[ ... ]

> @@ -719,6 +825,15 @@ void rds_conn_destroy(struct rds_connection *conn)
>  	 */
>  	rds_cong_remove_conn(conn);
>  
> +	/* drop the reference our c_passive pointer held, if any, and
> +	 * the one a parent's c_passive pointer held on us; neither can
> +	 * be the last, since the initial reference is dropped below
> +	 */
> +	if (passive)
> +		rds_conn_put(passive);

[Severity: Low]
Does the "neither can be the last" claim hold for the passive put?  The
reference dropped here is the parent's c_passive reference on the passive
twin, and the twin's own initial reference is dropped by the twin's own
rds_conn_destroy(), not by the put below.

Parent A snatches passive = P and clears A->c_passive under rds_conn_lock,
then spends an unbounded time in synchronize_rcu() and
rds_conn_path_quiesce().  Meanwhile P's own destroy runs, e.g. from the
peer protocol-version path in rds_ib_cm_connect_complete():

	rds_conn_destroy(P)
	  parent lookup finds nothing (A is already unhashed)
	  was_passive == false
	  rds_conn_put(P)		/* P's initial reference */

P is then left at refcount 1, and A's rds_conn_put(passive) is the final
put, running rds_conn_destroy_fini() -> rds_conn_path_free()
(destroy_workqueue()) plus kmem_cache_free() and rds_conn_lock inline from
rds_conn_destroy().

That is legal where the put currently sits, since rds_conn_destroy() is in
sleepable context with no locks held.  Would it be more accurate to say
that this put may be the final one and must therefore stay outside
rds_conn_lock and in sleepable context, rather than that it cannot be the
last?  As written, someone relying on the stated invariant to move the
puts under rds_conn_lock would recurse on that lock via
rds_conn_destroy_fini().

> +	if (was_passive)
> +		rds_conn_put(conn);
> +
>  	/* drop the initial reference; the connection is freed from
>  	 * rds_conn_destroy_fini() once every holder has dropped theirs
>  	 */
> diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
> index 26a32c1ec8f7f..98f34b494237a 100644
> --- a/net/rds/ib_cm.c
> +++ b/net/rds/ib_cm.c
> @@ -924,8 +924,15 @@ int rds_ib_cm_handle_connect(struct rdma_cm_id *cm_id,
>  		rds_ib_conn_error(conn, "rdma_accept failed\n");
>  
>  out:
> -	if (conn)
> +	if (conn) {
>  		mutex_unlock(&conn->c_cm_lock);
> +		/* Drop the reference rds_conn_create() handed us.  The
> +		 * conn stays reachable through cm_id->context without a
> +		 * reference of its own for now; the CM event handler is
> +		 * given one of its own by a following patch.
> +		 */
> +		rds_conn_put(conn);
> +	}

[Severity: Low]
This isn't a bug introduced by this patch, but for the record: after this
put, cm_id->context is a bare pointer that
rds_rdma_cm_event_handler_cmn() dereferences with no reference of its own
(mutex_lock(&conn->c_cm_lock) on the mutex embedded in the connection), so
in principle a concurrent rds_conn_destroy() plus final rds_conn_put()
could free it under an in-flight CM event.

Before this patch rds_conn_create() returned a bare pointer and
cm_id->context equally held no reference, so nothing is regressed here,
and the following patch in the series does close it -
rds_rdma_cm_event_handler_cmn() gains

	if (conn && !rds_conn_get_unless_zero(conn)) {
		...
		return 0;
	}

with a matching rds_conn_put() at out:.  Only noting it so the transient
state in this patch is not mistaken for the final one.

> diff --git a/net/rds/rds.h b/net/rds/rds.h
> index b3cc0804156e8..321f2da9e76d9 100644
> --- a/net/rds/rds.h
> +++ b/net/rds/rds.h
> @@ -669,7 +669,9 @@ struct rds_sock {
>  
>  	/*
>  	 * rds_sendmsg caches the conn it used the last time around.
> -	 * This helps avoid costly lookups.
> +	 * This helps avoid costly lookups.  The cache owns a connection
> +	 * reference, dropped when it is replaced or the socket is
> +	 * released, and is read and written under rs_lock.
>  	 */
>  	struct rds_connection	*rs_conn;

This is the contract that rds_release() does not follow, per the comment
on the af_rds.c hunk above.

> diff --git a/net/rds/send.c b/net/rds/send.c
> index 32c411d10e3ef..2d7839438abdc 100644
> --- a/net/rds/send.c
> +++ b/net/rds/send.c
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

[Severity: Medium]
This is a pre-existing issue and not introduced by this patch, but since
the hit predicate is being rewritten here: it compares c_faddr, ToS and
destroy state, and never compares the requested scope_id with
conn->c_dev_if, even though the miss path below passes scope_id as the
dev_if that becomes part of the connection identity.

For a socket bound to a non-link-local IPv6 address, rs_bound_scope_id is
0, and the earlier scope check accepts any non-zero destination scope:

	if (scope_id != rs->rs_bound_scope_id) {
		if (!scope_id) {
			scope_id = rs->rs_bound_scope_id;
		} else if (rs->rs_bound_scope_id) {
			release_sock(sk);
			ret = -EINVAL;
			...
		}
	}

So a send to fe80::x%ifA followed by a send to fe80::x%ifB appears to hit
the cached ifA connection and deliver the second message to the ifA peer,
because the lookup that would distinguish c_dev_if is bypassed.  Would
adding conn->c_dev_if == scope_id to the hit condition be the right fix
here?

The baseline condition omits c_dev_if in exactly the same way, so this
patch does not change the behaviour.

> +	} else {
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

This is the unlocked rs_tos sample discussed on the rds_ioctl() hunk
above.

> @@ -1352,9 +1371,28 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
>  						scope_id);
>  		if (IS_ERR(conn)) {
>  			ret = PTR_ERR(conn);
> +			conn = NULL;
>  			goto out;
>  		}
> +		/* rs_tos was sampled without rs_lock for the create above,
> +		 * and SIOCRDSSETTOS only refuses a change once rs_conn is
> +		 * set, so it can have changed underneath us.  Do not
> +		 * install - or send on - a connection whose ToS no longer
> +		 * matches the socket's; the retry uses the new one.
> +		 */
> +		spin_lock_irqsave(&rs->rs_lock, flags);
> +		if (conn->c_tos != rs->rs_tos) {
> +			spin_unlock_irqrestore(&rs->rs_lock, flags);
> +			ret = -EAGAIN;
> +			goto out;
> +		}
> +		/* hand the cache its own reference */
> +		rds_conn_get(conn);
> +		old = rs->rs_conn;
>  		rs->rs_conn = conn;
> +		spin_unlock_irqrestore(&rs->rs_lock, flags);
> +		if (old)
> +			rds_conn_put(old);
>  	}

Thanks for looking at these.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260917073958.174056-1-achender%40kernel.org
