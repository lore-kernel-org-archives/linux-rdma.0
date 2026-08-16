Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011000.outbound.protection.outlook.com [52.101.52.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617F33D9031;
	Sun, 16 Aug 2026 06:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786863106; cv=fail; b=lYsxCMq/ex6V4ayLBSdctNAsxCtqnIApksG6Ptg1ERVOUtvX3cZJRQn/homPX3EzAGO0VZmLTPqGzrlHMq1Vi1cB8+xeIWrB1Mg0uFY3sP5C9/QvwvGY+yo77rLC4kcHHGdctks/whLFdTGVRCtaOllHMiw5KHAq6uSpu9aqP9g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786863106; c=relaxed/simple;
	bh=kKqY/G/NFJUqwpoXrZX6Vhvm6sTTNXvBgn5RGgdC1EQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rxV7nd4Nrc7zBiyz9CcrrltH2Zgqief7AXi5z7SXonrSRvfz495bpMTI78aC63pEzpIYK2/lWRUSNsIMKzU/u0nJvK0oke81+9S8vtj1iqjbpC4Eb8BpMXCYKjbXhCk7Cc8+8WGWmbPCB7gv+8RiH69Z46He7Mm6DRdeGY2LPJ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UqjD4qnX; arc=fail smtp.client-ip=52.101.52.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UqjD4qnX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RVAT+GZdxnkW9Nk4SEQFmyajkgrz/9msTOwuZYeEsJ9JOwpU/VKC1K9+RIWjAXh4+mERYwMkdqbKSa9ZcKKnfXaSYVGMZjtNszzsB41LKOin5O/ioOEt+o0MGvOK0vZshdpOZCmrF0Rv2YNswZFs8imf//y/IOhkLNjg1jGBsb5euCcj5O1Rc112/7WFS074yNWY+ZeEFWusxWeHi0MP7bl2y2CDlDSBGN5Oz0rPzRpGa+CQFUUMGVRLs7l46Cte8Mkt/DwxNsdjwHmC9J9N6RqB7q7JKUoditiZEy9ThLFqzVpHn2qyxa6R5JV/hHAam3vl3Kyyv5xipQekvdNa0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4twqP1mOMgCNYvqU5FmqP/GUZzQQEiGdYQonJcXDSgc=;
 b=RdkWY4J+04YO4AB2wuqQUlPhd/NW7BeBd7c5CqjcgqSm6EFTXepKZUGtDfjNxj2muTaICTqfEWgRkFSPrKQJwviJYmNlXLsbzi2omJ6SDyItvlkVun0jPcHe/JkgaM93WcLSLxyxbjtXVjXEGx3uW7ezwuyhEhFlQ0YR3z3GO9GRk+yXIR30IMEbfTFEO+vLJCNtMUkj4AKoTparTiHXFqqcurhXH0FVI9vKPyus4DrvTDAJUrCehqzVmknsJOFepCx8xQoOP0LdpLz6KxfvGRvq+S3lHi8VEwzyS+g/5VF5nYBt4KMVZmcC/64iPTUfjS8aS94vHP+KC1YlVJt6kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4twqP1mOMgCNYvqU5FmqP/GUZzQQEiGdYQonJcXDSgc=;
 b=UqjD4qnXcAGue0vdgmFsOkukXQWWnOQzn4IKFJv/2LL7gPLCg5t/t9A0WuHG2zuSvk93lpixwAIeQVcLYsPGmZp7ljBAqqkV/q1X29Rl5cGPuoBCUY/Ao7Ftl7RbxCrl/tiH+YbVifCzfNYRKPKOIgLbv2fAlh7Vj/sUwie8xHIY8QQndgq6IcKw7+gtmz6RdP/saUHFNoAkJEXeiu8em//4i7tOQ0S5oMhEBjLsGbl2jzwU0lA0lSuuCMxq3zV49tb8cNBxdzu9+MwwvBF7OQ8C5v0OR559dBlvjK9QPmv2j8VFhGHFc2M2dF7RcHvKUh/L4hQvqLvkYMGm0GI5dA==
Received: from CH2PR18CA0027.namprd18.prod.outlook.com (2603:10b6:610:4f::37)
 by SJ2PR12MB8783.namprd12.prod.outlook.com (2603:10b6:a03:4d0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Sun, 16 Aug
 2026 06:51:38 +0000
Received: from CH3PEPF00000013.namprd21.prod.outlook.com
 (2603:10b6:610:4f:cafe::56) by CH2PR18CA0027.outlook.office365.com
 (2603:10b6:610:4f::37) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.17 via Frontend Transport; Sun,
 16 Aug 2026 06:51:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH3PEPF00000013.mail.protection.outlook.com (10.167.244.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.0 via Frontend Transport; Sun, 16 Aug 2026 06:51:38 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Sat, 15 Aug
 2026 23:51:26 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Sat, 15 Aug 2026 23:51:26 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.46 via Frontend
 Transport; Sat, 15 Aug 2026 23:51:21 -0700
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
Subject: [PATCH net 2/3] net/mlx5: Move vport DOWN state check out of mlx5_query_vport_max_tx_speed()
Date: Sun, 16 Aug 2026 09:50:14 +0300
Message-ID: <20260816065015.3280733-3-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000013:EE_|SJ2PR12MB8783:EE_
X-MS-Office365-Filtering-Correlation-Id: f65cd56b-56be-4588-feb0-08defb62d237
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|7416014|23010399003|36860700016|18002099003|22082099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	NuNPvRSKQ+Avjdueg8glYGPswaZMEC6cWHJxSAq0uexnAlFNEf70exVxqcvVuhNpRX3RvH7HqoUUTa+HrPxnAX3QXb6GvOU02ry7RtA/6A+HvZGSLs/sluoqLEgmN3ib6xPSjKPWRKCiynubgkdAZ4Ptm0ddGyZXOuN+ZPGklFbAIl4abQvXQF36vTJy71SExmvPi3L8m5nh8c17cL4GVSQHvbJ8jCD5CiohxceJi7YrihoEUc6zYKjJO7ZIj8Gqdugd2F3fCl7ri11mV1aIQd9VSbKR0HhZQRKWw7KkMo/Ek0BOvQuMwvHNKqF1TWgNiKnywm4AvVUXyxw6GOlIJrFC0YaIRCgB2ApUc8tYHg2+HuRomaDIr0AJvPHNiLgdvePKk+5x9C6kvjKqa15u/RXxqNpLdS7I7QZOkaThEK/01Bn862ip2J5ZpFiEHSTrb628xORyZ1HdHMK1wouOyp/qoTyu055omRJKCVb89Qhq2G3+rCmUyYAjapEu1QdXZY/Th/Qm97HdVQMNQSJxj66CbPFhwZ2m8kupa7hUANib5ZpO/AJI91kjai44ketYQW98pc7J7n3IXXQEObJMs25yJUAnwGfnmfX5KC95gwagDc97z6FXqRGv9C/Z0vn/enkXVX/4h62JoCzSbT1N26qES54FQW1CzyBnk5V/rvV5N1QirLK8CswJmX4Owiyei5Si5ulDHdLBhBCNdQc7Ng==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(7416014)(23010399003)(36860700016)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	WimbGDJnFTMWYLD8NKVcy21QBKh/WSONPXeYqf6DDg4EENC3l8xHtamuQem7PM9hSwIAQsTHU0g5fsp07N51PgrXNOxPZXPqRTpExwAR80LZrHZazT17/bfa2MTOePahtqDRtdwt8awKNyy//5zVFKxrZf22/UZgl1F80AEYjVUgP0rHBum6QQVJx1Ss5Ypks0w9hphMeQM7XB2DM8DxwP1Ar7NRm589mcL3hFF7Pn22xA7/rm4QbTpgJu/tBLw5ELn0W3ZZEnOdakiuhJ+ICcSBhZHn6dDdqs7qcNEYzNYOrdoKZ13OpesxlYRJ6bDV0EqSHhOvsyLDQd8/cZkYhi0kPp/EATV6HAZ/FkJr8VI+k+nIdFv6W7MWnAbjd7i3KHX5osWilJMvvk8kXbIgYieduiXpIqks/3EO5R64S8NrnDPHxuKHRUMaimT0ZUzh
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2026 06:51:38.3990
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f65cd56b-56be-4588-feb0-08defb62d237
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000013.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8783

From: Or Har-Toov <ohartoov@nvidia.com>

mlx5_query_vport_max_tx_speed() was introduced to serve the
query_port_speed path, which uses max_tx_speed == 0 when port is down.

This is incorrect for callers that need the actual configured speed
regardless of vport state, such as modify-vport-state helpers
that must preserve the speed across state transitions.

Move this logic to the caller function in the verb flow and let
mlx5_query_vport_max_tx_speed() return the raw firmware value
unconditionally.

Fixes: aaecff5e13cd ("RDMA/mlx5: Implement query_port_speed callback")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c               |  5 +++--
 drivers/net/ethernet/mellanox/mlx5/core/vport.c | 12 ++++--------
 include/linux/mlx5/vport.h                      |  3 ++-
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 02809114fc79..794b869579ad 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1631,14 +1631,15 @@ static int mlx5_ib_query_port_speed_from_vport(struct mlx5_core_dev *mdev,
 					       u32 port_num)
 {
 	u32 max_tx_speed;
+	u8 vport_state;
 	int err;
 
 	err = mlx5_query_vport_max_tx_speed(mdev, op_mod, vport, other_vport,
-					    &max_tx_speed);
+					    &max_tx_speed, &vport_state);
 	if (err)
 		return err;
 
-	if (max_tx_speed == 0)
+	if (vport_state == VPORT_STATE_DOWN || max_tx_speed == 0)
 		/* Value 0 indicates field not supported, fallback */
 		return mlx5_ib_query_port_speed_from_port(dev, port_num,
 							  speed);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 080f097b7bfa..edac2d694e0f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -131,11 +131,11 @@ int mlx5_modify_vport_max_tx_speed(struct mlx5_core_dev *mdev, u8 opmod,
 }
 
 int mlx5_query_vport_max_tx_speed(struct mlx5_core_dev *mdev, u8 op_mod,
-				  u16 vport, u8 other_vport, u32 *max_tx_speed)
+				  u16 vport, u8 other_vport,
+				  u32 *max_tx_speed, u8 *state)
 {
 	u32 out[MLX5_ST_SZ_DW(query_vport_state_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(query_vport_state_in)] = {};
-	u32 state;
 	int err;
 
 	MLX5_SET(query_vport_state_in, in, opcode,
@@ -148,13 +148,9 @@ int mlx5_query_vport_max_tx_speed(struct mlx5_core_dev *mdev, u8 op_mod,
 	if (err)
 		return err;
 
-	state = MLX5_GET(query_vport_state_out, out, state);
-	if (state == VPORT_STATE_DOWN) {
-		*max_tx_speed = 0;
-		return 0;
-	}
-
 	*max_tx_speed = MLX5_GET(query_vport_state_out, out, max_tx_speed);
+	if (state)
+		*state = MLX5_GET(query_vport_state_out, out, state);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mlx5_query_vport_max_tx_speed);
diff --git a/include/linux/mlx5/vport.h b/include/linux/mlx5/vport.h
index ee34d3ed335f..d5113ecb5958 100644
--- a/include/linux/mlx5/vport.h
+++ b/include/linux/mlx5/vport.h
@@ -61,7 +61,8 @@ u8 mlx5_query_vport_state(struct mlx5_core_dev *mdev, u8 opmod, u16 vport);
 int mlx5_modify_vport_admin_state(struct mlx5_core_dev *mdev, u8 opmod,
 				  u16 vport, u8 other_vport, u8 state);
 int mlx5_query_vport_max_tx_speed(struct mlx5_core_dev *mdev, u8 op_mod,
-				  u16 vport, u8 other_vport, u32 *max_tx_speed);
+				  u16 vport, u8 other_vport,
+				  u32 *max_tx_speed, u8 *state);
 int mlx5_modify_vport_max_tx_speed(struct mlx5_core_dev *mdev, u8 opmod,
 				   u16 vport, u8 other_vport, u16 max_tx_speed);
 int mlx5_query_nic_vport_mac_address(struct mlx5_core_dev *mdev,
-- 
2.44.0

