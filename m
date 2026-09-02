Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012017.outbound.protection.outlook.com [52.101.43.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28AA4AA572;
	Wed,  2 Sep 2026 16:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367271; cv=fail; b=tCxPFW+shoKunHTvr8J5L1KQmRhLEiQJKFU9mOn0aaHoNo8Fg+6EOVSHmCibftaywhnVdVN2kGKm1hhhzKBiTnGuwT0kAigxL3qC6vEpH9yC1glFPYlhwwCp6Nxdg4Z2TTHYvw51o20EL8WOnb8h+8o+7e+Hf87NGa/UVmOu6mE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367271; c=relaxed/simple;
	bh=3C43RGCoijl5pSO+jK9JjwUAhH2khtERvFURnNA+q5U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=amSB0H4Al2u+b1yCjshxJnIJ1mbvKLJCHsDy7LvizIG/uuK48pe4sBntl2sokL0R8+tWMk1offQOImd0U9jj2tsmrWq3BVKTa2iFYZ4Kfwospu8oMBeGLR2ObvWkxLkmD5U18BW+/D2rAAZh68sdgcJpcNdk9HS+zaWVMmnz5ZI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QTzrB7Xg; arc=fail smtp.client-ip=52.101.43.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QTzrB7Xg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VtY5wO9AUF5m85zEatdRn2GzbHmVD29falBAY5ltQPy2fXnqsjJVm1j710CYl68LPYMBOJ7LaVm8CsrwcbnNy/0c5ajPCk5bNixdfW04KjzH2/85POGxshdUnvYlZbpqMgaNNEvHBiAv4Jd1V3ZQXm5KP+BfGpeTqDdkWO1XvR95tmyTzNvbh8jt9PAEV0e/uKdYJIyKquNceWqBhskedGy52muhl+wuyA5mPAi3eoFQaAd3hLWkADn3WJi9ZH5xXjz67yqn9LXSZrh98fnXRmA7pOUs5DTZvcperoybmjquzsSzgErd/S0WitAFLO+CW3RB0g4uKNftdX/gYEWPfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Ys6udKrioHTsVwcyOTFWipQwoGwGZY6EuzE+v/TWBc=;
 b=a9eu3zgyHpUOC+vwr1zEPEnPcZ1/niTR77nw+/VnJINma0Wc521Eh28LGbB4mE9AJkUo8L8CYMDB51y+R55Wrm2eIENq6X6Xm51+qiKHiWGGYF074ddPbzxJSPQrV5RvoVwU7E6Crzf5MrK4keSm7WJu3zchtvs4QxjgLTVqfAwsfjc+ZW9FaKOu721Scrr0KezQUQtu3pH5pCA7Z4l1BC4W+5cPbMkePsUOWHt+lQn9GAn5oC3yRdhXaa9ge+VtIUupnHNproj4l0WHApQk8c0K5AUlPLETDQh0xQxuDFb+eySSd1gaNi1yPb/7q1DhVHG+wnnFkvgnkAbo1BmooA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Ys6udKrioHTsVwcyOTFWipQwoGwGZY6EuzE+v/TWBc=;
 b=QTzrB7XgcT51Y8h8LywmfgQjwKEUW3rTMYdX46EiSPtpBiVM/JcVlBWV+VO4wZwj9nRjWqrkMOef3DyK6bN+UtAyFVLvGAvc3Fxxg2uhvJcQYABXaNO6U8D/qAbUgGjp9kwupEMpug/Clu/q8oaVh1jPXqIMUViXh4Cq/fnaVDxYctvTlyKV6d87MPiRTnHdbEDZbN5ggJFzgAW35lyE1pUnoAC1wZD1Et2xKeFvEX8UHCHJUUWSwGTrdeggDWXtdDeldmIKQE2r3Rg9WfewwM6Bg1cfka2psNTZlFQJu8mkxm9ly3xdqMu6dK2JILsSmRonFNdLaqXGSdThfY2a8w==
Received: from CH3P220CA0028.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1e8::6)
 by PH7PR12MB7115.namprd12.prod.outlook.com (2603:10b6:510:1ee::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Wed, 2 Sep
 2026 16:40:58 +0000
Received: from DS3PEPF0000C37D.namprd04.prod.outlook.com
 (2603:10b6:610:1e8:cafe::81) by CH3P220CA0028.outlook.office365.com
 (2603:10b6:610:1e8::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Wed, 2
 Sep 2026 16:40:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS3PEPF0000C37D.mail.protection.outlook.com (10.167.23.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Wed, 2 Sep 2026 16:40:56 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 09:40:37 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 09:40:37 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.46 via Frontend
 Transport; Wed, 2 Sep 2026 09:40:32 -0700
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
Subject: [PATCH net 3/4] net/mlx5: SD, unload reps on shared FDB create error path
Date: Wed, 2 Sep 2026 19:37:15 +0300
Message-ID: <20260902163716.3656279-4-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37D:EE_|PH7PR12MB7115:EE_
X-MS-Office365-Filtering-Correlation-Id: 60ee3f6b-111e-4469-eaa8-08df0910f64e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|36860700016|82310400026|10067099003|11063799006|22082099003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	Z0CmY1EXnB+7gmdnyH1b/uP1RJAlNewoU9NZvONgAAmbjVwqw/1J1TvE+fR0JHhnjt5NWepF1ANZ8DvsRxXlS0j8clssCwgKzz4FYheCpkPik7Dp56lk5fRl8bGrtldOdwgX41DiTxM+Ea0NntB+z3yhiijr3mVSTKl8sNkKcnUNoECN485EASGs7LByfJCBPNvdKrV7nkHMd7dWGTMI1hze9yYtIU/8Hq7gkHXRB8E1L/OZ8CENoJRayun0N0hPUb2NBveiNX2RuwWyIPqPv8jYfZalBLxZF31oY1ujGtcRPVJ/2vECFQEj1h1A+ib4X2woGioKhs3d6RRFooAvTkarQvy8DGIyEfa2F/Hv5TnRgZHau4QW/eohA3QHV+GZIHFYRBQB6HOUEAveJEiQbjpEQucJ4Uvt7L4OQk8X90YlezDFuvxQFp+RwlDfgXUqMW0nzXywu8LmNTANBKkBH3JZpcEf8Ygaa248wiGOX0xI49m/1orEvjvHhaFb2K9XPYDsDoqkm0bmvuYxjSJaoVXBY6y5SSw9o/ycwGnshKGk6YAEomMSy8nRWpnt+b3jkIjcIInOVql+KubVFi79itZ42DvGYvRlxsIZw5EuSC5vfBRHXz7VkJGAnFM5/IumC2o5+KUpQ8dZucIxZyLhR1zS+y2fCc6w5bOzfdxQ0Jsg9VVCJ4bHXDUgbzPod0fceIjnlPF/wdgHfBfaKjzRyQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(36860700016)(82310400026)(10067099003)(11063799006)(22082099003)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	JvkaBRJBJxYGxqD4ifys5Ak3KiX/QkrUmVNEL6MpnaE7ABT3pHR8LPTUC45YYrNk6ZoJuPbv1Rdl2SDGQpBmueqb6lYVUXDtfj6IqcqBm5NbjXHh3tCu5soYk7i359F6mygcPA336Kun0Kui5VBMFYbuiMw27KbDDzNKoxgWj+INVd3VUCA4FOFFno2iP8dXveVS70cTbdIMhhaS2bG4mU+7HkBpBAnu0R/UZdLgVmJgnaRUTl0Uv/UQ9WYETqvajg/Va4jrLflmkzYb9OpdsAQkvCOjSFt6acQuRTQIBpWUHkrhD1tg64O3dMahG+TnXqlpjLZ1d0q6vCgfiPVD46pCuWlepUuKUwWXVie96Gw5NAAivbguh13xm6ixBQh9Bi38nHQSJlgDCElDvKtS0iUElbm8uPRHbb+GQp/WEOZdSlJSLsP4YsIWoZQcSKe3
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 16:40:56.4854
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60ee3f6b-111e-4469-eaa8-08df0910f64e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7115

From: Shay Drory <shayd@nvidia.com>

The teardown path unloads the representors; align the create error
path to do the same.

Fixes: 68c2dd59a6c7 ("net/mlx5: E-Switch, Tie rep load/unload to SD LAG state")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
index 6b4ad3c53f2f..424040918fa3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
@@ -270,6 +270,7 @@ int mlx5_lag_shared_fdb_create(struct mlx5_lag *ldev,
 			pf->sd_fdb_active = false;
 		}
 		mlx5_lag_destroy_single_fdb_filter(ldev, group_id);
+		mlx5_lag_unload_reps_from_locked(ldev, filter);
 	}
 err_add_devices:
 	mlx5_lag_add_devices_filter(ldev, filter);
-- 
2.44.0

