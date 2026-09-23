Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C235644210C;
	Wed, 23 Sep 2026 07:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790147505; cv=none; b=bvcHTxnaGQOLs5Bq5nySivU5uR+p+aY1bFnmsJ4XHLueLjoIMQQ4e/ymzRdQj1t2jzh4iIL3QoYyIMN9dV3u2023ZxN3UT2bC+6Ab/N9iRep90RVoaA0JXcgmHPDAjfPHIrcn/Wd3Z3oEJMsyxKbzF0/cbniqsxCgbC+hVJB2sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790147505; c=relaxed/simple;
	bh=PWsjQYOVx8JZiHPrZ+XSlYfOCEvgb4z2wnu22O48aE4=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VN6a5PG8bozHdWc1ikpAXF5m4k1uL8X1EUFygrM8y/NJtpeC3EbqKM0MpGvVVVW9FfYvo/gpErtiMqMBAZsmSqvIfwZudj/w2EhtUviqsIL/nS977nJV7UugXPR6916uqjMej4Hnh894wet1xT53/e4KJMVQx70Hl8vOz4VoBms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CXsAWgyD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CXsAWgyD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF001F00899;
	Wed, 23 Sep 2026 07:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790147500;
	bh=F65di/2dZ4E04mCJoYKeuV6gydd+NLXXcTKK1chYAoc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=CXsAWgyD6O6TcyKftAQJzTyhl0F90sKNHNZBg4upQz8B4qJRXz6o6BYF7mi7Y+6uX
	 PAYc/4Ml7Ux4n7oYdNTx9qvtIBAWEZh3HqViAXYXMv9o3JST+I95yZkDyx01L83j9f
	 99rYNcVmE5bczJa/ilAuVO1cEbsK52VPA6R3a2uomYcQ5TYfus0sCzuv7ruuYbU1Mu
	 0gFWNefOUagSTXHHf5jP6TWPxTxEc5JKVKkmsn2TimtiwM/T8u7X0++ZOoI5wJ9QyV
	 ix1koQsedSNM8pH2EygeTChFujgciQZqSFx4BjeVQrpFTcv70va2xQwUJtB0e8fCdq
	 Qap0/r5mNSVtQ==
Subject: Re: [PATCH net-next v5 08/12] net/rds: hold connection references in
 lookup, sockets and c_passive
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Wed, 23 Sep 2026 07:11:39 +0000
Message-ID: <179014749955.2160803.18068715836417249381@kernel.org>
In-Reply-To: <20260919061149.250658-9-achender@kernel.org>
References: <20260919061149.250658-9-achender@kernel.org>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 5 potential
issue(s) to consider.

Critical: 0 · High: 0 (1) · Medium: 1 · Low: 4

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] rds_sendmsg() detects a cached connection whose destroy has
  begun but never drops it from the cache: only the local variable…
- [Low] The commit fixes a syzbot-reported KCSAN data race on rs->rs_conn
  but carries no Fixes: tag (only Reported-by: and Closes:).
- [Low] The patch documents rs_conn in struct rds_sock as "read and
  written under rs_lock" and converts rds_ioctl(SIOCRDSSETTOS/GETTOS) to…
- [Low] The comment on c_destroy_in_prog in struct rds_connection states
  the flag is "read through rds_destroy_pending()", but this patch adds…
- [Low] rds_sendmsg() still performs a plain, unlocked read of rs->rs_tos
  when it passes the ToS to rds_conn_create_outgoing(), while…

Pre-existing issues:
- [High] __rds_conn_create() derives npaths from the caller-supplied
  transport before it may switch trans to &rds_loop_transport, but…

--

net/rds: hold connection references in lookup, sockets and c_passive

This patch makes every escaping struct rds_connection pointer carry a real
reference: rds_conn_lookup() and __rds_conn_create() hand one to the caller,
the rs->rs_conn sendmsg cache owns one, and parent->c_passive owns one and
becomes RCU-annotated. It also serializes the rs_conn cache under rs_lock,
which closes a syzbot-reported KCSAN data race between concurrent
rds_sendmsg() calls.

Closes: https://syzkaller.appspot.com/bug?extid=879c1877016972360186

>     Reported-by: syzbot+879c1877016972360186@syzkaller.appspotmail.com
>     Closes: https://syzkaller.appspot.com/bug?extid=879c1877016972360186

[Severity: Low]

A syzbot-reported KCSAN race is being fixed here, but the trailer block has
only Reported-by: and Closes: and no Fixes: tag.

The commit message does already explain the reasoning:

    This is not a stable candidate on its own: it depends on the
    connection reference counting introduced by the preceding patches,
    and the race it closes needs a connection destroyed under a live
    socket, which takes netns teardown, module unload or device removal.

Is that intended to stand in for the missing Fixes: tag, or would a Fixes:
plus an explicit "not for stable" note be preferred here?

> diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
> index d5defe9172e3..1cc20b5cfd21 100644
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
>  	spin_lock_bh(&rds_sock_lock);
>  	list_del_init(&rs->rs_item);
>  	spin_unlock_bh(&rds_sock_lock);
> @@ -255,6 +263,7 @@ static int rds_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
>  {
>  	struct rds_sock *rs = rds_sk_to_rs(sock->sk);
>  	rds_tos_t utos, tos = 0;
> +	unsigned long flags;
>  
>  	switch (cmd) {
>  	case SIOCRDSSETTOS:
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

[ ... ]

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index 1d48da1a794f..965d68e51a1c 100644
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

The kerneldoc-style comment on c_destroy_in_prog in struct rds_connection
says the flag is "read through rds_destroy_pending()", but three new sites
here read the raw flag instead:

	conn = rcu_dereference(parent->c_passive);
	if (conn && READ_ONCE(conn->c_destroy_in_prog))

	if (READ_ONCE(parent->c_destroy_in_prog)) {

	if (READ_ONCE(passive->c_destroy_in_prog)) {

The distinction looks deliberate, since rds_destroy_pending() also reports
netns teardown and module unload, which these sites do not want.

Could the comment in rds.h be updated to describe the narrower "this conn's
destroy has begun" read, so a later reader does not convert these sites to
the helper?

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

[ ... ]

> @@ -672,6 +744,9 @@ EXPORT_SYMBOL_GPL(rds_conn_put);
>  void rds_conn_destroy(struct rds_connection *conn)
>  {
>  	int i;
> +	struct rds_connection *passive, *parent;
> +	struct hlist_head *head;
> +	bool was_passive = false;
>  	struct rds_conn_path *cp;
>  	int npaths = (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
                     ^^^^

[Severity: High]

This isn't a bug introduced by this patch - baseline 8830e65 has the same
mismatch - but since the series rewrites these teardown functions, is the
npaths derivation here still correct for loopback-converted connections?

__rds_conn_create() computes npaths from the transport the caller passed in,
before it may switch trans:

	int npaths = (trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
	...
			trans = &rds_loop_transport;
	...
	conn->c_trans = trans;
	for (i = 0; i < npaths; i++) {
		...
		conn->c_path[i].cp_wq = alloc_ordered_workqueue(...);

For an outgoing RDS/TCP send to a local address, rds_tcp_transport has both
t_mp_capable and t_prefer_loopback set, so npaths is RDS_MPATH_WORKERS and
8 ordered workqueues are allocated, but c_trans ends up as
rds_loop_transport, whose t_mp_capable is 0.

rds_conn_destroy() and rds_conn_destroy_fini() then recompute npaths from
conn->c_trans and get 1, so only path 0 is quiesced and freed before
kfree(conn->c_path) drops the pointers to the other 7 workqueues.

rds_conn_path_free() also returns early for paths without transport data:

	if (!cp->cp_transport_data)
		return;

	if (cp->cp_wq != rds_wq) {
		destroy_workqueue(cp->cp_wq);

and rds_loop_conn_alloc() only populates path 0 (c_transport_data is a macro
for c_path[0].cp_transport_data), so even a corrected npaths would still skip
destroy_workqueue() for paths 1..7.

Can this leak 7 workqueues per loopback TCP connection, repeatable via
create netns / send to 127.0.0.1 / exit netns?

Note the rollback path in __rds_conn_create() uses the local, pre-switch
npaths and no transport-data gate:

		for (i = 0; i < npaths; i++)
			if (free_cp[i].cp_wq != rds_wq)
				destroy_workqueue(free_cp[i].cp_wq);

which suggests the two derivations are not interchangeable.

[ ... ]

> diff --git a/net/rds/rds.h b/net/rds/rds.h
> index b3cc0804156e..321f2da9e76d 100644
> --- a/net/rds/rds.h
> +++ b/net/rds/rds.h

[ ... ]

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

[Severity: Low]

The new text says rs_conn "is read and written under rs_lock", and
rds_ioctl(SIOCRDSSETTOS/SIOCRDSGETTOS) now relies on that. But rds_release()
in net/rds/af_rds.c reads it, puts it and stores NULL with no lock held:

	if (rs->rs_conn) {
		rds_conn_put(rs->rs_conn);
		rs->rs_conn = NULL;
	}

That looks safe today because rds_release() runs after the last fd reference
is gone, so no concurrent rds_sendmsg()/rds_ioctl() is possible. Could the
comment note that release-time exception?

Related: rs_tos is now read and written under rs_lock by both ioctls and read
under rs_lock by rds_sendmsg(), yet the "rs_lock protects all these adjacent
members before the newline" comment below only spans rs_send_queue through
rs_notify_queue. Should rs_tos (and rs_conn) be listed as rs_lock-protected
there?

> diff --git a/net/rds/send.c b/net/rds/send.c
> index 32c411d10e3e..2d7839438abd 100644
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

[Severity: Medium]

Does the code actually drop the destroy-pending connection from the cache?

The commit message says "sendmsg drops it and looks up or creates a live
one", and the comment above says "dropping it here lets the next sendmsg look
up or create a live one". But when rds_destroy_pending(conn) is true, only
the local variable is cleared:

	conn = rs->rs_conn;
	if (conn && ... && !rds_destroy_pending(conn)) {
		rds_conn_get(conn);
	} else {
		conn = NULL;
	}

rs->rs_conn still points at the quiesced connection and still owns the
reference this patch gave it. The cache is only replaced further down, after
a successful create and a passing ToS re-check:

	rds_conn_get(conn);
	old = rs->rs_conn;
	rs->rs_conn = conn;
	spin_unlock_irqrestore(&rs->rs_lock, flags);
	if (old)
		rds_conn_put(old);

So if rds_conn_create_outgoing() fails with -ENOMEM, or the ToS re-check
returns -EAGAIN, or the socket simply never sends again after an IB device
removal quiesced the connection, doesn't the destroyed conn stay pinned by
rs->rs_conn until rds_release()?

That would keep the conn slab object, its c_path array, its per-path ordered
workqueues, the transport per-connection state and the elevated
trans->t_conn_count alive for the socket's lifetime.

Would clearing rs->rs_conn and calling rds_conn_put() on it right where
rds_destroy_pending() is observed, still under rs_lock, match the described
behaviour?

> +
> +	if (!conn) {
> +		struct rds_connection *old;
> +
>  		conn = rds_conn_create_outgoing(sock_net(sock->sk),
>  						&rs->rs_bound_addr, &daddr,
>  						rs->rs_transport, rs->rs_tos,
                                                                ^^^^^^^^^^

[Severity: Low]

This read of rs->rs_tos is a plain access with no lock held, while
rds_ioctl(SIOCRDSSETTOS) does a plain store under rs_lock:

	spin_lock_irqsave(&rs->rs_lock, flags);
	if (rs->rs_tos || rs->rs_conn) {
		spin_unlock_irqrestore(&rs->rs_lock, flags);
		return -EINVAL;
	}
	rs->rs_tos = tos;

On a first send, rs_conn is NULL, so the ioctl does not refuse the change and
both accesses can run concurrently. Isn't that still a KCSAN-reportable data
race on rs_tos, in a patch whose purpose is removing such a race on the
adjacent rs_conn?

The locked re-check below keeps a stale-ToS connection from being installed
or used, so the effect looks limited to the report itself. Would taking the
rs_tos snapshot under rs_lock (or with READ_ONCE()) and keeping the re-check
close it?

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

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260919061149.250658-1-achender%40kernel.org
