Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74ED73A641D;
	Thu,  8 Oct 2026 03:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791429216; cv=none; b=mTjMdqV1VCdedj1Y0tVlnxt6DCpkWeKIZljHE3mkUM2OpXe/dWN9klcOi02P0+NyFbHVbkPDdjwutyi//bq1DnXSjsU5dUn222Z5vzoZc0S0QyyUOzhPlFCHDyYDTHv0W6Wj4IvkMIZPOgHlCY6nK9WyifQsRdomZs3rfR6Fj10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791429216; c=relaxed/simple;
	bh=/6evwGpivaSSzX+TQkY0+4JhkmHnEq8AOjxRCKAY6Go=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nEmQuc5K0/7AZExoPksUVUhbcoU5GRLCnwWsjyvC3pLt+ecIVC4hbFm2+CwWYOA0G038CWz2o72ws2WJ3YUqhVy7XCBGIAlNYoKTgMxcA+0vW46GmacrIxoxGh4fexQaeJN/52vCtVIHFy0OZ2LT79e1ekNIONc1Vkt12oMOctI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PfQBMfX7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PfQBMfX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64A01F00898;
	Thu,  8 Oct 2026 03:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791429215;
	bh=vpUxr9iHimDpu9f+fpnC7Vtz2lU6sCC6H61kSjErcxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PfQBMfX7Tep9E7DKKzaNzD0mxZ8lky9rBLVWFQ3JIA36U4hnGvEBb8HQdsVL5+fUW
	 RTekk3xvPMX354kl9Moek8SJKf3XZ9ccKX/DBqOshcRZuMIAGLMGghXhvqSRtsV/bL
	 ngrw08RdJUjCrKqFUmpahWa7nNhbiKofAHFc/7MytMVeorL8iYdBAdygVoH+4NNOzt
	 mTa+Kj7JdONkjb6DCQrE10kST1drN86e7MCCk3WiyAw4yUjYtxR50eS2MdRw69mm9/
	 nZv13xauwuGtcqvdw2tqETd0KpbTcI3CztEHKnI93RY79mXp0NBna6TgnIxOgs6+Fn
	 Uqbrc92cwpgtA==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v9 02/13] net/rds: undo conn_alloc() the same way on every __rds_conn_create() exit
Date: Wed,  7 Oct 2026 20:13:22 -0700
Message-Id: <20261008031333.1142174-3-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261008031333.1142174-1-achender@kernel.org>
References: <20261008031333.1142174-1-achender@kernel.org>
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

