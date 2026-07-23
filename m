Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011037.outbound.protection.outlook.com [52.101.62.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566AB3E8326;
	Thu, 23 Jul 2026 07:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784791413; cv=fail; b=Slvk0L1X1phqccAfqDoJBJvSXhNk7jorKYDbOARcbMP9ymtXErpD2Zhkdz7xsovTjswnbpiSpcgSXxllq6cOYJnRVD7qdKcRVkvjmovGZepEJITDt7EASbyyLDIiT6JW0te3if7ijPdQwfDpzlq5frno+HvNww48QHKBTWsqqZ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784791413; c=relaxed/simple;
	bh=IwFfheX/GPd4PE+lr4+iRyyEqpGDfloGCvvnJYHukD4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jVEJ1Mdoc1Off50AkvhuhOPnTj+sh2OsywmA5+xcZYScR8Vsnvg8x8BJcJQUKyt+p+cTN5sgvCH2jfmvDEvsJ6X4U+hXvESlswYDOkI1q3rJFzaqJgCjBUWARFvLp8pJHX461WNsT/6TXM1pwuWTHZHcOJd/nm+PmlUkIIwmXMg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SHwKqvj+; arc=fail smtp.client-ip=52.101.62.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SHwKqvj+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EeCHHcMZtlEZRQ0V8+dmoZMezB7f3CRV19hZkVhqQeV1aCbTmAaafXovPITaaTGyZBE97rzDPvza4YOQBuVOxkH0HzXEyB7BgqHpApDpQTYCLoxfd7hIRi5Fy/CBF07RkheN/Y7Oo68NBur1x8Vl9M5u0tCROwTYxT+hEjm8+twK1hb5xhDSqbUHwTr6uYuyAF8U3w4LNTL5fZBB9iKl/ny7SQFAMvfP/x2PMqFrDYt61v9LVK9SiOGDCILDKz7CNzx12NbPMezmx8f9Oht4E6nsncPH9zWIy57TMC/Mi5Y8Grbznu8q589DLUGMAbzV+3JAy+KSmvFq3XEJG8x/kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GA2EIwc90au0Y+OmQ2WLN0q1d3KI3+BMm+axC6TVZEM=;
 b=rHGKxhAFDFJLLeGCy/mMg5P3npV7tiIVqorCSnt8Y8E9n7VhmUENliGnJlQWggNWOdKHNPrnPUiAhuOLB7TjgG0J4TORRVm1oZZEpXO25bzu9MToDPDz18G4NhrJbIVMtVYj4zi62y9YFd4q2dL6jARc6bWERVTBp3W8UdpckzQ6d24e2cCOjYmHCJUlCUtv/d7+Pp+722t+0y7xr0Z/ysV2t5ZzaYBJJqp4qP04gVJ6b4agmWOR8yfyrgwvn/u/KjR8WxrZn2dsprTexKWn47ht0gunSgGMvji79CCvCpbY/MRJTfI+mLjP5Eq8IrGLfOikw+o/p8kPUcLvCuCJDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GA2EIwc90au0Y+OmQ2WLN0q1d3KI3+BMm+axC6TVZEM=;
 b=SHwKqvj+RBOcyGLc08KzHtnfIdKVQF6N4p3pS6uS9NfjBoyX0P0+ksvcY2cBrYHBxlmk7JhQG5mwDxG3eOYj8SOwVmN0CQ4ahW+Gmn896FA1hDsLfZBKTT8pDHgTcml3csmdXqds02zDnoBlz0ljZ/ZznFR5rdOL8AogNML8u4F1tqTjcvFc3sKsOD3FDNN4nL4xLT/Q0DLL2mzp8oQvmgXmYlB0gWSgvIB6GRF3Ki4TcoSt3Up/nBUQdVTIqkME/C80ia12IXvlbFGcE+wAlFcFXu+wkRwVyaUhStr2VNLIpxkAzu9e6vGQNNm1MkYDbZHZWFhb0reD5SXcKfCZEA==
Received: from PH7P221CA0045.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:33c::17)
 by SA0PR12MB7002.namprd12.prod.outlook.com (2603:10b6:806:2c0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 07:23:23 +0000
Received: from CY4PEPF0000EE3B.namprd03.prod.outlook.com
 (2603:10b6:510:33c:cafe::8e) by PH7P221CA0045.outlook.office365.com
 (2603:10b6:510:33c::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.10 via Frontend Transport; Thu,
 23 Jul 2026 07:23:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000EE3B.mail.protection.outlook.com (10.167.242.14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Thu, 23 Jul 2026 07:23:22 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 23 Jul
 2026 00:23:07 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 23 Jul
 2026 00:23:06 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 23
 Jul 2026 00:23:03 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Nimrod Oren
	<noren@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net-next 3/3] net/mlx5: add debugfs stats for doorbell dma pools
Date: Thu, 23 Jul 2026 10:22:22 +0300
Message-ID: <20260723072222.1863558-4-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3B:EE_|SA0PR12MB7002:EE_
X-MS-Office365-Filtering-Correlation-Id: b4e9bedf-5e76-4e7f-b3b7-08dee88b4707
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|82310400026|1800799024|56012099006|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	t9YnTQCtgqb/HN85fnmNYQ2RjzP7mxqmpm1jiURhR/Cli53/tcNUVjdzYWKz3DVfl5/WC9R308a3REL5QWWm9Nc/iX1yWpHuSGB0IgWEoiwzhYFId+Btw8E//CQWpBiJLgrdLcmuM4kaWaMaeUbMWCQX25nlA5uhIRM4UlsSC9ZxHUHzmWyk9C3YaE4LnMuSRRBtzmEL3zNC/He3wy4HF2T5wXGhEWyXhwDL4hn2AgzQXfYJLw6OQeXEydYTrHPx1J/dbCbGXHuq09/Ma146SYTZQd3vujTRwGuAnOGDKPBInTY0m/eUUX6PNjyzSIB2IW2XOQC2NfVBHGRxy6Gqj2yVicS9p6hwHBvA4bpLoCzX9qezp0cY11ZsPL08Rf2ffe3j5Hxq/kHluL1UAfg1eHPsrUbRBTOCZhBl/nkbMOwFPlOyhhKCuaUMcnwvgsWqflTwCOXGbvlb9JqaQ+CHN7f1IXRKWxnhxymhnoGlDK9nVBsBGahXI1PNca9oFHUuExuTsiAZl0WvP6nv8Ld5AIjq9COwwelNs60qytpV1mT3kNTQJefhrLe+/Zmc87niWU3+XYgZ4OkrUFtsK+SONlOH5uNTASLlvRO7ptrqaTSA4v20Ny08AbRfVnD7/YLACVDVg8wLSy89bX4sXzxJ8z3ChWD7YFXDfjAi78QVMmlWEKDFs5UUfYsJQ7ARYEdBQu5Pxk94eZ2ffzF1mxEgnw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(82310400026)(1800799024)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	IgxfdyKj+jVyUkMHdgCOrauXvPJz5xWrU2DQFVMZUDF6JyoJSd34bqJZlkLrDujy2As9X52Pltd1pfZrmPYe1SE8V0y4ydXSoJMD8WRAY5iH9lRDTFRbaIT8NSCtUQvlcy3UtkwQdpAk3by+FpE5vccYpdNDPSFHc6wp0jzL+eo8oMWc5kKAAauIZaycAqDX9xDyXx5DdUbbIOjktFTY6sePw6Y/GtubOGY5s47l++Df9c1O75SHmja+c4yo22q/b5p5Ir3bWefoUsTq4jPVN0vFIBz1/0RXc+Rixxl6isEakSzXlYJbC3kM5anvtkeO8jxpwSdwTZkMhkR1IJxWf9No93cNi12guYeYH+/UhxRCjmykswygj5WoNZoiVtiXdvoypLJhHLsyznpKqtJElr3CgECy7vBb8sRxlXNbEu46Jq3tQK4LwqRvSAt0sZo8
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 07:23:22.1493
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b4e9bedf-5e76-4e7f-b3b7-08dee88b4707
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7002

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
 .../net/ethernet/mellanox/mlx5/core/alloc.c   | 30 +++++++++++++++++++
 include/linux/mlx5/driver.h                   |  1 +
 2 files changed, 31 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
index 3975c726d35c..60ff413999f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
@@ -437,11 +437,37 @@ void mlx5_frag_buf_free(struct mlx5_core_dev *dev, struct mlx5_frag_buf *buf)
 }
 EXPORT_SYMBOL_GPL(mlx5_frag_buf_free);
 
+static int mlx5_db_dma_pools_debugfs_show(struct seq_file *file, void *priv)
+{
+	struct mlx5_core_dev *dev = file->private;
+	int node;
+
+	mlx5_dma_pools_debugfs_print_header(file);
+
+	if (!dev->priv.db_node_pools)
+		return 0;
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
@@ -471,6 +497,10 @@ int mlx5_db_pools_init(struct mlx5_core_dev *dev)
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

