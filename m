Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7413ACA4D;
	Thu,  8 Oct 2026 03:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791429218; cv=none; b=drF3p7UYeQcDoXlTJDh4Eh7gKuQ1CJkHbMFoTakchdvNhwmpO6/VkYaIwWTmrCRuPekLKSbioxNlEPLdsz3iYw5fJ5yd1M4ey4PQhaA+knI8m1kzol+N97bgZkfEyXZg5wcvJNlSWXDZ3jUVDlCUDm46qIoAY0cRqqh/HgLuktU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791429218; c=relaxed/simple;
	bh=CTJoXls1/T/+FhqtfZvkoLG+XqsWnDJ6G8RsvKnxBAE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A+yXyvj0x1yV2axwaOWUel6Tx2WcysRNEWwyJbKwe4PqIsxTsu7Xw1Dcuyr1JK5ECWVqr5al992vi3W08c11O49BZccz1NSgDjsN6r+btz3BLcSH8I0nXSoQzYjlKtO752Ov0SpELdJsvYbvF/2DX1got5uyKqqu/2Qr+8RbQ1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DZFmHOxE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DZFmHOxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B01A1F0089B;
	Thu,  8 Oct 2026 03:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791429216;
	bh=I8GtZmx/fyOlV4MKzGc9aEe4kZkn5e58TZkqpxafcMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DZFmHOxEeN88cdJ32+zY8wp2pCeYV1QWxeCuYPCBy6VhPjn9Y1sxry5HCCT5lt6S/
	 uY5a7tGfuFQ7MZhJ27c4VH5blo2Jx5iCxZuQ/VFpNQIzNCj/lpjcMYtvnIrAJP6A+2
	 0qMr40gmO+qH3ybjPu0zdssgxyB39nk0cAitXZy52izMdCL7M0sB20eIblo25oSk/I
	 ZlAYwbs2hcz72aEsBe2ekd6tAh2gY0dhjpg6osm1mZckSkPmPTnbmX/hX4xC4gEdpG
	 oSLnFy7BAJzQE/62jlmoJG5zbQSGeNxL5IiD7bFsP8MzD/WW+BfkpBlO1yanq2QBgH
	 8JNq432ccs6Sg==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v9 05/13] net/rds: make rds_destroy_pending() report a connection's own destroy
Date: Wed,  7 Oct 2026 20:13:25 -0700
Message-Id: <20261008031333.1142174-6-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261008031333.1142174-1-achender@kernel.org>
References: <20261008031333.1142174-1-achender@kernel.org>
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
cancel in the destroy path already rejects, and the destroy == true
rds_conn_path_drop(), which the destroy itself issues and flushes and
IB device removal issues ahead of the module exit that destroys the
connection - guard the queueing with
rds_destroy_pending() under rcu_read_lock() (the last stragglers were
converted by the previous patch), and rds_conn_destroy() already issues a
synchronize_rcu() after unhashing the connection.  But the predicate
only tests for the two global teardown cases (netns destruction via
check_net(), module unload via ->t_unloading).  Because the conn
itself lacks any indication that a destroy is in progress, the
predicate does not cover the destruction of a single connection
outside these two cases.

One caller escapes both terms.  When the core rds module unloads,
rds_conn_exit() runs rds_loop_net_exit() first, and unregistering the
pernet operations invokes rds_loop_exit_net() -> rds_loop_kill_conns()
-> rds_conn_destroy() for the loopback connections of every network
namespace that is still alive: check_net() is true for all of them,
and the loop transport's unloading flag is only set afterwards, by
rds_loop_exit().  For the duration of those destroys the predicate is
false, so a concurrent rds_cong_queue_updates() can still find the
connection on the congestion map's m_conn_list (the conn is only
removed from it after the paths are torn down) and call
queue_delayed_work() on a cp_wq that destroy_workqueue() has already
freed.  Nothing can exploit that today: every socket pins the rds
module, so none exists by the time rds_exit() runs, and the works a
connection's own ordered workqueue re-arms are drained by
destroy_workqueue().  But the predicate is wrong for those destroys,
and the following patches need it to be right.

The predicate is also imprecise even where it is true: it answers "is
this connection's world going away", not "is this connection being
destroyed", and the following patches need the second answer.  Once
the free is deferred to the last reference, a connection can be
handed to rds_conn_destroy() more than once (the IB unload path
re-sweeps its list until every connection is gone) and must
recognise its own destroy in progress, and the passive-twin creation
must refuse a parent whose destroy has begun.

The cp_flags bit that once served this purpose, RDS_DESTROY_PENDING
from commit c90ecbfaf50d2 ("rds: Use atomic flag to track connections
being destroyed"), was only ever set on the IB protocol-version path
and lost its last set_bit in commit cdc306a5c9cd3 ("rds: make v3.1 as
compat version"); it never covered the loopback path above, which
commit c809195f5523 ("rds: clean up loopback rds_connections on netns
deletion") added.

Record the destroy on the connection itself, where every caller is
covered: set
conn->c_destroy_in_prog before the unhash + synchronize_rcu() sequence
in rds_conn_destroy() and test it first in rds_destroy_pending().  The
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

Suggested-by: Sharath Srinivasan <sharath.srinivasan@oracle.com>
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/connection.c |  9 +++++++++
 net/rds/ib.c         |  5 +----
 net/rds/rds.h        | 17 +++++++++++++++--
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index 95ff50f31d1e..97d470242d0f 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -585,6 +585,15 @@ void rds_conn_destroy(struct rds_connection *conn)
 		 "%pI4\n", conn, &conn->c_laddr,
 		 &conn->c_faddr);
 
+	/* Make rds_destroy_pending() true for this conn.  Together with
+	 * the synchronize_rcu() below this stops the work-requeueing
+	 * sites (which test rds_destroy_pending() under rcu_read_lock(),
+	 * bar the exemptions noted at c_destroy_in_prog) from queueing
+	 * new work on the path workqueues once we start cancelling and
+	 * destroying them.
+	 */
+	WRITE_ONCE(conn->c_destroy_in_prog, true);
+
 	/* Ensure conn will not be scheduled for reconnect */
 	spin_lock_irq(&rds_conn_lock);
 	hlist_del_init_rcu(&conn->c_hash_node);
diff --git a/net/rds/ib.c b/net/rds/ib.c
index a7647ec01a11..d9879b6129e7 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -528,10 +528,7 @@ static void rds_ib_set_unloading(void)
 
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
index 2db49573dacd..5afdf5a8d93f 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -89,7 +89,6 @@ enum {
 #define RDS_RECONNECT_PENDING	1
 #define RDS_IN_XMIT		2
 #define RDS_RECV_REFILL		3
-#define	RDS_DESTROY_PENDING	4
 
 /* Max number of multipaths per RDS connection. Must be a power of 2 */
 #define	RDS_MPATH_WORKERS	8
@@ -148,6 +147,19 @@ struct rds_connection {
 				c_pad_to_32:29;
 	int			c_npaths;
 	bool			c_with_sport_idx;
+	/* Set once, by rds_conn_destroy(), before it cancels the path
+	 * works; read through rds_destroy_pending().  A site that arms
+	 * a path work must test the predicate and queue the work inside
+	 * one rcu_read_lock() section: the synchronize_rcu() that
+	 * follows the store is what keeps a queue issued after the
+	 * cancellation from landing on a destroyed workqueue.  Two kinds
+	 * of site are exempt: the workers' own self-requeues, which the
+	 * sync cancel in the destroy path rejects, and the destroy == true
+	 * rds_conn_path_drop(): the destroy issues and flushes it itself,
+	 * and IB device removal issues it ahead of the module exit, which
+	 * destroys - and so flushes - that connection afterwards.
+	 */
+	bool			c_destroy_in_prog;
 	struct rds_connection	*c_passive;
 	struct rds_transport	*c_trans;
 
@@ -994,7 +1006,8 @@ void __rds_put_mr_final(struct kref *kref);
 
 static inline bool rds_destroy_pending(struct rds_connection *conn)
 {
-	return !check_net(rds_conn_net(conn)) ||
+	return READ_ONCE(conn->c_destroy_in_prog) ||
+	       !check_net(rds_conn_net(conn)) ||
 	       (conn->c_trans->t_unloading && conn->c_trans->t_unloading(conn));
 }
 
-- 
2.25.1

