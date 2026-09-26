Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D583AAF42;
	Sat, 26 Sep 2026 09:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790416125; cv=none; b=NvQHcIdNhtsdMKv3RFM8pXoAdm27I4ukHqDn34oFzG6/YzP5yD8VDuBYsxLIbXOgAo4WgkY7Ny6AOE2CLDGtTXVAmsLxRraQXaUweQoYHKTovoKRGYAn24olIHaiVS57Uie0GTOrD4Adp1TE5OY+j60OwueqovEaK03X+8OKyxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790416125; c=relaxed/simple;
	bh=8DYO7DtgsYkZvHKE2qb8V5MJNh0k0kvN2S5MrJQJT98=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MWq5hpGupzsapqOkY7uZX4YMDPTbYsfjbPLUgroVvvAjISVMJlayQAnlzg+jBfPBml6t4E8P11fBz5QZRs2DBa4Z8ICsSmHWjqhn6V0BAF8fs3M9qrKgsPLmyw5xgueKc5kRDtzKl75oezD9ZLbKJmW3S6Ps4j1pRMKiKVb8SaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uz+i/lYm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uz+i/lYm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A391F00893;
	Sat, 26 Sep 2026 09:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790416122;
	bh=brHsbk0Pbhn/q6cy0/otfiUtOs0xHTWGn+JPPyxZlDc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Uz+i/lYmlIjXgpmzrwElYsozVd+SgZm2shSZ0flBbu+xy01W2PHNYV1RAghq34Iw8
	 G+7YgwovEyBAqqjPXd4Wmx5OkzyGWwiPvHf1Vk78a+Mar4i2dRbKWVKUXCLqcJ+/tj
	 LcNSGJmr0PDgP8AL+EKGJqB9lZp3G3Mx5sf+JNjSG8dcZQYqToWjq3Jbw3mnUUu0Lv
	 ya3O0nPEZBVgfnnVz2BKggo2IBBYVKH2Onu2wXz24Sr9v/nYp4ZNVau9svIrqRjGDs
	 IQGCM7De99u4A+RFJgj6eSqKUZmg1IvS334Mf1hVdG2B5nHfhGl8IXOiLDk6fFDe+7
	 CBpXUoerb5EVg==
Subject: Re: [PATCH net-next v6 08/12] net/rds: hold connection references in
 lookup, sockets and c_passive
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Sat, 26 Sep 2026 09:48:41 +0000
Message-ID: <179041612161.2160803.9570814419451707272@kernel.org>
In-Reply-To: <20260922085410.391323-9-achender@kernel.org>
References: <20260922085410.391323-9-achender@kernel.org>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 (1) · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The commit message's central justification for the new
  rs->rs_conn reference is factually wrong about reachability.
- [Medium] Concern as filed: rds_sendmsg()'s new connection reference can
  be the final reference at either exit put (net/rds/send.c:1516 success…
- [Low] The comment newly added to rds_tcp_accept_one()
  (net/rds/tcp_listen.c, around line 281) misattributes behaviour: it…

Pre-existing issues:
- [Medium] Concern as filed: this patch makes it an explicitly supported
  state for rds_sendmsg() to keep running on a connection whose…

--

net/rds: hold connection references in lookup, sockets and c_passive

This patch hands out real references wherever a struct rds_connection
pointer previously escaped bare: rds_conn_lookup() and __rds_conn_create()
return a referenced connection, the rs->rs_conn sendmsg cache owns a
reference and is read/written under rs_lock, and parent->c_passive owns an
RCU-annotated reference.  Serializing the rs_conn cache also resolves a
syzbot-reported KCSAN data race between concurrent rds_sendmsg() calls.

Closes: https://syzkaller.appspot.com/bug?extid=879c1877016972360186

A few questions on the commit message and on the new reference handling.

[Severity: Medium]

The commit message says:

  The connection may still be destroyed while a send is in flight -
  when its device is removed or its netns is torn down - but it is
  only quiesced; the free is held off by the sender's reference.

and later:

  the race it closes needs a connection destroyed under a live
  socket, which takes netns teardown, module unload or device removal.

Are either of the two named triggers reachable at this commit?

For device removal, rds_ib_remove_one() only calls rds_ib_dev_shutdown(),
which drops paths rather than destroying connections:

net/rds/ib.c:rds_ib_dev_shutdown() {
	...
	list_for_each_entry(ic, &rds_ibdev->conn_list, ib_node)
		rds_conn_path_drop(&ic->conn->c_path[0], true);
}

The only IB caller of rds_conn_destroy() is rds_ib_destroy_nodev_conns()
from rds_ib_exit(), i.e. module unload.

For netns teardown, rds_tcp_kill_sock() and rds_loop_kill_conns() run from
pernet ->exit hooks, which only run once the netns refcount reaches zero,
and a userspace RDS socket holds a netns reference from sk_alloc().
rds_sendmsg() also only ever caches a conn whose c_net matches the
socket's netns, given rds_conn_create_outgoing(sock_net(sock->sk), ...)
and the net == rds_conn_net(conn) test in rds_conn_lookup().

Module unload is blocked for as long as a bound socket exists:

net/rds/transport.c:rds_trans_get_preferred() {
	if (trans && (trans->laddr_check(net, addr, scope_id) == 0) &&
	    (!trans->t_owner || try_module_get(trans->t_owner))) {

and that module reference is released only by rds_trans_put() in
rds_release().

Would it be more accurate to describe what is fixed here as the KCSAN data
race on the plain rs->rs_conn stores plus the -EAGAIN-forever behaviour
against a quiesced cached conn, rather than a free under a sender?

> diff --git a/net/rds/send.c b/net/rds/send.c
> index 32c411d10e3ef..a83d4eca0c77c 100644
> --- a/net/rds/send.c
> +++ b/net/rds/send.c

[ ... ]

> @@ -1340,21 +1341,59 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
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

This is a pre-existing issue and not introduced by this patch, but the
patch does make it an explicitly supported state for rds_sendmsg() to keep
running on a connection whose rds_conn_destroy() is in progress ("it is
only quiesced; the free is held off by the sender's reference").

Is the quiesce synchronized against a sender that is already past this
rds_destroy_pending() test?

rds_conn_path_quiesce() walks and unlinks cp_send_queue with no cp_lock
held, and BUG_ON()s on any message a socket still has linked:

net/rds/connection.c:rds_conn_path_quiesce() {
	/* tear down queued messages */
	list_for_each_entry_safe(rm, rtmp,
				 &cp->cp_send_queue,
				 m_conn_item) {
		list_del_init(&rm->m_conn_item);
		BUG_ON(!list_empty(&rm->m_sock_item));

Meanwhile rds_sendmsg() tests rds_destroy_pending(conn) once and can then
block for an unbounded time in rds_cong_wait() and in the
wait_event_interruptible_timeout() retry loop before rds_send_queue_rm()
inserts the message under cp_lock, with no re-test at insertion.

The unlocked traversal is addressed later in the same series by "net/rds:
take cp_lock to purge cp_send_queue in the quiesce", which splices the
queue under cp_lock.  The remaining window - a message landing on
cp_send_queue after the purge - still needs a destroy running under a live
sender, which does not look reachable at this commit for the reasons above.

[ ... ]

> @@ -1474,6 +1513,8 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
>  		kfree(vct.vec[ind].iov);
>  	kfree(vct.vec);
>  
> +	rds_conn_put(conn);
> +
>  	return payload_len;
>  
>  out:
> @@ -1481,6 +1522,9 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
>  		kfree(vct.vec[ind].iov);
>  	kfree(vct.vec);
>  
> +	if (conn)
> +		rds_conn_put(conn);
> +

[Severity: Medium]

Can either of these puts (or the rds_conn_put(old) in the install path
above) be the final reference while a message that this same call queued is
still linked on cp->cp_send_queue?

At this commit rds_send_queue_rm() stores the connection and path pointers
into the message but takes only a message reference:

net/rds/send.c:rds_send_queue_rm() {
	...
		rds_message_populate_header(&rm->m_inc.i_hdr, sport, dport, 0);
		rm->m_inc.i_conn = conn;
		rm->m_inc.i_conn_path = cp;
		rds_message_addref(rm);

and the socket side later dereferences both:

net/rds/send.c:rds_send_drop_to() {
		conn = rm->m_inc.i_conn;
		if (conn->c_trans->t_mp_capable)
			cp = rm->m_inc.i_conn_path;
		else
			cp = &conn->c_path[0];

		spin_lock_irqsave(&cp->cp_lock, flags);

after rds_conn_destroy_fini() has done kfree(conn->c_path) and
kmem_cache_free(rds_conn_slab, conn).

A later patch in this series, "net/rds: hold a connection reference from
struct rds_incoming" (fe1de9d527be), adds rds_conn_get(conn) in
rds_send_queue_rm() immediately before the i_conn store, released from
rds_message_put(), which closes this gap.  Hitting it at this commit also
requires rds_conn_destroy() to run while a socket still has a message
queued on that connection, which does not look reachable here.

Would it make sense to order the rds_incoming reference patch ahead of this
one, or to note the dependency in the commit message?

> diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
> index 8a0c54aced5ea..7fea5501d7567 100644
> --- a/net/rds/tcp_listen.c
> +++ b/net/rds/tcp_listen.c

[ ... ]

> @@ -277,6 +278,12 @@ int rds_tcp_accept_one(struct rds_tcp_net *rtn)
>  	cp = rs_tcp->t_cpath;
>  	conn_state = rds_conn_path_state(cp);
>  	WARN_ON(conn_state == RDS_CONN_UP);
> +	/* A connection whose destroy has begun cannot be found here:
> +	 * TCP connections are only destroyed on netns teardown and on
> +	 * module unload, and both run rds_tcp_listen_stop() - which
> +	 * flushes this work and clears the listen socket that the top
> +	 * of this function tests - before any connection is destroyed.
> +	 */

[Severity: Low]

The comment credits rds_tcp_listen_stop() with clearing the listen socket,
but that helper is handed the socket by value and never touches
rtn->rds_tcp_listen_sock:

net/rds/tcp_listen.c:rds_tcp_listen_stop() {
	...
	flush_workqueue(rds_wq);
	flush_work(acceptor);
	sock_release(sock);
}

The pointer is cleared by the caller, just before it calls the helper:

net/rds/tcp.c:rds_tcp_kill_sock() {
	...
	rtn->rds_tcp_listen_sock = NULL;
	rds_tcp_listen_stop(lsock, &rtn->rds_tcp_accept_w);

The clear-then-flush-then-destroy ordering the safety argument relies on
does hold, but it comes from rds_tcp_kill_sock().  Could the comment name
that function instead?

> +	if (conn_state != RDS_CONN_CONNECTING && conn_state != RDS_CONN_ERROR) {
>  		rds_conn_path_drop(cp, 0);
>  		goto rst_nsk;

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260922085410.391323-1-achender%40kernel.org
