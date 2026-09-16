Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931943B19B9;
	Wed, 16 Sep 2026 04:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789533411; cv=none; b=L6I0IacN/8Hw5BLnOSWMua+8zZwJxPGE59yTcXexAeR4ihOCP/dTyA4SnBi3IAx7jtxQmdEni4vqtqMgunFQ+wcKau5o42WysX7JwivWDPh53La7bWblhYik+bb7bioNQ+0Tm4fdkw2Yz8WIw8kH9D9/M5Hnx6cJKRYS9DWn+jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789533411; c=relaxed/simple;
	bh=a71B0cGTp44cuvUYe2PHP6TcWZ3LXhMrjM0PNMKTMaE=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=N8AA4NkLkFey8CsQKIFLzywqcWi8ZIvAQvlfhkpC5UbASpoB+9qeAY2IxV9WIZF6V0b6CmK4iqBvcPuOX51sZ9F99WF1agHjz9h12L42AzBYhmu1yUNyfnu2W/qBaOQVFaV2Srbb3U9VsFPeLuPhDbPQKwmNcChEJWG0K6rnn0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C68Vxh/+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C68Vxh/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136161F00898;
	Wed, 16 Sep 2026 04:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789533409;
	bh=6cu0RP23P9p2rSvmRnsN507S19ylICnkMvax7f3Fs5s=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=C68Vxh/+jyImOKuP85ROZr3tGqrekMJgDLlZa1UHdTRhOrEgWqaSppLMvFGOlhQQj
	 m+zaY4KaLReoAv2Ox6zpvw/ux9Vcil0900ZRyBtO+eAx//haVRnRFrXRiFftKDl/K2
	 YvNkbhfoGuwAouqdvF9OuXLfdpyu7u1Qzz2iJhP7wrfT5E4bfHXGb4uITK0cPtdDpF
	 5CBRzuedohKJbp4xAXEiA3zPpAClBIi6idfcDzw+5ylnxeS32QzGQZHLEE6dsnTP7D
	 n9MJ76BsiDd/GXK7QbAjk77JYZW4EhShWz3ZqvvwDH2hRXv5U5jE2ewOfUYuRNvLmK
	 L7edRZk6P97Sw==
Subject: Re: [PATCH net-next v2 6/9] net/rds: hold connection references in
 lookup, sockets and c_passive
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Wed, 16 Sep 2026 04:36:48 +0000
Message-ID: <178953340862.22033.2159606586237246481@kernel.org>
In-Reply-To: <20260912035027.27447-7-achender@kernel.org>
References: <20260912035027.27447-7-achender@kernel.org>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 5 potential
issue(s) to consider:

Critical: 0 · High: 1 · Medium: 1 · Low: 3 (1)

- [High] Linked-list corruption in cp_send_queue because
  rds_conn_path_quiesce() mutates it without holding cp_lock, racing…
- [Medium] rds_sendmsg() samples rs->rs_tos outside rs_lock when it
  creates a connection and then installs that connection into…
- [Low] The SIOCRDSSETTOS writer of rs->rs_tos was moved from the global
  rds_sock_lock to rs->rs_lock, but the SIOCRDSGETTOS reader a few lines…
- [Low] The reference-ownership contract comment for rds_conn_lookup()
  ends up documenting the wrong function.
- [Low] struct rds_sock in net/rds/rds.h still documents rs_conn only as
  "rds_sendmsg caches the conn it used the last time around.

Pre-existing issues:
- [Low] cm_id->context still carries no connection reference after this
  patch: rds_ib_cm_handle_connect() publishes conn through…

--

net/rds: hold connection references in lookup, sockets and c_passive

This makes rds_conn_lookup() and __rds_conn_create() hand back a held
reference, gives the rs->rs_conn sendmsg cache and parent->c_passive
references of their own, and serializes the rs_conn cache under rs_lock.
c_passive becomes RCU-annotated, and the SIOCRDSSETTOS ioctl is switched
from the global rds_sock_lock to rs_lock.

Closes: https://syzkaller.appspot.com/bug?extid=879c1877016972360186

> diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
> index d5defe9172e36..63baac8aeb2d1 100644
> --- a/net/rds/af_rds.c
> +++ b/net/rds/af_rds.c

[ ... ]

> @@ -267,13 +276,18 @@ static int rds_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
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
>  	case SIOCRDSGETTOS:
>  		spin_lock_bh(&rds_sock_lock);

[Severity: Low]
The SIOCRDSSETTOS store of rs->rs_tos moves to rs->rs_lock here, but the
SIOCRDSGETTOS branch just below still reads it under the global lock:

	case SIOCRDSGETTOS:
		spin_lock_bh(&rds_sock_lock);
		tos = rs->rs_tos;
		spin_unlock_bh(&rds_sock_lock);

After this change the writer holds only rs_lock and the reader holds only
rds_sock_lock, so the two ioctl branches no longer exclude each other and
the rds_sock_lock in the getter no longer protects anything.

rs_tos is a u8, so the value returned is either the old or the new one,
but should the getter take rs->rs_lock as well, or read rs_tos with
READ_ONCE() and drop the lock?

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index 5848dd295911a..1ec141d6faa38 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c
> @@ -81,7 +81,18 @@ static struct hlist_head *rds_conn_bucket(const struct in6_addr *laddr,
>  		var |= RDS_INFO_CONNECTION_FLAG_##suffix;	\
>  } while (0)
>  
> -/* rcu read lock must be held or the connection spinlock */
> +/* rcu read lock must be held or the connection spinlock.
> + * On success a reference is taken on the returned connection; the
> + * caller must drop it with rds_conn_put().
> + */
> +/* c_passive is written under rds_conn_lock and read under RCU */
> +static struct rds_connection *
> +rds_conn_passive_locked(struct rds_connection *conn)
> +{
> +	return rcu_dereference_protected(conn->c_passive,
> +					 lockdep_is_held(&rds_conn_lock));
> +}
> +
>  static struct rds_connection *rds_conn_lookup(struct net *net,
>  					      struct hlist_head *head,
>  					      const struct in6_addr *laddr,

[Severity: Low]
Did the new helper end up in between the contract comment and the
function it describes?

As written, the comment saying "rcu read lock must be held or the
connection spinlock" and "On success a reference is taken on the returned
connection; the caller must drop it with rds_conn_put()" now sits directly
above rds_conn_passive_locked(), which takes no reference and requires
rds_conn_lock specifically via
rcu_dereference_protected(conn->c_passive, lockdep_is_held(&rds_conn_lock)).

rds_conn_lookup(), the function whose contract this patch actually changes
to return a held reference, is left with no comment of its own.

Both existing callers of rds_conn_passive_locked() hold rds_conn_lock and
do not put the result, i.e. the opposite of what the comment above it now
says. Would moving the reference-ownership comment back down to
rds_conn_lookup() be clearer?

[ ... ]

> diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
> index de5759c50b89a..01e4b4be979d2 100644
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

[Severity: Low]
This isn't a bug introduced by this patch, but does this comment agree
with the commit message?

The comment states the conn is safe without a reference because
"connection destroy shuts the cm_id down before the conn is freed", while
the commit message says the opposite is still true for now:

    cm_id->context still carries no reference of its own after this
    patch; the following patch pins the connection for the duration of
    the CM event handler.

The bare cm_id->context pointer predates this commit, and this hunk
narrows the window by holding a reference for the body of
rds_ib_cm_handle_connect(). The remaining consumers,
rds_ib_cm_initiate_connect() and rds_rdma_cm_event_handler_cmn(), read
cm_id->context and hold conn->c_cm_lock (which lives in the connection's
c_path array) across the transport callbacks without pinning the conn, and
the following patch in the series adds rds_conn_get_unless_zero() /
rds_conn_put() around exactly that.

Could the comment be reworded as a known temporary gap closed by the next
patch, so that someone bisecting or backporting this commit alone is not
misled?

[ ... ]

> diff --git a/net/rds/send.c b/net/rds/send.c
> index 32c411d10e3ef..1ae1f24c24e8c 100644
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

[Severity: High]
With rds_sendmsg() now holding its own reference for the duration of
the call, the commit message is explicit that a connection can be
destroyed under a live sender and that "it is only quiesced; the free
is held off by the sender's reference".  That is the window I am
worried about: the free is indeed held off, but the quiesce itself
mutates state the sender is still using.

rds_conn_destroy() calls rds_conn_path_quiesce() for each path, which
walks and empties cp->cp_send_queue with list_for_each_entry_safe() /
list_del_init(&rm->m_conn_item) and no lock at all, while
rds_send_queue_rm() in net/rds/send.c does

	spin_lock(&cp->cp_lock);
	...
	list_add_tail(&rm->m_conn_item, &cp->cp_send_queue);
	set_bit(RDS_MSG_ON_CONN, &rm->m_flags);
	spin_unlock(&cp->cp_lock);

on the same list head.  Two writers to one list with no common lock is
linked-list corruption, and the rds_destroy_pending(conn) test
rds_sendmsg() does before queueing does not close it: nothing holds
cp_lock across that test and the later list_add_tail(), and a
non-blocking sender can sit in wait_event_interruptible_timeout()
waiting for queue space and only wake up to queue its rm after
rds_conn_path_quiesce() has already drained the queue.  The mildest
outcome is an rm stranded on a queue nobody will ever drain, leaking
the message and its RDS_MSG_ON_CONN reference; the
BUG_ON(!list_empty(&cp->cp_retrans)) that rds_conn_destroy() runs
immediately after the quiesce loop is one plausible way for the
damage to become visible.

This is pre-existing in the sense that rds_conn_destroy() has always
run without excluding senders, but before this patch a sender could
not legitimately keep operating on a conn whose destroy had begun -
this patch makes that a documented, expected state, so the locking
ought to be made to match.

Should rds_conn_path_quiesce() splice cp->cp_send_queue under
cp->cp_lock and drop the message references outside the lock, and does
rds_send_queue_rm() additionally need to re-test
rds_destroy_pending(cp->cp_conn) under cp_lock so that no rm can be
queued after the drain has run?  Note the quiesce also frees
cp->cp_xmit_rm, which is owned by whoever holds RDS_IN_XMIT, so some
coordination with the xmit path looks necessary as well.  What is the
intended locking rule for cp_send_queue during teardown?

[Severity: Medium]
Is the SIOCRDSSETTOS window really closed by the rs_lock conversion?

rs->rs_tos is sampled here with no lock held, as an argument to
rds_conn_create_outgoing(), and that call can sleep in
kmem_cache_zalloc() / alloc_ordered_workqueue().

Starting from a socket with rs_tos == 0 and rs_conn == NULL:

thread A, rds_sendmsg()
	spin_lock_irqsave(&rs->rs_lock, flags);
	conn = rs->rs_conn;		/* NULL */
	spin_unlock_irqrestore(&rs->rs_lock, flags);
	conn = rds_conn_create_outgoing(..., rs->rs_tos /* 0 */, ...);

thread B, rds_ioctl(SIOCRDSSETTOS)
	spin_lock_irqsave(&rs->rs_lock, flags);
	if (rs->rs_tos || rs->rs_conn) {	/* both still 0/NULL */
		...
	}
	rs->rs_tos = tos;		/* succeeds */

thread A then publishes and uses the conn it created with c_tos == 0:

	rds_conn_get(conn);
	spin_lock_irqsave(&rs->rs_lock, flags);
	old = rs->rs_conn;
	rs->rs_conn = conn;
	spin_unlock_irqrestore(&rs->rs_lock, flags);

The install path never re-reads rs->rs_tos, so userspace is told the new
ToS was accepted while the in-flight datagram goes out on the old traffic
class, and rs_conn transiently holds a connection whose c_tos disagrees
with rs_tos until the next sendmsg fails the cache-hit test.

That makes the comment added to rds_ioctl() ("so a racing sendmsg cannot
cache a conn whose c_tos then disagrees with rs_tos") and the matching
commit message claim read as stronger than what the code enforces. Would
re-checking rs_tos == conn->c_tos under rs_lock at install time (or
capturing rs_tos under rs_lock and rejecting the install on mismatch)
close this?

[Severity: Low]
Should struct rds_sock in net/rds/rds.h be updated along with this?

rs_conn is still described only as a lookup cache, and it sits above the
block that declares what rs_lock covers:

	/*
	 * rds_sendmsg caches the conn it used the last time around.
	 * This helps avoid costly lookups.
	 */
	struct rds_connection	*rs_conn;

	/* flag indicating we were congested or not */
	int			rs_congested;
	/* seen congestion (ENOBUFS) when sending? */
	int			rs_seen_congestion;

	/* rs_lock protects all these adjacent members before the newline */
	spinlock_t		rs_lock;

After this patch rs_conn is serialized by rs->rs_lock in rds_sendmsg() and
rds_ioctl(), and it owns a connection reference dropped in rds_release()
and when the cache is replaced, but neither fact is recorded in the
header. Following the annotation as it stands would suggest rs_conn is an
unlocked, non-owning cache.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260912035027.27447-1-achender%40kernel.org
