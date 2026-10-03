Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C2448A2CC;
	Sat,  3 Oct 2026 16:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791045330; cv=none; b=hEBIhCsYG079BzyNd+rVKdIde1yj2i7lnIn9Dx1hiIpP+Purj0DbZSPr0HM+dT8muqMt9GDCToUE3KQhp0PL5kwpYnDvheMSTqLMJ/FLOEofyg7ZsyLeNLLIsKKT0dYT009HJX22RdNn/0/XWYIG54HwDuOvMGV7kVA8WKX9IDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791045330; c=relaxed/simple;
	bh=cmvBgE8j7lEIwIHYRjNnf+zUr9OvcTqLonRqpWRcCZk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mzr+DAIH9n62EGxdAPEFUPCVeHBty2xk+hZTymnQZjpvzjWCEGSOztZIGRWbmJjjfkPQRGskZfuSycbVnS+19z+wINcZGnKDTXsQ56EId2NpcRWYHbUbbG/rnqEFcjBS5sdK4XV8yGQz0hgyZgxxiM0r/EP0f2Wq3D4G0kTkt6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HJ5Hmyyu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HJ5Hmyyu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2341F0089E;
	Sat,  3 Oct 2026 16:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045328;
	bh=kNAw/tP0Vwe7FDz0wtyVCYXyzGO5WEZw0f/DZkidmHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HJ5HmyyuYUI7mHR68tvifLIMJNUYVOqTvHHekJ/GRVUA06PTntm6PCvaWsk+GtcL/
	 zvj9l0bolIHMgX1XKLWHGnDE4ZutlBFjInFl3thlODchR0JzWLdGqUUpHhS/FjB7X3
	 xsZIKXqVAGCwzRmoHu/caqW7f8TUPNCQfuJJLmdId24ncw8iUCpACkrbpigIBrylv7
	 osz1369aDtL82JbRaHmsJEZrOx4PfR3ZONlWQvcWpmqw/9HJAkTubJOnNSdE4GPd/8
	 ZA2dQTiiO/kkEoGYYCd9xz3W9N+lC7HjklisA0XsueTtlFBNJxqRlh2QIfYsC025y9
	 thX7L5v4QtlEw==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net v3 2/2] net/rds: include the scope id in the sendmsg connection cache check
Date: Sat,  3 Oct 2026 09:35:26 -0700
Message-Id: <20261003163526.250805-3-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261003163526.250805-1-achender@kernel.org>
References: <20261003163526.250805-1-achender@kernel.org>
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
send without a destination carries the connected peer's scope, so the
comparison is exact for it too.

Fixes: 1e2b44e78eea ("rds: Enable RDS IPv6 support")
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/send.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/rds/send.c b/net/rds/send.c
index 9380b67675bd..26a937a9df6a 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1342,7 +1342,8 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
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
2.25.1

