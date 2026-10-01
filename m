Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734FE479873;
	Thu,  1 Oct 2026 06:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790835373; cv=none; b=FHRT8th03ONlWLZyRU87Hd3mKcJvAV2jIx6iHlHQiP4xwpsi/tFtWO/iduQimcpIg3qabvK1+D2D3L4yVdrpUwj8YNjVQCIDaBg73t+yS81q3Z9DHaI0aFsoH9rdRNkGTTtUKwxU7FediL05tmP/n2syHr9ES33BUETsZkNNiJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790835373; c=relaxed/simple;
	bh=MWSWKDtSsipEbEckfKllxSi7caEC8FWY8TpePZWFFBk=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OQoNzLkl54cGd7HsQNhqzcjZnW374A4iBvYuRXrjaxpa75c/ocW6RdGowzj10KBhBH0UsdB/nIGDHHYyJIkp7X6tZpkFsIYjCOG8PA7p3DgRdvQBuCTNIxK86DhTZ++VLD6tBaKJ2RJI509PWwDXB59pe8IbqVm7+A3nmW7Wwpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZhuuMWzP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZhuuMWzP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD3C1F000FF;
	Thu,  1 Oct 2026 06:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790835370;
	bh=ycfi3sWNeL9n+xSZJwrHu897HShtQZA5AhF7VpS+tgw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ZhuuMWzPULV7Rbl/pbYmaSKnTPTP8bd0NqdKha+Ia2sdwvjrUT9pcNkzUtvLbVv6W
	 metWFOKGartDNQHHomMT48+uNROhZvUMrcHPhqvHPi5NztzJKEASdAPJCDqX4Zanp4
	 OMnzH64TVGtRSBBRMV45lzf+3FUn48t/26guMkI0s9uNbw3OAu4kQHlKnTGA0vNmfu
	 CsWkVIBVsuHiU5gAowV8LELNiq0vmZ2M4ZXArvq9jWRKjm7auQ7Qn5t2ZAVXUvzIb+
	 ccOUyBbJONhSTPX8v2zy8mPUnwGmtev+Ay31P9zrulCzZ4uMynQpscQks8WEcIfm9a
	 7M0qvXIiCtW8Q==
Subject: Re: [PATCH net-next v7 06/12] net/rds: wait for connections to be
 freed on transport unload
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Thu, 01 Oct 2026 06:16:10 +0000
Message-ID: <179083537008.434549.13718642925544980589@kernel.org>
In-Reply-To: <20260927061448.167862-7-achender@kernel.org>
References: <20260927061448.167862-7-achender@kernel.org>
X-sashiko-severity: High
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

Critical: 0 · High: 2 · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] At this commit rds_ib_add_conn() (net/rds/ib_rdma.c) loses its
  BUG_ON(list_empty(&ib_nodev_conns)).
- [High] rds_ib_exit() can hang forever in rds_conn_wait_conns_freed()
  when an IB connection attaches to a device's conn_list after…
- [Low] In rds_ib_exit() (net/rds/ib.c) this patch fixes two rmmod bugs
  that already exist, but the commit message calls the change…

--

net/rds: wait for connections to be freed on transport unload

This adds a per-transport t_conn_count. It is incremented when a
connection is published and decremented at the end of
rds_conn_destroy_fini(). The IB, TCP and loop exit paths now wait,
with no bound, for that count to reach zero. On IB, the wait resweeps
ib_nodev_conns on every poll, and rds_wq is flushed once afterwards.

> At this point in the series the initial
> reference is the only one and the wait returns at once; the guarantee
> becomes load-bearing with those patches.

[ ... ]

> At this point in the series the only reference holder is the
> destroyer itself, so the count reaches zero as soon as the sweep has
> run; the guarantee only becomes load-bearing once the following
> patches hand references to sockets and incs.

[ ... ]

> rds_ib_exit() has one more wrinkle.

[Severity: Low]
Is this accurate for IB?

rds_ib_remove_one()->rds_ib_dev_shutdown() only queues cp_down_w on
each connection's own ordered cp_wq:

    list_for_each_entry(ic, &rds_ibdev->conn_list, ib_node)
        rds_conn_path_drop(&ic->conn->c_path[0], true);

A connection moves to ib_nodev_conns only when that work runs
rds_ib_conn_path_shutdown()->rds_ib_remove_conn(). The
flush_workqueue(rds_wq) in rds_ib_unregister_client() does not wait for
cp_wq. So whenever a shutdown work is still pending, the new wait polls
and resweeps instead of returning at once.

That means the resweep fixes an existing rmmod bug. Before this patch,
rds_ib_exit() swept ib_nodev_conns only once. A connection that moved
there after that sweep was never destroyed, and it outlived the module
while still pointing at rds_ib_transport.

The same goes for the new flush_workqueue(rds_wq) in rds_ib_exit().
rds_ib_remove_conn()->rds_ib_dev_put() can drop the last device
reference after the flush in rds_ib_unregister_client(). That queues
rds_ib_dev_free() on rds_wq, and before this patch nothing flushed
rds_wq again before the module went away.

Could the commit message describe these two changes as fixes for
existing bugs, with a Fixes: tag, rather than as a wrinkle of the new
counter?

The message also doesn't mention the change from list_splice() to
list_splice_init() in rds_ib_destroy_nodev_conns(). With list_splice(),
the global ib_nodev_conns head was left pointing into the previous
call's stack-local tmp_list. That change is what makes repeated
resweeps safe. It is also why BUG_ON(list_empty(&ib_nodev_conns)) in
rds_ib_add_conn() can now trip.

This isn't a bug, but the two "At this point in the series" paragraphs
quoted above are nearly identical.

[ ... ]

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
Can this wait loop forever if an IB connection attaches to a device's
conn_list after rds_ib_dev_shutdown() has already walked it?

rds_ib_remove_one() does:

	rds_ib_dev_shutdown(rds_ibdev);

	/* stop connection attempts from getting a reference to this device. */
	ib_set_client_data(device, &rds_ib_client, NULL);
	...
	synchronize_rcu();

An active connect's ROUTE_RESOLVED handler goes through
rds_ib_cm_initiate_connect()->rds_ib_setup_qp():

	rds_ibdev = rds_ib_get_client_data(dev);
	if (!rds_ibdev)
		return -EOPNOTSUPP;
	...
	rds_ib_add_conn(rds_ibdev, conn);

Suppose the handler gets rds_ibdev before ib_set_client_data(NULL), but
calls rds_ib_add_conn() after the rds_ib_dev_shutdown() walk. Then the
connection moves from ib_nodev_conns onto the removed device's
conn_list. The synchronize_rcu() doesn't order anything against the
attach, because the attach happens after the RCU section in
rds_ib_get_client_data().

After that, nothing seems to drop the connection:

  - rds_conn_path_drop(cp, false) returns early, because
    rds_destroy_pending() checks t_unloading, which is now true.

  - The resweep callback, rds_ib_destroy_nodev_conns(), only scans
    ib_nodev_conns.

So rds_ib_transport.t_conn_count never reaches zero. The only exit from
rds_conn_wait_conns_freed() is:

	while (!wait_event_timeout(rds_conn_freed_waitq,
				   !atomic_read(&trans->t_conn_count),
				   msecs_to_jiffies(RDS_CONN_FREE_POLL_MS))) {

rmmod would then block uninterruptibly, and the 100 ms polling keeps
the hung task detector quiet. Before this patch, the same race left a
live connection behind after unload. With this patch it becomes an
rmmod hang that never ends.

The commit message says a connection that has not migrated "would never
be destroyed, and would hold the count up for good", and the resweep is
meant to handle that. Doesn't that stay reachable for a connection that
never goes back to ib_nodev_conns?

Later in the series, "net/rds: pin the connection across RDMA-CM event
handling" adds an rds_destroy_pending() check at the start of
rds_ib_cm_initiate_connect(). That narrows the window but doesn't seem
to close it. A handler that passed the check before
rds_ib_set_unloading() and is then preempted around
rds_ib_get_client_data()/rds_ib_add_conn() still escapes. That commit's
own message notes this outcome ("rds_ib_exit() would wait forever for
the device").

[ ... ]

> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
> index db7e92e7bd29f..0c91f1b85c9b7 100644
> --- a/net/rds/ib_rdma.c
> +++ b/net/rds/ib_rdma.c
> @@ -125,7 +125,6 @@ void rds_ib_add_conn(struct rds_ib_device *rds_ibdev, struct rds_connection *con
>  
>  	/* conn was previously on the nodev_conns_list */
>  	spin_lock_irq(&ib_nodev_conns_lock);
> -	BUG_ON(list_empty(&ib_nodev_conns));
>  	BUG_ON(list_empty(&ic->ib_node));
>  	list_del(&ic->ib_node);

[Severity: High]
With this assertion gone, what stops an in-flight connect from moving a
node that is sitting on the sweeper's stack-local tmp_list?

rds_ib_destroy_nodev_conns() moves everything onto tmp_list, drops
ib_nodev_conns_lock, and then walks tmp_list without the lock:

	spin_lock_irq(&ib_nodev_conns_lock);
	list_splice_init(&ib_nodev_conns, &tmp_list);
	spin_unlock_irq(&ib_nodev_conns_lock);

	list_for_each_entry_safe(ic, _ic, &tmp_list, ib_node)
		rds_conn_destroy(ic->conn);

Meanwhile, a ROUTE_RESOLVED handler may have got rds_ibdev from
rds_ib_get_client_data() before rds_ib_remove_one() cleared it. That
handler can still reach rds_ib_setup_qp()->rds_ib_add_conn(), which
does:

	list_del(&ic->ib_node);

	spin_lock(&rds_ibdev->spinlock);
	list_add_tail(&ic->ib_node, &rds_ibdev->conn_list);

Suppose that node is the one the sweeper has already cached in _ic.
The walk then follows ib_node.next to &rds_ibdev->conn_list, which is
not &tmp_list, so the loop doesn't stop. It then calls
rds_conn_destroy() on an ic->conn computed from memory inside struct
rds_ib_device.

The resweep callback in rds_ib_exit() repeats this unlocked walk on
every 100 ms poll, so the window opens again on each poll. A similar
list_del() from tmp_list was already possible before this patch, when
list_splice() was used.

The next patch in the series, "net/rds: unlink transport nodes before a
possibly deferred connection free", appears to fix this. It adds
i_ib_node_detached, which the sweep sets under ib_nodev_conns_lock, and
rds_ib_add_conn(), rds_ib_remove_conn() and rds_ib_conn_free() then
leave a claimed node alone. Could that be folded in here, so this
commit doesn't leave the hole open in between?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260927061448.167862-1-achender%40kernel.org
