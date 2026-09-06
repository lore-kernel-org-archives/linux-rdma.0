Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012000.outbound.protection.outlook.com [40.107.200.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5EA274B53;
	Sun,  6 Sep 2026 07:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788678894; cv=fail; b=u/MeeikWqVMKpJ+dkpTZAhZj8rf+kvLVgcAqmTo6Zr3UNCpXVT6DUuZdwHbn/tA9R63NjcYR4zynxR4VHV7SMyYw6ykLhbZWAJOMm817/udWUa357Ou/hsoGQIEhvRyVD0W0BSD0AiiHg/CXebCIv1VPMmXittU11Xx1JwRCP24=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788678894; c=relaxed/simple;
	bh=WUPBzc492uG9+j7vEXXgn1tpb5MTuRb8hcbCwhyFmc8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pQcCV8s2h15Nlbx0iZ+GKWxx0+jQPKfAyaZPfPKhxDrhKnMY7ilVdZiJDb6BonEUnQUzKHhj2587sW2EDodl7rR8K0Z10MtUIwA4D4TLPbrC3Iv29fNV6KNl4vSCGeN1s7V2S7R4uZYOjxwwsg9gpVNpl+/1eKksCvZF8rgMt5o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qsmwu6PU; arc=fail smtp.client-ip=40.107.200.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qsmwu6PU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O6zo7xX8q02Ok154F0YjsiPsafk3li0NDnWhxxNWl5CkNQmVB0RiyQmrO4XVNoIT3dk4BE7g2TEWIE2RxsvBS6xni1pZstkRNYSl/LpRcCr+M15/rixoz4vPx5AEWc0l5FpugdxaUoRHg9AnWTdak+vkhlTkZXJbYb2QkpdKlrpIyjZlEUGn+BDNS3dea9mcwfsa/jPXOi1n1Pqsd7Q/B5FYRDKxlLjKtSvgddQSDRhwR8ExXj2uKm6qB0Ium7fM1KbATdtK4fX40MxkSAggIGcVROnTVhly7tXJ3OB7MWyEUdi1ZQkCsSh4TrvsoQ/pl3dQaAC2a+7Xrfw9G+cmqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L3451Uc0B9byiYsKzdzGLih+2AfWg2zpoEJlXdDj+pQ=;
 b=fXJmpFEqlUmsvGp+ce+LbUvJ2Doa/9f7nIfSM2LpTz7ifuVDznNyas3mH4C7RNelbjFu+U86IJxUO5Rh59NnhqncjhS/mJ/Km/eDO20VK/fgd2IKjtz4s+8Xx34itR0EGVAqQjjXUCrb1E6oEEj1Q7Q6XkTaXgcoWrde8ifGypaiHsy2GHRWZs9179OQjrmbBDbuZj1KjqRTXIZf30tJPQdqlZpozTijoKeKT3i/PRjOCGVQvoZFmHhgIug2ySylAuEs1I9Ham4ARirSciRlcYp4R1tvTFm746WBlQUKhK4JjpKkdeXeIE6nVizSr83OYCyyXaX71u0FHeprFutHqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L3451Uc0B9byiYsKzdzGLih+2AfWg2zpoEJlXdDj+pQ=;
 b=qsmwu6PULbB91oJz7yNY1ck1aVvf8gtcQtp7jgglyAWNCvuUgV6IXCMsP87JPnhfqQdGF1QHAFpKs7ev8aFwjHOBOs4Mz7MHN0u1MJStSQ6A1pR7R5HUUlzg4dNUTL8vGIa0cxS/uEn5fTgBiNXqBngM7ha53q6s/6wUeuOMU4I1/YF2f2yhuPBiFlC8WvQoWGpJBFXOQeoYyMnNUken2x7Chv463gEqCvRU+9G42IHgkZmAHonCE06Il8yZEc4lDLcC5rodQ+DQKnbXTfrO2ydQ65Mpz76At8dFO//2tJXDxpc/ChnZxjaWgVTnglZJPYoSbmqYkxlrqpU/1wj8Nw==
Received: from SA0PR11CA0160.namprd11.prod.outlook.com (2603:10b6:806:1bb::15)
 by DS2PR12MB9664.namprd12.prod.outlook.com (2603:10b6:8:27b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Sun, 6 Sep
 2026 07:14:47 +0000
Received: from SN1PEPF0002BA4D.namprd03.prod.outlook.com
 (2603:10b6:806:1bb:cafe::79) by SA0PR11CA0160.outlook.office365.com
 (2603:10b6:806:1bb::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.15 via Frontend Transport; Sun, 6
 Sep 2026 07:14:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF0002BA4D.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Sun, 6 Sep 2026 07:14:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Sun, 6 Sep
 2026 00:14:29 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Sun, 6 Sep
 2026 00:14:28 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Sun, 6 Sep
 2026 00:14:23 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Edward Srouji
	<edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>, Kees Cook
	<kees@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Maher Sanalla
	<msanalla@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Or Har-Toov
	<ohartoov@nvidia.com>, Parav Pandit <parav@nvidia.com>, Patrisious Haddad
	<phaddad@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drori
	<shayd@nvidia.com>, Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net V2 1/4] net/mlx5: SD, serialize SD LAG init/cleanup against LAG mode changes
Date: Sun, 6 Sep 2026 10:13:29 +0300
Message-ID: <20260906071332.3759199-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260906071332.3759199-1-tariqt@nvidia.com>
References: <20260906071332.3759199-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4D:EE_|DS2PR12MB9664:EE_
X-MS-Office365-Filtering-Correlation-Id: e469592f-bb64-4a3b-a730-08df0be6880f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700016|1800799024|376014|82310400026|23010399003|6133799003|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	wSfod2dIS0xjKcl6+RAcSZDEl4yRrNKVwCBiN+CXX5fO+dlb+b7Q/5cmcZNDy8n9nhrTWSK4mPLO4W4wUupof0d3n4zAsgm6PpDwFTN4yDvi/pnDYhWjbpQr1MVYeGfpMVsF8PwK43v/MXqlABQnOi92wOFDR7zB6vv4QgHcj2L84SkepSizIxNqQ8t3q4chQTU7xROUh3caYbjYf0c4MDtOW8jvvUMLK9JHwTJ9UivO/Zr4jx9Xv88pL9OhZ8AHfev/vySX5smu2fPyBFHAYIzGNiANP8cmlX0fNX3dq9JUnO9QNxfWTd+bAU1Our+EJHcvUdMaHaRjmmjqWLUnTUtsBGRCXlt3uff4nrWDP0rOcZiP4lF1G81bkJq+bS55kNPrwM/KZ5ZtWnxGQZ9AkVwq7no9L1kU/NQBy0UdmQjwT32iN/UbQlzzkThy/ZiF29/EDwRM/7GN6VzECoUJC8ZIPJ/u4MIItWsua1ag/gGlcX2bVoYS2L1XlZ84xW/5qsPEVh5L9oYWpYzGNZHYxriW5o6s5Nxxf6DWsGNfKhkoFdrf5xyXqyqXFRRC4DIZ+wtRGwirFzz5sHaTrDM89egyOpJ1tCHcfVZi40y2DX8/Aekc8yP1YA+WSclIatTnAXifubnjjChNeQwl96mYoyLyReaLEtb7ZYMrPqE+tsM8c1O0pvUXtJfpWJWceczvEW7XRwWKtX5RzXRibMzhlQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(36860700016)(1800799024)(376014)(82310400026)(23010399003)(6133799003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	u30u+kH2zRG46O8DLhqBhBOy/CPMONcBux48OO7JHhIGRLjMyJI7CYthK1jidbPU7Ua1r3Sie0KxD9nTgeMeUZueuu2wHXWILrVERvJmk9oIg5scnQvK8hR6W4VzDnuEfqGK+4MTFf4iUMjONzA0dG3D0FuxwClGvR5Gn0DJtAyFXzjlhYiIOMbpgYnxjN9gjGLpBwRS1j5q7Mv76d829K7EKcOMG1RKj3IAMmIkmWpjO0WILqMubpbH5hf2dETttMUsvWk01NAo6tTcXSo6ZQQdmVgQbS99zuUUMQ8CUMN93vmQnaY6kGdtjoNUEpGrgAU85NmgjG6Xmc0bMCzZz8x/Zg6k9QBE1U6GR1ikUY2tAnqgagCR1jW4EEZkJoqajOj42jQ6WKBLVTzmgnTgB8NgbrAbRN7cMc2fuO44kLjkiD1mT+efKkao7aj4Gvam
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2026 07:14:46.1597
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e469592f-bb64-4a3b-a730-08df0be6880f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9664

From: Shay Drory <shayd@nvidia.com>

A secondary SD is spliced into the primary's shared LAG device (ldev)
by sd_lag_init() and removed by sd_lag_cleanup(). The LAG mode-change
paths drop ldev->lock mid-operation while iterating ldev->pfs, and rely
on ldev->mode_changes_in_progress to keep the member set stable across
that window.

sd_lag_cleanup() did not honor ldev->mode_changes_in_progress. Which
means a concurrent SD teardown could xa_erase() and kfree() a pf out of
ldev->pfs during a mode change's dropped-lock window, leading to a
NULL/use-after-free dereference of the secondary pf.

Make sd_lag_init() and sd_lag_cleanup() wait until
mode_changes_in_progress drops to zero before touching ldev, mirroring
mlx5_lag_remove_mdev().

In addition, fold the SD shared-FDB teardown in
mlx5_lag_disable_change() into the main locked section. Otherwise the
two acquire sd_devcom and mode_changes_in_progress in opposite orders -
sd_lag_init/cleanup takes sd_devcom then waits on
mode_changes_in_progress, while disable_change increments
mode_changes_in_progress then takes sd_devcom - an ABBA deadlock.

The same ABBA deadlock is present in mlx5_eswitch_disable(), which takes
sd_devcom between mlx5_lag_disable_change() and
mlx5_lag_enable_change(). Move that call after mlx5_lag_enable_change(),
matching the ordering already used by mlx5_devlink_eswitch_mode_set().

Fixes: 3c103110835d ("net/mlx5: SD, introduce Socket Direct LAG")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  2 +-
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 30 +++++++++----------
 .../net/ethernet/mellanox/mlx5/core/lib/sd.c  | 13 ++++++++
 3 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index b6e2c153b4f7..50e158b6a684 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2062,8 +2062,8 @@ void mlx5_eswitch_disable(struct mlx5_eswitch *esw)
 	mlx5_esw_reps_unblock(esw);
 
 	esw->mode = MLX5_ESWITCH_LEGACY;
-	mlx5_sd_eswitch_mode_set(esw->dev, MLX5_ESWITCH_LEGACY);
 	mlx5_lag_enable_change(esw->dev);
+	mlx5_sd_eswitch_mode_set(esw->dev, MLX5_ESWITCH_LEGACY);
 }
 
 static int mlx5_esw_sf_max_pf_functions(struct mlx5_core_dev *dev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 2285c889c215..aee5ce471eba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -2589,6 +2589,8 @@ void mlx5_lag_disable_change(struct mlx5_core_dev *dev)
 	mpesw = ldev->mode == MLX5_LAG_MODE_MPESW;
 	if (mpesw)
 		mlx5_mpesw_sd_devcoms_lock(ldev);
+	else if (sd_devcom)
+		mlx5_devcom_comp_lock(sd_devcom);
 	mutex_lock(&ldev->lock);
 
 	ldev->mode_changes_in_progress++;
@@ -2599,26 +2601,22 @@ void mlx5_lag_disable_change(struct mlx5_core_dev *dev)
 			mlx5_disable_lag(ldev);
 	}
 
+	if (sd_devcom) {
+		mlx5_lag_for_each(i, 0, ldev, MLX5_LAG_FILTER_ALL) {
+			pf = mlx5_lag_pf(ldev, i);
+			if (pf->dev == dev && pf->sd_fdb_active) {
+				mlx5_lag_shared_fdb_destroy(ldev, pf->group_id);
+				break;
+			}
+		}
+	}
+
 	mutex_unlock(&ldev->lock);
 	if (mpesw)
 		mlx5_mpesw_sd_devcoms_unlock(ldev);
+	else if (sd_devcom)
+		mlx5_devcom_comp_unlock(sd_devcom);
 	mlx5_devcom_comp_unlock(primary->priv.hca_devcom_comp);
-
-	if (!sd_devcom)
-		return;
-
-	/* Teardown SD shared FDB for this device's group if active */
-	mlx5_devcom_comp_lock(sd_devcom);
-	mutex_lock(&ldev->lock);
-	mlx5_lag_for_each(i, 0, ldev, MLX5_LAG_FILTER_ALL) {
-		pf = mlx5_lag_pf(ldev, i);
-		if (pf->dev == dev && pf->sd_fdb_active) {
-			mlx5_lag_shared_fdb_destroy(ldev, pf->group_id);
-			break;
-		}
-	}
-	mutex_unlock(&ldev->lock);
-	mlx5_devcom_comp_unlock(sd_devcom);
 }
 
 void mlx5_lag_enable_change(struct mlx5_core_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c
index 4cdc50cd6f03..99cf455a61e1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c
@@ -345,7 +345,14 @@ static void sd_lag_init(struct mlx5_core_dev *dev)
 		return;
 	}
 
+recheck:
 	mutex_lock(&ldev->lock);
+	if (ldev->mode_changes_in_progress) {
+		mutex_unlock(&ldev->lock);
+		msleep(100);
+		goto recheck;
+	}
+
 	pf = mlx5_lag_pf_by_dev(ldev, primary);
 	if (!pf) {
 		sd_warn(primary, "%s: primary not registered in ldev, skipping\n",
@@ -388,7 +395,13 @@ static void sd_lag_cleanup(struct mlx5_core_dev *dev)
 	if (!ldev)
 		return;
 
+recheck:
 	mutex_lock(&ldev->lock);
+	if (ldev->mode_changes_in_progress) {
+		mutex_unlock(&ldev->lock);
+		msleep(100);
+		goto recheck;
+	}
 	mlx5_sd_for_each_secondary(i, primary, pos)
 		mlx5_ldev_remove_mdev(ldev, pos);
 
-- 
2.44.0

