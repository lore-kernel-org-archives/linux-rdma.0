Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011006.outbound.protection.outlook.com [40.93.194.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6724918D636;
	Thu, 23 Jul 2026 09:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784800484; cv=fail; b=MS311cIUO7+Lb8f72sTOWpzwvjcWYwaNGudE4A9QsB8k7SIgbPgBnekV0T+3h9NUg+m+WOcSPulhZGCNr+5KQTWrJ11TfQBxMi4joUlcAYgT23Agp6lA8b7YdlRcJLEW4fyO4HbAbXIlpqK7Ke0/b9pd6vj8xfWaMUdkO6ol/hM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784800484; c=relaxed/simple;
	bh=wPHsImfmtEe41G8iyeWq143SZFiEQhcc08P2sxjKJVI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lLd/wWRKIdbCbqgeD3t9PhZzYWD2yYOZ4QnF7tKw4dt+2kDjGCHamNG9A/ksiQXqFDbGYFccEN40Uo3hhqgbMa6d+g9dM7MDlr8tpnTXHSeoG+WDgk4fK2f6w0vSXmTQXf75OhC7nCr/gcbt1eptvcoDryC+1EhLES0W3SODcb0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=A0genaw+; arc=fail smtp.client-ip=40.93.194.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="A0genaw+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RdSovaRusZtP2cdp4Vd0atTSOvev9CTQRtPUoN9x1E3wpRal2x4CKQZXX5tB0PD0ywsQLkgZtlqNL38KFipmtDWNNWrHNnhAJ8bRBY39tRX2ovyxYOofY4tatZaan1MIKVB5nvvKIRE7D20p8L4k45FyARPIEwbbZXSXU1r+/vehlSZeW9SWEqpPNhRih82b9POYjU9dhoHiDZztVVmCIpQYgGkIzZsGaZZWDnAN8TS1zrxY01zRl0gwIZN9CRo/IaXhUiujaXYFs/VROVLqErtmI/boUUMTc0uWlGFHV7Wi88jL6lOQ268f0FYAJk6MV74N4zllbvtqaGLoSj8eSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WSaw6JxYXlPvpCrOt8rsSiZl3OVFFOfODDtMpbqYFl4=;
 b=Ff0nm+R7l7qiO/7AaRpZXcUfQmDEuZtkAS7rJUlBgccbpG3IKN1HXWupvUkD+JFZCTPsrBlHUNiJsevFUUr9RuiRFI743oNjfYWNKVRUWjh29/rA/jadsDo0m63PR476JYVtmvQ+yl/b4fcl7SNOAwTZzQDOJiCjyyE6xbGjXeVequq2LNAx74w9EGdlJLPR5VaSclxDmgMF3R3g26GVxef8GnL4Hxs0ejLZSG2bJ/v2ruxXPd2GZw/bpF6995bDx9HOCt/Pfzxz/6xkndkWt5jnhw2Kuqsne2WlPJpq2OwDdO1E6anMQgjTy8WT7ptawNDLhDJjtaJqsAjDIcxIcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WSaw6JxYXlPvpCrOt8rsSiZl3OVFFOfODDtMpbqYFl4=;
 b=A0genaw+wuAuIEHAhqV2Lk0Baw8nu42wNvbAR4/dT6VfOQ+edVyGrdkQolo6vxFMvzl1uAHua3npMr/XyDZvVoQxucHNWR+bnWu06LBkBbmY5u+WItPqCtKsdmarwIsa4psJMSdanVFvm55xJ5Suj0ClhElvDdiR63Z1GqLVkLosnymOREOsfS7VhFGx4vROxABzjNpY3RVTlo36D2njJLPvLb2zx7+U+fWimwJgTyeV5u51hIkbqyInmAi4qQ0PIXn8o5j3grhnYXKPrDOawYbZMxYdpSTDggk305bMn/xlFDylhDcaGM6uXIvXHtgHR02awKsfwNFxTLIezvxS0A==
Received: from MN0P221CA0009.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:52a::27)
 by CHAPR12MB999250.namprd12.prod.outlook.com (2603:10b6:610:300::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 09:54:37 +0000
Received: from BL6PEPF00022573.namprd02.prod.outlook.com
 (2603:10b6:208:52a:cafe::5f) by MN0P221CA0009.outlook.office365.com
 (2603:10b6:208:52a::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Thu,
 23 Jul 2026 09:54:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF00022573.mail.protection.outlook.com (10.167.249.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Thu, 23 Jul 2026 09:54:36 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 23 Jul
 2026 02:54:21 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 23 Jul
 2026 02:54:20 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 23
 Jul 2026 02:54:14 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Akiva Goldberger <agoldberger@nvidia.com>, Alexei Lazar
	<alazar@nvidia.com>, Alex Vesker <valex@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, Erez Shitrit
	<erezsh@nvidia.com>, Feng Liu <feliu@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Kees Cook <kees@kernel.org>, Leon Romanovsky
	<leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Parav Pandit <parav@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>, Vlad Dogaru <vdogaru@nvidia.com>, Yevgeny Kliteynik
	<kliteyn@nvidia.com>
Subject: [PATCH net-next 1/5] net/mlx5: HWS, Print more details for bad completion
Date: Thu, 23 Jul 2026 12:53:45 +0300
Message-ID: <20260723095349.1890983-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260723095349.1890983-1-tariqt@nvidia.com>
References: <20260723095349.1890983-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00022573:EE_|CHAPR12MB999250:EE_
X-MS-Office365-Filtering-Correlation-Id: b4083bc2-65ae-4153-b8b6-08dee8a06814
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700016|23010399003|1800799024|6133799003|22082099003|18002099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	Pa7oZGdgI03mBDktcwzp7vSCBj21iRVP4iDig0nMJk2iT1aUc/XvXgQeo/vQciOKX6IHcYyMvw0bCVbke6/LoWReiQp2mYHT9+DsJiTN6P78Z3+GK4GtNQ2nLmrSg4OF7NqvW/eIjKB9IB73wyptIqVqDcGTo4+c4D2uZnnjlFAZyJmC8s68+KM0rfP1KQSBRSjLInk7+xHKd0tDilY9VMqpL6Q5sY8zrLTxCGx6nI1uUNKPGmzLZVL8WrccAJWpY5GWLailGewL988Mermp6Vd0sdnISyaNcdjPUi57IW/HK+D7aZAZJsmq/AYT1/rQF0TxvBuIU3UPO8d6I1dWqkuPyVEbMuexPNlvu61z7YQJ50jvxafkSaSK5rM2st0wP+PEvchN9FZER4a0hv5VN57co7HLcOiAQpzcUtulywl8vwUtEVAECVgJLpMFTx/ND4VCIK9MDrQvfuTN04TQj3B82E/kfxaNtxcxXtaps4hAMslDDpiEA43Yl6vUpHpW79OJnsdW9dmFK8gGUM16y1stYKhaYJ+XK7Jk6+31fPiJIv/vB2Dbv4sscYOgRjlQqU4up4XHF8+TqlSrHLQO3m3itzNPFjuXHb/OC8RBp7taTOxa1ttaaUSwgMsy9OpArNHVbTfpAq0qSkmcy8WGsxTsC4IMuB3SzdAXXH+m3jCDfWcD/4bPbiQKsSOtNyZh+gzHgPYZIGkaeWZm1LS2Ng==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700016)(23010399003)(1800799024)(6133799003)(22082099003)(18002099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Se4haNCymQjTBzViUcOC+eedwEXzt0fHm/QktsQ5qJk6/P/XxneHUryJfYzcc7eTiiUyzPXmcb7r5O4Q5g3jPqC4dXy3Ov7M28aNFeqlx0nlFkoDd5FcB2ntsfqK0uGXJYm1a4cl10U9r7+ascViFpGz+UfXBhDYgKr0kTdb1c3cv+fPjrcrBQumLXgXuP25n/eF3vmb3yzrsO5y40GFuc00UiNTcqPW/LY74j+NY8e18nBCnes7yDsVAO7LI/jmadrM7AF3mjUtF31bOn/TkkSFdzQ5Falxd9pmsU4ekDfS0RTAPR6xz8VjacpqOgzz2Ujc+lWIKXVl4Z3SbbMrXj8q37365HpW/+Jr1iSytdmsYxkFKdRdqmqo4Zi4ruqXSYT+fJR770sMuUTFALLhIRlH5k39Nc9LKrpNCEE9HzvAWrwlhr6gsllNPH+jCyyR
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 09:54:36.9865
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b4083bc2-65ae-4153-b8b6-08dee8a06814
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022573.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CHAPR12MB999250

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

