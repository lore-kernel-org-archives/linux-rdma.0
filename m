Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4C5319851;
	Thu, 10 Sep 2026 01:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789002185; cv=none; b=bZYqRCLIXzBk6her/1CfqhuyZ6mnzIgoTMqI7HJjDKYdMPnpd000Z/AzSkWsumzKkZQLHf4aol8LWWchBeIHyw3zS9ItT+NJ2gSUmkBMlW3++qC7hOBjRWP7YCbG0w5jkpKlqq/4Wnphl5CyKM7ccp/6ZbY4VtFA9ZjR00tzGtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789002185; c=relaxed/simple;
	bh=W5ikgruGDJVCfgzI2RXbBJlnuBmWJ0hmSkqsM+e+gfI=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Y+Ea164LVPXhWpF6KuaRZDliurZGRp3MJ/TXzJm3UZKgGA2rzMKn63uKrlajTFy3UAblvuz4Yfj3IAR9uhlQvY7/P1IDfn5lHXS4K9jg2du+e5ZCar7RBeWoPKXg40Gs3570T248bqh+6cPcDRBM29sipkv8C6mnOkmTVmjvPYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CJv7H6J3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CJv7H6J3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BA91F00893;
	Thu, 10 Sep 2026 01:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789002183;
	bh=2Dj/orflIRDzSIVkzby/Vu/Kglyjipm3yxS8NWmi8NU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=CJv7H6J3brIag1Dvs+K1u6pGe+3h3tInR3Js7wSLebdWLN13KE9aB0AvkR644vOct
	 mPhlXogeSFLOBHQ0dbBJb6EB7bcAdYWVlMZai744gZsovGgRMtW8TGev89hMk3UJnY
	 SuLMrmWbBxbTFTgyu9JGZ5/izCimqoVoP6D0Qk5xxn9H6y3Meg1ip83oENxfy96sSi
	 zrBYNNn9y1ATNQuF55MavG1ZWc8iSqMHJfwCzQg5GhioQor4T9flDFzcHK/X+jkwA/
	 Syhhrkw9eD83SxYZi47fmwUuw2XTRDZwJuYC98XJkG8BpmYFZRfZIZ8f3asXg9i5Bj
	 vUHYJTsdsqGhw==
Subject: Re: [PATCH net-next 2/6] net/rds: split connection destroy into
 quiesce and kref-governed free
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Thu, 10 Sep 2026 01:03:02 +0000
Message-ID: <178900218299.219967.18130567079488498198@kernel.org>
In-Reply-To: <20260904070248.160384-3-achender@kernel.org>
References: <20260904070248.160384-3-achender@kernel.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider:

Critical: 0 · High: 0 (1) · Medium: 0 · Low: 3

- [Low] Commit message misattributes the non-rmmod destroy paths.
- [Low] Concern (assessed as a false positive, retained for policy
  reasons): the new c_refcount comment in net/rds/rds.h:140-144 was read…
- [Low] Stale symbol reference after the rename performed by this patch:
  the correctness argument inside rds_conn_shutdown() still says…

Pre-existing issues:
- [High] Deadlock when an IB connection is destroyed from the CM event
  handler after unsupported protocol negotiation:…

--

net/rds: split connection destroy into quiesce and kref-governed free

This patch adds a kref to struct rds_connection and splits the teardown so
that rds_conn_destroy() still quiesces synchronously while the frees (the
transport conn_free, the path workqueues, the c_path array and the slab
object) move to rds_conn_destroy_fini(), which runs from the last
rds_conn_put().  rds_conn_get()/rds_conn_put() are exported for the
reference holders added in later patches.

No Link: tags are present in the commit header.

A couple of questions below, one about the changelog and two about the
teardown path.

[Severity: Low]

The changelog says:

    Today, connections can also be destroyed when the underlying IB
    device is removed (in rds_ib_destroy_nodev_conns()), or when a peer
    negotiates an unsupported protocol version.

Is rds_ib_destroy_nodev_conns() the device removal path?  It has a single
caller, rds_ib_exit(), which is the rds_rdma module unload path, i.e. the
same rmmod case the old comment allowed.

The IB device removal path, rds_ib_dev_shutdown(), only drops paths:

	list_for_each_entry(ic, &rds_ibdev->conn_list, ib_node)
		rds_conn_path_drop(&ic->conn->c_path[0], true);

Meanwhile the two destroy paths that really are not rmmod are the netns
teardown ones, and they are not mentioned:

	rds_tcp_exit_net() -> rds_tcp_kill_sock() -> rds_conn_destroy()
	rds_loop_exit_net() -> rds_loop_kill_conns() -> rds_conn_destroy()

Would citing those two, together with the peer protocol version case in
rds_ib_cm_connect_complete(), describe the motivation more accurately?

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index 50e1b6bfceeab..f45fd1fb1843d 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c

[ ... ]

> @@ -515,10 +516,12 @@ void rds_conn_shutdown(struct rds_conn_path *cp)
>  		conn->c_trans->conn_slots_available(conn, false);
>  }
>  
> -/* destroy a single rds_conn_path. rds_conn_destroy() iterates over
> - * all paths using rds_conn_path_destroy()
> +/* quiesce a single rds_conn_path: shut it down and tear down any
> + * queued messages.  rds_conn_destroy() iterates over all paths using
> + * rds_conn_path_quiesce(); the transport state and the workqueue are
> + * freed later, from rds_conn_path_free().
>   */
> -static void rds_conn_path_destroy(struct rds_conn_path *cp)

[Severity: Low]

With rds_conn_path_destroy() gone, the comment inside rds_conn_shutdown()
that justifies the cancel_delayed_work_sync(&cp->cp_conn_w) call still
names it:

			 * Quiesce the reconnect timer before bailing
			 * out, though.  When a pending destroy did
			 * suppress the queue, no later pass runs, and
			 * rds_conn_path_destroy() is about to flush
			 * cp_down_w and free the path: it must not
			 * find cp_conn_w still armed.

That comment is now the only match for rds_conn_path_destroy in the tree,
and it stays that way through the end of the series.  Since the flush of
cp_down_w is done by rds_conn_path_quiesce() while the free happens later
in rds_conn_path_free(), should the comment be reworded to name
rds_conn_path_quiesce() and note that the free is deferred?

> +static void rds_conn_path_quiesce(struct rds_conn_path *cp)
>  {
>  	struct rds_message *rm, *rtmp;
>  

[Severity: High]

This isn't a bug introduced by this patch, the same sequence exists in the
baseline rds_conn_path_destroy(), but can the quiesce deadlock when it is
reached from the RDMA CM event handler?

rds_conn_path_quiesce() keeps the drop plus synchronous flush:

	rds_conn_path_drop(cp, true);
	flush_work(&cp->cp_down_w);

rds_rdma_cm_event_handler_cmn() holds the mutex across the callback:

	if (conn) {
		mutex_lock(&conn->c_cm_lock);
	...
		trans->cm_connect_complete(conn, event);

and rds_single_path.h aliases that mutex to the path one:

	#define	c_cm_lock		c_path[0].cp_cm_lock

If the peer negotiates a version below RDS_PROTOCOL_VERSION,
rds_ib_cm_connect_complete() destroys the connection with that mutex still
held:

		rds_conn_destroy(conn);
		return;

rds_conn_path_drop(cp, true) sets cp_state to RDS_CONN_ERROR and queues
cp_down_w, so the flushed worker runs rds_shutdown_worker() ->
rds_conn_shutdown(), where the initial transition fails and it blocks on
the same mutex:

	if (!rds_conn_path_transition(cp, RDS_CONN_DOWN, RDS_CONN_DOWN)) {
		...
		mutex_lock(&cp->cp_cm_lock);

Does flush_work() then wait for a worker that is waiting for the mutex the
blocked CM handler owns?  The chain has no trylock or timeout, and it is
unchanged at the head of the series, so would this be a good place to
break the cycle while the destroy path is being reworked?

>  	WARN_ON(delayed_work_pending(&cp->cp_recv_w));
>  	WARN_ON(delayed_work_pending(&cp->cp_conn_w));
>  	WARN_ON(work_pending(&cp->cp_down_w));

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260904070248.160384-1-achender%40kernel.org
