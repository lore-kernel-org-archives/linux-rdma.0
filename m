Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA747386552;
	Mon, 12 Oct 2026 04:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791778669; cv=none; b=hZgIpDI+FOK/kwi/Eb3xmU/0dX2saMWH4Z6XtsN+KzL9YDZOyhg93wksdsq4mqiNEeAZIz1yYSWTIIYEh5aX9OFQ0m26eifnVR32Mmkw/Qw4ckSaay+R4/Aw3D02YhVgSjW6m/wAp8lcx5aqhRHf+8OVw4OtCNGWI2XOZsEij48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791778669; c=relaxed/simple;
	bh=sRBmRzGux5TUgJDu0oOqnrTVP6pDTpMgDbvsr0wbS8E=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IkSr1GM+n7Bfj4YBQKZqXPiByKoAg+xAs7KF7WigqAXhFIzA4zWeg8m0MvdYdVgpisWZ6ZJzQ+sYKel0kM1Dm7ruJJlNqNviwpQfBDV4j1lqdpoZmglQUMELfMq6qiI5oy1YRKJvk3iPbnP+FKFbUCdPUBPOkk2EentUPFv65LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nCls0gPV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nCls0gPV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682FC1F0089C;
	Mon, 12 Oct 2026 04:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791778667;
	bh=foNNdpYdWf82A7bflLzKafbaKn93zz9wCFA4tPDg2SQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=nCls0gPVkMoQevrP0EPbj+ymKM6RA/3AomOIb9zqWVyIfGk+ZZdHP62IfYbTjfnqP
	 9HWuVfqFeGrEYthLRiyhybq8rauW+/1NorI+Ok4J3lsd7mUR3KnJau1nX5ICYtF/0t
	 Ug8ULC+ro4Qhh9PzvSYT9lVHYNznwNXFs0pkkNAR3fZ/qvU0QvDSVFCw6fgni4ltyN
	 huqc35UHW5CJM+VQirlajhAHGzYikFg2vqUxAw7F4Jx4ZqCV8FbuU9/WSLudvIuKdH
	 7cA1Hj2mAFbNDIoFW+rGAr9VDYuOftnaXvcBsUJkkAshdnXbYCkPAga8AQSLUv90jH
	 smJcSeg7hHqGw==
Subject: Re: [PATCH net-next v9 07/13] net/rds: unlink transport nodes before
 a possibly deferred connection free
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Mon, 12 Oct 2026 04:17:47 +0000
Message-ID: <179177866700.434549.4866908041584634023@kernel.org>
In-Reply-To: <20261008031333.1142174-8-achender@kernel.org>
References: <20261008031333.1142174-8-achender@kernel.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit carries 'Fixes: 4716af3897e9', which makes it a stable
  candidate.
- [Low] Parts of the commit message are inaccurate or garbled.

Pre-existing issues:
- [Medium] At this commit, rds_ib_exit() still sweeps ib_nodev_conns only
  once, through rds_ib_destroy_nodev_conns(), right after…

--

net/rds: unlink transport nodes before a possibly deferred connection free

This patch changes the RDS TCP, loopback and IB teardown helpers so they
unlink each transport node from the on-stack gather list before calling
rds_conn_destroy(). A deferred conn_free() then cannot write into a dead
stack frame. For IB it adds an i_ib_node_detached claim flag and gathers
the nodev list entry by entry under ib_nodev_conns_lock, instead of
splicing it, and it pins each gathered connection with a reference.

> The node is unlinked much later, by the transport's conn_free():
> rds_tcp_conn_free() and rds_loop_conn_free() list_del() it, and
> rds_ib_conn_free() does so unconditionally.

[Severity: Low]
Is this accurate for rds_loop_conn_free()? Before this patch it also
called list_del() unconditionally:

net/rds/loop.c:rds_loop_conn_free() {
	...
	spin_lock_irqsave(&loop_conns_lock, flags);
	list_del(&lc->loop_node);
	...
}

Only rds_tcp_conn_free() checked t_tcp_node_detached first.

> today, so that part is preparation for those patches.  The IB list
> handling is a fix in its own right, below.
> So the gather takes a reference on each connection it moves

The paragraph above this one describes the IB list fix ("For IB this also
closes a race that exists today..."). Should "below" be "above"?

This sentence also falls between "that part is preparation for those
patches" and the sentence that continues it, "So the gather takes a
reference...". It looks like it was left over from an edit.

> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
> index 50c02f47cf683..f0e7d116b0844 100644
> --- a/net/rds/ib_rdma.c
> +++ b/net/rds/ib_rdma.c

[ ... ]

> @@ -155,15 +159,22 @@ void rds_ib_remove_conn(struct rds_ib_device *rds_ibdev, struct rds_connection *
>  {
>  	struct rds_ib_connection *ic = conn->c_transport_data;
>  
> -	/* place conn on nodev_conns_list */
> +	bool detached;
> +
> +	/* place conn on nodev_conns_list - unless a teardown sweep has
> +	 * claimed it ahead of destroying it, in which case its node
> +	 * belongs to the sweep
> +	 */
>  	spin_lock(&ib_nodev_conns_lock);
>  
>  	spin_lock_irq(&rds_ibdev->spinlock);
> -	BUG_ON(list_empty(&ic->ib_node));
> -	list_del(&ic->ib_node);
> +	detached = ic->i_ib_node_detached;
> +	if (!detached)
> +		list_del(&ic->ib_node);
>  	spin_unlock_irq(&rds_ibdev->spinlock);
>  
> -	list_add_tail(&ic->ib_node, &ib_nodev_conns);
> +	if (!detached)
> +		list_add_tail(&ic->ib_node, &ib_nodev_conns);

[Severity: Medium]
This is a pre-existing issue, not one introduced by this patch. Can a late
shutdown leave a connection on ib_nodev_conns that is never destroyed?

At this commit rds_ib_exit() still sweeps the nodev list only once:

net/rds/ib.c:rds_ib_exit() {
	...
	rds_ib_unregister_client();
	rds_ib_destroy_nodev_conns();
	rds_ib_sysctl_exit();
	rds_ib_recv_exit();
	...
}

rds_ib_unregister_client() only waits on rds_wq:

	ib_unregister_client(&rds_ib_client);
	/* wait for rds_ib_dev_free() to complete */
	flush_workqueue(rds_wq);

rds_ib_dev_shutdown() queues the shutdowns on the per-path cp_wq and does
not wait for them:

	list_for_each_entry(ic, &rds_ibdev->conn_list, ib_node)
		rds_conn_path_drop(&ic->conn->c_path[0], true);

A connection whose shutdown has not yet reached rds_ib_remove_conn() is
still on rds_ibdev->conn_list, so rds_ib_destroy_nodev_conns() never
claims it. When that shutdown finishes, i_ib_node_detached is false. The
node is added to ib_nodev_conns here after the only sweep has already run,
and rds_conn_destroy() is never called for it.

The rds_ib_dev_put() that follows can also queue rds_ib_dev_free() on
rds_wq after the flush has returned. Both paths can end up running module
text after rds_rdma is unloaded.

This commit does not claim to fix this; its "closes both" refers to the
stale head corruption and to a connect unlinking a node under the walk.
The next patch in the series, "net/rds: wait for connections to be freed
on transport unload", fixes it. There, rds_ib_exit() follows the sweep
with rds_conn_wait_conns_freed(&rds_ib_transport,
rds_ib_destroy_nodev_conns), which sweeps again on every poll until
t_conn_count reaches zero, and then runs a second flush_workqueue(rds_wq).

>  
>  	spin_unlock(&ib_nodev_conns_lock);
>  

[ ... ]

> @@ -176,13 +187,40 @@ void rds_ib_destroy_nodev_conns(void)
>  	struct rds_ib_connection *ic, *_ic;
>  	LIST_HEAD(tmp_list);
>  
> -	/* avoid calling conn_destroy with irqs off */
> +	struct rds_connection *conn;
> +

[ ... ]

>  	spin_lock_irq(&ib_nodev_conns_lock);
> -	list_splice(&ib_nodev_conns, &tmp_list);
> +	list_for_each_entry_safe(ic, _ic, &ib_nodev_conns, ib_node) {
> +		if (rds_conn_get_unless_zero(ic->conn)) {
> +			ic->i_ib_node_detached = true;
> +			list_move_tail(&ic->ib_node, &tmp_list);
> +		}
> +	}
>  	spin_unlock_irq(&ib_nodev_conns_lock);
>  
> -	list_for_each_entry_safe(ic, _ic, &tmp_list, ib_node)
> -		rds_conn_destroy(ic->conn);
> +	/* rds_conn_destroy() can return before the connection is freed,
> +	 * and it is the free - rds_ib_conn_free() - that would unlink
> +	 * ib_node.  tmp_list lives on this stack frame, so take each node
> +	 * off it before its destroy; the free then leaves it alone.
> +	 */
> +	list_for_each_entry_safe(ic, _ic, &tmp_list, ib_node) {
> +		conn = ic->conn;
> +		list_del_init(&ic->ib_node);
> +
> +		rds_conn_destroy(conn);
> +		rds_conn_put(conn);
> +	}

[Severity: Low]
Because of the "Fixes: 4716af3897e9" tag, this commit will be a stable
candidate. However, rds_conn_get_unless_zero() and rds_conn_put() don't
exist at the series baseline. They come from the previous patch, "net/rds:
split connection destroy into quiesce and kref-governed free", which has
no Fixes: tag.

Would a backport to a tree that has 4716af3897e9 but not the kref rework
fail to build?

The commit message calls the per-entry references "preparation" and says
"The IB list handling is a fix in its own right". It does not name the
prerequisite, for example with a stable dependency note. Later in the
series, "net/rds: hold a connection reference from struct rds_incoming"
leaves out a Fixes: tag for this same reason.

The IB list fix (the entry-by-entry gather under ib_nodev_conns_lock plus
the i_ib_node_detached claim) does not need the references while frees
are still synchronous. Could it be split out as a standalone patch that
goes ahead of the kref rework?

>  }
>  
>  void rds_ib_get_mr_info(struct rds_ib_device *rds_ibdev, struct rds_info_rdma_connection *iinfo)

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261008031333.1142174-1-achender%40kernel.org
