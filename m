Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E1A4349BF;
	Thu,  8 Oct 2026 20:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.60.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791492185; cv=none; b=F/C6XSkd8Ic172to9XXPsisVFCCdsZYqNSBLHTisEX0RQuVPigG4vPnxIYKlvWJOsPe2wg8LjfwNIxl5vfsSVhx2U5h19a+XAg2hDfVfZZb26EO0KfEOorI0jBCm1pyDHDU7X3Y2KB5cIcydXoMGn5ri+iSaTLFqKeZFiGcFr/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791492185; c=relaxed/simple;
	bh=qavuuytUnhj1pEQ4hSA9YKRRwkmqgBOUtnaNxaO9QR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hE73vi49NOsQG4B60OHQIQ3BKSq+IRnai4goJ+SZxUpYmiVoextfXJaYAPnawCdYSEYOVffkTCF3C2JzP+WZq+KDPKNoe1TmSVzJ5SSbNB3fCd9FmP3OoZOu8AckEN7OjiISQDnEU4/noLH6Y4llD0Av5NDwwgnw+rtfzrhbSnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr; spf=pass smtp.mailfrom=corp.free.fr; dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b=fq3jLvBF; arc=none smtp.client-ip=212.27.60.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b="fq3jLvBF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1791492179; bh=qavuuytUnhj1pEQ4hSA9YKRRwkmqgBOUtnaNxaO9QR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fq3jLvBFhyZyRYR62g58ObH5CCOAGfN6s3IqkgYDglWcEgZiw0J8gJXNXX+dDCxkm
	 6pYKnlpJYxPHv2VWQmj0XiORlJ4yCP+Gl1jwVkKQioBTHOSSWffNi4MIM5LS74Q9JV
	 sFoyeOr/ZYt6zGUnJr/3M3XD8HRbnLOEQ92jodTd/zrLbUzpM2E4egyoFXVZhz/H8b
	 nelwdzYH7S2X3pq3iy+p5bYCbqY0r1awn05XVRXASYfBvA1nLwzQ8iA7qpAyEUVaUq
	 HsefCD5NbNBCoE1dGV7Qkw8+iYVqy+/A6bvzKgjoLOGAClIvRtUuJMtTHHdgJZlmV+
	 g/Whcdbg54atw==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id 3192B44C0490;
	Thu,  8 Oct 2026 22:42:59 +0200 (CEST)
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
Subject: [PATCH net 2/2] net/mlx5: HWS, fix modify header pool creation race
Date: Thu,  8 Oct 2026 22:42:21 +0200
Message-ID: <20261008204230.3222198-3-acassen@corp.free.fr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008204230.3222198-1-acassen@corp.free.fr>
References: <20261008204230.3222198-1-acassen@corp.free.fr>
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

Tested for regressions on ConnectX-7 with firmware 28.48.1000.

Fixes: b36315ca69cb ("net/mlx5: fs, add HWS modify header API function")
Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
---
 .../mellanox/mlx5/core/steering/hws/fs_hws.c  | 21 +++++++++----------
 .../mellanox/mlx5/core/steering/hws/fs_hws.h  |  1 +
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
index 66edb42268cb..b387016bb5aa 100644
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
@@ -1474,6 +1476,7 @@ static int mlx5_cmd_hws_modify_header_alloc(struct mlx5_flow_root_namespace *ns,
 	pattern.sz = MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto) * num_actions;
 	pattern.data = modify_actions;
 
+	mutex_lock(&hws_pool->mh_pools_lock);
 	known_pattern = false;
 	xa_for_each(&hws_pool->mh_pools, i, pool) {
 		if (mlx5_fs_hws_mh_pool_match(pool, &pattern)) {
@@ -1483,17 +1486,16 @@ static int mlx5_cmd_hws_modify_header_alloc(struct mlx5_flow_root_namespace *ns,
 		cnt++;
 	}
 
-	if (!known_pattern) {
+	if (!known_pattern)
 		pool = mlx5_fs_create_mh_pool(ns->dev, &pattern,
 					      &hws_pool->mh_pools, cnt);
-		if (IS_ERR(pool))
-			return PTR_ERR(pool);
-	}
+	mutex_unlock(&hws_pool->mh_pools_lock);
+	if (IS_ERR(pool))
+		return PTR_ERR(pool);
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
@@ -1509,9 +1511,6 @@ static int mlx5_cmd_hws_modify_header_alloc(struct mlx5_flow_root_namespace *ns,
 
 release_mh:
 	mlx5_fs_hws_mh_pool_release_mh(pool, mh_data);
-destroy_pool:
-	if (!known_pattern)
-		mlx5_fs_destroy_mh_pool(pool, &hws_pool->mh_pools, cnt);
 	return err;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h
index 20cdacd8f12e..ee37e2e6d68a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h
@@ -19,6 +19,7 @@ struct mlx5_fs_hws_actions_pool {
 	struct xarray el2tol3tnl_pools;
 	struct xarray el2tol2tnl_pools;
 	struct xarray mh_pools;
+	struct mutex mh_pools_lock; /* serializes pool lookup and creation */
 	struct xarray table_dests;
 	struct xarray vport_vhca_dests;
 	struct xarray vport_dests;
-- 
2.43.0

