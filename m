Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.64
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793725998;
	b=IobNQVhlg+GktjpPkPK4JL+QNqmATUj6KUdUi59r4ogO0too5O1jcdzwUHEAnCt2hiYp
	 mO4q1q5UULRScV6a0x+CKa8xA2qjmqK/CQwYBjDqRcCB7WBcIsvrf5bknpvCa7IjsieRC
	 2LO1pttjIPwDZuL1DJhdc0+CcENsL8IjTVTmgbYPf4Zwyx6uKDjNWyIvL16ZtrmEI8oGx
	 Kf4gfcCK95jAI4SwpQAqsRn7BD9qj4PLc16AbIq6W5R/OOdeP1EKmiSB9MPa1K2zZn9vq
	 aD38Ec2gnPUCyhy6bbmM/n2ZjBRyiuApihZoVO9/EUNxRFjn7D4VeW1aW4m1C4+CcYg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793725998;
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
	bh=sZS91GbDc/tatTP/E2MCvTEXCqTWv53t4piFgP+DJwk=;
	b=tMLRQziI/M0kPUl5SRDMqVo5koZXx4bFYTZ/u7hhjMsWVT2orUlz1jZhGQJ7Y2YNb9QO
	 p0z0TMS7IhLStcBk73mGT7+wA7SlIdpIY/AGT5jR1ItoZUxBo0MDxVjnqNXU9IFRWgikd
	 G+nlBySDZTIalXA9E2pIxA/nYcDniqJbf+sx2v57C4MZpcLBg1erBll0K4RpejM0jfO7D
	 MN6wuxy/ZzXseVfkvGGlF2/yLraEiYpwk1Qv44pmy8NLjEwym+SXzu6CyeyCiF5COP6Yw
	 J61L+FawLQJUfnJd40zgNOkSjhaU2vpKLwTezal9aY8e7ywMzcrdMVK+uL1sVW8urQg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=rwJMi0Fa;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.64
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013064.outbound.protection.outlook.com [40.107.201.64])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D22606D82C;
	Tue,  3 Nov 2026 17:13:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24D22606D82C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=rwJMi0Fa
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ydTNjW+kPRtYnD6m3ELvMKuTqGOXcXuDD4Umsxkx2qtdaC6veg2zMF6uy+CMs5eA9Lp/CSyv57OdNZVPi7jhkKgQ17Q265OoELdVRMmIbAeHgq0sCpNpVpPqgeBgagK9/Q/vefzZE8I9Vw5sygFbZdgWUtsy5QotsK2TX/0wUxVwlxkRfbYvZxUCu7M0Mdc2oJXzrq9xFK0RnfZenc3q2eSxNMEc2hfq8WDT46KvlgCL4MK3EakqjlYgbFVrleDMtCDxkh7DdCb+EFC4cwc6/0QJwwtxk6CrO7WGmhEp/w1BHcNW/AL5cPCE6jcZouS6CVIuspZFT3DpblO43xUcqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sZS91GbDc/tatTP/E2MCvTEXCqTWv53t4piFgP+DJwk=;
 b=kEk1QPQwTYUHGVos5iESw2YPK8U5zgIF42U0+qe15iJTouAPA0M8iZD0SUy/9jsEQdrLjZj0QmEw800T3+drbYFXzejWKtOp8o/xaEVtc5Vr2w2V0LnXUDMqQC79WSuLy5vOwb1/wUOEowtL8YzaiqM1/TvY14MXoSSqAT4hZwQXY4Ca3RvKpWRYK1dQ0DXXdzC25dh37CAUfWYfWM3uJ2OOZSFoNid2DJn6EKbUrWZHoGAbGHzgxfvin9T/kM+UXHXK75jdyZN8afMcJhazH1JsLXIUE+4iEZgwO1yQ2ZZ6D/94mtBiCZyS8EUyYvv9Bwctv1aKARw00iBqk5qQIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sZS91GbDc/tatTP/E2MCvTEXCqTWv53t4piFgP+DJwk=;
 b=rwJMi0FaYAfD+jNWBCp11dHR+DgKTYu8RACuxaTsBl8bPGLz/rcngw/83GNHRsF9YQqjGfD8pm12uGQ1sE/wSUkVfoD9pW3sp+fKZGNUxruH9/n6jnu481PKIBs4aSTN/NOk9XlDg/ruZ1BZRdktY3RPyazmOsZZTGoX/20JOnTo98q10PCKpF7Yde9p94OIfRKG1xWwHIBrv3lMRLreWT8pzn0H4tNG2InzUfekb4EYa5YfpOyc/Tfz9FeLMvqjnmZX3GGPOEaniuX2tH365ontp2Qz2vtIYopB0I3ecP3MPr8xKbRqgFDeJsd6Vk7syDAAWvrfVkEY9/kBkud56Q==
Received: from DS7PR03CA0300.namprd03.prod.outlook.com (2603:10b6:5:3ad::35)
 by IA4PR12MB9833.namprd12.prod.outlook.com (2603:10b6:208:55b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 17:13:14 +0000
Received: from DM3PEPF000265B4.namprd02.prod.outlook.com
 (2603:10b6:5:3ad:cafe::15) by DS7PR03CA0300.outlook.office365.com
 (2603:10b6:5:3ad::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 17:13:14 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DM3PEPF000265B4.mail.protection.outlook.com (10.167.23.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 17:13:14 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 09:12:35 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 09:12:35 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 09:12:30 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Carolina Jubran
	<cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Edward Srouji
	<edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Patrisious Haddad
	<phaddad@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 09/15] net/mlx5: LAG, drop MLX5_MAX_PORTS scratch array from device rescan
Date: Tue, 3 Nov 2026 19:10:03 +0200
Message-ID: <20261103171009.563034-10-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261103171009.563034-1-tariqt@nvidia.com>
References: <20261103171009.563034-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM3PEPF000265B4:EE_|IA4PR12MB9833:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c0e5aab-dc70-4700-6d89-08df39cdbed5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|376014|1800799024|23010399003|10067099003|22082099003|261102123227099003|18002099003|56012099006|11063799006|261021121427099003|261009223027099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	ZkbRQP2/KTn53w8bXNXvO/7LzPxIF/+kgLxoTr/aYhfW/qIlQT92LZg8UsJs/RWWgZ9ACwMz6/GJTJIkez5ve6n3RlZY5xRHawferMT/e/+zL4IWeHjSW5sgvPnZ5Ql+i0XLpZlJ4xWs7WgY9qh72kLN2uDhCiUu5uPqPTkoqPNIYirvan9enYliFdI4yq9AJQeMyvT6/97FxPihWJ/Ihm5JjPoDHLg2zlg9W3Vgj5fsSGeL+1aH7rPkrKmZGGgK/15CL77SimdDl6gVOYXCR3BKCQXsReczdjStBwc0Z3B1lKzt7fCgyA/6VzeaVzroHTZiXGdCta/qYkPhB/TWrzDFDnXl65cHhASqrhBaXDRIUEjuyZOf2h7oszwZmJ/7DHAaTjAnF+ks10PBLqXHMrOUX6vetROVphJlCMEd/v7HaHUPLYyNj0P+5hOEGXQlTEqM0xCSWL6gMMDpD3TltSgxD6hP0FUx3cq9r1NdhLJ/sb1qtRiP2lJ8bxHj+llrlbsd5HLEnlLyVSBwLRkUW0E2+Ldajlcu+fiS+pdwztBXZcvNZ0x1nxo0+Rk13Q8Sv9G5EbXixc4IvDDtu5fKuZ2TN7R/YV/SrjdLTspW6TAeapTHlstppYU87HuyBL1NrC5TSHkgsZGU9dmd+O3u0Js8Z56LXnWxvdIFUVW4vIV/2q5NbHt7iS4PJE5u/2pCqj4isRv3MbvFfKIpV2PWXQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(376014)(1800799024)(23010399003)(10067099003)(22082099003)(261102123227099003)(18002099003)(56012099006)(11063799006)(261021121427099003)(261009223027099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Nkh77kzNH62aUiy9hjKGHww+JnJTjWA3HqRUWtVfEJTry6MJDsUDAQrthYyXfi7MRoBIRWWXhZhWoPGDq67Kg6LufgQnZLzekgbt6xZKN0nIGXiaSQtbDvzou1hjiwtPlnUluss976K9aQy5wZHKdbG1KLm8DM41TbRDOC2OChWNXH4GhifEcUOlqdFy4sR+a8s5rcWlh7PpMqF+Mb9eA7BJohtddcyI19Y6uUG7pyWDbgqz9TE4bszb0guymmZ0/0BrOYek3oFOFYorRs1ANweLRxEuwxsyqMX07RBsBYPGYjOZ5Uy80bquobTLPmFiSS54fN02TGznTQ+hoClpy5QbzSrtaWD4rRKJ1vqzPPFV1UY37O02iwawNzWp1nUNsp5k9xEgNgQtZIADpnt4H00kT5Gv9tI7cIbYxYMybdUI6ftcWymBqGax32TVjWZn
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 17:13:14.1173
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c0e5aab-dc70-4700-6d89-08df39cdbed5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM3PEPF000265B4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9833

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
index b873eb91fd0d..9bc4a929cef3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1341,9 +1341,7 @@ void mlx5_lag_rescan_dev_locked(struct mlx5_lag *ldev,
 static void mlx5_lag_rescan_devices_locked_filter(struct mlx5_lag *ldev,
 						  bool enable, u32 filter)
 {
-	struct mlx5_core_dev *devs[MLX5_MAX_PORTS];
 	struct lag_fn *fn;
-	int num_devs = 0;
 	int i;
 
 	mlx5_lag_assert_locked_transition(ldev, filter);
@@ -1357,12 +1355,16 @@ static void mlx5_lag_rescan_devices_locked_filter(struct mlx5_lag *ldev,
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

