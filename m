Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8102244AB76;
	Wed, 23 Sep 2026 07:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790147504; cv=none; b=MPEL/QWJelJmqBaO6r3sS2KD/acCGBBidODqUDu1JywwPV0ep/t6NxR5hizqFfKz40YHwEUTBF1LrqrAARorGpDN2wkMA0Rp1KtqJVutln0xWWcaWeKZ0x+ryDRmFlqnuqCa2shph8+GBi/122A/4AdqTc2ECPY5oD6k5MBnkB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790147504; c=relaxed/simple;
	bh=m38xvHQhvoYUAgi9mndbekWGOPKqM+cZhisS0Lat8QM=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fyLDQh17wITKI0LCGyipBy+0CAFLXtMDydUJTjNbrAJUzuvGXKKVe5vouiIZLUcsumDT2MzYNIxu7psmltSA7TToKBUX27bY+pt/Xjtd+Ek0XRoAEOzm0hA5FT0/HwEgX4rAVZWSVrfwDlTiSc0fViXIlNGGm3qDmo+o+6vLMLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e00usaUy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e00usaUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E201F00893;
	Wed, 23 Sep 2026 07:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790147499;
	bh=uXvk/HplsPBNejUN4iU8PyQdTW8MCq11r0J7cwwqEIg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=e00usaUy4kbnFaBdbr1klPLygorRtfcuhKGFoCdAyFp1mS7QHmmK5I8+FeH5Psep+
	 AsiKM8YZh64+JBTyVgrDg7rNiXElLd86TtI58J5L+GP0ZyaHsN3LMlc2veT6mCKc2Z
	 xiyJ81l+bTugQvIqD+pHJYGD/9GubV+IMqgE/sfufjFIQhYL1yimJfu4aE0S30eYkv
	 q8aeRJIon8WTVI0Ku6t9igF8oP3grKl2ZzgMYBs3Rs2+r5auUeMPwtygX7Bd53BWxf
	 YAqhNMKLWX3W9BG34p8Niw7aVDTPP7Sg1IjQoLldKatsV9yi/svBzglqQVlBdlIb+w
	 gfrhk9+4arzdw==
Subject: Re: [PATCH net-next v5 07/12] net/rds: unlink transport nodes before
 a possibly deferred connection free
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Wed, 23 Sep 2026 07:11:38 +0000
Message-ID: <179014749857.2160803.5641706025120854982@kernel.org>
In-Reply-To: <20260919061149.250658-8-achender@kernel.org>
References: <20260919061149.250658-8-achender@kernel.org>
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

- [High] net/rds/ib_rdma.c:rds_ib_add_conn(): the new `if
  (!ic->i_ib_node_detached)` guard covers only the ib_node list…
- [Low] rds_ib_conn_free()'s header comment (net/rds/ib_cm.c:1278-1281)
  still asserts a two-state invariant and denies the very race this…

--

net/rds: unlink transport nodes before a possibly deferred connection free

The transport teardown helpers now unlink each per-connection transport node
under the transport lock right before calling rds_conn_destroy(), so a
conn_free() deferred past the helper cannot list_del() from a stack frame
that no longer exists.  IB gets an explicit i_ib_node_detached flag and the
two BUG_ON()s in rds_ib_add_conn()/rds_ib_remove_conn() are removed, and the
gather loops now take a connection reference for each node they move.

A couple of questions about the IB side below.

> diff --git a/net/rds/ib.h b/net/rds/ib.h
> index 5ff346a1e8ba..cb410c3ae8d8 100644
> --- a/net/rds/ib.h
> +++ b/net/rds/ib.h
> @@ -143,6 +143,10 @@ struct rds_ib_device;
>  struct rds_ib_connection {
>  
>  	struct list_head	ib_node;
> +	/* set under ib_nodev_conns_lock once a transport teardown has
> +	 * claimed ib_node; from then on only the teardown touches it
> +	 */
> +	bool			i_ib_node_detached;
>  	struct rds_ib_device	*rds_ibdev;
>  	struct rds_connection	*conn;
>  
> diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
> index 53147793d44b..89340ecc3116 100644
> --- a/net/rds/ib_cm.c
> +++ b/net/rds/ib_cm.c
> @@ -1287,7 +1287,9 @@ void rds_ib_conn_free(void *arg)
>  	lock_ptr = ic->rds_ibdev ? &ic->rds_ibdev->spinlock : &ib_nodev_conns_lock;
>  
>  	spin_lock_irqsave(lock_ptr, flags);
> -	list_del(&ic->ib_node);
> +	/* a transport teardown that gathered us first owns the node */
> +	if (!ic->i_ib_node_detached)
> +		list_del(&ic->ib_node);
>  	spin_unlock_irqrestore(lock_ptr, flags);
>  
>  	rds_ib_recv_free_caches(ic);

[Severity: Low]
This isn't a bug, but the comment a few lines above the new check, in
rds_ib_conn_free(), still describes a world this patch has changed:

net/rds/ib_cm.c:rds_ib_conn_free() {
	/*
	 * Conn is either on a dev's list or on the nodev list.
	 * A race with shutdown() or connect() would cause problems
	 * (since rds_ibdev would change) but that should never happen.
	 */
	lock_ptr = ic->rds_ibdev ? &ic->rds_ibdev->spinlock : &ib_nodev_conns_lock;

After this patch there is a third state: the node sits on
rds_ib_destroy_nodev_conns()'s stack-local tmp_list with
i_ib_node_detached set, and is then list_del_init()'ed, so the connection
is on neither a device list nor the nodev list.

The commit message also says "a connect or shutdown worker can still be
running for a connection the sweep has claimed", which is the
shutdown()/connect() race this comment says should never happen.

Could the comment be updated to describe the detached state, and to note
that the lock choice only matters while i_ib_node_detached is false?

> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
> index a9b27f06cbfc..1548e5be0e55 100644
> --- a/net/rds/ib_rdma.c
> +++ b/net/rds/ib_rdma.c
> @@ -123,15 +123,18 @@ void rds_ib_add_conn(struct rds_ib_device *rds_ibdev, struct rds_connection *con
>  {
>  	struct rds_ib_connection *ic = conn->c_transport_data;
>  
> -	/* conn was previously on the nodev_conns_list */
> +	/* conn was previously on the nodev_conns_list, unless a teardown
> +	 * sweep has claimed it ahead of destroying it: then it is on its
> +	 * way out, and its node belongs to the sweep.
> +	 */
>  	spin_lock_irq(&ib_nodev_conns_lock);
> -	BUG_ON(list_empty(&ib_nodev_conns));
> -	BUG_ON(list_empty(&ic->ib_node));
> -	list_del(&ic->ib_node);
> +	if (!ic->i_ib_node_detached) {
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

[Severity: High]
The new guard covers only the list movement, but the two statements that
follow still run for a connection the sweep has already claimed:

net/rds/ib_rdma.c:rds_ib_add_conn() {
	spin_unlock_irq(&ib_nodev_conns_lock);

	ic->rds_ibdev = rds_ibdev;
	refcount_inc(&rds_ibdev->refcount);
}

Can this leak the rds_ib_device reference?

rds_ib_add_conn() is reached from rds_ib_setup_qp() via the RDMA-CM event
handlers, rds_ib_cm_initiate_connect() on the active side and
rds_ib_cm_handle_connect() on the passive side, which the sweep does not
serialize against.

The only site that clears ic->rds_ibdev and drops that reference is
rds_ib_conn_path_shutdown():

net/rds/ib_cm.c:rds_ib_conn_path_shutdown() {
	...
	if (ic->rds_ibdev)
		rds_ib_remove_conn(ic->rds_ibdev, conn);
	...
}

and rds_ib_remove_conn() ends with ic->rds_ibdev = NULL plus
rds_ib_dev_put().  Once the sweep's rds_conn_destroy() has quiesced the
paths, rds_conn_path_drop(cp, false) is gated by rds_destroy_pending(), so
no further shutdown pass runs for that connection.

rds_ib_conn_free() never calls rds_ib_dev_put(), so does an add_conn() that
lands after the quiesce leave ic->rds_ibdev set forever, with
rds_ibdev->refcount never reaching zero?  That would mean rds_ib_dev_free()
is never queued and the device struct, its PD and its 1M/8K MR pools are
never released, which rds_ib_exit()'s flush_workqueue(rds_wq) cannot
recover.  The QP, CQs and cm_id created by that late rds_ib_setup_qp() also
look like they stay around, since rdma_destroy_id() only happens in
rds_ib_conn_path_shutdown().

There is a second effect in the same window: the connection is bound to the
HCA but deliberately kept off rds_ibdev->conn_list, and device removal only
walks that list:

net/rds/ib.c:rds_ib_dev_shutdown() {
	spin_lock_irqsave(&rds_ibdev->spinlock, flags);
	list_for_each_entry(ic, &rds_ibdev->conn_list, ib_node)
		rds_conn_path_drop(&ic->conn->c_path[0], true);
	spin_unlock_irqrestore(&rds_ibdev->spinlock, flags);
}

Before this patch the node was still moved onto the device conn_list here,
so ib_device removal could at least find it.  Is losing that intentional?

And in the reverse interleaving, rds_ib_conn_path_shutdown() tests
ic->rds_ibdev without a lock and then asserts on it:

net/rds/ib_cm.c:rds_ib_conn_path_shutdown() {
		if (ic->rds_ibdev)
			rds_ib_remove_conn(ic->rds_ibdev, conn);
		...
	}
	BUG_ON(ic->rds_ibdev);

Can a concurrent rds_ib_add_conn() for the claimed connection store
ic->rds_ibdev between that test and the BUG_ON, making it fire?

For what it is worth, at the end of the series the later patch "net/rds: pin
the connection across RDMA-CM event handling" adds an
rds_destroy_pending() check only to rds_ib_cm_handle_connect(), so the
active path rds_ib_cm_initiate_connect() -> rds_ib_setup_qp() ->
rds_ib_add_conn() still looks unguarded, and rds_ib_add_conn() and
rds_ib_conn_free() are otherwise unchanged there.

> @@ -163,13 +173,40 @@ void rds_ib_destroy_nodev_conns(void)
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
> +	 * node itself, under this lock, once we drop it.  Marking the
> +	 * node detached claims it for this sweep: rds_ib_add_conn(),
> +	 * rds_ib_remove_conn() and rds_ib_conn_free() leave a claimed
> +	 * node alone, so the walk over tmp_list below needs no lock.
> +	 * Avoid calling conn_destroy with irqs off.
> +	 */
>  	spin_lock_irq(&ib_nodev_conns_lock);
> -	list_splice_init(&ib_nodev_conns, &tmp_list);
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
>  }

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260919061149.250658-1-achender%40kernel.org
