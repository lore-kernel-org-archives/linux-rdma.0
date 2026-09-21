Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7EF4468C31;
	Mon, 21 Sep 2026 09:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789982141; cv=none; b=poebDR9yUwT7qSLMk6IPHLWT2eSviT8Rup4eJPDPY8wuBDOY43elt/JHkOe9NNnYXvAnnHmleSEuIvjML6Haa65zvpZp2Zw0w4m7wsGy6RHpdPf33Kivt8rSZwj59j+fpQIlD3VRuApwNeFphBBnZKLVM5l7C5ixHFH+cnOzyP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789982141; c=relaxed/simple;
	bh=gQTn3+/hDoKeAAGUhoWYoAPLyOX/cae2teUdtDKM02U=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GLq6sJ3M6rk0snurjbv1fQiQ0wG9PBKKWjhXpPpwDQV4P6qEC3ekj36jHa5wT3W44JXbhomN+OnKHVvKs9pp2uLcdoWjfAEPNPIrbhopPxZvhVeVFNhn5oBhLFXa+bGewToxw1TDQ9+5EdQBfh7xc3W46ZMfYUpsv/ElAWDJd4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OOJMQvQP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OOJMQvQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BEF31F00898;
	Mon, 21 Sep 2026 09:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789982139;
	bh=GSDQz95Opo/jFrxsIJsOCvafIeuhRMbEo3ql0zEDMl8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=OOJMQvQPLgjZDbtW0Hi83RiL0yrljB1nSqGU2naDkV4qM3vQkr/FEqaAUHxinQCzG
	 6pQGNZNk5gZ0WxdQr0jOtkpvLSHfePfCgp7B6p/4l3WiPeDf5vGklA58tzZ83OzHNz
	 JP4TtIF4Op9VaUvg8r/tLaK6t1N7eARGVh83+2d+rQoH+Ax8+f6snpT4nzsrRa6rt6
	 tX5Ofnw1iqSQ2ctHHDV7wW6PxmnsZYFEdfhxieWRqVmMIzsmaN4b9tCHaSTtsk/Ihy
	 XhBA8Ju6r9EkkKaMdSPB0YFX5HvE9u8/GOVvuf+QvavrUtz330TVfVXxuQEudIFDL+
	 lrSQvRyghCcZA==
Subject: Re: [PATCH net-next v4 09/12] net/rds: refuse to queue on a
 connection being destroyed
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Mon, 21 Sep 2026 09:15:38 +0000
Message-ID: <178998213871.2160803.8802073985683603650@kernel.org>
In-Reply-To: <20260917073958.174056-10-achender@kernel.org>
References: <20260917073958.174056-10-achender@kernel.org>
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
issue(s) to consider.

Critical: 0 · High: 3 · Medium: 0 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] rds_conn_path_quiesce() still asserts
  BUG_ON(!list_empty(&rm->m_sock_item)) for every message it takes off…
- [High] The quiesce purge unlinks m_conn_item and drops the connection-
  queue message reference without clearing RDS_MSG_ON_CONN and without…
- [High] The new rds_destroy_pending() refusal in rds_send_queue_rm() is
  placed inside the `if (rs->rs_snd_bytes < rds_sk_sndbuf(rs))` branch,…
- [Low] The comment "The code ordering is a little weird, but we're
  trying to minimize the time we hold c_lock" in rds_send_queue_rm() now…
- [Low] Series bisectability: this patch repairs a defect introduced
  earlier in the same series (the preceding commit "net/rds: hold…

--

net/rds: refuse to queue on a connection being destroyed

This makes rds_conn_path_quiesce() splice cp_send_queue away under cp_lock
instead of walking it unlocked, and adds an rds_destroy_pending() test under
that same lock to rds_send_queue_rm() and rds_send_probe() so nothing is
queued after the purge.  rds_send_queue_rm() reports the refusal by setting
*queued negative and rds_sendmsg() turns that into -EAGAIN.

A few questions about the new purge and the placement of the refusal test.

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index 965d68e51a1c1..5699f45e4c377 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c
> @@ -606,6 +606,8 @@ void rds_conn_shutdown(struct rds_conn_path *cp)
>  static void rds_conn_path_quiesce(struct rds_conn_path *cp)
>  {
>  	struct rds_message *rm, *rtmp;
> +	unsigned long flags;
> +	LIST_HEAD(purge);
>  
>  	if (!cp->cp_transport_data)
>  		return;
> @@ -617,10 +619,16 @@ static void rds_conn_path_quiesce(struct rds_conn_path *cp)
>  	rds_conn_path_drop(cp, true);
>  	flush_work(&cp->cp_down_w);
>  
> -	/* tear down queued messages */
> -	list_for_each_entry_safe(rm, rtmp,
> -				 &cp->cp_send_queue,
> -				 m_conn_item) {
> +	/* Tear down queued messages.  Take the queue under cp_lock:
> +	 * a sender that still holds a reference can be inside
> +	 * rds_send_queue_rm() right now, and it tests
> +	 * rds_destroy_pending() under the same lock, so after this
> +	 * splice nothing is added behind our back.
> +	 */
> +	spin_lock_irqsave(&cp->cp_lock, flags);
> +	list_splice_init(&cp->cp_send_queue, &purge);
> +	spin_unlock_irqrestore(&cp->cp_lock, flags);
> +	list_for_each_entry_safe(rm, rtmp, &purge, m_conn_item) {
>  		list_del_init(&rm->m_conn_item);
>  		BUG_ON(!list_empty(&rm->m_sock_item));
>  		rds_message_put(rm);

[Severity: High]
The commit message says "A sender that gets there first has its message
purged".  Can that message actually be purged, given the retained
BUG_ON(!list_empty(&rm->m_sock_item))?

rds_send_queue_rm() links a sendmsg message onto both queues in the same
locked region:

net/rds/send.c:rds_send_queue_rm() {
	...
	list_add_tail(&rm->m_sock_item, &rs->rs_send_queue);
	set_bit(RDS_MSG_ON_SOCK, &rm->m_flags);
	...
	list_add_tail(&rm->m_conn_item, &cp->cp_send_queue);
	set_bit(RDS_MSG_ON_CONN, &rm->m_flags);
	...
}

So a message on cp_send_queue always has a non-empty m_sock_item, and the
sender that "gets there first" hits BUG() rather than a clean purge.

The window exists because the flag the new test reads is published under a
different lock:

net/rds/connection.c:rds_conn_destroy() {
	spin_lock_irq(&rds_conn_lock);
	if (conn->c_destroy_in_prog) {
		spin_unlock_irq(&rds_conn_lock);
		return;
	}
	WRITE_ONCE(conn->c_destroy_in_prog, true);
	...
}

CPU0 (sendmsg)                        CPU1 (destroy)
rds_send_queue_rm()
  spin_lock(&cp->cp_lock)
  rds_destroy_pending() == false
  list_add_tail(m_sock_item, ...)
  list_add_tail(m_conn_item, ...)
  spin_unlock(&cp->cp_lock)
                                      WRITE_ONCE(c_destroy_in_prog, true)
                                      rds_conn_path_quiesce()
                                        splice cp_send_queue
                                        BUG_ON(!list_empty(m_sock_item))

Is there also a non-racy path into the same assertion?  rds_conn_shutdown()
runs before the purge and rds_send_path_reset() puts retransmit messages
back on cp_send_queue:

net/rds/send.c:rds_send_path_reset() {
	...
	list_splice_init(&cp->cp_retrans, &cp->cp_send_queue);
	spin_unlock_irqrestore(&cp->cp_lock, flags);
}

Those messages are still on their socket's send queue, so destroying a
connection while a socket has unacked messages would reach the BUG_ON with
no timing involved at all.

[Severity: High]
The purge unlinks m_conn_item and drops the conn-side reference, but leaves
RDS_MSG_ON_CONN set and does not touch the socket side.  Can that let a
concurrent remover work on the private purge list?

RDS_MSG_ON_CONN is the token other conn-side removers use:

net/rds/send.c:rds_send_drop_to() {
	...
	spin_lock_irqsave(&cp->cp_lock, flags);
	if (!test_and_clear_bit(RDS_MSG_ON_CONN, &rm->m_flags)) {
		spin_unlock_irqrestore(&cp->cp_lock, flags);
		continue;
	}
	list_del_init(&rm->m_conn_item);
	spin_unlock_irqrestore(&cp->cp_lock, flags);
	...
	rds_message_put(rm);
}

rds_send_drop_to() is reachable from rds_release() and from
setsockopt(RDS_CANCEL_SENT_TO).  If it runs while the quiesce is walking
'purge' with cp_lock dropped, it unlinks an entry from that stack-local
list; if it runs after the purge, test_and_clear_bit() still succeeds and
rds_message_put() drops the conn-queue reference a second time.  Since
rds_send_queue_rm() takes one reference per membership, does that underflow
the rds_message refcount and free the message while rs_send_queue and the
sender still point at it?  rds_send_probe() messages, which have an empty
m_sock_item and survive the assertion above, look like the easiest case to
hit.

The established protocol clears the flag under the lock before releasing it:

net/rds/send.c:rds_send_path_drop_acked() {
	...
	list_move(&rm->m_conn_item, &list);
	clear_bit(RDS_MSG_ON_CONN, &rm->m_flags);
	...
	if (!list_empty(&list))
		smp_mb__after_atomic();
	spin_unlock_irqrestore(&cp->cp_lock, flags);
}

Should the splice clear RDS_MSG_ON_CONN for each message under cp_lock, and
retire the socket side (m_sock_item, rs_snd_bytes) through
rds_send_remove_from_sock()?  As written the purge never calls
rds_send_sndbuf_remove(), so rs_snd_bytes stays charged for the purged
messages.

> diff --git a/net/rds/send.c b/net/rds/send.c
> index 2d7839438abdc..f7bc4c5446d61 100644
> --- a/net/rds/send.c
> +++ b/net/rds/send.c
> @@ -928,6 +928,19 @@ static int rds_send_queue_rm(struct rds_sock *rs, struct rds_connection *conn,
>  	 * and poll() now knows no more data can be sent.
>  	 */
>  	if (rs->rs_snd_bytes < rds_sk_sndbuf(rs)) {
> +		/* rds_conn_path_quiesce() empties cp_send_queue under
> +		 * cp_lock once the connection's destroy has begun.  Test
> +		 * for that under the same lock, before touching either
> +		 * queue: a message added after the purge would hold a
> +		 * connection reference nothing ever drops.
> +		 */
> +		spin_lock(&cp->cp_lock);
> +		if (rds_destroy_pending(conn)) {
> +			spin_unlock(&cp->cp_lock);
> +			*queued = -EAGAIN;
> +			goto unlock;
> +		}
> +
>  		rs->rs_snd_bytes += len;

[Severity: High]
The refusal sits inside the "if (rs->rs_snd_bytes < rds_sk_sndbuf(rs))"
branch.  When the send buffer is already full, does *queued ever go
negative?

For a full sndbuf rds_send_queue_rm() skips the whole branch and returns the
unchanged *queued == 0, so rds_sendmsg() keeps sleeping:

net/rds/send.c:rds_sendmsg() {
	...
	timeo = wait_event_interruptible_timeout(*sk_sleep(sk),
				rds_send_queue_rm(rs, conn, cpath, rm, ...),
				timeo);
	if (timeo > 0 || timeo == MAX_SCHEDULE_TIMEOUT)
		continue;
	...
}

With the default SO_SNDTIMEO, timeo is MAX_SCHEDULE_TIMEOUT, so the loop
re-sleeps and the new "if (queued < 0)" exit is never reached.

Can the send room ever appear afterwards?  Credit is returned by
rds_send_remove_from_sock() on ack processing, which cannot happen on a
quiesced connection, or by rds_send_drop_to() on close/cancel, which the
blocked task itself is holding the socket against.  The purge in
rds_conn_path_quiesce() touches neither rs_snd_bytes nor sk_sleep(), so
there is no wake-up either.

The commit message states:

  "rds_send_queue_rm()'s *queued becomes negative on refusal so that the
  wait loop in rds_sendmsg() stops waiting for send room that will never
  come."

Is that true for the full-sndbuf case, which is the only case that reaches
the wait loop?  And since rds_sendmsg() holds rds_conn_get(conn) for the
whole call, does a sender parked this way keep t_conn_count non-zero and
leave rds_conn_wait_conns_freed() looping on transport unload?  Would moving
the rds_destroy_pending() test above the sndbuf-room check, and returning
the credit plus a wake-up from the purge, address both?

> @@ -951,7 +964,6 @@ static int rds_send_queue_rm(struct rds_sock *rs, struct rds_connection *conn,
>  		rm->m_inc.i_conn_path = cp;
>  		rds_message_addref(rm);
>  
> -		spin_lock(&cp->cp_lock);
>  		rm->m_inc.i_hdr.h_sequence = cpu_to_be64(cp->cp_next_tx_seq++);
>  		list_add_tail(&rm->m_conn_item, &cp->cp_send_queue);
>  		set_bit(RDS_MSG_ON_CONN, &rm->m_flags);

[Severity: Low]
This isn't a bug, but the comment a few lines above now describes something
the function no longer does:

		/* The code ordering is a little weird, but we're
		   trying to minimize the time we hold c_lock */
		rds_message_populate_header(&rm->m_inc.i_hdr, sport, dport, 0);

cp_lock is now taken at the top of the branch, so it is held across the
socket-queue insertion, sock_hold(), the header population, the
rds_message_addref() and the sequence bump.  Could the comment be updated or
dropped?

> @@ -964,6 +976,7 @@ static int rds_send_queue_rm(struct rds_sock *rs, struct rds_connection *conn,
>  		*queued = 1;
>  	}
>  
> +unlock:
>  	spin_unlock_irqrestore(&rs->rs_lock, flags);
>  out:
>  	return *queued;
> @@ -1485,6 +1498,11 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
>  			ret = -ETIMEDOUT;
>  		goto out;
>  	}
> +	/* rds_send_queue_rm() refused: the connection is being destroyed */
> +	if (queued < 0) {
> +		ret = queued;
> +		goto out;
> +	}
>  
>  	/*
>  	 * By now we've committed to the send.  We reuse rds_send_worker()

[ ... ]

> @@ -1567,6 +1585,14 @@ rds_send_probe(struct rds_conn_path *cp, __be16 sport,
>  		goto out;
>  
>  	spin_lock_irqsave(&cp->cp_lock, flags);
> +	/* Same rule as rds_send_queue_rm(): once the destroy has purged
> +	 * cp_send_queue under this lock, nothing may be added behind it.
> +	 */
> +	if (rds_destroy_pending(cp->cp_conn)) {
> +		spin_unlock_irqrestore(&cp->cp_lock, flags);
> +		ret = -EAGAIN;
> +		goto out;
> +	}
>  	list_add_tail(&rm->m_conn_item, &cp->cp_send_queue);
>  	set_bit(RDS_MSG_ON_CONN, &rm->m_flags);
>  	rds_message_addref(rm);

[Severity: Low]
One question about the series ordering rather than this hunk.  The
serialization added here is what makes the quiesce safe against senders that
are allowed to be in flight by the earlier commits "net/rds: split
connection destroy into quiesce and kref-governed free" and "net/rds: hold
connection references in lookup, sockets and c_passive".

At those intermediate commits the unlocked cp_send_queue walk in
rds_conn_path_quiesce() already races the locked add in
rds_send_queue_rm(), so a bisect or a partial backport lands on a tree with
the list corruption and pinned-connection behaviour described here.

Would folding this change into the prerequisite commit, or adding a Fixes:
tag naming it, keep the series bisectable?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260917073958.174056-1-achender%40kernel.org
