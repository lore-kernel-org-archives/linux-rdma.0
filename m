Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010052.outbound.protection.outlook.com [40.93.198.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543243AFB03;
	Mon, 10 Aug 2026 09:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786354061; cv=fail; b=esD/atSQFpGBx7Rpaxjva9+pbMEmVn7Hfo/FfvtdwlxRgWQwWmLHiGxR8XyN/1NaHpsO5CVHSjOb8sHzXQKAKwEKOxccMqFEKcIE1fEPHtard1zaMTZQI7Adzgx6x/b184Hpmyzcac92RlsuTgYBYrL7gU5/TrDmNIwMvLdnve4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786354061; c=relaxed/simple;
	bh=/GCqifligbeh/pm5JS4f1e4WhClbttnsEWTGKyv8m7Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EOO4uheSKDRQhJkptHal+0AdjNf1b6ad6z/gipHrVqg1+Odq1OAyvWA/RANxP8YuKAUJJA3rvhwzLK9yqlSBwAEJxIPqf7fKNS7EK5YhxMS+0HGtV6D0ACU1f8qNoUaNsP0NOXVfJTC6loA9tIJiZx0F7hMZcvIkR9x4ktN28X0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZbFtM2xx; arc=fail smtp.client-ip=40.93.198.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZbFtM2xx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LT3M8vQjAnpjxOaTfk4SG/FpFps4V8VxgdDY0ye3dRkmrkDN72VMnpbSPvNGgt36LQXDSYbAA2XhfkQJ8uBVQU4sVWKa1sq/ebT4DAZM1zCbGSWV8wwEymrnAUvOITc7jdbo+UmarVYNBLuidz28y1+udjR7GY+6M5YLLT6XAH3fZb2Gyau879G3kZmJBUnVVLn8wB9CtN6mhN3n4yw4JlMhYe9ijo1gMFwKQEkZpw7o6p1Ih9WGyXcQnvtaHNLGMi4it6DYknDumv0olh7pe3PvKIFu74LIFeIh+6y5JJeUBp6Bxu9uSz4EWYMG/qnLBeIyUznjHzkBsHvOvbU0xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R2A0NGAxy8AMJNr03AXwLbFBp1YCre7sWvchJGAg7oI=;
 b=vsn8zUNeuqcvTl7MkkOGJ5hNLQbhc9opL6Ny07BW3yLnVZgpHVjxKWc4L16SpGMQ4iAqilndmqg6u1d00EKixkkXNeO6puqloVmqtWwYWpsGXDCmmDcl+BekPenSWAKMEKE/AHZmMKEkCmnI6fr36lJJsZZ0JRRPCDYyX4AOdfLwoe1JlkWGAlJVv/fcsnsY0FKl0OqHYME+t0WlHVAMXMP1Ru1Q/983xkjxRp3Cpa7474eznmUaeZk1hSDiAsecduVyrhzK8YApzgyhihdvjJabfTxhCdl95d/FyJbw5PHAxQYav9ogHrv3USaDwSOKMESu7WaPeQsh57PUuPEu6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R2A0NGAxy8AMJNr03AXwLbFBp1YCre7sWvchJGAg7oI=;
 b=ZbFtM2xxsAf1LQmHru/1USTIOE3aGf/F3FWX3i9p7d28UXinpdg3/IkQnHjstxrJOoFVs+1T65GhJgUEJiYIWYOL7c3a5yR0x3zFP4M5vBLAJcoDZIb64+qYcamCLNUCoF3LcVVMD9TpKTGD19XSHa5yfYZ/a2e1KWp+g0F/ilc9uc4zkBiu1GkyiDWy7q8kBpjefiZl41jUfMZQOkPPUVfkES92tn/RxjmhZOYS76G8eSAyeJMu/j2c92z3xy9Lo+Q3FtTrKE4pNAmsQdC+FmQRWv0WnwscdM24escoK98tr8DH6eV5jh73rUJiNwsyD1N0qykyH4Lqsq1Yxa2mlg==
Received: from BLAPR03CA0038.namprd03.prod.outlook.com (2603:10b6:208:32d::13)
 by PH0PR12MB5677.namprd12.prod.outlook.com (2603:10b6:510:14d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 09:27:34 +0000
Received: from BL02EPF00029928.namprd02.prod.outlook.com
 (2603:10b6:208:32d:cafe::5) by BLAPR03CA0038.outlook.office365.com
 (2603:10b6:208:32d::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.25 via Frontend Transport; Mon,
 10 Aug 2026 09:27:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF00029928.mail.protection.outlook.com (10.167.249.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Mon, 10 Aug 2026 09:27:33 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 10 Aug
 2026 02:27:17 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 10 Aug 2026 02:27:16 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 10 Aug 2026 02:27:09 -0700
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
Subject: [PATCH net-next V2 3/5] net/mlx5: HWS, Set the num of queues only when alloc succeeded
Date: Mon, 10 Aug 2026 12:26:28 +0300
Message-ID: <20260810092630.3137666-4-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00029928:EE_|PH0PR12MB5677:EE_
X-MS-Office365-Filtering-Correlation-Id: 57e2fa99-d4bc-44ab-a630-08def6c19c07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700016|82310400026|23010399003|1800799024|11063799006|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	I+Lw/+jxwYn9fq/b7Y1xJ5OoDSWT48cIWVImonjP43YIjTLMXbIznTbK7ojfz4WzdzRx/8PuZKPok1lbD1KzEp042qL5hxbZjvOq89f4NNBqrJ3YB6AL38XCK37C4hU05juxecDfYqCjLvQ/FdgyZGdMjr6e22prS5NrRTtC99IKtyGu6GQI9bFk/soyhqdovDFwUTfWch+E3D6AhtB3UQb8B7aTfMLROigtXVxoB18uede7BzWOaweceO2Qr8MF6rfKPEdVyfzqFkzDs4tCZaVk3FucV4LPXOJJkBGel/xdtOk9hcSHpl/F4Hdvr/AHfiXRJh7I48PXcR+9seiCMVXCwBdNZZwHsoYfQJ2lLBfYhy14JHCKqCac3wWitskIUwn3Yda+Wy5abT1llAeXS2i78Whg2XbOZE5PEvi098+RYMxnWPZ3sCiJkYxPduTK+UmvcpTMidy2EJ+gayYx9v0iIeCeOdB928xXTgbQmRFxdqc6KK9WIGngzYYqMjzarEv7PIwbJ6yLllFjiwzRKUHPw0yJwUMtbHtH6gGPbhxs3xMmkKAsuWcAbvuxhwyT1f67XW6qMd2T80Fvz2/YjW3azkwQFbLLp/xrFsq59tyDnXegKJk0nWE3HM9p62PBa0R/CG9ab+YkHxaum/V+FYV8BTUFk1GdxfYwFzBwu6KBsjuLBZq1XJFkQu8JeT+OTrsg5OozdTBRdLxTYqB60g==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700016)(82310400026)(23010399003)(1800799024)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	hBs7p9pNxyOOjdIkCCnuEvMnLIhuV2jBvsEWk+5IXHjB1vTI0dBoVprtMTkQw1SH4d2i0e7KfFNWjf/Fa1GKIMG3US2bvhmjWsC3Sqoec36ss8JjeIeGCAnKE46l8ADKnWB+0mzA0IO8RiolwYC/3ui4gX+5M4HieVXwD87kDYW+2iK3YlIULVO3EsBjvyavNSyfd/Pj71On4YsFR77dYBPxmjo1KzZDgWmctw8U3XwoMjabiVtRAKp2bnJ55pTQwlxK9NC5oZGfYiC7DsNnK32oYaJlyQKiseDQ+M8DC5NeJF65/8Jo4czV3tq7xd53xMrMFIa5r4sJAK+qpWn7yvx5FU7pfvDhA9+xcKX+k290Okx+KR4bzO9tC2mVSkyuth7zOqM4eEBf0mHmWG0bzdILXObpKsusoQ5ob9aq8Hbj3qz9FhYcypYHEuedAkut
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2026 09:27:33.8163
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57e2fa99-d4bc-44ab-a630-08def6c19c07
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00029928.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5677

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

When initializing send queues, set the number of queues only
when allocations are over.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
index 1c9206f74aaa..f0c3a2bda0c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
@@ -1121,8 +1121,6 @@ static int hws_bwc_send_queues_init(struct mlx5hws_context *ctx)
 	if (!mlx5hws_context_bwc_supported(ctx))
 		return 0;
 
-	ctx->queues += bwc_queues;
-
 	ctx->bwc_send_queue_locks = kzalloc_objs(*ctx->bwc_send_queue_locks,
 						 bwc_queues);
 
@@ -1134,6 +1132,8 @@ static int hws_bwc_send_queues_init(struct mlx5hws_context *ctx)
 	if (!ctx->bwc_lock_class_keys)
 		goto err_lock_class_keys;
 
+	ctx->queues += bwc_queues;
+
 	for (i = 0; i < bwc_queues; i++) {
 		mutex_init(&ctx->bwc_send_queue_locks[i]);
 		lockdep_register_key(ctx->bwc_lock_class_keys + i);
-- 
2.44.0

