Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2034B3DAAB6;
	Sat, 17 Oct 2026 03:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792207408; cv=none; b=AUwDNbngGCKbtUrJfNRndNM8G2/DMNOoz+YUadicV9EK28dgK3ksY2NyCkkQJKLjFzJpooQVF8ar8n9RkBokAx9n6hUbvtehPFri2TI2StyEaUQgUSRm4HlNCqologvmiblbMbF/vs0TnEuEcFVpJYOOxxu9da+GW8e8cTHz2Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792207408; c=relaxed/simple;
	bh=9itCJJe/Iqwte3bBZu8vMlKjSQI4JtnK25hguIA+uwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VIvIToSS4qvjru2CzqepIEIkrktrCcnwFYIKRVi8rsRsyN8KAQDBOp+yLd0r/dKIKUOk8AdhEyfd/Fo8Z6czRj2Q+3OQ2nWORaIDFlaeyLk+/dPgXhT/Cb5sQT2Zumdd1aoS5MYP8kifMx7q0Yj+rfDYu89Fyd8wc4fX77Knu6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ooxycXAX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ooxycXAX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAFA31F000C4;
	Sat, 17 Oct 2026 03:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792207407;
	bh=r3VU4rpW4u46cPFMwYUXdLqDRIGWsWmLAYvUx+tx2i0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ooxycXAXhwana1Y3fZsRXt5YxaAnKD0uW9iQNV8Zo8UjbipgqDJM15zmAfaYFoo+7
	 qXV5uwfQF1njQquGVUh8PZJwTVveqNe2/KV6d7497LytZbcG451c8nt0CeJ0yGue97
	 1ulIJ04bcF9nJR2MMpPKzU+wjg+lHazpebGL9ayyps2Aclm4728feQrcX1pVokuDTz
	 NOXBqtjlGFcd7yWwiwb2vs5Ezjz8eIKaEPvbltyxcWKlEf6UNY0uGASVrMiJuGUYWm
	 gUAti9uMTPnA3roQk4xXFabUh6+98YHQZHsVx5eNcD6iwUGuyvvtFtO9Ie0P6/ie28
	 zh3E2XFN5AxvA==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v10 13/13] net/rds: drop rds_conn_count in favor of t_conn_count
Date: Fri, 16 Oct 2026 20:23:19 -0700
Message-ID: <20261017032319.2563014-14-achender@kernel.org>
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

The patch "net/rds: wait for connections to be freed on transport
unload", earlier in this series, gave each transport its own
connection count in t_conn_count, incremented and decremented at
exactly the points where the global rds_conn_count is.  That leaves
rds_conn_count with a single remaining consumer: the seed of the
per-path workqueue names in __rds_conn_create().

Switch the name seed to t_conn_count, as UEK does, and remove
rds_conn_count.  The numbering becomes per-transport instead of
global, so connections of different transports can now receive the
same seed; workqueue names carry no uniqueness requirement, and the
seed was already reused as the count rose and fell.  Removing the
counter also removes the rds_conn_lock round-trip that
rds_conn_destroy_fini() took solely to decrement it.  (The free path
still sleeps in destroy_workqueue(), so the last reference has to be
dropped from process context as before; only that one lock goes.)

Based on the Oracle UEK commit "net/rds: Each RDS transport
should keep its own connection count".

Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/connection.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index 7d03d53a3101..8c4df7d6b294 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -47,7 +47,6 @@
 
 /* converting this to RCU is a chore for another day.. */
 static DEFINE_SPINLOCK(rds_conn_lock);
-static unsigned long rds_conn_count;
 /* woken whenever a transport's t_conn_count drops to zero */
 static DECLARE_WAIT_QUEUE_HEAD(rds_conn_freed_waitq);
 static struct hlist_head rds_conn_hash[RDS_CONNECTION_HASH_ENTRIES];
@@ -338,12 +337,13 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 
 	init_waitqueue_head(&conn->c_hs_waitq);
 	for (i = 0; i < npaths; i++) {
+		int seq = atomic_read(&trans->t_conn_count);
+
 		__rds_conn_path_init(conn, &conn->c_path[i],
 				     is_outgoing);
 		conn->c_path[i].cp_index = i;
 		conn->c_path[i].cp_wq =
-			alloc_ordered_workqueue("krds_cp_wq#%lu/%d", 0,
-						rds_conn_count, i);
+			alloc_ordered_workqueue("krds_cp_wq#%d/%d", 0, seq, i);
 		if (!conn->c_path[i].cp_wq)
 			conn->c_path[i].cp_wq = rds_wq;
 	}
@@ -412,7 +412,6 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 			rds_conn_get(conn);	/* caller */
 			rcu_assign_pointer(parent->c_passive, conn);
 			rds_cong_add_conn(conn);
-			rds_conn_count++;
 			atomic_inc(&conn->c_trans->t_conn_count);
 		}
 	} else {
@@ -435,7 +434,6 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 			rds_conn_get(conn);
 			hlist_add_head_rcu(&conn->c_hash_node, head);
 			rds_cong_add_conn(conn);
-			rds_conn_count++;
 			atomic_inc(&conn->c_trans->t_conn_count);
 		}
 	}
@@ -684,7 +682,6 @@ static void rds_conn_destroy_fini(struct kref *kref)
 						   c_refcount);
 	int npaths = (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
 	struct rds_transport *trans = conn->c_trans;
-	unsigned long flags;
 	int i;
 
 	for (i = 0; i < npaths; i++)
@@ -693,10 +690,6 @@ static void rds_conn_destroy_fini(struct kref *kref)
 	kfree(conn->c_path);
 	kmem_cache_free(rds_conn_slab, conn);
 
-	spin_lock_irqsave(&rds_conn_lock, flags);
-	rds_conn_count--;
-	spin_unlock_irqrestore(&rds_conn_lock, flags);
-
 	/* only after everything the transport module owns has been
 	 * freed above may its unload proceed
 	 */
-- 
2.50.1

