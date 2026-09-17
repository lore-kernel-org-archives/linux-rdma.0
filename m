Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A9448E0DF;
	Thu, 17 Sep 2026 07:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789630806; cv=none; b=ZatyT+2W9DMk79fa4HsjH5aYWys27JtITKo7fzOwW2kJN2SkZlxIgrAMGdKISB1iIyBFdOPNEzPHtLRQ5+waNLTIxHtRMbR+6xO5FLtynoGqmEx7o3GfSsghyes7VCOwTONEddyN+VGpPe/k3mP6XnjYNhp9otR06Zo6wFvnq1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789630806; c=relaxed/simple;
	bh=xP1+B8s6+03E7azRS6cSqnoiWhdEx4pCDa3v2nexzXY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Gr75MCMSKyfDTJi5NlNbdi0rPBTkuV6WMqXY7lELbgtD39EM2wHgA3g629dmdpJOBkPxorxAlCEvwpJqKkzUEH1ERhP+Zs0llOutKxeVedyy9bGH96HJxgfDIbTFghbinMqmhtrHoYbVnUEdYiHLTIsTdpOsrWOmgaDumVMT8kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jIR1Psrl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jIR1Psrl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959B71F0089D;
	Thu, 17 Sep 2026 07:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789630805;
	bh=/qxnNdBmuJn+szU3I37+2/b2M2I9HNjdDZRyc5bq41Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jIR1PsrlnFaoHas3YVkC3USbKecWnaMBb6WzZEQF7MkdFnBpuplOECAeqQewqitjQ
	 V+OEmCXn8LtoRQgvpW3Y0MLgrNNdXkWSZQYL9ll7pYkvU63/juu996eOd/9ZhKYfJC
	 YxFPycWW6uWMDIg31jyE5qtlmMpHfkvVcr3dCLyxw64k1zCIIqJMS21oRBTcTOiYlj
	 J/jk4BYf1jV0OAuQo5y346hkn87hdCc4Hw0UIEyhhXT6Y0DyDeAp63Ma84Hax0gjrq
	 ZIvX1TjeWbDXipl2h1GJyo8TXyPSBKKis6hrGGfg4lweofVoDkQJ5XAQfO2uW9yvNt
	 x+eBxPXUA+9Sw==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	nicoyip.dev@gmail.com
Subject: [PATCH net-next v4 10/12] net/rds: pin the connection across RDMA-CM event handling
Date: Thu, 17 Sep 2026 00:39:56 -0700
Message-Id: <20260917073958.174056-11-achender@kernel.org>
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
 net/rds/ib_cm.c          |  7 +++++++
 net/rds/rdma_transport.c | 16 +++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 98f34b494237..019956048873 100644
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
-- 
2.25.1

