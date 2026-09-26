Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4F43AAF42;
	Sat, 26 Sep 2026 09:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790416120; cv=none; b=R55cLNNlRxwl6EoQlUgrcJAK2nlGxcMkDtO1LZMoHMDhUKooPBwPUBHxhFDre66QOmaPMbpo7qV0KEy5S1PpXmxJCDfNVXX9Kam2EHK2PXogaHpCXHG8o5Z2WLx9OtXR4RT9dFuFvMkkstyoYmA5lgSeM4YNQhWn+vzM1YXtkc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790416120; c=relaxed/simple;
	bh=NP71DmWz9VveVrqO5InBeMA6Uj8Y/TjcKEQCOHLKHKk=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bv8eBVfDZP/7xvA3kHdRg0ucLGanMlfx9st8qzvIxxqm/dmWj9KMJEjULFKvbm8I6UMT+PIDIp5lbI8DUz9TRclkh5sUPsuFrb3wcUzhie88s3bUnXyX//6GnPLbmIcyn6GSiwplAv4J8Sf/xraGdHr5FuNAy9HWYRyg2aGdYUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PRxjeMzF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PRxjeMzF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2609C1F000FF;
	Sat, 26 Sep 2026 09:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790416118;
	bh=swoC8YOpHlbFYKyzsGvM9nOKaCLOIOQQ/2YxogmbWss=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=PRxjeMzFPVSDdFzzzKH1etwQEYxGK8oNEFFIQlyDAmqeQiymE0sY9S1lMB8pvyEkl
	 eoFq0RlbBGyfmDZa8aB6hO1Dh1+i0M7DN+jtz/NMiJbaEyTi6L3mu0iw2MWvO57NzR
	 b9ws/jwBlsVtYSgAMHcqzpgoM66kWkxIjOZFvyG64j2zXa4msJpYC1V/Zhvz1RuQrF
	 P8u+0WiUtTlnSqa1mesEi3Eyn69kfFbCs8qS7tOWlkdE4gXzEe0rSxTKjm+7xGl7Qd
	 52obfivJm3vACllRFnf1J29cDU2JDFUe1FW8MwmBrLjcjkC1qn5PmrRQ6g03s8LRcj
	 TTMvqCO48IJFQ==
Subject: Re: [PATCH net-next v6 04/12] net/rds: make rds_destroy_pending()
 report a connection's own destroy
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Sat, 26 Sep 2026 09:48:37 +0000
Message-ID: <179041611766.2160803.9032711960072128883@kernel.org>
In-Reply-To: <20260922085410.391323-5-achender@kernel.org>
References: <20260922085410.391323-5-achender@kernel.org>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 (1) · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The invariant this patch documents is contradicted by in-tree
  arming sites, and the gap covers exactly the future case the commit…
- [Low] Commit message factual error: the justification "Today every
  rds_conn_destroy() does happen on one of those two global paths ... so…

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but it is a
  permanent, repeatable leak of 7 ordered workqueues per loopback…

--

net/rds: make rds_destroy_pending() report a connection's own destroy

This adds a per-connection c_destroy_in_prog flag, set by
rds_conn_destroy() before the unhash plus synchronize_rcu() sequence, and
tests it first in rds_destroy_pending() so the predicate reports a single
connection's own destroy.  The now-unreferenced RDS_DESTROY_PENDING
cp_flags bit and its dead test in rds_ib_is_unloading() are removed.

A few questions below, first about the commit message, then about the
new comments and the surrounding teardown code.

>     Today every rds_conn_destroy() does happen on one of those two global
>     paths - the last single-connection caller, the protocol-version
>     mismatch in rds_ib_cm_connect_complete(), was turned into a drop by
>     commit f97d8c7bab78 ("rds: ib: use rds_conn_drop() on protocol
>     version mismatch") - so the predicate is currently never wrong.

[Severity: Low]
Is "the predicate is currently never wrong" true for the loopback
transport at module unload?  rds_conn_exit() runs the pernet unregister
before the loop transport marks itself unloading:

net/rds/connection.c:rds_conn_exit() {
	rds_loop_net_exit(); /* unregister pernet callback */
	rds_loop_exit();
	...
}

rds_loop_net_exit() -> unregister_pernet_device() runs the .exit hook for
every net still on net_namespace_list, including init_net, so
rds_loop_exit_net() -> rds_loop_kill_conns() -> rds_conn_destroy() runs
with check_net() still true for those conns.

rds_loop_set_unloading() is the only writer of the flag that
t_unloading reports for the loop transport, and it is not called until
rds_loop_exit(), which runs afterwards:

net/rds/loop.c:rds_loop_exit() {
	rds_loop_set_unloading();
	synchronize_rcu();
	...
}

So for those loop connections the pre-patch rds_destroy_pending() is
false exactly while rds_conn_destroy() cancels the path works and calls
destroy_workqueue() on cp_wq, which would make this patch also close a
narrow real window rather than being purely preparatory.  Would it make
sense either to qualify the claim by naming this loop ordering, or to set
the loop unloading flag before unregister_pernet_device()?

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index a96569a3ee9ad..242ca0570a47e 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c
> @@ -579,6 +579,14 @@ void rds_conn_destroy(struct rds_connection *conn)
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
> +

[Severity: Medium]
Is the parenthetical "which all test rds_destroy_pending() under
rcu_read_lock()" accurate?  Two classes of arming sites do not.

rds_conn_path_drop() short-circuits the predicate when destroy is true:

net/rds/connection.c:rds_conn_path_drop() {
	rcu_read_lock();
	if (!destroy && rds_destroy_pending(cp->cp_conn)) {
		rcu_read_unlock();
		return;
	}
	queue_work(cp->cp_wq, &cp->cp_down_w);
	rcu_read_unlock();
}

rds_ib_dev_shutdown() uses exactly that form for every connection on a
device's conn_list:

net/rds/ib.c:rds_ib_dev_shutdown() {
	list_for_each_entry(ic, &rds_ibdev->conn_list, ib_node)
		rds_conn_path_drop(&ic->conn->c_path[0], true);
}

That is the hot-unplugged IB device case the commit message names as a
reason for the new flag, and the new flag does not cover it, while
rds_conn_path_destroy() later does:

net/rds/connection.c:rds_conn_path_destroy() {
	if (cp->cp_wq != rds_wq) {
		destroy_workqueue(cp->cp_wq);
		cp->cp_wq = NULL;
	}
	...
}

The second class is the workers' own requeues, which use neither the
predicate nor an RCU section:

net/rds/threads.c:rds_send_worker() {
		case -EAGAIN:
			rds_stats_inc(s_send_immediate_retry);
			queue_delayed_work(cp->cp_wq, &cp->cp_send_w, 0);
	...
}

The same shape appears for cp_recv_w in rds_recv_worker().  The commit
message calls out the self-requeue exception, but the new comment here
and the new comment on c_destroy_in_prog state the rule without it.

Would it be better to weaken both comments so they name the destroy ==
true and self-requeue exceptions, or to serialize
rds_conn_path_drop(cp, true) against the workqueue teardown so the stated
invariant actually holds?

[Severity: High]
This isn't a bug introduced by this patch, but since rds_conn_destroy()
is being touched here: does this path leak the per-path workqueues of a
loopback-substituted connection?

__rds_conn_create() computes npaths from the caller's transport, then
substitutes the loop transport without recomputing it:

net/rds/connection.c:__rds_conn_create() {
	int npaths = (trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
	...
			trans = &rds_loop_transport;
	...
	conn->c_trans = trans;
	...
	for (i = 0; i < npaths; i++) {
		...
		conn->c_path[i].cp_wq =
			alloc_ordered_workqueue("krds_cp_wq#%lu/%d", 0,
						rds_conn_count, i);
	...
}

rds_tcp_transport sets both t_prefer_loopback and t_mp_capable, so npaths
is 8 and eight ordered workqueues are allocated.  rds_loop_transport sets
neither, so the destroy side recomputes 1:

net/rds/connection.c:rds_conn_destroy() {
	int npaths = (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
	...
	for (i = 0; i < npaths; i++) {
		cp = &conn->c_path[i];
		rds_conn_path_destroy(cp);
	...
	kfree(conn->c_path);
	...
}

Paths 1 through 7 never reach destroy_workqueue(cp->cp_wq), and
kfree(conn->c_path) then drops the only pointers to those seven
workqueue_structs, which stay on the global workqueue list.

Note that just fixing npaths does not appear to be enough, because
rds_loop_conn_alloc() only fills c_path[0].cp_transport_data and
rds_conn_path_destroy() returns early:

net/rds/connection.c:rds_conn_path_destroy() {
	if (!cp->cp_transport_data)
		return;
	...
}

so the cp_wq teardown would also have to move out of that guard.

Trigger: in a netns, create an AF_RDS socket, bind a local address and
sendmsg() to a local RDS address so the loop substitution applies, then
destroy the netns (rds_loop_exit_net() -> rds_loop_kill_conns() ->
rds_conn_destroy()) or unload rds.  Each such connection destroy leaks
seven workqueues.

This also survives to the end of the series: rds_conn_destroy_fini() uses
the same npaths formula and rds_conn_path_free() keeps the
!cp->cp_transport_data early return.

>  	/* Ensure conn will not be scheduled for reconnect */
>  	spin_lock_irq(&rds_conn_lock);
>  	hlist_del_init_rcu(&conn->c_hash_node);

[ ... ]

> diff --git a/net/rds/rds.h b/net/rds/rds.h
> index 2db49573dacd5..50b08c28ab865 100644
> --- a/net/rds/rds.h
> +++ b/net/rds/rds.h
> @@ -148,6 +147,14 @@ struct rds_connection {
>  				c_pad_to_32:29;
>  	int			c_npaths;
>  	bool			c_with_sport_idx;
> +	/* Set once, by rds_conn_destroy(), before it cancels the path
> +	 * works; read through rds_destroy_pending().  A site that arms
> +	 * a path work must test the predicate and queue the work inside
> +	 * one rcu_read_lock() section: the synchronize_rcu() that
> +	 * follows the store is what keeps a queue issued after the
> +	 * cancellation from landing on a destroyed workqueue.
> +	 */
> +	bool			c_destroy_in_prog;

This is the second half of the comment question above: the rule stated
here as unconditional is not followed by rds_conn_path_drop(cp, true) or
by the rds_send_worker()/rds_recv_worker() retry requeues.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260922085410.391323-1-achender%40kernel.org
