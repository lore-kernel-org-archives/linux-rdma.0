Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010054.outbound.protection.outlook.com [52.101.193.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDA34AA017;
	Wed,  2 Sep 2026 16:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367262; cv=fail; b=JrILRl27RjpkFsOVaBSbrBzraz6UQbk6uZi+ZmX+nqC84ec1GraOVTDKmWn3YK5NjmKGaLZv0ejqDRQc2umbEECcniufBPFP2hGeyfKJTFqMggkMnV9VONGgKP+pJ2NclGoFaGgN+Frw+JdmlcsfZ9ST9UR94hY4UbV1l43no8s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367262; c=relaxed/simple;
	bh=lFrtYINS4KwveuY4CtkG/EzqL4ryjZuZu4WnDVFZ5Wo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bye4QbOeoKXC68zgUpWOTJ4lktLAExIeBk0BsMHnjQMAFsiUOzUZbYyEyLAjoXs2AFymqSWS1+yXEG8EDGuyL138wG1FJGx8AQHt4KEQKfmCCziI9+OQa1tqtlcHvzMItoS5oxKlPu8JZ2vlTBh8u0lINcr/HDO6bxuZtHcJh98=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=n5A/DQAT; arc=fail smtp.client-ip=52.101.193.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="n5A/DQAT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jFWfkDq6uyjx4iflpc+LRxcR2fMfQEA+7Xv5cmqvhBC36xuv+Gf8Z63ujUe1Lgxf1uwAJ3GK8mUGBJVnp1nZy/7mtqUMx8MbX4byP4QkCa4RVmwUs22OVBi5PVWyIrBKsyxXxn0oYw3F0ROI5f4tGMomZheYWaAL13jcO1AZUOO9g4aWxgTXEyNV8SOV2pcvKC4nSVmb4pVPcQtLla6MsZnAPGAqvL5FsSzndKp4mJsxY2d+qs8+1kglwh3On6EXnogGuoDnT+2qHL8c3a7iAXz4xcv9YIt6tv3Ej1B+KGxxCRVdi54vcBbzhggpn3/DgozMVYewxLC5+ORBtVNaqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PL6q35H8rfX8uQvsCXp438IIC0F4uWvUvbHFt5vdMvA=;
 b=ep67VJ2wV2gExL+/025nWoTizcH7wIkCCqxCk8pPlM+JJdPZlLM0GBmxyU8ubt1wBiLSG/RZVD1WyHcTc+2P09VYkOQ55TG1Dc/d1vHRgJcPBwS1uNvVAEu35kPDZJS3lXQxNJcaur86gBsNcn1uYoURKvSHly4JPM8d5EVSRDV1Sn1ISt8cLdcsG0pnYBVG3OaqCn1S343H/drHU7pTGmy21n7D26BY75RUyFbsN7dH5C9reQl0kSOqGTGS5JWsNrBJI33ZryoDeBdRjuQjjzZk/ySDRG4zqrccOvLLOkUPakleROG5SrQSj2f0DI96pMdJHP2V4QRk8s8UZYnBiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PL6q35H8rfX8uQvsCXp438IIC0F4uWvUvbHFt5vdMvA=;
 b=n5A/DQATom9wHgywJNWKrec/Hcq/tnKBp6tfyqEV8P4NaT017/2hBUi21Y/NbouDTAiXNiDU+7P5nJTbu/ipTJiYYlog8o3lMgFSbJVvvVJcsD0KhZ9Jy/EMjBmT5fziCuMHeZmSGuQ2GTv0fQl8WCskDxLvID92C2e5E45FeBoDdjvy4A/AFRmHn/7gh0ZmcEkgkBT+i7E6Ld+SLolxLmD9DbAh4AM7yyebGSN94bZK2vMLyswxGJblC9KSHuctLKhaexVUl7CxbBYe0dEYB/8QBHVxBTYCOVu/F0IcJrCCnL0I33nCT7NtQjgI1j9Sz3SrYzJT+BwtjxcM0jhn4g==
Received: from DS1PR03CA0002.namprd03.prod.outlook.com (2603:10b6:8:450::9) by
 DM4PR12MB9069.namprd12.prod.outlook.com (2603:10b6:8:b8::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.13; Wed, 2 Sep 2026 16:40:51 +0000
Received: from DS3PEPF0000C381.namprd04.prod.outlook.com
 (2603:10b6:8:450:cafe::4d) by DS1PR03CA0002.outlook.office365.com
 (2603:10b6:8:450::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Wed, 2
 Sep 2026 16:40:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS3PEPF0000C381.mail.protection.outlook.com (10.167.23.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Wed, 2 Sep 2026 16:40:50 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 09:40:26 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 09:40:26 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.46 via Frontend
 Transport; Wed, 2 Sep 2026 09:40:21 -0700
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
Subject: [PATCH net 1/4] net/mlx5: SD, serialize SD LAG init/cleanup against LAG mode changes
Date: Wed, 2 Sep 2026 19:37:13 +0300
Message-ID: <20260902163716.3656279-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260902163716.3656279-1-tariqt@nvidia.com>
References: <20260902163716.3656279-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C381:EE_|DM4PR12MB9069:EE_
X-MS-Office365-Filtering-Correlation-Id: 74d37b64-40ef-40b4-3d8f-08df0910f2cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|82310400026|7416014|376014|1800799024|6133799003|56012099006|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	BqPb5FiNVYXrehd64M6jk4RNlkSwaAH4+uqZ0xE8c/vLPumT4IUE1Gp2Q+3TtANvNYT1DtKwwWTM2nhfOecforyGJhz04NrCJpVIgJIvkEIkBzMqxpUTEaIiK6mH8+1K5UYq7tiCy0KoauQUD8G1X6bdamvx8SnNeyH8LgZlNSL8jmK2bRxsk+N22Pa14lv2bXHomIJUAhnZ6OlqvykAN1BEYGz646WhFSynNHT6pCQtRi03IFcORwX5RrmBOYQI+kJOoA5L+YL7tqYJkVZtt2Kbawbjx9ZfMvH5i7MPaSBFlh97i/LOTGhcZpxYbzVniRhabp4VeWrqCpURQxesEXv7OcW/vohiUzHh77dVqyCcCiF+l/0DR2blZ5ae/O+DBiaoAjuMjtPn8yiwG6ko/4R8t0K3fUgi+j5ZpRBKZbtWh/LZCjVEVe6DjXfdG4GsiEzmiwtnYgbmjpqaQpFPUmpdL0TM9zTpv6QZjelmUpDNo2wHYMGvd46GQ+wyAdTmaAt07W/JBkd8mY1fjSGvdM7dKdAacHobVbiR1wU1cy53BFRvdY8s8S5R13F0kgByNx7mqcARGknyV1uwdU6bZjktIlxGRen3D052Vvig8nsPjx1+WD5t1WGHY04qB9FYldYsc6JJOGgNaMcAjKl1SYIa5U0SpkpbIRPyqd/d8E0YKEPj34iRnK9DH/L8O2vU9gOXlc1WxruRtl73p1GzvA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(82310400026)(7416014)(376014)(1800799024)(6133799003)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jAM0DVhjWcFZgipwT6Ez4j6phwlys7Vgm+O6NXv3mAkGzZq1Zpm+86dlgsExu6/yFjmix1yrZAXyxe5d66E9tPJoh/5n6wf7oYnUblG9LjZGw3U3q+BReP5LKC3NYWUEfB5riy5LmgbUdr4kPPsbFXbjsISfeGhuDqX7RAfD5EkGIdHAPxCj50xFrqBBNDZ9LdQSdn3St2JSusCkHKyKsPvmsM1Mk6CzkMtqoUo4L7DhgwTA+vLauh0T8m/OtTouCIJtGzSHDZI3oF23UncN6Yzxus1/tR518Sm9HpoXE46zjzPwbsdc0EcsjdxiJfoWVaIaUjC0A+3idP5vifWRKsvNB6NHXiP8DByErhxNjkPHKbGNCz1Mk4KXcizV1oA/mSlK4FsVnaBRfT2mawmrRAETLXZTdd1hsVxfRYUZsAe1RP9hvIEOdr4QoJKYqkXe
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 16:40:50.6354
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74d37b64-40ef-40b4-3d8f-08df0910f2cf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C381.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB9069

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

Internal sashiko comment:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c
b/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c
> index ee2fdefa1945..2b2b7f3916f7 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c
> @@ -342,7 +342,14 @@ static void sd_lag_init(struct mlx5_core_dev *dev)
>  		return;
>  	}
>
> +recheck:
>  	mutex_lock(&ldev->lock);
> +	if (ldev->mode_changes_in_progress) {
> +		mutex_unlock(&ldev->lock);
> +		msleep(100);
> +		goto recheck;
> +
}
> +
Does this open-coded retry loop reimplement a wait mechanism without
immediate
wakeups or fairness?
It looks like we are polling the mode_changes_in_progress flag using a
hard
coded msleep(100). Could this unnecessarily delay the initialization
path if
the condition clears much sooner than 100ms? Would it be better to use a
proper
synchronization primitive like a waitqueue here instead of an ad-hoc
flag loop?

[SD] This is the same check as in mlx5_lag_remove_mdev().
I agree we need to change it, but this is net-next material

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

