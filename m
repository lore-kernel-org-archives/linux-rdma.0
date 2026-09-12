Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D1F2F6931;
	Sat, 12 Sep 2026 03:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789185032; cv=none; b=C6slr3FX+9tA1AtVPwgXx2GJgwK/GJkJO2SSL0F+XihsNcRIBKh9Wb/eBspbAc4GhDUOr9QON/gd+Wgc8JCe9Wfl5pEx+4VUCKtt1r4FcAB3qigAP6FPwoUw3dQCyEq5nUuwKk0sTu+eOMUwuPjcKnb7mG36tdguwRKlPc7rWxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789185032; c=relaxed/simple;
	bh=9gcR8HqA2//rrYD5eGiykicX7oOUYGPLZAOqZ4iVO3M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fDEhUAjBnxD+9gRapH8ldJwC4nEaIo/F8fpEYdL5vuUr9Ydt28yIiMj51obvGQAw3OMzmsEA8gJjT/I1Gp9qJYlrU59k7SsbdDxOK0oso18pCY20APJx6BLLmrQj26iY/FVkDkI1RTm2etCo3Z8rUFTr8biiD4E6cbVBZsG7R8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S8GPxQVK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S8GPxQVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E871F0089B;
	Sat, 12 Sep 2026 03:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789185030;
	bh=VOju80p08ynPFtK/YeApRyFgs4u+9mTpthURiZl9DcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S8GPxQVKEhkFq+5OoaQxMs06bZNPL6S0n3Ex0kENniYB6nBbS7EMsbxkNhgT4nVVC
	 c+X6qth4oBah5uOxYkDX4zYF9DvNEJxFX3FKFKtvuOQBO2GxSg0X8ML1TO6GY3Wg+D
	 fSVw9YJY7h7WNhWtVOylZCwt/cpuu0a++VMvZBQm0ulAepC7i1MfZf6jdlDSyn+80r
	 oSzI3k9w8gkfK1Bp+wk8OfBLQ/iZr9AgNko9mb1z96/7zzmAP3zGTnvii154Z3oSzg
	 bLGMXpL/VzPBWPsJIQ3AbGkCPC3PnfgEe4dCoaJ4rHstvw3lUeFs6hgZ1wAr+ZL8VR
	 UT4eaGMqfkQgw==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	nicoyip.dev@gmail.com
Subject: [PATCH net-next v2 3/9] net/rds: split connection destroy into quiesce and kref-governed free
Date: Fri, 11 Sep 2026 20:50:21 -0700
Message-Id: <20260912035027.27447-4-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260912035027.27447-1-achender@kernel.org>
References: <20260912035027.27447-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sharath Srinivasan <sharath.srinivasan@oracle.com>

rds_conn_destroy() tears down the transport state and immediately
frees the connection, along with its paths and its workqueues.  This
relies on the assumption (documented in the rds_conn_destroy()
comments) that "no one else is referencing the connection", which "we
can only ensure ... in the rmmod path".  However, the callers stopped
honoring that long ago.  Today, connections are also destroyed on
network namespace teardown (rds_tcp_kill_sock() and
rds_loop_kill_conns()) and, one at a time, when a peer negotiates an
unsupported protocol version (rds_ib_cm_connect_complete()).

This leaves loose ends since references to these destroyed
connections still exist.  Sockets cache their connections in rs_conn,
and congestion updates will walk the maps' m_conn_list.  The CM
callbacks and workers may also still hold the pointer.

Prepare to close those holes by making the connection refcounted:

- kref_init() the connection in __rds_conn_create(); the initial
  reference belongs to whoever is responsible for destroying the
  connection.
- rds_conn_destroy() still quiesces synchronously exactly as before
  (workers cancelled, paths dropped and shut down, queued messages
  purged, congestion list removal), but the frees - the transport's
  conn_free, the path workqueues, the c_path array and the connection
  slab object - move to rds_conn_destroy_fini(), which runs when the
  last reference is dropped via rds_conn_put().
- Export rds_conn_get()/rds_conn_put() for the reference holders
  introduced in the following patches.

With no additional reference holders yet, this only sets up the
refcounting framework and is functionally equivalent to the current
code (the initial reference is the only one).  Subsequent patches will
take references at the places that today rely on bare pointers.

Based on the Oracle UEK commit "net/rds: Add krefs to struct
rds_connection".

Signed-off-by: Sharath Srinivasan <sharath.srinivasan@oracle.com>
[achender: substantial reimplementation for net-next: UEK's
 rds_conn_destroy_init()/_fini() split redone against upstream's
 rds_conn_destroy()/rds_conn_path_destroy() (no heartbeat/reap/trace
 infrastructure, no rds_net, single conn hash); destroy keeps its
 one-call external interface; holder coverage split out into follow-up
 patches; rewrite commit message]
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/connection.c | 96 +++++++++++++++++++++++++++++++++++---------
 net/rds/rds.h        |  8 ++++
 2 files changed, 86 insertions(+), 18 deletions(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index 50e1b6bfceea..cc4e74b731df 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -215,6 +215,7 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 		goto out;
 	}
 
+	kref_init(&conn->c_refcount);
 	INIT_HLIST_NODE(&conn->c_hash_node);
 	conn->c_laddr = *laddr;
 	conn->c_isv6 = !ipv6_addr_v4mapped(laddr);
@@ -466,9 +467,10 @@ void rds_conn_shutdown(struct rds_conn_path *cp)
 			 * Quiesce the reconnect timer before bailing
 			 * out, though.  When a pending destroy did
 			 * suppress the queue, no later pass runs, and
-			 * rds_conn_path_destroy() is about to flush
-			 * cp_down_w and free the path: it must not
-			 * find cp_conn_w still armed.  A successor
+			 * rds_conn_path_quiesce() is about to flush
+			 * cp_down_w, ahead of the path's deferred
+			 * free: it must not find cp_conn_w still
+			 * armed.  A successor
 			 * pass, when there is one, re-arms the
 			 * reconnect from its own tail.
 			 */
@@ -515,10 +517,12 @@ void rds_conn_shutdown(struct rds_conn_path *cp)
 		conn->c_trans->conn_slots_available(conn, false);
 }
 
-/* destroy a single rds_conn_path. rds_conn_destroy() iterates over
- * all paths using rds_conn_path_destroy()
+/* quiesce a single rds_conn_path: shut it down and tear down any
+ * queued messages.  rds_conn_destroy() iterates over all paths using
+ * rds_conn_path_quiesce(); the transport state and the workqueue are
+ * freed later, from rds_conn_path_free().
  */
-static void rds_conn_path_destroy(struct rds_conn_path *cp)
+static void rds_conn_path_quiesce(struct rds_conn_path *cp)
 {
 	struct rds_message *rm, *rtmp;
 
@@ -547,6 +551,16 @@ static void rds_conn_path_destroy(struct rds_conn_path *cp)
 	WARN_ON(delayed_work_pending(&cp->cp_recv_w));
 	WARN_ON(delayed_work_pending(&cp->cp_conn_w));
 	WARN_ON(work_pending(&cp->cp_down_w));
+}
+
+/* free a quiesced rds_conn_path's transport state and workqueue; runs
+ * from rds_conn_destroy_fini() once the last connection reference is
+ * dropped.
+ */
+static void rds_conn_path_free(struct rds_conn_path *cp)
+{
+	if (!cp->cp_transport_data)
+		return;
 
 	if (cp->cp_wq != rds_wq) {
 		destroy_workqueue(cp->cp_wq);
@@ -556,16 +570,52 @@ static void rds_conn_path_destroy(struct rds_conn_path *cp)
 	cp->cp_conn->c_trans->conn_free(cp->cp_transport_data);
 }
 
+/* Free a connection.  This runs from rds_conn_put() when the last
+ * reference is dropped, after rds_conn_destroy() has quiesced the
+ * connection and dropped the initial reference.
+ */
+static void rds_conn_destroy_fini(struct kref *kref)
+{
+	struct rds_connection *conn = container_of(kref, struct rds_connection,
+						   c_refcount);
+	int npaths = (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
+	unsigned long flags;
+	int i;
+
+	for (i = 0; i < npaths; i++)
+		rds_conn_path_free(&conn->c_path[i]);
+
+	kfree(conn->c_path);
+	kmem_cache_free(rds_conn_slab, conn);
+
+	spin_lock_irqsave(&rds_conn_lock, flags);
+	rds_conn_count--;
+	spin_unlock_irqrestore(&rds_conn_lock, flags);
+}
+
+void rds_conn_get(struct rds_connection *conn)
+{
+	kref_get(&conn->c_refcount);
+}
+EXPORT_SYMBOL_GPL(rds_conn_get);
+
+void rds_conn_put(struct rds_connection *conn)
+{
+	kref_put(&conn->c_refcount, rds_conn_destroy_fini);
+}
+EXPORT_SYMBOL_GPL(rds_conn_put);
+
 /*
  * Stop and free a connection.
  *
- * This can only be used in very limited circumstances.  It assumes that once
- * the conn has been shutdown that no one else is referencing the connection.
- * We can only ensure this in the rmmod path in the current code.
+ * Quiesces the connection synchronously (workers cancelled, transport
+ * connections shut down, queued messages dropped) and drops the
+ * initial reference.  The memory - including the transport's
+ * per-connection state and the path workqueues - is freed once the
+ * last rds_conn_put() runs, which may be after this returns.
  */
 void rds_conn_destroy(struct rds_connection *conn)
 {
-	unsigned long flags;
 	int i;
 	struct rds_conn_path *cp;
 	int npaths = (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
@@ -579,11 +629,23 @@ void rds_conn_destroy(struct rds_connection *conn)
 	 * sites (which all test rds_destroy_pending() under
 	 * rcu_read_lock()) from queueing new work on the path
 	 * workqueues once we start cancelling and destroying them.
+	 *
+	 * Now that the transport state stays discoverable (e.g. on the
+	 * transports' connection lists) until the final rds_conn_put(),
+	 * a conn can be handed to rds_conn_destroy() more than once -
+	 * e.g. dropped for a protocol version mismatch and then found
+	 * again at module unload.  Only the first caller proceeds; the
+	 * unhash also happens under rds_conn_lock, so a looked-up conn
+	 * can never be quiesced twice.
 	 */
+	spin_lock_irq(&rds_conn_lock);
+	if (conn->c_destroy_in_prog) {
+		spin_unlock_irq(&rds_conn_lock);
+		return;
+	}
 	WRITE_ONCE(conn->c_destroy_in_prog, true);
 
 	/* Ensure conn will not be scheduled for reconnect */
-	spin_lock_irq(&rds_conn_lock);
 	hlist_del_init_rcu(&conn->c_hash_node);
 	spin_unlock_irq(&rds_conn_lock);
 	synchronize_rcu();
@@ -591,7 +653,7 @@ void rds_conn_destroy(struct rds_connection *conn)
 	/* shut the connection down */
 	for (i = 0; i < npaths; i++) {
 		cp = &conn->c_path[i];
-		rds_conn_path_destroy(cp);
+		rds_conn_path_quiesce(cp);
 		BUG_ON(!list_empty(&cp->cp_retrans));
 	}
 
@@ -602,12 +664,10 @@ void rds_conn_destroy(struct rds_connection *conn)
 	 */
 	rds_cong_remove_conn(conn);
 
-	kfree(conn->c_path);
-	kmem_cache_free(rds_conn_slab, conn);
-
-	spin_lock_irqsave(&rds_conn_lock, flags);
-	rds_conn_count--;
-	spin_unlock_irqrestore(&rds_conn_lock, flags);
+	/* drop the initial reference; the connection is freed from
+	 * rds_conn_destroy_fini() once every holder has dropped theirs
+	 */
+	rds_conn_put(conn);
 }
 EXPORT_SYMBOL_GPL(rds_conn_destroy);
 
diff --git a/net/rds/rds.h b/net/rds/rds.h
index 50b08c28ab86..49629108c22a 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -137,6 +137,12 @@ struct rds_conn_path {
 /* One rds_connection per RDS address pair */
 struct rds_connection {
 	struct hlist_node	c_hash_node;
+	/* Free of the connection memory (not the teardown of its
+	 * transport state - that stays synchronous in
+	 * rds_conn_destroy()) is deferred until the last reference is
+	 * dropped via rds_conn_put().
+	 */
+	struct kref		c_refcount;
 	struct in6_addr		c_laddr;
 	struct in6_addr		c_faddr;
 	int			c_dev_if; /* ifindex used for this conn */
@@ -826,6 +832,8 @@ struct rds_connection *rds_conn_create_outgoing(struct net *net,
 						u8 tos, gfp_t gfp, int dev_if);
 void rds_conn_shutdown(struct rds_conn_path *cpath);
 void rds_conn_destroy(struct rds_connection *conn);
+void rds_conn_get(struct rds_connection *conn);
+void rds_conn_put(struct rds_connection *conn);
 void rds_conn_drop(struct rds_connection *conn);
 void rds_conn_path_drop(struct rds_conn_path *cpath, bool destroy);
 void rds_conn_connect_if_down(struct rds_connection *conn);
-- 
2.25.1

