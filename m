Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEB93AD539;
	Sat, 19 Sep 2026 06:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789798318; cv=none; b=JArcZrduCWoeW1a+OIgJMD9Ah0kwDH/Phr65rsQMYpeQERor+AJArziokg3RZUkzxllXnbsIw571FqXsP9L1j2pVZ21jzCZ4QfAs2dASfwa7M8DUEIj6/VHa0DBcGPK1dD7veIVmVfIUzUyAOUep71ibW9T8r/vl8BiM31QdHdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789798318; c=relaxed/simple;
	bh=3zSs0ABuFnFCFfFexD/oL+0zWqGUs8XSEhmy7LV8fL4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Mo/dhrzNJzkIFBXMbF8voScFkdbLyfMqCavrVed/+tqpSVtlzrgCnSFSxXYCpKLPGPMQQEFQds6uF89Dc7PSK6yP/lW+o3wkzO1kt75ChtJzknwwuDkEvKrAK2mLXmfAtSZZOpaQ8U7szv3CfgGt4Z6Jy7+tio5EhskGldJYQe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eCvFDmYV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eCvFDmYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD391F000FF;
	Sat, 19 Sep 2026 06:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789798316;
	bh=oCxc3AFQocqHfZ8pwtUwBFuBK/JhlZMdid6+N0CEgmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eCvFDmYVs5P1m3R2LWTfQoHzFgmVA9Wk0y9EW3zh/g+NWIhbXeZbHsEGH7aadYKof
	 +1NsI5XEKwhwuMXpdE2+iAl8BDmn4+USRlp8B9XSU6mFNvtsKgBoRNkplpoNkmMQNv
	 cnzGcrLqhSQuBZUc0MNDM3CQxtn6K3KIddQgBIN7eQ3jLUlsECFSoYKEkoO+ugSJv4
	 mzsAVKOnxOiUMZkSjC1IYY14N5YylPCdK9qG4TgzNv3xJ6bNclCLvmRb82eLYzh+zo
	 cTTkngHRCLWz2Ifm5HqxgO3TF/0zS3a0zGl/YiqoNZnUkGFVmzNxDvFxQTnBM/c4nE
	 30W85eLXv+RTA==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	nicoyip.dev@gmail.com
Subject: [PATCH net-next v5 11/12] net/rds: drop rds_conn_count in favor of t_conn_count
Date: Fri, 18 Sep 2026 23:11:48 -0700
Message-Id: <20260919061149.250658-12-achender@kernel.org>
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

The previous patch gave each transport its own connection count in
t_conn_count, incremented and decremented at exactly the points where
the global rds_conn_count is.  That leaves rds_conn_count with a
single remaining consumer: the seed of the per-path workqueue names
in __rds_conn_create().

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
index 5699f45e4c37..546961bb2e12 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -47,7 +47,6 @@
 
 /* converting this to RCU is a chore for another day.. */
 static DEFINE_SPINLOCK(rds_conn_lock);
-static unsigned long rds_conn_count;
 /* woken whenever a transport's t_conn_count drops to zero */
 static DECLARE_WAIT_QUEUE_HEAD(rds_conn_freed_waitq);
 static struct hlist_head rds_conn_hash[RDS_CONNECTION_HASH_ENTRIES];
@@ -332,12 +331,13 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 
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
@@ -408,7 +408,6 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 			rds_conn_get(conn);	/* caller */
 			rcu_assign_pointer(parent->c_passive, conn);
 			rds_cong_add_conn(conn);
-			rds_conn_count++;
 			atomic_inc(&conn->c_trans->t_conn_count);
 		}
 	} else {
@@ -431,7 +430,6 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 			rds_conn_get(conn);
 			hlist_add_head_rcu(&conn->c_hash_node, head);
 			rds_cong_add_conn(conn);
-			rds_conn_count++;
 			atomic_inc(&conn->c_trans->t_conn_count);
 		}
 	}
@@ -669,7 +667,6 @@ static void rds_conn_destroy_fini(struct kref *kref)
 						   c_refcount);
 	int npaths = (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
 	struct rds_transport *trans = conn->c_trans;
-	unsigned long flags;
 	int i;
 
 	for (i = 0; i < npaths; i++)
@@ -678,10 +675,6 @@ static void rds_conn_destroy_fini(struct kref *kref)
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
2.25.1

