Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBB42DAFA9;
	Mon, 24 Aug 2026 00:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787531886; cv=none; b=pDSpmBuKkOfCgkfPmjUi39YXJwHXWV3hVev4mxL2gjoe0X0x4UXPAqsxuPX5Esq+5NsUivo0IqXmKlEWM7n4i6uJ0puudqnLi8am5Yf/nrHi7VaS3zB9FSD+BVAeesJRr7PElkoX3JVCjyZU2F7YY0zKVZERYsnh1xuLNxL4gL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787531886; c=relaxed/simple;
	bh=aINowWQGAPvtz2Wb9BrHk1q9bE/1pfj7PJiDGq2XkHw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fjYc1k2gJHKFNwbbmCDizrqp8tNldqXWLolXr7EhpfjcTuFR9+A45NV7Ay4WTOUETFHZwXESXX/Ne/T5/WsOSK8dslF8sF35dx94FVKkH8RrzxjclEiMJll5f1cDDExCyUNwxGem8aXgMepGTlnkBlAFcpZD4FQzmL6rXh8Ac5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Agn+OzmR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Agn+OzmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58D11F00A3E;
	Mon, 24 Aug 2026 00:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787531885;
	bh=1M97PmC9+IvGsBNOuHndCiPQIrZtrz4qe9sa/r9GmDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Agn+OzmRqMst+Z2CPUrfaV75g+hxvOXpmRFff9dDAfKAe3HIOHUrtEbKfrou0P8gO
	 akGWosZOagkVTHGHt5u/C4Xrkjg6EA8AAVHCid2UZSzZe7fKTdBZ/LwSyeGKC5HaIy
	 7Q2r7Yp+GwZqkin2hichUhjYAwd6J6U22WheQa0wCh+rNbW9iO3VItyixlt9xdj3bX
	 tl/cap1HQcjIer0pIGIhgSh6hrrG9oWLD5X06jL2C8PPZRZOnU0T2AAMy2ONxmwfNS
	 pCESxXWt6FKIYrNeMOC+KvfR7NhfEcao7YGreIZuDaI3yQRFRj19/QRhSlioJE1j+h
	 zcwaP6RYs86lA==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	jhubbard@nvidia.com,
	woni9911@gmail.com,
	michal.kubiak@intel.com,
	leon@kernel.org
Subject: [PATCH net v4 7/7] net/rds: don't let rds_conn_shutdown() consume a concurrent drop
Date: Sun, 23 Aug 2026 17:37:59 -0700
Message-Id: <20260824003759.127353-8-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260824003759.127353-1-achender@kernel.org>
References: <20260824003759.127353-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rds_conn_shutdown() finishes by moving the path from
RDS_CONN_DISCONNECTING to RDS_CONN_DOWN, and also accepts
RDS_CONN_ERROR as the starting state of that final transition, so that
a FIN processed in softirq context during the teardown does not derail
the shutdown into a noisy error path.

But consuming that RDS_CONN_ERROR also consumes the shutdown pass that
came with it: rds_conn_path_drop() sets RDS_CONN_ERROR and then queues
cp_down_w, and a pass that starts on a path already in RDS_CONN_DOWN
is a no-op.  For the FIN case that is harmless - the socket the FIN
arrived on is the very socket the teardown just released.  It is not
harmless for a dropper that attached something to the path first.

rds_tcp_accept_one() is such a dropper.  Its path claim in
rds_tcp_accept_one_path() transitions RDS_CONN_DOWN ->
RDS_CONN_CONNECTING, and a concurrent drop - a FIN on a previous
socket in softirq context, an administrative reset - can put the path
into RDS_CONN_ERROR between that claim and the state check that
follows, which accepts RDS_CONN_ERROR.  The accept then installs the
freshly accepted socket with rds_tcp_set_callbacks() while the queued
teardown - which sampled tc->t_sock before this socket existed - is
still running.  rds_connect_path_complete() fails its transition to
RDS_CONN_UP and drops the path again, queueing the pass that should
reap the socket it just installed.  If the in-flight shutdown's final
transition consumes that drop's RDS_CONN_ERROR, the queued pass finds
the path in RDS_CONN_DOWN and does nothing.  The installed socket is
never torn down: it sits established with its callbacks armed and its
rds_tcp_connection on rds_tcp_tc_list, the peer sees a connection that
nothing ever reads, and the path is wedged in RDS_CONN_DOWN until some
later event drops it again.  Reproduced with widened race windows as
an ever-growing receive queue on a socket owned by a path stuck in
RDS_CONN_DOWN, with the peer's send path wedged behind it.

Make the final transition only DISCONNECTING -> DOWN.  If it fails
because the path is in RDS_CONN_ERROR, a drop raced the teardown:
return quietly and let the pass that drop queued finish the job - it
tears down whatever attached to the path in the meantime, completes
the transition to RDS_CONN_DOWN, and handles the reconnect.  If no
pass was queued because a destroy is pending, rds_conn_path_destroy()
performs the final drop and flush itself.  The FIN case keeps making
progress, one pass later and still without noisy logging; any other
unexpected state keeps today's rds_conn_path_error() handling.

On kernels without the preceding patches the same hazard exists with
the sample-based quiesce; the fix applies there equally.

Fixes: e97656d03ca0 ("rds: tcp: allow progress of rds_conn_shutdown if the rds_connection is marked ERROR by an intervening FIN")
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
    New in v4.  Fixes the accept-vs-drop socket leak found while
    re-reviewing patch 6.
 net/rds/connection.c | 29 ++++++++++++++++++-----------
 net/rds/tcp.c        |  9 ++++++---
 2 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index fbbac55a0e81..73b4fa8a4b96 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -447,20 +447,27 @@ void rds_conn_shutdown(struct rds_conn_path *cp)
 		wake_up_all(&cp->cp_waitq);
 
 		if (!rds_conn_path_transition(cp, RDS_CONN_DISCONNECTING,
-					      RDS_CONN_DOWN) &&
-		    !rds_conn_path_transition(cp, RDS_CONN_ERROR,
 					      RDS_CONN_DOWN)) {
-			/* This can happen - eg when we're in the middle of tearing
-			 * down the connection, and someone unloads the rds module.
-			 * Quite reproducible with loopback connections.
-			 * Mostly harmless.
+			/* The path was dropped again while we tore it
+			 * down: by a socket state-change callback in
+			 * irq context on receipt of a FIN, or by an
+			 * accept that claimed the path just before a
+			 * drop put it back to RDS_CONN_ERROR and then
+			 * installed a fresh socket on it.  The drop
+			 * queued another shutdown pass, and that pass
+			 * must run, because it is what tears down
+			 * whatever attached to the path after the
+			 * transport shutdown above sampled its state.
+			 * Consuming the RDS_CONN_ERROR here would turn
+			 * that pass into a no-op: leave the state
+			 * alone, and let the pass finish the job.
 			 *
-			 * Note that this also happens with rds-tcp because
-			 * we could have triggered rds_conn_path_drop in irq
-			 * mode from rds_tcp_state change on the receipt of
-			 * a FIN, thus we need to recheck for RDS_CONN_ERROR
-			 * here.
+			 * Anything else - e.g. a module unload pulling
+			 * the connection down mid-teardown - keeps the
+			 * usual noisy drop.
 			 */
+			if (rds_conn_path_state(cp) == RDS_CONN_ERROR)
+				return;
 			rds_conn_path_error(cp, "%s: failed to transition "
 					    "to state DOWN, current state "
 					    "is %d\n", __func__,
diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 826e620b2dd1..50c2f0b3a038 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -165,9 +165,12 @@ void rds_tcp_reset_callbacks(struct socket *sock,
 	 * other state - typically RDS_CONN_DISCONNECTING or
 	 * RDS_CONN_ERROR with a shutdown in flight - is dropped
 	 * instead.  That still replaces its state, with RDS_CONN_ERROR,
-	 * and queues one more shutdown pass, but rds_conn_shutdown()
-	 * accepts RDS_CONN_ERROR in its final transition to
-	 * RDS_CONN_DOWN, so the shutdown in flight completes normally.
+	 * and, unless a pending destroy is about to reap the whole
+	 * connection anyway, queues one more shutdown pass.  A shutdown
+	 * already in flight leaves that RDS_CONN_ERROR alone when it
+	 * finishes; the queued pass then completes the transition to
+	 * RDS_CONN_DOWN and tears down anything that attached to the
+	 * path in the meantime.
 	 */
 	if (!rds_conn_path_transition(cp, RDS_CONN_CONNECTING,
 				      RDS_CONN_RESETTING) &&
-- 
2.25.1

