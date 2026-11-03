Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.62
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793724071;
	b=14s1ZcaNFeYr1qCaM2BFTUm3muZKKmnlmAPILTOMTAseSqSL0iBDzak5Mxxk39JUJuWt
	 s4uTkSfaYSuRGLqPQuI3zX5P03YujpAEKT8Uz8Pd6ULEVjt1T2W/25YLrftk2Jiy/N/Qf
	 1v6ECm0n3V44+K+Zp52K2Hi0wPA55pBs7+MYgL3ICSko2bk/1y/J7rg2aQIF21iP9vP7R
	 K6zMSyzqQK/kMhcdLB2QTYAgO/o34LuPM/j9nEb4uh+kHReGkkxHtrt8+lY4Lca3Qtg/X
	 RTmu/iHloTbI3FIV+CR7efD54iHbGeQFMJhor9lT9KbOV5o5vIOPoi7BxmLind/X5jQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724071;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-NV-OnPremToCloud:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=5lzRENs4y9ksnh4gH0jfKcvFF+zLoX8hsG+WgnEWrpY=;
	b=DM2aIIyQLF/MIWKki8FaFRUD7cwaudzIwaUF1CydUlasuUF5iIMI+QDnhUK+6C7jvLpb
	 gXBLXQCmyl12tL/ydrFtlaUiLvUv4C/syzlGBX8blnQ5GGrxpXQmhdlODGOG6azFF5w29
	 lBSUkbr/4U37QbRBTXfkJT1/78mx0SzVLbG4SCtKyB7E2/7LSWIkgbvQD4it+2IVMq6dY
	 zQ25aFEBT5CpSIs1nz7J6dO/9ivszbkHSLUNXi5ex8Hz4kTkb+jJ6kZ5ev0HXLjaNLF5J
	 p2wTYT6LbVU/fnCI3GPs/H4XoV3/60Y7LKQnV4l5vperJ53gdZlqUhubQxch833sfWw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=fCR5Ttyv;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.62
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010062.outbound.protection.outlook.com [52.101.46.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DDB606EEA6;
	Tue,  3 Nov 2026 16:41:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9DDB606EEA6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=fCR5Ttyv
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CSyRyo+EBaOWQOJT1dVKPCGZ62emqYHMC0vf6gFcuOC0BnkuqBu0w8QDHVwcXq5vLriW0a/9rgf+Dcks3iVPR25D8Lzf7yPIUeGJ3xFZE+k14dYG6huMUvJIl2mnT/tKrANz3GXRhoXS7kAC/31rdKqmmOHtmZ/TGZcW933ByKodIbH6ZQqL+UuQgiSlOFmZXSx2QxgNc9ZVZbP0s0TyZnX/VuHbDKm4wZ7LSmiK4XsY0ZZujNzfR3zEEfvQnF5UqYxSG7oi3Rv+JTj2l1xu/jJR6APbJ4CifkYGnneOFTkcNS6dLLCVswhiVe4hHfTf5uhgs8n7jagN27emoBCaEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5lzRENs4y9ksnh4gH0jfKcvFF+zLoX8hsG+WgnEWrpY=;
 b=in/d4IxxcEtQ4hUu4lWeymAZr6y49DCvoZ02R3vP9Ec8tKOs3ccyh8a22zArtK9FLqPc3QorESEsnlDoNV1KFhbqHD89sfRG2v0aOs+wG0ef5mdivcBIKxjrncKEIQGfac+SUgOQjgU7drH8kPXyA80pIeF3vR8ASnGw+5hBPDQs0mn8X1As/PB4spA0nlD8aKuspiXGLgAcqln+G446m6LpWrfvrqwJQHAQB7Y7pFgXky0F+6IuPcQgwvFmteC0g6IFSpPnM7k7AMnhR4aHUFArhBSu4eJUJXot8UOPD/eqDEy/9g1l9ukdn/8R4IGhAFgM7kgEJNDrW7ZQkIu2yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5lzRENs4y9ksnh4gH0jfKcvFF+zLoX8hsG+WgnEWrpY=;
 b=fCR5TtyvSp+82xnUuE8NXn1wSwe26ZwIJFLuatJVcabhHzKwbMb8r5yjNvw3Ln/H1rH4oOfEpGUNBKg35E/y+Ij5eWNWGEkiH3ydPAJtnTXCt4OrQ3YbW4CF3hY5by3h+PCFoh5zRIt4bwzxRvJKFuw+7b4NpddeOIcsaEJBbzpAQ7/LrxEdmGcBCubcNp4cH3Y5c7tkC3HfzcAIA2QavkErW7yPOiZ2RIEdBrOuQpLl3jSjVQIrGauuazdoq/1hqI7ocmWso1cFa41iVgsKKZ8ieV19Jf6l2xuwz/1plRs0B7017EosAqPsVr/GFDhURcdGjR87s/0ffApB4xvk3g==
Received: from CH2PR10CA0003.namprd10.prod.outlook.com (2603:10b6:610:4c::13)
 by PH0PR12MB7908.namprd12.prod.outlook.com (2603:10b6:510:28e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 16:41:00 +0000
Received: from BL2PEPF000352D0.namprd02.prod.outlook.com
 (2603:10b6:610:4c:cafe::26) by CH2PR10CA0003.outlook.office365.com
 (2603:10b6:610:4c::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.12 via Frontend Transport; Tue, 3
 Nov 2026 16:41:00 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL2PEPF000352D0.mail.protection.outlook.com (10.167.249.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 16:40:59 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:40:27 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:40:27 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 3 Nov
 2026 08:40:23 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 01/23] net/mlx5: Add mlx5_trigger_health_work_force()
Date: Tue, 3 Nov 2026 18:39:27 +0200
Message-ID: <20261103163949.1554-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261103163949.1554-1-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL2PEPF000352D0:EE_|PH0PR12MB7908:EE_
X-MS-Office365-Filtering-Correlation-Id: a211e04f-a8ab-4dc7-3d17-08df39c93dec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|376014|1800799024|261021135927099003|261021123027099003|261021121427099003|261022105027099003|261009223327099003|261009221227099003|261009221727099003|261009223027099003|261009220027099003|261022075727099003|11063799006|5023799004|261026140227099003|261026121527099003|261028144727099003|10067099003|22082099003|56012099006|261102123227099003|6133799003|18002099003|261102130727099003;
X-Microsoft-Antispam-Message-Info:
	tnv8WS+ij/eDrWWXptev6597Dxd27cGY4mKubYZVrNUcS89H0t7jx3Rqd+wb5TOIJfP1YdfaP81gcDB2MgLN5TN8MxpL0G3aNJBzKEGgr2Ad9FNNKtRGmcEWwiwQUlSwml+wWlzezAnE3jNbo+sk+Z5zxFkn7KUvat3+YESN0eD/GIudfySPVa9X6cuGCkmxZ0WzIkW/sthCkQj4IbElg8ei4NvLWIdEIP1w5NsR50ryO0uh547LKeMLdZbecJKWlLnZWkPjTfWYmFDS/EVxEF8E5SAJwKLMtvOVpPTz9MDeQIWRw6aE/EaSxPxUEWkbblTa6n+xU4SmidQmbB24BYskhSzoqAij4tCxSpqeitMqfAfJN0XQjaXLpm9OaAAatLT1d/Wr0vd1W9PkafXr4RaSTA6k7RRO+EvC4SNy+6aP3APcgKXkXCSWZ8mm4TbWr1wDvQFHouu1/Ipd3rlhW6kaC5GCAGbCoMbtB97wTw8EemoyTPJNec9N6K87jdhRpldvVh4GUlIwkRIWGi6LysZrvPjYNdxNlvGXScCPXuZW6Jblor1EZBYb/pwmSHo1GtIiCbkgXFFlwv4wWDqkJTb0CDMZl/9MOYlKGKVq+A6qJPfwmgZuR14JtFDejwBCJ5M3d/Oh0JzzRywE8aOjbD+SjImdRGTUXUjvnhmJp+2XaaOKDxIT+ndsjzHgnJwhZrFNdgUJ1cbER1HIGiYCfw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(376014)(1800799024)(261021135927099003)(261021123027099003)(261021121427099003)(261022105027099003)(261009223327099003)(261009221227099003)(261009221727099003)(261009223027099003)(261009220027099003)(261022075727099003)(11063799006)(5023799004)(261026140227099003)(261026121527099003)(261028144727099003)(10067099003)(22082099003)(56012099006)(261102123227099003)(6133799003)(18002099003)(261102130727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CsANC7VB+UbyM9Wrbyb3rQ9C3SqM4TjHfHJkoy/u/YIyre0jvY9hueme1k+V7wGixMQuNSY1RNRr2rrf5j/krlAdDa1GkecUCWqqSlOWoe1Byoz474csj9X3ofJ//BWw1pnh/4UFZG5EkqVrOgp1GAAalWc2NI6gfGX4HPijCis+QP0hiUMJYUnn5VP57F/mQDRp5y43ONu9AFCla+rUK3j50KcwFgoyfqDQmjIDf6YGLKJQvcRLKzfbWyR+xkzRAwl9GfL3uAzGviVcYX9T3SCvsUIuWoJgILotc94Zcshu3mrZT+97U3/v4SE2THcfR26zmg1cq1ScBhca/OFEGwHLfsT1JnIwIpe2CqjtHlUUNWj6R9KTq1FH1bokDO5mjhnNd7g83Bz2fluXt6CdTcUPr3EI+9H7mHJanv2nAQbu3eHnTjA18Uo+JGM2sIM3
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:40:59.8314
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a211e04f-a8ab-4dc7-3d17-08df39c93dec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL2PEPF000352D0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7908

mlx5_trigger_health_work() queues the health recovery, which enters
MLX5_DEVICE_STATE_INTERNAL_ERROR only if
mlx5_health_check_fatal_sensors() reports a fault.

A consumer can detect a fault the sensors cannot see, such as a device
that keeps answering while misbehaving. It then needs the recovery to
run with the error state forced, whatever the sensors say.

Add mlx5_trigger_health_work_force(), which queues a dedicated work that
runs the recovery with the error state forced. It only queues the work,
so it can be called from atomic context.

Before entering the error state the forced work stops the health poller
and asks the firmware to stop with mlx5_cmd_fast_teardown_hca(), as the
device might still be running. The error state is forced whether or not
the teardown succeeds. The teardown runs under intf_state_mutex and only
while the interface is up, so it cannot race an unload.

Export it for mlx5_ib, which will use it in a later patch of this series
when it detects a NIC forging completion queue entries, a fault the
health sensors cannot see.

Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/health.c  | 82 ++++++++++++++++---
 include/linux/mlx5/driver.h                   |  2 +
 2 files changed, 73 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index aeeb136f5ebc..d000ac335fa7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -627,18 +627,11 @@ mlx5_fw_fatal_reporter_dump(struct devlink_health_reporter *reporter,
 	return err;
 }
 
-static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
+static void mlx5_fw_fatal_reporter_err(struct mlx5_core_dev *dev, bool forced)
 {
 	struct mlx5_fw_reporter_ctx fw_reporter_ctx;
-	struct mlx5_core_health *health;
-	struct mlx5_core_dev *dev;
-	struct devlink *devlink;
-	struct mlx5_priv *priv;
-
-	health = container_of(work, struct mlx5_core_health, fatal_report_work);
-	priv = container_of(health, struct mlx5_priv, health);
-	dev = container_of(priv, struct mlx5_core_dev, priv);
-	devlink = priv_to_devlink(dev);
+	struct mlx5_core_health *health = &dev->priv.health;
+	struct devlink *devlink = priv_to_devlink(dev);
 
 	mutex_lock(&dev->intf_state_mutex);
 	if (test_bit(MLX5_DROP_HEALTH_WORK, &health->flags)) {
@@ -646,8 +639,26 @@ static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
 		mutex_unlock(&dev->intf_state_mutex);
 		return;
 	}
+	/*
+	 * The firmware might still be running, so stop it first. Do it under
+	 * intf_state_mutex and only while UP, so the cmd interface is valid.
+	 */
+	if (forced && test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
+		int err;
+
+		mlx5_stop_health_poll(dev, false);
+		err = mlx5_cmd_fast_teardown_hca(dev);
+		if (err)
+			mlx5_core_err(dev, "Failed to stop the device before forcing the error state, err %d\n",
+				      err);
+	}
+
+	/*
+	 * Enter the error state before unlocking, or an unload could send
+	 * TEARDOWN_HCA to the stopped NIC, fail and skip function disable.
+	 */
+	enter_error_state(dev, forced);
 	mutex_unlock(&dev->intf_state_mutex);
-	enter_error_state(dev, false);
 	if (IS_ERR_OR_NULL(health->fw_fatal_reporter)) {
 		devl_lock(devlink);
 		if (mlx5_health_try_recover(dev))
@@ -669,6 +680,33 @@ static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
 	}
 }
 
+static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
+{
+	struct mlx5_core_health *health;
+	struct mlx5_core_dev *dev;
+	struct mlx5_priv *priv;
+
+	health = container_of(work, struct mlx5_core_health, fatal_report_work);
+	priv = container_of(health, struct mlx5_priv, health);
+	dev = container_of(priv, struct mlx5_core_dev, priv);
+
+	mlx5_fw_fatal_reporter_err(dev, false);
+}
+
+static void mlx5_fw_fatal_reporter_force_err_work(struct work_struct *work)
+{
+	struct mlx5_core_health *health;
+	struct mlx5_core_dev *dev;
+	struct mlx5_priv *priv;
+
+	health = container_of(work, struct mlx5_core_health,
+			      force_fatal_report_work);
+	priv = container_of(health, struct mlx5_priv, health);
+	dev = container_of(priv, struct mlx5_core_dev, priv);
+
+	mlx5_fw_fatal_reporter_err(dev, true);
+}
+
 #define MLX5_FW_REPORTER_ECPF_GRACEFUL_PERIOD 180000
 #define MLX5_FW_REPORTER_PF_GRACEFUL_PERIOD 60000
 #define MLX5_FW_REPORTER_VF_GRACEFUL_PERIOD 30000
@@ -759,6 +797,25 @@ void mlx5_trigger_health_work(struct mlx5_core_dev *dev)
 		queue_work(health->wq, &health->fatal_report_work);
 }
 
+/**
+ * mlx5_trigger_health_work_force - enter the error state and recover, even
+ * if the health sensors report the device as healthy
+ * @dev: mlx5 core device
+ *
+ * For faults only a consumer can detect, where the firmware keeps answering
+ * and mlx5_health_check_fatal_sensors() sees nothing wrong. Without forcing,
+ * the device would stay in MLX5_DEVICE_STATE_UP and consumers waiting on
+ * outstanding work would never be released.
+ */
+void mlx5_trigger_health_work_force(struct mlx5_core_dev *dev)
+{
+	struct mlx5_core_health *health = &dev->priv.health;
+
+	if (!mlx5_dev_is_lightweight(dev))
+		queue_work(health->wq, &health->force_fatal_report_work);
+}
+EXPORT_SYMBOL_GPL(mlx5_trigger_health_work_force);
+
 #define MLX5_MSEC_PER_HOUR (MSEC_PER_SEC * 60 * 60)
 static void mlx5_health_log_ts_update(struct work_struct *work)
 {
@@ -874,6 +931,7 @@ void mlx5_drain_health_wq(struct mlx5_core_dev *dev)
 	cancel_delayed_work_sync(&health->update_fw_log_ts_work);
 	cancel_work_sync(&health->report_work);
 	cancel_work_sync(&health->fatal_report_work);
+	cancel_work_sync(&health->force_fatal_report_work);
 }
 
 void mlx5_health_cleanup(struct mlx5_core_dev *dev)
@@ -911,6 +969,8 @@ int mlx5_health_init(struct mlx5_core_dev *dev)
 	if (!health->wq)
 		goto out_err;
 	INIT_WORK(&health->fatal_report_work, mlx5_fw_fatal_reporter_err_work);
+	INIT_WORK(&health->force_fatal_report_work,
+		  mlx5_fw_fatal_reporter_force_err_work);
 	INIT_WORK(&health->report_work, mlx5_fw_reporter_err_work);
 	INIT_DELAYED_WORK(&health->update_fw_log_ts_work, mlx5_health_log_ts_update);
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index abb99371ff13..a1275e6aa6c1 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -450,6 +450,7 @@ struct mlx5_core_health {
 	struct workqueue_struct	       *wq;
 	unsigned long			flags;
 	struct work_struct		fatal_report_work;
+	struct work_struct		force_fatal_report_work;
 	struct work_struct		report_work;
 	struct devlink_health_reporter *fw_reporter;
 	struct devlink_health_reporter *fw_fatal_reporter;
@@ -1034,6 +1035,7 @@ void mlx5_stop_health_poll(struct mlx5_core_dev *dev, bool disable_health);
 void mlx5_start_health_fw_log_up(struct mlx5_core_dev *dev);
 void mlx5_drain_health_wq(struct mlx5_core_dev *dev);
 void mlx5_trigger_health_work(struct mlx5_core_dev *dev);
+void mlx5_trigger_health_work_force(struct mlx5_core_dev *dev);
 int mlx5_frag_buf_alloc_node(struct mlx5_core_dev *dev, int size,
 			     struct mlx5_frag_buf *buf, int node);
 void mlx5_frag_buf_free(struct mlx5_core_dev *dev, struct mlx5_frag_buf *buf);
-- 
2.18.1

