Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E50A2652B2;
	Thu,  8 Oct 2026 03:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791429269; cv=none; b=tDYDEL+t0LfX8CRGjtZ8Cuppp/oMMFdyiMFEnG6B4UKcDYu1vJCikmZNQcJufJnaije3FxsIR3QPH3UwhrBaDjyqlo93vBOoMr/ZCknxCdg4FzBPyEFOjQW5bvvlv+vT9mS0cYfNH4/lvAqXcJF3JOOEtNk/qluKZl0QlCnMXLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791429269; c=relaxed/simple;
	bh=TB4IYVED6llgUi6YP0WtWSUi7V5qpGdjBVfnVwQCW1I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bQuZSrZJfk3noMlNEIaCilF2LtxJsowfzPKcXh0jnjBalU5qeRvxh76wOuJLxNbC6ZvflYkdNw9LKpgyBM0K4BrqGI1oVHo3cb5jYjbDVKHkY+v8uyGBl64xBBu7/FKooK+bTWfnEh8270zh7HJdyshBD2PAUF6Vz4sNwNLfWxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KrqBNqWw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KrqBNqWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DADD91F00893;
	Thu,  8 Oct 2026 03:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791429268;
	bh=u3GH4auHC9QRN2oGMR7P/HwqXqbWmPAEYcFN8vG1cPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KrqBNqWwJ7WhbLD58UYG334lF4FLGSMINpSrsyDqAO5cz7v47ONEdofmomj2vCZBQ
	 +/NXfKazlUNmhFQ2giNXdJ2qngyctGrXcsnyCIYwvky9rKfdHaXAnyRYyO87fIr331
	 Gg6aVrwp+AkXL4G5OekyDxdfdvOCYZGohWG1cNG9V7spUUA/AEdb7o017/sJqsrb7m
	 klRe8iJmflCnyb+vSJis8t6j74AT//VdjAtvtC88bjTPnhwvohOYVH0jyYyCx+oypf
	 2BeKQkn85iGq+FWA0Ag22X82epK2WI6teOQnVaR25bB5u1Z7oINaa+4HEHzOvkXDK2
	 y18LVnZumt3+Q==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net v4 1/2] net/rds: keep the connected peer's scope id apart from the bound one
Date: Wed,  7 Oct 2026 20:14:25 -0700
Message-Id: <20261008031426.1142344-2-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261008031426.1142344-1-achender@kernel.org>
References: <20261008031426.1142344-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
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
getpeername() reports the connected peer with its own scope, and
recvmsg() reports a sender with the connected peer's scope when there
is one and the bound scope otherwise, as before.

Found by inspection while reworking the sendmsg connection cache; not
observed in the field.

Fixes: 1e2b44e78eea ("rds: Enable RDS IPv6 support")
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/af_rds.c | 15 +++++++++------
 net/rds/bind.c   |  4 ++--
 net/rds/rds.h    |  2 ++
 net/rds/recv.c   |  3 ++-
 net/rds/send.c   |  6 +++++-
 5 files changed, 20 insertions(+), 10 deletions(-)

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
index 6204e577a90a..9d81c76320ea 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -789,7 +789,8 @@ int rds_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 				sin6->sin6_port = inc->i_hdr.h_sport;
 				sin6->sin6_addr = inc->i_saddr;
 				sin6->sin6_flowinfo = 0;
-				sin6->sin6_scope_id = rs->rs_bound_scope_id;
+				sin6->sin6_scope_id = rs->rs_conn_scope_id ?:
+						      rs->rs_bound_scope_id;
 				msg->msg_namelen = sizeof(*sin6);
 			}
 		}
diff --git a/net/rds/send.c b/net/rds/send.c
index 1afa981e5c06..7b525a6f7eac 100644
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
2.25.1

