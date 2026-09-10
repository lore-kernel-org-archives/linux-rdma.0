Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012029.outbound.protection.outlook.com [52.101.43.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB1C3D9DD4;
	Thu, 10 Sep 2026 10:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789035950; cv=fail; b=evqUupHMbcF9p+VNBp/5WaVIra96jMJvTze43GsM1ZWDuB4Fi6/jD0LJzQ35Gr9wchlu9+GO+cCa3xqBWdCAL9yq1MXcaEVB/m4MZ3Dip+N0aSP+YodXUxwiOQPjorCJ922t9300h1FCk4dUWFHEPP+P1bbkbKqYGu/sufQGJrg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789035950; c=relaxed/simple;
	bh=BYE5LXjQvgA6qqSUzcT9ujZCcsTQD/9lOSzBgONqy1I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nJjxDvsNW5pfftZ/fjm5Tzu3x1vzzJqUa8zT2su/k+XQUyu9T/bw/B1W5P8Dp9UBwYuwoKt6Yfv9DY8OTD+fKveJdCovgcvVJDqWEcNkRKIotBiejspF2DSdmkGdgs0shlKpA8j5pBG6Zmtltz92sGSRDlcqHZuzisKFxjktEVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BhzqBtck; arc=fail smtp.client-ip=52.101.43.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BhzqBtck"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ijLl11o5UZFKi/3rL4RowWvubtSb/2EE3FmpdYbhEdtBmZ+34/KOeTxkBgPvh27y/xvdvxdCPDDAVUpQcIUSQJ1LMi/VA+zcNL15c0VHPYxrfJTS9144Vy6QkY8Lj2KcXPmC4Em0CWLyaNcFwZ4lHEwgz63ieOJCYMV5bXNbvcj0ogtB+es5HY+vALgtOG5kvRBvfsHS9Nqzd/dix/8u8SmzN93EvlAhOp22/1bA8PTga+pqDvw+WLuSIZV/OddmCtxhd1UsNWvyZS168j68dbb/FdIZhU3mJqWZXytwEboX4uFrAjWceTNxRk8CWFCPzGr1x2a+U/giop2x3SgPWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qFIQJe0rc6+Wv0WH75ZderFn4iXf4ZfW9RchCCn5JRM=;
 b=sZYgdjHB541GpiSEVE/hEqE9+AweKDf829WpIdZ6T6MoqwBdptqqPCAAruWsiXMi6JTwTSwYSKE/l81YxpcGPH3th8VwFM7rSLt0bCtsfYaqKqFtifnfMM6w6QUcZCR7eo3pHhKPzcvUy8XZb2jxrmzYS7p/csDZnTHevULtaOaAsFA/Xq6YWpXN0FL1imh/9ecmyD0ttTPcR1RMBQqKZiZYD6lg9OrVFom1dYQkSdVTjSaSHosXObGM7UdIa0oROXs4HKwnK7b5TEpgL6Ki8dEYEF2bktPrN4p5BR6cb2Min7ncjUhncIKMClQKrpXOamJF/se6D+jTGS3fHuR7RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qFIQJe0rc6+Wv0WH75ZderFn4iXf4ZfW9RchCCn5JRM=;
 b=BhzqBtckChPSPYarWRTBo3gSwl6HlbwFkX91dr6GE62lkJ49/53dXFAGasDHC3eI/wcKJxWqKVqdKPn19MoldDGkPOt3NMnVN2dZAGoTheqTrOAm4Y5Gtr1mj80EH1QZ9fYHtDE1JDzBzR/m+8xgqHL04ybCwBTVEmeeg1gQSIHnX34l+cVY1tGhXEX0sBgxexWJpqsq4G6gnU1z4bcKECdr7R5fJRUN2CFA80QUG2WgABEV7TxtUXUUeZBwMrxdcOxtrmhy6jCBnCQaUsTMQFc+QVN6h9dENdV3SyISzu68kA7Hv3uZQbwjm2Mkrkx2jE2z72hwaDCRomL2LkXvqg==
Received: from BN9PR03CA0924.namprd03.prod.outlook.com (2603:10b6:408:107::29)
 by DS2PR12MB9776.namprd12.prod.outlook.com (2603:10b6:8:2bd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 10:25:33 +0000
Received: from BL6PEPF00022574.namprd02.prod.outlook.com
 (2603:10b6:408:107:cafe::8d) by BN9PR03CA0924.outlook.office365.com
 (2603:10b6:408:107::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 10:25:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF00022574.mail.protection.outlook.com (10.167.249.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 10:25:32 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 10 Sep
 2026 03:25:18 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 10 Sep
 2026 03:25:17 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Thu, 10
 Sep 2026 03:25:13 -0700
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
Subject: [PATCH net 2/5] net/mlx5: Lag, reset vport speed on teardown
Date: Thu, 10 Sep 2026 13:24:29 +0300
Message-ID: <20260910102432.3845360-3-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00022574:EE_|DS2PR12MB9776:EE_
X-MS-Office365-Filtering-Correlation-Id: 579a1add-6055-4a9d-3429-08df0f25d88f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|23010399003|36860700016|56012099006|11063799006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	HxDT2G77cfxrpPuZB2FJnVIBaaYCzJ0/+Y6uKg9KzAyVbyVU/OyHBqIuDzwLEVnU/uNQ9y9/Jomzt2+1qNeO+miWc0KWVqrK8CfHY5oxNapGZDQvYy+DA5HhM1LnIeT4YhqL1F04drKqkt32ZRrDQFscxb1o3ZT3sfoLsJWZwVOfXHIFhxSRsKfO2BNI4LgI3dzQvUgW6Lm/w8dOgQq6NyOOoceB2uIH4B0Rmfu4BDK+v3FI9Z/LUtqu93usJ4vOlrLUdLUeVyyp1S15KnFKcK5v0st7rGa6n9HuIVbIuJDYYTjk8MS5IwioVnzzajq2cWOVEZoxMer6SMbgChP4dpcyjeCbFhHacGp7Uh9GU+kxu7fSzkcQRmElnguo4d2GNHBAl1BLjUgCbw1tVju47KBeaF98wzga+LxyGg4HDA+NqahxMLBE8gSklFk81dqR8GGPiiKo04YMMT5T0KSiQwsI7vc8kuYI8xZojXX3G/fq+iGPgnPn+UL9O8IL6lKSN8PjwNhdwB3c5b/LtehYgR1rDCFl1uGkHevLvjSdqda+sFlT8NretSDuTt2YGv6O9snQTgkzszipG8puHRf2LnuZQorPbSJMBn1umihYjhXcaKkVvyFjuVI56mCqhikhn9UVBrbSZ9GsbEhIHbkiXs1tFYI4hHFySuc6/ecjruvK1n68wnuxECKKwqXHwgtCorq29uBhFvWbLulJdOUbBg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(23010399003)(36860700016)(56012099006)(11063799006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XEdp139JfT5kk65VNxr8Sc69sGUCah9VKUGhfL9UD+TH4rAvbToBIhPZDel21Z8/qQUVaLw0rly7Sz3FxN8fEyeUPVfhAdFFMHkrgG9wtIWzcjJPWW8a2EdpuTsNHqSVtDgNKs4/3I1nRsrAGRGjHQHXm6WCqhgtCuxCk/QD6ysNBp1wa4HWeFyV69v+FUpqIDJt9hiX9tm0qIWmOJ2W7c35BfYnQ5x2prgmR9Z0OrQ4bLh1MFVUz8HSIsk37P25kP4nRPScHWdBF86Zby4FNon0k2F7XWPBKjNl3bBLVNDQfhSFSUKpGxfdKP3uKtAAMKRAcmrnThoag6i4YuIhqeOJVcfMdEpKeciZGqc7k7MUGOR3qT4qfhqmg1tBTMBJiyqBLkQx8f0dazZAshWpvMEFZXmFquktn5BrL6tl+JRd0HGTmZWFUx9d/u8bO1Iy
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 10:25:32.9474
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 579a1add-6055-4a9d-3429-08df0f25d88f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022574.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9776

From: Or Har-Toov <ohartoov@nvidia.com>

mlx5_lag_disable_mpesw() never resets the cached agg_max_tx_speed on
the vports, unlike regular LAG teardown. This leaves stale speed values
cached on struct mlx5_vport, and pushed to FW, after MPESW is torn
down.

Move the mlx5_lag_reset_vports_speed() call from mlx5_do_bond() into
mlx5_deactivate_lag(), so that every teardown path resets the vport
speeds.

Fixes: 50f1d188c580 ("net/mlx5: Propagate LAG effective max_tx_speed to vports")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 5aa9d5c98fe1..c2f21eb4ea7c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1075,6 +1075,8 @@ int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 	if (master_idx < 0)
 		return -EINVAL;
 
+	mlx5_lag_reset_vports_speed(ldev);
+
 	dev0 = mlx5_lag_pf(ldev, master_idx)->dev;
 	ldev->mode = MLX5_LAG_MODE_NONE;
 	ldev->mode_flags = 0;
@@ -1676,7 +1678,6 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 		mlx5_modify_lag(ldev, &tracker);
 		mlx5_lag_set_vports_agg_speed(ldev);
 	} else if (mlx5_lag_should_disable_lag(ldev, do_bond)) {
-		mlx5_lag_reset_vports_speed(ldev);
 		mlx5_disable_lag(ldev);
 	}
 }
-- 
2.44.0

