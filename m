Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.2
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794935440;
	b=cIn72vLgi1TJ4LTzZdQmWe6wUs5475Jv1r7M4d2f4C1WpSRKBklRLsr5SzL1DFvZRp3d
	 khXJGfbkSoBgOV1UUewEksjTFKg5Fw9ecD30R/zt+y3iNfAlhGK+OBd6XEynD7XNgj/Ye
	 79D/hUTmLbowNiRj4BnEqhzzLYNAQcZMQaDBTr3VkGzzju+s5/TYnkoORk6Ntm5xp6oBJ
	 ukTYyWXD2SR0ssmmrPzZVlRv6weTF1BkAIlFJd5isLzXue1w6V97Ho83SYsiHLuv9Fk54
	 0+UhDgxX88DiaCcXfdBpVzpoQiwuQ37utcCU/pYQ6FRI3swdGjACxDSSGgoymvYWL+g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794935440;
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
	b=shLqqkms3ycBUKheOk0doLeZRfr7NOhMQRVtVNSZrzoObdFfCqWS6K8QAEmm1MhxBzp2
	 Mzr3OCiSLrG/jazwSCx0nTC2Aez9+3yKgaP/Q6dSL8YDhkJ0KJndKghvTer5Tf9y1YnDV
	 h6/K6Badwdom48cI/zrsr353gsrsD1x59YTs+nSYEeb+ENfk5absdQ2GgvcWNmmQhqE9x
	 S9Ym48kGX/OWjf0MJ6A5yl6qBgKF4AL/LP2rYvDQ0UHi8B/W78IOeD8/eCFj5W7WAdqxN
	 g79oILYCf0CynMVTIsCJqPQeKnzGO70S3OKH40TsDEvOQ9ICukwTs5AaD3SbkcJTgWw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=fZIpyt81;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.2
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012002.outbound.protection.outlook.com [52.101.43.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEEC3606A8A6;
	Tue, 17 Nov 2026 17:10:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DEEC3606A8A6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=fZIpyt81
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M2/4kvMd83OT2TinKek8yaYYwrND2IK7vbnWOrc3ucE8R4rGpGPISLmwIZJylhixVFUTjfD68DZaGTD2pRQ1UYasa0+Boq+UTRxqkXLNK8dpumXx90Y3cOWMejZp6eDjfh1Mu1P/d+4JwuPySpuF3wHd0O25irtb+45RgC29vka8C1U68BhkoVee09Q9DXdo7PYF9W8vp0y6DHRhUp3sEu2muvHFIBZ87LOo9qW1qMkRhkIK901/+4dgUrm6jNfc5yTXrxXROqi/xlxhr8b82xx5uiS7hbolqHZIxr+1NsXrE7Dg4KYXegEGHfhdnmP9al4dFV9HyIXhStCg1nsQGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3pS5XmkmhCWyFBJqF26H1ej2OUhE2/fix0hTbT2FWr8=;
 b=FRilrbBsjxPXXOILUlIXG5CQwCHksoNh+tUORfuWazRUZqHDSlIuJL7oRwa3ERXJyZbk5vnfgcEtEBK9OIJ+NVlGsZ9h4UP0C7ICB7ND4Ar9qoghSnO87CB+hyG/8mgcsqjsgQiB4Lu13qALXtV2uDZim1Z25XAYlmP7KnBX0bfYsE2Sj/DvU/Gv+q8WkXwTD63hQrBIddtC5kIgMPgVOOwbX045OVVlDfJm7SqN4ULbdjTYR9yXg8WyhKOHUqAbziBmgWixQNe5EpgifLexI/TzsK9PIgZ4BP2KI9nnEUGU3qZysFaGRMy/MTTAHQVaZksRgsLFSE6Tni/2XXg3kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3pS5XmkmhCWyFBJqF26H1ej2OUhE2/fix0hTbT2FWr8=;
 b=fZIpyt81b4uMrUVd4IS1UFCGp4lKZeMcBr/v8+GdlZQebmnKfhz3l46htaTu8GnAq/3dzH6fe83ugeWGLDEV8fEQYJabWzKeBIjtpjXPpkideWajxvStMx+DMcGiywNMR+kclQaU3FUrkLtlaZXcULqqxbBXFhlqcOt29VsJKy1/76PEUVrjyMc7XYA2z94T1fPYEcBpYQxkBDU47bCdcFG47Tf96b53rjn+m9xJWq8LZ9HhG4ZG/P9Kmg1JuVK3yuuOrBRFrluo06HIh3MJYVFBepXQVs3EkGLTSj4s09pbasvm1arQflGH8zuJFuJ0b+aujsCZ9tJEdpqyAB9HQw==
Received: from BYAPR05CA0004.namprd05.prod.outlook.com (2603:10b6:a03:74::35)
 by SA1PR12MB6704.namprd12.prod.outlook.com (2603:10b6:806:254::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 17:10:35 +0000
Received: from SJ1PEPF00002325.namprd03.prod.outlook.com
 (2603:10b6:a03:74:cafe::88) by BYAPR05CA0004.outlook.office365.com
 (2603:10b6:a03:74::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.7 via Frontend Transport; Tue, 17
 Nov 2026 17:10:35 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00002325.mail.protection.outlook.com (10.167.242.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 17:10:35 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 09:10:16 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 17 Nov 2026 09:10:15 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Tue, 17 Nov 2026 09:10:11 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 rdma-next 07/21] RDMA/mlx5: Require IB_QPT_DRIVER for the DC vendor QP types
Date: Tue, 17 Nov 2026 19:09:00 +0200
Message-ID: <20261117170914.27410-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261117170914.27410-1-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002325:EE_|SA1PR12MB6704:EE_
X-MS-Office365-Filtering-Correlation-Id: e2bf7145-0731-4ed2-0ca9-08df44cdb223
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|376014|23010399003|18002099003|22082099003|261009223027099003|56012099006|11063799006|261102123227099003|261028144727099003|261026140227099003|261026121527099003|261021121427099003|261022105027099003|261021123027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	WbEgzzv3GO+X6QbTtAHk26pH89lTyhmAShfZzM6WYHBK2768Tbllm2OB5q6/Qoc8CRkSzhOs8bmKDeniMcvMu1fGq8qJSSyuJ7TRYb+DyabuKs5Xv52bkyHAHpvH0VzWzNr5b147ZoISMTWK3YZ/89oXDy4F/EkpEUiJx85Wikqnicnn/pbKfC2d12ewzN+2+EYyVGnYNFzMjP9+0le9/6kI7YMqVxHQU33QOGfj5YhfnD0SzPWjtk4Q+JVsVWryyZs6x1lkWV9Ixgnwk0WX9dWkP+9nK9upHDF/yV/ltHSDHh/OfJZI6svQQHxsNusWZKRlBzQ8EAJcsgG+6iSvl2idXM9iDEM/xM+EM3JDJfEqhwUk2dXG7CbSNhNwNZLmna/iCfIOi3hvERNq8+Zo1ceHE2CD2Sdfgd85VOWAfI6u9u4R4jUhyMQqinIJ1WV7TSjknQ9xeSaJvT5kzWbYt3cvWqRisiXR9cjX4+S0XPnfHVmGftzjuWhu+P58IGpaBHaK762CB5fddM2fZNwvKvONFnwjpJxIG5M2OLeALO7Rm5COpAOtHSGqmx/WvvpgOXvZzs7O4bZxuXioWmHMKePpKf8nT3gisw7oY0pZrINwA7sKgPHaPuYUQ4+L/alDKI/SLdJ5XnMWB5ATMxuykAfAVeevn00x5rAI+hwUwNR22vIurNRf4Two5cF8kXS8Nc9zTMLLUmrMoVoKkp1SXg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(376014)(23010399003)(18002099003)(22082099003)(261009223027099003)(56012099006)(11063799006)(261102123227099003)(261028144727099003)(261026140227099003)(261026121527099003)(261021121427099003)(261022105027099003)(261021123027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	i9Haqsr6KrSsx+iRnndSXjRNBuDubdj5lLgBvolzWscaENAQxg1PHePKAT5H7m0ApE/K9IfXGoEKq1Zhj5ovX584GuiVSdtU74Fe/jOacS75zPOYTIYqU2qqviAa4IuHQIH2Fr83JI9fFRnc1oUr85QnaFLw6lvoRVPXACujQNWoXDrmh6IJvfVuXzF3zUiwJ4AfQaJ2m/mJh3tPchpzg8QHSWzHkEAMrKOrNPmxdu020W4JWn476ZqZNuTrckI0BR4QBI8YpiYwCgXQIq3Ws+lFhEa2myVdcna+jAvEye627u5WQwbKQZOzKoceTY+1fFGPUB82znrKoUfOwjkfm7G0BrOgjhynSe5eLZZAT7MNpRiZJbsmME1dB4nU8r0XqVff/Ixm5ZbdLoH/3JzernIYh+sQr/BzcMMJ7mqIqYqC+5giptO7SiEcTx9pgvGK
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 17:10:35.7327
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2bf7145-0731-4ed2-0ca9-08df44cdb223
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002325.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6704

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

