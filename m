Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010022.outbound.protection.outlook.com [52.101.46.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8A44DA9D4;
	Wed, 30 Sep 2026 17:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787906; cv=fail; b=adHEeWxh+5Ez0xSEtQ23UCOjIwmnUYRObwgIL1kbC5QxCUxbeGdXUyOUH0WMsk9e9319kxP675vlhNBV6Dc+HStRY1T6pR+DDR5RcOnhl9LyVw7jvAhPTlF08isjM/odsmIApLjzdDuhiuJjOsMMl+7bQ5I7uo4De9FDRldvLqI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787906; c=relaxed/simple;
	bh=U3FcMOZdfbrBQacKizJohVvBhItKJFSMxOO9AewXiqA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZbAsWRlfo+krjOa1t8fZHCK5GXV3l5FbjFqq90KlX64ob4YjkMAwSnI2TWZHcUxAnIwXf5hQoZiCem9e70wYvZFPUEkWx1CefuE1z9LvMxO2WoKGCUsJ9uB4S5lzeMZY3T9BRHwGCz1OybaABT11NrwWDke5e9AdbQPTPYNQwIc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ag7b7V70; arc=fail smtp.client-ip=52.101.46.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ag7b7V70"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KsxIoB7L1Gd88WVY384TmNLlEmpD0RaZe0HmYc/g+ZH8Kvc1uRAG55wIeTX6HdLQqCddr3bNA2P7zzGa3XJ7rlI7RuDkVbZ7YrGvydZEMSRbWbwx4dBk7wX6WT9MlLOwi4SGgDx1kSWfqUd922zcCiWA6nVnINB75fbrOx82OOl3Q+f0k7QvjQHjvfHu60b3tQFIPR5571R2q9/3sTbfHqi/B16DvpQdSQzQ30KDGI7CNuBK7lCKDEeeIleQFQ/+i0s4IBO/mIs7k2MHJRC8fV4+K+P+7MNROIDH4fTgMT7PCHwatH3zpiOlGcw1oETWnINvldtYRHHZBeTEVKGI/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o4yRVUgC0vDqyENmLTEynPGDAtqk1saz9G7LI4Duni4=;
 b=UlV7vEc3mG9vAAqvWLSOay0Sa5vkaqJjcJQMtJuVVRjSymBD3ll5ps7hv/r++hHmoMR9MNDbPKXv7Sidd2qTUpGoIvajaHEd9eAIog0GZ0bPT658V+I4DrQuVkKuOHLKcv7+Sq5El8TiOVCaRlxDVPvcI7ip49lg7QpoOWUpapCD4oN7dNU2kUelGc0gQK69kCXK60JgBc3kHemwUJsKQEc45gI1LZNPo4XkQc71NA+s3/YvfL2KYJlq/kGXOMuQilacVUiE75ZM2+uQhiKoNuRvPgx1xWhHb3Ga+LXr98N3D61q0K8ZdO4IAeO/nPNjehfypLyain26wv8AISNvSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o4yRVUgC0vDqyENmLTEynPGDAtqk1saz9G7LI4Duni4=;
 b=Ag7b7V703QsctnRVK/lLEze1fvBP68VF21pzNhW8cGyHzw9W446V4yVOoMP7JlZ6M03g/ZRP5mRzqltp/AqGqFuHmstDm3K020tjDlWvfmDZ38hrZXhxanM2mwMtSSosxXxhSaZwTOpWBeQyUxvl8EjkyoD+MMNCVVvHNGH6HbOf10Gvzzrv/85eefQjnZii5Lw4WsVR9MALv8efWpuR3sQcYyKsqaXyBsEMJaY50pxx3c9vr3b+ptgF0Zw135Bdbwmm/YROvt1Zw898bFATN9qB35AdKdjNvRoUm/enYbwBRMrUSSssXU08rb/tW/6JLmj7QVZwlDRoIjBkYxt6QQ==
Received: from CH2PR17CA0006.namprd17.prod.outlook.com (2603:10b6:610:53::16)
 by MW4PR12MB6729.namprd12.prod.outlook.com (2603:10b6:303:1ed::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Wed, 30 Sep
 2026 17:04:58 +0000
Received: from BN1PEPF00004685.namprd03.prod.outlook.com
 (2603:10b6:610:53:cafe::27) by CH2PR17CA0006.outlook.office365.com
 (2603:10b6:610:53::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Wed,
 30 Sep 2026 17:04:57 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN1PEPF00004685.mail.protection.outlook.com (10.167.243.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 17:04:56 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 10:04:31 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 10:04:30 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Wed, 30 Sep 2026 10:04:26 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Edward Srouji <edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Maher Sanalla <msanalla@nvidia.com>, Mark Bloch
	<mbloch@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net V2] net/mlx5: Lag, split aggregate speed into oper and max helpers
Date: Wed, 30 Sep 2026 20:04:06 +0300
Message-ID: <20260930170406.148548-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004685:EE_|MW4PR12MB6729:EE_
X-MS-Office365-Filtering-Correlation-Id: b93e72bc-9a40-414a-ca22-08df1f14f480
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|1800799024|82310400026|18002099003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	GGXiTB5+I+9b3+ye/79QcolK3qPVkYTv6yp23du6DGqamKV/NvGooBTaMBW0LRGolYZqhE2kivwepFu5k7eEF4tqunYk28v73nZLVfJMFhYV6uPcXuAorqzANJopk2gqMEAgULM3PO5/8kT1lthBqAzzrGwoJoHBPtM+voZcu4DJZb0Zecu1aGRvcJloKQZST4IVoewvm47/KQFX8vz8/o3X8g7V/1VibTW0dmtfmWvZ8EbGn2Q0sGeZwPyurQ/0/o94S748TJtmADHOVk9v/nB+R0ukkPBjt1OwHgeKh54nWSOA+xxALiao1JVmMdc7p+GwIaRSWrDD88SMZ/BhTwUIp29jjCNyIqZ/vFf/UYsVHIKDMiGBg6FYE8XiJbKuDiywzGP0J99Y/gI2mlq4Vo2S+V9D8ekw28EG/k3FPnr1Xj+vOJAWNqVkA3ZWX7Uddc0HeAXQIVG2I8IMoEINgHTGoJ10R+eVJu5uAGrNnZAY3Kxmu5SaflHY/6hkyXxXxYZkmV5Al3/FYjW96L/qkId3ulfVEaNsh3l6LC0fiXenHQ4Apd7+R7/f31XY9sJAkV5h0cgQ6vMLtq0i60jNzQLccO2axnFI6S/zk+c8CtMY5BlSF6Sz3Wc/MSNMtQQgRbEYFw82ZOy9I+Q8nPPexQ/ddNbcEmaTxrf1ixKlJdwNupzK6UI0JU8VdAbvR8/mLPEnSHFu4QE3c2qOUHLsqA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(1800799024)(82310400026)(18002099003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	egmBI8h1hVpjyDX1MaCUO7jOHJQyHcFo0/gM/qXzD/BezqAT3xJ6+Zl1JwxDYxueVIBQ4UBKjTqaTw+rKGSqmg4SpsI5oy6RhC4/FyU3WEMrwqqleWxL6Us71IiIPyNoGeuzxj4jyIYXAp0HF3Q8BoKT/eCcMlMRB6n2ZR8MYDVZaLyqIfe75FdRcDZAnOwB3hJjxHhpVLCXoEdL8twb0q8YB8R6UmNExDfeb+/defE7huuqxVQQM9ez5EErLJMRkjs98gkXXlCxj/QyqoPBkRXLICXJvNG7x0cts6JjQIPmxiUeZZU3UwjAcF99lfhSrim2FE+4xLGUzX/qC7KYin0ga00UCJbtOIl1t/rw4ZbxaLFviZIf2ZzWyf8rZHBTBUCsqEap4pVo+VnflZL/ujyBAifoaNPXm0rAKEBQMZhkgs3D1PdYHLzLglN6yGp5
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 17:04:56.9970
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b93e72bc-9a40-414a-ca22-08df1f14f480
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004685.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6729

From: Or Har-Toov <ohartoov@nvidia.com>

mlx5_lag_sum_devices_speed computes the LAG aggregate by summing oper
speeds across all ports. This has two bugs.

First, it relies on the assumption that a port whose carrier is down
will report an oper speed of zero and therefore not contribute to the
sum. This assumption does not always hold: when the link partner
disconnects the port transitions to DOWN state but firmware may still
report a non-zero oper speed, causing the aggregate to include a port
that is not actively carrying traffic.

Second, in active-backup mode only one port transmits at a time, so
the aggregate should reflect a single port speed rather than the sum
of all ports.

Fix this by splitting mlx5_lag_sum_devices_speed into two helpers.
mlx5_lag_get_devices_oper_speed reflects the speed currently available:
it queries the vport state of each port and skips any port that is not
UP, rather than relying on oper speed being zero.
mlx5_lag_get_devices_max_speed is state-independent and returns the
maximum achievable speed used as a fallback when speed is 0; for
active-backup it takes the maximum single-port speed instead of the sum.

Fixes: 28ea6036dad2 ("net/mlx5: Handle port and vport speed change events in MPESW")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 79 +++++++++++++------
 1 file changed, 57 insertions(+), 22 deletions(-)

V2:
- MPESW state check now goes through mlx5_query_vport_max_tx_speed(),
  propagating a failed FW query as an error instead of silently
  treating it as VPORT_STATE_DOWN.
- Take maximum single-port speed for max in active-backup instead of a
  sum.

V1:
https://lore.kernel.org/all/20260910102432.3845360-2-tariqt@nvidia.com/

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 3b34bec559e0..4e173b08cb37 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1432,30 +1432,40 @@ static bool mlx5_lag_should_disable_lag(struct mlx5_lag *ldev, bool do_bond)
 }
 
 #ifdef CONFIG_MLX5_ESWITCH
-static int
-mlx5_lag_sum_devices_speed(struct mlx5_lag *ldev, u32 *sum_speed,
-			   int (*get_speed)(struct mlx5_core_dev *, u32 *))
+static int mlx5_lag_get_devices_oper_speed(struct mlx5_lag *ldev,
+					   u32 *sum_speed)
 {
-	struct mlx5_core_dev *pf_mdev;
-	struct lag_func *pf;
 	int pf_idx;
-	u32 speed;
-	int ret;
 
 	*sum_speed = 0;
 	mlx5_ldev_for_each(pf_idx, 0, ldev) {
+		u8 opmod = MLX5_VPORT_STATE_OP_MOD_VNIC_VPORT;
+		struct mlx5_core_dev *pf_mdev;
+		struct lag_func *pf;
+		u32 speed;
+		u8 state;
+		int ret;
+
 		pf = mlx5_lag_pf(ldev, pf_idx);
 		if (!pf)
 			continue;
 		pf_mdev = pf->dev;
 		if (!pf_mdev)
 			continue;
+		ret = mlx5_query_vport_max_tx_speed(pf_mdev, opmod, 0, 0,
+						    &speed, &state);
+		if (ret) {
+			mlx5_core_dbg(pf_mdev, "State query failed (err=%d)\n",
+				      ret);
+			return ret;
+		}
+		if (state != VPORT_STATE_UP)
+			continue;
 
-		ret = get_speed(pf_mdev, &speed);
+		ret = mlx5_port_oper_linkspeed(pf_mdev, &speed);
 		if (ret) {
 			mlx5_core_dbg(pf_mdev,
-				      "Failed to get device speed using %ps. Device %s speed is not available (err=%d)\n",
-				      get_speed, dev_name(pf_mdev->device),
+				      "Failed to get oper speed (err=%d)\n",
 				      ret);
 			return ret;
 		}
@@ -1466,17 +1476,42 @@ mlx5_lag_sum_devices_speed(struct mlx5_lag *ldev, u32 *sum_speed,
 	return 0;
 }
 
-static int mlx5_lag_sum_devices_max_speed(struct mlx5_lag *ldev, u32 *max_speed)
+static int mlx5_lag_get_devices_max_speed(struct mlx5_lag *ldev, u32 *max_speed)
 {
-	return mlx5_lag_sum_devices_speed(ldev, max_speed,
-					  mlx5_port_max_linkspeed);
-}
+	bool take_max;
+	int pf_idx;
 
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
+		struct mlx5_core_dev *pf_mdev;
+		struct lag_func *pf;
+		u32 speed;
+		int ret;
+
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
+				      "Failed to get max speed (err=%d)\n",
+				      ret);
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
@@ -1525,7 +1560,7 @@ void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev)
 	int pf_idx;
 
 	if (ldev->mode == MLX5_LAG_MODE_MPESW) {
-		if (mlx5_lag_sum_devices_oper_speed(ldev, &speed))
+		if (mlx5_lag_get_devices_oper_speed(ldev, &speed))
 			return;
 	} else {
 		speed = ldev->tracker.bond_speed_mbps;
@@ -1533,8 +1568,8 @@ void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev)
 			return;
 	}
 
-	/* If speed is not set, use the sum of max speeds of all PFs */
-	if (!speed && mlx5_lag_sum_devices_max_speed(ldev, &speed))
+	/* If speed is not set, fall back to the max achievable speed */
+	if (!speed && mlx5_lag_get_devices_max_speed(ldev, &speed))
 		return;
 
 	speed = speed / MLX5_MAX_TX_SPEED_UNIT;

base-commit: 99b43ede9e355ba35244cc9470bf1819774ce39d
-- 
2.44.0

