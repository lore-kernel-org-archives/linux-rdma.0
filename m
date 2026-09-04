Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EC642901E;
	Fri,  4 Sep 2026 07:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788505374; cv=none; b=WkozKp9Yg6r/ShFYkibV/CryxNlQfHVKFjHAC6S/XG9/t3WYTtToyS6QsXuqWLF6KxSFYBfs4AvmVk9ohmXXtlbLtqYWDY60odE7IwIeKMatpqTZEf52VkmIbgEtrCZSN1yKF3iXeoccfFqnTs480MqhvfSU0MAP2teJaH8OKfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788505374; c=relaxed/simple;
	bh=NN7iV52+WExGXCg6opKMiH0OytlQoHQmmWrehQYXPqI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SeRumQ1IgGCiNAx6hRHzmLt/q92pLo+DU7lmkardmlWmL6taAbQEqT9yxAsejSsJ86OrN7jIB3zqIVTMxr4oMPdiJxx7sM9YX2MLv+YOOoNnE69OWZ+mIwy8ktGKZZ7CUylFNQ+m/Q85wkdfG1q/NY65QR94J01dFjHG97V9s24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YPAuxJt1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YPAuxJt1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3D21F00A3F;
	Fri,  4 Sep 2026 07:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788505372;
	bh=6TV3CVIz5UHZdENWmeAw5qwbL2/jU+NXUdTeQcf4Zw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YPAuxJt1dip0u3PZuFKaWqjN+jXehgabS+zTR3oiyM81vYfcL3WfC1VHsKkro8xLd
	 IUUiazVk511NQh9A2YG42yp1u63Kvai4R+cxul9Li+Qa8BKkRRrq7S28TNywycHkaD
	 1aCEmGLfigQbgKk8sq6CTMTBrIwiwHdJU4nJBwQZLA8rjeERQBvEP8JgY+X7BdrxLL
	 7xicydlmP6zMpX1C33Ehvy6ekrVD2kkCQ3Y0IAJSIsK6N+YN9VpTQBeXYD5k6lhoS7
	 JHPaEJ5QJpFmT8akJ4Vuyo9aVziwQUG0q8U9RRR7oBx7RWwqE3bCHpmd5r2zN0de87
	 M2ufsXrRC7w7A==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	nicoyip.dev@gmail.com
Subject: [PATCH net-next 4/6] net/rds: wait for connections to be freed on transport unload
Date: Fri,  4 Sep 2026 00:02:46 -0700
Message-Id: <20260904070248.160384-5-achender@kernel.org>
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

Since connection free became asynchronous, rds_conn_destroy() only
quiesces the connection; the actual free - including the transport's
conn_free, which lives in the transport module - runs when the last
reference is dropped.  The transports' exit paths destroy all of
their connections and then proceed to unload, so a free that is still
pending (a racing lookup-style holder, or simply the destroyer's own
put not yet run when destroy was invoked from another context earlier)
would execute transport module code after that module's text is gone.

Count each transport's live connections in t_conn_count (incremented
when a connection is published in __rds_conn_create(), decremented as
the last step of rds_conn_destroy_fini()) and make the transport exit
paths - rds_ib_exit(), rds_tcp_exit() and rds_loop_exit() - wait for
the count to drop to zero after destroying their connections.

Sockets cannot keep the count elevated here: a bound socket holds a
module reference on its transport (rds_trans_get_preferred()), so a
transport cannot reach its exit path while any socket that could
cache one of its connections in rs_conn still exists.  The remaining
holders are short-lived, hence the bounded wait; if it expires
anyway, warn - the pending frees will touch freed module text.

In rds_ib_exit(), tearing down the last connection can also drop the
final reference on a device, which defers rds_ib_dev_free() - again
this module's text - to rds_wq.  Flush the workqueue once after the
connections are gone; rds_ib_dev_free() queues nothing further on
rds_wq, so a single pass drains it.

Based on Oracle UEK commits ece4b4e39afa ("net/rds: wait_event_timeout
until zero connections during rmmod") and 905ec90e6166 ("net/rds:
Each RDS transport should keep its own connection count").

Signed-off-by: Sharath Srinivasan <sharath.srinivasan@oracle.com>
[achender: reimplementation for net-next: t_conn_count did not exist
 upstream and is introduced here; single global waitqueue instead of
 per-transport (the loop transport never goes through
 rds_trans_register()); also cover rds_loop_exit(); rewrite commit
 message]
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/connection.c | 29 +++++++++++++++++++++++++++++
 net/rds/ib.c         |  9 +++++++++
 net/rds/loop.c       |  2 ++
 net/rds/rds.h        |  9 +++++++++
 net/rds/tcp.c        |  1 +
 5 files changed, 50 insertions(+)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index df26959b0fdc..90d660a45662 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -48,6 +48,8 @@
 /* converting this to RCU is a chore for another day.. */
 static DEFINE_SPINLOCK(rds_conn_lock);
 static unsigned long rds_conn_count;
+/* woken whenever a transport's t_conn_count drops to zero */
+static DECLARE_WAIT_QUEUE_HEAD(rds_conn_freed_waitq);
 static struct hlist_head rds_conn_hash[RDS_CONNECTION_HASH_ENTRIES];
 static struct kmem_cache *rds_conn_slab;
 
@@ -362,6 +364,7 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 			parent->c_passive = conn;
 			rds_cong_add_conn(conn);
 			rds_conn_count++;
+			atomic_inc(&conn->c_trans->t_conn_count);
 		}
 	} else {
 		/* Creating normal conn */
@@ -395,6 +398,7 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 			hlist_add_head_rcu(&conn->c_hash_node, head);
 			rds_cong_add_conn(conn);
 			rds_conn_count++;
+			atomic_inc(&conn->c_trans->t_conn_count);
 		}
 	}
 	spin_unlock_irqrestore(&rds_conn_lock, flags);
@@ -621,6 +625,7 @@ static void rds_conn_destroy_fini(struct kref *kref)
 	struct rds_connection *conn = container_of(kref, struct rds_connection,
 						   c_refcount);
 	int npaths = (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
+	struct rds_transport *trans = conn->c_trans;
 	unsigned long flags;
 	int i;
 
@@ -633,7 +638,31 @@ static void rds_conn_destroy_fini(struct kref *kref)
 	spin_lock_irqsave(&rds_conn_lock, flags);
 	rds_conn_count--;
 	spin_unlock_irqrestore(&rds_conn_lock, flags);
+
+	/* only after everything the transport module owns has been
+	 * freed above may its unload proceed
+	 */
+	if (!atomic_dec_return(&trans->t_conn_count))
+		wake_up_all(&rds_conn_freed_waitq);
+}
+
+/* Wait for all of @trans's connections to be freed; the free runs
+ * asynchronously once rds_conn_destroy() has quiesced a connection.
+ * Called on transport module unload, after the transport destroyed
+ * all of its connections: anything still holding a connection
+ * reference at that point is a short-lived lookup-style holder, so
+ * a bounded wait suffices - but warn if it expires, since the frees
+ * that follow the unload will then touch freed module text.
+ */
+void rds_conn_wait_conns_freed(struct rds_transport *trans)
+{
+	if (!wait_event_timeout(rds_conn_freed_waitq,
+				!atomic_read(&trans->t_conn_count),
+				msecs_to_jiffies(RDS_CONN_FREE_TIMEOUT_MS)))
+		WARN(1, "RDS/%s: %d connection(s) not freed\n",
+		     trans->t_name, atomic_read(&trans->t_conn_count));
 }
+EXPORT_SYMBOL_GPL(rds_conn_wait_conns_freed);
 
 void rds_conn_get(struct rds_connection *conn)
 {
diff --git a/net/rds/ib.c b/net/rds/ib.c
index 9fe3b9951bd3..755690583325 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -538,6 +538,15 @@ void rds_ib_exit(void)
 #endif
 	rds_ib_unregister_client();
 	rds_ib_destroy_nodev_conns();
+	rds_conn_wait_conns_freed(&rds_ib_transport);
+
+	/* Tearing down the last connection may have dropped the final
+	 * reference on a device, deferring rds_ib_dev_free() to rds_wq.
+	 * Drain it before the module goes away; it queues nothing
+	 * further on rds_wq.
+	 */
+	flush_workqueue(rds_wq);
+
 	rds_ib_sysctl_exit();
 	rds_ib_recv_exit();
 	rds_trans_unregister(&rds_ib_transport);
diff --git a/net/rds/loop.c b/net/rds/loop.c
index e6b0750bbeda..7daf8ed25d69 100644
--- a/net/rds/loop.c
+++ b/net/rds/loop.c
@@ -195,6 +195,8 @@ void rds_loop_exit(void)
 		WARN_ON(lc->conn->c_passive);
 		rds_conn_destroy(lc->conn);
 	}
+
+	rds_conn_wait_conns_freed(&rds_loop_transport);
 }
 
 static void rds_loop_kill_conns(struct net *net)
diff --git a/net/rds/rds.h b/net/rds/rds.h
index e27e5e2e3329..35760dd6b077 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -553,6 +553,12 @@ struct rds_transport {
 	unsigned int		t_prefer_loopback:1,
 				t_mp_capable:1;
 	unsigned int		t_type;
+	/* Connections of this transport not yet freed; freeing runs
+	 * asynchronously once rds_conn_destroy() has quiesced a
+	 * connection, so transport module unload has to wait for this
+	 * to reach zero (rds_conn_wait_conns_freed()).
+	 */
+	atomic_t		t_conn_count;
 
 	int (*laddr_check)(struct net *net, const struct in6_addr *addr,
 			   __u32 scope_id);
@@ -830,6 +836,9 @@ void rds_conn_shutdown(struct rds_conn_path *cpath);
 void rds_conn_destroy(struct rds_connection *conn);
 void rds_conn_get(struct rds_connection *conn);
 void rds_conn_put(struct rds_connection *conn);
+/* how long transport unload waits for its connections to be freed */
+#define RDS_CONN_FREE_TIMEOUT_MS	10000
+void rds_conn_wait_conns_freed(struct rds_transport *trans);
 void rds_conn_drop(struct rds_connection *conn);
 void rds_conn_path_drop(struct rds_conn_path *cpath, bool destroy);
 void rds_conn_connect_if_down(struct rds_connection *conn);
diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 774a71f88d37..2685ee21a22d 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -805,6 +805,7 @@ static void rds_tcp_exit(void)
 #endif
 	unregister_pernet_device(&rds_tcp_net_ops);
 	rds_tcp_destroy_conns();
+	rds_conn_wait_conns_freed(&rds_tcp_transport);
 	rds_trans_unregister(&rds_tcp_transport);
 	rds_tcp_recv_exit();
 	kmem_cache_destroy(rds_tcp_conn_slab);
-- 
2.25.1

