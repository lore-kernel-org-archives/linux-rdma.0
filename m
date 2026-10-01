Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CAC479873;
	Thu,  1 Oct 2026 06:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790835377; cv=none; b=SAPXETJbXuqWasD4EEZv6YgseI775u4bpIl0y4SuiSYrui1RCdMEi1zBPpI5VfMXJDqBoZdIJWlj+Wm7pipXBw51O5jWIb2mm0Isu4tFGJ5vayQ6+G/ds6IAeIm/pRrywRROiHjmpcYwaEQCcfY1n2AktxC+fJ8Qi7Cgx6pu4nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790835377; c=relaxed/simple;
	bh=0ADINqkbiVQXcj1904zxyfrVtqdfAjX7CW0LpaIxG9U=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IrWDO3AvYiyUPG0fe9B4DPhpO7XiiwHYFhQseS9eYpg+lHTyd5EaZDiqGnM0wst2MdoRAtIf0+vLUthZI6cwt7zu/ASTsKuRQHj1KO2ArnnrEnG/Q5h9hblDrx3zMTqW/lAGMTvlvXjfTiLhtvsM985Dp1x0zCX3C3COc+F7zC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PQeIUKaM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PQeIUKaM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6801F00898;
	Thu,  1 Oct 2026 06:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790835375;
	bh=DIAOovQNlfYQfwGuBPY5N9jHX9ZcxmnN6WfNEr48rjI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=PQeIUKaMFGzU6ARcjay82pTaro1fjSzF2qJe7Pw64D2QSFDvNRv9FRTM9wOxG1V6/
	 9lngr4RpS+ue0Le8yneqMQ+QQ41fvyLoS5tBfLO1yt6VkmMnIwj00MVgSViNKMz536
	 ZgmdEDbkA8sqvEt0cJmKLoby4RJ9elysu+wI2Gk3bn3davIivFmZvvMCm62PIB7Z9B
	 P+PVwbfRr+5iRh/tPjWXYpwmuUUSSr7g7qBLmh7r4rUo0UQq3/DimIjQyo8Ip3D8/S
	 BTDLpQYbSa2Vtfy6sVKRfDLkadgBAEml+ObxW5mfsxsl7rqfHim7lzgOld4TqmVBW8
	 S7qQqTpRQDoMg==
Subject: Re: [PATCH net-next v7 11/12] net/rds: pin the connection across
 RDMA-CM event handling
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Thu, 01 Oct 2026 06:16:14 +0000
Message-ID: <179083537495.434549.17126109584817331670@kernel.org>
In-Reply-To: <20260927061448.167862-12-achender@kernel.org>
References: <20260927061448.167862-12-achender@kernel.org>
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
issue(s) to consider.

Critical: 0 · High: 1 (1) · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The new rds_destroy_pending() check at the top of
  rds_ib_cm_initiate_connect() (ib_cm.c:966) does not close the…

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but it sits in the
  function the patch modifies and is still reachable at the end of the…

--

net/rds: pin the connection across RDMA-CM event handling

This commit makes rds_rdma_cm_event_handler_cmn() hold a reference on the
connection it takes from cm_id->context for as long as it handles each
RDMA-CM event. Events for connections that are already at zero references
are ignored. It also adds rds_destroy_pending() checks to
rds_ib_cm_initiate_connect() and rds_ib_cm_handle_connect(), so that no new
QP or cm_id is installed on a connection whose destroy has already started.

> diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
> index ee018dd230e9d..948fbf4b6a852 100644
> --- a/net/rds/ib_cm.c
> +++ b/net/rds/ib_cm.c

[ ... ]

> @@ -948,6 +955,17 @@ int rds_ib_cm_initiate_connect(struct rdma_cm_id *cm_id, bool isv6)
>  	union rds_ib_conn_priv dp;
>  	int ret;
>  
> +	/* A destroy that began while the address and route were being
> +	 * resolved has already quiesced this conn, or is waiting on
> +	 * c_cm_lock to do so.  Setting up a QP now would leave it - and
> +	 * the device reference rds_ib_add_conn() takes - with no
> +	 * shutdown pass left to tear them down.  The id we were handed
> +	 * is still ic->i_cm_id, so return success and let that shutdown
> +	 * destroy it, rather than have the rdma_cm destroy it on error.
> +	 */
> +	if (rds_destroy_pending(conn))
> +		return 0;

[Severity: High]

Does this check also cover transport unload? rds_destroy_pending() reports
unload through t_unloading.

Against the connection's own destroy the check works, because the shutdown
pass also takes c_cm_lock. The unload teardown in rds_ib_exit() never takes
c_cm_lock, though. Nothing checks for unload again when the conn is
attached to the device. This interleaving looks possible:

CPU1 (ROUTE_RESOLVED handler)
rds_ib_cm_initiate_connect()
  rds_destroy_pending(conn)   <- false, unloading not yet set
  rds_ib_setup_qp()
    rds_ib_get_client_data()  <- takes dev ref, drops rcu_read_lock()
    <preempted>

CPU2 (rmmod)
rds_ib_exit()
  rds_ib_set_unloading()
  synchronize_rcu()           <- does not wait for CPU1
  rds_ib_unregister_client()
    rds_ib_remove_one()
      rds_ib_dev_shutdown()   <- walks only rds_ibdev->conn_list, but the
                                 conn is still on ib_nodev_conns
      ib_set_client_data(device, &rds_ib_client, NULL)
      list_del_rcu(&rds_ibdev->list)

CPU1 resumes
    rds_ib_add_conn()         <- i_ib_node_detached is still false, so the
                                 conn moves to the removed device's
                                 conn_list
  rdma_connect_locked()       <- succeeds, the HCA is still present

rds_ib_destroy_nodev_conns() then scans only ib_nodev_conns, and so does
every resweep from rds_conn_wait_conns_freed(). This conn is never
destroyed.

Later DISCONNECTED or REJECTED events call rds_conn_drop(). That queues no
shutdown, because rds_destroy_pending() is true. No DEVICE_REMOVAL event
arrives either, since the IB device isn't going away.

Would t_conn_count then never reach zero? If so, rds_ib_exit() would loop
in rds_conn_wait_conns_freed() forever. The conn, QP, CQs and device
reference would all leak. That is the same hang the commit message says
this check prevents.

The passive side doesn't seem to have this problem during unload.
rds_rdma_listen_stop() runs first. rdma_destroy_id() on the listener then
waits on the handler_mutex, which is held while CONNECT_REQUEST is
delivered.

To close the active-side window, would rds_ib_add_conn() or
rds_ib_setup_qp() need an admission check that is synchronized with the
unload sweep? The early predicate check alone doesn't seem to be enough.

> +
>  	/* If the peer doesn't do protocol negotiation, we must
>  	 * default to RDSv3.0 */
>  	rds_ib_set_protocol(conn, RDS_PROTOCOL_4_1);
> diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
> index b15cf316b23a2..3dda7cf76ebb6 100644
> --- a/net/rds/rdma_transport.c
> +++ b/net/rds/rdma_transport.c
> @@ -63,6 +63,21 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
>  	if (cm_id->device->node_type == RDMA_NODE_IB_CA)
>  		trans = &rds_ib_transport;
>  
> +	/* cm_id->context carries no reference of its own.  Pin the
> +	 * connection for the duration of the handler, since the mutex
> +	 * released at out: lives in the connection's path array.  None
> +	 * of the callbacks below drops a reference on this connection,
> +	 * and the shutdown destroys the cm_id - waiting for a running
> +	 * handler - before the last reference can go, so this is
> +	 * defensive.  A connection already at zero references gets no
> +	 * events handled.
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

[Severity: High]

This isn't a bug introduced by this patch, but it is in the function
being modified, and it is still reachable after this series. Further down,
the RDMA_CM_EVENT_ADDR_RESOLVED case passes the result of
rdma_resolve_route() back to the rdma_cm without filtering it:

net/rds/rdma_transport.c:rds_rdma_cm_event_handler_cmn() {
    ...
	case RDMA_CM_EVENT_ADDR_RESOLVED:
		if (conn) {
			...
			/* XXX do we need to clean up if this fails? */
			ret = rdma_resolve_route(cm_id,
						 RDS_RDMA_RESOLVE_TIMEOUT_MS);
		}
		break;
    ...
}

rdma_resolve_route() can fail synchronously. Some examples:

  - -ENOMEM from cma_resolve_ib_route()
  - an SA query setup failure
  - -ENODEV or -EINVAL from cma_resolve_iboe_route() on RoCE

When the handler returns non-zero, addr_handler() frees the id:

drivers/infiniband/core/cma.c:addr_handler() {
    ...
	if (cma_cm_event_handler(id_priv, &event)) {
		destroy_id_handler_unlock(id_priv);
		return;
	}
    ...
}

The same cm_id is still stored in ic->i_cm_id, and nothing clears it. The
connection stays in RDS_CONN_CONNECTING. Incoming connects from the peer
only hit the "Wait and see" branch in rds_ib_cm_handle_connect(), so the
pair cannot reconnect.

Later the connection is shut down, for example by rds_conn_destroy() on
module unload. rds_ib_conn_path_shutdown() then finds ic->i_cm_id
non-NULL and does the following on it:

  - calls rdma_disconnect(ic->i_cm_id)
  - reads ic->i_cm_id->qp
  - calls rdma_destroy_id(ic->i_cm_id)

Is that a use-after-free, followed by a second destroy of the cm_id?

The ROUTE_RESOLVED path already avoids this. rds_ib_cm_initiate_connect()
forces ret = 0 when ic->i_cm_id == cm_id, and the new early return in
this patch returns 0 for the same reason.

Should the ADDR_RESOLVED case get the same guard?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260927061448.167862-1-achender%40kernel.org
