Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011060.outbound.protection.outlook.com [52.101.52.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2887403E88;
	Mon,  5 Oct 2026 08:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791189685; cv=fail; b=a1V8YTvhCgrqzsi0oZWzz0qxeRc7tfgxcxr1+9XPcWpcl7XN2ffDsB/jScoQZOKRnHPKPsHCrYmMdKACWM25PlDRsN5r6e6HkVXpHrkyG0Y5kRSAhivLUbyzJN7RwTUIJ7iMEu0y/lNfcn+ehuwIITpRDZL4rkmTuUcJyg34trs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791189685; c=relaxed/simple;
	bh=aEbMv9UFJ5gqiZerX/2v3k6UvDH7VPl9W9fZ+hiNqWA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nJ78tx8cd5RG21VRn+7aGfIENQsguanZ1FLqWfxdH8C1UTvVjzTMobK8E3HHPmseuAp+JnMP/JMfIdmYCQBBiKBUehGGaw9Nv+mLleHBgj5Dv5yJbJ3o6OKCvP/LYQbFyUjnKyGJlxFbWckJwsEVwBOX5qUcz6XdGzsqszCzVa4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iBbkeAk+; arc=fail smtp.client-ip=52.101.52.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iBbkeAk+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZU19n//SlVo9rQvqxDzyMP8yjktEk3VQamXL7INItudfDDLv41nqxMfNr9FePbPqx5NK2r0f15Qyg7tPGrI2Y0GlDa7SCyB1LAmgRyPVg9d7pYgBbmuzn5CFl5eA+8OO97tawBLh/3xy2vYf2tvrhAXWYhrp1EiA9jRQ5FvZFKK3AIHTwKpsKxaqgdrb8Ou9HpHEMyqzGSiypWpNub5S41wgjSgnjyWpm3wYHMVayiTAWhvfCvLB2gL/aubGUhQo/yqQ5eEU+3f+BEq+qHrSZt5gucmY+1/t/X6Hyf1O+MiwyTNeY6mTgRIPLeUZuXt0U4Frb/W7jmxyBqjgUkk3Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4BJaNwrRRhL0yRBab+3fcRt0wlp0ZIZs4F7dNLAlp5g=;
 b=tgm6adzURcCk40D8/3mnU3OfMJk8wEEqOi4odDl/NxdVyTIqauhFySz4u+cmTBk1yr1MFp6VjA7t4ChssNNQ3TP52I5GDOJQeprWhIT2dSXBa1zGJTArlR3TH4Jey76oG6JngBfOAJ7JxCPnbkQ5SnTghOo/v+qJ4dpeGDwDtnQSnBRPks1wnP6xGpSEHRI7ukB4JbnUb1x4DTTOW19VIFJI3xmXQpCSg2VOxifpGy7XziDmXkO9yZu1/N5f3ykhvaNr0O/PMWYIO3umz9aEaPlaML1bp2x2n+bYPJET6AwvLTWQUA3IZxPgtPdACf2UBPiVvY7dDhqo5PH0/1waVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4BJaNwrRRhL0yRBab+3fcRt0wlp0ZIZs4F7dNLAlp5g=;
 b=iBbkeAk+jxODDSLomxNWBdujwjrTWcZ7JrPuAlFu61tyoNcDMx2cWgHCHIyAO4ehhblQZhAHCJbMTXarEoKFULiIi16leDVCHfMXlT4GyiqY/0tKHZrwiyQcoib7a+v68h8XxsJvddVMfjS//zCUiCrdT2O3eZBh3zrb5AxbaJlUrwr/5J6K0df/61wabaG3BjuHOnZAZAT4p/ksewiaM/AMCFkAH3RCgCtyFn6+3DUn8toGT8DMFkCWiw0FM9Q9vO0nLFbMT/dksGveg1cUF5bcicWm5ReiEO0s7QbrtZsIqLhwZOteNTYx+6ub9onLrdlWLIaMY6KSlU/LdBfYCg==
Received: from SJ2PR07CA0018.namprd07.prod.outlook.com (2603:10b6:a03:505::22)
 by PHXPR12MB999233.namprd12.prod.outlook.com (2603:10b6:510:3cd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Mon, 5 Oct
 2026 08:41:19 +0000
Received: from BY1PEPF0001AE19.namprd04.prod.outlook.com
 (2603:10b6:a03:505:cafe::25) by SJ2PR07CA0018.outlook.office365.com
 (2603:10b6:a03:505::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Mon, 5
 Oct 2026 08:41:19 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BY1PEPF0001AE19.mail.protection.outlook.com (10.167.242.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Mon, 5 Oct 2026 08:41:19 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Mon, 5 Oct
 2026 01:41:07 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Mon, 5 Oct
 2026 01:41:07 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Mon, 5 Oct
 2026 01:41:03 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, <linux-rdma@vger.kernel.org>, "Mark
 Bloch" <mbloch@nvidia.com>, <netdev@vger.kernel.org>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
CC: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Gal Pressman
	<gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, Moshe Shemesh <moshe@nvidia.com>, Nimrod Oren
	<noren@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Paolo Abeni
	<pabeni@redhat.com>, Shay Drory <shayd@nvidia.com>
Subject: [PATCH mlx5-next 1/2] net/mlx5: Add cap_tx_speed and effective_tx_speed support to IFC
Date: Mon, 5 Oct 2026 11:40:46 +0300
Message-ID: <20261005084047.237081-2-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261005084047.237081-1-tariqt@nvidia.com>
References: <20261005084047.237081-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE19:EE_|PHXPR12MB999233:EE_
X-MS-Office365-Filtering-Correlation-Id: ed37af77-b365-47a5-bcc7-08df22bc6d69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|82310400026|1800799024|36860700016|6133799003|22082099003|18002099003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	6MzPeVPOI7S8xd3sUnip+81nKkMGxt4bZnNx5W5ypswzhrxH0M8fdZ9443L0RWCh80I0yc0ZGOR56lwVjz3Am3FmRFABgg+ZnXeyGC/TrytEBpxaa1fTX+ie/EjMTxKkb0FUpuLIAr0z13SNza75PG8l/ScA41qAoo7s9zsrE6GpNf9HwotJzHqPMAPd8wlJoB/5E4oBU8NDm1sSJL9vy1rTFW1TaVATmKAqsjj6PtbBN9PyV1blpRMnZMAtCYNOOM0lBRj1WK+dCpjB4TBh7cTGdqoLfsj9U3BPEJlS2vVBj9qBdJDo6wqIcspaGCjkZEcchySfQ+SmEnyL9a1vCgx0qdd9XT3Q19gqSPKzXVwbvRVjj8yvntzmui9GiqM7bTIQEHvECdU/mdzSRzHY1+74CbTVkmFv9HUJB6JFIVL6k15iPaN1SeHqQOpOvFL2d2X75diGls84I32m4DWFObqkBpwsfW0enjE7EVRA6eJG95QJPC7SuhNaXrlt1TLllCsmWkKHmW8BE4kScAhnAxNBBX79VADtqxVoXWM9zxSgfc0M3hZecBv/nDSj5aML0sF0vQRIrit75MGiyKjy+WjrXsq06zM/xrU/trv/qHY20lgLeav6+5B8OdzkmsWAm9idUoA1+SOk/1I1gGzLb7ZPGOE5YJ5fbUw4v0A3dDGTHjwalq+p/E15/jTfHBTy+Xy4GT5QFSWPyXGWLYFKFA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(82310400026)(1800799024)(36860700016)(6133799003)(22082099003)(18002099003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zjw1FO4LuDKXjFMoaaA+QuSG3wE9EQE58oYIlPBXCDlnqYd8hhKYxaG4LhPwB7rb48P5yJOHz58ArUgRjOSWTD2428cJrORWQSkgp8qjEdveYMtW4qqoX6PlRlIEPAoRGAfPayYEyb2HYNYfhQ5psHPGduzhxV2MEQW8GZ5w9am7d2cXIYlEYQsG3TR3Xo3Np292ex/l0IaXK8HMTSZw1YFtyiZlcNFYpXmNmu46IGmg9P/VyI1FOI4ZyIfk4HvvWeVQ6bnpXp3ZPat6wDhBdhht1r4BWkP6JikUxKYs5wx+YfnQBuzQzv21Uz5M3LIpiFOXWW0T6XrZYyjh7Uwxa+bQKbmAy2QW3YKcrxKz84LpXxRCwa8W5WDSAdWUcrK4evDhWTmeCBYejY3AwoA0wPTsM6UHarXqBxOAJCf9RPCwEYdu6PN8ZKne1voPhvBD
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 08:41:19.4375
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed37af77-b365-47a5-bcc7-08df22bc6d69
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE19.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PHXPR12MB999233

From: Or Har-Toov <ohartoov@nvidia.com>

Introduce the cap_tx_speed and effective_tx_speed fields to the query
and modify_vport_state structures.

Add the esw_vport_state_cap_tx_speed and
esw_vport_state_effective_tx_speed capability bits, indicating the
firmware supports modifying the cap_tx_speed and effective_tx_speed
fields, via the MODIFY_VPORT_STATE command.

Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Nimrod Oren <noren@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index a712463e89b4..989408764e1b 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1070,7 +1070,9 @@ struct mlx5_ifc_e_switch_cap_bits {
 	u8         root_ft_on_other_esw[0x1];
 	u8         reserved_at_a[0x1];
 	u8         esw_vport_state_max_tx_speed[0x1];
-	u8         reserved_at_c[0xd];
+	u8         esw_vport_state_cap_tx_speed[0x1];
+	u8         esw_vport_state_effective_tx_speed[0x1];
+	u8         reserved_at_e[0xb];
 	u8         esw_functions_changed[0x1];
 	u8         reserved_at_1a[0x1];
 	u8         ecpf_vport_exists[0x1];
@@ -5492,6 +5494,9 @@ struct mlx5_ifc_query_vport_state_out_bits {
 	u8         reserved_at_70[0x8];
 	u8         admin_state[0x4];
 	u8         state[0x4];
+
+	u8         cap_tx_speed[0x10];
+	u8         effective_tx_speed[0x10];
 };
 
 struct mlx5_ifc_array1024_auto_bits {
@@ -7840,6 +7845,9 @@ struct mlx5_ifc_modify_vport_state_in_bits {
 	u8         reserved_at_74[0x4];
 	u8         admin_state[0x4];
 	u8         reserved_at_7c[0x4];
+
+	u8         cap_tx_speed[0x10];
+	u8         effective_tx_speed[0x10];
 };
 
 struct mlx5_ifc_modify_tis_out_bits {
-- 
2.44.0

