Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68E735DA79;
	Wed, 16 Sep 2026 04:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789533409; cv=none; b=Ro/3/15VQpFSJLnue7D2CJ+oORU82tKFsr4S3W1f0/0cUBMv34pPduZfr73ibL1TnQaJIGseziVTwXnfCkyICOMkIsjPckGKYrogTw4EkQ1/2Czk/guBg5YIQ/P5nuXZeyjeV9x8GOAPF5HTCz8mzEDxqKfsgdDMMwPTM84lTo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789533409; c=relaxed/simple;
	bh=lYEPAP/JaOh+OV4r0VQ5WhanuN4qe0NiOXozwkf8kwA=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dJ7JCs9UJIso7EPuu5hLQyjIFi30WBooQxnpGrC/zWDZo4SX57y0yePjhR5lk5kXb645OdujBvrC9DmH93Byh2RLrMUdInpQCXd4+62X32ZHCt8E9E7oe7eWpeZekpJAWOiwpCHdwMP/YBEhknAcND43rRc6KG3BhAxhEfMChN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C9onmXP4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C9onmXP4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB1BA1F000FF;
	Wed, 16 Sep 2026 04:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789533407;
	bh=+OUuesIq7oMehX63RzZd0qwO8wwZHcMXLTBEF5+V5Oo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=C9onmXP4gqFnsMsiVHZrhe9iw8cnLd2P2J2dpA3gHyjGCmjI48oiqs3rojlI7Ngzr
	 pu7if5IDu539eF+EwnRE/7nM7RoWV6JyIt2Xquk4p3UClFWMEMlfjmiIiQpQ6I7bLD
	 OWROhd3waL8PQYHqWjtjTSjd5xeVAS6SUAo49kKSb/Uv1xeokCMWq9y+3+Wk7nB3ZQ
	 DNcpio2/xegs2/iPKY+rDDhhRXaVxj15Aso9MHFpU4rzCXoWzpIGGaqWt/i9kHjqX5
	 VBA/l7Z1DZI4Gu66J3FonKtCJoJrNK2YNbTJnOmibQdfHzfvdqDcj8EIUjESr4skhv
	 NAMBdsxVt/T2Q==
Subject: Re: [PATCH net-next v2 4/9] net/rds: wait for connections to be freed
 on transport unload
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Wed, 16 Sep 2026 04:36:46 +0000
Message-ID: <178953340650.22033.16266976006019809086@kernel.org>
In-Reply-To: <20260912035027.27447-5-achender@kernel.org>
References: <20260912035027.27447-5-achender@kernel.org>
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

Critical: 0 · High: 1 · Medium: 2 · Low: 1 (1)

- [High] rds_ib_exit() installs rds_ib_destroy_nodev_conns() as the
  repeatedly-invoked `resweep` callback of the new…
- [Medium] rds_conn_wait_conns_freed() (net/rds/connection.c:619-642)
  loops on wait_event_timeout(), i.e. TASK_UNINTERRUPTIBLE sleep, with…
- [Medium] The new unload barrier is released from inside transport-
  module context.
- [Low] (Baseline decision: FALSE - refuted by code.) The concern was
  that the single flush_workqueue(rds_wq) added at the end of…

Pre-existing issues:
- [Low] (Baseline decision: FALSE - discarded as resolved later in the
  series.) The concern was that the new comment above…

--

net/rds: wait for connections to be freed on transport unload

This adds a per-transport live connection count (t_conn_count), bumped when
a connection is published in __rds_conn_create() and dropped as the last
step of rds_conn_destroy_fini().  A new helper,
rds_conn_wait_conns_freed(), polls that count so rds_ib_exit(),
rds_tcp_exit() and rds_loop_exit() do not unload while a connection free is
still pending, with an optional resweep callback for IB's asynchronous
device detach.

A few questions below about the resweep callback, the unbounded wait, and
where the wake happens.

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index cc4e74b731df9..5848dd295911a 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c

[ ... ]

> @@ -579,6 +583,7 @@ static void rds_conn_destroy_fini(struct kref *kref)
>  	struct rds_connection *conn = container_of(kref, struct rds_connection,
>  						   c_refcount);
>  	int npaths = (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
> +	struct rds_transport *trans = conn->c_trans;
>  	unsigned long flags;
>  	int i;
>  
> @@ -591,7 +596,51 @@ static void rds_conn_destroy_fini(struct kref *kref)
>  	spin_lock_irqsave(&rds_conn_lock, flags);
>  	rds_conn_count--;
>  	spin_unlock_irqrestore(&rds_conn_lock, flags);
> +
> +	/* only after everything the transport module owns has been
> +	 * freed above may its unload proceed
> +	 */
> +	if (!atomic_dec_return(&trans->t_conn_count))
> +		wake_up_all(&rds_conn_freed_waitq);

[Severity: Medium]

Is it safe for this wake to happen from inside transport module text?

The final rds_conn_put() is not always made by the unloading thread.
rds_ib_connect_complete() in net/rds/ib_cm.c calls rds_conn_destroy() when
the peer negotiated an unsupported protocol version, and later in the series
rds_rdma_cm_event_handler_cmn() drops its own connection reference in its
out: epilogue.  Both of those run in rds_rdma.ko text:

RDMA_CM_EVENT_ESTABLISHED
  rds_rdma_cm_event_handler_cmn()
    rds_ib_connect_complete()
      rds_conn_destroy()
        rds_conn_put()
          rds_conn_destroy_fini()
            atomic_dec_return(&trans->t_conn_count) == 0
            wake_up_all(&rds_conn_freed_waitq)

If that put is the last one, the rmmod thread parked in
rds_conn_wait_conns_freed() is released while the releasing thread is still
executing and returning through rds_rdma text (at this commit it still has a
mutex_unlock(&conn->c_cm_lock) to do).  Nothing appears to keep that thread
out of the module image, so can rds_ib_exit() finish and free_module()
unmap the text under the frame that is still unwinding?

Is a quiesce of the transport's own asynchronous contexts needed after the
count reaches zero, so the last decrement is guaranteed to be the last
transport instruction executed?

> +}
> +
> +/* Wait for all of @trans's connections to be freed; the free runs
> + * asynchronously once rds_conn_destroy() has quiesced a connection.
> + * Called on transport module unload, after the transport has destroyed
> + * all of its connections.  A connection reference can be held for an
> + * application-controlled time - an unread datagram pins the inc that
> + * carries it, and thus the connection - so the wait is unbounded: the
> + * frees that run after unload call into this module's text (conn_free,
> + * inc_free) and free into its slabs, so proceeding while any remain
> + * would be a use-after-free, not a leak.  Warn periodically so a stuck
> + * count is diagnosable, but never stop waiting.  This matches the
> + * historical RDS contract that teardown does not discard queued data.
> + */

[Severity: Low]

This isn't a bug introduced by this patch, but the comment describes a
property the tree does not have yet at this commit.  It says "an unread
datagram pins the inc that carries it, and thus the connection", and that
the frees covered by the wait include inc_free and the transport's slabs.

At this commit t_conn_count counts connections only, and no inc holds a
connection reference, so an outstanding inc does not keep the predicate
false.  rds_ib_exit() can therefore return from the wait and go on to
rds_ib_recv_exit(), which only warns before destroying the slabs:

net/rds/ib_recv.c:rds_ib_recv_exit() {
	WARN_ON(atomic_read(&rds_ib_allocation));

	kmem_cache_destroy(rds_ib_incoming_slab);
	kmem_cache_destroy(rds_ib_frag_slab);
}

The later patch "net/rds: hold a connection reference from struct
rds_incoming" adds rds_conn_get() to rds_inc_init()/rds_inc_path_init(),
which is what makes the comment true, so this is only a matter of the
comment running ahead of the code.  Would it read better with the inc part
moved to that patch?

> +void rds_conn_wait_conns_freed(struct rds_transport *trans,
> +			       void (*resweep)(void))
> +{
> +	unsigned long warn_interval =
> +			msecs_to_jiffies(RDS_CONN_FREE_WARN_INTERVAL_MS);
> +	unsigned long warn_at = jiffies + warn_interval;
> +
> +	while (!wait_event_timeout(rds_conn_freed_waitq,
> +				   !atomic_read(&trans->t_conn_count),
> +				   msecs_to_jiffies(RDS_CONN_FREE_POLL_MS))) {

[Severity: Medium]

wait_event_timeout() sleeps in TASK_UNINTERRUPTIBLE, and this loop has no
bound, no kill/signal check and no error return, so the only way out is
t_conn_count reaching zero.

The callers are module exit functions, reached after try_stop_module() has
already set MODULE_STATE_GOING:

delete_module()
  mod->exit()
    rds_tcp_exit()  -> rds_conn_wait_conns_freed(&rds_tcp_transport, NULL)
    rds_ib_exit()   -> rds_conn_wait_conns_freed(&rds_ib_transport, ...)
    rds_loop_exit() -> rds_conn_wait_conns_freed(&rds_loop_transport, NULL)

As the commit message itself notes, the count can be held up by an
unprivileged local process that simply leaves a datagram unread, on a socket
that may belong to a different transport and therefore pins no module
reference:

    "an unread datagram pins its connection for as long as the application
     leaves it on the receive queue, and rds_find_bound() does not filter
     on transport, so that socket may well belong to a different transport
     than the connection and pin nothing that stops this unload"

In that case the rmmod thread stays in unkillable D state, the remaining
exit steps (rds_trans_unregister(), rds_tcp_recv_exit(), rds_ib_mr_exit())
never run, the module cannot be reloaded because try_module_get() fails on a
GOING module, and the new pr_warn() repeats every ten seconds for as long as
the machine is up.  For rds_loop_exit() the module in question is the core
rds module.

Since trans->t_owner is already used with try_module_get()/module_put() in
rds_trans_get()/rds_trans_get_preferred(), would holding a module reference
per live connection or inc be preferable, so delete_module() fails with
-EBUSY instead of blocking forever?  Failing that, could the wait at least
be killable or freezer aware?

> +		/* A transport whose teardown is asynchronous (IB moves a
> +		 * connection off its device from the shutdown work) gives
> +		 * us a resweep to destroy what has arrived since.
> +		 */
> +		if (resweep)
> +			resweep();
> +		if (time_after_eq(jiffies, warn_at)) {
> +			pr_warn("RDS/%s: still waiting for %d connection(s) to be freed before unload\n",
> +				trans->t_name,
> +				atomic_read(&trans->t_conn_count));
> +			warn_at = jiffies + warn_interval;
> +		}
> +	}
>  }
> +EXPORT_SYMBOL_GPL(rds_conn_wait_conns_freed);
>  
>  void rds_conn_get(struct rds_connection *conn)
>  {
> diff --git a/net/rds/ib.c b/net/rds/ib.c
> index 9fe3b9951bd32..3fc2de9d19d55 100644
> --- a/net/rds/ib.c
> +++ b/net/rds/ib.c
> @@ -537,7 +537,24 @@ void rds_ib_exit(void)
>  	rds_info_deregister_func(RDS6_INFO_IB_CONNECTIONS, rds6_ib_ic_info);
>  #endif
>  	rds_ib_unregister_client();
> +
> +	/* rds_ib_dev_shutdown() only dropped the connections still
> +	 * attached to a device; each moves itself to ib_nodev_conns
> +	 * from its shutdown work.  Destroy what is there now and keep
> +	 * sweeping the list while the wait sees connections outstanding,
> +	 * so a late arrival is destroyed rather than waited on forever.
> +	 */
>  	rds_ib_destroy_nodev_conns();
> +	rds_conn_wait_conns_freed(&rds_ib_transport,
> +				  rds_ib_destroy_nodev_conns);

[Severity: High]

Is rds_ib_destroy_nodev_conns() safe to call more than once?  It moves the
global list with a plain list_splice() and never re-initialises the head:

net/rds/ib_rdma.c:rds_ib_destroy_nodev_conns() {
	/* avoid calling conn_destroy with irqs off */
	spin_lock_irq(&ib_nodev_conns_lock);
	list_splice(&ib_nodev_conns, &tmp_list);
	spin_unlock_irq(&ib_nodev_conns_lock);

	list_for_each_entry_safe(ic, _ic, &tmp_list, ib_node)
		rds_conn_destroy(ic->conn);
}

rds_loop_exit() in the same tree does the reset that is missing here:

	spin_lock_irq(&loop_conns_lock);
	list_splice(&loop_conns, &tmp_list);
	INIT_LIST_HEAD(&loop_conns);
	spin_unlock_irq(&loop_conns_lock);

After the first non-empty sweep, ib_nodev_conns.next and .prev still point
at entries that now live on the previous sweep's stack-local tmp_list, and
those rds_ib_connection objects are freed asynchronously by
rds_ib_conn_free() when the last connection reference goes away.

The resweep runs on every 100 ms poll for as long as t_conn_count is
non-zero, so a second call is the expected case here.  On that call
list_empty(&ib_nodev_conns) is false, so list_splice() writes through
first->prev and last->next into rds_ib_connection memory that may already be
kfree()d, and the walk then follows a chain whose tail points at the tmp_list
of a stack frame that has already returned.  Can this corrupt memory?

In the other direction, rds_ib_conn_free() does:

net/rds/ib_cm.c:rds_ib_conn_free() {
	spin_lock_irq(lock_ptr);
	list_del(&ic->ib_node);
	spin_unlock_irq(lock_ptr);

with ib_node.prev being the address of the returned sweep's stack frame,
which is the region rds_conn_wait_conns_freed() and the next sweep are now
using.

And a genuinely late migration does:

net/rds/ib_rdma.c:rds_ib_remove_conn() {
	list_add_tail(&ic->ib_node, &ib_nodev_conns);

which links through the stale head->prev, so the new entry can end up off
the chain reachable from head->next.  Would the resweep then never find it,
leaving the unbounded wait above running forever - the exact case the
resweep was added for?

Would list_splice_init() (or an INIT_LIST_HEAD() after the splice, as
rds_loop_exit() does) address this?

As an additional note, the later series patch "net/rds: unlink transport
nodes before a possibly deferred connection free" adds a per-entry
list_del_init() to this loop, which removes the stack-linkage part, but
ib_nodev_conns is still left pointing at the moved entries.  The second
sweep then re-splices self-linked detached nodes, where
tmp_list.next == &C->ib_node and C->ib_node.next == &C->ib_node, so does
list_for_each_entry_safe() loop on the same entry indefinitely, calling
rds_conn_destroy() on it each time?

> +
> +	/* Tearing down the last connection may have dropped the final
> +	 * reference on a device, deferring rds_ib_dev_free() to rds_wq.
> +	 * Drain it before the module goes away; it queues nothing
> +	 * further on rds_wq.
> +	 */
> +	flush_workqueue(rds_wq);
> +
>  	rds_ib_sysctl_exit();
>  	rds_ib_recv_exit();
>  	rds_trans_unregister(&rds_ib_transport);
> diff --git a/net/rds/loop.c b/net/rds/loop.c
> index e6b0750bbedab..fd774f8080d01 100644
> --- a/net/rds/loop.c
> +++ b/net/rds/loop.c
> @@ -195,6 +195,8 @@ void rds_loop_exit(void)
>  		WARN_ON(lc->conn->c_passive);
>  		rds_conn_destroy(lc->conn);
>  	}
> +
> +	rds_conn_wait_conns_freed(&rds_loop_transport, NULL);
>  }
>  
>  static void rds_loop_kill_conns(struct net *net)

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260912035027.27447-1-achender%40kernel.org
