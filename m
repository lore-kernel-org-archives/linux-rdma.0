Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126762877FA;
	Thu, 12 Feb 2026 05:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770874354; cv=none; b=dHGK3CmVZTv688NEggNA2FRSuQBL/ZCy+PSZZejW0A95dZ5sIE+hSVp86bCQ4LeA9le1bSzVx11V+C5UBC4XODGzrhp79Y3vYp90HkMKBw8OGx0rKEhf/9blfw3g5a9hb0yityFtDnWdZzoAZgl7pzIDOXwS/uK7rweoCLn3LSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770874354; c=relaxed/simple;
	bh=n6zOhp9NhoaHXZ0TZxCKtceQ3+g5d/EDkBQzogyAbAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tptN4I6ifuINo+ozZB4wpy7vWWw84Rw/t22bpUxBtZyI+Jaa3PE4sjoE+dQKLVbVQ9bR5rzELSJrUxpk8tlPDQPjBHujYdx9VeBHMjIaUh7vVT7JG78V9QoWP5T1C4OpPeDjVW0cl94pP1WXMYBoYYOp8xCgHfZTmwcr5+/g4MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YTGSUrJV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YTGSUrJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E11C19424;
	Thu, 12 Feb 2026 05:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770874353;
	bh=n6zOhp9NhoaHXZ0TZxCKtceQ3+g5d/EDkBQzogyAbAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YTGSUrJVrTKScMvET0Q+XpcklHosAosHoZu8iHLFCqmLacoBzkPdYiY5lsWigmGpS
	 HPbesy9X1CH91ym8YRNk27qq3GFnaAyBS6KCh/2el9vEGG+08XDRd/kjWTY4BDnyNw
	 nbFSC17L85heZEqJV532XFCaC7l20q+vuvNpy/V2M4C2yQWbi+2rwCaxvJlAxpmoRl
	 qLIH2EsyAmlP5pUxKaBTQETXvqcq3XM6G2liQfd4AUHIPABXmIHA978jbnC+enxSg6
	 oLlhHAiNMREIxeOZ1P6754C9tJi8s67eNXLeG6Ef6w0xUdsdYKHhZ6BADmQwWiRFTZ
	 E+WyADRQJ6MrQ==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	rds-devel@oss.oracle.com,
	kuba@kernel.org,
	horms@kernel.org,
	linux-rdma@vger.kernel.org,
	allison.henderson@oracle.com
Subject: [PATCH net-next v4 2/4] net/rds: Refactor __rds_conn_create for blocking transport cleanup
Date: Wed, 11 Feb 2026 22:32:28 -0700
Message-ID: <20260212053230.1921241-3-achender@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260212053230.1921241-1-achender@kernel.org>
References: <20260212053230.1921241-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The next patch will delegate fanout operations to a background worker,
which requires cancel_work_sync() during connection cleanup.  However,
the error path of __rds_conn_create() currently calls
trans->conn_free() while holding rds_conn_lock (spinlock) and
rcu_read_lock, which creates an atomic context where cancel_work_sync()
cannot sleep.

To avoid this, refactor the error/race paths to defer
trans->conn_free() calls until after locks are released. This allows
transport cleanup functions to perform blocking operations safely.

This patch moves the cp_transport_data cleanup to the 'out:' label
where it runs outside the critical section, after the connection has
been freed from the slab and cannot be accessed by racing threads.

Link: https://ci.syzbot.org/series/1a5ef180-c02c-401d-9df7-670b18570a55
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/connection.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index 185f73b01694..695ab7446178 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -170,6 +170,7 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 	struct hlist_head *head = rds_conn_bucket(laddr, faddr);
 	struct rds_transport *loop_trans;
 	struct rds_conn_path *free_cp = NULL;
+	struct rds_transport *free_trans = NULL;
 	unsigned long flags;
 	int ret, i;
 	int npaths = (trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
@@ -305,7 +306,7 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 	if (parent) {
 		/* Creating passive conn */
 		if (parent->c_passive) {
-			trans->conn_free(conn->c_path[0].cp_transport_data);
+			free_trans = trans;
 			free_cp = conn->c_path;
 			kmem_cache_free(rds_conn_slab, conn);
 			conn = parent->c_passive;
@@ -321,18 +322,7 @@ static struct rds_connection *__rds_conn_create(struct net *net,
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
+			free_trans = trans;
 			free_cp = conn->c_path;
 			kmem_cache_free(rds_conn_slab, conn);
 			conn = found;
@@ -349,9 +339,23 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 
 out:
 	if (free_cp) {
-		for (i = 0; i < npaths; i++)
+		for (i = 0; i < npaths; i++) {
+			/*
+			 * The trans->conn_alloc call may have allocated
+			 * resources for the cp paths, which will need to
+			 * be freed before freeing cp itself.  We do this here
+			 * so it runs outside the rds_conn_lock spinlock
+			 * and rcu_read_lock section, because conn_free()
+			 * may call cancel_work_sync() which
+			 * can sleep.  free_trans is only set in the
+			 * race-loss paths where conn_alloc() succeeded.
+			 */
+			if (free_trans && free_cp[i].cp_transport_data)
+				free_trans->conn_free
+					(free_cp[i].cp_transport_data);
 			if (free_cp[i].cp_wq != rds_wq)
 				destroy_workqueue(free_cp[i].cp_wq);
+		}
 		kfree(free_cp);
 	}
 
-- 
2.43.0

