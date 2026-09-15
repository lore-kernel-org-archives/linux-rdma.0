Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010021.outbound.protection.outlook.com [52.101.193.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8C049502D;
	Tue, 15 Sep 2026 11:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789471217; cv=fail; b=SO3IK4MmbJ7U8xtf4Vp55cZhjrczX9bdTI9ylUy2E+8D3NfsyDrO1uCktg1soUWPxRsiI5QFIlkflVrw1LMuTDOLaPbClL1XL2ZwZtk353HAiBBg70P5ND71yRDzUv52muobrJdPZXLKK4XyjtVYs+SxAu55tV9e0RLyf2dtpBY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789471217; c=relaxed/simple;
	bh=gg1yEEvcr3PTiiAdwPPu//pdvZyfVfBpxL4mA8kTks8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pVKKLhizXwOKdrpobDEHp7AUw2DxNqDU9wYu8Gm/9hAvgrljrIWtKOCXyaOyN91XjIEqjUuWTkNXu6tEO92wpJAgojEtZy+WopAYAT79ovsGXJlrBbX+TIrOOW5j5fpqtEc6vCbo7eLREI5tIAm/Nwm6bpKMqtS9orSB82EYeI4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YaZQYtRT; arc=fail smtp.client-ip=52.101.193.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YaZQYtRT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cfo/85e7sBUM2Uzc7qtfMymnB0tLmrhIrauHCXI8Sybef3TAzrZTXlG2U/Q/vwg6gRdv4HUfIbCtcFpKb5FAaGFbuIj0whddbndFhXS8s+bE/LiEGmbBp+/rdHwbgG1E2h3Zxo/6mw+ahnJj2M1WAkeFBdrWqNdAoQF4XOLe9CRPR3yFfsMH4r0659Ryp7ymnxfOEnyt8R8F2VfLD1bps4CXOcLYNkFixtctx6PSteFPVWrcVfMYYv+Mw+u40QQiQNNjw81JlvQVV1V2DDboe4SZX/H0thV00XQ87Z6ZErdiVSHB5JEm8/omUWvQEj2Aiig2cTtyoQnICJ7ombHdlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JzPllBcsW+JCwTm6NHh0cMdyS6rhUDpPf8tkA4881l0=;
 b=Gpk95niQqj5EGelMMWLq6OtFMy31r70Q+n0B+RtN5k+DE1kXlYP6p7pSBfZ4OanvHIEW/x3knlWoGjtwQ0i9NOOA8a9mBAz7g2le3cDRdLaD1+Ul5LEqqyGfohMoSfC8Gz/5HpA43n/8afI8m2QztiSiokI+1nog/ua7yBEEjpnIkGVo47RZKvY0itZEvx0iOKoH3UpN8UV3WPoxzT3fibYyepcEbF7eDvEXwN+DextqNiCPd0gDdOc6WZ2RkZfRXFj45jaEbwtcE2npiiAxggT/yYu3m011nfubU0lgmpEvP5LC0W3nGFBHiG4s4ysrbnAoN0YG/6sES6V7UJW1ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JzPllBcsW+JCwTm6NHh0cMdyS6rhUDpPf8tkA4881l0=;
 b=YaZQYtRTAF0xsHuZabnXfUKf98QOQjYIQbxvGDccaiZkBCDVkdjFiA7H09IpZEZgHNfUDvj2COMxG3Cv/mr5+VDtb6in6goOKsz2HSrYw+EZvhz2EbxEcXC48dBPN2LBUP0mgTRisstO3goz3l7EN4iYSoegvC8NxSQvyce64eHPDH9a+vnlBovx/uliGs72P4VU+tbDeqhMxpM/NXdyVwnZsqWGBoSYAWb4j6l+GSv0Fk/Din4CZNud8rWh+l6ggfW+J4bw7hBhfc0Jrlus42kCpkvVuk8ZLNH4yuPWALY8JLF4Tj7l1m4F0uVyD9y3GInYuWAgHhpMhDCU8p6lcw==
Received: from BN0PR04CA0140.namprd04.prod.outlook.com (2603:10b6:408:ed::25)
 by BL3PR12MB6619.namprd12.prod.outlook.com (2603:10b6:208:38e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 11:20:10 +0000
Received: from BN3PEPF00022BBA.namprd04.prod.outlook.com
 (2603:10b6:408:ed:cafe::8b) by BN0PR04CA0140.outlook.office365.com
 (2603:10b6:408:ed::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Tue, 15
 Sep 2026 11:20:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN3PEPF00022BBA.mail.protection.outlook.com (10.167.248.116) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 11:20:10 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 04:19:49 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 15 Sep 2026 04:19:49 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.46 via Frontend
 Transport; Tue, 15 Sep 2026 04:19:45 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Erez Shitrit <erezsh@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Yevgeny Kliteynik
	<kliteyn@nvidia.com>
Subject: [PATCH net-next 5/6] net/mlx5: HWS, Handle timeout draining the send queue for FW STEs
Date: Tue, 15 Sep 2026 14:19:11 +0300
Message-ID: <20260915111912.3926585-6-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260915111912.3926585-1-tariqt@nvidia.com>
References: <20260915111912.3926585-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BBA:EE_|BL3PR12MB6619:EE_
X-MS-Office365-Filtering-Correlation-Id: b217407c-9596-40d8-ac7e-08df131b4dfd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|23010399003|36860700016|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	MyPPSNm3FuHmZQKJG/7eS6I1fETyQrXzwRz9B+U5K/CKly0GgaEY7+ncRi/+29e9ELpLJY6p3GLQaPF0RHBpLAJEXOAuN5dtRBL6XqC+6NQHHAWP714B+iq1LJvKlrcpH6BLOtMDV/RWHlWMwSBnvSqEOIMGbzD7kCfbFoTaX7amPcvpe9P4yffjyT7Z/GnpoKRJDXAyFVC5wj3RwXQOFo713NML0WFm+ICk4UJSZRhl2UO21JcIbtnKBeU53PmD3ter1fnpgeGy8PMn4sZvygCftuLh6+WEiDEymtu407uTn6CEnF2uNb18fKmrqsCG+s4kMPAFheq0Bibeipyu1NQexSWJCl1kAG1mKn83ki9Eg4qpuDhOHhBbIi8ApNxnJZLZCX7GY6WXhxWumarAjNFKsv/cQmb+R8ktOvw2QzN21INsG2tAbqbLjkifVFkKlNpwsK3QYohKvVVVdX9068AivujADoUBJN7K19Zwc50KkhYp4NEoECcB35QkhvvQVdfDZNNGC5awu+sFwjWnDzHjzwmCbNKx/nrvn2NzxJridGtQJXn8REcn+5ae7I4GI6Fq5bYfysacq1E6ExJURFsaV9jjJjWi0uAGT5STJSIEwHBUppxB475786JkahBm6RYwg/5PemVfC+xSscBkgVsF1IPHeT0Yf+fBB+aLe8iEfoPGodWRmc8o4/yWUW2Nax0zhooyJlyK01K1TU+j8w==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(23010399003)(36860700016)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ni4WCNTFbwqJq7jOPjBBkB4ysCLYZrTbU9DeDmGvZjTNh5o++HZbMIw6RKtZ7xNC2L5LJq9z0Z4k5BUMxi3CuTLbaEcGsYWyFqks896x6g12QuHL6n+ydUbJQHjoR6axN56Qq1iPoPD7kdqyipiGRd5V2AemOCAoqiWTYOWnn4tas/FvC/AlhmVsp9b+r73lDHiWWos8YyMn7xhzotMDmuJ4BjDSGQvdEWzAWugIxnhkXNSOGTzOGSynE7tP7mTkQmv4FIFLIe7IyWGwm+v0TC4sEmcpyBUnOEQoK15aO3XLgavNQ+tNj4gsvFli4TGnEiqDY9gTu09gr2JuHMcUkIfIu7Zh28p8G3vxlOAxTd13zwPUUqpBY9X1OSJgyJi5UjN05eSGmbMthrOSKDrsl22oiGwQAHdQJRwwmA91qsbStYpFyiByopl0mahBXL9N
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 11:20:10.1339
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b217407c-9596-40d8-ac7e-08df131b4dfd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BBA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6619

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Handle a case in mlx5hws_send_stes_fw where
draining a queue fails with timeout.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/steering/hws/send.c  | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
index 9ff109fc8230..bddac018b44b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
@@ -1335,10 +1335,14 @@ void mlx5hws_send_stes_fw(struct mlx5hws_context *ctx,
 	pdn = ctx->pd_num;
 
 	/* Writing through FW can't HW fence, therefore we drain the queue */
-	if (send_attr->fence)
-		mlx5hws_send_queue_action(ctx,
-					  queue_id,
-					  MLX5HWS_SEND_QUEUE_ACTION_DRAIN_SYNC);
+	if (send_attr->fence) {
+		enum mlx5hws_send_queue_actions drain =
+			MLX5HWS_SEND_QUEUE_ACTION_DRAIN_SYNC;
+
+		ret = mlx5hws_send_queue_action(ctx, queue_id, drain);
+		if (ret)
+			goto fail_rule;
+	}
 
 	if (ste_attr->rtc_1) {
 		send_attr->id = ste_attr->rtc_1;
-- 
2.44.0

