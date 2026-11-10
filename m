Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794319075;
	b=2wn1IC6xkpNw/ShxnFCppHwF5aZMp8lbbF9nQp+4ktsLAZl88YaznEqy9oG+I2R5mFE/
	 hS4P5O2ue2MhJUEDjXnKXwFwid/sgVHTyrSeqspGmRmCnj9gBVXC3+BBe8yQre1eVETzd
	 1/Pt7veSwHZqBIfOQvG/21DkL+xkr8fiw1R07HprJ0pQeiN9S5fQpTSvdXUIJOQWVZMYe
	 VMPpVdcW/+zmG5fp9kQiVzvz7WbZ7XkmYJhFzsrDq33xLnlMJZ/bglgOXEei6864qJmm+
	 uhWH7CJ2Qy4KE4BdPkKQ4OioCCkqDNH7EtXM0/mHcINXuCghuK+ydiqNVa+ZRxEcXdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794319075;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=YFjW35zvvJYki6kMAd/FYXGvh/Dc0hX3ITs/Jgj221g=;
	b=Ht25Wj7nu/7OvYGr0UR9uiWlmdWLE5qHzhGlfrOtXovXG+bJNxAnFcjQ0jMTD89aF+UP
	 9d0wvcHd8JAaKGe36RCD6ZmlZhiDWiMXo0ha6H4IOfeD1xIXjnMTYbkUvvIWl3VNc1PZe
	 c/zLIK45juFfcEHsQXn5CrqwcwUlfzm5Vk15IjPllGyatm9wUk0xThwh5z4y3CcPKX+GI
	 vRSBk2yHduTf4VDAU6wPxoRZsClrJypoNeUxz8EGGgqg5YS3Tk2E6ISI8XNcOe0/6AY76
	 xkBMeL5O+Cf6DV0h6qkxqlAccxNIAZd5n/UGNF0gPZW2EqlqqYpjde6h4Pk3M1j3k/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=krAdlZcS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8ED606A31C;
	Tue, 10 Nov 2026 13:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=krAdlZcS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6611F008BC;
	Tue, 10 Nov 2026 13:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794319074;
	bh=YFjW35zvvJYki6kMAd/FYXGvh/Dc0hX3ITs/Jgj221g=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=krAdlZcSRj0nnmM43Q8bCuQOwVZWdvkiafW4cwyjURCSVctnGpVGivC394Dj+2jnj
	 3HE6E66hnE/HFLkkj8jARceXSGMZ3HHpk/yx1ppe93IqjkAmOFnLHwwKla4B4ibukw
	 OgJgZdWP9haC41YFqXTdSOMKn1kOrksnMmHEVXLbohT2C6lvvkpnM1Lsln0RcA4dae
	 Qalx2mVlYJLap5pqvaCPWUvugpj1Wzn9jFtx4VkmeR6ksCaawUZHMmnTf4U8uDz54Z
	 3zWA4t+wvUZjobEprnJhoY9E8Vj2YeGaBviQOoj3bhu/HEvf+1FZMbBl45HWVcisJp
	 hNM5mMjnc71FQ==
Subject: Re: [PATCH net-next v11 08/12] net/rds: hold a connection reference
 from struct rds_incoming
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Tue, 10 Nov 2026 13:57:53 +0000
Message-ID: <179431907345.994134.1298028433995703002@kernel.org>
In-Reply-To: <20261106031615.1047052-9-achender@kernel.org>
References: <20261106031615.1047052-9-achender@kernel.org>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] With this patch, every rds_incoming holds a reference on its
  connection.

--

net/rds: hold a connection reference from struct rds_incoming

This patch makes every holder of rds_incoming->i_conn own a connection
reference. The references are taken in rds_inc_init(), rds_inc_path_init(),
rds_recv_incoming() and the three m_inc assignment sites in send.c. They
are dropped from rds_inc_put() and from a new rds_message_free() helper,
which fixes a use-after-free when a transport unload destroys a connection
that queued incs still point at.

Closes: https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.dev@gmail.com/

[ ... ]

> diff --git a/net/rds/recv.c b/net/rds/recv.c
> index 00ab60f2d9969..e4cae82c16818 100644
> --- a/net/rds/recv.c
> +++ b/net/rds/recv.c
> @@ -46,6 +46,7 @@ void rds_inc_init(struct rds_incoming *inc, struct rds_connection *conn,
>  {
>  	refcount_set(&inc->i_refcount, 1);
>  	INIT_LIST_HEAD(&inc->i_item);
> +	rds_conn_get(conn);	/* put in rds_inc_put() */
>  	inc->i_conn = conn;
>  	inc->i_conn_path = NULL;
>  	inc->i_saddr = *saddr;

[Severity: Medium]
With this reference, an unread inc on a socket receive queue keeps its
connection, and so the transport's t_conn_count, elevated until the
application reads the datagram or closes the socket. Can that block
rmmod of a transport forever?

rds_tcp_exit() and rds_ib_exit() both call rds_conn_wait_conns_freed().
That loop exits only when t_conn_count reaches zero:

net/rds/connection.c:rds_conn_wait_conns_freed() {
    ...
	while (!wait_event_timeout(rds_conn_freed_waitq,
				   !atomic_read(&trans->t_conn_count),
				   msecs_to_jiffies(RDS_CONN_FREE_POLL_MS))) {
    ...
}

The loop never checks for signals, so nobody can kill the rmmod task, and
the module stays in MODULE_STATE_GOING. The task wakes every 100ms, so the
hung-task detector doesn't report it either. The only sign is the pr_warn
every 10 seconds.

rds_find_bound() matches only on address, port and scope_id. It doesn't
compare rs->rs_transport with conn->c_trans. A socket bound with one
transport (through SO_RDS_TRANSPORT or rds_trans_get_preferred()) can
therefore queue incs that arrived over another transport's connection,
without holding a module reference on that transport:

  unprivileged process: binds an RDS socket using IB, never reads it
  remote peer: connects to the rds_tcp listener and sends to that port
    rds_recv_incoming()->rds_find_bound() matches the IB-bound socket
    the inc is queued on rs_recv_queue, holding a TCP conn reference
  admin: rmmod rds_tcp
    rds_tcp_exit()->rds_conn_wait_conns_freed() never returns

Before this patch, only the hash-table reference and short-lived
references pinned a connection, so the wait added earlier in the series
always finished.

The commit message says this is intended:

  "It also means the transport cannot unload while such a datagram is
   unread ... That is the intended behaviour"

However, it lets an unprivileged application decide how long a privileged
unload stays stuck. Could the unload path instead purge the departing
transport's incs from socket receive queues? Or could the wait be made
interruptible or abortable?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261106031615.1047052-1-achender%40kernel.org
