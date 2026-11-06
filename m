Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793934985;
	b=ZTOJHle2nZ3+Xwik2v1Mjipi+hO0MnLAE31iztnGU0TtGFrqRjzelSF61uLwUbwJzaW5
	 hqeqcmZzaKkbQSjPmQ8M+t5JCKGUNfE+ayiIX4hVTiNAFfcy+VAO9Mw7t1JdUNUd3Z4Yc
	 0xXTxFXhz275GpauZ28zqrzv2EEjCvMZlmHmAFAelm9/RnX16UbQkUlV3BHB3DGjFjW0Y
	 oHyDfK2BHmbs+rxLuWSq4pyzrKTMsEHnFy4DGgy5zKaLdo8Ecpy+qt/uxNEdHOwaH1sU+
	 HTyw9swIXpUe5SIsnnR/KALaAYV4hw02JL0WbeRJozpw3WNevDO6lQ9bvpYQFawfLPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793934985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=r3VU4rpW4u46cPFMwYUXdLqDRIGWsWmLAYvUx+tx2i0=;
	b=WlHJbODbad7Pe81Aa7i6yTb+m74DGSi3iG9FIr737YQ39+ZZMEVHDXoTMBzcxuWe+9sO
	 7BIq1dXBUplg7N2DfytbgIcHZRGLfdeC8RA3mVunpZaLpYdpF5kb3X9RRy5lAB8mxWYT/
	 naRu+RhhZ12yrcEG2PAkHQz7Mqm0/FiBruZeGDiuvnceP875fTQC95woY5pbQBWSi7lBA
	 WfoHCfokp1b8H88AvegAwoyBhLgeUIyyBE4GH5dP2UGpN/wI+9WmufO9v6fRyp6iL/sFp
	 Atwcj9dAmxa3tyBC43gAYP0G/SZUKJr6Moo0uhG6wisLOgNq/QOPg33qKiZGjdci7XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YNVS4oBA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE16E606A329;
	Fri,  6 Nov 2026 03:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YNVS4oBA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0130E1F0089F;
	Fri,  6 Nov 2026 03:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793934984;
	bh=r3VU4rpW4u46cPFMwYUXdLqDRIGWsWmLAYvUx+tx2i0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YNVS4oBAjO1IwKgoRUXXBDWRmZ3W6Lmg2R3aa+1oAklHjE2dRd6MuX4vz7lDOlsyQ
	 l0hyakIEKbSHgIXmrxZm7GFqPmmlo6gRvwTZM2GWlPS78kvZZs0baZIxCN3IPV+CRG
	 QYrVDRyEsvhpgrF+rCxsErjFCNEPX3FzoBGbvaxlXZQc7cdIGBOohff0csorTfsltY
	 PTI01kZdJdDU5MxaCN/x0FvDR7xMlUfqo1pg2QoFW+ExYUqfDldmD3YvqPp13wjN+J
	 A2heSFpm1f30OV86nrDq27xplXEbsWy4FItQtx1WGxXKp/8l84I9xdIu3AJ6Nu1zKN
	 F5nC9sRHMtcdw==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v11 12/12] net/rds: drop rds_conn_count in favor of t_conn_count
Date: Thu,  5 Nov 2026 20:16:15 -0700
Message-ID: <20261106031615.1047052-13-achender@kernel.org>
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

