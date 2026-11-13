Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794545039;
	b=mfYulEY/q7C9yiAGlHFUF9BsHJ2PAUP2h9JvNyM+e0jY20YAuD8y9dJjYpifQC2/3mCC
	 bSXCDSQBUJI4XWcKZ9xOrkWISNgG+2MdyfegkzER84QzzzVrQ/1rRcRSmSOPsg91o1neI
	 0zBP83kkMLvE2fvNsU4WfUiX2I1ssOeeBwKDEgpAXflteUaqgI4ctRjP8+iw5trvbxHjR
	 5zUH48IYgmrFgDTNLYOFZbX1EAMWEzugzIv8ENcix06CYHHAWmWgESjYW5ycgLQMs+Tyd
	 G1iO1VNJ0eE8zQR6ZJg3voh5N52Le3PaAwE67cZPzUCR7MSD0hf4riOuPkykzgWxoEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794545039;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=8DQ3geqUXPZNrSUwB5xH5fyNFGslHzWx+euxeoT7evc=;
	b=wCCfljglw7Ns/vyBcwINaXHddPHNiJzP69jA/sJMJSnvU1nsvXWyewqW07TLlxx84hzC
	 xFIxDeMsFMiNuRL+8ttN4dMpAKfrDmZwITRGu71fxMop/qdoHNgWmf2iEuthOpoQ+V0fM
	 XjICLzaExN8WVJfmF57yEBrJrm6pleFqwj0NTxsPeLscJN43oeX7VGObXFSNWNWVlrJ1d
	 gILjaiV3pKmB4Pm07aF3aYcV0l7Kc9dm88TFJz+ig9d8s1i3QbXgVsnWAvV960jy+6Xma
	 zSn61+FRN2Rh4FUJafRV9fFgZnjbiC2nmOZUEE+HfxTgyjk5SC/89NlIM79t6edTF0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EJEjKCAG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97754606A8B3;
	Fri, 13 Nov 2026 04:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EJEjKCAG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A301F000C7;
	Fri, 13 Nov 2026 04:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794545039;
	bh=8DQ3geqUXPZNrSUwB5xH5fyNFGslHzWx+euxeoT7evc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EJEjKCAGm4Wgp2sKseWK3OpkjLVwrTukeCMQcbLml/7O27w1PzTO4j8fkYDnC909Y
	 GQRRK1iiOdOpCqKBrLr+pkG8dCgqh/XeQK7E1qlyAdhU80uQ+36Um3k7FKOvNLMzzS
	 6zk9ZRq6lLAs//lOuPRlLE3f6rQhkGz5ZMqlnF8BX1OdcDvCHf3IjAjDT0KTjqU5cq
	 E8jvwO/U90WybVS1fNhWGP8sIhEnsReTiNXt+CA6Wg5xBzxtQA7Or09a4s3XMYM580
	 JN6MrD1ETnblnbz0FPabkZRFN1Br1LliftgzRY+CHRVSNoJ6A8stCEIdCIVAKXHjg3
	 sBEUktsIeEKYA==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v12 06/12] net/rds: unlink transport nodes before a possibly deferred connection free
Date: Thu, 12 Nov 2026 21:43:49 -0700
Message-ID: <20261113044355.2932029-7-achender@kernel.org>
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

The transport teardown helpers - rds_tcp_destroy_conns(),
rds_tcp_kill_sock(), rds_ib_destroy_nodev_conns(), rds_loop_exit() and
rds_loop_kill_conns() - gather the per-connection transport nodes onto
a list head on their own stack and call rds_conn_destroy() for each.
The node is unlinked much later, by the transport's conn_free():
rds_tcp_conn_free() skips a node that rds_tcp_kill_sock() marked
detached, while rds_loop_conn_free() and rds_ib_conn_free() list_del()
it unconditionally.

That is fine for as long as rds_conn_destroy() frees the connection
before it returns, which is still the case at this point in the
series: the initial reference is the only one.  The following patches
hand out references that outlive the teardown loop - a socket's
cached rs_conn, an inc parked on a receive queue - and with those, a
conn_free() deferred until after the helper has returned would
list_del() the node from a stack frame that no longer exists.  Make
the helpers ready for that first.

Unlink each node right before its rds_conn_destroy() - under the
transport lock for TCP and loopback, and off the claimed stack list
for IB - so that nothing is left on the stack list for a later free
to touch.  TCP marks the node detached, as
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
the assertions go, and rds_ib_add_conn() refuses a claimed node the
way it refuses a device that is shutting down, rather than attach a
connection the sweep is destroying.

For IB this also closes a race that exists today.
rds_ib_destroy_nodev_conns() spliced the nodev list onto its stack
without re-initialising the global head, and since commit
4716af3897e9 ("net/rds: Give each connection path its own workqueue")
the shutdown works that rds_ib_dev_shutdown() queues run on the
per-path cp_wq, which the flush_workqueue(rds_wq) in
rds_ib_unregister_client() no longer waits for.  A shutdown finishing
during the sweep links its node through the stale head, which points
into the stack list, so the last entry of that list now points at the
global head and the sweep's lockless walk runs off the end of its
list into it; a connect finishing then could likewise unlink a node
from under the walk.  Gathering entry by entry under
ib_nodev_conns_lock and claiming each node closes both.

The walk itself must not lose the entries either.  Once the following
patches hand out references, a connection on one of these lists can
be kept alive only by a reference that is dropped at any point during
the walk, freeing the transport node the iterator is about to read;
nothing in this tree destroys a connection behind the sweep's back
today, so that part is preparation for those patches, while the IB
list handling above is a fix in its own right.  So the gather takes a
reference on each connection it moves
onto the stack list, under the transport lock, and drops it after the
destroy; a connection whose free is already running gets no reference
and is left where it is, since that free unlinks the node itself once
the lock is released.  The tmp_list gathering itself remains: it is
what keeps rds_conn_destroy() from being called with the transport
lock held.

Fixes: 4716af3897e9 ("net/rds: Give each connection path its own workqueue")
Cc: <stable+noautosel@kernel.org> # depends on the connection reference counting earlier in this series
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/ib.h      |  4 +++
 net/rds/ib_cm.c   | 13 +++++---
 net/rds/ib_rdma.c | 78 +++++++++++++++++++++++++++++++++++------------
 net/rds/loop.c    | 59 +++++++++++++++++++++++++++--------
 net/rds/tcp.c     | 52 +++++++++++++++++++++++++++----
 5 files changed, 164 insertions(+), 42 deletions(-)

diff --git a/net/rds/ib.h b/net/rds/ib.h
index d1a3d421d439..07474fe7327b 100644
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
index ebb5e7aab580..e4a2cf4ded5e 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -1291,15 +1291,20 @@ void rds_ib_conn_free(void *arg)
 	rdsdebug("ic %p\n", ic);
 
 	/*
-	 * Conn is either on a dev's list or on the nodev list.
-	 * A race with shutdown() or connect() would cause problems
-	 * (since rds_ibdev would change) but that should never happen.
+	 * Conn is on a dev's list or on the nodev list - or, once a
+	 * transport teardown has claimed it (i_ib_node_detached), on
+	 * neither, in which case the lock chosen here only guards the
+	 * test below.  A connect or shutdown still running for a
+	 * claimed conn leaves the node alone, see rds_ib_add_conn() and
+	 * rds_ib_remove_conn().
 	 */
 	lock_ptr = ic->rds_ibdev ? &ic->rds_ibdev->spinlock : &ib_nodev_conns_lock;
 
 	/* May be called with IRQs already disabled (see __rds_conn_create()) */
 	spin_lock_irqsave(lock_ptr, flags);
-	list_del(&ic->ib_node);
+	/* a transport teardown that gathered us first owns the node */
+	if (!ic->i_ib_node_detached)
+		list_del(&ic->ib_node);
 	spin_unlock_irqrestore(lock_ptr, flags);
 
 	rds_ib_recv_free_caches(ic);
diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
index 50c02f47cf68..f0e7d116b084 100644
--- a/net/rds/ib_rdma.c
+++ b/net/rds/ib_rdma.c
@@ -123,27 +123,31 @@ int rds_ib_add_conn(struct rds_ib_device *rds_ibdev,
 		    struct rds_connection *conn)
 {
 	struct rds_ib_connection *ic = conn->c_transport_data;
+	int ret = 0;
 
-	/* conn was previously on the nodev_conns_list */
+	/* conn was previously on the nodev_conns_list, unless a teardown
+	 * sweep has claimed it ahead of destroying it: then it is on its
+	 * way out, and its node belongs to the sweep.
+	 */
 	spin_lock_irq(&ib_nodev_conns_lock);
-	BUG_ON(list_empty(&ib_nodev_conns));
-	BUG_ON(list_empty(&ic->ib_node));
-
 	spin_lock(&rds_ibdev->spinlock);
 	/* rds_ib_dev_shutdown() has walked conn_list, or is about to
 	 * with this lock held: a connection attached now would never be
-	 * dropped by it, so leave the connection on the nodev list for
-	 * the caller to fail and the transport exit to find.
+	 * dropped by it.  A node a teardown sweep has claimed belongs to
+	 * a connection that sweep is destroying.  Refuse both, and leave
+	 * the node where it is: on the nodev list for the exit sweep to
+	 * find, or on the sweep's own list.
 	 */
-	if (rds_ibdev->shutting_down) {
-		spin_unlock(&rds_ibdev->spinlock);
-		spin_unlock_irq(&ib_nodev_conns_lock);
-		return -ENODEV;
+	if (rds_ibdev->shutting_down || ic->i_ib_node_detached) {
+		ret = -ENODEV;
+	} else {
+		list_del(&ic->ib_node);
+		list_add_tail(&ic->ib_node, &rds_ibdev->conn_list);
 	}
-	list_del(&ic->ib_node);
-	list_add_tail(&ic->ib_node, &rds_ibdev->conn_list);
 	spin_unlock(&rds_ibdev->spinlock);
 	spin_unlock_irq(&ib_nodev_conns_lock);
+	if (ret)
+		return ret;
 
 	ic->rds_ibdev = rds_ibdev;
 	refcount_inc(&rds_ibdev->refcount);
@@ -155,15 +159,22 @@ void rds_ib_remove_conn(struct rds_ib_device *rds_ibdev, struct rds_connection *
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
 
@@ -176,13 +187,40 @@ void rds_ib_destroy_nodev_conns(void)
 	struct rds_ib_connection *ic, *_ic;
 	LIST_HEAD(tmp_list);
 
-	/* avoid calling conn_destroy with irqs off */
+	struct rds_connection *conn;
+
+	/* Gather the connections and take a reference on each, so that
+	 * none is freed under the walk below once the deferred frees
+	 * introduced later in the series can drop a connection's last
+	 * reference behind this sweep.  One whose free
+	 * is already running gets no reference: its free unlinks the
+	 * node itself, under this lock, once we drop it.  Marking the
+	 * node detached claims it for this sweep: rds_ib_add_conn(),
+	 * rds_ib_remove_conn() and rds_ib_conn_free() leave a claimed
+	 * node alone, so the walk over tmp_list below needs no lock.
+	 * Avoid calling conn_destroy with irqs off.
+	 */
 	spin_lock_irq(&ib_nodev_conns_lock);
-	list_splice(&ib_nodev_conns, &tmp_list);
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
index e6b0750bbeda..3d063a23bd0b 100644
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
 }
 
 static void rds_loop_kill_conns(struct net *net)
@@ -208,14 +246,11 @@ static void rds_loop_kill_conns(struct net *net)
 
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
index c1ad37505417..059c9a1729f8 100644
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
2.50.1

