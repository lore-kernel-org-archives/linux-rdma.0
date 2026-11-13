Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794545039;
	b=eYvYe5Bwyaj/bTYjg3KdWUdPB1Cbt5bg0WiNKgM0zBqGyEa983svEfCk3LYb4h11mFip
	 pvbKGi0DoVRmF8H0BDnCqY5dIXbxqx00yX6hYgXj4xA3Di4d8JBNDph4/7uvM9COtZjkG
	 //XhLedm0ApAGpIFgtF9jHdCJGiZUpQVNaNmr4JoTHvnO7UqJQutEhd43nJNpEFpk9Qx6
	 G1wkBy/EVab/qZLM8qQre7NHquQHoY+t/2gxt7rlmOlI0XVEsVPAUAXplMlFtpcJ8iYg6
	 lt2JSG8NpPHwpGu6Ud110nk3KwVQf6E5rKeialp1ik7+aas8HjCIe/xZnehFD3FidLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794545039;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=P1zoroDZUX0N/IAg4LoKGLSJdwHrid7dKsV/IJvimUM=;
	b=PyLu0PoDPeyUSnpNGzexBa/bS5j9ryUtPBR4omo9+6/SKydz3DSS6sWRDmftiVoIRhEk
	 mf1fIwFhJEEvKYVPVaujGAvKRoC2YbcUgVVF0qhMmFPJ7NT1vH5JOXZzPCz5jRg9hC0X+
	 l/7Y0hnFtCggAyu/5llpfrDazK1kGaslQgRvhWgbWRPncbe2Vlw+IAWBeidrU3ZNCxOIQ
	 XAMlyNzVEjuF5eczYeEjbW3bQJ5yU1OhMTF61+jLWkR3NKGbCk36LWpxj+YqkutSbKJX7
	 NRPpF03VpP2UUya38pOYUW+s34Ii8O79rglRFLi5IROEfIzUCSDx4ZYDxUqRtAVo09Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="i3hUod/f";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DDB606A8A2;
	Fri, 13 Nov 2026 04:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i3hUod/f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832491F000C8;
	Fri, 13 Nov 2026 04:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794545038;
	bh=P1zoroDZUX0N/IAg4LoKGLSJdwHrid7dKsV/IJvimUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i3hUod/fJSa3pjwWoUYJ82Qy+sj9ZcPlaSWWeRGuUqMLd2te0AtRgESN9agiswnOF
	 WZ3NZvHZlCtgCDHkOFmMNFvWdaesriq8BJk3VNEeLv5gngdqttA5biXQWQ5vc57ecR
	 P5i1QUu+ROUAwrSky+wjrSQdYzZ6lFdvpwaFxiifCoihWRxIfOgNQ6hqgYlXtkGryh
	 2Dycyo0cnBzKJLINjQDiX6FyYH5yrLcR+cvSqzhB6Acsw+wNuW+zWsh0svsh6UVeNe
	 MaWQSI9eMcTfcrBJc6Rh4s0dsybFaoC7jYa8esIS7s6ejpQFjHBOhJFe01gfrB6pd3
	 3fZuAicT58P0w==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v12 05/12] net/rds: split connection destroy into quiesce and kref-governed free
Date: Thu, 12 Nov 2026 21:43:48 -0700
Message-ID: <20261113044355.2932029-6-achender@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261113044355.2932029-1-achender@kernel.org>
References: <20261113044355.2932029-1-achender@kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
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
rds_loop_kill_conns()), and the following patches deliberately let a
connection outlive the call.

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
- Export rds_conn_get()/rds_conn_put(), plus an inline
  rds_conn_get_unless_zero() for holders that may find a connection
  already on its way out, for the reference holders introduced in the
  following patches.

rds_conn_destroy() also gains a first-caller-wins guard on the new
c_destroy_in_prog flag.  No caller in this tree hands a connection to
rds_conn_destroy() twice - every teardown sweep unlinks or claims its
node before the destroy - so the guard documents the contract rather
than closing a path: a second caller returns at once, without
quiescing anything and without waiting for the first.  With the
initial reference the only one, it is inert here either way.

With no additional reference holders yet, this only sets up the
refcounting framework and is functionally equivalent to the current
code (the initial reference is the only one), so every free still
completes inside rds_conn_destroy().  The next two patches make a
deferred free safe - the transport unload wait and the unlinking of
the transport nodes ahead of the destroy - and only then do the
patches that follow take references at the places that today rely on
bare pointers.

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
 net/rds/connection.c | 99 ++++++++++++++++++++++++++++++++++++--------
 net/rds/rds.h        | 19 ++++++++-
 2 files changed, 98 insertions(+), 20 deletions(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index 97d470242d0f..258a6bc3c573 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -231,6 +231,7 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 		goto out;
 	}
 
+	kref_init(&conn->c_refcount);
 	INIT_HLIST_NODE(&conn->c_hash_node);
 	conn->c_laddr = *laddr;
 	conn->c_isv6 = !ipv6_addr_v4mapped(laddr);
@@ -477,9 +478,10 @@ void rds_conn_shutdown(struct rds_conn_path *cp)
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
@@ -526,10 +528,12 @@ void rds_conn_shutdown(struct rds_conn_path *cp)
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
 
@@ -558,6 +562,16 @@ static void rds_conn_path_destroy(struct rds_conn_path *cp)
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
@@ -567,16 +581,55 @@ static void rds_conn_path_destroy(struct rds_conn_path *cp)
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
+ * initial reference.  Only the first call for a connection does any
+ * of that: a later one finds c_destroy_in_prog already set and
+ * returns at once, without waiting for the first.  The memory -
+ * including the transport's per-connection state and the path
+ * workqueues - is freed once the last rds_conn_put() runs, which may
+ * be after this returns.
  */
 void rds_conn_destroy(struct rds_connection *conn)
 {
-	unsigned long flags;
 	int i;
 	struct rds_conn_path *cp;
 	int npaths = (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
@@ -591,11 +644,23 @@ void rds_conn_destroy(struct rds_connection *conn)
 	 * bar the exemptions noted at c_destroy_in_prog) from queueing
 	 * new work on the path workqueues once we start cancelling and
 	 * destroying them.
+	 *
+	 * Only the first caller proceeds.  No caller in this tree hands
+	 * a connection to rds_conn_destroy() twice - every teardown
+	 * sweep unlinks or claims its node before the destroy - so this
+	 * documents the contract rather than closing a path: a second
+	 * caller returns at once, without quiescing or waiting.  The
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
@@ -603,7 +668,7 @@ void rds_conn_destroy(struct rds_connection *conn)
 	/* shut the connection down */
 	for (i = 0; i < npaths; i++) {
 		cp = &conn->c_path[i];
-		rds_conn_path_destroy(cp);
+		rds_conn_path_quiesce(cp);
 		BUG_ON(!list_empty(&cp->cp_retrans));
 	}
 
@@ -614,12 +679,10 @@ void rds_conn_destroy(struct rds_connection *conn)
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
index 7e0364fe7b56..6cc5ea183491 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -137,6 +137,12 @@ struct rds_conn_path {
 /* One rds_connection per RDS address pair */
 struct rds_connection {
 	struct hlist_node	c_hash_node;
+	/* rds_conn_destroy() quiesces the connection synchronously;
+	 * freeing it - the connection memory, the path workqueues and
+	 * the transport's per-connection state - is deferred until the
+	 * last reference is dropped via rds_conn_put().
+	 */
+	struct kref		c_refcount;
 	struct in6_addr		c_laddr;
 	struct in6_addr		c_faddr;
 	int			c_dev_if; /* ifindex used for this conn */
@@ -147,8 +153,10 @@ struct rds_connection {
 				c_pad_to_32:29;
 	int			c_npaths;
 	bool			c_with_sport_idx;
-	/* Set once, by rds_conn_destroy(), before it cancels the path
-	 * works; read through rds_destroy_pending().  A site that arms
+	/* Set once, by rds_conn_destroy() under rds_conn_lock - a
+	 * test-and-set, so a second destroy of the same connection
+	 * returns at once - before it cancels the path works.  Read
+	 * through rds_destroy_pending().  A site that arms
 	 * a path work must test the predicate and queue the work inside
 	 * one rcu_read_lock() section: the synchronize_rcu() that
 	 * follows the store is what keeps a queue issued after the
@@ -833,6 +841,13 @@ struct rds_connection *rds_conn_create_outgoing(struct net *net,
 						u8 tos, gfp_t gfp, int dev_if);
 void rds_conn_shutdown(struct rds_conn_path *cpath);
 void rds_conn_destroy(struct rds_connection *conn);
+void rds_conn_get(struct rds_connection *conn);
+void rds_conn_put(struct rds_connection *conn);
+/* take a reference unless the connection is already being freed */
+static inline bool rds_conn_get_unless_zero(struct rds_connection *conn)
+{
+	return kref_get_unless_zero(&conn->c_refcount);
+}
 void rds_conn_drop(struct rds_connection *conn);
 void rds_conn_path_drop(struct rds_conn_path *cpath, bool destroy);
 void rds_conn_connect_if_down(struct rds_connection *conn);
-- 
2.50.1

