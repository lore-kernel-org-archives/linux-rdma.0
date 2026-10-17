Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83AB83B3886;
	Sat, 17 Oct 2026 03:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792207441; cv=none; b=qYpJwsT8E/xQhx9ydy3J+WvIhihT1t0OL2ZO6DQIZc6hmJQX6ojX/Alp+dnvP+YpFX4yWpDN7Lxlhv3pCdYfaNW4ZI022mN6nEaEnTqaHHEhWnML1968IlZBmnt3qW8sDhJrNRR3PzSN98xQjgNqUhW5PklVixCgqZ5Xh9BZdJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792207441; c=relaxed/simple;
	bh=gUW6HFeSz4UjD7n74KkpqChg08y1FHM0uQ49Jh7frlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iMBuBQDNXnZWeusbqRHCTy9/tyqRup1aRP1wb7zCBrnB0I43KXNIXjyfsHqYVzzLnyZy0+0zFtAl1wT50LS1RwxEzkX5uH9tBr/1IWXLFqQOIQDiJzAfiiGEfCEPq1MOCYjRBVR0Aq//yTDWPtL4yjLQJHqs6iPq7hH6CWbzsh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E+vYH/EP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E+vYH/EP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60571F000C7;
	Sat, 17 Oct 2026 03:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792207440;
	bh=7wzQDZoqB11PrDEQ6TOh55IhA7crK6UbEChKQrk+cZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E+vYH/EPodWvsLex3y7HfbY5NNHtlKgELpuhPvCWOfn9GwHb/yvVsQZKS79D6mI/i
	 JNz86+hXmr678vl1e+I4ajp9WbJwqu8OAtv+BCTlTE3hWBTCTJ7mkeKPOetd9H87hP
	 NbyStUdmVwQKS56IBf6TjNPVs1zCKFcaYTloFUDhIxCRU0AKMIiFyqPuCjED9nhtHN
	 DSb6n7xguTsTGSsPiNdmPq00z8XwXxprjYRDkceIICQpkJzlXobdWiETP/4ZUGOQTd
	 7QR9l9FKeZuELnwvJ0pG8R9gZsa4oLb4Fe4kFPdsfY17gbLtMzrLpjgZDiWJKz/dMS
	 rzuwkZkF1GgUA==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v5 2/2] net/rds: include the scope id in the sendmsg connection cache check
Date: Fri, 16 Oct 2026 20:23:58 -0700
Message-ID: <20261017032358.2563121-3-achender@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261017032358.2563121-1-achender@kernel.org>
References: <20261017032358.2563121-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rds_sendmsg() reuses the connection cached in rs->rs_conn when its
peer address and ToS match the request.  The interface index is part
of a connection's identity as well: rds_conn_create_outgoing() passes
the request's scope_id down as dev_if, and rds_conn_lookup() compares
c_dev_if, so sends to the same link-local address through two
interfaces are two different connections.  The cache-hit test never
looked at it.

A socket bound to a non-link-local address has rs_bound_scope_id 0,
and the scope check at the top of rds_sendmsg() accepts any non-zero
destination scope for such a socket.  So after a send to fe80::x%ifA,
a send to fe80::x%ifB hits the cached ifA connection and the datagram
leaves through ifA, to whichever peer answers to that address there.

Compare c_dev_if with the request's scope_id in the cache test, so
that such a send takes the lookup path and finds, or creates, the ifB
connection - the same key the lookup uses.  With the previous patch a
send without a destination carries the connected peer's scope, or the
bound scope for a non-link-local peer, which is what an explicit send
to that peer computes, so the comparison is exact for it too.

Found by inspection while reworking this cache for the connection
lifetime series on net-next; not observed in the field.

Fixes: 1e2b44e78eea ("rds: Enable RDS IPv6 support")
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/send.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/rds/send.c b/net/rds/send.c
index 7b525a6f7eac..f38967f65af1 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1346,7 +1346,8 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 	/* rds_conn_create has a spinlock that runs with IRQ off.
 	 * Caching the conn in the socket helps a lot. */
 	if (rs->rs_conn && ipv6_addr_equal(&rs->rs_conn->c_faddr, &daddr) &&
-	    rs->rs_tos == rs->rs_conn->c_tos) {
+	    rs->rs_tos == rs->rs_conn->c_tos &&
+	    rs->rs_conn->c_dev_if == scope_id) {
 		conn = rs->rs_conn;
 	} else {
 		conn = rds_conn_create_outgoing(sock_net(sock->sk),
-- 
2.50.1

