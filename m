Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8187F47ECD0;
	Thu, 17 Sep 2026 07:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789630805; cv=none; b=MurD33LO/Bro6tDezs6eNWZVjeboTeFRFrpHD7ObY1v4Mekf1e1I7SrM//czNV8/mHbLJsFRI1cfPBaVIU9D2EWA3daDDLDiVYias8MtieA5AmsHZuDjtiUT3jlsmIbffKvcXe9eH7jKcqbYBtS9soicFNe/OVGpgsDbkBI93LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789630805; c=relaxed/simple;
	bh=KELhjF+Aurt+j0Volq8NsbFaAkFaJPeegQ4T68JqhBA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uj72m250JrWxfpO63hfaHkzz1EN6pcZuIm0VU5LejbhK/C2rms3aCeOyy8giANirlInsYS5pOKTQw1kZmE2miDLO9xe1It8D2Lizc/yn8av4+n2hi5RMOvDGIbnAe4wo4isYZwuNAlsD6VUlHKEL1Y8Kieawo20ADptKVJVstA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hmkjjiai; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hmkjjiai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FECE1F000FF;
	Thu, 17 Sep 2026 07:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789630804;
	bh=elVRUV81ZpWpsFhIbYE6xnGLDzj7RT+az03JknII20k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hmkjjiaiSu4/OrCe8EoVkOT6LCVLlJxJ6QHsAxdYgRA4RSP9IlunynMD78vDLdDxg
	 MYFoRln/ciI/vErIkXF2Zvslw88CWq+hn+QR2rFQkRQPE45rn8kf4vVaqPYcApzvaM
	 PS6UlA1OIb5mBDxOkL4X+mbXPS+VC8faL0PX5saCHhcaP4FwHyKJufooVA3Lol6PRB
	 xVpbIT5UlKrbXCCy/fmYqEO8V+foaVIA5EM2SzEhA8Ys7tGmoCwQ9A7Anm4UgyHvol
	 W3WfBgQ1cLNLkjZNX4bPnxDBSbFdbOOjHVRl67iFNX+OiPNb33tjxC6lNw/8/aZg8a
	 xq4+zPmzhKqOg==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	nicoyip.dev@gmail.com
Subject: [PATCH net-next v4 09/12] net/rds: refuse to queue on a connection being destroyed
Date: Thu, 17 Sep 2026 00:39:55 -0700
Message-Id: <20260917073958.174056-10-achender@kernel.org>
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
before it touches either queue.  rds_send_probe() adds to
cp_send_queue under cp_lock as well, for pings and pongs, and gets the
same test: a probe queued after the purge would pin the connection
just the same.  A sender that gets there first has
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
 net/rds/send.c       | 28 +++++++++++++++++++++++++++-
 2 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index 965d68e51a1c..5699f45e4c37 100644
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
index 2d7839438abd..f7bc4c5446d6 100644
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
@@ -1485,6 +1498,11 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
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
@@ -1567,6 +1585,14 @@ rds_send_probe(struct rds_conn_path *cp, __be16 sport,
 		goto out;
 
 	spin_lock_irqsave(&cp->cp_lock, flags);
+	/* Same rule as rds_send_queue_rm(): once the destroy has purged
+	 * cp_send_queue under this lock, nothing may be added behind it.
+	 */
+	if (rds_destroy_pending(cp->cp_conn)) {
+		spin_unlock_irqrestore(&cp->cp_lock, flags);
+		ret = -EAGAIN;
+		goto out;
+	}
 	list_add_tail(&rm->m_conn_item, &cp->cp_send_queue);
 	set_bit(RDS_MSG_ON_CONN, &rm->m_flags);
 	rds_message_addref(rm);
-- 
2.25.1

