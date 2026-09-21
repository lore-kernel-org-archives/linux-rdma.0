Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE2D46D0B5;
	Mon, 21 Sep 2026 09:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789982142; cv=none; b=G5zabw6KqMGRYBQDg77SHkiom56py+ecYUB9KCvlpMdgEaaMsceKMiI1T2T6CpZV6uQ1trlyKNOQTkPkJNrmEp2v39h3FejsRzvO6966xIJgZhA4b6y9Z999XWHMm9ohWhSjUMeQYM8Au5pI4fVO4qX1gYyWc48Nq5u4rndN/wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789982142; c=relaxed/simple;
	bh=8oXtz6Tvwwnn7MByYKLY/739Y3rVt60yMpewDFJADmY=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uKgC6mwoHP3ku+U0WgD4DcgTyrMoVk56cHBAtkwknJq1/hc9fhr/6Ytz/5GapK3mCtqlpTfhuIsJFaRde7fjGKnDklmj3ygkjkSaeri35Ms6bRiw1td91FLEpW8XfFp2cOHXDyHSV9kHxD1Ov7mXspOS9hGlZaAtE7I9jQqnUEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mWGVu4Bu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mWGVu4Bu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8451F000FF;
	Mon, 21 Sep 2026 09:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789982140;
	bh=hA1Lis9focpsdZM+VkwZ154VPVY9XxS9H3LoXgUpu7A=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=mWGVu4BuP+MRCBnAOMY7q+W3a4OYCb2ZFtCfOjVWKgYA/uvVu3PaXFCZgua8fbxTT
	 Dv6lNFaXwakQ+XIp9i37SqsgbjSxMXHmBAL1c3c3kX3A44aegMMyWcuyGb5kalxhWT
	 qnML6IF5QDaQTA2gPwC2pFbTb5181n8ndpaFrZve+6vzBHyOyLPVzupfHGZUapD5Zo
	 hT/FG4Ou2BXc6jkQ0bqpdEI/ctVFSWrxb8aJnV3u9o5Ox7HMH36MDT1OD6Rj7doyTh
	 sNXckooMHQePLuavv5U7qeaiCL/m8TEFqxrZcEL+iwCkJGHVXm8U84t5B635KwZnjD
	 TkdExCFJIblUQ==
Subject: Re: [PATCH net-next v4 10/12] net/rds: pin the connection across
 RDMA-CM event handling
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Mon, 21 Sep 2026 09:15:39 +0000
Message-ID: <178998213978.2160803.12966181628951084236@kernel.org>
In-Reply-To: <20260917073958.174056-11-achender@kernel.org>
References: <20260917073958.174056-11-achender@kernel.org>
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

Critical: 0 · High: 1 (1) · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The commit message's central premise is false for this tree: it
  claims that rds_ib_cm_connect_complete()'s protocol-version-mismatch…
- [Low] Stale forward-reference comment: net/rds/ib_cm.c:936-940 (out:
  block of rds_ib_cm_handle_connect()) still says the conn "stays…

Pre-existing issues:
- [High] rds_rdma_cm_event_handler_cmn() declares `struct rds_transport
  *trans;` with no initializer and assigns it only for InfiniBand…

--

net/rds: pin the connection across RDMA-CM event handling

The RDMA-CM event handler takes a reference on the connection it picked
up from cm_id->context for the duration of the callback dispatch, and
ignores the event when the connection is already being freed.
rds_ib_cm_handle_connect() additionally re-checks rds_destroy_pending()
under c_cm_lock and rejects the incoming request in that case.

Two questions on the code and one on a quoted paragraph of the commit
message below.

> net/rds: pin the connection across RDMA-CM event handling
>
> rds_rdma_cm_event_handler_cmn() picks the connection up from
> cm_id->context, which carries no reference, and holds c_cm_lock - a
> mutex that lives in the connection's path array - across the transport
> callbacks.  Before this series that was already a use-after-free
> whenever a callback destroyed the connection, since rds_conn_destroy()
> freed it synchronously and the handler's mutex_unlock() ran on freed
> memory; the one such callback, rds_ib_cm_connect_complete() on a
> protocol version below 3.1, has meanwhile been switched to
> rds_conn_drop() by commit f97d8c7bab78 ("rds: ib: use rds_conn_drop()
> on protocol version mismatch"), which also removed the deadlock that
> destroy took on c_cm_lock.

[Severity: High]
Which tree does commit f97d8c7bab78 ("rds: ib: use rds_conn_drop() on
protocol version mismatch") come from?  I cannot find it in the baseline
or anywhere in this series, and rds_ib_cm_connect_complete() still calls
rds_conn_destroy() on the version-mismatch path, both at this commit and
at the end of the series:

net/rds/ib_cm.c:rds_ib_cm_connect_complete() {
	...
	if (conn->c_version < RDS_PROTOCOL_VERSION) {
		if (conn->c_version != RDS_PROTOCOL_COMPAT_VERSION) {
			pr_notice("RDS/IB: Connection <%pI6c,%pI6c> version %u.%u no longer supported\n",
				  ...);
			rds_conn_destroy(conn);
			return;
		}
	}
	...
}

If that call site is still there, is the deadlock the paragraph says was
removed still reachable?  The handler dispatches this callback with
c_cm_lock held:

rds_rdma_cm_event_handler_cmn()
    mutex_lock(&conn->c_cm_lock);
    case RDMA_CM_EVENT_ESTABLISHED:
        trans->cm_connect_complete(conn, event);   /* rds_ib_cm_connect_complete() */
            rds_conn_destroy(conn)
                rds_conn_path_quiesce()
                    rds_conn_path_drop(cp, true);  /* forces RDS_CONN_ERROR, queues cp_down_w */
                    flush_work(&cp->cp_down_w);
                        rds_shutdown_worker() -> rds_conn_shutdown()
                            mutex_lock(&cp->cp_cm_lock);   /* held by the flushing thread */

Since c_cm_lock is c_path[0].cp_cm_lock, does the flush_work() in
rds_conn_path_quiesce() wait for a shutdown worker that blocks on the
mutex the same thread is holding?  rds_conn_shutdown() cannot take the
RDS_CONN_DOWN -> RDS_CONN_DOWN shortcut here because
rds_conn_path_drop(cp, true) has just set the state to RDS_CONN_ERROR.

The version bytes come from the peer's CM private data, so a remote
endpoint advertising a version below 3.1 (and different from the compat
version) selects this branch.  Would that hang the RDMA-CM event thread
with c_cm_lock held, leave the connection unfreed, and make rds_ib
unload block in rds_conn_wait_conns_freed()?

If the referenced commit is a prerequisite that is not part of this
posting, could the ordering be stated, or could the destroy-from-callback
site be converted in this series?

> diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
> index 98f34b494237a..0199560488738 100644
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
This isn't a bug, but the out: block a bit further down in the same
function still points at this change as future work:

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

This commit is that following patch, and it does not give cm_id->context
a reference of its own - rds_rdma_cm_event_handler_cmn() takes a
per-event reference and drops it at out:.  Could that comment be updated
to describe the per-event pinning?  It is unchanged at the end of the
series.

> diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
> index b15cf316b23a2..584e9867810f4 100644
> --- a/net/rds/rdma_transport.c
> +++ b/net/rds/rdma_transport.c
> @@ -63,6 +63,18 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
>  	if (cm_id->device->node_type == RDMA_NODE_IB_CA)
>  		trans = &rds_ib_transport;

[Severity: High]
This isn't a bug introduced by this patch - it reads the same way in the
baseline - but while we are in rds_rdma_cm_event_handler_cmn(): can trans
be used uninitialized here?  It is declared as

	struct rds_transport *trans;

with no initializer, assigned only for RDMA_NODE_IB_CA, and the
CONNECT_REQUEST arm dereferences it unconditionally:

	case RDMA_CM_EVENT_CONNECT_REQUEST:
		ret = trans->cm_handle_connect(cm_id, event, isv6);

The listener is created without a node-type restriction -
rds_rdma_listen_init_common() calls

	cm_id = rdma_create_id(&init_net, handler, NULL,
			       RDMA_PS_TCP, IB_QPT_RC);

and RDS never calls rdma_restrict_node_type(), so id_priv->
restricted_node_type stays RDMA_NODE_UNSPECIFIED and cma_listen_on_dev()
installs the listener on iWARP devices too.  An incoming iWARP request
then goes:

iw_conn_req_handler()          /* event.event = RDMA_CM_EVENT_CONNECT_REQUEST */
    cma_listen_handler()
        rds_rdma_cm_event_handler()
            rds_rdma_cm_event_handler_cmn()

with cm_id->device->node_type == RDMA_NODE_RNIC and cm_id->context NULL,
so the assignment above is skipped, conn stays NULL (the new
rds_conn_get_unless_zero() branch and the c_cm_lock block are both
skipped), and the indirect call goes through an uninitialized stack
value.  The other two arms happen to be guarded by conn.

Would an explicit else that rejects non-IB node types, or initialising
trans to NULL plus a check, be worth adding while this function is being
touched?

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

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260917073958.174056-1-achender%40kernel.org
