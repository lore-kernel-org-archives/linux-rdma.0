Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A434B4040;
	Thu, 17 Sep 2026 09:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789637948; cv=none; b=NZAnLn2Ee0LgaRJMx4jcIGobdZYuLRCQyKTiYsR1IDOa+H4dybn6sj/+eYYaaeYYs4B28+phHvGDz47TwKxIU7bjbi5c9IcUXE66oOPBikdAO4fKithWJ5OkUtxhVLpA+ZclNuZ0JAozxgta81HjfRht/dX1eEM08jA9Vcy1Ouo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789637948; c=relaxed/simple;
	bh=fq617fSrclWS57UJM1ZIqRXIXFY217bgVtJZG/sXcJk=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=t1tw9w733cRkgrQaB0D0fXPO/MzqcVUnw4AlkMZg3rjSvvDI9Tu8XwGD8Y+A8yQH9nrc9Ro1ZsFOsXi+Pthh/lbhtGqMJ0ChaBBOa7Z2wpz7bMZdXxOVGV06wbTRcml9Lk6I15+RbdptFXrH1CL+4B/uzCViapFvLaYCsJZpnSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RQhK4+V4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RQhK4+V4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A02B1F0089C;
	Thu, 17 Sep 2026 09:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789637924;
	bh=1KZJHIXm8QtMgRF09y9IeDwICpoQuGSWcZvvFajAft8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=RQhK4+V4YJCnmZuxg2K4r4U4fmONCbWSUoreyds4aPDBNKV/4tvbD3x7HwA75Vcvl
	 kuYWJBU0tgRATLBGji7nJ3PoUbodugbX3+TQyjyR0nsS+2vh2ETSFY9CFh0a39nMeL
	 4AwNNVRVS2M31xcK2FmOHAxtOcyXQephUbgGh2FYsJuUNTM+e+AzLXov1SgRL51COh
	 fsG4aD3ZOxYMF+oBAggW+9oxxIkIK+xEB5P3gqPZNpLPt2c1RQCDuEsusUMl1rwE9+
	 0QW/yu9VmE9lW/fjjmlCLyRsd44csZYmztahEwsTo5sIAMUfr6pf1AMKdIqnVTZVdQ
	 gv8ogLO5VAACg==
Subject: Re: [PATCH net-next v3 06/13] net/rds: wait for connections to be
 freed on transport unload
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Thu, 17 Sep 2026 09:38:43 +0000
Message-ID: <178963792307.22033.16634765137177286770@kernel.org>
In-Reply-To: <20260914033719.138057-7-achender@kernel.org>
References: <20260914033719.138057-7-achender@kernel.org>
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

Critical: 0 · High: 1 · Medium: 0 · Low: 1 (1)

- [High] rds_ib_exit()'s new comment and the commit message claim the
  resweep guarantees that "a late arrival is destroyed rather than…
- [Low] Assessed as a false positive for this patch and for the final
  state of the series (recorded for the pipeline, baseline decision =…

Pre-existing issues:
- [Low] Assessed as a false positive under the series rule (recorded for
  the pipeline, baseline decision = false).

--

net/rds: wait for connections to be freed on transport unload

This adds a per-transport live connection count (t_conn_count), bumped
when a connection is published in __rds_conn_create() and dropped as the
last step of rds_conn_destroy_fini().  The transport exit paths
(rds_ib_exit(), rds_tcp_exit(), rds_loop_exit()) then wait, without a
bound, for that count to reach zero before letting the module text go
away, with an optional resweep callback used by IB.

A few questions below about the IB resweep scope, the comment on
rds_conn_wait_conns_freed(), and the nodev sweep list handling.

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index a44aa4d2a5e8..c3b3d756c52e 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c

[ ... ]

> @@ -596,7 +601,51 @@ static void rds_conn_destroy_fini(struct kref *kref)
>  	spin_lock_irqsave(&rds_conn_lock, flags);
>  	rds_conn_count--;
>  	spin_unlock_irqrestore(&rds_conn_lock, flags);
> +
> +	/* only after everything the transport module owns has been
> +	 * freed above may its unload proceed
> +	 */
> +	if (!atomic_dec_return(&trans->t_conn_count))
> +		wake_up_all(&rds_conn_freed_waitq);
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

This is a pre-existing hole rather than something introduced here, but
does the comment above rds_conn_wait_conns_freed() describe more than
t_conn_count actually covers at this point in the series?

The comment names inc_free among the frees the wait protects, yet at this
commit a struct rds_incoming holds no connection reference, so an unread
datagram does not contribute to t_conn_count.  The wait in rds_ib_exit()
can therefore complete and rds_ib_recv_exit() can destroy
rds_ib_incoming_slab while an inc is still queued on a socket.

The commit message already flags the sequencing ("once the following
patches make incs hold a connection reference"), and the later patch
"net/rds: hold a connection reference from struct rds_incoming" makes it
true by taking a reference in rds_inc_init():

net/rds/recv.c:rds_inc_init() {
	...
	rds_conn_get(conn);	/* put in rds_inc_put() */
	inc->i_conn = conn;
	...
}

Would it be worth noting in this comment that the inc_free half only
becomes accurate with that later patch, so the intermediate state of the
tree is not read as a guarantee it does not yet provide?

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
> index 9fe3b9951bd3..3fc2de9d19d5 100644
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

Can the resweep here miss a connection entirely and turn this into an
rmmod that never returns?

rds_ib_destroy_nodev_conns() only looks at the global ib_nodev_conns
list:

net/rds/ib_rdma.c:rds_ib_destroy_nodev_conns() {
	spin_lock_irq(&ib_nodev_conns_lock);
	list_splice_init(&ib_nodev_conns, &tmp_list);
	spin_unlock_irq(&ib_nodev_conns_lock);
	...
}

A connection whose rds_ib_connection is still on an rds_ibdev->conn_list
is not on that list, and after ib_unregister_client() has returned
nothing appears to drop it again.  rds_ib_dev_shutdown() is a one-shot
sweep that already ran:

net/rds/ib.c:rds_ib_dev_shutdown() {
	spin_lock_irqsave(&rds_ibdev->spinlock, flags);
	list_for_each_entry(ic, &rds_ibdev->conn_list, ib_node)
		rds_conn_path_drop(&ic->conn->c_path[0], true);
	...
}

and every other drop site goes through rds_conn_path_drop(cp, false),
which bails out while rds_destroy_pending() is true - and
rds_ib_set_unloading() has made t_unloading true for the whole of
rds_ib_exit():

net/rds/connection.c:rds_conn_path_drop() {
	...
	if (!destroy && rds_destroy_pending(cp->cp_conn)) {
		rcu_read_unlock();
		return;
	}
	queue_work(cp->cp_wq, &cp->cp_down_w);
	...
}

Is there a window where an ic attaches to the device list after that
sweep?  rds_ib_setup_qp() resolves the device and then adds itself:

net/rds/ib_cm.c:rds_ib_setup_qp() {
	rds_ibdev = rds_ib_get_client_data(dev);
	if (!rds_ibdev)
		return -EOPNOTSUPP;
	...
	/* add the conn now so that connection establishment has the dev */
	rds_ib_add_conn(rds_ibdev, conn);
	...
}

and rds_ib_remove_one() clears the client data only after
rds_ib_dev_shutdown() has walked conn_list, so a connect already in
flight when rmmod starts can still get a device pointer and land on
conn_list.

Such a connection never migrates to ib_nodev_conns, the resweep never
sees it, and t_conn_count stays non-zero.  Since the wait is deliberately
unbounded and uninterruptible, rmmod would then block forever with the
ten-second warning repeating, and the module stays in MODULE_STATE_GOING.

Would it make sense for the resweep to also walk the rds_ib_devices
conn_lists, or otherwise cover connections that are still device
attached?  As written, the comment's claim that "a late arrival is
destroyed rather than waited on forever" seems to hold only for
connections that already reached ib_nodev_conns.

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
> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
> index db7e92e7bd29..a9b27f06cbfc 100644
> --- a/net/rds/ib_rdma.c
> +++ b/net/rds/ib_rdma.c
> @@ -165,7 +165,7 @@ void rds_ib_destroy_nodev_conns(void)
>  
>  	/* avoid calling conn_destroy with irqs off */
>  	spin_lock_irq(&ib_nodev_conns_lock);
> -	list_splice(&ib_nodev_conns, &tmp_list);
> +	list_splice_init(&ib_nodev_conns, &tmp_list);
>  	spin_unlock_irq(&ib_nodev_conns_lock);
>  
>  	list_for_each_entry_safe(ic, _ic, &tmp_list, ib_node)

[Severity: Low]

Now that the free of a connection can outlive rds_conn_destroy(), is the
ib_node of each ic left linked on the stack-local tmp_list across the
destroy?  rds_ib_conn_free() is what unlinks ib_node, so a free that runs
after rds_ib_destroy_nodev_conns() has returned would do a list_del()
against a dead stack frame.  The same shape exists in
rds_tcp_destroy_conns():

net/rds/tcp.c:rds_tcp_destroy_conns() {
	...
	list_for_each_entry_safe(tc, _tc, &tmp_list, t_tcp_node)
		rds_conn_destroy(tc->t_cpath->cp_conn);
}

At this commit rds_conn_get() has no callers, so the rds_conn_put() at
the end of rds_conn_destroy() is always the last reference and conn_free()
still runs inline inside the sweep loop, which means this cannot fire
yet.  The next patch in the series, "net/rds: unlink transport nodes
before a possibly deferred connection free", adds the per-entry
list_del_init() under the transport lock ahead of the reference-holding
patches.

Is it worth mentioning that ordering dependency in this commit message,
so the intermediate state is clearly safe by accident of there being no
extra reference holders yet rather than by design?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260914033719.138057-1-achender%40kernel.org
