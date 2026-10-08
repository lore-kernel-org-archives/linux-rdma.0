Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF554349A5;
	Thu,  8 Oct 2026 20:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.60.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791492184; cv=none; b=TmXziq2CHCUKJQtToJIoIO7TTG2sybth1+pME00SeiZa0m/hm8JT2AIHcWChLgWkGq8ChSo5/Cjj7iYNH8/4dGZbqhZZMPvoYC++IngBEF65BJq/pyYNrv8lRancKB97M21Snjgt1L7HuNlmJJQmWFZKKgwb6txk0Fr7J7jxFAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791492184; c=relaxed/simple;
	bh=Ww+BZGV8RfSigAabY4qzMmWlgMx3ojs0BQJpqNnowH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifx++jqydHb/s+I462pMwOloLuxFTdvxHzTLeAZ61jxL9TZwdj/zQJgMshjkivMO4Wwkdmdbk9YX4FbSW8e/soeFU1FZRQk/OZoiVh+fl03WIXUtlyZXaK/7yGDTutjbmgbCMC/Ij7PCmhwj0/5D9cm8r7tF+KQPd3HRDbIa+Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr; spf=pass smtp.mailfrom=corp.free.fr; dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b=DgDAFwcD; arc=none smtp.client-ip=212.27.60.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b="DgDAFwcD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1791492179; bh=Ww+BZGV8RfSigAabY4qzMmWlgMx3ojs0BQJpqNnowH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DgDAFwcDmxV4eLQFwFB7Q5/SBX+3j6/e2Sr+3cOH4IFbwixIYfvj2aHSjur++EBZC
	 exWbgEBCut4UysrZpK/h95WCuoE9E/GGamRcYrfIUsumZkHZtpKDMw5rr0yafoXnea
	 IvWw+QVTSslT97c1Lk8V1zUzxeVRHexFxcwAAjKlvy7FL+r75mVOb2JAPJ4CXJA1D8
	 xg2TOlLmcRmlEmOYP7eDvGheLvbe7c98OUJEQ0KKNzqw0n0CHf/oCphtw5filPKpF6
	 HkBkCMWie9zs68ezpEFUv2o/YEv2MZ/Ff8HN82L2RbkExE/PNHv41RLpl5CZhumstT
	 WArVC53M9q6qg==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id E215944C0479;
	Thu,  8 Oct 2026 22:42:58 +0200 (CEST)
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
Subject: [PATCH net 1/2] net/mlx5: HWS, fix reformat pool creation race
Date: Thu,  8 Oct 2026 22:42:20 +0200
Message-ID: <20261008204230.3222198-2-acassen@corp.free.fr>
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

mlx5_fs_get_pr_encap_pool() inserts a new pool when the lookup misses.
Two callers allocating the first reformat of a size at once both
create one and the second fails with -EBUSY. TC serializes these
allocations under encap_tbl_lock while RDMA flow actions on the FDB
don't.

Sashiko AI review of an earlier series spotted this issue.

Tested for regressions on ConnectX-7 with firmware 28.48.1000.

Fixes: aecd9d1020e3 ("net/mlx5: fs, add HWS packet reformat API function")
Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
---
 .../mellanox/mlx5/core/steering/hws/fs_hws.c        | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
index 5a172c572a68..66edb42268cb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
@@ -1228,7 +1228,7 @@ static struct mlx5_fs_pool *
 mlx5_fs_get_pr_encap_pool(struct mlx5_core_dev *dev, struct xarray *pr_pools,
 			  enum mlx5hws_action_type reformat_type, size_t size)
 {
-	struct mlx5_fs_pool *pr_pool;
+	struct mlx5_fs_pool *pr_pool, *old;
 	unsigned long index = size;
 	int err;
 
@@ -1242,13 +1242,14 @@ mlx5_fs_get_pr_encap_pool(struct mlx5_core_dev *dev, struct xarray *pr_pools,
 	err = mlx5_fs_hws_pr_pool_init(pr_pool, dev, size, reformat_type);
 	if (err)
 		goto free_pr_pool;
-	err = xa_insert(pr_pools, index, pr_pool, GFP_KERNEL);
-	if (err)
-		goto cleanup_pr_pool;
-	return pr_pool;
+	old = xa_cmpxchg(pr_pools, index, NULL, pr_pool, GFP_KERNEL);
+	if (!old)
+		return pr_pool;
 
-cleanup_pr_pool:
 	mlx5_fs_hws_pr_pool_cleanup(pr_pool);
+	kfree(pr_pool);
+	return xa_is_err(old) ? ERR_PTR(xa_err(old)) : old;
+
 free_pr_pool:
 	kfree(pr_pool);
 	return ERR_PTR(err);
-- 
2.43.0

