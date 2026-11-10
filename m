Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.39
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794318259;
	b=NReJTCsu3SIeiEZ99d9eZW/aRSInWk42IzUaOyL2oZfTEYQi+EuDWrfpWSSRGv5ivwRj
	 1pjj4vJ/YmRfTZLipAJoLtyBVvr/wTAJVBxMXQ8eux3riRidfJfEuTuDOieuI4MmXpyNl
	 miky0wbRaergMYlcYxKQSoA2AI4voCD9rOsp7oupW9wksJtGF3Mjn8s67ZF15+p5ELhPs
	 QZptpFf5+nd+2oZg295JrwsNrt41jS5bcWLBXNRm8CxzUHaGIul7vDJNEHUK9QviP46+R
	 EdnLIVDIq9ifpHV1qydl6LYHcbgUjfosZRrX/ybEUVoK8fsNK8a41V206WSqCa28r7w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794318259;
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
	bh=pVMz8tFV+Yn+K+kg64SlR6NHVVXHwcJkBgEXDjlYdik=;
	b=5FxWRTLWV2yrkVPaZd619xzKJXTo3/hYSOegUep4H00Z4KJ9amdgy+EeIGS8VLEp4vtG
	 gV1OBOozhjQ9epQsffhWttBKGS3A44dDuweONYEIfbYS5eZ91TqU8YwaeNIiAExqKTomG
	 J4okKaKbpD0ImZnME+VeO14vZufVGUqNsjd2p4+jqjwDVvCj3wylKcTPR1870he8uW+L+
	 iT0oeuaByVbYD+ixJWCOCEExxJ9mFCFKDcedHtPKtlT8NrXzEDOaU67GmkxgtQRE2TH2e
	 1J/hMuYqnKGkzpe2TxXo0Y8AFPavCSm9uewzDWO0h5Nxo52He21wlbV29pj79mH1c3w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=hNUIml7B;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.39
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012039.outbound.protection.outlook.com [52.101.43.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D77C606A332;
	Tue, 10 Nov 2026 13:44:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D77C606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=hNUIml7B
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NudsUHBsOFmHOY5V6U2ZKnydutt/suPS5exSb9RmhXVDlaNoyDii2WtA0PjEItWfLgwlqGX3f8tM8Wd9OZwCDN9Cn3KsC0j7UJzToDEp7jhQbJ4KaG0rREOnLzhjipFzOGaW1C6TJiUsKTORhZSvSNsuhWLCHLGn2Ut55LawNJhHfAwEC6F1jh07xF1J2vXuk5vgGrQCbYaZQg5k6b5uNP+bl12L4NFhZW0/RcR/LSco++kC2CEPl5SMO+T7E9KoWBdQoCKe9qBCi20iMT3LXmnp46lBjhda5fgYwQkeBQiWXmVLS5WqYL5QFAbOiUUe+8uWJL0P62loZpJk5HDq1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pVMz8tFV+Yn+K+kg64SlR6NHVVXHwcJkBgEXDjlYdik=;
 b=KEVvaht7li9f1/5D8T6Y/VShyKaDYfhL3zsAy3PivCVgDHaGSx4l4MeS+AyzADQEgxNKO9LdcKyQkqeGGDyoIC21jSWdW+1PmtSfHnCiFjTVuHkgJgAw/h7TZ46mJmMdL46KZJbMULdABlqqBpxf3kSbu++Pi4feV4Gw3bKafOXd7C4MJPCEHdLDmYz67iadeRJyDlgmDc4zPrQNop4CNBCPWJS0ywZhKb45bArAy3gIhRp52oRGqTzTdwInaBEVwjlBxpze8GCXrHFDwteCi9ptdNEpKx+CSTg6LpU2zWZnHkiUBKY284WDvwGHgoxAd2umN4epEStqG8LRrEK26Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pVMz8tFV+Yn+K+kg64SlR6NHVVXHwcJkBgEXDjlYdik=;
 b=hNUIml7BeGfQpZxUjZpiZNs5HBZh3nkyDD4cC9L50fR85jkgiWb629mW/cgY6pl7fGuFRuh83R0RHsiREleWq57qss6l/Ok/H2qVVtEGvdkp7R9C/C9IDDc2yn9pQVCPe9Sm/RcmxIQA3OCZxAH/k8nNq90VyifZ8lXGj+bhcm9rwMHGY0QKizwqTsBB7I8+/rzmaL7wnV3rK23vdfiSqipDmIWiOmrWgaBIACAlz20X9j1reaagIFiOH/KntZkSpwypb3Iw3A/C++d+mlX1IV57tL/KbMip4W9bPG6RrBWBNDi55L0iFYXHNpPqWHP1/dorPw2aqcgcyphwvtg/hg==
Received: from PH8P221CA0066.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:349::6)
 by CH8PR12MB118260.namprd12.prod.outlook.com (2603:10b6:610:702::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 13:44:13 +0000
Received: from SJ5PEPF000001F4.namprd05.prod.outlook.com
 (2603:10b6:510:349:cafe::96) by PH8P221CA0066.outlook.office365.com
 (2603:10b6:510:349::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 13:44:12 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001F4.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 13:44:12 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:43:54 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:43:53 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 05:43:50 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 01/24] net/mlx5: Add mlx5_trigger_health_work_force()
Date: Tue, 10 Nov 2026 15:42:57 +0200
Message-ID: <20261110134320.34408-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261110134320.34408-1-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F4:EE_|CH8PR12MB118260:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f5e9c75-a817-46ec-4c74-08df3f30b462
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|23010399003|376014|1800799024|5023799004|11063799006|56012099006|22082099003|18002099003|6133799003|10067099003|261102130727099003|261102123227099003|261022105027099003|261022075727099003|261021135927099003|261021123027099003|261021121427099003|261028144727099003|261026140227099003|261026121527099003|261009223327099003|261009223027099003|261009221727099003|261009221227099003|261009220027099003;
X-Microsoft-Antispam-Message-Info:
	MTf2dJ488fSzYHyHuWFAxd7FHZKT4c4h7LgiEQQzrjnV1O1EyqbxiQ+2kv2stt5CH273qfccWJc+nE0Y3+SEovL4xNSAz7nKqBeViF5oYki7phMs7Swo3iFEeQ6XjBCkfCHJkl8rq9KyAzv6fGq/pPMWNQPdyUET6/gjPTmad3CY4vVX/9Joe7er50rrzdOVRlOMEc0DaWi+qZ1tBLyTQYph3a04J3cLGrmgl7WaVgrIs33EhpF4GRZSx1jeDN9pf2GIZZVD202Bg9xLOAaQ2zcmMRgxIcvBwL75uM9WDyESxjAMYD7u3H8gTt2R6keWnsUVh+U0J6AM9lhcgHwg2gLeLQGpXSm6+J1lW/WsKYR+l6syAz2HC+jB9/Ski5M9N4ZN8f/rY4NtCVrc/iWFb+ioRLjG6qZSz8NqIGHRWTRUUv3ML2U6pGWsimQrR7Wz4vCzLCuE8Nm8M/CyL0OP7GP27wNNBOIQx/qLjyherN67S/Fw0ar7KRj+tL/s4SAkKaXR7U+0WqeEuWXpVnhoxPI38omI+M6lyA19YT7BNSDzZmqkVXpfpl23WdqTv+QfpJu/OL1iBwj/LAJapUl82UvZCdx368F7LtCBxLmAc2G8dNALfHtBDJTukQDOxZYP9j6EyRAFMGfpqqSkGt1wMmjWf4SDNenBp5RoNBNpCLV9QJiE34LSq2qSn38XWArRClRFh7z++rXqFNVuG9gIEw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(23010399003)(376014)(1800799024)(5023799004)(11063799006)(56012099006)(22082099003)(18002099003)(6133799003)(10067099003)(261102130727099003)(261102123227099003)(261022105027099003)(261022075727099003)(261021135927099003)(261021123027099003)(261021121427099003)(261028144727099003)(261026140227099003)(261026121527099003)(261009223327099003)(261009223027099003)(261009221727099003)(261009221227099003)(261009220027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ZOoHsnlgMzJQKpWvqNwjnADyn5+z8JQhTb3l6jteq5jK+dwOCzL7Qly/cJbN33RMySJFBOnHPea+jTcIsBjLUl6LrDCUAWn+BARUS03q4c61QTmuPrv3QhLuhdSucKmPm7EVaWILWLekc0xR6o7aSGfwieT4hjSI2H+o5sj9DEAhOX+DI9wBlNEcmxWKebZsK0Fx66Oxnro1SobudhW/I01cwThufon0oPWTCiHscZS40xnnvy+VNf1l0uTxnK5JeIQ3zg2UWZdR1qvbgnv8m8cyK0AO5nCjT6Vxu2pGTmKiNLFilHgfoq2aogOEI52zqZcCf4K2sK5G0Rt2nXGU8AOtZ533SgsSR+l8a83GNx7M97FzWODfVLjsq+ehRe9Pdh8JfdsXn1PqiQxRQ2jayvldP4/m+KRCA3OgVUVWXL/DRUBzITciNBegxImPphjx
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 13:44:12.6906
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f5e9c75-a817-46ec-4c74-08df3f30b462
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB118260

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
device might still be running. If that fails, it falls back to
mlx5_cmd_force_teardown_hca(), as mlx5_try_fast_unload() does. The error
state is forced whether or not the teardown succeeds. The teardown runs
under intf_state_mutex, so it cannot race an unload.

The forced work does nothing once the interface is down, as the unload
has already removed the consumers that need the error flow, or once the
command interface is down (fatal error, PCI error or firmware reset), as
that path owns the flush and the recovery.

Export it for mlx5_ib, which will use it in a later patch of this series
when it detects a NIC forging completion queue entries, a fault the
health sensors cannot see.

Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/health.c  | 95 ++++++++++++++++---
 include/linux/mlx5/driver.h                   |  2 +
 2 files changed, 86 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index aeeb136f5ebc..e76351860b15 100644
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
@@ -646,8 +639,39 @@ static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
 		mutex_unlock(&dev->intf_state_mutex);
 		return;
 	}
+	if (forced) {
+		int err;
+
+		/*
+		 * Once the interface is down, the unload already removed the
+		 * consumers that need the error flow. Once the cmd interface
+		 * is down, the path that brought it down owns the flush and
+		 * the recovery.
+		 */
+		if (mlx5_cmd_is_down(dev) ||
+		    !test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
+			mutex_unlock(&dev->intf_state_mutex);
+			return;
+		}
+		/*
+		 * The firmware might still be running, so stop it first. Do it
+		 * under intf_state_mutex, so the cmd interface is valid.
+		 */
+		mlx5_stop_health_poll(dev, false);
+		err = mlx5_cmd_fast_teardown_hca(dev);
+		if (err)
+			err = mlx5_cmd_force_teardown_hca(dev);
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
@@ -669,6 +693,33 @@ static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
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
@@ -759,6 +810,25 @@ void mlx5_trigger_health_work(struct mlx5_core_dev *dev)
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
@@ -874,6 +944,7 @@ void mlx5_drain_health_wq(struct mlx5_core_dev *dev)
 	cancel_delayed_work_sync(&health->update_fw_log_ts_work);
 	cancel_work_sync(&health->report_work);
 	cancel_work_sync(&health->fatal_report_work);
+	cancel_work_sync(&health->force_fatal_report_work);
 }
 
 void mlx5_health_cleanup(struct mlx5_core_dev *dev)
@@ -911,6 +982,8 @@ int mlx5_health_init(struct mlx5_core_dev *dev)
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

