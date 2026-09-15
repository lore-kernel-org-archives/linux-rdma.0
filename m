Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011028.outbound.protection.outlook.com [40.107.208.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823F64C77D1;
	Tue, 15 Sep 2026 11:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789472156; cv=fail; b=XJMBWG74l+bRO00OawWgtfC6SUpx94NbzLPPWKJVtkSdt+TIdqKyfcEmMNgPi0vu8okPEkKP/p1Tw3eGTLn8mwmdYYCd5xUb+3pfvO8j5hOQfhZ4BFJgdSBcaB1luNpr46YuJmFpc0z5DjI0pilVeVfUayOrQ7s1Z5SQvND20+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789472156; c=relaxed/simple;
	bh=ATzU+OYL6gzDfIXC9rpHnM4rp+EHLMggsFwkHSzbugc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mmeXOIGEAIEiVyJk3+C7Gg5mP4s0if4nieBMpFn7uyHZOhASdh2VowUgycLGiGZN579AZUAICiw4zMEwjKTAMAOPlaRg1k1wAwxzAnGjS0f4STY46WFGX+wiS8HvTGAdkx4fJ+BucoPgaKdJg89Q4q22RkxE3gZU4BOaza4Ilz8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rjGzPS7P; arc=fail smtp.client-ip=40.107.208.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rjGzPS7P"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZzNemaZGZyAw9H44czm1wR9wZC3R/KbfsazrfFW4Hq3HhjJOQsixgDjXOzlCro2pQfP8Bve1YF4vKQWTjU7QjI98Wh2rT+7JBc5Zgt39q+GGdHfJE2/C/jwwCTFt5Y7PcDAAgSwMKKjT7v0BArogsZY2+U0jp8JCgIujh6RlJ26ugxkxndLaN8rfiOhM4j8QNEfy0IcNYfjI28xlvgxn1F2mvF/4OrIDftcf7PDjHJ2UdY74X5vgMTncon7b5MJA/KD1FLP9Kt/OrRSbgZTdxnnMlfoNWii1mRG5WDrs7G0EFYr8ieB36E7StD3DUSdBx6kgg7PH6tR4npVn4PRv3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rcOrqn/JFHc4Iws7KwZOc6XnHTbfrGIXY6gMnhYqXA4=;
 b=qGqL6toqpg+4+N+SNZ2Pfx4IIn/bjq61npOYU+vOv7rGCALa8WXDqbXZlueyqs8/upFit4hmGnfOY7/YMBiD+bmnGHbKGUcgstUpIsKdHCp2+SFPM621BPhp6Nvd56NtqLfhMCZuGAR27W++bPrseBD3U1nyYukPzaBrK64Rux8LcYdpnt9mTFgdsGbYk/VkNuNRmi/G2tT6vSXftWIQ71jyKd143hcP9wkutkuno1BQjwgKKUVEvHqEMzKYUY4cAB/b34dPrzX/c4ry+jlJbgoLoPI5GzD9SvPzuSQir9GXY8zHRav4H5qIDYIkXLY/aCvIOhryTvsa0n+uKoSIog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rcOrqn/JFHc4Iws7KwZOc6XnHTbfrGIXY6gMnhYqXA4=;
 b=rjGzPS7PiH0OChZzOeYRaCDX35kJnAvhQgNcdtPeEFe/JHOvr9ZT1PiI4B/jE/HJua8OWaykR917GUZ01sUQiMxa2QJEKKJ4fXdW/gDRzz6tS5KimRPN8lgYNLBahE3tVYE2se6uznK5YYcFZjVb/ro0rtyvY2S9X6yKKXwf/ZE8XK8xiGmyLNtOCWnRH/3jYJFX9TU39jCxs9tRWoYVCiRsRZI/v0QDGM7QNDolzj6NZnsMXmxedHPfN1ZR6+DvfaYLtvSFU4ryTVbylxLq0O525ya9he2BEKFy5lY2Uk2k/tLtFl+20yTgckzcDQ3jd9bdw6j+GjS82qcbOkX1Wg==
Received: from MW4PR04CA0282.namprd04.prod.outlook.com (2603:10b6:303:89::17)
 by DS0PR12MB6440.namprd12.prod.outlook.com (2603:10b6:8:c8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Tue, 15 Sep
 2026 11:35:45 +0000
Received: from CO1PEPF000075F3.namprd03.prod.outlook.com
 (2603:10b6:303:89:cafe::6f) by MW4PR04CA0282.outlook.office365.com
 (2603:10b6:303:89::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.12 via Frontend Transport; Tue,
 15 Sep 2026 11:35:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000075F3.mail.protection.outlook.com (10.167.249.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 11:35:44 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 04:35:23 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 15 Sep
 2026 04:35:23 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 15
 Sep 2026 04:35:19 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Gal Pressman <gal@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net V3 2/3] net/mlx5: SD, unload reps on shared FDB create error path
Date: Tue, 15 Sep 2026 14:34:58 +0300
Message-ID: <20260915113459.3934760-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260915113459.3934760-1-tariqt@nvidia.com>
References: <20260915113459.3934760-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F3:EE_|DS0PR12MB6440:EE_
X-MS-Office365-Filtering-Correlation-Id: af1e2e22-6af2-487a-5731-08df131d7afd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|36860700016|82310400026|1800799024|56012099006|10067099003|18002099003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	Wc81d0Df/Bllix/t+Ycm+P8BD9ClZuJZr5JInPlZd+6JFoB0+VjyDkJs9m00B9r3N5ejkRQJWgqeQQV627H05ygb6mtY/g2Xt9X/tb/Rv+V/n9izgKDRJ+1rY8R/3AuSt/0i23xlk5zIANSH4ryDaNYLb5qTdv4fUGQ9KyuDosr+itDq1hpEb2p/liScX56E3BozlMpoN3f6JMBuExL3LA6Lq0zhCM81VJ5R/x25jB6PGlpLH3H/d1EAwpwpcL72yf25mgxtrpAJZ3d4B/JekwR2WRnN5gwDYy5QQCT5p8i1S7p4jD/AlWUQfCIWXSiHDYbfqu3mcwpmtAoQ425nXQdKsBEyfaf54xQNVADBH5w2ak11jgshEbA3kH/c4izd44iDEGuHIWkRwtcJxQalq6mWRrdlZm9+21hmvxhegYN/DqbMrCfXg7PM13v+Q6iR2Lj3Bmb/wKpZH+lMQ73VaGeB+nzSvyndJCrwn6/Lvw+TOtEDJL2hhqJnJ6dzjlqW0zM5PMEctnk4oG/IXUuN8r+bnKO8gR2E7q8Z718+t1SkJjE+s22Z7gOaQrLVSBoFS28p7l7LLNJcBcTv6fScC5sDuXQZYiGwgWlZu0wXGJAcVuVez3DT3oWUXVEWHr+N3YkEgxNjWHHemBtc2L1mYVaq//bdXbwkNvN+nHqL/ylsuXvr2ax6NAvl+MOtAnucnU/Gxbkx4/DkGaE7k3jPQw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(36860700016)(82310400026)(1800799024)(56012099006)(10067099003)(18002099003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9m3f2A9IUeaJUTc8mYafVI/Dir4QrCqHG218KdFSdadXYiUpobhbuPLymSMOWZEFJlTqLwpRivN1x1TnwPfm1sNOL3qom/gbTxm7X8etdEAVMIa5wz4epDFa4BeyhjiVSRiP21Bthk1NJr1LFOvoR5K9rRAiodOEQdBbAsnt5rYp+EZDyz/cQs8yNMxuSwgBtLoS2TNsP1JKiKiIzlp/ByOHA2v0fAbk8hpZ7bN52kX2UxoCJYq4fOLPT6nApKJuQKNCR0zidWspA/hCm6a1wNf2ibnd7umOF3A2ZqPzojfOV8lbY0UpzKE0O4osLdiiMorzxtt2fIIugJyXJ3fTKas4L9k4b+WIPQ/qcpZsv6tc74TBIoo2BTMta4POEOQ4hxSztQXfE3atjlfnLCZ6Iz+o2LghpCYU8bomVDIEqRoOAS7MUx0fhgflMwk8ahmW
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 11:35:44.6864
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af1e2e22-6af2-487a-5731-08df131d7afd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6440

From: Shay Drory <shayd@nvidia.com>

mlx5_lag_shared_fdb_create() sets sd_fdb_active on every group member
before reloading the representors, so mlx5_lag_is_active() is already
true and the guard in mlx5_esw_offloads_rep_load() does not skip the
VF/SF reps. If the reload then fails, the error path clears
sd_fdb_active and destroys the shared FDB, leaving the reps loaded
while SD LAG is inactive - the state cited commit was written
to prevent.

Unload the reps in the error path as well.

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

