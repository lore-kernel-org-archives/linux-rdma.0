Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31312E040D;
	Sat, 19 Sep 2026 06:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789798312; cv=none; b=IFBUf5XA8Y1owiK0sZBRM/SZTbb3TYWk50BGu0r2usK5ewsXn4V5hsSIhd2Gb5slvOoJkI4qSx1JnUCwYikfS/2iIe50BLevFOJfEjNZse74aq0KJhleZmL8xgY8xWr/LAMOHuryM7QCohyQOXP2ApxsLOUvbC0Iu+HT68GFuB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789798312; c=relaxed/simple;
	bh=l09qwOE5YR2ATkzO5c6FnO90asYtEnnucV6slikfzEI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IsW/vEkLWzTmgGXQ90jyZbQtEi79U7NbPT2XKX9+5VhOe5lLONOTudcIz3/8n96Ya5MBAb8GIEo6NjNwRoj+TL04h/3DsbYJBYngQo9mAvGaEl2ANBReChssRKuc/efoah7fwvHsK7/uSAOTVQK1Qp+c9IKNMJwnqGbRAwH0Ojk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LXyj/GJH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LXyj/GJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30361F0089C;
	Sat, 19 Sep 2026 06:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789798311;
	bh=YU42TL81YFZm7tgZvg285pKw+JqqFh9iFlBlrADUa8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LXyj/GJH9+DnGz+HOY5pGvzjXQ0aPvHpu4ON4ra1izWdtv8ICaSNvq+zk1LrukbqG
	 9VVrCXULPYLGXrBWwzt0mBBerxPWJwg2EHHUSngBIWkQr7MKZRZAfyItScoVRU6tJr
	 C6Z1Bog1tsaCldp7pImdIRQd7KabtrbD6Mf2nfnguZOmWWiBRn/mdm7XiJ+WmTO6Eu
	 0OBXxleMbpyLfWJaMv/OMfIoaS0A/wBnStc1XkgmqZDOaHWqwUn9Hy+6ioL4hkUTms
	 +SyjpHCPawtiP8mHqYiVKHBhKBxJpjumeHhicTZEbX0WJyyk0PnYARyruZ83D4aEdd
	 Mqmm71vy1NCZg==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	nicoyip.dev@gmail.com
Subject: [PATCH net-next v5 02/12] net/rds: free every path's transport data on the passive create paths
Date: Fri, 18 Sep 2026 23:11:39 -0700
Message-Id: <20260919061149.250658-3-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260919061149.250658-1-achender@kernel.org>
References: <20260919061149.250658-1-achender@kernel.org>
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
exit right above it, taken when a loopback parent already has its
c_passive twin, frees only path 0 and leaks the transport data of
paths 1..npaths-1.  RDS/TCP loopback is exactly a multipath passive
connection, so this is reachable.

Move the loop into a helper and use it on both exits.

Fixes: 1c5113cf796b ("RDS: Initialize all RDS_MPATH_WORKERS in __rds_conn_create")
Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/connection.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index b6c4beb50eaf..a96569a3ee9a 100644
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
@@ -316,7 +332,7 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 	if (parent) {
 		/* Creating passive conn */
 		if (parent->c_passive) {
-			trans->conn_free(conn->c_path[0].cp_transport_data);
+			rds_conn_free_transport_data(conn, npaths);
 			free_cp = conn->c_path;
 			kmem_cache_free(rds_conn_slab, conn);
 			conn = parent->c_passive;
@@ -332,18 +348,7 @@ static struct rds_connection *__rds_conn_create(struct net *net,
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

