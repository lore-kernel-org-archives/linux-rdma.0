Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011038.outbound.protection.outlook.com [52.101.62.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2772625785D;
	Mon,  3 Aug 2026 13:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785763581; cv=fail; b=IrfRX9V5ZcwxVndPqWHwfPVkvOdEauFAqWGilcaqhGT+/eZB4Mg84G94MnzKnM67f4VDQT2g+etSyIHXjBZUuFncNRjuNJyqXemEbAOlb6CQPYEdTftpxN6XsBMMHxS/bLOS+XNWVmtAppc3OE3v2brSUl/QRO93TnoM5EKdfQI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785763581; c=relaxed/simple;
	bh=un+WLtelwryIBQD5MJBt+TGs30fQIcCABwn7kYcQHR4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S4x4y7N3mDywXvoe7lsg2uPtaNao1aZZ28QQyLL4YOR2gmDKhljoxYlGpcbnEKcyA/qOVJ+aNv567nQ7IZ0c0o7j0NdJow32p3sd4DP+yspAZbtQNZJpi2x6ymnlSEtpWqPxSurFWi8dpoHIgOryiBpAB5S6hCKgBpdDpcxLI1E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NJ5gqgh2; arc=fail smtp.client-ip=52.101.62.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NJ5gqgh2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WnH2Bad49nyfwZE3fxetFFeeuIwtwgfsFb2gVlR03l6z/egk42MYA00p0DaSUy6p9F4hV2VQOdShhAbgTZCkWZMwczEXygeLJahQ9RXsWprqq+vkwF/6WucQlroqgtmf8aPOm05k+pbxIhUg3MEfvEUNnt7OmFot5T6KUteF0JtfOvbcioUTnNYGyF6xtdQ/RHuvt5GkIbrJGCGmnzqQxHrtBGsbJiz+zpq3aglddJUWqhZwRjw7jHRag/ZW6HdN8VGkjFtYcQ+k4PYoKHRfQ3jO6hHbwYh1aqGLKsBCTi7X9DMVM4LytrcHx9GvjvRHPV3YI7bVUE+YPKO2hoYKQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pbFwkqqVv0uqCxKjxsa4wg4lsKdOvR5SNZm3cVy3/oc=;
 b=HAg8z0gCXG9vYmnX1VKhBavDya8LJXs4m5NW5yLXhY/V3k/iW3AxphDXuMAO8bFRbYbH/DuS1ZEMWvUYwv+urx9L0uUUUfaeFLmbrVIYLZiX7P4iNd+IV5NcdypW9v/VlUVjLh9Cho9IaECS5ct0oJyvENdVo0aGz0IyxjuZV5ZJ4EYnBpxTv8NMh2C8ymULEo4d4XaZHFZjXJpfE2RBINqrY6KVeV2b3BRcsGYMvay8GF/hdnGyHb06psL7TExjNjSI4Gs2lJgaFeNNTtRI2KHzK1QSthf+darOjQBi1UIvVP/9AMWKBTEjAJZZ2iD9fMk7xnJc9rCYBJ+qbjstog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pbFwkqqVv0uqCxKjxsa4wg4lsKdOvR5SNZm3cVy3/oc=;
 b=NJ5gqgh2WCak0HGsu3JbRkiqDIHzVZp6pDDEYTM1tJr+DV873zquyUVddqi27XXX/3nnh9KgX6hks3/3inaE+OXoVqoAZ1ZFJXmYfdT+KEyjYpQ61T3uYt2/P7w1I0x3/oaLLgzzPWspEBwaQjEcpHFE5E2RlMKgwsQmTL72mo+D4jMuJCJ6T7JnXRCYHqLc167k3jiJCN3QJcQaAOg76tgWCskioTL+FMOeLLjevbU/nYJ6Q6WfbcP9AjRXPDlGjnaIo97BP3ZhvmHwwxWDrFkbxwfGs8Cw0/TLGG5ceIGa+BEvw+nBGBNZPoyGeuxc75era7sNR2N23wH4r+z1mw==
Received: from BLAPR05CA0047.namprd05.prod.outlook.com (2603:10b6:208:335::28)
 by MN2PR12MB4061.namprd12.prod.outlook.com (2603:10b6:208:19a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Mon, 3 Aug
 2026 13:26:10 +0000
Received: from BL02EPF0001A104.namprd05.prod.outlook.com
 (2603:10b6:208:335:cafe::d) by BLAPR05CA0047.outlook.office365.com
 (2603:10b6:208:335::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.15 via Frontend Transport; Mon, 3
 Aug 2026 13:26:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF0001A104.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Mon, 3 Aug 2026 13:26:08 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 3 Aug
 2026 06:25:53 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 3 Aug 2026 06:25:53 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 3 Aug 2026 06:25:50 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Nimrod Oren
	<noren@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net-next V2 1/3] net/mlx5: initialize doorbell dma pools
Date: Mon, 3 Aug 2026 16:25:18 +0300
Message-ID: <20260803132520.2891860-2-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A104:EE_|MN2PR12MB4061:EE_
X-MS-Office365-Filtering-Correlation-Id: 2146bd5b-4a53-4255-7372-08def162c791
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|36860700016|1800799024|82310400026|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	hbv1KbmASYjD9DCBmXwXgim5k9k/DGiPkWI38IhBNSTvQTofSQSVhDz+KsxqryApY3C3xSDzLr4YAMNa9XMhbcyr+OTvtRl3NV7tRasHIA+A/cnbx88d/6c+bu1ve+fE0xlWkqHmncpzDU0dIKGjsFTcWbbNjmamu8OEvU2mhK8D7sL7OU37jbzGQYsB2DQaaq3PKe0iKWUep34+EmblT61w57TPknOyf4ehvFuNFNyhJG/cXzesWpSLoEuLxvn/lCimcz4m0YiGCotpei18oK1PZP8BidIKkjnk+xDp1vTH4QbhobDbCxKao1lvzimAnYV/iUyzGb7Ym/RLl90aYUuos6uwVmcxo7l8GAiPSGBdLilTajQInoc70kd5bGP227x/azEZFhROSsCPIExjg7y9BP4iSPHap/x0Kmq47UXNYclubkQEUFFV1pqeUSriY/TnXgEwXqKJMiyM49wlCUlkx17Cqwb4YHm0/lHjPepZt/sPtS/vKRF1J/+PCrz/fGk1cCg4gPgiqXiVq6+TbgtpG+sC4MC6Our12kQBnptO4IlBnfNisi4zIXRZKg6LEGOgwiwTKB9lML7oEsIwRyVzQINODusKT/mrtDgQopZbis0jl4/8MCBzYHCpO9XxruX5L1mhpd/vlCC1EQ1OTcc9l0SfToynXinQ7TSkNL2APzWrF+W2L4RL9+eTdF4N7Sxabjh15ZZ2mF33necNVA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(36860700016)(1800799024)(82310400026)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zp6AFpfF2nb5MOs/tkKoF3xx6UFMoXXzrayVlx/HlJAuACorJLJ5YZCFc8HTgybx2pHfyLWv8HTASLkirQ7fdFVRqP/loPkBbZ1jdvEja6e+1vVe/50Mptsi3I1YyrsCGyIy/7kOUa+WKeoU7bxH3w5esD/mgh3gE/Xr5HZOJbCtno7wB3tXXabmpKx1FMcp9dVBSn6Nlp6e6ZBowJ9akA4k1YyanXAgST/hs1cJBd45mU6q771Q/pPotgltSNOTDBokqOljC6/4MYR3IVjwH+Uf73aAPqIi/z4VBG2bfVEXFn6RAJ6pCLZVc4qlvVgCHlAcA+np9TRj76G0XZ5Gu1sxTz6cl3oS+IF/HByQjCYvDkp6WDb5mtXm3txsFMc/vEhmKbWKaSK2se/KgIRP6OA9z4AqDtit7KZPZC6x8T5e0TY6ndCPLt8Q+vgKzM6q
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 13:26:08.9185
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2146bd5b-4a53-4255-7372-08def162c791
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A104.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4061

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

