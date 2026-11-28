Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.12
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795870927;
	b=L/fJsxQepa+17h5vypJXSd80T7xAL7PbYGyZSZYgFrS0f81ShXEX/eipJNZSGAOdeXSx
	 ZZvNmIlLx90AO4r68cSm1sACZ8TDfPcqPBLKp7YQzpfwFNWhI/lGPVXsHqbxLMyTfEFt7
	 9jmYp6zMdRLDdd/OH4o5PqXGBhjRrePagJqyDphtRtgHC+PAPtCgnYxohAqJHO41D1d8+
	 tyOu6LLX7o5WjtGNX2Z8sETL+fqjygs3vGx+GIXLuqPTVHiotutSWnk1imi1YNfyhjZwM
	 g2LnD5J7NWzo+kG1vgpBCdC6nHqDvVwZrRl2cwECLW7J6QgJ5Vlk4hRCgUmdDhlxEsA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795870927;
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
	bh=kiekMkZhfF0m+/MddKf+/JZxKUDzijTmVgYHYBZ3fWQ=;
	b=w5hjIJ8PxhicbWJu3higbCHsyJaR+52DPkFR7O/eekVQVaJy7oya9PF0GxSKLOdah1WC
	 AhYHwsKZiT20QxejvHErXQPpDV5asOgYlqMTriRjbRX75Otw19lmD3uh4tAM+IxCg0EfG
	 8pzP9ER2qbdugGY5nG4xNET6aMVQOVyLUmK4QBHVvNpeTFH8R4wfohuZl7yDmN0WjdfaA
	 Ga3ruvzNptHRGVMY4r+s5uBJ/wlyslK5DIciXrDVf9wIbpS/JtbLb/VyJBLAYmH1xQqQS
	 Cda5P+4RueIzQB8PwynmRe0VDRkg0P1nUZ+nFJzGMRKvIIJz9LHZEC1JqAy5w7OsNVA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=KcPIlA0T;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.12
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010012.outbound.protection.outlook.com [52.101.56.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76D9606A32D;
	Sat, 28 Nov 2026 13:02:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E76D9606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=KcPIlA0T
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e4X5d7DTQdxR4CojTzNTjI0geQLtN9ekszEh2za6afgeq3ZcJF+160JS44wTwGNOxEM+KwvwhicKWs+aCjkT9+3ckgZk9GunKl8ROzEfIZ+PN3RS5qLylHwPCn6M/1RKNtwRoQebsInRP89dDQkvtT7nRQIQDR8Nb+GiKpEknb5ubIgeJgLY6cRXU80WL2h7eXJnomw8Ic/C34y83v7AOLjNZTQRc4iyHcuHrQsO0/Ng7nRy49wqVmhmR340y/suNvrQW1qUC0uY1CYwBVOLPgoUUB03pSwL3JiA2Ib7nngAiaGqh93LQXE+C1oAZmwNQl0w7GwuMvpPmpoeSaJgTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kiekMkZhfF0m+/MddKf+/JZxKUDzijTmVgYHYBZ3fWQ=;
 b=XigxzDg+PiPRAPy7yxGXAVH2SWUdjWahysprXRLaWD8BmfnVkOVabQBxCS7I9bCeT9Tx4/UA6lcqnfcoafliOsQOrlB2DHYzfdiJktjPsrmoXlnU5x5//6qUmCCOOzEoFeGgojIXzl/GQ9rexP6SSsXfklU1E37I2s6rVBTJIl4aQQPvtk2ySD8pXpvA1IvztaEe+Jt57v6UFDWBk5RWuqUVI3XGA+ggemhXa8LyuIv3srzBhImQdJqwaD/tC5KQzn83PQjL46/fhx4A5itUnQb4S6bm8/9JSOwNAd2ENlkRuocibmF0EBVzy6n4TWlEBFZ78YX0QsA4hfV6vIIVBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kiekMkZhfF0m+/MddKf+/JZxKUDzijTmVgYHYBZ3fWQ=;
 b=KcPIlA0TyKIZSkEOHVkrSPvzoxBYgB1eEPV+Foo4wCLTYGdSHp2DcDMQl20pRHoRPpcXXXyRRccnv52UP3KRUizZHyt+0DHPbnOw89gGcqJx9abovLEb9DRyH7WRgZ7CHDR18RPasBztN9JPqQHjHy/TCN5ZO52lBkOuHkhXRFkjjVOAdPpQ0H35AjWtDheyTQiiQGf1tOXic8krnMBZmHFxZ0rPLBEVT4jg8+6pir3kJBjYR2TwLENK2UsawyHeI/53UD+S/j+KdXdTGKatugT8aO1N5+A8W5Ib3WjHTXf6qsYdavBSCUAj5zKGq6/VIQETIBWoGnJfvaWfJhHPMw==
Received: from BN0PR04CA0075.namprd04.prod.outlook.com (2603:10b6:408:ea::20)
 by DS7PR12MB9503.namprd12.prod.outlook.com (2603:10b6:8:251::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Sat, 28 Nov
 2026 13:01:57 +0000
Received: from BN5PEPF0004698D.namprd02.prod.outlook.com
 (2603:10b6:408:ea:cafe::85) by BN0PR04CA0075.outlook.office365.com
 (2603:10b6:408:ea::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.11 via Frontend Transport; Sat,
 28 Nov 2026 13:01:57 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN5PEPF0004698D.mail.protection.outlook.com (10.167.245.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Sat, 28 Nov 2026 13:01:56 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sat, 28 Nov
 2026 05:01:48 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Sat, 28 Nov 2026 05:01:47 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Sat, 28 Nov 2026 05:01:45 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Sat, 28 Nov 2026 15:01:24 +0200
Subject: [PATCH rdma-next v2 11/11] RDMA/mlx5: Resolve UAR and mmap core
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
Message-ID: <20261128-mlx5-sd-prep-v2-11-751878123711@nvidia.com>
References: <20261128-mlx5-sd-prep-v2-0-751878123711@nvidia.com>
In-Reply-To: <20261128-mlx5-sd-prep-v2-0-751878123711@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>, Akiva Goldberger <agoldberger@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795870878; l=19971;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=8DJWUMDC5XnAa7R6BVipjq79IJJ8HAaEt2waB0JwE7Q=;
 b=Ioc9FJ/2uzkYi7OpcrBgv4qxVqHq4OLTm2lltXybZD7LfXofsU29v2adCLgwoDFAjzazTHvIs
 Y+qV304aQGmA5+amI7HwMrCIefkO3flu72vMABFxa5oBYE3FqNuQSMm
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN5PEPF0004698D:EE_|DS7PR12MB9503:EE_
X-MS-Office365-Filtering-Correlation-Id: 6aee147c-d211-4cfc-df20-08df4d4fc87f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|376014|1800799024|82310400026|10067099003|56012099006|11063799006|261028144727099003|261022075727099003|261026121527099003|261026140227099003|261021123027099003|261102123227099003|261022105027099003|261021121427099003|261009223027099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	ng2m9HwOmNLCL7CarC4c3IPLTUgC2OPnumMQcG6WdV61jq+2OHiCTgLYQJdl5wUb0RwipT4GujTJ5YCnvY2hp8h7AnEybP1D3w9ChKdWyN7X9s07jkr4uNb4G0qjW5TH1TDIDfuC83WmB95w7/3Nd5hhXCAYcf+laJdZ6R3aG30W3xTMA/5X2tbMZcIJHNwNu5fHmNqg4HSbCbmrmTh5vtZLOlEBIXa6O42KF5HPPHtmjMIlJy/vW9G4RW3CsvFRQkNHeL2z4SdxL/m2ORzOaoMhwpC8AEUU3sUkL8WDUipwbe7g3XhC5S6nNVZGvbOGdjAZYRnfPSkRcBBFg9WzGpvoMT3KY3EDlJvJnz+CAPtG2sFQ0SuhxZ+rwXBqY2MVZG8s+aMDOSHIkPa3NTXxc9MMdc39+CqSqq1vXGVKcZUin4hOdYMtlk+cD9BqZ7j3HiOOcsuymzAmlCPSO4j54Sg6oYGLLXTB7t/BNSfMpP0BjMEUSzeTs29wmJFAglHn07RrhUUU62fp1rvQKW6T2MTbD1ON8QRWROd2JM08hnN4aLBJJXbBWnY6Rbj4v0Pf3XAo4/d7dBtLw98cvmnkRsJkJ8pe5OLiOsqMO2DEfrTXGG5xxDcqbdFyGcaQrSxd/vsag+hmF69aa12bPN9FPtjcFOvwQw+J2Q8RVV82gNhwM5Vww6QrYeuDHIU+PBz56HZxXDQce0A6hIzM59K/Rg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(376014)(1800799024)(82310400026)(10067099003)(56012099006)(11063799006)(261028144727099003)(261022075727099003)(261026121527099003)(261026140227099003)(261021123027099003)(261102123227099003)(261022105027099003)(261021121427099003)(261009223027099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+qbZzf9uUiMoZiwjBOYMKb47Xc0cydvH0AmWSr9Gx9jW+rGX+ZZ8G44AaAeCaaB4zhhjBoS3lf9YFnrIvtKoDxr5zczrO+NE2c+TlO2M1rv8SpECBFSfgeChAUUACBytL9aAoF0B2xJ4trtlOOlyhdWu790DcX3iDlqutXrgIMnx8QNS1UJJmnIAuESvwpZ1rrpcP5RFeXtujCtU0ccwc1kvNMnkn4RN++ynFTBNKNJwEr2GdQDvk04s2oxazLbUK12wy8M/BG5I/YGnRpTsDjdhbN6MRhwPYQh5H8B0L0NDshRhUlpcTlON30YbY7GcaF9lRAJ7smp19n/Au6tF8dVB50XMVx+Y36W/+lNHMORq3ZyUkvAPusr0vqoBeKxde1UD/FkhVF/KbJFAi1iYtRNAgFdCMMs7VGmgDiCJJZLbYxuHE6ZuMj4IqsRS8JC+
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2026 13:01:56.9469
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6aee147c-d211-4cfc-df20-08df4d4fc87f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN5PEPF0004698D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9503

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
index c56968ff31f1c5a9fe6e85be81ba9f013a08eea7..81f8498a924639fbb5758d63e54625e1566f1c18 100644
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
@@ -4290,11 +4302,11 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_VAR_OBJ_ALLOC)(
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
@@ -4368,8 +4380,8 @@ static struct mlx5_user_mmap_entry *
 alloc_uar_entry(struct mlx5_ib_ucontext *c,
 		enum mlx5_ib_uapi_uar_alloc_type alloc_type)
 {
+	struct mlx5_core_dev *mdev = uctx_to_mdev(c);
 	struct mlx5_user_mmap_entry *entry;
-	struct mlx5_ib_dev *dev;
 	u32 uar_index;
 	int err;
 
@@ -4377,13 +4389,12 @@ alloc_uar_entry(struct mlx5_ib_ucontext *c,
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
@@ -4396,7 +4407,7 @@ alloc_uar_entry(struct mlx5_ib_ucontext *c,
 	return entry;
 
 err_insert:
-	mlx5_cmd_uar_dealloc(dev->mdev, uar_index, c->devx_uid);
+	mlx5_cmd_uar_dealloc(mdev, uar_index, c->devx_uid);
 end:
 	kfree(entry);
 	return ERR_PTR(err);
@@ -4427,7 +4438,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_UAR_OBJ_ALLOC)(
 	    alloc_type != MLX5_IB_UAPI_UAR_ALLOC_TYPE_NC)
 		return -EOPNOTSUPP;
 
-	if (!mlx5_wc_support_get(to_dev(c->ibucontext.device)->mdev) &&
+	if (!mlx5_wc_support_get(uctx_to_mdev(c)) &&
 	    alloc_type == MLX5_IB_UAPI_UAR_ALLOC_TYPE_BF)
 		return -EOPNOTSUPP;
 

-- 
2.49.0

