Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF285489FDD;
	Sat,  3 Oct 2026 16:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791045329; cv=none; b=aOM0SGK4vXkqM/hdLVSt7mHUYBD3TuLtr4E63dY15jHx98Lu1lNmoPQK1TyRCFQXDepyd4ASkhNfU7UA9rCfuhfzDxwJdH+0E6CCMQWZOXwSaV2wKokGb1DOfbjjDh+vqc27BGjqHyR7pnkkabojurtSkAqazoMDe9sVCW4ANNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791045329; c=relaxed/simple;
	bh=LFHr+tAASGZOa0idyhHxbnue+09IvPBlUDuuj/2k/X4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N1jZoViVUXkn7yYM5o5kcPl/EYHeMrv1qpmFkBeHKe/bqPeWfJQM9olew3+wJqiDphl0ZbVIVz0ZB0PNpKlPbHbsu2Omto96hT1aikNehKmp23JYzGbtIoLUUEsFGSg3kQNpO+0VI4ddZaMvFV5/333a/TaxRy0VOYB+kDvs7IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mb0GK1gT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mb0GK1gT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6310D1F0089D;
	Sat,  3 Oct 2026 16:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045327;
	bh=Rk89605dKXj6Kb1McPF26dlaagoMHZKVdRiSV6849cA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mb0GK1gTZ/KoOjOomvo5JgQWVtCRM20OLn+EX/1+eKyiO39vlsc2emjlrb9f4FjMw
	 uedbtvB+316YytEX8Epcr+cLaY7gt8kg7833AL9HsGAY2G1h5h5FaQIsIZcwoaqPT1
	 WwEyjmoOwy/70BnckwKE88cwA7y9rEXyv9jyAUE03vgEVMMC6lKXQ1mi/BiQneZTQo
	 AC3Ge97XvGokYjfJ4+n0qCH7jheeql238JJHDtyPREVADXBjPRUrBL2EkilkJ28XgP
	 F7x/kpTe0KQsGsAozsuGF4v3syqn1eiFCfg6NfsSuw8QESTXq5xgeOCd/qDuOFay7j
	 ViRbSJkio1EZw==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net v3 1/2] net/rds: keep the connected peer's scope id apart from the bound one
Date: Sat,  3 Oct 2026 09:35:25 -0700
Message-Id: <20261003163526.250805-2-achender@kernel.org>
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

rds_connect() has nowhere to keep the scope of a link-local peer, so
it stores it in rs_bound_scope_id, the scope of the socket's own
bound address, for rds_bind() to check a later link-local bind
against.  That field is then also what a send without a destination
uses as the request's scope, and what a later bind() overwrites:
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
send takes its scope from it.

Fixes: 1e2b44e78eea ("rds: Enable RDS IPv6 support")
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/af_rds.c | 12 ++++++++----
 net/rds/bind.c   |  4 ++--
 net/rds/rds.h    |  2 ++
 net/rds/send.c   |  2 +-
 4 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index d5defe9172e3..ba726782addf 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -572,6 +572,7 @@ static int rds_connect(struct socket *sock, struct sockaddr_unsized *uaddr,
 		}
 		ipv6_addr_set_v4mapped(sin->sin_addr.s_addr, &rs->rs_conn_addr);
 		rs->rs_conn_port = sin->sin_port;
+		rs->rs_conn_scope_id = 0;
 		break;
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -616,11 +617,14 @@ static int rds_connect(struct socket *sock, struct sockaddr_unsized *uaddr,
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
diff --git a/net/rds/send.c b/net/rds/send.c
index 1afa981e5c06..9380b67675bd 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1256,7 +1256,7 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 		lock_sock(sk);
 		daddr = rs->rs_conn_addr;
 		dport = rs->rs_conn_port;
-		scope_id = rs->rs_bound_scope_id;
+		scope_id = rs->rs_conn_scope_id;
 		release_sock(sk);
 	}
 
-- 
2.25.1

