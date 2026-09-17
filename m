Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012061.outbound.protection.outlook.com [52.101.53.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E3A4D37B8;
	Thu, 17 Sep 2026 11:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789643742; cv=fail; b=nRhkyAFDNd4fgCKdtowA5hco2u8y2EBee5FOK5sW82VscdzSy41MMPVmWh+9XZXtGOEo/v0GCJg2FEy1gyjPMAITXTVzlwVu/HMWLgIK0I9s2/Ugr/S6zHTJTDjCaJb6+yLa6r/DOnuOi/jgB0nN5VDAXQ+5Tr0LcUArrUSZ6dA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789643742; c=relaxed/simple;
	bh=RcYejznkTZKc7VLM997dE8Y2/8C8CEuCgDtfiwi5Msk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G51Ut9XcemQQEfX0om0CTqh9Wt8ft5uJ+K41b/GZ+yRJnTSNQFSkrOm83fZvmB3pNGB/xsBMyFYFCyW66F6yzdhpNAFFOa4F/J4xRSrJIXcPOhKsHucXdWdsIjRFsJ0I6R6IUsjfLZ0rj9ybwVftK1jxMEWl+p8ql4iog1glnhk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Rqxx8qZR; arc=fail smtp.client-ip=52.101.53.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Rqxx8qZR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hi/tRyT+cz7lPYlI0dcW1J+dDwfuCIpU9oFSoIdxuO4tlFhCYltdN7os6P5zRlRgaaZmyJDaiapWqlr1UtiyU4lifljoOGdWxw3RofcI8KClfl7H7EIzpDvcv6Tx7KnzHA9hZ50WYr2leS4y8FM5WlW0hKOfWPSr9LX6oqDWYrloGf+5y3jtb5+iEvTE1TQqT47u04TpWyK5H4LwhqSg54LroDYa7qrJiphIBJxJEPv+L2k0QmG9f0dTcG8rwqLthd761J3QV2eOQGfJWd/h+8Q+aWI/n7emkzqka6kLASQ6yiI0vB4hPXNCl275onLcZzL2M13pnvlgykKxTMJpRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SxjPdk44MPo0ovWQYEBDzgDREckLZ1t+eE3kphzbRLc=;
 b=AER//ggL3WmKfRrV9UxDf3mE346QVfedtEJnRobVLelv55MnaqWpws4Hs/fVI34U4UGkl24bW4jkdrsuSloPZ+wn1UjV9mUu3lg1+hUHgxNtnt76Yt/vWWUHcpWLkHD31TJjSxry/z0JUlP7c5/CSZtXJ1JvF+5NILijXhPwabFQPD6Z4baYBcoOfg3GFsFMYVqK+M4DUeHPyGB/+Xc1Bq/VcJXCYqWAAh7dWXwt6zVhJidSU2y3+q8w24OGcAFKmUoGPNZ8vEWDnCxzsfUuwRPRX7lJL5beuYtK/mtR615JdkFhUX4hMW+sEFATNAlByWAmtcLAWZN2Szm3sGdYdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SxjPdk44MPo0ovWQYEBDzgDREckLZ1t+eE3kphzbRLc=;
 b=Rqxx8qZRamtxjvk6hryaSzd1XJf+DtsEF2hRHPCQ3hk+4IIsQD/ym648IsTaNkZeiRxr09uZmaCeq6M51K8GgarT1rsVXB70BRoCzh3lF3V/4FI+UMysazOPJ+ThXxAil3ChlWBXjMcZ0Z8CEn6zw3hKwYZaYNhGH5BazT22bfODF4X2XtMvWug/IpB6uOmaDvJDWLll1JOuvuHG+qugaNjsHgsFrai5ACMj8aqjXSo7GUYPY0+REbet+mDRbosY4WjlPhR8BX7Nf9Fh522iXolQd6gVWbMdp8bPavV6QNqWIA8RVmsqlXGtVNfCNI5cjLocvtOdN7gWu5rC1uPF1g==
Received: from MN2PR03CA0013.namprd03.prod.outlook.com (2603:10b6:208:23a::18)
 by CY5PR12MB6478.namprd12.prod.outlook.com (2603:10b6:930:35::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Thu, 17 Sep
 2026 11:15:26 +0000
Received: from BN3PEPF00022BC4.namprd05.prod.outlook.com
 (2603:10b6:208:23a:cafe::57) by MN2PR03CA0013.outlook.office365.com
 (2603:10b6:208:23a::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.12 via Frontend Transport; Thu,
 17 Sep 2026 11:15:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN3PEPF00022BC4.mail.protection.outlook.com (10.167.248.216) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Thu, 17 Sep 2026 11:15:26 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 17 Sep
 2026 04:15:05 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 17 Sep 2026 04:15:04 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Thu, 17 Sep 2026 04:15:01 -0700
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
Subject: [PATCH mlx5-next 01/10] RDMA/mlx5: Notify data direct users via a notifier chain on unbind
Date: Thu, 17 Sep 2026 14:14:13 +0300
Message-ID: <20260917111422.4054862-2-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BC4:EE_|CY5PR12MB6478:EE_
X-MS-Office365-Filtering-Correlation-Id: 821cecfa-10e0-4002-f979-08df14acf9a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|7416014|82310400026|376014|1800799024|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	7fR1S9ALRP75bddEY1PmO8Qm9f6j8MnE1v05qNdIDQOK/xfbWQQQjmMqQT+Va0KTpWKw9iP8uB/UYV+k+RnpcNqSCWz9DJTibEgRTIjBlpAxLypUH1voFhUUTCGITZH6GX1yyNMYx12TsKWUnsVsJDtdaidRWsCL3QTUR2Zt9jWOjqwFbW5mtBrNGnNbviI6jibjjFxuEBExjtv3dqTLMkLH8N5+cTlDSGpiY6eHovfQgR5RP6NpeM+tdgwSL1B9Q4rI6yXlsGj9fHYpDwMjLyC9a8U7u4F5AyMWZsyCQNsk4ovHskbtMpc6/a55SOmjvUbSpBKeJShO/bU/Xdo0fHwQ60Nkc5ElmXevPKau1nEFOeNHa4HR8wtaLd/VRNKrUMEpY68VoDOCF+2IBXCjAZpvsXKPWKRk4NBXOv+7vt1HZ/7lnksBoUKiXR7p3xGtRXqDNHAV1G67h16zI65xAhizO94CcbwS5xB3Jcj2vv2OOBHr3WKv4NbT3SRZn3GAYzjd0ltF8aIPvrdZmVA3PG1PnfoNOZvvi4bfqdf/58kTQ2V0CoclVmRNOw3Mu9yN0QD59SaE83Ipel8km150tLlt+0ej+yym0jdVe0Bigx+14eXy3FcC07fjsBQyMcdrKfvGJ98XeYpnHol63cWTw5LZcKLsDziV8tW4YdwLpgyetHMTt9kVJLTwxZgZFz0KGtIvjbkwEMyBOsaEgMfd/w==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(7416014)(82310400026)(376014)(1800799024)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wpKIVnWVcQd/3oDDqYKxEvWB481HpNynhrWGhYLYoyJyHEbo30cAqMwzKD2bly+L8wLMEdjR7meuyZJ2EIGRcqL0nLVelmCCR+H00lZbfVtNMLSLhA2bzExPpO7AQ7+AWKmuGswyTvbpUJqfa9wHmcQfAoGy3/3CxeMjuyj6BqmrUiScJlhCLepdN23bIGTm/H2Y84Q4bQW8ZTg7zpfy5yXzVQMDfAQVLhniH5n/oM03Ib4EXDJeDeSmu+g8XTQ3mdY3ubcCWM2vM4JEPn9YkdQTWRvxCiW4C2QtPpwf600dx6bJHpuufgDmiKKBLErQsi+R7HL2Y3GzV6YcE+od+frhD1kJ4OEtT5Ny9/8r56apBv17BToAT4PzNBl2RKx2Xzv0QJUEQEKRfZmazLpgd/gl0BDr9Ol4PI1ClPrFLDFw0zSwwfVRvx2twDJfBaGd
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 11:15:26.3363
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 821cecfa-10e0-4002-f979-08df14acf9a5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BC4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6478

From: Dragos Tatulea <dtatulea@nvidia.com>

Currently during unbind, data direct code calls
mlx5_ib_data_direct_unbind() directly. To make the unbind notification
generic and support multiple users, deliver an MLX5_DATA_DIRECT_UNBIND
event through a blocking_notifier chain kept per registration.

Users register a notifier_block via mlx5_data_direct_ib_reg(); mlx5_ib
embeds one in struct mlx5_ib_dev and, from its notifier callback, runs
the existing mlx5_ib_data_direct_unbind() teardown.

This patch doesn't introduce any functional changes.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/infiniband/hw/mlx5/data_direct.c | 17 ++++++++++++++---
 drivers/infiniband/hw/mlx5/data_direct.h | 12 ++++++++++--
 drivers/infiniband/hw/mlx5/main.c        | 17 +++++++++++++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h     |  1 +
 4 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/data_direct.c b/drivers/infiniband/hw/mlx5/data_direct.c
index d57484245c38..04affdbdcb12 100644
--- a/drivers/infiniband/hw/mlx5/data_direct.c
+++ b/drivers/infiniband/hw/mlx5/data_direct.c
@@ -4,6 +4,9 @@
  */
 
 #include "mlx5_ib.h"
+
+#include <linux/notifier.h>
+
 #include "data_direct.h"
 
 static LIST_HEAD(mlx5_data_direct_dev_list);
@@ -18,6 +21,7 @@ struct mlx5_data_direct_registration {
 	struct mlx5_ib_dev *ibdev;
 	char vuid[MLX5_ST_SZ_BYTES(array1024_auto) + 1];
 	struct list_head list;
+	struct blocking_notifier_head users;
 };
 
 static const struct pci_device_id mlx5_data_direct_pci_table[] = {
@@ -78,7 +82,8 @@ static int mlx5_data_direct_set_dma_caps(struct pci_dev *pdev)
 	return 0;
 }
 
-int mlx5_data_direct_ib_reg(struct mlx5_ib_dev *ibdev, char *vuid)
+int mlx5_data_direct_ib_reg(struct mlx5_ib_dev *ibdev, char *vuid,
+			    struct notifier_block *nb)
 {
 	struct mlx5_data_direct_registration *reg;
 	struct mlx5_data_direct_dev *dev;
@@ -89,6 +94,8 @@ int mlx5_data_direct_ib_reg(struct mlx5_ib_dev *ibdev, char *vuid)
 
 	reg->ibdev = ibdev;
 	strscpy(reg->vuid, vuid);
+	BLOCKING_INIT_NOTIFIER_HEAD(&reg->users);
+	blocking_notifier_chain_register(&reg->users, nb);
 
 	mutex_lock(&mlx5_data_direct_mutex);
 	list_for_each_entry(dev, &mlx5_data_direct_dev_list, list) {
@@ -106,13 +113,15 @@ int mlx5_data_direct_ib_reg(struct mlx5_ib_dev *ibdev, char *vuid)
 	return 0;
 }
 
-void mlx5_data_direct_ib_unreg(struct mlx5_ib_dev *ibdev)
+void mlx5_data_direct_ib_unreg(struct mlx5_ib_dev *ibdev,
+			       struct notifier_block *nb)
 {
 	struct mlx5_data_direct_registration *reg;
 
 	mutex_lock(&mlx5_data_direct_mutex);
 	list_for_each_entry(reg, &mlx5_data_direct_reg_list, list) {
 		if (reg->ibdev == ibdev) {
+			blocking_notifier_chain_unregister(&reg->users, nb);
 			list_del(&reg->list);
 			kfree(reg);
 			goto end;
@@ -150,7 +159,9 @@ static void mlx5_data_direct_dev_unreg(struct mlx5_data_direct_dev *dev)
 	list_del(&dev->list);
 	list_for_each_entry(reg, &mlx5_data_direct_reg_list, list) {
 		if (strcmp(dev->vuid, reg->vuid) == 0)
-			mlx5_ib_data_direct_unbind(reg->ibdev);
+			blocking_notifier_call_chain(&reg->users,
+						     MLX5_DATA_DIRECT_UNBIND,
+						     NULL);
 	}
 	mutex_unlock(&mlx5_data_direct_mutex);
 }
diff --git a/drivers/infiniband/hw/mlx5/data_direct.h b/drivers/infiniband/hw/mlx5/data_direct.h
index 2fd2bdbe8f69..a9bb471949e2 100644
--- a/drivers/infiniband/hw/mlx5/data_direct.h
+++ b/drivers/infiniband/hw/mlx5/data_direct.h
@@ -6,8 +6,14 @@
 #ifndef _MLX5_IB_DATA_DIRECT_H
 #define _MLX5_IB_DATA_DIRECT_H
 
+#include <linux/notifier.h>
+
 struct mlx5_ib_dev;
 
+enum mlx5_data_direct_event {
+	MLX5_DATA_DIRECT_UNBIND,
+};
+
 struct mlx5_data_direct_dev {
 	struct device *device;
 	struct pci_dev *pdev;
@@ -15,8 +21,10 @@ struct mlx5_data_direct_dev {
 	struct list_head list;
 };
 
-int mlx5_data_direct_ib_reg(struct mlx5_ib_dev *ibdev, char *vuid);
-void mlx5_data_direct_ib_unreg(struct mlx5_ib_dev *ibdev);
+int mlx5_data_direct_ib_reg(struct mlx5_ib_dev *ibdev, char *vuid,
+			    struct notifier_block *nb);
+void mlx5_data_direct_ib_unreg(struct mlx5_ib_dev *ibdev,
+			       struct notifier_block *nb);
 int mlx5_data_direct_driver_register(void);
 void mlx5_data_direct_driver_unregister(void);
 
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 02809114fc79..547275dfa40e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4019,6 +4019,18 @@ static bool mlx5_ib_bind_slave_port(struct mlx5_ib_dev *ibdev,
 	return false;
 }
 
+static int mlx5_ib_data_direct_event(struct notifier_block *nb,
+				     unsigned long action, void *data)
+{
+	struct mlx5_ib_dev *dev =
+		container_of(nb, struct mlx5_ib_dev, data_direct_nb);
+
+	if (action == MLX5_DATA_DIRECT_UNBIND)
+		mlx5_ib_data_direct_unbind(dev);
+
+	return NOTIFY_OK;
+}
+
 static int mlx5_ib_data_direct_init(struct mlx5_ib_dev *dev)
 {
 	char vuid[MLX5_ST_SZ_BYTES(array1024_auto) + 1] = {};
@@ -4037,7 +4049,8 @@ static int mlx5_ib_data_direct_init(struct mlx5_ib_dev *dev)
 		return ret;
 
 	INIT_LIST_HEAD(&dev->data_direct_mr_list);
-	ret = mlx5_data_direct_ib_reg(dev, vuid);
+	dev->data_direct_nb.notifier_call = mlx5_ib_data_direct_event;
+	ret = mlx5_data_direct_ib_reg(dev, vuid, &dev->data_direct_nb);
 	if (ret)
 		mlx5_ib_free_data_direct_resources(dev);
 
@@ -4050,7 +4063,7 @@ static void mlx5_ib_data_direct_cleanup(struct mlx5_ib_dev *dev)
 	    !MLX5_CAP_GEN_2(dev->mdev, query_vuid))
 		return;
 
-	mlx5_data_direct_ib_unreg(dev);
+	mlx5_data_direct_ib_unreg(dev, &dev->data_direct_nb);
 	mlx5_ib_free_data_direct_resources(dev);
 }
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 522984d958bb..97d2aa79e95d 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1131,6 +1131,7 @@ struct mlx5_ib_dev {
 	spinlock_t		reset_flow_resource_lock;
 	struct list_head	qp_list;
 	struct list_head data_direct_mr_list;
+	struct notifier_block data_direct_nb;
 	/* Array with num_ports elements */
 	struct mlx5_ib_port	*port;
 	struct mlx5_sq_bfreg	bfreg;
-- 
2.44.0

