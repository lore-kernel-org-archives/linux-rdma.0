Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.5
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794924147;
	b=y7JY5jVdWsG/n91835cuktXna+fTsPHG02xOhsLBfAf8ymzLUnkYXoIykIk3LjyXVZ+N
	 qVaI+AibQMz8FLyY7pDfTZ0yt2/Wb2ncTajZ2fpzSzwzl8X8So8vQAYFyoF9FZiNUNk7m
	 xn1IBpdlJSsv2eQWen2mGlaFis8LP0DIRKM0PlEbogC5QQDva37jnz8UxNqfE8rkxChj3
	 wD1pPzr/GGFbC/hdOtJIFRbZu1qTeLN1fbEHwG0UycjBt1eFP/QnNnX7tneL5brwdICAu
	 oKiD8DsI0echvFAmOAAS69ub2dHTSDTAyGRoo9c3HcSKLyoXOH7U8i0PHJx9AlEDVuw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924147;
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
	bh=4P4J0l37Wppak5Ps/I1UjdRcku4LnHEvG8V63i6DRnc=;
	b=T1vmkFRMGHXawFvjzACoNmlV4DOBpAC0D2V54O4Cr2htn+SSFWewAb1z+5tnh3NIue3E
	 1F0j09M5LR5JoDq9AWLVO0pizHLevgV81QangZD1g92OMPxOwzN6Tiy4QUCGNvbCsBTbj
	 C4VN+LWnr49AyTs+bP6WNFDrr1++geG09Isx5g79G56FgzIyqJI6oDSfMVf3nZDsU2hMy
	 x4b3jkqXI4Ae4oW8BOfKxVXDX4kXWsn3CN5YS+0LdQmEWKggbKHOnJDW+gFo7p6cEn3+L
	 mK9k5r9axmwkKlOyf789PwNsBriMaBZXVbb/J2uAEnlIzAh3vUstm1/MxwsNG70vNIw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Vq4YKb5Q;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.5
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010005.outbound.protection.outlook.com [52.101.46.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4039C606A8BE;
	Tue, 17 Nov 2026 14:02:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4039C606A8BE
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Vq4YKb5Q
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sbdqfV16qkaIwOtyE8F7CgJxZAse+TN2IKWZ3uBPfZExTLdCai+WPAAuNzHxp3BudGN2M4/wjfCVOhttdDKr14ypEYRT4AoFb970LxLBSL385p9EjN0xfHU2JTOvF408oP2H57jzWsmYTRbnCO6uI65aYH/jaqKdOygef9RLrm5posz8bwUPbZA2pOHFtIRkNMPUN098mV3git4z2FiooGTH8Xo9RiSkK2ltoPkN96CNGVPOdvQ2v9iAXgTXzojwhO6r/McXd7U6IyZ5xl8G36LnO8L+znVUAUd+h4hAfK5ZZBef28XvwOHgGzgAMOCsrT5fcrhTbhnQWQAlb1CwCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4P4J0l37Wppak5Ps/I1UjdRcku4LnHEvG8V63i6DRnc=;
 b=gAHcB+nJqLA+7BorV2On+QDdKxECIuSXIpWnnRgFGO1O3IXh32Tt7lItjmL/dScG4W0DQY1pG72lCJLS4DFq/RKX4dk3joAs8cVG0LxZNE9HifEPy7ij26czrGG3HecOfmcQnGkN4IFBVzsfASyoSfsHUQQgQHSpM/pTWWL3nZ3VZ/e0Q5DAkib/mQwTL8xvMny6ZfudFRnJwZCDur4YC/6eLVu9WTKOR/hFosQSfUhIWPnazQBmfwkOVGuz8sdWlq1YyFh4Mv36x6VwbE/wv1JXBLl4lQ3mfA1hY2iivknf6gbkCEJgANEuqmCqOp3qIaR75SHSvjmJ/+9ChtqWCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4P4J0l37Wppak5Ps/I1UjdRcku4LnHEvG8V63i6DRnc=;
 b=Vq4YKb5QhrdHRqWTp86ODRengoOLlNKArnXphSGNtCtuj2L1t9Gz3/BPocnoTSbveDa6FZBexZPpPA8GIEZJnRAOed/HMg3JFL/sN0NK1aFI4R+fwpNsOj1YFUmPbDjXgmzeqObr5gjXrXLHR1Nywzq82Z0xgkjoudvoCUnqTv9AZnVgGQ4UGeqb0hC/iK/JXnA/fdP/trsOJCO7aaN+DxUqX3H0/fTqus6bwzqyqQ3C/fR+J9qGc9xgxj4KRbByf2055tYkDkU2ELsMXOQsmEiIcSJm9dw7+JCJxW9CQD5MUSojrMC0XGOoANg6i9ZliuabrJo4qg8V3w9GqfJPoA==
Received: from SJ0PR13CA0201.namprd13.prod.outlook.com (2603:10b6:a03:2c3::26)
 by PH9PR12MB497784.namprd12.prod.outlook.com (2603:10b6:510:411::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 14:02:25 +0000
Received: from MW2PEPF0001467A.namprd04.prod.outlook.com
 (2603:10b6:a03:2c3:cafe::16) by SJ0PR13CA0201.outlook.office365.com
 (2603:10b6:a03:2c3::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.4 via Frontend Transport; Tue, 17
 Nov 2026 14:02:24 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MW2PEPF0001467A.mail.protection.outlook.com (10.167.249.187) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 14:02:24 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 06:01:49 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 17 Nov
 2026 06:01:49 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 17
 Nov 2026 06:01:46 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Tue, 17 Nov 2026 16:01:21 +0200
Subject: [PATCH rdma-next 10/11] RDMA/mlx5: Resolve the bfreg UAR-index
 core device from the ucontext
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
Message-ID: <20261117-mlx5-sd-prep-v1-10-8efd124c7895@nvidia.com>
References: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
In-Reply-To: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	"Sabrina Dubroca" <sd@queasysnail.net>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, Edward Srouji <edwards@nvidia.com>, "Akiva
 Goldberger" <agoldberger@nvidia.com>, Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794924076; l=9455;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=AUwGjiXZ9xTwXv4G//6GFuZmeXpGHo3hLuJy7+8uayg=;
 b=RZAiZcoNODKMGIaVhijazbcFMsUQFccML2PpxRNB7TLRtvljMKiZJbXrtWQypWA39IOIOZoIm
 RxqT/WMK7LCDw7IcqS1RjP8N9P+ahsh4Cse43EQ470kJ9aXBnvsoJDS
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW2PEPF0001467A:EE_|PH9PR12MB497784:EE_
X-MS-Office365-Filtering-Correlation-Id: 67c931c7-9f02-4652-a875-08df44b36836
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|376014|1800799024|18002099003|22082099003|261009223027099003|11063799006|56012099006|261028144727099003|261022105027099003|261026140227099003|261021121427099003|261021123027099003|261102123227099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	gFa8fXPTXmSlSkd7EzZ1igyq1XH80Evzsx9nrx9byTHif1AO7VX9hIaCAqF52Kk9k58p1IL0hZlc2iMpKZR18fr5H+aq0x1hc470X2GNnC5nvh4kvjRBHPtO7XAKdVM4CYjmz/Zb/KJOLomlykhGzaTnyaNbP7RswdrMSSdR7x09af8E2wf8UM+RPm3XZuBL//WSxNXKij32zRyzgmzCMCIUvdHVM/SnRfrgwg5kgmUt2e9qnsx8SExIfHKONw4F9HgeA/QtB1xs1L47kYUA2JcLdZNgC7HqFYUanYuYfS+P0fhYUojDt3A5LesiUfa40aS2s4TktHUZDZIrrSxbcHmSo55KdMko3RWinYHXvRCPGjGvePCNOLlmcU2qFNXxD1LKo2mmNvMyXrYZcTtSlC53ftfo9SWzPE1OVB1av+E3veueCrKk/ek6p/EzZeR/tZqhRSDjdn9YWNSOsW50ruxyqUzzREs/COssUDc/1gNuNh252VkTL9qNv+4dudQDdoChS8qVWAd3cCrUvB8hSPmRnBu5zPhSU323K140gflGfG988wz/Hw0wo3SfMCfwJKVA0DQHAsRLV4CY9vbMSXg1jA1zkbicsBzRh+YB+Bxi9I21TaSev4cucV9/guE7DvZT2kp0f0eSucFTmRB2JZamztLBHWQJ3zTOQpuIlzV1mgblUChmr3EBMW2hoAOhiEmohnw4wffPJAg1A9mIrg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(376014)(1800799024)(18002099003)(22082099003)(261009223027099003)(11063799006)(56012099006)(261028144727099003)(261022105027099003)(261026140227099003)(261021121427099003)(261021123027099003)(261102123227099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tZUlpZbcBTRsZ39WZC2Kss7/vyzgbSbgusm6hM896zw+T+lewGCUC+t65zRKkj0bN8n8BcfNWAJut7j+555uPTWRsRdRAPJLLbS+v03iVi4levbQxGrqPkYY8ByRKjYXfjEdlxPYkl0kjvzlDBwkQ3KvyDG8gnjcDpzjc2p8S+uE8hEsF2De94cTjC9uxb0HVfBMEzGORGMqGqLFj4TP9/ltKBdpK9/qbsUdfpheCQRDR+vnibbgoH7WQT/OoOhDzNtWHjjRvnCVZ94fGBtMIfk1xUJg1l0rbqnTynv4qCVRLlZumiU7/62spweGezSBRN87TUHKMdGg7at2//C4Ztr/4RWx9e3xav4JUQ02VBM2Uak0Y1So7hG36VTThIUqGVqHvBJHLyK56uFIrQs53UgiZBKbLmHWr9uzqKQdpK/Ec21nWSAZRicYqvAp06hZ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 14:02:24.7344
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 67c931c7-9f02-4652-a875-08df44b36836
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MW2PEPF0001467A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH9PR12MB497784

From: Akiva Goldberger <agoldberger@nvidia.com>

bfregn_to_uar_index() and its get_uars_per_sys_page() helper took an
mlx5_ib_dev only to reach dev->mdev. A bfreg is allocated on the owning
ucontext's core device, so take a struct mlx5_core_dev and have the QP and
DEVX callers resolve it from the ucontext via uctx_to_mdev().

No functional change.

Signed-off-by: Akiva Goldberger <agoldberger@nvidia.com>
Reviewed-by: Michael Gur <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/devx.c    |  5 ++--
 drivers/infiniband/hw/mlx5/main.c    |  5 ++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  7 +++---
 drivers/infiniband/hw/mlx5/qp.c      | 49 ++++++++++++++++++++----------------
 4 files changed, 36 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index d0b1876f9e8afc6de57f7db1631327bb7c9b91ba..c0314288c2a4f86bf9f7d3f2f314574c73d3bc63 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -1076,20 +1076,19 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_QUERY_UAR)(
 	struct uverbs_attr_bundle *attrs)
 {
 	struct mlx5_ib_ucontext *c;
-	struct mlx5_ib_dev *dev;
 	u32 user_idx;
 	s32 dev_idx;
 
 	c = devx_ufile2uctx(attrs);
 	if (IS_ERR(c))
 		return PTR_ERR(c);
-	dev = to_dev(c->ibucontext.device);
 
 	if (uverbs_copy_from(&user_idx, attrs,
 			     MLX5_IB_ATTR_DEVX_QUERY_UAR_USER_IDX))
 		return -EFAULT;
 
-	dev_idx = bfregn_to_uar_index(dev, &c->bfregi, user_idx, true);
+	dev_idx = bfregn_to_uar_index(uctx_to_mdev(c), &c->bfregi, user_idx,
+				      true);
 	if (dev_idx < 0)
 		return dev_idx;
 
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 0d9ef66765c6894b76067593420dab0350d9847c..50d0762db3d5a7007e6b44507fe56964b469d65b 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1916,7 +1916,7 @@ static int calc_total_bfregs(struct mlx5_ib_dev *dev, bool lib_uar_4k,
 	if (req->total_num_bfregs > MLX5_MAX_BFREGS)
 		return -ENOMEM;
 
-	uars_per_sys_page = get_uars_per_sys_page(dev, lib_uar_4k);
+	uars_per_sys_page = get_uars_per_sys_page(dev->mdev, lib_uar_4k);
 	bfregs_per_sys_page = uars_per_sys_page * MLX5_NON_FP_BFREGS_PER_UAR;
 	/* This holds the required static allocation asked by the user */
 	req->total_num_bfregs = ALIGN(req->total_num_bfregs, bfregs_per_sys_page);
@@ -2630,7 +2630,8 @@ static int uar_mmap(struct mlx5_ib_dev *dev, enum mlx5_ib_mmap_cmd cmd,
 	if (dyn_uar) {
 		int uars_per_page;
 
-		uars_per_page = get_uars_per_sys_page(dev, bfregi->lib_uar_4k);
+		uars_per_page = get_uars_per_sys_page(dev->mdev,
+						      bfregi->lib_uar_4k);
 		bfreg_dyn_idx = idx * (uars_per_page * MLX5_NON_FP_BFREGS_PER_UAR);
 		if (bfreg_dyn_idx >= bfregi->total_num_bfregs) {
 			mlx5_ib_warn(dev, "invalid bfreg_dyn_idx %u, max=%u\n",
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 61c663c7bfc9cf20b3b40dbb8aa4f621fe1d8ea8..b77a8eab6b9e672beafe55162b3cb75cdeb910c7 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1648,15 +1648,16 @@ static inline int get_srq_user_index(struct mlx5_ib_ucontext *ucontext,
 	return verify_assign_uidx(cqe_version, ucmd->uidx, user_index);
 }
 
-static inline int get_uars_per_sys_page(struct mlx5_ib_dev *dev, bool lib_support)
+static inline int get_uars_per_sys_page(struct mlx5_core_dev *mdev,
+					bool lib_support)
 {
-	return lib_support && MLX5_CAP_GEN(dev->mdev, uar_4k) ?
+	return lib_support && MLX5_CAP_GEN(mdev, uar_4k) ?
 				MLX5_UARS_IN_PAGE : 1;
 }
 
 extern void *xlt_emergency_page;
 
-int bfregn_to_uar_index(struct mlx5_ib_dev *dev,
+int bfregn_to_uar_index(struct mlx5_core_dev *mdev,
 			struct mlx5_bfreg_info *bfregi, u32 bfregn,
 			bool dyn_bfreg);
 
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 01babb9a0003abe2520200fcec2e9eb9224516e7..98bceae575724ca7a25936a1b1094f5801ffbcae 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -715,40 +715,43 @@ enum {
 	NUM_NON_BLUE_FLAME_BFREGS = 1,
 };
 
-static int max_bfregs(struct mlx5_ib_dev *dev, struct mlx5_bfreg_info *bfregi)
+static int max_bfregs(struct mlx5_core_dev *mdev,
+		      struct mlx5_bfreg_info *bfregi)
 {
-	return get_uars_per_sys_page(dev, bfregi->lib_uar_4k) *
+	return get_uars_per_sys_page(mdev, bfregi->lib_uar_4k) *
 	       bfregi->num_static_sys_pages * MLX5_NON_FP_BFREGS_PER_UAR;
 }
 
-static int num_med_bfreg(struct mlx5_ib_dev *dev,
+static int num_med_bfreg(struct mlx5_core_dev *mdev,
 			 struct mlx5_bfreg_info *bfregi)
 {
-	return max(0, max_bfregs(dev, bfregi) - bfregi->num_low_latency_bfregs -
+	return max(0, max_bfregs(mdev, bfregi) -
+			      bfregi->num_low_latency_bfregs -
 			      NUM_NON_BLUE_FLAME_BFREGS);
 }
 
-static int first_med_bfreg(struct mlx5_ib_dev *dev,
+static int first_med_bfreg(struct mlx5_core_dev *mdev,
 			   struct mlx5_bfreg_info *bfregi)
 {
-	return num_med_bfreg(dev, bfregi) ? 1 : -ENOMEM;
+	return num_med_bfreg(mdev, bfregi) ? 1 : -ENOMEM;
 }
 
-static int first_hi_bfreg(struct mlx5_ib_dev *dev,
+static int first_hi_bfreg(struct mlx5_core_dev *mdev,
 			  struct mlx5_bfreg_info *bfregi)
 {
 	int med;
 
-	med = num_med_bfreg(dev, bfregi);
+	med = num_med_bfreg(mdev, bfregi);
 	return ++med;
 }
 
-static int alloc_high_class_bfreg(struct mlx5_ib_dev *dev,
+static int alloc_high_class_bfreg(struct mlx5_core_dev *mdev,
 				  struct mlx5_bfreg_info *bfregi)
 {
 	int i;
 
-	for (i = first_hi_bfreg(dev, bfregi); i < max_bfregs(dev, bfregi); i++) {
+	for (i = first_hi_bfreg(mdev, bfregi); i < max_bfregs(mdev, bfregi);
+	     i++) {
 		if (!bfregi->count[i]) {
 			bfregi->count[i]++;
 			return i;
@@ -758,16 +761,16 @@ static int alloc_high_class_bfreg(struct mlx5_ib_dev *dev,
 	return -ENOMEM;
 }
 
-static int alloc_med_class_bfreg(struct mlx5_ib_dev *dev,
+static int alloc_med_class_bfreg(struct mlx5_core_dev *mdev,
 				 struct mlx5_bfreg_info *bfregi)
 {
-	int minidx = first_med_bfreg(dev, bfregi);
+	int minidx = first_med_bfreg(mdev, bfregi);
 	int i;
 
 	if (minidx < 0)
 		return minidx;
 
-	for (i = minidx; i < first_hi_bfreg(dev, bfregi); i++) {
+	for (i = minidx; i < first_hi_bfreg(mdev, bfregi); i++) {
 		if (bfregi->count[i] < bfregi->count[minidx])
 			minidx = i;
 		if (!bfregi->count[minidx])
@@ -778,7 +781,7 @@ static int alloc_med_class_bfreg(struct mlx5_ib_dev *dev,
 	return minidx;
 }
 
-static int alloc_bfreg(struct mlx5_ib_dev *dev,
+static int alloc_bfreg(struct mlx5_core_dev *mdev,
 		       struct mlx5_bfreg_info *bfregi)
 {
 	int bfregn = -ENOMEM;
@@ -788,9 +791,9 @@ static int alloc_bfreg(struct mlx5_ib_dev *dev,
 
 	mutex_lock(&bfregi->lock);
 	if (bfregi->ver >= 2) {
-		bfregn = alloc_high_class_bfreg(dev, bfregi);
+		bfregn = alloc_high_class_bfreg(mdev, bfregi);
 		if (bfregn < 0)
-			bfregn = alloc_med_class_bfreg(dev, bfregi);
+			bfregn = alloc_med_class_bfreg(mdev, bfregi);
 	}
 
 	if (bfregn < 0) {
@@ -846,7 +849,7 @@ static void mlx5_ib_lock_cqs(struct mlx5_ib_cq *send_cq,
 static void mlx5_ib_unlock_cqs(struct mlx5_ib_cq *send_cq,
 			       struct mlx5_ib_cq *recv_cq);
 
-int bfregn_to_uar_index(struct mlx5_ib_dev *dev,
+int bfregn_to_uar_index(struct mlx5_core_dev *mdev,
 			struct mlx5_bfreg_info *bfregi, u32 bfregn,
 			bool dyn_bfreg)
 {
@@ -857,7 +860,7 @@ int bfregn_to_uar_index(struct mlx5_ib_dev *dev,
 	if (bfregi->lib_uar_dyn)
 		return -EINVAL;
 
-	bfregs_per_sys_page = get_uars_per_sys_page(dev, bfregi->lib_uar_4k) *
+	bfregs_per_sys_page = get_uars_per_sys_page(mdev, bfregi->lib_uar_4k) *
 				MLX5_NON_FP_BFREGS_PER_UAR;
 	index_of_sys_page = bfregn / bfregs_per_sys_page;
 
@@ -869,7 +872,7 @@ int bfregn_to_uar_index(struct mlx5_ib_dev *dev,
 
 		if (bfregn > bfregi->num_dyn_bfregs ||
 		    bfregi->sys_pages[index_of_sys_page] == MLX5_IB_INVALID_UAR_INDEX) {
-			mlx5_ib_dbg(dev, "Invalid dynamic uar index\n");
+			dev_dbg(mdev->device, "Invalid dynamic uar index\n");
 			return -EINVAL;
 		}
 	}
@@ -994,7 +997,8 @@ static int _create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 		bfregn = MLX5_IB_INVALID_BFREG;
 		break;
 	case MLX5_QP_FLAG_BFREG_INDEX:
-		uar_index = bfregn_to_uar_index(dev, &context->bfregi,
+		uar_index = bfregn_to_uar_index(uctx_to_mdev(context),
+						&context->bfregi,
 						ucmd->bfreg_index, true);
 		if (uar_index < 0)
 			return uar_index;
@@ -1003,7 +1007,7 @@ static int _create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	case 0:
 		if (qp->flags & IB_QP_CREATE_CROSS_CHANNEL)
 			return -EINVAL;
-		bfregn = alloc_bfreg(dev, &context->bfregi);
+		bfregn = alloc_bfreg(uctx_to_mdev(context), &context->bfregi);
 		if (bfregn < 0)
 			return bfregn;
 		break;
@@ -1013,7 +1017,8 @@ static int _create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 
 	mlx5_ib_dbg(dev, "bfregn 0x%x, uar_index 0x%x\n", bfregn, uar_index);
 	if (bfregn != MLX5_IB_INVALID_BFREG)
-		uar_index = bfregn_to_uar_index(dev, &context->bfregi, bfregn,
+		uar_index = bfregn_to_uar_index(uctx_to_mdev(context),
+						&context->bfregi, bfregn,
 						false);
 
 	qp->rq.offset = 0;

-- 
2.49.0

