Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AC338AC90;
	Sat,  3 Oct 2026 16:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791045138; cv=none; b=chQFPG+2hvu6/H2Pv3jUVNX0+uBu7F2lrrFKmZ5+yIvnJVVg+wKxntXFeWutsPSoHAeYLdTBRvhjJOPQjI9hGIK/m0s2yHs5J91QLb5mfdnGVqRl5lqDijro+DgcdT/YjlWqstnuoXU0mECm4lPo2CKgBI/T/bKPkt36osuBHio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791045138; c=relaxed/simple;
	bh=/6evwGpivaSSzX+TQkY0+4JhkmHnEq8AOjxRCKAY6Go=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kwpYtQsrH6npsceb2EfSMxkm4I9WaRMnT64sEBMH2t+Bp4ta04eqUYTMHooufwDtidTjFFzsiE8Zt0LM5on9lRKcEGfp7hEXXkm8vky+UhUo36bERf6vmnZq0N7GKQksoax8YKqIzd64Jve8LlhPwFdXnlofB3D4br5KuEFytso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DVzv+bi8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DVzv+bi8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B331F008A0;
	Sat,  3 Oct 2026 16:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045136;
	bh=vpUxr9iHimDpu9f+fpnC7Vtz2lU6sCC6H61kSjErcxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DVzv+bi8hEsqxfr9ZGXOQg0GXJhmBzWDg68ai+1V0IFk6DRJF8htyxrQyq0EWdvxx
	 4thLcf85Lxe4EVQjDI8g7TWEsi95/0xDGXWOuA5Yt6B3sREFugfS+boccVMsfOjCEm
	 AbFJcq9RXhzz/mLC0vsf84E9befmXrGajaQ4YlShEs61rVNpWYDwfxhBrQI9HmvxLQ
	 7pPrzPX2YLUQjyby4p39+NBlL5IpmfHUZQn2UBJ1fMY8/HbJl1rkhQCOHGGF8GiHLm
	 tY4HIcBUTSFQqLRlKVVQ65EdKH/5cM38bmZ1Fs5knweeo+serr759q2CTmGxrSwRtf
	 ep8Kj0oH9rnnA==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v8 02/13] net/rds: undo conn_alloc() the same way on every __rds_conn_create() exit
Date: Sat,  3 Oct 2026 09:32:04 -0700
Message-Id: <20261003163215.250253-3-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261003163215.250253-1-achender@kernel.org>
References: <20261003163215.250253-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

trans->conn_alloc() may allocate transport data for every path of a
multipath connection - rds_tcp_conn_alloc() does - which is why the
lost-creation-race exit of __rds_conn_create() loops over all npaths
when it frees the connection it just built.  The passive-connection
exit right above it frees only path 0.

That is not a leak today: a passive twin is only created for an IB
loopback connection (an incoming TCP connect to a local address is
refused with -EOPNOTSUPP before it gets here), and the IB transport is
not multipath, so npaths is 1 on that exit.  But the two exits express
the same "undo conn_alloc()" step in two different ways, and the
following patches add another exit of the same kind.  Move the loop
into a helper and use it everywhere, so that the step cannot silently
diverge if a multipath transport ever grows a passive twin.

Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/connection.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index c752a8623cfc..95ff50f31d1e 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -161,6 +161,22 @@ static void __rds_conn_path_init(struct rds_connection *conn,
 	cp->cp_flags = 0;
 }
 
+/* Undo trans->conn_alloc(): it may have allocated transport data for
+ * every path of a multipath connection, not just for path 0.
+ */
+static void rds_conn_free_transport_data(struct rds_connection *conn,
+					 int npaths)
+{
+	struct rds_conn_path *cp;
+	int i;
+
+	for (i = 0; i < npaths; i++) {
+		cp = &conn->c_path[i];
+		if (cp->cp_transport_data)
+			conn->c_trans->conn_free(cp->cp_transport_data);
+	}
+}
+
 /*
  * There is only every one 'conn' for a given pair of addresses in the
  * system at a time.  They contain messages to be retransmitted and so
@@ -322,7 +338,7 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 	if (parent) {
 		/* Creating passive conn */
 		if (parent->c_passive) {
-			trans->conn_free(conn->c_path[0].cp_transport_data);
+			rds_conn_free_transport_data(conn, npaths);
 			free_cp = conn->c_path;
 			kmem_cache_free(rds_conn_slab, conn);
 			conn = parent->c_passive;
@@ -338,18 +354,7 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 		found = rds_conn_lookup(net, head, laddr, faddr, trans,
 					tos, dev_if);
 		if (found) {
-			struct rds_conn_path *cp;
-			int i;
-
-			for (i = 0; i < npaths; i++) {
-				cp = &conn->c_path[i];
-				/* The ->conn_alloc invocation may have
-				 * allocated resource for all paths, so all
-				 * of them may have to be freed here.
-				 */
-				if (cp->cp_transport_data)
-					trans->conn_free(cp->cp_transport_data);
-			}
+			rds_conn_free_transport_data(conn, npaths);
 			free_cp = conn->c_path;
 			kmem_cache_free(rds_conn_slab, conn);
 			conn = found;
-- 
2.25.1

