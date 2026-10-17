Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46E835AC0C;
	Sat, 17 Oct 2026 03:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792207440; cv=none; b=Np+mUM6NC2QcjC3ZXEni6MbGMIQbuYUOAFG00EjwphwyhFahIK0VbZvPqAHM0qJHjO7d69qzAkNDzYD7AWCh+jl6bjxv5fmbcJApWx+ubUeby4X/jvc6xGwcWO0LJZ9chxP9Nnu/ummJGaVyiFhZOjDzdBQBswStvc2Q7jsg1kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792207440; c=relaxed/simple;
	bh=Zzbq8Tx+Op5vp1qfxRm1EeLWV/Js3BlR/KzLpgFpSyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdxvHbUSn0t6dGor/aroWcHcu76fObPtZz8yqoww/NWMDBbAZ3FSGzxgHA8reYYgUjPkGysccqQcaB6BdzmcgEWEmEfLcY42E6xBuiyaNz/64iJCI5GGBhiGa2HJZHMqZYGIFGROmeoC1r6qg1BcGFVTHVS7lL/g23X3JtTbQ6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZVZ3bea6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZVZ3bea6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361A21F000C6;
	Sat, 17 Oct 2026 03:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792207439;
	bh=cEuxsyi+c54cWip2v50/a6OLzCw7DT1aw3aCrLjP/Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZVZ3bea6WKwnUGnoM4zHuPv1jFn3iSPDeEJHBUX9V5N8R1dz/hsw+UYigKNCH3Qy/
	 OCCv4l5Za0XnR+RKSovCg7a9K9fRFLLFrkN57Ww5v1Uuhund5wzs6m36VoB6GDA6J3
	 PW5m52R7gjWGWRUGtfIZmriXiY2imS/BV5zcZ6znb75j9unxmPvNUs+3nuJ6yu3mWS
	 w1aeDeRMSpljJuFWaoWQ292jRapsgZsMSv4yecDWgBodfoaWhgWi8pTaOyd7qcqXiM
	 APbTd1HF49kqn2BbDu8P34MJKefvUKdcnvX6Bc6gLyvl2Uk5x4/D0q1Z/8lObMmOsE
	 JXg3ISMBGn4XA==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v5 1/2] net/rds: keep the connected peer's scope id apart from the bound one
Date: Fri, 16 Oct 2026 20:23:57 -0700
Message-ID: <20261017032358.2563121-2-achender@kernel.org>
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
now reports a link-local sender with the interface its connection came
in on (c_dev_if, which the TCP accept path takes from the incoming
socket) and any other sender with scope 0, the inet6 convention, so an
application can reply to the address it was given.

Found by inspection while reworking the sendmsg connection cache; not
observed in the field.

Fixes: 1e2b44e78eea ("rds: Enable RDS IPv6 support")
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/af_rds.c | 15 +++++++++------
 net/rds/bind.c   |  4 ++--
 net/rds/rds.h    |  2 ++
 net/rds/recv.c   |  9 ++++++++-
 net/rds/send.c   |  6 +++++-
 5 files changed, 26 insertions(+), 10 deletions(-)

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
index 6204e577a90a..a036162539e5 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -789,7 +789,14 @@ int rds_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 				sin6->sin6_port = inc->i_hdr.h_sport;
 				sin6->sin6_addr = inc->i_saddr;
 				sin6->sin6_flowinfo = 0;
-				sin6->sin6_scope_id = rs->rs_bound_scope_id;
+				/* A link-local sender is reached through the
+				 * interface its connection came in on; any
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
2.50.1

