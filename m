Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794545042;
	b=PuC+Jxkm7FjFsM6oUjkVXhUNZh3czC5Y0Az30mWWJG4OfawYjUiTWYPaw1Ias5Akuhqa
	 t6j22brKA+6WLmnYJMRbc0Ud+9b4imKtd43vdDrB9p4yLcT7c64uqUuTvkcqaXijwWuzL
	 s8KUX3GmbLZhzA3tErKBYwbwig/eZFbFKq2DJYKT4g46aO9zIWUAjmWT19X6soxvMadDl
	 sd7/e7WV4mYZSPkvJ8XEhfpfblo/3P4SsjaQdVlGDqVw4zHYLAR/95dncRw0wDBfNrdRO
	 SoHLbCb44jnOzmhmH5jjfdED0bgn1rlCCiQbKBLYYEPtenR6J1gFyxXrI224/2TJUIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794545042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=7Di1L7BSWw1TBFRpaQGa6rpVzqNErV/jhh7XpUXXTvU=;
	b=gb5whOfbtkQFFXKdaq8KfPRZtbhtTecBjeep2j8ciHQnzYdQi/EmvdF/VIoTfX+rDGCD
	 SnheJajheMkSIE8OMeXtaXsuQ0DQwBiv2zgbmKDS+g1r7TyvHpEw3vyFeiAQfSQSfFTaJ
	 Q2I4dKI9L3Q/bagP/P4MJJG+fttS4anRDJ3h2gggY8SvunE+e+UjU3nD+s2VNLFr0UGfR
	 2oBo9bq/Au3hen41zY8BK4Zl49JWl5DXPbvX9F4gGKx7raZkD2f3vzTQBvsGyEciciEpA
	 CN5NjulOeagKsg6RDhqV8Ckm9hzNl2WpYWvjpesvAAdGFM+sg9uYU+goRmhaAJ/8kZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HGy3r64j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AE460A2626;
	Fri, 13 Nov 2026 04:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HGy3r64j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931231F000C7;
	Fri, 13 Nov 2026 04:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794545041;
	bh=7Di1L7BSWw1TBFRpaQGa6rpVzqNErV/jhh7XpUXXTvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HGy3r64jolpzA3KWE4b3wLL0zN4nKigLtFUCio8dw6C58cE43njddRdWAP35AZHde
	 ivDOESdvXIuFl9Ap4E+jXeI00tUgfHxrKDiDS+1W6uGvCUQOwWLacXVAk3n8xtyOdT
	 Ca8fNezmkhCZGraub6xYraTG7ERY2lOOriOveQmE0+Mx6mZBOQ9vb4SZJ/KROCptb+
	 hw2aRacxIdVaj8XdSbyeuKrh+sGA6uIJfKFp4MaL6JDgexDtdPNpFUvIZ7CLrLfBrp
	 sg/90ca8ake9wGIMMO9R7/gt3MdIMzIIfFazQOdXLyy9D+zHuw3xNYoXMixqDiX0AO
	 ENkfzpx7G91xQ==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v12 11/12] net/rds: give cm_id->context a reference on its connection
Date: Thu, 12 Nov 2026 21:43:54 -0700
Message-ID: <20261113044355.2932029-12-achender@kernel.org>
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

rds_rdma_cm_event_handler_cmn() picks the connection up from
cm_id->context and holds c_cm_lock - a mutex that lives in the
connection's path array - across the transport callbacks, but the
context pointer owns no reference.  What keeps the connection alive
under the handler is ordering: rds_ib_conn_path_shutdown() destroys the
id, and rdma_destroy_id() waits for a running handler, before the
destroy drops the connection's initial reference, so no event is
handled on a connection that is being freed.  Before this series that
ordering was broken from inside the handler, since rds_conn_destroy()
freed synchronously and the one callback that destroyed its
connection, rds_ib_cm_connect_complete() on a protocol version below
3.1, left the handler's mutex_unlock() running on freed memory;
commit f97d8c7bab78 ("rds: ib: use rds_conn_drop() on protocol version
mismatch") has since switched that path to rds_conn_drop(), which also
removed the deadlock that destroy took on c_cm_lock.

Now that connections are reference counted, give the id a reference of
its own rather than rely on that ordering.  rds_ib_conn_path_connect()
takes it once rdma_create_id() has installed the connection as the
context, rds_ib_cm_handle_connect() takes it when it installs the id on
the passive side, and each is dropped after rdma_destroy_id() has
returned: in rds_ib_conn_path_shutdown(), and on the two failure paths
of rds_ib_conn_path_connect() that destroy the id straight away.  With
that the handler cannot find its connection freed under it, whatever
the callbacks do to the other holders - the destroy's initial
reference, a socket's cache, a parent's c_passive, an inc.  None of the
new puts can be the last reference: the shutdown runs on behalf of a
destroy, or of a drop on a connection still in the hash, and the
connect worker runs on a connection still in the hash, and each of
those holds a reference of its own.

rds_ib_cm_initiate_connect() and rds_ib_cm_handle_connect() get a
defensive check of the same kind.  A destroy that began while the
address and route were resolving either waits on c_cm_lock behind the
ROUTE_RESOLVED handler - and its shutdown pass then tears down
whatever the handler set up, QP, cm_id and device reference alike - or
has already destroyed the id, in which case no event for it reaches
the handler.  On the passive side a quiesced connection is unhashed,
so rds_conn_create() cannot hand it to a connect request, and the
listeners are stopped before any IB connection is destroyed at unload.
Neither path is reachable today, then; both functions nevertheless
decline to set up a QP, or install a new cm_id, on a connection whose
destroy has begun, so that the contract does not rest on that
ordering.  rds_ib_cm_initiate_connect() returns success when it
declines: the id is still ic->i_cm_id, for the shutdown to destroy,
and a non-zero return would have the rdma_cm destroy it instead.  An
unload that begins after the check has passed is covered by
rds_ib_add_conn() refusing a device that rds_ib_dev_shutdown() has
marked.

Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/ib_cm.c          | 41 ++++++++++++++++++++++++++++++++++++----
 net/rds/rdma_transport.c |  7 +++++++
 2 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 5bf6b22c10d6..a580a8c667ca 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -876,6 +876,15 @@ int rds_ib_cm_handle_connect(struct rdma_cm_id *cm_id,
 	 * see the comment above rds_queue_reconnect()
 	 */
 	mutex_lock(&conn->c_cm_lock);
+	/* Defensive: a destroy that has quiesced this conn also unhashed
+	 * it, so rds_conn_create() cannot have returned it, and the
+	 * listeners are stopped before any IB connection is destroyed at
+	 * unload.  Should a request reach a conn in RDS_CONN_DOWN with
+	 * its destroy begun all the same, do not install a new cm_id and
+	 * QP that nothing would tear down.
+	 */
+	if (rds_destroy_pending(conn))
+		goto out;
 	if (!rds_conn_transition(conn, RDS_CONN_DOWN, RDS_CONN_CONNECTING)) {
 		if (rds_conn_state(conn) == RDS_CONN_UP) {
 			rdsdebug("incoming connect while connecting\n");
@@ -904,6 +913,10 @@ int rds_ib_cm_handle_connect(struct rdma_cm_id *cm_id,
 	BUG_ON(ic->i_cm_id);
 
 	ic->i_cm_id = cm_id;
+	/* The id owns a reference on the connection it points at, put
+	 * after rdma_destroy_id() in rds_ib_conn_path_shutdown().
+	 */
+	rds_conn_get(conn);
 	cm_id->context = conn;
 
 	/* We got halfway through setting up the ib_connection, if we
@@ -928,10 +941,8 @@ int rds_ib_cm_handle_connect(struct rdma_cm_id *cm_id,
 out:
 	if (conn) {
 		mutex_unlock(&conn->c_cm_lock);
-		/* Drop the reference rds_conn_create() handed us.  The
-		 * conn stays reachable through cm_id->context without a
-		 * reference of its own for now; the CM event handler is
-		 * given one of its own by a following patch.
+		/* Drop the reference rds_conn_create() handed us; the
+		 * cm_id holds its own from here on.
 		 */
 		rds_conn_put(conn);
 	}
@@ -950,6 +961,18 @@ int rds_ib_cm_initiate_connect(struct rdma_cm_id *cm_id, bool isv6)
 	union rds_ib_conn_priv dp;
 	int ret;
 
+	/* Defensive: a destroy that began while the address and route
+	 * were being resolved either waits on c_cm_lock behind this
+	 * handler, and its shutdown pass then tears down whatever is
+	 * set up here, or has already destroyed the id this event
+	 * arrived on, in which case the event never gets here.  Decline
+	 * to set up a QP all the same, and return success: the id is
+	 * still ic->i_cm_id, for that shutdown to destroy, and a
+	 * non-zero return would have the rdma_cm destroy it instead.
+	 */
+	if (rds_destroy_pending(conn))
+		return 0;
+
 	/* If the peer doesn't do protocol negotiation, we must
 	 * default to RDSv3.0 */
 	rds_ib_set_protocol(conn, RDS_PROTOCOL_4_1);
@@ -1007,6 +1030,10 @@ int rds_ib_conn_path_connect(struct rds_conn_path *cp)
 		rdsdebug("rdma_create_id() failed: %d\n", ret);
 		goto out;
 	}
+	/* The id owns a reference on the connection it points at, put
+	 * after rdma_destroy_id() wherever the id is destroyed.
+	 */
+	rds_conn_get(conn);
 
 	/* rds_ib_laddr_check() only vouched for the local address being
 	 * on an IB device; the address resolution below picks the device
@@ -1017,6 +1044,7 @@ int rds_ib_conn_path_connect(struct rds_conn_path *cp)
 		rdsdebug("rdma_restrict_node_type() failed: %d\n", ret);
 		rdma_destroy_id(ic->i_cm_id);
 		ic->i_cm_id = NULL;
+		rds_conn_put(conn);
 		goto out;
 	}
 
@@ -1058,6 +1086,7 @@ int rds_ib_conn_path_connect(struct rds_conn_path *cp)
 			 ret);
 		rdma_destroy_id(ic->i_cm_id);
 		ic->i_cm_id = NULL;
+		rds_conn_put(conn);
 	}
 
 out:
@@ -1188,6 +1217,10 @@ void rds_ib_conn_path_shutdown(struct rds_conn_path *cp)
 			rds_ib_recv_clear_ring(ic);
 
 		rdma_destroy_id(ic->i_cm_id);
+		/* The id's reference on the connection.  Never the last
+		 * one: whoever runs this shutdown holds its own.
+		 */
+		rds_conn_put(conn);
 
 		/*
 		 * Move connection back to the nodev list.
diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
index 75532734c054..5d7d41c2db29 100644
--- a/net/rds/rdma_transport.c
+++ b/net/rds/rdma_transport.c
@@ -60,6 +60,13 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
 	rdsdebug("conn %p id %p handling event %u (%s)\n", conn, cm_id,
 		 event->event, rdma_event_msg(event->event));
 
+	/* cm_id->context owns a reference on the connection, dropped
+	 * only after rdma_destroy_id() has returned, and that waits for
+	 * a running handler.  The connection, and the mutex released at
+	 * out: that lives in its path array, therefore outlive this
+	 * handler whatever the callbacks below do to the other holders.
+	 */
+
 	/* Prevent shutdown from tearing down the connection
 	 * while we're executing. */
 	if (conn) {
-- 
2.50.1

