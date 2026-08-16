Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011048.outbound.protection.outlook.com [40.107.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2957D13D891;
	Sun, 16 Aug 2026 06:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786863117; cv=fail; b=psce6avbELrrcE+olqQVo0vENcMPiGWzMPJFsGHNUa1veTynw9BSCSgq4i1IUQE3TMCpNmRfC1pyeLnp0OlWe4FicmbQYD01bYxYLkdQK9fYw1kK87YI6xNQK7Z8SnZi2pgfncCFKQ2GLPKJ3fbbasBG07b0jCw/yGSvs383qgw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786863117; c=relaxed/simple;
	bh=dHsfmF2U6ZOntvXnXhsWorV4JKxwUAAkuSqY0Oc3GxU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E/UIF3zbfzgMxXFKgxoTDhC+WaTZKK/3j7PnAmdFDSuove/b0jn114T0sTKF06Clu+TtGiNQcgy9Cvs2JNXKNfc8lsGDPlwMjh6l/QHkVYFBvl6lR/BBlOBu3ZI0nZCcGSRxfsr21d7Amc4o7o8x/9/j2yaNtd5n8kqU1UVt8rw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Az133bMT; arc=fail smtp.client-ip=40.107.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Az133bMT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wIQ8twdMxdsnOGeAU1Z7mA+CrrqVyD/xdoC2dOk6rzntNPGR/Iq06QoKcBUpmb5zHpHzBZ9PTL0WshDJ9o1ttfMWU4JvXcBfqSkK2jj/AKubtTOTV90b/+42BVMRx5CadDDBMmwVxOAtHm7Uy1vN9gDU4W+F9FaT4Z2YVXeqb9sDO13NhqOspnKjrPdjURLlyilzzg9wt+2DDW3XPgmnynxe970ijzc69pxqTx3UgwZarDT4L0QcvA1XdCmj1+8yTff2hqnX75z+JvEVzNHGL324I4fqs3rSAwUv6/Xqdol7gFaBRyCt22MovJgfSWyPzhFGVcrAgWeIhYdhQ5x2TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FKKzik78GGbxbXM9mmMjt3gZ8GBvGTo4/2FS+z2t19A=;
 b=ZmQJEKJNsXwK7xFd5OCeiuWMb4u+3szXm7MJVTSzdsh+gsJxCXVxhoyoj1hL58M39idztBRBpPW9jQVxjL6EszU3OulordTWy34g7pPP0s4vuf0rF1+//dk8GBRT7Q8kX1PmND6tLwovBwCblEUJk7DQdc8H5DOCANAMIOezazXraZz04NX7b38BZCUnGNGxFWxPt7fJoipepij+xJbBcOlBD8alECS8ZUClTZiCGf+TY4mfXOVfloQX1UuBs66EuLx3YB4krO+g5Na3MqMr+XpHqPL+PeA5tz5y7sk9UcskYaWxOJoO54K6Qxq4RbpYFwzVZcfDkoMKQmzplEtdzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FKKzik78GGbxbXM9mmMjt3gZ8GBvGTo4/2FS+z2t19A=;
 b=Az133bMTCIby2TgXD+IknJoY234mVoMq8ULokeRuWyG+xpQPaRH7+ebgsMJfmbiAhuCViKwXzUVRNBKFNsovJgnaI1pwi2bBsoTteXggaIAPPEock+/5d4gDp7Brxbx0R7gw8LPIY0bwCtexlLkbkIR6hkR/p7lMiojrgVpU+6jff31rt++36BDWwnRA1gG8GrYrSlFiivDpzSgfbOQtLSHcdZoZx/ne0nZbFsN+EbJFlaxQNlWVYlS+sQqk6Cuo/1H1ppWiPW2jLCLzSFxE53ycCYCk2//F4H/jBjdawvqEgfsIFFfas9WncmXdm3vmsW/Hw+MfnaNU5whhJnGgkA==
Received: from SJ0PR13CA0018.namprd13.prod.outlook.com (2603:10b6:a03:2c0::23)
 by CH3PR12MB8725.namprd12.prod.outlook.com (2603:10b6:610:170::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Sun, 16 Aug
 2026 06:51:48 +0000
Received: from MWH0EPF000C6192.namprd02.prod.outlook.com
 (2603:10b6:a03:2c0:cafe::54) by SJ0PR13CA0018.outlook.office365.com
 (2603:10b6:a03:2c0::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.8 via Frontend Transport; Sun, 16
 Aug 2026 06:51:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 MWH0EPF000C6192.mail.protection.outlook.com (10.167.249.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.3 via Frontend Transport; Sun, 16 Aug 2026 06:51:46 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Sat, 15 Aug
 2026 23:51:32 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Sat, 15 Aug 2026 23:51:31 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.46 via Frontend
 Transport; Sat, 15 Aug 2026 23:51:26 -0700
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
Subject: [PATCH net 3/3] net/mlx5: E-Switch, preserve max tx speed on vport state modification
Date: Sun, 16 Aug 2026 09:50:15 +0300
Message-ID: <20260816065015.3280733-4-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6192:EE_|CH3PR12MB8725:EE_
X-MS-Office365-Filtering-Correlation-Id: c490f31c-30c9-4fb6-14fb-08defb62d742
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|7416014|376014|1800799024|82310400026|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	+/N8oZTq6prVh7Io7aqEposdPGFKA/iqKz4QL0rFnRplskVNgv7/Syj+Hg67O2Y0FWBbi3CzWsBXzUlkXWNCNASb6jwn/CxBVpb35lorrLmsfdvxDe/hqJH28AB2Br2rKt8vjSC9ZsA0ZxFx1GjqkvGT/OJtOcO9fFE7Ll6Hv2B25I909BOMedCcbGUL2vNVtQnbDMBXKyi8f5eJCAm7YLZLpfwO4T2e8Js0bEud3BXZOrco/vg/69ba8bnipIX1oiwD3LUc1Qqg6qGaU0d57a2KFMJvHSGi20+XiIcye+W9wJafLXy5XSdpo2DJ67Kpvm6QYwolgrJh5sKyq7qcBjKXkvDysvKJOQtxhe8fSPZSG4Tswb9j3WW9HEJEvARtaO0rEdO75RJoCFfhe7d2SEXjCDBMzZ34lYnnDqBoo+kfaMUZtwE5aVoeeTH/pkli21Ha73NaAPNIdHlgys/GTbHLKqW16MHki2UDFufVKo+8Sxi8qsrL63GaJ+HOlm4ctlarObP2Jd+qsP9XPI8HFGBZmOTBVrb6B0uI52IOI4noc69dfPcqndAsI1fKsRwUMXcSoOMyjpgnj+9Gf6WFpTkKxaJnRkGL8DVDiqH+bhSBYjoAfIkk+sgypgWgiya9VZlWy8FzjR+5X9ll1uN2RPwGqiwLWKN7Oge/ilgFFAtSKzDBZpEj6TgnytvQrDxjMjA3IyuiQrAp3L8KKsoRiA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(7416014)(376014)(1800799024)(82310400026)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	esEBKLwEns0PpEDTrKABTazJdO/Y7BJazsih8Sg0lsgqMYo1HWHFgjg/NVQwsfjkSduvqDIoAWwN8PzlpwImP+6RG0Epr3GNdTDjAZvXpC4f8rxfNLFZpn4RuZyqXxgDnXNPHgLPI+V1RHkHQtHJ4cNV4m1Iulbr1odS34wo/u7KqMU0prFJ7ZjSPuYpFyWzy0KgZgzQA7pQVamJw4wbv0lixIaJCmLJoHnhScyscz/YtegAFXT2UF5SZqA3MGwxGVlcpjCOflC8/LXQghrzkHDCe4upihCyAkVCBL5Ag2qiueaYenbIbjl/cXN0i5y+JPoqfEl8buWAN0UpuzhlfwqBvpeO6L4y62B6vp/sk9bEadfhBeAfRMtf08EVkX3zxuikIUvyhGA9GJbnSQ54qTJ5cw+071eX7iMGq+pcg6YavWjTzr95UEP4wsvchwro
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2026 06:51:46.9036
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c490f31c-30c9-4fb6-14fb-08defb62d742
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6192.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8725

From: Or Har-Toov <ohartoov@nvidia.com>

When modifying vport state, the firmware interprets a zero in the max tx
speed field as an intentional reset, which can overwrite previously set
values. This patch attempts to fix this by querying the current max tx
speed from firmware before modifying the vport state and passing it back
in the modification command. If the query fails, fall back to the cached
agg_max_tx_speed value to avoid inadvertently resetting the speed.

Fixes: 50f1d188c580 ("net/mlx5: Propagate LAG effective max_tx_speed to vports")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/esw/adj_vport.c        | 20 ++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/vport.c   | 24 +++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/adj_vport.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/adj_vport.c
index 3624c680a861..7950b82d8b8a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/adj_vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/adj_vport.c
@@ -11,6 +11,26 @@ int mlx5_esw_adj_vport_modify(struct mlx5_core_dev *dev, u16 vport,
 
 	lockdep_assert_held(&dev->priv.eswitch->state_lock);
 
+	if (MLX5_CAP_ESW(dev, esw_vport_state_max_tx_speed)) {
+		u8 op_mod = MLX5_VPORT_STATE_OP_MOD_ESW_VPORT;
+		struct mlx5_vport *esw_vport;
+		u32 speed = 0;
+		int err;
+
+		err = mlx5_query_vport_max_tx_speed(dev, op_mod, vport,
+						    true, &speed, NULL);
+		if (err) {
+			esw_vport = mlx5_eswitch_get_vport(dev->priv.eswitch,
+							   vport);
+			speed = IS_ERR(esw_vport) ? 0 :
+				esw_vport->agg_max_tx_speed;
+			mlx5_core_dbg(dev,
+				      "Failed to query vport %d max tx speed, err=%d, using cached %u\n",
+				      vport, err, speed);
+		}
+		MLX5_SET(modify_vport_state_in, in, max_tx_speed, speed);
+	}
+
 	MLX5_SET(modify_vport_state_in, in, opcode,
 		 MLX5_CMD_OP_MODIFY_VPORT_STATE);
 	MLX5_SET(modify_vport_state_in, in, op_mod,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index edac2d694e0f..8aa94ec87a0e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -93,6 +93,30 @@ int mlx5_modify_vport_admin_state(struct mlx5_core_dev *mdev, u8 opmod,
 	lockdep_assert_held(&mdev->priv.eswitch->state_lock);
 #endif
 
+	if (MLX5_CAP_ESW(mdev, esw_vport_state_max_tx_speed) &&
+	    opmod == MLX5_VPORT_STATE_OP_MOD_ESW_VPORT &&
+	    vport != MLX5_VPORT_UPLINK) {
+		u32 speed = 0;
+		int err;
+
+		err = mlx5_query_vport_max_tx_speed(mdev, opmod, vport,
+						    other_vport, &speed, NULL);
+		if (err) {
+#ifdef CONFIG_MLX5_ESWITCH
+			struct mlx5_vport *esw_vport;
+
+			esw_vport = mlx5_eswitch_get_vport(mdev->priv.eswitch,
+							   vport);
+			speed = IS_ERR(esw_vport) ? 0 :
+				esw_vport->agg_max_tx_speed;
+#endif
+			mlx5_core_dbg(mdev,
+				      "Failed to query vport %d max tx speed, err=%d, using cached %u\n",
+				      vport, err, speed);
+		}
+		MLX5_SET(modify_vport_state_in, in, max_tx_speed, speed);
+	}
+
 	MLX5_SET(modify_vport_state_in, in, opcode,
 		 MLX5_CMD_OP_MODIFY_VPORT_STATE);
 	MLX5_SET(modify_vport_state_in, in, op_mod, opmod);
-- 
2.44.0

