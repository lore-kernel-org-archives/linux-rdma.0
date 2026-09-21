Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4F345FFBB;
	Mon, 21 Sep 2026 09:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789982139; cv=none; b=fRs50N2lQY+VFwFDlvruOjfIyPwhpdczM43bw41TVq5nk2cNuO7gELbvCPEKTtGrPuRg1bzzMbugzFx4wVJy5pBXnJve9YnCY86gE7LXrp6uOOdtVWfUxLSyqAXZOjRu5cdDrUL04Qiu92wA0kWNUko5e/yGLjAZWcsXF4vYtTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789982139; c=relaxed/simple;
	bh=UzrntaekIQ5ysBajw92BCQbqROicrlq/t4rvI6iQNMA=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Dlh42dR60ePLRFywxli+AEm2UWP5Jji2ey9A36eahlF3NGNAZLdIwPDEgFbr1yOHVjK2Id4YQ11YkTP1pYoq+kbBTgZOkY2WbTUk+TEhC85JkaU39BYoVdgMnxCm2x2/hyudnF74Sa+UqxdAdL8w5cdbdsCzHH0bUHF/d0TtSuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j4fY1xBT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j4fY1xBT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8541F000FF;
	Mon, 21 Sep 2026 09:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789982137;
	bh=p8bJIdHAc8+RnelrkN6pGs/9Q6cIO7cRx4/kMKTKhCM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=j4fY1xBT7drnqkX9N3/vfryRdwGzcQRUAiAdedeCKaN1Xnjhql+FdDmbktbUB/kG9
	 l2p55dmxLxOq6Z3W7GMtJ3uqZOSooJlBhUuSwvPo6Zupltf+pVmTx1q18fZVbPVtoN
	 HIBzHye7xZ5fAmtN81wrcw2Y9wMZ5mz/0xViftJlFKujl6nkeUSBFt0hqQ2jXNDl3W
	 ap09MnVMcvU4TG5LgxdKYPiscFH5OIl87wxv1977b5ucAFxwlt4Qo6JnUeK2aJS5av
	 tFpJpRcnNgkInII21XFv3TaN2wAVU4y5HyBjUok+0MsP/I4ahmQC8zdjyQaNI+h1bp
	 5vId4eRn0DlOQ==
Subject: Re: [PATCH net-next v4 07/12] net/rds: unlink transport nodes before
 a possibly deferred connection free
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Mon, 21 Sep 2026 09:15:36 +0000
Message-ID: <178998213661.2160803.17232965339695991911@kernel.org>
In-Reply-To: <20260917073958.174056-8-achender@kernel.org>
References: <20260917073958.174056-8-achender@kernel.org>
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

Critical: 0 · High: 1 · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] rds_ib_destroy_nodev_conns() leaves each gathered ib_node
  *linked* on its stack-local tmp_list and only unlinks it…
- [Low] The comment above the lock selection in rds_ib_conn_free() still
  asserts the two-state invariant 'Conn is either on a dev's list or on…

--

net/rds: unlink transport nodes before a possibly deferred connection free

The transport teardown helpers now unlink each per-connection transport node
under the transport lock right before calling rds_conn_destroy(), instead of
leaving that to the transport's conn_free().  The gather step also takes a
reference on each connection it moves onto the stack list and drops it after
the destroy, and the IB list movers no longer assert that a node is linked.

> diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
> index 118e033229aa8..26a32c1ec8f7f 100644
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

[Severity: Low]
This isn't a bug, but should the comment just above the lock selection in
rds_ib_conn_free() be updated too?  It still reads:

	/*
	 * Conn is either on a dev's list or on the nodev list.
	 * A race with shutdown() or connect() would cause problems
	 * (since rds_ibdev would change) but that should never happen.
	 ...
	lock_ptr = ic->rds_ibdev ? &ic->rds_ibdev->spinlock : &ib_nodev_conns_lock;

After this patch "on neither list" is a normal state, which is exactly what
the new list_empty() guard below handles.  rds_ib_add_conn() can now set
ic->rds_ibdev and take a device reference without linking ic->ib_node onto
rds_ibdev->conn_list, and rds_ib_remove_conn() can clear ic->rds_ibdev
without putting the node back on ib_nodev_conns.

The comment also still denies the connect/shutdown race that the new
comments in rds_ib_add_conn() and rds_ib_remove_conn() say can happen.

> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
> index a9b27f06cbfcf..bdd66c9b93c70 100644
> --- a/net/rds/ib_rdma.c
> +++ b/net/rds/ib_rdma.c
> @@ -123,15 +123,18 @@ void rds_ib_add_conn(struct rds_ib_device *rds_ibdev, struct rds_connection *con
>  {
>  	struct rds_ib_connection *ic = conn->c_transport_data;
>  
> -	/* conn was previously on the nodev_conns_list */
> +	/* conn was previously on the nodev_conns_list, unless a teardown
> +	 * sweep already unlinked it ahead of destroying it: then it is
> +	 * on its way out and stays off every list.
> +	 */
>  	spin_lock_irq(&ib_nodev_conns_lock);
> -	BUG_ON(list_empty(&ib_nodev_conns));
> -	BUG_ON(list_empty(&ic->ib_node));
> -	list_del(&ic->ib_node);
> +	if (!list_empty(&ic->ib_node)) {
> +		list_del(&ic->ib_node);
>  
> -	spin_lock(&rds_ibdev->spinlock);
> -	list_add_tail(&ic->ib_node, &rds_ibdev->conn_list);
> -	spin_unlock(&rds_ibdev->spinlock);
> +		spin_lock(&rds_ibdev->spinlock);
> +		list_add_tail(&ic->ib_node, &rds_ibdev->conn_list);
> +		spin_unlock(&rds_ibdev->spinlock);
> +	}
>  	spin_unlock_irq(&ib_nodev_conns_lock);
>  
>  	ic->rds_ibdev = rds_ibdev;
> @@ -142,15 +145,22 @@ void rds_ib_remove_conn(struct rds_ib_device *rds_ibdev, struct rds_connection *
>  {
>  	struct rds_ib_connection *ic = conn->c_transport_data;
>  
> -	/* place conn on nodev_conns_list */
> +	bool detached;
> +
> +	/* place conn on nodev_conns_list - unless a teardown sweep
> +	 * already unlinked it ahead of destroying it, in which case it
> +	 * stays off every list
> +	 */
>  	spin_lock(&ib_nodev_conns_lock);
>  
>  	spin_lock_irq(&rds_ibdev->spinlock);
> -	BUG_ON(list_empty(&ic->ib_node));
> -	list_del(&ic->ib_node);
> +	detached = list_empty(&ic->ib_node);
> +	if (!detached)
> +		list_del(&ic->ib_node);
>  	spin_unlock_irq(&rds_ibdev->spinlock);
>  
> -	list_add_tail(&ic->ib_node, &ib_nodev_conns);
> +	if (!detached)
> +		list_add_tail(&ic->ib_node, &ib_nodev_conns);
>  
>  	spin_unlock(&ib_nodev_conns_lock);
>  
> @@ -163,13 +173,38 @@ void rds_ib_destroy_nodev_conns(void)
>  	struct rds_ib_connection *ic, *_ic;
>  	LIST_HEAD(tmp_list);
>  
> -	/* avoid calling conn_destroy with irqs off */
> +	struct rds_connection *conn;
> +
> +	/* Gather the connections and take a reference on each, so that
> +	 * none is freed under the walk below (a connection destroyed
> +	 * earlier, for a protocol version mismatch, can be on this list
> +	 * with only a socket's reference still pending).  One whose free
> +	 * is already running gets no reference: its free unlinks the
> +	 * node itself, under this lock, once we drop it.  Avoid calling
> +	 * conn_destroy with irqs off.
> +	 */
>  	spin_lock_irq(&ib_nodev_conns_lock);
> -	list_splice_init(&ib_nodev_conns, &tmp_list);
> +	list_for_each_entry_safe(ic, _ic, &ib_nodev_conns, ib_node) {
> +		if (rds_conn_get_unless_zero(ic->conn))
> +			list_move_tail(&ic->ib_node, &tmp_list);
> +	}
>  	spin_unlock_irq(&ib_nodev_conns_lock);
>  
> -	list_for_each_entry_safe(ic, _ic, &tmp_list, ib_node)
> -		rds_conn_destroy(ic->conn);
> +	/* rds_conn_destroy() can return before the connection is freed,
> +	 * and it is the free - rds_ib_conn_free() - that unlinks ib_node.
> +	 * tmp_list lives on this stack frame, so unlink each node before
> +	 * its destroy; the free then finds it empty and leaves it alone.
> +	 */
> +	list_for_each_entry_safe(ic, _ic, &tmp_list, ib_node) {
> +		conn = ic->conn;
> +
> +		spin_lock_irq(&ib_nodev_conns_lock);
> +		list_del_init(&ic->ib_node);
> +		spin_unlock_irq(&ib_nodev_conns_lock);
> +
> +		rds_conn_destroy(conn);
> +		rds_conn_put(conn);
> +	}
>  }

[Severity: High]
Can a concurrent rds_ib_add_conn() steal an entry out of the tmp_list that
rds_ib_destroy_nodev_conns() keeps on its own stack?

The gather in rds_ib_destroy_nodev_conns() leaves each node linked, just on
a different list head:

	list_for_each_entry_safe(ic, _ic, &ib_nodev_conns, ib_node) {
		if (rds_conn_get_unless_zero(ic->conn))
			list_move_tail(&ic->ib_node, &tmp_list);
	}

The new "has a sweep already claimed me" test in rds_ib_add_conn() is
list_empty(&ic->ib_node), which is false for a node parked on tmp_list:

	spin_lock_irq(&ib_nodev_conns_lock);
	if (!list_empty(&ic->ib_node)) {
		list_del(&ic->ib_node);

		spin_lock(&rds_ibdev->spinlock);
		list_add_tail(&ic->ib_node, &rds_ibdev->conn_list);
		spin_unlock(&rds_ibdev->spinlock);
	}

So rds_ib_setup_qp()->rds_ib_add_conn() from the RDMA-CM event path would
treat a gathered node as still being on ib_nodev_conns and move it onto
rds_ibdev->conn_list.  rds_ib_remove_conn() does the mirror image, unlinking
a gathered node while holding only rds_ibdev->spinlock and re-adding it to
ib_nodev_conns.

The second loop in rds_ib_destroy_nodev_conns() walks tmp_list without
ib_nodev_conns_lock, and each iteration is long, since rds_conn_destroy()
does synchronize_rcu() plus work cancel/flush.  If the entry the iterator
is about to follow has been moved, doesn't the walk continue onto
rds_ibdev->conn_list or ib_nodev_conns?

That walk would then call rds_conn_destroy() and rds_conn_put() on
connections for which the gather never took a reference, and the loop's
termination test pos == &tmp_list can no longer fire on the foreign chain,
so the conn_list head embedded in struct rds_ib_device is eventually treated
as a struct rds_ib_connection and ic->conn read from it.

The list_del_init(&ic->ib_node) in that loop is also done under
ib_nodev_conns_lock, while a stolen node now lives on rds_ibdev->conn_list,
which is protected by rds_ibdev->spinlock and walked concurrently by
rds_ib_dev_shutdown().

And if a stolen entry is never reached by the walk, the reference the gather
took on it is never dropped, so does the resweep loop in rds_ib_exit():

	rds_ib_destroy_nodev_conns();
	rds_conn_wait_conns_freed(&rds_ib_transport,
				  rds_ib_destroy_nodev_conns);

keep spinning with "still waiting for N connection(s) to be freed before
unload" because t_conn_count never reaches zero?

The commit message says "a connect or shutdown worker can still be running
for a connection the sweep has just unlinked", and the gathered window is
earlier and longer than the unlinked one the guard was written for.  TCP
records this state explicitly with tc->t_tcp_node_detached; would IB need an
equivalent recorded under the transport lock at gather time, rather than
relying on list_empty()?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260917073958.174056-1-achender%40kernel.org
