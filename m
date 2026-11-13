Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794545038;
	b=OW3xb9+BJtDG7zbjUvEC9XotIJnkyUNj/XtCb2oaBcl6qA5pOAwIlZSBBdC06mIxaSga
	 uzPyvPjntEc5AjEHZMUfNAmLfgS1OBdGOADHCKnuxZpTgQC64JQvyBLsmrn3HNFIchfCe
	 ciIdxw3zolP48RWu5YOdXFeKX2wYfZilcD07tgCcm8SRXxjiAg+551+fpFfkf99O8eEgG
	 1Vm/CYMBxlfZ+s6+UEKWkrV7mOXqI7zwWJrQ/fwvEN7r4WeRhVWu5j3EdNX38liJOlLEp
	 dDmw1wMJafu+lbOIwYXkg/44rHU2g8WMnC+8b/I+U2HC+bMZhuEuW792rCYJ7gs3jfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794545038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=2WRPv8ZWR4UjzVKuptVlhpMu4wmeyxGJ5gIUxLfFfLY=;
	b=AHkkMFDb2uC37A4/H7P4acrNEybz3NSURB4i3t/qOME8PCEGFQaQiQj+LjYjpwNuuvgt
	 +YoUNtShTwTTi86uhdttbJffu/AetIDdLuhhwtI5VuMW/oPIq0EyJvg08uZ6CkfvGulHd
	 o4at81xb06us+r4+Ry+KVpvYaHxNSdHS613Gsi36iQfSTwRWEs1dAI59ZRomD8snCmm/t
	 p34jBCV2tVjwQmEKiQTu1SEGDYFHnQOd7N7sBjDHha2TJM0E2uHPKVZrsGHB/jovpF2ZW
	 frdCCG+JWkIKbPdSBlsKaij6hHMWHTNqLjSyOMC6Q5ydTNOUhWF7neutRBeOZG5GzoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MEf4mYXo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DCA606A88A;
	Fri, 13 Nov 2026 04:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MEf4mYXo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83AFB1F000C4;
	Fri, 13 Nov 2026 04:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794545037;
	bh=2WRPv8ZWR4UjzVKuptVlhpMu4wmeyxGJ5gIUxLfFfLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MEf4mYXo/oMCSFtqnMwIwDtNCMEwm2Xa55HBwFStunW1Q050LFIcBFeSvHHGd73lv
	 gQJYZk99KEWz6d+wQvQn8x0V7eWwiH9vPbs0+S+Vkh6BT/r6/mqX/Ew2Itw0bBNO8V
	 rokdotSotUDygHySUvPlDBPdQnYggl+92cItTjdv4vtiW3/zMklvCpaJnnZi1CSO4e
	 eLM9l4J2b845Y3YlXxWZNKsURl8IjJpQtIft45voELNY79FWSYS+7diU0qRLv7gS2h
	 gZSrgbOIvZwUusvmAaa4eRA6FpaNM9689m2s0+wcKvJ1j6hCPHA2p7ugHgu90XKAlM
	 +gwLqA9YAAimg==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v12 03/12] net/rds: guard every work-requeueing site with rds_destroy_pending()
Date: Thu, 12 Nov 2026 21:43:46 -0700
Message-ID: <20261113044355.2932029-4-achender@kernel.org>
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

rds_conn_destroy() cancels the path works and then destroys the
per-path workqueue.  The sites that can re-arm those works are
supposed to test rds_destroy_pending() under rcu_read_lock() first,
paired with the synchronize_rcu() in the destroy path, so that no new
work can be queued once the cancellation has begun.

Five arming sites never got that guard:

  - rds_ib_send_cqe_handler() and rds_ib_send_add_credits() re-arm
    cp_send_w when a send completion or a credit update clears
    RDS_LL_SEND_FULL,
  - rds_ib_recv_refill() re-arms cp_recv_w when the recv ring runs
    low,
  - rds_tcp_accept_one() kicks cp_recv_w on the freshly accepted
    socket, and
  - rds_sendmsg() arms cp_conn_w for a multipath connection whose
    path 0 is not up yet.

A completion landing in the window between the cancel and
destroy_workqueue() in rds_conn_path_destroy() would re-arm a work on
a workqueue that is about to be destroyed: with delay 0 the work is
queued directly on the freed workqueue, and with delay 1 the timer
survives destroy_workqueue() unseen and fires afterwards, queueing
from a timer_list that lives in the freed c_path array.  Today's
destroy triggers keep these sites out of that window - an IB
connection reaches rds_conn_destroy() only from the nodev list, with
its QP and CQs already gone, the TCP accept work is flushed before
any connection is destroyed, and a sending socket pins its netns and
its transport module - so this is preparation: the following patch
gives the predicate a per-connection term, and these are the sites
that would otherwise miss it.

Wrap all five sites in the same rcu_read_lock() +
rds_destroy_pending() pattern the other arming sites already use.

The four self-requeues in rds_send_worker() and rds_recv_worker() are
left alone on purpose: they run from inside the work item itself, and
cancel_delayed_work_sync() disables the work for the duration of the
cancel, so a requeue issued by the still-running callback is dropped
and none can follow once the cancel has returned.

With the predicate as it stands the guards cover the netns teardown and
module unload cases; the following patch extends it to the destroy of a
single connection.

Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/ib_recv.c    |  6 +++++-
 net/rds/ib_send.c    | 18 ++++++++++++++----
 net/rds/send.c       | 11 ++++++++---
 net/rds/tcp_listen.c | 10 +++++++---
 4 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index aa50b85b0f99..bec2b91a2467 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -458,7 +458,11 @@ void rds_ib_recv_refill(struct rds_connection *conn, int prefill, gfp_t gfp)
 	    (must_wake ||
 	    (can_wait && rds_ib_ring_low(&ic->i_recv_ring)) ||
 	    rds_ib_ring_empty(&ic->i_recv_ring))) {
-		queue_delayed_work(conn->c_path->cp_wq, &conn->c_recv_w, 1);
+		rcu_read_lock();
+		if (!rds_destroy_pending(conn))
+			queue_delayed_work(conn->c_path->cp_wq,
+					   &conn->c_recv_w, 1);
+		rcu_read_unlock();
 	}
 	if (can_wait)
 		cond_resched();
diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
index d6be95542119..bc411e96ad12 100644
--- a/net/rds/ib_send.c
+++ b/net/rds/ib_send.c
@@ -298,8 +298,13 @@ void rds_ib_send_cqe_handler(struct rds_ib_connection *ic, struct ib_wc *wc)
 	rds_ib_sub_signaled(ic, nr_sig);
 
 	if (test_and_clear_bit(RDS_LL_SEND_FULL, &conn->c_flags) ||
-	    test_bit(0, &conn->c_map_queued))
-		queue_delayed_work(conn->c_path->cp_wq, &conn->c_send_w, 0);
+	    test_bit(0, &conn->c_map_queued)) {
+		rcu_read_lock();
+		if (!rds_destroy_pending(conn))
+			queue_delayed_work(conn->c_path->cp_wq,
+					   &conn->c_send_w, 0);
+		rcu_read_unlock();
+	}
 
 	/* We expect errors as the qp is drained during shutdown */
 	if (wc->status != IB_WC_SUCCESS && rds_conn_up(conn)) {
@@ -420,8 +425,13 @@ void rds_ib_send_add_credits(struct rds_connection *conn, unsigned int credits)
 			test_bit(RDS_LL_SEND_FULL, &conn->c_flags) ? ", ll_send_full" : "");
 
 	atomic_add(IB_SET_SEND_CREDITS(credits), &ic->i_credits);
-	if (test_and_clear_bit(RDS_LL_SEND_FULL, &conn->c_flags))
-		queue_delayed_work(conn->c_path->cp_wq, &conn->c_send_w, 0);
+	if (test_and_clear_bit(RDS_LL_SEND_FULL, &conn->c_flags)) {
+		rcu_read_lock();
+		if (!rds_destroy_pending(conn))
+			queue_delayed_work(conn->c_path->cp_wq,
+					   &conn->c_send_w, 0);
+		rcu_read_unlock();
+	}
 
 	WARN_ON(IB_GET_SEND_CREDITS(credits) >= 16384);
 
diff --git a/net/rds/send.c b/net/rds/send.c
index f38967f65af1..9c3890c124a0 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1383,9 +1383,14 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 		 * outstanding.
 		 */
 		if (!test_and_set_bit(RDS_RECONNECT_PENDING,
-				      &conn->c_path[0].cp_flags))
-			queue_delayed_work(conn->c_path[0].cp_wq,
-					   &conn->c_path[0].cp_conn_w, 0);
+				      &conn->c_path[0].cp_flags)) {
+			rcu_read_lock();
+			if (!rds_destroy_pending(conn))
+				queue_delayed_work(conn->c_path[0].cp_wq,
+						   &conn->c_path[0].cp_conn_w,
+						   0);
+			rcu_read_unlock();
+		}
 		rds_send_ping(conn, 0);
 	}
 
diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index 13fa60c1985b..8a0c54aced5e 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -316,10 +316,14 @@ int rds_tcp_accept_one(struct rds_tcp_net *rtn)
 	 */
 	if (READ_ONCE(sk->sk_state) == TCP_CLOSE_WAIT ||
 	    READ_ONCE(sk->sk_state) == TCP_LAST_ACK ||
-	    READ_ONCE(sk->sk_state) == TCP_CLOSE)
+	    READ_ONCE(sk->sk_state) == TCP_CLOSE) {
 		rds_conn_path_drop(cp, 0);
-	else
-		queue_delayed_work(cp->cp_wq, &cp->cp_recv_w, 0);
+	} else {
+		rcu_read_lock();
+		if (!rds_destroy_pending(cp->cp_conn))
+			queue_delayed_work(cp->cp_wq, &cp->cp_recv_w, 0);
+		rcu_read_unlock();
+	}
 
 	sock_put(sk);
 
-- 
2.50.1

