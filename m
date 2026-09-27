Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8903B8BC6;
	Sun, 27 Sep 2026 06:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790489693; cv=none; b=rETbRYE9fFQpFtqBQ9vVKYLQaaWMY8mxWxQhMhwZUqbPOLgZCFp3U12qghU3lFZA2nKfcY4VopAVGdX/rKVCShMee+VNXYoqGvuwBgD93HTghAWwWhyfuC04RViyTFSsYyO/TYJaki81I2KgfocIAj1Qjcpc390lPLyvtxVMmjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790489693; c=relaxed/simple;
	bh=qkQqGJiHn9thzuD/3FEwvt4aHCuOaclqQWl5PGAZNik=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Oog0RGbiHD9D6tuQC0aFGhHi2HYtqPQ3kxJmzVIwVVjKfStmrt00+K06bMrcCXW2eL6sBXzNl9ik3ik/p51oPacb0v/8qM16ETIB81F43hjJMk36c+1oclY3n+4BzimZ03FHBd+Mz7PZN3ZFRtxm1iBcPrA1QvNh6U6xdSAoE1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JBKBZ0yA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JBKBZ0yA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3832B1F00898;
	Sun, 27 Sep 2026 06:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790489691;
	bh=ldWzD1UsZZVOBsM7dKfkfRGe9b1QSc9W3QYe4z3FKuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JBKBZ0yAu6GTPua1KhEzT0YZ7R75T56TsgPMdWxhKKVFcGGSZhazHyj9aUJGy/wzt
	 kRUogv8eVigm+UoW2nm9Nfmq61QV72xAyv8Kwu6fobTUvTt7gY+NbS9zIvlb2qGtl9
	 17WFJJi2eUFUcE3yLbI2mWnKy41Y5M4D5UTXjZXyehOdtnSPsm17k/jskjrwP0qPOI
	 A5I5ufgHTEL4g9prbcSLlZ5Poioo1Nglk4Q1KbcIYVluuGKRTUCAXx9C8Uplw2+ULs
	 oZ8+tDnJoU6P4OmMvmoPn8aSDh5VTzUmq7EYAgyNuzIrS4abNANQj7cqria4dQxe/j
	 z2O+liG3Pk6KQ==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v7 04/12] net/rds: make rds_destroy_pending() report a connection's own destroy
Date: Sat, 26 Sep 2026 23:14:40 -0700
Message-Id: <20260927061448.167862-5-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260927061448.167862-1-achender@kernel.org>
References: <20260927061448.167862-1-achender@kernel.org>
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
rds_conn_path_drop() that the destroy itself, and IB device removal,
issue and then flush - guard the queueing with
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
freed, and the other requeueing sites can likewise re-arm works that
live in the about-to-be-freed connection.

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

Fixes: c809195f5523 ("rds: clean up loopback rds_connections on netns deletion")
Suggested-by: Sharath Srinivasan <sharath.srinivasan@oracle.com>
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/connection.c |  8 ++++++++
 net/rds/ib.c         |  5 +----
 net/rds/rds.h        | 16 ++++++++++++++--
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index 95ff50f31d1e..cbc49426ba08 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -585,6 +585,14 @@ void rds_conn_destroy(struct rds_connection *conn)
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
index 2db49573dacd..d595fb78c61f 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -89,7 +89,6 @@ enum {
 #define RDS_RECONNECT_PENDING	1
 #define RDS_IN_XMIT		2
 #define RDS_RECV_REFILL		3
-#define	RDS_DESTROY_PENDING	4
 
 /* Max number of multipaths per RDS connection. Must be a power of 2 */
 #define	RDS_MPATH_WORKERS	8
@@ -148,6 +147,18 @@ struct rds_connection {
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
+	 * rds_conn_path_drop(), which the destroy itself (and IB device
+	 * removal) issues and then flushes.
+	 */
+	bool			c_destroy_in_prog;
 	struct rds_connection	*c_passive;
 	struct rds_transport	*c_trans;
 
@@ -994,7 +1005,8 @@ void __rds_put_mr_final(struct kref *kref);
 
 static inline bool rds_destroy_pending(struct rds_connection *conn)
 {
-	return !check_net(rds_conn_net(conn)) ||
+	return READ_ONCE(conn->c_destroy_in_prog) ||
+	       !check_net(rds_conn_net(conn)) ||
 	       (conn->c_trans->t_unloading && conn->c_trans->t_unloading(conn));
 }
 
-- 
2.25.1

