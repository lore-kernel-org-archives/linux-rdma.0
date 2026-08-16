Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012064.outbound.protection.outlook.com [40.107.209.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B1B3D5237;
	Sun, 16 Aug 2026 06:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786863101; cv=fail; b=V6O3gNch3PVOUK3v0nToWxiqquqw0NPAQGqMUSQ8j9+1kFf9lu+R6PzLi63vKgT3aZYE2GSQPkdpxRdf++3jreghohkl7181ngFzaOqiEvQ/AkjFRbLMqbGDn7eSGGQdmYf8jC/WYTyIvaDDxIAMOlNlpBL5hA1RljGEyu2h9WE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786863101; c=relaxed/simple;
	bh=VtN9a+8Mer+EY1a/+vvASrjamNCmRM/TV3s5RQg3MZM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uNW+qNNirFrLML06Nwu7VPgn1sFjaatfFzt8r0nJaCPnrP+qYZJnTkmoDfVcBsYGJ7e6MPcXmA8tSFQ9D3lWE7eOvZArnoER7Ef5USk9ZKSJl54svcViHUuwru6PbhrGMJk//GFYhux2YPnIh06ctHFuz1iIjNDSVbCXWP1wN20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=C3ku4O3C; arc=fail smtp.client-ip=40.107.209.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="C3ku4O3C"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aNFNN86vR5SJ8gdKVQXX5xLN0rMM8Cnc0aKaZS8HJDakCiqhGcrtXeGMV1pvS1rnwORLfmlcU2IBKHc5Btb4OpKSqygNJKk44lgtWCQ29M7iAQw6LgVg+GLBrYpN7xKWtTV9tvPqjpSOCfGTXeVEbhkmczZwuTc93eJLpK87/G+dtTdniF7yIbLfNGFn0I2KEMiXBhvVELEwqIOdp1lMS6cfK0Za8krRN0PKCJnAIpFdYOlIglWTyL9s3ltYeld6K/N7KtB7Kmn5ars0erYsb/fEbHW4hhY12aAH8ITJVf1NUoaCnQdSJX5HYykawQ5t84P3UZK53X6vQAVWLSk7XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hhfIVAQ/jpr7l21G3Ne82FEEdDqGrHLJ5SyfOjVRc+E=;
 b=CJnOdNdRrbATCjWveLv5LVAlkxrRcjWb94gUhQMY0Rjy9U0KntAKrmHKbJCG2DQCb3ibX3zDLilZzVtjt75J2e1zCK+07heSjgZN9Nx4ogm3eoi1ke0pZanFEaXayXkJpAQJ6yMyGs40w1I9TWIYYX5DjTG9aptTEF3lEN9uo2u775wZVYqtDJZvN2xoj1S1vBNy1YTdCVztisf/jIO4FPkwY0NeCal1bccvxrRti9QpXOnHuyGPJMciqLQSQqFbCV8H5qApZ0gdzymje00jWbLOJ5HzGyR8UUG3ztyizudHbpGRdByIRCgptoKEZ02vukq61YNoZ099lJEq0PJgDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hhfIVAQ/jpr7l21G3Ne82FEEdDqGrHLJ5SyfOjVRc+E=;
 b=C3ku4O3CMn6u0PUtzbdNWM1OBHT8r+Voh6af9FzOm3o7srhB0VRBNHNqe1MOoMAcLamX4FqDTauwjibHeWSimEfP/59ubZZXM8xp8B8+O9RKUnjK6JqHN4WjZiFDMk+TtJ/fE8YAOwsZjdqVniTOHa9JSoazVr6283vlpHl6U7h609LB14BvIZmI678mvbilL11oa8kAdqJVKw14lKYfK/6kkDIf5N3QdhydFeh1/pS/W8JL71pcs7P9Glk9LBAgd09BQFJnaY+BDMdIwapKNHC/bW6ffdWCvFfsxg7hnnH6rk47s/jWukZFv9Id7oZh3zNR6ocGXBA6B0sT8YjYFA==
Received: from DS7PR05CA0033.namprd05.prod.outlook.com (2603:10b6:8:2f::20) by
 DS7PR12MB6143.namprd12.prod.outlook.com (2603:10b6:8:99::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.17; Sun, 16 Aug 2026 06:51:30 +0000
Received: from CH3PEPF00000011.namprd21.prod.outlook.com
 (2603:10b6:8:2f:cafe::17) by DS7PR05CA0033.outlook.office365.com
 (2603:10b6:8:2f::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.7 via Frontend Transport; Sun, 16
 Aug 2026 06:51:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH3PEPF00000011.mail.protection.outlook.com (10.167.244.116) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.0 via Frontend Transport; Sun, 16 Aug 2026 06:51:30 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Sat, 15 Aug
 2026 23:51:21 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Sat, 15 Aug 2026 23:51:20 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.46 via Frontend
 Transport; Sat, 15 Aug 2026 23:51:15 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Adithya Jayachandran <ajayachandra@nvidia.com>, Edward Srouji
	<edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>, Jason Gunthorpe
	<jgg@ziepe.ca>, Jiri Pirko <jiri@resnulli.us>, Leon Romanovsky
	<leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Maher Sanalla <msanalla@nvidia.com>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Or Har-Toov
	<ohartoov@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drori
	<shayd@nvidia.com>, Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net 1/3] net/mlx5: E-Switch, use state lock for vport state changes
Date: Sun, 16 Aug 2026 09:50:13 +0300
Message-ID: <20260816065015.3280733-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260816065015.3280733-1-tariqt@nvidia.com>
References: <20260816065015.3280733-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000011:EE_|DS7PR12MB6143:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f600a66-f6a3-46d3-349f-08defb62cd3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|23010399003|7416014|36860700016|18002099003|22082099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	+d4lCmtp72lXWn1l4P1y3AHFPSEqDPwwdkhnGh0aqP5WXJB7jy7imqQZZvGcuOOxFVls2lkDx9NaCz/Tj8hMjWZyduD4TYmgZxm1SA/Xy02WxuNLI2fFDahn8GVVC8dMPEI4HcDJA3GKbU0mIjF3Q2ukNMCbYxPxMDlUX5HOcXcerR3EjEP3dY0ipkcbHMyIeRhghumjJOVYsYMvMi63KHEbCu+UXEcEkYlnZsH49POj6hEQHs56J6pftpqDVAesx985W301IZKusGSuG42p0JjwCiyR+FrHIe4Q0FXAM+oAUCjq4cPnf7TZluvt2CWyY868+ES3wxf2BP+vrgc9ANo345X3i+to6xLviz41JIf1UOgwpxF5eWbE7zME780wEXCvGpySY6M1C0hmcQd4H49uTZ+jC+/F4B7hlg3NJiJki6ZRsn1DBr62RoPAT7SjKS0neR4+Am8tnX1MRnp2AbeIh2TIni2Dg6QYl2mnCRN4QeakSM5NYS2SKE2K9qdDBhSdC/RNHNl5Iq0V6PHhL5FRHdME0Prsh9aKDl14VRh0hd1vKbK/BiOqyh97GttyjdcGSlko9UUOQhYUn0/6C9XSUQYZQoCSl/7RSFk40zwMZxm0cNHtbzfGWMquYIiB7HHX8SOnexNUKZp/jLzj4IJTyQuDlwbpOyXZBOc/M7ozHR6rrQs9tnd2fPwiGl+2CpmVL3ywnuQhx2qLBaPoVQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(23010399003)(7416014)(36860700016)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GlSQyxU7mP5A29lKf1xZWUuqjjBMBA/niDaaeaVEio5/NbqDqozXGBvcIbJSZ3En+7bZi7Jy0GF7T2OOlBkKjgYuYyL828tnbuiOfMB/4wK9mAN4cjeOvfFRwt3BsXAGHQN52Uve/cUhf637/C54SHmJYEz86uxIF2Y1Wb1+kcI9dnFLxlAvr9Hhov1TQ36MKivFFhE1XEWtV2kmAilY0xiP8JSBxOoODmZfrAEPTLFPL6Y+QHxhEYaWywdVSIbzN81AE6XzcqBdCZyY6NAZYjkrjDfAwnAuGaokSAAaLleeRacFu5rIi3HPQ7Ye2kbhn8g0fm3vaFu0aKua4WBS92ph0Wogh3OzJuuNakNC+7dEJIRqyijMywt4Kdy/p/lbihlNQCBWapS606QTwMevBbpTqytqNB2YoDs37vBC54z5aG/aqOMK4JHbzGw+T3X6
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2026 06:51:30.0492
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f600a66-f6a3-46d3-349f-08defb62cd3e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000011.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6143

From: Mark Bloch <mbloch@nvidia.com>

Protect vport admin state modifications and vport iteration with the
eswitch state_lock mutex to ensure proper serialization of concurrent
vport state changes.

Currently, calls to mlx5_modify_vport_admin_state() and loops iterating
over eswitch vports can race with each other, potentially leading to
inconsistent vport state. Fix this by acquiring esw->state_lock

Fixes: 7d0314b11cdd ("net/mlx5e: Modify uplink state on interface up/down")
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Reviewed-by: Or Har-Toov <ohartoov@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 20 ++++++++++++++-----
 .../mellanox/mlx5/core/esw/adj_vport.c        |  2 ++
 .../mellanox/mlx5/core/eswitch_offloads.c     |  4 ++++
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c |  2 ++
 .../net/ethernet/mellanox/mlx5/core/vport.c   |  8 ++++++++
 5 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index c8b76d301c92..3d544fe4e6f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -689,11 +689,13 @@ static int mlx5e_rep_open(struct net_device *dev)
 	if (err)
 		goto unlock;
 
+	mutex_lock(&rep->esw->state_lock);
 	if (!mlx5_modify_vport_admin_state(priv->mdev,
 					   MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
 					   rep->vport, 1,
 					   MLX5_VPORT_ADMIN_STATE_UP))
 		netif_carrier_on(dev);
+	mutex_unlock(&rep->esw->state_lock);
 
 unlock:
 	mutex_unlock(&priv->state_lock);
@@ -708,10 +710,12 @@ static int mlx5e_rep_close(struct net_device *dev)
 	int ret;
 
 	mutex_lock(&priv->state_lock);
+	mutex_lock(&rep->esw->state_lock);
 	mlx5_modify_vport_admin_state(priv->mdev,
 				      MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
 				      rep->vport, 1,
 				      MLX5_VPORT_ADMIN_STATE_DOWN);
+	mutex_unlock(&rep->esw->state_lock);
 	ret = mlx5e_close_locked(dev);
 	mutex_unlock(&priv->state_lock);
 	return ret;
@@ -783,22 +787,25 @@ static int mlx5e_rep_change_carrier(struct net_device *dev, bool new_carrier)
 	struct mlx5e_priv *priv = netdev_priv(dev);
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 	struct mlx5_eswitch_rep *rep = rpriv->rep;
-	int err;
+	int err = 0;
 
+	mutex_lock(&rep->esw->state_lock);
 	if (new_carrier) {
 		err = mlx5_modify_vport_admin_state(priv->mdev, MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
 						    rep->vport, 1, MLX5_VPORT_ADMIN_STATE_UP);
 		if (err)
-			return err;
+			goto unlock;
 		netif_carrier_on(dev);
 	} else {
 		err = mlx5_modify_vport_admin_state(priv->mdev, MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
 						    rep->vport, 1, MLX5_VPORT_ADMIN_STATE_DOWN);
 		if (err)
-			return err;
+			goto unlock;
 		netif_carrier_off(dev);
 	}
-	return 0;
+unlock:
+	mutex_unlock(&rep->esw->state_lock);
+	return err;
 }
 
 static const struct net_device_ops mlx5e_netdev_ops_rep = {
@@ -1337,9 +1344,12 @@ static void mlx5e_uplink_rep_enable(struct mlx5e_priv *priv)
 
 	mlx5e_rep_tc_enable(priv);
 
-	if (MLX5_CAP_GEN(mdev, uplink_follow))
+	if (MLX5_CAP_GEN(mdev, uplink_follow)) {
+		mutex_lock(&mdev->priv.eswitch->state_lock);
 		mlx5_modify_vport_admin_state(mdev, MLX5_VPORT_STATE_OP_MOD_UPLINK,
 					      0, 0, MLX5_VPORT_ADMIN_STATE_AUTO);
+		mutex_unlock(&mdev->priv.eswitch->state_lock);
+	}
 	mlx5_lag_add_netdev(mdev, netdev);
 	priv->events_nb.notifier_call = uplink_rep_async_event;
 	mlx5_notifier_register(mdev, &priv->events_nb);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/adj_vport.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/adj_vport.c
index ca249b50f830..3624c680a861 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/adj_vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/adj_vport.c
@@ -9,6 +9,8 @@ int mlx5_esw_adj_vport_modify(struct mlx5_core_dev *dev, u16 vport,
 {
 	u32 in[MLX5_ST_SZ_DW(modify_vport_state_in)] = {};
 
+	lockdep_assert_held(&dev->priv.eswitch->state_lock);
+
 	MLX5_SET(modify_vport_state_in, in, opcode,
 		 MLX5_CMD_OP_MODIFY_VPORT_STATE);
 	MLX5_SET(modify_vport_state_in, in, op_mod,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 247e5d85ec36..d603e294ee0e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2567,6 +2567,7 @@ static void mlx5_esw_fdb_active(struct mlx5_eswitch *esw)
 	mlx5_esw_fdb_drop_destroy(esw);
 	mlx5_mpfs_enable(esw->dev);
 
+	mutex_lock(&esw->state_lock);
 	mlx5_esw_for_each_vf_vport(esw, i, vport, U16_MAX) {
 		if (!vport->adjacent)
 			continue;
@@ -2574,6 +2575,7 @@ static void mlx5_esw_fdb_active(struct mlx5_eswitch *esw)
 			  vport->vport);
 		mlx5_esw_adj_vport_modify(esw->dev, vport->vport, true);
 	}
+	mutex_unlock(&esw->state_lock);
 
 	esw->offloads_inactive = false;
 	esw_warn(esw->dev, "MPFS/FDB active\n");
@@ -2587,6 +2589,7 @@ static void mlx5_esw_fdb_inactive(struct mlx5_eswitch *esw)
 	mlx5_mpfs_disable(esw->dev);
 	mlx5_esw_fdb_drop_create(esw);
 
+	mutex_lock(&esw->state_lock);
 	mlx5_esw_for_each_vf_vport(esw, i, vport, U16_MAX) {
 		if (!vport->adjacent)
 			continue;
@@ -2595,6 +2598,7 @@ static void mlx5_esw_fdb_inactive(struct mlx5_eswitch *esw)
 
 		mlx5_esw_adj_vport_modify(esw->dev, vport->vport, false);
 	}
+	mutex_unlock(&esw->state_lock);
 
 	esw->offloads_inactive = true;
 	esw_warn(esw->dev, "MPFS/FDB inactive\n");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 28d16fdc3f06..2285c889c215 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1471,6 +1471,7 @@ static void mlx5_lag_modify_device_vports_speed(struct mlx5_core_dev *mdev,
 	if (!MLX5_CAP_ESW(mdev, esw_vport_state_max_tx_speed))
 		return;
 
+	mutex_lock(&esw->state_lock);
 	mlx5_esw_for_each_vport(esw, i, vport) {
 		if (!vport)
 			continue;
@@ -1490,6 +1491,7 @@ static void mlx5_lag_modify_device_vports_speed(struct mlx5_core_dev *mdev,
 				      "Failed to set vport %d speed %d, err=%d\n",
 				      vport->vport, speed, ret);
 	}
+	mutex_unlock(&esw->state_lock);
 }
 
 void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 3676e26ac6b0..080f097b7bfa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -89,6 +89,10 @@ int mlx5_modify_vport_admin_state(struct mlx5_core_dev *mdev, u8 opmod,
 {
 	u32 in[MLX5_ST_SZ_DW(modify_vport_state_in)] = {};
 
+#ifdef CONFIG_MLX5_ESWITCH
+	lockdep_assert_held(&mdev->priv.eswitch->state_lock);
+#endif
+
 	MLX5_SET(modify_vport_state_in, in, opcode,
 		 MLX5_CMD_OP_MODIFY_VPORT_STATE);
 	MLX5_SET(modify_vport_state_in, in, op_mod, opmod);
@@ -106,6 +110,10 @@ int mlx5_modify_vport_max_tx_speed(struct mlx5_core_dev *mdev, u8 opmod,
 	u8 admin_state;
 	int err;
 
+#ifdef CONFIG_MLX5_ESWITCH
+	lockdep_assert_held(&mdev->priv.eswitch->state_lock);
+#endif
+
 	err = mlx5_query_vport_admin_state(mdev, opmod, vport, other_vport,
 					   &admin_state);
 	if (err)
-- 
2.44.0

