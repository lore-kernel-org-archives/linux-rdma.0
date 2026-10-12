Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCBB47253C;
	Mon, 12 Oct 2026 10:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.60.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791799581; cv=none; b=LucsUWXXRJ+A/aNxwWuckoNq5J3hZ9NDIk2+U5Ap2Bqk6GP7LjQ3a3qAS7G9bzVGL4qOVZ+Zvh0PG3VtrXJNe4KCoclwlxvP9qH+tmxVJbwtrQM0Rrv4YS4oszUTYaVbb/c7xnZb+IKTJJmBbvZOgbGAyeMgSyDiB60EQR7NaS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791799581; c=relaxed/simple;
	bh=Z5Ilt+pdwtP/h4MQMF+5aIMIESjOfx+bsTtpBlEsPkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sngoF/DpzicYZFLNOyoJQ+O/sHT+pYFxQdY7aaOEzVwQy8cMKgLx7/ADyilWImcVljh4VqoLyx0MbLsqrIVNrWvbmwPHPiGiP1SdhzCvhBjDtZV48xz3cyUrOEUkTuee/qd4prKyPqOmVMEaEM2ZXGxd+9MZ9LiNtAexoCDWSts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr; spf=pass smtp.mailfrom=corp.free.fr; dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b=P3ylZB/9; arc=none smtp.client-ip=212.27.60.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b="P3ylZB/9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1791799562; bh=Z5Ilt+pdwtP/h4MQMF+5aIMIESjOfx+bsTtpBlEsPkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P3ylZB/9utnxCS4gYV5Tnc2Tnw3VEz2GTUMV7UqsWgSEiDLykNLf3aZi3NZ1kb7V6
	 VS7K0QSvcTFaVN2VNseCQ5J8qeNamkJHluY7GHfXNBcmBP3zqgIT/wN9F/vYZsYN0H
	 lbChpicLxP//yMGF3DRY51iB+o5huKRcC+GTIYrlUoArxJ34X/m9vOE3oi8aYorXAE
	 qc/4UwRVcsIugZ3yUGfoHVPEZ58mdR4INH4ZcBNfo2VArOgVuaBSXltay1YIs9BwTA
	 +h7kAwXCmW6agpC72SIktuIVJmWUyOJQ+lhCwy3LTJajdi404SPd3Dky9tUVAPpbC5
	 ZKTmTbebqvsnQ==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id A7A5F44C2BA3;
	Mon, 12 Oct 2026 12:06:02 +0200 (CEST)
From: Alexandre Cassen <acassen@corp.free.fr>
To: Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH net v2 2/2] net/mlx5: HWS, fix modify header pool creation race
Date: Mon, 12 Oct 2026 12:05:54 +0200
Message-ID: <20261012100555.1317878-3-acassen@corp.free.fr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261012100555.1317878-1-acassen@corp.free.fr>
References: <20261012100555.1317878-1-acassen@corp.free.fr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mlx5_cmd_hws_modify_header_alloc() creates a pool at the index after
the last one if no pool matches the pattern. TC and CT allocate modify
headers concurrently, meaning two callers can take the same index and
the second call fails with -EBUSY.

Its error path also destroys the pool it just created although another
caller may already use it. Keep such a pool since cleanup releases it.

Pools now live until cleanup so the lookup needs no lock. A miss looks
again under a mutex before creating the pool.

Tested for regressions on ConnectX-7 with firmware 28.48.1000.

Fixes: b36315ca69cb ("net/mlx5: fs, add HWS modify header API function")
Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
---
 .../mellanox/mlx5/core/steering/hws/fs_hws.c  | 53 +++++++++++--------
 .../mellanox/mlx5/core/steering/hws/fs_hws.h  |  1 +
 2 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
index 66edb42268cb..11cced847186 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
@@ -63,6 +63,7 @@ static int mlx5_fs_init_hws_actions_pool(struct mlx5_core_dev *dev,
 	xa_init(&hws_pool->el2tol3tnl_pools);
 	xa_init(&hws_pool->el2tol2tnl_pools);
 	xa_init(&hws_pool->mh_pools);
+	mutex_init(&hws_pool->mh_pools_lock);
 	xa_init(&hws_pool->table_dests);
 	xa_init(&hws_pool->vport_dests);
 	xa_init(&hws_pool->vport_vhca_dests);
@@ -111,6 +112,7 @@ static void mlx5_fs_cleanup_hws_actions_pool(struct mlx5_fs_hws_context *fs_ctx)
 	xa_for_each(&hws_pool->mh_pools, i, pool)
 		mlx5_fs_destroy_mh_pool(pool, &hws_pool->mh_pools, i);
 	xa_destroy(&hws_pool->mh_pools);
+	mutex_destroy(&hws_pool->mh_pools_lock);
 	xa_for_each(&hws_pool->el2tol2tnl_pools, i, pool)
 		mlx5_fs_destroy_pr_pool(pool, &hws_pool->el2tol2tnl_pools, i);
 	xa_destroy(&hws_pool->el2tol2tnl_pools);
@@ -1457,6 +1459,23 @@ mlx5_fs_destroy_mh_pool(struct mlx5_fs_pool *pool, struct xarray *mh_pools,
 	kfree(pool);
 }
 
+static struct mlx5_fs_pool *
+mlx5_fs_find_mh_pool(struct xarray *mh_pools,
+		     struct mlx5hws_action_mh_pattern *pattern,
+		     unsigned long *cnt)
+{
+	struct mlx5_fs_pool *pool;
+	unsigned long i;
+
+	*cnt = 0;
+	xa_for_each(mh_pools, i, pool) {
+		if (mlx5_fs_hws_mh_pool_match(pool, pattern))
+			return pool;
+		(*cnt)++;
+	}
+	return NULL;
+}
+
 static int mlx5_cmd_hws_modify_header_alloc(struct mlx5_flow_root_namespace *ns,
 					    u8 namespace, u8 num_actions,
 					    void *modify_actions,
@@ -1467,33 +1486,28 @@ static int mlx5_cmd_hws_modify_header_alloc(struct mlx5_flow_root_namespace *ns,
 	struct mlx5_fs_hws_mh *mh_data = NULL;
 	struct mlx5hws_action *hws_action;
 	struct mlx5_fs_pool *pool;
-	unsigned long i, cnt = 0;
-	bool known_pattern;
+	unsigned long cnt;
 	int err;
 
 	pattern.sz = MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto) * num_actions;
 	pattern.data = modify_actions;
 
-	known_pattern = false;
-	xa_for_each(&hws_pool->mh_pools, i, pool) {
-		if (mlx5_fs_hws_mh_pool_match(pool, &pattern)) {
-			known_pattern = true;
-			break;
-		}
-		cnt++;
-	}
-
-	if (!known_pattern) {
-		pool = mlx5_fs_create_mh_pool(ns->dev, &pattern,
-					      &hws_pool->mh_pools, cnt);
+	pool = mlx5_fs_find_mh_pool(&hws_pool->mh_pools, &pattern, &cnt);
+	if (!pool) {
+		mutex_lock(&hws_pool->mh_pools_lock);
+		pool = mlx5_fs_find_mh_pool(&hws_pool->mh_pools, &pattern,
+					    &cnt);
+		if (!pool)
+			pool = mlx5_fs_create_mh_pool(ns->dev, &pattern,
+						      &hws_pool->mh_pools, cnt);
+		mutex_unlock(&hws_pool->mh_pools_lock);
 		if (IS_ERR(pool))
 			return PTR_ERR(pool);
 	}
+
 	mh_data = mlx5_fs_hws_mh_pool_acquire_mh(pool);
-	if (IS_ERR(mh_data)) {
-		err = PTR_ERR(mh_data);
-		goto destroy_pool;
-	}
+	if (IS_ERR(mh_data))
+		return PTR_ERR(mh_data);
 	hws_action = mh_data->bulk->hws_action;
 	mh_data->data = kmemdup(pattern.data, pattern.sz, GFP_KERNEL);
 	if (!mh_data->data) {
@@ -1509,9 +1523,6 @@ static int mlx5_cmd_hws_modify_header_alloc(struct mlx5_flow_root_namespace *ns,
 
 release_mh:
 	mlx5_fs_hws_mh_pool_release_mh(pool, mh_data);
-destroy_pool:
-	if (!known_pattern)
-		mlx5_fs_destroy_mh_pool(pool, &hws_pool->mh_pools, cnt);
 	return err;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h
index 20cdacd8f12e..cf068fb5bdbf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h
@@ -19,6 +19,7 @@ struct mlx5_fs_hws_actions_pool {
 	struct xarray el2tol3tnl_pools;
 	struct xarray el2tol2tnl_pools;
 	struct xarray mh_pools;
+	struct mutex mh_pools_lock; /* serializes pool creation */
 	struct xarray table_dests;
 	struct xarray vport_vhca_dests;
 	struct xarray vport_dests;
-- 
2.43.0

