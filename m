Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.55
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794318290;
	b=xmCWVQvYxvnluIFn8zxtEbnMhxvTOuj/USavZpiLnoDivTwQ1C3iLCM8cRZH86hOf83V
	 5BlrVo27lqEC8P1BrcEqBZA1KQvj9TDIJbw5yianhK+mhLA6RZVShgLTjZdvqsWF6Ws8S
	 AUtSaDgJ7hps20XQHn8AIIGZUCuf2R6oeZ47ARsgX0ZJRhhXHKPO7rjVM0vKJQGPaamZL
	 aHwaJn5bE9DvN75mc//V+qxpaer1iPoPaThpwqqJOBs/hFTSE8dTUgse0RvITXy9zjRtj
	 tF3gKrt7DNWPBECJJJ2nJ78XIgsmN5uYob8HJzTRrkJnYr7q+OnFA4giTn+aJjJSn/w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794318290;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-NV-OnPremToCloud:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=3pS5XmkmhCWyFBJqF26H1ej2OUhE2/fix0hTbT2FWr8=;
	b=pIGN2jVpvdHgjAW/Iy88cFuMzjRnMMm23vx3c2UQx/H4P3geBxjdPvecwRilggkLFYeG
	 Jh0DiIrGx7XLmD2T7XHJDL8F9XybHRz3CZqbuLQqtJbz/eFmFv15m/I6McPmMgMetdeBJ
	 clLp0Xn/uxzRJEncq1zFMlzp8Yi3/VCsgrTKfKx8mu7uDv1be504HV0wD3JkvCDFh9aEA
	 h9eUKIh9nfPOtfQkbdZXcLlbXfuNuJzBgWWrVnQbma8wOxBO+PijzcwLw2ny4E8K3kiI8
	 lo2hTmrdBZHvJx7Sg9VkCTE1L1YPbBK7k11Vorj77VDxHpYhwa3u1r7Vkl1pdwdi6qg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=T2hmOQrJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.55
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010055.outbound.protection.outlook.com [52.101.46.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D48B606A321;
	Tue, 10 Nov 2026 13:44:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D48B606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=T2hmOQrJ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BAPzQk0rjLLi29B4gFQ7I0ebWo0vfXRxBXIn9tuqPsQf/33u9vtfOqRu4cbwBsBDgtGOmwkHL+sAhUSYoNU2HJs1W7t8IOnrpd6xOb34t68ucf+3e9rNGFaFPjdN/IM3xmJd9ZWxrJtspg4hLIz1UUxDUNg4/J05Wx4ImqIh6iwwSSZAX2YwhEx6ayfnciyu4b2WNS35UkPS23b+49gKfGeRFqc2V6jfqdmymUuO3aZO4H43I4GAnkgRNWe9XJg/xYGi+xt8/E7NMm+tcKxfVvb/847836kJUm+OT+JEBz3CMZT0xTlF3H3XOPmTI0SGxoFDS9BEFF7EXTSIGJQExQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3pS5XmkmhCWyFBJqF26H1ej2OUhE2/fix0hTbT2FWr8=;
 b=N2QU1yKP7hlLAnBeFsccVmWNpvkYmM4bdtWQ0VsZYVDHUMBa5tZJLz1O/E3VikwM2Mm8vIgj2OMGZbzBob5HTylAzyDS2q4CEjIl3IV0D1+ywjymfkOW4JoQU4/JZ+ZGBXaM29SN5RB/7WB3wFCJlQPtx3e//GHuLQ8zE4uBmRF7rcQfA2AL+EVRiYA2rNCgsNtNINYjYE9SmIZmaeSyk1Bti4rFt/TjMVEhi/ofQ+otPCQCr1SHO2tOEPra5a2j79xhXH6GAfn9mv+ORuF9+mEChNvRSfNNYC0xxacQ/w/7H2Qd2RFYP7/F+IhYU8F+Ebc1FsMENoRn1ls23wcJ/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3pS5XmkmhCWyFBJqF26H1ej2OUhE2/fix0hTbT2FWr8=;
 b=T2hmOQrJhe2SFc4tgkcWuENpYQE3HFVfvfgy0f+IOtzttWlxewZOZBI/L3Wyv6qggMflqBU9chOuO95hhT2JNYY6HJD1HVQNd9GP33kAKrFAoEZlPm6deD+Qe8VSGgwOd5S1wQWMBR09HpuSz8GxEMyecdOEYFPRC0pqj1pF/mZaIlZNQDi+emPKUDM63dfl9OkOzha32/F7lw3XpnFeO6pksbJ/p5u5/xRUJmMYvTWhOEyFII+KcWr56DE2qxYmbooN+74cdo6dbbnAKhAQ4jI/fDqXPPu1KXpbA7oaIIFW5Eqnze1Mhxt82/aW5aE+KXePzVSQ/K0pwKawfabf1A==
Received: from PH7PR13CA0010.namprd13.prod.outlook.com (2603:10b6:510:174::20)
 by CH1PR12MB9645.namprd12.prod.outlook.com (2603:10b6:610:2af::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 13:44:42 +0000
Received: from CY4PEPF000392D9.namprd03.prod.outlook.com
 (2603:10b6:510:174:cafe::a3) by PH7PR13CA0010.outlook.office365.com
 (2603:10b6:510:174::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 13:44:41 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF000392D9.mail.protection.outlook.com (10.167.247.119) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 13:44:41 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:44:21 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:44:20 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 05:44:17 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 07/24] RDMA/mlx5: Require IB_QPT_DRIVER for the DC vendor QP types
Date: Tue, 10 Nov 2026 15:43:03 +0200
Message-ID: <20261110134320.34408-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261110134320.34408-1-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF000392D9:EE_|CH1PR12MB9645:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b663b96-97ec-4a67-1108-08df3f30c58a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|1800799024|376014|23010399003|56012099006|11063799006|22082099003|18002099003|10067099003|261009223027099003|261102123227099003|261026121527099003|261026140227099003|261021123027099003|261021121427099003|261022105027099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	Qh8dLpFrcBpNk8glkxmM6FyBe4qOc1tXaOAVbEQygwbFL2/6evE6FXBhd/lcV7CaLbuI1iyblfGsTs6wp1XWb++RmWQmv7xM5+sW4EaiephKUdoDGN2wQEY3T0xCzfBfqECnJUUtObMng7cra6a+JVhuldDBLej+L5MnpuXxU1stCYhLoB6HXM1nad9sasCbkcOYG2KzyYTWcEUfxA8e96qajST1sR7ubup48TMGy6HHmAgwbYHYZdgyb803c35gmBFeiAvWq2/1JCM6Tmckn5qFgaR7HPMSKRmEFhNvr8hZnFh0vYQC2IwkQ1mxkw+8J6y4yqgzsni2ZJ3c8nVFPqL789lZB3lTQ723g4O49sdbOI62IIBX/BGo7YnqaUtHJUk29VNdIQrogQZ5wUI1q+DZaZIpIwWLwLbbiJI3NUB9rN061sSsy4hGpwzXIUVVPPS6eF+tkUVjexoJJmhQOetRTno+tCsXyx9Nu422I5zclTSQu/aNYF6lcChrVXwmP879+5mYfikXjoU+rdbR4g6Et1I5nq8q3eE56VcS7Ywdwz/odKUGdFd2gozePfw3FkFm+NKeMalI7IUpStxOE2JCTtf8UuHq4JR/1vP4TZFGtzoVZgFug6s/fWX0sABZNxLbJyMHge3eYp3WcPU/NKx9/HiH0AcyTUbpUfvHHNELv/XX34gEcgaodpTG/8Tt2QXOHWiJoDObxM4MO194Gg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(1800799024)(376014)(23010399003)(56012099006)(11063799006)(22082099003)(18002099003)(10067099003)(261009223027099003)(261102123227099003)(261026121527099003)(261026140227099003)(261021123027099003)(261021121427099003)(261022105027099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	o5v4e2mXPQdgDUg36UEGDe5CtMVQ6j91PsB+b4ufGlkLemmsYOl4Ek6YcLJv/v+7iW8PRmzUkmIAJiGUwMEaw0k0UV1hQVQ8DR/Ak8Hj3ugU4d3Wez8GpGUlh4hneymI9Nk2DgJhXLbKUMf5nbwxPZUM2DIMhQ7wF5IUJSga9o7G+2goMh6XtK7zHAKMEQ2D4o6gzd5Ri0FPDPIYqcR9PWZj8BwkQepDHd7+/j20uVjHIF3NuiH4Vy2KjhkHt6KDYx5tV+oBUmya10uJ2sHQ8jhtb8B2jc+2rmXgPzwJjniJLLkOFGuJlAnrE1mjH1SaElLl4JGUGODUl2/BXm/cQ1JHGvFiIEjmJ8NSSb5gXUuYmUV2IrrbGhyo7B3wPcoaHiQTE+FDxmuX7E3NDol3aU6POIHkGfkJia5ne3L9R19Kc3AjByLyjBtD9tNgO/Ek
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 13:44:41.4011
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b663b96-97ec-4a67-1108-08df3f30c58a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF000392D9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9645

check_qp_type() checks the dct capability only for IB_QPT_DRIVER, but
process_vendor_flags() turns any QP that carries a DC type flag into a
DCI or DCT QP. A QP created as, for example, IB_QPT_RC with a DC flag
thus becomes a DC QP without the capability check.

Accept the DC type flags only on IB_QPT_DRIVER, the type userspace
uses to create DC QPs.

Fixes: 37518fa49f76 ("RDMA/mlx5: Process all vendor flags in one place")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 943ee5c55538..19cbf6b2b979 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2965,18 +2965,22 @@ static int process_vendor_flags(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 
 	switch (flags & (MLX5_QP_FLAG_TYPE_DCT | MLX5_QP_FLAG_TYPE_DCI)) {
 	case MLX5_QP_FLAG_TYPE_DCI:
+		if (qp->type != IB_QPT_DRIVER)
+			return -EINVAL;
 		qp->type = MLX5_IB_QPT_DCI;
 		break;
 	case MLX5_QP_FLAG_TYPE_DCT:
+		if (qp->type != IB_QPT_DRIVER)
+			return -EINVAL;
 		qp->type = MLX5_IB_QPT_DCT;
 		break;
+	case 0:
+		/* IB_QPT_DRIVER needs a subtype */
+		if (qp->type == IB_QPT_DRIVER)
+			return -EINVAL;
+		break;
 	default:
-		if (qp->type != IB_QPT_DRIVER)
-			break;
-		/*
-		 * It is IB_QPT_DRIVER and or no subtype or
-		 * wrong subtype were provided.
-		 */
+		/* Both subtypes */
 		return -EINVAL;
 	}
 
-- 
2.18.1

