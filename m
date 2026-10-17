Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD8C2E8DEC;
	Sat, 17 Oct 2026 03:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792207402; cv=none; b=fPF4Ok/s0jXIPiC7JNoBD1qHZgm8ghFE22ioy7C4IEUbTuYDCNMzzWyUq5jr3M0LE2BdPiJPlIOiLGQMIabISl8YtfbXFztUf6AgJhVVhdNE4PWBROyxg45c/l94nIhlv2cBNMuqEOaqEr0b53WEzDkvV7n5kbR8DeVbbwhUgZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792207402; c=relaxed/simple;
	bh=bkN9Rrr4L/Q2g5xWrjsI9zkd2xxg6cD8hpyQNb+EgLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OO9G2HgB9zI6QwmbBQA7Ur4gx85NthT/HYPlXB61uAYkWXJgT7AkRaOe8BnlJNzeeUF71YPSFNadw9lT0Htj9xoJknPlLNrBpYSN79a4yVhnVyINC+EnW9gvHiX5P0nCO/1sTzQC/MARR6Fpkah+V0d+irfq1twxOyiHx9L1I3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BAsUv1Ft; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BAsUv1Ft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001751F000CB;
	Sat, 17 Oct 2026 03:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792207401;
	bh=rS9yH2pHSUpZGvEI4bVkQ6rj4vMCLHWI7UEuhf1xYFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BAsUv1Ftd4tJWzi/cXX6zoZkV628LJrOdlwDyTYdCMcQqLvVPvKvNCbgAf1jcNIEP
	 vCE9ILM+UQvlwerVT6IOOqYtmF3in1Ia/w1FScPapRzbwYzX7EoLCgzJmNlnrAasJz
	 T8KmSUqa++6xsDVu5lVyy2Qna1kHpn/vFjjwGESkN9v/4isX+JvBrS6yw0EjWkMt1D
	 bEdt95yfSTgA4RaYxqdh9Nruu2K7tkbN9JNbkmngcbmYeKo9aZdUaEwsdTgVA7rHQi
	 7rYks4DYUHcA1vBx6k5+j2CaL398sEAr6aEQW4tJ3UENCehmKuzQXQvu6NROG1+jMg
	 jAo+VXQeqMV3A==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v10 02/13] net/rds: undo conn_alloc() the same way on every __rds_conn_create() exit
Date: Fri, 16 Oct 2026 20:23:08 -0700
Message-ID: <20261017032319.2563014-3-achender@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261017032319.2563014-1-achender@kernel.org>
References: <20261017032319.2563014-1-achender@kernel.org>
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
2.50.1

