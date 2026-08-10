Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011036.outbound.protection.outlook.com [52.101.57.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC2413C908;
	Mon, 10 Aug 2026 09:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786354055; cv=fail; b=Y/cgoNL5bCuYg/9oMmTgyfxrRVRLYD57jLRzeZ2KN5aFo3Jpj2BGKwuZ+OZcHHTWVsz6jpgozAqLbJ5AKFebw0izaZOUmjCU/3pDCalGGkKrP6h7CJ3/V1m79sEZPkswnAvGHmRGCCRAoV15Ry2kfxfoQfolj90qbF7wiwuqidI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786354055; c=relaxed/simple;
	bh=wPHsImfmtEe41G8iyeWq143SZFiEQhcc08P2sxjKJVI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W6UhfNHF+xX8Eeix75gy539uKFeXQyFAd7QVWIKnQAnLlVKwoYScakH4gAKXq1jmW1u+yb0R9CMHx9dRuJyWmkVKs8c2NnbH+JaDopYpoirM2m2dPEOpHkhC0KexDu7L8waHIlWW3zHZNujxJtq60bxJuFC3ZcAPdCx4zyaWgws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Km80K1ao; arc=fail smtp.client-ip=52.101.57.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Km80K1ao"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mguW+EmyfTrb1gSebFywcR8TTloPz1y2CTKoPhRu9xDRhK2etBNaWbiq5qsjAXORDkRIlgcMqLcf4t9K+PkEIzCR9BgrIeSrKdzH90CsPSNOZpsyxsGqGYiuLMpNR2kvwRN27Sr8HyidNSLHGec/Yh2MF5IwT2gYypw3CtO4V68MTvk1fuXehAwvUkVku6qHNoGzVW1LNQEUn0MhkvmOX93OCyxPDfPw3PMVJhnyIIOAP1fShKpZ/+eURbUgIx2oqANd1e/cCcabqNG5MbaPPtIYrJ2ZkEUhGvhUB6JKUrwUAZxgVBr/0pLg/Ea26PdXX/KV+Urdywuq9c4qRrzJZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WSaw6JxYXlPvpCrOt8rsSiZl3OVFFOfODDtMpbqYFl4=;
 b=EJb5LM5tlGjeKeDQMXj+zUB5Gj6wu355Zv0ROhJ5rdcE2RacjSeASNArF7s/smsFSld/ff+5sFUxtinzF6+CRjrHQmfUmA/R4o4beKxBh1qrvBvH8KwH368wbvLxYIBFPUjjKhA8PTyFTci3Xi93+n+zmXOmXpAWO+ya1AnZNJ3AgcVvAnmKiwDi+tXU3uOv5SlAiks6asU3Uka8jLLVzlnZYF+Sgcdls8IUlflnzQGtG92AuavcwYyoyQVv8ZAxQaNyOGMBsTx5HHSYIw0/W8JMn1Sxuqu4qHaQevILzEEYui+ZV0Y9Rpc2MnFmBW5tUJ3N1Ew1qKkeZEJFXPxhdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WSaw6JxYXlPvpCrOt8rsSiZl3OVFFOfODDtMpbqYFl4=;
 b=Km80K1aooqS1aXPnnUCisl9AV06OaIHN+cwJbPiCjDq50BAk5J+p1zb/zqnfbnVhyltgXecIV4AhyG5XAYaaqPxEs+2s0LeFlWErSMqgYUk7CRFmSoLRIsjFLZLSrs2X2R4ImWj9kSlfv5XQveaTexul8G/rnMNpRKH9giCpqqh6c4yohs0xvfIDWFj5GfkfObqYlER7CCEHHEhVpls8vIaUOHJbH006dK1tkABeMjEd7xJaffZK8swnBBvogdm460rMwwOzAXLpBYZzWcjs+5QLVNn5lTyHQrNwcLAztshp1C29VTIm+xmamP7sGgU62vMNtL2w+oizqqPy1zgQKw==
Received: from CH0PR13CA0007.namprd13.prod.outlook.com (2603:10b6:610:b1::12)
 by DM4PR12MB7600.namprd12.prod.outlook.com (2603:10b6:8:108::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 09:27:25 +0000
Received: from CH1PEPF0000A34A.namprd04.prod.outlook.com
 (2603:10b6:610:b1:cafe::6e) by CH0PR13CA0007.outlook.office365.com
 (2603:10b6:610:b1::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.11 via Frontend Transport; Mon,
 10 Aug 2026 09:27:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH1PEPF0000A34A.mail.protection.outlook.com (10.167.244.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Mon, 10 Aug 2026 09:27:24 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 10 Aug
 2026 02:27:09 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 10 Aug 2026 02:27:01 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 10 Aug 2026 02:26:53 -0700
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
Subject: [PATCH net-next V2 1/5] net/mlx5: HWS, Print more details for bad completion
Date: Mon, 10 Aug 2026 12:26:26 +0300
Message-ID: <20260810092630.3137666-2-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A34A:EE_|DM4PR12MB7600:EE_
X-MS-Office365-Filtering-Correlation-Id: f6212169-0d0d-4ed3-825e-08def6c1966b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|82310400026|36860700016|1800799024|6133799003|18002099003|22082099003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	YFMEs3D//2LA5pKDRilxaGZW6a4CSYqdJakZ7V5Igt4fo21HWC98MqzyGYxAMtD2+ktTvJAGQ5hBkh3rqWG1lug4q7eP4beMZgYJE4Alzu2Clsy1hKQg2Vo1PkmrDm+mG+6hkEGH9EgX81MipvLpCWcKTP6SyTKuRAXGqG3G+xf/tyAFBhu8cQB+GCURMhEGTPf+0BQlWww9diS2sAZxLaRwvnWU767U0ZkmrAsrJF1kO9ocLr3NvIc5+jN/6FUTH/TJhUNPiI4AiDYswSVCqHWNRjXOTjwEBd5xUmgIOkCTHfsVL9J/GTEdQmvtqqv9W5R4PEE5H1FPzgOThjj68seL3ldoKiE68RFezWSDnmRXXFZstlbAF1hkgiCDU8mx9taz2+AbBmVm92BAQ1VwWIsRxv42B9N7/zyYQwUHvirUXqgFdsCuKZyyFaFmfFvwWnMobVbrzd8QTSTM0FbaM2WW6GJ/OnKpSFOr2bTi7e4hUulQ3+e1PAQ3s/wJ1ycH374J9F7HBjNSfWlQqPhaP79HCUJcRrL3iZHSjZTHDATlRCIqSpJf3xxSemLBDO7weP2tswYQndTN6k/C23hwNSxQQ89d++d8y/Ii45LZ2RrUyeWiBK6j99dDirau4WYyqcaAh04jXalJEhcWXc6n0RYcOgN6fqssbryiz7qKrLmcZdL4V9IfVZNbFlDdNkAWP51h144kQATroGN2yRm6Fw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(82310400026)(36860700016)(1800799024)(6133799003)(18002099003)(22082099003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	RFlVfaA1woZCwpuKklradZ/h1M2/LJ3/zg1p6oImP+uCjmKxe68QRhcNPDEZjhC5NjpD7V8QlC/K5oJJeoV+XZHmhZ1Ewub7HSwkzrPDsxS9XV0QX0YkSquWHoZarrqmyTLv5dk2owucJWayrtvYvF5nYVAIO7/MLRHeUsL474LSCjXzG0vSpr4/6XDFsylJ3wKMg7dzEO7Jwe5n9uqX3il5tlHmOD7ZPy4vNljaXzS7UmNVqz/NJhc0hg/S5atEBFuEPHu1Pv5YPRbNfdLtZSGGHkCOD5cOXyHH9GPIKx1Kqd2ylDf7//Dk0IFnGtFOXt595ejKuomzhPImBs3XF9BwxNTMg0XlOl03f1o2xYDJqcoHxVddOlgO1qkG8120XZaAk6OOOJuw3OyG20JbCseyrU1hX0np0pcAHNbZamWao8RgiVcrMFFJLRNN5Kho
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2026 09:27:24.4521
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6212169-0d0d-4ed3-825e-08def6c1966b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A34A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7600

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

When polling for completion returned completion with error,
parse some more details: QP number and WQE count.
Also, extract all the long value-to-string if conditions
to a short value-to-string functions: do it for rule
resize state, rule status, and syndrome.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/steering/hws/send.c    | 68 +++++++++++++------
 1 file changed, 49 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
index aed009aec4fe..1c9206f74aaa 100644
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
 
@@ -423,6 +445,15 @@ static void hws_send_engine_dump_error_cqe(struct mlx5hws_send_engine *queue,
 			    "    rule 0x%08llx:  |--- syndrome = 0x%x\n",
 			    HWS_PTR_TO_ID(rule),
 			    err_cqe->syndrome);
+		mlx5hws_err(ctx,
+			    "    rule 0x%08llx:  |--- QPN = 0x%x\n",
+			    HWS_PTR_TO_ID(rule),
+			    be32_to_cpu(err_cqe->s_wqe_opcode_qpn) &
+					0xffffff);
+		mlx5hws_err(ctx,
+			    "    rule 0x%08llx:  |--- WQE_CNT = 0x%04x\n",
+			    HWS_PTR_TO_ID(rule),
+			    (u32)be16_to_cpu(err_cqe->wqe_counter));
 	}
 
 	mlx5hws_err(ctx,
@@ -433,13 +464,12 @@ static void hws_send_engine_dump_error_cqe(struct mlx5hws_send_engine *queue,
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

