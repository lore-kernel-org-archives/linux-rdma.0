Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AB5363C48;
	Thu, 17 Sep 2026 09:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789637958; cv=none; b=NKBRKvPpya+WjefkNy6pPCwK7OTlgPDNpwQXcqmbFvyjSDsp0xb0plRmp6VfjXfjtktIfS/X3wK4zukNON5Qz3+FiEp0RnNYVOkL26ROiHucWaEeFFTQ+VfrR/eOTVZm7SVB3YuiQD+lKbqwVcR1ZoGJamEtfmm7sVUAB2njFU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789637958; c=relaxed/simple;
	bh=rdJIskJHloQ5zvSz/RyaaJADEoVfInq2oh0HSTprfpY=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=U0uheeEDUSvkIDoo+PiE/LGLKQq6EDEfmBFiZq1CvK15gYcMSKA0kC7HRleSLJUR8+QFcEKq9lbWs8X/SHvGoz4cmY6ppJYUkT3utQSsPrDOhN3lPelKJv5oINvSbfm934Jbr7DXzJelrLImZCaxuV/wgKq9IL8x7rTn8++zLBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eJKDpmil; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eJKDpmil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E011F0089F;
	Thu, 17 Sep 2026 09:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789637926;
	bh=by51LgKx1ualdSZn8ZpPTBIub+1IdXm2prJNjTtNY/8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=eJKDpmilEqXDxPSuCAkm3aaMlpZlF/yn3/01oOemP8FanIMUtBZkRW3GY3XDXB9rw
	 06hWc2mbPhAwIEF9yvIGiiy/e30ZxlTTMIGYgd4MsPf1+YnC5+yjawBHDRYOslLEqo
	 elBegyLUdb69BRXaPNI4NF9o6eH4dhh21J1+apq+tgJuUp+Y+wT2ewgfQzr7jq+98A
	 vOWymSNwzorVju+fasunBCPLgXR9k0wAw8lUnMhu//QZp8DBiCwKZVfRCiyRPAABv3
	 D2ygPyNlkDfGwdS1U8aYQtyRFve3TmhflxOK663Tpmf7BspI+PmesjVfabYtCP0VGi
	 +XLts9rrZcsmQ==
Subject: Re: [PATCH net-next v3 08/13] net/rds: hold connection references in
 lookup, sockets and c_passive
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Thu, 17 Sep 2026 09:38:45 +0000
Message-ID: <178963792518.22033.13204882874552116749@kernel.org>
In-Reply-To: <20260914033719.138057-9-achender@kernel.org>
References: <20260914033719.138057-9-achender@kernel.org>
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

Critical: 0 · High: 1 · Medium: 1 · Low: 2

- [High] rds_send_probe() (net/rds/send.c:1579-1586) links a probe/pong
  message onto cp->cp_send_queue and takes a connection reference…
- [Medium] The commit message claims the new rs_lock coverage in
  rds_ioctl(SIOCRDSSETTOS) closes the window that "let a racing sendmsg…
- [Low] The comment block documenting rds_conn_lookup()'s contract now
  sits above the newly added rds_conn_passive_locked() helper, which has…
- [Low] struct rds_sock in net/rds/rds.h explicitly enumerates what
  rs_lock protects ("rs_lock protects all these adjacent members before…

--

net/rds: hold connection references in lookup, sockets and c_passive

This patch makes rds_conn_lookup() and __rds_conn_create() return a
connection with a reference held for the caller, gives the rs->rs_conn
sendmsg cache and parent->c_passive references of their own, and moves the
rs_conn/rs_tos serialization from the global rds_sock_lock to rs_lock.  It
also RCU-annotates c_passive and closes a KCSAN-reported data race between
concurrent rds_sendmsg() calls on the same socket.

Closes: https://syzkaller.appspot.com/bug?extid=879c1877016972360186

A few questions below about the new rs_lock discipline, the misplaced
comment block in connection.c, and the interaction between the new
"sender keeps running against a quiesced conn" rule and rds_send_probe().

> diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
> index d5defe9172e3..1cc20b5cfd21 100644
> --- a/net/rds/af_rds.c
> +++ b/net/rds/af_rds.c

[ ... ]

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

[Severity: Medium]

Does this comment (and the matching claim in the commit message, "it used
the unrelated global rds_sock_lock before, which also let a racing sendmsg
cache a connection whose c_tos disagrees with the rs_tos being set") hold
for a sendmsg that is already past its own rs_lock section?

rds_sendmsg() drops rs_lock before it samples rs->rs_tos:

net/rds/send.c:rds_sendmsg() {
	spin_lock_irqsave(&rs->rs_lock, flags);
	conn = rs->rs_conn;
	...
	} else {
		conn = NULL;
	}
	spin_unlock_irqrestore(&rs->rs_lock, flags);

	if (!conn) {
		...
		conn = rds_conn_create_outgoing(sock_net(sock->sk),
						&rs->rs_bound_addr, &daddr,
						rs->rs_transport, rs->rs_tos,
	...
}

and the install re-takes rs_lock without re-checking conn->c_tos against
rs->rs_tos:

		spin_lock_irqsave(&rs->rs_lock, flags);
		old = rs->rs_conn;
		rs->rs_conn = conn;
		spin_unlock_irqrestore(&rs->rs_lock, flags);

So with thread A between the two rs_lock sections (conn == NULL) and
thread B in SIOCRDSSETTOS, B sees rs_tos == 0 && rs_conn == NULL, succeeds
and stores the new tos; A then creates or looks up a connection with the
old tos and caches it.  Can that leave rs->rs_tos == X while
rs->rs_conn->c_tos == 0, and send the in-flight message over a connection
whose service level does not match the socket's configured ToS?

Would snapshotting rs_tos inside the first rs_lock section, or validating
conn->c_tos == rs->rs_tos when installing the cache, close this?

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index c3b3d756c52e..7ef6fb9d352b 100644
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

[Severity: Low]

Was the new helper meant to be inserted above rds_conn_lookup()'s comment
rather than below it?  As written, the "rcu read lock must be held or the
connection spinlock ... a reference is taken on the returned connection"
text now documents rds_conn_passive_locked(), which has neither property:
it asserts rds_conn_lock is held (RCU alone is not enough) and returns the
pointer without any reference.  __rds_conn_create() has to take the
reference itself right after calling it:

			passive = rds_conn_passive_locked(parent);
			...
				rds_conn_get(passive);

Meanwhile rds_conn_lookup(), whose contract this patch actually changes,
ends up with no comment describing that the caller now owns a reference.

> @@ -98,6 +109,17 @@ static struct rds_connection *rds_conn_lookup(struct net *net,
>  		    conn->c_tos == tos &&
>  		    net == rds_conn_net(conn) &&
>  		    conn->c_dev_if == dev_if) {
> +			/* Only ever hand out a live reference.
> +			 * rds_conn_destroy() unhashes under
> +			 * rds_conn_lock and waits a grace period
> +			 * before dropping the initial reference, so
> +			 * an entry this traversal reaches still holds
> +			 * at least that one; the conditional get
> +			 * documents the contract rather than
> +			 * papering over a zero-refcount entry.
> +			 */
> +			if (!kref_get_unless_zero(&conn->c_refcount))
> +				continue;
>  			ret = conn;
>  			break;
>  		}

[ ... ]

> diff --git a/net/rds/rds.h b/net/rds/rds.h
> index 8a969444e698..4608615e09e9 100644
> --- a/net/rds/rds.h
> +++ b/net/rds/rds.h
> @@ -161,7 +161,7 @@ struct rds_connection {
>  	 * cancellation from landing on a destroyed workqueue.
>  	 */
>  	bool			c_destroy_in_prog;
> -	struct rds_connection	*c_passive;
> +	struct rds_connection __rcu *c_passive;
>  	struct rds_transport	*c_trans;

[Severity: Low]

While touching this header, should the struct rds_sock declarations be
updated too?  rs_conn is now both rs_lock-serialized and reference-owning,
but its comment still only says:

	/*
	 * rds_sendmsg caches the conn it used the last time around.
	 * This helps avoid costly lookups.
	 */
	struct rds_connection	*rs_conn;

and rs_lock's own annotation reads:

	/* rs_lock protects all these adjacent members before the newline */
	spinlock_t		rs_lock;

rs_conn sits before that block and rs_tos sits at the very end of the
struct, so the header currently tells a reader that neither is covered by
rs_lock, which is the opposite of the new rule in rds_ioctl() and
rds_sendmsg().

> diff --git a/net/rds/send.c b/net/rds/send.c
> index 32c411d10e3e..1ae1f24c24e8 100644
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

[Severity: High]

The commit message says the connection "may still be destroyed while a
send is in flight ... but it is only quiesced; the free is held off by the
sender's reference."  Given that, can a sender that is already holding this
reference strand a probe message on a path that has already been purged?

rds_sendmsg() reaches the ping path before its own rds_destroy_pending()
re-check:

	if (conn->c_trans->t_mp_capable &&
	    !rds_conn_path_up(&conn->c_path[0])) {
		...
		rds_send_ping(conn, 0);
	}

and rds_send_probe() enqueues under cp_lock with no destroy test at all;
only the work queueing afterwards is guarded:

net/rds/send.c:rds_send_probe() {
	spin_lock_irqsave(&cp->cp_lock, flags);
	list_add_tail(&rm->m_conn_item, &cp->cp_send_queue);
	set_bit(RDS_MSG_ON_CONN, &rm->m_flags);
	rds_message_addref(rm);
	rm->m_inc.i_conn = cp->cp_conn;
	...
	spin_unlock_irqrestore(&cp->cp_lock, flags);
	...
	rcu_read_lock();
	if (!rds_destroy_pending(cp->cp_conn))
		queue_delayed_work(cp->cp_wq, &cp->cp_send_w, 1);
	rcu_read_unlock();
}

rds_conn_path_quiesce() drains cp_send_queue exactly once, and
rds_conn_destroy() runs that pass only once (c_destroy_in_prog guards it):

net/rds/connection.c:rds_conn_path_quiesce() {
	...
	/* tear down queued messages */
	list_for_each_entry_safe(rm, rtmp,
				 &cp->cp_send_queue,
				 m_conn_item) {
		list_del_init(&rm->m_conn_item);
		BUG_ON(!list_empty(&rm->m_sock_item));
		rds_message_put(rm);
	}
	...
}

If the cp_lock section in rds_send_probe() runs after that drain, nothing
reaps the message afterwards - rds_send_xmit() refuses destroy-pending
conns and there is no second purge pass.  Later in the series the same
enqueue also takes a connection reference released only from
rds_message_put() ("put in rds_message_put()"), so at that point does the
stranded probe keep c_refcount from reaching zero, leaving
rds_conn_destroy_fini() unreached and rds_conn_wait_conns_freed() waiting
forever at transport unload or netns teardown?

The sibling enqueue rds_send_queue_rm() does get exactly this guard later
in the series, with rds_conn_path_quiesce() splicing under cp_lock to pair
with it:

		spin_lock(&cp->cp_lock);
		if (rds_destroy_pending(conn)) {
			spin_unlock(&cp->cp_lock);
			*queued = -EAGAIN;
			goto unlock;
		}

Should rds_send_probe() get the same test under cp_lock?  Note the probe
enqueue is also reachable from the receive path, since a peer's probe ping
drives rds_recv_incoming() -> rds_send_pong() -> rds_send_probe().

> +
> +	if (!conn) {
> +		struct rds_connection *old;
> +
>  		conn = rds_conn_create_outgoing(sock_net(sock->sk),
>  						&rs->rs_bound_addr, &daddr,
>  						rs->rs_transport, rs->rs_tos,

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260914033719.138057-1-achender%40kernel.org
