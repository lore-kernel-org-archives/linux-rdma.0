Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41346363094;
	Mon, 14 Sep 2026 03:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789357046; cv=none; b=DOL08S/pxQjBth9SeWjzhR7NmeZ8T5SL92/DU9XGaX0Tk7Aoe6Lgcac6yNiQit54kQ+waAewY58T7wQG+FfrNX1VO5Q13gf1sw0RDUGbHCbLd4oadjoa6t7/OtoCMpTtPaHU5POlihDgnTw4za79zDPzoIuz1TWZRoPuC7QfSIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789357046; c=relaxed/simple;
	bh=8+OhiZRjvF7KujPyEhg3gPFCxre4hX+0uyea0psY9/4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HooOEHWyCAON1lQSJZZ4omrZVpm7jkHz61+X79R2tsK7Nvc5qu1bkN5ydnpLw/6M/YMP5EKNPJEYLxoNo58l+0gl2Gzc0+XcvzJfYZRCbMscWP3CQrt0VPRGblitM1YI7YriSmRz8TNWfUdtcuZJhi6U5mg12jOetJycoCOmPKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y0bjQFOd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y0bjQFOd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59FF1F00899;
	Mon, 14 Sep 2026 03:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789357045;
	bh=WMerKWCwexzeX9o5LqzV4MR+FgB7O8WlDiNKZvNus2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y0bjQFOddvM6+AdtAAx24EFW8TsjGbjSi0ZcfR4Ea4Rs3RvVQJ+aVN9xn+n0KdflJ
	 2Q6JvP5EKmJiJVTl+BzkaQLJeD+bImZNbA9+vbLB6GBKUKXKxuvMMwwjg5hHoKtyQo
	 SWJsSHMCPCwL1ndKHMIlvkee4e5NHY0bTMghxolNU2paUAyVc8zAb4nBHzcBhb8nyV
	 /A3KlNi/98F2ZDC3CF/zpp/J+CN54Smvu0UyPINdWgggzYdqy55tDP7JrqvPeBXsa2
	 g8+lposeZCUzo4yuCjzwLhfu8X1d67aa7L9/PKihVu9VOSAb2BrSHc13FUy6emArPc
	 VJEUJvrFhg1Dw==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	nicoyip.dev@gmail.com
Subject: [PATCH net-next v3 09/13] net/rds: refuse to queue a message on a connection being destroyed
Date: Sun, 13 Sep 2026 20:37:15 -0700
Message-Id: <20260914033719.138057-10-achender@kernel.org>
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

rds_conn_path_quiesce() tears down cp_send_queue by walking it with no
lock held.  That was tolerable while a connection could only be
destroyed with no sender in flight, but a sender now holds a
reference across rds_sendmsg(), and rds_conn_destroy() can quiesce
the connection underneath it.  rds_send_queue_rm() adds to
cp_send_queue under cp_lock, so the unlocked walk races the add and
can corrupt the list.  Worse, a message added after the purge sits on
the queue of a quiesced connection holding the connection reference
rds_send_queue_rm() took for it: the reference is only dropped when
the message is freed, the message is only freed when the queue is
torn down, and the queue is only torn down by the destroy that has
already run.  The connection would never be freed, and with it the
transport could never unload.

Splice the queue away under cp_lock in the quiesce, and have
rds_send_queue_rm() test rds_destroy_pending() under that same lock
before it touches either queue.  A sender that gets there first has
its message purged; one that gets there second is refused, and
rds_sendmsg() returns -EAGAIN for it, the same result the early
rds_destroy_pending() check in rds_sendmsg() already produces for a
connection whose destroy had begun before the send started.
rds_send_queue_rm()'s *queued becomes negative on refusal so that the
wait loop in rds_sendmsg() stops waiting for send room that will never
come.

Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/connection.c | 16 ++++++++++++----
 net/rds/send.c       | 20 +++++++++++++++++++-
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index 7ef6fb9d352b..e5a8534c23cf 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -606,6 +606,8 @@ void rds_conn_shutdown(struct rds_conn_path *cp)
 static void rds_conn_path_quiesce(struct rds_conn_path *cp)
 {
 	struct rds_message *rm, *rtmp;
+	unsigned long flags;
+	LIST_HEAD(purge);
 
 	if (!cp->cp_transport_data)
 		return;
@@ -617,10 +619,16 @@ static void rds_conn_path_quiesce(struct rds_conn_path *cp)
 	rds_conn_path_drop(cp, true);
 	flush_work(&cp->cp_down_w);
 
-	/* tear down queued messages */
-	list_for_each_entry_safe(rm, rtmp,
-				 &cp->cp_send_queue,
-				 m_conn_item) {
+	/* Tear down queued messages.  Take the queue under cp_lock:
+	 * a sender that still holds a reference can be inside
+	 * rds_send_queue_rm() right now, and it tests
+	 * rds_destroy_pending() under the same lock, so after this
+	 * splice nothing is added behind our back.
+	 */
+	spin_lock_irqsave(&cp->cp_lock, flags);
+	list_splice_init(&cp->cp_send_queue, &purge);
+	spin_unlock_irqrestore(&cp->cp_lock, flags);
+	list_for_each_entry_safe(rm, rtmp, &purge, m_conn_item) {
 		list_del_init(&rm->m_conn_item);
 		BUG_ON(!list_empty(&rm->m_sock_item));
 		rds_message_put(rm);
diff --git a/net/rds/send.c b/net/rds/send.c
index 1ae1f24c24e8..94d6ac174dde 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -928,6 +928,19 @@ static int rds_send_queue_rm(struct rds_sock *rs, struct rds_connection *conn,
 	 * and poll() now knows no more data can be sent.
 	 */
 	if (rs->rs_snd_bytes < rds_sk_sndbuf(rs)) {
+		/* rds_conn_path_quiesce() empties cp_send_queue under
+		 * cp_lock once the connection's destroy has begun.  Test
+		 * for that under the same lock, before touching either
+		 * queue: a message added after the purge would hold a
+		 * connection reference nothing ever drops.
+		 */
+		spin_lock(&cp->cp_lock);
+		if (rds_destroy_pending(conn)) {
+			spin_unlock(&cp->cp_lock);
+			*queued = -EAGAIN;
+			goto unlock;
+		}
+
 		rs->rs_snd_bytes += len;
 
 		/* let recv side know we are close to send space exhaustion.
@@ -951,7 +964,6 @@ static int rds_send_queue_rm(struct rds_sock *rs, struct rds_connection *conn,
 		rm->m_inc.i_conn_path = cp;
 		rds_message_addref(rm);
 
-		spin_lock(&cp->cp_lock);
 		rm->m_inc.i_hdr.h_sequence = cpu_to_be64(cp->cp_next_tx_seq++);
 		list_add_tail(&rm->m_conn_item, &cp->cp_send_queue);
 		set_bit(RDS_MSG_ON_CONN, &rm->m_flags);
@@ -964,6 +976,7 @@ static int rds_send_queue_rm(struct rds_sock *rs, struct rds_connection *conn,
 		*queued = 1;
 	}
 
+unlock:
 	spin_unlock_irqrestore(&rs->rs_lock, flags);
 out:
 	return *queued;
@@ -1474,6 +1487,11 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 			ret = -ETIMEDOUT;
 		goto out;
 	}
+	/* rds_send_queue_rm() refused: the connection is being destroyed */
+	if (queued < 0) {
+		ret = queued;
+		goto out;
+	}
 
 	/*
 	 * By now we've committed to the send.  We reuse rds_send_worker()
-- 
2.25.1

