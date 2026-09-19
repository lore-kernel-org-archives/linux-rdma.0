Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D9C37F74A;
	Sat, 19 Sep 2026 06:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789798316; cv=none; b=RfH75PHsvdT5qQDj5cwwMBnb/N2hzRn8Qo1QiVTPu94FosLkfzHpsZB58avkSRErlPadUqk6Xa8oV885qJhsvzHTSWZydpmbP7uPbCwB+Ey5Tvy/oz/fwHVl++LCznWsdWWlHOSl8F8NQJLW8yJpYz6i4C4fcyncZ1F1TSCRiEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789798316; c=relaxed/simple;
	bh=gj94KulXleEoOIjqVj+ZGxtd+PVtXKZR5Ah2kGc0bjY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LIIVoEhweZ2I5m//jH5hGCorNVH/nv22Nk+Tkkw8nW2F0j90eM+D6MYOwJj7PWT12hvM/iYRTS7FuDBjkQfQAwZ43LJG9a4eQHqPoLZBDBaIZQTkdSxzphA72kF9l2sxBZrBgbkF+IiruK96lLdutb9PU8U1hbtzsJUIY2kq5V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YPm3P7j3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YPm3P7j3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECBF1F0089D;
	Sat, 19 Sep 2026 06:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789798314;
	bh=miTI67Xl/O99hsGWwDUtVmCRi2ra8zhKasrmOCRuGJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YPm3P7j3WSnF5Iw5sdVpGc2KbR4aJ5Vp1edTbYeuD8t3UUj9zpyjdZ73a5iPEbKf+
	 oanPN3EAqxvAIGHqufu3QX1uGvfSvgRS0hR+ELR0mKDnF6rH5yzJun/cRuVUIgey4B
	 29EIhvBAY1DEaOTwHcI7e9A4yD5Fop7Bj/Iu+lHOjfE061KxqxzANg8DAMaXQ10PE3
	 jnBfs3txAg6LqybSqJjvTyfufw61JfsFqc04o54ogBJVQacLbseISjXmjOWvuK+TJ6
	 3dn3ogYWNllFouUkcGoMuSwKOYQj9V4U/m5DNFy7jAhX45nzVGhpugD9rWz+08UDcN
	 M7pd0aVTYifeQ==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	nicoyip.dev@gmail.com
Subject: [PATCH net-next v5 07/12] net/rds: unlink transport nodes before a possibly deferred connection free
Date: Fri, 18 Sep 2026 23:11:44 -0700
Message-Id: <20260919061149.250658-8-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260919061149.250658-1-achender@kernel.org>
References: <20260919061149.250658-1-achender@kernel.org>
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
multipath connection; loopback uses list_del_init() and has its
conn_free() skip a node that is already empty.

IB needs an explicit flag, i_ib_node_detached, because its node has
other movers: a connect worker moves it from the nodev list to a
device's list in rds_ib_add_conn(), and a shutdown moves it back in
rds_ib_remove_conn().  Either can run while the sweep holds the node
on its stack list, and "the node is linked" cannot tell that list
from the nodev list - an add_conn() that went by list emptiness would
unlink the node from under the sweep's lockless walk.  So the sweep
sets the flag when it gathers the node, under ib_nodev_conns_lock,
and from then on add_conn(), remove_conn() and conn_free() leave the
node alone; the node belongs to the sweep, and its walk needs no
lock.  Those movers used to assert that the node is linked (and
rds_ib_add_conn() that the nodev list is non-empty); a connect or
shutdown worker can still be running for a connection the sweep has
claimed, and such a connection is about to be destroyed anyway, so
the assertions go.

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
 net/rds/ib.h      |  4 +++
 net/rds/ib_cm.c   |  4 ++-
 net/rds/ib_rdma.c | 67 ++++++++++++++++++++++++++++++++++++-----------
 net/rds/loop.c    | 59 ++++++++++++++++++++++++++++++++---------
 net/rds/tcp.c     | 52 +++++++++++++++++++++++++++++++-----
 5 files changed, 152 insertions(+), 34 deletions(-)

diff --git a/net/rds/ib.h b/net/rds/ib.h
index 5ff346a1e8ba..cb410c3ae8d8 100644
--- a/net/rds/ib.h
+++ b/net/rds/ib.h
@@ -143,6 +143,10 @@ struct rds_ib_device;
 struct rds_ib_connection {
 
 	struct list_head	ib_node;
+	/* set under ib_nodev_conns_lock once a transport teardown has
+	 * claimed ib_node; from then on only the teardown touches it
+	 */
+	bool			i_ib_node_detached;
 	struct rds_ib_device	*rds_ibdev;
 	struct rds_connection	*conn;
 
diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 118e033229aa..ccb7e2b93ff5 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -1287,7 +1287,9 @@ void rds_ib_conn_free(void *arg)
 	lock_ptr = ic->rds_ibdev ? &ic->rds_ibdev->spinlock : &ib_nodev_conns_lock;
 
 	spin_lock_irqsave(lock_ptr, flags);
-	list_del(&ic->ib_node);
+	/* a transport teardown that gathered us first owns the node */
+	if (!ic->i_ib_node_detached)
+		list_del(&ic->ib_node);
 	spin_unlock_irqrestore(lock_ptr, flags);
 
 	rds_ib_recv_free_caches(ic);
diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
index a9b27f06cbfc..1548e5be0e55 100644
--- a/net/rds/ib_rdma.c
+++ b/net/rds/ib_rdma.c
@@ -123,15 +123,18 @@ void rds_ib_add_conn(struct rds_ib_device *rds_ibdev, struct rds_connection *con
 {
 	struct rds_ib_connection *ic = conn->c_transport_data;
 
-	/* conn was previously on the nodev_conns_list */
+	/* conn was previously on the nodev_conns_list, unless a teardown
+	 * sweep has claimed it ahead of destroying it: then it is on its
+	 * way out, and its node belongs to the sweep.
+	 */
 	spin_lock_irq(&ib_nodev_conns_lock);
-	BUG_ON(list_empty(&ib_nodev_conns));
-	BUG_ON(list_empty(&ic->ib_node));
-	list_del(&ic->ib_node);
+	if (!ic->i_ib_node_detached) {
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
+	/* place conn on nodev_conns_list - unless a teardown sweep has
+	 * claimed it ahead of destroying it, in which case its node
+	 * belongs to the sweep
+	 */
 	spin_lock(&ib_nodev_conns_lock);
 
 	spin_lock_irq(&rds_ibdev->spinlock);
-	BUG_ON(list_empty(&ic->ib_node));
-	list_del(&ic->ib_node);
+	detached = ic->i_ib_node_detached;
+	if (!detached)
+		list_del(&ic->ib_node);
 	spin_unlock_irq(&rds_ibdev->spinlock);
 
-	list_add_tail(&ic->ib_node, &ib_nodev_conns);
+	if (!detached)
+		list_add_tail(&ic->ib_node, &ib_nodev_conns);
 
 	spin_unlock(&ib_nodev_conns_lock);
 
@@ -163,13 +173,40 @@ void rds_ib_destroy_nodev_conns(void)
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
+	 * node itself, under this lock, once we drop it.  Marking the
+	 * node detached claims it for this sweep: rds_ib_add_conn(),
+	 * rds_ib_remove_conn() and rds_ib_conn_free() leave a claimed
+	 * node alone, so the walk over tmp_list below needs no lock.
+	 * Avoid calling conn_destroy with irqs off.
+	 */
 	spin_lock_irq(&ib_nodev_conns_lock);
-	list_splice_init(&ib_nodev_conns, &tmp_list);
+	list_for_each_entry_safe(ic, _ic, &ib_nodev_conns, ib_node) {
+		if (rds_conn_get_unless_zero(ic->conn)) {
+			ic->i_ib_node_detached = true;
+			list_move_tail(&ic->ib_node, &tmp_list);
+		}
+	}
 	spin_unlock_irq(&ib_nodev_conns_lock);
 
-	list_for_each_entry_safe(ic, _ic, &tmp_list, ib_node)
-		rds_conn_destroy(ic->conn);
+	/* rds_conn_destroy() can return before the connection is freed,
+	 * and it is the free - rds_ib_conn_free() - that would unlink
+	 * ib_node.  tmp_list lives on this stack frame, so take each node
+	 * off it before its destroy; the free then leaves it alone.
+	 */
+	list_for_each_entry_safe(ic, _ic, &tmp_list, ib_node) {
+		conn = ic->conn;
+		list_del_init(&ic->ib_node);
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

