Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.5
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794924153;
	b=rMYQx46g/pl/RYyXlRVb5QwYEkb7M5HtGquk4mz7y+o0+/EHXUhMxXdmw5m+/OF8uCOa
	 SvRgHcNQKsegJvH8QtFXLCYXWgrc/b92lLidnDCXxyjNvb2eBr0Uvefg0vdIoTLfzKdkC
	 Bz4DIvYZ051jRfofAPXFKuOM+KsoEO0otZ8fu+QrmCmwog2JJ9c8f1lNUsxc020ZwqsYa
	 7fOXOk7R0P6lC/BsJaXzIU5MfPmOWKSj6Y6nM4AOWYIBvhHYcZGY+Yk02XoTSpawnq+vk
	 8LXXkkGC/0yvLzkSZyjS4hpc/9L/Ofrf1W/80sybGtTOY4C//SXGabz/q0AbCTFf1gA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924153;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-ID:References:In-Reply-To:To:CC:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-NV-OnPremToCloud:
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
	bh=i2spLRpOBwbUsFKd396zOisiqJT7FG6cu7A16wIOhMk=;
	b=C2I6DPmLSlqfM+/EDKRHRvw3Q58eYNMfbaUgcmSTH9SQb3HsTueeyC1eme1Z91MF2anN
	 vgg31Gia1VvfYjtBEmKxp5HOo3/5E5+xjRqIYkEPDNKX0FTdU/zBgKhk2St/B0IJScGTf
	 +BJUc+xHnENdsLYi0zl+eJa7t22OPAHJgcUV1luBRvq4/M3bzxiQiorUZ9IQtjIB1uhmr
	 CtELUPnhuzaDm0+2ZJPlJiQdzruvuG8QvZEWaL/mcx/F3W3LUNTsihQU25EkTGNYveGVQ
	 O6xphUfJatNpkNAD5IZWbeGM1TsrKsDcE3U74BdNeXlm2P3ML4dEWNRCECcBQ9+fvEQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=DPZ+SSGT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.5
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011005.outbound.protection.outlook.com [52.101.52.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A737606A33A;
	Tue, 17 Nov 2026 14:02:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A737606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=DPZ+SSGT
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BDhSPzcqL3utmz/EBxucLziK5+g6q7wQw9h58g+1LfwhcMxkvjby7LXCqjTPkiwAvXc6Axz39qwDpB2O40U177ydwZwtdi6tp4VhkOlsqoAN4q4X/Go1rk2SvIFLgb3+77hLuCBNg4gHJCnguMgBquNzVbD1OHBzFfJ+ZwYpjoxwK6nyZyCzUtjc9403vhPCW4tYhgN3ArEuwibqwRpDmu3Z1tbnoyu3Jsy6YMqxd3P2kAPZIreHjkbLEhRMpHYoLlPvNVSFxamduTeGUtP4T+d2zb3P2COQKY4JeCdbXPG0+EnkMLKDGAInDZ4MB2TeZMCIAnP0jxn/xX07V6ntHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i2spLRpOBwbUsFKd396zOisiqJT7FG6cu7A16wIOhMk=;
 b=PMP8ulL5Slm7vb07FPJ6uBUfe71kXFsWRd5Mbx1ZUfsigKop9YQFH8O5wjVtkt04fP9otPACd8fgXLKDai7Ep+d618DnVEJRbFQKhI73yxxm73RqZ9LoMUXUi1C0rSOzYSQRpYRsSe5uMyFHqLiACgDl1ZBUZoHK5MO4uqbkokC1jh2EmK19rQUu+LxGk93Pokhg2ePlUVR1H68JWC3Owq0dIYVFGGXV9O2j7mElZDA9QKA1lRiTmVK2+ahI977DsFWsGKWuIVH276T5I+NUeLlA2PyDRuSv/w+SVVKgY8HhYT/yhZjdLuBhLK+dy6C0yWYDGhzkq1wGjoZr8f39FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i2spLRpOBwbUsFKd396zOisiqJT7FG6cu7A16wIOhMk=;
 b=DPZ+SSGTQP7bk6ibeqaVGnK+LxUcegXjlhvcbXL3m4gEfR3H9Q8kL1egSaKnTtDF1zgoQgmiy6lXZoL1gaBGyVFOrW52Zs/40uLYiPPvK5ZHYd0itNOt7HhED8pPEkIXRnpSsl1tceE6DWlrR/CHGLe/dt5I0uUTEnY9R/m4SDEzBZhoFMU8kkMkThojWzhxBIIquP6ILa/PJ0PWuNZXwupcIQLCuBvK9QiQV1Nnsr6QbbvLkDuuZiwHFKkeCt4BCa2vjlmLdlaJZOmtpSZwjKY3+/VvfMBzlCQA/I9LlhEG3msw3zBbiAl97Mma9n7He5n37hU3oDhYSrsNDvfmWA==
Received: from PH0P220CA0013.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:d3::11)
 by IA4PR12MB9785.namprd12.prod.outlook.com (2603:10b6:208:55b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Tue, 17 Nov
 2026 14:02:27 +0000
Received: from MW2PEPF00014676.namprd04.prod.outlook.com
 (2603:10b6:510:d3:cafe::80) by PH0P220CA0013.outlook.office365.com
 (2603:10b6:510:d3::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.10 via Frontend Transport; Tue,
 17 Nov 2026 14:02:27 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MW2PEPF00014676.mail.protection.outlook.com (10.167.249.183) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 14:02:27 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 06:01:52 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 17 Nov
 2026 06:01:52 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 17
 Nov 2026 06:01:49 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Tue, 17 Nov 2026 16:01:22 +0200
Subject: [PATCH rdma-next 11/11] RDMA/mlx5: Resolve UAR and mmap core
 devices via the ucontext
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261117-mlx5-sd-prep-v1-11-8efd124c7895@nvidia.com>
References: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
In-Reply-To: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	"Sabrina Dubroca" <sd@queasysnail.net>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, Edward Srouji <edwards@nvidia.com>, "Akiva
 Goldberger" <agoldberger@nvidia.com>, Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794924076; l=19971;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=AlHzLTEI+OuvPOAGDHf0s68fdezd6yB2DgsuPtzMm5c=;
 b=TSdgr/ymFPmkXXb2iESwgaWPWWjzy67Zs1QyVnn8jgEt78GFEfpSZJtlLn9nP1H1hU7lfxe/T
 bnIK2NA/0+BBr4FM9y1N8YrbfFjSlCmz+Dqi9GqElNcUukiZyW6d1EM
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW2PEPF00014676:EE_|IA4PR12MB9785:EE_
X-MS-Office365-Filtering-Correlation-Id: 66d7a308-ac6d-4d2a-7338-08df44b369bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|1800799024|376014|23010399003|18002099003|6133799003|22082099003|261009223027099003|11063799006|56012099006|261102123227099003|261028144727099003|10067099003|261026140227099003|261026121527099003|261021121427099003|261022075727099003|261022105027099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	V0k639xu24kU4bkG7b7Jbc3XgDN48ABvUPcs0A1ViTIa1gSoXoqzd+JP+V/Ccp7SunUuJAXPTATQ8bhw5YNiUPpJrb5FhOlXdoGXWgC3AnOa8BE0lZUmfSUkRV9NVhqSJ9GqUw7QEDiMLlU4x5OFMbMGljvFHgtanSetxtqtpbKsEPQqvNvZnL8mioqaXNbWy28qTRrSedi2uxbbc81IAEL3CwossDk/Lo1xRSprYy4uQwZTlwxcT+m4Cr1juBYHeZn/ZuTTE1EbPJ2wmp12hnMakL8FziVM3j1jiIS7rW1qzgJ9YRZ1LP2njB9osDREam7kq8pcQA6nZLHw/rKWlq5k0/FsL/uCGyaJs0ytAhWWlu64eBPasMfkgMvX25u4alCB7JYvdimgII4zFg0Yjy0DZNXQ4bMGzv0UYvN4VI1YzerXFZC8lhrYEX6Gn6Wd8oTfv1iBuqCOqWGAexBvTHXvl/zXfuUDosBgrkCAk8d+47go7wNi+ODJZpkWzvFx9dt4KDygHfImKGt/bVbRTIKD/qQ/R6ExNXYcfQtGjAiu2/9JASKQmx8iaaNAwn5cze0UlkfV3bKjIMeKcW6djI/aNgTREZLUJC4HOvXZ/rWfXOUdzmC4m8qAei21R+Zz65a836eCwVc6LNHBuzxknwlWiOob3e1o+tNmwgwejyHy5DNWVe2z2azW2kn+d8uJTKYRTIeqME2h4kQ5aUg5WQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(1800799024)(376014)(23010399003)(18002099003)(6133799003)(22082099003)(261009223027099003)(11063799006)(56012099006)(261102123227099003)(261028144727099003)(10067099003)(261026140227099003)(261026121527099003)(261021121427099003)(261022075727099003)(261022105027099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9/7tynB52fXS2uZ7qutb9h3ekth9E1+y5d0CKB/RueL+7R+1ZU0ipF8p+bSu+rbJKzHtVB4Rm+V1qppizmoMKxhO1/WprqYZl9+sFtYnbWIgIO2N7iAnojd8QpVOpHqYJq42OqgwwrDsiHoIqQEu8x723TcIu7/QaAC7c+v/jyihz0iId/zHVh2HOiGwwPIB2C3qPkrftjAkaw/ZIkB36AI6ypWO26NKwKHvj2fMvXqGSi7KdwdgC/3rsuuq9z7G5XBiwTIsQIdjrvNgV4LB1Z5H4WwileYznXKEbfY+bU5hAvxwefknteek2X3n+el7myE4beC5CMRELEbt8T9EXPdFXhxZYnnHMz6urwrrgNLTUfWf63+iHGzSLip02FMNYvvQ5nl5hGfTWGS5SHNfyootPh0hMrXTc/Hb+0JDCIv3icxQq+rccXKf38cC6QZ6
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 14:02:27.2781
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66d7a308-ac6d-4d2a-7338-08df44b369bf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MW2PEPF00014676.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9785

From: Akiva Goldberger <agoldberger@nvidia.com>

The ucontext is tied to one core device, so resolve the core device from
the ucontext instead of mlx5_ib_dev::mdev across the UAR allocation,
transport domain, ucontext response and mmap paths.

No functional change.

Signed-off-by: Akiva Goldberger <agoldberger@nvidia.com>
Reviewed-by: Michael Gur <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c | 177 ++++++++++++++++++++------------------
 1 file changed, 94 insertions(+), 83 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 50d0762db3d5a7007e6b44507fe56964b469d65b..e0305279793056a1bac0b6e335466f7fce2eed2c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1937,15 +1937,17 @@ static int calc_total_bfregs(struct mlx5_ib_dev *dev, bool lib_uar_4k,
 	return 0;
 }
 
-static int allocate_uars(struct mlx5_ib_dev *dev, struct mlx5_ib_ucontext *context)
+static int allocate_uars(struct mlx5_ib_ucontext *context)
 {
+	struct mlx5_ib_dev *dev = to_dev(context->ibucontext.device);
+	struct mlx5_core_dev *mdev = uctx_to_mdev(context);
 	struct mlx5_bfreg_info *bfregi;
 	int err;
 	int i;
 
 	bfregi = &context->bfregi;
 	for (i = 0; i < bfregi->num_static_sys_pages; i++) {
-		err = mlx5_cmd_uar_alloc(dev->mdev, &bfregi->sys_pages[i],
+		err = mlx5_cmd_uar_alloc(mdev, &bfregi->sys_pages[i],
 					 context->devx_uid);
 		if (err)
 			goto error;
@@ -1960,16 +1962,16 @@ static int allocate_uars(struct mlx5_ib_dev *dev, struct mlx5_ib_ucontext *conte
 
 error:
 	for (--i; i >= 0; i--)
-		if (mlx5_cmd_uar_dealloc(dev->mdev, bfregi->sys_pages[i],
+		if (mlx5_cmd_uar_dealloc(mdev, bfregi->sys_pages[i],
 					 context->devx_uid))
 			mlx5_ib_warn(dev, "failed to free uar %d\n", i);
 
 	return err;
 }
 
-static void deallocate_uars(struct mlx5_ib_dev *dev,
-			    struct mlx5_ib_ucontext *context)
+static void deallocate_uars(struct mlx5_ib_ucontext *context)
 {
+	struct mlx5_core_dev *mdev = uctx_to_mdev(context);
 	struct mlx5_bfreg_info *bfregi;
 	int i;
 
@@ -1977,7 +1979,7 @@ static void deallocate_uars(struct mlx5_ib_dev *dev,
 	for (i = 0; i < bfregi->num_sys_pages; i++)
 		if (i < bfregi->num_static_sys_pages ||
 		    bfregi->sys_pages[i] != MLX5_IB_INVALID_UAR_INDEX)
-			mlx5_cmd_uar_dealloc(dev->mdev, bfregi->sys_pages[i],
+			mlx5_cmd_uar_dealloc(mdev, bfregi->sys_pages[i],
 					     context->devx_uid);
 }
 
@@ -2072,41 +2074,48 @@ void mlx5_ib_disable_lb(struct mlx5_ib_dev *dev, bool td, bool qp)
 	mutex_unlock(&dev->lb.mutex);
 }
 
-static int mlx5_ib_alloc_transport_domain(struct mlx5_ib_dev *dev, u32 *tdn,
-					  u16 uid)
+static int mlx5_ib_alloc_transport_domain(struct mlx5_ib_ucontext *context)
 {
+	struct mlx5_ib_dev *dev = to_dev(context->ibucontext.device);
+	struct mlx5_core_dev *mdev = uctx_to_mdev(context);
+	u32 *tdn = &context->tdn;
+	u16 uid = context->devx_uid;
 	int err;
 
-	if (!MLX5_CAP_GEN(dev->mdev, log_max_transport_domain))
+	if (!MLX5_CAP_GEN(mdev, log_max_transport_domain))
 		return 0;
 
-	err = mlx5_cmd_alloc_transport_domain(dev->mdev, tdn, uid);
+	err = mlx5_cmd_alloc_transport_domain(mdev, tdn, uid);
 	if (err)
 		return err;
 
-	if ((MLX5_CAP_GEN(dev->mdev, port_type) != MLX5_CAP_PORT_TYPE_ETH) ||
-	    (!MLX5_CAP_GEN(dev->mdev, disable_local_lb_uc) &&
-	     !MLX5_CAP_GEN(dev->mdev, disable_local_lb_mc)))
+	if ((MLX5_CAP_GEN(mdev, port_type) != MLX5_CAP_PORT_TYPE_ETH) ||
+	    (!MLX5_CAP_GEN(mdev, disable_local_lb_uc) &&
+	     !MLX5_CAP_GEN(mdev, disable_local_lb_mc)))
 		return 0;
 
 	err = mlx5_ib_enable_lb(dev, true, false);
 	if (err)
-		mlx5_cmd_dealloc_transport_domain(dev->mdev, *tdn, uid);
+		mlx5_cmd_dealloc_transport_domain(mdev, *tdn, uid);
 
 	return err;
 }
 
-static void mlx5_ib_dealloc_transport_domain(struct mlx5_ib_dev *dev, u32 tdn,
-					     u16 uid)
+static void mlx5_ib_dealloc_transport_domain(struct mlx5_ib_ucontext *context)
 {
-	if (!MLX5_CAP_GEN(dev->mdev, log_max_transport_domain))
+	struct mlx5_ib_dev *dev = to_dev(context->ibucontext.device);
+	struct mlx5_core_dev *mdev = uctx_to_mdev(context);
+	u32 tdn = context->tdn;
+	u16 uid = context->devx_uid;
+
+	if (!MLX5_CAP_GEN(mdev, log_max_transport_domain))
 		return;
 
-	mlx5_cmd_dealloc_transport_domain(dev->mdev, tdn, uid);
+	mlx5_cmd_dealloc_transport_domain(mdev, tdn, uid);
 
-	if ((MLX5_CAP_GEN(dev->mdev, port_type) != MLX5_CAP_PORT_TYPE_ETH) ||
-	    (!MLX5_CAP_GEN(dev->mdev, disable_local_lb_uc) &&
-	     !MLX5_CAP_GEN(dev->mdev, disable_local_lb_mc)))
+	if ((MLX5_CAP_GEN(mdev, port_type) != MLX5_CAP_PORT_TYPE_ETH) ||
+	    (!MLX5_CAP_GEN(mdev, disable_local_lb_uc) &&
+	     !MLX5_CAP_GEN(mdev, disable_local_lb_mc)))
 		return;
 
 	mlx5_ib_disable_lb(dev, true, false);
@@ -2118,29 +2127,29 @@ static int set_ucontext_resp(struct ib_ucontext *uctx,
 	struct ib_device *ibdev = uctx->device;
 	struct mlx5_ib_dev *dev = to_dev(ibdev);
 	struct mlx5_ib_ucontext *context = to_mucontext(uctx);
+	struct mlx5_core_dev *mdev = uctx_to_mdev(context);
 	struct mlx5_bfreg_info *bfregi = &context->bfregi;
 
-	if (MLX5_CAP_GEN(dev->mdev, dump_fill_mkey)) {
+	if (MLX5_CAP_GEN(mdev, dump_fill_mkey)) {
 		resp->dump_fill_mkey = dev->mkeys.dump_fill_mkey;
 		resp->comp_mask |=
 			MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_DUMP_FILL_MKEY;
 	}
 
-	resp->qp_tab_size = 1 << MLX5_CAP_GEN(dev->mdev, log_max_qp);
-	if (mlx5_wc_support_get(dev->mdev))
-		resp->bf_reg_size = 1 << MLX5_CAP_GEN(dev->mdev,
-						      log_bf_reg_size);
+	resp->qp_tab_size = 1 << MLX5_CAP_GEN(mdev, log_max_qp);
+	if (mlx5_wc_support_get(mdev))
+		resp->bf_reg_size = 1 << MLX5_CAP_GEN(mdev, log_bf_reg_size);
 	resp->cache_line_size = cache_line_size();
-	resp->max_sq_desc_sz = MLX5_CAP_GEN(dev->mdev, max_wqe_sz_sq);
-	resp->max_rq_desc_sz = MLX5_CAP_GEN(dev->mdev, max_wqe_sz_rq);
-	resp->max_send_wqebb = 1 << MLX5_CAP_GEN(dev->mdev, log_max_qp_sz);
-	resp->max_recv_wr = 1 << MLX5_CAP_GEN(dev->mdev, log_max_qp_sz);
-	resp->max_srq_recv_wr = 1 << MLX5_CAP_GEN(dev->mdev, log_max_srq_sz);
+	resp->max_sq_desc_sz = MLX5_CAP_GEN(mdev, max_wqe_sz_sq);
+	resp->max_rq_desc_sz = MLX5_CAP_GEN(mdev, max_wqe_sz_rq);
+	resp->max_send_wqebb = 1 << MLX5_CAP_GEN(mdev, log_max_qp_sz);
+	resp->max_recv_wr = 1 << MLX5_CAP_GEN(mdev, log_max_qp_sz);
+	resp->max_srq_recv_wr = 1 << MLX5_CAP_GEN(mdev, log_max_srq_sz);
 	resp->cqe_version = context->cqe_version;
-	resp->log_uar_size = MLX5_CAP_GEN(dev->mdev, uar_4k) ?
+	resp->log_uar_size = MLX5_CAP_GEN(mdev, uar_4k) ?
 				MLX5_ADAPTER_PAGE_SHIFT : PAGE_SHIFT;
-	resp->num_uars_per_page = MLX5_CAP_GEN(dev->mdev, uar_4k) ?
-					MLX5_CAP_GEN(dev->mdev,
+	resp->num_uars_per_page = MLX5_CAP_GEN(mdev, uar_4k) ?
+					MLX5_CAP_GEN(mdev,
 						     num_of_uars_per_page) : 1;
 	resp->tot_bfregs = bfregi->lib_uar_dyn ? 0 :
 			bfregi->total_num_bfregs - bfregi->num_dyn_bfregs;
@@ -2149,11 +2158,11 @@ static int set_ucontext_resp(struct ib_ucontext *uctx,
 				      MLX5_USER_CMDS_SUPP_UHW_CREATE_AH;
 
 	if (mlx5_ib_port_link_layer(ibdev, 1) == IB_LINK_LAYER_ETHERNET) {
-		mlx5_query_min_inline(dev->mdev, &resp->eth_min_inline);
+		mlx5_query_min_inline(mdev, &resp->eth_min_inline);
 		resp->eth_min_inline++;
 	}
 
-	if (dev->mdev->clock_info)
+	if (mdev->clock_info)
 		resp->clock_info_versions = BIT(MLX5_IB_CLOCK_INFO_V1);
 
 	/*
@@ -2170,18 +2179,18 @@ static int set_ucontext_resp(struct ib_ucontext *uctx,
 				 internal_timer_h) % PAGE_SIZE;
 	}
 
-	if (MLX5_CAP_GEN(dev->mdev, ece_support))
+	if (MLX5_CAP_GEN(mdev, ece_support))
 		resp->comp_mask |= MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_ECE;
 
-	if (rt_supported(MLX5_CAP_GEN(dev->mdev, sq_ts_format)) &&
-	    rt_supported(MLX5_CAP_GEN(dev->mdev, rq_ts_format)) &&
-	    rt_supported(MLX5_CAP_ROCE(dev->mdev, qp_ts_format)))
+	if (rt_supported(MLX5_CAP_GEN(mdev, sq_ts_format)) &&
+	    rt_supported(MLX5_CAP_GEN(mdev, rq_ts_format)) &&
+	    rt_supported(MLX5_CAP_ROCE(mdev, qp_ts_format)))
 		resp->comp_mask |=
 			MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_REAL_TIME_TS;
 
 	resp->num_dyn_bfregs = bfregi->num_dyn_bfregs;
 
-	if (MLX5_CAP_GEN(dev->mdev, drain_sigerr))
+	if (MLX5_CAP_GEN(mdev, drain_sigerr))
 		resp->comp_mask |= MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_SQD2RTS;
 
 	resp->comp_mask |=
@@ -2204,6 +2213,7 @@ static int mlx5_ib_alloc_ucontext(struct ib_ucontext *uctx,
 	struct mlx5_ib_alloc_ucontext_req_v2 req;
 	struct mlx5_ib_alloc_ucontext_resp resp = {};
 	struct mlx5_ib_ucontext *context = to_mucontext(uctx);
+	struct mlx5_core_dev *mdev = uctx_to_mdev(context);
 	struct mlx5_bfreg_info *bfregi;
 	int ver;
 	int err;
@@ -2245,7 +2255,7 @@ static int mlx5_ib_alloc_ucontext(struct ib_ucontext *uctx,
 		context->devx_uid = err;
 
 		if (uctx_rdma_ctrl_is_enabled(uctx->enabled_caps)) {
-			err = mlx5_cmd_add_privileged_uid(dev->mdev,
+			err = mlx5_cmd_add_privileged_uid(mdev,
 							  context->devx_uid);
 			if (err)
 				goto out_devx;
@@ -2281,13 +2291,12 @@ static int mlx5_ib_alloc_ucontext(struct ib_ucontext *uctx,
 		goto out_count;
 	}
 
-	err = allocate_uars(dev, context);
+	err = allocate_uars(context);
 	if (err)
 		goto out_sys_pages;
 
 uar_done:
-	err = mlx5_ib_alloc_transport_domain(dev, &context->tdn,
-					     context->devx_uid);
+	err = mlx5_ib_alloc_transport_domain(context);
 	if (err)
 		goto out_uars;
 
@@ -2295,7 +2304,7 @@ static int mlx5_ib_alloc_ucontext(struct ib_ucontext *uctx,
 	mutex_init(&context->db_page_mutex);
 
 	context->cqe_version = min_t(__u8,
-				 (__u8)MLX5_CAP_GEN(dev->mdev, cqe_version),
+				 (__u8)MLX5_CAP_GEN(mdev, cqe_version),
 				 req.max_cqe_version);
 
 	err = set_ucontext_resp(uctx, &resp);
@@ -2312,7 +2321,7 @@ static int mlx5_ib_alloc_ucontext(struct ib_ucontext *uctx,
 	context->lib_caps = req.lib_caps;
 	print_lib_caps(dev, context->lib_caps);
 
-	if (mlx5_ib_lag_should_assign_affinity(dev, dev->mdev)) {
+	if (mlx5_ib_lag_should_assign_affinity(dev, mdev)) {
 		u32 port = mlx5_core_native_port_num(dev->mdev) - 1;
 
 		atomic_set(&context->tx_port_affinity,
@@ -2323,10 +2332,10 @@ static int mlx5_ib_alloc_ucontext(struct ib_ucontext *uctx,
 	return 0;
 
 out_mdev:
-	mlx5_ib_dealloc_transport_domain(dev, context->tdn, context->devx_uid);
+	mlx5_ib_dealloc_transport_domain(context);
 
 out_uars:
-	deallocate_uars(dev, context);
+	deallocate_uars(context);
 
 out_sys_pages:
 	kfree(bfregi->sys_pages);
@@ -2337,7 +2346,7 @@ static int mlx5_ib_alloc_ucontext(struct ib_ucontext *uctx,
 out_ucap:
 	if (req.flags & MLX5_IB_ALLOC_UCTX_DEVX &&
 	    uctx_rdma_ctrl_is_enabled(uctx->enabled_caps))
-		mlx5_cmd_remove_privileged_uid(dev->mdev, context->devx_uid);
+		mlx5_cmd_remove_privileged_uid(mdev, context->devx_uid);
 
 out_devx:
 	if (req.flags & MLX5_IB_ALLOC_UCTX_DEVX)
@@ -2373,43 +2382,42 @@ static int mlx5_ib_query_ucontext(struct ib_ucontext *ibcontext,
 static void mlx5_ib_dealloc_ucontext(struct ib_ucontext *ibcontext)
 {
 	struct mlx5_ib_ucontext *context = to_mucontext(ibcontext);
-	struct mlx5_ib_dev *dev = to_dev(ibcontext->device);
+	struct mlx5_core_dev *mdev = uctx_to_mdev(context);
 	struct mlx5_bfreg_info *bfregi;
 
 	bfregi = &context->bfregi;
-	mlx5_ib_dealloc_transport_domain(dev, context->tdn, context->devx_uid);
+	mlx5_ib_dealloc_transport_domain(context);
 
-	deallocate_uars(dev, context);
+	deallocate_uars(context);
 	kfree(bfregi->sys_pages);
 	kfree(bfregi->count);
 
 	if (context->devx_uid) {
 		if (uctx_rdma_ctrl_is_enabled(ibcontext->enabled_caps))
-			mlx5_cmd_remove_privileged_uid(dev->mdev,
+			mlx5_cmd_remove_privileged_uid(mdev,
 						       context->devx_uid);
 		mlx5_ib_devx_destroy(uctx_to_mdev(context), context->devx_uid);
 	}
 }
 
-static phys_addr_t uar_index2pfn(struct mlx5_ib_dev *dev,
+static phys_addr_t uar_index2pfn(struct mlx5_core_dev *mdev,
 				 int uar_idx)
 {
 	int fw_uars_per_page;
 
-	fw_uars_per_page = MLX5_CAP_GEN(dev->mdev, uar_4k) ? MLX5_UARS_IN_PAGE : 1;
+	fw_uars_per_page = MLX5_CAP_GEN(mdev, uar_4k) ? MLX5_UARS_IN_PAGE : 1;
 
-	return (dev->mdev->bar_addr >> PAGE_SHIFT) + uar_idx / fw_uars_per_page;
+	return (mdev->bar_addr >> PAGE_SHIFT) + uar_idx / fw_uars_per_page;
 }
 
-static u64 uar_index2paddress(struct mlx5_ib_dev *dev,
-				 int uar_idx)
+static u64 uar_index2paddress(struct mlx5_core_dev *mdev, int uar_idx)
 {
 	unsigned int fw_uars_per_page;
 
-	fw_uars_per_page = MLX5_CAP_GEN(dev->mdev, uar_4k) ?
+	fw_uars_per_page = MLX5_CAP_GEN(mdev, uar_4k) ?
 				MLX5_UARS_IN_PAGE : 1;
 
-	return (dev->mdev->bar_addr + (uar_idx / fw_uars_per_page) * PAGE_SIZE);
+	return (mdev->bar_addr + (uar_idx / fw_uars_per_page) * PAGE_SIZE);
 }
 
 static int get_command(unsigned long offset)
@@ -2454,10 +2462,11 @@ static inline char *mmap_cmd2str(enum mlx5_ib_mmap_cmd cmd)
 	}
 }
 
-static int mlx5_ib_mmap_clock_info_page(struct mlx5_ib_dev *dev,
-					struct vm_area_struct *vma,
+static int mlx5_ib_mmap_clock_info_page(struct vm_area_struct *vma,
 					struct mlx5_ib_ucontext *context)
 {
+	struct mlx5_core_dev *mdev = uctx_to_mdev(context);
+
 	if ((vma->vm_end - vma->vm_start != PAGE_SIZE) ||
 	    !(vma->vm_flags & VM_SHARED))
 		return -EINVAL;
@@ -2469,11 +2478,11 @@ static int mlx5_ib_mmap_clock_info_page(struct mlx5_ib_dev *dev,
 		return -EPERM;
 	vm_flags_clear(vma, VM_MAYWRITE);
 
-	if (!dev->mdev->clock_info)
+	if (!mdev->clock_info)
 		return -EOPNOTSUPP;
 
 	return vm_insert_page(vma, vma->vm_start,
-			      virt_to_page(dev->mdev->clock_info));
+			      virt_to_page(mdev->clock_info));
 }
 
 static int phys_addr_to_bar(struct pci_dev *pdev, phys_addr_t pa)
@@ -2504,7 +2513,9 @@ static int mlx5_ib_mmap_get_pfns(struct rdma_user_mmap_entry *entry,
 				 struct p2pdma_provider **provider)
 {
 	struct mlx5_user_mmap_entry *mentry = to_mmmap(entry);
-	struct pci_dev *pdev = to_dev(entry->ucontext->device)->mdev->pdev;
+	struct mlx5_core_dev *mdev =
+		uctx_to_mdev(to_mucontext(entry->ucontext));
+	struct pci_dev *pdev = mdev->pdev;
 	int bar;
 
 	phys_vec->paddr = mentry->address;
@@ -2572,7 +2583,7 @@ static void mlx5_ib_mmap_free(struct rdma_user_mmap_entry *entry)
 		break;
 	case MLX5_IB_MMAP_TYPE_UAR_WC:
 	case MLX5_IB_MMAP_TYPE_UAR_NC:
-		mlx5_cmd_uar_dealloc(dev->mdev, mentry->page_idx,
+		mlx5_cmd_uar_dealloc(uctx_to_mdev(context), mentry->page_idx,
 				     context->devx_uid);
 		kfree(mentry);
 		break;
@@ -2586,6 +2597,7 @@ static int uar_mmap(struct mlx5_ib_dev *dev, enum mlx5_ib_mmap_cmd cmd,
 		    struct mlx5_ib_ucontext *context)
 {
 	struct mlx5_bfreg_info *bfregi = &context->bfregi;
+	struct mlx5_core_dev *mdev = uctx_to_mdev(context);
 	int err;
 	unsigned long idx;
 	phys_addr_t pfn;
@@ -2630,8 +2642,7 @@ static int uar_mmap(struct mlx5_ib_dev *dev, enum mlx5_ib_mmap_cmd cmd,
 	if (dyn_uar) {
 		int uars_per_page;
 
-		uars_per_page = get_uars_per_sys_page(dev->mdev,
-						      bfregi->lib_uar_4k);
+		uars_per_page = get_uars_per_sys_page(mdev, bfregi->lib_uar_4k);
 		bfreg_dyn_idx = idx * (uars_per_page * MLX5_NON_FP_BFREGS_PER_UAR);
 		if (bfreg_dyn_idx >= bfregi->total_num_bfregs) {
 			mlx5_ib_warn(dev, "invalid bfreg_dyn_idx %u, max=%u\n",
@@ -2652,7 +2663,7 @@ static int uar_mmap(struct mlx5_ib_dev *dev, enum mlx5_ib_mmap_cmd cmd,
 		bfregi->count[bfreg_dyn_idx]++;
 		mutex_unlock(&bfregi->lock);
 
-		err = mlx5_cmd_uar_alloc(dev->mdev, &uar_index,
+		err = mlx5_cmd_uar_alloc(mdev, &uar_index,
 					 context->devx_uid);
 		if (err) {
 			mlx5_ib_warn(dev, "UAR alloc failed\n");
@@ -2662,7 +2673,7 @@ static int uar_mmap(struct mlx5_ib_dev *dev, enum mlx5_ib_mmap_cmd cmd,
 		uar_index = bfregi->sys_pages[idx];
 	}
 
-	pfn = uar_index2pfn(dev, uar_index);
+	pfn = uar_index2pfn(mdev, uar_index);
 	mlx5_ib_dbg(dev, "uar idx 0x%lx, pfn %pa\n", idx, &pfn);
 
 	err = rdma_user_mmap_io(&context->ibucontext, vma, pfn, PAGE_SIZE,
@@ -2682,7 +2693,7 @@ static int uar_mmap(struct mlx5_ib_dev *dev, enum mlx5_ib_mmap_cmd cmd,
 	if (!dyn_uar)
 		return err;
 
-	mlx5_cmd_uar_dealloc(dev->mdev, uar_index, context->devx_uid);
+	mlx5_cmd_uar_dealloc(mdev, uar_index, context->devx_uid);
 
 free_bfreg:
 	mlx5_ib_free_bfreg(dev, bfregi, bfreg_dyn_idx);
@@ -2746,6 +2757,7 @@ static int mlx5_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vm
 {
 	struct mlx5_ib_ucontext *context = to_mucontext(ibcontext);
 	struct mlx5_ib_dev *dev = to_dev(ibcontext->device);
+	struct mlx5_core_dev *mdev = uctx_to_mdev(context);
 	unsigned long command;
 	phys_addr_t pfn;
 
@@ -2753,7 +2765,7 @@ static int mlx5_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vm
 	switch (command) {
 	case MLX5_IB_MMAP_WC_PAGE:
 	case MLX5_IB_MMAP_ALLOC_WC:
-		if (!mlx5_wc_support_get(dev->mdev))
+		if (!mlx5_wc_support_get(mdev))
 			return -EPERM;
 		fallthrough;
 	case MLX5_IB_MMAP_NC_PAGE:
@@ -2775,7 +2787,7 @@ static int mlx5_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vm
 		if (PAGE_SIZE > 4096)
 			return -EOPNOTSUPP;
 
-		pfn = (dev->mdev->bar_addr +
+		pfn = (mdev->bar_addr +
 		       offsetof(struct mlx5_init_seg, internal_timer_h)) >>
 			PAGE_SHIFT;
 		return rdma_user_mmap_io(&context->ibucontext, vma, pfn,
@@ -2783,7 +2795,7 @@ static int mlx5_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vm
 					 pgprot_noncached(vma->vm_page_prot),
 					 NULL);
 	case MLX5_IB_MMAP_CLOCK_INFO:
-		return mlx5_ib_mmap_clock_info_page(dev, vma, context);
+		return mlx5_ib_mmap_clock_info_page(vma, context);
 
 	default:
 		return mlx5_ib_mmap_offset(dev, vma, ibcontext);
@@ -4187,11 +4199,11 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_VAR_OBJ_ALLOC)(
 		return err;
 
 	if (flags & MLX5_IB_UAPI_VAR_ALLOC_FLAG_TLP) {
-		if (!MLX5_CAP_GEN(to_dev(c->ibucontext.device)->mdev,
+		if (!MLX5_CAP_GEN(uctx_to_mdev(c),
 				  tlp_device_emulation_manager))
 			return -EOPNOTSUPP;
 	} else {
-		if (!(MLX5_CAP_GEN_64(to_dev(c->ibucontext.device)->mdev,
+		if (!(MLX5_CAP_GEN_64(uctx_to_mdev(c),
 				      general_obj_types) &
 		      MLX5_GENERAL_OBJ_TYPES_CAP_VIRTIO_NET_Q))
 			return -EOPNOTSUPP;
@@ -4265,8 +4277,8 @@ static struct mlx5_user_mmap_entry *
 alloc_uar_entry(struct mlx5_ib_ucontext *c,
 		enum mlx5_ib_uapi_uar_alloc_type alloc_type)
 {
+	struct mlx5_core_dev *mdev = uctx_to_mdev(c);
 	struct mlx5_user_mmap_entry *entry;
-	struct mlx5_ib_dev *dev;
 	u32 uar_index;
 	int err;
 
@@ -4274,13 +4286,12 @@ alloc_uar_entry(struct mlx5_ib_ucontext *c,
 	if (!entry)
 		return ERR_PTR(-ENOMEM);
 
-	dev = to_dev(c->ibucontext.device);
-	err = mlx5_cmd_uar_alloc(dev->mdev, &uar_index, c->devx_uid);
+	err = mlx5_cmd_uar_alloc(mdev, &uar_index, c->devx_uid);
 	if (err)
 		goto end;
 
 	entry->page_idx = uar_index;
-	entry->address = uar_index2paddress(dev, uar_index);
+	entry->address = uar_index2paddress(mdev, uar_index);
 	if (alloc_type == MLX5_IB_UAPI_UAR_ALLOC_TYPE_BF)
 		entry->mmap_flag = MLX5_IB_MMAP_TYPE_UAR_WC;
 	else
@@ -4293,7 +4304,7 @@ alloc_uar_entry(struct mlx5_ib_ucontext *c,
 	return entry;
 
 err_insert:
-	mlx5_cmd_uar_dealloc(dev->mdev, uar_index, c->devx_uid);
+	mlx5_cmd_uar_dealloc(mdev, uar_index, c->devx_uid);
 end:
 	kfree(entry);
 	return ERR_PTR(err);
@@ -4324,7 +4335,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_UAR_OBJ_ALLOC)(
 	    alloc_type != MLX5_IB_UAPI_UAR_ALLOC_TYPE_NC)
 		return -EOPNOTSUPP;
 
-	if (!mlx5_wc_support_get(to_dev(c->ibucontext.device)->mdev) &&
+	if (!mlx5_wc_support_get(uctx_to_mdev(c)) &&
 	    alloc_type == MLX5_IB_UAPI_UAR_ALLOC_TYPE_BF)
 		return -EOPNOTSUPP;
 

-- 
2.49.0

