Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011059.outbound.protection.outlook.com [52.101.62.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5955B28852E;
	Thu, 17 Sep 2026 11:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789643767; cv=fail; b=AsP1SWMhQTz1vGVBKAlisdnY7i87IP4D/4pRTOpZ5iY19NcjqGjrCtSIP5J4uA2Ijc+jnyhq0g3m1BaIIdfRcIjgiRe5KEucJChabMo/sCIua/qeZXT60AL/Ug/NLcHNw0xNWMn2DFy60LM3Bbgn2Qert04TKojsYQVpuGuckhg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789643767; c=relaxed/simple;
	bh=Yp7V1jvqXFmD3JMLCMnl22I21iPYkpY9YOVZTWW0KQc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C6dJaIflAwuzxlTwO7j6gwNu66NcA5AS8+wOxctYXAVHuwyCm3GOc13IgQ4duZmzMQ2RlXIMHLAG9FGY1aZqtSNXQ8uuEcY2qWsGaCPG6su4wZbRb6lF6ii4RbwkS3CESwuKUGP0rEOK8ZZVgDRM7qb3Ma7YeTcQPTT7AEmlp1o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Wn2HNKsl; arc=fail smtp.client-ip=52.101.62.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Wn2HNKsl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UVk3LCRr18Ycy14TtwSZ3rHgGnTtHaXTr5urnx6qxOnRuWNGhYG736L7mfcsH0kWTt1wHV01aR904LAWe1xrWHugyfdK/bDm2fWYjECoCVc6L+54UAdhw4XeFhHW0mEi+jJS5zfB0cVajH7YVnoIutdzNyu/uidhmSC1VSYydjVL5LJGK22dtAujRh16dWuD73gnslcWb3XKDKCHtrIO1oqGgFC7e0oOgF9Ooj8oXmxCwruBmmXuM5Bw4cEES2TPBFCbeF9iOcXTcp4tVdgjh3+ilyiskt2IGb/CjQuCZNcsqo1OVV0V5VPMcATAgKu6gNVqN0cpds3P3kvfkk4Z9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gtv2UwubdRQlP7YlgiJGi+wK9wJioW+I3WasBJ95PIM=;
 b=dseNcHASUhnIxPe2ufKgrqXhho2jSYfBxJxHpn9YRTBrTxC6u9BAALIL8cVbK46XqlaBKyCLdalhQdZ80C102E1GbxLRwcZpTNg6bYWfYBy1YOZ87C248P3I5LuDGFts9fc/6mmR2FJhC7QBPE/l5fpMKFtosNRNPTdbKBCne0ScqXQaLK3J08Zqz/GMfHVzVkfRFLfYDEPaBaSKN8UnhX8dKohiL1o0w+5UuI5eAUju1B5QxqS9s9f10I+pFgQeRBoW3vl8zDehcoMt8/re00lufR5sC8knoZtkKu0rYO0zERuTZWmeA0MI8gPV0likDmBIg5KBL6cn9TBmuDt9rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gtv2UwubdRQlP7YlgiJGi+wK9wJioW+I3WasBJ95PIM=;
 b=Wn2HNKsl52PvwNjZ5UohzzvJ2YqimKfQk7cxrGFqHDqec4lQhlsHWMF/U3aYjOUndPUNNrnO9gj7bQvEjF5K256C/l6eWFQYZ6Rh/gdZk5x0eiVYa7GqMPCGesJOf2/kZeH4FU5qFtgv+fOEaMudbj9NKYJ0kwWzBHTMAWL/zrpuGfJ45WfxOqQ8Qs1NrP8cIT7CknZ40gb2ACYQDVoSyvDOukHlMwpz0fg8DW2IqgZBkceX9sGZoYZ2FvxE0fdpvH/jWvWf3+WQWH5wdwm7mtCNyoMbsxYFXqkkQ97hYznDyvKtSaKhr2vTvCWBkJZZwZAWH0uflldcoTFXnj7fzw==
Received: from BN0PR03CA0058.namprd03.prod.outlook.com (2603:10b6:408:e7::33)
 by SJ0PR12MB6855.namprd12.prod.outlook.com (2603:10b6:a03:47e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Thu, 17 Sep
 2026 11:15:45 +0000
Received: from BN3PEPF00022BC6.namprd05.prod.outlook.com
 (2603:10b6:408:e7:cafe::4f) by BN0PR03CA0058.outlook.office365.com
 (2603:10b6:408:e7::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.12 via Frontend Transport; Thu,
 17 Sep 2026 11:15:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN3PEPF00022BC6.mail.protection.outlook.com (10.167.248.219) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Thu, 17 Sep 2026 11:15:45 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 04:15:27 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 17 Sep 2026 04:15:27 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Thu, 17 Sep 2026 04:15:23 -0700
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
Subject: [PATCH mlx5-next 06/10] RDMA/mlx5: Add new registration stage for data direct users
Date: Thu, 17 Sep 2026 14:14:18 +0300
Message-ID: <20260917111422.4054862-7-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BC6:EE_|SJ0PR12MB6855:EE_
X-MS-Office365-Filtering-Correlation-Id: 440f2a55-882d-4753-2b56-08df14ad04ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|36860700016|7416014|82310400026|1800799024|6133799003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ZsU71vHriFS4rXLBUpvBSDpJ3sbmaTPcD4TYCmuuBGEh9xKDzdNUjabAAF+g1DpUds3liZT4Qs7N6VmNcDpj5IfuqBY5n79JgNUfJKHMa8IFfvRXlFGQbwOoJyI3cdoYwtzXtPrwbBOSv8gUHz0u7eHjY0q0v7ZoM0upWzpWgpPj2d2CAt+P1MELiGXH5dPvSwpudNKbF3QU/aRuYIDqhBIwo0RggR34VbuT6V/EwQ7RtJkKYrTqIQosKyCa99FjOSTpcEYEI1t2SnNCkE9a3Xa/7hvrh67Bade+TUgoN1KtdFqEaA7buMOndgw2ASJNf+BOFujU5rLbX7EaYiAE7NkxsD7i/2ig3HkjMiLOQXNSb8WGRypLzw8jPDqPDsL1qIdH7iAlp+hEoxNOOX2MgbcgfUhinI1KNN/bgsPDK6lr5stJ/VJrIPK+ERrBI1WdGdf/BD+Y7oXWqHHLcwMZf38jPxyxIAcsDKHeZevO5JNRKKhzVu1IE0T5BYs51EbWPqddv53V6gySOt+OEGcWY0dzGbesjk1EGsnbncvkdSfdJUeCGvIY3x+q4FRSELDS+8gT22Pq2yeFg3L87ZpBa2kjAvzIUVgANj35wdk6tlURyVup3kypYmUnPYZvwuoQLcP1w1Bkrru6RND8bk4kipGephBsxRPLUNr84lLEqI7kwL50M1f7pd1DMiIdRzOSYWYkDeW9YqwgSGm8MvkuaA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(23010399003)(36860700016)(7416014)(82310400026)(1800799024)(6133799003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vMFVShXX6D3RT4wks6yCtwf9Z0/Hmewm+ezvmvqw1GO8jUt7yzU+nsEVmFd3+RCyP6SrlfYbR3swzQ18exJUnjFjzI/TO7Fye1/QFt8+QdMtlUkyj1iJir/q3xegYBzLqlj3F54SLz3KnzfjSD1vaQntSSNHtx4VKBd2GeFPtuQexSaQrLDeu5WAbizIDUa2EKMZnbQ5ifR9y9jldl/bFlnz+6c3jEp7LyMv54FPi6t68wlTJGi2k/w/wbSDLFHpfD7FXkgvPycLdRBMYHiMHzr0TIJnoc1YT207IHUfe48cBNnfjag3/nBbL9zl9y3GWKUwzdhYf+kj6qRUjrJJPgvrssgiNaclVRcKkN6xILtLveqcp6mRqpkFXYG/7lmvBrhARfw2lTSXkF2isfkNi4IJ3TbtBssYCxAcaItAbUlRgUTi/QlnZvIHM7Ortu57
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 11:15:45.2828
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 440f2a55-882d-4753-2b56-08df14ad04ef
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BC6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6855

From: Dragos Tatulea <dtatulea@nvidia.com>

For the upcoming move of data direct to mlx5_core driver,
the API needs to be split into init and register stages.
That's because only the core will do the init phase but
both IB and netdev devices will need to register.

While data direct still lives in mlx5_ib, do all steps in
mlx5_ib_data_direct_init().

While at it, make mlx5_data_direct_query_vuid() private
as it is no longer needed.

This patch has no functional changes. It is a preparation
for moving data direct infrastructure to mlx5_core. For
this reason the new functions are added to the new header.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/infiniband/hw/mlx5/data_direct.c | 114 ++++++++++++++++++-----
 drivers/infiniband/hw/mlx5/data_direct.h |   5 -
 drivers/infiniband/hw/mlx5/main.c        |  41 ++++----
 drivers/infiniband/hw/mlx5/mlx5_ib.h     |   3 -
 include/linux/mlx5/data_direct.h         |  10 +-
 5 files changed, 118 insertions(+), 55 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/data_direct.c b/drivers/infiniband/hw/mlx5/data_direct.c
index cc3f741b4f81..f871e3ce9f73 100644
--- a/drivers/infiniband/hw/mlx5/data_direct.c
+++ b/drivers/infiniband/hw/mlx5/data_direct.c
@@ -24,7 +24,8 @@ struct mlx5_data_direct_registration {
 	struct blocking_notifier_head users;
 };
 
-int mlx5_data_direct_query_vuid(struct mlx5_core_dev *dev, char *out_vuid)
+static int mlx5_data_direct_query_vuid(struct mlx5_core_dev *dev,
+				       char *out_vuid)
 {
 	u8 out[MLX5_ST_SZ_BYTES(query_vuid_out) +
 	       MLX5_ST_SZ_BYTES(array1024_auto)] = {};
@@ -182,25 +183,65 @@ void mlx5_data_direct_free_resources(struct mlx5_ib_dev *dev)
 	memset(&dev->ddr, 0, sizeof(dev->ddr));
 }
 
-int mlx5_data_direct_ib_reg(struct mlx5_ib_dev *ibdev, char *vuid,
-			    struct notifier_block *nb)
+static struct mlx5_data_direct_registration *
+mlx5_data_direct_get_reg(struct mlx5_ib_dev *ibdev)
+{
+	struct mlx5_data_direct_registration *reg;
+
+	list_for_each_entry(reg, &mlx5_data_direct_reg_list, list)
+		if (reg->ibdev == ibdev)
+			return reg;
+	return NULL;
+}
+
+static void mlx5_data_direct_bind(struct mlx5_ib_dev *ibdev,
+				  struct mlx5_data_direct_dev *dev)
+{
+	mutex_lock(&ibdev->data_direct_lock);
+	ibdev->data_direct_dev = dev;
+	mutex_unlock(&ibdev->data_direct_lock);
+}
+
+static void
+mlx5_data_direct_do_unbind(struct mlx5_data_direct_registration *reg)
+{
+	struct mlx5_ib_dev *ibdev = reg->ibdev;
+
+	mutex_lock(&ibdev->data_direct_lock);
+	blocking_notifier_call_chain(&reg->users, MLX5_DATA_DIRECT_UNBIND,
+				     NULL);
+	ibdev->data_direct_dev = NULL;
+	mutex_unlock(&ibdev->data_direct_lock);
+}
+
+int mlx5_data_direct_init(struct mlx5_ib_dev *ibdev)
 {
 	struct mlx5_data_direct_registration *reg;
 	struct mlx5_data_direct_dev *dev;
+	int err;
+
+	if (!mlx5_data_direct_supported(ibdev->mdev))
+		return 0;
 
 	reg = kzalloc_obj(*reg);
 	if (!reg)
 		return -ENOMEM;
 
 	reg->ibdev = ibdev;
-	strscpy(reg->vuid, vuid);
 	BLOCKING_INIT_NOTIFIER_HEAD(&reg->users);
-	blocking_notifier_chain_register(&reg->users, nb);
+
+	err = mlx5_data_direct_query_vuid(ibdev->mdev, reg->vuid);
+	if (err) {
+		mlx5_ib_warn(ibdev, "Failed to query VUID, disabling data direct, err=%d\n",
+			     err);
+		kfree(reg);
+		return err;
+	}
 
 	mutex_lock(&mlx5_data_direct_mutex);
 	list_for_each_entry(dev, &mlx5_data_direct_dev_list, list) {
-		if (strcmp(dev->vuid, vuid) == 0) {
-			mlx5_ib_data_direct_bind(ibdev, dev);
+		if (strcmp(dev->vuid, reg->vuid) == 0) {
+			mlx5_data_direct_bind(ibdev, dev);
 			break;
 		}
 	}
@@ -213,25 +254,56 @@ int mlx5_data_direct_ib_reg(struct mlx5_ib_dev *ibdev, char *vuid,
 	return 0;
 }
 
-void mlx5_data_direct_ib_unreg(struct mlx5_ib_dev *ibdev,
-			       struct notifier_block *nb)
+void mlx5_data_direct_cleanup(struct mlx5_ib_dev *ibdev)
 {
 	struct mlx5_data_direct_registration *reg;
 
+	if (!mlx5_data_direct_supported(ibdev->mdev))
+		return;
+
 	mutex_lock(&mlx5_data_direct_mutex);
-	list_for_each_entry(reg, &mlx5_data_direct_reg_list, list) {
-		if (reg->ibdev == ibdev) {
-			blocking_notifier_chain_unregister(&reg->users, nb);
-			list_del(&reg->list);
-			kfree(reg);
-			goto end;
-		}
+	reg = mlx5_data_direct_get_reg(ibdev);
+	if (reg) {
+		list_del(&reg->list);
+		mlx5_data_direct_do_unbind(reg);
 	}
+	mutex_unlock(&mlx5_data_direct_mutex);
 
-	WARN_ON(true);
-end:
+	kfree(reg);
+}
+
+int mlx5_data_direct_register(struct mlx5_ib_dev *ibdev,
+			      struct notifier_block *nb)
+{
+	struct mlx5_data_direct_registration *reg;
+
+	if (!mlx5_data_direct_supported(ibdev->mdev))
+		return 0;
+
+	mutex_lock(&mlx5_data_direct_mutex);
+	reg = mlx5_data_direct_get_reg(ibdev);
+	if (reg)
+		blocking_notifier_chain_register(&reg->users, nb);
+	mutex_unlock(&mlx5_data_direct_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mlx5_data_direct_register);
+
+void mlx5_data_direct_unregister(struct mlx5_ib_dev *ibdev,
+				 struct notifier_block *nb)
+{
+	struct mlx5_data_direct_registration *reg;
+
+	if (!mlx5_data_direct_supported(ibdev->mdev))
+		return;
+
+	mutex_lock(&mlx5_data_direct_mutex);
+	reg = mlx5_data_direct_get_reg(ibdev);
+	if (reg)
+		blocking_notifier_chain_unregister(&reg->users, nb);
 	mutex_unlock(&mlx5_data_direct_mutex);
 }
+EXPORT_SYMBOL_GPL(mlx5_data_direct_unregister);
 
 static void mlx5_data_direct_dev_reg(struct mlx5_data_direct_dev *dev)
 {
@@ -240,7 +312,7 @@ static void mlx5_data_direct_dev_reg(struct mlx5_data_direct_dev *dev)
 	mutex_lock(&mlx5_data_direct_mutex);
 	list_for_each_entry(reg, &mlx5_data_direct_reg_list, list) {
 		if (strcmp(dev->vuid, reg->vuid) == 0)
-			mlx5_ib_data_direct_bind(reg->ibdev, dev);
+			mlx5_data_direct_bind(reg->ibdev, dev);
 	}
 
 	/* Add the data direct device to the global list, further IB devices may
@@ -259,9 +331,7 @@ static void mlx5_data_direct_dev_unreg(struct mlx5_data_direct_dev *dev)
 	list_del(&dev->list);
 	list_for_each_entry(reg, &mlx5_data_direct_reg_list, list) {
 		if (strcmp(dev->vuid, reg->vuid) == 0)
-			blocking_notifier_call_chain(&reg->users,
-						     MLX5_DATA_DIRECT_UNBIND,
-						     NULL);
+			mlx5_data_direct_do_unbind(reg);
 	}
 	mutex_unlock(&mlx5_data_direct_mutex);
 }
diff --git a/drivers/infiniband/hw/mlx5/data_direct.h b/drivers/infiniband/hw/mlx5/data_direct.h
index 90e0565d7333..f207239461bf 100644
--- a/drivers/infiniband/hw/mlx5/data_direct.h
+++ b/drivers/infiniband/hw/mlx5/data_direct.h
@@ -33,11 +33,6 @@ struct mlx5_data_direct_resources {
 int mlx5_data_direct_create_resources(struct mlx5_ib_dev *dev);
 void mlx5_data_direct_free_resources(struct mlx5_ib_dev *dev);
 
-int mlx5_data_direct_query_vuid(struct mlx5_core_dev *dev, char *out_vuid);
-int mlx5_data_direct_ib_reg(struct mlx5_ib_dev *ibdev, char *vuid,
-			    struct notifier_block *nb);
-void mlx5_data_direct_ib_unreg(struct mlx5_ib_dev *ibdev,
-			       struct notifier_block *nb);
 int mlx5_data_direct_driver_register(void);
 void mlx5_data_direct_driver_unregister(void);
 
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 0bece3e55109..d0141509870a 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3945,33 +3945,41 @@ static int mlx5_ib_data_direct_event(struct notifier_block *nb,
 	struct mlx5_ib_dev *dev =
 		container_of(nb, struct mlx5_ib_dev, data_direct_nb);
 
-	if (action == MLX5_DATA_DIRECT_UNBIND)
-		mlx5_ib_data_direct_unbind(dev);
+	if (action != MLX5_DATA_DIRECT_UNBIND)
+		return NOTIFY_DONE;
+
+	mlx5_ib_revoke_data_direct_mrs(dev);
 
 	return NOTIFY_OK;
 }
 
 static int mlx5_ib_data_direct_init(struct mlx5_ib_dev *dev)
 {
-	char vuid[MLX5_ST_SZ_BYTES(array1024_auto) + 1] = {};
 	int ret;
 
 	if (!mlx5_data_direct_supported(dev->mdev))
 		return 0;
 
-	ret = mlx5_data_direct_query_vuid(dev->mdev, vuid);
+	ret = mlx5_data_direct_init(dev);
 	if (ret)
 		return ret;
 
 	ret = mlx5_data_direct_create_resources(dev);
 	if (ret)
-		return ret;
+		goto err_resources;
 
 	INIT_LIST_HEAD(&dev->data_direct_mr_list);
 	dev->data_direct_nb.notifier_call = mlx5_ib_data_direct_event;
-	ret = mlx5_data_direct_ib_reg(dev, vuid, &dev->data_direct_nb);
+	ret = mlx5_data_direct_register(dev, &dev->data_direct_nb);
 	if (ret)
-		mlx5_data_direct_free_resources(dev);
+		goto err_register;
+
+	return ret;
+
+err_register:
+	mlx5_data_direct_free_resources(dev);
+err_resources:
+	mlx5_data_direct_cleanup(dev);
 
 	return ret;
 }
@@ -3981,8 +3989,9 @@ static void mlx5_ib_data_direct_cleanup(struct mlx5_ib_dev *dev)
 	if (!mlx5_data_direct_supported(dev->mdev))
 		return;
 
-	mlx5_data_direct_ib_unreg(dev, &dev->data_direct_nb);
+	mlx5_data_direct_unregister(dev, &dev->data_direct_nb);
 	mlx5_data_direct_free_resources(dev);
+	mlx5_data_direct_cleanup(dev);
 }
 
 static int mlx5_ib_init_multiport_master(struct mlx5_ib_dev *dev)
@@ -5008,22 +5017,6 @@ static void mlx5_ib_stage_dev_notifier_cleanup(struct mlx5_ib_dev *dev)
 		cancel_work_sync(&devr->ports[port].pkey_change_work);
 }
 
-void mlx5_ib_data_direct_bind(struct mlx5_ib_dev *ibdev,
-			      struct mlx5_data_direct_dev *dev)
-{
-	mutex_lock(&ibdev->data_direct_lock);
-	ibdev->data_direct_dev = dev;
-	mutex_unlock(&ibdev->data_direct_lock);
-}
-
-void mlx5_ib_data_direct_unbind(struct mlx5_ib_dev *ibdev)
-{
-	mutex_lock(&ibdev->data_direct_lock);
-	mlx5_ib_revoke_data_direct_mrs(ibdev);
-	ibdev->data_direct_dev = NULL;
-	mutex_unlock(&ibdev->data_direct_lock);
-}
-
 void __mlx5_ib_remove(struct mlx5_ib_dev *dev,
 		      const struct mlx5_ib_profile *profile,
 		      int stage)
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index ff026985e293..e56f3eee7ba1 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1396,9 +1396,6 @@ int mlx5_ib_destroy_rwq_ind_table(struct ib_rwq_ind_table *wq_ind_table);
 struct ib_mr *mlx5_ib_reg_dm_mr(struct ib_pd *pd, struct ib_dm *dm,
 				struct ib_dm_mr_attr *attr,
 				struct uverbs_attr_bundle *attrs);
-void mlx5_ib_data_direct_bind(struct mlx5_ib_dev *ibdev,
-			      struct mlx5_data_direct_dev *dev);
-void mlx5_ib_data_direct_unbind(struct mlx5_ib_dev *ibdev);
 void mlx5_ib_revoke_data_direct_mrs(struct mlx5_ib_dev *dev);
 
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
diff --git a/include/linux/mlx5/data_direct.h b/include/linux/mlx5/data_direct.h
index 4556e58c6d03..71f47547aebb 100644
--- a/include/linux/mlx5/data_direct.h
+++ b/include/linux/mlx5/data_direct.h
@@ -7,7 +7,15 @@
 #define _MLX5_DATA_DIRECT_H
 
 struct mlx5_core_dev;
+struct mlx5_ib_dev;
+struct notifier_block;
 
-int mlx5_data_direct_query_vuid(struct mlx5_core_dev *dev, char *out_vuid);
+int mlx5_data_direct_init(struct mlx5_ib_dev *ibdev);
+void mlx5_data_direct_cleanup(struct mlx5_ib_dev *ibdev);
+
+int mlx5_data_direct_register(struct mlx5_ib_dev *ibdev,
+			      struct notifier_block *nb);
+void mlx5_data_direct_unregister(struct mlx5_ib_dev *ibdev,
+				 struct notifier_block *nb);
 
 #endif
-- 
2.44.0

