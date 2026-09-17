Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E08E4B1D1E;
	Thu, 17 Sep 2026 09:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789637966; cv=none; b=ojvXnubtqXOwOVbROPHQT0RyImXCT1e5ymnFVSz0FtS5VjQfoJdulk+qIn+j2e5i0zePUtlPenBousGKAbbWJRBkGeGRUlqtGhY150+yXntdGxOrJ1lG0dWj2o/RSxGo1LK5DrgbFqSyfV3t8jRwqXq7Tj2PeLvaqcofH84kvvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789637966; c=relaxed/simple;
	bh=QUpmvb75QffH4FGuExeuwjK9k7paM9HzrNqI2rTlWQ0=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KJiho/3qyQFRQgWnJ2KnIzQVYdP4cZOFZEjEZl9Iy8Zdkw9lR7DCV1D1fvSMj8zX34kxjbYxXjsV5qZ4U2iDEeqkQCNjb30SAfBPbG+EMiUBUe5jHOpGo9lorMFpMS1EhGs+lNXDgOJekVHTgaVm8aCa//fFo1d9nsPuDDVtwYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lMHE0jzR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lMHE0jzR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A810C1F008A2;
	Thu, 17 Sep 2026 09:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789637931;
	bh=/JDSTXj6dC7dCL8agVmD0RJ3CiR8CiIhmpwTlYMcZgk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=lMHE0jzR/f+rft4FCXikjUX3BgyafL3w+buFm825JIRn9sHhdxSetk1TYT72+GH5u
	 mkLJUeC+w3MSzE+ROvKzlBb6XG8u+H3brH7ZbWoiYmNxQwykAJWgdx1m2vzExCUVL1
	 x0Brkg/v6v26q3EfUfQBb9WmSrp8iKUhBjQGwzzjo39MKj4xPwynlaGX77afLY6p+m
	 a7Z+S4b7zBV6nXP32RaZ9m5oF9akCuQ8vgAyy2iDBIXBCX3MF8kU1V4ClxqI9cwFSw
	 j6lYMeheYyDFRAFXBA9uWRoABnL+UmxcrTv4825ClCfRhOxCn8KgjV0RFB3OHxc8F8
	 C6GDne37v0eFQ==
Subject: Re: [PATCH net-next v3 13/13] net/rds: hold a connection reference
 from struct rds_incoming
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Thu, 17 Sep 2026 09:38:50 +0000
Message-ID: <178963793024.22033.1202484658144001606@kernel.org>
In-Reply-To: <20260914033719.138057-14-achender@kernel.org>
References: <20260914033719.138057-14-achender@kernel.org>
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

Critical: 0 · High: 1 · Medium: 0 · Low: 2

- [High] rds_send_probe() (net/rds/send.c) now takes a connection
  reference for rm->m_inc.i_conn (line 1583) while linking the probe…
- [Low] The cross-netns comment in rds_recv_incoming()
  (net/rds/recv.c:424-431) is now factually wrong: it justifies dropping…
- [Low] The commit fixes a KASAN-reported slab-use-after-free
  (rds6_inc_info_copy() via rds_info_getsockopt(), plus a second panic…

--

net/rds: hold a connection reference from struct rds_incoming

This makes every assignment of struct rds_incoming::i_conn take a
connection reference, dropping it from rds_inc_put() for received
messages and from a new rds_message_free() helper for m_inc.  The goal is
to keep a connection allocated while incs that point at it sit on socket
receive or send queues.

Closes: https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.dev@gmail.com/

A question on the trailers before the diff:

> Reported-by: Chengfeng Ye <nicoyip.dev@gmail.com>
> Closes: https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.dev@gmail.com/

[Severity: Low]
The changelog fixes a KASAN-reported slab-use-after-free (rds6_inc_info_copy()
via rds_info_getsockopt(), plus the rds_ib_inc_free()/rds_clear_recv_queue()
panic) and carries Reported-by:/Closes:, but there is no Fixes: tag.

The unreferenced i_conn assignment goes back to bdbe6fbc6a2f ("RDS:
recv.c").  Would adding

  Fixes: bdbe6fbc6a2f ("RDS: recv.c")

be worthwhile so backporters can see which releases are affected, even
with the "This is not a stable candidate" note in the changelog that
explains this particular fix depends on the connection reference counting
added earlier in the series?

> diff --git a/net/rds/recv.c b/net/rds/recv.c
> index 6204e577a90ae..b031c0b43af83 100644
> --- a/net/rds/recv.c
> +++ b/net/rds/recv.c

[ ... ]

> @@ -325,6 +337,13 @@ void rds_recv_incoming(struct rds_connection *conn, struct in6_addr *saddr,
>  	unsigned long flags;
>  	struct rds_conn_path *cp;
>  
> +	/* every caller initialized @inc with rds_inc_init() or
> +	 * rds_inc_path_init() first, so i_conn already holds a reference.
> +	 * Take the new one before dropping the old, so that re-pointing an
> +	 * inc at the connection it already refers to cannot free it.
> +	 */
> +	rds_conn_get(conn);
> +	rds_conn_put(inc->i_conn);
>  	inc->i_conn = conn;
>  	inc->i_rx_jiffies = jiffies;
>  	if (conn->c_trans->t_mp_capable)

[Severity: Low]
Does the cross-netns comment further down in rds_recv_incoming() still
describe the code correctly after this change?  It currently reads:

	/*
	 * rds_find_bound() uses a global (netns-agnostic) hash table.
	 * An RDS connection created in netns A can match a socket bound
	 * in the init netns, delivering inc cross-netns with inc->i_conn
	 * pointing into netns A.  When cleanup_net() then frees that conn,
	 * any subsequent dereference of inc->i_conn is a use-after-free.
	 * Drop the inc if the receiving socket lives in a different netns.
	 */

With i_conn now owning a reference from rds_inc_init()/rds_inc_path_init(),
transferred here and released only after c_trans->inc_free() in
rds_inc_put(), can cleanup_net() -> rds_conn_destroy() still free the
connection while the inc is queued?  The test itself may still be wanted
for netns isolation and because c_net would outlive the freed struct net,
but should the stated rationale be updated?

> diff --git a/net/rds/send.c b/net/rds/send.c
> index 94d6ac174dde8..f59a487b079d5 100644
> --- a/net/rds/send.c
> +++ b/net/rds/send.c

[ ... ]

> @@ -960,6 +962,7 @@ static int rds_send_queue_rm(struct rds_sock *rs, struct rds_connection *conn,
>  		/* The code ordering is a little weird, but we're
>  		   trying to minimize the time we hold c_lock */
>  		rds_message_populate_header(&rm->m_inc.i_hdr, sport, dport, 0);
> +		rds_conn_get(conn);	/* put in rds_message_put() */
>  		rm->m_inc.i_conn = conn;
>  		rm->m_inc.i_conn_path = cp;
>  		rds_message_addref(rm);
> @@ -1577,6 +1580,7 @@ rds_send_probe(struct rds_conn_path *cp, __be16 sport,
>  	list_add_tail(&rm->m_conn_item, &cp->cp_send_queue);
>  	set_bit(RDS_MSG_ON_CONN, &rm->m_flags);
>  	rds_message_addref(rm);
> +	rds_conn_get(cp->cp_conn);	/* put in rds_message_put() */
>  	rm->m_inc.i_conn = cp->cp_conn;
>  	rm->m_inc.i_conn_path = cp;

[Severity: High]
Can this new reference in rds_send_probe() be stranded when the
connection is being destroyed?

rds_send_queue_rm() takes the same kind of reference for the same kind of
enqueue, but tests the destroy predicate under cp_lock first:

	spin_lock(&cp->cp_lock);
	if (rds_destroy_pending(conn)) {
		spin_unlock(&cp->cp_lock);
		*queued = -EAGAIN;
		goto unlock;
	}
	...
	rds_conn_get(conn);	/* put in rds_message_put() */

rds_send_probe() has no such test inside its cp_lock section, and
rds_conn_path_quiesce() drains cp_send_queue exactly once under that same
lock:

net/rds/connection.c:rds_conn_path_quiesce() {
	spin_lock_irqsave(&cp->cp_lock, flags);
	list_splice_init(&cp->cp_send_queue, &purge);
	spin_unlock_irqrestore(&cp->cp_lock, flags);
	list_for_each_entry_safe(rm, rtmp, &purge, m_conn_item) {
		...
		rds_message_put(rm);
	}
}

So if rds_send_probe() acquires cp_lock after that splice, the probe rm is
added to a queue nobody drains again, its RDS_MSG_ON_CONN reference is
never dropped, and the trailing

	rcu_read_lock();
	if (!rds_destroy_pending(cp->cp_conn))
		queue_delayed_work(cp->cp_wq, &cp->cp_send_w, 1);
	rcu_read_unlock();

skips the work, so rds_message_put() never reaches the new
rds_message_free().  Does that leak the struct rds_connection reference
taken above?

The window looks reachable from user context and from remote input:

rds_sendmsg() -> rds_send_ping() -> rds_send_probe()
rds_recv_incoming() -> rds_send_pong() -> rds_send_probe()
rds_tcp_accept_one() -> rds_send_probe()

with the rds_destroy_pending() check in rds_sendmsg() done before the
user data copy, well ahead of the rds_send_ping() call.

If the reference is stranded, does t_conn_count then stay non-zero and
leave rds_conn_wait_conns_freed() looping forever on module unload?

net/rds/connection.c:rds_conn_wait_conns_freed() {
	while (!wait_event_timeout(rds_conn_freed_waitq,
				   !atomic_read(&trans->t_conn_count),
				   msecs_to_jiffies(RDS_CONN_FREE_POLL_MS))) {
	...
}

Would adding the same rds_destroy_pending(cp->cp_conn) test inside
rds_send_probe()'s cp_lock section, before the list_add_tail() and
rds_conn_get(), keep the six reference sites consistent?

The commit message says of the six assignment sites that "each of them now
takes a reference"; should it also say what happens when a probe races
teardown?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260914033719.138057-1-achender%40kernel.org
