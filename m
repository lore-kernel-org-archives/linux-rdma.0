Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A312E737B;
	Sun, 27 Sep 2026 06:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790490195; cv=none; b=QRcCGYO33u9rwAVAhgpIBcFcRf6sKaPRxNrCrCOaXSVR5QDp63IQOnQgEdQ0y9TflzaSLWVEppkmuVXROWuZVsq2eAvedAkzMotTrNNHw0tfLFMuKLNIWLy4qPtwNqJhh5wM1xhgAwgxO56qpD1GHtNl80H8FMJ/QOVcWh0tCek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790490195; c=relaxed/simple;
	bh=k9yAOa6xb+L8NSUCwDvYCxygqfkz8HAvXRoshnEutco=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NrSXBriRrRDh1g6GPouh02xxLcNwhnl2+yQCBuUKT4/Dav1bq6955ojkPNjy8d+3dunAQGkWNQkTAxM969ZFJcUab+AX7OEsG3KpMsTonYOeB4cl2DpvFJ8+HPRbAEljDTbzT/2YlJ3eP3Gij05mZdlV1ZCx721yRc0CpLjdnb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ao3P01ot; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ao3P01ot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03FA91F000FF;
	Sun, 27 Sep 2026 06:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790490193;
	bh=getjAz67ligAbrpiUX7MiUy1Xq8e93Z5z/02Atu6OBI=;
	h=From:To:Cc:Subject:Date;
	b=ao3P01ot0qs2Tmj6+2g8Tu/45Ir3S2ipPuHTrjnu1Xw3kA2mNdzMiDtqa57AZ2y2H
	 ylHJjqkFyauU3A9UiE96q1/cvbjoL1j1BrtRQl6hgfRp2mF2AHTFkQy/PqeC4+1ENB
	 tCgpNnJWI0ZW0mISuiOK51LVLYpP3y6juwQbA9Q/8Zj70ULoISxwqdnXM1weTzWXqY
	 1mnu8VWJeunoijIEm5P+4OhH6C/RnDW/YrkA82YYhd1q6wD4z+JsLJv7YB1oZThVaI
	 QnkuDfCeskqhqOcHAoSjPuFlvtLF3LKe/o3fQM+3HiW3DkSGJ3EIDp43vZ+uXKHg8F
	 mY+LvkScZA6mQ==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net v2] net/rds: include the scope id in the sendmsg connection cache check
Date: Sat, 26 Sep 2026 23:23:12 -0700
Message-Id: <20260927062312.169097-1-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
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
connection.

A request without a scope keeps matching the cached connection.  A
send with a destination always carries one for a link-local peer, but
a send without a destination takes rs_bound_scope_id, and a bind() to
a non-link-local address after connect() to a link-local peer resets
that to 0.  Such a send never named an interface, so the connection
the socket last used is the one it means; making it miss the cache
would send it to look up a connection with no interface, which cannot
be established.

Fixes: 1e2b44e78eea ("rds: Enable RDS IPv6 support")
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/send.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/rds/send.c b/net/rds/send.c
index 1afa981e5c06..393898a079c1 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1342,7 +1342,8 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 	/* rds_conn_create has a spinlock that runs with IRQ off.
 	 * Caching the conn in the socket helps a lot. */
 	if (rs->rs_conn && ipv6_addr_equal(&rs->rs_conn->c_faddr, &daddr) &&
-	    rs->rs_tos == rs->rs_conn->c_tos) {
+	    rs->rs_tos == rs->rs_conn->c_tos &&
+	    (!scope_id || rs->rs_conn->c_dev_if == scope_id)) {
 		conn = rs->rs_conn;
 	} else {
 		conn = rds_conn_create_outgoing(sock_net(sock->sk),
-- 
2.25.1

