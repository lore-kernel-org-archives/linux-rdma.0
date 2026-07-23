Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012042.outbound.protection.outlook.com [52.101.43.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B863DB633;
	Thu, 23 Jul 2026 07:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784791403; cv=fail; b=kV8CDthzoA2VxqQVw7uOSsec9FWC2iodRNKCqQrQKKNGKhEQ4hv17EWnuY/5NDvDFKxHNRyTUqkTr//oD9rwaGSr6XUAiz0OfEpgVfTMM1+Da9jDfNV5UzA0k7rOZzHnMKQ8OTt2SHs8rinqZS4rczxyorUPaTQEV3FdbYpvIqU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784791403; c=relaxed/simple;
	bh=un+WLtelwryIBQD5MJBt+TGs30fQIcCABwn7kYcQHR4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uYLWv1c+NxI6RL4d6wFHlJql7W8/0k6ejB1NbW/S0iMwIYgfBJrzP6fV68fjicKMQ2BrPG55HiQS4M7CCrsniV5muP5IDZ1o+jqNz6VzUvX2BScHdYI3SvsgItdqM3REQr2wga5ew+H8rxw0qoB2nnO/A9autCDKUYOhdIkBaoQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DhTZsoJu; arc=fail smtp.client-ip=52.101.43.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DhTZsoJu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TE+O+rjzcxWFX1WrMXz3WlAPFBDYxSX0TF/6AUTIWdwrMbYpAuoxqTikdT3dbTIHplTOryNu0rXw7JnuHuomCxdqVaLlDRdvfCt1TQ7tQKqJo2fc+L4Irr1SqKuJM0F4AhBFAH+B97KmynL2KM9SDMurIPSf4d9YeI9Lvis32/vyyuXJKbXjtUBtmydKAqLudO99Uq+cKiE60hln5f+qk0H0gLY9e8M4m1/9gPeJRZkC7H+w15vOsoQvjF0Hg9sV2aRk/3aIatLvCJMgwe1WousCB8tq7UZMrEMAO+sroQzfmd0ODiv015PR6dor3zjjMypTwjXOrPqQy/4mJ9EsOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pbFwkqqVv0uqCxKjxsa4wg4lsKdOvR5SNZm3cVy3/oc=;
 b=b+hpwFPeXNX/plAknvL9oeub0y7Sb5+sT/kA9sxLo1qaDtrJqaVnFumOTJSA3owItaQRDzKxyDhnHsUSHpqaVdq4V2LfPxl+fXJtKtbIMPJDE/Bh2qMfMUUdq+HglxYE2T9iqx9DlrvU1mo40pphvMMU+nVcbxxcvUySXNbt8O6xw6WFEPqYXzCcBWp+L5KwIKGjOu/ir0mCesPm/JbJNFMRdfuRRPROkBPIFqHkupYRR3fjwpxITfIkzfPWz/JLBOn+tEG34cxhAQAMTOCbM5mxAQcQQ6ARkMDJFz9OQ56hNjU01CNcaIS/IAAqDk5L0EL6BqHmpIE9ni+c24MUFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pbFwkqqVv0uqCxKjxsa4wg4lsKdOvR5SNZm3cVy3/oc=;
 b=DhTZsoJunmU4xK0vEUYwCvzJ82f074QXhZE4tCVIkIcH94W2+NMxF+aLwR/gRHs+r4evrAzAo3EDQ9RkJJekzvDW59qMPNcrmaXWUmZvr50ETS39fTmC62bAyjfZTtP8LqY618Tcem8qznxso6A+1fDyUXERzQgZvvl3hwoqdNCeBd9Pkb1gft4mElcS5z4gk/2lXg6ptoaLsrnQJ1tIyJN0wKTNmjNdO0xd7M7X1ZaExtZglQKh4b1nMi7fQa66IW2lyxvJrFtUlXaLkU0IvFlun3KbpdE/buVFvr2GD5DacT1lKXcOW6/R2QnHZ+ZJkHJW7ZRnBhZcR2Hc8Nmoww==
Received: from DS1P221CA0023.NAMP221.PROD.OUTLOOK.COM (2603:10b6:8:242::6) by
 CH3PR12MB7571.namprd12.prod.outlook.com (2603:10b6:610:147::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.11; Thu, 23 Jul 2026 07:23:12 +0000
Received: from DS2PEPF000061C4.namprd02.prod.outlook.com
 (2603:10b6:8:242:cafe::24) by DS1P221CA0023.outlook.office365.com
 (2603:10b6:8:242::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Thu,
 23 Jul 2026 07:23:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS2PEPF000061C4.mail.protection.outlook.com (10.167.23.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Thu, 23 Jul 2026 07:23:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 23 Jul
 2026 00:22:59 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 23 Jul
 2026 00:22:58 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 23
 Jul 2026 00:22:54 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Nimrod Oren
	<noren@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net-next 1/3] net/mlx5: initialize doorbell dma pools
Date: Thu, 23 Jul 2026 10:22:20 +0300
Message-ID: <20260723072222.1863558-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260723072222.1863558-1-tariqt@nvidia.com>
References: <20260723072222.1863558-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C4:EE_|CH3PR12MB7571:EE_
X-MS-Office365-Filtering-Correlation-Id: 0536a0e7-670c-4594-ced7-08dee88b4103
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|36860700016|82310400026|376014|56012099006|10067099003|22082099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	LRfQ7Bd4kJ9BrIyXEda0Qrn1pXwx0pA/2pfguzRKWYuZTea4FErGsIc8DSwjIdzuWVthcPm3bvNRKLT1dVFZN9HTrz4mydFB3nFP3LNNw1hXOAx8wuPe8oAGrMWB4euMFg4Ydu4ynrjnLdREha3D2eVVPzPLgbB/12zxmZU0LIwaFEjXQNcqym1jJU1+t1oSlrhyUFV4gqC2ZF5Gfu65o6TzSqduX8mJgNvUscaq8WcP0BMO3+WVaGoIf72Gv/NcQmdO32KqfSg00vwq13d3buwW7Xz62HKATc8VmO1sKD6vUMt7P2HjtodUtBP8NHjaqc86uVlIWwn1YigJbMtbXiKMbjXRyQayI+TaEJnbw2GYpfK0RscrQktWlNEno/jWXzCOPUtktSAxLPo0/vHnhrk1pqYSrxhYwpzJmzmf34iMSmgbBFo4RBuN3b+Fu6MTWeJcp5F+5X+LDxoqhbuHA/AZCh80Ihd6BiQ5+wLJ6MXV3aFIW5wRfvwWcoH0A97Zg0nhoVwO0pBArgg1pjN8QJPVyTZ3Y4SEMeq7VhneF4eBIh5hhQ6/gulkpKfeAmEFmMnGzlYP+RsLabp2D/at6gbsYGEM1robCNM33dNn5o1Kj5LB6upSip6/Pr9fBijcLlmNJj2fF/MftwVfDX8bIgCugiNO/jOs8yprVtY8f2fAth9cbROPrPeAidxHe0t4iTJNTjMcIfYPzIhiwpUXsw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(36860700016)(82310400026)(376014)(56012099006)(10067099003)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mWNk+DFyjWbTBheBHlhL2WIX7wmF3tzokwNwcFqIaIzcz0c85FiuQVx1S3Dimw9GMcXoFu7cayWJH4V0YRsHfFqaKFG73d0EJSO+4d/CdP6uhnOTa08OW8dinvYU1DodnRp632+cg3k8lQ+h7kGbj3bHpvoxNQwFlvtZXc8xXheH/CtdvMunat4toLYptjlf21O24qO6z/GEg7Qx5w8dsMKCxHh3QdHDIxtG11bmMw6E+a/ms3l4J20o5Ovf0ocpvII6CTUsVzbKV/tVuzG+czgAVEBA+721/06tD9k0tfKynikOVwmFVkToI/jHaBsKqpPUL0SBUAFvP7Ln8/w4/PkXuroZEKtUSq/Rl+m8c30WDR/E7qqRG19yx6InXWVfpAR2UYiMsMazbZqfgOZfDPVD4vNtImKO+FaUy0yYSWLBYiTWkCBAx0z/7XCqDsif
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 07:23:12.0513
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0536a0e7-670c-4594-ced7-08dee88b4103
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7571

From: Nimrod Oren <noren@nvidia.com>

Add per-node doorbell dma pool creation and cleanup to mdev lifecycle.

Signed-off-by: Nimrod Oren <noren@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/alloc.c   | 37 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/main.c    |  7 ++++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  2 +
 include/linux/mlx5/driver.h                   |  2 +
 4 files changed, 48 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
index 4fe9d7d4f143..3c9938068c56 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
@@ -444,6 +444,43 @@ void mlx5_frag_buf_free(struct mlx5_core_dev *dev, struct mlx5_frag_buf *buf)
 }
 EXPORT_SYMBOL_GPL(mlx5_frag_buf_free);
 
+void mlx5_db_pools_cleanup(struct mlx5_core_dev *dev)
+{
+	struct mlx5_priv *priv = &dev->priv;
+	int node;
+
+	for_each_node_state(node, N_POSSIBLE)
+		if (priv->db_node_pools[node])
+			mlx5_dma_pool_destroy(priv->db_node_pools[node]);
+
+	kfree(priv->db_node_pools);
+	priv->db_node_pools = NULL;
+}
+
+int mlx5_db_pools_init(struct mlx5_core_dev *dev)
+{
+	struct mlx5_priv *priv = &dev->priv;
+	int node;
+
+	priv->db_node_pools = kzalloc_objs(*priv->db_node_pools, nr_node_ids);
+	if (!priv->db_node_pools)
+		return -ENOMEM;
+
+	for_each_node_state(node, N_POSSIBLE) {
+		struct mlx5_dma_pool *pool;
+
+		pool = mlx5_dma_pool_create(dev, node,
+					    order_base_2(cache_line_size()));
+		if (!pool) {
+			mlx5_db_pools_cleanup(dev);
+			return -ENOMEM;
+		}
+		priv->db_node_pools[node] = pool;
+	}
+
+	return 0;
+}
+
 static struct mlx5_db_pgdir *mlx5_alloc_db_pgdir(struct mlx5_core_dev *dev,
 						 int node)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 643b4aac2033..b3cb090b5677 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1830,6 +1830,10 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	if (err)
 		goto err_frag_buf_pools_init;
 
+	err = mlx5_db_pools_init(dev);
+	if (err)
+		goto err_db_pools_init;
+
 	INIT_LIST_HEAD(&priv->traps);
 
 	err = mlx5_cmd_init(dev);
@@ -1891,6 +1895,8 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 err_timeout_init:
 	mlx5_cmd_cleanup(dev);
 err_cmd_init:
+	mlx5_db_pools_cleanup(dev);
+err_db_pools_init:
 	mlx5_frag_buf_pools_cleanup(dev);
 err_frag_buf_pools_init:
 	debugfs_remove(dev->priv.dbg.dbg_root);
@@ -1917,6 +1923,7 @@ void mlx5_mdev_uninit(struct mlx5_core_dev *dev)
 	mlx5_health_cleanup(dev);
 	mlx5_tout_cleanup(dev);
 	mlx5_cmd_cleanup(dev);
+	mlx5_db_pools_cleanup(dev);
 	mlx5_frag_buf_pools_cleanup(dev);
 	debugfs_remove_recursive(dev->priv.dbg.dbg_root);
 	mutex_destroy(&priv->pgdir_mutex);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 09e669f83dba..d6713a2ce676 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -438,6 +438,8 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx);
 void mlx5_mdev_uninit(struct mlx5_core_dev *dev);
 int mlx5_frag_buf_pools_init(struct mlx5_core_dev *dev);
 void mlx5_frag_buf_pools_cleanup(struct mlx5_core_dev *dev);
+int mlx5_db_pools_init(struct mlx5_core_dev *dev);
+void mlx5_db_pools_cleanup(struct mlx5_core_dev *dev);
 int mlx5_init_one(struct mlx5_core_dev *dev);
 int mlx5_init_one_devl_locked(struct mlx5_core_dev *dev);
 void mlx5_uninit_one(struct mlx5_core_dev *dev);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index b1871c0821d0..4246d6d904ba 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -569,6 +569,7 @@ enum mlx5_page_mgt_mode {
 };
 
 struct mlx5_frag_buf_node_pools;
+struct mlx5_dma_pool;
 struct mlx5_ft_pool;
 struct mlx5_priv {
 	/* IRQ table valid only for real pci devices PF or VF */
@@ -602,6 +603,7 @@ struct mlx5_priv {
 	struct list_head        pgdir_list;
 
 	struct mlx5_frag_buf_node_pools **frag_buf_node_pools;
+	struct mlx5_dma_pool **db_node_pools;
 	/* end: alloc stuff */
 
 	struct mlx5_adev       **adev;
-- 
2.44.0

