Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DCE3BB69F;
	Sun, 27 Sep 2026 06:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790489697; cv=none; b=JFZSV3nyiA+/ZDgQspJ/EiE5m7cS1pmdZm0alVZGpXufADSmNRw6HNAU/QK3XHRkg9QzGBeM6DAwyRC/cV8xm53f35IX+li/R00FAO3xeWyFnXvQv12gL1t4ZhyqrL6nfpUfLcXKM+3yyauGJ1XGyxDrJEKnxswntXZQLMkVhs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790489697; c=relaxed/simple;
	bh=4OzLVR4ZQMxHRV32Ag4o7Y2MdLTiX727tRV8D15QizM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=F87aW8q8TDm/bpjCiRSghoY5gBgmHeaWWmhZl+mIvnWLM+5YKsvVQ3u4rg23EqnKplUQeCo/bg1SpaCu7GOybHY834iZNh/pxa5xQsYtQoXgEKvE39YPEr1j9t8i/TyXD77oTwF8ki1Gd/GOSO/nQLgemZI5/k9NY0RcK2cGC3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UhwGxxJV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UhwGxxJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CC11F00893;
	Sun, 27 Sep 2026 06:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790489695;
	bh=KGcA/OT7pb8KpumgbZ8yZuJHRDI3Eir56GoYQiX2nQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UhwGxxJVi8SnF/jO/nHLWqP1l8jdnJeGZR27xrTWQnVGMp5nTBN/q8UAMkOK3sciH
	 rK54TdxgoJ1mp8nz+hSuNckj9lyJwahOw+URRSv5Z985FMAPenDlcKjJXuwvBYAJVa
	 R5kdUrm1gq5NniMiEag1SAh/Mt9Sf1MZqj2ETtsyaQ0o9tex3qEuVfWUCKIz/fRZx0
	 nbG3g5oq8+BPhvyYOa6EvYhJDKmhZv+n8KUkF4zVE43BISbu9ijIobNr2PyvIV6Km8
	 x6KwRlz7JeLViffXQYPrZ1mO94n7hKMi9g5c4JI0/CgwV6PV4FJk9k5Fwf2D52svuL
	 Vy/hTW2dRhvyw==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v7 11/12] net/rds: pin the connection across RDMA-CM event handling
Date: Sat, 26 Sep 2026 23:14:47 -0700
Message-Id: <20260927061448.167862-12-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260927061448.167862-1-achender@kernel.org>
References: <20260927061448.167862-1-achender@kernel.org>
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

Now that a connection is freed by its last reference, none of the
callbacks the handler dispatches drops a reference on the connection
it was handed: the version-mismatch path only drops the connection,
and rds_ib_cm_handle_connect() puts the reference rds_conn_create()
gave it, on a connection the listener's cm_id never pointed at.  What
can reach zero while an event is in flight are the holders outside
the handler - the destroy's initial reference, a socket's cache, a
parent's c_passive, an inc.  Today the shutdown pass destroys the
cm_id, and rdma_destroy_id() waits for a running handler, before the
initial reference is dropped, so every event is ordered ahead of the
free; the pin is defensive, keeping the handler correct without
leaning on that ordering.  Take a reference for the duration of the
handler, and ignore the event if the connection is already at zero
references rather than handle it.

rds_ib_cm_initiate_connect() has the same hole on the active side: a
connection whose destroy began while its address and route were
resolving reaches RDMA_CM_EVENT_ROUTE_RESOLVED and sets up a QP -
taking a device reference in rds_ib_add_conn() - after the destroy's
shutdown pass has run, or with that pass waiting on c_cm_lock behind
the handler.  Nothing would ever release the QP, the cm_id or the
device reference, and rds_ib_exit() would wait forever for the
device.  Return before the QP is set up when the destroy is pending;
the cm_id is still ic->i_cm_id, so the shutdown destroys it.

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
 net/rds/ib_cm.c          | 22 ++++++++++++++++++++--
 net/rds/rdma_transport.c | 19 ++++++++++++++++++-
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index ee018dd230e9..948fbf4b6a85 100644
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
@@ -948,6 +955,17 @@ int rds_ib_cm_initiate_connect(struct rdma_cm_id *cm_id, bool isv6)
 	union rds_ib_conn_priv dp;
 	int ret;
 
+	/* A destroy that began while the address and route were being
+	 * resolved has already quiesced this conn, or is waiting on
+	 * c_cm_lock to do so.  Setting up a QP now would leave it - and
+	 * the device reference rds_ib_add_conn() takes - with no
+	 * shutdown pass left to tear them down.  The id we were handed
+	 * is still ic->i_cm_id, so return success and let that shutdown
+	 * destroy it, rather than have the rdma_cm destroy it on error.
+	 */
+	if (rds_destroy_pending(conn))
+		return 0;
+
 	/* If the peer doesn't do protocol negotiation, we must
 	 * default to RDSv3.0 */
 	rds_ib_set_protocol(conn, RDS_PROTOCOL_4_1);
diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
index b15cf316b23a..3dda7cf76ebb 100644
--- a/net/rds/rdma_transport.c
+++ b/net/rds/rdma_transport.c
@@ -63,6 +63,21 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
 	if (cm_id->device->node_type == RDMA_NODE_IB_CA)
 		trans = &rds_ib_transport;
 
+	/* cm_id->context carries no reference of its own.  Pin the
+	 * connection for the duration of the handler, since the mutex
+	 * released at out: lives in the connection's path array.  None
+	 * of the callbacks below drops a reference on this connection,
+	 * and the shutdown destroys the cm_id - waiting for a running
+	 * handler - before the last reference can go, so this is
+	 * defensive.  A connection already at zero references gets no
+	 * events handled.
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
@@ -171,8 +186,10 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
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

