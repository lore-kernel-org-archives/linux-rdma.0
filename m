Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010024.outbound.protection.outlook.com [52.101.61.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89784CDDE6;
	Wed, 30 Sep 2026 11:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790768675; cv=fail; b=j+IfkLcOpT7wkZYn0NmVA83/73+Q5fzlvIVu1x4XZLBJvQtqg9GsHsYsQojFdcUVyOrbhXqDUMkUYnfFslE+k0z3lCKLs6V3ug9N9fIt2+Wc3ZLNUYk8HT7MpVWiGdEYfiutlFYIorVvNhljmtqrTn4oP5X17HrYkMH0YqG5I/Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790768675; c=relaxed/simple;
	bh=yt755kuL8FcjqShJ6s3SOM9FRjJpyDgboPapq7AIsQI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nUsLTVFBHDaVZNklOsA57QlMEqryPl3JlieTPMczjmDLsWUnwhIysOt0nj18moWCZyImQlzY6iH7CU0n3vSVh58NTo8f03LlRcYffY6F5AOpPpb+oxTCTtR4kXvRjOTEOV3/4z6NI/trgIJHgOwmXfwx/X7h2L0919ayeqfki2U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dj2D1y/r; arc=fail smtp.client-ip=52.101.61.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dj2D1y/r"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sRig6NpNgv0/zNDvsoNh0Yy18BiFnYRiua8BEzSMN6lfNCJEWsU4sW2h7/z3eGeJt++zWjs1NH+vUJ62K4miPmoyst1IJ5tWEGDSNiU+iUEEksGS8rLbdaDXxO18PUVGuAgLo94096kW5POrDAJcGACfuuvDbiDobFEf0+8A7jZpWtwsRJqw0A4kIEyuKb6T6/9YQuOTmLfvzCPWjqi99aTru5clLKQ7PQUSgxL1tCWtig4w9Yr+I4KSJRFqU/ks6vjtdTPX+I2jYHpXE9RBmECxQbvGsDNEc/6vH/MNRNolpXfbo1x31AjcsP6xtlw9ZEaTU5SRtjwrhmQPZZcCpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kzNQOwtkkxQ1LVr1fx12U0+ureprU7rs37hSA+arXHQ=;
 b=igUg00bSpJRF1IJwXJ8cVVPuFGUWn8A+A9fRdI7qG0nzvdUpGaDfLUGhqsDgO1OBeuRFf1v9FJYVkXgXuO1l6YdFPk7G2wpM+8SaeGX990DcJRy2jQG2dxyty7IMivX2s1+rWk2oZUgj1ORoqmoG/k10E69impzO1Axi1tobCkMk/Ro8ZqFlL2GY8lV7Yn94ziOPaSS5k5KeTrOBE0zoSO2mbNahoaOxzKlwNolFOhuzeK/UDy5Rfniglnl/g7yjRI10dPd9LKbmVwI87WQMQ0LMRmN/i0ERF2eTNFfOr0A/Jz8+N8bnoxMMbiuFBJVOtgsk7S6NTIktwIiJMsbUfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kzNQOwtkkxQ1LVr1fx12U0+ureprU7rs37hSA+arXHQ=;
 b=dj2D1y/rkB33SMsUOiFiKYhsa7NTeNnKb+X5OtvqG8Ck+NSWDZHOx1whxFT4HrNh+yh0Bjq48l3iQ4n0KPMGB3AR4mZxvTacNnO1Ce6/UkZQDio2a4/nG5Gb+wwFLbkznku4hKooHdgwdyjhlzO5yO4ZtPYM2RptZ1q5N29nMexf//f1S4RekU2revxI4zcWhGmlfwrKhDvXINOAKux+S5KFfVIrAokcdy7wXKt6ptR0NmkczoCiI0aasvKNNEMKpUMwpH4HFLQ9bJJXcyOIv4jumslt0qUEI/oPnkSAki5xeEdWHMjpq8vm58Ltb9WlHj75bScpquBkDiS8fQPE7A==
Received: from CH2PR17CA0022.namprd17.prod.outlook.com (2603:10b6:610:53::32)
 by MW3PR12MB4492.namprd12.prod.outlook.com (2603:10b6:303:57::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Wed, 30 Sep
 2026 11:44:21 +0000
Received: from CH1PEPF0000AD7C.namprd04.prod.outlook.com
 (2603:10b6:610:53:cafe::5c) by CH2PR17CA0022.outlook.office365.com
 (2603:10b6:610:53::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.14 via Frontend Transport; Wed,
 30 Sep 2026 11:44:21 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH1PEPF0000AD7C.mail.protection.outlook.com (10.167.244.84) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 11:44:21 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 04:44:07 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 04:44:07 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 30
 Sep 2026 04:44:03 -0700
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
Subject: [PATCH mlx5-next V2 09/10] RDMA/mlx5: Pull data_direct resource creation in init phase
Date: Wed, 30 Sep 2026 14:42:26 +0300
Message-ID: <20260930114227.139274-10-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7C:EE_|MW3PR12MB4492:EE_
X-MS-Office365-Filtering-Correlation-Id: eb372382-f9b0-4fc2-f780-08df1ee82b21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|1800799024|7416014|376014|6133799003|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	WIW4MMNKpGGe93GztiRjrE2wXn0Fy1zp39jLwK1FBaMEUizw++e+aKKnWAeiveZovG/SPoP8zFNEhF+iZKXnMcUI1ErJ6Ss3W2qLwJ3CYVJrqNgE+NcCLBDaXHFN4Em1j+Gnf1UbjsGD7Rd5ViefT33bOyL+UpGTuAdc6HSo4EKzPzrCBRmd1yIcOtzLVYT7SyrW9Hi3QKxf7T168mkl7UMPnF6F4F7H0th8LNIDBv0otpKuU/3Oj+tESmhHcCWTBq/eKr02wp0ACGukUFGOFH+aQd5Gczfw/S2pVForbEp8sZ2RCNiPI2k5FRTbHeE7WWMSCPzVK7GZkkPdx92HVbItu/fI8XeZ1OmLRjGb36xFlRZDpVfY3s5O5E9PREiqFl12WoJBrQYLpAfb9fZ2g/hP1Voz0tbQkOyHH0yvEhrcNvCBVXr7tWZwIuG14f3nzGMmUtMt+j38seaNokcj5g93ecaXzjypUgygixit33+q5/CrO2AX7kYET6wHXZSUYbGRLMz2zkK5gJ484PPxt3oIiq+59GdCUkdWf1csnV3mYX58p+hXp+cGjKRLG+T+guYW4LpsCUelkQz4nv6igcfBzDHogA538cA//O9Du8FZzsxH2KjWCzHnOhy0IQ65Jn1r6l/4I885oAr5BTvadNEbvDeyL8K6baQA9CxYtDG6CZFCPMvOq2Nt+/z8Ow4wMN+LTrI8pSrdTKAYY0Dc9w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(1800799024)(7416014)(376014)(6133799003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rPpoKbJ8yG6EtDnZTQdY2h85eoQW6hMJEDGx76aZS3j2BB+szObCdrM41Oe9KSIm5HBPmmtIt5N1CANmoHFWx2/fJ6f9BDuTXVpmDEySfX0NTDyOe4hW5g+BPYARkTfyEVT+KknO2aC3kpacUUTrG6dkDADP1LWcujET9tGhTsaKmPB/141kso/Hvlk18Y5yLKoFwPOJNecaptga0nfwP6JTsZ8EZMe3bWFQR7steqjw0qOXFk4+iggUl165ffOrMwlju2Boax2zZg0yayW78oV+H6QHATJjQUYWNycoLSZPMlI+gG7WXECZcQ0GcqCaesps1dumPSOD2BuI488STvoKGAH/1jvoeumTjWbwnLl1Y2OkHIFzQ8QFFsSvob6sY0OkiJclI5aAYS3OmbCT8w4oQC24VpNhwsZKTZe8FGvqKVIxiH/pcKOzzivlq2aE
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 11:44:21.3514
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb372382-f9b0-4fc2-f780-08df1ee82b21
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4492

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

