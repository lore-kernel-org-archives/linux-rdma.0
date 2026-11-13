Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794545041;
	b=uQpE+UNkBSj0qyPK6cRr332vjgFGx/Z+o+8PZ9c19+MToOWZ/z42DHqexgF8WS8tDFLt
	 amhG/peJV17yhWCf92xSqEJR6btJ0R5uiqEEVR1Hh4/EE1/y0ruFRqE/4jQFsW8bTCbrV
	 3QslnLXZ7nAo6IaVBr8nNSNMV25OU/HkNsgnrSyKmp0sGbimnOxj46Du5EAwkhnU25Zax
	 N/844/DZwu/1/vQW0YMgXRmtAp3oAe4jmasEfBc4Gl/1qPfo6/GXLdOitWpnDoKO9AqWK
	 jSs72Iwzx5ajx2xiaGl7vedSNREWVzO7rL+LwklCk/R8VdsqB66LYhiapvUSYk9Zong==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794545041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Ux2FlTFu/MiPEAetJ4+Pnxl8nbsNuA+RQAXJnwICpfY=;
	b=PsGEmCkunHvB1nTOh4DnXN0cmLxd2C3B6xaQUMdbayB4VWeVvs16AtRI/YLHtWiWhDcs
	 ndqbNReTW5O0tbi112PCy5BZzyrNRILizLvXTOtu+sDHMX4KVSPbxCYNWGCdgsnN2xflT
	 udZz9u7Pcu3sN2zQzbJLnL8dydDdmvscBQTHl/VCxPaNw9tG5XkGVTmqOCvMWCz+e8DrV
	 BDrS6b5p8HdhkqqhZ2rBmpvbx58q+HjO1kGQvpR7ztLR145IoW7ap2xV3/CPH1NdROJs6
	 5LKQWgnCW4k+qPIN8a2pHQNj/i5uM09E8to454XgiaGiCKUmgdlXa2IxlilRf5woi4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lsKQcUdg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62BD60A2627;
	Fri, 13 Nov 2026 04:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lsKQcUdg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8BB1F000C4;
	Fri, 13 Nov 2026 04:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794545041;
	bh=Ux2FlTFu/MiPEAetJ4+Pnxl8nbsNuA+RQAXJnwICpfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lsKQcUdgxlzOh3ieLJ2mhYqykA/vzg5hKbcZgSyzWIiDvQHftcjY09HbJhW0SRPmk
	 j9gEwpyosyqBbhGUGA4ArRqDQeO63NM+5Sp4KmjZBtLQ2P7U5wri1weGtVjZUCCCIM
	 S3piG4+sF1aVjkKbIlaTX5FdUw+5baRWc7VTyx97/8Sf9dtNZS2VAtnV5QAbXelj+4
	 tBIG08m1T/w9MeR3biSX8M6unP3LwThAM/tPlxr0zl/YTlNXcc+V4fcl+voHQ/Lo0C
	 gG11nW1WeqL1aryDqyEV1YVPbW2sd/bAjRHG+HVOQ7mwJn/IGa9otapGQJSA4doNj5
	 6p/UqVAbsAWnA==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v12 10/12] net/rds: hold connection references in lookup, sockets and c_passive
Date: Thu, 12 Nov 2026 21:43:53 -0700
Message-ID: <20261113044355.2932029-11-achender@kernel.org>
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

Hand out real references everywhere a struct rds_connection pointer
previously escaped bare:

- rds_conn_lookup() takes a reference on the connection it returns
  (kref_get_unless_zero(), so that it only ever hands out a live
  reference), and
  __rds_conn_create() returns the connection with a reference held
  for the caller on every path: lookup hit, fresh creation, lost
  creation race, and the passive-loopback lookup, which now also
  holds the parent while it dereferences parent->c_passive.

- The rs->rs_conn sendmsg cache owns a reference, which is dropped
  when the cache is replaced or the socket is released.
  rds_sendmsg() itself holds a reference for the duration of the
  call, during which reads and updates of rs_conn are serialized by
  rs_lock.  So neither a concurrent rds_conn_destroy() nor another
  sender replacing the cache can free the connection under a sender.
  No destroy trigger in this tree - netns teardown, module unload -
  can run while a socket is still sending, since a socket holds its
  netns and pins its transport module; today the functional change
  is the rs_lock serialization that closes the data race below, and
  the reference is the discipline the later patches rely on.  A
  cached connection whose destruction has begun is no longer reused,
  which likewise no trigger reaches today.
  Instead, sendmsg evicts it and looks up or creates a live one in the
  same call, so a socket cannot get stuck returning -EAGAIN forever
  against a quiesced connection; the cache's own reference on it is
  dropped right there, so a socket that never sends again does not pin a
  quiesced connection until it is closed.  Both ToS ioctls use the same
  lock now (they used the unrelated global rds_sock_lock before), and
  since the create in rds_sendmsg() samples rs_tos without the lock, the
  install re-checks under it that the new connection's ToS still matches
  the socket's and returns -EAGAIN if a SIOCRDSSETTOS slipped in
  between, rather than sending on, and caching, a connection with the
  old ToS.

- parent->c_passive owns a reference, dropped when the parent is
  destroyed.  The pointer is read under rcu_read_lock() and written
  under rds_conn_lock, so it is RCU-annotated and accessed through
  rcu_dereference()/rcu_assign_pointer().  A passive connection whose
  own destroy has begun is neither handed out nor left dangling in
  the parent: __rds_conn_create() refuses it, and the child's destroy
  clears the parent's pointer and drops that reference itself, so a
  quiesced passive conn cannot be revived by a later connect request.

Serializing the rs_conn cache under rs_lock also resolves a
syzbot-reported KCSAN data race between concurrent rds_sendmsg()
calls on the same socket, each installing the connection it created
into rs->rs_conn with a plain store:

  BUG: KCSAN: data-race in rds_sendmsg / rds_sendmsg

  write to 0xffff888101dec818 of 8 bytes by task 30904 on cpu 0:
   rds_sendmsg+0xc1f/0x1580 net/rds/send.c:1332

  write to 0xffff888101dec818 of 8 bytes by task 30905 on cpu 1:
   rds_sendmsg+0xc1f/0x1580 net/rds/send.c:1332

  value changed: 0x0000000000000000 -> 0xffff88811b61faf0

cm_id->context still carries no reference of its own after this
patch; the following patch pins the connection for the duration of
the CM event handler.

rds_tcp_accept_one() needs no destroy check of its own even though it
now gets a referenced connection back from rds_conn_create(): TCP
connections are only destroyed on netns teardown and module unload,
and both go through rds_tcp_kill_sock(), which clears the listen
socket the accept tests first and then flushes the accept work in
rds_tcp_listen_stop(), before destroying anything.

This is not a stable candidate on its own: it depends on the
connection reference counting introduced by the preceding patches,
and the data race it closes has no consequence beyond the report
while no destroy can run under a live socket, which is the case in
this tree.

Based on the Oracle UEK commits "net/rds: Add krefs to
struct rds_connection" and "net/rds: rds_sendmsg must
use rs_conn only when not being destroyed".

Fixes: 5c11559046c4 ("RDS: send.c")
Cc: <stable+noautosel@kernel.org> # depends on the connection reference counting earlier in this series
Reported-by: syzbot+879c1877016972360186@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=879c1877016972360186
Signed-off-by: Sharath Srinivasan <sharath.srinivasan@oracle.com>
[achender: substantial reimplementation for net-next: upstream has no
 conn reaper, per-conn workers hold no references (destroy cancels
 them synchronously before the final put), and the sendmsg cache is
 serialized with rs_lock instead of UEK's socket flag; rewrite commit
 message]
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/af_rds.c     |  26 ++++++---
 net/rds/connection.c | 125 +++++++++++++++++++++++++++++++++++++++++--
 net/rds/ib_cm.c      |   9 +++-
 net/rds/loop.c       |   2 +-
 net/rds/rds.h        |  20 +++++--
 net/rds/send.c       |  67 ++++++++++++++++++++---
 net/rds/tcp_listen.c |  12 ++++-
 7 files changed, 236 insertions(+), 25 deletions(-)

diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index fb6b8ddb2d11..370f9b978846 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -80,6 +80,14 @@ static int rds_release(struct socket *sock)
 	rds_notify_queue_get(rs, NULL);
 	rds_notify_msg_zcopy_purge(&rs->rs_zcookie_queue);
 
+	/* drop the cached connection reference; no sendmsg can race
+	 * with us here, the socket is going away
+	 */
+	if (rs->rs_conn) {
+		rds_conn_put(rs->rs_conn);
+		rs->rs_conn = NULL;
+	}
+
 	spin_lock_bh(&rds_sock_lock);
 	list_del_init(&rs->rs_item);
 	spin_unlock_bh(&rds_sock_lock);
@@ -254,6 +262,7 @@ static int rds_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 {
 	struct rds_sock *rs = rds_sk_to_rs(sock->sk);
 	rds_tos_t utos, tos = 0;
+	unsigned long flags;
 
 	switch (cmd) {
 	case SIOCRDSSETTOS:
@@ -266,18 +275,23 @@ static int rds_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 		else
 			return -ENOIOCTLCMD;
 
-		spin_lock_bh(&rds_sock_lock);
+		/* rs_conn is serialized by rs_lock (see rds_sendmsg());
+		 * hold it across the "no connection yet" check and the
+		 * rs_tos store so a racing sendmsg cannot cache a conn
+		 * whose c_tos then disagrees with rs_tos.
+		 */
+		spin_lock_irqsave(&rs->rs_lock, flags);
 		if (rs->rs_tos || rs->rs_conn) {
-			spin_unlock_bh(&rds_sock_lock);
+			spin_unlock_irqrestore(&rs->rs_lock, flags);
 			return -EINVAL;
 		}
-		rs->rs_tos = tos;
-		spin_unlock_bh(&rds_sock_lock);
+		WRITE_ONCE(rs->rs_tos, tos);
+		spin_unlock_irqrestore(&rs->rs_lock, flags);
 		break;
 	case SIOCRDSGETTOS:
-		spin_lock_bh(&rds_sock_lock);
+		spin_lock_irqsave(&rs->rs_lock, flags);
 		tos = rs->rs_tos;
-		spin_unlock_bh(&rds_sock_lock);
+		spin_unlock_irqrestore(&rs->rs_lock, flags);
 		if (put_user(tos, (rds_tos_t __user *)arg))
 			return -EFAULT;
 		break;
diff --git a/net/rds/connection.c b/net/rds/connection.c
index 9c8c4b28d2b2..7d03d53a3101 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -81,7 +81,10 @@ static struct hlist_head *rds_conn_bucket(const struct in6_addr *laddr,
 		var |= RDS_INFO_CONNECTION_FLAG_##suffix;	\
 } while (0)
 
-/* rcu read lock must be held or the connection spinlock */
+/* rcu read lock must be held or the connection spinlock.
+ * On success a reference is taken on the returned connection; the
+ * caller must drop it with rds_conn_put().
+ */
 static struct rds_connection *rds_conn_lookup(struct net *net,
 					      struct hlist_head *head,
 					      const struct in6_addr *laddr,
@@ -98,6 +101,17 @@ static struct rds_connection *rds_conn_lookup(struct net *net,
 		    conn->c_tos == tos &&
 		    net == rds_conn_net(conn) &&
 		    conn->c_dev_if == dev_if) {
+			/* Only ever hand out a live reference.
+			 * rds_conn_destroy() unhashes under
+			 * rds_conn_lock and waits a grace period
+			 * before dropping the initial reference, so
+			 * an entry this traversal reaches still holds
+			 * at least that one; the conditional get
+			 * documents the contract rather than
+			 * papering over a zero-refcount entry.
+			 */
+			if (!kref_get_unless_zero(&conn->c_refcount))
+				continue;
 			ret = conn;
 			break;
 		}
@@ -163,6 +177,14 @@ static void __rds_conn_path_init(struct rds_connection *conn,
 	cp->cp_flags = 0;
 }
 
+/* c_passive is written under rds_conn_lock and read under RCU */
+static struct rds_connection *
+rds_conn_passive_locked(struct rds_connection *conn)
+{
+	return rcu_dereference_protected(conn->c_passive,
+					 lockdep_is_held(&rds_conn_lock));
+}
+
 /* Undo trans->conn_alloc(): it may have allocated transport data for
  * every path of a multipath connection, not just for path 0.
  */
@@ -215,7 +237,20 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 		 * We need a second connection object into which we
 		 * can stick the other QP. */
 		parent = conn;
-		conn = parent->c_passive;
+		/* The c_passive pointer holds a reference which is only
+		 * dropped one synchronize_rcu() after the pointer is
+		 * cleared, so within this RCU section a fetched pointer
+		 * is always safe to take a reference on.  A passive conn
+		 * whose own destroy has begun is not handed out, though:
+		 * it is quiesced and about to clear the parent's pointer
+		 * itself, and reusing it would re-arm a connection that
+		 * nothing will tear down again.
+		 */
+		conn = rcu_dereference(parent->c_passive);
+		if (conn && rds_destroy_pending(conn))
+			conn = NULL;
+		if (conn)
+			rds_conn_get(conn);
 	}
 	rcu_read_unlock();
 	if (conn)
@@ -340,13 +375,42 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 	spin_lock_irqsave(&rds_conn_lock, flags);
 	if (parent) {
 		/* Creating passive conn */
-		if (parent->c_passive) {
+		if (rds_destroy_pending(parent)) {
+			/* The parent's destroy has begun (it sets the
+			 * flag and snatches c_passive under this
+			 * lock); do not install a new passive conn
+			 * that nothing would ever destroy.
+			 */
+			rds_conn_free_transport_data(conn, npaths);
+			free_cp = conn->c_path;
+			kmem_cache_free(rds_conn_slab, conn);
+			conn = ERR_PTR(-ENETDOWN);
+		} else if (rcu_access_pointer(parent->c_passive)) {
+			struct rds_connection *passive;
+
+			passive = rds_conn_passive_locked(parent);
 			rds_conn_free_transport_data(conn, npaths);
 			free_cp = conn->c_path;
 			kmem_cache_free(rds_conn_slab, conn);
-			conn = parent->c_passive;
+			/* A passive conn still installed here cannot have
+			 * its own destroy begun: rds_conn_destroy() sets
+			 * c_destroy_in_prog and clears the parent's pointer
+			 * in one rds_conn_lock section, and the netns and
+			 * unload cases were ruled out by the parent above.
+			 */
+			rds_conn_get(passive);
+			conn = passive;
 		} else {
-			parent->c_passive = conn;
+			/* The initial reference belongs to whoever
+			 * destroys the conn (the transport's conn
+			 * lists, as for any other conn).  Take one
+			 * for the c_passive pointer - dropped when
+			 * the parent is destroyed - and one for our
+			 * caller.
+			 */
+			rds_conn_get(conn);	/* c_passive */
+			rds_conn_get(conn);	/* caller */
+			rcu_assign_pointer(parent->c_passive, conn);
 			rds_cong_add_conn(conn);
 			rds_conn_count++;
 			atomic_inc(&conn->c_trans->t_conn_count);
@@ -365,6 +429,10 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 		} else {
 			conn->c_my_gen_num = rds_gen_num;
 			conn->c_peer_gen_num = 0;
+			/* the initial reference belongs to whoever
+			 * destroys the conn; take one for our caller
+			 */
+			rds_conn_get(conn);
 			hlist_add_head_rcu(&conn->c_hash_node, head);
 			rds_cong_add_conn(conn);
 			rds_conn_count++;
@@ -375,6 +443,8 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 	rcu_read_unlock();
 
 out:
+	if (parent)
+		rds_conn_put(parent);
 	if (free_cp) {
 		for (i = 0; i < npaths; i++)
 			if (free_cp[i].cp_wq != rds_wq)
@@ -702,6 +772,9 @@ EXPORT_SYMBOL_GPL(rds_conn_put);
 void rds_conn_destroy(struct rds_connection *conn)
 {
 	int i;
+	struct rds_connection *passive, *parent;
+	struct hlist_head *head;
+	bool was_passive = false;
 	struct rds_conn_path *cp;
 	int npaths = (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
 
@@ -733,7 +806,38 @@ void rds_conn_destroy(struct rds_connection *conn)
 
 	/* Ensure conn will not be scheduled for reconnect */
 	hlist_del_init_rcu(&conn->c_hash_node);
+
+	/* Snatch c_passive while holding the lock:
+	 * __rds_conn_create() dereferences it under rcu_read_lock()
+	 * (and refuses to install a new one once c_destroy_in_prog is
+	 * set, which it checks under this lock).  After the
+	 * synchronize_rcu() below no one can pick the pointer up any
+	 * more and its reference can be dropped.
+	 */
+	passive = rds_conn_passive_locked(conn);
+	RCU_INIT_POINTER(conn->c_passive, NULL);
+
+	/* If we are a parent's passive twin, invalidate its pointer to
+	 * us as well, so that __rds_conn_create() cannot hand out a
+	 * connection whose teardown has begun.  The parent is the
+	 * hashed connection for our key (a passive conn is never
+	 * hashed, and we unhashed ourselves above); it holds its
+	 * initial reference for as long as it is hashed, so the lookup
+	 * reference dropped below cannot be its last.
+	 */
+	head = rds_conn_bucket(&conn->c_laddr, &conn->c_faddr);
+	rcu_read_lock();
+	parent = rds_conn_lookup(rds_conn_net(conn), head, &conn->c_laddr,
+				 &conn->c_faddr, conn->c_trans, conn->c_tos,
+				 conn->c_dev_if);
+	rcu_read_unlock();
+	if (parent && rds_conn_passive_locked(parent) == conn) {
+		RCU_INIT_POINTER(parent->c_passive, NULL);
+		was_passive = true;
+	}
 	spin_unlock_irq(&rds_conn_lock);
+	if (parent)
+		rds_conn_put(parent);
 	synchronize_rcu();
 
 	/* shut the connection down */
@@ -750,6 +854,17 @@ void rds_conn_destroy(struct rds_connection *conn)
 	 */
 	rds_cong_remove_conn(conn);
 
+	/* Drop the reference our c_passive pointer held, if any, and
+	 * the one a parent's c_passive pointer held on us.  Either may
+	 * be the last one - the twin's own destroy may already have run
+	 * - so these must stay here, in sleepable context with no lock
+	 * held, where the free that follows the last put is allowed.
+	 */
+	if (passive)
+		rds_conn_put(passive);
+	if (was_passive)
+		rds_conn_put(conn);
+
 	/* drop the initial reference; the connection is freed from
 	 * rds_conn_destroy_fini() once every holder has dropped theirs
 	 */
diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index e4a2cf4ded5e..5bf6b22c10d6 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -926,8 +926,15 @@ int rds_ib_cm_handle_connect(struct rdma_cm_id *cm_id,
 		rds_ib_conn_error(conn, "rdma_accept failed\n");
 
 out:
-	if (conn)
+	if (conn) {
 		mutex_unlock(&conn->c_cm_lock);
+		/* Drop the reference rds_conn_create() handed us.  The
+		 * conn stays reachable through cm_id->context without a
+		 * reference of its own for now; the CM event handler is
+		 * given one of its own by a following patch.
+		 */
+		rds_conn_put(conn);
+	}
 	if (err)
 		rdma_reject(cm_id, &err, sizeof(int),
 			    IB_CM_REJ_CONSUMER_DEFINED);
diff --git a/net/rds/loop.c b/net/rds/loop.c
index 71f760ccd458..5bac858df87e 100644
--- a/net/rds/loop.c
+++ b/net/rds/loop.c
@@ -170,7 +170,7 @@ static void rds_loop_destroy_gathered_conns(struct list_head *tmp_list)
 
 	list_for_each_entry_safe(lc, _lc, tmp_list, loop_node) {
 		conn = lc->conn;
-		WARN_ON(conn->c_passive);
+		WARN_ON(rcu_access_pointer(conn->c_passive));
 
 		spin_lock_irq(&loop_conns_lock);
 		list_del_init(&lc->loop_node);
diff --git a/net/rds/rds.h b/net/rds/rds.h
index b4311edb36bf..f476168c904c 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -156,7 +156,10 @@ struct rds_connection {
 	/* Set once, by rds_conn_destroy() under rds_conn_lock - a
 	 * test-and-set, so a second destroy of the same connection
 	 * returns at once - before it cancels the path works.  Read
-	 * through rds_destroy_pending().  A site that arms
+	 * through rds_destroy_pending(), which also reports netns
+	 * teardown and module unload; the c_passive handling in
+	 * __rds_conn_create() uses the same predicate, since those rule
+	 * a passive connection out just as well.  A site that arms
 	 * a path work must test the predicate and queue the work inside
 	 * one rcu_read_lock() section: the synchronize_rcu() that
 	 * follows the store is what keeps a queue issued after the
@@ -168,7 +171,7 @@ struct rds_connection {
 	 * destroys - and so flushes - that connection afterwards.
 	 */
 	bool			c_destroy_in_prog;
-	struct rds_connection	*c_passive;
+	struct rds_connection __rcu *c_passive;
 	struct rds_transport	*c_trans;
 
 	struct rds_cong_map	*c_lcong;
@@ -678,7 +681,12 @@ struct rds_sock {
 
 	/*
 	 * rds_sendmsg caches the conn it used the last time around.
-	 * This helps avoid costly lookups.
+	 * This helps avoid costly lookups.  The cache owns a connection
+	 * reference, dropped when it is replaced, when rds_sendmsg()
+	 * evicts a connection whose destroy has begun, or when the
+	 * socket is released, and is read and written under rs_lock -
+	 * except by
+	 * rds_release(), which runs once no one else can reach the socket.
 	 */
 	struct rds_connection	*rs_conn;
 
@@ -687,7 +695,11 @@ struct rds_sock {
 	/* seen congestion (ENOBUFS) when sending? */
 	int			rs_seen_congestion;
 
-	/* rs_lock protects all these adjacent members before the newline */
+	/* rs_lock protects all these adjacent members before the newline,
+	 * as well as rs_conn above and rs_tos at the end of the struct -
+	 * except that rds_sendmsg() samples rs_tos locklessly, with
+	 * READ_ONCE(), for the create, and re-checks it under the lock.
+	 */
 	spinlock_t		rs_lock;
 	struct list_head	rs_send_queue;
 	u32			rs_snd_bytes;
diff --git a/net/rds/send.c b/net/rds/send.c
index 518ac69b68b7..f4143014e0b1 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1162,13 +1162,14 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 	DECLARE_SOCKADDR(struct sockaddr_in *, usin, msg->msg_name);
 	__be16 dport;
 	struct rds_message *rm = NULL;
-	struct rds_connection *conn;
+	struct rds_connection *conn = NULL;
 	int ret = 0;
 	int queued = 0, allocated_mr = 0;
 	int nonblock = msg->msg_flags & MSG_DONTWAIT;
 	long timeo = sock_sndtimeo(sk, nonblock);
 	struct rds_conn_path *cpath;
 	struct in6_addr daddr;
+	unsigned long flags;
 	__u32 scope_id = 0;
 	size_t rdma_payload_len = 0;
 	bool zcopy = ((msg->msg_flags & MSG_ZEROCOPY) &&
@@ -1347,22 +1348,69 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 	rm->m_daddr = daddr;
 
 	/* rds_conn_create has a spinlock that runs with IRQ off.
-	 * Caching the conn in the socket helps a lot. */
-	if (rs->rs_conn && ipv6_addr_equal(&rs->rs_conn->c_faddr, &daddr) &&
-	    rs->rs_tos == rs->rs_conn->c_tos &&
-	    rs->rs_conn->c_dev_if == scope_id) {
-		conn = rs->rs_conn;
+	 * Caching the conn in the socket helps a lot.
+	 *
+	 * The cached rs_conn holds a connection reference; take one of
+	 * our own for the duration of this call (dropped on both exit
+	 * paths), so that neither a concurrent sender replacing the
+	 * cache nor rds_conn_destroy() can free the connection under
+	 * us.  A cached connection whose destruction has begun is not
+	 * reused: it is evicted here, and this call goes on to look up
+	 * or create a live one instead of returning -EAGAIN forever.
+	 */
+	spin_lock_irqsave(&rs->rs_lock, flags);
+	conn = rs->rs_conn;
+	if (conn && rds_destroy_pending(conn)) {
+		/* drop the cache's reference right here, or the socket
+		 * would pin the quiesced connection until it is closed
+		 */
+		rs->rs_conn = NULL;
+		spin_unlock_irqrestore(&rs->rs_lock, flags);
+		rds_conn_put(conn);
+		conn = NULL;
 	} else {
+		if (conn && ipv6_addr_equal(&conn->c_faddr, &daddr) &&
+		    rs->rs_tos == conn->c_tos &&
+		    conn->c_dev_if == scope_id)
+			rds_conn_get(conn);
+		else
+			conn = NULL;
+		spin_unlock_irqrestore(&rs->rs_lock, flags);
+	}
+
+	if (!conn) {
+		struct rds_connection *old;
+
 		conn = rds_conn_create_outgoing(sock_net(sock->sk),
 						&rs->rs_bound_addr, &daddr,
-						rs->rs_transport, rs->rs_tos,
+						rs->rs_transport,
+						READ_ONCE(rs->rs_tos),
 						sock->sk->sk_allocation,
 						scope_id);
 		if (IS_ERR(conn)) {
 			ret = PTR_ERR(conn);
+			conn = NULL;
+			goto out;
+		}
+		/* rs_tos was sampled without rs_lock for the create above,
+		 * and SIOCRDSSETTOS only refuses a change once rs_conn is
+		 * set, so it can have changed underneath us.  Do not
+		 * install - or send on - a connection whose ToS no longer
+		 * matches the socket's; the retry uses the new one.
+		 */
+		spin_lock_irqsave(&rs->rs_lock, flags);
+		if (conn->c_tos != rs->rs_tos) {
+			spin_unlock_irqrestore(&rs->rs_lock, flags);
+			ret = -EAGAIN;
 			goto out;
 		}
+		/* hand the cache its own reference */
+		rds_conn_get(conn);
+		old = rs->rs_conn;
 		rs->rs_conn = conn;
+		spin_unlock_irqrestore(&rs->rs_lock, flags);
+		if (old)
+			rds_conn_put(old);
 	}
 
 	if (conn->c_trans->t_mp_capable) {
@@ -1482,6 +1530,8 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 		kfree(vct.vec[ind].iov);
 	kfree(vct.vec);
 
+	rds_conn_put(conn);
+
 	return payload_len;
 
 out:
@@ -1489,6 +1539,9 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 		kfree(vct.vec[ind].iov);
 	kfree(vct.vec);
 
+	if (conn)
+		rds_conn_put(conn);
+
 	/* If the user included a RDMA_MAP cmsg, we allocated a MR on the fly.
 	 * If the sendmsg goes through, we keep the MR. If it fails with EAGAIN
 	 * or in any other way, we need to destroy the MR again */
diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index 8a0c54aced5e..bb4f01c07169 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -153,7 +153,7 @@ int rds_tcp_accept_one(struct rds_tcp_net *rtn)
 {
 	struct socket *listen_sock = rtn->rds_tcp_listen_sock;
 	struct socket *new_sock = NULL;
-	struct rds_connection *conn;
+	struct rds_connection *conn = NULL;
 	int ret;
 	struct inet_sock *inet;
 	struct rds_tcp_connection *rs_tcp = NULL;
@@ -229,6 +229,7 @@ int rds_tcp_accept_one(struct rds_tcp_net *rtn)
 
 	if (IS_ERR(conn)) {
 		ret = PTR_ERR(conn);
+		conn = NULL;
 		goto out;
 	}
 	/* An incoming SYN request came in, and TCP just accepted it.
@@ -277,6 +278,13 @@ int rds_tcp_accept_one(struct rds_tcp_net *rtn)
 	cp = rs_tcp->t_cpath;
 	conn_state = rds_conn_path_state(cp);
 	WARN_ON(conn_state == RDS_CONN_UP);
+	/* A connection whose destroy has begun cannot be found here:
+	 * TCP connections are only destroyed on netns teardown and on
+	 * module unload, and both go through rds_tcp_kill_sock() - which
+	 * clears the listen socket that the top of this function tests
+	 * and then flushes this work in rds_tcp_listen_stop() - before
+	 * any connection is destroyed.
+	 */
 	if (conn_state != RDS_CONN_CONNECTING && conn_state != RDS_CONN_ERROR) {
 		rds_conn_path_drop(cp, 0);
 		goto rst_nsk;
@@ -347,6 +355,8 @@ int rds_tcp_accept_one(struct rds_tcp_net *rtn)
 		mutex_unlock(&rs_tcp->t_conn_path_lock);
 	if (new_sock)
 		sock_release(new_sock);
+	if (conn)
+		rds_conn_put(conn);
 
 	mutex_unlock(&rtn->rds_tcp_accept_lock);
 
-- 
2.50.1

