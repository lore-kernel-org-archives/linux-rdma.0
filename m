Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012011.outbound.protection.outlook.com [52.101.43.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7960D4C9E02;
	Wed, 30 Sep 2026 11:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790768682; cv=fail; b=k4DQgTeJer0V1ZgeEcOD3kU9XipHsKtPhCVdyosLtvvt4Ex2AIH624vtygNXtPNmmVVtHnoNo2/RQMQL3gpZrKQCtkFtCAYU+F1cxkEp3i42vpakmS2M1PUVYCqW7EggeSNYcbAl06z05FGXJ3ZQ376itaoMVfXX+If0PSyQTE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790768682; c=relaxed/simple;
	bh=xDt7VBwEHJ8sVyow+xHHNralQh4ik/bfoaZW2It6MGU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PsfuRFa54YAM7HbeT6qgvYzC1ywNlbjFVXQ6+UV0VEOqgKKFiK6+1/UNNzZlc9naQLl5cgZaCovIvI93jqjPqXFZAciofoRPwNALXlBQRIPCRWSo0T2Uxc0zPShjGuTbgPxFL62VCAwGk3b/fL8A/imvXy8aDCvdz44152Whg0E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=brvEI7SX; arc=fail smtp.client-ip=52.101.43.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="brvEI7SX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rpttzu5xZUOOzG4etSdAK/kDX/XHNlnMbeZFcP4c4cnRXrYuzb3bsa34aUino9vxZzP1UOQ+SZMmYPdUGhMJjDl1WLUO/aJQvc/z8tuXmtJgIwXFFI0TehtgtEfnP+L7+jR/N1Zu49MZGg5X/FHAYaNQcT0p6Th0S4Aa8Y//AtXu4HvSBgHcmZcwNsCVn9TYS5mboEWeoaXF1SonLpiR2JJj+UkIseirx07p+xcDI+5KtIeDxxeAetFg5cKxSw86utAQEf4VCttILe4B5N1yQhaQyTJIktaBoBVyvIuFgekbCmJCsXdjbVk8nZsPJwQzUL/Lkf6lZJbaZEwdi7ipOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n8wRkIx7cFZfDhF6CDtQn2+44SAQ/jasRo9G7D/p0Gg=;
 b=Yf3Sblyo0IGMVEy4HolGGjWuOe8FJKb292HAdf2K1+bkmAh7f4Bbto40rMolVdoDl2cZfvTsuONwfTf6BDuE1cii6kjP2gtIxOz84m3+Cq4mL0rhhJimM3Ya+NU9md7MVjbtb+dF94Cb/o8jORZ0RDnmfzk6d9+vnNGq0JownnUiqZUH7AhEpOQlnBrhSCBfPXkE3HjJhm6C5oq//t2R5ZLQbEPO1SNEsiBivAqm6qixhwOUM+E6ZEMixAHlLewLmB1NJKxHUWAh3FJn5R2YtPBjwO24GnUHnqi302B8DbiEdOGhafLdaze9tQ4l80SXBE+yoCcurpvyluJYifUpHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n8wRkIx7cFZfDhF6CDtQn2+44SAQ/jasRo9G7D/p0Gg=;
 b=brvEI7SXRcbTwvqczbXGhfOxSUnEF3m74a6Zo8YnQdzOx4vGs1eY3nZBY4Q7NAL2gZG0f8nKSKqmOugTUYMFAlKOOb1AjEFdLFp1WcsRbcWydq0nSQJjIDrwTV1jzT92y/jvEr7CxUIfEPpdPV9SUm80ysz8n7CJD6vW0wXlLDmgNx3xerlbmZn14TP7HkmyTi6TO1uDLAWsq3uA+/qAJAkcu3ahJQv9NGFkZ2Z7tFmQ3wTvLLhL8IBg4IRG4u2OUK8FasDqoA2G4xp6ykJImH8R3f0hwTp5UPEjSt6QfahTiWL0XffgIu8dsFTcu4hB79J0sdqd3Noby4z6OL+f9w==
Received: from BN9PR03CA0363.namprd03.prod.outlook.com (2603:10b6:408:f7::8)
 by DSSPR12MB999237.namprd12.prod.outlook.com (2603:10b6:8:377::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.16; Wed, 30 Sep
 2026 11:44:32 +0000
Received: from BL6PEPF00020E64.namprd04.prod.outlook.com
 (2603:10b6:408:f7:cafe::2) by BN9PR03CA0363.outlook.office365.com
 (2603:10b6:408:f7::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.23 via Frontend Transport; Wed,
 30 Sep 2026 11:44:31 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF00020E64.mail.protection.outlook.com (10.167.249.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 11:44:30 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 04:44:12 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 04:44:11 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 30
 Sep 2026 04:44:07 -0700
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
Subject: [PATCH mlx5-next V2 10/10] mlx5: Move data direct implementation to mlx5_core
Date: Wed, 30 Sep 2026 14:42:27 +0300
Message-ID: <20260930114227.139274-11-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E64:EE_|DSSPR12MB999237:EE_
X-MS-Office365-Filtering-Correlation-Id: ace6140b-f820-421f-2580-08df1ee830eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|23010399003|36860700016|18002099003|22082099003|6133799003|10067099003|260925022911599003|260925021311599003|260925021911599003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	Q6tDmwWRy72Bn2H8WhFsOhSCFA+au+HlajbmxcVl3PRfn8825dFT/qWeiu+Ei51kakKRdHSZlTdR57mbe2zxyuf14bePhjzmGm8VLSlmDYUb/6PjuhsOkXHssfsUqHM0lSZrmAiAbCHTvpDDMYt+BqMtDp0tlBSPnRVBkDBOJk+ctgBXyktEW+w1dGubHhvi0uGhJ/X1ZprK2+w5VMx7fnkbkXmlABZ8aCfqHOZeYsgeHQs6o8QvtUaqkcPbZsyUitgMNKK46NCYv6LOEXMz2gOZ8IBLGCTCwAVey3xZPB2CYFe7PwkG6a3Tl5EHXd2KcV5s9HYZvg2lxG0UgPTfci7M//YbrcJ6REH+i07yeLD0avuT0yC4cbv9BsPcOVCQrF2z86SZYNhmf4iZe3tbKPkE5p94rN4lMSc+PTL7QdwbI03OgNPm50z9HE9B9fDrEZGjWwi2hPp5FxL9p+UQzQ91hYTjuUF+AeFTim+Va0GknyepnAyuhH8ExcfwvKdpSiE/8sAN306JZaYHip+UYZdxPQ4c4/PiEn+YU2kVBHG1EXWyY/XhrN0soCcTOguYwiTxMjJPbo2K3d1H3c93txMROU93rHGx6aX65nBCX8IoLI9XIaKnUL+BWDQYhUj32uHuNcDHsyR8z5HFCdUHm4P5tsX2oZUfF2v9VyIeZAwgDdeF/PI8UGlArokkWQ6jue4shWVoiWIrYwU/aqr3CA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(23010399003)(36860700016)(18002099003)(22082099003)(6133799003)(10067099003)(260925022911599003)(260925021311599003)(260925021911599003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Zxayp6gk0ECjEGHGrxebJoB/6vt9aeqDVPkLOxFivSN6qkRswX5bjG4fSrhi3FIIkI5Qm9NdOrF+G7hlpYbb6/ktcm8O75THNJR/AQ1GWZPcIfpBxDcV1HTQoe6nFr0ezso8buFjG1SY1w2fGOV2TL9WjkBVzwWN3RAGW/a5Xo6Kw7rl5g+yrQUqJVSpvGRWFEcU+tShiBPMvm89KnKFiDF5NeTs5xaTFqPyrysEOtWeDkkdLuyzGZBXIMIJPtRjNnkUd4aXVzCulsZZlrRHidiJB/+jp+m02dPc1IqxYvY/XuaJvbka7ZiYYIj/0lfdnTaIEtdwa2vVswhfXAetJ8ywICGodKR/eEcwcCB4XsMn+0T7K928yKH3YZrauHsMXO5O2I0aUUvBv8qwSlQos4ZSAEifftjF6LxOKXNQN9D1+Q0C87mI9mHcO1SVw+D9
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 11:44:30.9991
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ace6140b-f820-421f-2580-08df1ee830eb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E64.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSSPR12MB999237

From: Dragos Tatulea <dtatulea@nvidia.com>

As data direct will also be used by netdev devices, move the data direct
code to mlx5_core. Now mlx5_core is responsible for data direct
initialization and resource creation.

Now data_direct is initialized in mlx5_load() before attaching consumers
and clean it up in mlx5_unload() after detaching them. The data direct
PCI driver is moved and registered in mlx5_core.

IB specific work stays in mlx5_ib: notifier registration, mutex
initialization and MR list initialization.

Failure to query the VUID is now fatal because this is done only on
devices that support data direct. Other than this, this patch has no
additional functional changes.

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
 .../mellanox/mlx5/core}/data_direct.c         | 89 ++++++++++---------
 .../net/ethernet/mellanox/mlx5/core/main.c    | 15 ++++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  5 ++
 include/linux/mlx5/data_direct.h              | 23 +++--
 include/linux/mlx5/driver.h                   |  2 +
 14 files changed, 95 insertions(+), 113 deletions(-)
 delete mode 100644 drivers/infiniband/hw/mlx5/data_direct.h
 rename drivers/{infiniband/hw/mlx5 => net/ethernet/mellanox/mlx5/core}/data_direct.c (80%)

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
similarity index 80%
rename from drivers/infiniband/hw/mlx5/data_direct.c
rename to drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
index 3878c4aebb2c..5afb11a2a9f0 100644
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
@@ -210,17 +214,16 @@ int mlx5_data_direct_init(struct mlx5_ib_dev *ibdev)
 
 	BLOCKING_INIT_NOTIFIER_HEAD(&reg->users);
 
-	err = mlx5_data_direct_query_vuid(ibdev->mdev, reg->vuid);
+	err = mlx5_data_direct_query_vuid(mdev, reg->vuid);
 	if (err) {
-		mlx5_ib_warn(ibdev, "Failed to query VUID, disabling data direct, err=%d\n",
-			     err);
+		mlx5_core_warn(mdev, "Failed to query VUID, err=%d\n", err);
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
 
@@ -233,63 +236,63 @@ int mlx5_data_direct_init(struct mlx5_ib_dev *ibdev)
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
@@ -304,8 +307,8 @@ static void mlx5_data_direct_dev_reg(struct mlx5_data_direct_dev *dev)
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

