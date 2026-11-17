Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.3
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794935424;
	b=GR1KNmW6EOVR7ae3wI1ZyXOcLJWmKX9F7x6YpO7/PuiwSOf2rWSGCmj+yCyUyvRh9Qbz
	 FyWTTuiB/vIPdY9AMudG5MVNy9ED9/xUA+UoKls+eZ8rOoWW6ssyWnJiKd+x5sP5b2FpR
	 491jef/5u4VoG5dT/6J7Y8aKVy37I8cW6JbzKKlTE1CiUST2RV3GRBMOE5W1lbnfTlGgI
	 2l09+DzIWe9A80hoLDXSuNjShEYeatz6Yi3aqW8hTUX2KJpn79/6iJRVQ+KBOE9SOopf9
	 3lUqi6sKpcwGp6RBx8ALHg0XKNjx2pi2fYTnmX5x7BgBADuuCAyRrvZdVcAZfkB6Erg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794935424;
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
	b=InK+vjsVqEnFPN5IHyY2EF5vHcogBPnDRkVhBxNun9qyva1J2bAXDXZ53o+SHTfR6oyG
	 o/3NuvcydkVjW08AE42FryCTtLTfpaSc6TJAAlSHeb7A3JwTLEoA9mpfNpEvBZGbRcE9t
	 HEU4mSe5Tn/riFPqiIxsCcPwiGyzx4HwBFNvBOhuqMxBZsIPsdX14USo6bqsfFG1Px9Ch
	 O+acwDdBVXFtYcCu3PVarel3Nj06M5sKLLf4RenSKmCn+i5PjNKUT76D6Nii0V8g6GTIu
	 OXjaO5SSosP3eM5aQhTzHTqtatU3ujee8nq3OrnnCxBUqEelvsXbavt4W2X6fwkwZ7A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZC0zrKgp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.3
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013003.outbound.protection.outlook.com [40.93.196.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B913606A332;
	Tue, 17 Nov 2026 17:10:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B913606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZC0zrKgp
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FPzg+LXdib6a1P9AJBZllc9hNRNIFo0GkPL7UToiQooO/oX5mt672jGzlijh/N19zNcVAvfvXcKt42CnDnxdCfBEpWXcQXr/pmnbuAJmHUDxS/U/NN4mRnKnLnBGSUKGSecC/3MohkuHrNep64kXN+cRcvOqTM0oc+tW+9N2DS/YIJuxN4o5NunbTe8L3i0wvLAUwDlFECvVOo/vY3j5ts7ko3njFCmSOfLg+oivNWxhhQJf3D/09O4eIPUOL2XLxibmJ6TPeCyTFLFafCUBALraWNN1BbRXitbpo/aUQtO8Gu/LWQyoGBiKdifMqHbs8Gl+em15IJWtvKys5UzkMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pVMz8tFV+Yn+K+kg64SlR6NHVVXHwcJkBgEXDjlYdik=;
 b=Tu4v048z7DB3ToCeqOktxsaCesCT8vNodvMQ8wM1JAvPeGaJBiCT1weKIIDz+eYMNKxXG1mbcj2+dZLp0De+xqWqJbJG3IsZyugPPPR4znYtc3gR4ZYNs5OpA0I5sZG5kDmRm/7DU7ZHIuRFVn6dvU77zd3Uc41EoFHPgAy1efqMjepheMQ+lQ3Gel6hWE8BeEIsFRXAchLqC9uSfvxpSdHGrNgagCD/aJ5WYI21lcz/PnKkeT3v94y2ZzlIW7YTC32LveuuNJ/EcpKPdRSWZo7e5rKRULYhnv218fTjC9QAi3AK4yB/+jWET1ffpj8a9aYLub0/15cMpMdSUpnlHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pVMz8tFV+Yn+K+kg64SlR6NHVVXHwcJkBgEXDjlYdik=;
 b=ZC0zrKgp8Q9vyi6klgs+/7nUItBiEof1fN9SzJM5RiLgwXHHJtJIte/vu6Y6Jf+nGufH50TJf275BdBej1gju5SQK8mc7on6v+3KMcJJngSVyMHw9OXQkzoQbbQ51BM0CSR/SeYDgh3aG3VawwOUn2A6LUBcO7gFBHUYGe4vNLTvGMdcuKWNN2iura3mQLZ9/K+wfe8WkJVJU10oHElxp7JY2DJ2EWxjx+FOYIk39SZJE0nEcK5B8k3/rggwgUcKlLeO9QyxQqlMaWVZUCNPLwIyBbP2O6V10EFhKrR+I3bfBwfXP03dy5zFtFaInmzJa0kd1a8f0noV4veDHYlvMA==
Received: from DS2PEPF00004561.namprd21.prod.outlook.com
 (2603:10b6:f:fc00::505) by BL3PR12MB6644.namprd12.prod.outlook.com
 (2603:10b6:208:3b1::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Tue, 17 Nov
 2026 17:10:14 +0000
Received: from DS1PEPF00053450.namprd04.prod.outlook.com
 (2603:10b6:f:fc00::2f8) by DS2PEPF00004561.outlook.office365.com
 (2603:10b6:f:fc00::505) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.1 via Frontend Transport; Tue, 17
 Nov 2026 17:10:12 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS1PEPF00053450.mail.protection.outlook.com (10.167.23.232) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 17:10:11 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 09:09:48 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 17 Nov 2026 09:09:47 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Tue, 17 Nov 2026 09:09:43 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 rdma-next 01/21] net/mlx5: Add mlx5_trigger_health_work_force()
Date: Tue, 17 Nov 2026 19:08:54 +0200
Message-ID: <20261117170914.27410-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261117170914.27410-1-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00053450:EE_|BL3PR12MB6644:EE_
X-MS-Office365-Filtering-Correlation-Id: df604375-2377-4148-9bc8-08df44cda402
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700016|23010399003|18002099003|22082099003|6133799003|10067099003|5023799004|11063799006|261021123027099003|261009223327099003|261009223027099003|261102123227099003|261009220027099003|261021121427099003|261009221727099003|261022075727099003|261009221227099003|56012099006|261022105027099003|261026140227099003|261102130727099003|261021135927099003|261028144727099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	OQ2eoYoFgmOsvveU3cfChYUuCus4AfbP2eo6TvutUKfbHGxvHBQFBri7BsqBZ/RbaWNI/CgfzyLO2kZHSDhMWxnjBrBjSC9fOKSiu/DZoM1Y447xlZGF0uOc/amhYjxRzhwbjMBZ3M0LFuoLlmqpgDqoIv773No/lxkgzmS1vsOkPjS0lQZ7kJOTeNL4OlcvhzG7nzVZnjkalSsSMcnbCDrQU3DXbOtWFBeCd4IocE/vEryHSUv8MKWQu73mrzrEnd0BwP7YkvgmzzSbq564i9szmgJW1fuBQruX9Y5SKN6DHy/ujslPi2cXjBnOST2ntYFCs1ONuOzax3vGzwwpoKqxKDFNJYonsOL37tz8Nzm/VASav3kHDLYdfLrX9wBK3OVShNAzjueEU49JeuOPmmXRcIXUqlC9FnFF6CVrU/Oibu7+bKXMAWKp8/UdxAeH6/72NVJR8UEU6/zYAMU3paurbJyY3WXsI9l2yIwIMox6OVwit4Mv4cjJ5zradTDfk/JzjSrQz9JhoNqvJz3LU83ZpDBDF6pv2mpCemsVjEIACvtaM4D7gAbk0jsBp4NOxtb+8Sci8lTymHLCvYEeLNSu5KlnwBDLiAlod2M/lOAyet/tE8iss1sto5kU4aDdtYSywevzoeBAxCV6WP6rxVv7U6Jeus8zadWlf/akZ5yY24IIn1GDpKbQVBhT0VtH7tZQQQRKzlSkcaxTSjEU2g==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700016)(23010399003)(18002099003)(22082099003)(6133799003)(10067099003)(5023799004)(11063799006)(261021123027099003)(261009223327099003)(261009223027099003)(261102123227099003)(261009220027099003)(261021121427099003)(261009221727099003)(261022075727099003)(261009221227099003)(56012099006)(261022105027099003)(261026140227099003)(261102130727099003)(261021135927099003)(261028144727099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Vh78OBjOBa32298p43thLiNVgrBC6eOOXeoJyxr2Z+wbTswrOSWYV/M6m3aYJN4qO+FKeyniPjwlKO1+0yNbNg07McfiikNgua1C7hUMNLHoR7/aQWnvYub94f/0ef6POCELl11J4SsWemrIsuVHYzMCMtI4QabuQ4+570aBvaWaXJeEM5qvmI1pCQmoMA023RpAkYiEMXmmIjdrG/vawvc/MUHfZ8bLq3vd8HErUuD7E4juM2k33iwORu6uSiMtx6aUyR6syIjZftm2PU+lAhF4Vs2uSOA+rylg+l2KXt6fnJebUTTPDJzDd6cSukNwAOxeicQhBm75cDymJD2EsyO1KiPWBNJHpAI6oG93C7Zs4G2qgjoo0l+KN5cf0/vnQykQFuOkOkHEslGGFyxiZJvJMZAthNfupszdR9MEJQjX7yqHkBI9zC5jSFCvU7j7
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 17:10:11.9126
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df604375-2377-4148-9bc8-08df44cda402
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00053450.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6644

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

