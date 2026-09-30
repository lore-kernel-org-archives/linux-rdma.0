Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012003.outbound.protection.outlook.com [52.101.48.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325D94D17AA;
	Wed, 30 Sep 2026 11:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790768670; cv=fail; b=UriGPgya8UsM3Z3ySXZgAlUKa8KYwPNOywsvzBzFUSZWJMSJGoU9rSXDdbgUZr8K0bjiSoM6VZzi9R7QTtqqDaAPqJqztODpEGKJlQpdZqudcLTavWmuIIpIXTJ5X6NODXqhVXUdO3bqyk/kyh9XYYI73i2ff2fjXqEhmzJLA4w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790768670; c=relaxed/simple;
	bh=ORT3i5tKcExiFYj/PkptrP+CgSqeNrUuTbpYCr5xQqc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DqCd3Bla3AQ9jQ7HxYUkadkaedI2Qmr07IkxdDfrl4AZcBxOfuwhNX7Nl4A9W9MKp7W+wl/J81kbJXZ7JpTjhyiPsqw3Gd66Wkv+p0K19L46RrVHTxESbwSVta6uEK4EPZBcVmHHYfPiVCvteVUOylbdqeSSJv/Bhfsf+Aot5H4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BDqsrg2p; arc=fail smtp.client-ip=52.101.48.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BDqsrg2p"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wZclB9dQSN2l+9kxr34Gyl9r1qPTEk9EioovcgMImvKb1aBDpXVzZGP/GUI+nfD5VvOscR7QE9u/8qg69QJmuoMVhyaxr9koVwaXa/TJUaWCC4+gK7a1sWvkLzDpH39YUy7ZfkpHHnaTG6R/mRXSu35OJXZZ0QfA2IDr5sZXHTVbeu+w3VYpBsPa48zzCWqJFS6H6GR9YW1IQmwOCl5X95Ie6SzVgJQkhU1d0AI5GlYZrFxgFJe44qhL9kZH87Yt/taPsEH8wdARZMtWBzppQ7yaAvjasJoZMy6vuT9+XSFeMKzhjN3tW1QMPS4Yxdkfw6gsiu84e1hrbPWeFYv5/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BbwoOHz7t0q0Pd3QJzWwpQ254haD2l5BzFU9RFNacI0=;
 b=immqGSJXAVcrk6xZLo1rxeklPCV7OOld8g4qy7GH6o4eP+oEfF1K0I+sgHJYKJKvgtI72IH7QtrIlP9FP6zasKGK+tCdU7TK9buWNakGX7u9wLoQ7jU5RR0HViYZEd7nPB7xKf0+rDub64447LppMOM5jv8EzEfpTWoub8zhvG2R43Uz6SjrTRW6L4YUJClIhAX3IicW10X50wEYPg45TWvRGN6PabdLAdcaXyd6cL4YVYFNSaSNDPWUzn8x6yvkkffFPOsg5kuHiKCV9TEniVGcSJYLHl7cCnrNgWtd1MFJkU07hf7M8YMjs3EUca/lDiyoey6UHpQ3Tpf7Ywc+Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BbwoOHz7t0q0Pd3QJzWwpQ254haD2l5BzFU9RFNacI0=;
 b=BDqsrg2pPJeAcfTyxAtXd+k7V61QQvuns1CIx+0grnVsBEjPjNlcQy+PFInnIwR5X8SxME0L/1J2UwOlOZbgfQi7YXJnpdCW9qYv9Gqk0Qte03UzNDVMVYogdya63En0e7vsjE6buKoW3JWXg3Di7VgY7dPJ54qLJrSLHWB13g0DIyubw5SYG7e2X+i/G55klpXpSME/PrIqPye+GjQIhTOu7eLOKs4dAEIYj25rknZRitbohEUJd6mG1sDpq9Ax2uIj6aO7eJq+6SM2HUQQHCnLSRXlIwKsD2AA/XNOzcXtoYeysMw/Jz2ByiElWaM28JQBN66JSjQCEcAhv/cwrw==
Received: from CH2PR14CA0054.namprd14.prod.outlook.com (2603:10b6:610:56::34)
 by BY5PR12MB4306.namprd12.prod.outlook.com (2603:10b6:a03:206::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Wed, 30 Sep
 2026 11:44:17 +0000
Received: from CH1PEPF0000AD80.namprd04.prod.outlook.com
 (2603:10b6:610:56:cafe::11) by CH2PR14CA0054.outlook.office365.com
 (2603:10b6:610:56::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Wed,
 30 Sep 2026 11:44:17 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH1PEPF0000AD80.mail.protection.outlook.com (10.167.244.90) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 11:44:17 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 04:44:02 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 04:44:02 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 30
 Sep 2026 04:43:58 -0700
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
Subject: [PATCH mlx5-next V2 08/10] RDMA/mlx5: Consolidate data direct state into one object
Date: Wed, 30 Sep 2026 14:42:25 +0300
Message-ID: <20260930114227.139274-9-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD80:EE_|BY5PR12MB4306:EE_
X-MS-Office365-Filtering-Correlation-Id: b62a7785-50d6-4ce2-3096-08df1ee828cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|36860700016|82310400026|11063799006|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Au2I3+z7RY1/EI3zFf7fbcSEUamvIQLAA3OUaOY7SoXnb5CEVyrmc+JZkcWHxaDV6Ul2etl7R113sN8OhJxBin12r8bYep5LTewOOH/p19qLib9ay6G2vnilcM3w5XCOqy1XHVbKvd4UJdy6ITHURLHMLDU6npUWrNOEpaTcZh+NYUSs7o3wllVkaEEF6HbQLp5SPxsLLrC1ETpUmdgtCPnhmSdz7aqozwZ0Uf2IVmXNd7ChxMdUkuxmurHwnZYkFwF3pp+lZVmbvziMxpnttAOM1em5Zx/PNOj3DORO6LEraBxH1R+iYt4DNJdLrnj5GLtdWjRBoAANuwJIFPZRBz4AdU0BGYSBEfTeDGMnIsKLszYlZI7fXM6gJhDzBv0QC/pUM/ECqxVeKWq6or6awF8OviK6PrjVppYJZ9oDDcvU+NljD+6fTIPDV+h/eiTsL1LX4VMyq6liBke7d40741qHISOFZfKAKjlhXHxkdkfqEIjUsqD3SIi2kdgdwBPMxruCS3tNVDSMiJLnE4+C2NvfzYhrSxZlglrDxbLBrUvwuCu5QKNiKrLeRMPXsO7Ne8zUnmwkaRrrptEPY2nJsi4v4yirLCB8z6Zr0yjzPIl+t3SPBl90thWDyz6Nj+tMxz87ftR5U/OGrwQz3K0F28zT7FCsiPLET2tzJuo2/jQh6L71uMHDj0+31K5lYbml1aHLR8vE5yzzBjoQQ+1njg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(36860700016)(82310400026)(11063799006)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nZlL+9DM33GRwWdwmjxHiYBiCpPq4gxgydxC7pS9PslWD+zoC+8patKg+S+HhZJQU6rpfNpVptA2sCEzgM3+E1RrcBo7EwHh/i+0rDf4kAa7fl9EMPnfYrdgtig7ZIYTpZ3cRKpI5QxGWHT/UjbA76ovRk0fnOSkhf8DhtEXbjF4WEfcIO1a3pP9xhWmzbYjYq9meE1nLQYvXSzZEImHlpR10WmALtBKfff4um1m9Pof5TxugHYHx6LXp8mPaBbTVEt4pGf8IZuEnkxWCrz2yu7MHH5+7pErKGNTqPdkRGd/MTAbxyM7FrK2pCXigJrlOTO/P4iZJGKh2kLe2BPyA4Np8Re5dXYT45i5Jqoh1XguQ8uM6mj6mpItcd9OwieumSwVOkjXqtMpRypCtJ0lJkAdQizhwaw2q1FxIxAHJwl3jIXIOVaKA5hcGS9aKvlm
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 11:44:17.4172
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b62a7785-50d6-4ce2-3096-08df1ee828cf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD80.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4306

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

