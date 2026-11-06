Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793934977;
	b=tzfqt9nczLU/A1R3ZDV3FxoGLwmOBOLBOVqR41iIiMvaP3TuHzFTEhGnylQzcBv3h3Z6
	 HwOgF8Oq/rY/JkR1Adv8bwHnlt3yIxoz/bgSv5CylsJoUtF2S5Bw2xKi9qbmztrsx83Sw
	 Amy33+xIU8EC+sUrBo6gnA6fMb2hiQ98TGVcRuWboqnBXwlgn3tmR5sR3hd4no3ZSEO39
	 Totv2IHYkSX0S5lJl73I241A4ivoD6ZBkAkSCWekB4lLsbdKPULkeSN9e6W8HvjomOZFq
	 xAbMzI26YHnccMdhkb53QU/gMElDa+CwE+UO7eBzugOEyCK38JdMvtch12hkxdHfhjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793934977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=rS9yH2pHSUpZGvEI4bVkQ6rj4vMCLHWI7UEuhf1xYFU=;
	b=virWn0ZA/ZIpGnbfDZattTnlG6FC/3kUK7N08b/Fo1Ftc8SDsuc4DAtT597bBIRgu60B
	 3c/M8xf5sC/qNY/+J7hSMJ348B5cPm/u6w7kgy/w4pzoXa6pdkF95LfRfqOiKUwvq5b3i
	 VqVAga0lfGuKQpU5N8OhD5veh7g6QWk0mFD7J0NVrdmZUx9uaep/dkFVtRy7XBXxxDtMj
	 D4G+wFT8azM0hz876OSar8DkPadmV5lEk1oLx+uo5qastUGVYmW6Nn2AqVFvZeVnACgaV
	 x1yPbZce8FyyM1KbFVAVPqJ6UOcCWp7wsUMHrJAx3IsX2EYkx3BF54HVwzVHdhM4HHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LdKkYj3q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2F3606A328;
	Fri,  6 Nov 2026 03:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LdKkYj3q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9160E1F008A3;
	Fri,  6 Nov 2026 03:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793934977;
	bh=rS9yH2pHSUpZGvEI4bVkQ6rj4vMCLHWI7UEuhf1xYFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LdKkYj3qhQ6u3C61mXA87n+Lye0p4WKM4+/YJoa7mbmx5h4FiI4Mw9M1TO1rvQADz
	 lheEjZMFuSThT6fumUtHOt4B0FDkILvPrwEsU50y4YRX5h40WMTAs3eG0HVDVVaIqA
	 tjALL1NQlWmOCzAJR2PZrmvQYxPwZe35TIqiBNIHJ9ddsiJu3eXJ7weXQE8uFTDagQ
	 AL/0g43MAyWyR5jGm4o3DKcvxf+B6Vy9KIdQdLStglWWp2yhZCxoGJsS9pfxxpoU/Y
	 yYarI+sH6IF1zk+F8MVIbUrcIgduGGkFUAsWR8AIwDa97pDGmOnEKwJFcTplD99JpH
	 +e2j7XD4/AKmw==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v11 01/12] net/rds: undo conn_alloc() the same way on every __rds_conn_create() exit
Date: Thu,  5 Nov 2026 20:16:04 -0700
Message-ID: <20261106031615.1047052-2-achender@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261106031615.1047052-1-achender@kernel.org>
References: <20261106031615.1047052-1-achender@kernel.org>
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
2.50.1

