Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43721327C08;
	Thu, 10 Sep 2026 01:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789002184; cv=none; b=GymbtOtQMxSmtsYikZqhLuezxfBOom+E8YYpJ7rCklGwEmWsi1+2RpFGXB8STCa+8osAQf18W/+PoFNNi/bLVbOjyj5GZU+uHtE3YAudoug6eZNkyuML3aiTfzSWtkAq/weT9AuHgSWGE/7L9m159e1+B9/023HMOO9woV+vOFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789002184; c=relaxed/simple;
	bh=tsNLJDuZhSipRceswnwHhDRJmSRm0hrBOQDHsfN+Z6c=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iKdb+CimfZAGV7/xwmTCstJo6YyHcHQuPe61OYEk/Obqt0hS/1m0UReYncV0FK1/6YiuyzMgeKR+ajJq0j5cfTN8lSQmo2qJMU4e6cDNTFbH6JvT59CcJH8kjRC+XmpG2EdK3HpQl83PKxDMR9y5ouj0wSAp4ns6Bh2ipB19zaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S85dq2Ae; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S85dq2Ae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606EC1F000FF;
	Thu, 10 Sep 2026 01:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789002182;
	bh=+xsDggvhf7ZM1q9dGc/jKsdUwQCPbGLaEpv1sLYLiRo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=S85dq2AeKAdlIGAM+RoHgnQzw81FDZSg4WU6is5XWof9aG2HYIaE7ngQAOGb3SgMW
	 iuTo7lwbq7TCxUd5PgVc5BU2jmSSuS23gbm7uKjX1vsZiRqpM9GnzAIwLWnpPN6SPt
	 8tNrqB1wdoPLB0LrvDP3w4SNQWDlXi/ycOCLjY3ddZquh00nbqr5lbW4uJhErfGD3z
	 wJqO3eOZ1tLMclrb18R45N4PEfnsWhSWOx8QbIi+KtuhC0W9fXeD8baVLfhxB3xiBr
	 VR8IoOcSw/vaQVxQd4saxS64bDufm7PNUukGuT8Gk+41IeGD6SpRAcjYBqvDic2jIN
	 H3mqdvlgI8kmg==
Subject: Re: [PATCH net-next 1/6] net/rds: make rds_destroy_pending() cover
 single-connection destroy
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Thu, 10 Sep 2026 01:03:01 +0000
Message-ID: <178900218191.219967.11767581907135487885@kernel.org>
In-Reply-To: <20260904070248.160384-2-achender@kernel.org>
References: <20260904070248.160384-2-achender@kernel.org>
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

Critical: 0 · High: 1 · Medium: 1 · Low: 1

- [High] The fix is incomplete against its own stated invariant, so the
  bug class it claims to close stays reachable.
- [Medium] The commit message mischaracterizes which destroy paths this
  patch actually newly guards.
- [Low] The comment on the new struct field misdescribes the write side.

--

net/rds: make rds_destroy_pending() cover single-connection destroy

This adds a per-connection c_destroy_in_prog flag, set in
rds_conn_destroy() before the unhash + synchronize_rcu() sequence and
tested in rds_destroy_pending(), and removes the now-dead
RDS_DESTROY_PENDING cp_flags bit along with its test in
rds_ib_is_unloading().

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
> +	WRITE_ONCE(conn->c_destroy_in_prog, true);

[Severity: High]
Is the claim in this comment that the requeueing sites "all test
rds_destroy_pending() under rcu_read_lock()" accurate for the current
tree?

A grep of the queue_work()/queue_delayed_work() callers under net/rds
turns up several arming sites that never consult the predicate at all,
so the new flag cannot suppress them:

net/rds/ib_send.c:rds_ib_send_cqe_handler()
	if (test_and_clear_bit(RDS_LL_SEND_FULL, &conn->c_flags) ||
	    test_bit(0, &conn->c_map_queued))
		queue_delayed_work(conn->c_path->cp_wq, &conn->c_send_w, 0);

net/rds/ib_send.c:rds_ib_send_add_credits()
	if (test_and_clear_bit(RDS_LL_SEND_FULL, &conn->c_flags))
		queue_delayed_work(conn->c_path->cp_wq, &conn->c_send_w, 0);

net/rds/ib_recv.c:rds_ib_recv_refill()
		queue_delayed_work(conn->c_path->cp_wq, &conn->c_recv_w, 1);

net/rds/tcp_listen.c:rds_tcp_accept_one()
		queue_delayed_work(cp->cp_wq, &cp->cp_recv_w, 0);

net/rds/send.c:rds_sendmsg()
		if (!test_and_set_bit(RDS_RECONNECT_PENDING,
				      &conn->c_path[0].cp_flags))
			queue_delayed_work(conn->c_path[0].cp_wq,
					   &conn->c_path[0].cp_conn_w, 0);

Also, the one rds_destroy_pending(conn) test that rds_sendmsg() does
perform is not inside an RCU read-side section (send.c holds
rcu_read_lock() only around the three cp_send_w arming sites), so
the synchronize_rcu() in rds_conn_destroy() does not order against that
reader either.

Given that, can the window that rds_conn_path_quiesce() already warns
about still end in a crash?  It cancels the works while the path is
still RDS_CONN_UP:

	cancel_delayed_work_sync(&cp->cp_send_w);
	cancel_delayed_work_sync(&cp->cp_recv_w);

	rds_conn_path_drop(cp, true);
	flush_work(&cp->cp_down_w);
	...
	WARN_ON(delayed_work_pending(&cp->cp_send_w));
	WARN_ON(delayed_work_pending(&cp->cp_recv_w));
	WARN_ON(delayed_work_pending(&cp->cp_conn_w));

and teardown then proceeds regardless of the warning to

		destroy_workqueue(cp->cp_wq);
		cp->cp_wq = NULL;

followed by kfree(conn->c_path) in rds_conn_destroy().  An IB send or
receive completion landing in that window re-arms through one of the
unguarded sites above.  With delay 0 and cp_wq already NULL,
__queue_delayed_work() falls through to __queue_work(cpu, NULL, work);
with the delay 1 arming in rds_ib_recv_refill() the timer is invisible
to destroy_workqueue() and delayed_work_timer_fn() later calls
__queue_work(dwork->cpu, dwork->wq, ...) on the destroyed workqueue,
from a timer_list living in the freed c_path array.

Would it make sense to either extend the rcu_read_lock() +
rds_destroy_pending() pattern to those sites (or move the workqueue
teardown behind the transport quiesce), or otherwise to soften the
blanket coverage claim in this comment and in the changelog?

>  
>  	/* Ensure conn will not be scheduled for reconnect */
>  	spin_lock_irq(&rds_conn_lock);
>  	hlist_del_init_rcu(&conn->c_hash_node);
> diff --git a/net/rds/ib.c b/net/rds/ib.c
> index 786f39169bc14..9fe3b9951bd32 100644
> --- a/net/rds/ib.c
> +++ b/net/rds/ib.c
> @@ -525,10 +525,7 @@ static void rds_ib_set_unloading(void)
>  
>  static bool rds_ib_is_unloading(struct rds_connection *conn)
>  {
> -	struct rds_conn_path *cp = &conn->c_path[0];
> -
> -	return (test_bit(RDS_DESTROY_PENDING, &cp->cp_flags) ||
> -		atomic_read(&rds_ib_unloading) != 0);
> +	return atomic_read(&rds_ib_unloading) != 0;
>  }

[Severity: Medium]
Does the changelog describe the right set of paths that this patch newly
guards?  It says:

    rds_conn_destroy() is not limited to the global paths: rds_ib
    destroys connections whose underlying IB device was removed
    (rds_ib_destroy_nodev_conns())

and

    Bring the protection back at the connection level, where it also
    covers the device-removal path that was never guarded

At this revision net/rds/ib.c has no rds_conn_destroy() call at all; the
device removal path (rds_ib_remove_one() / rds_ib_dev_shutdown() /
rds_ib_remove_conn()) only drops connections and moves them onto
ib_nodev_conns.

rds_ib_destroy_nodev_conns() has a single caller, rds_ib_exit(), which
runs before it:

net/rds/ib.c:rds_ib_exit() {
	rds_ib_set_unloading();
	synchronize_rcu();
	...
	rds_ib_unregister_client();
	rds_ib_destroy_nodev_conns();
	...
}

Since rds_ib_is_unloading() is the IB ->t_unloading callback and returns
atomic_read(&rds_ib_unloading) != 0 for the whole of rds_ib_exit(),
wasn't rds_destroy_pending() already true for every conn destroyed on
that path, so the new flag adds nothing there?

That would leave the version-mismatch rds_conn_destroy() in
rds_ib_cm_connect_complete() as the only genuinely unguarded per-conn
destroy, which matches the Fixes: cdc306a5c9cd3 tag.  Could the
changelog be narrowed to that, so stable backport triage does not read
it as "hot-removing an IB device can queue work on a destroyed cp_wq"?

>  
>  void rds_ib_exit(void)
> diff --git a/net/rds/rds.h b/net/rds/rds.h
> index 2db49573dacd5..cede2b03baa50 100644
> --- a/net/rds/rds.h
> +++ b/net/rds/rds.h

[ ... ]

> @@ -148,6 +147,10 @@ struct rds_connection {
>  				c_pad_to_32:29;
>  	int			c_npaths;
>  	bool			c_with_sport_idx;
> +	/* Set (under RCU) when rds_conn_destroy() starts on this conn;
> +	 * read through rds_destroy_pending().
> +	 */
> +	bool			c_destroy_in_prog;

[Severity: Low]
This isn't a bug, but does "Set (under RCU)" match the setter?  The only
write is the plain WRITE_ONCE(conn->c_destroy_in_prog, true) in
rds_conn_destroy(), which is not inside an rcu_read_lock() section; the
RCU involvement is the synchronize_rcu() that follows.

Would it also be worth spelling out the reader-side requirement here,
namely that rcu_read_lock() must be held across both the
rds_destroy_pending() test and the queue_work()/queue_delayed_work()
that follows?  As written, the field comment permits the pattern already
present in rds_sendmsg():

net/rds/send.c:rds_sendmsg() {
	...
	if (rds_destroy_pending(conn)) {
		ret = -EAGAIN;
		goto out;
	}
	...
}

where the predicate is read outside any RCU read section and the
synchronize_rcu() in rds_conn_destroy() fences nothing.

>  	struct rds_connection	*c_passive;
>  	struct rds_transport	*c_trans;
>  
> @@ -994,7 +997,8 @@ void __rds_put_mr_final(struct kref *kref);
>  
>  static inline bool rds_destroy_pending(struct rds_connection *conn)
>  {
> -	return !check_net(rds_conn_net(conn)) ||
> +	return READ_ONCE(conn->c_destroy_in_prog) ||
> +	       !check_net(rds_conn_net(conn)) ||
>  	       (conn->c_trans->t_unloading && conn->c_trans->t_unloading(conn));
>  }

Thanks for looking at these.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260904070248.160384-1-achender%40kernel.org
