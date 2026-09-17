Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012021.outbound.protection.outlook.com [40.107.200.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7734D4D0CFC;
	Thu, 17 Sep 2026 11:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789643763; cv=fail; b=bDIqMx8sNClHOb793xHahel+8ytvcaBn12dx8w4/kAFk7+dV0M/teJffhhN9j4dJHp7sr5zt0r7SteuJXVa5KJuyrr2qcKTlXmG3UkwyVmuibFU1TmfekltwK0vpviDO6HzarkEfiu+HWe0Ht/Ak2uAvoEsh4tY5fnZ+D1yW9PA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789643763; c=relaxed/simple;
	bh=ORT3i5tKcExiFYj/PkptrP+CgSqeNrUuTbpYCr5xQqc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ymf4GWKSXKGoOpsOIimT2B0kc9RkpB3HJkqrqcRV2rn4PJSMkDIZAiSbNQ5Z1i1va4l6NN12s9/lr1IVu2O/DVZJCd2q510WCm0NQA1b7Yb2dUOYAm6okzjYRCxMaCMbFUgUyMCF36YPgOd01kwE+ISr/cMeBfIUlClkki8KUcE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kkf934i0; arc=fail smtp.client-ip=40.107.200.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kkf934i0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m3qNJh1dHcCMK/ZFiPe5/gtKTknULt+o5LkF0BHGWo0x2ZI+2mn3J8mf740jzGO5j5A5eRNGK/o8jsrPF5eVW1CDg1IxUuvMqKF+ZE32e+nr72I5IJJPaI8vgQ48vmUjwhn3ot0eXwMektMonihDRnPEMr3jFPJuvWrR00ipIWNOiABzYOHBW0+pipgUCioxlySC6pToFs/bDarwVTl0V+aYLYSqfNJ8WcJqLWf9kWUGmzzQ2NfLWfm9rLc2hTHCb6sC03jZsb646JSw43FvUSZXfDzXesyNPcgrqoBjxCWlY7naF9RDnr5sw5edYG7+qLfuhY9twMGIb7qLpUL0wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BbwoOHz7t0q0Pd3QJzWwpQ254haD2l5BzFU9RFNacI0=;
 b=KULGgfjgrPcbpVE9lrVS8l5CAmXiX/ZeLnXhn+2FVs6qlOTUiB/IDfCS23qgdQdnECyhLsHOzbkUrz+/xZm9XxNV6HexUUsS6iGluUyPjCLA/kbYx+kQBIN6AZJv9EEl32rBmZjH494kNnLMtGa96E+qj4fc9t4aU3qL+VL+3q1oe/rf+yTB8TELFOsOXn3yOrJW5fjFLlIuc+mCjHRJG8+jud5V5JShgLoN5XpF83r0Pgnx4nuh4mO1quW0YkWO69CnrwBp+fAjxKmOrSUkYkdlaSwfN3jyrNcMgctyWE6+TIRGsp9/a+Q2C9D01cs77TPbIVTsi3ioG+yfJhuWsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BbwoOHz7t0q0Pd3QJzWwpQ254haD2l5BzFU9RFNacI0=;
 b=kkf934i0pS1Hk+BEf3/JFoNWpvQ8rO+VBsNGt+6u6ZjVU+sTcSIgFNzMKEPwzWQLz0JlLeYEzlDrviSUFUkPjEmdUf4yUwRa0BwKyJ6Oc55A0q0pHgwjHqOg6EJVQ1U7SpOg2A8eWv6D5OP9wyaLRbhjXf4h4dV373hqi/JcHm2gkeA/QIROuPGeIGQSRHBwMRUA8Tjn+bQzQrnwBw+pLLNBCGrNzHfZMyt/vWPOVI4z31FZOsBD+YUgRSzhZDSFRIM1gQTvSGu006eeDlaxKDYu8q0AwpgyHQzC4EggoQBiUJ3374YR8JLcZz//MSnIJ6aSKp0qHU/mDlBtP3kTCA==
Received: from CH0PR03CA0238.namprd03.prod.outlook.com (2603:10b6:610:e7::33)
 by PH7PR12MB9201.namprd12.prod.outlook.com (2603:10b6:510:2e8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Thu, 17 Sep
 2026 11:15:48 +0000
Received: from CH3PEPF0000000A.namprd04.prod.outlook.com
 (2603:10b6:610:e7:cafe::52) by CH0PR03CA0238.outlook.office365.com
 (2603:10b6:610:e7::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.12 via Frontend Transport; Thu,
 17 Sep 2026 11:15:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CH3PEPF0000000A.mail.protection.outlook.com (10.167.244.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Thu, 17 Sep 2026 11:15:45 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 04:15:36 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 17 Sep 2026 04:15:35 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Thu, 17 Sep 2026 04:15:32 -0700
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
Subject: [PATCH mlx5-next 08/10] RDMA/mlx5: Consolidate data direct state into one object
Date: Thu, 17 Sep 2026 14:14:20 +0300
Message-ID: <20260917111422.4054862-9-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000A:EE_|PH7PR12MB9201:EE_
X-MS-Office365-Filtering-Correlation-Id: 8975927d-732e-4063-9d45-08df14ad0549
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|7416014|1800799024|23010399003|36860700016|18002099003|22082099003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	cqLZSrvqCCXowIlg2wB4luOT+d2Wpy5Lqi8B7DqhW/p7oH9h0o1gueWqYz2i87KYeL+roeEA9ea6iKb/9i3GZbHJbsR7/T8Cu6O2Qk+LH95gTjNV2SEqiUzltjfzpH7b7RxD+s9xG+fuiSJBkcfgdBT4xgFx7LorO2IJYSiEunu8rT1B/KKAaktJuA2kOVBoKatZsopq1bd0E2Dcx6DPhGgaTDtTQGLxB8uv+CKedsNk7Y4LlNBuWCBNMr3bObfEIAI/X8DqhgacWORm+ANcTaXFA/GhVFkZoll6V//SdLZDGPC7d5o9VrjAXG3wq4oOaDqDvq34iowlB2v4LzDjxE2K+dkk9+0YgdYvxampWJLIwodlF+hz12QJG3bjNYPkHLxAWi2LBlbfLqokYaKr5ZY65I/2WvaL/m278Uk24F5tXOxTFRmNW4gsKyOZm02jTHcjhgSwQAgni+3eaDhO4rfhCxt4yMBLaSar2jfaOOVZ41rxj64k7PYORqmDBSE2X/ktWn80fS2payW/DzH7+ixA1LqxllSSJVjUYoecvGKUakl/HytXOP7tTU+afr6qVvY873nDDWskMwPI8rgkhxrg8eMtbb3UIcFatzOxWDo2sgHm2alemhkst6sejyRdZitlicFBCZFzOZSZXpskO5zvm67629EWRyDUr72QVkSuUfdW00p8RUCyvRa31c8KJVGY7J4Q35/3TJ9lTcUfvA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(7416014)(1800799024)(23010399003)(36860700016)(18002099003)(22082099003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nEYAQ1MenUR7e4wUajeeNJc2NcYFHb1JfBsKRskkXyjXfjV3aYFKyb+fkJgouPvuNNDseielEBKhwiyW4qufLNYPf4MyMNFt4XZW5zrY1k21arQTcVVG85wFcMnw7H9ww+hhrxOfez05dHPijCRIzFS3T5TjTkAvIVdpSrx86ugzopoWi8zjjesoR7Aye/jGSiZRWk4uPog86YAiZRTX3I7bJmUGfIp7qznXcMI2qdza688dMDGuTH7g2odzRRPAj/JC/N97w0/albM9RjDnVFC0YxTRNsnxbMmBlEhMSZq/bHq3nNszTulnon75ZKiEok1F85rTya5pQsblUQbPQZUcNxq/noG1FHwFhsmd37oN+Mnr1UD6/bhHRYdi8XeLxLfmg3V798m4Wk/XmxP3S+UIe9Js/y2HNepgDTIn6PbYSLcvT2+5VsRYnaVqmwjC
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 11:15:45.9038
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8975927d-732e-4063-9d45-08df14ad0549
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9201

From: Dragos Tatulea <dtatulea@nvidia.com>

There are three per device data direct objects: mlx5_data_direct_dev,
mlx5_data_direct_resources and mlx5_data_direct_registration with
separate allocations. This patch consolidates all of them into the
registration object.

For this, a few things needed to happen:

- mlx5_ib_dev keeps a pointer to mlx5_data_direct.
- mlx5_data_direct_dev is now accessible from mlx5_data_direct.
  mlx5_data_direct_get_dev() is added as a helper to access
  the device pointer.
- Since mlx5_data_direct is part of mlx5_data_direct_registration,
  getting to the registration is a simple container_of. No need
  for searching the list.

Since mlx5_data_direct_resources no longer has an accurate name,
this patch renames it.

This is a preparation for the upcoming move of data_direct to
mlx5_core.

This patch has no functional changes.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/infiniband/hw/mlx5/data_direct.c | 73 ++++++++++--------------
 drivers/infiniband/hw/mlx5/data_direct.h |  7 ---
 drivers/infiniband/hw/mlx5/mlx5_ib.h     |  3 +-
 drivers/infiniband/hw/mlx5/mr.c          |  6 +-
 drivers/infiniband/hw/mlx5/odp.c         |  2 +-
 drivers/infiniband/hw/mlx5/std_types.c   |  2 +-
 drivers/infiniband/hw/mlx5/umr.c         | 11 ++--
 include/linux/mlx5/data_direct.h         | 17 ++++++
 8 files changed, 59 insertions(+), 62 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/data_direct.c b/drivers/infiniband/hw/mlx5/data_direct.c
index 16afacdd3601..f58a144d95e3 100644
--- a/drivers/infiniband/hw/mlx5/data_direct.c
+++ b/drivers/infiniband/hw/mlx5/data_direct.c
@@ -18,10 +18,10 @@ static LIST_HEAD(mlx5_data_direct_reg_list);
 static DEFINE_MUTEX(mlx5_data_direct_mutex);
 
 struct mlx5_data_direct_registration {
-	struct mlx5_ib_dev *ibdev;
 	char vuid[MLX5_ST_SZ_BYTES(array1024_auto) + 1];
 	struct list_head list;
 	struct blocking_notifier_head users;
+	struct mlx5_data_direct dd;
 };
 
 static int mlx5_data_direct_query_vuid(struct mlx5_core_dev *dev,
@@ -139,8 +139,8 @@ int mlx5_data_direct_create_resources(struct mlx5_ib_dev *dev)
 	if (err)
 		goto err_mkey;
 
-	dev->ddr.mkey = mkey;
-	dev->ddr.pdn = pdn;
+	dev->data_direct->mkey = mkey;
+	dev->data_direct->pdn = pdn;
 
 	/* create another mkey with RO support */
 	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write)) {
@@ -157,8 +157,8 @@ int mlx5_data_direct_create_resources(struct mlx5_ib_dev *dev)
 		err = mlx5_core_create_mkey(mdev, &mkey, in, inlen);
 		/* RO is defined as best effort */
 		if (!err) {
-			dev->ddr.mkey_ro = mkey;
-			dev->ddr.mkey_ro_valid = true;
+			dev->data_direct->mkey_ro = mkey;
+			dev->data_direct->mkey_ro_valid = true;
 		}
 	}
 
@@ -174,38 +174,25 @@ int mlx5_data_direct_create_resources(struct mlx5_ib_dev *dev)
 
 void mlx5_data_direct_free_resources(struct mlx5_ib_dev *dev)
 {
-	if (dev->ddr.mkey_ro_valid)
-		mlx5_core_destroy_mkey(dev->mdev, dev->ddr.mkey_ro);
+	if (dev->data_direct->mkey_ro_valid)
+		mlx5_core_destroy_mkey(dev->mdev, dev->data_direct->mkey_ro);
 
-	mlx5_core_destroy_mkey(dev->mdev, dev->ddr.mkey);
-	mlx5_core_dealloc_pd(dev->mdev, dev->ddr.pdn);
+	mlx5_core_destroy_mkey(dev->mdev, dev->data_direct->mkey);
+	mlx5_core_dealloc_pd(dev->mdev, dev->data_direct->pdn);
 
-	memset(&dev->ddr, 0, sizeof(dev->ddr));
+	memset(dev->data_direct, 0, sizeof(*dev->data_direct));
 }
 
-static struct mlx5_data_direct_registration *
-mlx5_data_direct_get_reg(struct mlx5_ib_dev *ibdev)
-{
-	struct mlx5_data_direct_registration *reg;
-
-	list_for_each_entry(reg, &mlx5_data_direct_reg_list, list)
-		if (reg->ibdev == ibdev)
-			return reg;
-	return NULL;
-}
-
-static void mlx5_data_direct_bind(struct mlx5_ib_dev *ibdev,
+static void mlx5_data_direct_bind(struct mlx5_data_direct_registration *reg,
 				  struct mlx5_data_direct_dev *dev)
 {
-	WRITE_ONCE(ibdev->data_direct_dev, dev);
+	WRITE_ONCE(reg->dd.dev, dev);
 }
 
 static void
 mlx5_data_direct_do_unbind(struct mlx5_data_direct_registration *reg)
 {
-	struct mlx5_ib_dev *ibdev = reg->ibdev;
-
-	WRITE_ONCE(ibdev->data_direct_dev, NULL);
+	WRITE_ONCE(reg->dd.dev, NULL);
 	blocking_notifier_call_chain(&reg->users, MLX5_DATA_DIRECT_UNBIND,
 				     NULL);
 }
@@ -223,7 +210,6 @@ int mlx5_data_direct_init(struct mlx5_ib_dev *ibdev)
 	if (!reg)
 		return -ENOMEM;
 
-	reg->ibdev = ibdev;
 	BLOCKING_INIT_NOTIFIER_HEAD(&reg->users);
 
 	err = mlx5_data_direct_query_vuid(ibdev->mdev, reg->vuid);
@@ -234,10 +220,12 @@ int mlx5_data_direct_init(struct mlx5_ib_dev *ibdev)
 		return err;
 	}
 
+	ibdev->data_direct = &reg->dd;
+
 	mutex_lock(&mlx5_data_direct_mutex);
 	list_for_each_entry(dev, &mlx5_data_direct_dev_list, list) {
 		if (strcmp(dev->vuid, reg->vuid) == 0) {
-			mlx5_data_direct_bind(ibdev, dev);
+			mlx5_data_direct_bind(reg, dev);
 			break;
 		}
 	}
@@ -257,14 +245,14 @@ void mlx5_data_direct_cleanup(struct mlx5_ib_dev *ibdev)
 	if (!mlx5_data_direct_supported(ibdev->mdev))
 		return;
 
+	reg = container_of(ibdev->data_direct,
+			    struct mlx5_data_direct_registration, dd);
 	mutex_lock(&mlx5_data_direct_mutex);
-	reg = mlx5_data_direct_get_reg(ibdev);
-	if (reg) {
-		list_del(&reg->list);
-		mlx5_data_direct_do_unbind(reg);
-	}
+	list_del(&reg->list);
+	mlx5_data_direct_do_unbind(reg);
 	mutex_unlock(&mlx5_data_direct_mutex);
 
+	ibdev->data_direct = NULL;
 	kfree(reg);
 }
 
@@ -276,11 +264,10 @@ int mlx5_data_direct_register(struct mlx5_ib_dev *ibdev,
 	if (!mlx5_data_direct_supported(ibdev->mdev))
 		return 0;
 
-	mutex_lock(&mlx5_data_direct_mutex);
-	reg = mlx5_data_direct_get_reg(ibdev);
-	if (reg)
-		blocking_notifier_chain_register(&reg->users, nb);
-	mutex_unlock(&mlx5_data_direct_mutex);
+	reg = container_of(ibdev->data_direct,
+			    struct mlx5_data_direct_registration, dd);
+	blocking_notifier_chain_register(&reg->users, nb);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mlx5_data_direct_register);
@@ -293,11 +280,9 @@ void mlx5_data_direct_unregister(struct mlx5_ib_dev *ibdev,
 	if (!mlx5_data_direct_supported(ibdev->mdev))
 		return;
 
-	mutex_lock(&mlx5_data_direct_mutex);
-	reg = mlx5_data_direct_get_reg(ibdev);
-	if (reg)
-		blocking_notifier_chain_unregister(&reg->users, nb);
-	mutex_unlock(&mlx5_data_direct_mutex);
+	reg = container_of(ibdev->data_direct,
+			    struct mlx5_data_direct_registration, dd);
+	blocking_notifier_chain_unregister(&reg->users, nb);
 }
 EXPORT_SYMBOL_GPL(mlx5_data_direct_unregister);
 
@@ -308,7 +293,7 @@ static void mlx5_data_direct_dev_reg(struct mlx5_data_direct_dev *dev)
 	mutex_lock(&mlx5_data_direct_mutex);
 	list_for_each_entry(reg, &mlx5_data_direct_reg_list, list) {
 		if (strcmp(dev->vuid, reg->vuid) == 0)
-			mlx5_data_direct_bind(reg->ibdev, dev);
+			mlx5_data_direct_bind(reg, dev);
 	}
 
 	/* Add the data direct device to the global list, further IB devices may
diff --git a/drivers/infiniband/hw/mlx5/data_direct.h b/drivers/infiniband/hw/mlx5/data_direct.h
index f207239461bf..de2730f00852 100644
--- a/drivers/infiniband/hw/mlx5/data_direct.h
+++ b/drivers/infiniband/hw/mlx5/data_direct.h
@@ -23,13 +23,6 @@ struct mlx5_data_direct_dev {
 	struct list_head list;
 };
 
-struct mlx5_data_direct_resources {
-	u32 pdn;
-	u32 mkey;
-	u32 mkey_ro;
-	u8 mkey_ro_valid :1;
-};
-
 int mlx5_data_direct_create_resources(struct mlx5_ib_dev *dev);
 void mlx5_data_direct_free_resources(struct mlx5_ib_dev *dev);
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 8792e10340c5..6952170f472b 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1091,7 +1091,7 @@ struct mlx5_macsec {
 struct mlx5_ib_dev {
 	struct ib_device		ib_dev;
 	struct mlx5_core_dev		*mdev;
-	struct mlx5_data_direct_dev	*data_direct_dev;
+	struct mlx5_data_direct		*data_direct;
 	/* Protects data_direct_mr_list and serializes mr
 	 * registration/deregistration with data direct device unbind.
 	 */
@@ -1152,7 +1152,6 @@ struct mlx5_ib_dev {
 	u16 pkey_table_len;
 	u8 lag_ports;
 	struct mlx5_special_mkeys mkeys;
-	struct mlx5_data_direct_resources ddr;
 
 #ifdef CONFIG_MLX5_MACSEC
 	struct mlx5_macsec macsec;
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 1fc61a680f8a..5efe78cb34c1 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -587,7 +587,7 @@ static struct mlx5_ib_mr *reg_create(struct ib_pd *pd, struct ib_umem *umem,
 				      populate ? pd : dev->umrc.pd);
 	/* In case a data direct flow, overwrite the pdn field by its internal kernel PD */
 	if (umem->is_dmabuf && ksm_mode)
-		MLX5_SET(mkc, mkc, pd, dev->ddr.pdn);
+		MLX5_SET(mkc, mkc, pd, dev->data_direct->pdn);
 
 	MLX5_SET(mkc, mkc, free, !populate);
 	MLX5_SET(mkc, mkc, access_mode_1_0, access_mode);
@@ -997,7 +997,7 @@ reg_user_mr_dmabuf_by_data_direct(struct ib_pd *pd, u64 offset,
 		return ERR_PTR(-EOPNOTSUPP);
 
 	mutex_lock(&dev->data_direct_lock);
-	data_direct_dev = READ_ONCE(dev->data_direct_dev);
+	data_direct_dev = mlx5_data_direct_get_dev(dev->data_direct);
 	if (!data_direct_dev) {
 		ret = -EINVAL;
 		goto end;
@@ -1006,7 +1006,7 @@ reg_user_mr_dmabuf_by_data_direct(struct ib_pd *pd, u64 offset,
 	/* If no device's 'data direct mkey' with RO flags exists
 	 * mask it out accordingly.
 	 */
-	if (!dev->ddr.mkey_ro_valid)
+	if (!dev->data_direct->mkey_ro_valid)
 		access_flags &= ~IB_ACCESS_RELAXED_ORDERING;
 	crossed_mr = reg_user_mr_dmabuf(pd, &data_direct_dev->pdev->dev,
 					offset, length, virt_addr, fd,
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 1badec9bf527..7b9f73b76d0d 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -952,7 +952,7 @@ int mlx5_ib_init_dmabuf_mr(struct mlx5_ib_mr *mr, struct ib_pd *pd)
 	int ret;
 
 	if (mr->data_direct)
-		pdn = dev->ddr.pdn;
+		pdn = dev->data_direct->pdn;
 	else
 		pdn = to_mpd(pd)->pdn;
 
diff --git a/drivers/infiniband/hw/mlx5/std_types.c b/drivers/infiniband/hw/mlx5/std_types.c
index df949fa634c9..3828100fdc6c 100644
--- a/drivers/infiniband/hw/mlx5/std_types.c
+++ b/drivers/infiniband/hw/mlx5/std_types.c
@@ -203,7 +203,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_GET_DATA_DIRECT_SYSFS_PATH)(
 		return PTR_ERR(c);
 	dev = to_mdev(c->ibucontext.device);
 	mutex_lock(&dev->data_direct_lock);
-	data_direct_dev = READ_ONCE(dev->data_direct_dev);
+	data_direct_dev = mlx5_data_direct_get_dev(dev->data_direct);
 	if (!data_direct_dev) {
 		ret = -ENODEV;
 		goto end;
diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index 48cae5cc1c1b..1ca83d2d8a0b 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -760,12 +760,14 @@ static int _mlx5r_umr_update_mr_pas(struct mlx5_ib_mr *mr, unsigned int flags,
 		}
 
 		if (dd) {
+			struct mlx5_data_direct *mdd = dev->data_direct;
+
 			cur_ksm->va = cpu_to_be64(rdma_block_iter_dma_address(&biter));
 			if (mr->access_flags & IB_ACCESS_RELAXED_ORDERING &&
-			    dev->ddr.mkey_ro_valid)
-				cur_ksm->key = cpu_to_be32(dev->ddr.mkey_ro);
+			    mdd->mkey_ro_valid)
+				cur_ksm->key = cpu_to_be32(mdd->mkey_ro);
 			else
-				cur_ksm->key = cpu_to_be32(dev->ddr.mkey);
+				cur_ksm->key = cpu_to_be32(mdd->mkey);
 			if (mr->umem->is_dmabuf &&
 			    (flags & MLX5_IB_UPD_XLT_ZAP)) {
 				cur_ksm->va = 0;
@@ -810,7 +812,8 @@ int mlx5r_umr_update_data_direct_ksm_pas_range(struct mlx5_ib_mr *mr,
 	    !(flags & MLX5_IB_UPD_XLT_KEEP_PGSZ)))
 		return -EINVAL;
 
-	return _mlx5r_umr_update_mr_pas(mr, flags, mr_to_mdev(mr)->ddr.pdn,
+	return _mlx5r_umr_update_mr_pas(mr, flags,
+					mr_to_mdev(mr)->data_direct->pdn,
 					true, start_block, nblocks);
 }
 
diff --git a/include/linux/mlx5/data_direct.h b/include/linux/mlx5/data_direct.h
index 71f47547aebb..eaa2dc6bc607 100644
--- a/include/linux/mlx5/data_direct.h
+++ b/include/linux/mlx5/data_direct.h
@@ -6,10 +6,27 @@
 #ifndef _MLX5_DATA_DIRECT_H
 #define _MLX5_DATA_DIRECT_H
 
+#include <linux/compiler.h>
+
 struct mlx5_core_dev;
+struct mlx5_data_direct_dev;
 struct mlx5_ib_dev;
 struct notifier_block;
 
+struct mlx5_data_direct {
+	struct mlx5_data_direct_dev *dev;
+	u32 pdn;
+	u32 mkey;
+	u32 mkey_ro;
+	u8 mkey_ro_valid :1;
+};
+
+static inline struct mlx5_data_direct_dev *
+mlx5_data_direct_get_dev(struct mlx5_data_direct *dd)
+{
+	return dd ? READ_ONCE(dd->dev) : NULL;
+}
+
 int mlx5_data_direct_init(struct mlx5_ib_dev *ibdev);
 void mlx5_data_direct_cleanup(struct mlx5_ib_dev *ibdev);
 
-- 
2.44.0

