Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8003AE1A5;
	Wed, 16 Sep 2026 04:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789533412; cv=none; b=ISk3g4nllI3DEjyV/YKyl7EnI095kGxUrJQK2U4a/OvzG76RxnSkyw5f5nIPT7UdO+Dc/QXhjuYBnGP1NVjeE65sNyfAKPcQqz5DiA5YiS2TlGVfSF7OOPh/VPvctXpwb+NMg+AyRNPfkgFCs3UmVpfk+iyI57qsZ2/cK+lMVh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789533412; c=relaxed/simple;
	bh=XW0y8RK5xV9MHBAFin6bt3WiNmZ/EOPx1H4VToDT1OM=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Bo7owdNguddaIXkPuR+kgotKwu/U2ljCi/TB9zqHR/LzP5g8xL0YidZr5BsGiEdPqX/SY1xpxfSCB9THnZ/IkuDGLYQ1fF2NmNRoJHWIZS3OK1uYAllSycj7SUK1gJ7WRLzsCpJ+QH9w9kgIQfn1E9CnmLcSIB6TW6vh8yv8Lj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NgDSOhCB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NgDSOhCB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170101F000FF;
	Wed, 16 Sep 2026 04:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789533410;
	bh=XdnGPRVtz/irOPRZzgO0rsB5kacCLtWcgNEH7EKkHWM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=NgDSOhCB8qbp3yqz+LwevACYDOrcTK9S+Y1Sq60pIslmYLp53F8ZpfVxIInxIn+/F
	 h9JxAbQ4Li5v7vRb6YJRzDZEqeFYC0RgZk1So8lX8xbc3hJ1VOgdGpnfTJALcw3dHy
	 Be7eTtRFh8VgPP0FU6/ffcZcftsUVUVgggMHjrwX9jkwpMVtNrBL9y0+ytfcquRc43
	 0WpGPRHuQEYFFG0QNXH6lfUPLNrAGGMwQCVsRFQqMiuK8gWctHZxAjwfT3a3L6XDSR
	 lDsbzG85EtxU7VFfuRapQY4GQqAbSgzRp9czdmtejyVsvkdQDCzdneT9HWRmyaOUuB
	 acgQfaPJwqhFg==
Subject: Re: [PATCH net-next v2 7/9] net/rds: pin the connection across
 RDMA-CM event handling
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Wed, 16 Sep 2026 04:36:49 +0000
Message-ID: <178953340967.22033.16717739111073634410@kernel.org>
In-Reply-To: <20260912035027.27447-8-achender@kernel.org>
References: <20260912035027.27447-8-achender@kernel.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 0 (2) · Medium: 0 · Low: 1

- [Low] Commit message misattributes a pre-existing use-after-free to the
  kref split, and never names the triggering callback.

Pre-existing issues:
- [High] Self-deadlock on the very callback path this patch relies on.
- [High] In the function this patch modifies, struct rds_transport
  *trans; (net/rds/rdma_transport.c:55) is assigned only under `if…

--

net/rds: pin the connection across RDMA-CM event handling

This adds a reference on the connection that rds_rdma_cm_event_handler_cmn()
picks up from cm_id->context, held for the duration of the handler, and skips
events for connections that are already being freed.  It also re-checks
rds_destroy_pending() under c_cm_lock in rds_ib_cm_handle_connect() so a
connect request cannot install a new cm_id and QP on a quiesced connection.

No Link: tags in the commit header.

A few questions below, mostly about the surrounding code that the new
reference is meant to protect.

First, on the changelog itself:

> Now that a connection is freed by its last reference rather than by
> rds_conn_destroy() itself, a callback that drops the last reference other
> than the handler's implicit one leaves the final mutex_unlock() running on
> freed memory.

[Severity: Low]

Is the hazard really new to this series?  In the baseline, rds_conn_destroy()
ended with:

	kfree(conn->c_path);
	kmem_cache_free(rds_conn_slab, conn);

so the connection was freed synchronously, and the handler's
mutex_unlock(&conn->c_cm_lock) at out: already ran on freed memory whenever a
callback destroyed the conn - unconditionally, not only when the last
reference happened to be dropped.

Also, which callback is meant here?  The only handler-reachable one seems to
be rds_ib_cm_connect_complete() on RDMA_CM_EVENT_ESTABLISHED, when the peer
advertises a protocol version below 3.1.  Could the changelog name that
trigger, so backporters know what to look for?

And what is "the handler's implicit one" reference?  Before this patch
cm_id->context carries no reference at all.

> diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
> index b15cf316b23a2..584e9867810f4 100644
> --- a/net/rds/rdma_transport.c
> +++ b/net/rds/rdma_transport.c
> @@ -63,6 +63,18 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
>  	if (cm_id->device->node_type == RDMA_NODE_IB_CA)
>  		trans = &rds_ib_transport;
>  

[Severity: High]

This isn't a bug introduced by this patch, but while looking at these lines:
can trans stay uninitialized here?  In
rds_rdma_cm_event_handler_cmn() it is a plain local:

	struct rds_transport *trans;
	...
	if (cm_id->device->node_type == RDMA_NODE_IB_CA)
		trans = &rds_ib_transport;

There is no else branch and no early return, yet the CONNECT_REQUEST case
calls through it:

	case RDMA_CM_EVENT_CONNECT_REQUEST:
		ret = trans->cm_handle_connect(cm_id, event, isv6);

RDS never calls rdma_restrict_node_type(), so cma_listen_on_dev() keeps
restricted_node_type == RDMA_NODE_UNSPECIFIED and installs the RDS listener
on every RDMA device, including iWARP RNICs (siw, cxgb4, irdma, qedr and
erdma all set node_type = RDMA_NODE_RNIC).  An incoming connect on such a
device reaches iw_conn_req_handler(), which creates a child id inheriting the
listener's event_handler and NULL context, and delivers CONNECT_REQUEST here.

Since conn is NULL on that path, the new rds_conn_get_unless_zero() guard
does not change reachability, so this ends up as an indirect call through an
uninitialized stack slot driven by a remote peer.  Would an explicit else
that rejects non-IB node types be appropriate while touching this function?

> +	/* cm_id->context carries no reference of its own.  Pin the
> +	 * connection for the duration of the handler: what the callbacks
> +	 * below do may drop the last reference other than ours, and the
> +	 * mutex released at out: lives in the connection's path array.
> +	 * A connection already being freed gets no events handled.
> +	 */
> +	if (conn && !rds_conn_get_unless_zero(conn)) {
> +		rdsdebug("conn %p id %p is being freed, ignoring event\n",
> +			 conn, cm_id);
> +		return 0;
> +	}
> +

[Severity: High]

This is a pre-existing issue, not something this patch introduces, but it is
the exact callback path the comment above refers to: can the handler ever
return from that callback?

c_cm_lock is conn->c_path[0].cp_cm_lock, taken just below and held until
out:, and the ESTABLISHED case dispatches with it held:

	case RDMA_CM_EVENT_ESTABLISHED:
		if (conn)
			trans->cm_connect_complete(conn, event);

rds_ib_cm_connect_complete() takes the peer's protocol major/minor straight
from the REP private data with no validation, and since RDS_PROTOCOL_VERSION
and RDS_PROTOCOL_COMPAT_VERSION are both RDS_PROTOCOL_3_1, any advertised
version below 3.1 makes both tests true:

	if (conn->c_version < RDS_PROTOCOL_VERSION) {
		if (conn->c_version != RDS_PROTOCOL_COMPAT_VERSION) {
			...
			rds_conn_destroy(conn);

>From there the cycle looks like this:

rds_rdma_cm_event_handler_cmn()
  mutex_lock(&conn->c_cm_lock)
  trans->cm_connect_complete()
    rds_ib_cm_connect_complete()
      rds_conn_destroy()
        rds_conn_path_quiesce()
          rds_conn_path_drop(cp, true)   /* sets ERROR, queues cp_down_w */
          flush_work(&cp->cp_down_w)
            rds_shutdown_worker()
              rds_conn_shutdown()
                mutex_lock(&cp->cp_cm_lock)   /* held by the CM handler */

rds_conn_shutdown()'s first transition DOWN -> DOWN fails because
rds_conn_path_drop() left the state at RDS_CONN_ERROR, so it goes on to take
cp_cm_lock and blocks.  flush_work() then never returns, and the

	out:
		if (conn) {
			mutex_unlock(&conn->c_cm_lock);
			rds_conn_put(conn);
		}

that this patch adds is never reached, so the new pin can never be exercised
on this path.  The comment in rds_conn_shutdown() states the assumption that
is inverted here ("we may be deadlocking with the CM handler ... the CM event
handler is supposed to check for state DISCONNECTING") - here the CM handler
is the one starting the shutdown while holding the lock.

Should rds_ib_cm_connect_complete() defer the destroy (for example via
rds_conn_path_drop() without the synchronous flush) instead of calling
rds_conn_destroy() under c_cm_lock?

>  	/* Prevent shutdown from tearing down the connection
>  	 * while we're executing. */
>  	if (conn) {

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260912035027.27447-1-achender%40kernel.org
