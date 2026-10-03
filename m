Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88625488741;
	Sat,  3 Oct 2026 16:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791045157; cv=none; b=BcR8VyXk2zdE5jmdtdrISDejiTSH+OCXBvYFB30zRCQ4byvq8RUhxcGD/ODsuXg5ph+XTAqGOuuDAjXpqJKucTqzlRg98KCg3d71UsbHxJ2PJBF8f8yanaHwdTVvRrNm4XajQ8681F3IQmWUVW9VnRk+jsnEp3/rWWB5KVd/qSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791045157; c=relaxed/simple;
	bh=7rWMTNKDNLBbmb+h/nkRosnrwrNG/Hc8yWk7scsI65I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nD+SZa0C2Nb3pL5UoLIFjtfz/kaLNmp/6lfhk8qn8gOPH+Q4nHx9QHkOCsnjhsNMrfhsj+wjxgbQdGTsH6qLK+onH4/zEk8lrFKDaBhLODTzH2Cry2HE3ln+7O7ewXWXEkJn759w3RUgwiImvVaNVogWlONWpkQvbFxbHxQPyzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I/8V3EIU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I/8V3EIU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E021F0089E;
	Sat,  3 Oct 2026 16:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045142;
	bh=vsgT4EegZshDoVvMGK9Sk20PzYAQop1qCYh2ThW3v/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I/8V3EIU9uPE3HVhcnrONEndyRWP8yzZu2irJh5YiZn97m4Aa8bsExs2VkvleveSD
	 veCMbK8RGcrjmtIFiG0hOxSZyfV1Pj0E74r8Rge0SYOhvPdQsgV4HDTcHjligSEtG1
	 Zwtq4hjgQ4pyP11Xp2eTwCWJQVcxaE5M+fX9ME63rWv9VkcTii3DLPCx8Agxn8Ux1W
	 +UHU0hGAWWGWF75tRKBwJhexhfBEio+stYRKlWVmcjAAfkQwFyv6K+XyKBFaBJcaf7
	 ZyaKn0vwABwuBAkpwvP6uHm2BqLUZtCFA/A6K+DghJ3v5C0S/e3zkvcueVLXvROhqH
	 PK1M+RAHFAqJA==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org
Subject: [PATCH net-next v8 13/13] net/rds: drop rds_conn_count in favor of t_conn_count
Date: Sat,  3 Oct 2026 09:32:15 -0700
Message-Id: <20261003163215.250253-14-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261003163215.250253-1-achender@kernel.org>
References: <20261003163215.250253-1-achender@kernel.org>
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
2.25.1

