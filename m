Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53003522694;
	Tue, 22 Sep 2026 08:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790067259; cv=none; b=rkK/krpt7364eAIZZdrk6CXWpm6gS8GQe3LsB5/mbchuhybsMDzGUVLSRmFegb99XtwnVbJx3iot5rqOH/rZsZU91LnLd0rVQyj2OE81gBPDx/NFoS1pPRzgnUPnTtTqvWdbu+44P81AeEOoal0eGA4kK9WdWrk3/IMiSHNM26o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790067259; c=relaxed/simple;
	bh=3ZTV/pSkrGqVG4UEI/jXaaswwIQyXULQcw5G9T2P+qo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OirPNi8lmSu5b/jMlDdToA8GfyONAgB6YESynUWoS9IwjOiROBzCEQY2HMzAD8IcupwKlZhP9Vcg7ULErn1a3NIHTewjtHXN+2hvLRgIgt7kdHu5ZjWiKYpia1DgGr0IGPG4otPpRAtmfN+JuNngFWrZ8Y9PqgQqtXVsVy6mEQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nwG6gDHH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nwG6gDHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A301F00893;
	Tue, 22 Sep 2026 08:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790067257;
	bh=qC/KmragR2dwQD40DU3E5XJWqgNbvOuROd8+8Pl+HTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nwG6gDHH+ti+yT7knqXms9nW2o3/YrXl+r3fZOwTcsKWcms7I8N9GDI+Z4V3W/P8+
	 4KmGiHh9ckOWXmY0KNfNILr8dP3ChWat1DS03orsIcr+W68ApyNCMe8sapb7NkNF3S
	 MXllO9xpt/PFre8SEW+sIDjY1Sx87FD0A+kPfh+aVGptTDHuqVgOigu1Mm3Q4HHkpO
	 W/4/XssLp74J+JMAPh2+wZF3yn298AO5Wd1QSmKiZmj7r3R1vBsAUJdJnQp4ozl1p0
	 fDvytuVAARwaLmkwqLvS1KNKpZgmHrmgMj8JkMfo7TM4DpBUywEd6f+E9LB9QSLmCT
	 VLbUM1nj9bbNw==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v6 10/12] net/rds: pin the connection across RDMA-CM event handling
Date: Tue, 22 Sep 2026 01:54:08 -0700
Message-Id: <20260922085410.391323-11-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260922085410.391323-1-achender@kernel.org>
References: <20260922085410.391323-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rds_rdma_cm_event_handler_cmn() picks the connection up from
cm_id->context, which carries no reference, and holds c_cm_lock - a
mutex that lives in the connection's path array - across the transport
callbacks.  Before this series that was already a use-after-free
whenever a callback destroyed the connection, since rds_conn_destroy()
freed it synchronously and the handler's mutex_unlock() ran on freed
memory; the one such callback, rds_ib_cm_connect_complete() on a
protocol version below 3.1, has meanwhile been switched to
rds_conn_drop() by commit f97d8c7bab78 ("rds: ib: use rds_conn_drop()
on protocol version mismatch"), which also removed the deadlock that
destroy took on c_cm_lock.

Now that a connection is freed by its last reference, the remaining
exposure is a callback that drops the last reference other than the
handler's - which has none - and the reference handed out by
rds_conn_create() to rds_ib_cm_handle_connect() and dropped at its
end.  Take a reference for the duration of the handler, and ignore the
event if the connection is already being freed: its cm_id teardown is
what stops event delivery, so an event that still arrives belongs to a
connection whose shutdown has run and whose memory is on its way out.

rds_ib_cm_handle_connect() has the mirror-image hole: a connection
whose destroy has already quiesced it sits in RDS_CONN_DOWN with no
cm_id, which is exactly the state the DOWN -> CONNECTING transition
claims.  A connect request arriving then would install a new cm_id and
QP on a connection that is only waiting for its last reference to go
away, and nothing would tear them down again.  Re-check
rds_destroy_pending() under c_cm_lock and reject the request instead.

Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/ib_cm.c          | 11 +++++++++--
 net/rds/rdma_transport.c | 16 +++++++++++++++-
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 786ddcb45bcb..1b5491598433 100644
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
@@ -928,8 +935,8 @@ int rds_ib_cm_handle_connect(struct rdma_cm_id *cm_id,
 		mutex_unlock(&conn->c_cm_lock);
 		/* Drop the reference rds_conn_create() handed us.  The
 		 * conn stays reachable through cm_id->context without a
-		 * reference of its own for now; the CM event handler is
-		 * given one of its own by a following patch.
+		 * reference of its own; rds_rdma_cm_event_handler_cmn()
+		 * takes one for the duration of each event it handles.
 		 */
 		rds_conn_put(conn);
 	}
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
-- 
2.25.1

