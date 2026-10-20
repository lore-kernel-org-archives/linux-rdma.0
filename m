Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792456098;
	b=L0UOvBOnmQ6gKPSCKEM4b7JufQyddFu0iRyqpCDh1JugZMcdX3fkkZip0hL7FGKlErWB
	 oTx7PERzPS4i/OI4t7Kb9QAh3SRi0o8qZ2+PZhNghj97bn4dX21epmWndi+NqidhEuFxg
	 QiTWzsfqlTEfdgKuuRkrcptXLdsfY2urDRBawa3dDjB/bP5su5qS/PBEeHAhD78O1ThBz
	 7DQZONY5vkMKoLqdLSPDZrCT2hIochJJBCUmQ6/bDMCmqvgi8TIxiv3cDTQafJzMBmTWD
	 q28DyhjBymwxh6szqxzhcteY7e6lAYvePyBB4sAGSOFiVfucIH/ErByynCgwJecaVcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792456098;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=8uJA/ehV5jojOjVkQUxowY7ETq9rQfYD4jD2peF67N4=;
	b=xZFVQbcLZ4XVdj6nW2GtTQfCi+LdMYWZgmFn/eVKE3+HEbzXw979UhOlqI8XDOG7uhmN
	 6lIeAXIJS2VZq6BAORFWNP6yHq3pWGOvq8CmXagcJPrIPHsgU9/g39PoRPZMX+vGfbLXA
	 d9DoHNDTio/PSTZkPuD80BnYJOl0RO3qiRpM5nhdhPVLvLwIdd3vHbpPcK6hC7NRwSE1j
	 EILLUUUupOCIUNtHCbZGX/Xzxs5GTDFaE0/yt9uDaRDVEJpbrqLqlrEyZ06rI0vKSOIUN
	 s1xtRhEIOYjbBcblZRpZmgAVerJDjx3vJqTtUW1dKKmFdraXwvqz6pUuln04+f3XRcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dWoEQ8r1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A81B606A323;
	Tue, 20 Oct 2026 00:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dWoEQ8r1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073D21F000C5;
	Tue, 20 Oct 2026 00:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792456098;
	bh=8uJA/ehV5jojOjVkQUxowY7ETq9rQfYD4jD2peF67N4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dWoEQ8r1bSjfTMWqxFCfUez7dxh6rfCkmQi1q6JZAtnhc4sCaLol7kc++Dk5Ty5vb
	 PgSaqAOhY8TOFAGNh0AMsjswnH1lEN34UABV0WIZ1t6K0xhdGZM7Q6sZK5MUZVRzC1
	 Imnn/PnRnGHTBn81tNWOAnmzZ1b+XOWawHNw9LM4n2/KwxFEVNwLlihepUf66f9e1N
	 tB6rmZ7azTfE/QRuiJwgVmHNwsyOiKBa8WH2kyipBeymjXLRlLOojg/5ID+KyoJVkJ
	 JLTDr1fRi1zTJdYhg1uZt+DRkWrFoODdxwp+mZASB9ZpvjaHzezuGnolUs6WT9MKuF
	 NNm9CRt/z99dw==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v6 2/2] net/rds: keep the connected peer's scope id apart from the bound one
Date: Mon, 19 Oct 2026 17:28:16 -0700
Message-ID: <20261020002816.3087414-3-achender@kernel.org>
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

rds_connect() has nowhere to keep the scope of a link-local peer, so
it stores it in rs_bound_scope_id, the scope of the socket's own
bound address, for rds_bind() to check a later link-local bind
against.  That field is then also what a send without a destination
uses as the request's scope, what getpeername() and recvmsg() report
as the peer's scope, and what a later bind() overwrites:
rds_add_bound() stores the bound address's scope unconditionally,
which for a non-link-local address is 0.

So after connect(fe80::x%ifA) followed by bind(global), a send() with
no destination asks for fe80::x with scope 0.  rds_conn_lookup() keys
on the interface, so that finds or creates a connection with c_dev_if
0, which the TCP transport then tries to connect through
sin6_scope_id 0 and tcp_v6_connect() rejects for a link-local peer:
the connected socket's data is queued on a connection that can never
come up.  In the other order, bind(global) then connect(fe80::x%ifB),
the connect leaves a global-bound socket with rs_bound_scope_id ifB,
so sends to other link-local peers are refused as off-link and sends
to global peers inherit a meaningless interface.

Give the connected peer its own rs_conn_scope_id.  rds_connect()
records it there and leaves the bound scope alone, rds_bind()'s
connected-socket check compares against it, and the destination-less
send takes its scope from it - falling back to the bound scope for a
non-link-local peer, so that send() and sendto() to the connected
peer compute the same scope, and so the same connection.
getpeername() reports the connected peer with its own scope.
recvmsg() used to report every sender with the socket's bound scope;
a connected socket receives from any peer, so neither the bound scope
nor the connected peer's scope is right for an arbitrary sender.  It
now reports a link-local sender with the interface recorded on its
connection, c_dev_if: the TCP accept path takes it from the incoming
socket, and the IB passive side resolves it from the local address,
the closest the CM gets to the arrival interface.  Any other sender
is reported with scope 0, the inet6 convention.  Either way, a reply
to the address an application was given reaches the same connection.

Found by inspection while reworking the sendmsg connection cache; not
observed in the field.

Fixes: 1e2b44e78eea ("rds: Enable RDS IPv6 support")
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/af_rds.c | 15 +++++++++------
 net/rds/bind.c   |  4 ++--
 net/rds/rds.h    |  2 ++
 net/rds/recv.c   | 11 ++++++++++-
 net/rds/send.c   |  6 +++++-
 5 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index d5defe9172e3..e84d00bbe9a1 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -136,8 +136,7 @@ static int rds_getname(struct socket *sock, struct sockaddr *uaddr,
 			sin6->sin6_port = rs->rs_conn_port;
 			sin6->sin6_addr = rs->rs_conn_addr;
 			sin6->sin6_flowinfo = 0;
-			/* scope_id is the same as in the bound address. */
-			sin6->sin6_scope_id = rs->rs_bound_scope_id;
+			sin6->sin6_scope_id = rs->rs_conn_scope_id;
 			uaddr_len = sizeof(*sin6);
 		}
 	} else {
@@ -572,6 +571,7 @@ static int rds_connect(struct socket *sock, struct sockaddr_unsized *uaddr,
 		}
 		ipv6_addr_set_v4mapped(sin->sin_addr.s_addr, &rs->rs_conn_addr);
 		rs->rs_conn_port = sin->sin_port;
+		rs->rs_conn_scope_id = 0;
 		break;
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -616,11 +616,14 @@ static int rds_connect(struct socket *sock, struct sockaddr_unsized *uaddr,
 				ret = -EINVAL;
 				break;
 			}
-			/* Remember the connected address scope ID.  It will
-			 * be checked against the binding local address when
-			 * the socket is bound.
+			/* Remember the connected address scope ID.  It is
+			 * checked against the binding local address when
+			 * the socket is bound, and gives a send without a
+			 * destination its scope.
 			 */
-			rs->rs_bound_scope_id = sin6->sin6_scope_id;
+			rs->rs_conn_scope_id = sin6->sin6_scope_id;
+		} else {
+			rs->rs_conn_scope_id = 0;
 		}
 		rs->rs_conn_addr = sin6->sin6_addr;
 		rs->rs_conn_port = sin6->sin6_port;
diff --git a/net/rds/bind.c b/net/rds/bind.c
index f800d920d969..3ac59cd512a2 100644
--- a/net/rds/bind.c
+++ b/net/rds/bind.c
@@ -233,8 +233,8 @@ int rds_bind(struct socket *sock, struct sockaddr_unsized *uaddr, int addr_len)
 	 * non-link local address (scope_id is 0).
 	 */
 	if (!ipv6_addr_any(&rs->rs_conn_addr) && scope_id &&
-	    rs->rs_bound_scope_id &&
-	    scope_id != rs->rs_bound_scope_id) {
+	    rs->rs_conn_scope_id &&
+	    scope_id != rs->rs_conn_scope_id) {
 		ret = -EINVAL;
 		goto out;
 	}
diff --git a/net/rds/rds.h b/net/rds/rds.h
index 2db49573dacd..9b1ffc49c0a6 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -646,6 +646,8 @@ struct rds_sock {
 	struct in6_addr		rs_conn_addr;
 #define rs_conn_addr_v4		rs_conn_addr.s6_addr32[3]
 	__be16			rs_conn_port;
+	/* scope of rs_conn_addr when it is link-local, 0 otherwise */
+	__u32			rs_conn_scope_id;
 	struct rds_transport    *rs_transport;
 
 	/*
diff --git a/net/rds/recv.c b/net/rds/recv.c
index 6204e577a90a..2458cd4ce73e 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -789,7 +789,16 @@ int rds_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 				sin6->sin6_port = inc->i_hdr.h_sport;
 				sin6->sin6_addr = inc->i_saddr;
 				sin6->sin6_flowinfo = 0;
-				sin6->sin6_scope_id = rs->rs_bound_scope_id;
+				/* A link-local sender is reported with the
+				 * interface recorded on its connection (the
+				 * accepting socket's device for TCP, the one
+				 * resolved for the local address on IB); any
+				 * other sender has no scope.
+				 */
+				sin6->sin6_scope_id =
+					(ipv6_addr_type(&inc->i_saddr) &
+					 IPV6_ADDR_LINKLOCAL) ?
+					inc->i_conn->c_dev_if : 0;
 				msg->msg_namelen = sizeof(*sin6);
 			}
 		}
diff --git a/net/rds/send.c b/net/rds/send.c
index 38b9cc9e0d20..f38967f65af1 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1256,7 +1256,11 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 		lock_sock(sk);
 		daddr = rs->rs_conn_addr;
 		dport = rs->rs_conn_port;
-		scope_id = rs->rs_bound_scope_id;
+		/* The connected peer's scope for a link-local peer, else
+		 * the bound scope, as an explicit send to that peer would
+		 * compute below.
+		 */
+		scope_id = rs->rs_conn_scope_id ?: rs->rs_bound_scope_id;
 		release_sock(sk);
 	}
 
-- 
2.50.1

