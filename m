Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794545042;
	b=jlI0RuVH23MZwrHR5kJc5EUjCrTVY7sL2rfHToWVprAb3NmbyZ63hzcVWM5QZqgT6j/Z
	 C7GOpwANyQnf5zpoO5hF2DczL8XVTLq42no5Tht6o8/+wDomtUCtghnYBng9wQvhzb7E8
	 xqTRq+pKkUeeC4ibi+TP0KpPu/xf+FHfekdPWLC8X8ihyYq4My/nulIrtaOy02qPvAxuT
	 OFUD6aD2q0SbE9vRYdj+bpNmJkORvSVMvA2welwZKs6kgq489en7OmfdOQryz3Ru343aU
	 03upvDD8ywxcUS/dOVDSSnAtPHaJl1w0g+iXRGbiyaUOqomCHPKNT8YEaqxU58kNbgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794545042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=r3VU4rpW4u46cPFMwYUXdLqDRIGWsWmLAYvUx+tx2i0=;
	b=zILmxf+HeEts8zRHpfQrm5aPiM1/lUhLk0vGHeMqAmJ+PsnX9i6PcyTIkoMEEHo6yrHG
	 32cu+rmPiY3z28O4H71MPKs+9/z88R7XLIouM6GxSx7FizIgTp12fYQ/qPJsCSl2qkyzN
	 /Ig0iLIZmItBb1TxgXbzPAPTlnbIQ/chQEkFYiiMcN3Und75NBdrDvqakiqSLoA8w5/HJ
	 jj+egzjAOWLtcn9Di1+lOAuemTRhU6GJ3qqEytlHwtwuDFBgdDyg9oWJ5owoS/Es3U9lY
	 WJ9CZVucmAOvPfVW44C3tBuOmtZfnlpQBxMR20B1mXgXOs6UktNN5xxglYKfhBc55sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oZVwHcdi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3DB60A3806;
	Fri, 13 Nov 2026 04:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oZVwHcdi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BDA11F000D1;
	Fri, 13 Nov 2026 04:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794545042;
	bh=r3VU4rpW4u46cPFMwYUXdLqDRIGWsWmLAYvUx+tx2i0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oZVwHcdiqPHwjPXXqqdPZ4DB+Dku4McP0w0rbff7jntmQ+FpZQfB74xk3+fseUCQt
	 5Pxz4TZc/K/cAT/TL0qE7Zp+4DSYUVOSof4EIIPs9C5OE7lr/f2h51OJ8h8EjTvz6q
	 gRINX5ZYw+O1+iSOVR0Iqbxy/WUDXFctOb9DhUHHOYq4lAIS99mlqVo4kBpE+yl7ea
	 F8nD/6HH3DC/aCxV7FNKyafPvuOcMmmdA1S6+hx2qntrYP03sB6Atp9ltxN5W408lK
	 jgAnWR/AAdeTj8nT4PdPPfcSV5tVnEWzcvozQVOcIss6xdzl4KJ5g0C0jM+qxX/uMK
	 q4Nh1LB1OT2gg==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v12 12/12] net/rds: drop rds_conn_count in favor of t_conn_count
Date: Thu, 12 Nov 2026 21:43:55 -0700
Message-ID: <20261113044355.2932029-13-achender@kernel.org>
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

