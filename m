Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4C8528434;
	Tue, 22 Sep 2026 08:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790067258; cv=none; b=aA0KgXXD4ArUDNCKYaBfT4QKLD3RrmlCFtNdkxp8im8//iKxpwl38KXUfon6YsUFzLdDVRdl6HaCmacO5c/oMxjtQ5HU9JQvnqwHqnUjT1PEw3G5l1BG/RP5A8qhV06DaohVzvcEPLuTsrUqcrNgavKF/c7OFnTdeM7Nh8J7c3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790067258; c=relaxed/simple;
	bh=smTPhtfjLrQu6IRmDNDJjtyJdiyrhjs6SSdarXUD7xU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZUhvao15CODU45VUyT0EE29QiOwyo/UF6e1tibTJcER22VpqE1E1mDY07gf+6jQzDHxYEo6COQlG70D2iW5iSnaZuChhxV0joNhOFkCuenLfKKSNaJRYsjeMLcUJa563sl19vYgH82IJC+jG55T+Y56O/NTwVuext4t5o2hY11Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W+VRBqNn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W+VRBqNn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432741F0089D;
	Tue, 22 Sep 2026 08:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790067256;
	bh=wJF3I6GoPPDJcOGFLznkW5gFe0U9zrVhcEloSZ1K/+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W+VRBqNniJOtDF7o2kN21UF52mUjqVqX0a1takZTbxzYTtVaf5WwHWYF5S2ouKrKY
	 i9LnP5eiiQ75JLjYP/hqe8di+5KrtwRgXM17ZmVYi+5PsMHVkgaO+mWRwa9/tH+mwP
	 j6MLiHF88EgfU18fUpk8f2sYowD4RgYax8qurFenrbOiKGgYcspYtF11Wt+NWe6gvs
	 YdX92ZqLo5N9t0MS5QpxMuGhkdTKgLDztQVmanGvvK/esusN38BmXZVhyXBQ1mNIrz
	 q5MhGQEB3ejTI+xFTDQ/jRAOqkA9E/zJCl9kdlCB9q6nDf/Q2QoVLCjOkjqCq6OE3p
	 dcHTVNOU48qRQ==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v6 09/12] net/rds: take cp_lock to purge cp_send_queue in the quiesce
Date: Tue, 22 Sep 2026 01:54:07 -0700
Message-Id: <20260922085410.391323-10-achender@kernel.org>
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
not a property of the code, and the following patches make a
connection outlive its destroy in more situations.  Splice the queue
away under cp_lock and drop the message references outside it, so the
purge is correct against a concurrent adder regardless.

Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/connection.c | 15 +++++++++++----
 net/rds/send.c       |  3 +--
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index 9b86070814a7..adeaf35d0ed0 100644
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
@@ -617,10 +619,15 @@ static void rds_conn_path_quiesce(struct rds_conn_path *cp)
 	rds_conn_path_drop(cp, true);
 	flush_work(&cp->cp_down_w);
 
-	/* tear down queued messages */
-	list_for_each_entry_safe(rm, rtmp,
-				 &cp->cp_send_queue,
-				 m_conn_item) {
+	/* Tear down queued messages.  Every path that adds to
+	 * cp_send_queue does so under cp_lock; take it here too rather
+	 * than rely on the argument that nothing can be adding at this
+	 * point.
+	 */
+	spin_lock_irqsave(&cp->cp_lock, flags);
+	list_splice_init(&cp->cp_send_queue, &purge);
+	spin_unlock_irqrestore(&cp->cp_lock, flags);
+	list_for_each_entry_safe(rm, rtmp, &purge, m_conn_item) {
 		list_del_init(&rm->m_conn_item);
 		BUG_ON(!list_empty(&rm->m_sock_item));
 		rds_message_put(rm);
diff --git a/net/rds/send.c b/net/rds/send.c
index a83d4eca0c77..2d7839438abd 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1366,8 +1366,7 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 
 		conn = rds_conn_create_outgoing(sock_net(sock->sk),
 						&rs->rs_bound_addr, &daddr,
-						rs->rs_transport,
-						READ_ONCE(rs->rs_tos),
+						rs->rs_transport, rs->rs_tos,
 						sock->sk->sk_allocation,
 						scope_id);
 		if (IS_ERR(conn)) {
-- 
2.25.1

