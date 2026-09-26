Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DACA3DB655;
	Sat, 26 Sep 2026 09:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790416130; cv=none; b=s6DBvuMB7YQ68E7WXRnNB2t7y05JpSkchHB4Gx0e17nwLJysj9LgtUQAm2QuIvN8e71V5W+kqK9ynk7fVxTT4i6gv61DG8CiCbD4Va3l3Zd1LURPKo+DLQs6+6rHwIRXO4zqAAEvAzmlLM6AMx6Px+Yky/2T1qKyI7pzb/2+TXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790416130; c=relaxed/simple;
	bh=oXPbJfKgTiRTzPxoW9SROHfjRU8dwsqT1ejV6qs8Oco=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ArqRX8Ce1me/NuIuFho19ilyRrPwaecSc9uNCUwzGLc3et4YPS8zxoraLdCsKMGLrxCAEXUB8dbO2HCOfHIQeIdCzmYpLkazRqgS/iTN/XpV/WYziB6ZEsNcC4+35r9EPOA/GyYhGfjewnBrZMZismfeNRXUEdODeoS2up6JnOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YOIEh7Ul; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YOIEh7Ul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30A31F00898;
	Sat, 26 Sep 2026 09:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790416123;
	bh=MKN/ezJDrrRUVrjye7FMwmigd2DklCm3phdsK1glATE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=YOIEh7Ul2+0965BYkcMzBsQPl6bKWdfIlIc8e06DB6/hoC/MXEFhbJ2n5unSC5UM0
	 ABWbMYMVtJxXs7/EsMIpWEhLFou3LY1n/t/XcFfwBhWG7wKKurulrcqEawh2EPqbWv
	 7fVDGIeEV0qND5co32BzFQwwyfykc1c0TaXi9Mqi9x81cOTvGCg49ZKeNVkofLBvyt
	 DKlKu6e1qBqbCT6035/Czia57awrs66EGUBJIF64/JvoKKW0iMGaEszykv2ny2FvjU
	 RnKDEZtiCPzf3ZvTGdROq64+3tzl93Eyq9ufsG4arRL4ICaDYmhfhsbHoSoPE3H87z
	 i5pAxB0aZtZQA==
Subject: Re: [PATCH net-next v6 09/12] net/rds: take cp_lock to purge
 cp_send_queue in the quiesce
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Sat, 26 Sep 2026 09:48:42 +0000
Message-ID: <179041612254.2160803.3409652005805851829@kernel.org>
In-Reply-To: <20260922085410.391323-10-achender@kernel.org>
References: <20260922085410.391323-10-achender@kernel.org>
X-sashiko-severity: High
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

Critical: 0 · High: 1 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The commit message asserts that splicing cp_send_queue under
  cp_lock makes the purge "correct against a concurrent adder…
- [Medium] Undisclosed, unrelated hunk: the patch reverts
  `READ_ONCE(rs->rs_tos)` back to a plain `rs->rs_tos` load at the…

--

net/rds: take cp_lock to purge cp_send_queue in the quiesce

rds_conn_path_quiesce() used to walk cp_send_queue with no lock while every
adder links onto that list under cp_lock.  This patch splices the queue away
under cp_lock and drops the message references outside it.  A second hunk in
net/rds/send.c changes the rs_tos argument passed to
rds_conn_create_outgoing().

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index 9b86070814a72..adeaf35d0ed06 100644
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
> @@ -617,10 +619,15 @@ void rds_conn_shutdown(struct rds_conn_path *cp)
>  	rds_conn_path_drop(cp, true);
>  	flush_work(&cp->cp_down_w);
>  
> -	/* tear down queued messages */
> -	list_for_each_entry_safe(rm, rtmp,
> -				 &cp->cp_send_queue,
> -				 m_conn_item) {
> +	/* Tear down queued messages.  Every path that adds to
> +	 * cp_send_queue does so under cp_lock; take it here too rather
> +	 * than rely on the argument that nothing can be adding at this
> +	 * point.
> +	 */
> +	spin_lock_irqsave(&cp->cp_lock, flags);
> +	list_splice_init(&cp->cp_send_queue, &purge);
> +	spin_unlock_irqrestore(&cp->cp_lock, flags);
> +	list_for_each_entry_safe(rm, rtmp, &purge, m_conn_item) {
>  		list_del_init(&rm->m_conn_item);
>  		BUG_ON(!list_empty(&rm->m_sock_item));
>  		rds_message_put(rm);

[Severity: High]
The commit message says the purge is now "correct against a concurrent adder
regardless", and the new comment in rds_conn_path_quiesce() repeats that.
Does taking cp_lock around list_splice_init() actually give that property?
The splice makes the list manipulation atomic, but it does not establish any
state that stops an adder, so there seem to be two cases left.

First, if the adder wins the race just before the splice.  rds_send_queue_rm()
links the socket item first, under rs_lock:

net/rds/send.c:rds_send_queue_rm() {
	...
	list_add_tail(&rm->m_sock_item, &rs->rs_send_queue);
	...
	spin_lock(&cp->cp_lock);
	rm->m_inc.i_hdr.h_sequence = cpu_to_be64(cp->cp_next_tx_seq++);
	list_add_tail(&rm->m_conn_item, &cp->cp_send_queue);
	...
}

So a message contributed by a live sender is spliced with m_sock_item still
on rs->rs_send_queue, and the retained assertion in the purge loop

	BUG_ON(!list_empty(&rm->m_sock_item));

fires for exactly the message the locking was added to cope with.  Does this
turn a racy walk into a deterministic BUG() in that case?

Second, if the adder wins just after the splice.  list_splice_init() is a
one-shot snapshot, and neither rds_send_queue_rm() nor rds_send_probe()
re-tests rds_destroy_pending() under cp_lock.  The only destroy test before
queueing is in rds_sendmsg(), taken outside cp_lock and with a potentially
blocking rds_cong_wait() in between:

net/rds/send.c:rds_sendmsg() {
	...
	if (rds_destroy_pending(conn)) {
		ret = -EAGAIN;
		goto out;
	}
	...
	ret = rds_cong_wait(conn->c_fcong, dport, nonblock, rs);
	...
	while (!rds_send_queue_rm(rs, conn, cpath, rm, rs->rs_bound_port,
				  dport, &queued)) {
	...
}

Is anything revisiting a message linked after the unlock?  rds_conn_destroy()
runs the quiesce once under c_destroy_in_prog, and rds_conn_path_free() /
rds_conn_destroy_fini() neither drain nor warn about cp_send_queue, so the
connection's reference on that rds_message looks leaked.  For a
rds_send_probe() message that reference is the only owner.  For a sendmsg
message, rm->m_conn_path keeps pointing into the c_path array that
rds_conn_destroy_fini() kfree()s, which would be a use-after-free when the
socket later closes and rds_send_drop_to() takes rm->m_conn_path->cp_lock.

Would mutual exclusion rather than atomicity be needed here - adders testing
the connection's destroy state under cp_lock, or the quiesce publishing a
"queue closed" marker under cp_lock - plus handling rather than asserting on a
message still owned by a socket?  At minimum, would a
WARN_ON(!list_empty(&cp->cp_send_queue)) re-check after the splice make a
missed message diagnosable?

For what it is worth, with the destroy triggers that exist at this commit and
at the end of the series (netns teardown and transport module unload, both of
which exclude a live sending socket), I could not construct a sending socket
that reaches this today, so the trigger appears unproven in the current tree.
The code in rds_conn_path_quiesce() is unchanged at the end of the series.

> diff --git a/net/rds/send.c b/net/rds/send.c
> index a83d4eca0c77c..2d7839438abdc 100644
> --- a/net/rds/send.c
> +++ b/net/rds/send.c
> @@ -1366,8 +1366,7 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
>  
>  		conn = rds_conn_create_outgoing(sock_net(sock->sk),
>  						&rs->rs_bound_addr, &daddr,
> -						rs->rs_transport,
> -						READ_ONCE(rs->rs_tos),
> +						rs->rs_transport, rs->rs_tos,

[Severity: Medium]
Is this hunk intentional?  The subject and the changelog describe only the
cp_lock and list_splice change in rds_conn_path_quiesce() and never mention
net/rds/send.c or rs_tos, but this reverts the READ_ONCE() that the
immediately preceding patch of the series, "net/rds: hold connection
references in lookup, sockets and c_passive", added here.  That patch's
message states that "the create in rds_sendmsg() samples rs_tos without the
lock".

The comment it added is still right below, and now documents a lockless read
that the code no longer marks:

net/rds/send.c:rds_sendmsg() {
	...
		/* rs_tos was sampled without rs_lock for the create above,
		 * and SIOCRDSSETTOS only refuses a change once rs_conn is
		 * set, so it can have changed underneath us.
	...
}

The concurrent writer is the SIOCRDSSETTOS path in rds_ioctl(), a plain store
under rs_lock reachable from unprivileged userspace, and every other rs_tos
access in net/rds/ is taken under rs_lock, so after this change this is the
only unmarked side of a plain/plain concurrent access.

rs_tos is a u8 so it cannot tear, and the sampled value is re-validated under
rs_lock a few lines further down before the connection is installed, so the
observable effect looks limited to a KCSAN report plus a hunk the changelog
does not describe.  The plain read is still there at the end of the series, so
no later patch restores it.  Would restoring the READ_ONCE(), or splitting the
removal into its own patch with a justification, be preferable?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260922085410.391323-1-achender%40kernel.org
