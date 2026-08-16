Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010039.outbound.protection.outlook.com [52.101.85.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE0633E36A;
	Sun, 16 Aug 2026 14:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786890094; cv=fail; b=r+dmnxcGQHrT5p3/tJWclfXRt2sRPOJg0TDCLppW6i8H1zYVYKXp8tUBR549g/rhbUdskeHRO2l8UOa3bopujHkC0rWXTkCQy4pkUUfm0iVcgdW4qR7gFs7IuB9o8WGnVBU64veTGKcHsqEgp+YDHyJVHt5B63DzDiUAMGMLS0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786890094; c=relaxed/simple;
	bh=0m8mCVS+W6tXKvqCGJc5a6INAggMb6XXEK/0w5v29z8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QCIBwBivHQi0VYwO2ogKGGpoy9DNRDLjpLLAa1SGLOl0iwqwvlZ6GQZGLkSUBxC5uBgQeNs8MtViKaLxKBiyChxTrTtpW+Lia3HWx5lcu4VDLE+EQx55baZnLplsyD2dLQd703bWPm9NxBT5SbK22H8OCc0Gc5UN/SKCRySWoD4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=odslr2C+; arc=fail smtp.client-ip=52.101.85.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="odslr2C+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sn2zrQ5h+L69fGezy9rG/cEU441wBFEqym8BI9pLJQ0WBOD+kuevh46rRObAR4HWhoaTmtUEWxI3IkIHwUIB15qoNQ2hEjaTxMwfnllwLzwbwcXQem8jyyg2AlzhIlDmb/Z8WuG2VglX1y50+gZcLHmRNxKPglkr7PKJivQ/4Hcw0jDXOt9SWoHth2IqNtSzjBrhC+vNLZ0BkpvIVbp4PeZuI7iq7M+bCekkfmDqCepr4/FrCGdf0yyqv0ASzDlRFcOREhRAlx+2uz/Wv1HfeQajOgtlAte4JnbNquFaQGLUy1toM+RQnO0CY4/+xKAWc3Yz+Y0iNsyex/3yJIbqsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QMwqRO2GT1S34YUWsQdcgV++iivfvLQglnsQWEcU1Ss=;
 b=aeL6fEJE7k+OfsGD/uq07DWdHGJxlFReiETrbHO7bzymH3B1yvlMg1GdIBiOTot/X8MivtONr89xZ5+LcX7XPf38WVSlVhaGmQdHlKHyZ6JNqr4EvSEVwkk4jMGD9FRCEPTriojfBPYeOcfB9CEz1dV/VGsXGIh+bPjUnOSKsOrPxsljk/JMSl1hQ01BW909Oac/8qCLDXpvOPOTPnld/WZGNzGzQYUzvo/pxwCESxPnEmrmpE7I6K/IdvZuW6311iccnwKD6fwp8tAC4re4ZqgjcLBuA/BX1XSEmIrA/u3BQBpTH+FtDmHpvD67+BHMS/xlVOIH6nK4HF3Y+ufcLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMwqRO2GT1S34YUWsQdcgV++iivfvLQglnsQWEcU1Ss=;
 b=odslr2C+jZT0W96a9U08LhylDaRITmG3+M6aR8Ag7uZN52VIpxFIBVCzqwVMkcgqFQMoZCmTJN7c+X58apSVJq2gYeo0F4EMJlGJp6OoIw9qFNLs0HFC+1eykygxTeSP90CcgD4b09tGdYj9jGfrWDApYv/L9HIBAn3LGIdqmnqq+cMrh7R+u5wO9d/os6abCqsnWX1AgG2sMDsKpD7dttnNzaQJiBgPLfOtiim9M2vw5DVE9cx0Dox354BO9HhQIQDeFU/HXmYvtkRIAwzHesQ4Vjfv77oyQ6oI8LQTTorgVwCz3c7c/P3splm3vxENaxnQFCiVeq7GTtWk9AkTig==
Received: from DS7PR03CA0133.namprd03.prod.outlook.com (2603:10b6:5:3b4::18)
 by SA1PR12MB6948.namprd12.prod.outlook.com (2603:10b6:806:24f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.12; Sun, 16 Aug
 2026 14:21:29 +0000
Received: from DS1PEPF00017091.namprd03.prod.outlook.com
 (2603:10b6:5:3b4:cafe::64) by DS7PR03CA0133.outlook.office365.com
 (2603:10b6:5:3b4::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.17 via Frontend Transport; Sun,
 16 Aug 2026 14:21:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF00017091.mail.protection.outlook.com (10.167.17.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.3 via Frontend Transport; Sun, 16 Aug 2026 14:21:28 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Sun, 16 Aug
 2026 07:21:18 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Sun, 16 Aug
 2026 07:21:17 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Sun, 16
 Aug 2026 07:21:11 -0700
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
Subject: [PATCH net-next V3 2/5] net/mlx5: HWS, Log syndrome on STC modify failure
Date: Sun, 16 Aug 2026 17:20:42 +0300
Message-ID: <20260816142045.3289452-3-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017091:EE_|SA1PR12MB6948:EE_
X-MS-Office365-Filtering-Correlation-Id: b32174bc-bdbf-4a8e-5295-08defba1a9ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|36860700016|82310400026|3023799007|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Ye229HOhLM0sefPawYXL03Lym67UNALga2pyFvfwjKVgztpziNXpQA3IyFDb+iWA7vAT3hPvjAxYfdokO3FGrOW7Vs/yK5B1aAYhzzyjrGDeyJMcM32tXXCun1oi5fRPpsRrtSC2mVvw4FpWolr0V6RbeReE9051LIXOAnsxtQhEuhy82hRtA0c55i55sz92am2w1sJKVZWeAn6xDWbA7s0SizOovkdriwMEIjDOyLpRTJvil4on8jAWJ24ls1qODieD5OqSW/4gPR/+/sBNLdaj/bpWLlGQ0GpGwphFnAbTHZ9jC12qYmZ1+g5nSoFDxtH6BoZ5cMyLDL8AKh0SC2oYqoUXyMhvhypjOUiVFgZcrEZ6p0NvyStOlnlb98nXr4f1nZEEmK9JnM4ESill6E5XFWqUZBr+JQjD6wFAKe5cT/4a734K+Wi++zGGjTyQECnWTQNWci7ZkTo81WFLmqE4PDjoJYPn2Gc+m0nh517ZgM3w1dLapxNgKUG4reGTE9lYkyvYoxoh7+q7LWT0YC+ZsGfrqIQ+Tu+w7INZc4kbwSgE8o8C8L81eAPKeutmurdZ7UkNIGl2fUf87jUv/BnActuZZolczXR/VKKOYgOe7/4NmnArrf8fqOQcXtzMvuFQd1G6AfC2Hltukvu2LWEJaq4KftbShnjQ5cBbN+gphBNBaFufiqgVPjGq2dXQRNOOmNNY5c6AH0S+obMVow==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(36860700016)(82310400026)(3023799007)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	i6ByCRruZGhSg5VGXu88XWXRALnGBgJjOXVWB/samTk65ziorc4PoxfcPgWVSZiaLt4spYdjn94frtY+9EhhKnm78FllCjIHE58XXE/341ASvth3e3rG66HPE0VZ/cmID1zBpDXglB3Rt4KhoPxbGX4Hi5brQtGAoKwHF0SW2elDz2qPHLNq+GGwWtDmYDxFVTOEMZpTuyLc261UiofLEqaj/Ca/xiqJTJZm4h7DyvRiKiYz+qpACOrjyukXbJFyZ+l5I2HSDL4bsV+ksZGsWcfZWcOOZd7lpLBpevfYKCkFps+/sFLN3FNgQ59RiRXJbW+yQAMQQqSm/fCLBsGW2qRP8lu5PJuBIkSIrqH+BuICmqILz3bwaVOGTDHtyi1wNZgsUlZaSla+0MltnZN09PAfycmxgNZE2aqp+C0NWKbsWIiMD41lmetOs0YxcETu
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2026 14:21:28.6536
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b32174bc-bdbf-4a8e-5295-08defba1a9ac
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017091.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6948

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

When mlx5_cmd_exec fails for STC modify, include the command syndrome
from the output buffer in the error message to aid debugging.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c    | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c
index 8fae90101653..2cdc03421433 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c
@@ -611,9 +611,11 @@ int mlx5hws_cmd_stc_modify(struct mlx5_core_dev *mdev,
 
 	ret = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 	if (ret)
-		mlx5_core_err(mdev, "Failed to modify STC FW action_type %d\n",
-			      stc_attr->action_type);
-
+		mlx5_core_err(mdev,
+			      "Failed to modify STC action_type %d, err %d, syndrome 0x%x\n",
+			      stc_attr->action_type, ret,
+			      MLX5_GET(general_obj_out_cmd_hdr,
+				       out, syndrome));
 	return ret;
 }
 
-- 
2.44.0

