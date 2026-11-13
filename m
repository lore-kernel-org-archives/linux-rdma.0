Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794545040;
	b=p3iokO+XxORCWnuWZRPJKgwUyqP88eDLkfqiZKcQ42vQF0llSyX47X+WBL+fWgHADXcI
	 axlomxAow1W7dEA9Slr7M7vukT9nSEsZ7oMFBVzUMc3FiZmCuAlo5LJcuDA1NSUs+FZd1
	 g/C6M0hz7Y+q/dg4V+MB8120aBzi1FFsEdB4p5LGwBlDJaQF4Gkjao3y6FOFFtt6RLnG/
	 qj8IUxR1T3dwXwFEF1XxSPX9TvN/gGsW4jUF+dh+WZ5fkhynCYlLb+NWA5fwKNuNZlK2x
	 ODesz2CA85KrJRLtc9n787mueRahidwAjLFm/aXO/wRlbkdgXexsGUQlSAMV7VB3aOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794545040;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=tLs7sq8fCRLLrdT/gEe1SepPWhq1CHzc5Xvo92KzSEU=;
	b=xxh2WzUvsw7gvFsHdsnXyo4U2ROZ7wBHjM8yGuQAkaXGTS+gyIUWdfiTFcVydt0Gliad
	 yQd5+u8n0m5Qrf5TU5R+bdGJb85GIw7flc2CSHbYAdBGHw/n7CTYCIe6JNNnTKj9owLdR
	 rQBOC9WDV6Md4zMTBHHsYppGqh6uIYhwNxRz7DUNF1+IpotPUInbXbaac1/p3CuyKvEUx
	 qIZBDTGI792cb8PFAioFDllVhVuncYlW1cTehTWRIoPufwgl6iyAMrqhrACtoZYhvLcxT
	 gQphlDd/YVqJ0W8mfj7JbgxmiDi8gbqI88WuzDekY1cva9kThR6f3CPkPAbPvnvyo+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HgncLQE7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F93460A260B;
	Fri, 13 Nov 2026 04:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HgncLQE7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0803F1F000D0;
	Fri, 13 Nov 2026 04:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794545040;
	bh=tLs7sq8fCRLLrdT/gEe1SepPWhq1CHzc5Xvo92KzSEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HgncLQE7ct7m97yLgY3TXNPecc59lRGrqaZ61fFUap8xG6UMiaisY1thH2nFA8arp
	 8+bDWa4L0SEKnsi3+UUKxUGUXZdcUsAM5HcM38soPfQtcR25TI0jmLF4qhpodL7PYv
	 h76E33yyNI1pV1qWr5anHuvGqPJAJRA3Pr0gCcFSekcifAE2J57+roZQpiF6gxSIRL
	 BD8sgTTCcFRgY9j6UVmaClTrtAplklBSghi48leShZO48GsRKXXQVkPYHilP5+T5q+
	 5ximga3HDizXjsFWrGrqJgFlgfNEAG2UD+F/iykK+EdWoqMA6tjf2YZZXpKfhLmQ65
	 ko1iSRIVJRY7Q==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v12 08/12] net/rds: hold a connection reference from struct rds_incoming
Date: Thu, 12 Nov 2026 21:43:51 -0700
Message-ID: <20261113044355.2932029-9-achender@kernel.org>
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

struct rds_incoming->i_conn stores a pointer to the connection a message
it belongs to, for both received messages and messages the socket sends.
But without taking a reference, nothing keeps that connection alive.
Embedded as the messages m_inc, an inc routinely outlives the connection
it points at, by sitting in the socket's receive queue until the
application reads it, while the connection is destroyed under it - and
every dereference of i_conn after that point touches freed memory. Netns
teardown and unloading rds.ko cannot do that to a live socket, which
pins both, but a transport unload can: rds_find_bound() does not check
the transport, so a socket bound with one transport (SO_RDS_TRANSPORT)
can hold incs that arrived over another transport's connection, and
unloading that other transport destroys the connection while the socket
stays open.

Chengfeng Ye reported one way to reach it, where the socket info
callbacks walk a receive queue after rmmod freed the connections:

  BUG: KASAN: slab-use-after-free in rds6_inc_info_copy+0x459/0x530 [rds]
  Read of size 1 at addr ffff888106031c50 by task poc/101
  Call Trace:
   rds6_inc_info_copy+0x459/0x530 [rds]
   rds6_sock_inc_info+0x2b9/0x3c0 [rds]
   rds_info_getsockopt+0x19d/0x380 [rds]
   do_sock_getsockopt+0x2ac/0x480
   __sys_getsockopt+0x128/0x210
  Freed by task 102:
   kmem_cache_free+0x1b5/0x3d0
   rds_conn_destroy+0x484/0x600 [rds]
   rds_loop_exit_net+0x32/0x50 [rds]
   unregister_pernet_device+0x2c/0x50
   rds_conn_exit+0x13/0xa0 [rds]
   rds_exit+0x1a/0xc40 [rds]
   __do_sys_delete_module+0x30a/0x4d0

That report has rds.ko itself unloading with an RDS socket still open,
which the socket's module reference would normally prevent, so the
reproduction appears to rely on a forced unload; the cross-transport
case above needs none. Closing the socket gets there too, with no reader
of i_conn other than RDS itself: freeing an IB inc dereferences i_conn
to hand the inc and its fragments back to the connection's recycle
cache, so draining the receive queue of a socket whose connection is
gone crashes in the transport:

  panic
  ...
  rds_ib_recv_cache_put (net/rds/ib_recv.c:703)
  rds_ib_inc_free (net/rds/ib_recv.c:207)
  rds_clear_recv_queue (net/rds/recv.c:909)
  rds_release (net/rds/af_rds.c:212)
  __sock_release (net/socket.c:649)
  sock_close (net/socket.c:1336)

with the freed connection confirmed by its now-zero reference count:

  -trace[9]["inc"].i_conn.c_refcount
  (struct kref){
          .refcount = (refcount_t){
                  .refs = (atomic_t){
                          .counter = (int)0,
                  },
          },
  }

Now that connections are reference counted, make every holder of i_conn
own a reference.  The pointer is assigned in six places - rds_inc_init()
and rds_inc_path_init() for received messages, rds_recv_incoming() when
it re-points an inc at the connection it arrived on, and
rds_send_queue_rm(), rds_send_probe() and the congestion-map path of
rds_send_xmit() for m_inc - and each of them now takes a reference.  The
references are dropped from rds_inc_put() and rds_message_put(), which
are the points where the last user of the pointer goes away.
rds_recv_incoming() takes the new reference before dropping the old one,
so re-pointing an inc at the connection it already refers to cannot free
it.  rds_inc_put() drops its reference through a local copy, since
inc_free() may free the memory the inc lives in.

This keeps a connection allocated for as long as messages that arrived
over it are queued on sockets, which is longer than before.  What
lingers is the quiesced connection, its per-path workqueues (idle,
every work cancelled) and the transport's per-connection state,
including an IB connection's receive caches: rds_conn_destroy() still
quiesces the connection synchronously, so nothing runs on any of it.
It also means the transport cannot unload while such a datagram is
unread - rds_conn_wait_conns_freed() waits, warning every ten seconds,
until the application reads or closes.  That is the intended
behaviour: teardown does not discard queued data, and unloading over a
live reference would be a use-after-free in the transport's text.

The final rds_conn_put() runs the free path, which destroys the per-path
workqueues and therefore may sleep, so the last reference has to be
dropped from process context.  It always is.  While a connection is
alive its hash-table entry holds the initial reference, so a put from a
completion handler or tasklet can never be the last one; that reference
is dropped by rds_conn_destroy(), from process context, after the
connection has been quiesced and its queued messages freed.  The
references that survive that point are the ones held by incs on socket
receive queues and by messages on socket send queues, and those are
dropped from recvmsg and from close - process context in both cases.

This is not a stable candidate, and is marked for the stable tooling to
skip so that it is not picked up without the patches it depends on:
reaching the use-after-free requires freeing a connection out from under
a live socket, which needs CAP_SYS_MODULE, and the fix depends on the
connection reference counting introduced earlier in this series.

Based on the Oracle UEK commit "net/rds: fix crash by
expanding kref coverage to rds_incoming.i_conn".

Fixes: 39de8281791c ("RDS: Main header file")
Cc: <stable+noautosel@kernel.org> # depends on the connection reference counting earlier in this series
Reported-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Closes: https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.dev@gmail.com/
Signed-off-by: Sharath Srinivasan <sharath.srinivasan@oracle.com>
Signed-off-by: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
[achender: port to net-next: same six assignment sites, but upstream
 splits the message free across rds_message_unpin_worker(), so the
 m_inc reference is dropped from a shared rds_message_free() helper
 that both paths call; rds_recv_incoming() takes the new reference
 before dropping the old; rewrite commit message]
Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/message.c | 16 ++++++++++++++--
 net/rds/recv.c    | 27 +++++++++++++++++++++++----
 net/rds/send.c    |  4 ++++
 3 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index 47d5e9ab9b10..cea48ad745ca 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -182,6 +182,18 @@ static void rds_message_purge(struct rds_message *rm)
 		kref_put(&rm->atomic.op_rdma_mr->r_kref, __rds_put_mr_final);
 }
 
+static void rds_message_free(struct rds_message *rm)
+{
+	/* get in rds_send_queue_rm(), rds_send_probe() or the congestion
+	 * map path of rds_send_xmit().  Messages that were never queued on
+	 * a connection have no reference to drop.
+	 */
+	if (rm->m_inc.i_conn)
+		rds_conn_put(rm->m_inc.i_conn);
+
+	kfree(rm);
+}
+
 static void rds_message_unpin_worker(struct work_struct *work)
 {
 	struct rds_message *rm = container_of(work, struct rds_message,
@@ -192,7 +204,7 @@ static void rds_message_unpin_worker(struct work_struct *work)
 	if (rm->atomic.op_unpin_deferred)
 		rds_atomic_op_unpin_page(&rm->atomic);
 
-	kfree(rm);
+	rds_message_free(rm);
 }
 
 void rds_message_put(struct rds_message *rm)
@@ -217,7 +229,7 @@ void rds_message_put(struct rds_message *rm)
 			return;
 		}
 
-		kfree(rm);
+		rds_message_free(rm);
 	}
 }
 EXPORT_SYMBOL_GPL(rds_message_put);
diff --git a/net/rds/recv.c b/net/rds/recv.c
index 00ab60f2d996..e4cae82c1681 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -46,6 +46,7 @@ void rds_inc_init(struct rds_incoming *inc, struct rds_connection *conn,
 {
 	refcount_set(&inc->i_refcount, 1);
 	INIT_LIST_HEAD(&inc->i_item);
+	rds_conn_get(conn);	/* put in rds_inc_put() */
 	inc->i_conn = conn;
 	inc->i_conn_path = NULL;
 	inc->i_saddr = *saddr;
@@ -61,6 +62,7 @@ void rds_inc_path_init(struct rds_incoming *inc, struct rds_conn_path *cp,
 {
 	refcount_set(&inc->i_refcount, 1);
 	INIT_LIST_HEAD(&inc->i_item);
+	rds_conn_get(cp->cp_conn);	/* put in rds_inc_put() */
 	inc->i_conn = cp->cp_conn;
 	inc->i_conn_path = cp;
 	inc->i_saddr = *saddr;
@@ -81,9 +83,19 @@ void rds_inc_put(struct rds_incoming *inc)
 {
 	rdsdebug("put inc %p ref %d\n", inc, refcount_read(&inc->i_refcount));
 	if (refcount_dec_and_test(&inc->i_refcount)) {
+		struct rds_connection *conn = inc->i_conn;
+
 		BUG_ON(!list_empty(&inc->i_item));
 
-		inc->i_conn->c_trans->inc_free(inc);
+		/* inc_free() can free the memory @inc lives in, so the
+		 * connection reference has to be dropped through the
+		 * copy taken above.
+		 */
+		conn->c_trans->inc_free(inc);
+		/* get in rds_inc_init(), rds_inc_path_init() or
+		 * rds_recv_incoming()
+		 */
+		rds_conn_put(conn);
 	}
 }
 EXPORT_SYMBOL_GPL(rds_inc_put);
@@ -325,6 +337,13 @@ void rds_recv_incoming(struct rds_connection *conn, struct in6_addr *saddr,
 	unsigned long flags;
 	struct rds_conn_path *cp;
 
+	/* every caller initialized @inc with rds_inc_init() or
+	 * rds_inc_path_init() first, so i_conn already holds a reference.
+	 * Take the new one before dropping the old, so that re-pointing an
+	 * inc at the connection it already refers to cannot free it.
+	 */
+	rds_conn_get(conn);
+	rds_conn_put(inc->i_conn);
 	inc->i_conn = conn;
 	inc->i_rx_jiffies = jiffies;
 	if (conn->c_trans->t_mp_capable)
@@ -408,8 +427,9 @@ void rds_recv_incoming(struct rds_connection *conn, struct in6_addr *saddr,
 	 * rds_find_bound() uses a global (netns-agnostic) hash table.
 	 * An RDS connection created in netns A can match a socket bound
 	 * in the init netns, delivering inc cross-netns with inc->i_conn
-	 * pointing into netns A.  When cleanup_net() then frees that conn,
-	 * any subsequent dereference of inc->i_conn is a use-after-free.
+	 * pointing into netns A.  Cross-netns delivery is wrong on its
+	 * own, and the inc's connection reference would keep a
+	 * connection of a dead netns around, with a stale c_net.
 	 * Drop the inc if the receiving socket lives in a different netns.
 	 */
 	if (!net_eq(sock_net(rds_rs_to_sk(rs)), rds_conn_net(conn))) {
@@ -484,7 +504,6 @@ static int rds_still_queued(struct rds_sock *rs, struct rds_incoming *inc,
 	if (!list_empty(&inc->i_item)) {
 		ret = 1;
 		if (drop) {
-			/* XXX make sure this i_conn is reliable */
 			rds_recv_rcvbuf_delta(rs, sk, inc->i_conn->c_lcong,
 					      -be32_to_cpu(inc->i_hdr.h_len),
 					      inc->i_hdr.h_dport);
diff --git a/net/rds/send.c b/net/rds/send.c
index 9c3890c124a0..518ac69b68b7 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -290,6 +290,8 @@ int rds_send_xmit(struct rds_conn_path *cp)
 			}
 			rm->data.op_active = 1;
 			rm->m_inc.i_conn_path = cp;
+			/* put in rds_message_put() */
+			rds_conn_get(cp->cp_conn);
 			rm->m_inc.i_conn = cp->cp_conn;
 
 			cp->cp_xmit_rm = rm;
@@ -947,6 +949,7 @@ static int rds_send_queue_rm(struct rds_sock *rs, struct rds_connection *conn,
 		/* The code ordering is a little weird, but we're
 		   trying to minimize the time we hold c_lock */
 		rds_message_populate_header(&rm->m_inc.i_hdr, sport, dport, 0);
+		rds_conn_get(conn);	/* put in rds_message_put() */
 		rm->m_inc.i_conn = conn;
 		rm->m_inc.i_conn_path = cp;
 		rds_message_addref(rm);
@@ -1532,6 +1535,7 @@ rds_send_probe(struct rds_conn_path *cp, __be16 sport,
 	list_add_tail(&rm->m_conn_item, &cp->cp_send_queue);
 	set_bit(RDS_MSG_ON_CONN, &rm->m_flags);
 	rds_message_addref(rm);
+	rds_conn_get(cp->cp_conn);	/* put in rds_message_put() */
 	rm->m_inc.i_conn = cp->cp_conn;
 	rm->m_inc.i_conn_path = cp;
 
-- 
2.50.1

