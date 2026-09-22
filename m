Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FC956B846;
	Tue, 22 Sep 2026 16:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790095402; cv=none; b=r5NftQqg5FY/2wRS6taKlX1CKly19iOnLQAVUV/gEAuCEfmXx9nM0U8g8m5j7JckI67mNTfnOXcwwQlXyljH1i2FCnrP4Ean++dPvvlVsbAlUIKnTPEpjcIknojlGQBDBKbuRnTM9Fu4q9cGsat4xnjnXGTM6WnXF3kgY0vtwxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790095402; c=relaxed/simple;
	bh=i6o2RmS4MEfClc9bq+Qy2TK/ZfwTrcI3n9NKONTtpl0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n6zBYjqZS+bbMgzl1Ln36sPa3lOSs7zkDH+XxIUq0d4TvmQLHpVeLycMK3WvpP/YqzaK+g4U0PRHKQ+ZHAU19MeY/fd1Me3/1EWqgqGjS6zVkSZjuqnYiLes4flQBDwOyjoEjiRPBf38R9tTxHV2MIM8GZ9tELsoAQQioaC6+Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kbpy+YfE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kbpy+YfE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E8A1F00898;
	Tue, 22 Sep 2026 16:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790095400;
	bh=8gHsjPFWmYqwBhW2iNLlFOhklX9I7Osu5rc4IZQpXyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kbpy+YfE51BVEkZQ2EVAv9PXFTy0tvK3I9avOCNKykzOBDCpYmCBC1Q5IxQa82zpb
	 1kWg/K349d9+zR06vpsovgQUGWeaRxnYbFVRRW+/HVqCavFug320rbyQTm878DIk32
	 nXoKlIJ1q2xLAlBcQZzN1KTi8RQIww6NNSCoEnkgRLlLj1Y1WGZgdSaG6YPKh3VZ/p
	 z0fw8NxLyQ3PFjb80nMjMp13xwJkbt6qrUol/ka5NhsQcvatSlvy6yiAq+ndad5Ah0
	 6Ac7CLyDQhGPtXEiVCAVn74zsqpVVqk9w3p35wHq6I+azLSF0daQonlcRx8tOuUJXn
	 GDxEleG2fgVGg==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v6 03/12] net/rds: guard every work-requeueing site with rds_destroy_pending()
Date: Tue, 22 Sep 2026 09:43:09 -0700
Message-Id: <20260922164318.447049-4-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260922164318.447049-1-achender@kernel.org>
References: <20260922164318.447049-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
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

The IB completion sites are reachable from soft-irq at any point
before the QP is drained, so a completion landing in the window
between the cancel and destroy_workqueue() in rds_conn_path_destroy()
re-arms a work on a workqueue that is about to be destroyed: with
delay 0 the work is queued directly on the freed workqueue, and with
delay 1 the timer survives destroy_workqueue() unseen and fires
afterwards, queueing from a timer_list that lives in the freed c_path
array.

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

Fixes: ebeeb1ad9b8a ("rds: tcp: use rds_destroy_pending() to synchronize netns/module teardown and rds connection/workq management")
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/ib_recv.c    |  6 +++++-
 net/rds/ib_send.c    | 18 ++++++++++++++----
 net/rds/send.c       | 11 ++++++++---
 net/rds/tcp_listen.c | 10 +++++++---
 4 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index bd6cb3ffaa57..7d45808544a0 100644
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
index 1afa981e5c06..32c411d10e3e 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1378,9 +1378,14 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
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
2.25.1

