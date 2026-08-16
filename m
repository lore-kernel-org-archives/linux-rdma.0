Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012030.outbound.protection.outlook.com [40.107.200.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3462F182D6;
	Sun, 16 Aug 2026 14:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786890091; cv=fail; b=b02j4pCHAe96tS6U6qHbEfYPjww2kDPZkQUudvQ5qwi5pBmMj3k6q7fmpXMdBF91fppzLMIERb+ovkzOhEeqrXrQEbIMbTflK77js7GBfyzWoHD2gvmdjR2IepurF+2fi7KAMFNf2Zv5NtXMClsB2Kt7vpNq3DC1JB3rTSK/7ec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786890091; c=relaxed/simple;
	bh=W3O9sQIGbCzRUNvJmxf7/Nma0YTqbhLOYhDc3ozP5qs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CXZiO0Yd1oQ5K+aO8LvQn/tPc7AlbbOR7+PNWOyZoQLINCljLm5TtcDYnHv1Y6zmvJ8S0SxRDKMgWJbe4EhdfrpSNGECS7Yv9WJ1Ysg5hvVYwG7SVlYG+oPzZI1lyD5ciMwALzJLTN9SPBcBTTQRu8OL/RZcZxauW+dbgslHAVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kqq/sFpe; arc=fail smtp.client-ip=40.107.200.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kqq/sFpe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O2rYegbXM1GfOZLcad2hk8vFDMrQCi+NLeXuzy1vr2hp9C/FYgJDrPVerTUzgj1c+v/NvH62/sbj3CA9yXuXbCCOrpELE5dmitYMxyxqaiHd8Pdf8F4PJ4I4WL99tpSau/v3B0RtlVeAg37vieK7m2PlwpCM+l3nY21rQdgisLgI4NAcMZx/tmCn2Zwc1rG5dhYfqi3dBtweeQzZl6hcgvtrkDYgmds5YFs7lKR4PI0SgrpaHORHO8kqcFc+17VgEfP0OuAkBKFPqvQNdHuMc7TKtDuInVv1r940/idvrLZG7AbjRzsvwFNQE/b/6poNCoHQ7lxUGKwNeEjIQn7UxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oyvfa1vyixYOAS8wi4hl6y4ND+r7pB0CRgEW5wYmB5E=;
 b=o9E9f/BzTPhs36uQ9qLtnGAWNxC6cQgP28gDr3cjrAHdrca/KLjAR+pRCDDDgDaSe3MxgbN/FhkLwgBOjprHw8D8rcvr2mxe4H8fiyjAORQiZtgJFzsr+oOCsEW+c/Eg/sL1s8Y2p9DqpXy+Kbp7X5Lq5tVF0WgCIDTwWG8WRVGlmtZ688CfwOcMgJw1AXjl5wazZ3sviYAdtFsX9f0Pe25Xodbg/2G+hN53x24RcctmCkd9RU+0++sU2L5dS3sZy0wuqIJu4y86LBrnCNAj4rKXN5ZhMhRoAcLM43cwM+y92RvkAc7r9BkYp5aSDPUezOKVXaLVuJs8hy0FTS1SiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oyvfa1vyixYOAS8wi4hl6y4ND+r7pB0CRgEW5wYmB5E=;
 b=kqq/sFpeqFDTM6f8kLQJEN3Tn28+IqNhBw9f5p+Ut+qlWabvLzuZkeTiTRLQoyKD3GUdguBWQtmziSVxVgzYoFIhMIejpjxmSD2Qet2ACvDgmLeBdNNkuWeZNtu7iHfan7vXzUlqii2bQ22tZS9T0P5XG6cCJf1JCYb4RJ+Qmu7FvdjPEN0zgLVqer/YgB4YOqQbLsBWbS8Lg2StI5A8G+gsHBLqJ7rltAjoz8DFCOpWWwc1qR+sVT4hfSMDb+zBDMQPVhs7ZJcna3X9bQhJ0mpO4I6k0o+jTtymdL/BNSan2guffXZcCLbXHsk2k+GCp7afAHPB/G8Pf+Ni0igrrg==
Received: from BN9PR03CA0560.namprd03.prod.outlook.com (2603:10b6:408:138::25)
 by PH7PR12MB7257.namprd12.prod.outlook.com (2603:10b6:510:205::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Sun, 16 Aug
 2026 14:21:24 +0000
Received: from BN1PEPF0000468D.namprd05.prod.outlook.com
 (2603:10b6:408:138:cafe::ac) by BN9PR03CA0560.outlook.office365.com
 (2603:10b6:408:138::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.16 via Frontend Transport; Sun,
 16 Aug 2026 14:21:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN1PEPF0000468D.mail.protection.outlook.com (10.167.243.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.3 via Frontend Transport; Sun, 16 Aug 2026 14:21:23 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Sun, 16 Aug
 2026 07:21:11 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sun, 16 Aug
 2026 07:21:11 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Sun, 16
 Aug 2026 07:21:05 -0700
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
Subject: [PATCH net-next V3 1/5] net/mlx5: HWS, Print more details for bad completion
Date: Sun, 16 Aug 2026 17:20:41 +0300
Message-ID: <20260816142045.3289452-2-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468D:EE_|PH7PR12MB7257:EE_
X-MS-Office365-Filtering-Correlation-Id: 213c5b64-c278-4c2f-4aab-08defba1a6ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|82310400026|376014|1800799024|36860700016|6133799003|22082099003|18002099003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	RQprUb+ff7XeDpKvOVAPqKipV+LiNQ4QwtUPqjLiA5fxR6lTwvXs49hOE3A5SoR9NrKPPaSGX0Hmn8yyxDvVje61841T/wrZLa6nFRlxZbEWGNH4UwuTWlre5PxMmmcmrhd2LRPDZfNEVBWyRpFIfi7x6nMWWrGQbRDTLPF7zIfgkpwGUgjccq8/nAzzfgesq0vXLU7/DS8Zer9gPk4fjZ4pqYwMQLOBMT8U3658QBVPExO9z6OGTwz31Ixn4cXRg5J+lflvzFqg0coM+L+5RxKWEcq5muyBu0g6zd0niK6CiZXWnTTY5Vgzqjz6FX1robfcDChuaWSG15jXvNYDLwUoYEppsGhSFSMEJQ1qFE3n6HyqDQUwB/pBBmuM0Gs8hvVFucQ08TkGAUauSb9YbaCUthg/TuQxDFxUPyJ7slZeZehUgQqsSNX/K0Clh1Pm/2r8AtiXGVSxSGSNjJ+lehej51EUB7T/ooL99E8U6VUE1ml9veTzJvkqRdbcrVKs50UX6WiPfqmp/yUZ9LvK+yroyByc4QY3eP0FgRJ0f1zxZy1ORv4aYvB5ZsFn3ryGXNQdY26rCRjNSGq8acEGd+mkJ8zfHVR76UE2U471VTuW9gKbrpaiyDCWI1/br0MkYzeb21Dw3zDGTpkWJ25koEfn0WA0PLXmuaPx9CtAYg0ZBOvv9QNDX30Jom9BMxK7MuFRNNTVyvMg0xPIvyhHEQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(82310400026)(376014)(1800799024)(36860700016)(6133799003)(22082099003)(18002099003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	C2Ka64jaJTrVPvQjngrdCc/q8BHEyzcW1qgQfVBgv0oZ3Nc2d5MmgsQKGzWRIiB7xd5VouGEnCQmHa10xzvJly4Z4sXeAAjCHOgugaPKuDjapc5I7fc08TsR6koyK9KdfV3uvrTLhtPo6eVz/XSnmYty3PV7DVAowlyHNjgeN0eAZpSOpvB7KhNu3hbFrfgrIaudGS1tc8G36+lRabd+beDoSVC9G/BPVYkiyGL08n4gcURDB9QPhmiTBfjTEBL6wlMovsRQ6aJ3nfWA5w+QQIWTzGYCgS4joWzc/cOO92JTC0c1oZbTmBI6hYFCvDJUADrVdu4iSXTor/cjjURWKfApX6upj6gWeMiC5l4/0SYtO3vO7spIJvAN5C2yjNUeIdGahRyLwn7cSMmNILRNJ8Ckd00UmSpWKzrLX9M8aHdE8yEk6vTosDNwwerRmWAD
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2026 14:21:23.8250
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 213c5b64-c278-4c2f-4aab-08defba1a6ce
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7257

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

When polling for completion returned completion with error,
parse some more details: WQE count and syndrome number.
Also, extract all the long value-to-string if conditions
to a short value-to-string functions: do it for rule
resize state, rule status, and syndrome.

v2: removed duplicated QPN print

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/steering/hws/send.c    | 63 +++++++++++++------
 1 file changed, 44 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
index aed009aec4fe..6612e58c896a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
@@ -344,6 +344,36 @@ hws_send_engine_update_rule_resize(struct mlx5hws_send_engine *queue,
 	}
 }
 
+static const char *hws_rule_status_to_string(enum mlx5hws_rule_status status)
+{
+	switch (status) {
+	case MLX5HWS_RULE_STATUS_CREATING: return "CREATING";
+	case MLX5HWS_RULE_STATUS_UPDATING: return "UPDATING";
+	case MLX5HWS_RULE_STATUS_DELETING: return "DELETING";
+	case MLX5HWS_RULE_STATUS_FAILING: return "FAILING";
+	default: return "NA";
+	}
+}
+
+static const char *hws_rule_resize_state_to_string(u8 state)
+{
+	switch (state) {
+	case MLX5HWS_RULE_RESIZE_STATE_IDLE: return "IDLE";
+	case MLX5HWS_RULE_RESIZE_STATE_WRITING: return "WRITING";
+	case MLX5HWS_RULE_RESIZE_STATE_DELETING: return "DELETING";
+	default: return "UNKNOWN";
+	}
+}
+
+static const char *hws_gta_syndrome_to_string(u8 syndrome)
+{
+	switch (syndrome) {
+	case 1: return "SET_FLOW_FAIL";
+	case 2: return "DISABLE_FLOW_FAIL";
+	default: return "UNKNOWN";
+	}
+}
+
 static void hws_send_engine_dump_error_cqe(struct mlx5hws_send_engine *queue,
 					   struct mlx5hws_send_ring_priv *priv,
 					   struct mlx5_cqe64 *cqe)
@@ -352,6 +382,7 @@ static void hws_send_engine_dump_error_cqe(struct mlx5hws_send_engine *queue,
 	struct mlx5hws_context *ctx = priv->rule->matcher->tbl->ctx;
 	u32 opcode = cqe ? get_cqe_opcode(cqe) : 0;
 	struct mlx5hws_rule *rule = priv->rule;
+	u8 syndrome;
 
 	/* If something bad happens and lots of rules are failing, we don't
 	 * want to pollute dmesg. Print only the first bad cqe per engine,
@@ -364,26 +395,17 @@ static void hws_send_engine_dump_error_cqe(struct mlx5hws_send_engine *queue,
 
 	if (mlx5hws_rule_move_in_progress(rule))
 		mlx5hws_err(ctx,
-			    "--- rule 0x%08llx: error completion moving rule: phase %s, wqes left %d\n",
+			    "--- rule 0x%08llx: error completion moving rule: phase %s (%d), wqes left %d\n",
 			    HWS_PTR_TO_ID(rule),
-			    rule->resize_info->state ==
-			    MLX5HWS_RULE_RESIZE_STATE_WRITING ? "WRITING" :
-			    rule->resize_info->state ==
-			    MLX5HWS_RULE_RESIZE_STATE_DELETING ? "DELETING" :
-			    "UNKNOWN",
+			    hws_rule_resize_state_to_string
+				(rule->resize_info->state),
+			    rule->resize_info->state,
 			    rule->pending_wqes);
 	else
 		mlx5hws_err(ctx,
 			    "--- rule 0x%08llx: error completion %s (%d), wqes left %d\n",
 			    HWS_PTR_TO_ID(rule),
-			    rule->status ==
-			    MLX5HWS_RULE_STATUS_CREATING ? "CREATING" :
-			    rule->status ==
-			    MLX5HWS_RULE_STATUS_DELETING ? "DELETING" :
-			    rule->status ==
-			    MLX5HWS_RULE_STATUS_FAILING ? "FAILING" :
-			    rule->status ==
-			    MLX5HWS_RULE_STATUS_UPDATING ? "UPDATING" : "NA",
+			    hws_rule_status_to_string(rule->status),
 			    rule->status,
 			    rule->pending_wqes);
 
@@ -423,6 +445,10 @@ static void hws_send_engine_dump_error_cqe(struct mlx5hws_send_engine *queue,
 			    "    rule 0x%08llx:  |--- syndrome = 0x%x\n",
 			    HWS_PTR_TO_ID(rule),
 			    err_cqe->syndrome);
+		mlx5hws_err(ctx,
+			    "    rule 0x%08llx:  |--- WQE_CNT = 0x%04x\n",
+			    HWS_PTR_TO_ID(rule),
+			    (u32)be16_to_cpu(err_cqe->wqe_counter));
 	}
 
 	mlx5hws_err(ctx,
@@ -433,13 +459,12 @@ static void hws_send_engine_dump_error_cqe(struct mlx5hws_send_engine *queue,
 		    HWS_PTR_TO_ID(rule),
 		    (be32_to_cpu(cqe->byte_cnt) & 0x80000000) ?
 		    "FAILURE" : "SUCCESS");
+	/* syndrome is in the lower 2 bits of byte_cnt */
+	syndrome = be32_to_cpu(cqe->byte_cnt) & 3;
 	mlx5hws_err(ctx,
-		    "    rule 0x%08llx:  |------- SYNDROME = %s\n",
+		    "    rule 0x%08llx:  |------- SYNDROME = %s (%u)\n",
 		    HWS_PTR_TO_ID(rule),
-		    ((be32_to_cpu(cqe->byte_cnt) & 0x00000003) == 1) ?
-		    "SET_FLOW_FAIL" :
-		    ((be32_to_cpu(cqe->byte_cnt) & 0x00000003) == 2) ?
-		    "DISABLE_FLOW_FAIL" : "UNKNOWN");
+		    hws_gta_syndrome_to_string(syndrome), syndrome);
 	mlx5hws_err(ctx,
 		    "    rule 0x%08llx: cqe->sop_drop_qpn  = 0x%08x\n",
 		    HWS_PTR_TO_ID(rule), be32_to_cpu(cqe->sop_drop_qpn));
-- 
2.44.0

