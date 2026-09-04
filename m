Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD30C42AF98;
	Fri,  4 Sep 2026 07:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788505375; cv=none; b=IAqt7oHDdfpnQU+ZuWKnB7IjcNQfmULGCa+Wl86A3hwmIUtGCMKgul0B4JCqyHn+s0VfDReJjkJGScWHhWPqbx1EPPy05CtkrVUUQXs1azxVlEnOzCHoqTCLL4GfwbLpwt+UaGaK+ZXYHiv9rPum+sZW1HtY2xAW0qjr87P0/xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788505375; c=relaxed/simple;
	bh=zHcNcIT8oAHRQrN37eIsAbaoP4YHWea8/EfZfjxEVUU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mum9f3PboFhhZit2q2+fT2NPIax7bkwt4N3wW8pAFDKSXpZvAA7Fb36WecI2vo1pYL9U2+5+RX35kKh27QEPY1rw2YeJQo9KyK9sxrRzqHY7iTktxfGYaR4K1fYio/iTP3LdD3gPMoP6CtIc3hcA1uGoMz3vEYB7WFNfCJ9C6as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TqLArDoR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TqLArDoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E1D1F00ADB;
	Fri,  4 Sep 2026 07:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788505373;
	bh=2lMKVSrGeUoCkV1flFCEH/CU+5E5XXbmejDPWW8QfP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TqLArDoRKJiI8o6JQ1+CU0H7VFELebPUhgLOBUe82g9PjW1/wwzNtZ6UEKg30asYi
	 NJiAaxuhc63b8/i+Qe6m8+1SMH9qYd/0O8ptcRNIPlkEUZKP0fDcIzhiagcJmZGwzQ
	 i3M62hC42Xnul71enRTuYHp845JbT2ktfVL2w+bRFF15lfHl0u616YdzK8zbAjz365
	 4pQAiJtGUZvUgaI59CQHUNEnfaqpebrnI3V1t/GASS9y1GFCuSyTpgse3Ik7fi+qQo
	 EW/beWULVE8JmkECzBAcjnkehYoeOacwqXkxCTJD9i4bZ5yaE5esMCP5pmvk+9rP97
	 ZiLKWQMkNxEWg==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	nicoyip.dev@gmail.com
Subject: [PATCH net-next 5/6] net/rds: drop rds_conn_count in favor of t_conn_count
Date: Fri,  4 Sep 2026 00:02:47 -0700
Message-Id: <20260904070248.160384-6-achender@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260904070248.160384-1-achender@kernel.org>
References: <20260904070248.160384-1-achender@kernel.org>
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

Based on Oracle UEK commit 905ec90e6166 ("net/rds: Each RDS transport
should keep its own connection count").

Assisted-by: Claude-Code:claude-fable-5
Signed-off-by: Allison Henderson <achender@kernel.org>
---
 net/rds/connection.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index 90d660a45662..2c8ca54a91ca 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -47,7 +47,6 @@
 
 /* converting this to RCU is a chore for another day.. */
 static DEFINE_SPINLOCK(rds_conn_lock);
-static unsigned long rds_conn_count;
 /* woken whenever a transport's t_conn_count drops to zero */
 static DECLARE_WAIT_QUEUE_HEAD(rds_conn_freed_waitq);
 static struct hlist_head rds_conn_hash[RDS_CONNECTION_HASH_ENTRIES];
@@ -302,8 +301,9 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 				     is_outgoing);
 		conn->c_path[i].cp_index = i;
 		conn->c_path[i].cp_wq =
-			alloc_ordered_workqueue("krds_cp_wq#%lu/%d", 0,
-						rds_conn_count, i);
+			alloc_ordered_workqueue("krds_cp_wq#%d/%d", 0,
+						atomic_read(&trans->t_conn_count),
+						i);
 		if (!conn->c_path[i].cp_wq)
 			conn->c_path[i].cp_wq = rds_wq;
 	}
@@ -363,7 +363,6 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 			rds_conn_get(conn);	/* caller */
 			parent->c_passive = conn;
 			rds_cong_add_conn(conn);
-			rds_conn_count++;
 			atomic_inc(&conn->c_trans->t_conn_count);
 		}
 	} else {
@@ -397,7 +396,6 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 			rds_conn_get(conn);
 			hlist_add_head_rcu(&conn->c_hash_node, head);
 			rds_cong_add_conn(conn);
-			rds_conn_count++;
 			atomic_inc(&conn->c_trans->t_conn_count);
 		}
 	}
@@ -626,7 +624,6 @@ static void rds_conn_destroy_fini(struct kref *kref)
 						   c_refcount);
 	int npaths = (conn->c_trans->t_mp_capable ? RDS_MPATH_WORKERS : 1);
 	struct rds_transport *trans = conn->c_trans;
-	unsigned long flags;
 	int i;
 
 	for (i = 0; i < npaths; i++)
@@ -635,10 +632,6 @@ static void rds_conn_destroy_fini(struct kref *kref)
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

