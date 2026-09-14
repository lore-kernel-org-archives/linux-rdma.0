Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5702B35F609;
	Mon, 14 Sep 2026 03:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789357045; cv=none; b=Q26wvVgJelcJvEhSsMFyyu72dJYhlx7MQteuXxKhdLTOMKlWlu0DGcXo46Z+K2PYJsV+krAz7zNRzdSCLVRLe6ChDJnT5a8ALL9HZ7DloozHkAoj5ylfHVq0YGzze0ermFmkIoJr93lgUTniAsxVTSHelK21mknaubzpUMkLjR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789357045; c=relaxed/simple;
	bh=+Rx5uh6Z6AWyn0OPrp75tAxPWsbMd3fgd8WmTuvyDJM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jwUjWmRNTq5AGsHXAsT/cOFxMgJ0EDW1A9LcAirmGCEnPITwDmXc3RJ93BcUvLKdlVwu2HfbtSCO1JYiHnXLmdBeylcymbutYyxkBdS+AJkqpgHToDDd2my8OryOTDCTG+7+3qhYkSA0BAs4QE4RpMTU8G6KORQLf6nbZusW9jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c/xxXhzz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c/xxXhzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A265B1F0089C;
	Mon, 14 Sep 2026 03:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789357044;
	bh=8sr3tNSNM9Bar8seznZ7XtrXegdnBTp4Q93aZBlEL/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c/xxXhzzxV4NBm+SG58J/vbiy7dvRSgFlT92w5/fPMs2QqVuIsLKUsLktl6nfwO/C
	 RwwypKwuk2ycpxSC6Oq1aIivHXYgU2E/qxNcsjO+Qpe2Y9+k8VuE/g5Ft2oOH/k+fB
	 Mc66VW1NzCTgBBCY2DNMH+pgn31ZotMXpSWlH5IuymaFC9MQGjO0khSC7N3/NtYGqt
	 bkOElHzEn0FvSXfIvaFEv/EykjOV9tlpjD9IXQCgFmRS79ZQ2ZUkCKX9nqQoSDKCow
	 H1tKft3GE5exOFBXaHwSw4Ud+bmgUzdWMKRTbD+v3zH4HKtNhL65gkOM7EBpSk6AZG
	 v6yGOUKW8+K0Q==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	nicoyip.dev@gmail.com
Subject: [PATCH net-next v3 07/13] net/rds: unlink transport nodes before a possibly deferred connection free
Date: Sun, 13 Sep 2026 20:37:13 -0700
Message-Id: <20260914033719.138057-8-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260914033719.138057-1-achender@kernel.org>
References: <20260914033719.138057-1-achender@kernel.org>
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

That was fine while rds_conn_destroy() freed the connection before it
returned.  Once the free is governed by the connection's reference
count, a holder that outlives the teardown loop - a socket's cached
rs_conn, an inc parked on a receive queue - defers conn_free() until
after the helper has returned, and the list_del() then writes the
neighbours' pointers into a stack frame that no longer exists.

Unlink each node under the transport lock right before its
rds_conn_destroy() instead, so that nothing is left on the stack list
for a later free to touch.  TCP marks the node detached, as
rds_tcp_kill_sock() already does for the secondary paths of a
multipath connection; IB and loopback use list_del_init() and have
their conn_free() skip a node that is already empty.  The tmp_list
gathering itself is unchanged: it still exists so that
rds_conn_destroy() is not called with the transport lock held.

Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/ib_cm.c   |  4 +++-
 net/rds/ib_rdma.c | 12 +++++++++++-
 net/rds/loop.c    | 37 +++++++++++++++++++++++++++----------
 net/rds/tcp.c     | 28 ++++++++++++++++++++++++----
 4 files changed, 65 insertions(+), 16 deletions(-)

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
index a9b27f06cbfc..91db43a0e7d7 100644
--- a/net/rds/ib_rdma.c
+++ b/net/rds/ib_rdma.c
@@ -168,8 +168,18 @@ void rds_ib_destroy_nodev_conns(void)
 	list_splice_init(&ib_nodev_conns, &tmp_list);
 	spin_unlock_irq(&ib_nodev_conns_lock);
 
-	list_for_each_entry_safe(ic, _ic, &tmp_list, ib_node)
+	/* rds_conn_destroy() can return before the connection is freed,
+	 * and it is the free - rds_ib_conn_free() - that unlinks ib_node.
+	 * tmp_list lives on this stack frame, so unlink each node before
+	 * its destroy; the free then finds it empty and leaves it alone.
+	 */
+	list_for_each_entry_safe(ic, _ic, &tmp_list, ib_node) {
+		spin_lock_irq(&ib_nodev_conns_lock);
+		list_del_init(&ic->ib_node);
+		spin_unlock_irq(&ib_nodev_conns_lock);
+
 		rds_conn_destroy(ic->conn);
+	}
 }
 
 void rds_ib_get_mr_info(struct rds_ib_device *rds_ibdev, struct rds_info_rdma_connection *iinfo)
diff --git a/net/rds/loop.c b/net/rds/loop.c
index fd774f8080d0..93be7832b11d 100644
--- a/net/rds/loop.c
+++ b/net/rds/loop.c
@@ -156,6 +156,28 @@ static int rds_loop_conn_alloc(struct rds_connection *conn, gfp_t gfp)
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
+
+	list_for_each_entry_safe(lc, _lc, tmp_list, loop_node) {
+		WARN_ON(lc->conn->c_passive);
+
+		spin_lock_irq(&loop_conns_lock);
+		list_del_init(&lc->loop_node);
+		spin_unlock_irq(&loop_conns_lock);
+
+		rds_conn_destroy(lc->conn);
+	}
+}
+
 static void rds_loop_conn_free(void *arg)
 {
 	struct rds_loop_connection *lc = arg;
@@ -163,7 +185,9 @@ static void rds_loop_conn_free(void *arg)
 
 	rdsdebug("lc %p\n", lc);
 	spin_lock_irqsave(&loop_conns_lock, flags);
-	list_del(&lc->loop_node);
+	/* already unlinked if a transport teardown gathered us first */
+	if (!list_empty(&lc->loop_node))
+		list_del(&lc->loop_node);
 	spin_unlock_irqrestore(&loop_conns_lock, flags);
 	kfree(lc);
 }
@@ -180,7 +204,6 @@ static void rds_loop_conn_path_shutdown(struct rds_conn_path *cp)
 
 void rds_loop_exit(void)
 {
-	struct rds_loop_connection *lc, *_lc;
 	LIST_HEAD(tmp_list);
 
 	rds_loop_set_unloading();
@@ -191,10 +214,7 @@ void rds_loop_exit(void)
 	INIT_LIST_HEAD(&loop_conns);
 	spin_unlock_irq(&loop_conns_lock);
 
-	list_for_each_entry_safe(lc, _lc, &tmp_list, loop_node) {
-		WARN_ON(lc->conn->c_passive);
-		rds_conn_destroy(lc->conn);
-	}
+	rds_loop_destroy_gathered_conns(&tmp_list);
 
 	rds_conn_wait_conns_freed(&rds_loop_transport, NULL);
 }
@@ -214,10 +234,7 @@ static void rds_loop_kill_conns(struct net *net)
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
index 826e4629e4ee..a71d6a4f0939 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -502,6 +502,28 @@ static bool rds_tcp_is_unloading(struct rds_connection *conn)
 	return atomic_read(&rds_tcp_unloading) != 0;
 }
 
+/* Destroy the connections whose nodes were gathered on @tmp_list.
+ *
+ * rds_conn_destroy() can return before the connection is freed, and
+ * it is the free - rds_tcp_conn_free() - that unlinks t_tcp_node.
+ * Since @tmp_list lives on the caller's stack, unlink each node here
+ * and mark it detached before its destroy, so that a free that runs
+ * after the caller has returned does not write into a dead frame.
+ */
+static void rds_tcp_destroy_gathered_conns(struct list_head *tmp_list)
+{
+	struct rds_tcp_connection *tc, *_tc;
+
+	list_for_each_entry_safe(tc, _tc, tmp_list, t_tcp_node) {
+		spin_lock_irq(&rds_tcp_conn_lock);
+		list_del_init(&tc->t_tcp_node);
+		tc->t_tcp_node_detached = true;
+		spin_unlock_irq(&rds_tcp_conn_lock);
+
+		rds_conn_destroy(tc->t_cpath->cp_conn);
+	}
+}
+
 static void rds_tcp_destroy_conns(void)
 {
 	struct rds_tcp_connection *tc, *_tc;
@@ -515,8 +537,7 @@ static void rds_tcp_destroy_conns(void)
 	}
 	spin_unlock_irq(&rds_tcp_conn_lock);
 
-	list_for_each_entry_safe(tc, _tc, &tmp_list, t_tcp_node)
-		rds_conn_destroy(tc->t_cpath->cp_conn);
+	rds_tcp_destroy_gathered_conns(&tmp_list);
 }
 
 static void rds_tcp_exit(void);
@@ -698,8 +719,7 @@ static void rds_tcp_kill_sock(struct net *net)
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

