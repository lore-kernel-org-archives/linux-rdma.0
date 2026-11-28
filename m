Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.39
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795870911;
	b=ph8OdUsREvCOGgfTWflRsFHL5URxBTRuvmrre+iSo4Zyo3S7YLC1bJvM4qThWGQ1t239
	 c6g6MrRzTmMf6pPMUV7w90VJkwXGqYk0H2l5lrEoJX5jV2o6/Y3XRL5IpLwcMvTgwThqV
	 Q+9qOGMs/rtnT+c6Z4ZldukaBst60BBvKnkNPzeQgcS3/4akKxJgEVbBwBuRxNBo7Xumd
	 oIHOoSnE5SLLWY+XjTGY+ztd6r7u7cHkUxEuEurTOUpKQoCkCtIk6E6QOTLS79UlnJ9Xw
	 PauqemHuUiEVJ+jc1Q+dsgKq0VRlWv74wZTO4jM3Ed0n4b6h8+I9x4gLJyMbFMb7Nrg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795870911;
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
	bh=1wiiOrzgYw5oJXl7SW53jRQoCaH8wsdNDXiMyb0CFxg=;
	b=tCMT6q+z2UfyfTXGZ+xJmaMiVUeNFmHdSWVh7JHAQwcVmM4FfV6AYs+9bEbJ2hpYBuSV
	 +kdrA2117rgUcpAkdD4z/z2Qe08FkapFXmcz3y/kP3aGzg5HBOUYMAqbYSZjnlzIzjOsP
	 F+xJCI0Gm26srUE2EF7pXasTgYvCURqktoQ1Yi0LGNi0ohFgfx+FUEBguFcuqZsrxQ9EP
	 SCA55OHtUS6t3AprxI8HDctHaRHaiYtTGN6tD3YVfSzYTdjvgu4uoO6Tb+H39gIBiygEJ
	 S/PkMTOfSfojv7iUW1mQIebv/2wUFomDldGvWz8257zBHfSddKISHBvGYysVB8tj05g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=rw4O4H6I;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.39
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012039.outbound.protection.outlook.com [40.93.195.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E927F606A334;
	Sat, 28 Nov 2026 13:01:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E927F606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=rw4O4H6I
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C2HCDuk97jS37KZ37qF79mldx7PRCex1ajducq8GL3bxsALELK4mI5YJ8kwjTMd+r4Uka3Vjq+Is+Q2atLcdEAvrX6qeLUFPlW0Lllkqyq1VdBWPAnx5eb/m2QucQjnVPb4ht46VUcTdnMOwKPY/QSeStLDsbM6YKMsh2ZkUEY4j34Yr2am+XAYWfV3stMfpnfS1jq4yrUNkuBiMVIOiN6Im52gRNjFAyPgVyNyIMJ+TGWYNA9EDua/RRD0d3mPXQGv8+ZaphhRYYEMBZ2eUVcumBIGUF5isCxJE9nG/IaOMeXr572YmZ8Cz9U3Df/f2dXhUyRolZiiAEK3ndpoHkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1wiiOrzgYw5oJXl7SW53jRQoCaH8wsdNDXiMyb0CFxg=;
 b=wXZ0/2S7lGeYWgVMRYUD//a5FaBRcE1DS5zuafAfnsURi89UeZ5IJOWryjiNhMy5dbyK5Ldhu2l92sbZfVcQUFt0gGDYREhqtm4kCSF8ik2r0WlCZj1UD7ZEPZH/bNLLuudAJcEL2l8y2pAtFAzNe5Zn2CN8nYo8Vc0NTvpJ0FrtCpqQsLp9dWa9ywmhOz0mYTldiOO0i5v8nipRzPJKtrbk7njJhdLF9zDJFq8Ec3xXDTsOGpjH0jzisjbIFFJbXfhkPXlPQQ6erwkLlvxrk6DYjB2Z72Ebmx4a7siS7nHdiNl2aL9k1pHydEUNFgc0OHhJWiIERdrugo8v/FoHoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1wiiOrzgYw5oJXl7SW53jRQoCaH8wsdNDXiMyb0CFxg=;
 b=rw4O4H6IcWqbAPraMLBtQSeWwRm7vcgpBYewCpky98LU7J5/Jwu6K64We8yJgRdPvM2mwmfoVkRUB9EEvxplrY6L+k2MFHTCqTnd0O0qOL2RZroOj/WBu8odGYuqugL+ZeiP0r0YAUy7uT34Su3PP/K2VLn/MejWGhdFBy0+GP4Zq1hbyqxmCnEQoo/hQVx/yyDcNHWBBp3JtNK0dCCgEZLBfe96YX69XHZLHyC79YZ+qIzmUnHwqAKYoXzn0QIV3fLa4adN+TMzXpLWebUrux4QEZ5Au6y6NXwfmsFA6cZwLuap5DOq1Ql6oeiBF3yeCp+5OXaXfAN9kSu1CuFBjQ==
Received: from BN0PR04CA0120.namprd04.prod.outlook.com (2603:10b6:408:ec::35)
 by FT1PR12MB748946.namprd12.prod.outlook.com (2603:10b6:170:31::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.11; Sat, 28 Nov
 2026 13:01:42 +0000
Received: from BN6PEPF0000006F.namprd03.prod.outlook.com
 (2603:10b6:408:ec:cafe::98) by BN0PR04CA0120.outlook.office365.com
 (2603:10b6:408:ec::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.11 via Frontend Transport; Sat,
 28 Nov 2026 13:01:42 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN6PEPF0000006F.mail.protection.outlook.com (10.167.248.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Sat, 28 Nov 2026 13:01:41 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sat, 28 Nov
 2026 05:01:33 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Sat, 28 Nov 2026 05:01:33 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Sat, 28 Nov 2026 05:01:31 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Sat, 28 Nov 2026 15:01:18 +0200
Subject: [PATCH rdma-next v2 05/11] RDMA/mlx5: Cache the MR core device and
 resolve the MW's via its PD
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
Message-ID: <20261128-mlx5-sd-prep-v2-5-751878123711@nvidia.com>
References: <20261128-mlx5-sd-prep-v2-0-751878123711@nvidia.com>
In-Reply-To: <20261128-mlx5-sd-prep-v2-0-751878123711@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>, Akiva Goldberger <agoldberger@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795870878; l=55881;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=Ivigt6FyV/V6iYpuHkZgomtUxKSL9jd4E8KMgyYuuo0=;
 b=QiDQ/pCHsyzW1MtFlIYXu4+O24dCH5P98Woua6guSQmx56L+dxCR3Mq7OmruykQWhyvhHGX+P
 ypmOTiFxDVJCsU9jxo6DfU4iDMGOT/gZX+Q25K9FLPzvsl//TF4/DRO
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PEPF0000006F:EE_|FT1PR12MB748946:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e5d381e-77d1-40b2-e1dd-08df4d4fbf8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|23010399003|1800799024|82310400026|10067099003|56012099006|11063799006|261021121427099003|261021123027099003|261026140227099003|261026121527099003|261009223027099003|261022105027099003|261028144727099003|261102123227099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	hE+RKzEBhGIEPh0vbGnQIs/tm5NXS+OA3BRBg7JGiL6XXbh553rJXponnv//22YsKN12Iy9GR8KoKQkWf7q48fjBHDLBPJxUEtrG1PGSxLqGZwRgPNmYquf1kUAD8imSfyr+Onprxww9DPZC7KD2a2qh4dp6NHVcv3z/+CFnfJJZYgjYDoSRN3iUsamrw/vGfuSkbgr5+21+zSB+e1ZrHQpifHcfuivMePVvr/xMUTuzkGafh9sNENDHfNB1wfuA7wUeHHKKAp3iEFF00el8N4la0Tw76AT6TAmPG5Kyfxos+vhzSENYlDsQ71rxd8wNdyefwUjia0uQ77eBUA8eYEUoU/j/slUU2KZr1uA08gnjDpED2NJNkHSNdgUa5zQ4CtPcvolRZPWlRLh/30QFzEezsnzcHXF8IsAfgRrdNQLBEgIO2Aun2CpDD+9D1KhvHA48TuwxpVmV5fg/m+WOMxThQjMrGnzyxkc+eZBSSNUeq2OG5BP6vS128ZpWWSUY30pE9zcsUW/q6YWbMYdY42xEiLPK8b1Zj47RnnCCJaLHRIUROjUDY8p41RdkNPoSxzx3Sb5A6Bwnb89AFV1JCR3LJwX8Y4FHYZlZ3rjSUvSllsOZjQIrT4Zf/RHduzEMfLgeg5NBG3YFDPlfQuyv29EMNbuDDah1OZfSeA+DaFrSbYZKxmLAaCySx7fwOkV5od3z5TjDDtmm4zLvccSTvQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(376014)(23010399003)(1800799024)(82310400026)(10067099003)(56012099006)(11063799006)(261021121427099003)(261021123027099003)(261026140227099003)(261026121527099003)(261009223027099003)(261022105027099003)(261028144727099003)(261102123227099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	f3L6PMyjcUo9QTSXK17jEEcbJokTNlrOd6VXZSrtGFVrGKAa93q0W4RZj+AKG3Dp4EBmBOZet8wi5UJ4e+waGoGRIyH6VSkVNU+aVdq5mgeuKA4o9bb4RI9zTDYIZL86BRHruO3hOnG1iCZUZbo3Yw4XFn9Z7iShGhkMheIkSJ2VNSDOszQfctuycZvNYVNHtvP89vDwfykJRJA+jIE0nica0nTePWHay5aATNQBbgsVEGp0b3lS5hPU8cMNG/3vli3DKPHfQdTx+DGPH5IG91YORo12thw7rfuaAOga05U/DE1e+MIWtlitxNsxvoUYlqeTeJ4+xHutDu6V+yqVkWxMjUacvEVkQ4NPbhUc/65EQrXX4YBVgE5iV9hVe5xoFrQdF4W3GJnBvE5hHWxytnbTwZtClglHoSlx8yBwHeo4xx7ABa53CeO/tJhBEKpf
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2026 13:01:41.9681
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e5d381e-77d1-40b2-e1dd-08df4d4fbf8e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN6PEPF0000006F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FT1PR12MB748946

From: Akiva Goldberger <agoldberger@nvidia.com>

Add mr_to_mdev() and mw_to_mdev() to reach the core device of an MR or
an MW from the resource itself instead of dev->mdev.

An MW resolves its core device through its PD, like the other resources
in this series. An MR cannot: ib_mr->pd is not a fixed pointer, since
IB_MR_REREG_PD replaces it in place, and ODP page faults, prefetch and
mmu notifier invalidation reach an MR without the uobject lock that
protects it. Store the core device in the MR when it is created instead.
MRs taken from the MR cache get it from their caller, which resolves it
from the PD or from the parent implicit ODP MR.

No functional change.

Signed-off-by: Akiva Goldberger <agoldberger@nvidia.com>
Reviewed-by: Michael Gur <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/devx.c    |   2 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  49 ++++++++----
 drivers/infiniband/hw/mlx5/mr.c      | 150 +++++++++++++++++++++--------------
 drivers/infiniband/hw/mlx5/odp.c     |  37 +++++----
 drivers/infiniband/hw/mlx5/umr.c     | 125 ++++++++++++++---------------
 drivers/infiniband/hw/mlx5/umr.h     |  26 +++---
 drivers/infiniband/hw/mlx5/wr.c      |   3 +-
 7 files changed, 218 insertions(+), 174 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 2317220e9cacaa31fbc2455b5da5aa5af301622a..d2c8e4ed9e846fa17c77ccfff22c345d36322617 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -2391,7 +2391,7 @@ static int devx_umem_reg_cmd_alloc(struct mlx5_ib_dev *dev,
 	MLX5_SET(umem, umem, page_offset,
 		 ib_umem_dma_offset(obj->umem, page_size));
 
-	if (mlx5_umem_needs_ats(dev, obj->umem, access))
+	if (mlx5_umem_needs_ats(dev->mdev, obj->umem, access))
 		MLX5_SET(umem, umem, ats, 1);
 
 	mlx5_ib_populate_pas(obj->umem, page_size, mtt,
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 03261e22de9bd1532d50d8024ae989d5af0ffaa8..1cf856e314d394fec694a6e4273592e5c85cd73e 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -682,6 +682,7 @@ struct mlx5_ib_mkey {
 struct mlx5_ib_mr {
 	struct ib_mr ibmr;
 	struct mlx5_ib_mkey mmkey;
+	struct mlx5_core_dev *mdev;
 
 	struct ib_umem *umem;
 	/* The mr is data direct related */
@@ -1305,6 +1306,16 @@ static inline struct mlx5_core_dev *srq_to_mdev(struct mlx5_core_srq *msrq)
 	return pd_to_mdev(to_mibsrq(msrq)->ibsrq.pd);
 }
 
+static inline struct mlx5_core_dev *mr_to_mdev(struct mlx5_ib_mr *mr)
+{
+	return mr->mdev;
+}
+
+static inline struct mlx5_core_dev *mw_to_mdev(struct ib_mw *ibmw)
+{
+	return pd_to_mdev(ibmw->pd);
+}
+
 static inline struct mlx5_ib_mw *to_mmw(struct ib_mw *ibmw)
 {
 	return container_of(ibmw, struct mlx5_ib_mw, ibmw);
@@ -1444,6 +1455,7 @@ int mlx5_ib_get_cqe_size(struct ib_cq *ibcq);
 int mlx5r_frmr_pools_init(struct ib_device *device);
 void mlx5r_frmr_pools_cleanup(struct ib_device *device);
 struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
+				       struct mlx5_core_dev *mdev,
 				       int access_flags, int access_mode,
 				       int ndescs);
 
@@ -1731,10 +1743,10 @@ static inline bool rt_supported(int ts_cap)
  *
  * For now assume if the umem is a dma_buf then it is P2P.
  */
-static inline bool mlx5_umem_needs_ats(struct mlx5_ib_dev *dev,
+static inline bool mlx5_umem_needs_ats(struct mlx5_core_dev *mdev,
 				       struct ib_umem *umem, int access_flags)
 {
-	if (!MLX5_CAP_GEN(dev->mdev, ats) || !umem->is_dmabuf)
+	if (!MLX5_CAP_GEN(mdev, ats) || !umem->is_dmabuf)
 		return false;
 	return access_flags & (IB_ACCESS_RELAXED_ORDERING | IB_ACCESS_UNORDERED);
 }
@@ -1757,39 +1769,39 @@ static inline u32 smi_to_native_portnum(struct mlx5_ib_dev *dev, u32 port)
 	return (port - 1) / dev->num_ports + 1;
 }
 
-static inline unsigned int get_max_log_entity_size_cap(struct mlx5_ib_dev *dev,
-						       int access_mode)
+static inline unsigned int
+get_max_log_entity_size_cap(struct mlx5_core_dev *mdev, int access_mode)
 {
 	int max_log_size = 0;
 
 	if (access_mode == MLX5_MKC_ACCESS_MODE_MTT)
 		max_log_size =
-			MLX5_CAP_GEN_2(dev->mdev, max_mkey_log_entity_size_mtt);
+			MLX5_CAP_GEN_2(mdev, max_mkey_log_entity_size_mtt);
 	else if (access_mode == MLX5_MKC_ACCESS_MODE_KSM)
 		max_log_size = MLX5_CAP_GEN_2(
-			dev->mdev, max_mkey_log_entity_size_fixed_buffer);
+			mdev, max_mkey_log_entity_size_fixed_buffer);
 
 	if (!max_log_size ||
 	    (max_log_size > 31 &&
-	     !MLX5_CAP_GEN_2(dev->mdev, umr_log_entity_size_5)))
+	     !MLX5_CAP_GEN_2(mdev, umr_log_entity_size_5)))
 		max_log_size = 31;
 
 	return max_log_size;
 }
 
-static inline unsigned int get_min_log_entity_size_cap(struct mlx5_ib_dev *dev,
-						       int access_mode)
+static inline unsigned int
+get_min_log_entity_size_cap(struct mlx5_core_dev *mdev, int access_mode)
 {
 	int min_log_size = 0;
 
 	if (access_mode == MLX5_MKC_ACCESS_MODE_KSM &&
-	    MLX5_CAP_GEN_2(dev->mdev,
+	    MLX5_CAP_GEN_2(mdev,
 			   min_mkey_log_entity_size_fixed_buffer_valid))
 		min_log_size = MLX5_CAP_GEN_2(
-			dev->mdev, min_mkey_log_entity_size_fixed_buffer);
+			mdev, min_mkey_log_entity_size_fixed_buffer);
 	else
 		min_log_size =
-			MLX5_CAP_GEN_2(dev->mdev, log_min_mkey_entity_size);
+			MLX5_CAP_GEN_2(mdev, log_min_mkey_entity_size);
 
 	min_log_size = max(min_log_size, MLX5_ADAPTER_PAGE_SHIFT);
 	return min_log_size;
@@ -1800,14 +1812,16 @@ static inline unsigned int get_min_log_entity_size_cap(struct mlx5_ib_dev *dev,
  * specifies both the page_offset and the on-the-wire IOVA
  */
 static __always_inline unsigned long
-mlx5_umem_mkc_find_best_pgsz(struct mlx5_ib_dev *dev, struct ib_umem *umem,
+mlx5_umem_mkc_find_best_pgsz(struct mlx5_core_dev *mdev, struct ib_umem *umem,
 			     u64 iova, int access_mode)
 {
 	unsigned int max_log_entity_size_cap, min_log_entity_size_cap;
 	unsigned long bitmap;
 
-	max_log_entity_size_cap = get_max_log_entity_size_cap(dev, access_mode);
-	min_log_entity_size_cap = get_min_log_entity_size_cap(dev, access_mode);
+	max_log_entity_size_cap =
+		get_max_log_entity_size_cap(mdev, access_mode);
+	min_log_entity_size_cap =
+		get_min_log_entity_size_cap(mdev, access_mode);
 
 	bitmap = GENMASK_ULL(max_log_entity_size_cap, min_log_entity_size_cap);
 
@@ -1819,10 +1833,11 @@ mlx5_umem_mkc_find_best_pgsz(struct mlx5_ib_dev *dev, struct ib_umem *umem,
 }
 
 static inline unsigned long
-mlx5_umem_dmabuf_find_best_pgsz(struct ib_umem_dmabuf *umem_dmabuf,
+mlx5_umem_dmabuf_find_best_pgsz(struct mlx5_core_dev *mdev,
+				struct ib_umem_dmabuf *umem_dmabuf,
 				int access_mode)
 {
-	return mlx5_umem_mkc_find_best_pgsz(to_dev(umem_dmabuf->umem.ibdev),
+	return mlx5_umem_mkc_find_best_pgsz(mdev,
 					    &umem_dmabuf->umem,
 					    umem_dmabuf->umem.iova,
 					    access_mode);
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 70cbb9b1997ce4168f4ee2d0e8ff8200c3444373..50c5f39c080f85f0cbefb886fb346e099ec07309 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -46,9 +46,9 @@
 #include "umr.h"
 #include "dmah.h"
 
-static int mkey_max_umr_order(struct mlx5_ib_dev *dev)
+static int mkey_max_umr_order(struct mlx5_core_dev *mdev)
 {
-	if (MLX5_CAP_GEN(dev->mdev, umr_extended_translation_offset))
+	if (MLX5_CAP_GEN(mdev, umr_extended_translation_offset))
 		return MLX5_MAX_UMR_EXTENDED_SHIFT;
 	return MLX5_MAX_UMR_SHIFT;
 }
@@ -62,7 +62,7 @@ static int __mlx5_ib_dereg_mr(struct ib_mr *ibmr);
 static void set_mkc_access_pd_addr_fields(void *mkc, int acc, u64 start_addr,
 					  struct ib_pd *pd)
 {
-	struct mlx5_ib_dev *dev = to_dev(pd->device);
+	struct mlx5_core_dev *mdev = pd_to_mdev(pd);
 
 	MLX5_SET(mkc, mkc, a, !!(acc & IB_ACCESS_REMOTE_ATOMIC));
 	MLX5_SET(mkc, mkc, rw, !!(acc & IB_ACCESS_REMOTE_WRITE));
@@ -70,7 +70,7 @@ static void set_mkc_access_pd_addr_fields(void *mkc, int acc, u64 start_addr,
 	MLX5_SET(mkc, mkc, lw, !!(acc & IB_ACCESS_LOCAL_WRITE));
 	MLX5_SET(mkc, mkc, lr, 1);
 
-	mlx5_core_mkey_set_ordering(dev->mdev, mkc,
+	mlx5_core_mkey_set_ordering(mdev, mkc,
 				    mlx5r_access_to_mkey_order(acc));
 
 	MLX5_SET(mkc, mkc, pd, to_mpd(pd)->pdn);
@@ -99,12 +99,13 @@ static void assign_mkey_variant(struct mlx5_ib_dev *dev, u32 *mkey, u32 *in)
 }
 
 static int mlx5_ib_create_mkey(struct mlx5_ib_dev *dev,
+			       struct mlx5_core_dev *mdev,
 			       struct mlx5_ib_mkey *mkey, u32 *in, int inlen)
 {
 	int ret;
 
 	assign_mkey_variant(dev, &mkey->key, in);
-	ret = mlx5_core_create_mkey(dev->mdev, &mkey->key, in, inlen);
+	ret = mlx5_core_create_mkey(mdev, &mkey->key, in, inlen);
 	if (!ret)
 		init_waitqueue_head(&mkey->wait);
 
@@ -115,7 +116,8 @@ static int destroy_mkey(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 {
 	WARN_ON(xa_load(&dev->odp_mkeys, mlx5_base_mkey(mr->mmkey.key)));
 
-	return mlx5_core_destroy_mkey(dev->mdev, mr->mmkey.key);
+	return mlx5_core_destroy_mkey(mr_to_mdev(mr),
+				      mr->mmkey.key);
 }
 
 static int get_mkc_octo_size(unsigned int access_mode, unsigned int ndescs)
@@ -145,10 +147,12 @@ static int get_mkc_octo_size(unsigned int access_mode, unsigned int ndescs)
 #define MLX5_FRMR_POOLS_KERNEL_KEY_ST_INDEX_MASK GENMASK_ULL(15, 0)
 
 static struct mlx5_ib_mr *
-_mlx5_frmr_pool_alloc(struct mlx5_ib_dev *dev, struct ib_umem *umem,
+_mlx5_frmr_pool_alloc(struct ib_pd *pd, struct ib_umem *umem,
 		      int access_flags, int access_mode,
 		      unsigned long page_size, u16 st_index, u8 ph)
 {
+	struct mlx5_ib_dev *dev = to_dev(pd->device);
+	struct mlx5_core_dev *mdev = pd_to_mdev(pd);
 	struct mlx5_ib_mr *mr;
 	int err;
 
@@ -156,9 +160,12 @@ _mlx5_frmr_pool_alloc(struct mlx5_ib_dev *dev, struct ib_umem *umem,
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
-	mr->ibmr.frmr.key.ats = mlx5_umem_needs_ats(dev, umem, access_flags);
+	mr->mdev = pd_to_mdev(pd);
+
+	mr->ibmr.frmr.key.ats = mlx5_umem_needs_ats(mdev, umem,
+						    access_flags);
 	mr->ibmr.frmr.key.access_flags =
-		mlx5r_umr_get_unchangeable_access_flags(dev, access_flags);
+		mlx5r_umr_get_unchangeable_access_flags(mdev, access_flags);
 	mr->ibmr.frmr.key.num_dma_blocks =
 		ib_umem_num_dma_blocks(umem, page_size);
 	mr->ibmr.frmr.key.vendor_key =
@@ -185,12 +192,13 @@ _mlx5_frmr_pool_alloc(struct mlx5_ib_dev *dev, struct ib_umem *umem,
 }
 
 struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
+				       struct mlx5_core_dev *mdev,
 				       int access_flags, int access_mode,
 				       int ndescs)
 {
 	struct ib_frmr_key key = {
 		.access_flags =
-			mlx5r_umr_get_unchangeable_access_flags(dev, access_flags),
+			mlx5r_umr_get_unchangeable_access_flags(mdev, access_flags),
 		.vendor_key = access_mode == MLX5_MKC_ACCESS_MODE_MTT ?
 				      0 :
 				      MLX5_FRMR_POOLS_KEY_ACCESS_MODE_KSM_MASK,
@@ -204,6 +212,8 @@ struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
+	mr->mdev = mdev;
+
 	init_waitqueue_head(&mr->mmkey.wait);
 
 	mr->ibmr.frmr.key = key;
@@ -302,7 +312,7 @@ static int mlx5r_build_frmr_key(struct ib_device *device,
 
 	/* check HW capabilities of users requested frmr key */
 	if ((in->ats && !MLX5_CAP_GEN(dev->mdev, ats)) ||
-	    ilog2(in->num_dma_blocks) > mkey_max_umr_order(dev))
+	    ilog2(in->num_dma_blocks) > mkey_max_umr_order(dev->mdev))
 		return -EOPNOTSUPP;
 
 	if (in->vendor_key & ~MLX5_FRMR_POOLS_KEY_VENDOR_KEY_SUPPORTED)
@@ -314,7 +324,7 @@ static int mlx5r_build_frmr_key(struct ib_device *device,
 
 	out->ats = in->ats;
 	out->access_flags =
-		mlx5r_umr_get_unchangeable_access_flags(dev, in->access_flags);
+		mlx5r_umr_get_unchangeable_access_flags(dev->mdev, in->access_flags);
 	out->vendor_key = in->vendor_key;
 	out->num_dma_blocks = in->num_dma_blocks;
 
@@ -353,6 +363,8 @@ struct ib_mr *mlx5_ib_get_dma_mr(struct ib_pd *pd, int acc)
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
+	mr->mdev = pd_to_mdev(pd);
+
 	in = kzalloc(inlen, GFP_KERNEL);
 	if (!in) {
 		err = -ENOMEM;
@@ -365,9 +377,10 @@ struct ib_mr *mlx5_ib_get_dma_mr(struct ib_pd *pd, int acc)
 	MLX5_SET(mkc, mkc, length64, 1);
 	set_mkc_access_pd_addr_fields(mkc, acc | IB_ACCESS_RELAXED_ORDERING, 0,
 				      pd);
-	MLX5_SET(mkc, mkc, ma_translation_mode, MLX5_CAP_GEN(dev->mdev, ats));
+	MLX5_SET(mkc, mkc, ma_translation_mode,
+		 MLX5_CAP_GEN(pd_to_mdev(pd), ats));
 
-	err = mlx5_ib_create_mkey(dev, &mr->mmkey, in, inlen);
+	err = mlx5_ib_create_mkey(dev, mr_to_mdev(mr), &mr->mmkey, in, inlen);
 	if (err)
 		goto err_in;
 
@@ -433,12 +446,12 @@ static struct mlx5_ib_mr *alloc_cacheable_mr(struct ib_pd *pd,
 	if (umem->is_dmabuf)
 		page_size = mlx5_umem_dmabuf_default_pgsz(umem, iova);
 	else
-		page_size = mlx5_umem_mkc_find_best_pgsz(dev, umem, iova,
-							 access_mode);
+		page_size = mlx5_umem_mkc_find_best_pgsz(pd_to_mdev(pd), umem,
+							 iova, access_mode);
 	if (WARN_ON(!page_size))
 		return ERR_PTR(-EINVAL);
 
-	mr = _mlx5_frmr_pool_alloc(dev, umem, access_flags, access_mode,
+	mr = _mlx5_frmr_pool_alloc(pd, umem, access_flags, access_mode,
 				   page_size, st_index, ph);
 	if (IS_ERR(mr))
 		return mr;
@@ -457,6 +470,7 @@ reg_create_crossing_vhca_mr(struct ib_pd *pd, u64 iova, u64 length, int access_f
 			    u32 crossed_lkey)
 {
 	struct mlx5_ib_dev *dev = to_dev(pd->device);
+	struct mlx5_core_dev *mdev = pd_to_mdev(pd);
 	int access_mode = MLX5_MKC_ACCESS_MODE_CROSSING;
 	struct mlx5_ib_mr *mr;
 	void *mkc;
@@ -464,13 +478,15 @@ reg_create_crossing_vhca_mr(struct ib_pd *pd, u64 iova, u64 length, int access_f
 	u32 *in;
 	int err;
 
-	if (!MLX5_CAP_GEN(dev->mdev, crossing_vhca_mkey))
+	if (!MLX5_CAP_GEN(mdev, crossing_vhca_mkey))
 		return ERR_PTR(-EOPNOTSUPP);
 
 	mr = kzalloc_obj(*mr);
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
+	mr->mdev = pd_to_mdev(pd);
+
 	inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if (!in) {
@@ -480,7 +496,7 @@ reg_create_crossing_vhca_mr(struct ib_pd *pd, u64 iova, u64 length, int access_f
 
 	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
 	MLX5_SET(mkc, mkc, crossing_target_vhca_id,
-		 MLX5_CAP_GEN(dev->mdev, vhca_id));
+		 MLX5_CAP_GEN(mdev, vhca_id));
 	MLX5_SET(mkc, mkc, translations_octword_size, crossed_lkey);
 	MLX5_SET(mkc, mkc, access_mode_1_0, access_mode & 0x3);
 	MLX5_SET(mkc, mkc, access_mode_4_2, (access_mode >> 2) & 0x7);
@@ -491,7 +507,7 @@ reg_create_crossing_vhca_mr(struct ib_pd *pd, u64 iova, u64 length, int access_f
 
 	MLX5_SET(mkc, mkc, free, 0);
 	MLX5_SET(mkc, mkc, umr_en, 0);
-	err = mlx5_ib_create_mkey(dev, &mr->mmkey, in, inlen);
+	err = mlx5_ib_create_mkey(dev, mr_to_mdev(mr), &mr->mmkey, in, inlen);
 	if (err)
 		goto err_2;
 
@@ -519,13 +535,14 @@ static struct mlx5_ib_mr *reg_create(struct ib_pd *pd, struct ib_umem *umem,
 				     int access_mode, u16 st_index, u8 ph)
 {
 	struct mlx5_ib_dev *dev = to_dev(pd->device);
+	struct mlx5_core_dev *mdev = pd_to_mdev(pd);
 	struct mlx5_ib_mr *mr;
 	__be64 *pas;
 	void *mkc;
 	int inlen;
 	u32 *in;
 	int err;
-	bool pg_cap = !!(MLX5_CAP_GEN(dev->mdev, pg)) &&
+	bool pg_cap = !!(MLX5_CAP_GEN(mdev, pg)) &&
 		(access_mode == MLX5_MKC_ACCESS_MODE_MTT) &&
 		(ph == MLX5_IB_NO_PH);
 	bool ksm_mode = (access_mode == MLX5_MKC_ACCESS_MODE_KSM);
@@ -536,6 +553,8 @@ static struct mlx5_ib_mr *reg_create(struct ib_pd *pd, struct ib_umem *umem,
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
+	mr->mdev = pd_to_mdev(pd);
+
 	mr->ibmr.pd = pd;
 	mr->access_flags = access_flags;
 	mr->page_shift = order_base_2(page_size);
@@ -584,7 +603,7 @@ static struct mlx5_ib_mr *reg_create(struct ib_pd *pd, struct ib_umem *umem,
 		MLX5_SET(mkc, mkc, translations_octword_size,
 			 get_octo_len(iova, umem->length, mr->page_shift));
 	MLX5_SET(mkc, mkc, log_page_size, mr->page_shift);
-	if (mlx5_umem_needs_ats(dev, umem, access_flags))
+	if (mlx5_umem_needs_ats(mdev, umem, access_flags))
 		MLX5_SET(mkc, mkc, ma_translation_mode, 1);
 	if (populate) {
 		MLX5_SET(create_mkey_in, in, translations_octword_actual_size,
@@ -598,7 +617,7 @@ static struct mlx5_ib_mr *reg_create(struct ib_pd *pd, struct ib_umem *umem,
 			MLX5_SET(mkc, mkc, pcie_tph_steering_tag_index, st_index);
 	}
 
-	err = mlx5_ib_create_mkey(dev, &mr->mmkey, in, inlen);
+	err = mlx5_ib_create_mkey(dev, mr_to_mdev(mr), &mr->mmkey, in, inlen);
 	if (err) {
 		mlx5_ib_warn(dev, "create mkey failed\n");
 		goto err_2;
@@ -634,6 +653,8 @@ static struct ib_mr *mlx5_ib_get_dm_mr(struct ib_pd *pd, u64 start_addr,
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
+	mr->mdev = pd_to_mdev(pd);
+
 	in = kzalloc(inlen, GFP_KERNEL);
 	if (!in) {
 		err = -ENOMEM;
@@ -647,7 +668,7 @@ static struct ib_mr *mlx5_ib_get_dm_mr(struct ib_pd *pd, u64 start_addr,
 	MLX5_SET64(mkc, mkc, len, length);
 	set_mkc_access_pd_addr_fields(mkc, acc, start_addr, pd);
 
-	err = mlx5_ib_create_mkey(dev, &mr->mmkey, in, inlen);
+	err = mlx5_ib_create_mkey(dev, mr_to_mdev(mr), &mr->mmkey, in, inlen);
 	if (err)
 		goto err_in;
 
@@ -740,14 +761,15 @@ static struct ib_mr *create_real_mr(struct ib_pd *pd, struct ib_umem *umem,
 			st_index = mdmah->st_index;
 	}
 
-	xlt_with_umr = mlx5r_umr_can_load_pas(dev, umem->length);
+	xlt_with_umr = mlx5r_umr_can_load_pas(pd_to_mdev(pd), umem->length);
 	if (xlt_with_umr) {
 		mr = alloc_cacheable_mr(pd, umem, iova, access_flags,
 					MLX5_MKC_ACCESS_MODE_MTT,
 					st_index, ph);
 	} else {
 		unsigned long page_size = mlx5_umem_mkc_find_best_pgsz(
-				dev, umem, iova, MLX5_MKC_ACCESS_MODE_MTT);
+				pd_to_mdev(pd), umem, iova,
+				MLX5_MKC_ACCESS_MODE_MTT);
 
 		mutex_lock(&dev->slow_path_mutex);
 		mr = reg_create(pd, umem, iova, access_flags, page_size,
@@ -762,7 +784,7 @@ static struct ib_mr *create_real_mr(struct ib_pd *pd, struct ib_umem *umem,
 
 	mlx5_ib_dbg(dev, "mkey 0x%x\n", mr->mmkey.key);
 
-	atomic_add(ib_umem_num_pages(umem), &dev->mdev->priv.reg_pages);
+	atomic_add(ib_umem_num_pages(umem), &mr_to_mdev(mr)->priv.reg_pages);
 
 	if (xlt_with_umr) {
 		/*
@@ -808,7 +830,7 @@ static struct ib_mr *create_user_odp_mr(struct ib_pd *pd, u64 start, u64 length,
 	}
 
 	/* ODP requires xlt update via umr to work. */
-	if (!mlx5r_umr_can_load_pas(dev, length))
+	if (!mlx5r_umr_can_load_pas(pd_to_mdev(pd), length))
 		return ERR_PTR(-EINVAL);
 
 	odp = ib_umem_odp_get(&dev->ib_dev, start, length, access_flags,
@@ -948,7 +970,8 @@ reg_user_mr_dmabuf(struct ib_pd *pd, struct device *dma_device,
 
 	mlx5_ib_dbg(dev, "mkey 0x%x\n", mr->mmkey.key);
 
-	atomic_add(ib_umem_num_pages(mr->umem), &dev->mdev->priv.reg_pages);
+	atomic_add(ib_umem_num_pages(mr->umem),
+		   &mr_to_mdev(mr)->priv.reg_pages);
 	umem_dmabuf->private = mr;
 	if (!pinned_mode) {
 		err = mlx5r_odp_create_eq(dev, &dev->odp_pf_eq);
@@ -1057,7 +1080,7 @@ struct ib_mr *mlx5_ib_reg_user_mr_dmabuf(struct ib_pd *pd, u64 offset,
 		return ERR_PTR(err);
 
 	/* dmabuf requires xlt update via umr to work. */
-	if (!mlx5r_umr_can_load_pas(dev, length))
+	if (!mlx5r_umr_can_load_pas(pd_to_mdev(pd), length))
 		return ERR_PTR(-EINVAL);
 
 	if (mlx5_access_flags & MLX5_IB_UAPI_REG_DMABUF_ACCESS_DATA_DIRECT)
@@ -1072,7 +1095,7 @@ struct ib_mr *mlx5_ib_reg_user_mr_dmabuf(struct ib_pd *pd, u64 offset,
  * True if the change in access flags can be done via UMR, only some access
  * flags can be updated.
  */
-static bool can_use_umr_rereg_access(struct mlx5_ib_dev *dev,
+static bool can_use_umr_rereg_access(struct mlx5_core_dev *mdev,
 				     unsigned int current_access_flags,
 				     unsigned int target_access_flags)
 {
@@ -1082,7 +1105,7 @@ static bool can_use_umr_rereg_access(struct mlx5_ib_dev *dev,
 		      IB_ACCESS_REMOTE_READ | IB_ACCESS_RELAXED_ORDERING |
 		      IB_ACCESS_REMOTE_ATOMIC))
 		return false;
-	return mlx5r_umr_can_reconfig(dev, current_access_flags,
+	return mlx5r_umr_can_reconfig(mdev, current_access_flags,
 				      target_access_flags);
 }
 
@@ -1091,13 +1114,12 @@ static bool can_use_umr_rereg_pas(struct mlx5_ib_mr *mr,
 				  int new_access_flags, u64 iova,
 				  unsigned long *page_size)
 {
-	struct mlx5_ib_dev *dev = to_dev(mr->ibmr.device);
 	u8 access_mode;
 
 	/* We only track the allocated sizes of MRs from the frmr pools */
 	if (!mr->ibmr.frmr.pool)
 		return false;
-	if (!mlx5r_umr_can_load_pas(dev, new_umem->length))
+	if (!mlx5r_umr_can_load_pas(mr_to_mdev(mr), new_umem->length))
 		return false;
 
 	access_mode = mr->ibmr.frmr.key.vendor_key &
@@ -1106,7 +1128,8 @@ static bool can_use_umr_rereg_pas(struct mlx5_ib_mr *mr,
 			      MLX5_MKC_ACCESS_MODE_MTT;
 
 	*page_size =
-		mlx5_umem_mkc_find_best_pgsz(dev, new_umem, iova, access_mode);
+		mlx5_umem_mkc_find_best_pgsz(mr_to_mdev(mr), new_umem, iova,
+					     access_mode);
 	if (WARN_ON(!*page_size))
 		return false;
 	return (mr->ibmr.frmr.key.num_dma_blocks) >=
@@ -1117,7 +1140,6 @@ static int umr_rereg_pas(struct mlx5_ib_mr *mr, struct ib_pd *pd,
 			 int access_flags, int flags, struct ib_umem *new_umem,
 			 u64 iova, unsigned long page_size)
 {
-	struct mlx5_ib_dev *dev = to_dev(mr->ibmr.device);
 	int upd_flags = MLX5_IB_UPD_XLT_ADDR | MLX5_IB_UPD_XLT_ENABLE;
 	struct ib_umem *old_umem = mr->umem;
 	int err;
@@ -1152,9 +1174,11 @@ static int umr_rereg_pas(struct mlx5_ib_mr *mr, struct ib_pd *pd,
 		return err;
 	}
 
-	atomic_sub(ib_umem_num_pages(old_umem), &dev->mdev->priv.reg_pages);
+	atomic_sub(ib_umem_num_pages(old_umem),
+		   &mr_to_mdev(mr)->priv.reg_pages);
 	ib_umem_release(old_umem);
-	atomic_add(ib_umem_num_pages(new_umem), &dev->mdev->priv.reg_pages);
+	atomic_add(ib_umem_num_pages(new_umem),
+		   &mr_to_mdev(mr)->priv.reg_pages);
 	return 0;
 }
 
@@ -1212,7 +1236,7 @@ struct ib_mr *mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 		struct ib_umem *umem;
 
 		/* Fast path for PD/access change */
-		if (can_use_umr_rereg_access(dev, mr->access_flags,
+		if (can_use_umr_rereg_access(mr_to_mdev(mr), mr->access_flags,
 					     new_access_flags)) {
 			err = mlx5r_umr_rereg_pd_access(mr, new_pd,
 							new_access_flags);
@@ -1233,7 +1257,8 @@ struct ib_mr *mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 			return ERR_PTR(err);
 		umem = mr->umem;
 		mr->umem = NULL;
-		atomic_sub(ib_umem_num_pages(umem), &dev->mdev->priv.reg_pages);
+		atomic_sub(ib_umem_num_pages(umem),
+			   &mr_to_mdev(mr)->priv.reg_pages);
 
 		return create_real_mr(new_pd, umem, mr->ibmr.iova,
 				      new_access_flags, NULL);
@@ -1247,7 +1272,8 @@ struct ib_mr *mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 		goto recreate;
 
 	if (!(new_access_flags & IB_ACCESS_ON_DEMAND) &&
-	    can_use_umr_rereg_access(dev, mr->access_flags, new_access_flags)) {
+	    can_use_umr_rereg_access(mr_to_mdev(mr), mr->access_flags,
+				     new_access_flags)) {
 		struct ib_umem *new_umem;
 		unsigned long page_size;
 
@@ -1280,13 +1306,11 @@ struct ib_mr *mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 }
 
 static int
-mlx5_alloc_priv_descs(struct ib_device *device,
-		      struct mlx5_ib_mr *mr,
+mlx5_alloc_priv_descs(struct mlx5_ib_mr *mr,
 		      int ndescs,
 		      int desc_size)
 {
-	struct mlx5_ib_dev *dev = to_dev(device);
-	struct device *ddev = &dev->mdev->pdev->dev;
+	struct device *ddev = &mr_to_mdev(mr)->pdev->dev;
 	int size = ndescs * desc_size;
 	int add_size;
 	int ret;
@@ -1322,11 +1346,9 @@ mlx5_free_priv_descs(struct mlx5_ib_mr *mr)
 {
 	if (!mr->umem && !mr->data_direct &&
 	    mr->ibmr.type != IB_MR_TYPE_DM && mr->descs) {
-		struct ib_device *device = mr->ibmr.device;
 		int size = mr->max_descs * mr->desc_size;
-		struct mlx5_ib_dev *dev = to_dev(device);
 
-		dma_unmap_single(&dev->mdev->pdev->dev, mr->desc_map, size,
+		dma_unmap_single(&mr_to_mdev(mr)->pdev->dev, mr->desc_map, size,
 				 DMA_TO_DEVICE);
 		kfree(mr->descs_alloc);
 		mr->descs = NULL;
@@ -1437,6 +1459,7 @@ static int mlx5r_handle_mkey_cleanup(struct mlx5_ib_mr *mr)
 static int __mlx5_ib_dereg_mr(struct ib_mr *ibmr)
 {
 	struct mlx5_ib_mr *mr = to_mmr(ibmr);
+	struct mlx5_core_dev *mdev = mr_to_mdev(mr);
 	struct mlx5_ib_dev *dev = to_dev(ibmr->device);
 	int rc;
 
@@ -1467,11 +1490,11 @@ static int __mlx5_ib_dereg_mr(struct ib_mr *ibmr)
 			mr->klm_mr = NULL;
 		}
 
-		if (mlx5_core_destroy_psv(dev->mdev,
+		if (mlx5_core_destroy_psv(mdev,
 					  mr->sig->psv_memory.psv_idx))
 			mlx5_ib_warn(dev, "failed to destroy mem psv %d\n",
 				     mr->sig->psv_memory.psv_idx);
-		if (mlx5_core_destroy_psv(dev->mdev, mr->sig->psv_wire.psv_idx))
+		if (mlx5_core_destroy_psv(mdev, mr->sig->psv_wire.psv_idx))
 			mlx5_ib_warn(dev, "failed to destroy wire psv %d\n",
 				     mr->sig->psv_wire.psv_idx);
 		kfree(mr->sig);
@@ -1488,7 +1511,7 @@ static int __mlx5_ib_dereg_mr(struct ib_mr *ibmr)
 
 		if (!is_odp)
 			atomic_sub(ib_umem_num_pages(mr->umem),
-				   &dev->mdev->priv.reg_pages);
+				   &mdev->priv.reg_pages);
 		ib_umem_release(mr->umem);
 		if (is_odp)
 			mlx5_ib_free_odp_mr(mr);
@@ -1534,7 +1557,6 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 static void mlx5_set_umr_free_mkey(struct ib_pd *pd, u32 *in, int ndescs,
 				   int access_mode, int page_shift)
 {
-	struct mlx5_ib_dev *dev = to_dev(pd->device);
 	void *mkc;
 
 	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
@@ -1549,7 +1571,8 @@ static void mlx5_set_umr_free_mkey(struct ib_pd *pd, u32 *in, int ndescs,
 	MLX5_SET(mkc, mkc, log_page_size, page_shift);
 	if (access_mode == MLX5_MKC_ACCESS_MODE_PA ||
 	    access_mode == MLX5_MKC_ACCESS_MODE_MTT)
-		MLX5_SET(mkc, mkc, ma_translation_mode, MLX5_CAP_GEN(dev->mdev, ats));
+		MLX5_SET(mkc, mkc, ma_translation_mode,
+			 MLX5_CAP_GEN(pd_to_mdev(pd), ats));
 }
 
 static int _mlx5_alloc_mkey_descs(struct ib_pd *pd, struct mlx5_ib_mr *mr,
@@ -1563,13 +1586,13 @@ static int _mlx5_alloc_mkey_descs(struct ib_pd *pd, struct mlx5_ib_mr *mr,
 	mr->desc_size = desc_size;
 	mr->max_descs = ndescs;
 
-	err = mlx5_alloc_priv_descs(pd->device, mr, ndescs, desc_size);
+	err = mlx5_alloc_priv_descs(mr, ndescs, desc_size);
 	if (err)
 		return err;
 
 	mlx5_set_umr_free_mkey(pd, in, ndescs, access_mode, page_shift);
 
-	err = mlx5_ib_create_mkey(dev, &mr->mmkey, in, inlen);
+	err = mlx5_ib_create_mkey(dev, mr_to_mdev(mr), &mr->mmkey, in, inlen);
 	if (err)
 		goto err_free_descs;
 
@@ -1599,6 +1622,8 @@ static struct mlx5_ib_mr *mlx5_ib_alloc_pi_mr(struct ib_pd *pd,
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
+	mr->mdev = pd_to_mdev(pd);
+
 	mr->ibmr.pd = pd;
 	mr->ibmr.device = pd->device;
 
@@ -1648,6 +1673,7 @@ static int mlx5_alloc_integrity_descs(struct ib_pd *pd, struct mlx5_ib_mr *mr,
 				      u32 *in, int inlen)
 {
 	struct mlx5_ib_dev *dev = to_dev(pd->device);
+	struct mlx5_core_dev *mdev = mr_to_mdev(mr);
 	u32 psv_index[2];
 	void *mkc;
 	int err;
@@ -1657,7 +1683,7 @@ static int mlx5_alloc_integrity_descs(struct ib_pd *pd, struct mlx5_ib_mr *mr,
 		return -ENOMEM;
 
 	/* create mem & wire PSVs */
-	err = mlx5_core_create_psv(dev->mdev, to_mpd(pd)->pdn, 2, psv_index);
+	err = mlx5_core_create_psv(mdev, to_mpd(pd)->pdn, 2, psv_index);
 	if (err)
 		goto err_free_sig;
 
@@ -1709,10 +1735,10 @@ static int mlx5_alloc_integrity_descs(struct ib_pd *pd, struct mlx5_ib_mr *mr,
 	mlx5_ib_dereg_mr(&mr->klm_mr->ibmr, NULL);
 	mr->klm_mr = NULL;
 err_destroy_psv:
-	if (mlx5_core_destroy_psv(dev->mdev, mr->sig->psv_memory.psv_idx))
+	if (mlx5_core_destroy_psv(mdev, mr->sig->psv_memory.psv_idx))
 		mlx5_ib_warn(dev, "failed to destroy mem psv %d\n",
 			     mr->sig->psv_memory.psv_idx);
-	if (mlx5_core_destroy_psv(dev->mdev, mr->sig->psv_wire.psv_idx))
+	if (mlx5_core_destroy_psv(mdev, mr->sig->psv_wire.psv_idx))
 		mlx5_ib_warn(dev, "failed to destroy wire psv %d\n",
 			     mr->sig->psv_wire.psv_idx);
 err_free_sig:
@@ -1736,6 +1762,8 @@ static struct ib_mr *__mlx5_ib_alloc_mr(struct ib_pd *pd,
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
+	mr->mdev = pd_to_mdev(pd);
+
 	in = kzalloc(inlen, GFP_KERNEL);
 	if (!in) {
 		err = -ENOMEM;
@@ -1829,7 +1857,7 @@ int mlx5_ib_alloc_mw(struct ib_mw *ibmw, struct ib_udata *udata)
 	MLX5_SET(mkc, mkc, en_rinval, !!((ibmw->type == IB_MW_TYPE_2)));
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
 
-	err = mlx5_ib_create_mkey(dev, &mw->mmkey, in, inlen);
+	err = mlx5_ib_create_mkey(dev, mw_to_mdev(ibmw), &mw->mmkey, in, inlen);
 	if (err)
 		goto free;
 
@@ -1855,7 +1883,7 @@ int mlx5_ib_alloc_mw(struct ib_mw *ibmw, struct ib_udata *udata)
 	return 0;
 
 free_mkey:
-	mlx5_core_destroy_mkey(dev->mdev, mw->mmkey.key);
+	mlx5_core_destroy_mkey(mw_to_mdev(ibmw), mw->mmkey.key);
 free:
 	kfree(in);
 	return err;
@@ -1874,7 +1902,7 @@ int mlx5_ib_dealloc_mw(struct ib_mw *mw)
 		 */
 		mlx5r_deref_wait_odp_mkey(&mmw->mmkey);
 
-	return mlx5_core_destroy_mkey(dev->mdev, mmw->mmkey.key);
+	return mlx5_core_destroy_mkey(mw_to_mdev(mw), mmw->mmkey.key);
 }
 
 int mlx5_ib_check_mr_status(struct ib_mr *ibmr, u32 check_mask,
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index d39611aa20f4b872c0c567dc601dd67a508024ec..e4978feccbe47e000d6c082f9a4ed2e9e43d663c 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -107,7 +107,7 @@ static u8 mlx5_imr_ksm_page_shift;
 static void populate_ksm(struct mlx5_ksm *pksm, size_t idx, size_t nentries,
 			struct mlx5_ib_mr *imr, int flags)
 {
-	struct mlx5_core_dev *mdev = mr_to_dev(imr)->mdev;
+	struct mlx5_core_dev *mdev = mr_to_mdev(imr);
 	struct mlx5_ksm *end = pksm + nentries;
 	u64 step = MLX5_CAP_ODP(mdev, mem_page_fault) ? mlx5_imr_mtt_size : 0;
 	__be32 key = MLX5_CAP_ODP(mdev, mem_page_fault) ?
@@ -254,7 +254,7 @@ static void destroy_unused_implicit_child_mr(struct mlx5_ib_mr *mr)
 		return;
 	}
 
-	if (MLX5_CAP_ODP(mr_to_dev(mr)->mdev, mem_page_fault))
+	if (MLX5_CAP_ODP(mr_to_mdev(mr), mem_page_fault))
 		xa_erase(&mr_to_dev(mr)->odp_mkeys,
 			 mlx5_base_mkey(mr->mmkey.key));
 	xa_unlock(&imr->implicit_children);
@@ -367,7 +367,8 @@ static void internal_fill_odp_caps(struct mlx5_ib_dev *dev)
 
 	memset(caps, 0, sizeof(*caps));
 
-	if (!MLX5_CAP_GEN(dev->mdev, pg) || !mlx5r_umr_can_load_pas(dev, 0))
+	if (!MLX5_CAP_GEN(dev->mdev, pg) ||
+	    !mlx5r_umr_can_load_pas(dev->mdev, 0))
 		return;
 
 	caps->general_caps = IB_ODP_SUPPORT;
@@ -425,7 +426,7 @@ static void internal_fill_odp_caps(struct mlx5_ib_dev *dev)
 	    !MLX5_CAP_GEN(dev->mdev, umr_indirect_mkey_disabled) &&
 	    mlx5_imr_ksm_entries != 0 &&
 	    !(mlx5_imr_ksm_page_shift >
-	      get_max_log_entity_size_cap(dev, MLX5_MKC_ACCESS_MODE_KSM)))
+	      get_max_log_entity_size_cap(dev->mdev, MLX5_MKC_ACCESS_MODE_KSM)))
 		caps->general_caps |= IB_ODP_SUPPORT_IMPLICIT;
 }
 
@@ -481,7 +482,7 @@ static struct mlx5_ib_mr *implicit_get_child_mr(struct mlx5_ib_mr *imr,
 	if (IS_ERR(odp))
 		return ERR_CAST(odp);
 
-	mr = mlx5_mr_cache_alloc(dev, imr->access_flags,
+	mr = mlx5_mr_cache_alloc(dev, mr_to_mdev(imr), imr->access_flags,
 				 MLX5_MKC_ACCESS_MODE_MTT,
 				 mlx5_imr_mtt_entries);
 	if (IS_ERR(mr)) {
@@ -529,7 +530,7 @@ static struct mlx5_ib_mr *implicit_get_child_mr(struct mlx5_ib_mr *imr,
 		goto out_lock;
 	}
 
-	if (MLX5_CAP_ODP(dev->mdev, mem_page_fault)) {
+	if (MLX5_CAP_ODP(mr_to_mdev(imr), mem_page_fault)) {
 		ret = xa_store(&dev->odp_mkeys, mlx5_base_mkey(mr->mmkey.key),
 			       &mr->mmkey, GFP_KERNEL);
 		if (xa_is_err(ret)) {
@@ -557,8 +558,7 @@ static struct mlx5_ib_mr *implicit_get_child_mr(struct mlx5_ib_mr *imr,
  * The null mkey is created with the properties to enable getting the page
  * fault for every time it is accessed and having all relevant access flags.
  */
-static int alloc_implicit_mr_null_mkey(struct mlx5_ib_dev *dev,
-				       struct mlx5_ib_mr *imr,
+static int alloc_implicit_mr_null_mkey(struct mlx5_ib_mr *imr,
 				       struct mlx5_ib_pd *pd)
 {
 	size_t inlen = MLX5_ST_SZ_BYTES(create_mkey_in) + 64;
@@ -579,7 +579,8 @@ static int alloc_implicit_mr_null_mkey(struct mlx5_ib_dev *dev,
 	MLX5_SET(mkc, mkc, rr, 1);
 	MLX5_SET(mkc, mkc, lw, 1);
 	MLX5_SET(mkc, mkc, lr, 1);
-	mlx5_core_mkey_set_ordering(dev->mdev, mkc, MLX5_MKEY_ORDER_RELAXED);
+	mlx5_core_mkey_set_ordering(mr_to_mdev(imr), mkc,
+				    MLX5_MKEY_ORDER_RELAXED);
 	MLX5_SET(mkc, mkc, free, 0);
 	MLX5_SET(mkc, mkc, umr_en, 0);
 	MLX5_SET(mkc, mkc, access_mode_1_0, MLX5_MKC_ACCESS_MODE_MTT);
@@ -591,7 +592,8 @@ static int alloc_implicit_mr_null_mkey(struct mlx5_ib_dev *dev,
 	MLX5_SET64(mkc, mkc, start_addr, 0);
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
 
-	err = mlx5_core_create_mkey(dev->mdev, &imr->null_mmkey.key, in, inlen);
+	err = mlx5_core_create_mkey(mr_to_mdev(imr), &imr->null_mmkey.key, in,
+				    inlen);
 	if (err)
 		goto free_in;
 
@@ -610,14 +612,16 @@ struct mlx5_ib_mr *mlx5_ib_alloc_implicit_mr(struct mlx5_ib_pd *pd,
 	struct mlx5_ib_mr *imr;
 	int err;
 
-	if (!mlx5r_umr_can_load_pas(dev, mlx5_imr_mtt_entries * PAGE_SIZE))
+	if (!mlx5r_umr_can_load_pas(pd_to_mdev(pd),
+				    mlx5_imr_mtt_entries * PAGE_SIZE))
 		return ERR_PTR(-EOPNOTSUPP);
 
 	umem_odp = ib_umem_odp_alloc_implicit(&dev->ib_dev, access_flags);
 	if (IS_ERR(umem_odp))
 		return ERR_CAST(umem_odp);
 
-	imr = mlx5_mr_cache_alloc(dev, access_flags, MLX5_MKC_ACCESS_MODE_KSM,
+	imr = mlx5_mr_cache_alloc(dev, pd_to_mdev(pd), access_flags,
+				  MLX5_MKC_ACCESS_MODE_KSM,
 				  mlx5_imr_ksm_entries);
 	if (IS_ERR(imr)) {
 		ib_umem_odp_release(umem_odp);
@@ -634,8 +638,8 @@ struct mlx5_ib_mr *mlx5_ib_alloc_implicit_mr(struct mlx5_ib_pd *pd,
 	imr->is_odp_implicit = true;
 	xa_init(&imr->implicit_children);
 
-	if (MLX5_CAP_ODP(dev->mdev, mem_page_fault)) {
-		err = alloc_implicit_mr_null_mkey(dev, imr, pd);
+	if (MLX5_CAP_ODP(pd_to_mdev(pd), mem_page_fault)) {
+		err = alloc_implicit_mr_null_mkey(imr, pd);
 		if (err)
 			goto out_mr;
 
@@ -684,7 +688,7 @@ void mlx5_ib_free_odp_mr(struct mlx5_ib_mr *mr)
 		xa_erase(&mr_to_dev(mr)->odp_mkeys,
 			 mlx5_base_mkey(mr->null_mmkey.key));
 
-		mlx5_core_destroy_mkey(mr_to_dev(mr)->mdev,
+		mlx5_core_destroy_mkey(mr_to_mdev(mr),
 				       mr->null_mmkey.key);
 	}
 }
@@ -859,7 +863,8 @@ static int pagefault_dmabuf_mr(struct mlx5_ib_mr *mr, size_t bcnt,
 		return err;
 	}
 
-	page_size = mlx5_umem_dmabuf_find_best_pgsz(umem_dmabuf, access_mode);
+	page_size = mlx5_umem_dmabuf_find_best_pgsz(mr_to_mdev(mr), umem_dmabuf,
+						    access_mode);
 	if (!page_size) {
 		ib_umem_dmabuf_unmap_pages(umem_dmabuf);
 		err = -EINVAL;
diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index 14f679d2d4d41784ed7dc6dbc35749fc8a7d0fc1..c85e1e38b226d2b44b335962dfbae2181c28dfeb 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -34,20 +34,20 @@ static __be64 get_umr_disable_mr_mask(void)
 	return cpu_to_be64(result);
 }
 
-static __be64 get_umr_update_translation_mask(struct mlx5_ib_dev *dev)
+static __be64 get_umr_update_translation_mask(struct mlx5_core_dev *mdev)
 {
 	u64 result;
 
 	result = MLX5_MKEY_MASK_LEN |
 		 MLX5_MKEY_MASK_PAGE_SIZE |
 		 MLX5_MKEY_MASK_START_ADDR;
-	if (MLX5_CAP_GEN_2(dev->mdev, umr_log_entity_size_5))
+	if (MLX5_CAP_GEN_2(mdev, umr_log_entity_size_5))
 		result |= MLX5_MKEY_MASK_PAGE_SIZE_5;
 
 	return cpu_to_be64(result);
 }
 
-static __be64 get_umr_update_access_mask(struct mlx5_ib_dev *dev)
+static __be64 get_umr_update_access_mask(struct mlx5_core_dev *mdev)
 {
 	u64 result;
 
@@ -56,13 +56,13 @@ static __be64 get_umr_update_access_mask(struct mlx5_ib_dev *dev)
 		 MLX5_MKEY_MASK_RR |
 		 MLX5_MKEY_MASK_RW;
 
-	if (MLX5_CAP_GEN(dev->mdev, atomic))
+	if (MLX5_CAP_GEN(mdev, atomic))
 		result |= MLX5_MKEY_MASK_A;
 
-	if (MLX5_CAP_GEN(dev->mdev, order_write_after_write_umr))
+	if (MLX5_CAP_GEN(mdev, order_write_after_write_umr))
 		result |= MLX5_MKEY_MASK_RELAXED_ORDERING_WRITE;
 
-	if (MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read_umr))
+	if (MLX5_CAP_GEN(mdev, pci_relaxed_ordered_read_umr))
 		result |= MLX5_MKEY_MASK_RELAXED_ORDERING_READ;
 
 	return cpu_to_be64(result);
@@ -77,22 +77,22 @@ static __be64 get_umr_update_pd_mask(void)
 	return cpu_to_be64(result);
 }
 
-static int umr_check_mkey_mask(struct mlx5_ib_dev *dev, u64 mask)
+static int umr_check_mkey_mask(struct mlx5_core_dev *mdev, u64 mask)
 {
 	if (mask & MLX5_MKEY_MASK_PAGE_SIZE &&
-	    MLX5_CAP_GEN(dev->mdev, umr_modify_entity_size_disabled))
+	    MLX5_CAP_GEN(mdev, umr_modify_entity_size_disabled))
 		return -EPERM;
 
 	if (mask & MLX5_MKEY_MASK_A &&
-	    MLX5_CAP_GEN(dev->mdev, umr_modify_atomic_disabled))
+	    MLX5_CAP_GEN(mdev, umr_modify_atomic_disabled))
 		return -EPERM;
 
 	if (mask & MLX5_MKEY_MASK_RELAXED_ORDERING_WRITE &&
-	    !MLX5_CAP_GEN(dev->mdev, order_write_after_write_umr))
+	    !MLX5_CAP_GEN(mdev, order_write_after_write_umr))
 		return -EPERM;
 
 	if (mask & MLX5_MKEY_MASK_RELAXED_ORDERING_READ &&
-	    !MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read_umr))
+	    !MLX5_CAP_GEN(mdev, pci_relaxed_ordered_read_umr))
 		return -EPERM;
 
 	return 0;
@@ -243,8 +243,7 @@ static int mlx5r_umr_post_send(struct ib_qp *ibqp, u32 mkey, struct ib_cqe *cqe,
 		with_data ? sizeof(struct mlx5r_umr_wqe) :
 			    sizeof(struct mlx5r_umr_wqe) -
 				    sizeof(struct mlx5_wqe_data_seg);
-	struct mlx5_ib_dev *dev = to_dev(ibqp->device);
-	struct mlx5_core_dev *mdev = dev->mdev;
+	struct mlx5_core_dev *mdev = qp_to_mdev(ibqp);
 	struct mlx5_ib_qp *qp = to_mqp(ibqp);
 	struct mlx5_wqe_ctrl_seg *ctrl;
 	union {
@@ -352,14 +351,18 @@ static inline void mlx5r_umr_init_context(struct mlx5r_umr_context *context)
 	init_completion(&context->done);
 }
 
-static int mlx5r_umr_post_send_wait(struct mlx5_ib_dev *dev, u32 mkey,
-				   struct mlx5r_umr_wqe *wqe, bool with_data)
+static int mlx5r_umr_post_send_wait(struct mlx5_ib_mr *mr,
+				    struct mlx5r_umr_wqe *wqe, bool with_data)
 {
+	struct mlx5_ib_dev *dev = mr_to_dev(mr);
+	struct mlx5_core_dev *mdev = mr_to_mdev(mr);
 	struct umr_common *umrc = &dev->umrc;
 	struct mlx5r_umr_context umr_context;
+	u32 mkey = mr->mmkey.key;
 	int err;
 
-	err = umr_check_mkey_mask(dev, be64_to_cpu(wqe->ctrl_seg.mkey_mask));
+	err = umr_check_mkey_mask(mdev,
+				  be64_to_cpu(wqe->ctrl_seg.mkey_mask));
 	if (WARN_ON(err))
 		return err;
 
@@ -425,7 +428,7 @@ int mlx5r_umr_revoke_mr(struct mlx5_ib_mr *mr)
 	struct mlx5_ib_dev *dev = mr_to_dev(mr);
 	struct mlx5r_umr_wqe wqe = {};
 
-	if (dev->mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
+	if (mr_to_mdev(mr)->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
 		return 0;
 
 	wqe.ctrl_seg.mkey_mask |= get_umr_update_pd_mask();
@@ -438,10 +441,10 @@ int mlx5r_umr_revoke_mr(struct mlx5_ib_mr *mr)
 	MLX5_SET(mkc, &wqe.mkey_seg, mkey_7_0,
 		 mlx5_mkey_variant(mr->mmkey.key));
 
-	return mlx5r_umr_post_send_wait(dev, mr->mmkey.key, &wqe, false);
+	return mlx5r_umr_post_send_wait(mr, &wqe, false);
 }
 
-static void mlx5r_umr_set_access_flags(struct mlx5_ib_dev *dev,
+static void mlx5r_umr_set_access_flags(struct mlx5_core_dev *mdev,
 				       struct mlx5_mkey_seg *seg,
 				       unsigned int access_flags)
 {
@@ -451,29 +454,29 @@ static void mlx5r_umr_set_access_flags(struct mlx5_ib_dev *dev,
 	MLX5_SET(mkc, seg, lw, !!(access_flags & IB_ACCESS_LOCAL_WRITE));
 	MLX5_SET(mkc, seg, lr, 1);
 
-	mlx5_core_mkey_set_ordering(dev->mdev, seg,
+	mlx5_core_mkey_set_ordering(mdev, seg,
 				    mlx5r_access_to_mkey_order(access_flags));
 }
 
 int mlx5r_umr_rereg_pd_access(struct mlx5_ib_mr *mr, struct ib_pd *pd,
 			      int access_flags)
 {
-	struct mlx5_ib_dev *dev = mr_to_dev(mr);
+	struct mlx5_core_dev *mdev = mr_to_mdev(mr);
 	struct mlx5r_umr_wqe wqe = {};
 	int err;
 
-	wqe.ctrl_seg.mkey_mask = get_umr_update_access_mask(dev);
+	wqe.ctrl_seg.mkey_mask = get_umr_update_access_mask(mdev);
 	wqe.ctrl_seg.mkey_mask |= get_umr_update_pd_mask();
 	wqe.ctrl_seg.flags = MLX5_UMR_CHECK_FREE;
 	wqe.ctrl_seg.flags |= MLX5_UMR_INLINE;
 
-	mlx5r_umr_set_access_flags(dev, &wqe.mkey_seg, access_flags);
+	mlx5r_umr_set_access_flags(mdev, &wqe.mkey_seg, access_flags);
 	MLX5_SET(mkc, &wqe.mkey_seg, pd, to_mpd(pd)->pdn);
 	MLX5_SET(mkc, &wqe.mkey_seg, qpn, 0xffffff);
 	MLX5_SET(mkc, &wqe.mkey_seg, mkey_7_0,
 		 mlx5_mkey_variant(mr->mmkey.key));
 
-	err = mlx5r_umr_post_send_wait(dev, mr->mmkey.key, &wqe, false);
+	err = mlx5r_umr_post_send_wait(mr, &wqe, false);
 	if (err)
 		return err;
 
@@ -546,11 +549,9 @@ static void mlx5r_umr_free_xlt(void *xlt, size_t length)
 	kfree(xlt);
 }
 
-static void mlx5r_umr_unmap_free_xlt(struct mlx5_ib_dev *dev, void *xlt,
+static void mlx5r_umr_unmap_free_xlt(struct device *ddev, void *xlt,
 				     struct ib_sge *sg)
 {
-	struct device *ddev = &dev->mdev->pdev->dev;
-
 	dma_unmap_single(ddev, sg->addr, sg->length, DMA_TO_DEVICE);
 	mlx5r_umr_free_xlt(xlt, sg->length);
 }
@@ -558,11 +559,11 @@ static void mlx5r_umr_unmap_free_xlt(struct mlx5_ib_dev *dev, void *xlt,
 /*
  * Create an XLT buffer ready for submission.
  */
-static void *mlx5r_umr_create_xlt(struct mlx5_ib_dev *dev, struct ib_sge *sg,
-				  size_t nents, size_t ent_size,
-				  unsigned int flags)
+static void *mlx5r_umr_create_xlt(struct mlx5_ib_mr *mr, struct device *ddev,
+				  struct ib_sge *sg, size_t nents,
+				  size_t ent_size, unsigned int flags)
 {
-	struct device *ddev = &dev->mdev->pdev->dev;
+	struct mlx5_ib_dev *dev = mr_to_dev(mr);
 	dma_addr_t dma;
 	void *xlt;
 
@@ -596,12 +597,11 @@ mlx5r_umr_set_update_xlt_ctrl_seg(struct mlx5_wqe_umr_ctrl_seg *ctrl_seg,
 		cpu_to_be16(mlx5r_umr_get_xlt_octo(sg->length));
 }
 
-static void mlx5r_umr_set_update_xlt_mkey_seg(struct mlx5_ib_dev *dev,
-					      struct mlx5_mkey_seg *mkey_seg,
+static void mlx5r_umr_set_update_xlt_mkey_seg(struct mlx5_mkey_seg *mkey_seg,
 					      struct mlx5_ib_mr *mr, u32 pdn,
 					      unsigned int page_shift)
 {
-	mlx5r_umr_set_access_flags(dev, mkey_seg, mr->access_flags);
+	mlx5r_umr_set_access_flags(mr_to_mdev(mr), mkey_seg, mr->access_flags);
 	MLX5_SET(mkc, mkey_seg, pd, pdn);
 	MLX5_SET64(mkc, mkey_seg, start_addr, mr->ibmr.iova);
 	MLX5_SET64(mkc, mkey_seg, len, mr->ibmr.length);
@@ -629,11 +629,11 @@ static void mlx5r_umr_update_offset(struct mlx5_wqe_umr_ctrl_seg *ctrl_seg,
 	ctrl_seg->flags |= MLX5_UMR_TRANSLATION_OFFSET_EN;
 }
 
-static void mlx5r_umr_final_update_xlt(struct mlx5_ib_dev *dev,
-				       struct mlx5r_umr_wqe *wqe,
+static void mlx5r_umr_final_update_xlt(struct mlx5r_umr_wqe *wqe,
 				       struct mlx5_ib_mr *mr, struct ib_sge *sg,
 				       unsigned int flags)
 {
+	struct mlx5_core_dev *mdev = mr_to_mdev(mr);
 	bool update_pd_access, update_translation;
 
 	if (flags & MLX5_IB_UPD_XLT_ENABLE)
@@ -644,7 +644,7 @@ static void mlx5r_umr_final_update_xlt(struct mlx5_ib_dev *dev,
 			   flags & MLX5_IB_UPD_XLT_ACCESS;
 
 	if (update_pd_access) {
-		wqe->ctrl_seg.mkey_mask |= get_umr_update_access_mask(dev);
+		wqe->ctrl_seg.mkey_mask |= get_umr_update_access_mask(mdev);
 		wqe->ctrl_seg.mkey_mask |= get_umr_update_pd_mask();
 	}
 
@@ -652,7 +652,8 @@ static void mlx5r_umr_final_update_xlt(struct mlx5_ib_dev *dev,
 		flags & MLX5_IB_UPD_XLT_ENABLE || flags & MLX5_IB_UPD_XLT_ADDR;
 
 	if (update_translation) {
-		wqe->ctrl_seg.mkey_mask |= get_umr_update_translation_mask(dev);
+		wqe->ctrl_seg.mkey_mask |=
+			get_umr_update_translation_mask(mdev);
 		if (!mr->ibmr.length)
 			MLX5_SET(mkc, &wqe->mkey_seg, length64, 1);
 		if (flags & MLX5_IB_UPD_XLT_KEEP_PGSZ)
@@ -670,11 +671,8 @@ static void _mlx5r_umr_init_wqe(struct mlx5_ib_mr *mr,
 				unsigned int flags, u32 pdn,
 				unsigned int page_shift)
 {
-	struct mlx5_ib_dev *dev = mr_to_dev(mr);
-
 	mlx5r_umr_set_update_xlt_ctrl_seg(&wqe->ctrl_seg, flags, sg);
-	mlx5r_umr_set_update_xlt_mkey_seg(dev, &wqe->mkey_seg, mr, pdn,
-					  page_shift);
+	mlx5r_umr_set_update_xlt_mkey_seg(&wqe->mkey_seg, mr, pdn, page_shift);
 	mlx5r_umr_set_update_xlt_data_seg(&wqe->data_seg, sg);
 }
 
@@ -684,7 +682,7 @@ static int _mlx5r_umr_update_mr_pas(struct mlx5_ib_mr *mr, unsigned int flags,
 {
 	size_t ent_size = dd ? sizeof(struct mlx5_ksm) : sizeof(struct mlx5_mtt);
 	struct mlx5_ib_dev *dev = mr_to_dev(mr);
-	struct device *ddev = &dev->mdev->pdev->dev;
+	struct device *ddev = &mr_to_mdev(mr)->pdev->dev;
 	struct mlx5r_umr_wqe wqe = {};
 	size_t processed_blocks = 0;
 	struct ib_block_iter biter;
@@ -708,7 +706,8 @@ static int _mlx5r_umr_update_mr_pas(struct mlx5_ib_mr *mr, unsigned int flags,
 	if (nblocks)
 		total_blocks = nblocks;
 
-	entry = mlx5r_umr_create_xlt(dev, &sg, total_blocks, ent_size, flags);
+	entry = mlx5r_umr_create_xlt(mr, ddev, &sg, total_blocks, ent_size,
+				     flags);
 	if (!entry)
 		return -ENOMEM;
 
@@ -740,7 +739,7 @@ static int _mlx5r_umr_update_mr_pas(struct mlx5_ib_mr *mr, unsigned int flags,
 			dma_sync_single_for_device(ddev, sg.addr, sg.length,
 						   DMA_TO_DEVICE);
 
-			err = mlx5r_umr_post_send_wait(dev, mr->mmkey.key, &wqe,
+			err = mlx5r_umr_post_send_wait(mr, &wqe,
 						       true);
 			if (err)
 				goto err;
@@ -786,14 +785,14 @@ static int _mlx5r_umr_update_mr_pas(struct mlx5_ib_mr *mr, unsigned int flags,
 	final_size = curr_entry - entry;
 	sg.length = ALIGN(final_size, MLX5_UMR_FLEX_ALIGNMENT);
 	memset(curr_entry, 0, sg.length - final_size);
-	mlx5r_umr_final_update_xlt(dev, &wqe, mr, &sg, flags);
+	mlx5r_umr_final_update_xlt(&wqe, mr, &sg, flags);
 
 	dma_sync_single_for_device(ddev, sg.addr, sg.length, DMA_TO_DEVICE);
-	err = mlx5r_umr_post_send_wait(dev, mr->mmkey.key, &wqe, true);
+	err = mlx5r_umr_post_send_wait(mr, &wqe, true);
 
 err:
 	sg.length = orig_sg_length;
-	mlx5r_umr_unmap_free_xlt(dev, entry, &sg);
+	mlx5r_umr_unmap_free_xlt(ddev, entry, &sg);
 	return err;
 }
 
@@ -838,9 +837,9 @@ int mlx5r_umr_update_mr_pas(struct mlx5_ib_mr *mr, unsigned int flags, u32 pdn)
 	return mlx5r_umr_update_mr_pas_range(mr, flags, pdn, 0, 0);
 }
 
-static bool umr_can_use_indirect_mkey(struct mlx5_ib_dev *dev)
+static bool umr_can_use_indirect_mkey(struct mlx5_core_dev *mdev)
 {
-	return !MLX5_CAP_GEN(dev->mdev, umr_indirect_mkey_disabled);
+	return !MLX5_CAP_GEN(mdev, umr_indirect_mkey_disabled);
 }
 
 int mlx5r_umr_update_xlt(struct mlx5_ib_mr *mr, u64 idx, int npages,
@@ -850,8 +849,8 @@ int mlx5r_umr_update_xlt(struct mlx5_ib_mr *mr, u64 idx, int npages,
 			       ? sizeof(struct mlx5_klm)
 			       : sizeof(struct mlx5_mtt);
 	const int page_align = MLX5_UMR_FLEX_ALIGNMENT / desc_size;
-	struct mlx5_ib_dev *dev = mr_to_dev(mr);
-	struct device *ddev = &dev->mdev->pdev->dev;
+	struct mlx5_core_dev *mdev = mr_to_mdev(mr);
+	struct device *ddev = &mdev->pdev->dev;
 	const int page_mask = page_align - 1;
 	struct mlx5r_umr_wqe wqe = {};
 	size_t pages_mapped = 0;
@@ -864,7 +863,7 @@ int mlx5r_umr_update_xlt(struct mlx5_ib_mr *mr, u64 idx, int npages,
 	void *xlt;
 
 	if ((flags & MLX5_IB_UPD_XLT_INDIRECT) &&
-	    !umr_can_use_indirect_mkey(dev))
+	    !umr_can_use_indirect_mkey(mdev))
 		return -EPERM;
 
 	if (WARN_ON(!mr->umem->is_odp))
@@ -879,7 +878,7 @@ int mlx5r_umr_update_xlt(struct mlx5_ib_mr *mr, u64 idx, int npages,
 	}
 	pages_to_map = ALIGN(npages, page_align);
 
-	xlt = mlx5r_umr_create_xlt(dev, &sg, npages, desc_size, flags);
+	xlt = mlx5r_umr_create_xlt(mr, ddev, &sg, npages, desc_size, flags);
 	if (!xlt)
 		return -ENOMEM;
 
@@ -894,8 +893,7 @@ int mlx5r_umr_update_xlt(struct mlx5_ib_mr *mr, u64 idx, int npages,
 	}
 
 	mlx5r_umr_set_update_xlt_ctrl_seg(&wqe.ctrl_seg, flags, &sg);
-	mlx5r_umr_set_update_xlt_mkey_seg(dev, &wqe.mkey_seg, mr, pdn,
-					  page_shift);
+	mlx5r_umr_set_update_xlt_mkey_seg(&wqe.mkey_seg, mr, pdn, page_shift);
 	mlx5r_umr_set_update_xlt_data_seg(&wqe.data_seg, &sg);
 
 	for (pages_mapped = 0;
@@ -921,12 +919,12 @@ int mlx5r_umr_update_xlt(struct mlx5_ib_mr *mr, u64 idx, int npages,
 		sg.length = ALIGN(size_to_map, MLX5_UMR_FLEX_ALIGNMENT);
 
 		if (pages_mapped + pages_iter >= pages_to_map)
-			mlx5r_umr_final_update_xlt(dev, &wqe, mr, &sg, flags);
+			mlx5r_umr_final_update_xlt(&wqe, mr, &sg, flags);
 		mlx5r_umr_update_offset(&wqe.ctrl_seg, idx * desc_size);
-		err = mlx5r_umr_post_send_wait(dev, mr->mmkey.key, &wqe, true);
+		err = mlx5r_umr_post_send_wait(mr, &wqe, true);
 	}
 	sg.length = orig_sg_length;
-	mlx5r_umr_unmap_free_xlt(dev, xlt, &sg);
+	mlx5r_umr_unmap_free_xlt(ddev, xlt, &sg);
 	return err;
 }
 
@@ -939,12 +937,12 @@ int mlx5r_umr_update_xlt(struct mlx5_ib_mr *mr, u64 idx, int npages,
 int mlx5r_umr_update_mr_page_shift(struct mlx5_ib_mr *mr,
 				   unsigned int page_shift)
 {
-	struct mlx5_ib_dev *dev = mr_to_dev(mr);
 	struct mlx5r_umr_wqe wqe = {};
 	int err;
 
 	/* Build UMR wqe: we touch only PAGE_SIZE, so use the dedicated mask */
-	wqe.ctrl_seg.mkey_mask = get_umr_update_translation_mask(dev);
+	wqe.ctrl_seg.mkey_mask =
+		get_umr_update_translation_mask(mr_to_mdev(mr));
 
 	/* MR must be free while page size is modified */
 	wqe.ctrl_seg.flags = MLX5_UMR_CHECK_FREE | MLX5_UMR_INLINE;
@@ -955,7 +953,7 @@ int mlx5r_umr_update_mr_page_shift(struct mlx5_ib_mr *mr,
 	MLX5_SET64(mkc, &wqe.mkey_seg, start_addr, mr->ibmr.iova);
 	MLX5_SET64(mkc, &wqe.mkey_seg, len, mr->ibmr.length);
 
-	err = mlx5r_umr_post_send_wait(dev, mr->mmkey.key, &wqe, false);
+	err = mlx5r_umr_post_send_wait(mr, &wqe, false);
 	if (!err)
 		mr->page_shift = page_shift;
 
@@ -992,7 +990,6 @@ static int _mlx5r_umr_zap_mkey(struct mlx5_ib_mr *mr, unsigned int flags,
 			       u32 pdn, bool dd)
 {
 	unsigned int old_page_shift = mr->page_shift;
-	struct mlx5_ib_dev *dev = mr_to_dev(mr);
 	unsigned int max_page_shift;
 	size_t page_shift_nblocks;
 	unsigned int max_log_size;
@@ -1002,7 +999,7 @@ static int _mlx5r_umr_zap_mkey(struct mlx5_ib_mr *mr, unsigned int flags,
 	access_mode = dd ? MLX5_MKC_ACCESS_MODE_KSM : MLX5_MKC_ACCESS_MODE_MTT;
 	flags |= MLX5_IB_UPD_XLT_KEEP_PGSZ | MLX5_IB_UPD_XLT_ZAP |
 		 MLX5_IB_UPD_XLT_ATOMIC;
-	max_log_size = get_max_log_entity_size_cap(dev, access_mode);
+	max_log_size = get_max_log_entity_size_cap(mr_to_mdev(mr), access_mode);
 	max_page_shift = order_base_2(mr->ibmr.length);
 	max_page_shift = min(max(max_page_shift, page_shift), max_log_size);
 	/* Count blocks in units of max_page_shift, we will zap exactly this
diff --git a/drivers/infiniband/hw/mlx5/umr.h b/drivers/infiniband/hw/mlx5/umr.h
index 78b91d614a17e11cfe85a8d004df3c2a7f883af6..5f5af250d53481993a459b7e955175c61f2c0d67 100644
--- a/drivers/infiniband/hw/mlx5/umr.h
+++ b/drivers/infiniband/hw/mlx5/umr.h
@@ -20,7 +20,7 @@ void mlx5r_umr_resource_cleanup(struct mlx5_ib_dev *dev);
 int mlx5r_umr_init(struct mlx5_ib_dev *dev);
 void mlx5r_umr_cleanup(struct mlx5_ib_dev *dev);
 
-static inline bool mlx5r_umr_can_load_pas(struct mlx5_ib_dev *dev,
+static inline bool mlx5r_umr_can_load_pas(struct mlx5_core_dev *mdev,
 					  size_t length)
 {
 	/*
@@ -31,14 +31,14 @@ static inline bool mlx5r_umr_can_load_pas(struct mlx5_ib_dev *dev,
 	 * quirky hardware by just saying it can't use PAS lists with UMR at
 	 * all.
 	 */
-	if (MLX5_CAP_GEN(dev->mdev, umr_modify_entity_size_disabled))
+	if (MLX5_CAP_GEN(mdev, umr_modify_entity_size_disabled))
 		return false;
 
 	/*
 	 * length is the size of the MR in bytes when mlx5_ib_update_xlt() is
 	 * used.
 	 */
-	if (!MLX5_CAP_GEN(dev->mdev, umr_extended_translation_offset) &&
+	if (!MLX5_CAP_GEN(mdev, umr_extended_translation_offset) &&
 	    length >= MLX5_MAX_UMR_PAGES * PAGE_SIZE)
 		return false;
 	return true;
@@ -46,37 +46,37 @@ static inline bool mlx5r_umr_can_load_pas(struct mlx5_ib_dev *dev,
 
 /* Return subset of access_flags whose mkey fields can't be updated via UMR. */
 static inline unsigned int
-mlx5r_umr_get_unchangeable_access_flags(struct mlx5_ib_dev *dev,
+mlx5r_umr_get_unchangeable_access_flags(struct mlx5_core_dev *mdev,
 					unsigned int access_flags)
 {
 	unsigned int ret = access_flags & IB_ACCESS_UNORDERED;
 
 	if ((access_flags & IB_ACCESS_REMOTE_ATOMIC) &&
-	    MLX5_CAP_GEN(dev->mdev, atomic) &&
-	    MLX5_CAP_GEN(dev->mdev, umr_modify_atomic_disabled))
+	    MLX5_CAP_GEN(mdev, atomic) &&
+	    MLX5_CAP_GEN(mdev, umr_modify_atomic_disabled))
 		ret |= IB_ACCESS_REMOTE_ATOMIC;
 
 	if ((access_flags & IB_ACCESS_RELAXED_ORDERING) &&
-	    MLX5_CAP_GEN(dev->mdev, mkc_order_write_after_write_ro) &&
-	    !MLX5_CAP_GEN(dev->mdev, order_write_after_write_umr))
+	    MLX5_CAP_GEN(mdev, mkc_order_write_after_write_ro) &&
+	    !MLX5_CAP_GEN(mdev, order_write_after_write_umr))
 		ret |= IB_ACCESS_RELAXED_ORDERING;
 
 	if ((access_flags & IB_ACCESS_RELAXED_ORDERING) &&
-	    (MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read) ||
-	     MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_pci_enabled)) &&
-	    !MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read_umr))
+	    (MLX5_CAP_GEN(mdev, pci_relaxed_ordered_read) ||
+	     MLX5_CAP_GEN(mdev, relaxed_ordering_read_pci_enabled)) &&
+	    !MLX5_CAP_GEN(mdev, pci_relaxed_ordered_read_umr))
 		ret |= IB_ACCESS_RELAXED_ORDERING;
 
 	return ret;
 }
 
 /* true if an existing MR can be reconfigured to new access_flags using UMR. */
-static inline bool mlx5r_umr_can_reconfig(struct mlx5_ib_dev *dev,
+static inline bool mlx5r_umr_can_reconfig(struct mlx5_core_dev *mdev,
 					  unsigned int current_access_flags,
 					  unsigned int target_access_flags)
 {
 	return mlx5r_umr_get_unchangeable_access_flags(
-		dev, current_access_flags ^ target_access_flags) == 0;
+		mdev, current_access_flags ^ target_access_flags) == 0;
 }
 
 static inline u64 mlx5r_umr_get_xlt_octo(u64 bytes)
diff --git a/drivers/infiniband/hw/mlx5/wr.c b/drivers/infiniband/hw/mlx5/wr.c
index 3d3fdbce1354f4390b1ebbd14114c0efd93f46df..7d1a64d24df181ad5b23580c00d68a3b48baf960 100644
--- a/drivers/infiniband/hw/mlx5/wr.c
+++ b/drivers/infiniband/hw/mlx5/wr.c
@@ -639,7 +639,6 @@ static int set_reg_wr(struct mlx5_ib_qp *qp,
 {
 	struct mlx5_ib_mr *mr = to_mmr(wr->mr);
 	struct mlx5_ib_pd *pd = to_mpd(qp->ibqp.pd);
-	struct mlx5_ib_dev *dev = to_dev(pd->ibpd.device);
 	int mr_list_size = (mr->mmkey.ndescs + mr->meta_ndescs) * mr->desc_size;
 	bool umr_inline = mr_list_size <= MLX5_IB_SQ_UMR_INLINE_THRESHOLD;
 	bool atomic = wr->access & IB_ACCESS_REMOTE_ATOMIC;
@@ -649,7 +648,7 @@ static int set_reg_wr(struct mlx5_ib_qp *qp,
 	 * Relaxed Ordering is set implicitly in mlx5_set_umr_free_mkey() and
 	 * kernel ULPs are not aware of it, so we don't set it here.
 	 */
-	if (!mlx5r_umr_can_reconfig(dev, 0, wr->access)) {
+	if (!mlx5r_umr_can_reconfig(mr_to_mdev(mr), 0, wr->access)) {
 		mlx5_ib_warn(
 			to_dev(qp->ibqp.device),
 			"Fast update for MR access flags is not possible\n");

-- 
2.49.0

