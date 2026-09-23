Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F884499BA;
	Wed, 23 Sep 2026 07:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790147505; cv=none; b=V50EMmRZ1s2oC52noLPp2Kovoi9Edh8+VJXBWRiDqJY6I0R5Np8XknRDpx43mvWSsOOzpcJjvcLMA4k7gUL712BNulhJNfSry0CdE5xxoOJY8vfaMKz2N5zXIC3xxkJn95MzV+bWMhVL0+NaMz1ItNFRgPzj0ymi8MyBa/N4Mh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790147505; c=relaxed/simple;
	bh=XJgq4U44waRxv9ZeekCO3Vf3ChiB8xy1jMP+ebHsNIM=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RLsjh0ayhbDK7zgtiAvQFe5tbgsPLamSYOWX6hHxzUhqjIIy5jDcIHfigyE9QRy0leZrNmXlw1Kr2z7++VC4oO1CSdqJDMpkpPx08Wkvma84Nf4f3v9TyLzdxP0kbJj5vW2QnwF8t1VtKUjA4QwErErgl4FGIf9TwvbvHg1BBPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ln9e7DRo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ln9e7DRo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01AAB1F00898;
	Wed, 23 Sep 2026 07:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790147502;
	bh=9mhN52NQI+quaQTt6oAVtCyezl96/rNDJWCJ0wvLTJ4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Ln9e7DRoavjte/x1PZ+G0WaGWPzVMTcyQS6xbIyxTi4qUAd33gkfgGtEJHJKPo7tD
	 YznQS+StldXeSwwF1YaoGgOw3Sa/1hHiU+wWqP2+skbiBoVygPnGtuzxOFqrPAKTzL
	 jNuAgRCAbS6PpsgDgbX33kjRoJKUTWON9gfmKslJiSl1MLa4xtbtMqpw9GATHuE11U
	 O5Al4nfVWw4JW4q9aRJ6lGTTKjqxVMWefLwEdpWKAcjH3RPYE9X1+qg8Yge5CdZiWH
	 3zX/ghDSp1dui1rK8WEIYRxDqd5atu7elft+2H6bgAuV/PukgLRm6eXHWSIGYlKbah
	 Awt2FiulC5o2A==
Subject: Re: [PATCH net-next v5 10/12] net/rds: pin the connection across
 RDMA-CM event handling
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Wed, 23 Sep 2026 07:11:41 +0000
Message-ID: <179014750156.2160803.1314634841859810844@kernel.org>
In-Reply-To: <20260919061149.250658-11-achender@kernel.org>
References: <20260919061149.250658-11-achender@kernel.org>
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

- [Low] Stale forward-referencing comment: the ownership comment at the
  `out:` label of rds_ib_cm_handle_connect() (net/rds/ib_cm.c:936-940)…
- [Low] Misattributed trigger in both the commit message and the new in-
  code comment: the message states "the remaining exposure is a callback…

--

net/rds: pin the connection across RDMA-CM event handling

The RDMA-CM event handler takes a reference on the connection it picks up
from cm_id->context and drops it at the out: label, ignoring the event
entirely if the connection is already on its way out.
rds_ib_cm_handle_connect() also re-checks rds_destroy_pending() under
c_cm_lock and rejects the connect request instead of claiming the
DOWN -> CONNECTING transition.

A couple of questions about the commit message and about a comment that
this patch appears to invalidate.

>     Now that a connection is freed by its last reference, the remaining
>     exposure is a callback that drops the last reference other than the
>     handler's - which has none - and the reference handed out by
>     rds_conn_create() to rds_ib_cm_handle_connect() and dropped at its
>     end.

[Severity: Low]
Is there really a callback below the handler that drops a connection
reference?

For most events the handler calls rds_conn_drop(), which ends in
rds_conn_path_drop() in net/rds/connection.c:

	atomic_set(&cp->cp_state, RDS_CONN_ERROR);
	...
	queue_work(cp->cp_wq, &cp->cp_down_w);

That only flips the state and queues the shutdown work, it releases no
reference.  rds_ib_cm_initiate_connect() and rds_ib_cm_connect_complete()
have no rds_conn_put() or rds_conn_destroy() either.  The only
rds_conn_put() in net/rds/ib_cm.c is the one at the end of
rds_ib_cm_handle_connect(), and that path only runs when cm_id->context
was NULL (BUG_ON(cm_id->context) just above it), so the handler's own conn
is NULL there and neither the new reference nor c_cm_lock is in play.

The pin still looks necessary, but for a different reason: a concurrent
rds_conn_destroy() from transport or device teardown can drop the last
reference while the handler is still inside the switch holding c_cm_lock.
For example rds_ib_destroy_nodev_conns() in net/rds/ib_rdma.c:

	rds_conn_destroy(conn);
	rds_conn_put(conn);

rds_conn_shutdown() only takes cp_cm_lock around the state transition, and
skips it when the path is already DOWN, so that thread is not serialized
against a handler sitting in the switch.  Without the new reference the
handler's mutex_unlock(&conn->c_cm_lock) would run on freed memory.

Would it be clearer to describe that path instead?  As written a reader
could look for the callback that drops the reference, not find one, and
conclude the pin is not needed.

> diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
> index 786ddcb45bcb..abe5919c368a 100644
> --- a/net/rds/ib_cm.c
> +++ b/net/rds/ib_cm.c
> @@ -874,6 +874,13 @@ int rds_ib_cm_handle_connect(struct rdma_cm_id *cm_id,
>  	 * see the comment above rds_queue_reconnect()
>  	 */
>  	mutex_lock(&conn->c_cm_lock);
> +	/* A destroy that has already quiesced this conn leaves it in
> +	 * RDS_CONN_DOWN with no cm_id, exactly what the transition
> +	 * below would happily claim; nothing would tear the new cm_id
> +	 * and QP down again before the conn is freed.  Reject instead.
> +	 */
> +	if (rds_destroy_pending(conn))
> +		goto out;
>  	if (!rds_conn_transition(conn, RDS_CONN_DOWN, RDS_CONN_CONNECTING)) {
>  		if (rds_conn_state(conn) == RDS_CONN_UP) {
>  			rdsdebug("incoming connect while connecting\n");

[Severity: Low]
Should the comment at the out: label further down in
rds_ib_cm_handle_connect() be updated by this patch?  It currently reads:

net/rds/ib_cm.c:rds_ib_cm_handle_connect() {
	...
out:
	if (conn) {
		mutex_unlock(&conn->c_cm_lock);
		/* Drop the reference rds_conn_create() handed us.  The
		 * conn stays reachable through cm_id->context without a
		 * reference of its own for now; the CM event handler is
		 * given one of its own by a following patch.
		 */
		rds_conn_put(conn);
	}
	...
}

This patch is the "following patch" that comment points at, so from here
on the statement that the CM event handler holds no reference of its own
is no longer true, and the forward reference has nothing left to look
forward to.  The comment is still unchanged at the tip of the series, so
the two files end up describing contradictory reference rules for CM
event handling.

> diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
> index b15cf316b23a..584e9867810f 100644
> --- a/net/rds/rdma_transport.c
> +++ b/net/rds/rdma_transport.c
> @@ -63,6 +63,18 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
>  	if (cm_id->device->node_type == RDMA_NODE_IB_CA)
>  		trans = &rds_ib_transport;
>  
> +	/* cm_id->context carries no reference of its own.  Pin the
> +	 * connection for the duration of the handler: what the callbacks
> +	 * below do may drop the last reference other than ours, and the
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[Severity: Low]
Same question here as on the changelog: which callback below drops a
connection reference?  rds_conn_drop() only queues cp_down_w, and neither
rds_ib_cm_initiate_connect() nor rds_ib_cm_connect_complete() calls
rds_conn_put().  Would naming the concurrent rds_conn_destroy() path,
such as rds_ib_destroy_nodev_conns(), describe what this pin protects
against?

> +	 * mutex released at out: lives in the connection's path array.
> +	 * A connection already being freed gets no events handled.
> +	 */
> +	if (conn && !rds_conn_get_unless_zero(conn)) {
> +		rdsdebug("conn %p id %p is being freed, ignoring event\n",
> +			 conn, cm_id);
> +		return 0;
> +	}
> +
>  	/* Prevent shutdown from tearing down the connection
>  	 * while we're executing. */
>  	if (conn) {

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260919061149.250658-1-achender%40kernel.org
