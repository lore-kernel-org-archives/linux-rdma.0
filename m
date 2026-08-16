Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010063.outbound.protection.outlook.com [52.101.56.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C513B27E8;
	Sun, 16 Aug 2026 14:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786890119; cv=fail; b=oga4FWQIwsAyoC4G7CVUfOnjQmoNaBwOkksfyjOBOf9ZNchObPClaKwyPVnM4pQVjmFD6uv5Tk/VeTri0ddkntzXdghtnN3bvVUvaE9uF6cebdSwPynr4TJlYMLFtHS9/dIFUxptyIgdDsbL8K+Di25d+0f846ZVgrdHHFiOqYo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786890119; c=relaxed/simple;
	bh=ZfmuYhxhzd7qOVmX2xgtJ3BnW+EAFsqjVi7n0Yy9Uvk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q2gXSVNgRxeTZTbh3XcXYAzERIGWprUYEwgA/aUGXeAREGlBsww3SFiIWH/4JFEfpjfWFldskgRvEITu2cQFvbeRcQolytPE9i0ohJ9I6JVIDO1s1V4Cm1R5e1foyX81VQtAin7/3Wt7YyFPyIrmXMfBw7nsQQ+zin+rGX/geHw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WW0B/TYm; arc=fail smtp.client-ip=52.101.56.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WW0B/TYm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qRB03xvQJY9bV7Es207xuU4JpJbLR1wuy5W2NVxzhWEmpHPkRxuXLqZYjPpg9GbLlDiy6joMH8QOvP2hEWZmzoADp3t4cgbLdNl08ajskL5fPc9Gc+4ZAE5K5+pG/E4xddhWb7vAq09Tmi/CV00/8i7mInUnEcENKATrG/4cla/0MfWUrbtmN3d9pM8MbArkbTAlk+trtJjWeJR022DPNTcjJd6bbreNkpuZZozZGwO6db0kHs1K21TeYRVFUKv0G3CrYWOFE7IfTJoUEQSmMgSRInSO7EzWm1e8kT6dBHfvLp+2casjbTenKk7xbEqwv9gsjgGo9iZMiLiy3dsXFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fw336ks0vWngNLjiNjUDNAt3ba7wb2b7GXRkR/DneGU=;
 b=nDIoqUd681ioCLFBTSN/eHaPMtCww+4TfWvlytQ/2abuZmhMXwsbwTAQhmjnDZUigfBopf7kmgHu/Sbm8Ars089MMgLfFYTM1V0WI75ACeTQeUJs7y6sMs1eO8fgh+KC1Qvwek8e6LCdskuV4gFffQQF8le9k0ObNnuR/wjMrGVG/m+fdFJ8lIgn8CxdGXGDavnK1YBCNb4spfCTLCsuv4sgXSoSrOC7kwtb7FELg9I3WHSUMNB8iQzbrOXvjNOhvvM/WWrROS75lZCrbVbGGOu0oV1gPBW/fra9Nkri1jPxgMahLxkUpIKLxr/E1e2kX2P+8gYQor9tBsh5XHPffA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fw336ks0vWngNLjiNjUDNAt3ba7wb2b7GXRkR/DneGU=;
 b=WW0B/TYmnK3xzm+4b7NdFt0MTdp52W04MvSzPjzLzYag1k9Yh2AHl8Ev7hxu/yvYFK/irfLTVE6a9tmrlTrxtX2YIiI5tcd8bVf83T0g1o1O3tW+X+dSwk56wINxnyBJaO+sf7qQqEt0zUdRV+u/4LPqydNjeb7t+obdPjH6VGoBFe0ujpofzx6SSiMbmXPZuj0Z8p70WIrEQ9BbltT3j4qBRnJiIOKtpUIxYdw0+XUru1XdArfPo+4kXc03VK0qWnbBgML/H3yv1lBupN48z2h1jS4vh+f4sYoDWWJskRQRuZOGGGWZ2hoOMA3WsHvwO3SQV6qF50iCISyo+6AmZg==
Received: from DS7PR03CA0126.namprd03.prod.outlook.com (2603:10b6:5:3b4::11)
 by SA1PR12MB7441.namprd12.prod.outlook.com (2603:10b6:806:2b9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Sun, 16 Aug
 2026 14:21:53 +0000
Received: from DS1PEPF00017091.namprd03.prod.outlook.com
 (2603:10b6:5:3b4:cafe::a8) by DS7PR03CA0126.outlook.office365.com
 (2603:10b6:5:3b4::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.17 via Frontend Transport; Sun,
 16 Aug 2026 14:21:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF00017091.mail.protection.outlook.com (10.167.17.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.3 via Frontend Transport; Sun, 16 Aug 2026 14:21:53 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Sun, 16 Aug
 2026 07:21:38 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Sun, 16 Aug
 2026 07:21:37 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Sun, 16
 Aug 2026 07:21:31 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Alex Vesker <valex@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, "Erez
 Shitrit" <erezsh@nvidia.com>, Gal Pressman <gal@nvidia.com>, Jacob Keller
	<jacob.e.keller@intel.com>, Kees Cook <kees@kernel.org>, Leon Romanovsky
	<leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>, Vlad Dogaru <vdogaru@nvidia.com>, Yevgeny Kliteynik
	<kliteyn@nvidia.com>
Subject: [PATCH net-next V3 5/5] net/mlx5: HWS, Remove redundant FW command when reading caps
Date: Sun, 16 Aug 2026 17:20:45 +0300
Message-ID: <20260816142045.3289452-6-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260816142045.3289452-1-tariqt@nvidia.com>
References: <20260816142045.3289452-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017091:EE_|SA1PR12MB7441:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d216873-a5d2-45f8-c530-08defba1b83b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|82310400026|7416014|376014|1800799024|10067099003|56012099006|22082099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	v+ItfRgU7LIbn728kSAdd9kvGdtReMOdPn/42ErvA7qIczK/IyAc6bDe8vihsgB4a3FQtx4I9nC5xEFUjFSi/zTOqLoWwKnz3d/eaUMf5mjmhyVd5XhfAY+aa2MLv9w+UqVHGvkWr9Lg2ImCHtM3lBjU46PjezAMz/8LP+XIXO1VF+a9SlKiVb/hoCLWcPcNyt05W5189g0aTL9wWGAgL2byFcVYuvkpvFacaXHk8BbatxzQGxg6buV943ZPytOhAT7lePW/W3ghRd4kXgv1S25i0n2JWJXCWPRPCuSCIQTumu+fn8FLK/oYOVQ0nJj6JBTVk3yhO7DiGgYaXV//O5LsvumpiIvz69TvsorScjUOYTBvMVhSqF6lME7JC0n5TlKgwuXlHioMK2Fn9/wR/b0WtLu0Y/anpMSFqmW2A6+PMmB/7DaW4y745EYp8JP80mGDsLAABwHqHrvlo564W9hvNvUqfroyWe4IudZbgaeM1j7+/AkRXD1ajso/x2uohWkiYNoXeNNQK9tlLEA5LGWZsHtmBplgULIOxZoQU08T+Ztj3Qwm+MCNt2Kt716PPEXaLoxIqz63b//eIdVE2eX1MwzfuyMAmx2yfs3QRvo1Cd3KOB1iN9cYysxS4F4zGEl50XAI/MKtj/SMfbytvQJH8yN6wIpE7GfF3hfg0JYlL8JVO5ZJXr77/A4eHMME3HmQuqGOYnTTshwBSNgfpw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(82310400026)(7416014)(376014)(1800799024)(10067099003)(56012099006)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	aYPpBTA98adRrlLboy5yoHtchmBStjnZ4Dvfg/4Lf5Kfc8svJeggjnkwjuOQAHu3+yMp8I2V6dhdpeICuLy5FzItdBd3lCttqE+N7sgs88I4RV08vF0TmWcLNY8CPcqdIXqf/ccJVeEJzzbe9PpWZWD2vwDydiJLSADywX2uWq38Kd+HnTmwKeCImu1t5AGGqrwThuVtA44ileDWlA+OnrE1S6Ba5j26ofnd7oGZIGCty8VDNPhSEroujDS4WdqBia6jifeesPwR+0ziUZkVXQ+7LpT/LgnlWEd02GzHAaroXHMpVBPaypHVuOKcedouIoPpDkIfq+bZnhbYM0IzuxojaHholL6QSF3xx+TuPFtxTyojxbDyutXTcKPpGZq8jmU0Q3TYzCckFpi/giYY9bjpMDXyOvYvai6088ZoHRYU9BGFERdUzlaG50KVrvbw
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2026 14:21:53.0861
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d216873-a5d2-45f8-c530-08defba1b83b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017091.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7441

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Remove redundant FW query that isn't really in use.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c
index 3782d793550d..775dc5c2d7a6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c
@@ -1182,12 +1182,6 @@ int mlx5hws_cmd_query_caps(struct mlx5_core_dev *mdev,
 						capability.e_switch_cap.merged_eswitch);
 	}
 
-	ret = mlx5_cmd_exec(mdev, in, sizeof(in), out, out_size);
-	if (ret) {
-		mlx5_core_err(mdev, "Failed to query device attributes\n");
-		goto out;
-	}
-
 	snprintf(caps->fw_ver, sizeof(caps->fw_ver), "%d.%d.%d",
 		 fw_rev_maj(mdev), fw_rev_min(mdev), fw_rev_sub(mdev));
 
-- 
2.44.0

