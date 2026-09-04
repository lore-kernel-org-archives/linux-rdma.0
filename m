Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7181A3F23DF;
	Fri,  4 Sep 2026 07:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788505374; cv=none; b=XQwubBn/je3JJIidI3QXznoCgA6Kp07ssvawG5dK76toAPCtHTyOrGYK5X/csZ2ERxA6ZJ5kHKxmDTN7KAu5/nmDGAU4qTsWrXpwUt7892Xra9g6f3kRqE5iJ9jhK86+GBEZ8TF64tW/+l3uFslWLYjVkKglAX32Uf0nyLXDNds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788505374; c=relaxed/simple;
	bh=ZfeK2spITnFofs/CLhijmmXNHeGeBCe5gekgauooxHo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lFqeExTkKYiRuA2+Mu2neEix/gS1VM1B6fL9JCEW1LfvLcJF6c61tQZ2Gfb99OxOz4nIgH257k/VCqVt7JcGSZewTP/xwPOcwAxINA03ZUG5jaM7WAxexBNXXtQXelKae5fivr4sCA+WTE0dc/YD0esrvpGA5zhQmdC8NqP9XUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ny1kBFsI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ny1kBFsI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860091F00A3D;
	Fri,  4 Sep 2026 07:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788505372;
	bh=gPAfG7843M+I77P7sdyeXpHz4JkbGRvfcdkRPsuXxq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ny1kBFsIH3ESBdIRPpcs8BELufkjpGYa71D8ml2k9FqVu0N9yeJZTssTEbE215Ii9
	 1kDm+z424181iuF+00eFX7u9Ab/k+ScXUlilxnuSecD+fozwTM7w8gXWEsjaZNO/Qw
	 MNAaZA0LBWBI0cJ7Q0B/RibzMalqX8XkKpGv9TquZ1Z7LOXBBNLvSG1HjEFPPkOwtT
	 YATQcrz/3TxiiBFOBN755wbEf4zlZag3IA94hGXYXBJirAs0cq/tMXemrQOIx/c7lF
	 stzmi6iw50vzZEr5Qm4yDfOxpTBL7Oe/D5/Vs7074Yh2newXk0kc/2GBdTdjJmyKQb
	 q3ohSJ03k0zCw==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	nicoyip.dev@gmail.com
Subject: [PATCH net-next 3/6] net/rds: hold connection references in lookup, sockets and c_passive
Date: Fri,  4 Sep 2026 00:02:45 -0700
Message-Id: <20260904070248.160384-4-achender@kernel.org>
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

Hand out real references everywhere a struct rds_connection pointer
previously escaped bare:

- rds_conn_lookup() takes a reference on the connection it returns
  (kref_get_unless_zero(), skipping entries whose free has already
  begun and that an RCU traversal may still encounter), and
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
  quiesced connection.

- parent->c_passive owns a reference, dropped when the parent is
  destroyed.

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

The cm_id->context back-pointers deliberately remain reference-free:
connection destroy tears down the cm_id before the connection can be
freed, so a CM callback can never see a stale context.

Based on Oracle UEK commits 2c8569e4c880 ("net/rds: Add krefs to
struct rds_connection") and 0e9e3a72b7f7 ("net/rds: rds_sendmsg must
use rs_conn only when not being destroyed").

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
 net/rds/af_rds.c     |  8 ++++++
 net/rds/connection.c | 62 ++++++++++++++++++++++++++++++++++++++++++--
 net/rds/ib_cm.c      |  8 +++++-
 net/rds/send.c       | 42 ++++++++++++++++++++++++++----
 net/rds/tcp_listen.c |  5 +++-
 5 files changed, 116 insertions(+), 9 deletions(-)

diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index d5defe9172e3..0eaa5b976572 100644
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
diff --git a/net/rds/connection.c b/net/rds/connection.c
index f45fd1fb1843..df26959b0fdc 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -79,7 +79,10 @@ static struct hlist_head *rds_conn_bucket(const struct in6_addr *laddr,
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
@@ -96,6 +99,13 @@ static struct rds_connection *rds_conn_lookup(struct net *net,
 		    conn->c_tos == tos &&
 		    net == rds_conn_net(conn) &&
 		    conn->c_dev_if == dev_if) {
+			/* An entry whose refcount already dropped to
+			 * zero has been unhashed and is about to be
+			 * freed; an RCU traversal may still come
+			 * across it.  Treat it as absent.
+			 */
+			if (!kref_get_unless_zero(&conn->c_refcount))
+				continue;
 			ret = conn;
 			break;
 		}
@@ -197,7 +207,14 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 		 * We need a second connection object into which we
 		 * can stick the other QP. */
 		parent = conn;
+		/* The c_passive pointer holds a reference which is only
+		 * dropped one synchronize_rcu() after the pointer is
+		 * cleared, so within this RCU section a fetched pointer
+		 * is always safe to take a reference on.
+		 */
 		conn = parent->c_passive;
+		if (conn)
+			rds_conn_get(conn);
 	}
 	rcu_read_unlock();
 	if (conn)
@@ -316,12 +333,32 @@ static struct rds_connection *__rds_conn_create(struct net *net,
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
+			trans->conn_free(conn->c_path[0].cp_transport_data);
+			free_cp = conn->c_path;
+			kmem_cache_free(rds_conn_slab, conn);
+			conn = ERR_PTR(-ENETDOWN);
+		} else if (parent->c_passive) {
+			rds_conn_get(parent->c_passive);
 			trans->conn_free(conn->c_path[0].cp_transport_data);
 			free_cp = conn->c_path;
 			kmem_cache_free(rds_conn_slab, conn);
 			conn = parent->c_passive;
 		} else {
+			/* The initial reference belongs to whoever
+			 * destroys the conn (the transport's conn
+			 * lists, as for any other conn).  Take one
+			 * for the c_passive pointer - dropped when
+			 * the parent is destroyed - and one for our
+			 * caller.
+			 */
+			rds_conn_get(conn);	/* c_passive */
+			rds_conn_get(conn);	/* caller */
 			parent->c_passive = conn;
 			rds_cong_add_conn(conn);
 			rds_conn_count++;
@@ -351,6 +388,10 @@ static struct rds_connection *__rds_conn_create(struct net *net,
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
@@ -360,6 +401,8 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 	rcu_read_unlock();
 
 out:
+	if (parent)
+		rds_conn_put(parent);
 	if (free_cp) {
 		for (i = 0; i < npaths; i++)
 			if (free_cp[i].cp_wq != rds_wq)
@@ -616,6 +659,7 @@ EXPORT_SYMBOL_GPL(rds_conn_put);
 void rds_conn_destroy(struct rds_connection *conn)
 {
 	int i;
+	struct rds_connection *passive;
 	struct rds_conn_path *cp;
 	int npaths = (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
 
@@ -646,6 +690,16 @@ void rds_conn_destroy(struct rds_connection *conn)
 
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
+	passive = conn->c_passive;
+	conn->c_passive = NULL;
 	spin_unlock_irq(&rds_conn_lock);
 	synchronize_rcu();
 
@@ -663,6 +717,10 @@ void rds_conn_destroy(struct rds_connection *conn)
 	 */
 	rds_cong_remove_conn(conn);
 
+	/* drop the reference our c_passive pointer held, if any */
+	if (passive)
+		rds_conn_put(passive);
+
 	/* drop the initial reference; the connection is freed from
 	 * rds_conn_destroy_fini() once every holder has dropped theirs
 	 */
diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 4feb0edc360c..24e538c253a7 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -924,8 +924,14 @@ int rds_ib_cm_handle_connect(struct rdma_cm_id *cm_id,
 		rds_ib_conn_error(conn, "rdma_accept failed\n");
 
 out:
-	if (conn)
+	if (conn) {
 		mutex_unlock(&conn->c_cm_lock);
+		/* The conn stays reachable through cm_id->context
+		 * without a reference of its own: connection destroy
+		 * shuts the cm_id down before the conn is freed.
+		 */
+		rds_conn_put(conn);
+	}
 	if (err)
 		rdma_reject(cm_id, &err, sizeof(int),
 			    IB_CM_REJ_CONSUMER_DEFINED);
diff --git a/net/rds/send.c b/net/rds/send.c
index 1afa981e5c06..036a68372e2f 100644
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
@@ -1352,9 +1371,17 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 						scope_id);
 		if (IS_ERR(conn)) {
 			ret = PTR_ERR(conn);
+			conn = NULL;
 			goto out;
 		}
+		/* hand the cache its own reference */
+		rds_conn_get(conn);
+		spin_lock_irqsave(&rs->rs_lock, flags);
+		old = rs->rs_conn;
 		rs->rs_conn = conn;
+		spin_unlock_irqrestore(&rs->rs_lock, flags);
+		if (old)
+			rds_conn_put(old);
 	}
 
 	if (conn->c_trans->t_mp_capable) {
@@ -1469,6 +1496,8 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 		kfree(vct.vec[ind].iov);
 	kfree(vct.vec);
 
+	rds_conn_put(conn);
+
 	return payload_len;
 
 out:
@@ -1476,6 +1505,9 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 		kfree(vct.vec[ind].iov);
 	kfree(vct.vec);
 
+	if (conn)
+		rds_conn_put(conn);
+
 	/* If the user included a RDMA_MAP cmsg, we allocated a MR on the fly.
 	 * If the sendmsg goes through, we keep the MR. If it fails with EAGAIN
 	 * or in any other way, we need to destroy the MR again */
diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index 13fa60c1985b..0d2ced892a8a 100644
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
@@ -343,6 +344,8 @@ int rds_tcp_accept_one(struct rds_tcp_net *rtn)
 		mutex_unlock(&rs_tcp->t_conn_path_lock);
 	if (new_sock)
 		sock_release(new_sock);
+	if (conn)
+		rds_conn_put(conn);
 
 	mutex_unlock(&rtn->rds_tcp_accept_lock);
 
-- 
2.25.1

