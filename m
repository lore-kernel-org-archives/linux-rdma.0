Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010068.outbound.protection.outlook.com [40.93.198.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2610831B82B;
	Mon, 10 Aug 2026 09:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786354076; cv=fail; b=UMa0RgUJUy1HGFbA4PIIslL89+7uijTMV7+bQy0UPQJcRG6qmsN/WJeUvM+fG6JBcDz4KC9oA85w3QBFcTXTxFqZl4EzTJA15yTB11cl58eHG41wd8RmiAnBHKBUoeh6U8bdKlucEFm0QCxmO2cm1zym40+fnNOIymIaMyCevjI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786354076; c=relaxed/simple;
	bh=ZfmuYhxhzd7qOVmX2xgtJ3BnW+EAFsqjVi7n0Yy9Uvk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qrZ81Btln+X234QYgcaTjHD7ZNIgTEHpuu4yixpv8+E9G85++BnJtfapBRN85BoCQyhexnMDvYK2Pb+JbpuFs/kmyzyyWgtddYsWL9UPncEzHtHjTT93ieTbfTx8njJdXAyjcA0Qrh6Wbv/VzmbSeqNUobE+TNuAVV7NjzsIFGg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=emVIIZbA; arc=fail smtp.client-ip=40.93.198.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="emVIIZbA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rF6apNT139UqFc7q+B+TgN0G2Vu3ER0G19OZ+Bzlvd4pqMt5UKOScCU5S7SpYOAJFficNuKTPzZp1fHt0kc4g2Yvv2fRZL4lsQdzc6I4L4fJhsAGYsN/Ng8jT3CJwHO4v6nCW5fwOtYM+uRP4xbWrjWsnDPpD2Gn0mjsQvNY1ndNDA35YU42dS/WPDBTQ/boMyzezWNrq2qhsOorD9tsSGfyE/Ni+YUL36Ldfqx3FD19j4szhKQByRFmOHVx5zSJMUB4RMw3y0P7xRYFnqmNo4SEbpgBi0+LfznZxIPnc8ejQ/WkcaYjQunlAnZUYar6aynJGwQM1NXPsUrhAMu/zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fw336ks0vWngNLjiNjUDNAt3ba7wb2b7GXRkR/DneGU=;
 b=rH9IHbz1X+3inA6xmXJ7vi2y7RsbQradKxHo8YlRGZtjlWEgET9E6h086bP1KfOmrZb6OyOnOKW/3KIOsUz6EBOIkrygZgjw3HGK6+1HPI218jIjttFvTIoLTX75X6XKwZVzTzArfsUxx11kPSfTKuYYeRydkXZgKxEqjxc93Sf2liCRV1nQxIAoTU5dOFrD/R0HcGzv1zp5KdeSnq57LCaDiI603xnh90CE328dMwr+DDVmPvonoEQx0h2K3qhMXj2/wb0GO/HCwZrOvG0z6dHMEsF5apX+6NmyU4dJsEFUqPC0z0zbj+5ksTk9O3ROPaFRVk25cLPKpoy0kQrtRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fw336ks0vWngNLjiNjUDNAt3ba7wb2b7GXRkR/DneGU=;
 b=emVIIZbA5Ypk3jLLMgtsSeeJ2suJPsY+8Q0AiEz8ey2U8nCi4nx+CPnvvCuDJmucNj8tu2d1BrS/X4SRwugygvCbZBPBjU+sTRLthVaCTbN+S6NCbfL9G0VIyzGcbm7xJh13c4Zapq4RVgX0gCjBrKeFGjWPuNnt7Bc/yaKoTjak34J9FPtVkEyBdNRlwH4Sspct5zku5O13DLyU19rmdLnmmsn+jvE4AdaqEst+5qWjdm2xjiU8VuSe7jCwaCYbnLPUo3r+nPm+bsjqGKwkuP4xbkIO3pGmWM7hVFzUkwLhwyPRrL2KGaPdkrWlmLsWyoTIcZho/MIRq8vkrxuXEg==
Received: from CH2PR20CA0025.namprd20.prod.outlook.com (2603:10b6:610:58::35)
 by MW3PR12MB4457.namprd12.prod.outlook.com (2603:10b6:303:2e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Mon, 10 Aug
 2026 09:27:51 +0000
Received: from CH1PEPF0000A346.namprd04.prod.outlook.com
 (2603:10b6:610:58:cafe::76) by CH2PR20CA0025.outlook.office365.com
 (2603:10b6:610:58::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.25 via Frontend Transport; Mon,
 10 Aug 2026 09:27:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH1PEPF0000A346.mail.protection.outlook.com (10.167.244.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Mon, 10 Aug 2026 09:27:50 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 10 Aug
 2026 02:27:31 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 10 Aug 2026 02:27:30 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 10 Aug 2026 02:27:23 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Alexei Lazar
	<alazar@nvidia.com>, Alex Vesker <valex@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, Erez Shitrit
	<erezsh@nvidia.com>, Feng Liu <feliu@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Jacob Keller <jacob.e.keller@intel.com>, Kees Cook
	<kees@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Parav Pandit
	<parav@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>, Vlad Dogaru <vdogaru@nvidia.com>, Yevgeny Kliteynik
	<kliteyn@nvidia.com>
Subject: [PATCH net-next V2 5/5] net/mlx5: HWS, Remove redundant FW command when reading caps
Date: Mon, 10 Aug 2026 12:26:30 +0300
Message-ID: <20260810092630.3137666-6-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260810092630.3137666-1-tariqt@nvidia.com>
References: <20260810092630.3137666-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A346:EE_|MW3PR12MB4457:EE_
X-MS-Office365-Filtering-Correlation-Id: cff54b7a-eee1-484e-53ff-08def6c1a5d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|23010399003|36860700016|11063799006|56012099006|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	DFYEAijhFyz//UD/t5UMI59Fkwgihtmc2AG16jDJpbAXyS/rrR+wyAl4J8JSCe2EjdJ/rifuApxKe9/dQjEyuy//rfYfoE0RV32YtIm8klPWRDqRmCEVAoAEyPDcMCfFTfDbXhaRPMEdYUiW+osJVC29b7c9Nfu3SpY/BIvjDwe7jb1J7KB5vPoPy6DtrH5JWG9yfGg47IMOpXxd1S7Nl5Z+O2a65ttY1pcZMexcud4iX2vDKfF/ciOZUsjrMJIXIJX6JlgQd5vR3BIYZGIkA70cHjJIPUfqLH3dOoylMEGdsyYOCT+GKEyZzbOTrWiKnkPValcR6rg2HbpeoJIRdDXLsrN7xvo30+iUBMPc3pxPmK0SZuCyUjyhHtcHsgi9Dl2e8xLUAk1Mn1l52EpDLiEq0y5g3NCvMDIN48OJAeLG1uZhyiuWOUUITAPm4woxduz8r//Asy7ohMTswELkbBydHwbenRQvfrgVQZ16uSPvkFIJSVWMssvvOGVO5B0DpP03dp/0RqCZ4rBMhiXFXvAwlldebWtp5tOglyV4COonIwROFiw3dO5L0ffff4dIJPWCa806CVHrR7y7MFsNz5b+8IM9NYIRcQiyOur/IQBusCJI349cP4RYHP+WNYrOJ7YGI4EPNqQgb2PfTrTskhnupI8T/pTemTk9JpJsN990yiB4cOWwVRZBoH2QxDUCv9svbVYxmRVJo4u6LJTIbw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(23010399003)(36860700016)(11063799006)(56012099006)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ISGABVf5vlSNLBxKGEs08hffODg0rYEsB6+1Mo56fGWZdY8WsIms/yylW6tHYzvSA1Gwp34PPcF4h3q+uY62hr0F5PTxJMgfUr+HzsHf+m7cx64LcM7bpsqnvsWFDaV2vS4rSqOjKWh2mCqTJLbPCyphGLx2R2vFfMdV0UIWOYki+5utHDWBd3ZfcRicrKQjazj7iLshoEEeE+Jo/tJ7FNr1fGhVgKaWfWhPlYhzJ6O3pjIb0N+T9fDVZRyPgFNuNOrFaKxWHwQw4AjIiSIVW84PGTb2N3qxxNSQNdSn2okcHii1MiIoPFjoQkiV9ScMDQ+VqfAuscQHazn58Jt2pdkFtHQD8CX6UqWmjjSHGn7ArZriID4Y2K9MBDUAB16qZDG3Xg3vA+JU+d33Ytth4gBbMF33B1MoV+JnrtQvuIjutETQMmccRtCAjReHiggh
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2026 09:27:50.3175
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cff54b7a-eee1-484e-53ff-08def6c1a5d6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A346.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4457

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

