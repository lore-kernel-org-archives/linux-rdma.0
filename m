Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010047.outbound.protection.outlook.com [52.101.85.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1789540DB54;
	Mon,  3 Aug 2026 13:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785763591; cv=fail; b=N13o0AmmLgD6jnaalQO/vKs6ihGNtMap2B0cTqOxQXb9u0oVEwzJcR71PI3wJJVeV14GE7yYQfBSeIJWVywp+tG6Gnor+QDA6pFyLFaWaDsQXwoe642IhDZHU8spEdAj1wVv5XHLOjxvOJLftOVfW3uMkKCW9n4U3xFS3909lHI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785763591; c=relaxed/simple;
	bh=NkNE0Ej/kRc1iYTROmOSQlQ46IbV7R/rl3+Jg6UE7XY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RwNrvtcpRcgyMT0VvxlVHk9++vfhj3AU9YlxO0+U5iA0R/UO1HSyM3cjxFtuhMQMMiswU0n6onLo5eEtSz4uao+BbfH7+6FTeXHAunJXH070XriPDlLMk/6MyYt+lCOpCVSStd5BlrvgQenZ8nxodceAPwqIj4mv2O2kzP8dvqc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WUu8/SHu; arc=fail smtp.client-ip=52.101.85.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WUu8/SHu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KJuuTyPu+sWEUTbnzCbkIhv52acZZKJ9qtRHPuxib2Rd5ihtxOfumBdX3WbnDf6/KgCwI24NLf7lYu96Ewt22vj7ZNmu4v0/33vHkt+y7K/gTelFfM9jBauC4w5njLHJdx5c3k9qPDxFKqxXzgOUwqYKWnfX8IKAYAJ6epPKUZKr3A65u2p7AxanzJPN3V3uI7uKUbryLrxGYnKM58N4kjAM0PYy4sjN0X2Zao/F5kpwbRpEhI3ETT1gCEx0AMXLYNwQycX1vBC6yMK+RfFTvTlH9p6YHkZ+pa/G+Hforb30klWZ0CZBNK9Ai6ayv1rYuZILBdQ01+w6g1SGGeYAlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fSQcMffT84dwPijp5MJtWDigwIZ4E2syN40ZQzj7i+U=;
 b=CFpS60bcSxNioqXL/7mED6lK4SVx2fpz6btQdGHoNZ4IGQg75bwO4tgGzEiOaLkFv5OHo7bm6UmlTlNJfil2SOIVt2EV61OKRAeglcT9Yl4pYU9UpNjsge3N/hGVGWXO5DLS7bWSkEMGcXXzFbmAyDjJlDzd+CBp+out3+9B28aMZsu7R8Ji3MJebHiVjlCajn0Myg8Z/eO1I/9yox6WEc3FihRhed+Mv20oPKrWwCOErgwry3LCqq+R929iur4rBHtQ32dEZIi/zBxfcb8CKORhdkPi7JIOy77jqzcH8g7PJ2fpQq3IxI/fmYLySgT2U5HbpuYF1B6aukw88UobfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fSQcMffT84dwPijp5MJtWDigwIZ4E2syN40ZQzj7i+U=;
 b=WUu8/SHuUUUf+RckBGtk8zsL8jeQ7NyVmsrLHVF7E0Od5seriDBFJ1aSPVvHiF+XVACdM3oFfgaoyn1+lCx/ROXnkazLJP//OHfn51oGOZX406+WmCDIpgFV7uwfwZDjvLl9ChtKOVsClEEBDckFwcNLaIGI73ZFnTl6z6pnXOP4UflvscwLelhqUO9FypSyW2JJpKl6OkiKBMg4tHMrHhmJhxrEnv251HSBxt4QGCOKPwHepSsC/tLOUvPIR6+04horKX5PFDunzLDvETi367JO3SNU8daBTh9OWdokVfyyBVzd82qDrvVBMesQvN6EGVXn5CMhoGIw2Fj9+QpVpQ==
Received: from SA0PR11CA0074.namprd11.prod.outlook.com (2603:10b6:806:d2::19)
 by SAWPR12MB999316.namprd12.prod.outlook.com (2603:10b6:806:55f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Mon, 3 Aug
 2026 13:26:21 +0000
Received: from SN1PEPF00026369.namprd02.prod.outlook.com
 (2603:10b6:806:d2:cafe::b) by SA0PR11CA0074.outlook.office365.com
 (2603:10b6:806:d2::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.18 via Frontend Transport; Mon, 3
 Aug 2026 13:26:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SN1PEPF00026369.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Mon, 3 Aug 2026 13:26:21 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 3 Aug
 2026 06:26:01 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 3 Aug 2026 06:26:01 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 3 Aug 2026 06:25:57 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Nimrod Oren
	<noren@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net-next V2 3/3] net/mlx5: add debugfs stats for doorbell dma pools
Date: Mon, 3 Aug 2026 16:25:20 +0300
Message-ID: <20260803132520.2891860-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260803132520.2891860-1-tariqt@nvidia.com>
References: <20260803132520.2891860-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00026369:EE_|SAWPR12MB999316:EE_
X-MS-Office365-Filtering-Correlation-Id: 76e3c541-8a80-4068-b6bb-08def162cf23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|1800799024|82310400026|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	UI7MvEuiyjF6d1WdHKcvYv3p9/MCyHtCwzd1tN6gLRUmdoOQ4SmopBlFl2xofuDX1DuNA1RElUIMXcbaUC+qAUYe0sL7t8sIdybnjmKMIHYtLnG96dEvKHnkPEp0grPYUf/qK88myGZ7//+TGZcPMIN3LbYXoHXb6I8xERRqFf6x+CzBVLSkiawKIIqaQh1kb7fyx1wRz58lVCn624lZqPMYu+m/bKBjZjmr+2oGXRI3YPADXOT+wRkukcfeLGC6Px16eHypIDlvi3kFiNY9P6jrKvdLXRGAIMyNL7mOWFSeRgdYF2yiJOTifNIzUjCaqofRl8cPVSD5lIbttPcOXR/9rTjB0S8MXREQlkcM/jEMq5Xa8LVMwfooEIa2Y/bkHY5tpnd0ubDUUC3yLhSI0Rfd/PqR3EBvGdrGWMECRtaucr0pX6L4D7dgQtrSfWV3wkZ/TC3HOmgo7pJzF0wgi7slo6UfuWnT6ee1ld+nZPqLY60Wi5dFBeG/ObajeHxJq6Cspn1Zz8bUc0e+0vA5nLdX7uEfzoiNiAgBNEo/G8sifyQb8A/NX9lua55uBp34ABTNKfz7xij8xofvAcn/mYdT2j40gRuGTwTJL8azfEyheu9viZu+z/4HDr9Cc+/EG72RqFMVjeja2pMMgsr9U0AwAvtAnnAwwUxwK8lK8RQASAv0bPQgiyMorz3GB/dLu8hTZC9JOjBbyxvgEXZ8RQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(1800799024)(82310400026)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2Q3PtTKab4aM9/9uOMGL9ky3iaV/g35rk8bv1DQqx16tNU6t3qNYZ+sA9qhfpcwGNni302nY1m24PmN1huJqXZVHLHLvg7LWNh9leP0kyDSfGTRzp0NotgWLrFmQoC+Yu9EhPAa10G1eB+yg3UXBqCumwST7ffa/GxBerNolNIiT5YsBP1Ei2FuDHOn0k8iyS9D7QPLJeLZKfU1SVsWR18OV8YuHNIgaJ/AgSWSeL5q7ykHo7+OmSm/E1kGKXhCrYvcu/Cl9auZzUtUaU3qMzkt7vuOLIUvRZGFn9nh5R0bYQGNWyGsPPk1EfeeHsIAcmNARW9PQJqm0l85vZbjmOdsFtVjDtYvFVjpO/bmUFr4j4pCg6yFuqXul3kkOjjxU8qzq1lHAdjIYQbL2BNKHOb94YV+HzkniMvbF+KkqsWHm5OzLadWTi17HmSrbeNB7
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 13:26:21.6257
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76e3c541-8a80-4068-b6bb-08def162cf23
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00026369.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR12MB999316

From: Nimrod Oren <noren@nvidia.com>

Add a debugfs file exposing per-node DMA pool usage for doorbell
allocations.

  # cat /sys/kernel/debug/mlx5/<dev>/db_dma_pools
  node  block_size  used_blocks  allocated_blocks
     0          64            0                 0
     1          64            0                 0

Signed-off-by: Nimrod Oren <noren@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/alloc.c   | 27 +++++++++++++++++++
 include/linux/mlx5/driver.h                   |  1 +
 2 files changed, 28 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
index 3975c726d35c..a92cf545bdaf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
@@ -437,11 +437,34 @@ void mlx5_frag_buf_free(struct mlx5_core_dev *dev, struct mlx5_frag_buf *buf)
 }
 EXPORT_SYMBOL_GPL(mlx5_frag_buf_free);
 
+static int mlx5_db_dma_pools_debugfs_show(struct seq_file *file, void *priv)
+{
+	struct mlx5_core_dev *dev = file->private;
+	int node;
+
+	mlx5_dma_pools_debugfs_print_header(file);
+
+	for_each_node_state(node, N_POSSIBLE) {
+		struct mlx5_dma_pool *pool = dev->priv.db_node_pools[node];
+
+		if (!pool)
+			continue;
+
+		mlx5_dma_pool_debugfs_stats_print(file, pool);
+	}
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(mlx5_db_dma_pools_debugfs);
+
 void mlx5_db_pools_cleanup(struct mlx5_core_dev *dev)
 {
 	struct mlx5_priv *priv = &dev->priv;
 	int node;
 
+	debugfs_remove(priv->dbg.db_dma_pools_debugfs);
+	priv->dbg.db_dma_pools_debugfs = NULL;
+
 	for_each_node_state(node, N_POSSIBLE)
 		if (priv->db_node_pools[node])
 			mlx5_dma_pool_destroy(priv->db_node_pools[node]);
@@ -471,6 +494,10 @@ int mlx5_db_pools_init(struct mlx5_core_dev *dev)
 		priv->db_node_pools[node] = pool;
 	}
 
+	priv->dbg.db_dma_pools_debugfs =
+		debugfs_create_file("db_dma_pools", 0444, priv->dbg.dbg_root,
+				    dev, &mlx5_db_dma_pools_debugfs_fops);
+
 	return 0;
 }
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 2c56bb1d676d..83d0a83bbfbc 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -548,6 +548,7 @@ struct mlx5_debugfs_entries {
 	struct dentry *cq_debugfs;
 	struct dentry *cmdif_debugfs;
 	struct dentry *frag_buf_dma_pools_debugfs;
+	struct dentry *db_dma_pools_debugfs;
 	struct dentry *pages_debugfs;
 	struct dentry *lag_debugfs;
 };
-- 
2.44.0

