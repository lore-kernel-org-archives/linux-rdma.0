Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011031.outbound.protection.outlook.com [52.101.52.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2714149362F;
	Tue, 15 Sep 2026 11:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789471200; cv=fail; b=t/s++oDAqI03uMvlaBsGMucZ9gymUUOrXUWNY8/01jeeI8wrniq6dpufGl766W7f3OuuwX+Ohps1345MvvYRAfixlWCzYtSGbHrNpolCd5/IFvoTrwna2rJsszFacOcJ1UbqCL+PTrgc1FGo5CBz7dBPz15SH+4kvjopp6z3iRA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789471200; c=relaxed/simple;
	bh=oataAgDKL++D0kj40eolVORHj2fXQiN77C63d02RP2s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aJGtEfV6uGLL1DiU52lfGrz9aYfKTAkIMnTXjOHZaxIAxlcZh+y3eb+PqxnN52OqoLscNraDnK8yIM6EfIcsfOIdBQoTsjCLrbj9eyMUD54q/gkHFonaMGYKWWXEar86zmdIVK2Z2dmQqT3MSteqW9ohWkbumjhJNSkDYz0XXzk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fd5DPym5; arc=fail smtp.client-ip=52.101.52.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fd5DPym5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WLsK3gcEdyeIQwfD+rTWKVPLgqp+pdUGfGEYwVUTgrdlV6JeKtWJfwpty2SAjraClfpFiBGaviGRkWpAZ8jgKzt+agTeA60pCYwlZonQsUEhkkgzcxqEtpv7M9iBKQIj/xzBkKHJ/OGGCbZqQHpB9uU2RtHB5YQjLkHwBETKbx4lzWR4Jc3rLH+Ts7PGuGUKkGV0rEaoXJiuMbiPx9cigXxgwlksnjs4WcN1soFh1DGiDe9GCnNvIBDrIDdKwvM/euQ2wSbw6baDyE+oPyXzPibew4MSx5M/N9kpdxv0KmOUqTskFYrCgASZrM/EBulbYUX5n6mEy8VSbLNCxxyF5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8jBWt4cScxKTStuxip0cE8UUHcug5PAejMgag28C4SU=;
 b=m+gVCiM3kv6cR6KXSlaExT89pfu22azOhIqx65ooTKN8mpyX/JtmUJ6yxQgc93xgJwTbVGk9WaPC9Q3leJn9ZOjljFfH8j5/tAdsW9ETIuEa9S3hlBsomun3JHg8cdXRKu3rztSRwm2p5FU1pVgyNEE8uBl1fILyQm3k/NHK5JpvBGQ/g+M4z1xSRQ6r1A5PQnTT6zrfoQ3p8Php1hZlylkOfuOOZza8n9Tu3Pd91X2WYn4I8XsHPTD4p8wBq/xRYqtX+rBtP9uKvhcu3elcraM8v2TICMois7VxZEjCDW50DcMVUB0gd7q0H+LY4ntpEdLImcEjXTWvUSpNZFxu7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jBWt4cScxKTStuxip0cE8UUHcug5PAejMgag28C4SU=;
 b=fd5DPym5Z0u4So1eelbntVyX8HlYxW3LhTs0S1FgJvVkfiaIUwpNO0/tC1nUWQrKd/Kk3XB3FmCCN7AmwO23MJTJtgyBiPiAvG9EKw3VXxBMSmo3OKhjpx22PROjKFnmWs4SUi0B9hlr4ncVYWJlPgCg2gCq49Xg7Sbcf7NKuJjPQVQ6Wl/YE/xl6NsxJMYllORMAaXM8QmgKECM2EQ0hG9uPseKB80qnA9ZmZKj/tNsrxxq1XfOnB+LJHQ2xsappzyK7wElbkAwyYGqYasqluNnI5bkbGXSryv07WF8cPAs9Aa22Yu8j9U45VvPPROg54c4f3fhmLRKWLlsW8WqDw==
Received: from DS7PR05CA0093.namprd05.prod.outlook.com (2603:10b6:8:56::17) by
 SN7PR12MB6929.namprd12.prod.outlook.com (2603:10b6:806:263::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 11:19:50 +0000
Received: from DS2PEPF000061C4.namprd02.prod.outlook.com
 (2603:10b6:8:56:cafe::5c) by DS7PR05CA0093.outlook.office365.com
 (2603:10b6:8:56::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.8 via Frontend Transport; Tue, 15
 Sep 2026 11:19:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS2PEPF000061C4.mail.protection.outlook.com (10.167.23.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 11:19:49 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 04:19:37 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 15 Sep 2026 04:19:33 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.46 via Frontend
 Transport; Tue, 15 Sep 2026 04:19:29 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Erez Shitrit <erezsh@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Yevgeny Kliteynik
	<kliteyn@nvidia.com>
Subject: [PATCH net-next 1/6] net/mlx5: HWS, Return meaningful error code in hws_send_wqe_fw
Date: Tue, 15 Sep 2026 14:19:07 +0300
Message-ID: <20260915111912.3926585-2-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C4:EE_|SN7PR12MB6929:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c62463d-20c1-406a-f990-08df131b41d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|82310400026|376014|1800799024|18002099003|10067099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	fv5Ep9Q6g6yIKxNv2cvkzbQ65H/qKK0j6rlaDbTPLgE8sNZakLM+14sbIQABAjvDR98wAGt4fmB61XT8GI5E5iDTupe4K+goi5uR/K2Tv/4CjSakDYt+EcarA/jHv3N7pzovuz3xEb8M+qR4qGaDIdn56ZUD9XcK/6LGeluBX/ajVzekLAKGD+o2BZEdi7IAOuRLFSsyAQUDsutzGS41YTC3ApOBty29YLA9xsX1LbOX7UWYZlO3R1w7aHdNR8l7GTm7PTh4dd55kfKNxm2LPSX2X3T6js54kjPqDS6jFUUSTiROLUrb3t1pE6CYwdY/JHukj0qnk7aZSWgKBjZ+n9hg1RTwgLY6svUfDKPe2XyF3RQZZVxeMWzI3+IJA3G14nz3hbkWpyhQerm7gnP5zVEr7XhnKTrzgetkUheVHKkc1qTqCBzd97d/K/8bt60c1VmFQAITw31YIHw4GuwWlp3KKOSpgZNnZYF7fZNAjcYwmsyQAQEmDTGfYdD93w1hbu06BnD9BGQGAMlay6xCEQfqwc+RNRJCykXPdm0fIzsDMaUp+0oxmRgI17UdO0uVS0hqd0IACF7L8+BSWctg6BDqCpz2cPB9enBjJ1inpnFGvPMqCKnRfF0HlAblZSv3r/QfVyZLBx9Wj+h3XRjVIAW1CA+q9tMXUwA8GW0iyXHWJxvlJWdDJTEPUoQxRm7GRHbVh2ic+Enbjtr9wnzKig==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(82310400026)(376014)(1800799024)(18002099003)(10067099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QRLXSrH61Zm73FxgDzbqB6IJ2nFDCMmK6AXK7M6mfocN0DCKL+cpMqcUwaCSgGUZg2ampzB4J4qfHvoDb55cv4hhVNh5qgnugO7+th6ghwa9DUsmA2oBphcjNQGSDY7MUhsNgQSFSooECKgEN1GrMyY+WUBUOjYhpy6xajdEEqXfDpM2g7A/ezo+PRXQF9K55U4jpmwtSAbVYHZWkEk9yk0NyIeZEOYeIt7sUK08ucSe5uEh4V/a4g8LFI0JyKuMGlxe8WvvjXdrVwnlC1naasGIW1cbWM3VWzm21FHF9Von44507B8jSFTgvV0zlW2Z3KaXqSK07RPOsOcDKEpZw++3rZihHDRyATQtHBf92JeTxLPqN4yuV01kAQ1vYg5JeWpOGaX8IqgjC0dqcmnmI8HKth71q2gUdIsY1g8BIrX5UJcmm7H5wMZakWmTcuTa
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 11:19:49.7878
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c62463d-20c1-406a-f990-08df131b41d4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6929

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Returning '-1' is non-idiomatic in kernel code.
Use a meaningful error code instead.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
index df3b93499eeb..ae3ff232c63b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
@@ -1305,7 +1305,7 @@ hws_send_wqe_fw(struct mlx5_core_dev *mdev,
 		goto send_wqe;
 	}
 
-	return -1;
+	return -EIO;
 }
 
 void mlx5hws_send_stes_fw(struct mlx5hws_context *ctx,
-- 
2.44.0

