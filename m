Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA203C9891;
	Sun,  4 Oct 2026 16:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791131706; cv=none; b=CTdirPeUXV82UkizMXI5B2u2H3OsLON/1Gl1AlUdYtQLScZXB9PqYrvSmFaPFYUVsNzv6m5nn0RgEO5AQlWdzoubnIEi1OooWUndoLYB7cDCMY31fIgDTw6S7yfvsxaf32wEVDGwuJ5zWGMdI8x9fypTVRX0HRKEbYCOSDSFXAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791131706; c=relaxed/simple;
	bh=Lm7sGLnX4QMUbEw+a54w7AGBJFi2lzqeZU43AGDZ+EI=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TFApaealOmmpcvn5FYeBkwP8+6ZOoCgyutNQKHKVkD9oRrbEnuJWAQ/S28rFYZf8NeYhyJrghk4XFlXujz+cJ0Qi7fS9WG7uxLkp2NIwDIntehGoOIcwDhezsSDZOVs+zCAyzDJMMBcYudQtk5ZI7CilT62kIaO2wsNYE9OrbnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NGfxOx7r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NGfxOx7r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1015A1F00893;
	Sun,  4 Oct 2026 16:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791131705;
	bh=kjr9/0nKb1J6ihVqg9Ainpe2oMxh8KPtexF8CcgGBl8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=NGfxOx7rHK2h7s5GK8jKMSjk2a/Q14W2A1+/2HYsQJGBiPv+imdwO2HC+ZdA775L8
	 nHeDJ5PX8E9LLSKQ1g7k/kctzQjk3B39kWyPgZlX7LIM6zZF8opSNBcT9m8lMPbU+3
	 +mb8CJOOJlC//aduzSTpT3FzrcyQX3AXOufCo4kFIfk97pD4cy2nLvVHCvzgHx48de
	 5agfK0ErnmW+uPWSO0eqfi3ey+KQpICxR9V6IEwgxAmPvia+3M6BubJH9FioJ4A+6P
	 3BpW3Nf5oQEXN249XoOCJ1DgV+zKdV77iXcGzDl9TPVkssvrrUZfI6VxJh5YHt7sz7
	 cotX45w2NO9jw==
Subject: Re: [PATCH net-next v8 12/13] net/rds: pin the connection across
 RDMA-CM event handling
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Sun, 04 Oct 2026 16:35:04 +0000
Message-ID: <179113170465.434549.8485797174502943029@kernel.org>
In-Reply-To: <20261003163215.250253-13-achender@kernel.org>
References: <20261003163215.250253-13-achender@kernel.org>
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

- [Medium] The commit message and the new comment in
  rds_ib_cm_initiate_connect() (net/rds/ib_cm.c) describe a resource…

--

net/rds: pin the connection across RDMA-CM event handling

This patch makes rds_rdma_cm_event_handler_cmn() take a reference on the
connection for the duration of each RDMA-CM event. It also adds
rds_destroy_pending() checks to rds_ib_cm_initiate_connect() and
rds_ib_cm_handle_connect(), so a connection that is being destroyed does
not get a new QP or cm_id set up.

> diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
> index 165a29d4196e8..6307c88c31431 100644
> --- a/net/rds/ib_cm.c
> +++ b/net/rds/ib_cm.c
> @@ -876,6 +876,13 @@ int rds_ib_cm_handle_connect(struct rdma_cm_id *cm_id,
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

[ ... ]

> @@ -950,6 +957,17 @@ int rds_ib_cm_initiate_connect(struct rdma_cm_id *cm_id, bool isv6)
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
> +

[Severity: Medium]
Can the leak described in this comment and in the commit message actually
happen? The commit message says:

  "a connection whose destroy began while its address and route were
  resolving reaches RDMA_CM_EVENT_ROUTE_RESOLVED and sets up a QP -
  taking a device reference in rds_ib_add_conn() - after the destroy's
  shutdown pass has run, or with that pass waiting on c_cm_lock behind
  the handler.  Nothing would ever release the QP, the cm_id or the
  device reference, and rds_ib_exit() would wait forever for the
  device."

First, the case where the shutdown pass is waiting on c_cm_lock. The
quiesce calls rds_conn_path_drop(cp, true), which sets RDS_CONN_ERROR and
queues cp_down_w. Nothing in the ROUTE_RESOLVED path moves the state away
from ERROR.

Once the handler releases c_cm_lock, rds_conn_shutdown() moves ERROR to
DISCONNECTING and calls rds_ib_conn_path_shutdown(). Because ic->i_cm_id
is set, that function already tears everything down:

rds_ib_conn_path_shutdown() {
    ...
		rdma_destroy_id(ic->i_cm_id);
    ...
		if (ic->rds_ibdev)
			rds_ib_remove_conn(ic->rds_ibdev, conn);

		ic->i_cm_id = NULL;
    ...
}

So the QP, CQs, cm_id and device reference are all released, with or
without this patch.

Second, the case where the shutdown pass has already run. By then
ic->i_cm_id has been destroyed and cleared, and rdma_destroy_id() waits
for a running handler and blocks later callbacks on that id.

A ROUTE_RESOLVED event on some other id fails the ibic->i_cm_id == cm_id
test in rds_rdma_cm_event_handler_cmn() and only calls rds_conn_drop().
While the pass is running, the handler exits early on
RDS_CONN_DISCONNECTING. A conn that is unhashed and destroy-pending can't
be reconnected either.

Third, the device reference. IB conns are only destroyed from
rds_ib_destroy_nodev_conns(), which rds_ib_exit() calls after
rds_ib_unregister_client(). By that point rds_ib_dev_shutdown() has set
shutting_down on every device, and rds_ib_add_conn() bails out before it
takes the reference:

rds_ib_add_conn() {
    ...
	if (rds_ibdev->shutting_down) {
		ret = -ENODEV;
    ...
}

As far as I can tell, the new early return only fires when
rds_destroy_pending() is true through t_unloading (rds_ib_is_unloading())
before any destroy has started. Neither the comment nor the commit
message mentions that case, and the exit sweep would tear such a conn
down anyway.

Also, suppose the "already quiesced" case could be reached. Would
returning 0 here help? It would leave a cm_id whose context points at a
conn that is about to be freed, and rds_ib_conn_free() never destroys
ic->i_cm_id.

The check in rds_ib_cm_handle_connect() has the same problem. The commit
message calls it "the mirror-image hole", but rds_rdma_exit() stops the
listeners before rds_ib_exit() runs:

rds_rdma_exit() {
	rds_rdma_listen_stop();
	rds_ib_exit();
}

So the listeners are destroyed before the unloading flag is set or any
IB conn is destroyed. In addition, the lookup in rds_conn_create() can't
return a conn once rds_conn_destroy() has unhashed it under
rds_conn_lock.

Both checks look harmless. Could the commit message and these two
comments describe them as defensive, the way the handler pin is
described? Right now they read as fixes for a reachable QP/cm_id/device
reference leak and an rds_ib_exit() hang.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261003163215.250253-1-achender%40kernel.org
