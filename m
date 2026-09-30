Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011011.outbound.protection.outlook.com [52.101.57.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4AA4C8C5A;
	Wed, 30 Sep 2026 11:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790768633; cv=fail; b=R0WpBgJ4AEzv0n7CtI8CNMojHLkTUh9iVqZOcHrvmd5gLYq5r6u1uIdAkswLr2TOyqoal3ME1g7utHe03rrvcIu78R/aGXiv4Em1LIlDr0ct9IoWqxy5jrhIE978oVcTncHYBskEJLvAmnMgVU3jxSrNeMhi9KE9JGpYWwMOeGE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790768633; c=relaxed/simple;
	bh=im+/ALoZKoD0Ndj+022qBtkSCcdlGcvB+rLY29jMYj0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KkMhBqx/UE7g6G+kZBL3lcSlq/WNUq795Sb7WI9VyDGMXEEDW/9XDHXve7Vpw4tAWB5FHSiVFPV18CAZkpcqY37oS5b+cTI+nRiU18AW6pVVIsNQV4UrlPLfu2+L0kg6et8HZ4Odgs2Fv2a4F8ojtK8dmxkrt8Yl7xmJv5HaiL0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NAAYXev6; arc=fail smtp.client-ip=52.101.57.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NAAYXev6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cwc3wPuBoRy3HgAH1kH4sO5LdzP79Z+1Gun642ar9jhOw+/NUSobJfmUy7beVS0IfYW5iOgeVI/y1MV4MMoPeIiNdtOZnv0IOyBXJ2FJDlZ3TmdTohKTst1Aw4U817xMuNTRPgIWd4n28tgqQMrZfO4i3zGSnqW5g3AnQZ0aA4zTuLZ3PaWFltyWj5zyn/aO2NMKgwuHwBoprNoSJYDqSHLMHE/9BJ6CntSl+KxKHP4P2Lko74p25dXmWLQ1n+ncN3dLlNHm8fzTWLhCSDzhnJ0nFpPb5vvjGTWiCYnnTUHyvBKHmSLxulqH/88kEEZ4zjwMro1kTcegUHChrSkhwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Sz1UeZ8Vxhqr1IF5oUGYCRT3uOfT3RW2OadRdXXkyA=;
 b=fWmmlS3+4xUqH2pNyXe12vBLzo4jL10OZEw4sCS1MDySzIcxPiOkKEo7iiwq+OoTfPSj4H4MYyn9EYP4BwhAT3eYFBOSHJNlSeKnd6l93MFhykBSScWtCDMI8D0V8EhGTP85WR6q3cLmoBHr9CDGoq5Q8QmHZM5fmD+5Ymi2N5an3fzaxTMpWQLiDin+8H2mO2hMkw8D8hFJCc7ZN+BB3DHPc267i0IF4bfl83qbMLiEijmxzrftdFGZ134IFUSt7hk70Vzgr7rq4EK+mom4QNxDSiwU9ewErOjF4dE3y2F6A+cp0beRqSKCtGeJ19XQgNRGLhBUpMAXlit04NTpvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Sz1UeZ8Vxhqr1IF5oUGYCRT3uOfT3RW2OadRdXXkyA=;
 b=NAAYXev6hFEt1wzoggSDM8EMbVOno+FJtLwdnd1Tx0wziGEsqtN1Jt8xVKYZRsdUtmbkbz0F43dxlti5ZCdctEi6J5s23tggBgzMUbIvW5lwp4DErLD7LHxJXerNmQnFLW+OB/79+0Q5HyFpFf+GYWZU7YgxneUEvQr48u9QTmG0uJefBPHH/Ru03WO27jlv8xlQBMP5GKOcjTtaBBohb6G9TlS8/MMWCOv4EC/ne9QSJfNeZ4latYl5N80ZLQC1N6dcKstW8fxdp/GTQPSNtYJ4DGawmpLdupJIxwh1jSAHKnBRuxYgp1SSb8jhzQnuU8GIk+/GIr6oQsHS7TApRg==
Received: from CH0P220CA0028.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:ef::7) by
 IA0PR12MB7750.namprd12.prod.outlook.com (2603:10b6:208:431::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Wed, 30 Sep
 2026 11:43:43 +0000
Received: from CH1PEPF0000AD82.namprd04.prod.outlook.com
 (2603:10b6:610:ef:cafe::51) by CH0P220CA0028.outlook.office365.com
 (2603:10b6:610:ef::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.15 via Frontend Transport; Wed,
 30 Sep 2026 11:43:43 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH1PEPF0000AD82.mail.protection.outlook.com (10.167.244.91) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 11:43:43 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 04:43:30 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 04:43:29 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 30
 Sep 2026 04:43:25 -0700
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
Subject: [PATCH mlx5-next V2 01/10] RDMA/mlx5: Notify data direct users via a notifier chain on unbind
Date: Wed, 30 Sep 2026 14:42:18 +0300
Message-ID: <20260930114227.139274-2-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD82:EE_|IA0PR12MB7750:EE_
X-MS-Office365-Filtering-Correlation-Id: c89e3df8-9533-4109-34e1-08df1ee81487
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|36860700016|82310400026|11063799006|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	R0vL18fxmPInowRNKDJJWqVcRCXIaLga5InbaH0mSiimYeB+8LkZ9e0D1niBsPrFg0ecDY9sDRvpoFmnyii9PHm/aDx3PAU6HWP1GhF8QLxnluDNJud9SKjjzDW7F/uNTPv8bkArWjnVQ63qxiyUsgCsTQ0XmVJUHfYvzV7/nsEarVxhV3ubFkatFoKl4UCuvleHiFEEhQ7BoFG2KXS0eXKckeitvyFr6DskuaQmnGYYxHYG7txor0Xp0Hpu3vuw7PzoGL9LjWahiUFcjFdz5iDELxxSbBxrs2f+3u8J2VpofHW6v6eNkAvC4r1kvqp5wJYuuD1bx02PGCWe7rk5UOA37cJYOp1rCLldv2zKKLsXIXKrmGWyRUroqHpc6mtSf860J/Q3PBfxHRf+2fi/pGvdNWUGuVa7KUumPWdmnKzlMQmUtP7Hlx6CoCgnuHAA5SE34aUFIJemcdl6qzqA8isQWbIqOXGNZ4E2J2z5vRC9NjKel+EsgZHObHQ4bD0WLlwUOHSw/CQPQfJZ9rA2QxeuNU1aPsdFmL0oe9MP8nVulcRyD1t79F3LAyS4rcT/ajAxKPtb1++pMBy1IghQwt47GtNt3JayEynOvfCrgu7uPMKmoJWH5ntXD+K9KvSQqv7rBiXEHFbM9EVdaMnBgwmYmOWc6OqW+IIajeOafZrzxtYn2//pcHNRviO1x30532tgHs36Sok9iyQ/l9OcHw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(36860700016)(82310400026)(11063799006)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qhBCoNAsbQVYg57uy11OlJYe7XxwR/BTIbXATB7U3DGGsL7cwGGTN+i6+lPNjkGuk/BZd0ErIsOirkQ+TIxJp+P/oMNSyFqPZTy8Q2aCZEL1pfQiD5EOchNHcXn7teHnfLONdRa4wyIxNtCeIAVeZXVHlL+4TheQJMcMgusJDy02X1m9isEPq3+0Yb5pSsUsIpzb98dIMemJYJNLTfyDjU9AggSkEMk3XyA8zwIVODbDP3RvI3azQzg3BbT1dm2OGWIcFxnTSniMcnmMvKjT+Tqz9majxUTYYBw9QUMDu6SRoAsgpVLxYdYnq/fPD6hFcuI7O/Go2eXdbZ3V2lUz1gx/Kv17pK6oEXth09aO/ZqmdeCAHcrgumI5AvEZed71iFngeb5ZnyatI66ljX7eJzbzybeXlyiaU1Om5BKCGy70sEMgeQYsKw9+MRPuI9FY
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 11:43:43.3960
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c89e3df8-9533-4109-34e1-08df1ee81487
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD82.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7750

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
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
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

