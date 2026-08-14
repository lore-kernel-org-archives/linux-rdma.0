Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A58B3955FC;
	Fri, 14 Aug 2026 01:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786671313; cv=none; b=W5IOj+qHsEE7IsxdjxLh3gw2yKXGS2heOXG1nF39uvEjON1z6ZDQg6TaIrpZSjyJlaE63oWxVEfePKXwi8zTJ9jNSZFjTmYNyEyKcohoES3mb/Xym/qX235Hqkn4gQxNbXgIrvMJNDmnPrm1ATcCf6a+8AD+UZPKCFR8GBQcL0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786671313; c=relaxed/simple;
	bh=4hX7rknPvkdKCV78op2z3prAoeRWdfgvFWTSC9g+nsI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qAzCQ8qoCKU0qmzWj7by8lZGoEAaxL/p2D/tbniwln0VIv/1WkNurTgOflfSHDaXTyWbHkZAw7RnKngQ5rhnJulPJafyFY+T6qh0XsXjivtQDlqEPlv66obyIEI1t2AQCiQVV59Uz4fSLQgF7HI4fpPa/EQ2UuHKcT6T7e4TXcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TLN58WQU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TLN58WQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 249B21F00A3F;
	Fri, 14 Aug 2026 01:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786671305;
	bh=EQlwtdbKtIRK1YNKa4WwhLTLRn1m/VfinwVNtbZz35o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TLN58WQUcQoJ/wqPzoXF8HFwli0Q0d4q65OX803IjBnP2+xbHA6Kapo/1WP+coXc0
	 PlRcvtc83EJkW1dTCeQZ4paRhK6yTxJjtjYkhTlGVldzm7BRDnijnng6f2MeTncVA+
	 xq4yyGgq2KlncaOjhkUpGXn4w00u4HZB6UyJsEmsk6gowfzSDqBkH9Q+HPd1agjvNC
	 AVJgyRbs+BiMHGqNRMkXq623e5SX6N2uWJLPXArfv/I/2il7ivzVjQ9d7fzSOFAtXg
	 o/DYCrH2IGRTCxFEl7RXjWn0+0POp+PUu09ZqQsm6xSlkFmdtvQ9VspHas9+gwIolf
	 2nH7WsOBZD/Bg==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	jhubbard@nvidia.com,
	leon@kernel.org
Subject: [PATCH net-next 4/4] net/rds: acquire RDS_IN_XMIT in rds_tcp_reset_callbacks()
Date: Thu, 13 Aug 2026 18:35:01 -0700
Message-Id: <20260814013501.43760-5-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260814013501.43760-1-achender@kernel.org>
References: <20260814013501.43760-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rds_tcp_reset_callbacks() quiesces the transmit path by setting the
path state to RDS_CONN_RESETTING and then waiting for RDS_IN_XMIT to
be sampled clear before swapping the underlying socket and calling
rds_send_path_reset().

As in rds_conn_shutdown(), sampling the bit clear is not the same as
owning it: rds_send_xmit() can re-acquire RDS_IN_XMIT right after the
wait_event() returns.  Its state recheck after taking the lock is a
store-buffering pattern (teardown writes the state and reads the bit,
the sender writes the bit and reads the state) and acquire_in_xmit()
is only an acquire operation, so on weakly ordered architectures both
sides can miss each other's write and the transmit path then runs
concurrently with rds_send_path_reset() rewriting cp_xmit_* state.

Take the lock instead, hold it across the socket swap and
rds_send_path_reset(), and release it with a wake-up at the end.  The
lock-ordering constraint documented above the wait still holds: the
lock is acquired before lock_sock(), so a sender inside tcp_sendmsg()
can never be waited on while we hold the socket lock.

Owning the lock also serializes this function against
rds_conn_shutdown(), which since the previous patch holds RDS_IN_XMIT
across the transport shutdown.  That closes two holes the old
sample-based wait left open when a teardown and a duelling-SYN accept
raced on the same path:

 - t_sock is now read only after the lock is acquired.  The old code
   cached it before waiting; a concurrent teardown could release that
   socket inside rds_tcp_conn_path_shutdown() while the accept path
   was still blocked, which would leave it locking and releasing a
   freed socket once it resumed.

 - The old !osock early path called rds_send_path_reset() with no
   serialization at all, while the teardown could be running
   rds_send_path_reset() on the same path concurrently.  Losing that
   race means two threads walking cp_send_queue and putting the same
   messages.  That path now also runs under the lock (and sets
   RDS_CONN_RESETTING like the normal path; the raced connection ends
   up dropped and reconnecting either way).

The in-function comment describing the old wait-based quiesce is
rewritten to describe the lock-based one.

Fixes: 335b48d980f6 ("RDS: TCP: Add/use rds_tcp_reset_callbacks to reset tcp socket safely")
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
Previously patch 4/4 of "net/rds: Bug fix ports, part 2".
v2: read t_sock only after acquiring RDS_IN_XMIT and hold the lock on
the !osock path too, closing the teardown-vs-accept races described
in the commit message; rewrite the in-function quiesce comment.
v1: https://lore.kernel.org/netdev/20260806072045.1092968-5-achender@kernel.org/
 net/rds/tcp.c | 50 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 19 deletions(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index b263634ac750..4ba5d4858ec7 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -127,33 +127,42 @@ void rds_tcp_reset_callbacks(struct socket *sock,
 			     struct rds_conn_path *cp)
 {
 	struct rds_tcp_connection *tc = cp->cp_transport_data;
-	struct socket *osock = tc->t_sock;
-
-	if (!osock)
-		goto newsock;
+	struct socket *osock;
 
 	/* Need to resolve a duelling SYN between peers.
 	 * We have an outstanding SYN to this peer, which may
 	 * potentially have transitioned to the RDS_CONN_UP state,
 	 * so we must quiesce any send threads before resetting
-	 * cp_transport_data. We quiesce these threads by setting
-	 * cp_state to something other than RDS_CONN_UP, and then
-	 * waiting for any existing threads in rds_send_xmit to
-	 * complete release_in_xmit(). (Subsequent threads entering
-	 * rds_send_xmit() will bail on !rds_conn_up().
+	 * cp_transport_data.  Setting cp_state to something other
+	 * than RDS_CONN_UP stops new senders, and owning RDS_IN_XMIT
+	 * excludes any thread already inside rds_send_xmit() as well
+	 * as the teardown in rds_conn_shutdown(), which holds the same
+	 * lock across the transport shutdown.
 	 *
-	 * However an incoming syn-ack at this point would end up
-	 * marking the conn as RDS_CONN_UP, and would again permit
-	 * rds_send_xmi() threads through, so ideally we would
-	 * synchronize on RDS_CONN_UP after lock_sock(), but cannot
-	 * do that: waiting on !RDS_IN_XMIT after lock_sock() may
-	 * end up deadlocking with tcp_sendmsg(), and the RDS_IN_XMIT
-	 * would not get set. As a result, we set c_state to
-	 * RDS_CONN_RESETTTING, to ensure that rds_tcp_state_change
-	 * cannot mark rds_conn_path_up() in the window before lock_sock()
+	 * An incoming syn-ack at this point would end up marking the
+	 * conn as RDS_CONN_UP, and would again permit rds_send_xmit()
+	 * threads through, so ideally we would synchronize on
+	 * RDS_CONN_UP after lock_sock(), but cannot do that: acquiring
+	 * RDS_IN_XMIT after lock_sock() may end up deadlocking with
+	 * tcp_sendmsg(), which takes the socket lock while holding
+	 * RDS_IN_XMIT.  As a result, we set c_state to
+	 * RDS_CONN_RESETTING, to ensure that rds_tcp_state_change
+	 * cannot mark rds_conn_path_up() in the window before
+	 * lock_sock().
 	 */
 	atomic_set(&cp->cp_state, RDS_CONN_RESETTING);
-	wait_event(cp->cp_waitq, !test_bit(RDS_IN_XMIT, &cp->cp_flags));
+	wait_event(cp->cp_waitq,
+		   !test_and_set_bit_lock(RDS_IN_XMIT, &cp->cp_flags));
+
+	/* Only read t_sock while owning RDS_IN_XMIT: a concurrent
+	 * rds_conn_shutdown() releases the old socket and clears
+	 * t_sock under the same lock, so a pointer sampled before the
+	 * wait could be freed by the time we wake up.
+	 */
+	osock = tc->t_sock;
+	if (!osock)
+		goto newsock;
+
 	/* reset receive side state for rds_tcp_data_recv() for osock  */
 	cancel_delayed_work_sync(&cp->cp_send_w);
 	cancel_delayed_work_sync(&cp->cp_recv_w);
@@ -172,6 +181,9 @@ void rds_tcp_reset_callbacks(struct socket *sock,
 	lock_sock(sock->sk);
 	rds_tcp_set_callbacks(sock, cp);
 	release_sock(sock->sk);
+
+	clear_bit_unlock(RDS_IN_XMIT, &cp->cp_flags);
+	wake_up_all(&cp->cp_waitq);
 }
 
 /* Add tc to rds_tcp_tc_list and set tc->t_sock. See comments
-- 
2.25.1

