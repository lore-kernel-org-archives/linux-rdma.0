Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B776E48D884;
	Thu, 17 Sep 2026 07:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789630807; cv=none; b=SVzz/rchuhkl9eIYCh6FTjDm3UEBqRM0xYn2njC0aAl0HTf0LrNGHJcoYyF5qW3pl+kXkRqmBLcE3bg5oC2v400JnBg5kXazbxb+IVlWumN7Zjf5szm75pUfL5ZL2O1pDlZyVZjVG3Hr0T0ZIVVbMCgBokNyLnEHwxN1zRQCwVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789630807; c=relaxed/simple;
	bh=ke2W+MC7S52VzvPWJvi5nr3BOZlN0fHgsu4rIZy1+VE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ft5Cfy3aya7/YkxhUT31hxaNMr2V6LTQWA/3eSc18PL5QW0gqfZGetkyXBQ77lGl5VbaSqUk6hfYEnXvoyz3akONOrp1VXU28Ni3w2kWZ3CoBO6NQyHdEhRHWQZ/5abCeX/kpUs6yPZdPqhb5RZyK/evUM0FYT8RH+Q33voUdWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hmhkh2FR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hmhkh2FR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F451F00898;
	Thu, 17 Sep 2026 07:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789630803;
	bh=gYIm4nRFe+UHgxVNC4v0TfTWyJcajYiPKFluDoy0zHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hmhkh2FRCXQJ1QG06Imsj8jiLiOcJQERlENiAVFwu3k4UGfeWkGtJ7jxXRxs+jEu8
	 F2x/JARQf5KolOdnst/o25/wJNseNkx/R9+yC5+HkMhfnBfMYTvmmj2fF7NcDOrVRO
	 +5E+RsYi8VgSyo2a16GsVu0/V2x7FtQ3W9C4Wc7iRGtEUqXXp9ineh35eNz1kQqPnB
	 /g/RZVrGPTknV9B+gOP3Cpa6gdlgzTyb0E7M/oRa4/1pWcdZXD6l4qJH8TFzqZOdCN
	 zrLpBpNuIqNNGQRXpaXJAnZGmVmBxTFnKgrGkULL3EygIziipvk7IF/01bcUtRwA+0
	 W/GgxxMiUxN4Q==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	nicoyip.dev@gmail.com
Subject: [PATCH net-next v4 08/12] net/rds: hold connection references in lookup, sockets and c_passive
Date: Thu, 17 Sep 2026 00:39:54 -0700
Message-Id: <20260917073958.174056-9-achender@kernel.org>
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
  The connection may still be destroyed while a send is in flight -
  when its device is removed or its netns is torn down - but it is
  only quiesced; the free is held off by the sender's reference.  A
  cached connection whose destruction has begun is no longer reused.
  Instead, sendmsg drops it and looks up or creates a live one, so a
  socket cannot get stuck returning -EAGAIN forever against a
  quiesced connection.  Both ToS ioctls use the same lock now (they
  used the unrelated global rds_sock_lock before), and since the
  create in rds_sendmsg() samples rs_tos without the lock, the install
  re-checks under it that the new connection's ToS still matches the
  socket's and returns -EAGAIN if a SIOCRDSSETTOS slipped in between,
  rather than sending on, and caching, a connection with the old ToS.

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
and both stop the listener - flushing the accept work and clearing
the listen socket the accept tests first - before destroying anything.

This is not a stable candidate on its own: it depends on the
connection reference counting introduced by the preceding patches,
and the race it closes needs a connection destroyed under a live
socket, which takes netns teardown, module unload or device removal.

Based on the Oracle UEK commits "net/rds: Add krefs to
struct rds_connection" and "net/rds: rds_sendmsg must
use rs_conn only when not being destroyed".

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
 net/rds/af_rds.c     |  24 +++++++--
 net/rds/connection.c | 125 +++++++++++++++++++++++++++++++++++++++++--
 net/rds/ib_cm.c      |   9 +++-
 net/rds/loop.c       |   2 +-
 net/rds/rds.h        |   6 ++-
 net/rds/send.c       |  53 ++++++++++++++++--
 net/rds/tcp_listen.c |  11 +++-
 7 files changed, 210 insertions(+), 20 deletions(-)

diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index d5defe9172e3..1cc20b5cfd21 100644
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
@@ -255,6 +263,7 @@ static int rds_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 {
 	struct rds_sock *rs = rds_sk_to_rs(sock->sk);
 	rds_tos_t utos, tos = 0;
+	unsigned long flags;
 
 	switch (cmd) {
 	case SIOCRDSSETTOS:
@@ -267,18 +276,23 @@ static int rds_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
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
 		rs->rs_tos = tos;
-		spin_unlock_bh(&rds_sock_lock);
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
index 1d48da1a794f..965d68e51a1c 100644
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
+		if (conn && READ_ONCE(conn->c_destroy_in_prog))
+			conn = NULL;
+		if (conn)
+			rds_conn_get(conn);
 	}
 	rcu_read_unlock();
 	if (conn)
@@ -334,13 +369,44 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 	spin_lock_irqsave(&rds_conn_lock, flags);
 	if (parent) {
 		/* Creating passive conn */
-		if (parent->c_passive) {
+		if (READ_ONCE(parent->c_destroy_in_prog)) {
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
+			if (READ_ONCE(passive->c_destroy_in_prog)) {
+				/* Its destroy will clear the parent's
+				 * pointer under this lock shortly; until
+				 * then there is no usable passive conn.
+				 */
+				conn = ERR_PTR(-ENETDOWN);
+			} else {
+				rds_conn_get(passive);
+				conn = passive;
+			}
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
@@ -359,6 +425,10 @@ static struct rds_connection *__rds_conn_create(struct net *net,
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
@@ -369,6 +439,8 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 	rcu_read_unlock();
 
 out:
+	if (parent)
+		rds_conn_put(parent);
 	if (free_cp) {
 		for (i = 0; i < npaths; i++)
 			if (free_cp[i].cp_wq != rds_wq)
@@ -672,6 +744,9 @@ EXPORT_SYMBOL_GPL(rds_conn_put);
 void rds_conn_destroy(struct rds_connection *conn)
 {
 	int i;
+	struct rds_connection *passive, *parent;
+	struct hlist_head *head;
+	bool was_passive = false;
 	struct rds_conn_path *cp;
 	int npaths = (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
 
@@ -702,7 +777,38 @@ void rds_conn_destroy(struct rds_connection *conn)
 
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
@@ -719,6 +825,15 @@ void rds_conn_destroy(struct rds_connection *conn)
 	 */
 	rds_cong_remove_conn(conn);
 
+	/* drop the reference our c_passive pointer held, if any, and
+	 * the one a parent's c_passive pointer held on us; neither can
+	 * be the last, since the initial reference is dropped below
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
index 26a32c1ec8f7..98f34b494237 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -924,8 +924,15 @@ int rds_ib_cm_handle_connect(struct rdma_cm_id *cm_id,
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
index b3cc0804156e..321f2da9e76d 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -161,7 +161,7 @@ struct rds_connection {
 	 * cancellation from landing on a destroyed workqueue.
 	 */
 	bool			c_destroy_in_prog;
-	struct rds_connection	*c_passive;
+	struct rds_connection __rcu *c_passive;
 	struct rds_transport	*c_trans;
 
 	struct rds_cong_map	*c_lcong;
@@ -669,7 +669,9 @@ struct rds_sock {
 
 	/*
 	 * rds_sendmsg caches the conn it used the last time around.
-	 * This helps avoid costly lookups.
+	 * This helps avoid costly lookups.  The cache owns a connection
+	 * reference, dropped when it is replaced or the socket is
+	 * released, and is read and written under rs_lock.
 	 */
 	struct rds_connection	*rs_conn;
 
diff --git a/net/rds/send.c b/net/rds/send.c
index 32c411d10e3e..2d7839438abd 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1159,13 +1159,14 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
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
@@ -1340,11 +1341,29 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 	rm->m_daddr = daddr;
 
 	/* rds_conn_create has a spinlock that runs with IRQ off.
-	 * Caching the conn in the socket helps a lot. */
-	if (rs->rs_conn && ipv6_addr_equal(&rs->rs_conn->c_faddr, &daddr) &&
-	    rs->rs_tos == rs->rs_conn->c_tos) {
-		conn = rs->rs_conn;
+	 * Caching the conn in the socket helps a lot.
+	 *
+	 * The cached rs_conn holds a connection reference; take one of
+	 * our own for the duration of this call (dropped on both exit
+	 * paths), so that neither a concurrent sender replacing the
+	 * cache nor rds_conn_destroy() can free the connection under
+	 * us.  A cached connection whose destruction has begun is not
+	 * reused: dropping it here lets the next sendmsg look up or
+	 * create a live one instead of returning -EAGAIN forever.
+	 */
+	spin_lock_irqsave(&rs->rs_lock, flags);
+	conn = rs->rs_conn;
+	if (conn && ipv6_addr_equal(&conn->c_faddr, &daddr) &&
+	    rs->rs_tos == conn->c_tos && !rds_destroy_pending(conn)) {
+		rds_conn_get(conn);
 	} else {
+		conn = NULL;
+	}
+	spin_unlock_irqrestore(&rs->rs_lock, flags);
+
+	if (!conn) {
+		struct rds_connection *old;
+
 		conn = rds_conn_create_outgoing(sock_net(sock->sk),
 						&rs->rs_bound_addr, &daddr,
 						rs->rs_transport, rs->rs_tos,
@@ -1352,9 +1371,28 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 						scope_id);
 		if (IS_ERR(conn)) {
 			ret = PTR_ERR(conn);
+			conn = NULL;
 			goto out;
 		}
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
+			goto out;
+		}
+		/* hand the cache its own reference */
+		rds_conn_get(conn);
+		old = rs->rs_conn;
 		rs->rs_conn = conn;
+		spin_unlock_irqrestore(&rs->rs_lock, flags);
+		if (old)
+			rds_conn_put(old);
 	}
 
 	if (conn->c_trans->t_mp_capable) {
@@ -1474,6 +1512,8 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 		kfree(vct.vec[ind].iov);
 	kfree(vct.vec);
 
+	rds_conn_put(conn);
+
 	return payload_len;
 
 out:
@@ -1481,6 +1521,9 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 		kfree(vct.vec[ind].iov);
 	kfree(vct.vec);
 
+	if (conn)
+		rds_conn_put(conn);
+
 	/* If the user included a RDMA_MAP cmsg, we allocated a MR on the fly.
 	 * If the sendmsg goes through, we keep the MR. If it fails with EAGAIN
 	 * or in any other way, we need to destroy the MR again */
diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index 8a0c54aced5e..7fea5501d756 100644
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
@@ -277,6 +278,12 @@ int rds_tcp_accept_one(struct rds_tcp_net *rtn)
 	cp = rs_tcp->t_cpath;
 	conn_state = rds_conn_path_state(cp);
 	WARN_ON(conn_state == RDS_CONN_UP);
+	/* A connection whose destroy has begun cannot be found here:
+	 * TCP connections are only destroyed on netns teardown and on
+	 * module unload, and both run rds_tcp_listen_stop() - which
+	 * flushes this work and clears the listen socket that the top
+	 * of this function tests - before any connection is destroyed.
+	 */
 	if (conn_state != RDS_CONN_CONNECTING && conn_state != RDS_CONN_ERROR) {
 		rds_conn_path_drop(cp, 0);
 		goto rst_nsk;
@@ -347,6 +354,8 @@ int rds_tcp_accept_one(struct rds_tcp_net *rtn)
 		mutex_unlock(&rs_tcp->t_conn_path_lock);
 	if (new_sock)
 		sock_release(new_sock);
+	if (conn)
+		rds_conn_put(conn);
 
 	mutex_unlock(&rtn->rds_tcp_accept_lock);
 
-- 
2.25.1

