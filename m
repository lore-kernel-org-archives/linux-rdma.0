Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B93E522688;
	Tue, 22 Sep 2026 08:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790067256; cv=none; b=oGxpcQviuevCA5DyFjkDq5vHIw104xsG//P6y6ShsO3rfOXfFuwV0dGfadGsDXnsBUBKzJOahu+tTgyxvgyP/3qjHkd+WbNog/9hUJMup6R4tfmLSYA6cxdIzr9BQPPgfn+xngRkXCE1PwKpjpkAaA1/ZnC9FemUfFeOS0vBxlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790067256; c=relaxed/simple;
	bh=PO9TaFPgtjvbUhCAUWGipQZAobU3eRmmHSpDDVCRDac=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FovTyQGZ0xhNdneGfsQqxSvqokEF3kwuemL1to5bZZd/MO/xEpBCGEgQI48bCtYzriWikbRmDkLCvhZgpvWMGYQKGVVg25LOQsUDUhqOQ0zsZGEfpmaP5BFogOeuzrBldcA5PIZk+umvN4b2kr/f/AklPqQouVLfoNcopAhhO0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CYk9V3Co; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CYk9V3Co"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BECD1F000FF;
	Tue, 22 Sep 2026 08:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790067253;
	bh=Ot8oG0FQtZs6Fvo3vnKvxxIDdhkxVgyKmszzWm92l5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CYk9V3CoP9atye5IRAAPlBxUqfvieE81NsNfIP0Que7l8gpl/FiqjM7EZXuffJY4y
	 1W0aeY99ZvDE9GYM8kwYE9aG5YEGXFcUchyO1MHQqomFtxY4o62kTY+J5HmbDaCIDV
	 D9ktPFsprWNhdCZsVMYosnHYtu2oRn86wAWbRL3W/i/x3/K3tJM4aXdmmdzgrc2mEQ
	 zmFPRr3OoYKUy9w/V/ZwwPReCZZpoLRDzFM5nbAxfX5R1+A9CpxeOLmC+SIZz105+3
	 2ckmT+hG0abCM3/sGvPTyWRPQDTdmHcJHwJUaW1Vo3iR2xLUq8aFKYx55aPy7ESAvN
	 g6N12ho13y4DA==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v6 04/12] net/rds: make rds_destroy_pending() report a connection's own destroy
Date: Tue, 22 Sep 2026 01:54:02 -0700
Message-Id: <20260922085410.391323-5-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260922085410.391323-1-achender@kernel.org>
References: <20260922085410.391323-1-achender@kernel.org>
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

Today every rds_conn_destroy() does happen on one of those two global
paths - the last single-connection caller, the protocol-version
mismatch in rds_ib_cm_connect_complete(), was turned into a drop by
commit f97d8c7bab78 ("rds: ib: use rds_conn_drop() on protocol
version mismatch") - so the predicate is currently never wrong.  It is
also never precise: it answers "is this connection's world going
away", not "is this connection being destroyed", and the following
patches need the second answer.  Once the free is deferred to the
last reference, a connection can be handed to rds_conn_destroy() more
than once (the IB unload path re-sweeps its list until every
connection is gone) and must recognise its own destroy in progress;
the passive-twin creation must refuse a parent whose destroy has
begun; and a future single-connection destroy - a hot-unplugged IB
device, or the asynchronous teardown the Oracle UEK kernel has -
would re-open the window below.  While a single-connection destroy
runs, a concurrent rds_cong_queue_updates() can
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

Record the destroy on the connection itself: set
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

