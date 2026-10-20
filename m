Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792456098;
	b=qR6i4Ps6vndR4XujD2So6zB2JNBqUYjDJtqtE+8WLn9v+PW9si+hR8WLveFn8c14+pjV
	 Y2m8IAh9yEIGplCkzDUrsQdUdhZA83kp1yGqCyZJ6mugututCqY4nkx0eVWO2PyWBj+tB
	 TU2d8esKHnFlkYIMYdwSaPFmcDQvaReeYFsq0h+eJb96Q1vfQlwHdCduBk0bfq3q0MRo9
	 LcWHT29N9Gp7yIdh1AKKaIAFahQHRLdI7or0LlUpSLiqBUXALDWi30JA+hEBs/CFnaU61
	 3w52iSAivqJPw8QMk6siY5QxgYbVOdvRe2HChUm97MGPcHX9UyY8zb8bs3MIfeHraIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792456098;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ULtxg0Fk0whulWZSHTNN5DQiIhcB0QibJjb6BHCTOMs=;
	b=nK3uFfC8eHuS30B4Z/BBe5O46YaE6qlS0nLphV39pGlJkG7l/TXI17J8KhNL3ZDOo6FF
	 cTrprNt6u27yKp92TuIR4b9oQjPDQH1uN3fjAK+9bBY0zEaFc0Abg1dcYtWkLX89RYQAv
	 3GGgpuKP5jgh0nm/jtvJbdHJt9YUYjUoI99WcMOGu/YBO8J1qHq8E1U2afHa4r3F7VLgI
	 rh6pcj26JmRykjqbrszcneL2luncE2O7qZNeTj8QaQ5hGIjxy8X6RGt7jEni8srZxchpm
	 CG73ja7SvYsya4gx/Stmn2oX0+Hwpeq+T5WasRpEy3Gh98BZuMTtwQigr0f2WdSTNZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DMyLsdqx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C51606A31B;
	Tue, 20 Oct 2026 00:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DMyLsdqx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746D51F000C8;
	Tue, 20 Oct 2026 00:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792456097;
	bh=ULtxg0Fk0whulWZSHTNN5DQiIhcB0QibJjb6BHCTOMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DMyLsdqxxxggacI8ZuSNLwCfUPMnLZFFNfybdB4lPYeBi6/UM0XwKQ8gTwJN1o4lU
	 DH7ClSCrPo4V+R4pANvHEjYglQ/5L+tR3h9DUNPl3dTVKkAlf1NDH2KmoS/6ZDM6VT
	 Ea6UVP4JLGIRhtWYpfMxgLMvBRgwAOGOv2Hr025/OG6Si97du3lCHKwvAVJ0c0WW5Q
	 q/WWoeN4L8/KykiH30W4x6UMsbG1VoefqhnnIax6bUBn9XigY+yi2ubI2OdWCzM4Dg
	 JDtSM/Z7lwQQ3q320yoVvzSx9iC8a/IS/J3VtwEJU+bgn4yGGvPz4u54mEymEC+EU4
	 SFTdivULfa6/g==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v6 1/2] net/rds: include the scope id in the sendmsg connection cache check
Date: Mon, 19 Oct 2026 17:28:15 -0700
Message-ID: <20261020002816.3087414-2-achender@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261020002816.3087414-1-achender@kernel.org>
References: <20261020002816.3087414-1-achender@kernel.org>
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
connection - the same key the lookup uses.  A send without a
destination takes its scope from the socket, and the connection it
created was keyed on that same scope, so the comparison holds for it
too; the next patch gives that send the connected peer's own scope.

Found by inspection while reworking this cache for the connection
lifetime series on net-next; not observed in the field.

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
2.50.1

