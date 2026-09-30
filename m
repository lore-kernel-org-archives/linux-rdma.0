Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012044.outbound.protection.outlook.com [52.101.53.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65EC4C9DE1;
	Wed, 30 Sep 2026 11:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790768638; cv=fail; b=UK2/xu94TsgfRDk4Tjej6LHeZfYW/TjV/yeHYoT60lqtqAD4zDumkE5ZNhyC/C7otkLF7p89hzxnWa3PLiU6bFdBX9U0B6GONOhWut4tO0k5tVqwxrhp4S6Fqwd+HLr2XTN816DTQ8aEhRV8e94HLKEDsLucsLAQcwQdc+e49qo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790768638; c=relaxed/simple;
	bh=UynRZJFWUm9rjppcchAduLjIXAEXqlWDoBIl6JRDr/A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gNxGR8Us+Ffpum5jnLe7ycmCQtt9Bm1k3EKfn/Df5RL35ftWI2bbWXytLMwXsfRM6ZZYz0l1UEg7YHaugsck6FNexcFRQvAXCQKKMG820APGlRXWQIMNYj7IkqmEaCojbbF+FOCwZssIi13lU/H4XUJHnA8Vs/bP8m3IdKSb9es=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=boCIrIbA; arc=fail smtp.client-ip=52.101.53.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="boCIrIbA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DXZNRMHlQsAV3K8AqzSbAn7ackrj+bYUGZxnECC2DRE8sZfjqe460eyKdryQTxsAutbxwZwb+sPJsE7H5Vfy4IJUgPtoC3+MP9qSxiMrdxr9dchDlVBKWNOPU7crk5L4NFdLSWCekf7qzWIGVl/QVNWQsGg5xWYrK3Da/+Eh47biyKqK2OA/G5/uVX/XbkLIsnO7EeFzy4aWcIPpTWsfXcipBL8YC2HevcxWK072TnUnK2P5rAxVMa6VIVNAItUMrC8OJTrCi+vYCgacHlwzjDy3AN9Z4brwyyOFJw+1aSW3TvoxIhHEsBMQCkzO9RsMEBHQXpx6D1l7g9L6QzqzQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Y9PGfmu1eK0XBWYgAqOdrOUgR/iEcZBXznn90aKfJk=;
 b=KLunf0kffJ22/AobtydPXD7i7s6wXZh8fRjbUOcvv+UGuiDhQUP4rKoy7l072OPrLW1Dz6nF17MlyyM/sCZ8x/YOIN0vXc+Zq4nKJoXbFmAl4dSiKcWtxMPbTxeF+QVsIhIZJ5PWZDpzzXFDNSUwAPHUnlwm4bRYcUfClxjXU9THkj8snm8YWZh+vugHqKRGAprtAyxgqBgRjPDn2cnTKLs9XebtrIhFc8Q86qVbIU8OWw3wQkZJsi1P5Sul587hFqMrPNqImu3QQz9BZeec45sTJ0Y+0DAoXE+Telcsmn0Aoq5iA9O64LNjFs3hXQ4mh0HQphs58tuQs2OU5vf7gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Y9PGfmu1eK0XBWYgAqOdrOUgR/iEcZBXznn90aKfJk=;
 b=boCIrIbAZ2V3gmA/NZA2V6x1vD3WnlBPmGm72r5o8OgpFo69rxA+Nd8vgFfaYuJrwHqXx8I7XjtvjJ3rArQ8bf3S52FauczJYZ2cCQ/iGM5xZaTzwvZ/9QcWc2scUQqh8blOTaNpcNQSKlzj2TWLtw+DtJSyUyk8ZYtfgLT9B9Sf+ivVRunA9vfAP/NV1GRGcLv4Ugaoo6Jh7QRC5oma5K5SUBXxjEOMiZRsOF3EFvgyK2gSoXJpFvPWWkIHxBh76h37aPipVI0gYhh/hfqnHhfxHc7H5C96NrCnrvqHRwEzQQh2+fK4l0FQ7YOqFRuso+WMhWPIr5mUKnp3HMRYNg==
Received: from CH5P222CA0021.NAMP222.PROD.OUTLOOK.COM (2603:10b6:610:1ee::10)
 by MN6PR12MB8491.namprd12.prod.outlook.com (2603:10b6:208:46f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.25; Wed, 30 Sep
 2026 11:43:48 +0000
Received: from CH1PEPF0000AD80.namprd04.prod.outlook.com
 (2603:10b6:610:1ee:cafe::10) by CH5P222CA0021.outlook.office365.com
 (2603:10b6:610:1ee::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Wed,
 30 Sep 2026 11:43:47 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH1PEPF0000AD80.mail.protection.outlook.com (10.167.244.90) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 11:43:47 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 04:43:34 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 04:43:34 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 30
 Sep 2026 04:43:30 -0700
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
Subject: [PATCH mlx5-next V2 02/10] RDMA/mlx5: Add mlx5_data_direct_supported() helper
Date: Wed, 30 Sep 2026 14:42:19 +0300
Message-ID: <20260930114227.139274-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260930114227.139274-1-tariqt@nvidia.com>
References: <20260930114227.139274-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD80:EE_|MN6PR12MB8491:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e899938-e93e-4910-3c1e-08df1ee81719
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|82310400026|1800799024|376014|36860700016|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	V9Z+v8jOm9Btu4JoLZ7r2/N4ZoL+dvKO2JkxV5DNo6Xa2WHPgIBEr7zEUSLkaifs0upParXwe3v8cGiugrz0nQYwOOVgSxxG2vs0+a0AWnExm1o0ZuC3mk4ib7gAKcTQ1apykgDm8lBXkgnjpftyEc6sdJ13uMYdRC4KqhvPLT2sQtQQve6DBN4Zf3f4XzLdcJZfooTssvQLO+/sqQKAaLnHBDu+flFS1M//V8REtcXHGobM73qkyE+hjYFec/HZohfxEKuCjVyfutCBnhkhHbwSSjvO1uoK0H8FtMZ5QuW/Bb55J+ls05gDKCOssWqBfGUWnVVV5BIEKrtVrdKcwtqFt9jEeHvY80MzdEWXyfUK6SGH3tAv4axOm2jM/3dhdkFTk55AmyEGM3qL5XiLIEj5btfOHgzwNgntlek1Gjfvh0oeIIGXhUD3IGbrbFwaHZfvSxHQ159LfE57TccVAoo/ZPUWP/4drLzvF308kzS+OASM7EOlb8E7X3sXADI2ukCugy0vhj5WDrhMk16LWg9kp/wUkZKnS3mS3QiXcK0SNzCjrXcjEiMlIjdSmqCBr5v/CpcUy7gHYqNRR4lANsgobd36rQkEMO6gjp9rVtbFv4eByfYOqUxvOo3R17LMNYu96rv3seJjs8GF26ZMZysO/NoznF6wNCQy1hyFsXbp0bQEVkl0E1K2MxUd37El/LsbgCMGri6PenJsvo2FAg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(82310400026)(1800799024)(376014)(36860700016)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	y9MU7TTatUu85ooHd7huTimzJeujl6HPHQbnHgP97v627o7/lV6OBUt559MDZOKw0d91vZX8bUVMCH9kOrOeVld5yflPUl+6ORYBVfpZB0kzD6H+XssSwy/H44eQlNN3mMo89ZV7v7Vxo7+dfhT5AsEJ7ZUAczajYigFWbHcrvvQ6IoHBDaJz8X5GUGLIUnbigfvNLFVLA9z4Y/dX5vVAsM6K/AZmjGce7LoDCEQfcA/Nqe4S9UI7B0lbKBnNqGcp/gvLAhBRFqwU89rtTevWNqlB1o/eVona/ujeJmLnnJ/OKR0hDVwrSl+5WDzMFcCXccbUAEUwAeW1e2ILgYI2Ms4xWW3B+J/eU1t6Jl/N4uTQPKdfkALiqrL0cEvHEJ+hBsqL1j3KdNn5iXmc1UMDt2NpC4BY7sUqwk+xUr6o6Z8mXwpfxDxYoDAmP7speTP
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 11:43:47.7174
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e899938-e93e-4910-3c1e-08df1ee81719
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD80.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8491

From: Dragos Tatulea <dtatulea@nvidia.com>

The data direct capability FW checks are duplicated inline in
mlx5_ib_data_direct_init() and mlx5_ib_data_direct_cleanup().

Wrap it in a mlx5_data_direct_supported() helper and use it in both
places, in preparation for moving the data direct matching code to
mlx5_core. For the same reason put it in driver.h instead of
data_direct.h.

No functional change.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c | 6 ++----
 include/linux/mlx5/driver.h       | 6 ++++++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 547275dfa40e..0c57cb39ae7e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4036,8 +4036,7 @@ static int mlx5_ib_data_direct_init(struct mlx5_ib_dev *dev)
 	char vuid[MLX5_ST_SZ_BYTES(array1024_auto) + 1] = {};
 	int ret;
 
-	if (!MLX5_CAP_GEN(dev->mdev, data_direct) ||
-	    !MLX5_CAP_GEN_2(dev->mdev, query_vuid))
+	if (!mlx5_data_direct_supported(dev->mdev))
 		return 0;
 
 	ret = mlx5_cmd_query_vuid(dev->mdev, true, vuid);
@@ -4059,8 +4058,7 @@ static int mlx5_ib_data_direct_init(struct mlx5_ib_dev *dev)
 
 static void mlx5_ib_data_direct_cleanup(struct mlx5_ib_dev *dev)
 {
-	if (!MLX5_CAP_GEN(dev->mdev, data_direct) ||
-	    !MLX5_CAP_GEN_2(dev->mdev, query_vuid))
+	if (!mlx5_data_direct_supported(dev->mdev))
 		return;
 
 	mlx5_data_direct_ib_unreg(dev, &dev->data_direct_nb);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index b1871c0821d0..ee29f95ead18 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1395,4 +1395,10 @@ static inline struct net *mlx5_core_net(struct mlx5_core_dev *dev)
 
 #define MLX5_SW_IMAGE_GUID_MAX_BYTES 9
 
+static inline bool mlx5_data_direct_supported(struct mlx5_core_dev *mdev)
+{
+	return MLX5_CAP_GEN(mdev, data_direct) &&
+	       MLX5_CAP_GEN_2(mdev, query_vuid);
+}
+
 #endif /* MLX5_DRIVER_H */
-- 
2.44.0

