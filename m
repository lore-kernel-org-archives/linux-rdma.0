Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9C9383C94;
	Thu, 27 Aug 2026 18:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787853742; cv=none; b=sTJqGolJ407Fhw+1ZuB1Pba8l0NhsQSnCVyxDnZ0a90NiievwDqDSe07e/D0c4ocHcO3+g5ipqPvrBSBB8IObHjzIX0ZcLUlslceL3wAQ2f/I5gxQTfIQUz7henDh+ag1vY91mVDVMSDt8xi9enKiHVRYzq3yxmhO2HBL0lWQTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787853742; c=relaxed/simple;
	bh=BBH6YHZbr0IWB12YXcqDL9nFpWtkd8KRHbmM/72PwKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDPwHqI6lFSbflhSNErUNxxhlgDlfEEFYjeeA8dVFx19kWn4VbAOFBMxCpZxYFNQl0lVEoWwWYKDy5tjX6YJT1cPHXV5rZry7fejH3sHUkyF+hanhxyB3lOY2Or72yKsDIwLYUbvzOs6suunXbyVH9SQR+7maaV1RsulDk9eziM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mT7zBVT7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mT7zBVT7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88401F00A3A;
	Thu, 27 Aug 2026 18:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787853741;
	bh=3RXjlkUBElxi8M9lYVLDnMXpQgNF0CfbcmVYQ7q+mLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mT7zBVT7MaCx6Cyb5aLHzCdogHhl8wpZcLbkhpQ/t7EDI3UL/5IYbP7PLAZsnwOJA
	 WR/s1unofK0MgGhNYtdNhultEb81BY1l9FUxL2L9FQEO7H9NfXxhxWknnxiAr0Chiw
	 rIk8bxX4xZYQtoPZtVnV90npVH3HfWnwWzEa8dhag18SlWkq0CFUG/yszZrzEP4a9Z
	 7obsYf6Zl5puG0YZW6gmkkKByP465+uLN0+2wi1KU3whhdyoPwmCLWkUKGDbeepypG
	 nPuRQWeCgPVF+xfRJJKHl280cMdYl4lepw4ezanyhwxHk2wDOEBzqWMP9EM2tN6cCP
	 ISDTTpiPRuktg==
From: Jakub Kicinski <kuba@kernel.org>
To: achender@kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	jhubbard@nvidia.com,
	woni9911@gmail.com,
	michal.kubiak@intel.com,
	leon@kernel.org
Subject: Re: [PATCH net v4 6/7] net/rds: acquire the fastpath locks in rds_conn_shutdown()
Date: Thu, 27 Aug 2026 11:02:20 -0700
Message-ID: <20260827180220.3951003-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260824003759.127353-7-achender@kernel.org>
References: <20260824003759.127353-7-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
net/rds: acquire the fastpath locks in rds_conn_shutdown()

This changes rds_conn_shutdown() from waiting for RDS_IN_XMIT and
RDS_RECV_REFILL to be observed clear into acquiring both bits as locks,
holding them across the transport shutdown and rds_conn_path_reset(), and
releasing them with clear_bit_unlock() plus a wake-up.  Related comments in
rds_send_xmit(), rds_ib_recv_refill() and rds_tcp_reset_callbacks() are
updated to describe the new ownership rules.

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index 46ac72088f842..fbbac55a0e818 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c

[ ... ]

> @@ -414,14 +417,35 @@ void rds_conn_shutdown(struct rds_conn_path *cp)
>  		}
>  		mutex_unlock(&cp->cp_cm_lock);
>  
> +		/* Quiesce the transmit and receive-refill paths by
> +		 * acquiring their bit locks, not merely waiting for
> +		 * them to be released: with a plain wait, either path
> +		 * can re-take its lock the instant after we sample it
> +		 * clear and then run concurrently with the transport
> +		 * shutdown and the path reset below.  Holding both
> +		 * locks across the teardown makes that structurally
> +		 * impossible.
> +		 */
>  		wait_event(cp->cp_waitq,
> -			   !test_bit(RDS_IN_XMIT, &cp->cp_flags));
> +			   !test_and_set_bit_lock(RDS_IN_XMIT, &cp->cp_flags));

[Severity: Medium]

How long can this ownership window be in practice?  Both bits are now held
across conn->c_trans->conn_path_shutdown(), which blocks.  For TCP that is
the drain loop in rds_tcp_conn_path_shutdown():

	} while (!wait_event_timeout(tc->t_recv_done_waitq,
				(sk->sk_state == TCP_CLOSING || ...) &&
				skb_queue_empty_lockless(&sk->sk_receive_queue),
				msecs_to_jiffies(100)) &&
			 ++rounds < 50);

which is the up to ~5 s the changelog mentions, with the exit condition
driven by the peer's TCP state and receive queue.

For IB, rds_ib_conn_path_shutdown() has no iteration cap:

	while (!wait_event_timeout(rds_ib_ring_empty_wait,
				   rds_ib_conn_path_shutdown_check_wait(cp) == 0,
				   msecs_to_jiffies(1000))) {

so the window there is unbounded, and rds_ib_flush_mrs() and tasklet_kill()
run inside it too.

The only blocking waiter for RDS_IN_XMIT is rds_tcp_reset_callbacks(), called
from rds_tcp_accept_one() on rds_wq, which rds_threads_init() creates as:

	rds_wq = create_singlethread_workqueue("krdsd");

and it parks there holding rtn->rds_tcp_accept_lock and tc->t_conn_path_lock.
While it is parked the single krdsd worker is occupied, so accept processing
for other connections and other namespaces, rds_ibdev->free_work, rds_message
unpin work, and the flush_workqueue(rds_wq) in rds_tcp_listen_stop() during
namespace teardown all wait behind it.  Before this patch that wait was
bounded by a single rds_send_xmit() batch, since teardown never owned the bit.

Is the uncapped IB retry loop meant to be covered by the "up to 5 s" bound
stated in the changelog?

>  		wait_event(cp->cp_waitq,
> -			   !test_bit(RDS_RECV_REFILL, &cp->cp_flags));
> +			   !test_and_set_bit(RDS_RECV_REFILL, &cp->cp_flags));

[Severity: Low]

RDS_RECV_REFILL is now taken as a lock here, and the release comment below
describes an ordered handoff of the bit.  The release side of that handoff is
release_refill() in net/rds/ib_recv.c, which only gained release semantics in
the earlier series patch "net/rds: use clear_bit_unlock() in
release_refill()".

The backport paragraph in the changelog names only two prerequisites:

    "For anyone backporting this patch standalone: it depends on
    "net/rds: clear cp_flags bits individually in rds_conn_path_reset()"
    and "net/rds: acquire RDS_IN_XMIT in rds_tcp_reset_callbacks()"
    earlier in this series."

Without the release_refill() patch, that function reads:

	clear_bit(RDS_RECV_REFILL, &conn->c_flags);
	smp_mb__after_atomic();

with the barrier after the clear, which does not order the refill path's
preceding ring and recv stores before the bit clear.

Should the release_refill() patch be listed as a prerequisite as well?

>  
>  		conn->c_trans->conn_path_shutdown(cp);
>  		rds_conn_path_reset(cp);
>  
> +		/* Release the two locks and wake any waiter (e.g.
> +		 * rds_tcp_reset_callbacks()) that blocked on them while
> +		 * we held them.  The unlock orders the transport's ring
> +		 * re-initialization and the path reset above before
> +		 * either bit is seen clear.  rds_conn_path_reset() leaves
> +		 * both bits alone: ownership ends here, not inside the
> +		 * reset.
> +		 */
> +		clear_bit_unlock(RDS_IN_XMIT, &cp->cp_flags);
> +		clear_bit_unlock(RDS_RECV_REFILL, &cp->cp_flags);
> +		wake_up_all(&cp->cp_waitq);
> +
>  		if (!rds_conn_path_transition(cp, RDS_CONN_DISCONNECTING,
>  					      RDS_CONN_DOWN) &&
>  		    !rds_conn_path_transition(cp, RDS_CONN_ERROR,

[Severity: Medium]

This is a pre-existing behaviour rather than something this patch introduces,
but the new ownership window makes it reachable deterministically, so it
seems worth a question.

rds_tcp_reset_callbacks() does its state check before it blocks on
RDS_IN_XMIT, so a duelling SYN accepted in the window before the teardown
moves the path to RDS_CONN_DISCONNECTING now resumes only after
conn_path_shutdown() and rds_conn_path_reset() have run.  The accept then
installs the new socket:

net/rds/tcp_listen.c:rds_tcp_accept_one() {
	...
	if (rs_tcp->t_sock) {
		rds_tcp_reset_callbacks(new_sock, cp);
		rds_connect_path_complete(cp, RDS_CONN_RESETTING);
	...
}

and rds_connect_path_complete() cannot match RDS_CONN_RESETTING from
DISCONNECTING/ERROR:

net/rds/threads.c:rds_connect_path_complete() {
	if (!rds_conn_path_transition(cp, curr, RDS_CONN_UP)) {
		printk(KERN_WARNING "%s: Cannot transition to state UP, ...");
		rds_conn_path_drop(cp, false);
	...
}

At this commit the RDS_CONN_ERROR set by that drop can be consumed by the
second arm above, so the shutdown pass the drop queued becomes a no-op and
the freshly accepted socket stays attached to a path the teardown already
reset.

The last patch of this series, "net/rds: don't let rds_conn_shutdown()
consume a concurrent drop", replaces that arm with

	if (rds_conn_path_state(cp) == RDS_CONN_ERROR)
		return;

so at the end of the series the queued pass survives and finishes the
teardown.  Since the new deterministic resume point depends on that, should
the standalone-backport paragraph name that patch too?

> diff --git a/net/rds/send.c b/net/rds/send.c
> index 8aad185e4b1aa..b90e0586f818c 100644
> --- a/net/rds/send.c
> +++ b/net/rds/send.c
> @@ -244,8 +244,9 @@ int rds_send_xmit(struct rds_conn_path *cp)
>  	WRITE_ONCE(cp->cp_send_gen, send_gen);
>  
>  	/*
> -	 * rds_conn_shutdown() sets the conn state and then tests RDS_IN_XMIT,
> -	 * we do the opposite to avoid races.
> +	 * rds_conn_shutdown() sets the conn state and then acquires
> +	 * RDS_IN_XMIT; we take the lock first and then check the state,
> +	 * so one of us is guaranteed to see the other's update.
>  	 */
>  	if (!rds_conn_path_up(cp)) {

[Severity: Low]

This isn't a bug, only a note on the wording.  Read on its own, "guaranteed
to see the other's update" looks like a cross-variable ordering claim, which
neither acquire_in_xmit() (test_and_set_bit_lock, acquire only) nor the plain
atomic_read() behind rds_conn_path_up() provides.

Checking it against the code, the claim holds for a different reason: both
sides RMW the same bit of the same cp_flags word, so the modification order
of that word serializes them.  If the sender's test_and_set_bit_lock() wins,
the teardown's returns 1 and it blocks in wait_event(); if the teardown wins,
acquire_in_xmit() fails and the sender backs off.

Would it be clearer to say that ownership is decided by the RMW on cp_flags,
as the changelog does, rather than by ordering between the two variables?

> diff --git a/net/rds/tcp.c b/net/rds/tcp.c
> index f4c83e3683905..826e620b2dd14 100644
> --- a/net/rds/tcp.c
> +++ b/net/rds/tcp.c
> @@ -144,8 +144,10 @@ void rds_tcp_reset_callbacks(struct socket *sock,
>  	 * so we must quiesce any send threads before resetting
>  	 * cp_transport_data.  Setting cp_state to something other
>  	 * than RDS_CONN_UP stops new senders, and owning RDS_IN_XMIT
> -	 * excludes any thread already inside rds_send_xmit() for the
> -	 * whole socket swap and the rds_send_path_reset() below.
> +	 * excludes any thread already inside rds_send_xmit() - or a
> +	 * teardown in rds_conn_shutdown(), which holds the same lock
> +	 * for the duration of the transport shutdown - for the whole
> +	 * socket swap and the rds_send_path_reset() below.

[Severity: Low]

The changelog states:

    "It cannot deadlock: the teardown runs on the path's own ordered
    workqueue and never waits on krdsd, so it always completes the drain
    and releases the bit"

Is that accurate as written?  After this patch rds_conn_shutdown() blocks in
wait_event() until it can acquire RDS_IN_XMIT, and rds_tcp_reset_callbacks()
running from the krdsd accept worker can already own that bit, so the
teardown does wait for a krdsd work item to make progress.  The dependency
looks bidirectional.

While holding RDS_IN_XMIT, rds_tcp_reset_callbacks() does:

	cancel_delayed_work_sync(&cp->cp_send_w);
	cancel_delayed_work_sync(&cp->cp_recv_w);
	lock_sock(osock->sk);

cp_send_w and cp_recv_w live on cp->cp_wq, the same workqueue whose single
execution slot the blocked cp_down_w occupies.  That appears safe only
because __rds_conn_create() allocates it as:

		conn->c_path[i].cp_wq =
			alloc_ordered_workqueue("krds_cp_wq#%lu/%d", 0,
						rds_conn_count, i);
		if (!conn->c_path[i].cp_wq)
			conn->c_path[i].cp_wq = rds_wq;

with max_active == 1, so those items cannot be running and the sync cancels
return without flushing.

Could that invariant be stated, either in the changelog or next to the new
blocking wait, given that a non-ordered cp_wq or any added flush inside the
RDS_IN_XMIT section here would turn it into a hang?

[ ... ]
