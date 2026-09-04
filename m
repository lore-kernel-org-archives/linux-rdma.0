Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5743AA9F8;
	Fri,  4 Sep 2026 07:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788505372; cv=none; b=VomXgpytoiHYRayQpVliQtuvz9/2mtDIFW/2jACMT8BpOhAvHXXWcGH2uIX9Iyy33WX1oA9lLwK2TkcKwSfn8Q41t4iySTntuCqT3Io1fWc2N5ke5aZGTeHoWgS80pabGDYnIhx/cqKbY2J5tco0EMA2or8jyj2XHSRd3KXCmYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788505372; c=relaxed/simple;
	bh=PSPtmh0jznqMPWwWo5/dvyP91D0olB43iFwtupdgnUU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hwpu4mx+oUXSbrI8c0q0J2zg+EmgFsAKEfJEMVBbB3a8C+OJj7CYYFZgW9n9+RFfF8zYWjjYlLHgmeQxnQ3Lk1KUW62DA8K0zjlX/VCM7+vWe+5sGbZPjdhXBQXauvQC0Jioc5IIbsyq9Q2aUAylcnVVzyUbPQmj9yod/YoTwSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KXkB/BLB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KXkB/BLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212C21F00A3E;
	Fri,  4 Sep 2026 07:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788505370;
	bh=Zk+q8ogaZVGiWtFXGz5hemisUGhKlb4NtYCvfPwQw0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KXkB/BLB5o9wy0aoAjY0ybn4BZ4SqCaU1GLTzvBE7mhpb7aQHkrr93Lc8UhQOUN01
	 xw1pXTu9VfjBP4jPUElBP29t1cRWHLUkgt+mDEbDepVv9DTrioDFKExbCh8hLyn+hb
	 2m//S2b7t84inJVL5UAPzwyhUq587r7kDGeop4WDdLGkRL9aa1ldoqJU+pgc3gcuPX
	 jLETuWVWlRy6R13rcIs5DqeQkTF9SpVCLefgsYXr4EmNyqM3pJnj89DKsASB4Kq8Ty
	 L+qx3VT7KE0Na1O3jJFYOTWkWzZennR4RS7N3aNX6ujFtcgigojz6b7Wf3QWdtGZIh
	 gZwK00aBLH1rA==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	nicoyip.dev@gmail.com
Subject: [PATCH net-next 1/6] net/rds: make rds_destroy_pending() cover single-connection destroy
Date: Fri,  4 Sep 2026 00:02:43 -0700
Message-Id: <20260904070248.160384-2-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260904070248.160384-1-achender@kernel.org>
References: <20260904070248.160384-1-achender@kernel.org>
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
sites already guard the queueing with rds_destroy_pending() under
rcu_read_lock(), and rds_conn_destroy() already issues a
synchronize_rcu() after unhashing the connection.  But the predicate
only tests for the two global teardown cases (netns destruction via
check_net(), module unload via ->t_unloading).  Because the conn
itself lacks any indication that a destroy is in progress, the
predicate does not cover the destruction of a single connection
outside these two cases.

rds_conn_destroy() is not limited to the global paths: rds_ib
destroys connections whose underlying IB device was removed
(rds_ib_destroy_nodev_conns()) and connections whose peer negotiated
an unsupported protocol version (rds_ib_cm_connect_complete()).
While one of those runs, a concurrent rds_cong_queue_updates() can
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

Bring the protection back at the connection level, where it also
covers the device-removal path that was never guarded: set
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
 net/rds/connection.c | 8 ++++++++
 net/rds/ib.c         | 5 +----
 net/rds/rds.h        | 8 ++++++--
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index b6c4beb50eaf..50e1b6bfceea 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -574,6 +574,14 @@ void rds_conn_destroy(struct rds_connection *conn)
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
index 2db49573dacd..cede2b03baa5 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -89,7 +89,6 @@ enum {
 #define RDS_RECONNECT_PENDING	1
 #define RDS_IN_XMIT		2
 #define RDS_RECV_REFILL		3
-#define	RDS_DESTROY_PENDING	4
 
 /* Max number of multipaths per RDS connection. Must be a power of 2 */
 #define	RDS_MPATH_WORKERS	8
@@ -148,6 +147,10 @@ struct rds_connection {
 				c_pad_to_32:29;
 	int			c_npaths;
 	bool			c_with_sport_idx;
+	/* Set (under RCU) when rds_conn_destroy() starts on this conn;
+	 * read through rds_destroy_pending().
+	 */
+	bool			c_destroy_in_prog;
 	struct rds_connection	*c_passive;
 	struct rds_transport	*c_trans;
 
@@ -994,7 +997,8 @@ void __rds_put_mr_final(struct kref *kref);
 
 static inline bool rds_destroy_pending(struct rds_connection *conn)
 {
-	return !check_net(rds_conn_net(conn)) ||
+	return READ_ONCE(conn->c_destroy_in_prog) ||
+	       !check_net(rds_conn_net(conn)) ||
 	       (conn->c_trans->t_unloading && conn->c_trans->t_unloading(conn));
 }
 
-- 
2.25.1

