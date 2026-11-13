Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794545037;
	b=up+q09eZJTurRQSdRYU/yaAeN5dfhbRENOmh5QKEa2f8es7x+E+OPxv1pM3nrOHyTZvk
	 FoJCnZzFxk6znFBrXKCJ/IlKL0CIh0jCb4SIq2XDZLyY4kjO7TcZ5VQVujMKNJ3R3/UfD
	 Od7JOT1r4i0flpzXz7+Z4dn8H+mRd/ElmlGeKBvbdHMHrn2zJ4zL+pHyLisHXplzgUAyE
	 zGx2MfNVJ5jQv2zH7/wf0+wcnvFSI8HCHnC64ZJz4DrTM4R5OYaZrT1X3Ib9zkjXJXrLW
	 ryv16QKCNgaOYqF9533WIq1aKArD6RW4SX1cAh0Bz0bhGOEudr5jWRsE9AZngFbWnxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794545037;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=rS9yH2pHSUpZGvEI4bVkQ6rj4vMCLHWI7UEuhf1xYFU=;
	b=VmODHOfATHBF2BUh3oxESbv9Gmwt0UuS6eq3uSIz9tKryLUQpqhwFZeePyMNlUS6gcMn
	 UN74TZcZi01gRX9k7RSvZ77rWqjxAWUfLBV/4t/PokZ++P5+B3kEU5CEgJyYbqNox2jZr
	 fCD27z7tFSug7y3ZGgjpIp8fqnPsnfXMz4bmG7JLQ+kt3Ugi9rg7NntGUozmCuUIDQP23
	 QBKD7wfaI+f7kT8o/Tt77t6dH9M8uK1mhbDHAt98YXFNcTxxqqN7l4PHtsiHFRtEYdOYB
	 WkOWjG/AbHE5sneNJ2SfLjPpxMuaGgRzV9xmPXu7JECBQzQFf0uLaQxJ6CM3fophpPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AoQQeJ9I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44663606A333;
	Fri, 13 Nov 2026 04:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AoQQeJ9I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861DC1F000C7;
	Fri, 13 Nov 2026 04:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794545036;
	bh=rS9yH2pHSUpZGvEI4bVkQ6rj4vMCLHWI7UEuhf1xYFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AoQQeJ9IZfEhUqnPGYS482KJArgK7LKbfstdX5KnuutwQvU8y278ylBiRDz6hclH/
	 QFb+mH4PVIwQJ8VawnBk0k0WjshqEpKyQfq6flO+TRNZxaRni9B6pWNd4+GAOB3qw1
	 JHhMyEyEiWnHV4J15cXkdLVCUds6gdC4b63uvH/AfPYT6WhXD7n3/dCP723Lm/L3AI
	 I1UJqnqz6ujKTIUjkzgelokLbxPQB2JBPs/XTGv2QgYrTwZ4b4LBGkyqDOMgAC6an1
	 bn+t5c1aPyPQjE2MVTY5G7qTbmKiWi66rJGeHetv8lk8BgsT+cVKaObkiz45KzaH1m
	 dd7RiDb5wdLAQ==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v12 01/12] net/rds: undo conn_alloc() the same way on every __rds_conn_create() exit
Date: Thu, 12 Nov 2026 21:43:44 -0700
Message-ID: <20261113044355.2932029-2-achender@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261113044355.2932029-1-achender@kernel.org>
References: <20261113044355.2932029-1-achender@kernel.org>
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

