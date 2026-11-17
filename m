Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.21
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794935425;
	b=e95wJvioXRjkqJ3dvW/SvcKSFG7pspcOqCJP84orUeW//UnFKgWgzY8Icy7RK3+e3FM8
	 MxMNyqcjid6Xkjvf5NGmsWHRlB9OMtiFF588OB13ci++p+29N3jv87CJJfWXUxxNBNAs2
	 kJp29rwrccrURLnM5Z/OJqo9/fV/wPNEnCFuZFaEWI7oFTFRaktusFk85SOM38fW1e4vT
	 pOU6pZm8XmMBKW8Deuf+7nKO5RqMxJKJWjxxx3CUQ/WVzauBRkerRVJpubDYTZVRbLe1z
	 AqUnA7Agz6UBkHyQhH8+yYni/eWR6dQJAnApOU1EYnQOxmMDJ6KDXTB8aFmahMydf8w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794935425;
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
	bh=fbGbnt5YiwcM7ajeUc1BWGCvPs8tXJn+Ia5Hl+utOHM=;
	b=ORKvTUuAScIPPBxuxdGUThMhFsHs+KgYnsVvbmxqJL4hZXHUGaIFKWx4RxsERALdp2uF
	 HiunaP4xECm1giARrGtN+punK+UtZsiDkYoao73oAXmCaemW0FE9Jr1d/5tVOz5Kb8Z2o
	 w4bX6M1XE3W3xtqEWerzVvBb2ZzKxTI+exGoQq5dsTkCG/Yt1JgDbOcXuJXGCsaKyF5/4
	 0nNX/bczvbRCoywOA0NAmk2QpjMhpaT071ewKs4ZixMwrLWWCWaHY+yEL/c1WSudrVSyu
	 qPTUfpEbeHJRZz1scbt1PrYcxpml0T7J29Bl2zVCHV9EieqW4h5JeZvKYjXC+d0iD0A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JSU1iZiP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.21
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012021.outbound.protection.outlook.com [52.101.43.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6EB606A88F;
	Tue, 17 Nov 2026 17:10:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E6EB606A88F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JSU1iZiP
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zBlfy6SBqRsIzFOBecN5Fz9qz7oxhBom7XvNJ7WJ7TWxK8fEOqJxZQ5dtu32MIv3eG7Z2NU2xWZ0NnTwQbmHYn+9Ztit00L4eEfGUET9BGI1B1PUGC6qfbXAdIvebyJ3BYxbirRegR/CGoQdLEmWg4e45IBCW4xTVK38RGK+JUXL+xvDbQ9AsdfZIb0y6t/JdREHQCr/Tp+ppwtQOjdCgVD+Th8R7giYe7EYSc97wJYKp3g15U+4jQnxK6uVzwXTWZ6B2/tTw2Fo59xZO0ux0zevYQhrenjLW/FRIuxQDsLKrgoc1vAfr+AgwNdSblyBudD8UcV72xGrm5D5RQ0pvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fbGbnt5YiwcM7ajeUc1BWGCvPs8tXJn+Ia5Hl+utOHM=;
 b=yP+xeQv+c3bPpE32A493RqDuME5Qi1T47d9diF7EWGHZWOr+LVcAabmbZNVS468KKLjy2e1ygof/KtW4A3qUSSaQdtnoGEUOgJZULlq2N63eRhEJuK4CcUCY9tLS6TeFvJiaIT3H+5EvcW2h2R5NnwrjTSJgr/mr0EGt0nyyjkK76x+pBeDQuAhd+0hxjkcGdJkXKFZUR25Ec/h2jXGwliUB3OLpZ/1fDBdQt1V7lloZ7rlpn3CzTgX4M0pg3lwN5H6z0sJ2PAhXaFqzBzyVK1rC8vuozN8sUr1dSXqX9lPSU42piya+mGhNuwXwNPt3xoI+zRfcltmlP4e4gYafBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fbGbnt5YiwcM7ajeUc1BWGCvPs8tXJn+Ia5Hl+utOHM=;
 b=JSU1iZiPbVZketFYIZ8prfro9XKv//ggz0645KHIJSIEakcjte2fyzEAK9+mnMG8phXAPWScO9f0gJKBj20u4+Vd8+lSFEqrdZ2GDLIzkSztS25x2f7ksydvcavt13TrDcRT1N+o6eKuLnMcTChq0oxVxY+XDy76/j4ZOZBYfPwpahWA6G8x9sCtzbypF5ObXY3XW4M0L6QM5xFGpn5AquKR9xKfR9Xp7hVx0FduR2hga0WPXcbyApS40qE2afBvlCMheY0GorDkWWkWY5QBMCK/TskPSk6/VkCWtRAPQttfLQxZlxs/7NZu4mF7eOy7RHUNZrQiATKxgFy8ouYNQQ==
Received: from MW4P220CA0029.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::34)
 by PH7PR12MB5856.namprd12.prod.outlook.com (2603:10b6:510:1d7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Tue, 17 Nov
 2026 17:10:17 +0000
Received: from SJ1PEPF00002324.namprd03.prod.outlook.com
 (2603:10b6:303:115:cafe::7f) by MW4P220CA0029.outlook.office365.com
 (2603:10b6:303:115::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Tue,
 17 Nov 2026 17:10:17 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00002324.mail.protection.outlook.com (10.167.242.87) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 17:10:16 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 09:10:02 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 17 Nov 2026 09:10:01 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Tue, 17 Nov 2026 09:09:57 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 rdma-next 04/21] net/mlx5: Catch too low max number of EQs
Date: Tue, 17 Nov 2026 19:08:57 +0200
Message-ID: <20261117170914.27410-5-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002324:EE_|PH7PR12MB5856:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b0b8064-5b4d-4114-a62f-08df44cda6ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|82310400026|1800799024|261028144727099003|261102123227099003|261026140227099003|261022105027099003|261021123027099003|261021121427099003|56012099006|11063799006|10067099003|22082099003|18002099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	ufgtJJdSQxV+qx1RINAfvsmXpoXqw67vZ8cmU+yDbJTbVfm2mR/PhKHVH+NJsHGrnqjQTbfDXhrLe1R2AI/oVF1ZrQaq7q/Ax/TIRBFGQs9TiMZJy71DfEaq0vc9sbGaOI2csIMrCmiBlpBCii1Nsf9sO0FqEFeDABuaQZNaPWuqSGiYSyMZpuFbK0kNO0Ztz+jsolRm5ZJtbNEE3M68Isvd7+l4BveU9nhJH6DuJ4nMngH4HCG0LnTyOj4e6ufVLwB6V1R+pumAiSeUMvn+7SaXDsrMbKZmYFtcjaM3AiOusbkiu7llAnsdBLa4CB++cP7lmZItfhe/eW3o4MxLFtUXSidskilBloaXQmhMyDBv/UXTcN8NHr7gq68NkQcOV7A7p7+okQY3yCRBzHaAilSgrYHLHgILtLCCgcItcElm3NEln9nyW7bQRZytUips7b470oAm8lgs6JuIXdK/OSnmShHFq10FfmAB3xzhkv+dHnwdnn4PX9rtlg6lOpn14B/xM3M6mt57YP9bxTnjEUvT7UG5/gh76cTvNzgtsgKdMw3NJk2wv6UMTY2hoEblydxN2cONR2T//RzxnW7a3def5TUKJwmEKmlpopXBg1b40nMfvSw+SgKE801efKhS1KAu9piOt2Et3YI14uO0rUeLDXr9+p033NzDIc3IUHINhCl9FEJPCe4RkScmZyQmAeQRXtTIPEMnzGOPqNOCGQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(82310400026)(1800799024)(261028144727099003)(261102123227099003)(261026140227099003)(261022105027099003)(261021123027099003)(261021121427099003)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+SNt+eSBR+Ol/vXaWDQeANweBUtWzUO2Xby+TElowYSdb5UKKL0e5EGsO2wAz8BRiUr1Mc62gnusLpLSiZrBzjM1x+nILb1IKqT5Ie860MH2LaoBQWjhpXfBs5uVyqJs4EeOOh37D2S3Hj8MWDEYOzprCWJtXrVrk2CqV5Is9DEIaaaZEmjcoOa9ktfX2ihkN5E8pT+ggj0i5YvnTCZXmlT8ocp/b8HcBpR3fHSPp+3Z6Mma5QvZOXgJAtAAUhVJcwA5tovDYJDkV6shhMM4U3Nx+RKOU/9Iwb18mnX6W03uGBrpxvjFosBwR7xq4EZw/zEzYa2BIRBAVD5VSBAH6TU4N9sJDh7aEwarFhndzUpTACxHMLmvoJx/zgprjMiJ5HS65+ZxTrsD+XZRrRAjMr59rNedjtI3cs8XBy9/OOhcecD6WcDIclz1nycpabto
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 17:10:16.9229
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b0b8064-5b4d-4114-a62f-08df44cda6ed
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002324.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5856

From: Dragos Tatulea <dtatulea@nvidia.com>

get_num_eqs() can return a negative value when an adversarial FW reports
fewer EQs than MLX5_MAX_ASYNC_EQS. Return an error in this case.

0 completion EQs is a valid count, e.g. for an SF whose max_io_eqs is
set to 0.

Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index d11ec263d53c..b34670eb037c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -1195,9 +1195,13 @@ static int get_num_eqs(struct mlx5_core_dev *dev)
 int mlx5_eq_table_create(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *eq_table = dev->priv.eq_table;
-	int err;
+	int err, num_eqs;
+
+	num_eqs = get_num_eqs(dev);
+	if (num_eqs < 0)
+		return -EINVAL;
 
-	eq_table->max_comp_eqs = get_num_eqs(dev);
+	eq_table->max_comp_eqs = num_eqs;
 	err = create_async_eqs(dev);
 	if (err) {
 		mlx5_core_err(dev, "Failed to create async EQs\n");
-- 
2.18.1

