Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.31
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794825108;
	b=D8nns5IN68LNNOXh7LnpUmur8ysBeHAA/ZYpKajejq3nbr65FKn9F4Xrx2chYko1PE2x
	 JmFYyjdIHdCtNpqHpJS7r0JmMXpKM7o1l89uIatQuURp9GUPx4iKcQBeucPQ9RxZETolt
	 dn5Yec3xARY79DAbHh8SRfa8kZnD9wKzoBpNDFKxqbiok4Og0/zu3YxHKISnHCzJiyfoh
	 Ck5wsWotq1mkIrv+CKgWd2mJXZysK82dMKKICg4ElnIrh2/055VscXQjhxeDysfMTFdgP
	 F0tW0Si8FmogXK1dLixOrUNZ0NwWHT96T5bDJjc0SL3Mn1U/+jhnt/q0fDB+8YdQXHA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794825108;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-NV-OnPremToCloud:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=TBfdUSKnUfT4q8DvohCerT/nmodRemv5NsCGCjwH6MA=;
	b=RTpzBQFSNakaS0rcUkTnh1Z8NQhc2JqEY6LKhfO5RK05EZ71a6zFZeueAHkKddeyK6vS
	 /c8zTr3gltpb+4UbKtG7Ys4xh8sDxm+/HXHJEiAO7nsuDfz5GA8qt51I3ilb+EyMZKAVz
	 tdSX/G22kDOLtM/JyIUh4nqI7FPol7kPH5uJtBO07orGb/yL1g9BOxgOUd6rJbhX6MDGM
	 0Lkn4Qkf4EyXmlMMhSPMUF3n3VGz4b5eLTkEQYYDyGrowUQ6sqG5yC/1y7T1RtGatDtMj
	 gf8IR2cxwWxHx4T7GHjhudGYOjRrAKY5ABhl1IOh9eEjoHEaHBSZTUVtJE56Pn/4Zrw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ldmKH0x3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.31
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010031.outbound.protection.outlook.com [52.101.85.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36369606A88C;
	Mon, 16 Nov 2026 10:31:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36369606A88C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ldmKH0x3
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aPym5pO4Ao6CS3YvcWHOv3u9Ql/ii9Z/Fsf2pZ/h11LsDEtX5TygxnPfb0wEUjRkoK4412m9/kiyodVrRgh60JP0a2Xp44LzkgSVicTlKF8V3X4QgaQz+6q05HdA398a8L6s0bWU91hJx9kYsWlrlgWFCiXB64B6tMPLl8d51oEzzZwcRg6sKFpmpDz7TEDYNRGRNxBQsnvyPzJ6H1Vt860ioqAAZA467OgCI09tdKDN17XP+QwlmnRrNBRxYr6BxeV36/2gA53gxfMZ6pGKhPWGyJY46qCa+gaCnmklh5ckY5pX4f9/q302utaLWXIAGH5//3iyxmCTjL7CaacCLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TBfdUSKnUfT4q8DvohCerT/nmodRemv5NsCGCjwH6MA=;
 b=f2iIObg7KYEqAeL8+ar5JCvr3wGZ7JDN94ilQkyAzTk2HURxVf6x6MHavphN1NSj5cQZLW0VaQNNQJi5R7FOoQ6OMsDIKhjbTa/0krxoJ7EPkQLvFsJWaV5d7B+GVUSpdNfER0ZTE6h1o/QCGCdWnd33uET5F9lEeqGfj/LWHer/L8j0SaBBvNQXaJrUqbKqnXcMF1BrC1lNCd/PAOWkU5qJYo17i5+gk9aYM/lA9RNvMyvAbPdrWZdZXqHVMxxz5tWUO4cEmgbSvV1yF+zHgxC/NY6Rd/5T+tLWV8I5Z43fetQ/CnRHnZKHDBcIMrEnTe29JMaMws/bVH+CVUg6Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TBfdUSKnUfT4q8DvohCerT/nmodRemv5NsCGCjwH6MA=;
 b=ldmKH0x3dXHHGct7qOsCzygNPjEuGLhFooa2a0AO2ukJ/TR8XAVUfdNG7FbEZUA6skT8FkHEeUL66M1+EkwADC9JzlRDSqX/0HgyXiv0wQoEsaDLmw3lFwQ10NwzcAsrFFbrSyGK/xNmI5cwCBuVACT8LYkXSCVkd9cMWi3nQn38BUJwFzq1t56LlDYQn2rrV8gz38vVRyfhHCs3CMmsxX7Mf0nWgNcx/tPiT0FyB4Vkgrg2v4iuXQjL287zpyNPv4nKCoRG1p/Pf3LV3qb+qQcPdzjSWZccMqHSlccqFmYKG6LDJY3I7DGCZRAWfslUFVvK4vNyJawjKXWBYzcgxQ==
Received: from PH5P220CA0010.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:34a::13)
 by EAYPR12MB756173.namprd12.prod.outlook.com (2603:10b6:303:2f9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 10:31:45 +0000
Received: from PH4PEPF0000B60D.namprd21.prod.outlook.com
 (2603:10b6:510:34a:cafe::9e) by PH5P220CA0010.outlook.office365.com
 (2603:10b6:510:34a::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.14 via Frontend Transport; Mon,
 16 Nov 2026 10:31:44 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 PH4PEPF0000B60D.mail.protection.outlook.com (10.167.243.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.0 via Frontend Transport; Mon, 16 Nov 2026 10:31:44 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 16 Nov
 2026 02:31:29 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 16 Nov 2026 02:31:29 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Mon, 16 Nov 2026 02:31:24 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
	Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Or Har-Toov
	<ohartoov@nvidia.com>, Patrisious Haddad <phaddad@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>, Uri Dar <udar@nvidia.com>
Subject: [PATCH net-next V2 09/10] net/mlx5: LAG, drop MLX5_MAX_PORTS scratch array from device rescan
Date: Mon, 16 Nov 2026 12:30:09 +0200
Message-ID: <20261116103010.1129666-10-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261116103010.1129666-1-tariqt@nvidia.com>
References: <20261116103010.1129666-1-tariqt@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH4PEPF0000B60D:EE_|EAYPR12MB756173:EE_
X-MS-Office365-Filtering-Correlation-Id: f1fbd2e9-f417-4493-b43b-08df43cccfcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|36860700016|82310400026|10067099003|11063799006|56012099006|261021121427099003|261021123027099003|261102123227099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	xOFwd4nJAI3D5ugWtyGD6MiFUJMr6gia+jX7OZ++zXESmXNPkpL4sYA2e41l49oU6McX6lAZyLlS86l2k/6vt4BkNJ5FErh2i0abrl+p1uHcTcfIn91OjSldXnl+T5GKReNZbmjpxfvlvl8xdNsJxS1URsEhcB6GouGRVcDFxmLHYqQusOHLK2hUEi4HuQbMrVuX/y1CMCHid/lRFBtTwy2s1xztNSCMQNDBCYE+bNqOBm1jYB74pWa2qI4H1XKPGWXqy4PUvwLtoJ3Np3Y+9eoUCMTZNrk3iJbvxgncPOlTQBNfpiOhmaC7frUVUz2HheX4Z+zesVyeqVa447Od+elWYY0Z0/4JU8IafTBJGSykrhdkD6Itv0fmCG0vvpkz7pW55D9apdYKswYFqs/7UxKZUfKdCC5DGhGhMI3CcSkQgjvNiyDVGktSZprsrWxg5ZkvTxhTSt3w7KVy+T7Ou8sweNYGvl6KT1p4BtnnEUnrFvnhDlrm3a6rbHreB69JIz6qILL65GjYmyveM1rqyFPqF/r4JapwN2pl79LPKS4MF1+qF644by0jMXkCoRu8s0ghMaclB6Ka1+7YSZ7L+msP7rGv0vIVvDcreNcuCXXNf7Yaz5T8uZpcBAhWt3LavEM06TtcX7yaCIU1D3KwrVzomCnD1IWv4COZoCeFl2OKceJC1cn5+bs5CzsTDa5Nrrf5PiDcGu6ckNFvVMeQ2g==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(36860700016)(82310400026)(10067099003)(11063799006)(56012099006)(261021121427099003)(261021123027099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gO5Upa9+LHRPKL23E3h5v/qfxareRXIlbUjUpd7YPini5Jil2dMpCrm+Bu/LANjIM61wCoWwBoCk20zFc17bbh6D3EYqjiCpksngHJKXQ5vEe2RHvppzNaO+2cs3PEf3M/jMzjlPbtlrcrjVi1H7nAoBWE/Jv+HSBqQ87vty8iLQa4KLMBqZ2Dxs3hx1pOYF3JtJkhwinIFuUnFfPhzgFclWInFip7IQlPaognR/g0nke53HWAswbMIb6xIIVV6MkXo88bnSrDhX77aXT1NozHEqJjatCa7p3e7HPwRb4G+pYcUQYx8dw8QeymQeTWYyIn1UC2eTpxQW+2QEjJn4cEIIsZ3aTIl7sLwyHwl+9HzV3Da3S6PqozYRtk2fnP7VQ1/g401dLTY4lNfSxdTfpTnGJMwuBDMe4o8VS+y8khKzPsflKevH/VE6NK8yCmFT
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 10:31:44.7563
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f1fbd2e9-f417-4493-b43b-08df43cccfcc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH4PEPF0000B60D.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: EAYPR12MB756173

From: Shay Drory <shayd@nvidia.com>

mlx5_lag_rescan_devices_locked_filter() collected the participating LAG
members into a fixed-size devs[MLX5_MAX_PORTS] array only to iterate
over it a second time for the rescan calls. Drop the scratch array and
re-walk the members directly with mlx5_lag_for_each().

This removes another dependency on the compile-time MLX5_MAX_PORTS bound
with no functional change.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index a7b12353b722..3e88b3f51612 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1340,9 +1340,7 @@ void mlx5_lag_rescan_dev_locked(struct mlx5_lag *ldev,
 static void mlx5_lag_rescan_devices_locked_filter(struct mlx5_lag *ldev,
 						  bool enable, u32 filter)
 {
-	struct mlx5_core_dev *devs[MLX5_MAX_PORTS];
 	struct lag_fn *fn;
-	int num_devs = 0;
 	int i;
 
 	mlx5_lag_assert_locked_transition(ldev, filter);
@@ -1356,12 +1354,16 @@ static void mlx5_lag_rescan_devices_locked_filter(struct mlx5_lag *ldev,
 			fn->dev->priv.flags &= ~MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
 		else
 			fn->dev->priv.flags |= MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
-		devs[num_devs++] = fn->dev;
 	}
 
 	mlx5_lag_drop_lock_for_reps(ldev, filter);
-	for (i = 0; i < num_devs; i++)
-		mlx5_rescan_drivers_locked(devs[i]);
+	mlx5_lag_for_each(i, 0, ldev, filter) {
+		fn = mlx5_lag_fn(ldev, i);
+		if (fn->dev->priv.flags & MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV)
+			continue;
+
+		mlx5_rescan_drivers_locked(fn->dev);
+	}
 	mlx5_lag_retake_lock_after_reps(ldev);
 }
 
-- 
2.44.0

