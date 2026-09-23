Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758AC44BC82;
	Wed, 23 Sep 2026 07:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790147505; cv=none; b=BlQXE2Adh0dUcwAFbRwIGot8+homsArYVeGj8BENK1a+czKaKS2YIUEfXgqQBuB/fiohN8iab6v7awdoL3LLeo3gp8z88U5ZeZhGpcqzEX3HU9rPm7hRVohE5vxf9jjBgLEqToK0h6rdqpq0NIUCvclUSg6/0ImZaKfOYfFdB1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790147505; c=relaxed/simple;
	bh=qVJ+AIOAVqKPcu14j20VRi90VY3jPPedp8A4FuD8Uc4=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QQnoa3c6isgxQ0+zGTCqxGF7xmHVSNUyC07bX/Redpp/J6anMknOnE90mvAV0o9ekW7VWuEMznfl3jE5+3gGf9Z+kpk6kNrtXgaY6rGE7c6HjkVbtZr7treb2kap/6ipZW7YMj57JOC9ShqAJUTc/CYT6doDAIOn3pbF8n30S7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AjnRmVca; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AjnRmVca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005851F0089B;
	Wed, 23 Sep 2026 07:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790147501;
	bh=yVwUuOJPj/nYPTBym3Up7YDkEOLGhiAqwK9AW60sb7Q=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=AjnRmVcaQqYlG8LKLowU9AB9YqBwrl+4MTjb706J4cUiLq2k9o9tFhrU54t+bP35a
	 Tq9yaNnM4spEHLs3dCINGguOucmb7IAisUvzYZX0nsnBpghVNScEUyFNqL5OnlS8fR
	 BBw2XJDek+ByNRIlSHxJwIomigfKtk4AX6W8pLryhbk4oJ1m1GImYkmZvMhMEsQ6S7
	 dbBwuyrBxjbF60EGgl5NPZ9keh9W/dsWi5dWAQUlRPOEFrzqHJ2VuEMAWQF6yM4KjU
	 yk5vhtIHoXVgoBSoCZx+cuTBtK9gBY1UVvOAvpxyamEy5X5/jBsje28zOV2ibddA9C
	 S+feYy43hjT1g==
Subject: Re: [PATCH net-next v5 09/12] net/rds: refuse to queue on a
 connection being destroyed
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Wed, 23 Sep 2026 07:11:40 +0000
Message-ID: <179014750057.2160803.276056348207073012@kernel.org>
In-Reply-To: <20260919061149.250658-10-achender@kernel.org>
References: <20260919061149.250658-10-achender@kernel.org>
X-sashiko-severity: High
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

Critical: 0 · High: 3 · Medium: 1 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] rds_conn_path_quiesce() (net/rds/connection.c:628-634) purges
  cp_send_queue by only retiring the *connection-side* state of each…
- [High] The new rds_destroy_pending() refusal in rds_send_queue_rm() is
  nested inside the `if (rs->rs_snd_bytes < rds_sk_sndbuf(rs))` branch…
- [High] The quiesce splices cp_send_queue into an on-stack list under
  cp_lock, drops the lock, and then walks and frees that list unlocked…
- [Medium] Concern (baseline verdict: FALSE POSITIVE for the use-after-
  free; the commit-message inaccuracy is real): queued outgoing messages…
- [Low] Moving spin_lock(&cp->cp_lock) above the socket-side bookkeeping
  in rds_send_queue_rm() (net/rds/send.c:937) makes cp_lock cover the…
- [Low] Concern (baseline verdict: FALSE POSITIVE): the patch is claimed
  to lack a Fixes:/dependency note for the hazard enabled by the…

--

net/rds: refuse to queue on a connection being destroyed

This changes rds_conn_path_quiesce() to splice cp_send_queue onto a local
list under cp_lock before purging it, and adds an rds_destroy_pending()
test under cp_lock to rds_send_queue_rm() and rds_send_probe() so that
nothing is queued after the purge.  rds_send_queue_rm() now signals the
refusal by setting *queued negative, and rds_sendmsg() turns that into
-EAGAIN.

A few questions on the commit message and the new locking below.

> rds_send_queue_rm() adds to
> cp_send_queue under cp_lock, so the unlocked walk races the add and
> can corrupt the list.  Worse, a message added after the purge sits on
> the queue of a quiesced connection holding the connection reference
> rds_send_queue_rm() took for it: the reference is only dropped when
> the message is freed, the message is only freed when the queue is
> torn down, and the queue is only torn down by the destroy that has
> already run.  The connection would never be freed, and with it the
> transport could never unload.

[Severity: Medium]
Is this description accurate at this point in the series?  Reading
rds_send_queue_rm() at this commit, the queueing sequence is:

net/rds/send.c:rds_send_queue_rm() {
	...
	rds_message_populate_header(&rm->m_inc.i_hdr, sport, dport, 0);
	rm->m_inc.i_conn = conn;
	rm->m_inc.i_conn_path = cp;
	rds_message_addref(rm);
	...
}

There is no rds_conn_get() here, and rds_message_put() has no matching
rds_conn_put(), so a message does not hold a connection reference yet.
That reference appears later in the series, in "net/rds: hold a
connection reference from struct rds_incoming".

Should the wording be adjusted so it does not describe a reference that
does not exist until a later patch, or should the patch ordering change?

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index 965d68e51a1c..5699f45e4c37 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c

[ ... ]

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
Can this purge hit the BUG_ON for a message a socket still owns?

The commit message says "A sender that gets there first has its message
purged".  A message that got there first was linked on both queues by
rds_send_queue_rm():

net/rds/send.c:rds_send_queue_rm() {
	...
	list_add_tail(&rm->m_sock_item, &rs->rs_send_queue);
	set_bit(RDS_MSG_ON_SOCK, &rm->m_flags);
	rds_message_addref(rm);
	sock_hold(rds_rs_to_sk(rs));
	rm->m_rs = rs;
	...
	list_add_tail(&rm->m_conn_item, &cp->cp_send_queue);
	set_bit(RDS_MSG_ON_CONN, &rm->m_flags);
	...
}

m_sock_item is only unlinked by rds_send_remove_from_sock() (ack driven)
and rds_send_drop_to() (close() or RDS_CANCEL_SENT_TO).  The teardown
path rds_conn_path_drop(cp, true) -> rds_conn_shutdown() ->
rds_send_path_reset() only puts cp_xmit_rm and splices cp_retrans back
into cp_send_queue, so it does not touch the socket side.

Does that mean any unacked message still on cp_send_queue reaches the
purge with a non-empty m_sock_item and trips
BUG_ON(!list_empty(&rm->m_sock_item))?

And for messages whose m_sock_item was already unlinked by a racing
rds_send_drop_to(), do rs_snd_bytes and the sock_hold() taken above stay
charged, since the purge neither calls rds_send_sndbuf_remove() nor
sock_put()?

[Severity: High]
Separately: the splice serializes additions, but does it serialize
removals?  The purged messages keep RDS_MSG_ON_CONN set, and
rds_send_drop_to() decides ownership of the connection-queue reference
purely from that bit:

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

After the splice, m_conn_item points into the purge list whose head is on
rds_conn_path_quiesce()'s stack.  If a close() or
setsockopt(RDS_CANCEL_SENT_TO) runs while the unlocked
list_for_each_entry_safe() walk is in progress, can drop_to unlink an
entry and rewrite that stack list head behind the walker, so the cached
next pointer is followed into an already freed message?

Does the same stale bit also give two rds_message_put() calls for one
connection-queue reference, one from the purge and one from drop_to?

The invariant in net/rds/rds.h seems to expect the flag to be cleared
along with the list removal:

 * The RDS_MSG_ON_SOCK and RDS_MSG_ON_CONN flags are used to avoid lock
 * nesting.  As paths iterate over messages on a sock, or conn, they must
 * also lock the conn, or sock, to remove the message from those lists too.

Would clearing RDS_MSG_ON_CONN under cp_lock as part of the splice, or
holding cp_lock across the walk, close this?

> diff --git a/net/rds/send.c b/net/rds/send.c
> index 2d7839438abd..f7bc4c5446d6 100644
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

[Severity: High]
The refusal sits inside the "if (rs->rs_snd_bytes < rds_sk_sndbuf(rs))"
branch, so it is only evaluated when the socket already has send room.

With a full send buffer rds_send_queue_rm() returns *queued == 0 without
ever testing rds_destroy_pending(), and the sendmsg loop keeps sleeping:

net/rds/send.c:rds_sendmsg() {
	...
	timeo = wait_event_interruptible_timeout(*sk_sleep(sk),
				rds_send_queue_rm(rs, conn, cpath, rm,
						  rs->rs_bound_port,
						  dport,
						  &queued),
				timeo);
	...
	if (timeo > 0 || timeo == MAX_SCHEDULE_TIMEOUT)
		continue;
	...
}

For a blocking socket timeo is MAX_SCHEDULE_TIMEOUT, so the continue arm
re-enters the wait.  Send room is released only by
rds_send_sndbuf_remove() from rds_send_remove_from_sock() (ack driven,
which cannot happen on a quiesced connection) or from
rds_send_drop_to(), and rds_conn_path_quiesce() neither decrements
rs_snd_bytes nor calls rds_wake_sk_sleep().

Does that make the new "if (queued < 0)" escape in rds_sendmsg()
unreachable in exactly the case the commit message names, "so that the
wait loop in rds_sendmsg() stops waiting for send room that will never
come"?

Since that sleeping thread holds the connection reference rds_sendmsg()
took, does this also keep rds_conn_wait_conns_freed() blocked and the
transport module unloadable?

Would hoisting the rds_destroy_pending() test above the sndbuf check
address both?

>  		rs->rs_snd_bytes += len;
>  
>  		/* let recv side know we are close to send space exhaustion.
> @@ -951,7 +964,6 @@ static int rds_send_queue_rm(struct rds_sock *rs, struct rds_connection *conn,
>  		rm->m_inc.i_conn_path = cp;
>  		rds_message_addref(rm);
>  
> -		spin_lock(&cp->cp_lock);
>  		rm->m_inc.i_hdr.h_sequence = cpu_to_be64(cp->cp_next_tx_seq++);
>  		list_add_tail(&rm->m_conn_item, &cp->cp_send_queue);
>  		set_bit(RDS_MSG_ON_CONN, &rm->m_flags);

[Severity: Low]
This isn't a bug, but with the lock taken earlier, the comment a few
lines above the removed spin_lock() is now stale:

net/rds/send.c:rds_send_queue_rm() {
	...
	/* The code ordering is a little weird, but we're
	   trying to minimize the time we hold c_lock */
	rds_message_populate_header(&rm->m_inc.i_hdr, sport, dport, 0);
	...
}

cp_lock now covers the rs_snd_bytes update, the rs_send_queue insertion,
the two rds_message_addref() calls, sock_hold() and the header memset in
rds_message_populate_header().  Could the comment be updated or dropped,
or the destroy test done in its own short cp_lock section?

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

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260919061149.250658-1-achender%40kernel.org
