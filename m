Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010029.outbound.protection.outlook.com [52.101.56.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0764CC287;
	Thu, 17 Sep 2026 11:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789643773; cv=fail; b=oKQvdW0erSIVrZ1S2cNGDCLlHnmUFjc6rf9PGxo+Fp/rbeTIoEgWL4dz8VnGR9TQUwhGZoq1sfLe/xIjYn3tIv08eXVqw+yqvOYjzDkx6g6FVayauadsgwxWC59oMaVW9rJaBd+WHg5pUyLamN6fKfK7xcr4Hm3NgXJIS3YHLNA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789643773; c=relaxed/simple;
	bh=yt755kuL8FcjqShJ6s3SOM9FRjJpyDgboPapq7AIsQI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BHbtN8kkmqQgT1XS1QwaWK1BAxCNXcogB1yEwI6h+OpBSlmTXHfJs6h+GNrdM5FeqI+fD63+LzRtrwi+l7KYTR4xIHSfmsR8QQeGjAJswlufvA3lxqAvMOggkv7uhdbI2zFig4BqCaK+nRBDOiL8bsogMlal7vkvERbLYaOWN1I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=V+al0u9i; arc=fail smtp.client-ip=52.101.56.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="V+al0u9i"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W8WBHuhfYwCUOSEgVXknAYalveAWi8ePMigcyPK9R6FtgsIuDQLKaP4x+mJKPkRphyS/LJoUrAB8KeOb6g+5DIr/8Pf+TrtfBrV9RHP3xPMy+vNK+84h5xhZE1OXdzWqjxvc9Nc1yeh4dJxEx1XJwcbJKvPoTmdbxQswprqcbyWkvKVNiNdwE2tnt6uUHGc/NPBek/OZQqvIj3+xvr5WYuD+W7+IsUml74HA+sKdHT+fdMbQzW8h8Lgl6gcLv02PBoQW7vggHUbBxKdEoO6IRyjzAVaMFsde/x/tDRBBv91xTmBbhNATMWm+1o78K3O6oeZIWKDQbdv5C4V6Tr2Bzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kzNQOwtkkxQ1LVr1fx12U0+ureprU7rs37hSA+arXHQ=;
 b=VDAoQOwrBSew1YG7Ilt2EdjSzIZq5huAiLSi2nKh21f2n9D+pc68JAEjplpQ0cNu58Y+JysDA5IMWX9IakhDU6duIBEf7lmHjJn7SstvMd0oBXfRumdmXKICW1rmsJF971QMJu6xmtIcyTVBxQ0cTZLz0u3sYTO2pWVc51eGkZnBrD1V9qggAjHjgtHntMrV2m6eHxOeIrHRuMQsaQGCj8gmGTxMTGqbYW5r15TURsR7UlZ/7ydvyZbIR4t5TszFZPMIiIyh2l1GYJm5lQEArWcsR+HDkIdOISd4kvlcfqKlJ/09hV6OV+AChFeaCDFrWLI2ZqiqdzWUi+kWEMa/oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kzNQOwtkkxQ1LVr1fx12U0+ureprU7rs37hSA+arXHQ=;
 b=V+al0u9iXZ1BJAModooKoDWMeq3HJiKjKhPxXHvlXGhMFPfldjWWTgeL5lpSdPEtJ8/bLjY1OWEYHui1rWA9spea/WrlnNvm2U7xjxkJvVPPhWCdDyGSzFfLRQtVODzp3KWrTgqlbfprRmD87SVacjlPvzL1r41G4B/U6jId1aN/nC6O0pddsK+EUQzu0A+mOrAdk72p7M/d6NGQ9uUJsyVSgnwuUBI5bebUIlgGqpwazyB2uhiqnZf864NSJcteErMLs0cLXb4VfCNffj9z5j1KmbBhlQ96eCE3COUa/O19B8CO5S9pwvuEzGBpz73wRfd1iAFAHpmblyMoeFqKmA==
Received: from BN0PR03CA0048.namprd03.prod.outlook.com (2603:10b6:408:e7::23)
 by PH8PR12MB7304.namprd12.prod.outlook.com (2603:10b6:510:217::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.11; Thu, 17 Sep
 2026 11:15:58 +0000
Received: from BN3PEPF00022BC6.namprd05.prod.outlook.com
 (2603:10b6:408:e7:cafe::3a) by BN0PR03CA0048.outlook.office365.com
 (2603:10b6:408:e7::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.12 via Frontend Transport; Thu,
 17 Sep 2026 11:15:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN3PEPF00022BC6.mail.protection.outlook.com (10.167.248.219) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Thu, 17 Sep 2026 11:15:57 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 04:15:41 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 17 Sep 2026 04:15:40 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Thu, 17 Sep 2026 04:15:36 -0700
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
Subject: [PATCH mlx5-next 09/10] RDMA/mlx5: Pull data_direct resource creation in init phase
Date: Thu, 17 Sep 2026 14:14:21 +0300
Message-ID: <20260917111422.4054862-10-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BC6:EE_|PH8PR12MB7304:EE_
X-MS-Office365-Filtering-Correlation-Id: 6373068f-279e-4e56-7009-08df14ad0c78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|376014|82310400026|1800799024|23010399003|6133799003|10067099003|22082099003|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	7ZKyP7h0n/2T4Wyqk9VyNcSy9C1zmup/Lw/NuHYSEdcqxsFhghOygqFBnEZYCM7FevCgvy9KTISE3ZFQNVaKK3aIyLJQBTuCBtoU82rLobgCNOIgjQOJCMBt7ZM3Nwm/mbEzCCByDEh3Sb47X04QEjV+CSu80zAUu/buk89MFQsgtuMM7Zn+MX8FGt9V8diNMvGF+0CwYqXgb787K60lHGsVAwJy1nOHD/791P1WKZUPKR7fNH/kU7fFL7Rm66LMyyXaACUPlAGebcNtAUt42jqDupfQob8Sl6trP/XKPo2zfnIeLn1Xmb+BWWuZzCfNeWdkBaasbCWw1zjkXyBj3GxG4Yc11eq6paPL0uXJuppYAW0rEZUtc9gzpOYyeJIfUPl2KQxvVMdgIUbHBvnmjTT2thyjWk5ALgnn1of0if+QwZVg1/EZ3xtRQPKsc2q97DTsTGwdSg8D4NxojITTKur5//huR3ykyu31st08Gho6ubaZ9tHUBEs5NpEYsVQCEZRxIHk28jgChYT6q9qeRHneWAL+T8e1gPNKOcg9qPTflRPMMf9cTgiu07CPURxZTlWWtuyC74Cxo7p2Vs/PbIaQ6ovEFMB4G3itUSytM5cYhaLYR8G5YxBx12DJMO/u68l9XPMDYMdxX3681x520/u3BjTQrnY+ekUyp2LBCN/wfyhQtKgBXJsdEqrV1B8yDy7cpiAkdM/jyn7peyF1DA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(376014)(82310400026)(1800799024)(23010399003)(6133799003)(10067099003)(22082099003)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	OWbFZFMmaRnVHLz4eVMyS/rIZ0GJ5WWOKQ/bKG7tqvqLe4wxI5mOIQ7Wcj4ype0rU8/WODK6nXgWIr7346kvPl8nYzRbu8tZ9tbp20Z+Lc1AbNpdUOmGkog/JYZZPInimdbGqqRCF1Q1GIce5AxJTHxi4AXBQ0COiFThmDMYcmmt9gTadrdfg9v2Yill+XLjYWPVUEUW2tFhfQICsHWMXJwqdob8gc5D16KciQiV6jutK9GuYDIVt89QTPtupbZ/af11PAWEheSFle+KSKo42s7nR1AIeot135Q9zDFoFbPbPExQWMZgJ4yWEEJ3fZQIY3oB0CjFLHc0R4JvPvDOkha5cek0xdONYeBAsTjpL6YQ3FUf6IsTJaVkJRMth/R8BmTYOF+/9J36wUCirE7Zq60HRzmMQepPBY+f0fMfCvgVR+iQORqwBa/qgSA6Llvp
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 11:15:57.9085
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6373068f-279e-4e56-7009-08df14ad0c78
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BC6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7304

From: Dragos Tatulea <dtatulea@nvidia.com>

Since data_direct resource creation happens directly after init,
there's no need to separate them.

This patch moves data direct resource creation in the init phase,
thus simplifying the data direct API. The cleanup path gets the same
treatment.

This keeps the existing IB device lifetime and prepares for moving the
combined initialization and cleanup to mlx5_core load and unload.

The patch has no functional changes.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/infiniband/hw/mlx5/data_direct.c | 16 ++++++++++++----
 drivers/infiniband/hw/mlx5/data_direct.h |  3 ---
 drivers/infiniband/hw/mlx5/main.c        |  7 -------
 3 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/data_direct.c b/drivers/infiniband/hw/mlx5/data_direct.c
index f58a144d95e3..3878c4aebb2c 100644
--- a/drivers/infiniband/hw/mlx5/data_direct.c
+++ b/drivers/infiniband/hw/mlx5/data_direct.c
@@ -103,7 +103,7 @@ static int mlx5_data_direct_set_dma_caps(struct pci_dev *pdev)
 	return 0;
 }
 
-int mlx5_data_direct_create_resources(struct mlx5_ib_dev *dev)
+static int mlx5_data_direct_create_resources(struct mlx5_ib_dev *dev)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
 	struct mlx5_core_dev *mdev = dev->mdev;
@@ -172,15 +172,13 @@ int mlx5_data_direct_create_resources(struct mlx5_ib_dev *dev)
 	return err;
 }
 
-void mlx5_data_direct_free_resources(struct mlx5_ib_dev *dev)
+static void mlx5_data_direct_free_resources(struct mlx5_ib_dev *dev)
 {
 	if (dev->data_direct->mkey_ro_valid)
 		mlx5_core_destroy_mkey(dev->mdev, dev->data_direct->mkey_ro);
 
 	mlx5_core_destroy_mkey(dev->mdev, dev->data_direct->mkey);
 	mlx5_core_dealloc_pd(dev->mdev, dev->data_direct->pdn);
-
-	memset(dev->data_direct, 0, sizeof(*dev->data_direct));
 }
 
 static void mlx5_data_direct_bind(struct mlx5_data_direct_registration *reg,
@@ -222,6 +220,10 @@ int mlx5_data_direct_init(struct mlx5_ib_dev *ibdev)
 
 	ibdev->data_direct = &reg->dd;
 
+	err = mlx5_data_direct_create_resources(ibdev);
+	if (err)
+		goto err_resources;
+
 	mutex_lock(&mlx5_data_direct_mutex);
 	list_for_each_entry(dev, &mlx5_data_direct_dev_list, list) {
 		if (strcmp(dev->vuid, reg->vuid) == 0) {
@@ -236,6 +238,11 @@ int mlx5_data_direct_init(struct mlx5_ib_dev *ibdev)
 	list_add_tail(&reg->list, &mlx5_data_direct_reg_list);
 	mutex_unlock(&mlx5_data_direct_mutex);
 	return 0;
+
+err_resources:
+	ibdev->data_direct = NULL;
+	kfree(reg);
+	return err;
 }
 
 void mlx5_data_direct_cleanup(struct mlx5_ib_dev *ibdev)
@@ -252,6 +259,7 @@ void mlx5_data_direct_cleanup(struct mlx5_ib_dev *ibdev)
 	mlx5_data_direct_do_unbind(reg);
 	mutex_unlock(&mlx5_data_direct_mutex);
 
+	mlx5_data_direct_free_resources(ibdev);
 	ibdev->data_direct = NULL;
 	kfree(reg);
 }
diff --git a/drivers/infiniband/hw/mlx5/data_direct.h b/drivers/infiniband/hw/mlx5/data_direct.h
index de2730f00852..49cdd407018a 100644
--- a/drivers/infiniband/hw/mlx5/data_direct.h
+++ b/drivers/infiniband/hw/mlx5/data_direct.h
@@ -23,9 +23,6 @@ struct mlx5_data_direct_dev {
 	struct list_head list;
 };
 
-int mlx5_data_direct_create_resources(struct mlx5_ib_dev *dev);
-void mlx5_data_direct_free_resources(struct mlx5_ib_dev *dev);
-
 int mlx5_data_direct_driver_register(void);
 void mlx5_data_direct_driver_unregister(void);
 
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index cefbcc816651..941928a782bd 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3966,10 +3966,6 @@ static int mlx5_ib_data_direct_init(struct mlx5_ib_dev *dev)
 	if (ret)
 		return ret;
 
-	ret = mlx5_data_direct_create_resources(dev);
-	if (ret)
-		goto err_resources;
-
 	INIT_LIST_HEAD(&dev->data_direct_mr_list);
 	dev->data_direct_nb.notifier_call = mlx5_ib_data_direct_event;
 	ret = mlx5_data_direct_register(dev, &dev->data_direct_nb);
@@ -3979,8 +3975,6 @@ static int mlx5_ib_data_direct_init(struct mlx5_ib_dev *dev)
 	return ret;
 
 err_register:
-	mlx5_data_direct_free_resources(dev);
-err_resources:
 	mlx5_data_direct_cleanup(dev);
 
 	return ret;
@@ -3992,7 +3986,6 @@ static void mlx5_ib_data_direct_cleanup(struct mlx5_ib_dev *dev)
 		return;
 
 	mlx5_data_direct_unregister(dev, &dev->data_direct_nb);
-	mlx5_data_direct_free_resources(dev);
 	mlx5_data_direct_cleanup(dev);
 }
 
-- 
2.44.0

