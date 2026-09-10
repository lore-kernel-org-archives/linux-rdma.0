Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010042.outbound.protection.outlook.com [52.101.61.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3933B6BFA;
	Thu, 10 Sep 2026 10:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789035946; cv=fail; b=A6nPeFjEfQwtie36jCSfw1a5WqlcqC9OlYKttl6+I6Ov/liNvrHfJsCNXZf5U6GoIE0wwZPYp+jUh3qs0p/e3wvFdzgMJaSldf4mTUv5br/w86/EieomvoiGJ2nSISEs+ZkB4p6Qwx5e/0K8DcNUEGWpf4ezwauMglrdpm/burA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789035946; c=relaxed/simple;
	bh=nzJNKvILyuKLCxaY4ISQqRhJKHMpi61qmrETBFpxAbc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RjNw4yv079UQ+Ym6pT4koAc7T3hxpg3lpuLHNMcyAFYKE6zdCzK97AjKHyig4E86Bq/NF75ri9Zxqsf3NafZyvq/x3ZTOn8mBFLYS1Yz8nqN0OMNQMyUqq2L6q/8qGvzYrD04BFONBrALBJCnrwAnw1fzZcJ0cdXKqDoFn5Jrx8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oEHw6Knd; arc=fail smtp.client-ip=52.101.61.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oEHw6Knd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eYGl4ypMZ4TkTDbnokAaXEUjaRyjl3pik47gemYPNR0SdtFicuO+c5Zw0aS+vaI1peSeDiErMVkHNBzNgGJry6rZCxJUmgTU0q4rHVtgUVStoKuXgXgU9zo7I4eY36l4Hh53a5K7HRsHSOcLL4UklRX0qinSrpE1cn98i7hUG5qwCe6KNr3lhOtks+JbgZ606FgpNAACSGDTLoFnPb/GBAB5QbAgCabDyEcFgQKZcbHcu6sNqrEY/yiJVJReSNRgDw1SqVbLUTgJWivspA4WXVRUmfcZwWQwiJngz0ntGieBD8Em5mBTzOKntgI5ZQ8vPTDZ6E2p7uCiJ5EkYORDGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D4uFqj5113Vpl3EM1BHmgHjgeveDL4fxpYxBpZ1s8PA=;
 b=GtqGKV9bT2IYIR2ip7lzuKSKtuhHS8XGGQBScIahp6ll9QnSCVqw/JOi9pYl/wez6fXCj65nGr9vSyYk+tuDrjYtSP+a2gKhA7z0GCQl66fT/w/7poULKcQhVc35pGLpQIsCI3RoZQuoSCfgY9T/S4G3eRVeLxV7i0MZvfqycuOQ6Zmhi+0A6nK7R2oXENHrNXQc2mlVftOmAM/IkfLs0Lb/X4xf9yKm4TAe4zSbj9tqffNMaXYDnPThtbPofJ49lwDBYNm53lOC4zIcmCp+Q9+iNBZN21jIlawKoSIrfdjfpwo+Er4higUf8JprE70EwfIBP77s5N1Fk9LgJrXL0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D4uFqj5113Vpl3EM1BHmgHjgeveDL4fxpYxBpZ1s8PA=;
 b=oEHw6KndmEtRWkqufuQgI46WYune2xIhB67f3tjorv4WbnSb2WAj799sFUaqPPifvYrDNlpLfXPkTlVE0Ft+zg+WR4XkWu7ckkThTG9xOPxskKWCbUx6c1S+CdQCv76HSlmCIX4vlRlVdQSsSAdADN/IvShTKY5lKd4RKy07x4uRF1ul/Qf3VzHnF+l6Mn61WU7Ds9pIjdfwqh6qCVqIURyYlzf5TEqEg5QD7tlk1/JiG2WKa/Hx9elEAjW/AzxZHGFm/4URvbviEqFPNdDa6yZVHvRZoMzQDEuMy5Tlt+QVLLiFFuya8RM/TH1L/EtMk0FJaqkDe9xkNbyIxUrgBw==
Received: from CH2PR17CA0030.namprd17.prod.outlook.com (2603:10b6:610:53::40)
 by DS4PR12MB9562.namprd12.prod.outlook.com (2603:10b6:8:27e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 10:25:30 +0000
Received: from CH2PEPF0000013C.namprd02.prod.outlook.com
 (2603:10b6:610:53:cafe::9e) by CH2PR17CA0030.outlook.office365.com
 (2603:10b6:610:53::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 10:25:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF0000013C.mail.protection.outlook.com (10.167.244.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 10:25:28 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 10 Sep
 2026 03:25:13 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 10 Sep
 2026 03:25:12 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Thu, 10
 Sep 2026 03:25:08 -0700
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
Subject: [PATCH net 1/5] net/mlx5: Lag, split aggregate speed into oper and max helpers
Date: Thu, 10 Sep 2026 13:24:28 +0300
Message-ID: <20260910102432.3845360-2-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013C:EE_|DS4PR12MB9562:EE_
X-MS-Office365-Filtering-Correlation-Id: f06fa30f-a364-4af9-4151-08df0f25d62c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|23010399003|7416014|376014|10067099003|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	sncpaAEbcx4nLNdVm2O7jDjAnRc3NvAWu2YHjf3ne+gQf+kdCK5HddXxyZL/q+6OfElhkJYd/KE2Cy1PxvpubK02yRxPKOaqx2K6s/2QmT+wwMbvirage75HPAn0BW2AFI0P9AeDOMYV4TY9xPCVkIk6b8ZdGbXXv/EXB4Yv32XQdbLY7OfveLz3b5PjYONx3f3sf4enMuHlVWQraw0amXaRpIetsuBC4w6QGB5Ho9cRgM0VnTKOBPqzcZaydeQlNGdgLFefgJWeABLZDxQ5MjbxT2Kr0jqh/kjXh4t6sF8wf/mAUxfRTnT/rWF4l/4apfvwyvOrrF0WLO/i8V1DWakiaJvyf/j2gVZ112lYk9/uEy8mavGBrSVDTc8uKeen1zLl1j6+xg2CmUK/e0utnm2Fg3L3rWK3V4jM385T521AygFY2qGZCQZSaD2kFXGRbChLsRpOhYhX0zbbCuoIPlxZurq4jBAAxW2Bm3YxkchY9OZf5wSUlfDby8PkhmXkowK8gysOfECqSi0sOEsK+UKNMOk9h2aG7K+SxMVnXIhkRyyDW4BQbW5PTzISkzET9Qd1ndGoq1/gpf2fFVNDuZD9ne+1T6e4cv8oe/DbP03FNQ+CUEhTYhpg6UxKxnFkWRM1+KEkWAhAvZr/Aec8iNCK4dKY7G7QQx9OgyzIkRf8BwP3maxjlDJdr3k8kmg4T8UwhMX0Ha6sTLRJbwmpfg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(23010399003)(7416014)(376014)(10067099003)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	YNIpun6w/cMmsZuybg/oB0ewAOdWo0Mpx/5Z/34ZuMWNCtitBMeVT/B4CeJ1Ighm9CNTOaph5RSYcxAgiqhqRGBzYkzqquTAIEBeD/bhkwYsvV1okNxcM7cXaxDFi/UE41ofaYYJBjq/zVjeRPUn6Ni6A2yEPfl0O+6sY2QP8Nq4i7X4kXULD9UOHqxBQW911FYzGQOXpigdDk2m+GEdVvb29J2+2oAC7RCLo2HVx6Q2GEAlrW2da7gauBNtjoxn5DLJ/JEzM1Y25doGhaj/tpcSQX5U223Es2AwZS5RhDCVsoxZzjh4d+zXThMgnqsYGsFhq1wjoq1XFnLEePmO7SLydX5NsvJBDOqzbGRxtmDqpK0ZH8jrPYrn1eSI0KIJjuwsVszhpOKIcH0tt4qQzKghcXlzi6fXr1GX3Vckiyb9Q29mVfGvOAjGrrJmJCJw
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 10:25:28.9765
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f06fa30f-a364-4af9-4151-08df0f25d62c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9562

From: Or Har-Toov <ohartoov@nvidia.com>

Split mlx5_lag_sum_devices_speed into mlx5_lag_get_devices_oper_speed
and mlx5_lag_get_devices_max_speed. The oper function reflects only
the speed currently available and the max function is state-independent
and represents the maximum achievable speed, taking the best single
port for active-backup and summing all ports for XOR, LACP and MPESW.

The oper function skips a port for two reasons:
- the bonding driver set tx_enabled=false - LACP converging or
  active-backup standby slave, where carrier may still be up but the
  port is intentionally not forwarding traffic.
- the link is down.

Fixes: 50f1d188c580 ("net/mlx5: Propagate LAG effective max_tx_speed to vports")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 71 ++++++++++++++-----
 1 file changed, 53 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index c655f6e32e9b..5aa9d5c98fe1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1412,16 +1412,20 @@ static bool mlx5_lag_should_disable_lag(struct mlx5_lag *ldev, bool do_bond)
 }
 
 #ifdef CONFIG_MLX5_ESWITCH
-static int
-mlx5_lag_sum_devices_speed(struct mlx5_lag *ldev, u32 *sum_speed,
-			   int (*get_speed)(struct mlx5_core_dev *, u32 *))
+static int mlx5_lag_get_devices_oper_speed(struct mlx5_lag *ldev,
+					   u32 *sum_speed)
 {
 	struct mlx5_core_dev *pf_mdev;
 	struct lag_func *pf;
 	int pf_idx;
+	bool mpesw;
 	u32 speed;
+	u8 opmod;
 	int ret;
 
+	mpesw = ldev->mode == MLX5_LAG_MODE_MPESW;
+	opmod = MLX5_VPORT_STATE_OP_MOD_VNIC_VPORT;
+
 	*sum_speed = 0;
 	mlx5_ldev_for_each(pf_idx, 0, ldev) {
 		pf = mlx5_lag_pf(ldev, pf_idx);
@@ -1430,13 +1434,20 @@ mlx5_lag_sum_devices_speed(struct mlx5_lag *ldev, u32 *sum_speed,
 		pf_mdev = pf->dev;
 		if (!pf_mdev)
 			continue;
+		if (mpesw) {
+			if (mlx5_query_vport_state(pf_mdev, opmod, 0) !=
+			    VPORT_STATE_UP)
+				continue;
+		} else if (!ldev->tracker.netdev_state[pf_idx].tx_enabled ||
+			   !ldev->tracker.netdev_state[pf_idx].link_up) {
+			continue;
+		}
 
-		ret = get_speed(pf_mdev, &speed);
+		ret = mlx5_port_oper_linkspeed(pf_mdev, &speed);
 		if (ret) {
 			mlx5_core_dbg(pf_mdev,
-				      "Failed to get device speed using %ps. Device %s speed is not available (err=%d)\n",
-				      get_speed, dev_name(pf_mdev->device),
-				      ret);
+				      "Failed to get device %s oper speed (err=%d)\n",
+				      dev_name(pf_mdev->device), ret);
 			return ret;
 		}
 
@@ -1446,17 +1457,41 @@ mlx5_lag_sum_devices_speed(struct mlx5_lag *ldev, u32 *sum_speed,
 	return 0;
 }
 
-static int mlx5_lag_sum_devices_max_speed(struct mlx5_lag *ldev, u32 *max_speed)
+static int mlx5_lag_get_devices_max_speed(struct mlx5_lag *ldev, u32 *max_speed)
 {
-	return mlx5_lag_sum_devices_speed(ldev, max_speed,
-					  mlx5_port_max_linkspeed);
-}
+	struct mlx5_core_dev *pf_mdev;
+	struct lag_func *pf;
+	bool take_max;
+	int pf_idx;
+	u32 speed;
+	int ret;
 
-static int mlx5_lag_sum_devices_oper_speed(struct mlx5_lag *ldev,
-					   u32 *oper_speed)
-{
-	return mlx5_lag_sum_devices_speed(ldev, oper_speed,
-					  mlx5_port_oper_linkspeed);
+	take_max = ldev->tracker.tx_type == NETDEV_LAG_TX_TYPE_ACTIVEBACKUP;
+	if (ldev->mode == MLX5_LAG_MODE_MPESW)
+		take_max = false;
+
+	*max_speed = 0;
+	mlx5_ldev_for_each(pf_idx, 0, ldev) {
+		pf = mlx5_lag_pf(ldev, pf_idx);
+		if (!pf)
+			continue;
+		pf_mdev = pf->dev;
+		if (!pf_mdev)
+			continue;
+
+		ret = mlx5_port_max_linkspeed(pf_mdev, &speed);
+		if (ret) {
+			mlx5_core_dbg(pf_mdev,
+				      "Failed to get device %s max speed (err=%d)\n",
+				      dev_name(pf_mdev->device), ret);
+			return ret;
+		}
+
+		*max_speed = take_max ?
+			max(*max_speed, speed) : *max_speed + speed;
+	}
+
+	return 0;
 }
 
 static void mlx5_lag_modify_device_vports_speed(struct mlx5_core_dev *mdev,
@@ -1505,7 +1540,7 @@ void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev)
 	int pf_idx;
 
 	if (ldev->mode == MLX5_LAG_MODE_MPESW) {
-		if (mlx5_lag_sum_devices_oper_speed(ldev, &speed))
+		if (mlx5_lag_get_devices_oper_speed(ldev, &speed))
 			return;
 	} else {
 		speed = ldev->tracker.bond_speed_mbps;
@@ -1514,7 +1549,7 @@ void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev)
 	}
 
 	/* If speed is not set, use the sum of max speeds of all PFs */
-	if (!speed && mlx5_lag_sum_devices_max_speed(ldev, &speed))
+	if (!speed && mlx5_lag_get_devices_max_speed(ldev, &speed))
 		return;
 
 	speed = speed / MLX5_MAX_TX_SPEED_UNIT;
-- 
2.44.0

