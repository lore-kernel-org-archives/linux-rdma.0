Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010061.outbound.protection.outlook.com [40.93.198.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485393DC4DD;
	Thu, 10 Sep 2026 10:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789035966; cv=fail; b=R6NEMy8JejrBFv0NDJaF6v370qccX2QM3jwBBzX12ZnNpGKvB4Zmmd3l8oPQZhOzKjrx/HgqbL5Zv4xVtcZQnUVpIcrqweMITxqEp1322BHFn/StnFi/KzOuUUldnHKw2SxsFek89GXT9C08EG9BByd5wwzvqCBjKQ4//guFNwA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789035966; c=relaxed/simple;
	bh=Q4K5eTnDCz6ekNVsX3j+lOosC2czksPun18goXAsNQE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rTiUf1fNqvBSEYdtk4AiltbxNQVs2SQLBV7K533Xf8ThRMXbopA7skaviRb8Z2fpqx3N+h5udIHkY4pfs+xosfRot6aIDl3764HwnmvbbYZCgR1Oc2i24pukvglG1KEIHSFMeggL/iY/aGvtPXTliU3I94a6G75symZ1JmgqWXc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=a46ZXryi; arc=fail smtp.client-ip=40.93.198.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="a46ZXryi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VeUCYwLvz5M4t1brn77fYwYiV+1bUNXo/3BswQzQ15JAJHdfyM7pYtQGZKNHRQVYi3eJc4DPnZpm0VMYghke0IpFe/qwuEY0urxDXZybyk5ewzG+yYW7t1kf5RdY8/9aOaOT+7rXUFffQiLS3pghsZwsafqragBT+sA/joGCWglCtJMTbWnlE6bvJc5epooguTZXshZkfDISB1vLfh8ENfUScHTCnIG/anroEfNMOk3oR1HvusuiAWg97200dYJF9xR6ZqSLBElNeXjX46a8lYBqj5CWiLtXrVoC3L38chDgGwSBRzNOAocRm+iogf9i4hahpHWS9juJQJl2JEI8YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S52Q+aX0qyWTs8O31jgL5gdpFHT7t5x7yH1OtKjJTPY=;
 b=SI3EZ+gQJHaJV2rutmTAWP60T5ucA6IFxFM5KGHymAV/l+4Sam4txijgossXul8P5vhTvBnX/M3RCGRlHqo1VhfLIb/giao20NZsLyiE8oHWuf4nnYb/HuTrl9XPkZvENzUJR3ustCbCWw3GA8Fo+gIyvB5kUfJoJ6h5O66PmGDljzKcNi8K+1QnF0dXZUlj5l38jhOCuUn3DiD7qJHj2+al/bYOvGX2wQSF8VrrHdxHzVpnU/iFk0wcYPhDDY/ekrtduPGt0OOlGGUpmJPMCvZPgTY8UGcg1D69HmhW3t2QNl7U6q07lTG0nC33TUOC2+EE0kie6G30VxdNAnuY5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S52Q+aX0qyWTs8O31jgL5gdpFHT7t5x7yH1OtKjJTPY=;
 b=a46ZXryiVugOEG0TuCLqrBe8d/mJw/Nx26VerrZ950jxO+Lefm+ouq9wr3be0J9ISmcE7O4Bd8OIw7yUZXEXMPWNEyMrb4wZ6ZlNj5cMXZ9ySe3WtVvOGy6LAxtHkWnjJV52vrTwi1YhyvqNudbwWQDbJtQ2a6904vZYsc/SMBhMNOtfvlWrXKBIiDj8+k89opNsTG5qtEzyYdO+0xo1569AS0biq6jr8SI4Mahx7UCeZXasnYjgyVo6y2U3XlqrfTvYCy9V0+3ql4OSQJTxj9VG6ua4hC5p57UOEDysHDF7iWbEyJu4Y7Jkl0Q9DfuXozqYF+IamO+n8sG92czsUA==
Received: from CH2PR17CA0024.namprd17.prod.outlook.com (2603:10b6:610:53::34)
 by PH8PR12MB6748.namprd12.prod.outlook.com (2603:10b6:510:1c4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 10:25:41 +0000
Received: from BL6PEPF00022575.namprd02.prod.outlook.com
 (2603:10b6:610:53:cafe::98) by CH2PR17CA0024.outlook.office365.com
 (2603:10b6:610:53::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 10:25:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF00022575.mail.protection.outlook.com (10.167.249.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 10:25:38 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 10 Sep
 2026 03:25:23 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 10 Sep
 2026 03:25:22 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Thu, 10
 Sep 2026 03:25:18 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Edward Srouji <edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Maher Sanalla
	<msanalla@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Or Har-Toov
	<ohartoov@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drori
	<shayd@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net 3/5] {RDMA,net}/mlx5: cache and use TX-enabled aggregate speed for vports
Date: Thu, 10 Sep 2026 13:24:30 +0300
Message-ID: <20260910102432.3845360-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260910102432.3845360-1-tariqt@nvidia.com>
References: <20260910102432.3845360-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00022575:EE_|PH8PR12MB6748:EE_
X-MS-Office365-Filtering-Correlation-Id: 24917d51-87b8-48ef-a710-08df0f25dbae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|376014|7416014|82310400026|23010399003|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	MkOn5WNMO8+nA1E2i/qKcwVkoF0PnZUY1JJAECuLCEcqvXdWoWBHurwcr46KzSGOcqX9LVHvWO9IjDsOaBq9dTI8RWL2MMkMbYuszBp7MOI1yod2vnrAEYyqHIKpsPEKnmqmbU3dSloLwBEH2XNxzw7QnVscMi1F8WLrIVEtUIe4Gtg3wjJCw73XCY7uNM1WpFPsrieeaOPOMJqnsjeddwUq2J9/WHjlsrWpqXSQioS5JzDezt3M3slQHqz5rkTYSLOQRzftFVODwLa9sXjhReGubWiEPVGiAhwo71OXHf1xwLpB/ax+WOB2jX9ScwqXV3WmviYGWyVAS5kAnOnFgkXyBjQpyJtuP0DTXcnauCTZyjIzFH/kxit1Kjshf1sa3x/ytwS6Vv/bap/95SAo8KRx4MAkURvI57vgd2IrXF4Clql7RewvNZ4MCUUXEZkFHd8n9JLsFd3WDmfpP3gRijackJNoVdaXJZmDlcFm2dbVoUq/Iy6K+fgoLl7rP55FofvFznxPHPMmCDlZ+1ZTshlDctSPEF7t4aTHUw4TDuPRnd4U6edzFA0L1q52j9191fyw0njkGkiylBU+Rc8VUrELhqdk+YEHEQ4kum0AVSBt0qZ7HADpgJg/XVoZAh4F0nCBLxyhrI/4YG2IYc+h9WYSxHZJypoTzIiS9inErzNfQfjuGRK553f1Dt5adVJ8
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(7416014)(82310400026)(23010399003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	d4If7KNHvKfvK5yv+v63kMzNvHI8oMKsRFkuwWGwjOoGZgOMHsQjw51+OSo+XelzL1QmDzOpFDrEPmS7SlD27+B/kxqX844wfHv2kpuDV92dYaJOWedmInL8m8Y+DiCIVfBkhpOduIrhMzEU1uRQ3rQDNf/Qobee8Oy3NtV8DzNthVCnrGIsrH32+FmWbmoLf7448sd4fMgli2ulZwJQBWn9PVtFOYYq/FpIpV1SBCM62C3rXSe5E+POaoXN1Bl1fXHvwAl+ZgnyM/RLwmGBfZQ80EPejAdelU8zVPyc1XvaRMdof/tz/SZLKLb55mDvQLmXS3+LFOwf/ptLCX+w3pXcaaLA0SjPBGoo8Pq/fN/w9JWg862dFWcXpjaW3HfhHvcz3ZJMJoo5D/EJZRKgkq8N+NWSUQXMYZ9+FJgnt7WEpSJGmWBtvT6V9jQMMZNf
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 10:25:38.1910
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24917d51-87b8-48ef-a710-08df0f25dbae
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022575.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6748

From: Or Har-Toov <ohartoov@nvidia.com>

Cache aggregate TX-enabled speed we calculated, and use it instead of
querying the bond speed so we can, in the following patch, limit it by
the PCI bandwidth.

The bond speed takes the calculation from PTYS, and PTYS is not bounded
by the PCI bandwidth of the NIC.

Fixes: 50f1d188c580 ("net/mlx5: Propagate LAG effective max_tx_speed to vports")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c             |  2 +-
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 61 +++++++++++++++----
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h | 15 ++++-
 include/linux/mlx5/driver.h                   |  1 +
 4 files changed, 65 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 373ee1f42d4a..6ab7f945e712 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1654,7 +1654,7 @@ static int mlx5_ib_query_port_speed_from_bond(struct mlx5_ib_dev *dev,
 	u32 bond_speed;
 	int err;
 
-	err = mlx5_lag_query_bond_speed(mdev, &bond_speed);
+	err = mlx5_lag_query_aggregated_speed(mdev, &bond_speed);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index c2f21eb4ea7c..76b574fa0d7a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1413,7 +1413,6 @@ static bool mlx5_lag_should_disable_lag(struct mlx5_lag *ldev, bool do_bond)
 	       ldev->mode != MLX5_LAG_MODE_MPESW;
 }
 
-#ifdef CONFIG_MLX5_ESWITCH
 static int mlx5_lag_get_devices_oper_speed(struct mlx5_lag *ldev,
 					   u32 *sum_speed)
 {
@@ -1496,6 +1495,30 @@ static int mlx5_lag_get_devices_max_speed(struct mlx5_lag *ldev, u32 *max_speed)
 	return 0;
 }
 
+void mlx5_lag_update_agg_speed(struct mlx5_lag *ldev)
+{
+	u32 speed;
+
+	lockdep_assert_held(&ldev->lock);
+
+	if (mlx5_lag_get_devices_oper_speed(ldev, &speed))
+		return;
+
+	/* If speed is not set, use the sum of max speeds of all PFs */
+	if (!speed && mlx5_lag_get_devices_max_speed(ldev, &speed))
+		return;
+
+	ldev->agg_speed_mbps = speed;
+}
+
+void mlx5_lag_reset_agg_speed(struct mlx5_lag *ldev)
+{
+	lockdep_assert_held(&ldev->lock);
+
+	ldev->agg_speed_mbps = 0;
+}
+
+#ifdef CONFIG_MLX5_ESWITCH
 static void mlx5_lag_modify_device_vports_speed(struct mlx5_core_dev *mdev,
 						u32 speed)
 {
@@ -1541,17 +1564,10 @@ void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev)
 	u32 speed;
 	int pf_idx;
 
-	if (ldev->mode == MLX5_LAG_MODE_MPESW) {
-		if (mlx5_lag_get_devices_oper_speed(ldev, &speed))
-			return;
-	} else {
-		speed = ldev->tracker.bond_speed_mbps;
-		if (speed == SPEED_UNKNOWN)
-			return;
-	}
+	mlx5_lag_update_agg_speed(ldev);
+	speed = ldev->agg_speed_mbps;
 
-	/* If speed is not set, use the sum of max speeds of all PFs */
-	if (!speed && mlx5_lag_get_devices_max_speed(ldev, &speed))
+	if (!speed)
 		return;
 
 	speed = speed / MLX5_MAX_TX_SPEED_UNIT;
@@ -1576,6 +1592,7 @@ void mlx5_lag_reset_vports_speed(struct mlx5_lag *ldev)
 	int pf_idx;
 	int ret;
 
+	mlx5_lag_reset_agg_speed(ldev);
 	mlx5_ldev_for_each(pf_idx, 0, ldev) {
 		pf = mlx5_lag_pf(ldev, pf_idx);
 		if (!pf)
@@ -2068,6 +2085,28 @@ static int mlx5_handle_changeinfodata_event(struct mlx5_lag *ldev,
 	return 1;
 }
 
+/* Returns speed in Mbps. */
+int mlx5_lag_query_aggregated_speed(struct mlx5_core_dev *mdev, u32 *speed)
+{
+	struct mlx5_lag *ldev;
+	int ret = 0;
+
+	ldev = mlx5_lag_dev(mdev);
+	if (!ldev)
+		return -ENODEV;
+
+	mutex_lock(&ldev->lock);
+	*speed = ldev->agg_speed_mbps;
+	if (*speed == 0)
+		ret = -EINVAL;
+	mutex_unlock(&ldev->lock);
+
+	if (ret == -EINVAL)
+		mlx5_core_dbg(mdev, "aggregated speed is unknown\n");
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mlx5_lag_query_aggregated_speed);
+
 static void mlx5_lag_update_tracker_speed(struct lag_tracker *tracker,
 					  struct net_device *ndev)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index e9f0ef83ce1d..744fbf9a0078 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -99,6 +99,7 @@ struct mlx5_lag {
 	/* Protect lag fields/state changes */
 	struct mutex		  lock;
 	struct lag_mpesw	  lag_mpesw;
+	u32			  agg_speed_mbps;
 };
 
 static inline struct mlx5_lag *
@@ -258,12 +259,22 @@ void mlx5_lag_rescan_dev_locked(struct mlx5_lag *ldev,
 void mlx5_lag_add_devices_filter(struct mlx5_lag *ldev, u32 filter);
 struct mlx5_devcom_comp_dev *mlx5_lag_get_devcom_comp(struct mlx5_lag *ldev);
 
+void mlx5_lag_update_agg_speed(struct mlx5_lag *ldev);
+void mlx5_lag_reset_agg_speed(struct mlx5_lag *ldev);
+
 #ifdef CONFIG_MLX5_ESWITCH
 void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev);
 void mlx5_lag_reset_vports_speed(struct mlx5_lag *ldev);
 #else
-static inline void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev) {}
-static inline void mlx5_lag_reset_vports_speed(struct mlx5_lag *ldev) {}
+static inline void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev)
+{
+	mlx5_lag_update_agg_speed(ldev);
+}
+
+static inline void mlx5_lag_reset_vports_speed(struct mlx5_lag *ldev)
+{
+	mlx5_lag_reset_agg_speed(ldev);
+}
 #endif
 
 static inline bool mlx5_lag_is_supported(struct mlx5_core_dev *dev)
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 83d0a83bbfbc..a83926689e9a 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1155,6 +1155,7 @@ bool mlx5_lag_is_roce(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_sriov(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_active(struct mlx5_core_dev *dev);
 int mlx5_lag_query_bond_speed(struct mlx5_core_dev *dev, u32 *speed);
+int mlx5_lag_query_aggregated_speed(struct mlx5_core_dev *dev, u32 *speed);
 bool mlx5_lag_mode_is_hash(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_master(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_shared_fdb(struct mlx5_core_dev *dev);
-- 
2.44.0

