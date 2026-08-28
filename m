Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0B13AFAFA;
	Fri, 28 Aug 2026 22:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787956766; cv=none; b=EPBGF5HVqlIv8UAjAia0MjzVUP8DLP/7jPA3ocYusw/11NIKcctG9tfNQmX3xwu0x/w8El5rnh7kYTelZtRSH68dSxjBYyfiZ5ETIfke5FX8RKgVMQddLmbjE1JWP/xQHXL9oTQxgSQKL+ZXiYJ0t3z32cMBz5Kw4KhRLk/bIZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787956766; c=relaxed/simple;
	bh=JWow+X7XZbJlkcdZ4rjo0435zwLCGIjNZGnKXhPQFWE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CZtG2pJs167bPRdkQR71d/cInqvWaOALBv25qESS+Kjjgg6rslELpbXpEzvQfm9pmaPmVwJH04VNK6k9JpF6vGSGDPRlmoxqcI/V+/o6N5BcMxLTUoyfvKiTFHuvwuVHgMb0IAd2ZTQP7hCUxWJpwxtpIPPJ50uIp4dCr3MAi0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JsOYMSmi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JsOYMSmi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1271F00A3D;
	Fri, 28 Aug 2026 22:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787956765;
	bh=qDQkQtA81QPT6O/t1ICuHO2xpONrPRy53UchPq5Tdu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JsOYMSmiLrdLRTRaNco3ELY0XGmYvIXWpBh9USU6sVCKS3kxcObfGW09cw2NwBo7A
	 zd3faqqzLk3LHP7cHOWSyVLp3ApzW8JU7t7Ny4JNzDT+8JS2lJG4qPHZAhUHAhkJl6
	 CpBtY6B9BBQY5v8KisUzUB2kE5gFN7rhfqecrdhQ2e5H6kd5exIG02HKttjN0aT63M
	 u68DqrjEPgtp/GcKTykgZJWOtic56Ebb9fCAvdseZsy6yKZKArzIfOFNWTW1RHBesp
	 iilCQk5bJbdoTysoTxfmCJ2fKpN5nNrkYRlvD/cWrwd+HEeVCmrP2hDIWB/EQw/ikv
	 PSnCoL6G/rd6A==
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
Subject: [PATCH net v5 4/7] net/rds: tcp: don't force RDS_CONN_RESETTING over a concurrent shutdown
Date: Fri, 28 Aug 2026 15:39:18 -0700
Message-Id: <20260828223921.202913-5-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260828223921.202913-1-achender@kernel.org>
References: <20260828223921.202913-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gerd Rausch <gerd.rausch@oracle.com>

rds_tcp_reset_callbacks() resolves a duelling SYN by storing
RDS_CONN_RESETTING into cp_state unconditionally.  Nothing serializes
that store against the shutdown path: rds_tcp_accept_one() checks
for RDS_CONN_CONNECTING or RDS_CONN_ERROR under t_conn_path_lock, but
neither rds_conn_path_drop(), which forces RDS_CONN_ERROR, nor
rds_conn_shutdown(), which moves the path to RDS_CONN_DISCONNECTING
under cp_cm_lock, takes that lock.  The store can therefore land on
top of a shutdown that is already in progress, or that gets queued
right after the accept-side check.

When it does, the shutdown worker's final DISCONNECTING -> DOWN
transition fails and the path goes through rds_conn_path_error() and
a second drop/shutdown cycle instead of a clean reconnect, tearing
down the socket the accept path has just installed.  Before commit
ad22d24be635 ("net/rds: No shortcut out of RDS_CONN_ERROR") a path
found in RDS_CONN_RESETTING even made rds_conn_shutdown() bail out
altogether.

Make the transition conditional: move CONNECTING -> RESETTING (or
stay in RESETTING from an earlier duel), and drop the path in any
other state.  The drop has side effects of its own: it replaces the
shutdown's RDS_CONN_DISCONNECTING (or RDS_CONN_ERROR) with
RDS_CONN_ERROR and queues one more cp_down_w run.  The difference is
that rds_conn_shutdown() accepts RDS_CONN_ERROR in its final
transition to RDS_CONN_DOWN, so the shutdown in flight completes
normally instead of through rds_conn_path_error(); the extra
down-work pass then finds the path already down and falls through to
the reconnect check, or catches a reconnect that has already started
and restarts it.  The accept path still installs the new socket,
rds_connect_path_complete() then fails its RESETTING -> UP transition
and drops it: the raced socket ends up torn down as it does today.
The comment at that call site, which promised that
rds_connect_path_complete() marks the path RDS_CONN_UP, is updated to
name this outcome as well.

The state can change again between the failed transitions and the
drop.  That is inherent to rds_conn_path_drop(), which the socket
state-change callbacks also call unconditionally, and costs at most
one extra drop/reconnect cycle.

Based on Oracle UEK commit "net/rds: Don't force state
RDS_CONN_RESETTING" by Gerd Rausch.

Fixes: 9c79440e2c5e ("RDS: TCP: fix race windows in send-path quiescence by rds_tcp_accept_one()")
Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
[achender: port to net-next: use the two-argument
 rds_conn_path_transition()/rds_conn_path_drop() and rewrite the
 changelog for the upstream shutdown path]
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
    v5: the rds_tcp_accept_one() call-site comment no longer promises
    an unconditional transition to RDS_CONN_UP.  No other change.
 net/rds/tcp.c        | 17 +++++++++++++++--
 net/rds/tcp_listen.c |  6 +++++-
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index b263634ac750..ad14217867a4 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -150,9 +150,22 @@ void rds_tcp_reset_callbacks(struct socket *sock,
 	 * end up deadlocking with tcp_sendmsg(), and the RDS_IN_XMIT
 	 * would not get set. As a result, we set c_state to
 	 * RDS_CONN_RESETTTING, to ensure that rds_tcp_state_change
-	 * cannot mark rds_conn_path_up() in the window before lock_sock()
+	 * cannot mark rds_conn_path_up() in the window before lock_sock().
+	 *
+	 * Only make that transition if the path is still connecting
+	 * (or already resetting from an earlier duel).  A path in any
+	 * other state - typically RDS_CONN_DISCONNECTING or
+	 * RDS_CONN_ERROR with a shutdown in flight - is dropped
+	 * instead.  That still replaces its state, with RDS_CONN_ERROR,
+	 * and queues one more shutdown pass, but rds_conn_shutdown()
+	 * accepts RDS_CONN_ERROR in its final transition to
+	 * RDS_CONN_DOWN, so the shutdown in flight completes normally.
 	 */
-	atomic_set(&cp->cp_state, RDS_CONN_RESETTING);
+	if (!rds_conn_path_transition(cp, RDS_CONN_CONNECTING,
+				      RDS_CONN_RESETTING) &&
+	    !rds_conn_path_transition(cp, RDS_CONN_RESETTING,
+				      RDS_CONN_RESETTING))
+		rds_conn_path_drop(cp, 0);
 	wait_event(cp->cp_waitq, !test_bit(RDS_IN_XMIT, &cp->cp_flags));
 	/* reset receive side state for rds_tcp_data_recv() for osock  */
 	cancel_delayed_work_sync(&cp->cp_send_w);
diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index a3db9b057084..13fa60c1985b 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -295,7 +295,11 @@ int rds_tcp_accept_one(struct rds_tcp_net *rtn)
 	if (rs_tcp->t_sock) {
 		/* Duelling SYN has been handled in rds_tcp_accept_one() */
 		rds_tcp_reset_callbacks(new_sock, cp);
-		/* rds_connect_path_complete() marks RDS_CONN_UP */
+		/* rds_connect_path_complete() marks RDS_CONN_UP, or,
+		 * if a concurrent shutdown won the duel, drops the
+		 * path again and the pass that drop queues reaps the
+		 * socket installed above.
+		 */
 		rds_connect_path_complete(cp, RDS_CONN_RESETTING);
 	} else {
 		rds_tcp_set_callbacks(new_sock, cp);
-- 
2.25.1

