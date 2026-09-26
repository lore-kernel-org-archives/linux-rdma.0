Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD223DC4D8;
	Sat, 26 Sep 2026 09:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790416125; cv=none; b=uX/7V+y4fqPR87EFwlj15UM+HBNqQsB+vWtNf4WaCNAdIJlzziiwEoh6l5UP8+E0eAR4Iod05Qsj8ZxR/GnARSQ4TGoxisqkoQERj/LhMG4E9IUSub81o3J0c+NIcghguf+Cig5sj+rE5G456ii4QhWkMLUMVyPDOu00fVAsO9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790416125; c=relaxed/simple;
	bh=ib6C+2kiqr9G7O6UIelYWqw0zDGmVUVXObD30EgxZsQ=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cb8ldIyKtJIcsyf4KfIAPH/L8qBNYe4jM2eqOdl96BHIDTQoEVUkKyZn/9hDW6mtOEJL6XIuGFJ9D9N3XNGBx4v8ozQkje1ssoZI7AZK+ZUGMeSofirQXIvOPGwwHd/rlxE6DYdTkbkjyhtek90b6XhWG4svThDsA7h+2OyJw/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QKptug9M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QKptug9M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046D51F00899;
	Sat, 26 Sep 2026 09:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790416124;
	bh=/NwQqu0ZnX0p+cF0oqbCoylIIsiutyI3ZggTkHHqNO0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=QKptug9MMuEDrOGpKARoIyuadMT8LtpHay2Lw75Xgulvf7pM5m9jpoCALmjxCuOP2
	 Le+4ahj/dWoHdunQG+SrpIahxcR0yQt8UC2S6V+NA4CsCf1dpLRo7LqpiRs67Or+EV
	 buNxathU9ZUvWsTQFc1QVWWc+WdNUr3ZkSwpMr2QRIYF7tI/S0Cthmap2wz66XLo8C
	 Qsz7dlh6bPsUK39qTVhIrXt519daU4M9mdsoFtEXYybDfqPo0YB5XRi7lisoMwVgbK
	 iC/ygnhoql7n3S5nBudhmcPLXg6mRD9uo8xGYydecUmY7u3jpQMICNYRAB9DtOM8zV
	 D5ic7zsSfR0eQ==
Subject: Re: [PATCH net-next v6 10/12] net/rds: pin the connection across
 RDMA-CM event handling
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Sat, 26 Sep 2026 09:48:43 +0000
Message-ID: <179041612353.2160803.17928939603104539719@kernel.org>
In-Reply-To: <20260922085410.391323-11-achender@kernel.org>
References: <20260922085410.391323-11-achender@kernel.org>
X-sashiko-severity: Medium
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

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The rationale attached to the new reference pin in
  rds_rdma_cm_event_handler_cmn() (net/rds/rdma_transport.c:66-72) and…

--

net/rds: pin the connection across RDMA-CM event handling

This takes a reference on the connection found via cm_id->context for the
duration of rds_rdma_cm_event_handler_cmn(), ignoring the event if the
connection is already being freed, and re-checks rds_destroy_pending()
under c_cm_lock in rds_ib_cm_handle_connect() so a connect request cannot
install a new cm_id and QP on a connection that is only waiting for its
last reference.

> diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
> index 786ddcb45bcbf..1b5491598433b 100644
> --- a/net/rds/ib_cm.c
> +++ b/net/rds/ib_cm.c

[ ... ]

> @@ -928,8 +935,8 @@ int rds_ib_cm_handle_connect(struct rdma_cm_id *cm_id,
>  		mutex_unlock(&conn->c_cm_lock);
>  		/* Drop the reference rds_conn_create() handed us.  The
>  		 * conn stays reachable through cm_id->context without a
> -		 * reference of its own for now; the CM event handler is
> -		 * given one of its own by a following patch.
> +		 * reference of its own; rds_rdma_cm_event_handler_cmn()
> +		 * takes one for the duration of each event it handles.
>  		 */
>  		rds_conn_put(conn);
>  	}
> diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
> index b15cf316b23a2..584e9867810f4 100644
> --- a/net/rds/rdma_transport.c
> +++ b/net/rds/rdma_transport.c
> @@ -63,6 +63,18 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
>  	if (cm_id->device->node_type == RDMA_NODE_IB_CA)
>  		trans = &rds_ib_transport;
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

[Severity: Medium]

The get_unless_zero/put pair itself looks balanced, but is the stated
reason for it accurate?  The comment says "what the callbacks below do may
drop the last reference other than ours", and the changelog says the same:

    Now that a connection is freed by its last reference, the remaining
    exposure is a callback that drops the last reference other than the
    handler's

Walking the callbacks dispatched from the switch below, none of them puts
a reference on the connection the handler just pinned.

cm_connect_complete -> rds_ib_cm_connect_complete() only drops the
connection on a version mismatch, and after commit f97d8c7bab78 that is
rds_conn_drop(), which takes no reference action:

net/rds/connection.c:rds_conn_path_drop() {
	atomic_set(&cp->cp_state, RDS_CONN_ERROR);

	rcu_read_lock();
	if (!destroy && rds_destroy_pending(cp->cp_conn)) {
		rcu_read_unlock();
		return;
	}
	queue_work(cp->cp_wq, &cp->cp_down_w);
	rcu_read_unlock();
}

cm_initiate_connect -> rds_ib_cm_initiate_connect() contains no put, and
the remaining switch arms only call rds_conn_drop().

cm_handle_connect -> rds_ib_cm_handle_connect() does call rds_conn_put(),
but that releases the reference rds_conn_create() handed to that same
function, and it runs after its own mutex_unlock(&conn->c_cm_lock).  On
RDMA_CM_EVENT_CONNECT_REQUEST the handler's conn is NULL anyway, since the
listener cm_id is created with a NULL context:

net/rds/rdma_transport.c:rds_rdma_listen() {
	cm_id = rdma_create_id(&init_net, handler, NULL,
			       RDMA_PS_TCP, IB_QPT_RC);
}

which is what BUG_ON(cm_id->context) in rds_ib_cm_handle_connect()
asserts, so nothing was pinned on that path.

That leaves holders outside the handler as the ones that can reach zero
concurrently - rds_conn_destroy() dropping the initial reference, a socket
dropping rs_conn, a c_passive drop, or an inc drop - which is a different
invariant than the one written down.  Could the comment and the changelog
name the holder that can actually race here, or say plainly that the pin
is defensive?  As written, a later reader auditing the callbacks will find
no put and may conclude the pin is dead code, and the same wording is what
a backporter would use to decide whether this is a fix or hardening.

I also checked the end of the series (fe1de9d527be84f2ab7fed636cc4915635b09f0d)
and the comment is unchanged there, so no later patch adjusts it.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260922085410.391323-1-achender%40kernel.org
