Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794545041;
	b=I+c/PnfXGvL74JhT1cFA/m2TXEYi+UrZ8rbcVux60rHBBSnkcZ/K96KqYuWinJwXhUkR
	 6T7PEQJPcFk3wollrSmmgsjWl674NM5wYANdHfEy1KHiv4YrlKGPCG5hi3SpPvryRl1pZ
	 4/QSXDN0kZWuJ3gER6DOFIGqxWkOF3M/3EZ1CMeQZbmcFX0zkmgMp8CF6PBw0qURaGvC3
	 3vZKqWgAC7u1EDtl7JXKj9Q5b9GoaWz/y4bDuXM3qzc+hOJvNFh9oTsFQXnAysmuouRHg
	 R7Ewj/GCR6r/SUFf70W4WeBD1Uwuod4C9s0rEByPcgMsntBV4GthUjP0H7jB0biDH4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794545041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=6xaoxifvY23UPd5Pl5k1g4wGQeX4X9m3tRKXdO7g+0k=;
	b=JhRn8r9QH56fUVjCXRDePMEFqiVpEhk3Rb5rGf7yxRCXQ0ay4ULDV12IuCzWYehoKIve
	 umwMkK3A8RhJT5P74tAvGXY1x8msKQwXUvziqA/8a0iWzQh5kHxxnDOOGI+ZTi6qQucav
	 dbMN+lRQKr7676pXZugYapxG5N0EVw9dH2X8v/h9corXWSaFwBqGOxBZ0+O+VJMe+iZ2+
	 5AB7ilLxQE4E05WPbmp7WiphLVp1hHiO1cLyHM4Ki041e5RArfOa3HNEmqIq2inYRUzmF
	 FMWU3r7+eJP+3ztQSCJuf0oOOvYGtT3fxFLfU/FXUtAroZK6GjlmoAeMIWmeCi0UhrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dBGy9r+S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0414F60A260D;
	Fri, 13 Nov 2026 04:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dBGy9r+S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D6F1F000C7;
	Fri, 13 Nov 2026 04:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794545040;
	bh=6xaoxifvY23UPd5Pl5k1g4wGQeX4X9m3tRKXdO7g+0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dBGy9r+ShxCmLjYrEl+chzRJqYIi3NRwsd4fgFVBw/pmEZO0COMSiEACtq80RHeyE
	 XuZ18dVh89ibhuvDa9pkc/juhYeVf7/AOsbfQgYR7KiU9U3J1Y33KAHOGS0cABTeFw
	 Lms0zlTy6o4T+lPcsjtQe/G7rsg9lzdlgOyoJK/f6+6rwPqwggfhDFwT93HJh2t7Wo
	 eYAy8uEUAh85OF6VkoSO6hztmLmiceC62k25c58jT3jKRT2UIVu9hgQF+WOH3Sc0dD
	 lTl4tUQDmCKcZktZ/4A2mQ4d22lDDrvs+Q95a+iz3p8DHa5kEG0BvkB73BBuXVfQqG
	 ktijN9tn0sN9Q==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v12 09/12] net/rds: take cp_lock to purge cp_send_queue in the quiesce
Date: Thu, 12 Nov 2026 21:43:52 -0700
Message-ID: <20261113044355.2932029-10-achender@kernel.org>
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
2.50.1

