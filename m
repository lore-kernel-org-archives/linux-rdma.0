Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB5331F9B5;
	Thu, 10 Sep 2026 01:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789002188; cv=none; b=XcdIrxncp8IDj7CpCTkiIHmi336T39nNSoOQTQhfwH3fMtrWtLSIlA5BrynszbzWemA+jXOBGuVu8Z3YrAw71I4RmZJ1jr2Cbizffo2MiXeXiyaQw17TdwfnVGGwcNyXVM6H93LyWqmCQsb70LVXnmjkulzduhB8Yxqv2f9m7DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789002188; c=relaxed/simple;
	bh=d5QL8AnkDVn8WAYRTHqsEZWd4KWMI6QxyGGsV1ZYnCE=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QblW9REbPYQJcaphuJyaSn3IFuazbIHF8NuHt+shJfc9tPEM110BjBIfnpGeuruK6OmkkiF17Q7vUWxsCkxdgBmHOEnLp7FZfczJqA9JuSBkOWFjV4oL70X/EFiyqDzAqUNny9474kAs+uFjx5SJn5M1RAi0INFkYZRUQdGCbng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A4WcNMSb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A4WcNMSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73BF21F00893;
	Thu, 10 Sep 2026 01:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789002186;
	bh=0lD1sueg04AFMoBga4KGcfl4CNqNs75i4mugNORlnVA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=A4WcNMSb9+EaPURkRK/OR1c7ChXNPaNRqjwYZTt7plyWRfnnv/NzsTxhm2bj4rF8s
	 3cG5i+0nP54h9/oakbk6TZpl2xyS3gGGjkJV/iwgtj5o8MeuZBY0+AAorYNT4pl7Ql
	 pqWueSHheZxy9nklDgg2MwXfGpoMgKKLIPSXreFTbsSbB7O8Wgi+wkMhzl0h9X8GvC
	 6stdnnnuTQ5GF0jU4DTO2Ziy3zB5j7mdMmbOhMcc6oNbuPewWy/B7QyCELnax65ZV8
	 tjza87gk2nX6dok0wxNpuoeWbHtzhBp+qGMhS7/TOpv8/IBmYq4t5HEIfPAlrkspgr
	 ENSSSPR/VOCFQ==
Subject: Re: [PATCH net-next 6/6] net/rds: hold a connection reference from
 struct rds_incoming
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Thu, 10 Sep 2026 01:03:06 +0000
Message-ID: <178900218605.219967.1439957833741038840@kernel.org>
In-Reply-To: <20260904070248.160384-7-achender@kernel.org>
References: <20260904070248.160384-7-achender@kernel.org>
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
issue(s) to consider:

Critical: 0 · High: 1 · Medium: 1 · Low: 0

- [High] Module-unload barrier defeated: incs/messages parked on a socket
  now hold a `struct rds_connection` reference for a userspace-…
- [Medium] The commit message understates the cost and the residual
  exposure of the new reference.

--

net/rds: hold a connection reference from struct rds_incoming

This makes every holder of struct rds_incoming->i_conn own a connection
reference: the six assignment sites take one, and rds_inc_put() and the
new rds_message_free() helper drop it.  The stated goal is to stop
dereferences of i_conn from touching a connection that was already freed
by device removal, netns teardown or module unload.

Closes: https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.dev@gmail.com/

First, a question about the commit message itself:

>     This keeps a connection allocated for as long as messages that arrived
>     over it are queued on sockets, which is longer than before but costs
>     only the connection's memory: rds_conn_destroy() still quiesces the
>     connection synchronously, so a lingering inc holds nothing running.

[Severity: Medium]
Is "costs only the connection's memory" accurate?  A lingering inc keeps
trans->t_conn_count non-zero, and that counter only reaches zero from
rds_conn_destroy_fini():

net/rds/connection.c:rds_conn_destroy_fini() {
	for (i = 0; i < npaths; i++)
		rds_conn_path_free(&conn->c_path[i]);
	...
	if (!atomic_dec_return(&trans->t_conn_count))
		wake_up_all(&rds_conn_freed_waitq);
}

so unloading a transport while a datagram sits unread stalls for
RDS_CONN_FREE_TIMEOUT_MS and then warns:

net/rds/connection.c:rds_conn_wait_conns_freed() {
	if (!wait_event_timeout(rds_conn_freed_waitq,
				!atomic_read(&trans->t_conn_count),
				msecs_to_jiffies(RDS_CONN_FREE_TIMEOUT_MS)))
		WARN(1, "RDS/%s: %d connection(s) not freed\n",
		     trans->t_name, atomic_read(&trans->t_conn_count));
}

Does "holds nothing running" also hold?  destroy_workqueue() and the
transport's per-connection state are released only at the final put:

net/rds/connection.c:rds_conn_path_free() {
	if (cp->cp_wq != rds_wq) {
		destroy_workqueue(cp->cp_wq);
		cp->cp_wq = NULL;
	}

	cp->cp_conn->c_trans->conn_free(cp->cp_transport_data);
}

so the per-path workqueues and, for IB, the connection's ic with its
receive caches stay allocated for as long as the new reference is held.
Could the message mention the 10 second unload stall plus WARN, and that
the per-path workqueues and transport state are kept alive too?

> diff --git a/net/rds/message.c b/net/rds/message.c
> index f25f2592586f7..29e95028e61e4 100644
> --- a/net/rds/message.c
> +++ b/net/rds/message.c
> @@ -182,6 +182,18 @@ static void rds_message_purge(struct rds_message *rm)
>  		kref_put(&rm->atomic.op_rdma_mr->r_kref, __rds_put_mr_final);
>  }
>  
> +static void rds_message_free(struct rds_message *rm)
> +{
> +	/* get in rds_send_queue_rm(), rds_send_probe() or the congestion
> +	 * map path of rds_send_xmit().  Messages that were never queued on
> +	 * a connection have no reference to drop.
> +	 */
> +	if (rm->m_inc.i_conn)
> +		rds_conn_put(rm->m_inc.i_conn);
> +
> +	kfree(rm);
> +}
> +

[ ... ]

> diff --git a/net/rds/recv.c b/net/rds/recv.c
> index 6204e577a90ae..b031c0b43af83 100644
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
> @@ -61,6 +62,7 @@ void rds_inc_path_init(struct rds_incoming *inc, struct rds_conn_path *cp,
>  {
>  	refcount_set(&inc->i_refcount, 1);
>  	INIT_LIST_HEAD(&inc->i_item);
> +	rds_conn_get(cp->cp_conn);	/* put in rds_inc_put() */
>  	inc->i_conn = cp->cp_conn;
>  	inc->i_conn_path = cp;
>  	inc->i_saddr = *saddr;
> @@ -81,9 +83,19 @@ void rds_inc_put(struct rds_incoming *inc)
>  {
>  	rdsdebug("put inc %p ref %d\n", inc, refcount_read(&inc->i_refcount));
>  	if (refcount_dec_and_test(&inc->i_refcount)) {
> +		struct rds_connection *conn = inc->i_conn;
> +
>  		BUG_ON(!list_empty(&inc->i_item));
>  
> -		inc->i_conn->c_trans->inc_free(inc);
> +		/* inc_free() can free the memory @inc lives in, so the
> +		 * connection reference has to be dropped through the
> +		 * copy taken above.
> +		 */
> +		conn->c_trans->inc_free(inc);
> +		/* get in rds_inc_init(), rds_inc_path_init() or
> +		 * rds_recv_incoming()
> +		 */
> +		rds_conn_put(conn);
>  	}
>  }
>  EXPORT_SYMBOL_GPL(rds_inc_put);

[Severity: High]
Does the new reference outlive the transport unload barrier in the module
unload case this patch targets?

The get taken in rds_inc_init()/rds_inc_path_init() is dropped only from
rds_inc_put(), i.e. when userspace calls recvmsg() or close(), so the
hold time is chosen by the application.  The unload barrier, however, is
bounded:

net/rds/connection.c:rds_conn_wait_conns_freed() {
	if (!wait_event_timeout(rds_conn_freed_waitq,
				!atomic_read(&trans->t_conn_count),
				msecs_to_jiffies(RDS_CONN_FREE_TIMEOUT_MS)))
		WARN(1, "RDS/%s: %d connection(s) not freed\n",
		     trans->t_name, atomic_read(&trans->t_conn_count));
}

and its own comment states the assumption this patch appears to break -
"anything still holding a connection reference at that point is a
short-lived lookup-style holder".

Is there a configuration where the socket does not pin the transport of
the conn it holds?  rds_find_bound() matches on daddr, dport and
bound_if only, and rds_recv_incoming() re-points the inc at the arriving
conn, so a socket bound with one transport can end up queueing an inc
whose i_conn belongs to the other transport (for example an inbound
RDS/TCP conn to an IPoIB address on a host whose sockets prefer RDS/IB).
The socket's module reference from rds_set_transport() covers only its
own transport, so rmmod of the other one is not blocked, hits the
timeout and unloads anyway.

Once that happens, doesn't the later recvmsg() or close() run these two
calls against a module that is gone?

rds_inc_put()
    conn->c_trans->inc_free(inc);
    rds_conn_put(conn)
        rds_conn_destroy_fini()
            rds_conn_path_free()
                cp->cp_conn->c_trans->conn_free(cp->cp_transport_data);
            atomic_dec_return(&trans->t_conn_count);

By that point rds_tcp_exit() has already run rds_trans_unregister() and
kmem_cache_destroy(rds_tcp_conn_slab), and rds_ib_exit() has run
rds_ib_recv_exit(), which destroys rds_ib_incoming_slab and
rds_ib_frag_slab that the queued inc and its fragments came from.
rds_recvmsg() dereferences inc->i_conn->c_trans->inc_copy_to_user the
same way.

Would the barrier need to become unbounded, or the socket-held
references dropped or detached at quiesce time, so that the reachable
dereference is not simply moved from freed conn memory to freed module
text after the timeout?

The same question applies to the send side: a message parked on a socket
send queue drops its conn reference only from rds_message_free() at
close, so it extends the connection lifetime past the unload wait too.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260904070248.160384-1-achender%40kernel.org
