Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4604F3ABD82;
	Thu,  8 Oct 2026 03:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791429220; cv=none; b=Pa8WBSKwl3O0/5+asqBz1XclsLn121i4LccSuWTTCw99J1EJNjL12Nqs2O5COtsniSBSP8Y7yJcwT1n/6Uyw/LUXUMB425Z3AXBM/7AWR5Tu22Y2VeuCqUqZuEutkAHsezo1/WAfZB2Xspa45BX8fiRDoDlyGJ+Nrd8LRN7UElA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791429220; c=relaxed/simple;
	bh=lFxnp+0T3xUD0pesEZjinLYrx1nPfwUvYRaGJhvZ5sI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oHdyag32QbYmqKNwY7gMQEavmIG8AqcWa6t0KRP7Fqao/ShErG2rbM5Xau10fnGNpp+uHbgcuNxe1HEJgmG1L/qUpZqAhrxG0Jq610qP33Mip5kBuvFwXf8fL/QnJ+6MFJuc96ztr6A5YUzp8oMxVuaa74uDa1oKgDHvBs7uKfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZkxbXsij; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZkxbXsij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41711F0089B;
	Thu,  8 Oct 2026 03:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791429219;
	bh=/uPDUY3wwVIRqLO8keCN951MAtCrIwbwiDF+YltReJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZkxbXsijNG5DNQZyvrVFNH/Sahy37wUwt364NKFh+rOCRL6x9l30kayq4x67yXEBE
	 /7ibwRBnW8YfktGejJASRnxrAZXlVWSDmhDU8TtqHI8vp47deL4Vf7nuSNOD+xt6Ni
	 eeVk+YXIwiq2n6+cjZJLuhcPOkYYU1Jhxnf0A9lYuCgpt+J8ouKp7oxo16xi3l/qjh
	 ezSWND27dWoQvkP9TEWd4LAtfw0QCazH8WU6IQgnJ00K9BOX3rVNKn8VRYs4o3dpzC
	 wqNT/f1GMuUgqMnph3jJNpQIuvM/+2X6IVK/nF02qrEIysFBM3X5phIQHrk77rwJY8
	 qmKk5g32UAk6A==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v9 10/13] net/rds: take cp_lock to purge cp_send_queue in the quiesce
Date: Wed,  7 Oct 2026 20:13:30 -0700
Message-Id: <20261008031333.1142174-11-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261008031333.1142174-1-achender@kernel.org>
References: <20261008031333.1142174-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rds_conn_path_quiesce() empties cp_send_queue by walking it with no
lock held, while every path that adds to that queue -
rds_send_queue_rm(), rds_send_probe(), the retransmit requeue in
rds_send_path_reset() - does so under cp_lock.  The unlocked walk was
justified by the destroy running with nothing else alive: at every
destroy trigger there is - netns teardown and module unload - no
socket can still be sending on the connection, since a bound socket
pins its transport module and a namespace closes its sockets before
its RDS connections are torn down.

That argument still holds, but it is an argument about the callers,
not a property of the code.  Splice the queue away under cp_lock and
drop the message references outside it, so that the one walker of the
list follows the same lock discipline as its adders.  This does not
by itself make a sender that is still running safe - nothing here
tells such a sender that the queue is closed - and it does not need
to, since no such sender exists at any destroy trigger.

While at it, make the purge coherent with rds_send_drop_to(), the
other path that removes messages from a connection queue.  drop_to
decides whether it owns the queue's reference by test_and_clear on
RDS_MSG_ON_CONN, and unlinks m_conn_item from whatever list the
message is on.  The purge used to BUG_ON() a message that a socket
still had queued, and that assertion is also what kept a drop_to
racing it from putting the queue's reference a second time or
unlinking from the purge list; the lock above is what closes the
stale-next hazard of the old walk, not the assertion.  Clear the bit
under cp_lock as part of the splice, so that drop_to leaves a purged
message alone, and turn the BUG_ON() into a WARN_ON_ONCE(): a socket
with messages queued at destroy is still a condition worth reporting -
no sender or closer can be running at any destroy trigger today - but
not one worth a panic, since the socket side keeps its own reference
and retires the message on close.

Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/connection.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index c7655e9339ca..9c8c4b28d2b2 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -540,6 +540,8 @@ void rds_conn_shutdown(struct rds_conn_path *cp)
 static void rds_conn_path_quiesce(struct rds_conn_path *cp)
 {
 	struct rds_message *rm, *rtmp;
+	unsigned long flags;
+	LIST_HEAD(purge);
 
 	if (!cp->cp_transport_data)
 		return;
@@ -551,12 +553,29 @@ static void rds_conn_path_quiesce(struct rds_conn_path *cp)
 	rds_conn_path_drop(cp, true);
 	flush_work(&cp->cp_down_w);
 
-	/* tear down queued messages */
-	list_for_each_entry_safe(rm, rtmp,
-				 &cp->cp_send_queue,
-				 m_conn_item) {
+	/* Tear down queued messages.  Every path that adds to
+	 * cp_send_queue does so under cp_lock; take it here too.  No
+	 * sender can still be running at any destroy trigger, so this is
+	 * lock discipline rather than a race fix: nothing here tells a
+	 * sender that the queue is closed.
+	 */
+	spin_lock_irqsave(&cp->cp_lock, flags);
+	list_splice_init(&cp->cp_send_queue, &purge);
+	/* Give up the queue's claim on each message while still under
+	 * the lock, so that rds_send_drop_to(), which decides ownership
+	 * of the connection-queue reference by this bit, neither drops
+	 * it a second time nor unlinks the message from our list.
+	 */
+	list_for_each_entry(rm, &purge, m_conn_item)
+		clear_bit(RDS_MSG_ON_CONN, &rm->m_flags);
+	spin_unlock_irqrestore(&cp->cp_lock, flags);
+	list_for_each_entry_safe(rm, rtmp, &purge, m_conn_item) {
+		/* No socket can still have messages queued on a connection
+		 * at any destroy trigger; say so if one does, since the
+		 * socket side then retires the message on its own.
+		 */
+		WARN_ON_ONCE(!list_empty(&rm->m_sock_item));
 		list_del_init(&rm->m_conn_item);
-		BUG_ON(!list_empty(&rm->m_sock_item));
 		rds_message_put(rm);
 	}
 	if (cp->cp_xmit_rm)
-- 
2.25.1

