Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF70486B9B;
	Thu, 17 Sep 2026 07:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789630805; cv=none; b=WKGOY0eAotV5N1HGNxSG5CN9n1GPPdJkfF5dMt8IWpAn96+Laj/t048oiToiCZxHY4DtnLrFAoZo/pUVW5lurknwXQeALq6EUgad+mOifXOOF66G2d+y3RvczKJ/XeDolJeZRk7KX8NqKqJU17N6MzYXrLHObflUnINbcG1ATgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789630805; c=relaxed/simple;
	bh=kr8q6tcBPY5sFUdKkLvyilrz2zoiybb8Kzt3IVzrif8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RlstmLQ3HUQgPGnLRddvzz8DtdhXNC3BOnwIVjnQ8ifQfXgXYZ6afy+Si5AeUZ3OFGIssfrYYHzZJtUJMTMxkHphXUOXLios1/HFrVVMQe04B0lESYEQSwBsbL3aMVJt+uv1OOavqcdtlpc8VgPP7B1PvQIjt/I68FKiPV1C8SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HToBvVH9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HToBvVH9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06DA1F00893;
	Thu, 17 Sep 2026 07:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789630803;
	bh=VxikyXGg0YJnEoMD+wPHP+HacGA2KK/mIQ4nKdFj0yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HToBvVH9bffCSmKEtdNyl7qHSN9RT0KuYFzpt3dxFVwxknPXnXJNEbOQgrgQTpmQ5
	 HqQ47xuq5bhn/wgxi/bnIxnFykuco44fNGBobJ0glfWdbFwMBOCnMQ7ArqiQJ0FVRI
	 N+1HRVpRFnXuKpyuqsq5aDKQTsi0Q+bt4ZmTIRnLH+XPJA9gla61B13R4thnamB2bd
	 pSmqzHILAN0QYUDLvygmO5hrrk3DPnu/Xus48WxF7bbBa+ug5j1GQArpU2Sad9zy4z
	 OjiIjx2tPdxoxjDv8vgzIzD23JuQ8D3B979dZrYHKbpSrCk06Oi1mSVWCf1l2Wj82P
	 Hz4bHETCFxx+A==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	nicoyip.dev@gmail.com
Subject: [PATCH net-next v4 07/12] net/rds: unlink transport nodes before a possibly deferred connection free
Date: Thu, 17 Sep 2026 00:39:53 -0700
Message-Id: <20260917073958.174056-8-achender@kernel.org>
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

The transport teardown helpers - rds_tcp_destroy_conns(),
rds_tcp_kill_sock(), rds_ib_destroy_nodev_conns(), rds_loop_exit() and
rds_loop_kill_conns() - gather the per-connection transport nodes onto
a list head on their own stack and call rds_conn_destroy() for each.
The node is unlinked much later, by the transport's conn_free():
rds_tcp_conn_free() and rds_loop_conn_free() list_del() it, and
rds_ib_conn_free() does so unconditionally.

That is fine for as long as rds_conn_destroy() frees the connection
before it returns, which is still the case at this point in the
series: the initial reference is the only one.  The following patches
hand out references that outlive the teardown loop - a socket's
cached rs_conn, an inc parked on a receive queue - and with those, a
conn_free() deferred until after the helper has returned would
list_del() the node from a stack frame that no longer exists.  Make
the helpers ready for that first.

Unlink each node under the transport lock right before its
rds_conn_destroy(), so that nothing is left on the stack list for a
later free to touch.  TCP marks the node detached, as
rds_tcp_kill_sock() already does for the secondary paths of a
multipath connection; IB and loopback use list_del_init() and have
their conn_free() skip a node that is already empty.  The two IB list
movers, rds_ib_add_conn() and rds_ib_remove_conn(), likewise leave an
already-unlinked node alone instead of asserting that it is linked: a
connect or shutdown worker can still be running for a connection the
sweep has just unlinked, and such a connection is about to be
destroyed anyway.  rds_ib_add_conn() also loses its assertion that the
nodev list is non-empty, which is not true while a sweep holds the
entries.

The walk itself must not lose the entries either.  A connection that
was destroyed earlier - dropped for a protocol version mismatch, then
found again at module unload - is kept alive only by whatever
reference is still pending, and that can be dropped at any point
during the walk, freeing the transport node the iterator is about to
read.  So the gather takes a reference on each connection it moves
onto the stack list, under the transport lock, and drops it after the
destroy; a connection whose free is already running gets no reference
and is left where it is, since that free unlinks the node itself once
the lock is released.  The tmp_list gathering itself remains: it is
what keeps rds_conn_destroy() from being called with the transport
lock held.

Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/ib_cm.c   |  4 ++-
 net/rds/ib_rdma.c | 65 ++++++++++++++++++++++++++++++++++++-----------
 net/rds/loop.c    | 59 +++++++++++++++++++++++++++++++++---------
 net/rds/tcp.c     | 52 ++++++++++++++++++++++++++++++++-----
 4 files changed, 146 insertions(+), 34 deletions(-)

diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 118e033229aa..26a32c1ec8f7 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -1287,7 +1287,9 @@ void rds_ib_conn_free(void *arg)
 	lock_ptr = ic->rds_ibdev ? &ic->rds_ibdev->spinlock : &ib_nodev_conns_lock;
 
 	spin_lock_irqsave(lock_ptr, flags);
-	list_del(&ic->ib_node);
+	/* already unlinked if a transport teardown gathered us first */
+	if (!list_empty(&ic->ib_node))
+		list_del(&ic->ib_node);
 	spin_unlock_irqrestore(lock_ptr, flags);
 
 	rds_ib_recv_free_caches(ic);
diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
index a9b27f06cbfc..bdd66c9b93c7 100644
--- a/net/rds/ib_rdma.c
+++ b/net/rds/ib_rdma.c
@@ -123,15 +123,18 @@ void rds_ib_add_conn(struct rds_ib_device *rds_ibdev, struct rds_connection *con
 {
 	struct rds_ib_connection *ic = conn->c_transport_data;
 
-	/* conn was previously on the nodev_conns_list */
+	/* conn was previously on the nodev_conns_list, unless a teardown
+	 * sweep already unlinked it ahead of destroying it: then it is
+	 * on its way out and stays off every list.
+	 */
 	spin_lock_irq(&ib_nodev_conns_lock);
-	BUG_ON(list_empty(&ib_nodev_conns));
-	BUG_ON(list_empty(&ic->ib_node));
-	list_del(&ic->ib_node);
+	if (!list_empty(&ic->ib_node)) {
+		list_del(&ic->ib_node);
 
-	spin_lock(&rds_ibdev->spinlock);
-	list_add_tail(&ic->ib_node, &rds_ibdev->conn_list);
-	spin_unlock(&rds_ibdev->spinlock);
+		spin_lock(&rds_ibdev->spinlock);
+		list_add_tail(&ic->ib_node, &rds_ibdev->conn_list);
+		spin_unlock(&rds_ibdev->spinlock);
+	}
 	spin_unlock_irq(&ib_nodev_conns_lock);
 
 	ic->rds_ibdev = rds_ibdev;
@@ -142,15 +145,22 @@ void rds_ib_remove_conn(struct rds_ib_device *rds_ibdev, struct rds_connection *
 {
 	struct rds_ib_connection *ic = conn->c_transport_data;
 
-	/* place conn on nodev_conns_list */
+	bool detached;
+
+	/* place conn on nodev_conns_list - unless a teardown sweep
+	 * already unlinked it ahead of destroying it, in which case it
+	 * stays off every list
+	 */
 	spin_lock(&ib_nodev_conns_lock);
 
 	spin_lock_irq(&rds_ibdev->spinlock);
-	BUG_ON(list_empty(&ic->ib_node));
-	list_del(&ic->ib_node);
+	detached = list_empty(&ic->ib_node);
+	if (!detached)
+		list_del(&ic->ib_node);
 	spin_unlock_irq(&rds_ibdev->spinlock);
 
-	list_add_tail(&ic->ib_node, &ib_nodev_conns);
+	if (!detached)
+		list_add_tail(&ic->ib_node, &ib_nodev_conns);
 
 	spin_unlock(&ib_nodev_conns_lock);
 
@@ -163,13 +173,38 @@ void rds_ib_destroy_nodev_conns(void)
 	struct rds_ib_connection *ic, *_ic;
 	LIST_HEAD(tmp_list);
 
-	/* avoid calling conn_destroy with irqs off */
+	struct rds_connection *conn;
+
+	/* Gather the connections and take a reference on each, so that
+	 * none is freed under the walk below (a connection destroyed
+	 * earlier, for a protocol version mismatch, can be on this list
+	 * with only a socket's reference still pending).  One whose free
+	 * is already running gets no reference: its free unlinks the
+	 * node itself, under this lock, once we drop it.  Avoid calling
+	 * conn_destroy with irqs off.
+	 */
 	spin_lock_irq(&ib_nodev_conns_lock);
-	list_splice_init(&ib_nodev_conns, &tmp_list);
+	list_for_each_entry_safe(ic, _ic, &ib_nodev_conns, ib_node) {
+		if (rds_conn_get_unless_zero(ic->conn))
+			list_move_tail(&ic->ib_node, &tmp_list);
+	}
 	spin_unlock_irq(&ib_nodev_conns_lock);
 
-	list_for_each_entry_safe(ic, _ic, &tmp_list, ib_node)
-		rds_conn_destroy(ic->conn);
+	/* rds_conn_destroy() can return before the connection is freed,
+	 * and it is the free - rds_ib_conn_free() - that unlinks ib_node.
+	 * tmp_list lives on this stack frame, so unlink each node before
+	 * its destroy; the free then finds it empty and leaves it alone.
+	 */
+	list_for_each_entry_safe(ic, _ic, &tmp_list, ib_node) {
+		conn = ic->conn;
+
+		spin_lock_irq(&ib_nodev_conns_lock);
+		list_del_init(&ic->ib_node);
+		spin_unlock_irq(&ib_nodev_conns_lock);
+
+		rds_conn_destroy(conn);
+		rds_conn_put(conn);
+	}
 }
 
 void rds_ib_get_mr_info(struct rds_ib_device *rds_ibdev, struct rds_info_rdma_connection *iinfo)
diff --git a/net/rds/loop.c b/net/rds/loop.c
index fd774f8080d0..71f760ccd458 100644
--- a/net/rds/loop.c
+++ b/net/rds/loop.c
@@ -156,6 +156,45 @@ static int rds_loop_conn_alloc(struct rds_connection *conn, gfp_t gfp)
 	return 0;
 }
 
+/* Destroy the connections whose nodes were gathered on @tmp_list.
+ *
+ * rds_conn_destroy() can return before the connection is freed, and
+ * it is the free - rds_loop_conn_free() - that unlinks loop_node.
+ * @tmp_list lives on the caller's stack, so unlink each node before
+ * its destroy; the free then finds it empty and leaves it alone.
+ */
+static void rds_loop_destroy_gathered_conns(struct list_head *tmp_list)
+{
+	struct rds_loop_connection *lc, *_lc;
+	struct rds_connection *conn;
+
+	list_for_each_entry_safe(lc, _lc, tmp_list, loop_node) {
+		conn = lc->conn;
+		WARN_ON(conn->c_passive);
+
+		spin_lock_irq(&loop_conns_lock);
+		list_del_init(&lc->loop_node);
+		spin_unlock_irq(&loop_conns_lock);
+
+		rds_conn_destroy(conn);
+		rds_conn_put(conn);
+	}
+}
+
+/* Gather @lc's connection for destruction: move the node to the
+ * caller's @tmp_list and take a reference that keeps the connection,
+ * and so the node, alive until rds_loop_destroy_gathered_conns() has
+ * dealt with it.  Called with loop_conns_lock held.  A connection
+ * whose free is already running gets no reference; its free unlinks
+ * the node itself, under the same lock, once we drop it.
+ */
+static void rds_loop_gather_conn(struct rds_loop_connection *lc,
+				 struct list_head *tmp_list)
+{
+	if (rds_conn_get_unless_zero(lc->conn))
+		list_move_tail(&lc->loop_node, tmp_list);
+}
+
 static void rds_loop_conn_free(void *arg)
 {
 	struct rds_loop_connection *lc = arg;
@@ -163,7 +202,9 @@ static void rds_loop_conn_free(void *arg)
 
 	rdsdebug("lc %p\n", lc);
 	spin_lock_irqsave(&loop_conns_lock, flags);
-	list_del(&lc->loop_node);
+	/* already unlinked if a transport teardown gathered us first */
+	if (!list_empty(&lc->loop_node))
+		list_del(&lc->loop_node);
 	spin_unlock_irqrestore(&loop_conns_lock, flags);
 	kfree(lc);
 }
@@ -187,14 +228,11 @@ void rds_loop_exit(void)
 	synchronize_rcu();
 	/* avoid calling conn_destroy with irqs off */
 	spin_lock_irq(&loop_conns_lock);
-	list_splice(&loop_conns, &tmp_list);
-	INIT_LIST_HEAD(&loop_conns);
+	list_for_each_entry_safe(lc, _lc, &loop_conns, loop_node)
+		rds_loop_gather_conn(lc, &tmp_list);
 	spin_unlock_irq(&loop_conns_lock);
 
-	list_for_each_entry_safe(lc, _lc, &tmp_list, loop_node) {
-		WARN_ON(lc->conn->c_passive);
-		rds_conn_destroy(lc->conn);
-	}
+	rds_loop_destroy_gathered_conns(&tmp_list);
 
 	rds_conn_wait_conns_freed(&rds_loop_transport, NULL);
 }
@@ -210,14 +248,11 @@ static void rds_loop_kill_conns(struct net *net)
 
 		if (net != c_net)
 			continue;
-		list_move_tail(&lc->loop_node, &tmp_list);
+		rds_loop_gather_conn(lc, &tmp_list);
 	}
 	spin_unlock_irq(&loop_conns_lock);
 
-	list_for_each_entry_safe(lc, _lc, &tmp_list, loop_node) {
-		WARN_ON(lc->conn->c_passive);
-		rds_conn_destroy(lc->conn);
-	}
+	rds_loop_destroy_gathered_conns(&tmp_list);
 }
 
 static void __net_exit rds_loop_exit_net(struct net *net)
diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 826e4629e4ee..552b32278e30 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -502,6 +502,48 @@ static bool rds_tcp_is_unloading(struct rds_connection *conn)
 	return atomic_read(&rds_tcp_unloading) != 0;
 }
 
+/* Gather @tc's connection for destruction: move the node to the
+ * caller's @tmp_list and take a reference that keeps the connection,
+ * and so the node, alive until rds_tcp_destroy_gathered_conns() has
+ * dealt with it.  Called with rds_tcp_conn_lock held.  A connection
+ * whose free is already running gets no reference; its free unlinks
+ * the node itself, under the same lock, once we drop it.
+ */
+static void rds_tcp_gather_conn(struct rds_tcp_connection *tc,
+				struct list_head *tmp_list)
+{
+	if (rds_conn_get_unless_zero(tc->t_cpath->cp_conn))
+		list_move_tail(&tc->t_tcp_node, tmp_list);
+}
+
+/* Destroy the connections whose nodes were gathered on @tmp_list.
+ *
+ * rds_conn_destroy() can return before the connection is freed, and
+ * it is the free - rds_tcp_conn_free() - that unlinks t_tcp_node.
+ * Since @tmp_list lives on the caller's stack, unlink each node here
+ * and mark it detached before its destroy, so that a free that runs
+ * after the caller has returned does not write into a dead frame.
+ * Every entry holds a reference taken by rds_tcp_gather_conn(), so
+ * none can be freed under the walk; each is dropped after its destroy.
+ */
+static void rds_tcp_destroy_gathered_conns(struct list_head *tmp_list)
+{
+	struct rds_tcp_connection *tc, *_tc;
+	struct rds_connection *conn;
+
+	list_for_each_entry_safe(tc, _tc, tmp_list, t_tcp_node) {
+		conn = tc->t_cpath->cp_conn;
+
+		spin_lock_irq(&rds_tcp_conn_lock);
+		list_del_init(&tc->t_tcp_node);
+		tc->t_tcp_node_detached = true;
+		spin_unlock_irq(&rds_tcp_conn_lock);
+
+		rds_conn_destroy(conn);
+		rds_conn_put(conn);
+	}
+}
+
 static void rds_tcp_destroy_conns(void)
 {
 	struct rds_tcp_connection *tc, *_tc;
@@ -511,12 +553,11 @@ static void rds_tcp_destroy_conns(void)
 	spin_lock_irq(&rds_tcp_conn_lock);
 	list_for_each_entry_safe(tc, _tc, &rds_tcp_conn_list, t_tcp_node) {
 		if (!list_has_conn(&tmp_list, tc->t_cpath->cp_conn))
-			list_move_tail(&tc->t_tcp_node, &tmp_list);
+			rds_tcp_gather_conn(tc, &tmp_list);
 	}
 	spin_unlock_irq(&rds_tcp_conn_lock);
 
-	list_for_each_entry_safe(tc, _tc, &tmp_list, t_tcp_node)
-		rds_conn_destroy(tc->t_cpath->cp_conn);
+	rds_tcp_destroy_gathered_conns(&tmp_list);
 }
 
 static void rds_tcp_exit(void);
@@ -691,15 +732,14 @@ static void rds_tcp_kill_sock(struct net *net)
 		if (net != c_net)
 			continue;
 		if (!list_has_conn(&tmp_list, tc->t_cpath->cp_conn)) {
-			list_move_tail(&tc->t_tcp_node, &tmp_list);
+			rds_tcp_gather_conn(tc, &tmp_list);
 		} else {
 			list_del(&tc->t_tcp_node);
 			tc->t_tcp_node_detached = true;
 		}
 	}
 	spin_unlock_irq(&rds_tcp_conn_lock);
-	list_for_each_entry_safe(tc, _tc, &tmp_list, t_tcp_node)
-		rds_conn_destroy(tc->t_cpath->cp_conn);
+	rds_tcp_destroy_gathered_conns(&tmp_list);
 }
 
 static void __net_exit rds_tcp_exit_net(struct net *net)
-- 
2.25.1

