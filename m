Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8768D3AF64D;
	Wed, 16 Sep 2026 04:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789533410; cv=none; b=iBZMYOf08fdLoeIeG5kWJ/O2l9T8qULNXNcKScMJTLfA/STioSFKjrHqzwUjlYC9iTe5cxoSs+9U7iHL6rc50e1tVDsJ5Q8gxqYWSdMLGSABljU02HFW6qKllzR7ynCYMPMCFwGhmcQ0KyhiVuEQucBIPr0fF+SvwITJX6LT8MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789533410; c=relaxed/simple;
	bh=L1pzec/OWbM5U8gj/wJ0y9GZasTpYahKyy3imEdJGus=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dizEcqeSF+EB5MubvrvoWKDa9zfX5sWsRHGlcEtmEm1Wy4kiSQA38IAWiGhChhh0WJGfiBXPAg1Tza+NWRGmf2/ya1AnsJrOEcI51CWV82F81HRiBtc388viZvKR248XYWVWqrYc0bMOJoAhk+x1crdhJ6gg4R7eYVMwRiLzFX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n8u2Vbli; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n8u2Vbli"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A061F00893;
	Wed, 16 Sep 2026 04:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789533408;
	bh=oXk8SS7aIGHF0UaJcj3BzXY89JCSuV8eb99EhYDOZOA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=n8u2VbliGJ5WEJL3vi+SZdDtT0ZUiR9yQ+aFTTyWmBv3ccURPGWAtLaEZ9e5KEsFU
	 YsERA6XdjfU2OTXrSnHRQlpUpWKHlMH8nYKiq9FnHtz89qoeMlXsUFOVUtd4StRC7u
	 GVlI23/BgAJnHfnUsBX+o2vb6kAYTNFHDe5Nirxt+USZNbSdD7aNthjiVyuFCGFGDd
	 OeayBHkLloeJl4cAVoGDyGdPPduU8vqVqIum0y+iA1SZM+jehUln+MzuvPDq+EC+ho
	 U6oV0vgE8UpCi3aAkq5hh0CZ55vlUz1+rKurXUrwixQdXBjuQ4RcYDtofKVsaCVJ5d
	 pPdQDA5Gnrs/Q==
Subject: Re: [PATCH net-next v2 5/9] net/rds: unlink transport nodes before a
 possibly deferred connection free
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Wed, 16 Sep 2026 04:36:47 +0000
Message-ID: <178953340756.22033.6429864814126761152@kernel.org>
In-Reply-To: <20260912035027.27447-6-achender@kernel.org>
References: <20260912035027.27447-6-achender@kernel.org>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 4 potential
issue(s) to consider:

Critical: 0 · High: 2 · Medium: 1 · Low: 1

- [High] rds_ib_destroy_nodev_conns() (net/rds/ib_rdma.c:161) moves the
  global nodev list with list_splice(&ib_nodev_conns, &tmp_list) at line…
- [High] The fix is incomplete: the teardown helpers still walk the
  gathered stack list and dereference the transport node without holding…
- [Medium] The new list_del_init(&ic->ib_node) in
  rds_ib_destroy_nodev_conns() (net/rds/ib_rdma.c:178) leaves a still-…
- [Low] Commit message describes a live memory-corruption bug that is not
  reachable at this commit.

--

net/rds: unlink transport nodes before a possibly deferred connection free

The transport teardown helpers gather per-connection transport nodes onto a
list head on their own stack and call rds_conn_destroy() for each.  This
patch moves the node unlink out of the transport conn_free() callbacks and
into the teardown loops, under the transport lock, so that nothing is left
on the stack list once the helper returns.

A few questions on the change and on the commit message below.

Starting with the commit message:

> That was fine while rds_conn_destroy() freed the connection before it
> returned.  Once the free is governed by the connection's reference
> count, a holder that outlives the teardown loop - a socket's cached
> rs_conn, an inc parked on a receive queue - defers conn_free() until
> after the helper has returned, and the list_del() then writes the
> neighbours' pointers into a stack frame that no longer exists.

[Severity: Low]
Is that holder reachable at this commit?  rds_conn_get() has no callers in
net/rds at this revision, so the reference taken by __rds_conn_create() is
the only one and the rds_conn_put() at the end of rds_conn_destroy():

net/rds/connection.c:rds_conn_destroy() {
	...
	/* drop the initial reference; the connection is freed from
	 * rds_conn_destroy_fini() once every holder has dropped theirs
	 */
	rds_conn_put(conn);
}

is always the last one.  rds_conn_destroy_fini() -> rds_conn_path_free() ->
trans->conn_free() therefore still runs inside the teardown loop here, and
no list_del() can land on a dead frame yet.

The named holders (a socket's cached rs_conn, an inc on a receive queue)
only appear with the later patches in the series that add rds_conn_get()
calls in recv.c and send.c.

Could the message say that this is a prerequisite for those patches rather
than a fix for a currently reachable corruption?  As written, a backporter
would read it as a standalone fix, and there is no Fixes: tag to anchor it.

> diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
> index 4feb0edc360c8..de5759c50b89a 100644
> --- a/net/rds/ib_cm.c
> +++ b/net/rds/ib_cm.c
> @@ -1282,7 +1282,9 @@ void rds_ib_conn_free(void *arg)
>  	lock_ptr = ic->rds_ibdev ? &ic->rds_ibdev->spinlock : &ib_nodev_conns_lock;
>  
>  	spin_lock_irq(lock_ptr);
> -	list_del(&ic->ib_node);
> +	/* already unlinked if a transport teardown gathered us first */
> +	if (!list_empty(&ic->ib_node))
> +		list_del(&ic->ib_node);
>  	spin_unlock_irq(lock_ptr);

[Severity: Medium]
This makes an empty ib_node mean "already detached", but two assertions in
ib_rdma.c still treat an empty ib_node on a live connection as impossible:

net/rds/ib_rdma.c:rds_ib_add_conn() {
	spin_lock_irq(&ib_nodev_conns_lock);
	BUG_ON(list_empty(&ib_nodev_conns));
	BUG_ON(list_empty(&ic->ib_node));
	list_del(&ic->ib_node);
	...
}

net/rds/ib_rdma.c:rds_ib_remove_conn() {
	spin_lock_irq(&rds_ibdev->spinlock);
	BUG_ON(list_empty(&ic->ib_node));
	list_del(&ic->ib_node);
	...
}

After the sweep in rds_ib_destroy_nodev_conns() does list_del_init(), the ic
is still live: c_destroy_in_prog is only set once rds_conn_destroy() is
entered, and the path workers have not been quiesced yet.  A connect worker
already running on that connection's own cp_wq (allocated per connection in
__rds_conn_create(), so not drained by the flush_workqueue(rds_wq) in
rds_ib_unregister_client()) reaches rds_ib_conn_path_connect() ->
rds_ib_setup_qp() -> rds_ib_add_conn() and would hit the first BUG_ON.

If instead the connect wins and moves the node onto rds_ibdev->conn_list,
the sweep empties it again and the following rds_ib_conn_path_shutdown() ->
rds_ib_remove_conn() hits the second BUG_ON.

TCP sidesteps this by carrying an explicit t_tcp_node_detached flag rather
than overloading list emptiness.  Would an equivalent flag, or dropping the
two BUG_ONs, be preferable for IB?

> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
> index db7e92e7bd29f..b30f2a3715878 100644
> --- a/net/rds/ib_rdma.c
> +++ b/net/rds/ib_rdma.c
> @@ -168,8 +168,18 @@ void rds_ib_destroy_nodev_conns(void)
>  	list_splice(&ib_nodev_conns, &tmp_list);
>  	spin_unlock_irq(&ib_nodev_conns_lock);
>  
> -	list_for_each_entry_safe(ic, _ic, &tmp_list, ib_node)
> +	/* rds_conn_destroy() can return before the connection is freed,
> +	 * and it is the free - rds_ib_conn_free() - that unlinks ib_node.
> +	 * tmp_list lives on this stack frame, so unlink each node before
> +	 * its destroy; the free then finds it empty and leaves it alone.
> +	 */
> +	list_for_each_entry_safe(ic, _ic, &tmp_list, ib_node) {
> +		spin_lock_irq(&ib_nodev_conns_lock);
> +		list_del_init(&ic->ib_node);
> +		spin_unlock_irq(&ib_nodev_conns_lock);
> +
>  		rds_conn_destroy(ic->conn);
> +	}
>  }

[Severity: High]
Does the splice here leave ib_nodev_conns pointing at the gathered nodes?
There is no INIT_LIST_HEAD(&ib_nodev_conns) after the list_splice(), unlike
the loopback side in this same patch:

net/rds/loop.c:rds_loop_exit() {
	spin_lock_irq(&loop_conns_lock);
	list_splice(&loop_conns, &tmp_list);
	INIT_LIST_HEAD(&loop_conns);
	spin_unlock_irq(&loop_conns_lock);
	...
}

list_splice() only relinks the entries, so ib_nodev_conns.next still points
at the first gathered ib_node and .prev at the last, and the new
list_del_init() repairs tmp_list only - it leaves each gathered node
self-linked and never touches the global head.

rds_ib_exit() then calls this helper again as the resweep callback:

net/rds/ib.c:rds_ib_exit() {
	...
	rds_ib_destroy_nodev_conns();
	rds_conn_wait_conns_freed(&rds_ib_transport,
				  rds_ib_destroy_nodev_conns);
	...
}

and rds_conn_wait_conns_freed() invokes resweep() on every poll timeout
while t_conn_count is non-zero:

net/rds/connection.c:rds_conn_wait_conns_freed() {
	while (!wait_event_timeout(rds_conn_freed_waitq,
				   !atomic_read(&trans->t_conn_count),
				   msecs_to_jiffies(RDS_CONN_FREE_POLL_MS))) {
		if (resweep)
			resweep();
	...
}

On that second call, does __list_splice() write first->prev / last->next
into rds_ib_connection objects that rds_ib_conn_free() may already have
kfree()d?  And with the first gathered node self-linked, does
list_for_each_entry_safe() compute n == pos on every pass, so the sweep
never terminates and keeps calling rds_conn_destroy(ic->conn) on a conn
pointer read out of freed memory?

Separately, a late arrival through the stale head:

net/rds/ib_rdma.c:rds_ib_remove_conn() {
	...
	list_add_tail(&ic->ib_node, &ib_nodev_conns);
	...
}

dereferences ib_nodev_conns.prev, which after the sweep points at a
gathered node.  Is that write safe once that node has been freed?

> diff --git a/net/rds/tcp.c b/net/rds/tcp.c
> index 826e4629e4eee..a71d6a4f0939c 100644
> --- a/net/rds/tcp.c
> +++ b/net/rds/tcp.c
> @@ -502,6 +502,28 @@ static bool rds_tcp_is_unloading(struct rds_connection *conn)
>  	return atomic_read(&rds_tcp_unloading) != 0;
>  }
>  
> +/* Destroy the connections whose nodes were gathered on @tmp_list.
> + *
> + * rds_conn_destroy() can return before the connection is freed, and
> + * it is the free - rds_tcp_conn_free() - that unlinks t_tcp_node.
> + * Since @tmp_list lives on the caller's stack, unlink each node here
> + * and mark it detached before its destroy, so that a free that runs
> + * after the caller has returned does not write into a dead frame.
> + */
> +static void rds_tcp_destroy_gathered_conns(struct list_head *tmp_list)
> +{
> +	struct rds_tcp_connection *tc, *_tc;
> +
> +	list_for_each_entry_safe(tc, _tc, tmp_list, t_tcp_node) {
> +		spin_lock_irq(&rds_tcp_conn_lock);
> +		list_del_init(&tc->t_tcp_node);
> +		tc->t_tcp_node_detached = true;
> +		spin_unlock_irq(&rds_tcp_conn_lock);
> +
> +		rds_conn_destroy(tc->t_cpath->cp_conn);
> +	}
> +}

[Severity: High]
Does this still leave the not-yet-visited entries exposed?  Only the node
the cursor is currently on gets detached; every other tc parked on tmp_list
still has t_tcp_node_detached == false, so a concurrent last put takes the
list_del() path here and frees the object:

net/rds/tcp.c:rds_tcp_conn_free() {
	spin_lock_irqsave(&rds_tcp_conn_lock, flags);
	if (!tc->t_tcp_node_detached)
		list_del(&tc->t_tcp_node);
	spin_unlock_irqrestore(&rds_tcp_conn_lock, flags);

	kmem_cache_free(rds_tcp_conn_slab, tc);
}

The walk holds no connection reference, so can the iterator then read
list_next_entry() out of freed slab memory, write list_del_init() and
tc->t_tcp_node_detached into it, and call rds_conn_destroy() on a conn
pointer fetched from it?

There also looks to be a window on the current node: after list_del_init()
nothing pins tc, so can a racing last put free it before
tc->t_cpath->cp_conn is evaluated on the next statement?

rds_loop_destroy_gathered_conns() in loop.c and the reworked
rds_ib_destroy_nodev_conns() in ib_rdma.c walk their stack lists the same
way, with lc->conn and ic->conn read after the unlink.

The freeing side seems reachable for a gathered connection whose destroy
already ran - rds_conn_destroy() notes this itself:

net/rds/connection.c:rds_conn_destroy() {
	...
	 * a conn can be handed to rds_conn_destroy() more than once -
	 * e.g. dropped for a protocol version mismatch and then found
	 * again at module unload.
	...
}

For such a connection the free is governed entirely by a remaining holder,
which can drop it at any point during the walk.  Would taking
rds_conn_get() on each gathered connection under the transport lock and
putting it after rds_conn_destroy() cover both the current and the pending
entries?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260912035027.27447-1-achender%40kernel.org
