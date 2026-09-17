Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012003.outbound.protection.outlook.com [40.107.200.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34ADA49A3D6;
	Thu, 17 Sep 2026 11:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789643740; cv=fail; b=s8Qj9PFC11x8vU51OdTPN5vJNknoO72pHDRudAI60LkyJNybasm5nqkI3pEYy4ITH4IJ4wustJk7nI8Ed0W4G5jbihnhSWt5MwO+A1ZStpYcujNeUT60s4SQkuy2sqvFbpA3xleMaCyAD5/n9Bo9LkGskVHkzD8pJS0pRhi80Lc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789643740; c=relaxed/simple;
	bh=ZtSs3W2HEoxvoCQOzB3jIqsjNuuA1aI96GvPn0ZJ4+I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UF5/8NvH1n9+w/bREErwAEvo8IqlA1eZHYkkyfLAX264BliKeyOZqHcNi4ZRupwKWLXQRYavj7AsPuvonsl/PihRtx/Pq5MuWPo9KkEV5hgosXTmsA2YzKu4RdHZ7N6xJYim6xvwFLzAPAvz40CeDue0QNQ9O16MCL+gpI55SNw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=V7d9L2b+; arc=fail smtp.client-ip=40.107.200.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="V7d9L2b+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IS4SS6IhNL8zDSm3xSQjQ+YzltBN6gtb57qkop6ANzOUEx4wsA7NPsNy9ZNfNx34k0UknZJ858BY8U8echgL86Ny/cVZS6hzBj1h6fRfDqbonI8ooQ8X8VIAC43/2MKcPS2AJ38aHbKzg8coy911xcZMhH/ymil7FNnj+KkFsWYnkVUc8uAZGqChQ/lcvo2QQYdvciq/9HXM3v4SX3i662qjWf4JtQuyPzvaPbEK0QvrGKU+7uGGT7kftarREK7lcVvrfyqEgpGRd656zIZuHk2c7yaQBuX7f3q7QSBMZpu0yP9y1usWN6jRUZptkggnmi1SdWs1yPMWSmzWaw3ysw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yav1JipEFMWWfS1xStmQe2+DI+tcaYrDaCtIGbdIsJg=;
 b=x8Ht97kslAURpNlgMKZjDbl8Z4qgfy3j8LyqrpWkq+/YP981T5Bh05MFEG5A+dirTSuKltyEtdnMpeq6uM9CpW9d0PX8bNlKRDqZsrmfLZEnKGwZ4CjiCR/etLPaOThNVbMwi7EDFOMj+FXt+Prpi0/C+iPz1ANC61nhgrcWFJILFteQeZRaCSWQ2QPvuQ+l9TWdDMplB/ff+esT19pzU+NU2vWm9HHkHt9FwyfvZCDvJcmkord99bQfGqujsfAkbK6dWX6TWx3TUOro51eZhkTMKJolNPayLgI6V3NvQ5q5zJ8+qvgadQatw1D8OT8UVSjwkzAUAEg0M++TpNUQxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yav1JipEFMWWfS1xStmQe2+DI+tcaYrDaCtIGbdIsJg=;
 b=V7d9L2b+oU4a5BEHVkLqHVtGh+O5zJIxC+xjQ/5jWD9mlVkm11/drVN2Hg8jLXmiKGxakuyWLnhGAUN0bcuA9TaQYePBjZTMj/0dvrjptngaYJdBNzxp+rym65Jri3oandsQNk214FJhggvJat3ZWBp3QTb8QnEVLRp0Vf6vBCFX6H3dGAt7gPvbISEx9536rNx8EJMflAjBa239TMjcAD1O3XRnaoDZj0zRqqeFQZN3O3ZIX/fUMjZzwdEEd3tk309Mhomv3aUbMmpfn66WJ3s91MPDMMwBFdi8RlZMeMnWp40q3y00ViTrCtWIIkUgNvipSvA45sL6zH7BoS6DUw==
Received: from CH2PR02CA0012.namprd02.prod.outlook.com (2603:10b6:610:4e::22)
 by IA0PR12MB8646.namprd12.prod.outlook.com (2603:10b6:208:489::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 17 Sep
 2026 11:15:25 +0000
Received: from CH3PEPF0000000D.namprd04.prod.outlook.com
 (2603:10b6:610:4e:cafe::48) by CH2PR02CA0012.outlook.office365.com
 (2603:10b6:610:4e::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Thu, 17
 Sep 2026 11:15:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CH3PEPF0000000D.mail.protection.outlook.com (10.167.244.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Thu, 17 Sep 2026 11:15:25 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 04:15:14 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 17 Sep 2026 04:15:13 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Thu, 17 Sep 2026 04:15:10 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, <linux-rdma@vger.kernel.org>, "Mark
 Bloch" <mbloch@nvidia.com>, <netdev@vger.kernel.org>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
CC: Andrew Lunn <andrew+netdev@lunn.ch>, Cosmin Ratiu <cratiu@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>, Dragos Tatulea
	<dtatulea@nvidia.com>, Eric Dumazet <edumazet@google.com>, Gal Pressman
	<gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>, Jason Gunthorpe
	<jgg@ziepe.ca>, Leon Romanovsky <leonro@nvidia.com>, open list
	<linux-kernel@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH mlx5-next 03/10] RDMA/mlx5: Make the data direct VUID query self-contained
Date: Thu, 17 Sep 2026 14:14:15 +0300
Message-ID: <20260917111422.4054862-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260917111422.4054862-1-tariqt@nvidia.com>
References: <20260917111422.4054862-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000D:EE_|IA0PR12MB8646:EE_
X-MS-Office365-Filtering-Correlation-Id: a7675263-f9d5-4e50-2b2b-08df14acf91d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|36860700016|82310400026|1800799024|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	sAeKMAeUsSwna0PiYctbBaPf+vOuTcYR1jFEIJQdSAIYg+WXmiUUuD1fzkX9wAgzL9LuOYnyCIUEjHWy+aH7LhizjK3Fxm16iGjEAdafboabHy+/uv+3lZ3md21ppMRvjID7bLhHRpKsxgWk07CwiRVmop/mP26L4/EtNJxLjd2bKP4jp9ibCT+NXQ8EwGBrbq6XV/TbQ7XjYIqmEwLpw615PK7o4v1bph43VxIjmhoTxavmeF/2Ugfin8w3yh3mHbydcUuP3QUWpKqBG+arlYaGJkOt1TEda/RfDC6/vyn3+D2PJuKgN+z/Jey1Y+oL0SNOjz/m96lFZHP0IeaSXAogrDI92aJNVsMM/cxzzxzhFerK52fed48hKsPbIQgWh2hGpvxxXSPqGpxzbQUa4aHsOy1qa33mBO23gmwsAFPt8vyENHJkevzT9y+uO325E4AjrCKo9pZH0HL7zlz3U5O+ImGwF5YCkpia6d/tGf3rG8wN8VbUlW6LH9Z1arr/bzY6gtotyzs3tUs0Nmu3iVDYAItswE1MrETBM8NLS/eiyJTYF7eRKLo6m3Gjc/vduI1sELMQSGig6mPrPLFXVoxMdZMMdlLmiLmguZGL+tFB5ex4b//mC2v0hGYXDXvr/8cJIYXhULzN/QH2Rzs4PF7XwXhtQN78stmVdKC90uES3vpG/7UMW0j3gfUIT6Zbt3HMZgP1Pn9rf8HtpTVA0Q==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(36860700016)(82310400026)(1800799024)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GRcLnKdC+Y1fjynkVgKoUr6Nn2aRmesv9RkPkPwjSC1Q9E2oX9PduvkP+Ch6lx2Aewd/48qmchPMesSjhxqAd4EbonulnGBn3m5seEPcmluvPcaQV45vgpR1nh4HX/zcIt6ltqbaL0SHrHk537bdVerjlXe0c3fQSzw2OFtq1PDWZgsai9UOAtIK6hSiPVaUa2i2Qr+3NKJ1fIl375B8uExp0jI6WreFxbX2sRYPE5hhY1CH4QEIqLgMAsghbrvdl3v3X8EiOviz1Jh1l3R7uuxd9dP/pmc/2bz/VVxCQgVCl4HmwRSYtFIgxgO7CaWed6kpCaG1dBRvInPZY6Z6Ew5gLCeOCfyp4lcWG2aUWFDz3RfRMbiwdav2lF9U9rXarCMCEo9XIpHMco0kOLcfvRN8IIBvQBDVSK5Gg1ggWzStAB6qV4AvFPKiwVD9PSXU
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 11:15:25.4649
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7675263-f9d5-4e50-2b2b-08df14acf91d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8646

From: Dragos Tatulea <dtatulea@nvidia.com>

mlx5_cmd_query_vuid() in cmd.c is generic over the data_direct flag but
its only caller is the data direct init path, which always passes
data_direct=true.

Move it into data_direct.c as mlx5_data_direct_query_vuid(), dropping
the always-true parameter and hardcoding data_direct=1. This groups the
query with the rest of the data direct code so that it travels together
when the data direct matching code is relocated to mlx5_core, and lets
it become static there once the query is folded into the core bind path.

This function will become private in a subsequent patch.

No functional change.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/infiniband/hw/mlx5/cmd.c         | 21 ---------------------
 drivers/infiniband/hw/mlx5/cmd.h         |  2 --
 drivers/infiniband/hw/mlx5/data_direct.c | 20 ++++++++++++++++++++
 drivers/infiniband/hw/mlx5/data_direct.h |  3 +++
 drivers/infiniband/hw/mlx5/main.c        |  3 ++-
 include/linux/mlx5/data_direct.h         | 13 +++++++++++++
 6 files changed, 38 insertions(+), 24 deletions(-)
 create mode 100644 include/linux/mlx5/data_direct.h

diff --git a/drivers/infiniband/hw/mlx5/cmd.c b/drivers/infiniband/hw/mlx5/cmd.c
index 7c08e3008927..895b62cc528d 100644
--- a/drivers/infiniband/hw/mlx5/cmd.c
+++ b/drivers/infiniband/hw/mlx5/cmd.c
@@ -245,24 +245,3 @@ int mlx5_cmd_uar_dealloc(struct mlx5_core_dev *dev, u32 uarn, u16 uid)
 	MLX5_SET(dealloc_uar_in, in, uid, uid);
 	return mlx5_cmd_exec_in(dev, dealloc_uar, in);
 }
-
-int mlx5_cmd_query_vuid(struct mlx5_core_dev *dev, bool data_direct,
-			char *out_vuid)
-{
-	u8 out[MLX5_ST_SZ_BYTES(query_vuid_out) +
-		MLX5_ST_SZ_BYTES(array1024_auto)] = {};
-	u8 in[MLX5_ST_SZ_BYTES(query_vuid_in)] = {};
-	char *vuid;
-	int err;
-
-	MLX5_SET(query_vuid_in, in, opcode, MLX5_CMD_OPCODE_QUERY_VUID);
-	MLX5_SET(query_vuid_in, in, vhca_id, MLX5_CAP_GEN(dev, vhca_id));
-	MLX5_SET(query_vuid_in, in, data_direct, data_direct);
-	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
-	if (err)
-		return err;
-
-	vuid = MLX5_ADDR_OF(query_vuid_out, out, vuid);
-	memcpy(out_vuid, vuid, MLX5_ST_SZ_BYTES(array1024_auto));
-	return 0;
-}
diff --git a/drivers/infiniband/hw/mlx5/cmd.h b/drivers/infiniband/hw/mlx5/cmd.h
index e6c88b6ebd0d..e5cd31270443 100644
--- a/drivers/infiniband/hw/mlx5/cmd.h
+++ b/drivers/infiniband/hw/mlx5/cmd.h
@@ -58,6 +58,4 @@ int mlx5_cmd_mad_ifc(struct mlx5_ib_dev *dev, const void *inb, void *outb,
 		     u16 opmod, u8 port);
 int mlx5_cmd_uar_alloc(struct mlx5_core_dev *dev, u32 *uarn, u16 uid);
 int mlx5_cmd_uar_dealloc(struct mlx5_core_dev *dev, u32 uarn, u16 uid);
-int mlx5_cmd_query_vuid(struct mlx5_core_dev *dev, bool data_direct,
-			char *out_vuid);
 #endif /* MLX5_IB_CMD_H */
diff --git a/drivers/infiniband/hw/mlx5/data_direct.c b/drivers/infiniband/hw/mlx5/data_direct.c
index 04affdbdcb12..8d006b611c63 100644
--- a/drivers/infiniband/hw/mlx5/data_direct.c
+++ b/drivers/infiniband/hw/mlx5/data_direct.c
@@ -24,6 +24,26 @@ struct mlx5_data_direct_registration {
 	struct blocking_notifier_head users;
 };
 
+int mlx5_data_direct_query_vuid(struct mlx5_core_dev *dev, char *out_vuid)
+{
+	u8 out[MLX5_ST_SZ_BYTES(query_vuid_out) +
+	       MLX5_ST_SZ_BYTES(array1024_auto)] = {};
+	u8 in[MLX5_ST_SZ_BYTES(query_vuid_in)] = {};
+	char *vuid;
+	int err;
+
+	MLX5_SET(query_vuid_in, in, opcode, MLX5_CMD_OPCODE_QUERY_VUID);
+	MLX5_SET(query_vuid_in, in, vhca_id, MLX5_CAP_GEN(dev, vhca_id));
+	MLX5_SET(query_vuid_in, in, data_direct, 1);
+	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	if (err)
+		return err;
+
+	vuid = MLX5_ADDR_OF(query_vuid_out, out, vuid);
+	memcpy(out_vuid, vuid, MLX5_ST_SZ_BYTES(array1024_auto));
+	return 0;
+}
+
 static const struct pci_device_id mlx5_data_direct_pci_table[] = {
 	{ PCI_VDEVICE(MELLANOX, 0x2100) }, /* ConnectX-8 Data Direct */
 	{ 0, }
diff --git a/drivers/infiniband/hw/mlx5/data_direct.h b/drivers/infiniband/hw/mlx5/data_direct.h
index a9bb471949e2..fa3a145c06c6 100644
--- a/drivers/infiniband/hw/mlx5/data_direct.h
+++ b/drivers/infiniband/hw/mlx5/data_direct.h
@@ -7,7 +7,9 @@
 #define _MLX5_IB_DATA_DIRECT_H
 
 #include <linux/notifier.h>
+#include <linux/mlx5/data_direct.h>
 
+struct mlx5_core_dev;
 struct mlx5_ib_dev;
 
 enum mlx5_data_direct_event {
@@ -21,6 +23,7 @@ struct mlx5_data_direct_dev {
 	struct list_head list;
 };
 
+int mlx5_data_direct_query_vuid(struct mlx5_core_dev *dev, char *out_vuid);
 int mlx5_data_direct_ib_reg(struct mlx5_ib_dev *ibdev, char *vuid,
 			    struct notifier_block *nb);
 void mlx5_data_direct_ib_unreg(struct mlx5_ib_dev *ibdev,
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 0c57cb39ae7e..8d6914de1442 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -25,6 +25,7 @@
 #include <linux/mlx5/vport.h>
 #include <linux/mlx5/fs.h>
 #include <linux/mlx5/eswitch.h>
+#include <linux/mlx5/data_direct.h>
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/lag.h>
 #include <linux/list.h>
@@ -4039,7 +4040,7 @@ static int mlx5_ib_data_direct_init(struct mlx5_ib_dev *dev)
 	if (!mlx5_data_direct_supported(dev->mdev))
 		return 0;
 
-	ret = mlx5_cmd_query_vuid(dev->mdev, true, vuid);
+	ret = mlx5_data_direct_query_vuid(dev->mdev, vuid);
 	if (ret)
 		return ret;
 
diff --git a/include/linux/mlx5/data_direct.h b/include/linux/mlx5/data_direct.h
new file mode 100644
index 000000000000..4556e58c6d03
--- /dev/null
+++ b/include/linux/mlx5/data_direct.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/*
+ * Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#ifndef _MLX5_DATA_DIRECT_H
+#define _MLX5_DATA_DIRECT_H
+
+struct mlx5_core_dev;
+
+int mlx5_data_direct_query_vuid(struct mlx5_core_dev *dev, char *out_vuid);
+
+#endif
-- 
2.44.0

