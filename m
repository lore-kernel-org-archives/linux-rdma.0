Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793934989;
	b=Uds5Zjmq+N1EougFeZiALNQXNvg2iWQf2cBfQJdLnaLs/b2gNkmNSAqu0aaKOuD0u73F
	 apMTaF2nxRFBCJE/T9nV4blloiQfBGdm9xBuQMvZ8vtqbiBGvXlS2MqUOD1Lx6uKJyhma
	 l36DYoKRxZ+NAf/iGYp//7CuOvTV7uTnwgeKlU3ryRZn5Si/I9gpqOivurRhBumJC1Zei
	 vkdnzmzj5Oj2liE75T4treXt6P495Pr+ZTxoEOnDevDXDCjtRCMHE/Pu1OXAruVX81c2A
	 P8pyC+6hgxEpPaKLVfyHMLR0FhMOecE7EzbWDhRRHKtdRXqBtWUw7TQLmJq1UjkEu5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793934989;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=5SHtK00FrDS/tP8gGyt2PMFM+fCyBrUnSR45eHoy8dY=;
	b=XMKCXZhY2rPaDwzp6LaeP+ITAPccswh3mhQnxsuDSXPjMWNdw6UihyBzmqBfW0mKZJ/w
	 fLmSzZp0ZGfNjQR82pNsQV5+r5ZC8qgqcITVvOcDv7QvptKAIJtkwpA2MyHS6A7iSvp04
	 AmAhyf//LpdE/vB/8z14iywT4Fpatsm9Uq6k6jLvnojkbuOgGBDc7KqKBsLEMPWSVa6ph
	 uLeat2nVYRb5nMvQe2KY4ltO2EUIW5CIdFRW7dPLzJYoahQR6eJV21uwItL4AzpyZh9fV
	 8sun+R7W9v682CkpO3/rdyJAsUThjea7zt0SyUXrSLxVuFPHlle/pZkJWAkxC+Bf+mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dd2HQNim;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C29606D803;
	Fri,  6 Nov 2026 03:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dd2HQNim
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E311F008A1;
	Fri,  6 Nov 2026 03:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793934983;
	bh=5SHtK00FrDS/tP8gGyt2PMFM+fCyBrUnSR45eHoy8dY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dd2HQNimr59uHNwf9ZXq3ovm0vlEfVMnMESe83VbPEKda9YOvpfL/+UH2NvMIQfh4
	 Fd87hsScoLTrnDcfO9S05D9LU9Gk7VzfrmOQTWwVOyHNkDRKf+4scMnWSYkc4PUKch
	 F3dpIWtNoaQ5KcxseEf2JisNX9sGiGfRFW3h7Rk1lp+R/0Lx2lyZYKsRIKtx3PfB93
	 /kg9VjsOAk7Ts6Q+2aMzhXLAcgFn/vFfi7jANFMkLoB5aqfE+q0Mr/YzSCCiAJOcPT
	 FZioi4PnF2HEBjL0BSdEIGJxW05l0J0GFattvNP3zfzl9IBtOdqYCxg9tFrXBtT0aS
	 d1HFklftj+ykw==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v11 11/12] net/rds: pin the connection across RDMA-CM event handling
Date: Thu,  5 Nov 2026 20:16:14 -0700
Message-ID: <20261106031615.1047052-12-achender@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261106031615.1047052-1-achender@kernel.org>
References: <20261106031615.1047052-1-achender@kernel.org>
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
 net/rds/ib_cm.c          | 25 +++++++++++++++++++++++--
 net/rds/rdma_transport.c | 19 ++++++++++++++++++-
 2 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 5bf6b22c10d6..ff3189bfe498 100644
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
@@ -930,8 +939,8 @@ int rds_ib_cm_handle_connect(struct rdma_cm_id *cm_id,
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
@@ -950,6 +959,18 @@ int rds_ib_cm_initiate_connect(struct rdma_cm_id *cm_id, bool isv6)
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
diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
index 75532734c054..03c21ce2324c 100644
--- a/net/rds/rdma_transport.c
+++ b/net/rds/rdma_transport.c
@@ -60,6 +60,21 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
 	rdsdebug("conn %p id %p handling event %u (%s)\n", conn, cm_id,
 		 event->event, rdma_event_msg(event->event));
 
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
@@ -199,8 +214,10 @@ static int rds_rdma_cm_event_handler_cmn(struct rdma_cm_id *cm_id,
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
2.50.1

