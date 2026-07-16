Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013037.outbound.protection.outlook.com [40.93.201.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF5143B6E9;
	Thu, 16 Jul 2026 17:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784221428; cv=fail; b=h3DAJaljkzfD9j5r8L9F1cZ/rZkoO8d8zOpYO3/YhO61BsLsuPinILbPweb9SomolB6l/qYoDYvSp4a9Enl3T6/xemLjCGinh6mS/kx5rWgq7piTAnskY44IXbT+G+LtR8PJx4dY0wtVzT5QywngpupIKBSZEsyTKqb4eCFF+rE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784221428; c=relaxed/simple;
	bh=DZlaWR/YhZ7mz4Lm9B+t7BLspMDIJLMtDrG0+LxL2yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=llO0Nwqsg/XQXfdxsK92jlm7P8HQhxBoApI6D82+gd5aZgDQlqtO5mtRaQBAHyxsFal68ceSPruVDB/TGOwWCNxt+rb1LRParp6kRo4Q4fMRa4cEqPMygXXuADuPcBZwwf1SDNPA8U5D69ff2+YrxAOhv8FxIHQlXVMVzy864zw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XDIgVmR6; arc=fail smtp.client-ip=40.93.201.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XDIgVmR6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qk1u93NVsuWxriB9apOHyIFkiJjxyw/ktaAAMKKMZMRNIaqN8kOFsrxGkw5sKtfqUhghzFHY/fvKgaHNIom+aw31Lxq8/+HcmCwxDKTIdw1+V7dLqAajjqIS2UiyUusxvyj8jhHt2q+D+1TWDF6Q59Cy8ox1jK+PJxolNW97LoSTF2Vw8JSNGwKNb442YDO97DmK9NTLXdl/anDqzTsZ6AWUygYHEJ/QTI6LKcEW053Tne2VLDMzWTYxcXEhcP5il3dPhIRzaqooheVautmI2xbqCAECuSrEcssAEwbTPjFNMvwjVSESnlVw4PTc8pOkLNUQjVgpH0OwtCFJT3rCBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Ei0ExrkrXLbO40XJuWvqExHfjN9npGNYKh9dRIX6eY=;
 b=LUgvf/cgf1UopSgYb4YRg2+zX4kymmpDLynpT4b2yfqSCItwek3Nrky/OTakyJGWocMkHkuJL0nQ59ifrJdEdZ/414f6UjaOlmrDqN7j9hpNHrf2fUgIKTBB3UNZFP7BSj8du8jTkckchb+OwESTyMmgiV9sHn7pZJkeiECC+iz15hww8t9REsJir1fJ3wDZIZ9XxOqZu7UHTq/u51Nw8uKn+vttDoalcZTjxR8+mc0i6s6yDjeftlM2Nd7xVLkOYadBMjs9fn8lImnH1gnEKyXPbg5MzG3od418BtPd5earhqaacsr2HlMm4QzRMqM22SdwHJliSJvKB7F5iGkKNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Ei0ExrkrXLbO40XJuWvqExHfjN9npGNYKh9dRIX6eY=;
 b=XDIgVmR6rj6eA/hefGd/aMmDR6QrJIRMIwqOSjCUwhpZGggvK9RewtOGfdcuHgYZdv6H8471pZSTY+d9m7Zmys4DnwdFjR9DbKmqZPofGMD3aggvNzrdt6F6uk34zbgaN2j0ifmSi9KLDrCqZXys/PEYWT3/eUygEpPT+tdkb9Ku7JOnA7Hsg7JIGNOGO5ApEB3DOaYdilkC7Cfupql7iG70rx3Ow3v3YUqGvurjTol7nkl49XToOtM/B3HtdCsXT9sugWAJGnMcSi9/p+6bwise3oNWZ/+H4SeFGmVkvTnvfP93Ceok+lLhgc5c5u5UtRj5a5EOMvtCqF8luzFH5A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH3PR12MB9731.namprd12.prod.outlook.com (2603:10b6:610:253::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Thu, 16 Jul
 2026 17:03:30 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0202.014; Thu, 16 Jul 2026
 17:03:30 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex@shazbot.org>,
	David Matlack <dmatlack@google.com>,
	Justin Stitt <justinstitt@google.com>,
	kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	llvm@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	netdev@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>
Cc: patches@lists.linux.dev
Subject: [PATCH v3 10/11] vfio: selftests: Add mlx5 driver - data path and memcpy ops
Date: Thu, 16 Jul 2026 14:03:26 -0300
Message-ID: <10-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0004.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::7) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH3PR12MB9731:EE_
X-MS-Office365-Filtering-Correlation-Id: 99a0fbaa-0cef-42cf-26c1-08dee35c2884
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|23010399003|921020|22082099003|18002099003|6133799003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	qOTm46u1b/TVsoxiTLEOKkryMwBkDnqHCGhxeYb32M89CbJCQDAbz65ecQUpzeak4QOdINfvh0HnmQhxvPpTKY4EC/PCddQl7crz6JnX7buGzRRGyyP32J5iUS8PLQl+kQ8q3nGgvktf6oyA2OHAif/YjGkbqZEgRqIEyffmE0WE4QQ5WeYEJewcAAFVXaf8REZSzD6dYusDHXXe7UoTObJrB4PyeYn8zvWyGSMVygF5g8QlBx0jRTUOzthtzl/GoaQkHVGyG7tObmT6S6oDmhzlzjEwma6gemrzXK6kUmg/PzomG1YF8ovmMk8UIEnVzWciDS3ckvWvuffPFn28RtOAJf4tcdd2CEfmF8zyUqPQhDzrTGZftSm6fcitMVz2sKAqnLAZWpTcIhdxzYU7rCaHj+vxYczvqgETYUo0Qf7ajCzEUCY/Hm6u5LkDhm9kDyNcZDNPU0SfkuI0crtvEQnTwFfm1DSMhZDEhrJlXEVQPVtamioZIv0NDIaAW0lcPUiyHGZx/CzfV1s4C30uujPoR/VlwdDM1IXeIp5XdxqPuh8MIr0+ejmk3jQp+AP7vCJxtos77p1C/peYgtx6eNjxbBu+gkX8jo/sGaeQbSCuGnRUcywmhhFlR0cBQNJVn80lpnDasO+Pg4p8BUChbnkalJhdmYnrSyrOZU0BmxtDwh15sUKiM37fW6nw5+4g3yD6i/ch429yPKif/E0u5g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(23010399003)(921020)(22082099003)(18002099003)(6133799003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZQ1v3ZWWMt4EHPAb3YdLtGGJP+Ct6iPQTd8UoMAHbaUqsXVbAB8XZB3aw6Hz?=
 =?us-ascii?Q?Uh2I5xNX8JQUN6nX8EM8k3qEzLJi2usFmM8oK7ZI47m8pSx/QDMalXN3DNW/?=
 =?us-ascii?Q?vHFsAyQSme1az+v+Mkn0VegAqrZb6QFSdVwXDWGttaTqhuh7oIPspc8BrrGI?=
 =?us-ascii?Q?SXYcu2MuSE2xCKnwVHf++Qk/TTwRS2QwXhK8u1w4rNdDJETYAe3+5lY9n2lM?=
 =?us-ascii?Q?t4cLEAxjYwEgway5AoPDOOIbrq59jBa8lPRtAfIXNqpBXUtXTYqaz2M3uYw/?=
 =?us-ascii?Q?X2M9JCCePLh5OE6ShUYHftGxNi2e6KIQD8wfE3W2UMhTQGrI/89zgjUjLcKM?=
 =?us-ascii?Q?SZzSAZBRWbgp3ObMf0wNSP0yKCFOeTfY4Jc6CCbQEE9UoCtMchqHXQpgR8mN?=
 =?us-ascii?Q?Lai6EMfRrkFRkKyKv+RGEbT2vF/1hsYul8633i2htnINAlMwHqBp3YVVmaVx?=
 =?us-ascii?Q?H3zSsL5IX1bvVRP66zA3+lD0i5ERRKOl31sRlp/o1OWYGXkeWs1GEYe+vfrw?=
 =?us-ascii?Q?sHnK7hUpz/O+wyTGa+Ty3uUNLFaD4JRRP+CDdUYCOf0Ve/Y2VarEXKNbLkUa?=
 =?us-ascii?Q?nnNEbJ6JD5nIyFrOycEAMj5NcumwAPHLzh1rzH9odj9+i80UeaIgvusVU499?=
 =?us-ascii?Q?8R6+TRBzFVs51PngQWXPh1s8YorpHkdJ9SlSMBYfdkFVeu0shRa7/soXTkrc?=
 =?us-ascii?Q?lrx3TR/p4CR/EVAggURkOQsjwHXMNYmg6XWAMLMZi0gIiyYCieCBEoU9P4Im?=
 =?us-ascii?Q?tnF6bIDLgKjRkxhUMArcka0Qlcwkqrajdx1OGRbsZVMr9aXSQIe93uhqH2re?=
 =?us-ascii?Q?k51Dm8fE0xDm2VqevGagcQIb+FL14XExBEI7CqQa3WUn0iCcnBJBR0Lwi3BO?=
 =?us-ascii?Q?TdpjTlUqwAWD3Kg9fLe2tY4ubRnboP10ZtPflPU0Fdx0ErRQ9UmdtZ/ZqPcK?=
 =?us-ascii?Q?UCrRnyxNzDIbbA/uZ1bYRov45Cigi3v+siWtYCv5GNAARMyg/4/zjJo3Hky6?=
 =?us-ascii?Q?nqA7eHzCQa57fWXOaCLxsJD0wiNnhx+8lkQ9L+BduPOJVbvFWrNFuOZPezey?=
 =?us-ascii?Q?ojc5zOQw6hheEaC72Z5IdwPn/ell4EACfgZalMiiAzVgh+teZmUgtfJZs5nC?=
 =?us-ascii?Q?w71M31lJS11qIezNr7U2gBhNmXvf37c3sbm2abWirESZPeOkhH5eBr1XYJZr?=
 =?us-ascii?Q?3nEuPCs9YEtFFwb2VHQo/0nSklnozWjKwXjMkMmnrmpLoVEIEIf4+Rl1JF0a?=
 =?us-ascii?Q?ige3CZyqNl23BiPLrKhtUsj8y2ZcDYbszYjJQMQsSWCWN1hQGk09OnHySycJ?=
 =?us-ascii?Q?YbVhGFJS4/VmTC5mLZXIVt58lOx/OacZyysgkf1H9tSsBUUJunliGBQkrXJV?=
 =?us-ascii?Q?w14mB4KjVDPGqLu+gxvCKwF6A1x79tw9OqG4ShZqnwhhrxV+aplTSlBGO0CI?=
 =?us-ascii?Q?JcxvSUT5rneaC0hZbd/thE/FtkL1aBPLcwopcZUS1XvTixxK53NpMbxr4kBE?=
 =?us-ascii?Q?PRq0xsdIRj4Plg5W7l+fbImSxW7pBQYuckefZfKwg89AEVhaVU4cX7A+QD2L?=
 =?us-ascii?Q?i/ZeWVjY7BzNQ7mt9typeGYrdWaeL/3TdCNjku34Mkjka+3VMM9qkt9PObC3?=
 =?us-ascii?Q?hjmDyaX1FlwMP8nnhKYHZwxWtnROmhV3HeZkWq6n9xuG/EeeLJ8KoG5nC7cz?=
 =?us-ascii?Q?c/qUnV32Q2g2bpJ0Xclq3JX6hg4/KBbdi+D6kSSuUnS+XOl4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99a0fbaa-0cef-42cf-26c1-08dee35c2884
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 17:03:29.1281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KTAa7KUiT0iT9d60Sjb5vTeHuLq/dAfJqRuR79kQqmMSw15LjLSVSLCYqyfFzUle
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9731

Complete the mlx5 driver by adding CQ/QP creation, QP state
transitions, WQE posting, CQ polling, and the
memcpy_start/memcpy_wait callbacks. After this patch the driver is
functional for DMA tests.

The data path implements RDMA Write self-loopback via an RC QP with
force-loopback.  WQEs are posted to a 16-entry send queue with an
NC doorbell, and completions are polled from a 16-entry CQ.

Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../selftests/vfio/lib/drivers/mlx5/mlx5.c    | 359 +++++++++++++++++-
 1 file changed, 357 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c b/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c
index 804801cc564e7a..e5e75adb253166 100644
--- a/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c
+++ b/tools/testing/selftests/vfio/lib/drivers/mlx5/mlx5.c
@@ -1343,6 +1343,354 @@ static void mlx5st_destroy_mkey(struct mlx5st_device *dev)
 	mlx5st_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 }
 
+/*
+ * CQ create/destroy
+ */
+
+static void mlx5st_create_cq(struct mlx5st_device *dev)
+{
+	struct vfio_pci_device *device = dev->device;
+	u64 in[MLX5_ST_SZ_QW(create_cq_in) + 1] = {};
+	u32 out[MLX5_ST_SZ_DW(create_cq_out)] = {};
+	struct mlx5_ifc_cqc_bits *cqc;
+	unsigned int i;
+	__be64 *pas;
+
+	/* Initialize CQEs before CREATE_CQ: opcode=0xF, owner=1 */
+	for (i = 0; i < CQ_CQE_CNT; i++) {
+		struct mlx5st_cqe64 *cqe = &dev->cq_buf[i];
+
+		MLX5_SET(cqe64, cqe, opcode, 0xF);
+		MLX5_SET_ONCE(cqe64, cqe, owner, 1);
+	}
+
+	MLX5_SET(create_cq_in, in, opcode, MLX5_CMD_OP_CREATE_CQ);
+
+	cqc = MLX5_ADDR_OF(create_cq_in, in, cq_context);
+	MLX5_SET(cqc, cqc, log_cq_size, LOG_CQ_SIZE);
+	MLX5_SET(cqc, cqc, uar_page, dev->uar_page);
+	MLX5_SET(cqc, cqc, c_eqn_or_apu_element, dev->eqn);
+	MLX5_SET(cqc, cqc, cqe_sz, 0);
+	pas = MLX5_ADDR_OF(create_cq_in, in, pas);
+	MLX5_SET(cqc, cqc, page_offset, mlx5st_fill_pas(device, dev->cq_buf, pas));
+	MLX5_SET(cqc, cqc, log_page_size, 0);
+	MLX5_SET64(cqc, cqc, dbr_addr, to_iova(device, &dev->cq_dbrec));
+
+	mlx5st_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+
+	dev->cqn = MLX5_GET(create_cq_out, out, cqn);
+	dev->cq_ci = 0;
+	dev_dbg(device, "Created CQ: cqn=%u, %d entries\n", dev->cqn,
+		 CQ_CQE_CNT);
+}
+
+static void mlx5st_destroy_cq(struct mlx5st_device *dev)
+{
+	u32 out[MLX5_ST_SZ_DW(destroy_cq_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(destroy_cq_in)] = {};
+
+	MLX5_SET(destroy_cq_in, in, opcode, MLX5_CMD_OP_DESTROY_CQ);
+	MLX5_SET(destroy_cq_in, in, cqn, dev->cqn);
+	mlx5st_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+}
+
+/*
+ * QP create/destroy
+ */
+
+static void mlx5st_create_qp(struct mlx5st_device *dev)
+{
+	struct vfio_pci_device *device = dev->device;
+	u64 in[MLX5_ST_SZ_QW(create_qp_in) + 1] = {};
+	u32 out[MLX5_ST_SZ_DW(create_qp_out)] = {};
+	struct mlx5_ifc_qpc_bits *qpc;
+	__be64 *pas;
+
+	MLX5_SET(create_qp_in, in, opcode, MLX5_CMD_OP_CREATE_QP);
+
+	qpc = MLX5_ADDR_OF(create_qp_in, in, qpc);
+	MLX5_SET(qpc, qpc, st, MLX5_QPC_ST_RC);
+	MLX5_SET(qpc, qpc, pm_state, MLX5_QPC_PM_STATE_MIGRATED);
+	MLX5_SET(qpc, qpc, pd, dev->pdn);
+	MLX5_SET(qpc, qpc, uar_page, dev->uar_page);
+	MLX5_SET(qpc, qpc, cqn_snd, dev->cqn);
+	MLX5_SET(qpc, qpc, cqn_rcv, dev->cqn);
+	MLX5_SET(qpc, qpc, log_sq_size, LOG_SQ_SIZE);
+	MLX5_SET(qpc, qpc, log_msg_max, dev->log_max_msg);
+	MLX5_SET(qpc, qpc, rq_type, 0x3);
+	MLX5_SET(qpc, qpc, ts_format, 1);
+	pas = MLX5_ADDR_OF(create_qp_in, in, pas);
+	MLX5_SET(qpc, qpc, page_offset,
+		 mlx5st_fill_pas(device, dev->sq_buf, pas));
+	MLX5_SET(qpc, qpc, log_page_size, 0);
+	MLX5_SET64(qpc, qpc, dbr_addr, to_iova(device, &dev->qp_dbrec));
+
+	mlx5st_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+
+	dev->qpn = MLX5_GET(create_qp_out, out, qpn);
+	dev->sq_pi = 0;
+	dev_dbg(device, "Created QP: qpn=%u, RC, sq=%d wqes\n", dev->qpn,
+		 SQ_WQE_CNT);
+}
+
+static void mlx5st_destroy_qp(struct mlx5st_device *dev)
+{
+	u32 out[MLX5_ST_SZ_DW(destroy_qp_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(destroy_qp_in)] = {};
+
+	MLX5_SET(destroy_qp_in, in, opcode, MLX5_CMD_OP_DESTROY_QP);
+	MLX5_SET(destroy_qp_in, in, qpn, dev->qpn);
+	mlx5st_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+}
+
+/*
+ * QP state transitions
+ */
+
+static void mlx5st_qp_rst2init(struct mlx5st_device *dev)
+{
+	u32 out[MLX5_ST_SZ_DW(rst2init_qp_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(rst2init_qp_in)] = {};
+	struct mlx5_ifc_qpc_bits *qpc = MLX5_ADDR_OF(rst2init_qp_in, in, qpc);
+
+	MLX5_SET(rst2init_qp_in, in, opcode, MLX5_CMD_OP_RST2INIT_QP);
+	MLX5_SET(rst2init_qp_in, in, qpn, dev->qpn);
+
+	MLX5_SET(qpc, qpc, primary_address_path.vhca_port_num, 1);
+	MLX5_SET(qpc, qpc, pm_state, MLX5_QPC_PM_STATE_MIGRATED);
+	MLX5_SET(qpc, qpc, rre, 1);
+	MLX5_SET(qpc, qpc, rwe, 1);
+
+	mlx5st_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	dev_dbg(dev->device, "QP RST->INIT\n");
+}
+
+static void mlx5st_qp_init2rtr(struct mlx5st_device *dev)
+{
+	u32 out[MLX5_ST_SZ_DW(init2rtr_qp_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(init2rtr_qp_in)] = {};
+	struct mlx5_ifc_qpc_bits *qpc = MLX5_ADDR_OF(init2rtr_qp_in, in, qpc);
+
+	MLX5_SET(init2rtr_qp_in, in, opcode, MLX5_CMD_OP_INIT2RTR_QP);
+	MLX5_SET(init2rtr_qp_in, in, qpn, dev->qpn);
+
+	MLX5_SET(qpc, qpc, mtu, 3);
+	MLX5_SET(qpc, qpc, log_msg_max, dev->log_max_msg);
+	MLX5_SET(qpc, qpc, remote_qpn, dev->qpn);
+	MLX5_SET(qpc, qpc, min_rnr_nak, 12);
+	MLX5_SET(qpc, qpc, primary_address_path.vhca_port_num, 1);
+	MLX5_SET(qpc, qpc, primary_address_path.fl, 1);
+
+	mlx5st_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	dev_dbg(dev->device, "QP INIT->RTR (fl=1)\n");
+}
+
+static void mlx5st_qp_rtr2rts(struct mlx5st_device *dev)
+{
+	u32 out[MLX5_ST_SZ_DW(rtr2rts_qp_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(rtr2rts_qp_in)] = {};
+	struct mlx5_ifc_qpc_bits *qpc = MLX5_ADDR_OF(rtr2rts_qp_in, in, qpc);
+
+	MLX5_SET(rtr2rts_qp_in, in, opcode, MLX5_CMD_OP_RTR2RTS_QP);
+	MLX5_SET(rtr2rts_qp_in, in, qpn, dev->qpn);
+
+	MLX5_SET(qpc, qpc, log_ack_req_freq, 0);
+	MLX5_SET(qpc, qpc, retry_count, 7);
+	MLX5_SET(qpc, qpc, rnr_retry, 7);
+	MLX5_SET(qpc, qpc, primary_address_path.ack_timeout, 14);
+
+	mlx5st_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	dev_dbg(dev->device, "QP RTR->RTS\n");
+}
+
+/*
+ * Post RDMA Write WQE
+ */
+static void mlx5st_post_rdma_write(struct mlx5st_device *dev, u64 src_addr,
+				    u32 src_lkey, u64 dst_addr, u32 dst_rkey,
+				    u32 length, bool signaled)
+{
+	struct mlx5st_send_wqe *wqe;
+	unsigned int idx;
+
+	idx = dev->sq_pi % SQ_WQE_CNT;
+	wqe = &dev->sq_buf[idx];
+
+	memset(wqe, 0, sizeof(*wqe));
+	MLX5_SET(wqe_ctrl_seg, &wqe->ctrl, opcode, MLX5_OPCODE_RDMA_WRITE);
+	MLX5_SET(wqe_ctrl_seg, &wqe->ctrl, wqe_index, dev->sq_pi);
+	MLX5_SET(wqe_ctrl_seg, &wqe->ctrl, qp_or_sq, dev->qpn);
+	MLX5_SET(wqe_ctrl_seg, &wqe->ctrl, ds, MLX5_RDMA_WRITE_DS);
+	if (signaled)
+		MLX5_SET(wqe_ctrl_seg, &wqe->ctrl, ce, MLX5_WQE_CE_CQE_ALWAYS);
+
+	MLX5_SET64(wqe_raddr_seg, &wqe->raddr, raddr, dst_addr);
+	MLX5_SET(wqe_raddr_seg, &wqe->raddr, rkey, dst_rkey);
+
+	MLX5_SET(wqe_data_seg, &wqe->data, byte_count, length);
+	MLX5_SET(wqe_data_seg, &wqe->data, lkey, src_lkey);
+	MLX5_SET64(wqe_data_seg, &wqe->data, addr, src_addr);
+
+	dev->sq_pi++;
+
+	/* Ensure WQE is visible to device before doorbell record */
+	dma_wmb();
+
+	WRITE_ONCE(dev->qp_dbrec.send_counter,
+		   cpu_to_be32(dev->sq_pi & 0xffff));
+
+	/*
+	 * Ring doorbell: write first 8 bytes of ctrl to UAR BF register,
+	 * iowrite has an internal dma_wmb() so the doorbell record will be
+	 * visible.
+	 */
+	iowrite64be(be64_to_cpu(*(__be64 *)wqe),
+		    (u8 __iomem *)dev->uar_base + dev->uar_bf_offset);
+	dev->uar_bf_offset ^= MLX5_BF_SIZE;
+}
+
+/*
+ * Poll CQ
+ */
+static int mlx5st_poll_cq_batch(struct mlx5st_device *dev,
+				unsigned int max_cqe)
+{
+	unsigned int polled = 0;
+
+	while (polled < max_cqe) {
+		unsigned int idx = dev->cq_ci % CQ_CQE_CNT;
+		struct mlx5st_cqe64 *cqe = &dev->cq_buf[idx];
+		u8 owner, opcode;
+
+		owner = MLX5_GET_ONCE(cqe64, cqe, owner);
+		if (owner != ((dev->cq_ci >> LOG_CQ_SIZE) & 1))
+			break;
+
+		dma_rmb();
+
+		opcode = MLX5_GET(cqe64, cqe, opcode);
+
+		dev->cq_ci++;
+		WRITE_ONCE(dev->cq_dbrec.recv_counter,
+			   cpu_to_be32(dev->cq_ci & 0xffffff));
+
+		if (opcode == MLX5_CQE_REQ) {
+			dev->sq_ci =
+				(u16)(MLX5_GET(cqe64, cqe, wqe_counter) + 1);
+			polled++;
+			continue;
+		}
+		if (opcode == MLX5_CQE_REQ_ERR ||
+		    opcode == MLX5_CQE_RESP_ERR) {
+			dev_dbg(dev->device,
+				"CQE error: opcode=0x%x syndrome=0x%x vendor=0x%x\n",
+				opcode,
+				MLX5_GET(cqe64, cqe, error_syndrome.syndrome),
+				MLX5_GET(cqe64, cqe,
+					 error_syndrome.vendor_error_syndrome));
+			return -1;
+		}
+		dev_err(dev->device, "CQE unexpected opcode=0x%x\n", opcode);
+		return -1;
+	}
+
+	return polled;
+}
+
+static int mlx5st_poll_cq(struct mlx5st_device *dev, unsigned int timeout_ms)
+{
+	struct timespec start, now;
+	unsigned int elapsed;
+	int ret;
+
+	clock_gettime(CLOCK_MONOTONIC, &start);
+	for (;;) {
+		ret = mlx5st_poll_cq_batch(dev, 1);
+		if (ret < 0)
+			return -1;
+		if (ret > 0)
+			return 0;
+
+		if (dev->have_eq)
+			mlx5st_process_events(dev);
+
+		clock_gettime(CLOCK_MONOTONIC, &now);
+		elapsed = (now.tv_sec - start.tv_sec) * 1000 +
+			  (now.tv_nsec - start.tv_nsec) / 1000000;
+		if (elapsed > timeout_ms) {
+			dev_err(dev->device, "CQ poll timeout after %u ms\n",
+				timeout_ms);
+			return -1;
+		}
+	}
+}
+
+/*
+ * Data path setup/teardown helpers
+ */
+
+static void mlx5st_setup_datapath(struct mlx5st_device *dev)
+{
+	mlx5st_create_cq(dev);
+	mlx5st_create_qp(dev);
+	mlx5st_qp_rst2init(dev);
+	mlx5st_qp_init2rtr(dev);
+	mlx5st_qp_rtr2rts(dev);
+}
+
+static void mlx5st_teardown_datapath(struct mlx5st_device *dev)
+{
+	if (dev->qpn) {
+		mlx5st_destroy_qp(dev);
+		dev->qpn = 0;
+	}
+	if (dev->cqn) {
+		mlx5st_destroy_cq(dev);
+		dev->cqn = 0;
+	}
+	dev->sq_pi = 0;
+	dev->sq_ci = 0;
+	memset(&dev->qp_dbrec, 0, sizeof(dev->qp_dbrec));
+	memset(&dev->cq_dbrec, 0, sizeof(dev->cq_dbrec));
+}
+
+/*
+ * memcpy callbacks
+ */
+
+#define MLX5ST_MEMCPY_TIMEOUT_MS 60000
+
+static void mlx5st_memcpy_start(struct vfio_pci_device *device,
+				 iova_t src, iova_t dst, u64 size, u64 count)
+{
+	struct mlx5st_device *dev = to_mlx5st(device);
+	u64 i;
+
+	for (i = 0; i < count; i++) {
+		bool signaled = (i == count - 1);
+
+		mlx5st_post_rdma_write(dev, src, dev->global_lkey, dst,
+				       dev->global_rkey, size, signaled);
+	}
+}
+
+static int mlx5st_memcpy_wait(struct vfio_pci_device *device)
+{
+	struct mlx5st_device *dev = to_mlx5st(device);
+	int ret;
+
+	ret = mlx5st_poll_cq(dev, MLX5ST_MEMCPY_TIMEOUT_MS);
+	if (ret) {
+		/*
+		 * CQE error puts the QP in error state.  Rebuild the data path
+		 * so subsequent operations can succeed.
+		 */
+		mlx5st_teardown_datapath(dev);
+		mlx5st_setup_datapath(dev);
+	}
+	return ret;
+}
+
 /*
  * Driver ops callbacks
  */
@@ -1373,6 +1721,11 @@ static void mlx5st_init(struct vfio_pci_device *device)
 	mlx5st_alloc_pd(dev);
 	mlx5st_create_mkey(dev);
 
+	mlx5st_setup_datapath(dev);
+
+	device->driver.max_memcpy_size = 1ULL << dev->log_max_msg;
+	device->driver.max_memcpy_count = SQ_WQE_CNT - 1;
+
 	dev_dbg(device, "mlx5 driver initialized\n");
 }
 
@@ -1380,6 +1733,8 @@ static void mlx5st_remove(struct vfio_pci_device *device)
 {
 	struct mlx5st_device *dev = to_mlx5st(device);
 
+	mlx5st_teardown_datapath(dev);
+
 	dev_dbg(device, "teardown: destroy_mkey\n");
 	if (dev->mkey_index) {
 		mlx5st_destroy_mkey(dev);
@@ -1408,7 +1763,7 @@ struct vfio_pci_driver_ops mlx5st_ops = {
 	.probe = mlx5st_probe,
 	.init = mlx5st_init,
 	.remove = mlx5st_remove,
-	.memcpy_start = NULL,
-	.memcpy_wait = NULL,
+	.memcpy_start = mlx5st_memcpy_start,
+	.memcpy_wait = mlx5st_memcpy_wait,
 	.send_msi = NULL,
 };
-- 
2.43.0

