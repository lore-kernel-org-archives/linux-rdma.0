Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C5F352032;
	Sat, 12 Sep 2026 03:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789185044; cv=none; b=cBoo+H1FmBF//fIYYvm4a+A3LX4EZYlzqTHWjaUw++eeS4rfdB+Dvb7GMn/rxr1HMKYOkBHvZXc+PohHIBFH6jC4KML1zAkrxY5kheimTyR3ropmv1egKcz/xp4CmXIoI4OvHxPEG6Pb9KEpgE78OwKOanbXYcBq2obIdFoqLWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789185044; c=relaxed/simple;
	bh=V/CHrS7WIx+TIA/cWcS8BUhnsPuQl8t/1xQxw1Srt20=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r5OGF/1hg6y60FGiVUk2kfdnSLxjU9tUdvs62GN0biNHcZojmqn9J/UYVrG2qB4jyHHqBj4fZhHsdcVh1HkgFpcLKgq53jO3YkaegX3BbdccExumES26BNWYH7hH/ie3s/gnRQVHi9xY3CfCUkuGUhg8XUnEEmagV4qBrBuaGKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SohNro/k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SohNro/k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BEB1F0089C;
	Sat, 12 Sep 2026 03:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789185033;
	bh=K+z6X9loMsifflGK9MTZSITK5NkbKWY3N9Qi7aezu/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SohNro/kDgkVRsdoLrXq7/AezUA64Per9gjNfJxh8GpBztBBmToVzYPUPFrh8Ytln
	 HR/siikYuxP57PFOsw6zc03UKEiqdJZF38xSapMGvsYv+7Y2roqeazdcmls0px32Hp
	 T23G/+ynBrXwpo1PTIluvF/8bsapHOhsNqoBP8kViOLSF9esgpvd3xZCs4P4RPrA4p
	 3xMOxZhcw7mOh/qnkeh6Cy9kkNmCEiUnvK5mohNIwRLiXo6ZkulbdJBA/zpRMtzMI/
	 jr64PJBaGCMC2bzVclp+xX9oUQ+EZutNpjqMygERJH9+N+nH2LbNb/aFqCr1ayMMco
	 YkEVJspw6LVGw==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	nicoyip.dev@gmail.com
Subject: [PATCH net-next v2 9/9] net/rds: hold a connection reference from struct rds_incoming
Date: Fri, 11 Sep 2026 20:50:27 -0700
Message-Id: <20260912035027.27447-10-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260912035027.27447-1-achender@kernel.org>
References: <20260912035027.27447-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sharath Srinivasan <sharath.srinivasan@oracle.com>

struct rds_incoming->i_conn stores a pointer to the connection a message
it belongs to, for both received messages and messages the socket sends.
But without taking a reference, nothing keeps that connection alive.
Embedded as the messages m_inc, an inc routinely outlives the connection
it points at, by sitting in the socket's receive queue until the
application reads it, while the connection is destroyed by device removal,
netns teardown or module unload - and every dereference of i_conn after
that point touches freed memory.

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

Closing the socket gets there too, with no reader of i_conn other than
RDS itself: freeing an IB inc dereferences i_conn to hand the inc and
its fragments back to the connection's recycle cache, so draining the
receive queue of a socket whose connection is gone crashes in the
transport:

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

This is not a stable candidate: reaching the use-after-free requires
freeing a connection out from under a live socket, which needs
CAP_SYS_MODULE, netns teardown or physical device removal, and the fix
depends on the connection reference counting introduced earlier in this
series.

Based on the Oracle UEK commit "net/rds: fix crash by
expanding kref coverage to rds_incoming.i_conn".

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
 net/rds/recv.c    | 21 ++++++++++++++++++++-
 net/rds/send.c    |  4 ++++
 3 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index f25f2592586f..29e95028e61e 100644
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
index 6204e577a90a..b031c0b43af8 100644
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
diff --git a/net/rds/send.c b/net/rds/send.c
index 1ae1f24c24e8..dbda24470d21 100644
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
@@ -1559,6 +1562,7 @@ rds_send_probe(struct rds_conn_path *cp, __be16 sport,
 	list_add_tail(&rm->m_conn_item, &cp->cp_send_queue);
 	set_bit(RDS_MSG_ON_CONN, &rm->m_flags);
 	rds_message_addref(rm);
+	rds_conn_get(cp->cp_conn);	/* put in rds_message_put() */
 	rm->m_inc.i_conn = cp->cp_conn;
 	rm->m_inc.i_conn_path = cp;
 
-- 
2.25.1

