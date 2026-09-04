Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2573B05AC;
	Fri,  4 Sep 2026 07:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788505373; cv=none; b=NW4DzZ+gqy7zXMKsu9dvG66it2blrdmy5ydYkmKtb+J1KsmCNahwTuIMS8q3AfrDuV2ZsEkDsvR0jkOGl/1qat2alWAjJQ63T3IGwGhKiCSPUXFIfk5N0HoYhx+GpJQI0L4zUWuqUrcPRFR4NZdvjftRUrvmUagCE2vzLN2pmw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788505373; c=relaxed/simple;
	bh=bYfaR+reHSR832jus7w9wItq9/LIWTrFPrAdQhpoMxs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X7nhqt7mXLMp3KiInuw8DS/vwLwJqCXBmpAR0Rqpjdn5xgku2pcsp7GIdCQ7jGa/jho57eFGsHtiN+1sMHiYsOREeie1tlcAgmR+mR0SNyRKVOAznGaEUewNMLb2vb1m+LFDWcLcy0jt2JO7soHz/TuLxeuP9k5hfhdlDOUU+E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EaLU9iTz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EaLU9iTz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC451F00AC4;
	Fri,  4 Sep 2026 07:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788505371;
	bh=PDcg1z/3x1xhbPxmJ6yJeYrXY9VrewRtc4hlN4xkqdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EaLU9iTzvK1dAykX9VBd+7If5c1LoFtppzgov40wi+w2HskqKC8KunEK9W+fGb49e
	 1xiQyGho9qI/9Kmo0AOGxoRBUfYbi+7kZNEvtWEACfaR3EC7In4uFIhKtQy8peUyUr
	 p0h24+hOYyglRUlM9XDEhswnD8pLM3u76BeOUMAXgo4b3UHJ/GoONQxiXIBPBlkHo4
	 wS0Zp+Bp8BSBNmh9Qg2B9+9L3GdLN1Lft/tv1XY10qAL7pmw1PL5V2DKLXNdugxHxx
	 Q/9UDbr7ljHhg+82rOycOm+tj/ncXHW+ZXy4sOY5k5izdS3LhVksS0IBgi4/hsf6ho
	 wNHxOrHW/o4kw==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	nicoyip.dev@gmail.com
Subject: [PATCH net-next 2/6] net/rds: split connection destroy into quiesce and kref-governed free
Date: Fri,  4 Sep 2026 00:02:44 -0700
Message-Id: <20260904070248.160384-3-achender@kernel.org>
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

From: Sharath Srinivasan <sharath.srinivasan@oracle.com>

rds_conn_destroy() tears down the transport state and immediately
frees the connection, along with its paths and its workqueues.  This
relies on the assumption (documented in the rds_conn_destroy()
comments) that "no one else is referencing the connection", which "we
can only ensure ... in the rmmod path".  However, the callers stopped
honoring that long ago.  Today, connections can also be destroyed
when the underlying IB device is removed (in
rds_ib_destroy_nodev_conns()), or when a peer negotiates an
unsupported protocol version.

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

Based on Oracle UEK commit 2c8569e4c880 ("net/rds: Add krefs to struct
rds_connection").

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
 net/rds/connection.c | 89 ++++++++++++++++++++++++++++++++++++--------
 net/rds/rds.h        |  8 ++++
 2 files changed, 82 insertions(+), 15 deletions(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index 50e1b6bfceea..f45fd1fb1843 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -215,6 +215,7 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 		goto out;
 	}
 
+	kref_init(&conn->c_refcount);
 	INIT_HLIST_NODE(&conn->c_hash_node);
 	conn->c_laddr = *laddr;
 	conn->c_isv6 = !ipv6_addr_v4mapped(laddr);
@@ -515,10 +516,12 @@ void rds_conn_shutdown(struct rds_conn_path *cp)
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
 
@@ -547,6 +550,16 @@ static void rds_conn_path_destroy(struct rds_conn_path *cp)
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
@@ -556,16 +569,52 @@ static void rds_conn_path_destroy(struct rds_conn_path *cp)
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
@@ -579,11 +628,23 @@ void rds_conn_destroy(struct rds_connection *conn)
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
@@ -591,7 +652,7 @@ void rds_conn_destroy(struct rds_connection *conn)
 	/* shut the connection down */
 	for (i = 0; i < npaths; i++) {
 		cp = &conn->c_path[i];
-		rds_conn_path_destroy(cp);
+		rds_conn_path_quiesce(cp);
 		BUG_ON(!list_empty(&cp->cp_retrans));
 	}
 
@@ -602,12 +663,10 @@ void rds_conn_destroy(struct rds_connection *conn)
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
index cede2b03baa5..e27e5e2e3329 100644
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
@@ -822,6 +828,8 @@ struct rds_connection *rds_conn_create_outgoing(struct net *net,
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

