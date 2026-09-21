Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720C451614B;
	Mon, 21 Sep 2026 21:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790027448; cv=none; b=sRzizSrdpY5idLq5V/k41WaRhcHiR8DpjQ/+OwIjW9tNy3iNV1yyJiZCspFnN2MAW7yjCe7keRangwFzIhSqJzoTjzbkGYMrYkPU9xQGvBEt2wRIH4mvIk2pCz6v+tnQ+j1+auF/Gn1W6OR4Kd+iLJg9Mb0epO8/ZMZnKaXodMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790027448; c=relaxed/simple;
	bh=D71f7uILAyrvvvvFg//FqtUrM6J53vSeLJLumSknAOc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mpyRrUg61EIDc9ybUwgipjiwxwj0fK2h63nhj7YKIf+zUCqVH5aXhvCNy43JxYEget6C73bLQys4vIy76ynPXOxtQ0pKUMExM9wgaGGqrWQFHZwJ21ykeiJ65/WUAp0CC2y+HZbZCPH+Zpr07aZFnV0auXE0S3w3+fuFw4XKWV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TtYmyO8j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TtYmyO8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75011F000FF;
	Mon, 21 Sep 2026 21:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790027447;
	bh=HLip/4mebxRdBkh5E4jlcAdSH/jfbe3rHCsYtFhelbg=;
	h=From:To:Cc:Subject:Date;
	b=TtYmyO8j3KcTdifwzU+PrLpBm2q+hMv3htjFfZOBSvWhPmLnhm8cF+qJozcOG3NA8
	 S4ktO7f07yMdOYHNVFPZ/KTkyThgdvGXGSB71C9ihIvT2vLTJGoCG3oTGQ3gS52l0Q
	 zwC5DopIop5pf/bnb0rXS9EkNYKlMIbbv1kjEapDUiE12pkVkpnrfSYoEUSuBk9QdW
	 lkRoRFze9S1mvu3eT/x9XQr2+wP5ebUN1mzOsyXNY2Z66xQIVIPffJqXCsVRtCT/IO
	 o9VnR70hF7gbG1zsTfi5o+O4LuDw9t9wPdWHUFjg0nG+twRw4oKCGDHkhKxEBNE/qO
	 aAHvVrFVGwrLg==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net] net/rds: include the scope id in the sendmsg connection cache check
Date: Mon, 21 Sep 2026 14:50:46 -0700
Message-Id: <20260921215046.174745-1-achender@kernel.org>
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

Fixes: 1e2b44e78eea ("rds: Enable RDS IPv6 support")
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/send.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/rds/send.c b/net/rds/send.c
index 1afa981e5c06..38b9cc9e0d20 100644
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

