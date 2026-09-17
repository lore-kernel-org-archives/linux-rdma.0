Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84FF4B66FB;
	Thu, 17 Sep 2026 09:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789637966; cv=none; b=BrpNRzg1g7pkJI4iWOGGFsAvyTkmBim9l/wamGki/Z6x3Uu6/uByshrjXEYyPtGi523097BLjBW6zSpNqmYIdu8Z8IXokohCsr6oXGRyeZl2CyJcLxpXA3mvkxawtFL0Ox47OFvs4AKfJlmY2EuKa8PZ+rwPedQCb5uRsFaKIBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789637966; c=relaxed/simple;
	bh=iWA0+Wwhf2Mg+fYVN/t/KtWxP6KRVbvaiKxO9oorpLo=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s6Yo3GLOoAidPWAxo4eDzpRz1yitnuzPBKnRfvdiVpwxNS3yMHBZW/8twm+i5f4sQAQHaDSLIypYRlyB53FUer2xtbhYPUnqTiJxtXUruMZZq6egRhbnmdV1YHB+tjLqKBqclkqRU8eEOgiASEVp7HSLDsDFu3c9d3P2cmxHYAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gTTJY5y9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gTTJY5y9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3C91F00899;
	Thu, 17 Sep 2026 09:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789637929;
	bh=4hbnbhgv368KnNhlupjo6lL9EC73yude5iGpkEmq9EA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=gTTJY5y9LjvpwDX/G6P1qwu3I2TuflIMkFK7Sz4TaZrvJycksS1uGblifk3QZm87u
	 5gg6tQMdi0keGMbV77o5b/WNliVhoSSC4SzbFQOgjnL/S5BnA3EsYAs4V/yYKeiGZ0
	 GfRdun2dfdonOK465+4QUoA1Cp0ItgJ5pg8ZUpJMSc7LrK+go93DDps6/cMkTI7LpT
	 IVDXpCzq+6AGUC4vifrshFhB5ZMD5grxp9iZx4DWypmbd8Yz1qq8ZuVEQFcn6HMlWP
	 1+1affzaVI4jTpW/RsFv6ZRlJnbX96nvLyoVOB0rzSRmjHjmQ6xo4oua0mG0cOxCVI
	 Up4QBL222Y83w==
Subject: Re: [PATCH net-next v3 11/13] net/rds: pin the connection across
 RDMA-CM event handling
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Thu, 17 Sep 2026 09:38:48 +0000
Message-ID: <178963792823.22033.13533789241810444484@kernel.org>
In-Reply-To: <20260914033719.138057-12-achender@kernel.org>
References: <20260914033719.138057-12-achender@kernel.org>
X-sashiko-severity: High
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

Critical: 0 · High: 1 (1) · Medium: 0 · Low: 0

- [High] Self-deadlock: rds_ib_cm_connect_complete() destroys the
  connection synchronously from inside the RDMA-CM event callback, while…

Pre-existing issues:
- [High] Uninitialized function-pointer-bearing struct pointer
  dereference in rds_rdma_cm_event_handler_cmn()…

--

net/rds: pin the connection across RDMA-CM event handling

The patch takes a reference on the connection found in cm_id->context for
the duration of rds_rdma_cm_event_handler_cmn(), ignoring the event when
the connection is already on its way out, and adds an rds_destroy_pending()
re-check under c_cm_lock in rds_ib_cm_handle_connect().  A new helper,
rds_conn_get_unless_zero(), wraps kref_get_unless_zero() on c_refcount.

> diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
> index b15cf316b23a2..584e9867810f4 100644
> --- a/net/rds/rdma_transport.c
> +++ b/net/rds/rdma_transport.c
> @@ -63,6 +63,18 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
>  	if (cm_id->device->node_type == RDMA_NODE_IB_CA)
>  		trans = &rds_ib_transport;
                        ^^^^^

[Severity: High]

This isn't a bug introduced by this patch, but since the new hunk lands
directly underneath it: is trans guaranteed to be initialized here?  In
rds_rdma_cm_event_handler_cmn() the declaration is a plain

	struct rds_transport *trans;

and the only assignment is the RDMA_NODE_IB_CA test above, with no else
branch and no bail-out for other node types.  The CONNECT_REQUEST case then
dereferences it unconditionally:

	case RDMA_CM_EVENT_CONNECT_REQUEST:
		ret = trans->cm_handle_connect(cm_id, event, isv6);

On that path conn is NULL (the child cm_id inherits the listener's NULL
context), so none of the "if (conn)" guards cover the use.

Can a non-IB-CA device reach this handler?  RDS's own comment in
rds_ib_laddr_check() says so:

	/* rdma_bind_addr will only succeed for IB & iWARP devices */
	...
	/* due to this, we will claim to support iWARP devices unless we
	   check node_type. */

and rds_ib_add_one() rejects anything that is not RDMA_NODE_IB_CA, while
rds_rdma_listen_init() listens on INADDR_ANY, so the CM fans connect
requests out over every registered device.  With an iWARP or usnic device
present, would a remote connect request to RDS_PORT end up making an
indirect call through an indeterminate stack value?  The kernel build
disables -Wmaybe-uninitialized, so nothing flags it at compile time.

Still present unchanged at the end of the series.

>  
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

The commit message says "a callback that drops the last reference other
than the handler's implicit one leaves the final mutex_unlock() running on
freed memory".  Which callback is that?

The one callback that destroys the connection is the ESTABLISHED path, and
on that path control does not seem to reach the new rds_conn_put() at all,
because the destroy blocks on the mutex the handler is still holding:

rds_rdma_cm_event_handler_cmn()
  mutex_lock(&conn->c_cm_lock);	/* == conn->c_path[0].cp_cm_lock */
  trans->cm_connect_complete(conn, event)
    rds_ib_cm_connect_complete()
      rds_conn_destroy(conn)
        rds_conn_path_quiesce()
          rds_conn_path_drop(cp, true)	/* always queues cp_down_w */
          flush_work(&cp->cp_down_w)
            rds_shutdown_worker() -> rds_conn_shutdown()
              mutex_lock(&cp->cp_cm_lock);	/* held by the caller */

Is this a circular wait?  The handler thread waits in flush_work() for
cp_down_w, and the flushed worker waits for cp_cm_lock, which the handler
thread holds.

rds_conn_shutdown() does enter that block, since rds_conn_path_drop() has
just moved the state to RDS_CONN_ERROR, so the DOWN -> DOWN transition
fails:

net/rds/connection.c:rds_conn_shutdown() {
	if (!rds_conn_path_transition(cp, RDS_CONN_DOWN, RDS_CONN_DOWN)) {
		/*
		 * ... We don't hold the mutex for the entire
		 * duration of the shutdown operation, else we may be
		 * deadlocking with the CM handler. Instead, the CM event
		 * handler is supposed to check for state DISCONNECTING
		 */
		mutex_lock(&cp->cp_cm_lock);
	...
}

The existing comment there states the assumption that the CM handler only
checks DISCONNECTING and returns.  Does the synchronous rds_conn_destroy()
from inside rds_ib_cm_connect_complete() break that assumption?

The trigger looks remote-controlled.  In rds_ib_cm_connect_complete():

	if (conn->c_version < RDS_PROTOCOL_VERSION) {
		if (conn->c_version != RDS_PROTOCOL_COMPAT_VERSION) {
			pr_notice("RDS/IB: Connection <%pI6c,%pI6c> version %u.%u no longer supported\n",
			...
			rds_conn_destroy(conn);
			return;
		}
	}

A peer accepting with an older advertised version reaches it, and so does a
peer accepting with absent or short private data: the connection is
allocated with kmem_cache_zalloc() and only rds_ib_set_protocol() ever
writes c_version, so c_version stays 0 and compares below
RDS_PROTOCOL_VERSION.

There is a second effect worth checking: the RDMA core holds
id_priv->handler_mutex across the callback, so while the handler thread is
parked in flush_work(), CM events for that cm_id stop and a later
rdma_destroy_id() on it would block as well - and the shutdown worker's
rds_ib_conn_path_shutdown() needs handler_mutex itself.

The synchronous destroy from the callback is older than this patch, but
since that is the very callback the new reference is meant to make safe,
would deferring the destroy out of the CM callback be the change that
actually covers it?  Pinning the connection does not help if the
mutex_unlock() and rds_conn_put() at out: are never reached.

Verified still present at the end of the series.

>  	/* Prevent shutdown from tearing down the connection
>  	 * while we're executing. */
>  	if (conn) {

[ ... ]

> @@ -171,8 +183,10 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
>  	}
>  
>  out:
> -	if (conn)
> +	if (conn) {
>  		mutex_unlock(&conn->c_cm_lock);
> +		rds_conn_put(conn);
> +	}
>  
>  	rdsdebug("id %p event %u (%s) handling ret %d\n", cm_id, event->event,
>  		 rdma_event_msg(event->event), ret);

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260914033719.138057-1-achender%40kernel.org
