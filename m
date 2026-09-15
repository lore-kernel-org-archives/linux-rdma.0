Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010056.outbound.protection.outlook.com [40.93.198.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E300367B87
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 14:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789481517; cv=fail; b=HJjj/rACqN9GQwH1iVxv1zNqabny/3BSPeeEBn+PBwG/Kt4WRY13eWwQ4MhnegOT9QzJ/7yAs/Dw4D7A4nZxxY3dyBYvAVR0BdcTFZnoB6UnuregUoa6AWmEbwX92wzLMnbyfKfiGDFd9Ju4niO1hfX+650OOouXthZAMU7bBBc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789481517; c=relaxed/simple;
	bh=SCJcjuaO51uK7m99C7VQ0X/OdRlU2zhcaUJf69NYizs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=drnqVikCfPWXDEvfwPJcJtzDmUIsoiOFvaoBF6ZGNU/sEjF8OmniA1JA7aL5G5DFG3cJgdIBrsaaUfS6sFY+CQWMMdKVnmdNsx/Lrq1TFveCl9xf/vnXmyRgyZz5qYMMtAikfh0IyPqXmWaa2qUMHswEtuQWr75t76q7aSnKJCA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UVxn1SSc; arc=fail smtp.client-ip=40.93.198.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UVxn1SSc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LmWcrYWkGzFlDkPAcz2bSPsCkfRlUo55yo1NUhTNxuDuwknGZ5LhYA7GQtGLbcZ36D2Y0SeNa3tWxvp1xB/j1OgAfOfbXdSjcQfvP2jDeCFk1QFl5H5kAk8gQkNxEAKCjwhwt0ckz/pk79V/lv9nO3Wao4DcmAi8LS1nbuq7iF/s2nSadJG4809aPkGnxdFcKkqCttx1lC9d3ED8xizNRIPTFvZlaBQlbATfi+Kt7gkZqHLP4tQ2W8YCk1hCIrkzdThzB3mpBckQWMfcI1IFFrjvgUBxzDnrJHI2Kakx3UAVGcXnknsO0D/2IftfUV6TcKp5N6j9tCHA5ncM08CXOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LN++FBFLjYm1Qb981CJMun/eko5gY93UklR395sn/2g=;
 b=kbcecEiBBoIh/RydPqg3pzccpx4AGLAOqdYDZf/nTxf4MwUbvnVX5HdkwTMbuHUbkLoxiwX/ZQZv7tNYnODKFwwwwJmJe8UcljYEROBSLm/M8VocUdYWvtJKybt8qRh+f86KnEZia7VHeW3hkGExvVSOIZIExbumwtZGLogGA2wzhnlTW2TavvQzzkIyZejfyMp3RcxcGwjEJnrV0Fw13ORnl0wLVUmbGhFCOECUArT9fBdW1EkaTY9oNEe7BdXzabiza7CL+R3o07tD/E+uFxg5Pe3YgxN/1u6nXB7oLrl6pkFbjvr+nCya/ocGfvN7BKT+KCew/Ksc9U4sSWRm4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LN++FBFLjYm1Qb981CJMun/eko5gY93UklR395sn/2g=;
 b=UVxn1SScYtg2OcU5NWLBGuca57RSLRMXpZNi5NU8IcgRbXUN9SeOmPX0AZ1y/wABoDDFNcO8KL9tUZr79NGD0aEWIKKVKwAOU63RDMqAdO6QPuF9XuuHgbYXXQGyi/UEjywOOkN6MJ0CIpisAcR8uUyzl8SnKle3UfLcivDZ+/1elPJBe5/m8wHor5X4EP353dtLz8sfUtQtiSWvfmGuvFECvDKdLGMZIiSxdzfgYey3/TTuQ7ymDEXNgHcl5fmQr9IrS0XnfQhInUp2krdWR8p81jJQMEOTFz0I409QhYlGyysK2n1fxXiBrjnUKJ4fICwSZfy9SVhPXjAWOrqgfg==
Received: from YT3PR01CA0064.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:84::10)
 by SJ2PR12MB7846.namprd12.prod.outlook.com (2603:10b6:a03:4c9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.10; Tue, 15 Sep
 2026 14:11:49 +0000
Received: from BL02EPF00021F6F.namprd02.prod.outlook.com
 (2603:10b6:b01:84:cafe::18) by YT3PR01CA0064.outlook.office365.com
 (2603:10b6:b01:84::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Tue, 15
 Sep 2026 14:11:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF00021F6F.mail.protection.outlook.com (10.167.249.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 14:11:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 07:11:19 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 15 Sep
 2026 07:11:18 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 15
 Sep 2026 07:11:14 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 14/15] RDMA/mlx5: Initialize QP/RQ/SQ resource refcount before publishing it
Date: Tue, 15 Sep 2026 17:09:32 +0300
Message-ID: <20260915140933.40580-15-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20260915140933.40580-1-yishaih@nvidia.com>
References: <20260915140933.40580-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6F:EE_|SJ2PR12MB7846:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f5dbaf0-0ab6-438b-cb41-08df13334860
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|23010399003|36860700016|7416014|376014|56012099006|18002099003|11063799006|6133799003|10067099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	41n0RIH9zPM1A/qRognz4KGx+4Ub3bgFQCTfPaNbVOgCvBKz3IRbCz//0XyL1+QBwJJsWsj/Ok2eLGQszJijVmaMdq15VDc7L5K6HXYUNDTFku5M2bl6HxBvyiwyrWQxpc+2KVTgrgGW3vvA9dPmayOnDX398k8BY2loK+iB3S9KhGFuN43jVsZHzJMxsrA+PMwM6jA37xhaiUtAwa606C2lhi7JdG+nmJLxs28UxumuYYRjDrfo+5FPPM5Z8+U1nyzwHQgK83YU8EiweFx5mH9e0WPadYNQEN25igaU6wlH2dyMwniVMG540Nm02hEKpG07/1NelCw0FHyziSujhUFlyBflD6SUUrpzcEoYpiRLS2KvsPERYaHulNoF306NMtUzUT6IzygNNM8X7I4txq7zDzLL91A6EVGHYFLGlWRR2Suw63636UJEsXPZ85Qpjk+1RDnoXd8TLqVxH8vJCxXphgjwiyYvkJukkdpCMwX/fBEdMNv4qaeCq6fDbfi/YLT9K+Ze8pGdXgIyNc9taT65C6lS0XfEdrgH2nfR593Kf20N83jv1nn+NUPtcBNtAs07lTdiO44KuISn8TAQIaIdTcvU4ChFvHG5WnbTrjrSZZlHWTSdTRC/hDX44F6oljcf/u8i4rBAd4WFPSBsjwsl7xFfAsbeRnNlhj8uXnzdrcYOmBcJ7bLRip2yfjaQuBeuSezVAGGyjhfnUftE+Q==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(23010399003)(36860700016)(7416014)(376014)(56012099006)(18002099003)(11063799006)(6133799003)(10067099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	H8cnXuhbAiD7XBgTCG6JYowrqtna97dOG9w357bjFR4Y8XwGb4gPw8HlzDBTUgPIl2eTUqVtNNiZPgsPgy7L5KlFGPwvnn6tCMS6VKvcAN6itFc6RS797Gwl5pz63cMHG92LrwRrXwO42LJR5Re+2msCH4OHXGmf95dWyUWQTuA4xYzAFSXjY5caM7W8/+YCgfx2hTb+ibBnw3wWmzZYkIukow9GjC9ORCcdQ7BTg5SRGNW21sI8mPcJY5Hy8aLTAdRJosOiEeDKVGCuYWjZhEwkAiqV+qqq/pIv//kifx517woDWDfFzCkWIErotsvmSR47BssqK2CTP4TPf1ZTcPieNV2z+fq5J8e9bYrgHzucFXt5m27na3U0CuCEdnx9or+iQP8rQ0SvILibyNDbCgUkdfDAcKDy0GwB2/JdC78MSHzIu+e3DMhBnPFNPhsm
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 14:11:48.6630
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f5dbaf0-0ab6-438b-cb41-08df13334860
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7846

create_resource_common() inserted the resource into the radix tree
before its initialization was complete. A firmware EQE in that window
finds a zero refcount_t and calls refcount_inc() on it; the refcount API
treats this as a use-after-free, saturates the counter, and permanently
breaks the resource's lifecycle tracking.

Move the initialization before the radix_tree_insert().

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/qpc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qpc.c b/drivers/infiniband/hw/mlx5/qpc.c
index 77ddab666ecd..8b5bd33a7f0f 100644
--- a/drivers/infiniband/hw/mlx5/qpc.c
+++ b/drivers/infiniband/hw/mlx5/qpc.c
@@ -167,6 +167,10 @@ static int create_resource_common(struct mlx5_ib_dev *dev,
 	int err;
 
 	qp->common.res = rsc_type;
+	refcount_set(&qp->common.refcount, 1);
+	init_completion(&qp->common.free);
+	qp->pid = current->pid;
+
 	spin_lock_irq(&table->lock);
 	err = radix_tree_insert(&table->tree,
 				qp->qpn | (rsc_type << MLX5_USER_INDEX_LEN),
@@ -175,10 +179,6 @@ static int create_resource_common(struct mlx5_ib_dev *dev,
 	if (err)
 		return err;
 
-	refcount_set(&qp->common.refcount, 1);
-	init_completion(&qp->common.free);
-	qp->pid = current->pid;
-
 	return 0;
 }
 
-- 
2.18.1

