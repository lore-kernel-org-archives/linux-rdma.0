Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C94360EF2;
	Mon, 14 Sep 2026 03:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789357048; cv=none; b=PRy/cWC54BnsaE+C3BAmA4Relgvymu/pnPFuWk8wAtQFPkMvyTzv9N053zbv9SP8rDf2FLpo8TkxZwm9lwdZnJPQk4nvn2mXSw+RKhBPZN2HGInzj1LLlAMUFsspCS715eGZOpiZV3FVxPp0nC8RieCwzQ7SvkCyvEeZPjs/TIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789357048; c=relaxed/simple;
	bh=IvXMUudo4vfx/gOC1IrVVgdp9B6SuF91cGN/4R4bEt0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JHEiMl0Q7V2c0dE3BRtP1DFKNjmfFxWQFZ9CIrnBE4/fNmu93TSLEJ/hQnSXG9ejd15Tly2ySUz+so/kidemsPJ9TGhYRAozyA22Vwo8a9sAtLg/wzG3JoQJUHpjXncB7c4no3UJPksdQZchYJQPOnrfQfqC5lyFFHX1ScradRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cf/sPe8w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cf/sPe8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64EEC1F000FF;
	Mon, 14 Sep 2026 03:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789357046;
	bh=pgSaccr31vvq36fpdiyaqN5ENIPd6m7tZyd54+RlfVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cf/sPe8wfmbyhVU17magYCemA2ZT0snauNkoCCY61lOI8Rp38PqZevtcc0LZ1M0Nw
	 rJUn9mc8YezxgMUQwms8n9PJQPuwegOrAzEHEQkQTAZqmQQdn6Wrc20zMD+veWzXmZ
	 94ZsC52M1nkGZLxbuSUaHHbCgVplIHvCZD2zcI8mBW5oK+ETFR0PrLg02DkwAeK28o
	 oqUZT1isBwzP8lrqpFVz0wftxSa+O1L4OIcg1ajHTCB1wj4u/zTsVHGfZaO2Y7b6Jq
	 z1yYmprXt0nbXlZtgf7Samw+LglxVqb3P2r3nXMkUp+RqXXxAaRpnCED5ZWraUBqKy
	 oR39WfCXVkp/w==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	nicoyip.dev@gmail.com
Subject: [PATCH net-next v3 12/13] net/rds: drop rds_conn_count in favor of t_conn_count
Date: Sun, 13 Sep 2026 20:37:18 -0700
Message-Id: <20260914033719.138057-13-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260914033719.138057-1-achender@kernel.org>
References: <20260914033719.138057-1-achender@kernel.org>
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
rds_conn_destroy_fini() took solely to decrement it, leaving the
free path lock-free.

Based on the Oracle UEK commit "net/rds: Each RDS transport
should keep its own connection count".

Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/connection.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index e5a8534c23cf..f5f25e4a53b9 100644
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

