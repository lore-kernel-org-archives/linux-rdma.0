Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3E7480947;
	Thu, 17 Sep 2026 07:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789630803; cv=none; b=S2KWTERTd1gDky8EslMU25e320/NPovBUhI/aQIjjMILtzVetQFLvgS1LSVBL4i5i0D0L1W6/WIKvKaP1WTt8GHfl/ACKUZcUDCy4GdzvOZOn7iBYzdxZjR/MfMcuRKr8JautglfrVYBVGDHRgwZgYsdaBMmrW9wd2hlfGLaZ4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789630803; c=relaxed/simple;
	bh=tV9l81hjJZs0+v+yO+86FH+Den+/5Uc+8opCnc1TbJs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=E/c2yZ7kr9fHM8uj9vH7bHWoKwkhP8kibrqL+iO4GBT0f7LzsJxr6J33wSmPbcEcnr5RLE07IP8Bcsw08cdNvD1RO/+5GJp/JKv5mI+UVoZ+jYl+UzRS4ADV5S1W0Cuawxm5kLacQd+BaejCWVVItmJgfma8VnPmx7C1NS3y5NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nDWpPJ5Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nDWpPJ5Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254FE1F00898;
	Thu, 17 Sep 2026 07:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789630801;
	bh=h8R9zPXbWyLxCMq5UOLua/R9DO0msPFNgUwwc9gg9j8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nDWpPJ5YLWM0IIodip76pXz5rHrvOKfEfib8u1mLdpy2lCP4xmwnetOQfdAGaUoAU
	 QSs60hqIGauQjttUhu//Julndw2I1jdR+fknulhzsTAsbddsXLqTmWt0MGNtAwOqDh
	 K4N0Xqy2jYM3CO9waPfbxLTRP6L9sAmMoUfUEKKBMj27uBN0YUVun7BGG9GpvELTPw
	 AFt2jOYa2WKpoG1fLkrB1gwyScx370EUKeUnV0Xnx4CNQe44417YhKduSaBR2S2jvZ
	 Kah1WgkzwR6o6vaSkpbeS1cufzzAcwumN9IFsD4cywX/QeH6SXtMwuid+ZKWfrY0wd
	 91/PwJ0o5R9/w==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	nicoyip.dev@gmail.com
Subject: [PATCH net-next v4 04/12] net/rds: make rds_destroy_pending() cover single-connection destroy
Date: Thu, 17 Sep 2026 00:39:50 -0700
Message-Id: <20260917073958.174056-5-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260917073958.174056-1-achender@kernel.org>
References: <20260917073958.174056-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rds_conn_destroy() cancels the path works and then destroys the
per-path workqueue.  However, nothing currently stops the
work-requeueing sites from queueing new work on the connection while
that happens.  The existing code would suggest that this protection
is supposed to come from rds_destroy_pending(), since all of those
sites - apart from the workers' own self-requeues, which the sync
cancel in the destroy path already rejects - guard the queueing with
rds_destroy_pending() under rcu_read_lock() (the last stragglers were
converted by the previous patch), and rds_conn_destroy() already issues a
synchronize_rcu() after unhashing the connection.  But the predicate
only tests for the two global teardown cases (netns destruction via
check_net(), module unload via ->t_unloading).  Because the conn
itself lacks any indication that a destroy is in progress, the
predicate does not cover the destruction of a single connection
outside these two cases.

rds_conn_destroy() is not limited to the global paths:
rds_ib_cm_connect_complete() destroys a single connection whose peer
negotiated an unsupported protocol version.  (The other per-transport
caller, rds_ib_destroy_nodev_conns(), is only reached from
rds_ib_exit(), where ->t_unloading already covers it.)  While that
destroy runs, a concurrent rds_cong_queue_updates() can
still find the connection on the congestion map's m_conn_list (the
conn is only removed from it after the paths are torn down) and call
queue_delayed_work() on a cp_wq that destroy_workqueue() has already
freed.  Additionally, the other requeueing sites can likewise re-arm
works that live in the about-to-be-freed connection unless
rds_destroy_pending() has something to guard it with.

The version-mismatch path used to be covered: commit c90ecbfaf50d2
("rds: Use atomic flag to track connections being destroyed")
introduced the RDS_DESTROY_PENDING cp_flags bit for exactly this, and
after commit ebeeb1ad9b8ad ("rds: tcp: use rds_destroy_pending() to
synchronize netns/module teardown and rds connection/workq management")
it was set right before that rds_conn_destroy() call and
tested via rds_ib_is_unloading().  Commit cdc306a5c9cd3 ("rds: make
v3.1 as compat version") then removed the last set_bit while leaving
the test behind, so the bit has been dead ever since and per-conn
destroy has run unguarded.

Bring the protection back at the connection level: set
conn->c_destroy_in_prog before the unhash + synchronize_rcu() sequence
in rds_conn_destroy() and test it in rds_destroy_pending().  The
existing rcu_read_lock() around every check-and-queue site pairs with
that synchronize_rcu(): once it returns, every new reader observes the
flag and refuses to queue, and anything queued before it is flushed or
cancelled by the existing teardown.  Drop the now-unreferenced
RDS_DESTROY_PENDING bit and its dead test.

In the Oracle UEK kernel the equivalent conn->c_destroy_in_prog flag
is part of the larger connection refcounting rework ("net/rds: Add
krefs to struct rds_connection"), including ("net/rds: Merge uses of
conn->c_destroy_in_prog & RDS_DESTROY_PENDING").  This ports the
missing pieces of the requeue guard, which stand on their own.

Fixes: cdc306a5c9cd3 ("rds: make v3.1 as compat version")
Suggested-by: Sharath Srinivasan <sharath.srinivasan@oracle.com>
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/connection.c |  8 ++++++++
 net/rds/ib.c         |  5 +----
 net/rds/rds.h        | 12 ++++++++++--
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index a96569a3ee9a..242ca0570a47 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -579,6 +579,14 @@ void rds_conn_destroy(struct rds_connection *conn)
 		 "%pI4\n", conn, &conn->c_laddr,
 		 &conn->c_faddr);
 
+	/* Make rds_destroy_pending() true for this conn.  Together with
+	 * the synchronize_rcu() below this stops the work-requeueing
+	 * sites (which all test rds_destroy_pending() under
+	 * rcu_read_lock()) from queueing new work on the path
+	 * workqueues once we start cancelling and destroying them.
+	 */
+	WRITE_ONCE(conn->c_destroy_in_prog, true);
+
 	/* Ensure conn will not be scheduled for reconnect */
 	spin_lock_irq(&rds_conn_lock);
 	hlist_del_init_rcu(&conn->c_hash_node);
diff --git a/net/rds/ib.c b/net/rds/ib.c
index 786f39169bc1..9fe3b9951bd3 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -525,10 +525,7 @@ static void rds_ib_set_unloading(void)
 
 static bool rds_ib_is_unloading(struct rds_connection *conn)
 {
-	struct rds_conn_path *cp = &conn->c_path[0];
-
-	return (test_bit(RDS_DESTROY_PENDING, &cp->cp_flags) ||
-		atomic_read(&rds_ib_unloading) != 0);
+	return atomic_read(&rds_ib_unloading) != 0;
 }
 
 void rds_ib_exit(void)
diff --git a/net/rds/rds.h b/net/rds/rds.h
index 2db49573dacd..50b08c28ab86 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -89,7 +89,6 @@ enum {
 #define RDS_RECONNECT_PENDING	1
 #define RDS_IN_XMIT		2
 #define RDS_RECV_REFILL		3
-#define	RDS_DESTROY_PENDING	4
 
 /* Max number of multipaths per RDS connection. Must be a power of 2 */
 #define	RDS_MPATH_WORKERS	8
@@ -148,6 +147,14 @@ struct rds_connection {
 				c_pad_to_32:29;
 	int			c_npaths;
 	bool			c_with_sport_idx;
+	/* Set once, by rds_conn_destroy(), before it cancels the path
+	 * works; read through rds_destroy_pending().  A site that arms
+	 * a path work must test the predicate and queue the work inside
+	 * one rcu_read_lock() section: the synchronize_rcu() that
+	 * follows the store is what keeps a queue issued after the
+	 * cancellation from landing on a destroyed workqueue.
+	 */
+	bool			c_destroy_in_prog;
 	struct rds_connection	*c_passive;
 	struct rds_transport	*c_trans;
 
@@ -994,7 +1001,8 @@ void __rds_put_mr_final(struct kref *kref);
 
 static inline bool rds_destroy_pending(struct rds_connection *conn)
 {
-	return !check_net(rds_conn_net(conn)) ||
+	return READ_ONCE(conn->c_destroy_in_prog) ||
+	       !check_net(rds_conn_net(conn)) ||
 	       (conn->c_trans->t_unloading && conn->c_trans->t_unloading(conn));
 }
 
-- 
2.25.1

