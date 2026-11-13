Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794545040;
	b=DBLRXhtbVLNEOlkLXOjEAcjLyeEHpiICU5Hj3F5T8ppysGabzf4jMdU5JGpj3xUHvVbt
	 FEpJ5Zk8wEgBOkOmxFHhUlxSnUTtm6XdO3hkvJBj6GS+gtZq8kgPfoDBCD64qW9G5PNLy
	 hx+kySJnIUatfDKY12oGrYrp9DSwwcdxN5yyUknC1ZJBAcu2InuuI/KUaNvePpSTLS3pA
	 sspcktVAa+XucQHa47pY4oQ0kCMGhDmDL/2gIuTZqAhkHoYEwOMsFL+xM7NF7hJ1OfhdL
	 EXKOIZEG9XAfnI8ITjcP7I4wP0EunvjVvcxnSq8QuWYz0rp0+yV4iZMSAbBKkVfO1aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794545040;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=iQGMS0DBrCf1ddQATkftg8rgY2XziPgGwhSjvIN+1bI=;
	b=4vsdYn5AH812KoE+hnHoNu1/TAIeZbxITCYW65BfbdBhZe6NaPGiZaAzz3ab4W7R4cry
	 Ipe7jhxoB8X0JWbsKZK0Hu1zdrl9Jw4/eobkedyfOQQ/U6jysGwwpRGY8FCkTtvdVNqn8
	 zkJCvDmXW7eW7rzhJwqnO7j/EHXSZRpRuuCY1YrOMqovmxRfTvW9W/tBiOJwNcjwpqdgD
	 9TOSzC20fjH5dIKmEZ2W1VztBIZVyf1mXhy4BkuNutL7nT6GGZnxdP50tEMo3TaQCGzg2
	 Q94397UHV1sB9PGgYkRIMFRkFu3XQKQzZS9lNN6X8pjis3/0lKDditdoQNPR8zPuUTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=REtRQKlA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F30660A2603;
	Fri, 13 Nov 2026 04:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=REtRQKlA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BB01F000C4;
	Fri, 13 Nov 2026 04:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794545039;
	bh=iQGMS0DBrCf1ddQATkftg8rgY2XziPgGwhSjvIN+1bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=REtRQKlA3e+Y0qsMaCUkErKtZ1xrIuDg3ZiAinM+vi2MAy5wK+ISJaeioxyASSpB6
	 04Ue3vjFC2teKDs45TYz6fVNb00qfPBCUc6ARaiLUybWPa+0CRV+4di8ZEV8cEqoGG
	 MDzDXiJHGnk4JkQsYyji5Hh+CrYJy014eULDMgwFCOhlgJTywOCo2ONYSZ1gZVVOl2
	 FaAuVoXJlub4MHKf4o2GGo7jWPPoOJ7br0QCPzoa27+WS6iF9sHg/y5iFNq/uyP9/j
	 JqWSncuOHfaBaKFp8JcFg4NYDmy82FWTIf+u/nXNnXdD2V96OlERk1/sBCfkF8XFb8
	 6PtX4hGujB08Q==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v12 07/12] net/rds: wait for connections to be freed on transport unload
Date: Thu, 12 Nov 2026 21:43:50 -0700
Message-ID: <20261113044355.2932029-8-achender@kernel.org>
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

Since connection free became asynchronous, rds_conn_destroy() only
quiesces the connection; the actual free - including the transport's
conn_free, which lives in the transport module - runs when the last
reference is dropped.  The transports' exit paths destroy all of
their connections and then proceed to unload, so a free that is still
pending - once the following patches hand out references to lookups,
sockets and incs - would execute transport module code after that
module's text is gone.  At this point in the series the initial
reference is the only one, so the wait only has work to do for IB,
where it also catches the late arrivals described below; the
guarantee becomes load-bearing with those patches.

Count each transport's live connections in t_conn_count (incremented
when a connection is published in __rds_conn_create(), decremented as
the last step of rds_conn_destroy_fini()) and make the transport exit
paths - rds_ib_exit(), rds_tcp_exit() and rds_loop_exit() - wait for
the count to drop to zero after destroying their connections.

A bound socket holds a module reference on its own transport
(rds_trans_get_preferred()), but that does not bound the wait: once
the following patches make incs hold a connection reference, an
unread datagram pins its connection for as long as the application
leaves it on the receive queue, and rds_find_bound() does not filter
on transport, so that socket may well belong to a different transport
than the connection and pin nothing that stops this unload.
Proceeding after a timeout would turn a leak into a use-after-free in
this module's text, so the wait is unbounded: it polls the count,
warns every ten seconds naming the transport and the number of
connections outstanding, and returns only when the count reaches
zero.  rmmod therefore blocks while data is queued and unread, which
is the historical RDS contract - teardown does not discard queued
data.
The wait is deliberately not interruptible: the exit function has
already passed the point of no return, and a killed rmmod would leave
the module half torn down and unloadable, which is worse than a
blocked one.  The polling wakes every 100 ms, so the hung task detector
does not fire.

The wake at the end of rds_conn_destroy_fini() can run from a thread
executing transport module text, but never as that thread's last use
of it: the CM event handler's reference (added later in the series) is
always dropped before the rdma_destroy_id() in the connection's own
shutdown returns, and rds_rdma_exit() stops the listener - waiting for
any handler running on it - before rds_ib_exit() starts to wait.

rds_ib_exit() has one more wrinkle, and an existing hole.
rds_ib_dev_shutdown() only drops the connections still attached to a
device, and each of them moves itself to ib_nodev_conns from its own
shutdown work, asynchronously; the flush_workqueue(rds_wq) in
rds_ib_unregister_client() does not wait for those per-connection
workqueues.  A connection that had not migrated by the time
rds_ib_destroy_nodev_conns() made its single sweep was never
destroyed: it outlived the module, still pointing at
rds_ib_transport.  With the count, it would hold the count up for
good instead.  So the wait takes a resweep callback, which
rds_ib_exit() points at rds_ib_destroy_nodev_conns(): late arrivals
get destroyed on the next poll instead of being waited on.  The sweep
claims and unlinks every node it gathers (see the previous patch), so
a resweep never hands a connection to rds_conn_destroy() twice.

In rds_ib_exit(), tearing down the last connection can also drop the
final reference on a device, which defers rds_ib_dev_free() - again
this module's text - to rds_wq.  The flush of rds_wq that the device
gate patch added after the sweep moves after the wait, so that it
covers the connections the resweep destroys as well; rds_ib_dev_free()
queues nothing further on rds_wq, so a single pass drains it.

Based on the Oracle UEK commits "net/rds: wait_event_timeout
until zero connections during rmmod" and "net/rds:
Each RDS transport should keep its own connection count".

Fixes: 4716af3897e9 ("net/rds: Give each connection path its own workqueue")
Cc: <stable+noautosel@kernel.org> # depends on the connection reference counting earlier in this series
Signed-off-by: Sharath Srinivasan <sharath.srinivasan@oracle.com>
[achender: reimplementation for net-next: t_conn_count did not exist
 upstream and is introduced here; single global waitqueue instead of
 per-transport (the loop transport never goes through
 rds_trans_register()); unbounded wait with a periodic warning in
 place of UEK's wait_event_timeout() + WARN_ON(), plus the resweep for
 IB's asynchronous device detach; also cover rds_loop_exit(); rewrite
 commit message]
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/connection.c | 52 ++++++++++++++++++++++++++++++++++++++++++++
 net/rds/ib.c         | 20 ++++++++++++-----
 net/rds/loop.c       |  2 ++
 net/rds/rds.h        | 14 ++++++++++++
 net/rds/tcp.c        |  1 +
 5 files changed, 84 insertions(+), 5 deletions(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index 258a6bc3c573..c7655e9339ca 100644
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
 
@@ -347,6 +349,7 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 			parent->c_passive = conn;
 			rds_cong_add_conn(conn);
 			rds_conn_count++;
+			atomic_inc(&conn->c_trans->t_conn_count);
 		}
 	} else {
 		/* Creating normal conn */
@@ -365,6 +368,7 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 			hlist_add_head_rcu(&conn->c_hash_node, head);
 			rds_cong_add_conn(conn);
 			rds_conn_count++;
+			atomic_inc(&conn->c_trans->t_conn_count);
 		}
 	}
 	spin_unlock_irqrestore(&rds_conn_lock, flags);
@@ -590,6 +594,7 @@ static void rds_conn_destroy_fini(struct kref *kref)
 	struct rds_connection *conn = container_of(kref, struct rds_connection,
 						   c_refcount);
 	int npaths = (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
+	struct rds_transport *trans = conn->c_trans;
 	unsigned long flags;
 	int i;
 
@@ -602,7 +607,54 @@ static void rds_conn_destroy_fini(struct kref *kref)
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
+ * Called on transport module unload after an initial sweep has
+ * destroyed the transport's connections; @resweep, when given, is
+ * called on every poll to destroy connections that were still
+ * detaching from a device when the sweep ran (IB).  A connection
+ * reference can be held for an application-controlled time - once
+ * incs hold one, an unread datagram pins the inc that carries it, and
+ * thus the connection - so the wait is unbounded: the frees that run
+ * after unload call into this module's text (conn_free, inc_free) and
+ * free into its slabs, so proceeding while any remain would be a
+ * use-after-free, not a leak.  Warn periodically so a stuck count is
+ * diagnosable, but never stop waiting.  This matches the historical
+ * RDS contract that teardown does not discard queued data.
+ */
+void rds_conn_wait_conns_freed(struct rds_transport *trans,
+			       void (*resweep)(void))
+{
+	unsigned long warn_interval =
+			msecs_to_jiffies(RDS_CONN_FREE_WARN_INTERVAL_MS);
+	unsigned long warn_at = jiffies + warn_interval;
+
+	while (!wait_event_timeout(rds_conn_freed_waitq,
+				   !atomic_read(&trans->t_conn_count),
+				   msecs_to_jiffies(RDS_CONN_FREE_POLL_MS))) {
+		/* A transport whose teardown is asynchronous (IB moves a
+		 * connection off its device from the shutdown work) gives
+		 * us a resweep to destroy what has arrived since.
+		 */
+		if (resweep)
+			resweep();
+		if (time_after_eq(jiffies, warn_at)) {
+			pr_warn("RDS/%s: still waiting for %d connection(s) to be freed before unload\n",
+				trans->t_name,
+				atomic_read(&trans->t_conn_count));
+			warn_at = jiffies + warn_interval;
+		}
+	}
 }
+EXPORT_SYMBOL_GPL(rds_conn_wait_conns_freed);
 
 void rds_conn_get(struct rds_connection *conn)
 {
diff --git a/net/rds/ib.c b/net/rds/ib.c
index e14110ea37b6..7b1f611c0a3e 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -540,14 +540,24 @@ void rds_ib_exit(void)
 	rds_info_deregister_func(RDS6_INFO_IB_CONNECTIONS, rds6_ib_ic_info);
 #endif
 	rds_ib_unregister_client();
+
+	/* rds_ib_dev_shutdown() only dropped the connections still
+	 * attached to a device; each moves itself to ib_nodev_conns
+	 * from its shutdown work.  Destroy what is there now and keep
+	 * sweeping the list while the wait sees connections outstanding,
+	 * so a late arrival is destroyed rather than waited on forever.
+	 */
 	rds_ib_destroy_nodev_conns();
-	/* A connect that was refused above may have held the last
-	 * reference on its device, and dropped it - deferring
-	 * rds_ib_dev_free() to rds_wq - only once the sweep had destroyed
-	 * its connection, after rds_ib_unregister_client()'s flush.
-	 * Drain rds_wq again before this module's text goes away.
+	rds_conn_wait_conns_freed(&rds_ib_transport,
+				  rds_ib_destroy_nodev_conns);
+
+	/* Tearing down the last connection may have dropped the final
+	 * reference on a device, deferring rds_ib_dev_free() to rds_wq.
+	 * Drain it before the module goes away; it queues nothing
+	 * further on rds_wq.
 	 */
 	flush_workqueue(rds_wq);
+
 	rds_ib_sysctl_exit();
 	rds_ib_recv_exit();
 	rds_trans_unregister(&rds_ib_transport);
diff --git a/net/rds/loop.c b/net/rds/loop.c
index 3d063a23bd0b..71f760ccd458 100644
--- a/net/rds/loop.c
+++ b/net/rds/loop.c
@@ -233,6 +233,8 @@ void rds_loop_exit(void)
 	spin_unlock_irq(&loop_conns_lock);
 
 	rds_loop_destroy_gathered_conns(&tmp_list);
+
+	rds_conn_wait_conns_freed(&rds_loop_transport, NULL);
 }
 
 static void rds_loop_kill_conns(struct net *net)
diff --git a/net/rds/rds.h b/net/rds/rds.h
index 6cc5ea183491..b4311edb36bf 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -564,6 +564,12 @@ struct rds_transport {
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
@@ -848,6 +854,14 @@ static inline bool rds_conn_get_unless_zero(struct rds_connection *conn)
 {
 	return kref_get_unless_zero(&conn->c_refcount);
 }
+
+/* transport unload waits for its connections to be freed, polling at
+ * the first interval and warning at the second
+ */
+#define RDS_CONN_FREE_POLL_MS		100
+#define RDS_CONN_FREE_WARN_INTERVAL_MS	10000
+void rds_conn_wait_conns_freed(struct rds_transport *trans,
+			       void (*resweep)(void));
 void rds_conn_drop(struct rds_connection *conn);
 void rds_conn_path_drop(struct rds_conn_path *cpath, bool destroy);
 void rds_conn_connect_if_down(struct rds_connection *conn);
diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 059c9a1729f8..900269ae6341 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -845,6 +845,7 @@ static void rds_tcp_exit(void)
 #endif
 	unregister_pernet_device(&rds_tcp_net_ops);
 	rds_tcp_destroy_conns();
+	rds_conn_wait_conns_freed(&rds_tcp_transport, NULL);
 	rds_trans_unregister(&rds_tcp_transport);
 	rds_tcp_recv_exit();
 	kmem_cache_destroy(rds_tcp_conn_slab);
-- 
2.50.1

