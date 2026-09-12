Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28F6377A8F;
	Sat, 12 Sep 2026 03:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789185034; cv=none; b=AvSSEotN88N3B8DaN7auU8NZATByD1VoT512XrvbBEg/Q3pV7oQltsZW75P86eWyWzWgWM+IBT+L/fjO8EJ5k3yBJE3yZkWkFLN6yenYwdhH9DI3wBRiblqIvarkoUjPBheZKTrX2D8IHnOr9PqPDfPuJxXuqBx7BVT53Koykt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789185034; c=relaxed/simple;
	bh=OlSruQzvZPVPVlKABu/+7hL1xneyKnfN5IEg8NkHiok=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YQu1y6v+J4Is0Mh7BKIdBn10FyfrYKtXrrFmnZ4lCCVJ3dWE3w4LAlH7d63BFIqb5seZrCk6vB9bNS0nNQLPEGYSI26LmHLOJjDMTzqkktB3i7yXRksbPxd4onT4dhAbxy7GekTXJRpfZ2bSgfZNpjTThKfWtHEgdAPkI2aO2KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R8OLemmR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R8OLemmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFDA1F00899;
	Sat, 12 Sep 2026 03:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789185032;
	bh=PTmYRaZ9nxh4oHihWYZhowvY6twy/PxzOF0kisncgHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R8OLemmRjAtY2wgKSbkq3ePxSw91jot2p0NxrC77MQ1DPJkqsk9GShPEhbuvsa5W1
	 qhwTXt0ap/DByvFZHzHp5pEpgsWCDBpYJcY9zigFv3BZ89dPjgv3jRhere0BHPpRlV
	 Zu/XTniL5MANlPfWYs5pqBmViPHf4jd5MKqBr/F34uC0qRTVdfdmNUpVIFauKCu89V
	 WY9OWKOJvbljWqK0uCFGf96KnWw5wVF0Qs/qQ76nsZP0yTE0B49bfg1IsdkwsA8uOt
	 HGBZGhOgEokHwVoRu7VJ2TvW659CMvHVixlH7XHasfsiXgvC6traGINT6t6JP3LjMi
	 PKe1fb93atk1w==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	nicoyip.dev@gmail.com
Subject: [PATCH net-next v2 7/9] net/rds: pin the connection across RDMA-CM event handling
Date: Fri, 11 Sep 2026 20:50:25 -0700
Message-Id: <20260912035027.27447-8-achender@kernel.org>
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

rds_rdma_cm_event_handler_cmn() picks the connection up from
cm_id->context, which carries no reference, and holds c_cm_lock - a
mutex that lives in the connection's path array - across the
transport callbacks.  Now that a connection is freed by its last
reference rather than by rds_conn_destroy() itself, a callback that
drops the last reference other than the handler's implicit one leaves
the final mutex_unlock() running on freed memory.

Take a reference for the duration of the handler, and ignore the event
if the connection is already being freed: its cm_id teardown is what
stops event delivery, so an event that still arrives belongs to a
connection whose shutdown has run and whose memory is on its way out.

rds_ib_cm_handle_connect() has the mirror-image hole: a connection
whose destroy has already quiesced it sits in RDS_CONN_DOWN with no
cm_id, which is exactly the state the DOWN -> CONNECTING transition
claims.  A connect request arriving then would install a new cm_id
and QP on a connection that is only waiting for its last reference to
go away, and nothing would tear them down again.  Re-check
rds_destroy_pending() under c_cm_lock and reject the request instead.

Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/ib_cm.c          |  7 +++++++
 net/rds/rdma_transport.c | 16 +++++++++++++++-
 net/rds/rds.h            |  5 +++++
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 01e4b4be979d..323c1eee2777 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -874,6 +874,13 @@ int rds_ib_cm_handle_connect(struct rdma_cm_id *cm_id,
 	 * see the comment above rds_queue_reconnect()
 	 */
 	mutex_lock(&conn->c_cm_lock);
+	/* A destroy that has already quiesced this conn leaves it in
+	 * RDS_CONN_DOWN with no cm_id, exactly what the transition
+	 * below would happily claim; nothing would tear the new cm_id
+	 * and QP down again before the conn is freed.  Reject instead.
+	 */
+	if (rds_destroy_pending(conn))
+		goto out;
 	if (!rds_conn_transition(conn, RDS_CONN_DOWN, RDS_CONN_CONNECTING)) {
 		if (rds_conn_state(conn) == RDS_CONN_UP) {
 			rdsdebug("incoming connect while connecting\n");
diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
index b15cf316b23a..584e9867810f 100644
--- a/net/rds/rdma_transport.c
+++ b/net/rds/rdma_transport.c
@@ -63,6 +63,18 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
 	if (cm_id->device->node_type == RDMA_NODE_IB_CA)
 		trans = &rds_ib_transport;
 
+	/* cm_id->context carries no reference of its own.  Pin the
+	 * connection for the duration of the handler: what the callbacks
+	 * below do may drop the last reference other than ours, and the
+	 * mutex released at out: lives in the connection's path array.
+	 * A connection already being freed gets no events handled.
+	 */
+	if (conn && !rds_conn_get_unless_zero(conn)) {
+		rdsdebug("conn %p id %p is being freed, ignoring event\n",
+			 conn, cm_id);
+		return 0;
+	}
+
 	/* Prevent shutdown from tearing down the connection
 	 * while we're executing. */
 	if (conn) {
@@ -171,8 +183,10 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
 	}
 
 out:
-	if (conn)
+	if (conn) {
 		mutex_unlock(&conn->c_cm_lock);
+		rds_conn_put(conn);
+	}
 
 	rdsdebug("id %p event %u (%s) handling ret %d\n", cm_id, event->event,
 		 rdma_event_msg(event->event), ret);
diff --git a/net/rds/rds.h b/net/rds/rds.h
index 4608615e09e9..06d48c2821ef 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -840,6 +840,11 @@ void rds_conn_shutdown(struct rds_conn_path *cpath);
 void rds_conn_destroy(struct rds_connection *conn);
 void rds_conn_get(struct rds_connection *conn);
 void rds_conn_put(struct rds_connection *conn);
+/* take a reference unless the connection is already being freed */
+static inline bool rds_conn_get_unless_zero(struct rds_connection *conn)
+{
+	return kref_get_unless_zero(&conn->c_refcount);
+}
 /* transport unload waits for its connections to be freed, polling at
  * the first interval and warning at the second
  */
-- 
2.25.1

