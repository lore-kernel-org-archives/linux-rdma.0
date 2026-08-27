Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6033E453A5D;
	Thu, 27 Aug 2026 18:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787853743; cv=none; b=FAgQSkW18KGTPcB7UUKjj9C0ag6U4Zhp5mxWUQQtQ/BHprjwtq6SQCdFmsbEbBz6shm4uWdzTqENEJC6fgI0MpAy04KjyWlSHndTPtGT1ecyNo2zFWHMavk0DFDFgn7LFIFFnrPUltrgBWEfio/8EGi3/NHWe/bmbiGPD6Ggk6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787853743; c=relaxed/simple;
	bh=EA9fHgAacp2OGVTKdqaWSzlD2XLgEc3u9038YsG/ikA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7Z1K7vhw5yLNuZmnHWsSquZEPWR9zAd/AHcEjNQxLnzh8LIXGAUM7AiI5u3EuS7fjDDwWYL1sM6kHbQzCKwOImGnLV3wtB7SEyEVHagIWtmRirheJ/E2fDwO06Vki+Nz5bfGSmjmeKrle/wf2NKUVCHPQxFDuF588wChGtKvxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gdQ1QAsj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gdQ1QAsj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B467A1F000E9;
	Thu, 27 Aug 2026 18:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787853742;
	bh=MpLVn7VocU1Nx+IcP+qRzxZ/b4UpnNhIwozYkQBUv3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gdQ1QAsjQ5sG9AOBTEPLKnuPoQnnRSyKiFTcuF7uJRonKfzT1HOk05piiszKbXC7D
	 Vm/rtUDM7ff+ytuZmQ/6rM3XsbkbNtVt3JYjKA9/gVdfpwnd3GVisBxz7C99XstVsA
	 2jOGN7f/rf90eQphJDdBztFE2zEvXsGNJlK4Ye8Z2drbzn52DV5+ps9/3Yo1n5cO4K
	 +0rNa/8n1xoUKtd/XoehpJHhty9whi9bMcCcYmM7wQ32Gdc/xbDfUKDfiIgz6qgWyU
	 C4NuYcXcgAvjCujgKq8dSCbhPe+wtdTVpbQANO/PzTpaAzluaHJ6KTXx80SQDLznj/
	 M69jr1+aHeimA==
From: Jakub Kicinski <kuba@kernel.org>
To: achender@kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	jhubbard@nvidia.com,
	woni9911@gmail.com,
	michal.kubiak@intel.com,
	leon@kernel.org
Subject: Re: [PATCH net v4 7/7] net/rds: don't let rds_conn_shutdown() consume a concurrent drop
Date: Thu, 27 Aug 2026 11:02:21 -0700
Message-ID: <20260827180221.3951040-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260824003759.127353-8-achender@kernel.org>
References: <20260824003759.127353-8-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
net/rds: don't let rds_conn_shutdown() consume a concurrent drop

This restricts the final state transition in rds_conn_shutdown() to
DISCONNECTING -> DOWN, and returns quietly when the path is found in
RDS_CONN_ERROR so that the shutdown pass queued by the racing drop is the
one that finishes the teardown.  The comments in rds_conn_shutdown() and
rds_tcp_reset_callbacks() are rewritten to describe the new rule.

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index fbbac55a0e818..73b4fa8a4b963 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c
> @@ -447,20 +447,27 @@ void rds_conn_shutdown(struct rds_conn_path *cp)
>  		wake_up_all(&cp->cp_waitq);
>  
>  		if (!rds_conn_path_transition(cp, RDS_CONN_DISCONNECTING,
> -					      RDS_CONN_DOWN) &&
> -		    !rds_conn_path_transition(cp, RDS_CONN_ERROR,
>  					      RDS_CONN_DOWN)) {
> -			/* This can happen - eg when we're in the middle of tearing
> -			 * down the connection, and someone unloads the rds module.
> -			 * Quite reproducible with loopback connections.
> -			 * Mostly harmless.
> +			/* The path was dropped again while we tore it
> +			 * down: by a socket state-change callback in
> +			 * irq context on receipt of a FIN, or by an
> +			 * accept that claimed the path just before a
> +			 * drop put it back to RDS_CONN_ERROR and then
> +			 * installed a fresh socket on it.  The drop
> +			 * queued another shutdown pass, and that pass
> +			 * must run, because it is what tears down
> +			 * whatever attached to the path after the
> +			 * transport shutdown above sampled its state.
> +			 * Consuming the RDS_CONN_ERROR here would turn
> +			 * that pass into a no-op: leave the state
> +			 * alone, and let the pass finish the job.
>  			 *
> -			 * Note that this also happens with rds-tcp because
> -			 * we could have triggered rds_conn_path_drop in irq
> -			 * mode from rds_tcp_state change on the receipt of
> -			 * a FIN, thus we need to recheck for RDS_CONN_ERROR
> -			 * here.
> +			 * Anything else - e.g. a module unload pulling
> +			 * the connection down mid-teardown - keeps the
> +			 * usual noisy drop.
>  			 */
> +			if (rds_conn_path_state(cp) == RDS_CONN_ERROR)
> +				return;

[Severity: High]
The new return does not just skip the reconnect - it leaves
rds_conn_shutdown() before its whole tail, which is also where
cancel_delayed_work_sync(&cp->cp_conn_w) runs, where
RDS_RECONNECT_PENDING is cleared, and where conn_slots_available()
is called.  Who performs that work when this return fires?

For the ordinary case the changelog's answer holds: the pass that the
racing rds_conn_path_drop() queued runs later and reaches the tail.
But the drop does not always queue a pass.  rds_conn_path_drop(cp,
false) stores RDS_CONN_ERROR unconditionally and only then checks
rds_destroy_pending(cp->cp_conn), returning without queue_work() when
a destroy is in progress - which is precisely the qualification the
new rds_tcp_reset_callbacks() comment in this patch spells out, and
which the changelog answers with "rds_conn_path_destroy() performs the
final drop and flush itself".

That answer looks one pass short.  rds_conn_path_destroy() does a
single rds_conn_path_drop(cp, true) followed by
flush_work(&cp->cp_down_w).  If the flushed pass is the one that a
concurrent FIN turns into this silent return - rds_tcp_state_change()
-> rds_conn_path_drop(cp, false) during the conn_path_shutdown() and
quiesce window, destroy pending, so RDS_CONN_ERROR is stored and no
cp_down_w is queued - then no pass ever reaches the tail, and there is
nothing left to flush.  rds_conn_path_destroy() continues into

	WARN_ON(delayed_work_pending(&cp->cp_conn_w));

and then frees the transport data and the path with cp_conn_w still
armed.  The WARN_ON is itself the evidence that destroy relies on
rds_conn_shutdown() having cancelled that work; if a cp_conn_w queued
by an earlier rds_queue_reconnect() has not yet expired, its timer
fires on a freed rds_conn_path.  Before this patch the ERROR -> DOWN
leg of the final transition kept the tail reachable in exactly this
situation, so the cancel always ran.

So two questions.  Should the RDS_CONN_ERROR return be placed after
cancel_delayed_work_sync(&cp->cp_conn_w) (and after the
RDS_RECONNECT_PENDING clear), so the path's timers are quiesced no
matter which pass completes the state transition?  Or should
rds_conn_path_destroy() stop depending on the shutdown pass and cancel
cp_conn_w itself before the WARN_ONs?  Either way, the destroy-pending
case deserves a comment here, because that is the one case where the
"let the pass finish the job" argument has no pass to lean on.

[Severity: Medium]
Does the new comment in rds_conn_shutdown() match the code below it?

It says a module unload "keeps the usual noisy drop", but the unload path
goes through rds_conn_destroy() -> rds_conn_path_destroy() ->
rds_conn_path_drop(cp, true), and rds_conn_path_drop() starts with an
unconditional state store:

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

So an unload racing an in-flight shutdown leaves the path in
RDS_CONN_ERROR and takes the new silent return, not the
rds_conn_path_error() branch the comment points at.  The old comment that
documented exactly that case ("someone unloads the rds module ... Mostly
harmless") is removed in the same hunk, so is the unload scenario now
described against the wrong branch?

Second question on the same comment: it states flatly that "The drop
queued another shutdown pass".  In the snippet above, a
rds_conn_path_drop(cp, false) returns before queue_work() when
rds_destroy_pending() is true:

net/rds/rds.h:rds_destroy_pending() {
	return !check_net(rds_conn_net(conn)) ||
	       (conn->c_trans->t_unloading && conn->c_trans->t_unloading(conn));
}

The comment this patch adds to rds_tcp_reset_callbacks() carries that
qualification:

	 * and, unless a pending destroy is about to reap the whole
	 * connection anyway, queues one more shutdown pass.

Should the connection.c comment carry the same "unless a destroy is
pending" wording so the two new comments agree?

Last question: which state actually reaches rds_conn_path_error() here?
Every other writer of cp_state uses a cmpxchg from a non-DISCONNECTING
state - rds_connect_path_complete() from CONNECTING/RESETTING,
rds_tcp_reset_callbacks() from CONNECTING/RESETTING, rds_connect_worker()
from DOWN - and the only unconditional store is the RDS_CONN_ERROR in
rds_conn_path_drop().  If nothing can leave a DISCONNECTING path in a
state other than RDS_CONN_ERROR, is the noisy branch the comment
illustrates reachable at all?

> +			rds_conn_path_error(cp, "%s: failed to transition "
>  					    "to state DOWN, current state "
>  					    "is %d\n", __func__,

[ ... ]
