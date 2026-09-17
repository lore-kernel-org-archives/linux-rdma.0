Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012010.outbound.protection.outlook.com [40.107.200.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5CB4DAF8C;
	Thu, 17 Sep 2026 11:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789643797; cv=fail; b=YK7eJsteKs9NcwMLDeNPWKs32ZxdGW6N75rYgn8zkuwIN6upaoZgcS8lsqGD+bq8dI3vJxRXqIluM07lqIXFPfc8IltsqJ6yrPXDOB6Bv+MAuPfaXdEMzTZ8OM5MieHPCZM6aGmjPrR6HgeZNlh5QJB8G4ZHd7nACAyraauKFY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789643797; c=relaxed/simple;
	bh=4XJIMa8dSvvFUVSBJf87FsdPJ1uHAXOvFbY2wHE667k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iRW2UG0UpzC6wI1erQD423ZEegyXO38SIPfym4Y2buOarduOkhDjKDFFMPxhVEYQtJP3PLky3uUGlvdpvG+CnMN+FQDO3P91PRfoEzhcPqjRKYTH2KcEWcDngww7k780U2MM0r8nnrGB9G18NKbe0BvWun7/64PIsQ+ySZXvdp4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kI/3nZsX; arc=fail smtp.client-ip=40.107.200.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kI/3nZsX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PJL7T/QHPk+r6JwAdrz0ujLnIXk4Xf7WOJR+8WPdQxItj0J4NbQhDKy7PGYTs4Adja7OKIuejUIvngB/IoqBVCNZiXOKsAKQZCBJNqZeCWEVVnONTIqA5xDNGFj/xbDwV1D0AYqk31ONGm+Tvt1VvgG7Srj8trX7V8L5+TxfXaSwu50EgP+vewS9bTn/NImBnezOOA2ghFecnQ8ZV9Njo/up7GmAVu+ySrU9MDmT/0F+3+4s2yY9o/5enDlblSFM+PkPzh5J15Zew0cXibpQbRAftH0BnPxfZXS0SrG+4PG/HTFag4WfM/49SUPew+pvB68xGDPzQWKHu0v8uvZM3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wyXJN7rRpQbGv4I42RDi4N2pDZW68MY97pzSSRTkNU8=;
 b=psJyqbhHWejKJweOl/GvnfRtcrMlxz0HTsM/CdtnSJeKUfOEIlr76QYkv6NUgX49MQrTT6SN6WxbmPAnqjDiCVSg3VaZoFw5jONv1VCZTvzzAPnhWESbAJ4Mz1qg52l0M+2dFyGm9peOQ24hRFOuxc6k/Dvnsh73qEt/93Rcs0IdouhwBlkgK+6RqgqziqCuGhD5sL4N3ZPdJPF8eKWpgKMl+oirSZ9U2VRcgK+a3BN/qftu6ITrUiwqNl6CNnUHUycmdZhCzhlhzdVkeaM+/yses7YWcG0KhU9VMzQNyxfQVz7Kh0iRyqxcS6dhxMoKkdWKNtJ7aclt5DUZxdcVFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wyXJN7rRpQbGv4I42RDi4N2pDZW68MY97pzSSRTkNU8=;
 b=kI/3nZsXDeYaZ9rPbLC6Z6fJPH3mHN7PMFynVmaPl0mMqnvKyrd9E0vH2JX+3YwSBdW/vqLoY63K8AreAZXyPK77kq0iAS5NucMYBxyvQHDf37JtJbaVlmcmPWQhVrM4cBhCjkDiPfGiLEEB9bXsmnu8U08FwLgRfIOB7OkbONsLs8D955GQj5jw+IhpToGAzJ0bOvKsYuqKXN1vISUNyD/qyksD4Yx4/kI1HLMSPvz3pLU8zVrRsTXpwuELH6y5kK6Okw3/nOUyu12xujVOOi2My3KaTx7o7FaReoxyeSI5nmVIx/CczpdmQzRYNh6oIKMtRAMEVbWoXnfrRFx6Bg==
Received: from BN0PR03CA0034.namprd03.prod.outlook.com (2603:10b6:408:e7::9)
 by PH7PR12MB5974.namprd12.prod.outlook.com (2603:10b6:510:1d9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Thu, 17 Sep
 2026 11:16:02 +0000
Received: from BN3PEPF00022BC6.namprd05.prod.outlook.com
 (2603:10b6:408:e7:cafe::7a) by BN0PR03CA0034.outlook.office365.com
 (2603:10b6:408:e7::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.12 via Frontend Transport; Thu,
 17 Sep 2026 11:16:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN3PEPF00022BC6.mail.protection.outlook.com (10.167.248.219) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Thu, 17 Sep 2026 11:16:01 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 04:15:45 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 17 Sep 2026 04:15:44 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Thu, 17 Sep 2026 04:15:41 -0700
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
Subject: [PATCH mlx5-next 10/10] mlx5: Move data direct implementation to mlx5_core
Date: Thu, 17 Sep 2026 14:14:22 +0300
Message-ID: <20260917111422.4054862-11-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BC6:EE_|PH7PR12MB5974:EE_
X-MS-Office365-Filtering-Correlation-Id: 7985e55a-7b43-4038-9271-08df14ad0ebb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|23010399003|82310400026|7416014|376014|10067099003|56012099006|11063799006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	3A6icbHC4ZW5Dx7Mpqg5bSWrbp3iZlC/vSoR8J7IMPP0mukMmA9laAKnU1kCQPE6EaXncx+rb8Ypnbi6FIeiAAGndZ1CAixhwMgIewF0n5Wty/oEJA5hydiNLSp2amk9h2dppd9dXi007MlEI3/mEGdZRLTXjg8yf8QO9LGGCURkIjUJfhEgpcMH715UK6AchobJ+Sn/uDI+wCFq6myaRTHbzlQITRMqXqt72Sm1THCkHuWoLPzm39wgksc8tmTwlTzK0uW6aTQHD3r2mPHzE+wHStP36m0oHOwSEAnmTu/VaLDQ7ODRC5sPvY6hOrFoSirYLy1FFJQovbEYAXLHmCCVzG7vulZhBvBf2r1T2RJzy/22P6qbPet5x1BV3O7lRhR5PZg8PRTeb7NX/PuBupX/NM6d9dtxwmsCnp1kPTAyeUAjsks6zBvARTPpmkQkQFMPK5rqqt4SYvvJ4FFAmjQQVY4Fdpujf+Y7tV3rGNaMuzw4Uv1Z6bOq4y6PD9xNFPVSDdxOaMOSqU4nF4wB58zZ1IbDzEyuCpaOtEMIqL8ai0QN37P2X6g9q9HhcJkcOpVrjkxoFdaf+QARFKOldMtQ+9V20TB74ON0IyxMegkdZRGss4NtyuSOOv3Gn5FaLq8kBB+1J0jfXY9WTheUJQ7JEAAoJ6pNRTB+G3eC4Kn3rW+40e/jO30x+1oTg3tGHnpF/fmi2892X425u27P+w==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(23010399003)(82310400026)(7416014)(376014)(10067099003)(56012099006)(11063799006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SoDBboZlv5mlPm9Hk/QWQGHA7RQ3RkYWLpHdJLjz1IDZyuXlu6CWvaYv1/TtwOaLOw0SzcmaU94m6iNfvMmrTCdPQkFOEtJMz2amtbrUhaaVZRnHllIv5RU9tqxwzob6hvNyqV8mL10rE/iUyZhHZW7bjf6TbfS6P24jbyCf2OoCtRy6hjGcca7NQbignLzT+6BFkDDhXB+QuKiwsXMxetP4op3XMqZtuecpcWole0jTD92Lx+0iqV6m0epBYbiNN39Re36bCV8RJCmflZgQXMkrTkTFvu1YRQSiiDdqoLlmz/QvsrC8LRTSCczuZ1MQmDdfKPkhnK5FwceMA1i7gSUDawgsZl2z34EBHF+czaTA9hUtf7CDoxowQ+eskY9WZYyOmf+Q1dDt9tfVudIt16Qxsyl0AC7FOy822wswWMFzdjSq1En+GZwxw3G0F7tF
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 11:16:01.7218
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7985e55a-7b43-4038-9271-08df14ad0ebb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BC6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5974

From: Dragos Tatulea <dtatulea@nvidia.com>

As data direct will also be used by netdev devices, move the data direct
code to mlx5_core. Now mlx5_core is responsible for data direct
initialization and resource creation.

Now data_direct is initialized in mlx5_load() before attaching consumers
and clean it up in mlx5_unload() after detaching them. The data direct
PCI driver is moved and registered in mlx5_core.

IB specific work stays in mlx5_ib: notifier registration, mutex
initialization and MR list initialization.

This patch has no functional changes.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/infiniband/hw/mlx5/Makefile           |  1 -
 drivers/infiniband/hw/mlx5/data_direct.h      | 29 ------
 drivers/infiniband/hw/mlx5/main.c             | 23 +----
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  3 +-
 drivers/infiniband/hw/mlx5/mr.c               |  7 +-
 drivers/infiniband/hw/mlx5/odp.c              |  2 +-
 drivers/infiniband/hw/mlx5/std_types.c        |  3 +-
 drivers/infiniband/hw/mlx5/umr.c              |  4 +-
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  2 +-
 .../mellanox/mlx5/core}/data_direct.c         | 91 ++++++++++---------
 .../net/ethernet/mellanox/mlx5/core/main.c    | 15 +++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  5 +
 include/linux/mlx5/data_direct.h              | 23 +++--
 include/linux/mlx5/driver.h                   |  2 +
 14 files changed, 97 insertions(+), 113 deletions(-)
 delete mode 100644 drivers/infiniband/hw/mlx5/data_direct.h
 rename drivers/{infiniband/hw/mlx5 => net/ethernet/mellanox/mlx5/core}/data_direct.c (79%)

diff --git a/drivers/infiniband/hw/mlx5/Makefile b/drivers/infiniband/hw/mlx5/Makefile
index dd7bb377f491..35afc7bc57d2 100644
--- a/drivers/infiniband/hw/mlx5/Makefile
+++ b/drivers/infiniband/hw/mlx5/Makefile
@@ -6,7 +6,6 @@ mlx5_ib-y := ah.o \
 	     cong.o \
 	     counters.o \
 	     cq.o \
-	     data_direct.o \
 	     dm.o \
 	     dmah.o \
 	     doorbell.o \
diff --git a/drivers/infiniband/hw/mlx5/data_direct.h b/drivers/infiniband/hw/mlx5/data_direct.h
deleted file mode 100644
index 49cdd407018a..000000000000
--- a/drivers/infiniband/hw/mlx5/data_direct.h
+++ /dev/null
@@ -1,29 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
-/*
- * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES. All rights reserved
- */
-
-#ifndef _MLX5_IB_DATA_DIRECT_H
-#define _MLX5_IB_DATA_DIRECT_H
-
-#include <linux/notifier.h>
-#include <linux/mlx5/data_direct.h>
-
-struct mlx5_core_dev;
-struct mlx5_ib_dev;
-
-enum mlx5_data_direct_event {
-	MLX5_DATA_DIRECT_UNBIND,
-};
-
-struct mlx5_data_direct_dev {
-	struct device *device;
-	struct pci_dev *pdev;
-	char *vuid;
-	struct list_head list;
-};
-
-int mlx5_data_direct_driver_register(void);
-void mlx5_data_direct_driver_unregister(void);
-
-#endif
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 941928a782bd..dd2a3996b14e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -52,7 +52,6 @@
 #include <rdma/mlx5_user_ioctl_cmds.h>
 #include <rdma/ib_ucaps.h>
 #include "macsec.h"
-#include "data_direct.h"
 #include "dmah.h"
 
 #define UVERBS_MODULE_NAME mlx5_ib
@@ -3962,20 +3961,9 @@ static int mlx5_ib_data_direct_init(struct mlx5_ib_dev *dev)
 	if (!mlx5_data_direct_supported(dev->mdev))
 		return 0;
 
-	ret = mlx5_data_direct_init(dev);
-	if (ret)
-		return ret;
-
 	INIT_LIST_HEAD(&dev->data_direct_mr_list);
 	dev->data_direct_nb.notifier_call = mlx5_ib_data_direct_event;
-	ret = mlx5_data_direct_register(dev, &dev->data_direct_nb);
-	if (ret)
-		goto err_register;
-
-	return ret;
-
-err_register:
-	mlx5_data_direct_cleanup(dev);
+	ret = mlx5_data_direct_register(dev->mdev, &dev->data_direct_nb);
 
 	return ret;
 }
@@ -3985,8 +3973,7 @@ static void mlx5_ib_data_direct_cleanup(struct mlx5_ib_dev *dev)
 	if (!mlx5_data_direct_supported(dev->mdev))
 		return;
 
-	mlx5_data_direct_unregister(dev, &dev->data_direct_nb);
-	mlx5_data_direct_cleanup(dev);
+	mlx5_data_direct_unregister(dev->mdev, &dev->data_direct_nb);
 }
 
 static int mlx5_ib_init_multiport_master(struct mlx5_ib_dev *dev)
@@ -5438,9 +5425,6 @@ static int __init mlx5_ib_init(void)
 	ret = mlx5r_rep_init();
 	if (ret)
 		goto rep_err;
-	ret = mlx5_data_direct_driver_register();
-	if (ret)
-		goto dd_err;
 	ret = auxiliary_driver_register(&mlx5r_mp_driver);
 	if (ret)
 		goto mp_err;
@@ -5453,8 +5437,6 @@ static int __init mlx5_ib_init(void)
 drv_err:
 	auxiliary_driver_unregister(&mlx5r_mp_driver);
 mp_err:
-	mlx5_data_direct_driver_unregister();
-dd_err:
 	mlx5r_rep_cleanup();
 rep_err:
 	mlx5_ib_qp_event_cleanup();
@@ -5466,7 +5448,6 @@ static int __init mlx5_ib_init(void)
 
 static void __exit mlx5_ib_cleanup(void)
 {
-	mlx5_data_direct_driver_unregister();
 	auxiliary_driver_unregister(&mlx5r_driver);
 	auxiliary_driver_unregister(&mlx5r_mp_driver);
 	mlx5r_rep_cleanup();
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 6952170f472b..1a3b9cb79184 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -24,7 +24,7 @@
 #include <rdma/mlx5_user_ioctl_cmds.h>
 #include <rdma/mlx5_user_ioctl_verbs.h>
 
-#include "data_direct.h"
+#include <linux/mlx5/data_direct.h>
 #include "srq.h"
 #include "qp.h"
 #include "macsec.h"
@@ -1091,7 +1091,6 @@ struct mlx5_macsec {
 struct mlx5_ib_dev {
 	struct ib_device		ib_dev;
 	struct mlx5_core_dev		*mdev;
-	struct mlx5_data_direct		*data_direct;
 	/* Protects data_direct_mr_list and serializes mr
 	 * registration/deregistration with data direct device unbind.
 	 */
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 5efe78cb34c1..7463b36a36b6 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -44,7 +44,6 @@
 #include "dm.h"
 #include "mlx5_ib.h"
 #include "umr.h"
-#include "data_direct.h"
 #include "dmah.h"
 
 static int mkey_max_umr_order(struct mlx5_ib_dev *dev)
@@ -587,7 +586,7 @@ static struct mlx5_ib_mr *reg_create(struct ib_pd *pd, struct ib_umem *umem,
 				      populate ? pd : dev->umrc.pd);
 	/* In case a data direct flow, overwrite the pdn field by its internal kernel PD */
 	if (umem->is_dmabuf && ksm_mode)
-		MLX5_SET(mkc, mkc, pd, dev->data_direct->pdn);
+		MLX5_SET(mkc, mkc, pd, dev->mdev->data_direct->pdn);
 
 	MLX5_SET(mkc, mkc, free, !populate);
 	MLX5_SET(mkc, mkc, access_mode_1_0, access_mode);
@@ -997,7 +996,7 @@ reg_user_mr_dmabuf_by_data_direct(struct ib_pd *pd, u64 offset,
 		return ERR_PTR(-EOPNOTSUPP);
 
 	mutex_lock(&dev->data_direct_lock);
-	data_direct_dev = mlx5_data_direct_get_dev(dev->data_direct);
+	data_direct_dev = mlx5_data_direct_get_dev(dev->mdev->data_direct);
 	if (!data_direct_dev) {
 		ret = -EINVAL;
 		goto end;
@@ -1006,7 +1005,7 @@ reg_user_mr_dmabuf_by_data_direct(struct ib_pd *pd, u64 offset,
 	/* If no device's 'data direct mkey' with RO flags exists
 	 * mask it out accordingly.
 	 */
-	if (!dev->data_direct->mkey_ro_valid)
+	if (!dev->mdev->data_direct->mkey_ro_valid)
 		access_flags &= ~IB_ACCESS_RELAXED_ORDERING;
 	crossed_mr = reg_user_mr_dmabuf(pd, &data_direct_dev->pdev->dev,
 					offset, length, virt_addr, fd,
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 7b9f73b76d0d..2e9a704acc44 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -952,7 +952,7 @@ int mlx5_ib_init_dmabuf_mr(struct mlx5_ib_mr *mr, struct ib_pd *pd)
 	int ret;
 
 	if (mr->data_direct)
-		pdn = dev->data_direct->pdn;
+		pdn = dev->mdev->data_direct->pdn;
 	else
 		pdn = to_mpd(pd)->pdn;
 
diff --git a/drivers/infiniband/hw/mlx5/std_types.c b/drivers/infiniband/hw/mlx5/std_types.c
index 3828100fdc6c..b705b88dc917 100644
--- a/drivers/infiniband/hw/mlx5/std_types.c
+++ b/drivers/infiniband/hw/mlx5/std_types.c
@@ -10,7 +10,6 @@
 #include <linux/mlx5/eswitch.h>
 #include <linux/mlx5/vport.h>
 #include "mlx5_ib.h"
-#include "data_direct.h"
 
 #define UVERBS_MODULE_NAME mlx5_ib
 #include <rdma/uverbs_named_ioctl.h>
@@ -203,7 +202,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_GET_DATA_DIRECT_SYSFS_PATH)(
 		return PTR_ERR(c);
 	dev = to_mdev(c->ibucontext.device);
 	mutex_lock(&dev->data_direct_lock);
-	data_direct_dev = mlx5_data_direct_get_dev(dev->data_direct);
+	data_direct_dev = mlx5_data_direct_get_dev(dev->mdev->data_direct);
 	if (!data_direct_dev) {
 		ret = -ENODEV;
 		goto end;
diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index 1ca83d2d8a0b..a3bb8d03fd35 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -760,7 +760,7 @@ static int _mlx5r_umr_update_mr_pas(struct mlx5_ib_mr *mr, unsigned int flags,
 		}
 
 		if (dd) {
-			struct mlx5_data_direct *mdd = dev->data_direct;
+			struct mlx5_data_direct *mdd = dev->mdev->data_direct;
 
 			cur_ksm->va = cpu_to_be64(rdma_block_iter_dma_address(&biter));
 			if (mr->access_flags & IB_ACCESS_RELAXED_ORDERING &&
@@ -813,7 +813,7 @@ int mlx5r_umr_update_data_direct_ksm_pas_range(struct mlx5_ib_mr *mr,
 		return -EINVAL;
 
 	return _mlx5r_umr_update_mr_pas(mr, flags,
-					mr_to_mdev(mr)->data_direct->pdn,
+					mr_to_mdev(mr)->mdev->data_direct->pdn,
 					true, start_block, nblocks);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 19e50f0d55af..a1871259210d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -18,7 +18,7 @@ mlx5_core-y :=	main.o cmd.o debugfs.o fw.o eq.o uar.o pagealloc.o \
 		lib/devcom.o lib/pci_vsc.o lib/dm.o lib/fs_ttc.o diag/fs_tracepoint.o \
 		diag/fw_tracer.o diag/crdump.o devlink.o sh_devlink.o diag/rsc_dump.o \
 		diag/reporter_vnic.o fw_reset.o qos.o lib/tout.o lib/aso.o wc.o fs_pool.o \
-		lib/nv_param.o
+		lib/nv_param.o data_direct.o
 
 #
 # Netdev basic
diff --git a/drivers/infiniband/hw/mlx5/data_direct.c b/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
similarity index 79%
rename from drivers/infiniband/hw/mlx5/data_direct.c
rename to drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
index 3878c4aebb2c..67717110feab 100644
--- a/drivers/infiniband/hw/mlx5/data_direct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
@@ -3,11 +3,14 @@
  * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES. All rights reserved
  */
 
-#include "mlx5_ib.h"
+#include <linux/list.h>
+#include <linux/mlx5/driver.h>
+#include <linux/mlx5/data_direct.h>
+#include <linux/mlx5/mlx5_ifc.h>
+#include <linux/pci.h>
+#include <linux/slab.h>
 
-#include <linux/notifier.h>
-
-#include "data_direct.h"
+#include "mlx5_core.h"
 
 static LIST_HEAD(mlx5_data_direct_dev_list);
 static LIST_HEAD(mlx5_data_direct_reg_list);
@@ -103,10 +106,9 @@ static int mlx5_data_direct_set_dma_caps(struct pci_dev *pdev)
 	return 0;
 }
 
-static int mlx5_data_direct_create_resources(struct mlx5_ib_dev *dev)
+static int mlx5_data_direct_create_resources(struct mlx5_core_dev *mdev)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
-	struct mlx5_core_dev *mdev = dev->mdev;
 	bool ro_supp = false;
 	void *mkc;
 	u32 mkey;
@@ -139,16 +141,16 @@ static int mlx5_data_direct_create_resources(struct mlx5_ib_dev *dev)
 	if (err)
 		goto err_mkey;
 
-	dev->data_direct->mkey = mkey;
-	dev->data_direct->pdn = pdn;
+	mdev->data_direct->mkey = mkey;
+	mdev->data_direct->pdn = pdn;
 
 	/* create another mkey with RO support */
-	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write)) {
+	if (MLX5_CAP_GEN(mdev, relaxed_ordering_write)) {
 		MLX5_SET(mkc, mkc, relaxed_ordering_write, 1);
 		ro_supp = true;
 	}
 
-	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read)) {
+	if (MLX5_CAP_GEN(mdev, relaxed_ordering_read)) {
 		MLX5_SET(mkc, mkc, relaxed_ordering_read, 1);
 		ro_supp = true;
 	}
@@ -157,8 +159,8 @@ static int mlx5_data_direct_create_resources(struct mlx5_ib_dev *dev)
 		err = mlx5_core_create_mkey(mdev, &mkey, in, inlen);
 		/* RO is defined as best effort */
 		if (!err) {
-			dev->data_direct->mkey_ro = mkey;
-			dev->data_direct->mkey_ro_valid = true;
+			mdev->data_direct->mkey_ro = mkey;
+			mdev->data_direct->mkey_ro_valid = true;
 		}
 	}
 
@@ -172,13 +174,15 @@ static int mlx5_data_direct_create_resources(struct mlx5_ib_dev *dev)
 	return err;
 }
 
-static void mlx5_data_direct_free_resources(struct mlx5_ib_dev *dev)
+static void mlx5_data_direct_free_resources(struct mlx5_core_dev *mdev)
 {
-	if (dev->data_direct->mkey_ro_valid)
-		mlx5_core_destroy_mkey(dev->mdev, dev->data_direct->mkey_ro);
+	struct mlx5_data_direct *data_direct = mdev->data_direct;
+
+	if (data_direct->mkey_ro_valid)
+		mlx5_core_destroy_mkey(mdev, data_direct->mkey_ro);
 
-	mlx5_core_destroy_mkey(dev->mdev, dev->data_direct->mkey);
-	mlx5_core_dealloc_pd(dev->mdev, dev->data_direct->pdn);
+	mlx5_core_destroy_mkey(mdev, data_direct->mkey);
+	mlx5_core_dealloc_pd(mdev, data_direct->pdn);
 }
 
 static void mlx5_data_direct_bind(struct mlx5_data_direct_registration *reg,
@@ -195,13 +199,13 @@ mlx5_data_direct_do_unbind(struct mlx5_data_direct_registration *reg)
 				     NULL);
 }
 
-int mlx5_data_direct_init(struct mlx5_ib_dev *ibdev)
+int mlx5_data_direct_init(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_data_direct_registration *reg;
 	struct mlx5_data_direct_dev *dev;
 	int err;
 
-	if (!mlx5_data_direct_supported(ibdev->mdev))
+	if (!mlx5_data_direct_supported(mdev))
 		return 0;
 
 	reg = kzalloc_obj(*reg);
@@ -210,17 +214,18 @@ int mlx5_data_direct_init(struct mlx5_ib_dev *ibdev)
 
 	BLOCKING_INIT_NOTIFIER_HEAD(&reg->users);
 
-	err = mlx5_data_direct_query_vuid(ibdev->mdev, reg->vuid);
+	err = mlx5_data_direct_query_vuid(mdev, reg->vuid);
 	if (err) {
-		mlx5_ib_warn(ibdev, "Failed to query VUID, disabling data direct, err=%d\n",
-			     err);
+		mlx5_core_warn(mdev,
+			       "Failed to query VUID, disabling data direct, err=%d\n",
+			       err);
 		kfree(reg);
-		return err;
+		return -EINVAL;
 	}
 
-	ibdev->data_direct = &reg->dd;
+	mdev->data_direct = &reg->dd;
 
-	err = mlx5_data_direct_create_resources(ibdev);
+	err = mlx5_data_direct_create_resources(mdev);
 	if (err)
 		goto err_resources;
 
@@ -233,63 +238,63 @@ int mlx5_data_direct_init(struct mlx5_ib_dev *ibdev)
 	}
 
 	/* Add the registration to its global list, to be used upon bind/unbind
-	 * of its affiliated data direct device
+	 * of its affiliated data direct device.
 	 */
 	list_add_tail(&reg->list, &mlx5_data_direct_reg_list);
 	mutex_unlock(&mlx5_data_direct_mutex);
 	return 0;
 
 err_resources:
-	ibdev->data_direct = NULL;
+	mdev->data_direct = NULL;
 	kfree(reg);
 	return err;
 }
 
-void mlx5_data_direct_cleanup(struct mlx5_ib_dev *ibdev)
+void mlx5_data_direct_cleanup(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_data_direct_registration *reg;
 
-	if (!mlx5_data_direct_supported(ibdev->mdev))
+	if (!mlx5_data_direct_supported(mdev))
 		return;
 
-	reg = container_of(ibdev->data_direct,
-			    struct mlx5_data_direct_registration, dd);
+	reg = container_of(mdev->data_direct,
+			   struct mlx5_data_direct_registration, dd);
 	mutex_lock(&mlx5_data_direct_mutex);
 	list_del(&reg->list);
 	mlx5_data_direct_do_unbind(reg);
 	mutex_unlock(&mlx5_data_direct_mutex);
 
-	mlx5_data_direct_free_resources(ibdev);
-	ibdev->data_direct = NULL;
+	mlx5_data_direct_free_resources(mdev);
+	mdev->data_direct = NULL;
 	kfree(reg);
 }
 
-int mlx5_data_direct_register(struct mlx5_ib_dev *ibdev,
+int mlx5_data_direct_register(struct mlx5_core_dev *mdev,
 			      struct notifier_block *nb)
 {
 	struct mlx5_data_direct_registration *reg;
 
-	if (!mlx5_data_direct_supported(ibdev->mdev))
+	if (!mlx5_data_direct_supported(mdev))
 		return 0;
 
-	reg = container_of(ibdev->data_direct,
-			    struct mlx5_data_direct_registration, dd);
+	reg = container_of(mdev->data_direct,
+			   struct mlx5_data_direct_registration, dd);
 	blocking_notifier_chain_register(&reg->users, nb);
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mlx5_data_direct_register);
 
-void mlx5_data_direct_unregister(struct mlx5_ib_dev *ibdev,
+void mlx5_data_direct_unregister(struct mlx5_core_dev *mdev,
 				 struct notifier_block *nb)
 {
 	struct mlx5_data_direct_registration *reg;
 
-	if (!mlx5_data_direct_supported(ibdev->mdev))
+	if (!mlx5_data_direct_supported(mdev))
 		return;
 
-	reg = container_of(ibdev->data_direct,
-			    struct mlx5_data_direct_registration, dd);
+	reg = container_of(mdev->data_direct,
+			   struct mlx5_data_direct_registration, dd);
 	blocking_notifier_chain_unregister(&reg->users, nb);
 }
 EXPORT_SYMBOL_GPL(mlx5_data_direct_unregister);
@@ -304,8 +309,8 @@ static void mlx5_data_direct_dev_reg(struct mlx5_data_direct_dev *dev)
 			mlx5_data_direct_bind(reg, dev);
 	}
 
-	/* Add the data direct device to the global list, further IB devices may
-	 * use it later as well
+	/* Add the data direct device to the global list, further mlx5 devices
+	 * may use it later as well.
 	 */
 	list_add_tail(&dev->list, &mlx5_data_direct_dev_list);
 	mutex_unlock(&mlx5_data_direct_mutex);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 643b4aac2033..34f0375b6851 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -40,6 +40,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/mlx5/driver.h>
+#include <linux/mlx5/data_direct.h>
 #include <linux/mlx5/cq.h>
 #include <linux/mlx5/qp.h>
 #include <linux/debugfs.h>
@@ -1339,8 +1340,14 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 	if (err)
 		goto err_traps_reg;
 
+	err = mlx5_data_direct_init(dev);
+	if (err)
+		goto err_data_direct;
+
 	return 0;
 
+err_data_direct:
+	mlx5_devlink_traps_unregister(priv_to_devlink(dev));
 err_traps_reg:
 	mlx5_sf_dev_table_destroy(dev);
 	mlx5_sriov_detach(dev);
@@ -1371,6 +1378,7 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 
 static void mlx5_unload(struct mlx5_core_dev *dev)
 {
+	mlx5_data_direct_cleanup(dev);
 	mlx5_devlink_traps_unregister(priv_to_devlink(dev));
 	mlx5_vhca_event_stop(dev);
 	mlx5_sf_dev_table_destroy(dev);
@@ -2360,6 +2368,10 @@ static int __init mlx5_init(void)
 	if (err)
 		goto err_sf;
 
+	err = mlx5_data_direct_driver_register();
+	if (err)
+		goto err_dd;
+
 	err = pci_register_driver(&mlx5_core_driver);
 	if (err)
 		goto err_pci;
@@ -2367,6 +2379,8 @@ static int __init mlx5_init(void)
 	return 0;
 
 err_pci:
+	mlx5_data_direct_driver_unregister();
+err_dd:
 	mlx5_sf_driver_unregister();
 err_sf:
 	mlx5e_cleanup();
@@ -2378,6 +2392,7 @@ static int __init mlx5_init(void)
 static void __exit mlx5_cleanup(void)
 {
 	pci_unregister_driver(&mlx5_core_driver);
+	mlx5_data_direct_driver_unregister();
 	mlx5_sf_driver_unregister();
 	mlx5e_cleanup();
 	mlx5_unregister_debugfs();
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 09e669f83dba..fd93530a3938 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -530,4 +530,9 @@ static inline bool mlx5_pcie_cong_event_supported(struct mlx5_core_dev *dev)
 
 	return true;
 }
+
+int mlx5_data_direct_init(struct mlx5_core_dev *mdev);
+void mlx5_data_direct_cleanup(struct mlx5_core_dev *mdev);
+int mlx5_data_direct_driver_register(void);
+void mlx5_data_direct_driver_unregister(void);
 #endif /* __MLX5_CORE_H__ */
diff --git a/include/linux/mlx5/data_direct.h b/include/linux/mlx5/data_direct.h
index eaa2dc6bc607..4cff5ff5489d 100644
--- a/include/linux/mlx5/data_direct.h
+++ b/include/linux/mlx5/data_direct.h
@@ -7,11 +7,23 @@
 #define _MLX5_DATA_DIRECT_H
 
 #include <linux/compiler.h>
+#include <linux/list.h>
 
+struct device;
 struct mlx5_core_dev;
-struct mlx5_data_direct_dev;
-struct mlx5_ib_dev;
 struct notifier_block;
+struct pci_dev;
+
+enum mlx5_data_direct_event {
+	MLX5_DATA_DIRECT_UNBIND,
+};
+
+struct mlx5_data_direct_dev {
+	struct device *device;
+	struct pci_dev *pdev;
+	char *vuid;
+	struct list_head list;
+};
 
 struct mlx5_data_direct {
 	struct mlx5_data_direct_dev *dev;
@@ -27,12 +39,9 @@ mlx5_data_direct_get_dev(struct mlx5_data_direct *dd)
 	return dd ? READ_ONCE(dd->dev) : NULL;
 }
 
-int mlx5_data_direct_init(struct mlx5_ib_dev *ibdev);
-void mlx5_data_direct_cleanup(struct mlx5_ib_dev *ibdev);
-
-int mlx5_data_direct_register(struct mlx5_ib_dev *ibdev,
+int mlx5_data_direct_register(struct mlx5_core_dev *mdev,
 			      struct notifier_block *nb);
-void mlx5_data_direct_unregister(struct mlx5_ib_dev *ibdev,
+void mlx5_data_direct_unregister(struct mlx5_core_dev *mdev,
 				 struct notifier_block *nb);
 
 #endif
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index ee29f95ead18..ed348a82576e 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -707,6 +707,7 @@ struct mlx5_rsvd_gids {
 
 struct mlx5_clock;
 struct mlx5_clock_dev_state;
+struct mlx5_data_direct;
 struct mlx5_dm;
 struct mlx5_fw_tracer;
 struct mlx5_vxlan;
@@ -801,6 +802,7 @@ struct mlx5_core_dev {
 	/* sync write combining state */
 	struct mutex wc_state_lock;
 	struct devlink *shd;
+	struct mlx5_data_direct *data_direct;
 };
 
 struct mlx5_db {
-- 
2.44.0

