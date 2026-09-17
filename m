Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC5E4B1D02;
	Thu, 17 Sep 2026 09:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789637948; cv=none; b=N1QZ+hZvv9xaofL8r1iKkyyJzfBSPV9Sn0Dr3nJIU7zyRBIN9X+VO5TAtOcUTBRovk6w7DGcdGBNITcsCs///06RNxvcNGK95uiu9qIqpNy8EFzrpSvAqP6uZbrPxyIiOjJ0IeGcDhIrUBBWAiuhsr0LraRw5AGUqWkNa9L1Ilw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789637948; c=relaxed/simple;
	bh=0/xIJ2PC1luNEknXYOZeyRegAcIzvE2K5ydNh0QOO78=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iebVgp/MJeJtm4tXWVPuTcikJ6mxvRomOb0VWSq+9uMyke4xK8mXAz/18ZWYHB/O3tEuZ3pEpafTJG/EVJICJpSeo8O77xzZrem5llFEif44tC9Wpy3eLuSvmcFkULJJNGDNZPAZk+26AeRb9TRfAVL9m6jJKdHAuboxzMusnyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JucnDvoF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JucnDvoF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A051F0089E;
	Thu, 17 Sep 2026 09:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789637927;
	bh=nN14hTmK5LuYaXitAioo0ZaIgaszsocaSLcFffuNb1o=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=JucnDvoFG49OIrvt+41J3/CUrpRP2mQMciGPgfHoiMHK7UmhjoeukKTWpegU3CPpn
	 5js84BCmbon2Ip8AWIYT+p/RUHDqQdxqMqpGd8gnN1/lXq0c48aChcwIMStn2uhEjb
	 oVmbenFGrrvxlJiJ1PkyKPRVZMBEWvE5n5MZPjTA8zXyiTlw+F02X5D53aKj3iwGCW
	 e4zlAlFbeFghjebepFQpDmJNKV1VCvQrlkKE2CA5f/WAstxXfRxWquOCEb1iWE7SH/
	 ChPM1+XlLIjExl2J6nKpmWDB+KuM5+rrUn3iawy0DzCzrFX1KSc0LjZxHsko1KHjb2
	 KJfMIdYAmC7Bg==
Subject: Re: [PATCH net-next v3 09/13] net/rds: refuse to queue a message on a
 connection being destroyed
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Thu, 17 Sep 2026 09:38:46 +0000
Message-ID: <178963792614.22033.732461810986657356@kernel.org>
In-Reply-To: <20260914033719.138057-10-achender@kernel.org>
References: <20260914033719.138057-10-achender@kernel.org>
X-sashiko-severity: Critical
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

Critical: 1 · High: 2 · Medium: 1 · Low: 1

- [Critical] rds_conn_path_quiesce() keeps
  BUG_ON(!list_empty(&rm->m_sock_item)) (net/rds/connection.c:633) while…
- [High] The new comment in rds_conn_path_quiesce()
  (net/rds/connection.c:622-627) claims that after the cp_lock-protected…
- [High] The rds_destroy_pending() refusal is nested inside `if
  (rs->rs_snd_bytes < rds_sk_sndbuf(rs))` (net/rds/send.c:932, check at…
- [Medium] The changelog ("a message added after the purge sits on the
  queue of a quiesced connection holding the connection reference…
- [Low] This patch repairs a regression created by the immediately
  preceding patch of the same series, "net/rds: hold connection…

--

net/rds: refuse to queue a message on a connection being destroyed

This splices cp_send_queue away under cp_lock in rds_conn_path_quiesce()
rather than walking it unlocked, and makes rds_send_queue_rm() test
rds_destroy_pending() under cp_lock before it queues a message.  On
refusal *queued is set to -EAGAIN and rds_sendmsg() returns that to the
caller.

No Link: tags are present in the commit header.

A few questions on this one.

[Severity: Low]

> rds_conn_path_quiesce() tears down cp_send_queue by walking it with no
> lock held.  That was tolerable while a connection could only be
> destroyed with no sender in flight, but a sender now holds a
> reference across rds_sendmsg(), and rds_conn_destroy() can quiesce
> the connection underneath it.

The "now" here refers to the immediately preceding patch of this series,
"net/rds: hold connection references in lookup, sockets and c_passive",
which adds the rds_conn_get() that keeps the connection alive across
rds_sendmsg().

If that is right, then applying the series up to that commit leaves
rds_conn_path_quiesce() walking cp_send_queue unlocked while a referenced
sender can be adding to it under cp_lock, and a bisect landing there sees
the list corruption described above.

Would it make sense to fold this change into that patch, or to carry a
Fixes: tag or an explicit dependency note?

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index 7ef6fb9d352b..e5a8534c23cf 100644
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
> @@ -617,10 +619,16 @@ static void rds_conn_shutdown(struct rds_conn_path *cp)
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

[Severity: High]

Is "nothing is added behind our back" true for the other producer of
cp_send_queue?  rds_send_probe() takes cp_lock and adds unconditionally,
with no rds_destroy_pending() test before the add:

net/rds/send.c:rds_send_probe() {
	...
	spin_lock_irqsave(&cp->cp_lock, flags);
	list_add_tail(&rm->m_conn_item, &cp->cp_send_queue);
	set_bit(RDS_MSG_ON_CONN, &rm->m_flags);
	rds_message_addref(rm);
	rm->m_inc.i_conn = cp->cp_conn;
	rm->m_inc.i_conn_path = cp;
	...
	spin_unlock_irqrestore(&cp->cp_lock, flags);

	/* schedule the send work on cp_wq */
	rcu_read_lock();
	if (!rds_destroy_pending(cp->cp_conn))
		queue_delayed_work(cp->cp_wq, &cp->cp_send_w, 1);
	rcu_read_unlock();
	...
}

The destroy test there runs after the message is already linked, and only
suppresses the work that could have drained it.

This is reachable from the syscall being hardened here.  rds_sendmsg()
calls rds_send_ping() -> rds_send_probe() for an mp-capable connection
whose path 0 is down, before its own rds_destroy_pending() check:

net/rds/send.c:rds_sendmsg() {
	...
	if (conn->c_trans->t_mp_capable &&
	    !rds_conn_path_up(&conn->c_path[0])) {
		...
		rds_send_ping(conn, 0);
	}
	...
	if (rds_destroy_pending(conn)) {
		ret = -EAGAIN;
		goto out;
	}

rds_send_pong() reaches the same code from the receive path.

Since the quiesce splices once and never purges again, can a probe that
lands after the splice sit on cp_send_queue forever with no worker to
drain it?  That would leak the rds_message whose reference the queue
holds, and leave rm->m_conn_item and rm->m_inc.i_conn_path pointing into
the c_path array that rds_conn_destroy_fini() kfree()s.

At the end of this series rds_send_probe() also takes rds_conn_get(), so
would the same window then leak a connection reference and leave
rds_conn_wait_conns_freed() waiting for a count that never drops, blocking
transport unload?

> +	list_for_each_entry_safe(rm, rtmp, &purge, m_conn_item) {
>  		list_del_init(&rm->m_conn_item);
>  		BUG_ON(!list_empty(&rm->m_sock_item));
              ^^^^^^

[Severity: Critical]

Can this BUG_ON() fire in exactly the interleaving the changelog says is
now handled ("A sender that gets there first has its message purged")?

Every message rds_send_queue_rm() puts on cp_send_queue is linked on the
socket send queue in the same critical section:

net/rds/send.c:rds_send_queue_rm() {
	...
		list_add_tail(&rm->m_sock_item, &rs->rs_send_queue);
		set_bit(RDS_MSG_ON_SOCK, &rm->m_flags);
	...
		list_add_tail(&rm->m_conn_item, &cp->cp_send_queue);
		set_bit(RDS_MSG_ON_CONN, &rm->m_flags);
}

m_sock_item is emptied only by the ack path via
rds_send_remove_from_sock(), or by rds_send_drop_to() / rds_release().
Nothing in the destroy path does it.  rds_conn_path_quiesce() itself runs
rds_conn_path_drop(cp, true) and flush_work(&cp->cp_down_w) first, and
rds_conn_shutdown() -> rds_conn_path_reset() -> rds_send_path_reset()
puts still socket-linked messages back on cp_send_queue:

net/rds/send.c:rds_send_path_reset() {
	...
	list_splice_init(&cp->cp_retrans, &cp->cp_send_queue);
	...
}

So an unacked message reaches this loop with a non-empty m_sock_item and
panics the kernel.

Independent of the panic, the loop drops the conn-side reference with
list_del_init(&rm->m_conn_item) + rds_message_put(), but never clears
RDS_MSG_ON_CONN and never undoes the socket-side state (the rs_snd_bytes
charge, RDS_MSG_ON_SOCK, the extra rds_message_addref() and the
sock_hold()).

Because the flag stays set, does a later rds_send_drop_to() still pass
here and issue a second put for the reference already released?

net/rds/send.c:rds_send_drop_to() {
	...
		if (!test_and_clear_bit(RDS_MSG_ON_CONN, &rm->m_flags)) {
			spin_unlock_irqrestore(&cp->cp_lock, flags);
			continue;
		}
		list_del_init(&rm->m_conn_item);
	...
}

That is a refcount_t underflow on rm->m_refcount and a premature free.
And since that path holds cp_lock while the quiesce walks its private
purge list with no lock at all, it can also list_del_init() an entry
living on the purge list, so does the splice really establish the
exclusive ownership the new comment claims?

Should the purge clear RDS_MSG_ON_CONN under cp_lock and detach the
message from its socket queue the way rds_send_drop_to() and
rds_send_remove_from_sock() do, instead of asserting m_sock_item is empty?

>  		rds_message_put(rm);
>  	}

> diff --git a/net/rds/send.c b/net/rds/send.c
> index 1ae1f24c24e8..94d6ac174dde 100644
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

[Severity: Medium]

Does the connection reference this comment describes exist yet?  The same
claim is in the changelog:

> Worse, a message added after the purge sits on
> the queue of a quiesced connection holding the connection reference
> rds_send_queue_rm() took for it: the reference is only dropped when
> the message is freed, the message is only freed when the queue is
> torn down, and the queue is only torn down by the destroy that has
> already run.  The connection would never be freed, and with it the
> transport could never unload.

At this commit rds_send_queue_rm() takes only a message reference:

net/rds/send.c:rds_send_queue_rm() {
	...
		rds_message_populate_header(&rm->m_inc.i_hdr, sport, dport, 0);
		rm->m_inc.i_conn = conn;
		rm->m_inc.i_conn_path = cp;
		rds_message_addref(rm);
	...
}

and rds_message_put() goes rds_message_purge() -> rds_message_free()
without touching rm->m_inc.i_conn, so nothing here pins the connection.
The rds_conn_get() with the "put in rds_message_put()" annotation only
appears with the last patch of the series, "net/rds: hold a connection
reference from struct rds_incoming".

The damage from a post-purge add in this tree state looks like a leaked
rds_message plus a list linkage dangling into the c_path array that
rds_conn_destroy_fini() kfree()s, not a connection that can never be
freed.

Could the changelog and the comment be adjusted for the tree state they
land in, or this patch ordered after the incoming-reference patch?

> +		spin_lock(&cp->cp_lock);
> +		if (rds_destroy_pending(conn)) {
> +			spin_unlock(&cp->cp_lock);
> +			*queued = -EAGAIN;
> +			goto unlock;
> +		}
> +

[Severity: High]

The refusal is nested inside if (rs->rs_snd_bytes < rds_sk_sndbuf(rs)),
so it only fires when send room exists.  Does that leave the blocked
sender, the one the changelog is about, still waiting forever?

With the send buffer full, rds_send_queue_rm() falls through and returns
0, and rds_sendmsg() re-arms the wait with timeo == MAX_SCHEDULE_TIMEOUT
on a blocking socket:

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

rs_snd_bytes is decremented only by rds_send_sndbuf_remove() from the ack
path via rds_send_remove_from_sock(), or from rds_send_drop_to().  After
the connection is quiesced no acks arrive, and the purge in
rds_conn_path_quiesce() calls neither rds_send_sndbuf_remove() nor
rds_wake_sk_sleep() - it only drops the conn-side message reference.

So the wake condition can never become non-zero, and the new
if (queued < 0) exit below is never evaluated.  Should the destroy test
move outside the sndbuf-room branch, and should the purge release the
sndbuf accounting and wake sk_sleep()?

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

[ ... ]

> @@ -1474,6 +1487,11 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
>  			ret = -ETIMEDOUT;
>  		goto out;
>  	}
> +	/* rds_send_queue_rm() refused: the connection is being destroyed */
> +	if (queued < 0) {
> +		ret = queued;
> +		goto out;
> +	}

Thanks for looking at these.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260914033719.138057-1-achender%40kernel.org
