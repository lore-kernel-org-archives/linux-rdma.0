Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F944B1269;
	Thu, 17 Sep 2026 09:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789637957; cv=none; b=qGF8RMT4rHyW4EiyEMawTvh7/7r2xWSmwhfxeCPRQoNlUE9PG+Z5qpQazTnAqx+qcw1kg0p9jtMpmSKAW6sqpYfVTWsvLhpHplmtCAmdEcA+ugomFGCvnituYXj9e1JafQibE02tZXZBrASNdo3TQbnezFLh4G8f8z+Z2s+FYOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789637957; c=relaxed/simple;
	bh=eZuvAwqe7p26CEUyxqSpzjRp2o7jPIbt375qqXaZB3Y=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lhjXWLFEiaUSvKJuW7YOP5Q+2GnLt7CaGttnk1DOU2GroTrA/VhzqaWzFJBD7OFvT8n7VGPVlVlc1/PWphqBdtWZ1iARwkWdlCb2D8OtQvCoTzmMcaYZHGc0DxJeJYlO89rk3L0vqrRpHSs4CMsFQyTUBxKHyi0t1/9Fg5Y8yLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QxZQmTD8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QxZQmTD8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B22B1F0089D;
	Thu, 17 Sep 2026 09:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789637925;
	bh=zdI7maQwNq11/vS0vabhGQw22emWnRVkysiaHeNXFZE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=QxZQmTD8ycK0QDQUHE50GtsD25CYoW2xJdIM3alpNLTbHGus4hCJolFm50Bi6luB4
	 1J37Ufo1GJDTq4C9hh4EtSMg4ACtQM7H6jx7SipZwRCqfmbhEGInpq+DjZqtPtgDFa
	 mGKrsXm8wn3xd8TFi4PfUASvUtJPYzKve50KePB8t2VawLcgbusMNl1qIXpiA3u+hl
	 NMmCLRT0tr8C2I2YMJzcGrt1VXORVcR5voDNg3Ys6nDaZySClTGyYROsLIHjRJCD47
	 ONcVhI2JgYSz8npCPVdzsP4iSwBlHpWG+Uf8MDyQnu6wqlzLIkW/E7UkrIZf6WR6MT
	 67TBoKVXLs5MQ==
Subject: Re: [PATCH net-next v3 07/13] net/rds: unlink transport nodes before
 a possibly deferred connection free
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Thu, 17 Sep 2026 09:38:44 +0000
Message-ID: <178963792421.22033.14748308461338014508@kernel.org>
In-Reply-To: <20260914033719.138057-8-achender@kernel.org>
References: <20260914033719.138057-8-achender@kernel.org>
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

Critical: 0 · High: 1 · Medium: 2 · Low: 1

- [High] The patch does not close the bug class its commit message claims
  to close ("Unlink each node under the transport lock right before its…
- [Medium] rds_ib_destroy_nodev_conns() (net/rds/ib_rdma.c:176-181) now
  leaves ic->ib_node in the empty state (list_del_init) while the…
- [Medium] rds_ib_destroy_nodev_conns() unlinks ic->ib_node while holding
  only ib_nodev_conns_lock (net/rds/ib_rdma.c:177-179), but the lock…
- [Low] Commit message overstates the change as a fix for a live
  corruption.

--

net/rds: unlink transport nodes before a possibly deferred connection free

The transport teardown helpers gather per-connection transport nodes onto a
stack list and call rds_conn_destroy() for each one.  This patch moves the
unlink of each transport node out of the transport conn_free() callbacks and
into the teardown loops, so a conn_free() that runs after the helper has
returned no longer touches the helper's stack list.  The conn_free()
callbacks for IB and loopback now skip a node that is already empty.

A few questions on the reference counting assumptions below.

[Severity: Low]
The changelog describes an existing corruption:

  "Once the free is governed by the connection's reference count, a holder
   that outlives the teardown loop - a socket's cached rs_conn, an inc
   parked on a receive queue - defers conn_free() until after the helper
   has returned, and the list_del() then writes the neighbours' pointers
   into a stack frame that no longer exists."

Can either of those holders exist at this commit?  rds_conn_get() in
net/rds/connection.c has no callers here - grep over net/rds only finds the
definition, the EXPORT_SYMBOL and the declaration in rds.h.  With the kref
count always at one, the rds_conn_put() at the end of rds_conn_destroy() is
always the final put, so conn_free() still runs synchronously inside the
teardown loop.

The rs_conn holder in net/rds/send.c and the inc references in
net/rds/recv.c appear later in the series, in "net/rds: hold connection
references in lookup, sockets and c_passive" and "net/rds: hold a
connection reference from struct rds_incoming".

Would it be worth saying that this patch prepares the teardown helpers for
the reference holders added by the following patches, so a reader does not
go looking for the defect (or a Fixes: tag) in the tree as it stands?

> diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
> index 118e033229aa..26a32c1ec8f7 100644
> --- a/net/rds/ib_cm.c
> +++ b/net/rds/ib_cm.c
> @@ -1287,7 +1287,9 @@ void rds_ib_conn_free(void *arg)
>  	lock_ptr = ic->rds_ibdev ? &ic->rds_ibdev->spinlock : &ib_nodev_conns_lock;
>  
>  	spin_lock_irqsave(lock_ptr, flags);
> -	list_del(&ic->ib_node);
> +	/* already unlinked if a transport teardown gathered us first */
> +	if (!list_empty(&ic->ib_node))
> +		list_del(&ic->ib_node);
>  	spin_unlock_irqrestore(lock_ptr, flags);

[Severity: Medium]
Which lock serializes this new test-then-delete against the new
list_del_init() in rds_ib_destroy_nodev_conns()?

rds_ib_conn_free() picks the lock from ic->rds_ibdev:

	lock_ptr = ic->rds_ibdev ? &ic->rds_ibdev->spinlock : &ib_nodev_conns_lock;

but rds_ib_destroy_nodev_conns() always takes ib_nodev_conns_lock.  A node
gathered on tmp_list can be migrated by rds_ib_add_conn() before the sweep
reaches it:

net/rds/ib_rdma.c:rds_ib_add_conn() {
	spin_lock_irq(&ib_nodev_conns_lock);
	...
	list_del(&ic->ib_node);

	spin_lock(&rds_ibdev->spinlock);
	list_add_tail(&ic->ib_node, &rds_ibdev->conn_list);
	spin_unlock(&rds_ibdev->spinlock);
	spin_unlock_irq(&ib_nodev_conns_lock);

	ic->rds_ibdev = rds_ibdev;
}

After that, ib_node lives on rds_ibdev->conn_list, protected by
rds_ibdev->spinlock, which is also what rds_ib_dev_shutdown() holds while
walking that list.  Would the sweep's list_del_init() then mutate a live
device list under the wrong lock, and could the list_empty()/list_del()
pair above and the sweep's list_del_init() run concurrently and unlink the
same node twice?

The reachable window looks narrow: rds_ib_destroy_nodev_conns() runs from
rds_ib_exit() after rds_ib_unregister_client(), and once the per-device
client data is cleared rds_ib_setup_qp()'s rds_ib_get_client_data() returns
NULL and it returns -EOPNOTSUPP before rds_ib_add_conn().  A thread that
already fetched rds_ibdev and is then preempted until after the splice
would still get there, though - is there something that excludes it?

> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
> index a9b27f06cbfc..91db43a0e7d7 100644
> --- a/net/rds/ib_rdma.c
> +++ b/net/rds/ib_rdma.c
> @@ -168,8 +168,18 @@ void rds_ib_destroy_nodev_conns(void)
>  	list_splice_init(&ib_nodev_conns, &tmp_list);
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
Does this actually leave nothing on the stack list for a later free to
touch?  Only the entry about to be destroyed is detached here; every entry
the loop has not visited yet is still linked on tmp_list with a non-empty
ib_node, and no reference is taken on ic->conn.

With the reference holders added later in the series, a connection whose
initial reference was already dropped by rds_ib_cm_connect_complete() on a
protocol version mismatch:

net/rds/ib_cm.c:rds_ib_cm_connect_complete() {
	...
		rds_conn_destroy(conn);
		return;
}

stays alive and stays linked on ib_nodev_conns while a socket's rs_conn or
an inc on a receive queue still owns a kref.  If that holder drops the last
reference while this loop is running:

rds_conn_destroy_fini()
  rds_conn_path_free()
    rds_ib_conn_free()
      spin_lock_irqsave(lock_ptr, flags);
      if (!list_empty(&ic->ib_node))
              list_del(&ic->ib_node);	/* unlinks out of tmp_list */
      ...
      kfree(ic);

the list_del() writes through the neighbours of an entry that lives on this
stack list, and the ic is freed.  The loop's cached cursor _ic then points
into freed slab memory, list_del_init() writes into it, and
rds_conn_destroy() is called on a dangling conn.  For the entry currently
being processed, the same free after spin_unlock_irq() makes the ic->conn
read a use-after-free.

The window is not small - it spans the synchronize_rcu(),
cancel_delayed_work_sync() and flush_work() calls inside
rds_conn_destroy() - and rds_conn_wait_conns_freed() re-runs this sweep
precisely while deferred frees are outstanding:

net/rds/connection.c:rds_conn_wait_conns_freed() {
	while (!wait_event_timeout(rds_conn_freed_waitq,
				   !atomic_read(&trans->t_conn_count),
				   msecs_to_jiffies(RDS_CONN_FREE_POLL_MS))) {
		if (resweep)
			resweep();
	...
}

Would taking a connection reference while gathering under the transport
lock, and dropping it after rds_conn_destroy(), or detaching and marking all
gathered nodes up front, close this?

The TCP and loopback helpers use the same one-entry-at-a-time detach.  They
look safe at the end of the series only because rds_conn_destroy() has no
other caller for those transports, so every gathered conn still holds its
initial reference for the whole walk - is that something the helpers should
be relying on?

[Severity: Medium]
Does this break the invariant that a live rds_ib_connection is always linked
on some list?  After list_del_init() the ic is still alive with an empty
ib_node, but both users of that node still assert otherwise:

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

If rds_ib_setup_qp() reaches rds_ib_add_conn() for a connection whose node
the sweep has already emptied, does the first BUG_ON() fire?  And in the
opposite order, if add_conn wins and relinks the node onto
rds_ibdev->conn_list, the sweep empties it again and the
rds_ib_conn_path_shutdown() -> rds_ib_remove_conn() that rds_conn_destroy()
drives would hit the second BUG_ON().

Before this patch the node stayed linked on tmp_list, so
list_empty(&ic->ib_node) was false in that window and only the weaker
BUG_ON(list_empty(&ib_nodev_conns)) could trigger.  Since rds_ib_conn_free()
is the only one of the three sites taught to tolerate an empty ib_node,
would an explicit detached flag - as the TCP side uses with
t_tcp_node_detached - keep the assertions and the linkage consistent?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260914033719.138057-1-achender%40kernel.org
